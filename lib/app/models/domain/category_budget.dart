import 'package:refyn/app/models/category_budget_model.dart';

class CategoryBudget {
  const CategoryBudget({
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

  CategoryBudgetModel toModel() {
    return CategoryBudgetModel(
      category: category,
      budgetAmount: budgetAmount,
      spentAmount: spentAmount,
      currency: currency,
      period: period,
      updatedAt: updatedAt,
    );
  }

  factory CategoryBudget.fromModel(CategoryBudgetModel model) {
    return CategoryBudget(
      category: model.category,
      budgetAmount: model.budgetAmount,
      spentAmount: model.spentAmount,
      currency: model.currency,
      period: model.period,
      updatedAt: model.updatedAt,
    );
  }
}
