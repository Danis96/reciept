import 'package:flutter/material.dart';
import 'package:wiggly_loaders/wiggly_loaders.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:refyn/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:refyn/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:refyn/app/features/dashboard/ui/widgets/home_recent_receipts_card.dart';
import 'package:refyn/app/features/dashboard/ui/widgets/home_summary_hero.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/theme/app_spacing.dart';

import '../widgets/home_category_budget_cards.dart';
import '../widgets/home_quick_actions_rows.dart';

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
                child: Center(child: WigglyLoader.indeterminate()),
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
                        onPressed: controller.refreshHome,
                        child: Text(context.l10n.retryHome),
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
                  currency: 'BAM',
                  topCategoryLabel: 'No spending',
                  budgetProgress: <DashboardBudgetProgressModel>[],
                  recentReceipts: <ReceiptModel>[],
                );

            return WigglyRefreshIndicator(
              onRefresh: controller.refreshHome,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                            onManageBudgets: () =>
                                DashboardActionUtils.onManageBudgets(
                                  context,
                                  budgetProgress: data.budgetProgress,
                                  supportedCategories:
                                      controller.supportedBudgetCategories,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          HomeRecentReceiptsCard(
                            data: data,
                            onViewAll: () =>
                                DashboardActionUtils.onTabSelected(context, 2),
                            onOpenReceipt: (ReceiptModel receipt) =>
                                DashboardActionUtils.onOpenReceipt(
                                  context,
                                  receipt,
                                ),
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
