import 'package:flutter/material.dart';

class ReceiptTopBar extends StatelessWidget {
  const ReceiptTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      height: 72 + topInset,
      padding: EdgeInsets.fromLTRB(18, topInset, 18, 0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Receipt Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
