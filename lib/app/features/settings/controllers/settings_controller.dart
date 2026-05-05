import 'package:flutter/material.dart';
import 'package:refyn/app/features/ai/domain/ai_configuration.dart';
import 'package:refyn/app/features/ai/domain/ai_model_option.dart';
import 'package:refyn/app/features/ai/domain/repositories/ai_configuration_repository.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/features/export/repository/receipt_export_service.dart';
import 'package:refyn/app/features/settings/application/local_backup_service.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/app/models/category_budget_model.dart';

import '../repository/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({
    required SettingsRepository repository,
    required AiConfigurationRepository aiConfigurationRepository,
  })  : _repository = repository,
        _aiConfigurationRepository = aiConfigurationRepository;

  final SettingsRepository _repository;
  final AiConfigurationRepository _aiConfigurationRepository;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  String _currencyCode = SettingsRepository.defaultCurrency;
  List<CategoryBudgetModel> _categoryBudgets = const <CategoryBudgetModel>[];
  bool _loading = false;
  bool _exporting = false;
  bool _receiptExporting = false;
  bool _importing = false;
  bool _clearing = false;

  // ── AI configuration state ─────────────────────────────────────────────────

  String _apiKeyDraft = '';
  String _confirmedApiKey = '';
  bool _isApiKeyVisible = false;
  bool _hasProtectedDefaultApiKey = false;
  bool _isLoadingAiConfiguration = false;
  bool _isConfirmingApiKey = false;
  bool _isSavingSelectedModel = false;
  String? _selectedModelId;
  bool _isThinkingEnabled = false;
  bool _isSavingThinkingMode = false;
  List<AiModelOption> _availableModels = const <AiModelOption>[];
  String? _aiConfigurationError;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get currencyCode => _currencyCode;
  List<CategoryBudgetModel> get categoryBudgets => _categoryBudgets;
  bool get loading => _loading;
  bool get exporting => _exporting;
  bool get receiptExporting => _receiptExporting;
  bool get importing => _importing;
  bool get clearing => _clearing;
  List<String> get supportedBudgetCategories =>
      CategoryBudgetCatalog.supportedCategories;
  double get monthlyBudget => _categoryBudgets.fold(
    0,
    (double sum, CategoryBudgetModel item) => sum + item.budgetAmount,
  );

  String get apiKeyDraft => _apiKeyDraft;
  bool get isApiKeyConfirmed =>
      _confirmedApiKey.trim().isNotEmpty &&
      _confirmedApiKey.trim() == _apiKeyDraft.trim();
  bool get isApiKeyVisible => _isApiKeyVisible;
  bool get hasProtectedDefaultApiKey => _hasProtectedDefaultApiKey;
  bool get isLoadingAiConfiguration => _isLoadingAiConfiguration;
  bool get isConfirmingApiKey => _isConfirmingApiKey;
  bool get isSavingSelectedModel => _isSavingSelectedModel;
  String? get selectedModelId => _selectedModelId;
  bool get isThinkingEnabled => _isThinkingEnabled;
  bool get isSavingThinkingMode => _isSavingThinkingMode;
  List<AiModelOption> get availableModels => _availableModels;
  String? get aiConfigurationError => _aiConfigurationError;

  bool get canConfirmApiKey =>
      _apiKeyDraft.trim().isNotEmpty &&
      !_isConfirmingApiKey &&
      !_isLoadingAiConfiguration;

  bool get canResetAiConfiguration =>
      _apiKeyDraft.trim().isNotEmpty ||
      _confirmedApiKey.trim().isNotEmpty ||
      _selectedModelId != null;

  bool get hasModelSelection =>
      isApiKeyConfirmed &&
      _availableModels.isNotEmpty &&
      _selectedModelId != null;

  Future<void> loadSettings() async {
    _loading = true;
    notifyListeners();
    _themeMode = await _repository.getThemeMode();
    _locale = await _repository.getLocale();
    _currencyCode = await _repository.getCurrency();
    _categoryBudgets = await _repository.getCategoryBudgets();
    _loading = false;
    notifyListeners();
    await loadAiConfiguration();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }
    await _repository.setThemeMode(mode);
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> updateCurrency(String code) async {
    final String normalized = code.trim().toUpperCase();
    if (normalized.isEmpty || _currencyCode == normalized) {
      return;
    }
    await _repository.setCurrency(normalized);
    _currencyCode = normalized;
    _categoryBudgets = await _repository.getCategoryBudgets();
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

  Future<LocalBackupExportResult> exportBackup() async {
    _exporting = true;
    notifyListeners();
    try {
      return await _repository.exportBackup();
    } finally {
      _exporting = false;
      notifyListeners();
    }
  }

  Future<String> exportReceipts(ReceiptExportFormat format) async {
    _receiptExporting = true;
    notifyListeners();
    try {
      return await _repository.exportReceipts(format);
    } finally {
      _receiptExporting = false;
      notifyListeners();
    }
  }

  Future<List<ReceiptModel>> getReceiptsForExport() async {
    _receiptExporting = true;
    notifyListeners();
    try {
      return await _repository.getReceiptsForExport();
    } finally {
      _receiptExporting = false;
      notifyListeners();
    }
  }

  Future<LocalBackupImportResult> importBackup(String archivePath) async {
    _importing = true;
    notifyListeners();
    try {
      final LocalBackupImportResult result = await _repository.importBackup(
        archivePath,
      );
      await loadSettings();
      return result;
    } finally {
      _importing = false;
      notifyListeners();
    }
  }

  Future<void> clearAllLocalData() async {
    _clearing = true;
    notifyListeners();
    try {
      await _repository.clearAllLocalData();
      _resetAiConfigurationState();
      await loadSettings();
    } finally {
      _clearing = false;
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

  Future<void> deleteBudget(String category) async {
    await _repository.deleteCategoryBudget(category);
    _categoryBudgets = await _repository.getCategoryBudgets();
    notifyListeners();
  }

  // ── AI configuration actions ───────────────────────────────────────────────

  void updateApiKeyDraft(String value) {
    if (_apiKeyDraft == value) {
      return;
    }

    _apiKeyDraft = value;
    if (value.trim().isNotEmpty) {
      _hasProtectedDefaultApiKey = false;
    }

    if (_confirmedApiKey.trim() != value.trim()) {
      _availableModels = const <AiModelOption>[];
      _selectedModelId = null;
      _aiConfigurationError = null;
    }

    notifyListeners();
  }

  void toggleApiKeyVisibility() {
    _isApiKeyVisible = !_isApiKeyVisible;
    notifyListeners();
  }

  Future<void> loadAiConfiguration() async {
    if (_isLoadingAiConfiguration) {
      return;
    }

    _isLoadingAiConfiguration = true;
    _aiConfigurationError = null;
    notifyListeners();

    try {
      final AiConfiguration configuration = await _aiConfigurationRepository
          .getConfiguration();
      _hasProtectedDefaultApiKey = configuration.isUsingBuiltInApiKey;
      if (_hasProtectedDefaultApiKey) {
        _apiKeyDraft = '';
        _confirmedApiKey = '';
        _isApiKeyVisible = false;
      } else {
        _apiKeyDraft = configuration.apiKey;
        _confirmedApiKey = configuration.apiKey;
      }
      _selectedModelId = configuration.selectedModel;
      _isThinkingEnabled = configuration.isThinkingEnabled;

      if (configuration.hasApiKey) {
        await _loadModelsForApiKey(
          configuration.apiKey,
          preferredModelId: configuration.selectedModel,
          persistSelectedModel: false,
        );
      }
    } catch (error) {
      _availableModels = const <AiModelOption>[];
      _selectedModelId = null;
      _isThinkingEnabled = false;
      _confirmedApiKey = '';
      _hasProtectedDefaultApiKey = false;
      _aiConfigurationError = error.toString();
    } finally {
      _isLoadingAiConfiguration = false;
      notifyListeners();
    }
  }

  Future<void> confirmApiKey() async {
    final String trimmedApiKey = _apiKeyDraft.trim();
    if (trimmedApiKey.isEmpty) {
      throw StateError('missing_api_key');
    }

    _isConfirmingApiKey = true;
    _aiConfigurationError = null;
    _hasProtectedDefaultApiKey = false;
    notifyListeners();

    try {
      await _loadModelsForApiKey(trimmedApiKey, persistSelectedModel: true);
      await _aiConfigurationRepository.saveApiKey(trimmedApiKey);
      _confirmedApiKey = trimmedApiKey;
    } catch (error) {
      _availableModels = const <AiModelOption>[];
      _selectedModelId = null;
      _isThinkingEnabled = false;
      _confirmedApiKey = '';
      _hasProtectedDefaultApiKey = false;
      _aiConfigurationError = error.toString();
      rethrow;
    } finally {
      _isConfirmingApiKey = false;
      notifyListeners();
    }
  }

  Future<void> saveSelectedModel(String modelId) async {
    if (_selectedModelId == modelId || _isSavingSelectedModel) {
      return;
    }

    _isSavingSelectedModel = true;
    notifyListeners();

    try {
      await _aiConfigurationRepository.saveSelectedModel(modelId);
      _selectedModelId = modelId;
    } finally {
      _isSavingSelectedModel = false;
      notifyListeners();
    }
  }

  Future<void> saveThinkingEnabled(bool enabled) async {
    if (_isSavingThinkingMode || _isThinkingEnabled == enabled) {
      return;
    }

    _isSavingThinkingMode = true;
    notifyListeners();

    try {
      final String thinkingLevel = enabled
          ? AiConfiguration.highThinkingLevel
          : AiConfiguration.minimalThinkingLevel;
      await _aiConfigurationRepository.saveThinkingLevel(thinkingLevel);
      _isThinkingEnabled = enabled;
    } finally {
      _isSavingThinkingMode = false;
      notifyListeners();
    }
  }

  Future<void> resetAiConfiguration() async {
    _isLoadingAiConfiguration = true;
    notifyListeners();

    try {
      await _aiConfigurationRepository.clearConfiguration();
      _resetAiConfigurationState();
    } finally {
      _isLoadingAiConfiguration = false;
      notifyListeners();
    }

    await loadAiConfiguration();
  }

  Future<void> _loadModelsForApiKey(
    String apiKey, {
    String? preferredModelId,
    required bool persistSelectedModel,
  }) async {
    final List<AiModelOption> options = await _aiConfigurationRepository
        .fetchAvailableModels(apiKey: apiKey);

    final List<AiModelOption> filteredOptions = options
        .where((AiModelOption option) =>
            option.id.toLowerCase().contains('gemma'))
        .toList(growable: false);
    _availableModels = filteredOptions;

    if (filteredOptions.isEmpty) {
      throw StateError(
        'No compatible Gemma models were returned for this API key.',
      );
    }

    final String? preferredId = preferredModelId?.trim();
    final String selectedModel = filteredOptions.any(
      (AiModelOption option) => option.id == preferredId,
    )
        ? preferredId!
        : filteredOptions.first.id;

    _selectedModelId = selectedModel;

    if (persistSelectedModel) {
      await _aiConfigurationRepository.saveSelectedModel(selectedModel);
    }
  }

  void _resetAiConfigurationState() {
    _apiKeyDraft = '';
    _confirmedApiKey = '';
    _selectedModelId = null;
    _availableModels = const <AiModelOption>[];
    _isThinkingEnabled = false;
    _hasProtectedDefaultApiKey = false;
    _aiConfigurationError = null;
    _isApiKeyVisible = false;
  }
}
