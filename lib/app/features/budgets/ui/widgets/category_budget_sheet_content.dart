import 'package:flutter/material.dart';
import 'package:reciep/app/features/budgets/ui/widgets/category_budget_sheet_header.dart';
import 'package:reciep/app/features/budgets/ui/widgets/category_budget_sheet_row.dart';
import 'package:reciep/theme/app_spacing.dart';

import '../utils/category_budget_sheet_pallete.dart';

class CategoryBudgetSheetContent extends StatelessWidget {
  const CategoryBudgetSheetContent({
    super.key,
    required this.supportedCategories,
    required this.currentAmounts,
    required this.controllers,
    required this.focusNodes,
    required this.fieldKeys,
    required this.busyCategories,
    required this.successCategories,
    required this.onSave,
    required this.onDelete,
  });

  final List<String> supportedCategories;
  final Map<String, double> currentAmounts;
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;
  final Map<String, GlobalKey> fieldKeys;
  final Set<String> busyCategories;
  final Set<String> successCategories;
  final Future<void> Function(String) onSave;
  final Future<void> Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final activeBudgets =
        currentAmounts.values.where((amount) => amount > 0).length;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: CategoryBudgetSheetPalette.cardBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.92),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: keyboardInset),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md + mediaQuery.padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CategoryBudgetSheetHeader(activeBudgets: activeBudgets),
                const SizedBox(height: AppSpacing.md),
                ...supportedCategories.map(
                      (category) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: CategoryBudgetSheetRow(
                      category: category,
                      controller: controllers[category]!,
                      focusNode: focusNodes[category]!,
                      fieldKey: fieldKeys[category]!,
                      busy: busyCategories.contains(category),
                      showSuccess: successCategories.contains(category),
                      currentAmount: currentAmounts[category],
                      onSave: () => onSave(category),
                      onDelete: () => onDelete(category),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
