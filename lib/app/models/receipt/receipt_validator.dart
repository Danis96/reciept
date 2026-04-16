import 'package:reciep/app/models/domain/receipt.dart';
import 'package:reciep/app/models/domain/receipt_item.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

class ReceiptSaveValidator {
  const ReceiptSaveValidator._();

  static List<String> validateDomain(Receipt receipt) {
    final List<String> errors = <String>[];

    if (receipt.id.trim().isEmpty) {
      errors.add('receipt.id is required');
    }
    if (receipt.country.trim().isEmpty) {
      errors.add('receipt.country is required');
    }
    if (receipt.currency.trim().isEmpty) {
      errors.add('receipt.currency is required');
    }
    if (receipt.merchantName.trim().isEmpty) {
      errors.add('merchant.name is required');
    }
    if (receipt.total <= 0) {
      errors.add('totals.total must be greater than 0');
    }
    if (receipt.createdAt.isAfter(
      DateTime.now().add(const Duration(days: 1)),
    )) {
      errors.add('created_at is in the future');
    }

    for (int i = 0; i < receipt.items.length; i++) {
      final ReceiptItem item = receipt.items[i];
      if (item.name.trim().isEmpty) {
        errors.add('items[$i].name is required');
      }
      if (item.quantity <= 0) {
        errors.add('items[$i].quantity must be > 0');
      }
      if (item.finalPrice < 0) {
        errors.add('items[$i].final_price must be >= 0');
      }
    }

    return errors;
  }

  static List<String> validateModel(ReceiptModel model) {
    return validateDomain(Receipt.fromModel(model));
  }

  static bool canSaveModel(ReceiptModel model) {
    return validateModel(model).isEmpty;
  }
}
