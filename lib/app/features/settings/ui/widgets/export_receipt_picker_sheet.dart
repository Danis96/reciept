import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/theme/app_spacing.dart';

class ExportReceiptPickerSheet extends StatefulWidget {
  const ExportReceiptPickerSheet({
    super.key,
    required this.receipts,
  });

  final List<ReceiptModel> receipts;

  @override
  State<ExportReceiptPickerSheet> createState() =>
      _ExportReceiptPickerSheetState();
}

class _ExportReceiptPickerSheetState extends State<ExportReceiptPickerSheet> {
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.receipts.map((r) => r.id).toSet();
  }

  bool get _allSelected => _selectedIds.length == widget.receipts.length;

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(widget.receipts.map((r) => r.id));
      }
    });
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _confirm() {
    final List<ReceiptModel> selected = widget.receipts
        .where((r) => _selectedIds.contains(r.id))
        .toList(growable: false);
    Navigator.of(context).pop(selected);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MediaQueryData mq = MediaQuery.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 34 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(
            color: colorScheme.onSurface.withValues(
              alpha: isDark ? 0.22 : 0.12,
            ),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: mq.size.height * 0.82),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 46,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SheetHeader(
                      selectedCount: _selectedIds.length,
                      totalCount: widget.receipts.length,
                      allSelected: _allSelected,
                      onToggleAll: _toggleAll,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  shrinkWrap: true,
                  itemCount: widget.receipts.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (BuildContext context, int index) {
                    final ReceiptModel receipt = widget.receipts[index];
                    final bool selected = _selectedIds.contains(receipt.id);
                    return _ReceiptTile(
                      receipt: receipt,
                      selected: selected,
                      onTap: () => _toggle(receipt.id),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md + mq.padding.bottom,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _selectedIds.isEmpty ? null : _confirm,
                    child: Text(
                      _selectedIds.isEmpty
                          ? context.l10n.export
                          : '${context.l10n.export} (${_selectedIds.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _selectedIds.isEmpty
                            ? colorScheme.onSurface.withValues(alpha: 0.38)
                            : colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.selectedCount,
    required this.totalCount,
    required this.allSelected,
    required this.onToggleAll,
  });

  final int selectedCount;
  final int totalCount;
  final bool allSelected;
  final VoidCallback onToggleAll;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.export,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$selectedCount / $totalCount',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onToggleAll,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: allSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              allSelected ? context.l10n.cancel : 'All',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: allSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({
    required this.receipt,
    required this.selected,
    required this.onTap,
  });

  final ReceiptModel receipt;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final String merchant = receipt.merchant.name.isNotEmpty
        ? receipt.merchant.name
        : 'Unknown';
    final String date = DateFormat.yMMMd().format(receipt.createdAt);
    final String total =
        '${receipt.totals.total.toStringAsFixed(2)} ${receipt.currency}';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer.withValues(
                  alpha: isDark ? 0.36 : 0.48,
                )
              : colorScheme.onSurface.withValues(
                  alpha: isDark ? 0.08 : 0.03,
                ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.5)
                : colorScheme.onSurface.withValues(
                    alpha: isDark ? 0.16 : 0.08,
                  ),
          ),
        ),
        child: Row(
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: selected
                    ? colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    merchant,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              total,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
