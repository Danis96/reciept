import 'package:intl/intl.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/l10n/app_localizations.dart';

class CategoryBudgetMoney {
  const CategoryBudgetMoney._();

  static String formatInt(double value) {
    return NumberFormat('0').format(value);
  }
}

class CategoryBudgetLabel {
  const CategoryBudgetLabel._();

  static String shortLabel(String category) {
    return AppLocalizations.current.categoryLabel(
      CategoryBudgetCatalog.normalize(category),
    );
  }
}
