import 'package:flutter/material.dart';

import 'preview_shared.dart';

class AiVisual extends StatefulWidget {
  const AiVisual({super.key});

  @override
  State<AiVisual> createState() => _AiVisualState();
}

class _AiVisualState extends State<AiVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _receiptIn;
  late final Animation<double> _signalIn;
  late final Animation<double> _resultIn;
  late final Animation<double> _badgeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _receiptIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.38, curve: Curves.easeOutCubic),
    );
    _signalIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.62, curve: Curves.easeOutCubic),
    );
    _resultIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.36, 0.82, curve: Curves.easeOutCubic),
    );
    _badgeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.64, 1.00, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: 222,
          height: 168,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: RingPulse(scale: 1.16, opacity: 0.06),
                ),
              ),
              Positioned(
                left: 2,
                top: 36 - (7 * (1 - _receiptIn.value)),
                child: Opacity(
                  opacity: _receiptIn.value,
                  child: _SourceReceiptCard(colorScheme: colorScheme),
                ),
              ),
              Positioned(
                left: 63,
                top: 74,
                child: Opacity(
                  opacity: _signalIn.value,
                  child: _SignalBridge(
                    progress: _signalIn.value,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 2 + (10 * (1 - _resultIn.value)),
                child: Opacity(
                  opacity: _resultIn.value,
                  child: _StructuredResultCard(colorScheme: colorScheme),
                ),
              ),
              Positioned(
                right: 92,
                bottom: 4 - (5 * (1 - _badgeIn.value)),
                child: Opacity(
                  opacity: _badgeIn.value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.9 + (0.1 * _badgeIn.value.clamp(0.0, 1.0)),
                    child: _InsightBadge(colorScheme: colorScheme),
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

class _SourceReceiptCard extends StatelessWidget {
  const _SourceReceiptCard({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.rotate(
      angle: -0.08,
      child: Container(
        width: 74,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RECEIPT',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                fontSize: 8.5,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'FRESH\nMARKET',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.0,
                fontSize: 9.5,
              ),
            ),
            const SizedBox(height: 7),
            ...List<Widget>.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  height: 2.6,
                  width: 50 - (index * 7),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(
                      alpha: index == 3 ? 0.12 : 0.18,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '\$42.85',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 8.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalBridge extends StatelessWidget {
  const _SignalBridge({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 22,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  color.withValues(alpha: 0),
                  color.withValues(alpha: 0.28),
                  color.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List<Widget>.generate(4, (index) {
              final double threshold = (index + 1) / 4;
              final bool active = progress >= threshold - 0.14;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: active ? 8 : 5,
                height: active ? 8 : 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? color
                      : color.withValues(alpha: 0.18),
                  boxShadow: active
                      ? <BoxShadow>[
                          BoxShadow(
                            color: color.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StructuredResultCard extends StatelessWidget {
  const _StructuredResultCard({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 128,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: colorScheme.primary,
                  size: 14,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Parse',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const _ResultRow(
            label: 'Merchant',
            value: 'Fresh Market',
            emphasize: true,
          ),
          const SizedBox(height: 6),
          const _ResultRow(label: 'Category', value: 'Groceries'),
          const SizedBox(height: 6),
          const _ResultRow(label: 'Items', value: '5 detected'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w700,
                    fontSize: 9.5,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$42.85',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            fontSize: 8.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: (emphasize
                  ? theme.textTheme.titleMedium
                  : theme.textTheme.labelLarge)
              ?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: emphasize ? 11 : 10,
              ),
        ),
      ],
    );
  }
}

class _InsightBadge extends StatelessWidget {
  const _InsightBadge({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: colorScheme.primary,
            size: 10,
          ),
          const SizedBox(width: 4),
          Text(
            'Auto-categorized',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }
}
