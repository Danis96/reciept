import 'package:flutter/material.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:reciep/app/features/history/controllers/history_receipt_list_entry.dart';
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
  int get totalItemCount => _allReceipts.fold<int>(
    0,
    (int sum, ReceiptModel receipt) => sum + receipt.items.length,
  );

  List<String> get categoryFilters => <String>[
    'all',
    ...CategoryBudgetCatalog.supportedCategories,
  ];

  List<HistoryReceiptListEntry> get historyEntries {
    Iterable<HistoryReceiptListEntry> current = _allReceipts.expand(
      (ReceiptModel receipt) => receipt.items.asMap().entries.map(
        (MapEntry<int, dynamic> entry) => HistoryReceiptListEntry(
          receipt: receipt,
          item: entry.value,
          itemIndex: entry.key,
        ),
      ),
    );

    final String query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      current = current.where((HistoryReceiptListEntry entry) {
        final String merchant = entry.merchantName.toLowerCase();
        final String itemName = entry.itemName.toLowerCase();
        final String category = CategoryBudgetCatalog.normalize(entry.category);
        return merchant.contains(query) ||
            itemName.contains(query) ||
            category.contains(query);
      });
    }

    if (_selectedCategory != 'all') {
      current = current.where(
        (HistoryReceiptListEntry entry) =>
            CategoryBudgetCatalog.normalize(entry.category) ==
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
      current = current.where((HistoryReceiptListEntry entry) {
        final DateTime date = entry.createdAt;
        return !date.isBefore(start) && !date.isAfter(end);
      });
    }

    final List<HistoryReceiptListEntry> result = current.toList(
      growable: false,
    );
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

  int _sortComparator(HistoryReceiptListEntry a, HistoryReceiptListEntry b) {
    switch (_sortOption) {
      case HistorySortOption.newest:
        return b.createdAt.compareTo(a.createdAt);
      case HistorySortOption.oldest:
        return a.createdAt.compareTo(b.createdAt);
      case HistorySortOption.highestAmount:
        return b.amount.compareTo(a.amount);
      case HistorySortOption.lowestAmount:
        return a.amount.compareTo(b.amount);
    }
  }
}
