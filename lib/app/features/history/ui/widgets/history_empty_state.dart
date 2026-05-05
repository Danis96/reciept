import 'package:flutter/material.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/history/ui/utils/history_ui_utils.dart';
import 'package:refyn/app/widgets/category_asset_image.dart';
import 'package:refyn/theme/app_spacing.dart';
import 'package:refyn/theme/category_palette.dart';

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
                  context.l10n.noItemsFound,
                  style: theme.textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  selectedCategory == 'all'
                      ? context.l10n.noItemsFoundAll
                      : context.l10n.noItemsFoundCategory(
                          HistoryCategoryLabel.labelForBadge(selectedCategory),
                        ),
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
