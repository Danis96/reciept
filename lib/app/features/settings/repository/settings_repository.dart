import 'package:flutter/material.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_repository.dart';
import 'package:refyn/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:refyn/app/features/export/repository/receipt_export_service.dart';
import 'package:refyn/app/features/settings/application/local_backup_service.dart';
import 'package:refyn/app/shared/utils/app_currency_utils.dart';
import 'package:refyn/app/models/category_budget_model.dart';
import 'package:refyn/app/models/receipt/receipt_db_mapper.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/database/app_database.dart';

class SettingsRepository {
  SettingsRepository({
    required AppSettingsDao settingsDao,
    required ReceiptDao receiptDao,
    required ReceiptExportService receiptExportService,
    required CategoryBudgetRepository categoryBudgetRepository,
    required MonthlyBudgetSyncRepository monthlyBudgetSyncRepository,
    required LocalBackupService localBackupService,
  }) : _settingsDao = settingsDao,
       _receiptDao = receiptDao,
       _receiptExportService = receiptExportService,
       _categoryBudgetRepository = categoryBudgetRepository,
       _monthlyBudgetSyncRepository = monthlyBudgetSyncRepository,
       _localBackupService = localBackupService;

  final AppSettingsDao _settingsDao;
  final ReceiptDao _receiptDao;
  final ReceiptExportService _receiptExportService;
  final CategoryBudgetRepository _categoryBudgetRepository;
  final MonthlyBudgetSyncRepository _monthlyBudgetSyncRepository;
  final LocalBackupService _localBackupService;

  static const String _themeModeKey = 'theme_mode';
  static const String _languageCodeKey = 'language_code';
  static const String _currencyCodeKey = 'currency_code';
  static const String defaultCurrency = AppCurrencyUtils.defaultCode;

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
      case 'da':
        return const Locale('da');
      case 'bs':
        return const Locale('bs');
      case 'en':
      default:
        return const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    final String languageCode = switch (locale.languageCode) {
      'da' => 'da',
      'bs' => 'bs',
      _ => 'en',
    };
    await _settingsDao.upsertSetting(
      key: _languageCodeKey,
      value: languageCode,
    );
  }

  Future<String> getCurrency() async {
    final String? value = await _settingsDao.getSetting(_currencyCodeKey);
    return AppCurrencyUtils.normalizeCode(value);
  }

  Future<void> setCurrency(String code) async {
    final String normalized = AppCurrencyUtils.normalizeCode(code);
    await _settingsDao.upsertSetting(
      key: _currencyCodeKey,
      value: normalized,
    );
    await _categoryBudgetRepository.updateAllCurrencies(normalized);
  }

  Future<List<CategoryBudgetModel>> getCategoryBudgets() async {
    await _monthlyBudgetSyncRepository.syncCurrentMonth();
    final List<CategoryBudgetModel> budgets = await _categoryBudgetRepository
        .getBudgets();
    final String currency = await getCurrency();

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
            currency: currency,
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

  Future<void> deleteCategoryBudget(String category) async {
    await _categoryBudgetRepository.deleteBudget(category);
    await _monthlyBudgetSyncRepository.syncCurrentMonth();
  }

  Future<String> exportReceipts(ReceiptExportFormat format) async {
    final List<ReceiptModel> receipts = await _getReceipts();
    if (receipts.isEmpty) {
      throw StateError('No receipts available to export yet.');
    }

    return _receiptExportService.exportReceipts(
      receipts: receipts,
      format: format,
      scopeLabel: 'settings',
    );
  }

  Future<List<ReceiptModel>> getReceiptsForExport() async {
    final List<ReceiptModel> receipts = await _getReceipts();
    if (receipts.isEmpty) {
      throw StateError('No receipts available to export yet.');
    }
    return receipts;
  }

  Future<String> exportSelectedReceipts({
    required List<ReceiptModel> receipts,
    required ReceiptExportFormat format,
  }) async {
    if (receipts.isEmpty) {
      throw StateError('No receipts selected for export.');
    }
    return _receiptExportService.exportReceipts(
      receipts: receipts,
      format: format,
      scopeLabel: 'selected',
    );
  }

  Future<LocalBackupExportResult> exportBackup() {
    return _localBackupService.exportBackup();
  }

  Future<LocalBackupImportResult> importBackup(String archivePath) {
    return _localBackupService.importBackup(archivePath);
  }

  Future<void> clearAllLocalData() {
    return _localBackupService.clearAllLocalData();
  }

  Future<List<ReceiptModel>> _getReceipts() async {
    final List<ReceiptWithItems> rows = await _receiptDao
        .getReceiptsWithItems();
    return rows.map((ReceiptWithItems row) => row.toReceiptModel()).toList();
  }
}
