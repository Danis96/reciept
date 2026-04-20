import 'receipt_parsing_utils.dart';

class ReceiptItemModel {
  final String name;
  final String category;
  final String? unit;
  final double quantity;
  final double? unitPrice;
  final double? discountPercent;
  final double? discountAmount;
  final double finalPrice;

  const ReceiptItemModel({
    required this.name,
    required this.category,
    required this.quantity,
    required this.finalPrice,
    this.unit,
    this.unitPrice,
    this.discountPercent,
    this.discountAmount,
  });

  ReceiptItemModel copyWith({
    String? name,
    String? category,
    String? unit,
    double? quantity,
    double? unitPrice,
    double? discountPercent,
    double? discountAmount,
    double? finalPrice,
  }) {
    return ReceiptItemModel(
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      finalPrice: finalPrice ?? this.finalPrice,
    );
  }

  factory ReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ReceiptItemModel(
      name: json['name']?.toString() ?? '',
      category:
          json['category']?.toString() ??
          json['item_category']?.toString() ??
          'miscellaneous',
      unit: json['unit']?.toString(),
      quantity: toDoubleValue(json['quantity'], fallback: 1),
      unitPrice: json['unit_price'] != null || json['unitPrice'] != null
          ? toDoubleValue(json['unit_price'] ?? json['unitPrice'])
          : null,
      discountPercent: json['discount_percent'] != null
          ? toDoubleValue(json['discount_percent'])
          : null,
      discountAmount: json['discount_amount'] != null
          ? toDoubleValue(json['discount_amount'])
          : null,
      finalPrice: toDoubleValue(json['final_price'] ?? json['finalPrice']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'unit': unit,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount_percent': discountPercent,
      'discount_amount': discountAmount,
      'final_price': finalPrice,
    };
  }
}
