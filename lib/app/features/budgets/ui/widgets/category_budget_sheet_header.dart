import 'package:flutter/material.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/theme/app_spacing.dart';


class CategoryBudgetSheetHeader extends StatelessWidget {
  const CategoryBudgetSheetHeader({super.key, required this.activeBudgets});

  final int activeBudgets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color headingColor = colorScheme.onSurface;
    final Color subtitleColor = colorScheme.secondary;
    final Color badgeBg = colorScheme.primary.withValues(alpha: 0.10);
    final Color badgeBorder = colorScheme.primary.withValues(alpha: 0.18);
    final Color badgeText = colorScheme.primary;
    final Color closeButtonBg = colorScheme.onSurface.withValues(alpha: 0.08);
    final Color closeButtonIcon = colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.categoryBudgets,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: headingColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.budgetSheetDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: badgeBorder),
                  ),
                  child: Text(
                    context.l10n.activeBudgetsLabel(activeBudgets),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: badgeText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Material(
            color: closeButtonBg,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
              color: closeButtonIcon,
            ),
          ),
        ],
      ),
    );
  }
}
