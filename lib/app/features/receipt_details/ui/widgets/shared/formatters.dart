import 'package:refyn/app/shared/utils/app_currency_utils.dart';

String money(double value, String currency) {
  final String code = AppCurrencyUtils.normalizeCode(currency);
  return '${value.toStringAsFixed(2)} $code';
}

String qty(double quantity) {
  if (quantity == quantity.roundToDouble()) {
    return quantity.toStringAsFixed(0);
  }
  return quantity.toStringAsFixed(2);
}
