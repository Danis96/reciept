import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/budgets/ui/widgets/category_budget_manager_sheet.dart';
import 'package:reciep/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:reciep/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/widgets/receipt_paper_card.dart';
import 'package:reciep/app/widgets/category_asset_image.dart';
import 'package:reciep/routing/app_router.dart';
import 'package:reciep/theme/app_spacing.dart';
import 'package:reciep/theme/category_palette.dart';

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

            return SingleChildScrollView(
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
                          onOpenCategory: (String category) =>
                              DashboardActionUtils.onBudgetCategoryPressed(
                                context,
                                category: category,
                              ),
                          onManageBudgets: () => showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: false,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext sheetContext) {
                              return CategoryBudgetManagerSheet(
                                supportedCategories:
                                    controller.supportedBudgetCategories,
                                currentAmounts: <String, double>{
                                  for (final DashboardBudgetProgressModel item
                                      in data.budgetProgress)
                                    item.category: item.budgetAmount,
                                },
                                onSave: (String category, double amount) {
                                  return DashboardActionUtils.onBudgetSaved(
                                    context,
                                    category: category,
                                    amount: amount,
                                  );
                                },
                                onDelete: (String category) {
                                  return DashboardActionUtils.onBudgetDeleted(
                                    context,
                                    category: category,
                                  );
                                },
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
                            final HistoryController historyController = context
                                .read<HistoryController>();
                            final Object? result = await Navigator.of(context)
                                .pushNamed(
                                  AppRouter.receiptDetails,
                                  arguments: ReceiptDetailsRouteArgs(
                                    receiptId: receipt.id,
                                    heroTag: AppRouter.receiptHeroTag(
                                      'home',
                                      receipt.id,
                                    ),
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
    final double topInset = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        topInset + AppSpacing.md,
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
    final ThemeData theme = Theme.of(context);
    final Color dividerColor = const Color(0xFFE7E8EF);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: HomeStatCard(
                    icon: const Icon(
                      Icons.receipt_long_rounded,
                      size: 21,
                      color: Colors.white,
                    ),
                    value: data.totalReceipts.toString(),
                    label: 'SCANS',
                    accent: const Color(0xFF2F6BFF),
                  ),
                ),
                VerticalDivider(width: 1, thickness: 1, color: dividerColor),
                Expanded(
                  child: HomeStatCard(
                    icon: const Icon(
                      Icons.trending_up_rounded,
                      size: 21,
                      color: Colors.white,
                    ),
                    value: data.thisMonthReceipts.toString(),
                    label: 'THIS MONTH',
                    accent: const Color(0xFF9C3CF7),
                  ),
                ),
                VerticalDivider(width: 1, thickness: 1, color: dividerColor),
                Expanded(
                  child: HomeStatCard(
                    icon: CategoryAssetImage(
                      category: data.topCategoryLabel,
                      size: 24,
                    ),
fontValue: 15,
                    value: data.topCategoryLabel,
                    label: 'TOP\nCATEGORY',
                    accent: BudgetCategoryColors.primaryFor(
                      data.topCategoryLabel,
                      context,
                    ),
                    tint: BudgetCategoryColors.primaryFor(
                      data.topCategoryLabel,
                      context,
                    ).withValues(alpha: 0.08),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3040),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    "This Month's Spending",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212330),
                    ),
                  ),
                ),
                Text(
                  '${DashboardMoney.formatDouble(data.thisMonthSpending)} KM',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF161821),
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

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
    this.tint = Colors.transparent,
    this.fontValue = 22,
  });

  final Widget icon;
  final String value;
  final String label;
  final Color accent;
  final Color tint;
  final double fontValue;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      height: 164,
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 14),
      decoration: BoxDecoration(color: tint),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: accent.withValues(alpha: 0.32),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(child: icon),
          ),
          Text(
            value,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: fontValue,
              color: const Color(0xFF12131A),
              height: 1.05,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6E7284),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              height: 1.15,
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
    final theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
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
          child: GestureDetector(
            onTap: () => onUploadReceipt(),
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: const Icon(Icons.ios_share_outlined, size: 18)),
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
            HomeCardEmptyState(
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

class HomeBudgetProgressItem extends StatelessWidget {
  const HomeBudgetProgressItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  final DashboardBudgetProgressModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = BudgetCategoryColors.primaryFor(
      item.category,
      context,
    );
    final String remainingText = item.remainingAmount >= 0
        ? '${DashboardMoney.formatInt(item.remainingAmount)} KM left'
        : '-${DashboardMoney.formatInt(item.remainingAmount.abs())} KM left';
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: categoryColor),
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: BudgetCategoryColors.surfaceFor(
                        item.category,
                        context,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CategoryAssetImage(
                        category: item.category,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    remainingText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              HomeBudgetProgressBar(
                usageRatio: item.usageRatio,
                state: item.state,
                categoryColor: categoryColor,
                trackColor: BudgetCategoryColors.trackFor(
                  item.category,
                  context,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Row(
                children: <Widget>[
                  Text(
                    '${DashboardMoney.formatInt(item.spentAmount)} KM spent',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${DashboardMoney.formatInt(item.budgetAmount)} KM budget',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (item.state == BudgetUsageState.nearLimit)
                Text(
                  'You used ${(item.usageRatio * 100).round()}% of ${item.label} budget',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: categoryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (item.state == BudgetUsageState.exceeded)
                Text(
                  'Budget exceeded by ${DashboardMoney.formatInt(item.remainingAmount.abs())} KM',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: HomeThemePalette.danger(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBudgetProgressBar extends StatelessWidget {
  const HomeBudgetProgressBar({
    super.key,
    required this.usageRatio,
    required this.state,
    required this.categoryColor,
    required this.trackColor,
  });

  final double usageRatio;
  final BudgetUsageState state;
  final Color categoryColor;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final double clamped = usageRatio.clamp(0, 1).toDouble();
    final List<Color> fillColors = state == BudgetUsageState.exceeded
        ? <Color>[categoryColor, HomeThemePalette.danger(context)]
        : <Color>[categoryColor, categoryColor];

    return Container(
      height: 7,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              width: constraints.maxWidth * clamped,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(colors: fillColors),
              ),
            ),
          );
        },
      ),
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
            HomeCardEmptyState(
              imageCategory: 'groceries',
              title: 'No receipts yet',
              message:
                  'Scan first receipt or import one from gallery. Latest receipts will show here.',
            ),
          if (data.recentReceipts.isNotEmpty)
            ReceiptPaperList(
              receipts: data.recentReceipts,
              heroTagBuilder: (ReceiptModel receipt) =>
                  AppRouter.receiptHeroTag('home', receipt.id),
              onOpenReceipt: onOpenReceipt,
            ),
        ],
      ),
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

class BudgetCategoryLabel {
  const BudgetCategoryLabel._();

  static String shortLabel(String category) {
    final String label = CategoryBudgetCatalog.labelFor(category);
    return label == 'Miscellaneous' ? 'Misc' : label;
  }

  static String normalized(String value) {
    return CategoryBudgetCatalog.normalize(value);
  }
}

class HomeCardEmptyState extends StatelessWidget {
  const HomeCardEmptyState({
    super.key,
    required this.imageCategory,
    required this.title,
    required this.message,
  });

  final String imageCategory;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HomeThemePalette.cardBorder(context)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
            ),
            child: CategoryAssetImage(category: imageCategory, size: 40),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  message,
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

class BudgetCategoryColors {
  const BudgetCategoryColors._();

  static Color primaryFor(String category, BuildContext context) {
    return CategoryPalette.primaryFor(category, context);
  }

  static Color surfaceFor(String category, BuildContext context) {
    return CategoryPalette.surfaceFor(category, context);
  }

  static Color trackFor(String category, BuildContext context) {
    return CategoryPalette.trackFor(category, context);
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

  static Color receiptBadgeBackground(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.12 : 0.08);
  }

  static Color categoryGroceries(BuildContext context) {
    return _dark(context) ? const Color(0xFF5FD08A) : const Color(0xFF38A169);
  }

  static Color categoryHousehold(BuildContext context) {
    return _dark(context) ? const Color(0xFFC79A72) : const Color(0xFF8B5E3C);
  }

  static Color categoryPets(BuildContext context) {
    return _dark(context) ? const Color(0xFFFFD96A) : const Color(0xFFE0B321);
  }

  static Color categoryClothing(BuildContext context) {
    return _dark(context) ? const Color(0xFF72AEFF) : const Color(0xFF3A84F7);
  }

  static Color categoryFuel(BuildContext context) {
    return _dark(context) ? const Color(0xFFFF9A73) : const Color(0xFFE76F51);
  }

  static Color categoryMisc(BuildContext context) {
    return _dark(context) ? const Color(0xFFACB4C8) : const Color(0xFF667085);
  }

  static Color statIconBackground(BuildContext context, Color base) {
    return base.withValues(alpha: _dark(context) ? 0.26 : 0.16);
  }

  static Color statIcon(BuildContext context, Color base) {
    return _dark(context) ? base.withValues(alpha: 0.92) : base;
  }

  static Color statValue(BuildContext context, Color base) {
    return _dark(context) ? base.withValues(alpha: 0.94) : base;
  }

  static Color statCardBackground(BuildContext context, Color base) {
    if (_dark(context)) {
      return Color.lerp(Theme.of(context).colorScheme.surface, base, 0.14) ??
          Theme.of(context).colorScheme.surface;
    }
    return base.withValues(alpha: 0.10);
  }

  static Color statCardCornerAccent(BuildContext context, Color base) {
    return base.withValues(alpha: _dark(context) ? 0.30 : 0.16);
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
