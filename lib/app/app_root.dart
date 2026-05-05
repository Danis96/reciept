import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/features/ai/domain/repositories/ai_configuration_repository.dart';
import 'package:refyn/app/features/ai/infrastructure/app_settings_ai_configuration_repository.dart';
import 'package:refyn/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_repository.dart';
import 'package:refyn/app/features/export/repository/receipt_export_service.dart';
import 'package:refyn/app/features/receipt_details/repository/receipt_details_repository.dart';
import 'package:refyn/app/features/scan/repository/gemma_receipt_scan_service.dart';
import 'package:refyn/app/features/scan/repository/receipt_image_compression_service.dart';
import 'package:refyn/app/features/settings/application/local_backup_service.dart';

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
        Provider<ReceiptImageCompressionService>(
          create: (_) => const ReceiptImageCompressionService(),
        ),
        Provider<AiConfigurationRepository>(
          create: (context) => AppSettingsAiConfigurationRepository(
            settingsDao: context.read<AppSettingsDao>(),
            defaultApiKey: _gemmaApiKey,
            defaultModel: _gemmaModel,
            apiBaseUrl: _gemmaBaseUrl,
          ),
        ),
        Provider<GemmaReceiptScanService>(
          create: (context) {
            final GemmaReceiptScanService service = GemmaReceiptScanService(
              configurationRepository: context.read<AiConfigurationRepository>(),
              baseUrl: _gemmaBaseUrl,
              imageCompressionService: context
                  .read<ReceiptImageCompressionService>(),
            );
            unawaited(service.warmUp());
            return service;
          },
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
            receiptDao: context.read<ReceiptDao>(),
            receiptExportService: context.read<ReceiptExportService>(),
            categoryBudgetRepository: context.read<CategoryBudgetRepository>(),
            monthlyBudgetSyncRepository: context
                .read<MonthlyBudgetSyncRepository>(),
            localBackupService: LocalBackupService(
              database: context.read<AppDatabase>(),
              receiptDao: context.read<ReceiptDao>(),
              appSettingsDao: context.read<AppSettingsDao>(),
              categoryBudgetRepository: context
                  .read<CategoryBudgetRepository>(),
            ),
          ),
        ),
        ChangeNotifierProvider<SettingsController>(
          create: (context) => SettingsController(
            repository: context.read<SettingsRepository>(),
            aiConfigurationRepository:
                context.read<AiConfigurationRepository>(),
          )..loadSettings(),
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
