import 'package:refyn/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_repository.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:refyn/app/models/category_budget_model.dart';
import 'package:refyn/app/models/receipt/receipt_db_mapper.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/app/models/receipt/receipt_validator.dart';
import 'package:refyn/database/app_database.dart';

class HistoryRepository {
  HistoryRepository({
    required ReceiptDao dao,
    required MonthlyBudgetSyncRepository monthlyBudgetSyncRepository,
    required CategoryBudgetRepository categoryBudgetRepository,
  }) : _dao = dao,
       _monthlyBudgetSyncRepository = monthlyBudgetSyncRepository,
       _categoryBudgetRepository = categoryBudgetRepository;

  final ReceiptDao _dao;
  final MonthlyBudgetSyncRepository _monthlyBudgetSyncRepository;
  final CategoryBudgetRepository _categoryBudgetRepository;

  Future<void> saveReceipt(ReceiptModel receipt) async {
    final List<String> errors = ReceiptSaveValidator.validateModel(receipt);
    if (errors.isNotEmpty) {
      throw StateError('Invalid receipt: ${errors.join('; ')}');
    }

    await _dao.upsertReceiptWithItems(
      receipt.toReceiptCompanion(),
      receipt.toReceiptItemsCompanions(),
    );
    await _monthlyBudgetSyncRepository.syncCurrentMonth();
  }

  Future<List<ReceiptModel>> getReceipts() async {
    final List<ReceiptWithItems> rows = await _dao.getReceiptsWithItems();
    return rows.map((ReceiptWithItems row) => row.toReceiptModel()).toList();
  }

  Future<Map<String, BudgetUsageState>> getBudgetStateByCategory() async {
    final List<CategoryBudgetModel> budgets = await _categoryBudgetRepository
        .getBudgets();
    final Map<String, BudgetUsageState> result = <String, BudgetUsageState>{};

    for (final CategoryBudgetModel budget in budgets) {
      final double ratio = budget.budgetAmount <= 0
          ? 0
          : (budget.spentAmount / budget.budgetAmount);
      final BudgetUsageState state;
      if (ratio >= 1) {
        state = BudgetUsageState.exceeded;
      } else if (ratio >= 0.8) {
        state = BudgetUsageState.nearLimit;
      } else {
        state = BudgetUsageState.underBudget;
      }
      result[CategoryBudgetCatalog.normalize(budget.category)] = state;
    }
    return result;
  }
}
