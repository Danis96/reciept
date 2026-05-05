import 'package:flutter/material.dart';
import 'package:refyn/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/widgets/category_asset_image.dart';
import 'package:refyn/theme/app_spacing.dart';

class HomeBudgetProgressItem extends StatelessWidget {
  const HomeBudgetProgressItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  final DashboardBudgetProgressModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = BudgetCategoryColors.primaryFor(
      item.category,
      context,
    );
    final String remainingText = item.remainingAmount >= 0
        ? context.l10n.remainingAmountLabel(
            DashboardMoney.formatInt(item.remainingAmount),
            item.currency,
          )
        : context.l10n.overBudgetLabel(
            DashboardMoney.formatInt(item.remainingAmount.abs()),
            item.currency,
          );
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: BudgetCategoryColors.surfaceFor(
                        item.category,
                        context,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CategoryAssetImage(
                        category: item.category,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    remainingText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              HomeBudgetProgressBar(
                usageRatio: item.usageRatio,
                state: item.state,
                categoryColor: categoryColor,
                trackColor: BudgetCategoryColors.trackFor(
                  item.category,
                  context,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Row(
                children: <Widget>[
                  Text(
                    context.l10n.spentAmountLabel(
                      DashboardMoney.formatInt(item.spentAmount),
                      item.currency,
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${DashboardMoney.formatInt(item.budgetAmount)} ${item.currency} ${context.l10n.budget.toLowerCase()}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (item.state == BudgetUsageState.nearLimit)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxs),
                  child: Text(
                    '${context.l10n.usedPercentLabel((item.usageRatio * 100).round())} ${item.label}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (item.state == BudgetUsageState.exceeded)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxs),
                  child: Text(
                    '${context.l10n.budget} ${context.l10n.overBudgetLabel(DashboardMoney.formatInt(item.remainingAmount.abs()), item.currency)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: HomeThemePalette.danger(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBudgetProgressBar extends StatelessWidget {
  const HomeBudgetProgressBar({
    super.key,
    required this.usageRatio,
    required this.state,
    required this.categoryColor,
    required this.trackColor,
  });

  final double usageRatio;
  final BudgetUsageState state;
  final Color categoryColor;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final double clamped = usageRatio.clamp(0, 1).toDouble();
    final List<Color> fillColors = state == BudgetUsageState.exceeded
        ? <Color>[categoryColor, HomeThemePalette.danger(context)]
        : <Color>[categoryColor, categoryColor];

    return Container(
      height: 7,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              width: constraints.maxWidth * clamped,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(colors: fillColors),
              ),
            ),
          );
        },
      ),
    );
  }
}
