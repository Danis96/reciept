import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_repository.dart';
import 'package:refyn/app/models/category_budget_model.dart';
import 'package:refyn/database/app_database.dart';

class MonthlyBudgetSyncRepository {
  MonthlyBudgetSyncRepository({
    required ReceiptDao receiptDao,
    required CategoryBudgetRepository categoryBudgetRepository,
  }) : _receiptDao = receiptDao,
       _categoryBudgetRepository = categoryBudgetRepository;

  final ReceiptDao _receiptDao;
  final CategoryBudgetRepository _categoryBudgetRepository;

  Future<void> syncCurrentMonth({DateTime? now}) async {
    final DateTime current = now ?? DateTime.now();
    final DateTime monthStart = DateTime(current.year, current.month);
    final DateTime monthEnd = DateTime(current.year, current.month + 1);

    final Map<String, double> rawSpent = await _receiptDao
        .getCategorySpendBetween(
          fromInclusive: monthStart,
          toExclusive: monthEnd,
        );
    final Map<String, double> normalized = <String, double>{};

    for (final MapEntry<String, double> entry in rawSpent.entries) {
      final String category = CategoryBudgetCatalog.normalize(entry.key);
      final double previous = normalized[category] ?? 0;
      normalized[category] = previous + entry.value;
    }

    final List<CategoryBudgetModel> budgets = await _categoryBudgetRepository
        .getBudgets();
    for (final CategoryBudgetModel budget in budgets) {
      await _categoryBudgetRepository.updateSpentAmount(
        category: budget.category,
        spentAmount: normalized[budget.category] ?? 0,
      );
    }
  }
}
