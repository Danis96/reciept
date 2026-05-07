import 'package:flutter/material.dart';

import 'preview_shared.dart';

class PrivacyVisual extends StatefulWidget {
  const PrivacyVisual({super.key});

  @override
  State<PrivacyVisual> createState() => _PrivacyVisualState();
}

class _PrivacyVisualState extends State<PrivacyVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rings;
  late final Animation<double> _icon;
  late final Animation<double> _lock;
  late final Animation<double> _chip1;
  late final Animation<double> _chip2;
  late final Animation<double> _chip3;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _rings = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.00, 0.45, curve: Curves.easeOut),
    );
    _icon = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.15, 0.65, curve: Curves.elasticOut),
    );
    _lock = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.52, 0.75, curve: Curves.easeOutBack),
    );
    _chip1 = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.56, 0.82, curve: Curves.easeOutCubic),
    );
    _chip2 = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.65, 0.90, curve: Curves.easeOutCubic),
    );
    _chip3 = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.74, 0.98, curve: Curves.easeOutCubic),
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
          width: 224,
          height: 224,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: _rings.value,
                child: Transform.scale(
                  scale: _rings.value,
                  child: const RingPulse(scale: 1.18, opacity: 0.08),
                ),
              ),
              Opacity(
                opacity: _rings.value,
                child: Transform.scale(
                  scale: _rings.value,
                  child: const RingPulse(scale: 0.82, opacity: 0.05),
                ),
              ),
              Transform.scale(
                scale: _icon.value,
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Image.asset(
                          'assets/app_icon/receipt_app_icon_clean.png',
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Transform.scale(
                          scale: _lock.value,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.surface,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.30),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.lock_rounded,
                                color: Colors.white, size: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 0,
                child: Opacity(
                  opacity: _chip1.value,
                  child: Transform.translate(
                    offset: Offset(-10 * (1 - _chip1.value), 0),
                    child: const _PrivacyChip(
                      icon: Icons.phone_android_rounded,
                      label: 'Local storage',
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 0,
                child: Opacity(
                  opacity: _chip2.value,
                  child: Transform.translate(
                    offset: Offset(10 * (1 - _chip2.value), 0),
                    child: const _PrivacyChip(
                      icon: Icons.auto_awesome_rounded,
                      label: 'AI scanning',
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                child: Opacity(
                  opacity: _chip3.value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - _chip3.value)),
                    child: const _PrivacyChip(
                      icon: Icons.no_accounts_rounded,
                      label: 'No accounts',
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

class _PrivacyChip extends StatelessWidget {
  const _PrivacyChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant),
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
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
