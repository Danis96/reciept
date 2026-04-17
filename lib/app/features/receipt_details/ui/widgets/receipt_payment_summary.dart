import 'package:flutter/material.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/formatters.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/receipt_card_shell.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

class ReceiptPaymentSummaryCard extends StatelessWidget {
  const ReceiptPaymentSummaryCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    return ReceiptCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Payment Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF273142),
            ),
          ),
          const SizedBox(height: 18),
          PaymentSummaryRow(
            label: 'Subtotal',
            value: money(receipt.totals.subtotal ?? 0, receipt.currency),
          ),
          const SizedBox(height: 12),
          PaymentSummaryRow(
            label: 'Tax',
            value: money(receipt.totals.vatAmount ?? 0, receipt.currency),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE7EDF6), height: 1),
          const SizedBox(height: 14),
          PaymentSummaryRow(
            label: 'Total',
            value: money(receipt.totals.total, receipt.currency),
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class PaymentSummaryRow extends StatelessWidget {
  const PaymentSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final TextStyle? style = emphasize
        ? textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      color: const Color(0xFF111827),
    )
        : textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: const Color(0xFF273142),
    );

    return Row(
      children: <Widget>[
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}
