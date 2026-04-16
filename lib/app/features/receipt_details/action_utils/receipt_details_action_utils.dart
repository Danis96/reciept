import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/receipt_details/controllers/receipt_details_controller.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

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

  static Future<void> onExport(
    BuildContext context,
    ReceiptModel receipt,
  ) async {
    final String prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(receipt.toJson());
    await Clipboard.setData(ClipboardData(text: prettyJson));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Receipt JSON copied.')));
  }
}
