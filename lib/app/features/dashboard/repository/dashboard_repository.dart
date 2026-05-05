import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_repository.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_category_details_model.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_category_item_model.dart';
import 'package:refyn/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:refyn/app/models/category_budget_model.dart';
import 'package:refyn/app/models/receipt/receipt_db_mapper.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/database/app_database.dart';
import 'package:refyn/l10n/app_localizations.dart';

class DashboardRepository {
  DashboardRepository({
    required ReceiptDao receiptDao,
    required CategoryBudgetRepository categoryBudgetRepository,
    required AppSettingsDao settingsDao,
  }) : _receiptDao = receiptDao,
       _categoryBudgetRepository = categoryBudgetRepository,
       _settingsDao = settingsDao;

  final ReceiptDao _receiptDao;
  final CategoryBudgetRepository _categoryBudgetRepository;
  final AppSettingsDao _settingsDao;

  static const String _currencyCodeKey = 'currency_code';
  static const String _defaultCurrency = 'BAM';

  Future<String> _getDefaultCurrency() async {
    final String? value = await _settingsDao.getSetting(_currencyCodeKey);
    return (value != null && value.trim().isNotEmpty) ? value : _defaultCurrency;
  }

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

    final String defaultCurrency = await _getDefaultCurrency();
    final String currency = budgets.isNotEmpty ? budgets.first.currency : defaultCurrency;

    return HomeDashboardModel(
      totalReceipts: totalReceipts,
      thisMonthReceipts: thisMonthReceipts,
      thisMonthSpending: thisMonthSpending,
      totalBudget: totalBudget,
      remainingBudget: remainingBudget,
      currency: currency,
      topCategoryLabel: topCategoryLabel,
      budgetProgress: progress,
      recentReceipts: recentReceipts,
    );
  }

  Future<DashboardCategoryDetailsModel> loadCategoryDetails(
    String category,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime monthStart = DateTime(now.year, now.month);
    final DateTime monthEnd = DateTime(now.year, now.month + 1);
    final String normalizedCategory = CategoryBudgetCatalog.normalize(category);

    final String defaultCurrency = await _getDefaultCurrency();
    final CategoryBudgetModel? budget = await _categoryBudgetRepository
        .getBudgetByCategory(normalizedCategory);
    final DashboardBudgetProgressModel progress = _toBudgetProgress(
      budget ??
          CategoryBudgetModel(
            category: normalizedCategory,
            budgetAmount: 0,
            spentAmount: 0,
            currency: defaultCurrency,
            period: 'monthly',
            updatedAt: now,
          ),
    );

    final List<ReceiptWithItems> receipts = await _receiptDao
        .getReceiptsWithItemsBetween(
          fromInclusive: monthStart,
          toExclusive: monthEnd,
        );
    final List<DashboardCategoryItemModel> items =
        receipts
            .expand(
              (ReceiptWithItems row) => row.items
                  .where(
                    (ReceiptItem item) =>
                        CategoryBudgetCatalog.normalize(item.category) ==
                        normalizedCategory,
                  )
                  .map(
                    (ReceiptItem item) => DashboardCategoryItemModel(
                      name: item.name,
                      merchantName: row.receipt.merchantName,
                      currency: row.receipt.currency,
                      purchasedAt: row.receipt.createdAt,
                      amount: item.finalPrice,
                      quantity: item.quantity,
                      unit: item.unit,
                    ),
                  ),
            )
            .toList(growable: false);

    return DashboardCategoryDetailsModel(
      category: progress.category,
      label: progress.label,
      currency: progress.currency,
      budgetAmount: progress.budgetAmount,
      spentAmount: progress.spentAmount,
      remainingAmount: progress.remainingAmount,
      usageRatio: progress.usageRatio,
      state: progress.state,
      itemCount: items.length,
      items: items,
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
      currency: budget.currency,
      budgetAmount: budgetAmount,
      spentAmount: spentAmount,
      remainingAmount: remaining,
      usageRatio: ratio,
      state: state,
    );
  }

  String _resolveTopCategory(List<DashboardBudgetProgressModel> budgets) {
    if (budgets.isEmpty) {
      return AppLocalizations.current.noBudgetsYet;
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
