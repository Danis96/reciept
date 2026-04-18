import 'package:flutter/material.dart';

class CategoryBudgetSheetPalette {
  const CategoryBudgetSheetPalette._();

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static List<Color> heroGradient(BuildContext context) {
    if (_isDark(context)) {
      return const [Color(0xFF12172B), Color(0xFF222B48)];
    }
    return const [Color(0xFF171727), Color(0xFF2A2A43)];
  }

  static Color cardBorder(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: _isDark(context) ? 0.18 : 0.08);
  }

  static Color danger(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }
}
