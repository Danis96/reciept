import 'receipt_parsing_utils.dart';

class ReceiptItemModel {
  final String name;
  final String? unit;
  final double quantity;
  final double? unitPrice;
  final double? discountPercent;
  final double? discountAmount;
  final double finalPrice;

  const ReceiptItemModel({
    required this.name,
    required this.quantity,
    required this.finalPrice,
    this.unit,
    this.unitPrice,
    this.discountPercent,
    this.discountAmount,
  });

  factory ReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ReceiptItemModel(
      name: json['name']?.toString() ?? '',
      unit: json['unit']?.toString(),
      quantity: toDoubleValue(json['quantity'], fallback: 1),
      unitPrice: json['unit_price'] != null
          ? toDoubleValue(json['unit_price'])
          : null,
      discountPercent: json['discount_percent'] != null
          ? toDoubleValue(json['discount_percent'])
          : null,
      discountAmount: json['discount_amount'] != null
          ? toDoubleValue(json['discount_amount'])
          : null,
      finalPrice: toDoubleValue(json['final_price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount_percent': discountPercent,
      'discount_amount': discountAmount,
      'final_price': finalPrice,
    };
  }
}
