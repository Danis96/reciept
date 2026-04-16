import 'package:flutter/material.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

import '../repository/history_repository.dart';

enum HistorySortOption { newest, oldest, highestAmount, lowestAmount }

class HistoryController extends ChangeNotifier {
  HistoryController({required HistoryRepository repository})
    : _repository = repository;

  final HistoryRepository _repository;

  bool _isLoading = false;
  List<ReceiptModel> _allReceipts = const <ReceiptModel>[];
  Map<String, BudgetUsageState> _budgetStateByCategory =
      const <String, BudgetUsageState>{};
  String _searchQuery = '';
  String _selectedCategory = 'all';
  HistorySortOption _sortOption = HistorySortOption.newest;
  DateTimeRange? _dateRange;

  bool get isLoading => _isLoading;
  List<ReceiptModel> get allReceipts => _allReceipts;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  HistorySortOption get sortOption => _sortOption;
  DateTimeRange? get dateRange => _dateRange;
  Map<String, BudgetUsageState> get budgetStateByCategory =>
      _budgetStateByCategory;

  int get totalReceiptCount => _allReceipts.length;

  List<String> get categoryFilters => <String>[
    'all',
    ...CategoryBudgetCatalog.supportedCategories,
  ];

  List<ReceiptModel> get receipts {
    Iterable<ReceiptModel> current = _allReceipts;

    final String query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      current = current.where((ReceiptModel receipt) {
        final String merchant = receipt.merchant.name.toLowerCase();
        final String category = CategoryBudgetCatalog.normalize(
          receipt.category,
        );
        return merchant.contains(query) || category.contains(query);
      });
    }

    if (_selectedCategory != 'all') {
      current = current.where(
        (ReceiptModel receipt) =>
            CategoryBudgetCatalog.normalize(receipt.category) ==
            _selectedCategory,
      );
    }

    if (_dateRange != null) {
      final DateTime start = DateTime(
        _dateRange!.start.year,
        _dateRange!.start.month,
        _dateRange!.start.day,
      );
      final DateTime end = DateTime(
        _dateRange!.end.year,
        _dateRange!.end.month,
        _dateRange!.end.day,
        23,
        59,
        59,
      );
      current = current.where((ReceiptModel receipt) {
        final DateTime date = receipt.createdAt;
        return !date.isBefore(start) && !date.isAfter(end);
      });
    }

    final List<ReceiptModel> result = current.toList(growable: false);
    result.sort(_sortComparator);
    return result;
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _allReceipts = await _repository.getReceipts();
    _budgetStateByCategory = await _repository.getBudgetStateByCategory();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveReceipt(ReceiptModel receipt) async {
    await _repository.saveReceipt(receipt);
    await loadHistory();
  }

  BudgetUsageState? budgetStateForCategory(String category) {
    final String key = CategoryBudgetCatalog.normalize(category);
    return _budgetStateByCategory[key];
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(HistorySortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    _dateRange = range;
    notifyListeners();
  }

  int _sortComparator(ReceiptModel a, ReceiptModel b) {
    switch (_sortOption) {
      case HistorySortOption.newest:
        return b.createdAt.compareTo(a.createdAt);
      case HistorySortOption.oldest:
        return a.createdAt.compareTo(b.createdAt);
      case HistorySortOption.highestAmount:
        return b.totals.total.compareTo(a.totals.total);
      case HistorySortOption.lowestAmount:
        return a.totals.total.compareTo(b.totals.total);
    }
  }
}
