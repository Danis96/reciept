class GemmaReceiptResponseValidator {
  const GemmaReceiptResponseValidator._();

  static const Set<String> _requiredRootKeys = <String>{
    'receiptId',
    'merchantName',
    'merchantCity',
    'merchantAddress',
    'currency',
    'subtotalAmount',
    'vatAmount',
    'totalAmount',
    'paymentMethod',
    'category',
    'purchaseDate',
    'rawSummary',
    'confidence',
    'items',
  };

  static const Set<String> _requiredItemKeys = <String>{
    'name',
    'quantity',
    'unitPrice',
    'finalPrice',
  };

  static List<String> validate(Map<String, dynamic> payload) {
    final List<String> errors = <String>[];

    final Set<String> rootKeys = payload.keys.toSet();
    final Set<String> missingRoot = _requiredRootKeys.difference(rootKeys);
    final Set<String> extraRoot = rootKeys.difference(_requiredRootKeys);

    if (missingRoot.isNotEmpty) {
      errors.add('Missing root keys: ${missingRoot.toList()..sort()}');
    }
    if (extraRoot.isNotEmpty) {
      errors.add('Unexpected root keys: ${extraRoot.toList()..sort()}');
    }

    for (final String key in _requiredRootKeys) {
      if (!payload.containsKey(key)) {
        continue;
      }
      if (key == 'items') {
        continue;
      }
      if (payload[key] is! String) {
        errors.add('$key must be string');
      }
    }

    final dynamic rawItems = payload['items'];
    if (rawItems is! List) {
      errors.add('items must be array');
      return errors;
    }

    if (rawItems.isEmpty) {
      errors.add('items must not be empty');
      return errors;
    }

    for (int index = 0; index < rawItems.length; index++) {
      final dynamic rawItem = rawItems[index];
      if (rawItem is! Map) {
        errors.add('items[$index] must be object');
        continue;
      }

      final Map<String, dynamic> item = rawItem.map(
        (dynamic key, dynamic value) => MapEntry(key.toString(), value),
      );

      final Set<String> itemKeys = item.keys.toSet();
      final Set<String> missingItem = _requiredItemKeys.difference(itemKeys);
      final Set<String> extraItem = itemKeys.difference(_requiredItemKeys);

      if (missingItem.isNotEmpty) {
        errors.add(
          'items[$index] missing keys: ${missingItem.toList()..sort()}',
        );
      }
      if (extraItem.isNotEmpty) {
        errors.add(
          'items[$index] unexpected keys: ${extraItem.toList()..sort()}',
        );
      }

      for (final String key in _requiredItemKeys) {
        if (!item.containsKey(key)) {
          continue;
        }
        if (item[key] is! String) {
          errors.add('items[$index].$key must be string');
        }
      }
    }

    final String? purchaseDate = payload['purchaseDate'] as String?;
    if (purchaseDate != null && !_isIsoDate(purchaseDate)) {
      errors.add('purchaseDate must match YYYY-MM-DD');
    }

    _requirePositiveNumber(payload, 'totalAmount', errors);
    _requireNumber(payload, 'subtotalAmount', errors);
    _requireNumber(payload, 'vatAmount', errors);

    final String? confidenceRaw = payload['confidence'] as String?;
    if (confidenceRaw != null) {
      final double? confidence = double.tryParse(confidenceRaw);
      if (confidence == null || confidence < 0 || confidence > 1) {
        errors.add('confidence must be number between 0 and 1');
      }
    }

    return errors;
  }

  static void _requirePositiveNumber(
    Map<String, dynamic> payload,
    String key,
    List<String> errors,
  ) {
    final String? raw = payload[key] as String?;
    final double? value = raw == null ? null : double.tryParse(raw);
    if (value == null || value <= 0) {
      errors.add('$key must be positive number string');
    }
  }

  static void _requireNumber(
    Map<String, dynamic> payload,
    String key,
    List<String> errors,
  ) {
    final String? raw = payload[key] as String?;
    final double? value = raw == null ? null : double.tryParse(raw);
    if (value == null) {
      errors.add('$key must be number string');
    }
  }

  static bool _isIsoDate(String value) {
    final RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!datePattern.hasMatch(value)) {
      return false;
    }
    return DateTime.tryParse(value) != null;
  }
}
