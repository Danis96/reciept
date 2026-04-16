class CategoryBudgetModel {
  const CategoryBudgetModel({
    required this.category,
    required this.budgetAmount,
    required this.spentAmount,
    required this.currency,
    required this.period,
    required this.updatedAt,
  });

  final String category;
  final double budgetAmount;
  final double spentAmount;
  final String currency;
  final String period;
  final DateTime updatedAt;
}
