import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/formatters.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/receipt_card_shell.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

class ReceiptOverviewCard extends StatelessWidget {
  const ReceiptOverviewCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String receiptNumber =
        receipt.receiptInfo.number?.trim().isNotEmpty == true
        ? receipt.receiptInfo.number!.trim()
        : 'RCP-${DateFormat('yyyy-MM-dd').format(receipt.createdAt)}-${receipt.id.substring(0, receipt.id.length >= 3 ? 3 : receipt.id.length).padLeft(3, '0')}';

    final TextTheme textTheme = theme.textTheme;

    return ReceiptCardShell(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const CardLabel(text: 'Receipt Number'),
                    const SizedBox(height: 6),
                    Text(
                      receiptNumber,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                money(receipt.totals.total, receipt.currency),
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.7),
            height: 1,
          ),
          const SizedBox(height: 14),
          ReceiptInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: DateFormat('MMMM d, y').format(receipt.createdAt),
          ),
          const SizedBox(height: 14),
          ReceiptInfoRow(
            icon: Icons.storefront_outlined,
            label: 'Merchant',
            value: receipt.merchant.name.trim().isEmpty
                ? 'Unknown merchant'
                : receipt.merchant.name.trim(),
          ),
          const SizedBox(height: 14),
          ReceiptInfoRow(
            icon: Icons.credit_card_outlined,
            label: 'Payment Method',
            value: receipt.payment.method.trim().isEmpty
                ? 'Unknown'
                : receipt.payment.method.trim(),
          ),
        ],
      ),
    );
  }
}

class ReceiptInfoRow extends StatelessWidget {
  const ReceiptInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InfoIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CardLabel(text: label),
              const SizedBox(height: 2),
              Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoIcon extends StatelessWidget {
  const InfoIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
    );
  }
}

class CardLabel extends StatelessWidget {
  const CardLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
