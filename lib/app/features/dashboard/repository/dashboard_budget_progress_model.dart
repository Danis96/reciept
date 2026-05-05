enum BudgetUsageState { underBudget, nearLimit, exceeded }

class DashboardBudgetProgressModel {
  const DashboardBudgetProgressModel({
    required this.category,
    required this.label,
    required this.currency,
    required this.budgetAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.usageRatio,
    required this.state,
  });

  final String category;
  final String label;
  final String currency;
  final double budgetAmount;
  final double spentAmount;
  final double remainingAmount;
  final double usageRatio;
  final BudgetUsageState state;
}
