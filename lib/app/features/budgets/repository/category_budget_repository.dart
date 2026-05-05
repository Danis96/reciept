import 'package:drift/drift.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/shared/utils/app_currency_utils.dart';
import 'package:refyn/app/models/category_budget_model.dart';
import 'package:refyn/database/app_database.dart';

class CategoryBudgetRepository {
  CategoryBudgetRepository({
    required CategoryBudgetDao dao,
    required AppSettingsDao settingsDao,
  }) : _dao = dao,
       _settingsDao = settingsDao;

  final CategoryBudgetDao _dao;
  final AppSettingsDao _settingsDao;

  static const String _currencyCodeKey = 'currency_code';
  Future<String> getDefaultCurrency() async {
    final String? value = await _settingsDao.getSetting(_currencyCodeKey);
    return AppCurrencyUtils.normalizeCode(value);
  }

  Future<int> upsertBudget({
    required String category,
    required double budgetAmount,
    required double spentAmount,
    String? currency,
    String period = 'monthly',
  }) async {
    final String resolvedCurrency = currency ?? await getDefaultCurrency();
    final String normalizedCategory = CategoryBudgetCatalog.normalize(category);
    return _dao.upsertBudget(
      CategoryBudgetsCompanion.insert(
        category: normalizedCategory,
        budgetAmount: Value(budgetAmount),
        spentAmount: Value(spentAmount),
        currency: Value(resolvedCurrency),
        period: Value(period),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateAllCurrencies(String currency) {
    return _dao.updateAllCurrencies(AppCurrencyUtils.normalizeCode(currency));
  }

  Future<List<CategoryBudgetModel>> getBudgets() async {
    final List<CategoryBudget> budgets = await _dao.getAllBudgets();
    return budgets.map(_mapBudget).toList();
  }

  Future<CategoryBudgetModel?> getBudgetByCategory(String category) async {
    final String normalizedCategory = CategoryBudgetCatalog.normalize(category);
    final CategoryBudget? budget = await _dao.getBudgetByCategory(
      normalizedCategory,
    );
    return budget == null ? null : _mapBudget(budget);
  }

  Future<void> updateSpentAmount({
    required String category,
    required double spentAmount,
  }) {
    final String normalizedCategory = CategoryBudgetCatalog.normalize(category);
    return _dao.updateSpentAmount(
      category: normalizedCategory,
      spentAmount: spentAmount,
    );
  }

  Future<int> deleteBudget(String category) {
    final String normalizedCategory = CategoryBudgetCatalog.normalize(category);
    return _dao.deleteBudget(normalizedCategory);
  }

  CategoryBudgetModel _mapBudget(CategoryBudget budget) {
    return CategoryBudgetModel(
      category: budget.category,
      budgetAmount: budget.budgetAmount,
      spentAmount: budget.spentAmount,
      currency: budget.currency,
      period: budget.period,
      updatedAt: budget.updatedAt,
    );
  }
}
