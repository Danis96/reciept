import 'package:flutter/material.dart';
import 'package:refyn/app/features/export/repository/receipt_export_service.dart';
import 'package:refyn/app/models/receipt/merchant_model.dart';
import 'package:refyn/app/models/receipt/payment_info_model.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';

import '../repository/receipt_details_repository.dart';

class ReceiptDetailsController extends ChangeNotifier {
  ReceiptDetailsController({
    required ReceiptDetailsRepository repository,
    required String receiptId,
  }) : _repository = repository,
       _receiptId = receiptId;

  final ReceiptDetailsRepository _repository;
  final String _receiptId;

  bool _isLoading = false;
  bool _isDeleting = false;
  bool _isExporting = false;
  String? _error;
  ReceiptModel? _receipt;

  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;
  bool get isExporting => _isExporting;
  String? get error => _error;
  ReceiptModel? get receipt => _receipt;
  String get receiptId => _receiptId;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _receipt = await _repository.getReceiptById(_receiptId);
      if (_receipt == null) {
        _error = 'Receipt not found.';
      }
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteReceipt() async {
    _isDeleting = true;
    notifyListeners();
    await _repository.deleteReceipt(_receiptId);
    _isDeleting = false;
    notifyListeners();
  }

  Future<String> exportReceipt(ReceiptExportFormat format) async {
    final ReceiptModel? current = _receipt;
    if (current == null) {
      throw StateError('Receipt not loaded.');
    }
    _isExporting = true;
    notifyListeners();
    try {
      return await _repository.exportReceipt(receipt: current, format: format);
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  Future<void> updateBasics({
    required String merchantName,
    required String paymentMethod,
  }) async {
    final ReceiptModel current = _receipt!;
    final ReceiptModel updated = ReceiptModel(
      id: current.id,
      country: current.country,
      currency: current.currency,
      merchant: MerchantModel(
        name: merchantName,
        storeName: current.merchant.storeName,
        address: current.merchant.address,
        city: current.merchant.city,
        jib: current.merchant.jib,
        pib: current.merchant.pib,
      ),
      receiptInfo: current.receiptInfo,
      items: current.items,
      totals: current.totals,
      payment: PaymentInfoModel(
        method: paymentMethod,
        paid: current.payment.paid,
        change: current.payment.change,
      ),
      category: current.category,
      confidence: current.confidence,
      createdAt: current.createdAt,
      fiscal: current.fiscal,
      rawText: current.rawText,
      rawJson: current.rawJson,
      imagePath: current.imagePath,
    );

    await _repository.saveReceipt(updated);
    _receipt = updated;
    notifyListeners();
  }

  Future<void> updateItemCategory({
    required int itemIndex,
    required String category,
  }) async {
    await updateItem(itemIndex: itemIndex, category: category);
  }

  Future<void> updateItem({
    required int itemIndex,
    String? name,
    String? category,
  }) async {
    final ReceiptModel current = _receipt!;
    if (itemIndex < 0 || itemIndex >= current.items.length) {
      throw RangeError.index(itemIndex, current.items, 'itemIndex');
    }

    final updatedItems = current.items
        .asMap()
        .entries
        .map(
          (entry) => entry.key == itemIndex
              ? entry.value.copyWith(
                  name: name ?? entry.value.name,
                  category: category ?? entry.value.category,
                )
              : entry.value,
        )
        .toList(growable: false);

    final ReceiptModel updated = ReceiptModel(
      id: current.id,
      country: current.country,
      currency: current.currency,
      merchant: current.merchant,
      receiptInfo: current.receiptInfo,
      items: updatedItems,
      totals: current.totals,
      payment: current.payment,
      category: current.category,
      confidence: current.confidence,
      createdAt: current.createdAt,
      fiscal: current.fiscal,
      rawText: current.rawText,
      rawJson: current.rawJson,
      imagePath: current.imagePath,
    );

    await _repository.saveReceipt(updated);
    _receipt = updated;
    notifyListeners();
  }
}
