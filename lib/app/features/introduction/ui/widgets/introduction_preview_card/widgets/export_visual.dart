import 'package:flutter/material.dart';

import 'package:refyn/theme/app_colors.dart';
import 'preview_shared.dart';

class ExportVisual extends StatefulWidget {
  const ExportVisual({super.key});

  @override
  State<ExportVisual> createState() => _ExportVisualState();
}

class _ExportVisualState extends State<ExportVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _cardFade;
  late final Animation<double> _cardScale;
  late final Animation<double> _chip;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _cardFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.00, 0.50, curve: Curves.easeOut),
    );
    _cardScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.00, 0.50, curve: Curves.easeOut),
      ),
    );
    _chip = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
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
        return SizedBox(
          width: 232,
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
                    width: 172,
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
                                Icons.description_rounded,
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
                                    'May Report',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    '12 receipts',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(
                          3,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Container(
                              height: 5,
                              width: 128.0 - i * 22,
                              decoration: BoxDecoration(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.09),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            FormatBadge(
                              label: 'PDF',
                              color: AppColors.success,
                              backgroundColor: AppColors.success.withValues(alpha: 0.12),
                            ),
                            const SizedBox(width: 6),
                            FormatBadge(
                              label: 'CSV',
                              color: AppColors.success,
                              backgroundColor:
                                  AppColors.success.withValues(alpha: 0.12),
                            ),
                            const Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(Icons.ios_share_rounded,
                                  color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 8,
                child: Opacity(
                  opacity: _chip.value,
                  child: Transform.translate(
                    offset: Offset(0, -10 * (1 - _chip.value)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: AppColors.lightBackground, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'Ready',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
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
