import 'package:flutter/material.dart';
import 'package:refyn/app/features/export/repository/receipt_export_service.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/receipt_details/ui/widgets/receipt_action_toolbar.dart';
import 'package:refyn/app/features/receipt_details/ui/widgets/receipt_items_card.dart';
import 'package:refyn/app/features/receipt_details/ui/widgets/receipt_overview_card.dart';
import 'package:refyn/app/features/receipt_details/ui/widgets/receipt_payment_summary.dart';
import 'package:refyn/app/features/receipt_details/ui/widgets/receipt_top_bar.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';

class ReceiptDetailsScaffold extends StatelessWidget {
  const ReceiptDetailsScaffold({
    super.key,
    required this.receipt,
    required this.deleting,
    required this.exporting,
    required this.onViewImage,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onExportSelected,
    required this.onEditItemCategory,
  });

  final ReceiptModel receipt;
  final bool deleting;
  final bool exporting;
  final VoidCallback onViewImage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final Future<void> Function(ReceiptExportFormat format) onExportSelected;
  final Future<void> Function(int itemIndex) onEditItemCategory;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      children: <Widget>[
        const ReceiptTopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              18,
              16,
              28 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: <Widget>[
                ReceiptActionToolbar(
                  hasImage:
                      receipt.imagePath != null &&
                      receipt.imagePath!.trim().isNotEmpty,
                  deleting: deleting,
                  exporting: exporting,
                  onViewImage: onViewImage,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  onShare: onShare,
                  onExportSelected: onExportSelected,
                ),
                const SizedBox(height: 22),
                ReceiptOverviewCard(receipt: receipt),
                const SizedBox(height: 16),
                ReceiptItemsCard(
                  receipt: receipt,
                  onEditItemCategory: onEditItemCategory,
                ),
                const SizedBox(height: 16),
                ReceiptPaymentSummaryCard(receipt: receipt),
                const SizedBox(height: 24),
                Text(
                  context.l10n.keepReceiptForRecords,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
