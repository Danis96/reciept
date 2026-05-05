import 'package:refyn/app/models/receipt/receipt_item_model.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';

class HistoryReceiptListEntry {
  const HistoryReceiptListEntry({
    required this.receipt,
    required this.item,
    required this.itemIndex,
  });

  final ReceiptModel receipt;
  final ReceiptItemModel item;
  final int itemIndex;

  String get id => '${receipt.id}::$itemIndex';
  DateTime get createdAt => receipt.createdAt;
  double get amount => item.finalPrice;
  String get merchantName => receipt.merchant.name;
  String get itemName => item.name;
  String get category => item.category;
}
