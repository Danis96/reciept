import 'package:flutter/material.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/features/history/controllers/history_controller.dart';
import 'package:refyn/l10n/app_localizations.dart';

class HistoryCategoryLabel {
  const HistoryCategoryLabel._();

  static String labelForChip(String key) {
    switch (key) {
      case 'all':
        return AppLocalizations.current.all;
      case CategoryBudgetCatalog.groceries:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.groceries);
      case CategoryBudgetCatalog.fuel:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.fuel);
      case CategoryBudgetCatalog.household:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.household);
      case CategoryBudgetCatalog.pets:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.pets);
      case CategoryBudgetCatalog.clothing:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.clothing);
      case CategoryBudgetCatalog.pharmacy:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.pharmacy);
      case CategoryBudgetCatalog.dental:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.dental);
      case CategoryBudgetCatalog.nightOut:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.nightOut);
      case CategoryBudgetCatalog.cigarettes:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.cigarettes);
      case CategoryBudgetCatalog.miscellaneous:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.miscellaneous);
      default:
        return AppLocalizations.current.all;
    }
  }

  static String labelForBadge(String category) {
    final String normalized = CategoryBudgetCatalog.normalize(category);
    switch (normalized) {
      case CategoryBudgetCatalog.groceries:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.groceries);
      case CategoryBudgetCatalog.fuel:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.fuel);
      case CategoryBudgetCatalog.household:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.household);
      case CategoryBudgetCatalog.pets:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.pets);
      case CategoryBudgetCatalog.clothing:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.clothing);
      case CategoryBudgetCatalog.pharmacy:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.pharmacy);
      case CategoryBudgetCatalog.dental:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.dental);
      case CategoryBudgetCatalog.nightOut:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.nightOut);
      case CategoryBudgetCatalog.cigarettes:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.cigarettes);
      case CategoryBudgetCatalog.miscellaneous:
        return AppLocalizations.current.categoryLabel(CategoryBudgetCatalog.miscellaneous);
      default:
        return AppLocalizations.current.categoryLabel(
          CategoryBudgetCatalog.miscellaneous,
        );
    }
  }
}

class HistorySortLabel {
  const HistorySortLabel._();

  static String labelFor(HistorySortOption option) {
    switch (option) {
      case HistorySortOption.newest:
        return AppLocalizations.current.date;
      case HistorySortOption.oldest:
        return AppLocalizations.current.oldestFirst;
      case HistorySortOption.highestAmount:
        return AppLocalizations.current.highestAmount;
      case HistorySortOption.lowestAmount:
        return AppLocalizations.current.lowestAmount;
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
