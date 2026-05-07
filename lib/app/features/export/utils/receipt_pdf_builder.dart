import 'package:flutter/services.dart';
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
  static const PdfColor _accentSoft = PdfColor.fromInt(0xFFE6F4F2);
  static const PdfColor _white = PdfColors.white;

  static Future<pw.Font> _loadFont(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return pw.Font.ttf(data);
  }

  static Future<Uint8List> build(List<ReceiptModel> receipts) async {
    final pw.Font baseFont = await _loadFont(
      'assets/fonts/NotoSans-Regular.ttf',
    );
    final pw.Font boldFont = await _loadFont('assets/fonts/NotoSans-Bold.ttf');
    final pw.Font italicFont = await _loadFont(
      'assets/fonts/NotoSans-Italic.ttf',
    );
    final pw.Font boldItalicFont = await _loadFont(
      'assets/fonts/NotoSans-BoldItalic.ttf',
    );

    final pw.Document pdf = pw.Document();
    final DateTime now = DateTime.now();
    final double totalSpent = receipts.fold<double>(
      0,
      (double sum, ReceiptModel item) => sum + item.totals.total,
    );
    final String currency = receipts.isNotEmpty ? receipts.first.currency : '';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 28, 32, 36),
        theme: pw.ThemeData.withFont(
          base: baseFont,
          bold: boldFont,
          italic: italicFont,
          boldItalic: boldItalicFont,
        ),
        header: (pw.Context ctx) => _header(now, receipts.length, totalSpent, currency),
        footer: (pw.Context ctx) => _footer(ctx, receipts.length),
        build: (pw.Context ctx) => <pw.Widget>[
          _sectionLabel('Receipt Overview'),
          pw.SizedBox(height: 8),
          _overviewTable(receipts),
          pw.SizedBox(height: 22),
          if (receipts.isNotEmpty) ...<pw.Widget>[
            _sectionLabel('Full Details'),
            pw.SizedBox(height: 10),
            ...receipts.map(_detailCard),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _header(
    DateTime now,
    int receiptCount,
    double totalSpent,
    String currency,
  ) {
    return pw.Column(
      children: <pw.Widget>[
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: pw.BoxDecoration(
            color: _panel,
            border: pw.Border.all(color: _line, width: 0.5),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: <pw.Widget>[
              pw.Row(
                children: <pw.Widget>[
                  pw.Container(width: 3, height: 28, color: _accent),
                  pw.SizedBox(width: 10),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text(
                        'REFYN',
                        style: pw.TextStyle(
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold,
                          color: _accent,
                          letterSpacing: 2.5,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Receipt Export Report',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: <pw.Widget>[
                  pw.Text(
                    'Generated on',
                    style: pw.TextStyle(fontSize: 8, color: _muted),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    _formatDateTime(now),
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: _accent,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    '$receiptCount receipt(s)  ·  ${totalSpent.toStringAsFixed(2)} $currency',
                    style: pw.TextStyle(fontSize: 8, color: _muted),
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 18),
      ],
    );
  }

  static pw.Widget _sectionLabel(String text) {
    return pw.Row(
      children: <pw.Widget>[
        pw.Container(width: 3, height: 13, color: _accent),
        pw.SizedBox(width: 7),
        pw.Text(
          text.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: _accent,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  static pw.Widget _overviewTable(List<ReceiptModel> receipts) {
    return pw.Table(
      columnWidths: <int, pw.TableColumnWidth>{
        0: const pw.FlexColumnWidth(2.4),
        1: const pw.FlexColumnWidth(1.4),
        2: const pw.FlexColumnWidth(1.4),
        3: const pw.FlexColumnWidth(1.2),
        4: const pw.FlexColumnWidth(1.2),
      },
      border: pw.TableBorder.all(color: _line, width: 0.5),
      children: <pw.TableRow>[
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _ink),
          children: <pw.Widget>[
            _thCell('Merchant'),
            _thCell('Category'),
            _thCell('Payment'),
            _thCell('Date'),
            _thCell('Total'),
          ],
        ),
        ...receipts.asMap().entries.map((MapEntry<int, ReceiptModel> entry) {
          final PdfColor shade = entry.key.isEven ? _white : _panel;
          final ReceiptModel r = entry.value;
          return pw.TableRow(
            decoration: pw.BoxDecoration(color: shade),
            children: <pw.Widget>[
              _tdCell(_readValue(r.merchant.name), bold: true),
              _tdCell(_readValue(r.category)),
              _tdCell(_readValue(r.payment.method)),
              _tdCell(_formatDate(r.createdAt)),
              _tdCell(
                '${r.totals.total.toStringAsFixed(2)} ${r.currency}',
                bold: true,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _thCell(String text) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: _white,
            letterSpacing: 0.5,
          ),
        ),
      );

  static pw.Widget _tdCell(String text, {bool bold = false}) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 8,
            color: _ink,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      );

  static pw.Widget _detailCard(ReceiptModel receipt) {
    final String merchantName = _readValue(
      receipt.merchant.name,
      fallback: 'Unknown merchant',
    );
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _line, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Container(
            color: _ink,
            padding: const pw.EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text(
                        merchantName,
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: _white,
                        ),
                      ),
                      if (_hasText(receipt.merchant.city)) ...<pw.Widget>[
                        pw.SizedBox(height: 3),
                        pw.Text(
                          receipt.merchant.city!,
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: _accentSoft,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                pw.SizedBox(width: 16),
                pw.Text(
                  '${receipt.totals.total.toStringAsFixed(2)} ${receipt.currency}',
                  style: pw.TextStyle(
                    fontSize: 17,
                    fontWeight: pw.FontWeight.bold,
                    color: _accentSoft,
                  ),
                ),
              ],
            ),
          ),
          pw.Container(height: 2, color: _accent),
          pw.Padding(
            padding: const pw.EdgeInsets.all(14),
            child: pw.Column(
              children: <pw.Widget>[
                _dataRow(
                  'Created',
                  _formatDateTime(receipt.createdAt),
                  'Receipt no.',
                  _readValue(receipt.receiptInfo.number),
                ),
                pw.SizedBox(height: 8),
                _dataRow(
                  'Payment',
                  _readValue(receipt.payment.method),
                  'Category',
                  _readValue(receipt.category),
                ),
                pw.SizedBox(height: 8),
                _dataRow(
                  'Confidence',
                  receipt.confidence.toStringAsFixed(2),
                  'Items',
                  '${receipt.items.length}',
                ),
                if (receipt.items.isNotEmpty) ...<pw.Widget>[
                  pw.SizedBox(height: 12),
                  _itemsTable(receipt),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _dataRow(String l1, String v1, String l2, String v2) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Expanded(child: _fieldBox(l1, v1)),
        pw.SizedBox(width: 10),
        pw.Expanded(child: _fieldBox(l2, v2)),
      ],
    );
  }

  static pw.Widget _fieldBox(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: pw.BoxDecoration(
        color: _panel,
        border: pw.Border.all(color: _line, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Text(
            label.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 6.5,
              color: _accent,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            value.isEmpty ? '—' : value,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: _ink,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _itemsTable(ReceiptModel receipt) {
    return pw.Table(
      columnWidths: <int, pw.TableColumnWidth>{
        0: const pw.FlexColumnWidth(4),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.4),
      },
      border: pw.TableBorder.all(color: _line, width: 0.5),
      children: <pw.TableRow>[
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _panel),
          children: <pw.Widget>[
            _thItem('Item'),
            _thItem('Qty', align: pw.TextAlign.right),
            _thItem('Price', align: pw.TextAlign.right),
          ],
        ),
        ...receipt.items.map((ReceiptItemModel item) {
          final String name = item.name.trim().isEmpty
              ? 'Item'
              : item.name.trim();
          final String qty = item.quantity % 1 == 0
              ? item.quantity.toStringAsFixed(0)
              : item.quantity.toStringAsFixed(2);
          return pw.TableRow(
            children: <pw.Widget>[
              _tdItem(name),
              _tdItem(qty, align: pw.TextAlign.right),
              _tdItem(
                '${item.finalPrice.toStringAsFixed(2)} ${receipt.currency}',
                align: pw.TextAlign.right,
                bold: true,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _thItem(String text, {pw.TextAlign? align}) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(
            fontSize: 7.5,
            fontWeight: pw.FontWeight.bold,
            color: _accent,
            letterSpacing: 0.5,
          ),
        ),
      );

  static pw.Widget _tdItem(
    String text, {
    pw.TextAlign? align,
    bool bold = false,
  }) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(
            fontSize: 8,
            color: _ink,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      );

  static pw.Widget _footer(pw.Context ctx, int total) {
    return pw.Column(
      children: <pw.Widget>[
        pw.SizedBox(height: 6),
        pw.Container(height: 0.5, color: _line),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: <pw.Widget>[
            pw.Text(
              'Refyn  ·  Receipt Report',
              style: pw.TextStyle(fontSize: 7.5, color: _muted),
            ),
            pw.Text(
              'Page ${ctx.pageNumber} of ${ctx.pagesCount}  ·  $total receipt(s)',
              style: pw.TextStyle(fontSize: 7.5, color: _muted),
            ),
          ],
        ),
      ],
    );
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _readValue(String? value, {String fallback = 'N/A'}) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? fallback : trimmed;
  }

  static String _formatDate(DateTime value) {
    return DateFormat('dd.MM.yyyy').format(value);
  }

  static String _formatDateTime(DateTime value) {
    return DateFormat('dd.MM.yyyy HH:mm').format(value);
  }
}
