import 'package:drift/drift.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/models/category_budget_model.dart';
import 'package:reciep/database/app_database.dart';

class CategoryBudgetRepository {
  CategoryBudgetRepository({required CategoryBudgetDao dao}) : _dao = dao;

  final CategoryBudgetDao _dao;

  Future<int> upsertBudget({
    required String category,
    required double budgetAmount,
    required double spentAmount,
    String currency = 'BAM',
    String period = 'monthly',
  }) {
    final String normalizedCategory = CategoryBudgetCatalog.normalize(category);
    return _dao.upsertBudget(
      CategoryBudgetsCompanion.insert(
        category: normalizedCategory,
        budgetAmount: Value(budgetAmount),
        spentAmount: Value(spentAmount),
        currency: Value(currency),
        period: Value(period),
        updatedAt: Value(DateTime.now()),
      ),
    );
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
