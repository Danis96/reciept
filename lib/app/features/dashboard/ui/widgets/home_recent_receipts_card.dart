import 'package:flutter/material.dart';
import 'package:reciep/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:reciep/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:reciep/app/features/dashboard/ui/widgets/home_card_empty_state.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/widgets/receipt_paper_card.dart';
import 'package:reciep/routing/app_router.dart';
import 'package:reciep/theme/app_spacing.dart';

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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: HomeThemePalette.cardBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Recent Receipts',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: onViewAll,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (data.recentReceipts.isEmpty)
            const HomeCardEmptyState(
              imageCategory: 'groceries',
              title: 'No receipts yet',
              message:
              'Scan first receipt or import one from gallery. Latest receipts will show here.',
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
