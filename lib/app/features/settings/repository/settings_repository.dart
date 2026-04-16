import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_repository.dart';
import 'package:reciep/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:reciep/app/models/category_budget_model.dart';
import 'package:reciep/app/models/receipt/receipt_db_mapper.dart';
import 'package:reciep/database/app_database.dart';

class SettingsRepository {
  SettingsRepository({
    required AppSettingsDao settingsDao,
    required CategoryBudgetRepository categoryBudgetRepository,
    required MonthlyBudgetSyncRepository monthlyBudgetSyncRepository,
    required ReceiptDao receiptDao,
  }) : _settingsDao = settingsDao,
       _categoryBudgetRepository = categoryBudgetRepository,
       _monthlyBudgetSyncRepository = monthlyBudgetSyncRepository,
       _receiptDao = receiptDao;

  final AppSettingsDao _settingsDao;
  final CategoryBudgetRepository _categoryBudgetRepository;
  final MonthlyBudgetSyncRepository _monthlyBudgetSyncRepository;
  final ReceiptDao _receiptDao;

  static const String _themeModeKey = 'theme_mode';
  static const String _languageCodeKey = 'language_code';

  Future<ThemeMode> getThemeMode() async {
    final String? value = await _settingsDao.getSetting(_themeModeKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
      case ThemeMode.dark:
        value = 'dark';
      case ThemeMode.system:
        value = 'system';
    }

    await _settingsDao.upsertSetting(key: _themeModeKey, value: value);
  }

  Future<Locale> getLocale() async {
    final String? value = await _settingsDao.getSetting(_languageCodeKey);
    switch (value) {
      case 'bs':
        return const Locale('bs');
      case 'en':
      default:
        return const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    final String languageCode = switch (locale.languageCode) {
      'bs' => 'bs',
      _ => 'en',
    };
    await _settingsDao.upsertSetting(
      key: _languageCodeKey,
      value: languageCode,
    );
  }

  Future<List<CategoryBudgetModel>> getCategoryBudgets() async {
    await _monthlyBudgetSyncRepository.syncCurrentMonth();
    final List<CategoryBudgetModel> budgets = await _categoryBudgetRepository
        .getBudgets();

    final Map<String, CategoryBudgetModel> byCategory =
        <String, CategoryBudgetModel>{
          for (final CategoryBudgetModel budget in budgets)
            CategoryBudgetCatalog.normalize(budget.category): budget,
        };

    return CategoryBudgetCatalog.supportedCategories.map((String category) {
      return byCategory[category] ??
          CategoryBudgetModel(
            category: category,
            budgetAmount: 0,
            spentAmount: 0,
            currency: 'BAM',
            period: 'monthly',
            updatedAt: DateTime.now(),
          );
    }).toList();
  }

  Future<void> saveCategoryBudget({
    required String category,
    required double amount,
  }) async {
    final String normalized = CategoryBudgetCatalog.normalize(category);
    final CategoryBudgetModel? existing = await _categoryBudgetRepository
        .getBudgetByCategory(normalized);
    await _categoryBudgetRepository.upsertBudget(
      category: normalized,
      budgetAmount: amount,
      spentAmount: existing?.spentAmount ?? 0,
    );
    await _monthlyBudgetSyncRepository.syncCurrentMonth();
  }

  Future<String> exportReceiptsAsCsv() async {
    final List<ReceiptWithItems> rows = await _receiptDao
        .getReceiptsWithItems();
    final List<String> lines = <String>[
      'id,date,merchant,total,currency,category,item_count',
    ];

    for (final ReceiptWithItems row in rows) {
      final model = row.toReceiptModel();
      final String line = [
        _escapeCsv(model.id),
        _escapeCsv(model.createdAt.toIso8601String()),
        _escapeCsv(model.merchant.name),
        _escapeCsv(model.totals.total.toStringAsFixed(2)),
        _escapeCsv(model.currency),
        _escapeCsv(CategoryBudgetCatalog.labelFor(model.category)),
        _escapeCsv(model.items.length.toString()),
      ].join(',');
      lines.add(line);
    }

    final String timestamp = DateFormat(
      'yyyyMMdd_HHmmss',
    ).format(DateTime.now());
    final File file = File(
      '${Directory.systemTemp.path}/receipts_$timestamp.csv',
    );
    await file.writeAsString(lines.join('\n'));
    return file.path;
  }

  Future<String> exportReceiptsAsJson() async {
    final List<ReceiptWithItems> rows = await _receiptDao
        .getReceiptsWithItems();
    final List<Map<String, dynamic>> payload = rows
        .map((ReceiptWithItems row) => row.toReceiptModel().toJson())
        .toList();

    final String timestamp = DateFormat(
      'yyyyMMdd_HHmmss',
    ).format(DateTime.now());
    final File file = File(
      '${Directory.systemTemp.path}/receipts_$timestamp.json',
    );
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(payload));
    return file.path;
  }

  String _escapeCsv(String value) {
    final String escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
