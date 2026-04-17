import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_category_item_model.dart';

class DashboardCategoryDetailsModel {
  const DashboardCategoryDetailsModel({
    required this.category,
    required this.label,
    required this.budgetAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.usageRatio,
    required this.state,
    required this.itemCount,
    required this.items,
  });

  final String category;
  final String label;
  final double budgetAmount;
  final double spentAmount;
  final double remainingAmount;
  final double usageRatio;
  final BudgetUsageState state;
  final int itemCount;
  final List<DashboardCategoryItemModel> items;
}
