import 'dart:convert';

import 'package:reciep/app/models/receipt/merchant_model.dart';
import 'package:reciep/app/models/receipt/payment_info_model.dart';
import 'package:reciep/app/models/receipt/receipt_info_model.dart';
import 'package:reciep/app/models/receipt/receipt_item_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/models/receipt/receipt_parsing_utils.dart';
import 'package:reciep/app/models/receipt/receipt_totals_model.dart';

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

    final List<ReceiptItemModel> items =
        (payload['items'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic raw) => _itemFromJson(raw))
            .toList(growable: false);

    final double subtotal = toDoubleValue(payload['subtotalAmount']);
    final double vatAmount = toDoubleValue(payload['vatAmount']);
    final double total = toDoubleValue(payload['totalAmount']);

    return ReceiptModel(
      id: _safeString(payload['receiptId']).isEmpty
          ? 'scan-${now.microsecondsSinceEpoch}'
          : _safeString(payload['receiptId']),
      country: 'BA',
      currency: _normalizeCurrency(_safeString(payload['currency'])),
      merchant: MerchantModel(
        name: _safeString(payload['merchantName']),
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
        method: _safeString(payload['paymentMethod']).toLowerCase(),
        paid: total,
        change: 0,
      ),
      category: _safeString(payload['category']).toLowerCase(),
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
        quantity: 1,
        finalPrice: 0,
      );
    }

    final Map<String, dynamic> item = raw.map(
      (dynamic key, dynamic value) => MapEntry(key.toString(), value),
    );

    return ReceiptItemModel(
      name: _safeString(item['name']),
      quantity: toDoubleValue(item['quantity'], fallback: 1),
      unitPrice: toDoubleValue(item['unitPrice']),
      finalPrice: toDoubleValue(item['finalPrice']),
    );
  }

  static String _safeString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static String? _emptyToNull(String value) {
    return value.isEmpty || value.toLowerCase() == 'unknown' ? null : value;
  }

  static String _normalizeCurrency(String value) {
    final String normalized = value.toUpperCase();
    if (normalized == 'KM') {
      return 'BAM';
    }
    return normalized.isEmpty ? 'BAM' : normalized;
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
