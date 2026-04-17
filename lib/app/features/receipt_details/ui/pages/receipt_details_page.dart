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
            return Scaffold(
              backgroundColor: const Color(0xFFF5F7FB),
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
                  onViewImage: () => _openReceiptImage(context, receipt),
                  onEdit: () => _showEditDialog(context, controller, receipt),
                  onDelete: () => _showDeleteDialog(context),
                  onShare: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share is not available yet.'),
                      ),
                    );
                  },
                  onExportSelected: (ReceiptExportFormat format) async {
                    final String path = await ReceiptDetailsActionUtils.onExport(
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
                      SnackBar(content: Text('$formatLabel saved: $path')),
                    );
                  },
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

  Future<void> _openReceiptImage(
    BuildContext context,
    ReceiptModel receipt,
  ) async {
    final String? imagePath = receipt.imagePath;
    final bool hasImage = imagePath != null && imagePath.trim().isNotEmpty;

    if (!hasImage) {
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
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return const Text(
                            'Unable to load image.',
                            style: TextStyle(color: Colors.white),
                          );
                        },
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
  });

  final ReceiptModel receipt;
  final bool deleting;
  final bool exporting;
  final VoidCallback onViewImage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final Future<void> Function(ReceiptExportFormat format) onExportSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const _ReceiptTopBar(),
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
                  hasImage: receipt.imagePath != null &&
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
                ReceiptItemsCard(receipt: receipt),
                const SizedBox(height: 16),
                ReceiptPaymentSummaryCard(receipt: receipt),
                const SizedBox(height: 24),
                Text(
                  'Keep this receipt for your records',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF95A4C6),
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

class _ReceiptTopBar extends StatelessWidget {
  const _ReceiptTopBar();

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;

    return Container(
      height: 72 + topInset,
      padding: EdgeInsets.fromLTRB(18, topInset, 18, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE7EDF6)),
        ),
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Color(0xFF4A5468),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Receipt Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptActionToolbar extends StatelessWidget {
  const ReceiptActionToolbar({
    super.key,
    required this.hasImage,
    required this.deleting,
    required this.exporting,
    required this.onViewImage,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onExportSelected,
  });

  final bool hasImage;
  final bool deleting;
  final bool exporting;
  final VoidCallback onViewImage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final Future<void> Function(ReceiptExportFormat format) onExportSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 10,
        children: <Widget>[
          _ActionButton(
            icon: Icons.image_outlined,
            onTap: hasImage ? onViewImage : null,
          ),
          _ActionButton(
            icon: Icons.edit_outlined,
            onTap: deleting ? null : onEdit,
          ),
          _ActionButton(
            icon: Icons.delete_outline_rounded,
            iconColor: const Color(0xFFFF4D4F),
            borderColor: const Color(0xFFFFD9D9),
            onTap: deleting ? null : onDelete,
          ),
          _ActionButton(
            icon: Icons.share_outlined,
            onTap: onShare,
          ),
          ReceiptExportButton(
            exporting: exporting,
            onSelected: onExportSelected,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.iconColor = const Color(0xFF64748B),
    this.borderColor = const Color(0xFFDDE5F0),
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: onTap == null ? const Color(0xFFF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? iconColor.withValues(alpha: 0.35)
              : iconColor,
        ),
      ),
    );
  }
}

class ReceiptExportButton extends StatelessWidget {
  const ReceiptExportButton({
    super.key,
    required this.exporting,
    required this.onSelected,
  });

  final bool exporting;
  final Future<void> Function(ReceiptExportFormat format) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ReceiptExportFormat>(
      tooltip: 'Export receipt',
      onSelected: onSelected,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDDE5F0)),
        ),
        child: exporting
            ? const Padding(
                padding: EdgeInsets.all(9),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF64748B),
                ),
              )
            : const Icon(
                Icons.file_download_outlined,
                size: 18,
                color: Color(0xFF64748B),
              ),
      ),
    );
  }
}

class ReceiptOverviewCard extends StatelessWidget {
  const ReceiptOverviewCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    final String receiptNumber =
        receipt.receiptInfo.number?.trim().isNotEmpty == true
        ? receipt.receiptInfo.number!.trim()
        : 'RCP-${DateFormat('yyyy-MM-dd').format(receipt.createdAt)}-${receipt.id.substring(0, receipt.id.length >= 3 ? 3 : receipt.id.length).padLeft(3, '0')}';

    return _ReceiptCardShell(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _CardLabel(text: 'Receipt Number'),
                    const SizedBox(height: 6),
                    Text(
                      receiptNumber,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF273142),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _money(receipt.totals.total, receipt.currency),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE7EDF6), height: 1),
          const SizedBox(height: 14),
          ReceiptInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: DateFormat('MMMM d, y').format(receipt.createdAt),
          ),
          const SizedBox(height: 14),
          ReceiptInfoRow(
            icon: Icons.storefront_outlined,
            label: 'Merchant',
            value: receipt.merchant.name.trim().isEmpty
                ? 'Unknown merchant'
                : receipt.merchant.name.trim(),
          ),
          const SizedBox(height: 14),
          ReceiptInfoRow(
            icon: Icons.credit_card_outlined,
            label: 'Payment Method',
            value: receipt.payment.method.trim().isEmpty
                ? 'Unknown'
                : receipt.payment.method.trim(),
          ),
          const SizedBox(height: 14),
          ReceiptCategoryRow(category: receipt.category),
        ],
      ),
    );
  }
}

class ReceiptInfoRow extends StatelessWidget {
  const ReceiptInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _InfoIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _CardLabel(text: label),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReceiptCategoryRow extends StatelessWidget {
  const ReceiptCategoryRow({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CategoryAssetImage(category: category, size: 28),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _CardLabel(text: 'Category'),
              const SizedBox(height: 2),
              Text(
                CategoryBudgetCatalog.labelFor(category),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReceiptItemsCard extends StatelessWidget {
  const ReceiptItemsCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    return _ReceiptCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Items',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF273142),
            ),
          ),
          const SizedBox(height: 14),
          if (receipt.items.isEmpty)
            Text(
              'No items available.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
          if (receipt.items.isNotEmpty)
            ...receipt.items.asMap().entries.map((MapEntry<int, ReceiptItemModel> entry) {
              return ReceiptItemListRow(
                item: entry.value,
                showDivider: entry.key != receipt.items.length - 1,
                currency: receipt.currency,
              );
            }),
        ],
      ),
    );
  }
}

class ReceiptItemListRow extends StatelessWidget {
  const ReceiptItemListRow({
    super.key,
    required this.item,
    required this.showDivider,
    required this.currency,
  });

  final ReceiptItemModel item;
  final bool showDivider;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: showDivider ? 14 : 0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  item.name.trim().isEmpty ? 'Unnamed item' : item.name.trim(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF273142),
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _money(item.finalPrice, currency),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF273142),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Qty: ${_qty(item.quantity)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7A99),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showDivider) ...<Widget>[
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFE7EDF6), height: 1),
          ],
        ],
      ),
    );
  }
}

class ReceiptPaymentSummaryCard extends StatelessWidget {
  const ReceiptPaymentSummaryCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    return _ReceiptCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Payment Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF273142),
            ),
          ),
          const SizedBox(height: 18),
          _PaymentSummaryRow(
            label: 'Subtotal',
            value: _money(receipt.totals.subtotal ?? 0, receipt.currency),
          ),
          const SizedBox(height: 12),
          _PaymentSummaryRow(
            label: 'Tax',
            value: _money(receipt.totals.vatAmount ?? 0, receipt.currency),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE7EDF6), height: 1),
          const SizedBox(height: 14),
          _PaymentSummaryRow(
            label: 'Total',
            value: _money(receipt.totals.total, receipt.currency),
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _PaymentSummaryRow extends StatelessWidget {
  const _PaymentSummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = emphasize
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          )
        : Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF273142),
          );

    return Row(
      children: <Widget>[
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

class _ReceiptCardShell extends StatelessWidget {
  const _ReceiptCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE5F0)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoIcon extends StatelessWidget {
  const _InfoIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF6B7A99),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

String _money(double value, String currency) {
  final String code = currency.trim().isEmpty ? 'KM' : currency.trim();
  return '${value.toStringAsFixed(2)} $code';
}

String _qty(double quantity) {
  if (quantity == quantity.roundToDouble()) {
    return quantity.toStringAsFixed(0);
  }
  return quantity.toStringAsFixed(2);
}
