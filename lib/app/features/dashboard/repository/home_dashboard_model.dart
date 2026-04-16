import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

class HomeDashboardModel {
  const HomeDashboardModel({
    required this.totalReceipts,
    required this.thisMonthReceipts,
    required this.thisMonthSpending,
    required this.totalBudget,
    required this.remainingBudget,
    required this.topCategoryLabel,
    required this.budgetProgress,
    required this.recentReceipts,
  });

  final int totalReceipts;
  final int thisMonthReceipts;
  final double thisMonthSpending;
  final double totalBudget;
  final double remainingBudget;
  final String topCategoryLabel;
  final List<DashboardBudgetProgressModel> budgetProgress;
  final List<ReceiptModel> recentReceipts;
}
