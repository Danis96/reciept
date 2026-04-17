import 'package:flutter/material.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';

class HistoryCategoryLabel {
  const HistoryCategoryLabel._();

  static String labelForChip(String key) {
    switch (key) {
      case 'all':
        return 'All';
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
      case CategoryBudgetCatalog.miscellaneous:
        return 'Misc';
      default:
        return 'All';
    }
  }

  static String labelForBadge(String category) {
    final String normalized = CategoryBudgetCatalog.normalize(category);
    switch (normalized) {
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
      case CategoryBudgetCatalog.miscellaneous:
        return 'Misc';
      default:
        return 'Misc';
    }
  }
}

class HistorySortLabel {
  const HistorySortLabel._();

  static String labelFor(HistorySortOption option) {
    switch (option) {
      case HistorySortOption.newest:
        return 'Sort by Date';
      case HistorySortOption.oldest:
        return 'Oldest First';
      case HistorySortOption.highestAmount:
        return 'Highest Amount';
      case HistorySortOption.lowestAmount:
        return 'Lowest Amount';
    }
  }
}

class HistoryThemePalette {
  const HistoryThemePalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color border(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: _dark(context) ? 0.18 : 0.08);
  }

  static Color inputBackground(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha:_dark(context) ? 0.14 : 0.06);
  }

  static Color selectedChipBackground(BuildContext context) {
    return _dark(context)
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.35)
        : const Color(0xFF0C0C1F);
  }

  static Color selectedChipText(BuildContext context) {
    return _dark(context)
        ? Theme.of(context).colorScheme.onPrimary
        : Colors.white;
  }
}
