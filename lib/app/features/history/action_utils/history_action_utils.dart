import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:refyn/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:refyn/app/features/history/controllers/history_controller.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/routing/app_router.dart';

class HistoryActionUtils {
  const HistoryActionUtils._();

  static Future<void> refresh(BuildContext context) {
    return context.read<HistoryController>().loadHistory();
  }

  static void onSearchChanged(BuildContext context, String query) {
    context.read<HistoryController>().setSearchQuery(query);
  }

  static void onCategorySelected(BuildContext context, String category) {
    context.read<HistoryController>().setCategoryFilter(category);
  }

  static void onSortSelected(BuildContext context, HistorySortOption option) {
    context.read<HistoryController>().setSortOption(option);
  }

  static void onDateRangeChanged(BuildContext context, DateTimeRange? range) {
    context.read<HistoryController>().setDateRange(range);
  }

  static Future<void> showDateRangePicker(BuildContext context) async {
    final HistoryController controller = context.read<HistoryController>();
    final DateTime now = DateTime.now();

    final DateTimeRange? range = await material.showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDateRange: controller.dateRange,
    );

    if (!context.mounted) {
      return;
    }

    onDateRangeChanged(context, range);
  }

  static Future<void> onOpenDetails(
      BuildContext context,
      ReceiptModel receipt,
      ) async {
    final HistoryController historyController = context
        .read<HistoryController>();
    final DashboardController dashboardController = context
        .read<DashboardController>();
    final Object? result = await Navigator.of(context).pushNamed(
      AppRouter.receiptDetails,
      arguments: ReceiptDetailsRouteArgs(
        receiptId: receipt.id,
        heroTag: AppRouter.receiptHeroTag('history', receipt.id),
      ),
    );
    if (result == true && context.mounted) {
      // Refresh both history and dashboard data
      await historyController.loadHistory();
      await dashboardController.refreshHome();
    }
  }
}
