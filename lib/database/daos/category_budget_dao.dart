part of '../app_database.dart';

@DriftAccessor(tables: [CategoryBudgets])
class CategoryBudgetDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryBudgetDaoMixin {
  CategoryBudgetDao(super.attachedDatabase);

  Future<int> upsertBudget(CategoryBudgetsCompanion budget) async {
    final String category = budget.category.value;
    final CategoryBudget? existing = await (select(
      categoryBudgets,
    )..where((tbl) => tbl.category.equals(category))).getSingleOrNull();

    if (existing == null) {
      return into(categoryBudgets).insert(budget);
    }

    await (update(categoryBudgets)..where((tbl) => tbl.id.equals(existing.id)))
        .write(budget.copyWith(updatedAt: Value(DateTime.now())));

    return existing.id;
  }

  Future<List<CategoryBudget>> getAllBudgets() {
    return (select(
      categoryBudgets,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.category)])).get();
  }

  Future<CategoryBudget?> getBudgetByCategory(String category) {
    return (select(
      categoryBudgets,
    )..where((tbl) => tbl.category.equals(category))).getSingleOrNull();
  }

  Future<void> updateSpentAmount({
    required String category,
    required double spentAmount,
  }) async {
    final CategoryBudget? budget = await getBudgetByCategory(category);
    if (budget == null) {
      return;
    }

    await (update(
      categoryBudgets,
    )..where((tbl) => tbl.id.equals(budget.id))).write(
      CategoryBudgetsCompanion(
        spentAmount: Value(spentAmount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteBudget(String category) {
    return (delete(
      categoryBudgets,
    )..where((tbl) => tbl.category.equals(category))).go();
  }
}
