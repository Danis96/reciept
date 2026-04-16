import 'package:reciep/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:reciep/app/models/receipt/receipt_db_mapper.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/database/app_database.dart';

class ReceiptDetailsRepository {
  ReceiptDetailsRepository({
    required ReceiptDao receiptDao,
    required MonthlyBudgetSyncRepository monthlyBudgetSyncRepository,
  }) : _receiptDao = receiptDao,
       _monthlyBudgetSyncRepository = monthlyBudgetSyncRepository;

  final ReceiptDao _receiptDao;
  final MonthlyBudgetSyncRepository _monthlyBudgetSyncRepository;

  Future<ReceiptModel?> getReceiptById(String receiptId) async {
    final ReceiptWithItems? row = await _receiptDao
        .getReceiptWithItemsByReceiptId(receiptId);
    return row?.toReceiptModel();
  }

  Future<void> saveReceipt(ReceiptModel receipt) async {
    await _receiptDao.upsertReceiptWithItems(
      receipt.toReceiptCompanion(),
      receipt.toReceiptItemsCompanions(),
    );
    await _monthlyBudgetSyncRepository.syncCurrentMonth();
  }

  Future<void> deleteReceipt(String receiptId) async {
    await _receiptDao.deleteReceiptByReceiptId(receiptId);
    await _monthlyBudgetSyncRepository.syncCurrentMonth();
  }
}
