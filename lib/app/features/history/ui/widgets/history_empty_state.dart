import 'package:flutter/material.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/history/ui/utils/history_ui_utils.dart';
import 'package:reciep/app/widgets/category_asset_image.dart';
import 'package:reciep/theme/app_spacing.dart';
import 'package:reciep/theme/category_palette.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key, required this.selectedCategory});

  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    final String category = selectedCategory == 'all'
        ? CategoryBudgetCatalog.household
        : selectedCategory;

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: CategoryPalette.surfaceFor(category, context)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface,
            ),
            child: CategoryAssetImage(category: category, size: 52),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'No receipts found',
                  style: theme.textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  selectedCategory == 'all'
                      ? 'Try a different merchant, category, or date range. Your saved receipts will appear here.'
                      : 'No ${HistoryCategoryLabel.labelForBadge(selectedCategory).toLowerCase()} receipts match the current search or date range.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
