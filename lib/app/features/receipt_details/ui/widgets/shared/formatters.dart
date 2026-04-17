String money(double value, String currency) {
  final String code = 'KM';
  return '${value.toStringAsFixed(2)} $code';
}

String qty(double quantity) {
  if (quantity == quantity.roundToDouble()) {
    return quantity.toStringAsFixed(0);
  }
  return quantity.toStringAsFixed(2);
}
