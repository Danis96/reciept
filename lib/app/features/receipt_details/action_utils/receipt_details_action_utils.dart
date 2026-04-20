import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/export/repository/receipt_export_service.dart';
import 'package:reciep/app/features/receipt_details/controllers/receipt_details_controller.dart';
import 'package:reciep/app/models/receipt/receipt_item_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/theme/app_spacing.dart';

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
    BuildContext context, {
    required ReceiptExportFormat format,
  }) async {
    final String path = await context
        .read<ReceiptDetailsController>()
        .exportReceipt(format);
    if (!context.mounted) {
      return;
    }
    final String formatLabel = switch (format) {
      ReceiptExportFormat.csv => 'CSV',
      ReceiptExportFormat.json => 'JSON',
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$formatLabel saved: $path')));
  }

  static Future<void> showDeleteDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        final navigator = Navigator.of(dialogContext);
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
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This action cannot be undone. This will permanently delete this receipt from your history.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
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
                    onPressed: () => navigator.pop(true),
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => navigator.pop(false),
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
    await onDeleteConfirmed(context);
  }

  static Future<void> showEditDialog(
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

    final bool? save = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final navigator = Navigator.of(dialogContext);

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
                  onPressed: () => navigator.pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => navigator.pop(true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (save != true || !context.mounted) return;

    await controller.updateBasics(
      merchantName: merchantController.text.trim().isEmpty
          ? receipt.merchant.name
          : merchantController.text.trim(),
      paymentMethod: paymentController.text.trim().isEmpty
          ? receipt.payment.method
          : paymentController.text.trim(),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Receipt updated.')));
  }

  static Future<void> showItemCategoryPicker(
    BuildContext context,
    ReceiptDetailsController controller,
    ReceiptModel receipt, {
    required int itemIndex,
  }) async {
    if (itemIndex < 0 || itemIndex >= receipt.items.length) {
      return;
    }

    final ReceiptItemModel item = receipt.items[itemIndex];
    String selectedCategory = CategoryBudgetCatalog.normalize(item.category);
    final TextEditingController nameController = TextEditingController(
      text: item.name,
    );

    final ({String category, String name})? editedItem =
        await showModalBottomSheet<({String category, String name})>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext sheetContext) {
            final ThemeData theme = Theme.of(sheetContext);
            final ColorScheme colorScheme = theme.colorScheme;

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    12,
                    AppSpacing.md,
                    AppSpacing.md +
                        MediaQuery.of(sheetContext).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Change item category',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name.trim().isEmpty
                            ? 'Unnamed item'
                            : item.name.trim(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Item name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: CategoryBudgetCatalog.supportedCategories
                            .map(
                              (String category) => ChoiceChip(
                                label: Text(
                                  CategoryBudgetCatalog.labelFor(category),
                                ),
                                selected: selectedCategory == category,
                                onSelected: (_) {
                                  setState(() => selectedCategory = category);
                                },
                              ),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(sheetContext).pop((
                            category: selectedCategory,
                            name: nameController.text.trim(),
                          )),
                          child: const Text('Save changes'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );

    final String? saveCategory = editedItem?.category;
    final String normalizedName = editedItem?.name.trim() ?? '';
    final String nextName = normalizedName.isEmpty ? item.name : normalizedName;

    if (saveCategory == null || !context.mounted) {
      return;
    }

    final bool categoryUnchanged =
        saveCategory == CategoryBudgetCatalog.normalize(item.category);
    final bool nameUnchanged = nextName == item.name;
    if (categoryUnchanged && nameUnchanged) {
      return;
    }

    await controller.updateItem(
      itemIndex: itemIndex,
      name: nextName,
      category: saveCategory,
    );
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${nextName.trim().isEmpty ? 'Item' : nextName.trim()} updated.',
        ),
      ),
    );
  }

  static Future<void> openReceiptImage(
    BuildContext context,
    ReceiptModel receipt,
  ) async {
    final String? imagePath = receipt.imagePath;
    if (imagePath == null || imagePath.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No receipt image available.')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (BuildContext dialogContext) {
        return Dialog.fullscreen(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'Unable to load image.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(dialogContext).padding.top + 12,
                right: 16,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
