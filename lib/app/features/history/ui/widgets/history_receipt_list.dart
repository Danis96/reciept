import 'package:flutter/material.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/widgets/receipt_paper_card.dart';
import 'package:reciep/routing/app_router.dart';

class HistoryReceiptsList extends StatelessWidget {
  const HistoryReceiptsList({
    super.key,
    required this.receipts,
    required this.onOpenDetails,
  });

  final List<ReceiptModel> receipts;
  final Future<void> Function(ReceiptModel receipt) onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return ReceiptPaperList(
      receipts: receipts,
      heroTagBuilder: (ReceiptModel receipt) =>
          AppRouter.receiptHeroTag('history', receipt.id),
      enableEntranceAnimation: true,
      onOpenReceipt: onOpenDetails,
    );
  }
}
