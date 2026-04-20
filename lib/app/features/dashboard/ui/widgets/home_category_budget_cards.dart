import 'package:flutter/material.dart';
import 'package:reciep/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:reciep/app/features/dashboard/ui/widgets/home_budget_progress_item.dart';
import 'package:reciep/app/features/dashboard/ui/widgets/home_card_empty_state.dart';
import 'package:reciep/theme/app_spacing.dart';

class HomeCategoryBudgetsCard extends StatefulWidget {
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
  State<HomeCategoryBudgetsCard> createState() =>
      _HomeCategoryBudgetsCardState();
}

class _HomeCategoryBudgetsCardState extends State<HomeCategoryBudgetsCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surface,
        border: Border.all(color: HomeThemePalette.cardBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                child: Row(
                  children: <Widget>[
                    Text(
                      _isExpanded ? 'Hide' : 'Show',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
              GestureDetector(
                onTap: widget.onManageBudgets,
                child:  Text('Manage', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w500)),
              ),]
          ),
          const SizedBox(height: 4),
          const Divider(thickness: 0.5),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              Text(
                'Category Budgets',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1,
                      child: child,
                    ),
                  );
                },
                child: !_isExpanded
                    ? const SizedBox.shrink(key: ValueKey('collapsed'))
                    : Padding(
                        key: const ValueKey('expanded'),
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: widget.data.budgetProgress.isEmpty
                            ? const HomeCardEmptyState(
                                imageCategory: 'miscellaneous',
                                title: 'No budgets yet',
                                message:
                                    'Create monthly category budgets from Manage and track each spend bucket here.',
                              )
                            : Column(
                                children: widget.data.budgetProgress
                                    .map(
                                      (DashboardBudgetProgressModel budget) =>
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: AppSpacing.sm,
                                            ),
                                            child: HomeBudgetProgressItem(
                                              item: budget,
                                              onTap: () =>
                                                  widget.onOpenCategory(
                                                    budget.category,
                                                  ),
                                            ),
                                          ),
                                    )
                                    .toList(growable: false),
                              ),
                      ),
              ),
            ),
          ),
          if (!_isExpanded && widget.data.budgetProgress.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                '${widget.data.budgetProgress.length} budget categories hidden',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
