import 'package:flutter/material.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/formatters.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/receipt_card_shell.dart';
import 'package:reciep/app/models/receipt/receipt_item_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

import '../../../../../theme/category_palette.dart';
import '../../../budgets/repository/category_budget_catalog.dart';

class ReceiptItemsCard extends StatelessWidget {
  const ReceiptItemsCard({
    super.key,
    required this.receipt,
    required this.onEditItemCategory,
  });

  final ReceiptModel receipt;
  final Future<void> Function(int itemIndex) onEditItemCategory;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return ReceiptCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Items',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          if (receipt.items.isEmpty)
            Text(
              'No items available.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...receipt.items.asMap().entries.map(
              (MapEntry<int, ReceiptItemModel> entry) => ReceiptItemListRow(
                itemIndex: entry.key,
                item: entry.value,
                showDivider: entry.key != receipt.items.length - 1,
                currency: receipt.currency,
                onEditCategory: onEditItemCategory,
              ),
            ),
        ],
      ),
    );
  }
}

class ReceiptItemListRow extends StatelessWidget {
  const ReceiptItemListRow({
    super.key,
    required this.itemIndex,
    required this.item,
    required this.showDivider,
    required this.currency,
    required this.onEditCategory,
  });

  final int itemIndex;
  final ReceiptItemModel item;
  final bool showDivider;
  final String currency;
  final Future<void> Function(int itemIndex) onEditCategory;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
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
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                money(item.finalPrice, currency),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Qty: ${qty(item.quantity)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ReceiptItemCategoryChip(
                category: item.category,
                onTap: () => onEditCategory(itemIndex),
              ),
            ],
          ),
          if (showDivider) ...<Widget>[
            const SizedBox(height: 14),
            Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.7),
              height: 1,
            ),
          ],
        ],
      ),
    );
  }
}

class ReceiptItemCategoryChip extends StatelessWidget {
  const ReceiptItemCategoryChip({
    super.key,
    required this.category,
    required this.onTap,
  });

  final String category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = CategoryPalette.primaryFor(category, context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: CategoryPalette.surfaceFor(category, context),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: accent.withValues(alpha: 0.24)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 6),
              Text(
                CategoryBudgetCatalog.labelFor(category),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.edit_rounded, size: 14, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}
