import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/dashboard/repository/dashboard_category_details_model.dart';
import 'package:reciep/app/features/dashboard/ui/widgets/category_budget_details_sheet.dart';
import 'package:reciep/app/features/scan/controllers/scan_controller.dart';

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
}
