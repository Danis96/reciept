String money(double value, String currency) {
  final String code = currency.trim().isEmpty ? 'KM' : currency.trim();
  return '${value.toStringAsFixed(2)} $code';
}

String qty(double quantity) {
  if (quantity == quantity.roundToDouble()) {
    return quantity.toStringAsFixed(0);
  }
  return quantity.toStringAsFixed(2);
}
