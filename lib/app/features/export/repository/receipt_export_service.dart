import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

enum ReceiptExportFormat { json, csv }

class ReceiptExportService {
  const ReceiptExportService();

  static const List<String> _csvHeaders = <String>[
    'id',
    'created_at',
    'country',
    'currency',
    'merchant_name',
    'merchant_store_name',
    'merchant_city',
    'category',
    'payment_method',
    'receipt_number',
    'receipt_date',
    'receipt_time',
    'subtotal',
    'vat_amount',
    'discount_total',
    'total',
    'item_count',
    'image_path',
    'confidence',
  ];

  Future<String> exportReceipts({
    required List<ReceiptModel> receipts,
    required ReceiptExportFormat format,
    required String scopeLabel,
  }) async {
    final String content = switch (format) {
      ReceiptExportFormat.json => _buildJson(receipts),
      ReceiptExportFormat.csv => _buildCsv(receipts),
    };
    final File file = await _createExportFile(
      format: format,
      scopeLabel: scopeLabel,
    );
    await file.writeAsString(content);
    return file.path;
  }

  String _buildJson(List<ReceiptModel> receipts) {
    final List<Map<String, dynamic>> payload = receipts
        .map((ReceiptModel receipt) => receipt.toJson())
        .toList(growable: false);
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(payload);
  }

  String _buildCsv(List<ReceiptModel> receipts) {
    final List<String> lines = <String>[_csvHeaders.join(',')];
    for (final ReceiptModel receipt in receipts) {
      final List<String> values = <String>[
        receipt.id,
        receipt.createdAt.toIso8601String(),
        receipt.country,
        receipt.currency,
        receipt.merchant.name,
        receipt.merchant.storeName ?? '',
        receipt.merchant.city ?? '',
        receipt.category,
        receipt.payment.method,
        receipt.receiptInfo.number ?? '',
        receipt.receiptInfo.date ?? '',
        receipt.receiptInfo.time ?? '',
        (receipt.totals.subtotal ?? 0).toStringAsFixed(2),
        (receipt.totals.vatAmount ?? 0).toStringAsFixed(2),
        (receipt.totals.discountTotal ?? 0).toStringAsFixed(2),
        receipt.totals.total.toStringAsFixed(2),
        receipt.items.length.toString(),
        receipt.imagePath ?? '',
        receipt.confidence.toStringAsFixed(4),
      ];
      lines.add(values.map(_escapeCsv).join(','));
    }
    return lines.join('\n');
  }

  Future<File> _createExportFile({
    required ReceiptExportFormat format,
    required String scopeLabel,
  }) async {
    final Directory exportDirectory = Directory(
      '${Directory.systemTemp.path}/reciep_exports',
    );
    if (!await exportDirectory.exists()) {
      await exportDirectory.create(recursive: true);
    }

    final String timestamp = DateFormat(
      'yyyyMMdd_HHmmss',
    ).format(DateTime.now());
    final String extension = switch (format) {
      ReceiptExportFormat.json => 'json',
      ReceiptExportFormat.csv => 'csv',
    };
    final String scope = _sanitizeScope(scopeLabel);
    return File(
      '${exportDirectory.path}/receipts_${scope}_$timestamp.$extension',
    );
  }

  String _sanitizeScope(String input) {
    final String sanitized = input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return sanitized.isEmpty ? 'export' : sanitized;
  }

  String _escapeCsv(String value) {
    final String escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
