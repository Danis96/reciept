import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:reciep/app/features/history/action_utils/history_action_utils.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/widgets/category_asset_image.dart';
import 'package:reciep/app/widgets/receipt_paper_card.dart';
import 'package:reciep/routing/app_router.dart';
import 'package:reciep/theme/app_spacing.dart';
import 'package:reciep/theme/category_palette.dart';

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
                            HistoryEmptyState(
                              selectedCategory: controller.selectedCategory,
                            ),
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
                                        heroTag: AppRouter.receiptHeroTag(
                                          'history',
                                          receipt.id,
                                        ),
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
    final ThemeData theme = Theme.of(context);
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
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.secondary.withValues(alpha: 0.78),
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
    final ThemeData theme = Theme.of(context);
    final bool isAll = category == 'all';
    final Color categoryColor = isAll
        ? theme.colorScheme.primary
        : CategoryPalette.primaryFor(category, context);
    final Color activeColor = isAll
        ? HistoryThemePalette.selectedChipBackground(context)
        : categoryColor;
    final Color idleColor = isAll
        ? theme.colorScheme.surface
        : categoryColor.withValues(alpha: 0.18);

    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isAll
                ? HistoryThemePalette.border(context)
                : categoryColor.withValues(alpha: selected ? 0.12 : 0.42),
          ),
          boxShadow: <BoxShadow>[
            if (!selected)
              BoxShadow(
                color: categoryColor.withValues(alpha: 0.08),
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
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: activeColor),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
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
                                ? Colors.white.withValues(alpha: 0.22)
                                : Colors.white.withValues(alpha: 0.72),
                          ),
                          child: CategoryAssetImage(
                            category: category,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        HistoryCategoryLabel.labelForChip(category),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: selected
                              ? isAll
                                    ? HistoryThemePalette.selectedChipText(
                                        context,
                                      )
                                    : CategoryPalette.onPrimaryFor(
                                        category,
                                        context,
                                      )
                              : isAll
                              ? theme.colorScheme.secondary.withValues(alpha: 0.9)
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
    return ReceiptPaperList(
      receipts: receipts,
      heroTagBuilder: (ReceiptModel receipt) =>
          AppRouter.receiptHeroTag('history', receipt.id),
      enableEntranceAnimation: true,
      onOpenReceipt: onOpenDetails,
    );
  }
}

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key, required this.selectedCategory});

  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    final String category = selectedCategory == 'all'
        ? CategoryBudgetCatalog.household
        : selectedCategory;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: CategoryPalette.surfaceFor(category, context)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
            ),
            child: CategoryAssetImage(category: category, size: 52),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'No receipts found',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  selectedCategory == 'all'
                      ? 'Try a different merchant, category, or date range. Your saved receipts will appear here.'
                      : 'No ${HistoryCategoryLabel.labelForBadge(selectedCategory).toLowerCase()} receipts match the current search or date range.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
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
      case CategoryBudgetCatalog.pharmacy:
        return 'Pharmacy';
      case CategoryBudgetCatalog.dental:
        return 'Dental';
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
      case CategoryBudgetCatalog.pharmacy:
        return 'Pharmacy';
      case CategoryBudgetCatalog.dental:
        return 'Dental';
      case CategoryBudgetCatalog.miscellaneous:
        return 'Misc';
    }
    return 'Misc';
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
