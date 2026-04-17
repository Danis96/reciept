import 'package:flutter/material.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';
import 'package:reciep/app/features/history/ui/utils/history_ui_utils.dart';
import 'package:reciep/theme/app_spacing.dart';

class HistorySortFilterRow extends StatelessWidget {
  const HistorySortFilterRow({
    super.key,
    required this.sortOption,
    required this.hasDateFilter,
    required this.onSortSelected,
    required this.onDateFilterTapped,
  });

  final HistorySortOption sortOption;
  final bool hasDateFilter;
  final ValueChanged<HistorySortOption> onSortSelected;
  final VoidCallback onDateFilterTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 36,
          height: 36,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onDateFilterTapped,
            icon: Icon(
              hasDateFilter ? Icons.date_range_outlined : Icons.tune,
              size: 19,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        HistorySortDropdown(
          sortOption: sortOption,
          onSelected: onSortSelected,
        ),
      ],
    );
  }
}

class HistorySortDropdown extends StatelessWidget {
  const HistorySortDropdown({
    super.key,
    required this.sortOption,
    required this.onSelected,
  });

  final HistorySortOption sortOption;
  final ValueChanged<HistorySortOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HistorySortOption>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => [
        for (final option in HistorySortOption.values)
          PopupMenuItem<HistorySortOption>(
            value: option,
            child: Row(
              children: <Widget>[
                Expanded(child: Text(HistorySortLabel.labelFor(option))),
                if (sortOption == option) const Icon(Icons.check, size: 16),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: HistoryThemePalette.inputBackground(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              HistorySortLabel.labelFor(sortOption),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    );
  }
}
