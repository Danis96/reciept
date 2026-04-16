import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:reciep/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/routing/app_router.dart';
import 'package:reciep/theme/app_spacing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder:
          (
            BuildContext context,
            DashboardController controller,
            Widget? child,
          ) {
            if (controller.isLoading && controller.homeData == null) {
              return const SafeArea(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.errorMessage != null &&
                controller.homeData == null) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        controller.errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(
                        onPressed: () => controller.refreshHome(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final HomeDashboardModel data =
                controller.homeData ??
                const HomeDashboardModel(
                  totalReceipts: 0,
                  thisMonthReceipts: 0,
                  thisMonthSpending: 0,
                  totalBudget: 0,
                  remainingBudget: 0,
                  topCategoryLabel: 'No spending',
                  budgetProgress: <DashboardBudgetProgressModel>[],
                  recentReceipts: <ReceiptModel>[],
                );

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    HomeSummaryHero(data: data),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          HomeStatsRow(data: data),
                          const SizedBox(height: AppSpacing.md),
                          HomeQuickActionsRow(
                            onScanReceipt: () =>
                                DashboardActionUtils.onScanReceipt(context),
                            onUploadReceipt: () =>
                                DashboardActionUtils.onUploadReceipt(context),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          HomeCategoryBudgetsCard(
                            data: data,
                            onManageBudgets: () => showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (BuildContext sheetContext) {
                                return HomeBudgetManagerSheet(
                                  controller: controller,
                                  data: data,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          HomeRecentReceiptsCard(
                            data: data,
                            onViewAll: () =>
                                DashboardActionUtils.onTabSelected(context, 2),
                            onOpenReceipt: (ReceiptModel receipt) async {
                              final DashboardController dashboardController =
                                  controller;
                              final HistoryController historyController =
                                  context.read<HistoryController>();
                              final Object? result = await Navigator.of(context)
                                  .pushNamed(
                                    AppRouter.receiptDetails,
                                    arguments: ReceiptDetailsRouteArgs(
                                      receiptId: receipt.id,
                                    ),
                                  );
                              if (result == true && context.mounted) {
                                await dashboardController.refreshHome();
                                await historyController.loadHistory();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
    );
  }
}

class HomeSummaryHero extends StatelessWidget {
  const HomeSummaryHero({super.key, required this.data});

  final HomeDashboardModel data;

  @override
  Widget build(BuildContext context) {
    final double safeTotalBudget = data.totalBudget <= 0 ? 1 : data.totalBudget;
    final double ratio = (data.thisMonthSpending / safeTotalBudget).clamp(0, 1);
    final int usedPercent = (ratio * 100).round();
    final String greeting = TimeGreetingLabel.forNow(DateTime.now());

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: HomeThemePalette.heroGradient(context),
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$greeting!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "Here's your spending overview",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _HeroMetric(
                      title: 'This Month',
                      value:
                          '${DashboardMoney.formatInt(data.thisMonthSpending)} KM',
                      alignEnd: false,
                    ),
                    _HeroMetric(
                      title: 'Budget',
                      value: '${DashboardMoney.formatInt(data.totalBudget)} KM',
                      alignEnd: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.26),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HomeThemePalette.success(context),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '$usedPercent% used',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${DashboardMoney.formatInt(data.remainingBudget)} KM left',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HomeThemePalette.success(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.title,
    required this.value,
    required this.alignEnd,
  });

  final String title;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class HomeStatsRow extends StatelessWidget {
  const HomeStatsRow({super.key, required this.data});

  final HomeDashboardModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: HomeStatCard(
            icon: Icons.receipt_long_outlined,
            value: data.totalReceipts.toString(),
            label: 'Receipts',
            iconBackground: HomeThemePalette.statIconBackground(
              context,
              const Color(0xFF4F6BFF),
            ),
            iconColor: HomeThemePalette.statIcon(
              context,
              const Color(0xFF4F6BFF),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: HomeStatCard(
            icon: Icons.show_chart_rounded,
            value: data.thisMonthReceipts.toString(),
            label: 'This Month',
            iconBackground: HomeThemePalette.statIconBackground(
              context,
              const Color(0xFFA555F7),
            ),
            iconColor: HomeThemePalette.statIcon(
              context,
              const Color(0xFFA555F7),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: HomeStatCard(
            icon: Icons.checkroom_outlined,
            value: data.topCategoryLabel,
            label: 'Top',
            iconBackground: HomeThemePalette.statIconBackground(
              context,
              const Color(0xFF4FAF66),
            ),
            iconColor: HomeThemePalette.statIcon(
              context,
              const Color(0xFF4FAF66),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconBackground,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: HomeThemePalette.cardBorder(context)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: iconBackground,
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeQuickActionsRow extends StatelessWidget {
  const HomeQuickActionsRow({
    super.key,
    required this.onScanReceipt,
    required this.onUploadReceipt,
  });

  final Future<void> Function() onScanReceipt;
  final Future<void> Function() onUploadReceipt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => onScanReceipt(),
              icon: const Icon(Icons.photo_camera_outlined, size: 18),
              label: const Text('Scan Receipt'),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          height: 46,
          width: 46,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => onUploadReceipt(),
            child: const Icon(Icons.ios_share_outlined, size: 18),
          ),
        ),
      ],
    );
  }
}

class HomeCategoryBudgetsCard extends StatelessWidget {
  const HomeCategoryBudgetsCard({
    super.key,
    required this.data,
    required this.onManageBudgets,
  });

  final HomeDashboardModel data;
  final VoidCallback onManageBudgets;

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
            Text(
              'No category budgets yet. Tap Manage to add monthly budgets.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          if (data.budgetProgress.isNotEmpty)
            ...data.budgetProgress.map(
              (DashboardBudgetProgressModel budget) => Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: HomeBudgetProgressItem(item: budget),
              ),
            ),
        ],
      ),
    );
  }
}

class HomeBudgetProgressItem extends StatelessWidget {
  const HomeBudgetProgressItem({super.key, required this.item});

  final DashboardBudgetProgressModel item;

  @override
  Widget build(BuildContext context) {
    final Color valueColor = BudgetStateColor.valueColor(item.state, context);
    final String remainingText = item.remainingAmount >= 0
        ? '${DashboardMoney.formatInt(item.remainingAmount)} KM left'
        : '-${DashboardMoney.formatInt(item.remainingAmount.abs())} KM left';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(BudgetCategoryIcon.iconFor(item.category), size: 18),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              remainingText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: item.usageRatio.clamp(0, 1),
            minHeight: 7,
            backgroundColor: HomeThemePalette.progressTrack(context),
            valueColor: AlwaysStoppedAnimation<Color>(
              HomeThemePalette.progressFill(context),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          children: <Widget>[
            Text(
              '${DashboardMoney.formatInt(item.spentAmount)} KM spent',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${DashboardMoney.formatInt(item.budgetAmount)} KM budget',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (item.state == BudgetUsageState.nearLimit)
          Text(
            'You used ${(item.usageRatio * 100).round()}% of ${item.label} budget',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: HomeThemePalette.warning(context),
              fontWeight: FontWeight.w700,
            ),
          ),
        if (item.state == BudgetUsageState.exceeded)
          Text(
            'Budget exceeded by ${DashboardMoney.formatInt(item.remainingAmount.abs())} KM',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: HomeThemePalette.danger(context),
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class HomeRecentReceiptsCard extends StatelessWidget {
  const HomeRecentReceiptsCard({
    super.key,
    required this.data,
    required this.onViewAll,
    required this.onOpenReceipt,
  });

  final HomeDashboardModel data;
  final Future<void> Function() onViewAll;
  final Future<void> Function(ReceiptModel receipt) onOpenReceipt;

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
                'Recent Receipts',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onViewAll(),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (data.recentReceipts.isEmpty)
            Text(
              'No receipts saved yet.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          if (data.recentReceipts.isNotEmpty)
            ...data.recentReceipts.map(
              (ReceiptModel receipt) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: HomeReceiptListItem(
                  receipt: receipt,
                  onTap: () => onOpenReceipt(receipt),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HomeReceiptListItem extends StatelessWidget {
  const HomeReceiptListItem({
    super.key,
    required this.receipt,
    required this.onTap,
  });

  final ReceiptModel receipt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: HomeThemePalette.cardBorder(context)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HomeThemePalette.chipSurface(context),
              ),
              child: Icon(
                BudgetCategoryIcon.iconFor(receipt.category),
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    receipt.merchant.name.isEmpty
                        ? 'Store'
                        : receipt.merchant.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${BudgetCategoryLabel.shortLabel(receipt.category)} · ${receipt.items.length} items',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${DashboardMoney.formatDouble(receipt.totals.total)} KM',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  DateFormat('MMM d').format(receipt.createdAt),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBudgetManagerSheet extends StatefulWidget {
  const HomeBudgetManagerSheet({
    super.key,
    required this.controller,
    required this.data,
  });

  final DashboardController controller;
  final HomeDashboardModel data;

  @override
  State<HomeBudgetManagerSheet> createState() => _HomeBudgetManagerSheetState();
}

class _HomeBudgetManagerSheetState extends State<HomeBudgetManagerSheet> {
  late final Map<String, TextEditingController> _controllers;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final Map<String, String> existing = <String, String>{
      for (final item in widget.data.budgetProgress)
        item.category: DashboardMoney.formatInt(item.budgetAmount),
    };

    _controllers = <String, TextEditingController>{
      for (final String category in widget.controller.supportedBudgetCategories)
        category: TextEditingController(text: existing[category] ?? ''),
    };
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Manage Category Budgets',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              IconButton(
                onPressed: _saving ? null : () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ...widget.controller.supportedBudgetCategories.map(
            (String category) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: HomeBudgetManagerRow(
                category: category,
                controller: _controllers[category]!,
                busy: _saving,
                onSave: () => _onSave(category),
                onDelete: () => _onDelete(category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave(String category) async {
    final String text = _controllers[category]!.text.trim();
    final double? parsed = double.tryParse(text);
    if (parsed == null || parsed < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid budget amount.')),
      );
      return;
    }

    setState(() {
      _saving = true;
    });
    await widget.controller.upsertBudget(category: category, amount: parsed);
    setState(() {
      _saving = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${BudgetCategoryLabel.shortLabel(category)} budget saved.',
          ),
        ),
      );
    }
  }

  Future<void> _onDelete(String category) async {
    setState(() {
      _saving = true;
    });
    await widget.controller.deleteBudget(category);
    _controllers[category]!.text = '';
    setState(() {
      _saving = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${BudgetCategoryLabel.shortLabel(category)} budget deleted.',
          ),
        ),
      );
    }
  }
}

class HomeBudgetManagerRow extends StatelessWidget {
  const HomeBudgetManagerRow({
    super.key,
    required this.category,
    required this.controller,
    required this.busy,
    required this.onSave,
    required this.onDelete,
  });

  final String category;
  final TextEditingController controller;
  final bool busy;
  final Future<void> Function() onSave;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
          child: Text(
            BudgetCategoryLabel.shortLabel(category),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              hintText: 'Budget KM',
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        IconButton(
          onPressed: busy ? null : () => onSave(),
          icon: const Icon(Icons.save_outlined),
        ),
        IconButton(
          onPressed: busy ? null : () => onDelete(),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}

class DashboardMoney {
  const DashboardMoney._();

  static String formatInt(double value) {
    return NumberFormat('0').format(value);
  }

  static String formatDouble(double value) {
    return NumberFormat('0.00').format(value);
  }
}

class TimeGreetingLabel {
  const TimeGreetingLabel._();

  static String forNow(DateTime now) {
    if (now.hour < 12) {
      return 'Good Morning';
    }
    if (now.hour < 18) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}

class BudgetCategoryIcon {
  const BudgetCategoryIcon._();

  static IconData iconFor(String category) {
    switch (BudgetCategoryLabel.normalized(category)) {
      case 'groceries':
        return Icons.shopping_cart_outlined;
      case 'pets':
        return Icons.pets_outlined;
      case 'fuel':
        return Icons.local_gas_station_outlined;
      case 'household':
        return Icons.home_outlined;
      case 'clothing':
        return Icons.checkroom_outlined;
      case 'miscellaneous':
        return Icons.category_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}

class BudgetCategoryLabel {
  const BudgetCategoryLabel._();

  static String shortLabel(String category) {
    switch (normalized(category)) {
      case 'groceries':
        return 'Groceries';
      case 'fuel':
        return 'Fuel';
      case 'household':
        return 'Household';
      case 'pets':
        return 'Pets';
      case 'clothing':
        return 'Clothing';
      case 'miscellaneous':
        return 'Misc';
      default:
        return 'Misc';
    }
  }

  static String normalized(String value) {
    final String key = value.trim().toLowerCase();
    if (key.contains('groc') || key.contains('food')) {
      return 'groceries';
    }
    if (key.contains('fuel') || key.contains('gas') || key.contains('car')) {
      return 'fuel';
    }
    if (key.contains('house') || key.contains('home')) {
      return 'household';
    }
    if (key.contains('pet') || key.contains('dog') || key.contains('cat')) {
      return 'pets';
    }
    if (key.contains('cloth')) {
      return 'clothing';
    }
    return 'miscellaneous';
  }
}

class BudgetStateColor {
  const BudgetStateColor._();

  static Color valueColor(BudgetUsageState state, BuildContext context) {
    switch (state) {
      case BudgetUsageState.underBudget:
        return HomeThemePalette.success(context);
      case BudgetUsageState.nearLimit:
        return HomeThemePalette.warning(context);
      case BudgetUsageState.exceeded:
        return HomeThemePalette.danger(context);
    }
  }
}

class HomeThemePalette {
  const HomeThemePalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static List<Color> heroGradient(BuildContext context) {
    if (_dark(context)) {
      return const <Color>[Color(0xFF12172B), Color(0xFF222B48)];
    }
    return const <Color>[Color(0xFF171727), Color(0xFF2A2A43)];
  }

  static Color cardBorder(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.18 : 0.08);
  }

  static Color progressTrack(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.24 : 0.16);
  }

  static Color progressFill(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.88 : 0.92);
  }

  static Color chipSurface(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.16 : 0.06);
  }

  static Color statIconBackground(BuildContext context, Color base) {
    return base.withValues(alpha: _dark(context) ? 0.28 : 0.14);
  }

  static Color statIcon(BuildContext context, Color base) {
    return _dark(context) ? base.withValues(alpha: 0.92) : base;
  }

  static Color success(BuildContext context) {
    return _dark(context) ? const Color(0xFF62D483) : const Color(0xFF4FAF66);
  }

  static Color warning(BuildContext context) {
    return _dark(context) ? const Color(0xFFE1BA63) : const Color(0xFFC6972A);
  }

  static Color danger(BuildContext context) {
    return _dark(context) ? const Color(0xFFFF8B87) : const Color(0xFFE0574E);
  }
}
