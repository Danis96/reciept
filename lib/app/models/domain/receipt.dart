import 'package:reciep/app/models/domain/receipt_item.dart';
import 'package:reciep/app/models/receipt/fiscal_info_model.dart';
import 'package:reciep/app/models/receipt/merchant_model.dart';
import 'package:reciep/app/models/receipt/payment_info_model.dart';
import 'package:reciep/app/models/receipt/receipt_info_model.dart';
import 'package:reciep/app/models/receipt/receipt_item_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/models/receipt/receipt_totals_model.dart';

class Receipt {
  const Receipt({
    required this.id,
    required this.country,
    required this.currency,
    required this.merchantName,
    required this.total,
    required this.items,
    required this.category,
    required this.confidence,
    required this.createdAt,
    this.receiptNumber,
    this.receiptDateTime,
    this.storeName,
    this.merchantAddress,
    this.merchantCity,
    this.jib,
    this.pib,
    this.ibfm,
    this.qrPresent = false,
    this.verificationCode,
    this.subtotal,
    this.discountTotal,
    this.taxableAmount,
    this.vatRate,
    this.vatAmount,
    this.paymentMethod,
    this.paymentPaid,
    this.paymentChange,
    this.rawText,
    this.rawJson,
    this.imagePath,
  });

  final String id;
  final String country;
  final String currency;
  final String merchantName;
  final String? storeName;
  final String? merchantAddress;
  final String? merchantCity;
  final String? jib;
  final String? pib;
  final String? receiptNumber;
  final DateTime? receiptDateTime;
  final List<ReceiptItem> items;
  final double? subtotal;
  final double? discountTotal;
  final double? taxableAmount;
  final double? vatRate;
  final double? vatAmount;
  final double total;
  final String? paymentMethod;
  final double? paymentPaid;
  final double? paymentChange;
  final String? ibfm;
  final bool qrPresent;
  final String? verificationCode;
  final String category;
  final double confidence;
  final String? rawText;
  final String? rawJson;
  final String? imagePath;
  final DateTime createdAt;

  ReceiptModel toModel() {
    return ReceiptModel(
      id: id,
      country: country,
      currency: currency,
      merchant: MerchantModel(
        name: merchantName,
        storeName: storeName,
        address: merchantAddress,
        city: merchantCity,
        jib: jib,
        pib: pib,
      ),
      receiptInfo: ReceiptInfoModel(
        type: 'fiscal',
        number: receiptNumber,
        dateTime: receiptDateTime,
        date: null,
        time: null,
      ),
      items: items.map((ReceiptItem item) => item.toModel()).toList(),
      totals: ReceiptTotalsModel(
        total: total,
        subtotal: subtotal,
        discountTotal: discountTotal,
        taxableAmount: taxableAmount,
        vatRate: vatRate,
        vatAmount: vatAmount,
      ),
      payment: PaymentInfoModel(
        method: paymentMethod ?? 'unknown',
        paid: paymentPaid,
        change: paymentChange,
      ),
      fiscal: ibfm == null && verificationCode == null && qrPresent == false
          ? null
          : FiscalInfoModel(
              ibfm: ibfm,
              qrPresent: qrPresent,
              verificationCode: verificationCode,
            ),
      category: category,
      confidence: confidence,
      rawText: rawText,
      rawJson: rawJson,
      imagePath: imagePath,
      createdAt: createdAt,
    );
  }

  factory Receipt.fromModel(ReceiptModel model) {
    return Receipt(
      id: model.id,
      country: model.country,
      currency: model.currency,
      merchantName: model.merchant.name,
      storeName: model.merchant.storeName,
      merchantAddress: model.merchant.address,
      merchantCity: model.merchant.city,
      jib: model.merchant.jib,
      pib: model.merchant.pib,
      receiptNumber: model.receiptInfo.number,
      receiptDateTime: model.receiptInfo.dateTime,
      items: model.items
          .map((ReceiptItemModel item) => ReceiptItem.fromModel(item))
          .toList(),
      subtotal: model.totals.subtotal,
      discountTotal: model.totals.discountTotal,
      taxableAmount: model.totals.taxableAmount,
      vatRate: model.totals.vatRate,
      vatAmount: model.totals.vatAmount,
      total: model.totals.total,
      paymentMethod: model.payment.method,
      paymentPaid: model.payment.paid,
      paymentChange: model.payment.change,
      ibfm: model.fiscal?.ibfm,
      qrPresent: model.fiscal?.qrPresent ?? false,
      verificationCode: model.fiscal?.verificationCode,
      category: model.category,
      confidence: model.confidence,
      rawText: model.rawText,
      rawJson: model.rawJson,
      imagePath: model.imagePath,
      createdAt: model.createdAt,
    );
  }
}
