import 'package:reciep/app/models/receipt/receipt_item_model.dart';

class ReceiptItem {
  const ReceiptItem({
    required this.name,
    required this.quantity,
    required this.finalPrice,
    this.unit,
    this.unitPrice,
    this.discountPercent,
    this.discountAmount,
  });

  final String name;
  final String? unit;
  final double quantity;
  final double? unitPrice;
  final double? discountPercent;
  final double? discountAmount;
  final double finalPrice;

  ReceiptItemModel toModel() {
    return ReceiptItemModel(
      name: name,
      unit: unit,
      quantity: quantity,
      unitPrice: unitPrice,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
    );
  }

  factory ReceiptItem.fromModel(ReceiptItemModel model) {
    return ReceiptItem(
      name: model.name,
      unit: model.unit,
      quantity: model.quantity,
      unitPrice: model.unitPrice,
      discountPercent: model.discountPercent,
      discountAmount: model.discountAmount,
      finalPrice: model.finalPrice,
    );
  }
}
