import 'package:flutter/foundation.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_repository.dart';
import 'package:reciep/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:reciep/app/features/dashboard/repository/home_dashboard_model.dart';

import '../repository/dashboard_repository.dart';

class DashboardController extends ChangeNotifier {
  DashboardController({
    required DashboardRepository repository,
    required CategoryBudgetRepository categoryBudgetRepository,
    required MonthlyBudgetSyncRepository monthlyBudgetSyncRepository,
  }) : _repository = repository,
       _categoryBudgetRepository = categoryBudgetRepository,
       _monthlyBudgetSyncRepository = monthlyBudgetSyncRepository;

  final DashboardRepository _repository;
  final CategoryBudgetRepository _categoryBudgetRepository;
  final MonthlyBudgetSyncRepository _monthlyBudgetSyncRepository;

  int _currentTabIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  HomeDashboardModel? _homeData;

  int get currentTabIndex => _currentTabIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  HomeDashboardModel? get homeData => _homeData;

  List<String> get supportedBudgetCategories =>
      CategoryBudgetCatalog.supportedCategories;

  Future<void> refreshHome() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _monthlyBudgetSyncRepository.syncCurrentMonth();
      _homeData = await _repository.loadHomeDashboard();
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> upsertBudget({
    required String category,
    required double amount,
  }) async {
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be zero or greater');
    }

    final String normalized = CategoryBudgetCatalog.normalize(category);
    final existing = await _categoryBudgetRepository.getBudgetByCategory(
      normalized,
    );
    await _categoryBudgetRepository.upsertBudget(
      category: normalized,
      budgetAmount: amount,
      spentAmount: existing?.spentAmount ?? 0,
    );
    await refreshHome();
  }

  Future<void> deleteBudget(String category) async {
    await _categoryBudgetRepository.deleteBudget(category);
    await refreshHome();
  }

  void setCurrentTab(int index) {
    if (_currentTabIndex == index) {
      return;
    }
    _currentTabIndex = index;
    notifyListeners();
  }
}
