import 'fiscal_info_model.dart';
import 'merchant_model.dart';
import 'payment_info_model.dart';
import 'receipt_info_model.dart';
import 'receipt_item_model.dart';
import 'receipt_parsing_utils.dart';
import 'receipt_totals_model.dart';

class ReceiptModel {
  final String id;
  final String country;
  final String currency;
  final MerchantModel merchant;
  final ReceiptInfoModel receiptInfo;
  final List<ReceiptItemModel> items;
  final ReceiptTotalsModel totals;
  final PaymentInfoModel payment;
  final FiscalInfoModel? fiscal;
  final String category;
  final double confidence;
  final String? rawText;
  final String? rawJson;
  final String? imagePath;
  final DateTime createdAt;

  const ReceiptModel({
    required this.id,
    required this.country,
    required this.currency,
    required this.merchant,
    required this.receiptInfo,
    required this.items,
    required this.totals,
    required this.payment,
    required this.category,
    required this.confidence,
    required this.createdAt,
    this.fiscal,
    this.rawText,
    this.rawJson,
    this.imagePath,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id']?.toString() ?? '',
      country: json['country']?.toString() ?? 'BA',
      currency: json['currency']?.toString() ?? 'BAM',
      merchant: MerchantModel.fromJson(
        (json['merchant'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      receiptInfo: ReceiptInfoModel.fromJson(
        (json['receipt'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      items: (json['items'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                ReceiptItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      totals: ReceiptTotalsModel.fromJson(
        (json['totals'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      payment: PaymentInfoModel.fromJson(
        (json['payment'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      fiscal: json['fiscal'] != null
          ? FiscalInfoModel.fromJson(json['fiscal'] as Map<String, dynamic>)
          : null,
      category: json['category']?.toString() ?? 'miscellaneous',
      confidence: toDoubleValue(json['confidence']),
      rawText: json['raw_text']?.toString(),
      rawJson: json['raw_json']?.toString(),
      imagePath: json['image_path']?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'currency': currency,
      'merchant': merchant.toJson(),
      'receipt': receiptInfo.toJson(),
      'items': items.map((ReceiptItemModel item) => item.toJson()).toList(),
      'totals': totals.toJson(),
      'payment': payment.toJson(),
      'fiscal': fiscal?.toJson(),
      'category': category,
      'confidence': confidence,
      'raw_text': rawText,
      'raw_json': rawJson,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
