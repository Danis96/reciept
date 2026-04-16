import 'package:flutter/material.dart';
import 'package:reciep/app/features/export/repository/receipt_export_service.dart';
import 'package:reciep/app/models/category_budget_model.dart';

import '../repository/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({required SettingsRepository repository})
    : _repository = repository;

  final SettingsRepository _repository;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  List<CategoryBudgetModel> _categoryBudgets = const <CategoryBudgetModel>[];
  bool _loading = false;
  bool _exporting = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  List<CategoryBudgetModel> get categoryBudgets => _categoryBudgets;
  bool get loading => _loading;
  bool get exporting => _exporting;
  double get monthlyBudget => _categoryBudgets.fold(
    0,
    (double sum, CategoryBudgetModel item) => sum + item.budgetAmount,
  );

  Future<void> loadSettings() async {
    _loading = true;
    notifyListeners();
    _themeMode = await _repository.getThemeMode();
    _locale = await _repository.getLocale();
    _categoryBudgets = await _repository.getCategoryBudgets();
    _loading = false;
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }
    await _repository.setThemeMode(mode);
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> updateLanguage(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) {
      return;
    }
    await _repository.setLocale(locale);
    _locale = locale;
    notifyListeners();
  }

  Future<String> exportCsv() async {
    return _exportReceipts(ReceiptExportFormat.csv);
  }

  Future<String> exportJson() async {
    return _exportReceipts(ReceiptExportFormat.json);
  }

  Future<String> _exportReceipts(ReceiptExportFormat format) async {
    _exporting = true;
    notifyListeners();
    try {
      return await _repository.exportAllReceipts(format);
    } finally {
      _exporting = false;
      notifyListeners();
    }
  }

  Future<void> saveBudget({
    required String category,
    required double amount,
  }) async {
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be zero or greater');
    }
    await _repository.saveCategoryBudget(category: category, amount: amount);
    _categoryBudgets = await _repository.getCategoryBudgets();
    notifyListeners();
  }

  Future<void> saveBudgets(Map<String, double> valuesByCategory) async {
    for (final MapEntry<String, double> entry in valuesByCategory.entries) {
      if (entry.value < 0) {
        throw ArgumentError.value(
          entry.value,
          entry.key,
          'Must be zero or greater',
        );
      }
      await _repository.saveCategoryBudget(
        category: entry.key,
        amount: entry.value,
      );
    }
    _categoryBudgets = await _repository.getCategoryBudgets();
    notifyListeners();
  }
}
