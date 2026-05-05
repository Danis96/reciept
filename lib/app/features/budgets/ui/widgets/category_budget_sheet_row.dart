import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiggly_loaders/wiggly_loaders.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/budgets/ui/utils/budget_formatting.dart';
import 'package:refyn/app/features/settings/controllers/settings_controller.dart';
import 'package:refyn/app/widgets/category_asset_image.dart';
import 'package:refyn/theme/app_spacing.dart';
import 'package:refyn/theme/category_palette.dart';

import '../utils/category_budget_sheet_pallete.dart';

class CategoryBudgetSheetRow extends StatelessWidget {
  const CategoryBudgetSheetRow({
    super.key,
    required this.category,
    required this.controller,
    required this.focusNode,
    required this.fieldKey,
    required this.busy,
    required this.showSuccess,
    required this.currentAmount,
    required this.onSave,
    required this.onDelete,
    this.currency = 'BAM',
  });

  final String category;
  final TextEditingController controller;
  final FocusNode focusNode;
  final GlobalKey fieldKey;
  final bool busy;
  final bool showSuccess;
  final double? currentAmount;
  final VoidCallback onSave;
  final VoidCallback onDelete;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = CategoryPalette.primaryFor(category, context);
    final String currencyCode = context.read<SettingsController>().currencyCode;
    final currentAmountLabel = currentAmount == null
        ? context.l10n.noBudgetSet
        : context.l10n.activeBudgetAmountLabel(
            CategoryBudgetMoney.formatInt(currentAmount!),
            currencyCode,
          );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: CategoryBudgetSheetPalette.cardBorder(context),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CategoryPalette.surfaceFor(category, context),
                ),
                child: ClipOval(
                  child: CategoryAssetImage(category: category, size: 44),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CategoryBudgetLabel.shortLabel(category),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentAmountLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: _buildStatusIndicator(context, accent),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          KeyedSubtree(
            key: fieldKey,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: !busy,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _buildInputDecoration(context, accent),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context, Color accent) {
    if (busy) {
      return SizedBox(
        key: const ValueKey('busy'),
        width: 18,
        height: 18,
        child: WigglyLoader.indeterminate(size: 18, strokeWidth: 2.2),
      );
    }
    if (showSuccess) {
      return Container(
        key: const ValueKey('success'),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
      );
    }
    return const SizedBox(key: ValueKey('idle'), width: 22, height: 22);
  }

  InputDecoration _buildInputDecoration(BuildContext context, Color accent) {
    final borderColor = CategoryBudgetSheetPalette.cardBorder(context);
    return InputDecoration(
      prefixIcon: Icon(Icons.wallet_outlined, color: accent),
      suffixText: currency,
      hintText: context.l10n.enterMonthlyBudget,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent, width: 1.4),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: busy ? null : onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: CategoryBudgetSheetPalette.danger(context),
              side: BorderSide(
                color: CategoryBudgetSheetPalette.danger(
                  context,
                ).withValues(alpha: 0.28),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: Text(context.l10n.clear),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: FilledButton.icon(
            onPressed: busy ? null : onSave,
            style: FilledButton.styleFrom(
              backgroundColor: CategoryPalette.primaryFor(category, context),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.check_rounded, size: 18),
            label: Text(context.l10n.save),
          ),
        ),
      ],
    );
  }
}
