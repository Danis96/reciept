import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';
import 'package:reciep/app/features/scan/controllers/scan_controller.dart';
import 'package:reciep/app/features/scan/repository/scan_failure.dart';
import 'package:reciep/app/helpers/extensions/build_context_x.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

class ScanActionUtils {
  const ScanActionUtils._();

  static void handleFailure(
      BuildContext context,
      ScanController controller,
      ) {
    final ScanFailure? failure = controller.consumeFailure();
    if (failure == null) {
      return;
    }

    // Use a post-frame callback to safely show a dialog during a build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      showErrorPopup(context, failure);
    });
  }

  static Future<void> onOpenGallery(BuildContext context) {
    return context.read<ScanController>().pickFromGallery();
  }

  static Future<void> onOpenCamera(BuildContext context) {
    return context.read<ScanController>().pickFromCamera();
  }

  static Future<void> onScan(BuildContext context) async {
    await context.read<ScanController>().scanSelectedImage();
  }

  static Future<void> onRetryScan(BuildContext context) async {
    await context.read<ScanController>().scanSelectedImage();
  }

  static Future<void> onSaveDraft(BuildContext context) async {
    final ScanController scanController = context.read<ScanController>();
    final DashboardController dashboardController = context
        .read<DashboardController>();
    final HistoryController historyController = context
        .read<HistoryController>();

    await scanController.saveDraftReceipt();
    final bool saved = !scanController.hasPendingReceiptDraft;
    if (saved) {
      await dashboardController.refreshHome();
      await historyController.loadHistory();
    }
    if (!context.mounted) {
      return;
    }
    if (saved) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.scanReceiptSaved)));
    }
  }

  static void onReset(BuildContext context) {
    context.read<ScanController>().clearSelection();
  }

  static Future<void> onScanAnother(BuildContext context) {
    return context.read<ScanController>().showReadyToScan();
  }

  static Future<void> onEditDraft(BuildContext context) async {
    final ScanController controller = context.read<ScanController>();
    final ReceiptModel? draft = controller.pendingReceiptDraft;
    if (draft == null) {
      return;
    }

    final TextEditingController merchantController = TextEditingController(
      text: draft.merchant.name,
    );
    final TextEditingController paymentController = TextEditingController(
      text: draft.payment.method,
    );
    final TextEditingController totalController = TextEditingController(
      text: draft.totals.total.toStringAsFixed(2),
    );

    final bool? save = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext _, StateSetter setState) {
            return AlertDialog(
              title: Text(context.l10n.scanEditParsedReceipt),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: merchantController,
                      decoration: InputDecoration(
                        labelText: context.l10n.scanEditMerchant,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: paymentController,
                      decoration: InputDecoration(
                        labelText: context.l10n.scanEditPaymentMethod,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: totalController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: context.l10n.scanEditTotal,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(context.l10n.scanDialogCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(context.l10n.scanDialogApply),
                ),
              ],
            );
          },
        );
      },
    );

    if (save != true || !context.mounted) {
      return;
    }

    final double? total = double.tryParse(totalController.text.trim());
    if (total == null || total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.scanTotalValidationError)),
      );
      return;
    }

    controller.updateDraftReceipt(
      merchantName: merchantController.text.trim().isEmpty
          ? draft.merchant.name
          : merchantController.text.trim(),
      paymentMethod: paymentController.text.trim().isEmpty
          ? draft.payment.method
          : paymentController.text.trim(),
      total: total,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.scanDraftUpdated)));
  }

  static Future<void> showErrorPopup(
      BuildContext context,
      ScanFailure failure,
      ) async {
    if (!context.mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colorScheme.error.withValues(alpha:0.16),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        failure.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  failure.message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(context.l10n.scanErrorDismiss),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await onRetryScan(context);
                        },
                        child: Text(context.l10n.scanErrorRetry),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
