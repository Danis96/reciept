import 'package:flutter/material.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';

class CategoryPalette {
  const CategoryPalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color primaryFor(String category, BuildContext context) {
    switch (CategoryBudgetCatalog.normalize(category)) {
      case CategoryBudgetCatalog.groceries:
        return _dark(context)
            ? const Color(0xFF5FD08A)
            : const Color(0xFF38A169);
      case CategoryBudgetCatalog.household:
        return _dark(context)
            ? const Color(0xFFC79A72)
            : const Color(0xFF8B5E3C);
      case CategoryBudgetCatalog.pets:
        return _dark(context)
            ? const Color(0xFFFFD96A)
            : const Color(0xFFE0B321);
      case CategoryBudgetCatalog.clothing:
        return _dark(context)
            ? const Color(0xFF72AEFF)
            : const Color(0xFF3A84F7);
      case CategoryBudgetCatalog.fuel:
        return _dark(context)
            ? const Color(0xFFFF9A73)
            : const Color(0xFFE76F51);
      case CategoryBudgetCatalog.pharmacy:
        return _dark(context)
            ? const Color(0xFF61D3C6)
            : const Color(0xFF0E9384);
      case CategoryBudgetCatalog.dental:
        return _dark(context)
            ? const Color(0xFF8FD3FF)
            : const Color(0xFF2D9CDB);
      case CategoryBudgetCatalog.nightOut:
        return _dark(context)
            ? const Color(0xFFFFB38A)
            : const Color(0xFFB65A2A);
      case CategoryBudgetCatalog.cigarettes:
        return _dark(context)
            ? const Color(0xFFD7C27A)
            : const Color(0xFF8A6A1F);
      case CategoryBudgetCatalog.miscellaneous:
        return _dark(context)
            ? const Color(0xFFACB4C8)
            : const Color(0xFF667085);
      default:
        return _dark(context)
            ? const Color(0xFFACB4C8)
            : const Color(0xFF667085);
    }
  }

  static Color surfaceFor(String category, BuildContext context) {
    return primaryFor(
      category,
      context,
    ).withValues(alpha: _dark(context) ? 0.22 : 0.32);
  }

  static Color onPrimaryFor(String category, BuildContext context) {
    switch (CategoryBudgetCatalog.normalize(category)) {
      case CategoryBudgetCatalog.pets:
        return const Color(0xFF2B2300);
      default:
        return Colors.white;
    }
  }

  static Color trackFor(String category, BuildContext context) {
    return primaryFor(
      category,
      context,
    ).withValues(alpha: _dark(context) ? 0.24 : 0.18);
  }

  static LinearGradient subtleGradientFor(
    String category,
    BuildContext context,
  ) {
    final Color base = primaryFor(category, context);
    final Color start = base.withValues(alpha: _dark(context) ? 0.18 : 0.5);
    final Color end = Theme.of(
      context,
    ).colorScheme.surface.withValues(alpha: _dark(context) ? 0.96 : 1);

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[start, end],
    );
  }
}
