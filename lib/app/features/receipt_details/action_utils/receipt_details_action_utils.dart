import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/export/repository/receipt_export_service.dart';
import 'package:reciep/app/features/receipt_details/controllers/receipt_details_controller.dart';

class ReceiptDetailsActionUtils {
  const ReceiptDetailsActionUtils._();

  static Future<void> onDeleteConfirmed(BuildContext context) async {
    final ReceiptDetailsController controller = context
        .read<ReceiptDetailsController>();
    await controller.deleteReceipt();
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  static Future<String> onExport(
    BuildContext context, {
    required ReceiptExportFormat format,
  }) {
    return context.read<ReceiptDetailsController>().exportReceipt(format);
  }
}
