import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:reciep/app/features/scan/repository/receipt_ai_prompt_builder.dart';
import 'package:reciep/app/features/scan/repository/receipt_image_compression_service.dart';

class GemmaScanException implements Exception {
  GemmaScanException(this.message);

  final String message;

  @override
  String toString() => message;
}

class GemmaReceiptScanService {
  GemmaReceiptScanService({
    required String apiKey,
    String model = 'gemma-4-26b-a4b-it',
    String baseUrl = 'https://generativelanguage.googleapis.com/v1beta',
    Duration timeout = const Duration(seconds: 1080),
    HttpClient? httpClient,
    ReceiptAiPromptBuilder? promptBuilder,
    ReceiptImageCompressionService? imageCompressionService,
  }) : _apiKey = apiKey,
       _model = _normalizeModelId(model),
       _baseUrl = baseUrl,
       _timeout = timeout,
       _httpClient = httpClient ?? HttpClient(),
       _promptBuilder = promptBuilder ?? ReceiptAiPromptBuilder(),
       _imageCompressionService =
           imageCompressionService ?? const ReceiptImageCompressionService();

  final String _apiKey;
  final String _model;
  final String _baseUrl;
  final Duration _timeout;
  final HttpClient _httpClient;
  final ReceiptAiPromptBuilder _promptBuilder;
  final ReceiptImageCompressionService _imageCompressionService;

  Future<void> warmUp() async {
    if (_apiKey.trim().isEmpty) {
      return;
    }

    final Uri uri = Uri.parse('$_baseUrl/models?key=$_apiKey');
    try {
      final HttpClientRequest request = await _httpClient.getUrl(uri);
      final HttpClientResponse response = await request.close();
      await response.drain<void>();
      _logDebug('Warm-up request completed. status=${response.statusCode}');
    } catch (error) {
      _logDebug('Warm-up request skipped. error=$error');
    }
  }

  Future<Map<String, dynamic>> scanReceiptImage({
    required String imagePath,
  }) async {
    _logDebug('Starting receipt scan. model=$_model imagePath=$imagePath');

    if (_apiKey.trim().isEmpty) {
      throw GemmaScanException(
        'Gemma API key missing. Start app with --dart-define=GEMMA_API_KEY=...'
        ' and optional --dart-define=GEMMA_MODEL=... .',
      );
    }

    final File imageFile = File(imagePath);
    if (!await imageFile.exists()) {
      throw GemmaScanException('Selected image file not found.');
    }

    final PreparedReceiptImage preparedImage = await _imageCompressionService
        .prepareForUpload(imagePath: imagePath);
    if (preparedImage.bytes.isEmpty) {
      throw GemmaScanException('Selected image is empty.');
    }
    _logDebug(
      'Prepared image bytes. count=${preparedImage.bytes.length} mime=${preparedImage.mimeType}',
    );

    final Uri uri = Uri.parse(
      '$_baseUrl/models/$_model:generateContent?key=$_apiKey',
    );

    final HttpClientRequest request = await _httpClient.postUrl(uri);
    request.headers.contentType = ContentType.json;

    final String prompt = _promptBuilder.build();
    final Map<String, dynamic> body = <String, dynamic>{
      'contents': <dynamic>[
        <String, dynamic>{
          'role': 'user',
          'parts': <dynamic>[
            <String, dynamic>{'text': prompt},
            <String, dynamic>{
              'inlineData': <String, dynamic>{
                'mimeType': preparedImage.mimeType,
                'data': base64Encode(preparedImage.bytes),
              },
            },
          ],
        },
      ],
      'generationConfig': <String, dynamic>{
        'temperature': 0.1,
        'topP': 0.8,
        'maxOutputTokens': 1000,
        'thinkingConfig': {
          'thinkingLevel': 'MINIMAL',
        },
        'mediaResolution': 'MEDIA_RESOLUTION_MEDIUM',
        'responseMimeType': 'application/json',
      },
    };

    _logDebug(
      'Sending request to Gemma. baseUrl=$_baseUrl model=$_model promptLength=${prompt.length}',
    );
    request.write(jsonEncode(body));

    final HttpClientResponse response;
    try {
      response = await request.close().timeout(_timeout);
    } on TimeoutException {
      throw GemmaScanException('Gemma API timeout. Please try again.');
    } on SocketException catch (error) {
      throw GemmaScanException(
        'Gemma socket error for ${uri.host}: ${error.message} ${error.osError?.message ?? ''}'
            .trim(),
      );
    }

    final String rawResponse = await utf8.decodeStream(response);
    _logDebug(
      'Gemma HTTP response received. status=${response.statusCode} bodyPreview=${_preview(rawResponse)}',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final String errorMessage = _extractApiError(rawResponse);
      _logDebug(
        'Gemma request failed. status=${response.statusCode} error=$errorMessage',
      );
      if (response.statusCode == 400 &&
          errorMessage.toLowerCase().contains('unexpected model name format')) {
        throw GemmaScanException(
          'Invalid model id "$_model". Use Gemini API model id like '
          '"gemma-4-26b-a4b-it" (without "models/").',
        );
      }
      throw GemmaScanException(
        'Gemma API error ${response.statusCode}: $errorMessage',
      );
    }

    final Map<String, dynamic> decoded = _decodeToMap(rawResponse);
    _logDebug(
      'Decoded response envelope. keys=${decoded.keys.toList()} candidates=${_listLength(decoded['candidates'])}',
    );
    final String jsonText = _extractTextPayload(decoded);
    _logDebug('Extracted text payload. length=${jsonText.length}');
    final String cleaned = _sanitizeJsonPayload(jsonText);
    _logDebug('Cleaned payload text. length=${cleaned.length}');

    final dynamic structured;
    try {
      structured = jsonDecode(cleaned);
    } catch (_) {
      _logDebug(
        'Failed to parse structured JSON payload. cleanedPreview=${_preview(cleaned)}',
      );
      throw GemmaScanException(
        'Gemma returned invalid structured JSON payload.',
      );
    }
    if (structured is! Map) {
      throw GemmaScanException('Gemma response is not a JSON object.');
    }
    _logDebug('Structured JSON parsed successfully.');

    return structured.map(
      (dynamic key, dynamic value) => MapEntry(key.toString(), value),
    );
  }

  Map<String, dynamic> _decodeToMap(String rawResponse) {
    try {
      final dynamic decoded = jsonDecode(rawResponse);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map(
          (dynamic key, dynamic value) => MapEntry(key.toString(), value),
        );
      }
    } catch (_) {
      _logDebug(
        'Failed to decode Gemma envelope JSON. rawPreview=${_preview(rawResponse)}',
      );
      throw GemmaScanException('Gemma API returned invalid JSON envelope.');
    }

    _logDebug(
      'Gemma envelope decoded to unsupported type. rawPreview=${_preview(rawResponse)}',
    );
    throw GemmaScanException('Gemma API returned invalid JSON envelope.');
  }

  String _extractTextPayload(Map<String, dynamic> envelope) {
    final dynamic candidatesDynamic = envelope['candidates'];
    if (candidatesDynamic is! List || candidatesDynamic.isEmpty) {
      throw GemmaScanException('Gemma API response missing candidates.');
    }

    final dynamic firstCandidate = candidatesDynamic.first;
    if (firstCandidate is! Map) {
      throw GemmaScanException('Gemma API candidate format invalid.');
    }

    final dynamic content = firstCandidate['content'];
    if (content is! Map) {
      throw GemmaScanException('Gemma API content missing.');
    }

    final dynamic partsDynamic = content['parts'];
    if (partsDynamic is! List || partsDynamic.isEmpty) {
      throw GemmaScanException('Gemma API content parts missing.');
    }

    for (final dynamic part in partsDynamic) {
      if (part is! Map || part['thought'] == true || part['text'] == null) {
        continue;
      }
      final String text = part['text'].toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }

    final String finishReason =
        firstCandidate['finishReason']?.toString() ?? 'unknown';
    _logDebug(
      'No non-empty text payload found. finishReason=$finishReason parts=${_partSummary(partsDynamic)} promptFeedback=${_preview(jsonEncode(envelope['promptFeedback']))}',
    );

    final bool hasAnyTextField = partsDynamic.any(
      (dynamic part) => part is Map && part['text'] != null,
    );
    if (hasAnyTextField) {
      throw GemmaScanException(
        'Gemma API returned empty text payload (finishReason: $finishReason).',
      );
    }
    throw GemmaScanException(
      'Gemma API text payload missing (finishReason: $finishReason).',
    );
  }

  String _sanitizeJsonPayload(String text) {
    String cleaned = text.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7).trim();
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3).trim();
    }

    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3).trim();
    }

    final int firstBrace = cleaned.indexOf('{');
    final int lastBrace = cleaned.lastIndexOf('}');
    if (firstBrace >= 0 && lastBrace >= firstBrace) {
      cleaned = cleaned.substring(firstBrace, lastBrace + 1).trim();
    }

    return cleaned;
  }

  String _extractApiError(String raw) {
    try {
      final dynamic decoded = jsonDecode(raw);
      if (decoded is Map) {
        final dynamic error = decoded['error'];
        if (error is Map && error['message'] != null) {
          return error['message'].toString();
        }
      }
    } catch (_) {
      // Fall back to short raw text.
    }

    final String trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return 'unknown error';
    }

    return trimmed.length > 220 ? '${trimmed.substring(0, 220)}...' : trimmed;
  }

  static String _normalizeModelId(String value) {
    String model = value.trim();
    if (model.startsWith('models/')) {
      model = model.substring('models/'.length);
    }

    if (model.isEmpty) {
      return 'gemma-4-26b-a4b-it';
    }

    return model;
  }

  int _listLength(dynamic value) => value is List ? value.length : -1;

  String _partSummary(List<dynamic> parts) {
    final List<String> summary = <String>[];
    for (final dynamic part in parts) {
      if (part is! Map) {
        summary.add('non-map');
        continue;
      }
      summary.add(part.keys.join('|'));
    }
    return summary.join(',');
  }

  String _preview(String value, {int max = 400}) {
    final String clean = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.length <= max) {
      return clean;
    }
    return '${clean.substring(0, max)}...';
  }

  void _logDebug(String message) {
    developer.log(message, name: 'GemmaReceiptScanService');
  }
}
