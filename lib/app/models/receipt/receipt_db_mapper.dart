import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:reciep/database/app_database.dart';

import 'fiscal_info_model.dart';
import 'merchant_model.dart';
import 'payment_info_model.dart';
import 'receipt_info_model.dart';
import 'receipt_item_model.dart';
import 'receipt_model.dart';
import 'receipt_totals_model.dart';

extension ReceiptRowMapper on ReceiptWithItems {
  ReceiptModel toReceiptModel() {
    final Map<String, dynamic> payload = _decodePayload(receipt.payloadJson);
    if (payload.isNotEmpty) {
      return ReceiptModel.fromJson(payload);
    }

    return ReceiptModel(
      id: receipt.receiptId,
      country: receipt.country,
      currency: receipt.currency,
      merchant: MerchantModel(
        name: receipt.merchantName,
        storeName: receipt.merchantStoreName,
        address: receipt.merchantAddress,
        city: receipt.merchantCity,
        jib: receipt.merchantJib,
        pib: receipt.merchantPib,
      ),
      receiptInfo: ReceiptInfoModel(
        type: receipt.receiptType,
        number: receipt.receiptNumber,
        dateTime: receipt.receiptDateTime,
        date: receipt.receiptDateText,
        time: receipt.receiptTimeText,
      ),
      items: items
          .map(
            (ReceiptItem item) => ReceiptItemModel(
              name: item.name,
              category: item.category,
              unit: item.unit,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              discountPercent: item.discountPercent,
              discountAmount: item.discountAmount,
              finalPrice: item.finalPrice,
            ),
          )
          .toList(),
      totals: ReceiptTotalsModel(
        total: receipt.totalAmount,
        subtotal: receipt.subtotal,
        discountTotal: receipt.discountTotal,
        taxableAmount: receipt.taxableAmount,
        vatRate: receipt.vatRate,
        vatAmount: receipt.vatAmount,
      ),
      payment: PaymentInfoModel(
        method: receipt.paymentMethod,
        paid: receipt.paymentPaid,
        change: receipt.paymentChange,
      ),
      fiscal:
          receipt.fiscalIbfm == null &&
              receipt.fiscalVerificationCode == null &&
              receipt.fiscalQrPresent == false
          ? null
          : FiscalInfoModel(
              ibfm: receipt.fiscalIbfm,
              qrPresent: receipt.fiscalQrPresent,
              verificationCode: receipt.fiscalVerificationCode,
            ),
      category: receipt.category,
      confidence: receipt.confidence,
      rawText: receipt.rawText,
      rawJson: receipt.rawJson,
      imagePath: receipt.imagePath,
      createdAt: receipt.createdAt,
    );
  }
}

extension ReceiptModelCompanionMapper on ReceiptModel {
  ReceiptsCompanion toReceiptCompanion() {
    return ReceiptsCompanion.insert(
      receiptId: id,
      country: Value(country),
      currency: Value(currency),
      merchantName: Value(merchant.name),
      merchantStoreName: Value(merchant.storeName),
      merchantAddress: Value(merchant.address),
      merchantCity: Value(merchant.city),
      merchantJib: Value(merchant.jib),
      merchantPib: Value(merchant.pib),
      receiptType: Value(receiptInfo.type),
      receiptNumber: Value(receiptInfo.number),
      receiptDateTime: Value(receiptInfo.dateTime),
      receiptDateText: Value(receiptInfo.date),
      receiptTimeText: Value(receiptInfo.time),
      subtotal: Value(totals.subtotal),
      discountTotal: Value(totals.discountTotal),
      taxableAmount: Value(totals.taxableAmount),
      vatRate: Value(totals.vatRate),
      vatAmount: Value(totals.vatAmount),
      totalAmount: Value(totals.total),
      paymentMethod: Value(payment.method),
      paymentPaid: Value(payment.paid),
      paymentChange: Value(payment.change),
      fiscalIbfm: Value(fiscal?.ibfm),
      fiscalQrPresent: Value(fiscal?.qrPresent ?? false),
      fiscalVerificationCode: Value(fiscal?.verificationCode),
      category: Value(category),
      confidence: Value(confidence),
      rawText: Value(rawText),
      rawJson: Value(rawJson),
      imagePath: Value(imagePath),
      payloadJson: Value(jsonEncode(toJson())),
      createdAt: Value(createdAt),
    );
  }

  List<ReceiptItemsCompanion> toReceiptItemsCompanions() {
    return items
        .asMap()
        .entries
        .map(
          (MapEntry<int, ReceiptItemModel> entry) => ReceiptItemsCompanion(
            position: Value(entry.key),
            name: Value(entry.value.name),
            category: Value(entry.value.category),
            unit: Value(entry.value.unit),
            quantity: Value(entry.value.quantity),
            unitPrice: Value(entry.value.unitPrice),
            discountPercent: Value(entry.value.discountPercent),
            discountAmount: Value(entry.value.discountAmount),
            finalPrice: Value(entry.value.finalPrice),
          ),
        )
        .toList();
  }
}

Map<String, dynamic> _decodePayload(String payloadJson) {
  if (payloadJson.trim().isEmpty) {
    return <String, dynamic>{};
  }

  try {
    final dynamic decoded = jsonDecode(payloadJson);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map(
        (dynamic key, dynamic value) => MapEntry(key.toString(), value),
      );
    }
    return <String, dynamic>{};
  } catch (_) {
    return <String, dynamic>{};
  }
}
