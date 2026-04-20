import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciep/app/models/receipt/receipt_item_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/theme/app_spacing.dart';

class ReceiptPaperList extends StatefulWidget {
  const ReceiptPaperList({
    super.key,
    required this.receipts,
    this.onOpenReceipt,
    this.heroTagBuilder,
    this.enableEntranceAnimation = false,
    this.expandFirstByDefault = true,
  });

  final List<ReceiptModel> receipts;
  final Future<void> Function(ReceiptModel receipt)? onOpenReceipt;
  final String? Function(ReceiptModel receipt)? heroTagBuilder;
  final bool enableEntranceAnimation;
  final bool expandFirstByDefault;

  @override
  State<ReceiptPaperList> createState() => _ReceiptPaperListState();
}

class _ReceiptPaperListState extends State<ReceiptPaperList> {
  late Set<String> _expandedReceiptIds;

  @override
  void initState() {
    super.initState();
    _expandedReceiptIds = <String>{
      if (widget.expandFirstByDefault && widget.receipts.isNotEmpty)
        widget.receipts.first.id,
    };
  }

  @override
  void didUpdateWidget(covariant ReceiptPaperList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.receipts != widget.receipts) {
      _expandedReceiptIds = _expandedReceiptIds
          .where(
            (String id) =>
            widget.receipts.any((ReceiptModel item) => item.id == id),
      )
          .toSet();
      if (widget.expandFirstByDefault &&
          _expandedReceiptIds.isEmpty &&
          widget.receipts.isNotEmpty) {
        _expandedReceiptIds.add(widget.receipts.first.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.receipts.asMap().entries.map((
          MapEntry<int, ReceiptModel> entry,
          ) {
        final int index = entry.key;
        final ReceiptModel receipt = entry.value;
        final bool expanded = _expandedReceiptIds.contains(receipt.id);

        final Widget card = Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ReceiptPaperCard(
            receipt: receipt,
            expanded: expanded,
            heroTag: widget.heroTagBuilder?.call(receipt),
            onOpen: widget.onOpenReceipt == null
                ? null
                : () => widget.onOpenReceipt!(receipt),
            onToggleExpanded: () {
              setState(() {
                if (expanded) {
                  _expandedReceiptIds.remove(receipt.id);
                } else {
                  _expandedReceiptIds.add(receipt.id);
                }
              });
            },
          ),
        );

        if (!widget.enableEntranceAnimation) {
          return card;
        }

        return TweenAnimationBuilder<double>(
          key: ValueKey<String>('receipt-paper-${receipt.id}'),
          duration: Duration(milliseconds: 260 + (index * 55).clamp(0, 280)),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (BuildContext context, double value, Widget? child) {
            return Transform.translate(
              offset: Offset(0, 22 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: card,
        );
      }).toList(),
    );
  }
}

class ReceiptPaperCard extends StatelessWidget {
  const ReceiptPaperCard({
    super.key,
    required this.receipt,
    required this.expanded,
    required this.onToggleExpanded,
    this.onOpen,
    this.heroTag,
  });

  final ReceiptModel receipt;
  final bool expanded;
  final Future<void> Function()? onOpen;
  final VoidCallback onToggleExpanded;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String merchant = receipt.merchant.name.trim().isEmpty
        ? 'STORE'
        : receipt.merchant.name.trim().toUpperCase();
    final int itemCount = receipt.items.length;
    final int quantityCount = receipt.items
        .fold<double>(
      0,
          (double sum, ReceiptItemModel item) => sum + item.quantity,
    )
        .round();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onOpen == null ? null : () => onOpen!(),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: ReceiptPaperPalette.border(context)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ReceiptPerforation(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Column(
                  children: <Widget>[
                    heroTag == null
                        ? ReceiptPaperText.header(merchant)
                        : Hero(
                      tag: heroTag!,
                      child: Material(
                        color: Colors.transparent,
                        child: ReceiptPaperText.header(merchant),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ReceiptPaperText.meta(
                      DateFormat('EEE, MMM d, yyyy').format(receipt.createdAt),
                    ),
                    const SizedBox(height: 2),
                    ReceiptPaperText.meta(
                      DateFormat('hh:mm a').format(receipt.createdAt),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Divider(
                      color: ReceiptPaperPalette.border(context),
                      height: 1,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ReceiptTotalsRow(
                      label: 'ITEMS ($itemCount)',
                      value: '$quantityCount x',
                      emphasized: false,
                    ),

                    // ── Animated expandable items + subtotal/tax section ──
                    AnimatedSize(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeInOutCubic,
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: expanded
                            ? <Widget>[
                          const SizedBox(height: AppSpacing.xs),
                          ...receipt.items.map(
                                (ReceiptItemModel item) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: ReceiptItemRow(item: item),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Divider(
                            color: ReceiptPaperPalette.border(context),
                            height: 1,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ReceiptTotalsRow(
                            label: 'SUBTOTAL:',
                            value:
                            '${ReceiptPaperMoney.format(receipt.totals.subtotal ?? 0)} ${ReceiptPaperMoney.currencyLabel(receipt.currency)}',
                            emphasized: false,
                          ),
                          const SizedBox(height: 4),
                          ReceiptTotalsRow(
                            label: 'TAX:',
                            value:
                            '${ReceiptPaperMoney.format(receipt.totals.vatAmount ?? 0)} ${ReceiptPaperMoney.currencyLabel(receipt.currency)}',
                            emphasized: false,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ]
                            : const <Widget>[SizedBox(height: AppSpacing.xs)],
                      ),
                    ),

                    Divider(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.72,
                      ),
                      height: 1,
                      thickness: 1.4,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ReceiptTotalsRow(
                      label: 'TOTAL:',
                      value:
                      '${ReceiptPaperMoney.format(receipt.totals.total)} ${ReceiptPaperMoney.currencyLabel(receipt.currency)}',
                      emphasized: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ReceiptConfidencePill(confidence: receipt.confidence),
                    const SizedBox(height: AppSpacing.sm),

                    // ── Animated toggle button ──
                    TextButton(
                      onPressed: onToggleExpanded,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface
                            .withValues(alpha: 0.52),
                        textStyle: ReceiptPaperText.buttonStyle(context),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 200),
                            crossFadeState: expanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: Text(
                              'SHOW MORE',
                              style: ReceiptPaperText.buttonStyle(context)
                                  .copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.52),
                              ),
                            ),
                            secondChild: Text(
                              'SHOW LESS',
                              style: ReceiptPaperText.buttonStyle(context)
                                  .copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.52),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: expanded ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeInOutCubic,
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Animated footer (Receipt ID + Thank You) ──
                    AnimatedSize(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOutCubic,
                      alignment: Alignment.topCenter,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 240),
                        opacity: expanded ? 1.0 : 0.0,
                        child: expanded
                            ? Column(
                          children: <Widget>[
                            const SizedBox(height: AppSpacing.sm),
                            Divider(
                              color: ReceiptPaperPalette.border(context),
                              height: 1,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ReceiptPaperText.footer(
                                'RECEIPT ID: ${receipt.id}'),
                            const SizedBox(height: 4),
                            const ReceiptPaperText.footer('THANK YOU!'),
                          ],
                        )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              const ReceiptPerforation(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiptPerforation extends StatelessWidget {
  const ReceiptPerforation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(
          22,
              (int index) => Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.18),
            ),
          ),
        ),
      ),
    );
  }
}

class ReceiptItemRow extends StatelessWidget {
  const ReceiptItemRow({super.key, required this.item});

  final ReceiptItemModel item;

  @override
  Widget build(BuildContext context) {
    final String quantityLabel = item.quantity % 1 == 0
        ? item.quantity.toStringAsFixed(0)
        : item.quantity.toStringAsFixed(2);
    final String name = item.name.trim().isEmpty ? 'Item' : item.name.trim();

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '$quantityLabel x $name',
            style: ReceiptPaperText.item(context),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '${ReceiptPaperMoney.format(item.finalPrice)} ${ReceiptPaperMoney.currencyLabel('BAM')}',
          style: ReceiptPaperText.itemValue(context),
        ),
      ],
    );
  }
}

class ReceiptTotalsRow extends StatelessWidget {
  const ReceiptTotalsRow({
    super.key,
    required this.label,
    required this.value,
    required this.emphasized,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: emphasized
                ? ReceiptPaperText.total(context)
                : ReceiptPaperText.rowLabel(context),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: emphasized
              ? ReceiptPaperText.total(context)
              : ReceiptPaperText.rowValue(context),
        ),
      ],
    );
  }
}

class ReceiptConfidencePill extends StatelessWidget {
  const ReceiptConfidencePill({super.key, required this.confidence});

  final double confidence;

  @override
  Widget build(BuildContext context) {
    final int percent = confidence <= 1
        ? (confidence * 100).round().clamp(0, 100)
        : confidence.round().clamp(0, 100);
    final bool high = percent >= 95;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: high ? const Color(0xFFDDF5E3) : const Color(0xFFF9E9A8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$percent% SCAN CONFIDENCE',
        style: ReceiptPaperText.confidence(
          context,
          color: high ? const Color(0xFF2F9B53) : const Color(0xFFBE8A14),
        ),
      ),
    );
  }
}

class ReceiptPaperText extends StatelessWidget {
  const ReceiptPaperText._({
    required this.text,
    required this.textAlign,
    required this.style,
  });

  final String text;
  final TextAlign textAlign;
  final TextStyle? style;

  const ReceiptPaperText.header(String text)
      : this._(text: text, textAlign: TextAlign.center, style: null);
  const ReceiptPaperText.meta(String text)
      : this._(text: text, textAlign: TextAlign.center, style: null);
  const ReceiptPaperText.muted(String text)
      : this._(text: text, textAlign: TextAlign.left, style: null);
  const ReceiptPaperText.footer(String text)
      : this._(text: text, textAlign: TextAlign.center, style: null);

  @override
  Widget build(BuildContext context) {
    TextStyle? resolvedStyle = style;
    if (resolvedStyle == null) {
      if (textAlign == TextAlign.center && text.contains('STORE')) {
        resolvedStyle = headerStyle(context);
      } else if (textAlign == TextAlign.center &&
          text.contains('RECEIPT ID:')) {
        resolvedStyle = footerStyle(context);
      } else if (textAlign == TextAlign.center && text == 'THANK YOU!') {
        resolvedStyle = footerStyle(context);
      } else if (textAlign == TextAlign.center) {
        resolvedStyle = metaStyle(context);
      } else {
        resolvedStyle = mutedStyle(context);
      }
    }

    return Text(text, textAlign: textAlign, style: resolvedStyle);
  }

  static TextStyle base(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontFamily: 'monospace',
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.88),
    );
  }

  static TextStyle headerStyle(BuildContext context) {
    return base(context).copyWith(
      fontSize: 22,
      height: 1.0,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.1,
    );
  }

  static TextStyle metaStyle(BuildContext context) {
    return base(context).copyWith(
      fontSize: 13,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
    );
  }

  static TextStyle mutedStyle(BuildContext context) {
    return base(context).copyWith(
      fontSize: 12,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
    );
  }

  static TextStyle footerStyle(BuildContext context) {
    return base(context).copyWith(
      fontSize: 11,
      height: 1.2,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.9,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.42),
    );
  }

  static TextStyle item(BuildContext context) {
    return base(context).copyWith(fontSize: 13, fontWeight: FontWeight.w700);
  }

  static TextStyle itemValue(BuildContext context) {
    return base(context).copyWith(fontSize: 14, fontWeight: FontWeight.w800);
  }

  static TextStyle rowLabel(BuildContext context) {
    return base(context).copyWith(fontSize: 14, fontWeight: FontWeight.w800);
  }

  static TextStyle rowValue(BuildContext context) {
    return base(context).copyWith(fontSize: 14, fontWeight: FontWeight.w800);
  }

  static TextStyle total(BuildContext context) {
    return base(context).copyWith(
      fontSize: 19,
      height: 1.0,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.6,
    );
  }

  static TextStyle confidence(BuildContext context, {required Color color}) {
    return base(context).copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w900,
      letterSpacing: 0.8,
      color: color,
    );
  }

  static TextStyle buttonStyle(BuildContext context) {
    return base(context).copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.8,
    );
  }
}

class ReceiptPaperMoney {
  const ReceiptPaperMoney._();

  static String format(double value) {
    return NumberFormat('0.00').format(value);
  }

  static String currencyLabel(String currency) {
    return 'KM';
  }
}

class ReceiptPaperPalette {
  const ReceiptPaperPalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color border(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.18 : 0.08);
  }

}
