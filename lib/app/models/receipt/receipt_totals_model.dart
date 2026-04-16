import 'receipt_parsing_utils.dart';

class ReceiptTotalsModel {
  final double? subtotal;
  final double? discountTotal;
  final double? taxableAmount;
  final double? vatRate;
  final double? vatAmount;
  final double total;

  const ReceiptTotalsModel({
    required this.total,
    this.subtotal,
    this.discountTotal,
    this.taxableAmount,
    this.vatRate,
    this.vatAmount,
  });

  factory ReceiptTotalsModel.fromJson(Map<String, dynamic> json) {
    return ReceiptTotalsModel(
      subtotal: json['subtotal'] != null
          ? toDoubleValue(json['subtotal'])
          : null,
      discountTotal: json['discount_total'] != null
          ? toDoubleValue(json['discount_total'])
          : null,
      taxableAmount: json['taxable_amount'] != null
          ? toDoubleValue(json['taxable_amount'])
          : null,
      vatRate: json['vat_rate'] != null
          ? toDoubleValue(json['vat_rate'])
          : null,
      vatAmount: json['vat_amount'] != null
          ? toDoubleValue(json['vat_amount'])
          : null,
      total: toDoubleValue(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'discount_total': discountTotal,
      'taxable_amount': taxableAmount,
      'vat_rate': vatRate,
      'vat_amount': vatAmount,
      'total': total,
    };
  }
}
