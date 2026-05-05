import 'dart:convert';

import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/shared/utils/app_currency_utils.dart';
import 'package:refyn/app/models/domain/receipt.dart';
import 'package:refyn/app/models/domain/receipt_item.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/app/models/receipt/receipt_parsing_utils.dart';
import 'package:refyn/app/models/receipt/receipt_validator.dart';

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

  static ReceiptAiParserResult parseStructured(
    dynamic input, {
    String defaultCurrency = AppCurrencyUtils.defaultCode,
  }) {
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
      'betaling',
    ]);
    final Map<String, dynamic> fiscal = _nestedMap(root, <String>[
      'fiscal',
      'fiskalni',
    ]);

    final List<ReceiptItem> items = _parseItems(root, warnings);

    final String currency =
        _firstString(root, <String>['currency', 'valuta', 'mønt']) ??
        _inferCurrency(root) ??
        defaultCurrency;

    final double total = _pickDouble(<dynamic>[
      totals['total'],
      totals['ukupno'],
      totals['iznos'],
      totals['i_alt'],
      root['total'],
      root['ukupno'],
      root['i_alt'],
      root['totalAmount'],
    ], fallback: 0);

    final String merchantName =
        _firstString(merchant, <String>[
          'name',
          'naziv',
          'merchant_name',
          'butik',
        ]) ??
        _firstString(root, <String>[
          'merchant_name',
          'merchantName',
          'naziv_firme',
        ]) ??
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
      country: (_firstString(root, <String>['country', 'drzava', 'land']) ??
              _countryFromCurrency(currency))
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
            'bon',
            'kvitteringsnr',
          ]) ??
          _firstString(root, <String>['bf', 'broj_racuna', 'bon_nr']),
      receiptDateTime: receiptDateTime,
      items: items,
      subtotal: _pickNullableDouble(<dynamic>[
        totals['subtotal'],
        totals['meduzbroj'],
        totals['netto'],
        totals['grundlag'],
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
        totals['moms'],
        totals['heraf_moms'],
      ]),
      total: total,
      paymentMethod:
          (_firstString(payment, <String>['method', 'nacin', 'betalingsmetode']) ??
                  _firstString(root, <String>[
                    'payment_method',
                    'paymentMethod',
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
      category: _legacyReceiptCategory(items),
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

  static ReceiptModel? parseToModel(
    dynamic input, {
    String defaultCurrency = AppCurrencyUtils.defaultCode,
  }) {
    final ReceiptAiParserResult result = parseStructured(
      input,
      defaultCurrency: defaultCurrency,
    );
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
              _firstString(item, <String>[
                'name',
                'naziv',
                'artikl',
                'varetekst',
                'vare',
              ]) ??
              'unknown',
          category: CategoryBudgetCatalog.normalize(
            _firstString(item, <String>['category', 'kategorija']) ??
                'miscellaneous',
          ),
          unit: _firstString(item, <String>['unit', 'jedinica', 'enhed']),
          quantity: _pickDouble(<dynamic>[
            item['quantity'],
            item['kolicina'],
            item['antal'],
          ], fallback: 1),
          unitPrice: _pickNullableDouble(<dynamic>[
            item['unit_price'],
            item['unitPrice'],
            item['cijena_po_komadu'],
            item['cijena'],
            item['pris'],
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
            item['finalPrice'],
            item['iznos'],
            item['total'],
            item['ialt'],
          ], fallback: 0),
        ),
      );
    }

    return parsed;
  }

  static String _legacyReceiptCategory(List<ReceiptItem> items) {
    if (items.isEmpty) {
      return CategoryBudgetCatalog.miscellaneous;
    }

    return CategoryBudgetCatalog.normalize(items.first.category);
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

    final RegExp europeanDate = RegExp(
      r'^(\d{1,2})[.\-/\s](\d{1,2})[.\-/\s](\d{2,4})(?:[.\s]+(\d{1,2}):(\d{2})(?::(\d{2}))?)?$',
    );
    final Match? match = europeanDate.firstMatch(text);
    if (match != null) {
      final int day = int.parse(match.group(1)!);
      final int month = int.parse(match.group(2)!);
      int year = int.parse(match.group(3)!);
      if (year < 100) {
        year += 2000;
      }
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
      _firstString(root, <String>['rawSummary']) ?? '',
    ].join(' ');

    final String normalized = haystack.toUpperCase();
    if (normalized.contains('DKK') ||
        normalized.contains('MOMS') ||
        normalized.contains('I ALT')) {
      return 'DKK';
    }
    if (normalized.contains('BAM') || normalized.contains('KM')) {
      return 'BAM';
    }
    if (normalized.contains('EUR')) {
      return 'EUR';
    }
    if (normalized.contains('USD')) {
      return 'USD';
    }
    return null;
  }

  static String _countryFromCurrency(String currency) {
    switch (currency.toUpperCase()) {
      case 'DKK':
        return 'DK';
      case 'USD':
        return 'US';
      case 'EUR':
        return 'EU';
      default:
        return 'BA';
    }
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
