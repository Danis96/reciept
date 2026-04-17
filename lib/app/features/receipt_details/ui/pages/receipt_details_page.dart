import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/export/repository/receipt_export_service.dart';
import 'package:reciep/app/features/receipt_details/action_utils/receipt_details_action_utils.dart';
import 'package:reciep/app/features/receipt_details/controllers/receipt_details_controller.dart';
import 'package:reciep/app/models/receipt/receipt_item_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/widgets/category_asset_image.dart';
import 'package:reciep/theme/app_spacing.dart';
import 'package:reciep/theme/category_palette.dart';

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
              return const Scaffold(
                body: SafeArea(
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (controller.error != null || controller.receipt == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Receipt Details')),
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(controller.error ?? 'Receipt not found'),
                    ),
                  ),
                ),
              );
            }

            final ReceiptModel receipt = controller.receipt!;
            final Color accent = CategoryPalette.primaryFor(
              receipt.category,
              context,
            );
            final String rawJsonPretty = const JsonEncoder.withIndent(
              '  ',
            ).convert(receipt.toJson());

            return Scaffold(
              body: SafeArea(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (BuildContext context, double value, Widget? child) {
                    return Transform.translate(
                      offset: Offset(0, 18 * (1 - value)),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: Column(
                      children: <Widget>[
                        ReceiptDetailsHeader(
                          receipt: receipt,
                          accent: accent,
                          exporting: controller.isExporting,
                          onBack: () => Navigator.of(context).pop(),
                          onExportSelected: (ReceiptExportFormat format) async {
                            final String path =
                                await ReceiptDetailsActionUtils.onExport(
                                  context,
                                  format: format,
                                );
                            if (!context.mounted) {
                              return;
                            }
                            final String formatLabel = switch (format) {
                              ReceiptExportFormat.csv => 'CSV',
                              ReceiptExportFormat.json => 'JSON',
                            };
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$formatLabel saved: $path'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ReceiptImageCard(receipt: receipt, heroTag: heroTag),
                        const SizedBox(height: AppSpacing.md),
                        ReceiptMetaCard(receipt: receipt),
                        const SizedBox(height: AppSpacing.md),
                        ReceiptLineItemsCard(receipt: receipt),
                        const SizedBox(height: AppSpacing.md),
                        ReceiptTotalsCard(receipt: receipt),
                        const SizedBox(height: AppSpacing.md),
                        ReceiptRawJsonCard(rawJsonPretty: rawJsonPretty),
                        const SizedBox(height: AppSpacing.md),
                        ReceiptDetailsActionRow(
                          deleting: controller.isDeleting,
                          onEdit: () =>
                              _showEditDialog(context, controller, receipt),
                          onDelete: () => _showDeleteDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Delete Receipt?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This action cannot be undone. This will permanently delete this receipt from your history.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD92D00),
                    ),
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm != true || !context.mounted) {
      return;
    }
    await ReceiptDetailsActionUtils.onDeleteConfirmed(context);
  }

  Future<void> _showEditDialog(
    BuildContext context,
    ReceiptDetailsController controller,
    ReceiptModel receipt,
  ) async {
    final TextEditingController merchantController = TextEditingController(
      text: receipt.merchant.name,
    );
    final TextEditingController paymentController = TextEditingController(
      text: receipt.payment.method,
    );
    String selectedCategory = CategoryBudgetCatalog.normalize(receipt.category);

    final bool? save = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Receipt'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: merchantController,
                    decoration: const InputDecoration(
                      labelText: 'Merchant',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: CategoryBudgetCatalog.supportedCategories
                        .map(
                          (String category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category[0].toUpperCase() + category.substring(1),
                            ),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: paymentController,
                    decoration: const InputDecoration(
                      labelText: 'Payment method',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Save'),
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

    await controller.updateBasics(
      merchantName: merchantController.text.trim().isEmpty
          ? receipt.merchant.name
          : merchantController.text.trim(),
      category: selectedCategory,
      paymentMethod: paymentController.text.trim().isEmpty
          ? receipt.payment.method
          : paymentController.text.trim(),
    );
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Receipt updated.')));
  }
}

class ReceiptDetailsHeader extends StatelessWidget {
  const ReceiptDetailsHeader({
    super.key,
    required this.receipt,
    required this.accent,
    required this.exporting,
    required this.onBack,
    required this.onExportSelected,
  });

  final ReceiptModel receipt;
  final Color accent;
  final bool exporting;
  final VoidCallback onBack;
  final Future<void> Function(ReceiptExportFormat format) onExportSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            accent.withValues(alpha: 0.18),
            Theme.of(context).colorScheme.surface,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Material(
                color: Colors.white.withValues(alpha: 0.72),
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.white.withValues(alpha: 0.72),
                shape: const CircleBorder(),
                child: ReceiptDetailsExportMenu(
                  exporting: exporting,
                  onSelected: onExportSelected,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: accent.withValues(alpha: 0.26),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CategoryAssetImage(
                    category: receipt.category,
                    size: 58,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Receipt Details',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      CategoryBudgetCatalog.labelFor(receipt.category),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceiptDetailsExportMenu extends StatelessWidget {
  const ReceiptDetailsExportMenu({
    super.key,
    required this.exporting,
    required this.onSelected,
  });

  final bool exporting;
  final Future<void> Function(ReceiptExportFormat format) onSelected;

  @override
  Widget build(BuildContext context) {
    if (exporting) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return PopupMenuButton<ReceiptExportFormat>(
      tooltip: 'Export receipt',
      onSelected: (ReceiptExportFormat format) async => onSelected(format),
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<ReceiptExportFormat>>[
            const PopupMenuItem<ReceiptExportFormat>(
              value: ReceiptExportFormat.csv,
              child: Text('Export CSV'),
            ),
            const PopupMenuItem<ReceiptExportFormat>(
              value: ReceiptExportFormat.json,
              child: Text('Export JSON'),
            ),
          ],
      icon: const Icon(Icons.download_outlined),
    );
  }
}

class ReceiptImageCard extends StatelessWidget {
  const ReceiptImageCard({
    super.key,
    required this.receipt,
    required this.heroTag,
  });

  final ReceiptModel receipt;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = receipt.imagePath;
    final bool hasImage = imagePath != null && imagePath.trim().isNotEmpty;

    return _DetailCard(
      child: Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: hasImage
                ? Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return const ReceiptImagePlaceholder();
                        },
                  )
                : const ReceiptImagePlaceholder(),
          ),
        ),
      ),
    );
  }
}

class ReceiptImagePlaceholder extends StatelessWidget {
  const ReceiptImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE5E7EC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.inventory_2_outlined, size: 42, color: Colors.grey[600]),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Receipt Image',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptMetaCard extends StatelessWidget {
  const ReceiptMetaCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    final String categoryLabel = CategoryBudgetCatalog.labelFor(
      receipt.category,
    );
    final int confidence = receipt.confidence <= 1
        ? (receipt.confidence * 100).round().clamp(0, 100)
        : receipt.confidence.round().clamp(0, 100);

    return _DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      receipt.merchant.name.isEmpty
                          ? 'Unknown merchant'
                          : receipt.merchant.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      DateFormat('EEEE, MMMM d, y').format(receipt.createdAt),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFEDEEF2),
                child: ClipOval(
                  child: CategoryAssetImage(
                    category: receipt.category,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _MetaRow(
            label: 'Category',
            valueWidget: _PillText(text: categoryLabel, dark: false),
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(label: 'Items', valueText: '${receipt.items.length}'),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(
            label: 'AI Confidence',
            valueWidget: _PillText(text: '$confidence%', dark: true),
          ),
        ],
      ),
    );
  }
}

class ReceiptLineItemsCard extends StatelessWidget {
  const ReceiptLineItemsCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Line Items',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          if (receipt.items.isEmpty)
            Text(
              'No line items available for this receipt.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          if (receipt.items.isNotEmpty)
            ...receipt.items.map(
              (ReceiptItemModel item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ItemRow(item: item),
              ),
            ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final ReceiptItemModel item;

  @override
  Widget build(BuildContext context) {
    final String name = item.name.trim().isEmpty ? 'Unnamed item' : item.name;
    final bool showQty = item.quantity > 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                showQty ? '$name  x${item.quantity.toStringAsFixed(0)}' : name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                CategoryBudgetCatalog.labelFor(item.category),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${item.finalPrice.toStringAsFixed(2)} KM',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class ReceiptTotalsCard extends StatelessWidget {
  const ReceiptTotalsCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Total Breakdown',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          _MetaRow(
            label: 'Subtotal',
            valueText:
                '${(receipt.totals.subtotal ?? 0).toStringAsFixed(2)} KM',
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(
            label: 'Taxes',
            valueText:
                '${(receipt.totals.vatAmount ?? 0).toStringAsFixed(2)} KM',
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(
            label: 'Payment',
            valueText: receipt.payment.method.isEmpty
                ? 'unknown'
                : receipt.payment.method,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            label: 'Total',
            valueText: '${receipt.totals.total.toStringAsFixed(2)} KM',
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class ReceiptRawJsonCard extends StatelessWidget {
  const ReceiptRawJsonCard({super.key, required this.rawJsonPretty});

  final String rawJsonPretty;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Raw JSON',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SelectableText(
              rawJsonPretty,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFF2F3348),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptDetailsActionRow extends StatelessWidget {
  const ReceiptDetailsActionRow({
    super.key,
    required this.deleting,
    required this.onEdit,
    required this.onDelete,
  });

  final bool deleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            onPressed: deleting ? null : onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: deleting ? null : onDelete,
            icon: const Icon(Icons.delete_outline, color: Color(0xFFE14924)),
            label: Text(
              deleting ? 'Deleting...' : 'Delete',
              style: const TextStyle(color: Color(0xFFE14924)),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    this.valueText,
    this.valueWidget,
    this.emphasize = false,
  });

  final String label;
  final String? valueText;
  final Widget? valueWidget;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        valueWidget ??
            Text(
              valueText ?? '-',
              style: emphasize
                  ? Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    )
                  : Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
            ),
      ],
    );
  }
}

class _PillText extends StatelessWidget {
  const _PillText({required this.text, required this.dark});

  final String text;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFFFFF2D8) : const Color(0xFFEFF1F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: dark ? const Color(0xFFE3BA61) : Colors.transparent,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: dark ? const Color(0xFFCA8D19) : const Color(0xFF3C4058),
        ),
      ),
    );
  }
}
