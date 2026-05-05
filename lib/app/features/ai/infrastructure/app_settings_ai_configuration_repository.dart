import 'dart:convert';
import 'dart:io';

import 'package:refyn/app/features/ai/domain/ai_configuration.dart';
import 'package:refyn/app/features/ai/domain/ai_model_option.dart';
import 'package:refyn/app/features/ai/domain/repositories/ai_configuration_repository.dart';
import 'package:refyn/app/features/ai/infrastructure/google_ai_constants.dart';
import 'package:refyn/database/app_database.dart';

class AppSettingsAiConfigurationRepository implements AiConfigurationRepository {
  AppSettingsAiConfigurationRepository({
    required AppSettingsDao settingsDao,
    required String defaultApiKey,
    required String defaultModel,
    required String apiBaseUrl,
    HttpClient? httpClient,
  }) : _settingsDao = settingsDao,
       _defaultApiKey = defaultApiKey,
       _defaultModel = defaultModel,
       _apiBaseUrl = apiBaseUrl,
       _httpClient = httpClient ?? HttpClient();

  static const String _apiKeyKey = 'ai_api_key';
  static const String _selectedModelKey = 'ai_selected_model';
  static const String _thinkingLevelKey = 'ai_thinking_level';

  final AppSettingsDao _settingsDao;
  final String _defaultApiKey;
  final String _defaultModel;
  final String _apiBaseUrl;
  final HttpClient _httpClient;

  @override
  Future<AiConfiguration> getConfiguration() async {
    final String? storedApiKey = await _settingsDao.getSetting(_apiKeyKey);
    final String? storedModel = await _settingsDao.getSetting(_selectedModelKey);
    final String? storedThinking = await _settingsDao.getSetting(
      _thinkingLevelKey,
    );

    final String builtInApiKey = _defaultApiKey.trim();
    final bool hasStoredKey = (storedApiKey ?? '').trim().isNotEmpty;
    final bool isUsingBuiltInApiKey = !hasStoredKey && builtInApiKey.isNotEmpty;

    return AiConfiguration(
      apiKey: hasStoredKey ? storedApiKey!.trim() : builtInApiKey,
      selectedModel: (storedModel ?? '').trim().isNotEmpty
          ? storedModel!.trim()
          : _defaultModel,
      thinkingLevel: (storedThinking ?? '').trim().isNotEmpty
          ? storedThinking!.trim().toUpperCase()
          : AiConfiguration.minimalThinkingLevel,
      isUsingBuiltInApiKey: isUsingBuiltInApiKey,
    );
  }

  @override
  Future<List<AiModelOption>> fetchAvailableModels({String? apiKey}) async {
    final String resolvedApiKey =
        (apiKey ?? (await getConfiguration()).apiKey).trim();

    if (resolvedApiKey.isEmpty) {
      throw StateError('missing_api_key');
    }

    final Uri uri = Uri.parse('$_apiBaseUrl/models');

    final HttpClientRequest request = await _httpClient
        .getUrl(uri)
        .timeout(const Duration(seconds: 30));
    request.headers.set(GoogleAiConstants.apiKeyHeader, resolvedApiKey);

    final HttpClientResponse response = await request
        .close()
        .timeout(const Duration(seconds: 30));
    final String raw = await utf8.decodeStream(response);
    final Map<String, dynamic> body =
        jsonDecode(raw) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final String message =
          (body['error'] as Map<String, dynamic>?)?['message'] as String? ??
              'Unknown Google API error';
      throw StateError(message);
    }

    final List<dynamic> models = body['models'] as List<dynamic>? ?? const [];
    final Map<String, AiModelOption> optionsById = <String, AiModelOption>{};

    for (final Map<String, dynamic> item
        in models.whereType<Map<String, dynamic>>()) {
      final List<String> supportedGenerationMethods =
          (item['supportedGenerationMethods'] as List<dynamic>? ?? const [])
              .whereType<String>()
              .toList(growable: false);

      if (!supportedGenerationMethods.contains(
        GoogleAiConstants.generateContentMethod,
      )) {
        continue;
      }

      final String rawName = (item['name'] as String? ?? '').trim();
      if (rawName.isEmpty) {
        continue;
      }

      final String id = rawName.startsWith(GoogleAiConstants.modelsPathPrefix)
          ? rawName.substring(GoogleAiConstants.modelsPathPrefix.length)
          : rawName;

      optionsById[id] = AiModelOption(
        id: id,
        label: (item['displayName'] as String?)?.trim().isNotEmpty == true
            ? (item['displayName'] as String).trim()
            : id,
        supportedGenerationMethods: supportedGenerationMethods,
      );
    }

    final List<AiModelOption> options = optionsById.values.toList(growable: false)
      ..sort((AiModelOption a, AiModelOption b) =>
          a.label.toLowerCase().compareTo(b.label.toLowerCase()));

    if (options.isEmpty) {
      throw StateError(
        'No compatible AI models were returned for this API key.',
      );
    }

    return options;
  }

  @override
  Future<void> saveApiKey(String apiKey) {
    return _settingsDao.upsertSetting(
      key: _apiKeyKey,
      value: apiKey.trim(),
    );
  }

  @override
  Future<void> saveSelectedModel(String modelId) {
    return _settingsDao.upsertSetting(
      key: _selectedModelKey,
      value: modelId.trim(),
    );
  }

  @override
  Future<void> saveThinkingLevel(String thinkingLevel) {
    return _settingsDao.upsertSetting(
      key: _thinkingLevelKey,
      value: thinkingLevel.trim().toUpperCase(),
    );
  }

  @override
  Future<void> clearConfiguration() async {
    await _settingsDao.deleteSetting(_apiKeyKey);
    await _settingsDao.deleteSetting(_selectedModelKey);
    await _settingsDao.deleteSetting(_thinkingLevelKey);
  }
}
