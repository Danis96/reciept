import 'package:flutter/material.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:refyn/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:refyn/app/features/dashboard/ui/widgets/home_card_empty_state.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/app/widgets/receipt_paper_card.dart';
import 'package:refyn/routing/app_router.dart';
import 'package:refyn/theme/app_spacing.dart';

class HomeRecentReceiptsCard extends StatelessWidget {
  const HomeRecentReceiptsCard({
    super.key,
    required this.data,
    required this.onViewAll,
    required this.onOpenReceipt,
  });

  final HomeDashboardModel data;
  final VoidCallback onViewAll;
  final Future<void> Function(ReceiptModel) onOpenReceipt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        border: Border.all(color: HomeThemePalette.cardBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                context.l10n.recentReceipts,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  context.l10n.viewAll,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (data.recentReceipts.isEmpty)
            HomeCardEmptyState(
              imageCategory: 'groceries',
              title: context.l10n.noReceiptsYet,
              message: context.l10n.scanRecentEmptyHint,
            ),
          if (data.recentReceipts.isNotEmpty)
            ReceiptPaperList(
              receipts: data.recentReceipts,
              heroTagBuilder: (ReceiptModel receipt) =>
                  AppRouter.receiptHeroTag('home', receipt.id),
              onOpenReceipt: onOpenReceipt,
            ),
        ],
      ),
    );
  }
}
