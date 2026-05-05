import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_category_details_model.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_category_item_model.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/widgets/category_asset_image.dart';
import 'package:refyn/theme/app_colors.dart';
import 'package:refyn/theme/app_spacing.dart';
import 'package:refyn/theme/category_palette.dart';

import '../../action_utils/dashboard_action_utils.dart';

class CategoryBudgetDetailsSheet extends StatelessWidget {
  const CategoryBudgetDetailsSheet({super.key, required this.details});

  final DashboardCategoryDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = CategoryPalette.primaryFor(
      details.category,
      context,
    );
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final double safeRatio = details.usageRatio.clamp(0, 1).toDouble();
    final String monthLabel = DateFormat('MMMM yyyy').format(DateTime.now());
    final String remainingText = details.remainingAmount >= 0
        ? context.l10n.remainingAmountLabel(
            DashboardMoney.formatInt(details.remainingAmount),
          )
        : context.l10n.overBudgetLabel(
            DashboardMoney.formatInt(details.remainingAmount.abs()),
          );

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
              ),
              children: <Widget>[
                CategoryBudgetDetailsHero(
                  details: details,
                  categoryColor: categoryColor,
                  safeRatio: safeRatio,
                  monthLabel: monthLabel,
                  remainingText: remainingText,
                ),
                const SizedBox(height: AppSpacing.md),
                CategoryBudgetDetailsStats(
                  details: details,
                  categoryColor: categoryColor,
                ),
                const SizedBox(height: AppSpacing.md),
                CategoryBudgetDetailsItemsCard(
                  details: details,
                  categoryColor: categoryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBudgetDetailsHero extends StatelessWidget {
  const CategoryBudgetDetailsHero({
    super.key,
    required this.details,
    required this.categoryColor,
    required this.safeRatio,
    required this.monthLabel,
    required this.remainingText,
  });

  final DashboardCategoryDetailsModel details;
  final Color categoryColor;
  final double safeRatio;
  final String monthLabel;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    final Color accentTextColor = details.state == BudgetUsageState.exceeded
        ? AppColors.danger
        : categoryColor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: categoryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.74),
                ),
                child: ClipOval(
                  child: CategoryAssetImage(
                    category: details.category,
                    size: 52,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      details.label,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      monthLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                label: Text(context.l10n.close),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.spentAmountLabel(
              DashboardMoney.formatInt(details.spentAmount),
            ),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            remainingText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: accentTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: safeRatio,
              minHeight: 10,
              backgroundColor: CategoryPalette.trackFor(details.category, context),
              valueColor: AlwaysStoppedAnimation<Color>(
                details.state == BudgetUsageState.exceeded
                    ? AppColors.danger
                    : categoryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBudgetDetailsStats extends StatelessWidget {
  const CategoryBudgetDetailsStats({
    super.key,
    required this.details,
    required this.categoryColor,
  });

  final DashboardCategoryDetailsModel details;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CategoryBudgetDetailsStatCard(
            label: context.l10n.budget,
            value: '${DashboardMoney.formatInt(details.budgetAmount)} KM',
            tone: categoryColor,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: CategoryBudgetDetailsStatCard(
            label: context.l10n.scanItems,
            value: '${details.itemCount}',
            tone: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class CategoryBudgetDetailsStatCard extends StatelessWidget {
  const CategoryBudgetDetailsStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tone.withValues(alpha: 0.38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBudgetDetailsItemsCard extends StatelessWidget {
  const CategoryBudgetDetailsItemsCard({
    super.key,
    required this.details,
    required this.categoryColor,
  });

  final DashboardCategoryDetailsModel details;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.itemsInThisCategory,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            context.l10n.itemsInCategoryThisMonthLabel(details.label),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          if (details.items.isEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            CategoryBudgetDetailsEmptyState(
              categoryColor: categoryColor,
              categoryLabel: details.label,
            ),
          ],
          if (details.items.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            ...details.items.map(
              (DashboardCategoryItemModel item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: CategoryBudgetDetailsItemRow(
                  item: item,
                  categoryColor: categoryColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CategoryBudgetDetailsEmptyState extends StatelessWidget {
  const CategoryBudgetDetailsEmptyState({
    super.key,
    required this.categoryColor,
    required this.categoryLabel,
  });

  final Color categoryColor;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: categoryColor.withValues(alpha: 0.08),
      ),
      child: Text(
        context.l10n.noTrackedItemsInCategoryLabel(categoryLabel),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CategoryBudgetDetailsItemRow extends StatelessWidget {
  const CategoryBudgetDetailsItemRow({
    super.key,
    required this.item,
    required this.categoryColor,
  });

  final DashboardCategoryItemModel item;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    final String quantityText = item.unit == null || item.unit!.trim().isEmpty
        ? item.quantity.toStringAsFixed(
            item.quantity == item.quantity.roundToDouble() ? 0 : 2,
          )
        : '${item.quantity.toStringAsFixed(item.quantity == item.quantity.roundToDouble() ? 0 : 2)} ${item.unit}';

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: AppSpacing.xs),
            decoration: BoxDecoration(
              color: categoryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  item.merchantName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${DateFormat('d MMM, HH:mm').format(item.purchasedAt)} • $quantityText',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.86),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${DashboardMoney.formatInt(item.amount)} KM',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
