import 'package:flutter/material.dart';

import 'package:refyn/theme/app_colors.dart';
import 'preview_shared.dart';

class BudgetsVisual extends StatefulWidget {
  const BudgetsVisual({super.key});

  @override
  State<BudgetsVisual> createState() => _BudgetsVisualState();
}

class _BudgetsVisualState extends State<BudgetsVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _cardFade;
  late final Animation<double> _cardScale;
  late final Animation<double> _bar1;
  late final Animation<double> _bar2;
  late final Animation<double> _badge;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _cardFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.00, 0.40, curve: Curves.easeOut),
    );
    _cardScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.00, 0.40, curve: Curves.easeOutCubic),
      ),
    );
    _bar1 = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.25, 0.60, curve: Curves.easeOutCubic),
    );
    _bar2 = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.38, 0.72, curve: Curves.easeOutCubic),
    );
    _badge = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.55, 0.85, curve: Curves.easeOutBack),
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
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return SizedBox(
          width: 240,
          height: 224,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const RingPulse(scale: 1.06, opacity: 0.08),
              Opacity(
                opacity: _cardFade.value,
                child: Transform.scale(
                  scale: _cardScale.value,
                  child: Container(
                    width: 196,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh
                          .withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: colorScheme.primary
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: colorScheme.primary,
                                size: 19,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'May Budget',
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    '\$320 / \$500',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _BudgetBar(
                          label: 'Groceries',
                          progress: 0.72 * _bar1.value,
                          color: colorScheme.primary,
                          amount: '\$180 / \$250',
                        ),
                        const SizedBox(height: 10),
                        _BudgetBar(
                          label: 'Fuel',
                          progress: 0.56 * _bar2.value,
                          color: AppColors.success,
                          amount: '\$140 / \$250',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 4,
                child: Opacity(
                  opacity: _badge.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset:
                        Offset(0, -10 * (1 - _badge.value.clamp(0.0, 1.0))),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.trending_down_rounded,
                              color: AppColors.lightBackground, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'On track',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.lightBackground,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BudgetBar extends StatelessWidget {
  const _BudgetBar({
    required this.label,
    required this.progress,
    required this.color,
    required this.amount,
  });

  final String label;
  final double progress;
  final Color color;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              amount,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
