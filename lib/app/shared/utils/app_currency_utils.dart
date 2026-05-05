class AppCurrencyUtils {
  const AppCurrencyUtils._();

  static const String defaultCode = 'BAM';

  static String normalizeCode(
    String? value, {
    String fallback = defaultCode,
  }) {
    final String normalized = (value ?? '').trim().toUpperCase();
    if (normalized == 'KM') {
      return 'BAM';
    }
    if (normalized == 'KR' || normalized == 'DKR') {
      return 'DKK';
    }
    return normalized.isEmpty ? fallback.trim().toUpperCase() : normalized;
  }
}
