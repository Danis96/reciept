import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/features/budgets/ui/widgets/category_budget_manager_sheet.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_budget_progress_model.dart';
import 'package:refyn/app/features/dashboard/repository/dashboard_category_details_model.dart';
import 'package:refyn/app/features/dashboard/ui/widgets/category_budget_details_sheet.dart';
import 'package:refyn/app/features/history/controllers/history_controller.dart';
import 'package:refyn/app/features/scan/controllers/scan_controller.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/l10n/app_localizations.dart';
import 'package:refyn/routing/app_router.dart';

import '../../../../theme/category_palette.dart';
import '../controllers/dashboard_controller.dart';

class DashboardActionUtils {
  const DashboardActionUtils._();

  static Future<void> onTabSelected(BuildContext context, int index) async {
    context.read<DashboardController>().setCurrentTab(index);
    if (index == 0) {
      await context.read<DashboardController>().refreshHome();
    }
  }

  static Future<void> onScanReceipt(BuildContext context) async {
    context.read<DashboardController>().setCurrentTab(1);
  }

  static Future<void> onUploadReceipt(BuildContext context) async {
    context.read<DashboardController>().setCurrentTab(1);
    await context.read<ScanController>().pickFromGallery();
  }

  static Future<void> onBudgetSaved(
      BuildContext context, {
        required String category,
        required double amount,
      }) {
    return context.read<DashboardController>().upsertBudget(
      category: category,
      amount: amount,
    );
  }

  static Future<void> onBudgetDeleted(
      BuildContext context, {
        required String category,
      }) {
    return context.read<DashboardController>().deleteBudget(category);
  }

  static Future<void> onBudgetCategoryPressed(
      BuildContext context, {
        required String category,
      }) async {
    final DashboardCategoryDetailsModel details = await context
        .read<DashboardController>()
        .loadCategoryDetails(category);
    if (!context.mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return CategoryBudgetDetailsSheet(details: details);
      },
    );
  }

  static Future<void> onOpenReceipt(
      BuildContext context,
      ReceiptModel receipt,
      ) async {
    final DashboardController dashboardController =
    context.read<DashboardController>();
    final HistoryController historyController =
    context.read<HistoryController>();
    final Object? result = await Navigator.of(context).pushNamed(
      AppRouter.receiptDetails,
      arguments: ReceiptDetailsRouteArgs(
        receiptId: receipt.id,
        heroTag: AppRouter.receiptHeroTag(
          'home',
          receipt.id,
        ),
      ),
    );
    if (result == true && context.mounted) {
      await dashboardController.refreshHome();
      await historyController.loadHistory();
    }
  }

  static Future<void> onManageBudgets(
      BuildContext context, {
        required List<DashboardBudgetProgressModel> budgetProgress,
        required List<String> supportedCategories,
      }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return CategoryBudgetManagerSheet(
          supportedCategories: supportedCategories,
          currentAmounts: <String, double>{
            for (final DashboardBudgetProgressModel item in budgetProgress)
              item.category: item.budgetAmount,
          },
          onSave: (String category, double amount) {
            return onBudgetSaved(
              context,
              category: category,
              amount: amount,
            );
          },
          onDelete: (String category) {
            return onBudgetDeleted(
              context,
              category: category,
            );
          },
        );
      },
    );
  }
}

class DashboardMoney {
  const DashboardMoney._();

  static String formatInt(double value) {
    return NumberFormat('0').format(value);
  }

  static String formatDouble(double value) {
    return NumberFormat('0.00').format(value);
  }

  static String formatDecimalConditionally(double value) {
    if (value % 1 == 0) {
      return NumberFormat('0').format(value);
    } else {
      return NumberFormat('0.00').format(value);
    }
  }
}

class TimeGreetingLabel {
  const TimeGreetingLabel._();

  static String forNow(DateTime now) {
    if (now.hour < 12) {
      return 'Good Morning';
    }
    if (now.hour < 18) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}

class BudgetCategoryLabel {
  const BudgetCategoryLabel._();

  static String shortLabel(String category) {
    final String label = CategoryBudgetCatalog.labelFor(category);
    return label == 'Miscellaneous'
        ? AppLocalizations.current.categoryLabel('miscellaneous')
        : label;
  }

  static String normalized(String value) {
    return CategoryBudgetCatalog.normalize(value);
  }
}

class BudgetCategoryColors {
  const BudgetCategoryColors._();

  static Color primaryFor(String category, BuildContext context) {
    return CategoryPalette.primaryFor(category, context);
  }

  static Color surfaceFor(String category, BuildContext context) {
    return CategoryPalette.surfaceFor(category, context);
  }

  static Color trackFor(String category, BuildContext context) {
    return CategoryPalette.trackFor(category, context);
  }
}

class HomeThemePalette {
  const HomeThemePalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static List<Color> heroGradient(BuildContext context) {
    if (_dark(context)) {
      return const <Color>[Color(0xFF12172B), Color(0xFF222B48)];
    }
    return const <Color>[Color(0xFF171727), Color(0xFF2A2A43)];
  }

  static Color cardBorder(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .onSurface
        .withAlpha(_dark(context) ? 46 : 20); // 0.18 for dark, 0.08 for light
  }

  static Color success(BuildContext context) {
    return _dark(context) ? const Color(0xFF62D483) : const Color(0xFF4FAF66);
  }

  static Color danger(BuildContext context) {
    return _dark(context) ? const Color(0xFFFF8B87) : const Color(0xFFE0574E);
  }
}
