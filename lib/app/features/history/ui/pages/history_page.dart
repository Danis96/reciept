import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/features/history/action_utils/history_action_utils.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/routing/app_router.dart';
import 'package:reciep/theme/app_spacing.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryController>(
      builder:
          (BuildContext context, HistoryController controller, Widget? child) {
            final List<ReceiptModel> receipts = controller.receipts;
            final ThemeData theme = Theme.of(context);

            return SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Receipt History',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            '${controller.totalReceiptCount} total receipts',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          HistorySearchBar(
                            initialValue: controller.searchQuery,
                            onChanged: (String query) =>
                                HistoryActionUtils.onSearchChanged(
                                  context,
                                  query,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          HistoryCategoryChips(controller: controller),
                          const SizedBox(height: AppSpacing.sm),
                          HistorySortFilterRow(controller: controller),
                          const SizedBox(height: AppSpacing.md),
                          if (controller.isLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (!controller.isLoading && receipts.isEmpty)
                            const HistoryEmptyState(),
                          if (!controller.isLoading && receipts.isNotEmpty)
                            HistoryReceiptsList(
                              receipts: receipts,
                              controller: controller,
                              onOpenDetails: (ReceiptModel receipt) async {
                                final HistoryController historyController =
                                    controller;
                                final DashboardController dashboardController =
                                    context.read<DashboardController>();
                                final Object? result =
                                    await Navigator.of(context).pushNamed(
                                      AppRouter.receiptDetails,
                                      arguments: ReceiptDetailsRouteArgs(
                                        receiptId: receipt.id,
                                      ),
                                    );
                                if (result == true && context.mounted) {
                                  await historyController.loadHistory();
                                  await dashboardController.refreshHome();
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}

class HistorySearchBar extends StatefulWidget {
  const HistorySearchBar({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<HistorySearchBar> createState() => _HistorySearchBarState();
}

class _HistorySearchBarState extends State<HistorySearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant HistorySearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: HistoryThemePalette.inputBackground(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: 'Search by merchant or category...',
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.secondary.withValues(alpha: 0.78),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}

class HistoryCategoryChips extends StatelessWidget {
  const HistoryCategoryChips({super.key, required this.controller});

  final HistoryController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.categoryFilters
            .map(
              (String category) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: HistoryCategoryChip(
                  category: category,
                  selected: controller.selectedCategory == category,
                  onTap: () =>
                      HistoryActionUtils.onCategorySelected(context, category),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? HistoryThemePalette.selectedChipBackground(context)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HistoryThemePalette.border(context)),
        ),
        child: Text(
          HistoryCategoryLabel.labelForChip(category),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected
                ? HistoryThemePalette.selectedChipText(context)
                : Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.9),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class HistorySortFilterRow extends StatelessWidget {
  const HistorySortFilterRow({super.key, required this.controller});

  final HistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 36,
          height: 36,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final DateTime now = DateTime.now();
              final DateTimeRange? range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(now.year + 1),
                initialDateRange: controller.dateRange,
              );
              if (!context.mounted) {
                return;
              }
              HistoryActionUtils.onDateRangeChanged(context, range);
            },
            icon: Icon(
              controller.dateRange == null
                  ? Icons.tune
                  : Icons.date_range_outlined,
              size: 19,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        HistorySortDropdown(controller: controller),
      ],
    );
  }
}

class HistorySortDropdown extends StatelessWidget {
  const HistorySortDropdown({super.key, required this.controller});

  final HistoryController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HistorySortOption>(
      onSelected: (HistorySortOption value) =>
          HistoryActionUtils.onSortSelected(context, value),
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<HistorySortOption>>[
            PopupMenuItem<HistorySortOption>(
              value: HistorySortOption.newest,
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('Newest')),
                  if (controller.sortOption == HistorySortOption.newest)
                    const Icon(Icons.check, size: 16),
                ],
              ),
            ),
            PopupMenuItem<HistorySortOption>(
              value: HistorySortOption.oldest,
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('Oldest')),
                  if (controller.sortOption == HistorySortOption.oldest)
                    const Icon(Icons.check, size: 16),
                ],
              ),
            ),
            PopupMenuItem<HistorySortOption>(
              value: HistorySortOption.highestAmount,
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('Highest amount')),
                  if (controller.sortOption == HistorySortOption.highestAmount)
                    const Icon(Icons.check, size: 16),
                ],
              ),
            ),
            PopupMenuItem<HistorySortOption>(
              value: HistorySortOption.lowestAmount,
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('Lowest amount')),
                  if (controller.sortOption == HistorySortOption.lowestAmount)
                    const Icon(Icons.check, size: 16),
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
              HistorySortLabel.labelFor(controller.sortOption),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    );
  }
}

class HistoryReceiptsList extends StatelessWidget {
  const HistoryReceiptsList({
    super.key,
    required this.receipts,
    required this.controller,
    required this.onOpenDetails,
  });

  final List<ReceiptModel> receipts;
  final HistoryController controller;
  final Future<void> Function(ReceiptModel receipt) onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: receipts
          .map(
            (ReceiptModel receipt) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: HistoryReceiptCard(
                receipt: receipt,
                budgetState: controller.budgetStateForCategory(
                  receipt.category,
                ),
                onTap: () => onOpenDetails(receipt),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class HistoryReceiptCard extends StatelessWidget {
  const HistoryReceiptCard({
    super.key,
    required this.receipt,
    required this.budgetState,
    required this.onTap,
  });

  final ReceiptModel receipt;
  final BudgetUsageState? budgetState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: HistoryThemePalette.border(context)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HistoryReceiptThumbnail(receipt: receipt),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          receipt.merchant.name.isEmpty
                              ? 'Unknown merchant'
                              : receipt.merchant.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${receipt.totals.total.toStringAsFixed(2)} KM',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            DateFormat('M/d/yyyy').format(receipt.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Row(
                    children: <Widget>[
                      HistoryCategoryBadge(category: receipt.category),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${receipt.items.length} items',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  HistoryConfidenceChip(
                    confidence: receipt.confidence,
                    budgetState: budgetState,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryReceiptThumbnail extends StatelessWidget {
  const HistoryReceiptThumbnail({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    final String? path = receipt.imagePath;
    final bool hasPath = path != null && path.trim().isNotEmpty;
    final String safePath = path ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 42,
        width: 42,
        color: HistoryThemePalette.thumbnailBackground(context),
        child: hasPath
            ? Image.file(
                File(safePath),
                fit: BoxFit.cover,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Icon(
                        HistoryCategoryLabel.iconFor(receipt.category),
                        color: HistoryThemePalette.thumbnailIcon(context),
                        size: 20,
                      );
                    },
              )
            : Icon(
                HistoryCategoryLabel.iconFor(receipt.category),
                color: HistoryThemePalette.thumbnailIcon(context),
                size: 20,
              ),
      ),
    );
  }
}

class HistoryCategoryBadge extends StatelessWidget {
  const HistoryCategoryBadge({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: HistoryThemePalette.inputBackground(context),
      ),
      child: Text(
        HistoryCategoryLabel.labelForBadge(category),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class HistoryConfidenceChip extends StatelessWidget {
  const HistoryConfidenceChip({
    super.key,
    required this.confidence,
    required this.budgetState,
  });

  final double confidence;
  final BudgetUsageState? budgetState;

  @override
  Widget build(BuildContext context) {
    final int percent = confidence <= 1
        ? (confidence * 100).round().clamp(0, 100)
        : confidence.round().clamp(0, 100);

    final bool green =
        percent >= 96 || budgetState == BudgetUsageState.underBudget;
    final Color textColor = green
        ? HistoryThemePalette.successText(context)
        : HistoryThemePalette.warningText(context);
    final Color bgColor = green
        ? HistoryThemePalette.successBg(context)
        : HistoryThemePalette.warningBg(context);
    final Color borderColor = green
        ? HistoryThemePalette.successBorder(context)
        : HistoryThemePalette.warningBorder(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        '$percent% confidence',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: HistoryThemePalette.border(context)),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.receipt_long_outlined,
            size: 46,
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.75),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No receipts found',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try another search, category, or date range.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryCategoryLabel {
  const HistoryCategoryLabel._();

  static String labelForChip(String key) {
    switch (key) {
      case 'all':
        return 'All';
      case CategoryBudgetCatalog.groceries:
        return 'Groceries';
      case CategoryBudgetCatalog.fuel:
        return 'Fuel';
      case CategoryBudgetCatalog.household:
        return 'Household';
      case CategoryBudgetCatalog.pets:
        return 'Pets';
      case CategoryBudgetCatalog.clothing:
        return 'Clothing';
      case CategoryBudgetCatalog.miscellaneous:
        return 'Misc';
    }
    return 'All';
  }

  static String labelForBadge(String category) {
    final String normalized = CategoryBudgetCatalog.normalize(category);
    switch (normalized) {
      case CategoryBudgetCatalog.groceries:
        return 'Groceries';
      case CategoryBudgetCatalog.fuel:
        return 'Fuel';
      case CategoryBudgetCatalog.household:
        return 'Household';
      case CategoryBudgetCatalog.pets:
        return 'Pets';
      case CategoryBudgetCatalog.clothing:
        return 'Clothing';
      case CategoryBudgetCatalog.miscellaneous:
        return 'Misc';
    }
    return 'Misc';
  }

  static IconData iconFor(String category) {
    switch (CategoryBudgetCatalog.normalize(category)) {
      case CategoryBudgetCatalog.groceries:
        return Icons.shopping_basket_outlined;
      case CategoryBudgetCatalog.fuel:
        return Icons.local_gas_station_outlined;
      case CategoryBudgetCatalog.household:
        return Icons.home_outlined;
      case CategoryBudgetCatalog.pets:
        return Icons.pets_outlined;
      case CategoryBudgetCatalog.clothing:
        return Icons.checkroom_outlined;
      case CategoryBudgetCatalog.miscellaneous:
        return Icons.category_outlined;
    }
    return Icons.category_outlined;
  }
}

class HistorySortLabel {
  const HistorySortLabel._();

  static String labelFor(HistorySortOption option) {
    switch (option) {
      case HistorySortOption.newest:
        return 'Sort by Date';
      case HistorySortOption.oldest:
        return 'Oldest First';
      case HistorySortOption.highestAmount:
        return 'Highest Amount';
      case HistorySortOption.lowestAmount:
        return 'Lowest Amount';
    }
  }
}

class HistoryThemePalette {
  const HistoryThemePalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color border(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.18 : 0.08);
  }

  static Color inputBackground(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.14 : 0.06);
  }

  static Color selectedChipBackground(BuildContext context) {
    return _dark(context)
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.35)
        : const Color(0xFF0C0C1F);
  }

  static Color selectedChipText(BuildContext context) {
    return _dark(context)
        ? Theme.of(context).colorScheme.onPrimary
        : Colors.white;
  }

  static Color thumbnailBackground(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.18 : 0.08);
  }

  static Color thumbnailIcon(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.75 : 0.56);
  }

  static Color successText(BuildContext context) {
    return _dark(context) ? const Color(0xFF87E4A0) : const Color(0xFF3AA85B);
  }

  static Color successBg(BuildContext context) {
    return _dark(context) ? const Color(0xFF1E3A29) : const Color(0xFFEAF9EE);
  }

  static Color successBorder(BuildContext context) {
    return _dark(context) ? const Color(0xFF2F6A45) : const Color(0xFF86D79A);
  }

  static Color warningText(BuildContext context) {
    return _dark(context) ? const Color(0xFFFFD287) : const Color(0xFFCA8D19);
  }

  static Color warningBg(BuildContext context) {
    return _dark(context) ? const Color(0xFF43351F) : const Color(0xFFFFF5DF);
  }

  static Color warningBorder(BuildContext context) {
    return _dark(context) ? const Color(0xFF7A6033) : const Color(0xFFE2BB67);
  }
}
