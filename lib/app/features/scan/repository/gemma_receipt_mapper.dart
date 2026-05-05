import 'dart:convert';

import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/models/receipt/merchant_model.dart';
import 'package:refyn/app/models/receipt/payment_info_model.dart';
import 'package:refyn/app/models/receipt/receipt_info_model.dart';
import 'package:refyn/app/models/receipt/receipt_item_model.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/app/models/receipt/receipt_parsing_utils.dart';
import 'package:refyn/app/models/receipt/receipt_totals_model.dart';

class GemmaReceiptMapper {
  const GemmaReceiptMapper._();

  static ReceiptModel toReceiptModel({
    required Map<String, dynamic> payload,
    required String imagePath,
  }) {
    final DateTime now = DateTime.now();
    final DateTime? purchaseDate = DateTime.tryParse(
      payload['purchaseDate']?.toString() ?? '',
    );
    final String merchantName = _defaultText(
      _safeString(payload['merchantName']),
      fallback: 'unknown',
    );

    final List<ReceiptItemModel> items =
        (payload['items'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic raw) => _itemFromJson(raw))
            .toList(growable: false);

    final double subtotal = toDoubleValue(payload['subtotalAmount']);
    final double vatAmount = toDoubleValue(payload['vatAmount']);
    final double total = _resolveTotal(payload, subtotal, vatAmount, items);

    return ReceiptModel(
      id: _safeString(payload['receiptId']).isEmpty
          ? 'scan-${now.microsecondsSinceEpoch}'
          : _safeString(payload['receiptId']),
      country: 'BA',
      currency: _normalizeCurrency(_safeString(payload['currency'])),
      merchant: MerchantModel(
        name: merchantName,
        address: _emptyToNull(_safeString(payload['merchantAddress'])),
        city: _emptyToNull(_safeString(payload['merchantCity'])),
      ),
      receiptInfo: ReceiptInfoModel(
        type: 'fiscal',
        number: null,
        dateTime: purchaseDate,
      ),
      items: items,
      totals: ReceiptTotalsModel(
        total: total,
        subtotal: subtotal,
        taxableAmount: subtotal - vatAmount,
        vatAmount: vatAmount,
      ),
      payment: PaymentInfoModel(
        method: _defaultText(
          _safeString(payload['paymentMethod']).toLowerCase(),
          fallback: 'unknown',
        ),
        paid: total,
        change: 0,
      ),
      category: _legacyReceiptCategory(items),
      confidence: _clamp01(toDoubleValue(payload['confidence'])),
      rawText: _emptyToNull(_safeString(payload['rawSummary'])),
      rawJson: jsonEncode(payload),
      imagePath: imagePath,
      createdAt: now,
    );
  }

  static ReceiptItemModel _itemFromJson(dynamic raw) {
    if (raw is! Map) {
      return const ReceiptItemModel(
        name: 'unknown',
        category: 'miscellaneous',
        quantity: 1,
        finalPrice: 0,
      );
    }

    final Map<String, dynamic> item = raw.map(
      (dynamic key, dynamic value) => MapEntry(key.toString(), value),
    );

    return ReceiptItemModel(
      name: _defaultText(_safeString(item['name']), fallback: 'unknown'),
      category: CategoryBudgetCatalog.normalize(_safeString(item['category'])),
      unit: _emptyToNull(_safeString(item['unit'])),
      quantity: toDoubleValue(item['quantity'], fallback: 1),
      unitPrice: toDoubleValue(item['unitPrice']),
      finalPrice: _resolveItemFinalPrice(item),
    );
  }

  static String _legacyReceiptCategory(List<ReceiptItemModel> items) {
    if (items.isEmpty) {
      return CategoryBudgetCatalog.miscellaneous;
    }

    return CategoryBudgetCatalog.normalize(items.first.category);
  }

  static String _safeString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static String? _emptyToNull(String value) {
    return value.isEmpty || value.toLowerCase() == 'unknown' ? null : value;
  }

  static String _defaultText(String value, {required String fallback}) {
    return value.isEmpty ? fallback : value;
  }

  static String _normalizeCurrency(String value) {
    final String normalized = value.toUpperCase();
    if (normalized == 'KM') {
      return 'BAM';
    }
    return normalized.isEmpty ? 'BAM' : normalized;
  }

  static double _resolveItemFinalPrice(Map<String, dynamic> item) {
    final double finalPrice = toDoubleValue(item['finalPrice']);
    if (finalPrice > 0) {
      return finalPrice;
    }

    final double unitPrice = toDoubleValue(item['unitPrice']);
    final double quantity = toDoubleValue(item['quantity'], fallback: 1);
    if (unitPrice > 0 && quantity > 0) {
      return unitPrice * quantity;
    }

    return 0;
  }

  static double _resolveTotal(
    Map<String, dynamic> payload,
    double subtotal,
    double vatAmount,
    List<ReceiptItemModel> items,
  ) {
    final double declaredTotal = toDoubleValue(payload['totalAmount']);
    if (declaredTotal > 0) {
      return declaredTotal;
    }

    final double itemsTotal = items.fold<double>(
      0,
      (double sum, ReceiptItemModel item) => sum + item.finalPrice,
    );
    if (itemsTotal > 0) {
      return itemsTotal;
    }

    final double subtotalWithVat = subtotal + vatAmount;
    if (subtotalWithVat > 0) {
      return subtotalWithVat;
    }

    return subtotal > 0 ? subtotal : 0;
  }

  static double _clamp01(double value) {
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }
}
