import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/settings_controller.dart';

class SettingsActionUtils {
  const SettingsActionUtils._();

  static Future<void> onThemeModeChanged(
    BuildContext context,
    ThemeMode themeMode,
  ) {
    return context.read<SettingsController>().updateThemeMode(themeMode);
  }

  static Future<void> onLanguageChanged(BuildContext context, Locale locale) {
    return context.read<SettingsController>().updateLanguage(locale);
  }

  static Future<String> onExportCsv(BuildContext context) {
    return context.read<SettingsController>().exportCsv();
  }

  static Future<String> onExportJson(BuildContext context) {
    return context.read<SettingsController>().exportJson();
  }

  static Future<void> onBudgetSaved(
    BuildContext context, {
    required String category,
    required double amount,
  }) {
    return context.read<SettingsController>().saveBudget(
      category: category,
      amount: amount,
    );
  }

  static Future<void> onBudgetsSaved(
    BuildContext context,
    Map<String, double> valuesByCategory,
  ) {
    return context.read<SettingsController>().saveBudgets(valuesByCategory);
  }
}
