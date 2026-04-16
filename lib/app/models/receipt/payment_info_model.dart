import 'receipt_parsing_utils.dart';

class PaymentInfoModel {
  final String method;
  final double? paid;
  final double? change;

  const PaymentInfoModel({required this.method, this.paid, this.change});

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentInfoModel(
      method: json['method']?.toString() ?? 'unknown',
      paid: json['paid'] != null ? toDoubleValue(json['paid']) : null,
      change: json['change'] != null ? toDoubleValue(json['change']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'method': method, 'paid': paid, 'change': change};
  }
}
