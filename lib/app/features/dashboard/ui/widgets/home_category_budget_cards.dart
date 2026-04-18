import 'package:flutter/material.dart';
import 'package:reciep/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:reciep/app/features/dashboard/ui/widgets/home_budget_progress_item.dart';
import 'package:reciep/app/features/dashboard/ui/widgets/home_card_empty_state.dart';
import 'package:reciep/theme/app_spacing.dart';

class HomeCategoryBudgetsCard extends StatelessWidget {
  const HomeCategoryBudgetsCard({
    super.key,
    required this.data,
    required this.onManageBudgets,
    required this.onOpenCategory,
  });

  final HomeDashboardModel data;
  final VoidCallback onManageBudgets;
  final ValueChanged<String> onOpenCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: HomeThemePalette.cardBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Category Budgets',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: onManageBudgets,
                child: const Text('Manage'),
              ),
            ],
          ),
          if (data.budgetProgress.isEmpty)
            const HomeCardEmptyState(
              imageCategory: 'miscellaneous',
              title: 'No budgets yet',
              message:
              'Create monthly category budgets from Manage and track each spend bucket here.',
            ),
          if (data.budgetProgress.isNotEmpty)
            ...data.budgetProgress.map(
                  (DashboardBudgetProgressModel budget) => Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: HomeBudgetProgressItem(
                  item: budget,
                  onTap: () => onOpenCategory(budget.category),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
