import 'package:flutter/material.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/formatters.dart';
import 'package:reciep/app/features/receipt_details/ui/widgets/shared/receipt_card_shell.dart';
import 'package:reciep/app/models/receipt/receipt_item_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

class ReceiptItemsCard extends StatelessWidget {
  const ReceiptItemsCard({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return ReceiptCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Items',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          if (receipt.items.isEmpty)
            Text(
              'No items available.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...receipt.items.asMap().entries.map(
              (MapEntry<int, ReceiptItemModel> entry) => ReceiptItemListRow(
                item: entry.value,
                showDivider: entry.key != receipt.items.length - 1,
                currency: receipt.currency,
              ),
            ),
        ],
      ),
    );
  }
}

class ReceiptItemListRow extends StatelessWidget {
  const ReceiptItemListRow({
    super.key,
    required this.item,
    required this.showDivider,
    required this.currency,
  });

  final ReceiptItemModel item;
  final bool showDivider;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: showDivider ? 14 : 0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  item.name.trim().isEmpty ? 'Unnamed item' : item.name.trim(),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                money(item.finalPrice, currency),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Qty: ${qty(item.quantity)}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showDivider) ...<Widget>[
            const SizedBox(height: 14),
            Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.7),
              height: 1,
            ),
          ],
        ],
      ),
    );
  }
}
