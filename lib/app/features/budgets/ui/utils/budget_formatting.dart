import 'package:intl/intl.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';

class CategoryBudgetMoney {
  const CategoryBudgetMoney._();

  static String formatInt(double value) {
    return NumberFormat('0').format(value);
  }
}

class CategoryBudgetLabel {
  const CategoryBudgetLabel._();

  static String shortLabel(String category) {
    switch (CategoryBudgetCatalog.normalize(category)) {
      case CategoryBudgetCatalog.groceries:
        return 'Groceries';
      case CategoryBudgetCatalog.fuel:
        return 'Fuel';
      case CategoryBudgetCatalog.household:
        return 'Household';
      case CategoryBudgetCatalog.pets:
        return 'Pets';
      case CategoryBudgetCatalog.clothing:
        return 'Clothing';
      case CategoryBudgetCatalog.pharmacy:
        return 'Pharmacy';
      case CategoryBudgetCatalog.dental:
        return 'Dental';
      case CategoryBudgetCatalog.nightOut:
        return 'Night Out';
      case CategoryBudgetCatalog.cigarettes:
        return 'Cigarettes';
      case CategoryBudgetCatalog.miscellaneous:
        return 'Misc';
      default:
        return 'Misc';
    }
  }
}
