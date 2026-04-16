import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_repository.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:reciep/app/models/category_budget_model.dart';
import 'package:reciep/app/models/receipt/receipt_db_mapper.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/database/app_database.dart';

class DashboardRepository {
  DashboardRepository({
    required ReceiptDao receiptDao,
    required CategoryBudgetRepository categoryBudgetRepository,
  }) : _receiptDao = receiptDao,
       _categoryBudgetRepository = categoryBudgetRepository;

  final ReceiptDao _receiptDao;
  final CategoryBudgetRepository _categoryBudgetRepository;

  Future<HomeDashboardModel> loadHomeDashboard() async {
    final DateTime now = DateTime.now();
    final DateTime monthStart = DateTime(now.year, now.month);
    final DateTime monthEnd = DateTime(now.year, now.month + 1);

    final int totalReceipts = await _receiptDao.getReceiptCount();
    final int thisMonthReceipts = await _receiptDao.getReceiptCountBetween(
      fromInclusive: monthStart,
      toExclusive: monthEnd,
    );
    final double thisMonthSpending = await _receiptDao.getTotalSpentBetween(
      fromInclusive: monthStart,
      toExclusive: monthEnd,
    );

    final List<CategoryBudgetModel> budgets = await _categoryBudgetRepository
        .getBudgets();
    final List<DashboardBudgetProgressModel> progress = budgets
        .map(_toBudgetProgress)
        .toList(growable: false);

    final double totalBudget = progress.fold<double>(
      0,
      (double sum, DashboardBudgetProgressModel item) =>
          sum + item.budgetAmount,
    );
    final double remainingBudget = progress.fold<double>(
      0,
      (double sum, DashboardBudgetProgressModel item) =>
          sum + item.remainingAmount,
    );

    final List<ReceiptWithItems> rows = await _receiptDao
        .getRecentReceiptsWithItems(3);
    final List<ReceiptModel> recentReceipts = rows
        .map((ReceiptWithItems row) => row.toReceiptModel())
        .toList(growable: false);

    final String topCategoryLabel = _resolveTopCategory(progress);

    return HomeDashboardModel(
      totalReceipts: totalReceipts,
      thisMonthReceipts: thisMonthReceipts,
      thisMonthSpending: thisMonthSpending,
      totalBudget: totalBudget,
      remainingBudget: remainingBudget,
      topCategoryLabel: topCategoryLabel,
      budgetProgress: progress,
      recentReceipts: recentReceipts,
    );
  }

  DashboardBudgetProgressModel _toBudgetProgress(CategoryBudgetModel budget) {
    final double budgetAmount = budget.budgetAmount;
    final double spentAmount = budget.spentAmount;
    final double remaining = budgetAmount - spentAmount;
    final double ratio = budgetAmount <= 0 ? 0 : (spentAmount / budgetAmount);
    final BudgetUsageState state;
    if (ratio >= 1) {
      state = BudgetUsageState.exceeded;
    } else if (ratio >= 0.8) {
      state = BudgetUsageState.nearLimit;
    } else {
      state = BudgetUsageState.underBudget;
    }

    return DashboardBudgetProgressModel(
      category: budget.category,
      label: CategoryBudgetCatalog.labelFor(budget.category),
      budgetAmount: budgetAmount,
      spentAmount: spentAmount,
      remainingAmount: remaining,
      usageRatio: ratio,
      state: state,
    );
  }

  String _resolveTopCategory(List<DashboardBudgetProgressModel> budgets) {
    if (budgets.isEmpty) {
      return 'No budgets';
    }

    final List<DashboardBudgetProgressModel> sorted =
        List<DashboardBudgetProgressModel>.from(budgets)..sort(
          (DashboardBudgetProgressModel a, DashboardBudgetProgressModel b) =>
              b.spentAmount.compareTo(a.spentAmount),
        );

    if (sorted.first.spentAmount <= 0) {
      return 'No spending';
    }
    return sorted.first.label;
  }
}
