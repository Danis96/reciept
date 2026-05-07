import 'package:flutter/material.dart';

import 'package:refyn/theme/app_colors.dart';

class OrganizeVisual extends StatefulWidget {
  const OrganizeVisual({super.key});

  @override
  State<OrganizeVisual> createState() => _OrganizeVisualState();
}

class _OrganizeVisualState extends State<OrganizeVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _header;
  late final Animation<double> _row1;
  late final Animation<double> _row2;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _header = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.00, 0.40, curve: Curves.easeOut),
    );
    _row1 = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.15, 0.52, curve: Curves.easeOutCubic),
    );
    _row2 = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.30, 0.67, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 244,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: _header.value,
                  child: Transform.translate(
                    offset: Offset(0, -12 * (1 - _header.value)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh
                            .withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'May 2026',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onSurface,
                                ),
                          ),
                          const Spacer(),
                          _StatusChip(
                            label: '3 receipts',
                            color: AppColors.success,
                            backgroundColor:
                                AppColors.success.withValues(alpha: 0.12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: _row1.value,
                  child: Transform.translate(
                    offset: Offset(20 * (1 - _row1.value), 0),
                    child: _ReceiptRow(
                      icon: Icons.shopping_bag_rounded,
                      title: 'Fresh Market',
                      amount: '\$42.85',
                      category: 'Groceries',
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Opacity(
                  opacity: _row2.value,
                  child: Transform.translate(
                    offset: Offset(20 * (1 - _row2.value), 0),
                    child: _ReceiptRow(
                      icon: Icons.local_gas_station_rounded,
                      title: 'Shell Station',
                      amount: '\$58.20',
                      category: 'Fuel',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.icon,
    required this.title,
    required this.amount,
    required this.category,
  });

  final IconData icon;
  final String title;
  final String amount;
  final String category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 3),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
