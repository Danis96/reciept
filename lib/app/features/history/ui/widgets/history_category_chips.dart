import 'package:flutter/material.dart';
import 'package:refyn/app/features/history/ui/utils/history_ui_utils.dart';
import 'package:refyn/app/widgets/category_asset_image.dart';
import 'package:refyn/theme/app_spacing.dart';
import 'package:refyn/theme/category_palette.dart';

class HistoryCategoryChips extends StatelessWidget {
  const HistoryCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (String category) => Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: HistoryCategoryChip(
              category: category,
              selected: selectedCategory == category,
              onTap: () => onCategorySelected(category),
            ),
          ),
        )
            .toList(growable: false),
      ),
    );
  }
}

class HistoryCategoryChip extends StatelessWidget {
  const HistoryCategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final String category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isAll = category == 'all';
    final Color categoryColor =
    isAll ? theme.colorScheme.primary : CategoryPalette.primaryFor(category, context);
    final Color activeColor =
    isAll ? HistoryThemePalette.selectedChipBackground(context) : categoryColor;
    final Color idleColor =
    isAll ? theme.colorScheme.surface : categoryColor.withValues(alpha:0.18);

    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isAll
                ? HistoryThemePalette.border(context)
                : categoryColor.withValues(alpha:selected ? 0.12 : 0.42),
          ),
          boxShadow: <BoxShadow>[
            if (!selected)
              BoxShadow(
                color: categoryColor.withValues(alpha:0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.8),
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  left: selected ? 0 : 18,
                  right: selected ? 0 : -18,
                  top: 0,
                  bottom: 0,
                  child: DecoratedBox(decoration: BoxDecoration(color: activeColor)),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  color: selected ? Colors.transparent : idleColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!isAll) ...<Widget>[
                        Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? Colors.white.withValues(alpha:0.22)
                                : Colors.white.withValues(alpha:0.72),
                          ),
                          child: CategoryAssetImage(category: category, size: 16),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        HistoryCategoryLabel.labelForChip(category),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: selected
                              ? isAll
                              ? HistoryThemePalette.selectedChipText(context)
                              : CategoryPalette.onPrimaryFor(category, context)
                              : isAll
                              ? theme.colorScheme.secondary.withValues(alpha:0.9)
                              : categoryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
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
