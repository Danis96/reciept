import 'package:flutter/material.dart';
import 'package:wiggly_loaders/wiggly_loaders.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/receipt_details/action_utils/receipt_details_action_utils.dart';
import 'package:refyn/app/features/receipt_details/controllers/receipt_details_controller.dart';
import 'package:refyn/app/features/receipt_details/ui/widgets/receipt_details_scaffold.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/app/widgets/app_snackbar.dart';
import 'package:refyn/theme/app_spacing.dart';

class ReceiptDetailsPage extends StatelessWidget {
  const ReceiptDetailsPage({super.key, required this.heroTag});

  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptDetailsController>(
      builder:
          (
            BuildContext context,
            ReceiptDetailsController controller,
            Widget? child,
          ) {
            if (controller.isLoading && controller.receipt == null) {
              return Scaffold(
                body: SafeArea(
                  child: Center(
                    child: WigglyLoader.indeterminate(willAnimate: true),
                  ),
                ),
              );
            }

            if (controller.error != null || controller.receipt == null) {
              return Scaffold(
                appBar: AppBar(title: Text(context.l10n.receiptDetails)),
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        controller.error ?? context.l10n.receiptNotFound,
                      ),
                    ),
                  ),
                ),
              );
            }

            final ReceiptModel receipt = controller.receipt!;
            final ThemeData theme = Theme.of(context);
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: 1),
                builder: (BuildContext context, double value, Widget? child) {
                  return Transform.translate(
                    offset: Offset(0, 18 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: ReceiptDetailsScaffold(
                  receipt: receipt,
                  deleting: controller.isDeleting,
                  exporting: controller.isExporting,
                  onViewImage: () => ReceiptDetailsActionUtils.openReceiptImage(
                    context,
                    receipt,
                  ),
                  onEdit: () => ReceiptDetailsActionUtils.showEditDialog(
                    context,
                    controller,
                    receipt,
                  ),
                  onDelete: () =>
                      ReceiptDetailsActionUtils.showDeleteDialog(context),
                  onShare: () => AppSnackBar.warning(
                    context,
                    context.l10n.shareUnavailable,
                  ),
                  onExportSelected: (format) =>
                      ReceiptDetailsActionUtils.onExport(
                        context,
                        format: format,
                      ),
                  onEditItemCategory: (int itemIndex) =>
                      ReceiptDetailsActionUtils.showItemCategoryPicker(
                        context,
                        controller,
                        receipt,
                        itemIndex: itemIndex,
                      ),
                ),
              ),
            );
          },
    );
  }
}
