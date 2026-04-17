import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/history/action_utils/history_action_utils.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';
import 'package:reciep/app/features/history/ui/widgets/history_category_chips.dart';
import 'package:reciep/app/features/history/ui/widgets/history_empty_state.dart';
import 'package:reciep/app/features/history/ui/widgets/history_search_bar.dart';
import 'package:reciep/app/features/history/ui/widgets/history_sort_filter_row.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/theme/app_spacing.dart';

import '../widgets/history_receipt_list.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryController>(
      builder: (BuildContext context, HistoryController controller, _) {
        final ThemeData theme = Theme.of(context);
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Receipt History',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '${controller.totalReceiptCount} total receipts',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      HistorySearchBar(
                        initialValue: controller.searchQuery,
                        onChanged: (String query) =>
                            HistoryActionUtils.onSearchChanged(context, query),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      HistoryCategoryChips(
                        categories: controller.categoryFilters,
                        selectedCategory: controller.selectedCategory,
                        onCategorySelected: (String category) =>
                            HistoryActionUtils.onCategorySelected(
                              context,
                              category,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      HistorySortFilterRow(
                        sortOption: controller.sortOption,
                        hasDateFilter: controller.dateRange != null,
                        onSortSelected: (HistorySortOption option) =>
                            HistoryActionUtils.onSortSelected(context, option),
                        onDateFilterTapped: () =>
                            HistoryActionUtils.showDateRangePicker(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (controller.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (controller.receipts.isEmpty)
                        HistoryEmptyState(
                          selectedCategory: controller.selectedCategory,
                        )
                      else
                        HistoryReceiptsList(
                          receipts: controller.receipts,
                          onOpenDetails: (ReceiptModel receipt) =>
                              HistoryActionUtils.onOpenDetails(
                                context,
                                receipt,
                              ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
