import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:refyn/app/models/receipt/receipt_item_model.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';

class ReceiptPdfBuilder {
  const ReceiptPdfBuilder._();

  static const PdfColor _ink = PdfColor.fromInt(0xFF101828);
  static const PdfColor _muted = PdfColor.fromInt(0xFF667085);
  static const PdfColor _panel = PdfColor.fromInt(0xFFF8FAFC);
  static const PdfColor _line = PdfColor.fromInt(0xFFD0D5DD);
  static const PdfColor _accent = PdfColor.fromInt(0xFF0F766E);

  static Future<Uint8List> build(List<ReceiptModel> receipts) async {
    final pw.Document pdf = pw.Document();
    final DateTime now = DateTime.now();
    final double totalSpent = receipts.fold<double>(
      0,
      (double sum, ReceiptModel item) => sum + item.totals.total,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 36),
        build: (pw.Context context) => <pw.Widget>[
          _buildHeader(now, receipts.length, totalSpent),
          pw.SizedBox(height: 20),
          ...receipts.map(_buildReceiptCard),
        ],
        footer: (pw.Context context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: _muted),
          ),
        ),
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(
    DateTime now,
    int receiptCount,
    double totalSpent,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: _panel,
        borderRadius: pw.BorderRadius.circular(16),
        border: pw.Border.all(color: _line),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Text(
            'Receipt Export Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: _ink,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Generated ${_formatDateTime(now)}',
            style: const pw.TextStyle(fontSize: 11, color: _muted),
          ),
          pw.SizedBox(height: 14),
          pw.Row(
            children: <pw.Widget>[
              _buildStat('Receipts', '$receiptCount'),
              pw.SizedBox(width: 10),
              _buildStat('Total', totalSpent.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStat(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(12),
          border: pw.Border.all(color: _line),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _accent,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: _ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildReceiptCard(ReceiptModel receipt) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(14),
        border: pw.Border.all(color: _line),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text(
                      receipt.merchant.name,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: _ink,
                      ),
                    ),
                    if (_hasText(receipt.merchant.city))
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 4),
                        child: pw.Text(
                          receipt.merchant.city!,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: _muted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: pw.BoxDecoration(
                  color: _panel,
                  borderRadius: pw.BorderRadius.circular(999),
                ),
                child: pw.Text(
                  '${receipt.totals.total.toStringAsFixed(2)} ${receipt.currency}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: _accent,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          _buildInfoRow('Created', _formatDateTime(receipt.createdAt)),
          _buildInfoRow('Receipt no.', _readValue(receipt.receiptInfo.number)),
          _buildInfoRow('Payment', _readValue(receipt.payment.method)),
          _buildInfoRow('Category', _readValue(receipt.category)),
          _buildInfoRow('Confidence', receipt.confidence.toStringAsFixed(2)),
          if (receipt.items.isNotEmpty) ...<pw.Widget>[
            pw.SizedBox(height: 10),
            pw.Text(
              'Items',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: _ink,
              ),
            ),
            pw.SizedBox(height: 6),
            ...receipt.items.take(8).map(_buildItemRow),
            if (receipt.items.length > 8)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4),
                child: pw.Text(
                  '+${receipt.items.length - 8} more items',
                  style: const pw.TextStyle(fontSize: 10, color: _muted),
                ),
              ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.SizedBox(
            width: 76,
            child: pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 10, color: _muted),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 10, color: _ink),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemRow(ReceiptItemModel item) {
    final String price = item.finalPrice.toStringAsFixed(2);
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 4),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: pw.BoxDecoration(
        color: _panel,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        children: <pw.Widget>[
          pw.Expanded(
            child: pw.Text(
              item.name,
              style: const pw.TextStyle(fontSize: 10, color: _ink),
            ),
          ),
          pw.Text(
            price,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: _accent,
            ),
          ),
        ],
      ),
    );
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _readValue(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? 'Not available' : trimmed;
  }

  static String _formatDateTime(DateTime value) {
    return DateFormat('dd.MM.yyyy HH:mm').format(value);
  }
}
