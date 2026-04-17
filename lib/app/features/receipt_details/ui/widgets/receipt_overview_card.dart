import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/formatters.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/receipt_card_shell.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/widgets/category_asset_image.dart';

class ReceiptOverviewCard extends StatelessWidget {
  const ReceiptOverviewCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    final String receiptNumber =
    receipt.receiptInfo.number?.trim().isNotEmpty == true
        ? receipt.receiptInfo.number!.trim()
        : 'RCP-${DateFormat('yyyy-MM-dd').format(receipt.createdAt)}-${receipt.id.substring(0, receipt.id.length >= 3 ? 3 : receipt.id.length).padLeft(3, '0')}';

    final textTheme = Theme.of(context).textTheme;

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
                        color: const Color(0xFF273142),
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
                  color: const Color(0xFF111827),
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE7EDF6), height: 1),
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
          const SizedBox(height: 14),
          ReceiptCategoryRow(category: receipt.category),
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
    final textTheme = Theme.of(context).textTheme;
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
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReceiptCategoryRow extends StatelessWidget {
  const ReceiptCategoryRow({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CategoryAssetImage(category: category, size: 28),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CardLabel(text: 'Category'),
              const SizedBox(height: 2),
              Text(
                CategoryBudgetCatalog.labelFor(category),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
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
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
    );
  }
}

class CardLabel extends StatelessWidget {
  const CardLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF6B7A99),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
