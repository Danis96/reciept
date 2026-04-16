import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/theme/app_spacing.dart';

class RecentScansSection extends StatelessWidget {
  const RecentScansSection({
    super.key,
    required this.title,
    required this.emptyText,
    required this.emptyHintText,
    required this.receipts,
  });

  final String title;
  final String emptyText;
  final String emptyHintText;
  final List<ReceiptModel> receipts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        if (receipts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.secondary.withValues(alpha: 0.26),
              ),
              color: theme.colorScheme.surface.withValues(alpha: 0.65),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  emptyText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  emptyHintText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ...receipts.map(
          (ReceiptModel receipt) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ScanRecentTile(receipt: receipt),
          ),
        ),
      ],
    );
  }
}

class ScanRecentTile extends StatelessWidget {
  const ScanRecentTile({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('M/d/yyyy');
    final IconData icon = _CategoryIconMapper(receipt.category).icon;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
              ),
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    receipt.merchant.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    receipt.category,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${receipt.totals.total.toStringAsFixed(2)} ${receipt.currency}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  dateFormat.format(receipt.createdAt),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryIconMapper {
  _CategoryIconMapper(this.category);

  final String category;

  IconData get icon {
    switch (CategoryBudgetCatalog.normalize(category)) {
      case CategoryBudgetCatalog.pets:
        return Icons.pets_outlined;
      case CategoryBudgetCatalog.groceries:
        return Icons.shopping_cart_outlined;
      case CategoryBudgetCatalog.household:
        return Icons.home_outlined;
      case CategoryBudgetCatalog.fuel:
        return Icons.local_gas_station_outlined;
      case CategoryBudgetCatalog.clothing:
        return Icons.checkroom_outlined;
      case CategoryBudgetCatalog.miscellaneous:
      default:
        return Icons.category_outlined;
    }
  }
}
