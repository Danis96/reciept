import 'dart:convert';

import 'package:reciep/app/models/domain/receipt.dart';
import 'package:reciep/app/models/domain/receipt_item.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/models/receipt/receipt_parsing_utils.dart';
import 'package:reciep/app/models/receipt/receipt_validator.dart';

class ReceiptAiParserResult {
  const ReceiptAiParserResult({
    required this.receipt,
    required this.errors,
    required this.warnings,
  });

  final Receipt? receipt;
  final List<String> errors;
  final List<String> warnings;

  bool get isValid => receipt != null && errors.isEmpty;
}

class ReceiptAiParser {
  const ReceiptAiParser._();

  static ReceiptAiParserResult parseStructured(dynamic input) {
    final List<String> errors = <String>[];
    final List<String> warnings = <String>[];

    final Map<String, dynamic>? root = _toMap(input);
    if (root == null) {
      return ReceiptAiParserResult(
        receipt: null,
        errors: <String>['Input is not valid JSON object'],
        warnings: warnings,
      );
    }

    final Map<String, dynamic> merchant = _nestedMap(root, <String>[
      'merchant',
      'prodavac',
      'company',
    ]);
    final Map<String, dynamic> receiptInfo = _nestedMap(root, <String>[
      'receipt',
      'racun',
      'invoice',
    ]);
    final Map<String, dynamic> totals = _nestedMap(root, <String>[
      'totals',
      'iznosi',
      'ukupno',
    ]);
    final Map<String, dynamic> payment = _nestedMap(root, <String>[
      'payment',
      'placanje',
    ]);
    final Map<String, dynamic> fiscal = _nestedMap(root, <String>[
      'fiscal',
      'fiskalni',
    ]);

    final List<ReceiptItem> items = _parseItems(root, warnings);

    final String currency =
        _firstString(root, <String>['currency', 'valuta']) ??
        _inferCurrency(root) ??
        'BAM';

    final double total = _pickDouble(<dynamic>[
      totals['total'],
      totals['ukupno'],
      totals['iznos'],
      root['total'],
      root['ukupno'],
    ], fallback: 0);

    final String merchantName =
        _firstString(merchant, <String>['name', 'naziv', 'merchant_name']) ??
        _firstString(root, <String>['merchant_name', 'naziv_firme']) ??
        '';

    final DateTime now = DateTime.now();
    final DateTime createdAt =
        _tryParseDateTime(root['created_at']) ??
        _tryParseDateTime(root['timestamp']) ??
        now;

    final DateTime? receiptDateTime =
        _tryParseDateTime(receiptInfo['datetime']) ??
        _tryParseDateTime(receiptInfo['date_time']) ??
        _tryParseDateTime(root['datetime']);

    final Receipt receipt = Receipt(
      id:
          (_firstString(root, <String>['id', 'receipt_id']) ??
                  'rcp-${createdAt.microsecondsSinceEpoch}')
              .trim(),
      country: (_firstString(root, <String>['country', 'drzava']) ?? 'BA')
          .toUpperCase(),
      currency: currency.toUpperCase(),
      merchantName: merchantName,
      storeName: _firstString(merchant, <String>['store_name', 'poslovnica']),
      merchantAddress: _firstString(merchant, <String>['address', 'adresa']),
      merchantCity: _firstString(merchant, <String>['city', 'grad']),
      jib:
          _firstString(merchant, <String>['jib']) ??
          _firstString(root, <String>['jib']),
      pib:
          _firstString(merchant, <String>['pib']) ??
          _firstString(root, <String>['pib']),
      receiptNumber:
          _firstString(receiptInfo, <String>[
            'number',
            'broj',
            'bf',
            'receipt_number',
          ]) ??
          _firstString(root, <String>['bf', 'broj_racuna']),
      receiptDateTime: receiptDateTime,
      items: items,
      subtotal: _pickNullableDouble(<dynamic>[
        totals['subtotal'],
        totals['meduzbroj'],
      ]),
      discountTotal: _pickNullableDouble(<dynamic>[
        totals['discount_total'],
        totals['ukupan_popust'],
      ]),
      taxableAmount: _pickNullableDouble(<dynamic>[
        totals['taxable_amount'],
        totals['osnovica'],
      ]),
      vatRate: _pickNullableDouble(<dynamic>[
        totals['vat_rate'],
        totals['pdv_rate'],
      ]),
      vatAmount: _pickNullableDouble(<dynamic>[
        totals['vat_amount'],
        totals['pdv'],
      ]),
      total: total,
      paymentMethod:
          (_firstString(payment, <String>['method', 'nacin']) ??
                  _firstString(root, <String>[
                    'payment_method',
                    'nacin_placanja',
                  ]) ??
                  'unknown')
              .toLowerCase(),
      paymentPaid: _pickNullableDouble(<dynamic>[
        payment['paid'],
        payment['placeno'],
      ]),
      paymentChange: _pickNullableDouble(<dynamic>[
        payment['change'],
        payment['povrat'],
      ]),
      ibfm:
          _firstString(fiscal, <String>['ibfm']) ??
          _firstString(root, <String>['ibfm']),
      qrPresent: _pickBool(<dynamic>[
        fiscal['qr_present'],
        fiscal['qr'],
        root['qr_present'],
      ]),
      verificationCode: _firstString(fiscal, <String>[
        'verification_code',
        'code',
      ]),
      category:
          (_firstString(root, <String>['category', 'kategorija']) ??
                  'miscellaneous')
              .toLowerCase(),
      confidence: _clamp01(toDoubleValue(root['confidence'], fallback: 0)),
      rawText: _firstString(root, <String>['raw_text', 'ocr_text']),
      rawJson: _encodeRaw(root),
      imagePath: _firstString(root, <String>['image_path', 'slika']),
      createdAt: createdAt,
    );

    errors.addAll(ReceiptSaveValidator.validateDomain(receipt));

    if (merchantName.isEmpty) {
      warnings.add('merchant.name missing');
    }
    if (items.isEmpty) {
      warnings.add('items empty');
    }
    if (total <= 0) {
      warnings.add('totals.total not positive');
    }

    return ReceiptAiParserResult(
      receipt: errors.isEmpty ? receipt : null,
      errors: errors,
      warnings: warnings,
    );
  }

  static ReceiptModel? parseToModel(dynamic input) {
    final ReceiptAiParserResult result = parseStructured(input);
    return result.isValid ? result.receipt!.toModel() : null;
  }

  static List<ReceiptItem> _parseItems(
    Map<String, dynamic> root,
    List<String> warnings,
  ) {
    final dynamic dynamicItems = root['items'] ?? root['stavke'];
    if (dynamicItems is! List) {
      return const <ReceiptItem>[];
    }

    final List<ReceiptItem> parsed = <ReceiptItem>[];
    for (final dynamic entry in dynamicItems) {
      final Map<String, dynamic>? item = _toMap(entry);
      if (item == null) {
        warnings.add('item skipped: not object');
        continue;
      }

      parsed.add(
        ReceiptItem(
          name:
              _firstString(item, <String>['name', 'naziv', 'artikl']) ??
              'unknown',
          unit: _firstString(item, <String>['unit', 'jedinica']),
          quantity: _pickDouble(<dynamic>[
            item['quantity'],
            item['kolicina'],
          ], fallback: 1),
          unitPrice: _pickNullableDouble(<dynamic>[
            item['unit_price'],
            item['cijena_po_komadu'],
            item['cijena'],
          ]),
          discountPercent: _pickNullableDouble(<dynamic>[
            item['discount_percent'],
            item['popust_procenat'],
          ]),
          discountAmount: _pickNullableDouble(<dynamic>[
            item['discount_amount'],
            item['popust_iznos'],
          ]),
          finalPrice: _pickDouble(<dynamic>[
            item['final_price'],
            item['iznos'],
            item['total'],
          ], fallback: 0),
        ),
      );
    }

    return parsed;
  }

  static Map<String, dynamic>? _toMap(dynamic input) {
    if (input == null) {
      return null;
    }
    if (input is Map<String, dynamic>) {
      return input;
    }
    if (input is Map) {
      return input.map(
        (dynamic key, dynamic value) => MapEntry(key.toString(), value),
      );
    }
    if (input is String) {
      try {
        return _toMap(jsonDecode(input));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Map<String, dynamic> _nestedMap(
    Map<String, dynamic> source,
    List<String> keys,
  ) {
    for (final String key in keys) {
      final Map<String, dynamic>? nested = _toMap(source[key]);
      if (nested != null) {
        return nested;
      }
    }
    return <String, dynamic>{};
  }

  static String? _firstString(Map<String, dynamic> source, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = source[key];
      if (value == null) {
        continue;
      }
      final String text = value.toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }

  static double _pickDouble(List<dynamic> values, {required double fallback}) {
    for (final dynamic value in values) {
      if (value == null) {
        continue;
      }
      final double parsed = toDoubleValue(value, fallback: fallback);
      if (parsed != fallback ||
          value.toString().trim() == fallback.toString()) {
        return parsed;
      }
    }
    return fallback;
  }

  static double? _pickNullableDouble(List<dynamic> values) {
    for (final dynamic value in values) {
      if (value == null) {
        continue;
      }
      return toDoubleValue(value);
    }
    return null;
  }

  static bool _pickBool(List<dynamic> values) {
    for (final dynamic value in values) {
      if (value == null) {
        continue;
      }
      if (value is bool) {
        return value;
      }
      final String text = value.toString().trim().toLowerCase();
      if (text == '1' || text == 'true' || text == 'yes' || text == 'da') {
        return true;
      }
      if (text == '0' || text == 'false' || text == 'no' || text == 'ne') {
        return false;
      }
    }
    return false;
  }

  static DateTime? _tryParseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    final String text = value.toString().trim();
    if (text.isEmpty) {
      return null;
    }

    final DateTime? direct = DateTime.tryParse(text);
    if (direct != null) {
      return direct;
    }

    final RegExp bosnianDate = RegExp(
      r'^(\d{1,2})\.(\d{1,2})\.(\d{4})(?:\.?\s+(\d{1,2}):(\d{2}))?$',
    );
    final Match? match = bosnianDate.firstMatch(text);
    if (match != null) {
      final int day = int.parse(match.group(1)!);
      final int month = int.parse(match.group(2)!);
      final int year = int.parse(match.group(3)!);
      final int hour = int.tryParse(match.group(4) ?? '0') ?? 0;
      final int minute = int.tryParse(match.group(5) ?? '0') ?? 0;
      return DateTime(year, month, day, hour, minute);
    }

    return null;
  }

  static String? _inferCurrency(Map<String, dynamic> root) {
    final String haystack = [
      _firstString(root, <String>['raw_text']) ?? '',
      _firstString(root, <String>['currency']) ?? '',
    ].join(' ');

    final String normalized = haystack.toUpperCase();
    if (normalized.contains('BAM') || normalized.contains('KM')) {
      return 'BAM';
    }
    if (normalized.contains('EUR')) {
      return 'EUR';
    }
    return null;
  }

  static String _encodeRaw(Map<String, dynamic> root) {
    try {
      return jsonEncode(root);
    } catch (_) {
      return '{}';
    }
  }

  static double _clamp01(double value) {
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }
}
