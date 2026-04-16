import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_repository.dart';
import 'package:reciep/app/features/export/repository/receipt_export_service.dart';
import 'package:reciep/app/features/receipt_details/repository/receipt_details_repository.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_scan_service.dart';

import '../database/app_database.dart';
import 'features/dashboard/controllers/dashboard_controller.dart';
import 'features/dashboard/repository/dashboard_repository.dart';
import 'features/history/controllers/history_controller.dart';
import 'features/history/repository/history_repository.dart';
import 'features/scan/controllers/scan_controller.dart';
import 'features/scan/repository/scan_repository.dart';
import 'features/settings/controllers/settings_controller.dart';
import 'features/settings/repository/settings_repository.dart';
import 'my_app.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, this.database});

  static const String _gemmaModelFallback = String.fromEnvironment(
    'GEMMA_MODEL',
    defaultValue: 'gemma-4-26b-a4b-it',
  );
  static const String _gemmaBaseUrlFallback = String.fromEnvironment(
    'GEMMA_API_BASE_URL',
    defaultValue: 'https://generativelanguage.googleapis.com/v1beta',
  );

  final AppDatabase? database;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => database ?? AppDatabase(),
          dispose: (_, createdDatabase) => createdDatabase.close(),
        ),
        Provider<ReceiptDao>(
          create: (context) => ReceiptDao(context.read<AppDatabase>()),
        ),
        Provider<CategoryBudgetDao>(
          create: (context) => CategoryBudgetDao(context.read<AppDatabase>()),
        ),
        Provider<AppSettingsDao>(
          create: (context) => AppSettingsDao(context.read<AppDatabase>()),
        ),
        Provider<ReceiptExportService>(create: (_) => ReceiptExportService()),
        Provider<CategoryBudgetRepository>(
          create: (context) =>
              CategoryBudgetRepository(dao: context.read<CategoryBudgetDao>()),
        ),
        Provider<DashboardRepository>(
          create: (context) => DashboardRepository(
            receiptDao: context.read<ReceiptDao>(),
            categoryBudgetRepository: context.read<CategoryBudgetRepository>(),
          ),
        ),
        Provider<MonthlyBudgetSyncRepository>(
          create: (context) => MonthlyBudgetSyncRepository(
            receiptDao: context.read<ReceiptDao>(),
            categoryBudgetRepository: context.read<CategoryBudgetRepository>(),
          ),
        ),
        ChangeNotifierProvider<DashboardController>(
          create: (context) => DashboardController(
            repository: context.read<DashboardRepository>(),
            categoryBudgetRepository: context.read<CategoryBudgetRepository>(),
            monthlyBudgetSyncRepository: context
                .read<MonthlyBudgetSyncRepository>(),
          )..refreshHome(),
        ),
        Provider<GemmaReceiptScanService>(
          create: (_) => GemmaReceiptScanService(
            apiKey: _gemmaApiKey,
            model: _gemmaModel,
            baseUrl: _gemmaBaseUrl,
          ),
        ),
        Provider<ScanRepository>(
          create: (context) => ScanRepository(
            receiptDao: context.read<ReceiptDao>(),
            gemmaService: context.read<GemmaReceiptScanService>(),
            monthlyBudgetSyncRepository: context
                .read<MonthlyBudgetSyncRepository>(),
          ),
        ),
        Provider<HistoryRepository>(
          create: (context) => HistoryRepository(
            dao: context.read<ReceiptDao>(),
            monthlyBudgetSyncRepository: context
                .read<MonthlyBudgetSyncRepository>(),
            categoryBudgetRepository: context.read<CategoryBudgetRepository>(),
          ),
        ),
        Provider<ReceiptDetailsRepository>(
          create: (context) => ReceiptDetailsRepository(
            receiptDao: context.read<ReceiptDao>(),
            monthlyBudgetSyncRepository: context
                .read<MonthlyBudgetSyncRepository>(),
            receiptExportService: context.read<ReceiptExportService>(),
          ),
        ),
        ChangeNotifierProvider<HistoryController>(
          create: (context) =>
              HistoryController(repository: context.read<HistoryRepository>())
                ..loadHistory(),
        ),
        ChangeNotifierProvider<ScanController>(
          create: (context) =>
              ScanController(repository: context.read<ScanRepository>())
                ..initialize(),
        ),
        Provider<SettingsRepository>(
          create: (context) => SettingsRepository(
            settingsDao: context.read<AppSettingsDao>(),
            categoryBudgetRepository: context.read<CategoryBudgetRepository>(),
            monthlyBudgetSyncRepository: context
                .read<MonthlyBudgetSyncRepository>(),
            receiptDao: context.read<ReceiptDao>(),
            receiptExportService: context.read<ReceiptExportService>(),
          ),
        ),
        ChangeNotifierProvider<SettingsController>(
          create: (context) =>
              SettingsController(repository: context.read<SettingsRepository>())
                ..loadSettings(),
        ),
      ],
      child: const MyApp(),
    );
  }

  String get _gemmaApiKey {
    final String fromEnv = dotenv.isInitialized
        ? (dotenv.env['GEMMA_API_KEY']?.trim() ?? '')
        : '';
    if (fromEnv.isNotEmpty) {
      return fromEnv;
    }
    return const String.fromEnvironment('GEMMA_API_KEY');
  }

  String get _gemmaModel {
    final String fromEnv = dotenv.isInitialized
        ? (dotenv.env['GEMMA_MODEL']?.trim() ?? '')
        : '';
    if (fromEnv.isNotEmpty) {
      return fromEnv;
    }
    return _gemmaModelFallback;
  }

  String get _gemmaBaseUrl {
    final String fromEnv = dotenv.isInitialized
        ? (dotenv.env['GEMMA_API_BASE_URL']?.trim() ?? '')
        : '';
    if (fromEnv.isNotEmpty) {
      return fromEnv;
    }
    return _gemmaBaseUrlFallback;
  }
}
