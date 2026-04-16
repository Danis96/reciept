double toDoubleValue(dynamic value, {double fallback = 0}) {
  if (value == null) {
    return fallback;
  }

  if (value is num) {
    return value.toDouble();
  }

  final String raw = value.toString().trim();
  if (raw.isEmpty) {
    return fallback;
  }

  String normalized = raw.replaceAll(RegExp(r'[^0-9,.-]'), '');
  if (normalized.isEmpty) {
    return fallback;
  }

  final int lastComma = normalized.lastIndexOf(',');
  final int lastDot = normalized.lastIndexOf('.');
  if (lastComma >= 0 && lastDot >= 0) {
    final bool commaIsDecimal = lastComma > lastDot;
    if (commaIsDecimal) {
      normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
    } else {
      normalized = normalized.replaceAll(',', '');
    }
  } else if (lastComma >= 0) {
    normalized = normalized.replaceAll(',', '.');
  }

  return double.tryParse(normalized) ?? fallback;
}
