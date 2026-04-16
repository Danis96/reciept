import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/history_controller.dart';

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
}
