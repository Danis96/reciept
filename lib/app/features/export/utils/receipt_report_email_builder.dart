import 'package:intl/intl.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';

class ReceiptReportEmailDraft {
  const ReceiptReportEmailDraft({
    required this.subject,
    required this.htmlBody,
    required this.plainTextBody,
    required this.attachmentPaths,
  });

  final String subject;
  final String htmlBody;
  final String plainTextBody;
  final List<String> attachmentPaths;
}

class ReceiptReportEmailBuilder {
  const ReceiptReportEmailBuilder._();

  static ReceiptReportEmailDraft build(List<ReceiptModel> receipts) {
    final DateTime now = DateTime.now();
    final List<String> attachmentPaths = <String>{
      for (final ReceiptModel receipt in receipts)
        if (_hasText(receipt.imagePath)) receipt.imagePath!,
    }.toList(growable: false);

    final String subject =
        'Receipt report - ${DateFormat('dd.MM.yyyy').format(now)}';

    final String htmlBody =
        '''
<html>
  <body style="margin:0;padding:24px;background:#f5f7fb;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;color:#101828;">
    <div style="max-width:720px;margin:0 auto;background:#ffffff;border-radius:24px;padding:28px;border:1px solid #d0d5dd;">
      <div style="padding:18px 20px;border-radius:18px;background:linear-gradient(135deg,#ecfdf3 0%,#f0f9ff 100%);">
        <div style="font-size:12px;letter-spacing:0.08em;text-transform:uppercase;color:#0f766e;font-weight:700;">Receipt export</div>
        <div style="margin-top:8px;font-size:22px;font-weight:800;color:#101828;">${receipts.length} saved receipts</div>
      </div>
      <div style="height:18px;"></div>
      ${receipts.map(_buildReceiptSection).join('<div style="height:14px;"></div>')}
    </div>
  </body>
</html>
''';

    final String plainTextBody = _buildPlainTextBody(receipts, now);

    return ReceiptReportEmailDraft(
      subject: subject,
      htmlBody: htmlBody,
      plainTextBody: plainTextBody,
      attachmentPaths: attachmentPaths,
    );
  }

  static String _buildPlainTextBody(
    List<ReceiptModel> receipts,
    DateTime generatedAt,
  ) {
    final StringBuffer buffer = StringBuffer()
      ..writeln('Receipt Export Report')
      ..writeln(
        'Generated on: ${DateFormat('dd.MM.yyyy HH:mm').format(generatedAt)}',
      )
      ..writeln('Receipts: ${receipts.length}')
      ..writeln();

    for (int index = 0; index < receipts.length; index++) {
      final ReceiptModel receipt = receipts[index];
      buffer
        ..writeln(receipt.merchant.name)
        ..writeln(
          'Total: ${receipt.totals.total.toStringAsFixed(2)} ${receipt.currency}',
        )
        ..writeln(
          'Created: ${DateFormat('dd.MM.yyyy HH:mm').format(receipt.createdAt)}',
        )
        ..writeln('Receipt no.: ${_readValue(receipt.receiptInfo.number)}')
        ..writeln('Payment: ${_readValue(receipt.payment.method)}')
        ..writeln('Items: ${receipt.items.length}');

      if (index != receipts.length - 1) {
        buffer
          ..writeln()
          ..writeln('----------------------------------------')
          ..writeln();
      }
    }

    return buffer.toString().trimRight();
  }

  static String _buildReceiptSection(ReceiptModel receipt) {
    return '''
<table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #d0d5dd;border-radius:18px;background:#fcfcfd;">
  <tr>
    <td style="padding:18px;">
      <div style="font-size:20px;font-weight:700;color:#101828;">${_escapeHtml(receipt.merchant.name)}</div>
      <div style="margin-top:6px;font-size:14px;color:#475467;">Total: ${receipt.totals.total.toStringAsFixed(2)} ${_escapeHtml(receipt.currency)}</div>
      <div style="margin-top:10px;font-size:14px;color:#344054;">Created: ${_escapeHtml(DateFormat('dd.MM.yyyy HH:mm').format(receipt.createdAt))}</div>
      <div style="margin-top:4px;font-size:14px;color:#344054;">Receipt no.: ${_escapeHtml(_readValue(receipt.receiptInfo.number))}</div>
      <div style="margin-top:4px;font-size:14px;color:#344054;">Payment: ${_escapeHtml(_readValue(receipt.payment.method))}</div>
      <div style="margin-top:4px;font-size:14px;color:#344054;">Items: ${receipt.items.length}</div>
    </td>
  </tr>
</table>
''';
  }

  static String _readValue(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? 'Not available' : trimmed;
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }
}
