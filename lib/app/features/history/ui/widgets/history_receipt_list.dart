import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/history/controllers/history_receipt_list_entry.dart';
import 'package:reciep/app/features/history/ui/utils/history_ui_utils.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/widgets/category_asset_image.dart';
import 'package:reciep/theme/app_spacing.dart';
import 'package:reciep/theme/category_palette.dart';

class HistoryReceiptsList extends StatelessWidget {
  const HistoryReceiptsList({
    super.key,
    required this.entries,
    required this.onOpenDetails,
  });

  final List<HistoryReceiptListEntry> entries;
  final Future<void> Function(ReceiptModel receipt) onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries
          .asMap()
          .entries
          .map(
            (MapEntry<int, HistoryReceiptListEntry> entry) =>
                HistoryReceiptListCard(
                  key: ValueKey<String>(entry.value.id),
                  entry: entry.value,
                  index: entry.key,
                  onOpenDetails: onOpenDetails,
                ),
          )
          .toList(growable: false),
    );
  }
}

class HistoryReceiptListCard extends StatelessWidget {
  const HistoryReceiptListCard({
    super.key,
    required this.entry,
    required this.index,
    required this.onOpenDetails,
  });

  final HistoryReceiptListEntry entry;
  final int index;
  final Future<void> Function(ReceiptModel receipt) onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String merchantName = entry.merchantName.trim().isEmpty
        ? 'Unknown merchant'
        : entry.merchantName.trim();
    final String itemName = entry.itemName.trim().isEmpty
        ? 'Unnamed item'
        : entry.itemName.trim();
    final String quantityLabel = entry.item.quantity % 1 == 0
        ? entry.item.quantity.toStringAsFixed(0)
        : entry.item.quantity.toStringAsFixed(2);
    final String priceLabel =
        '${entry.amount.toStringAsFixed(2)} KM';

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 220 + (index * 40).clamp(0, 240)),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onOpenDetails(entry.receipt),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: HistoryThemePalette.border(context)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              merchantName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              itemName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        priceLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        children: <Widget>[
                          HistoryReceiptMetaChip(label: 'Qty: $quantityLabel'),
                          const SizedBox(width: 6),
                          HistoryReceiptMetaChip(
                            label:
                                DateFormat('MMM d, yyyy').format(entry.createdAt),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          HistoryItemCategoryBadge(category: entry.category),
                          const SizedBox(width: 6),
                          HistoryReceiptMetaChip(
                            label:
                            CategoryBudgetCatalog.labelFor(entry.category),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryItemCategoryBadge extends StatelessWidget {
  const HistoryItemCategoryBadge({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CategoryPalette.surfaceFor(category, context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CategoryPalette.primaryFor(category, context).withValues(
            alpha: 0.22,
          ),
        ),
      ),
      child: CategoryAssetImage(category: category, size: 28),
    );
  }
}

class HistoryReceiptMetaChip extends StatelessWidget {
  const HistoryReceiptMetaChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
