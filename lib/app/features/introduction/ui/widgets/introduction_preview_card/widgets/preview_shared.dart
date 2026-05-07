import 'package:flutter/material.dart';

class RingPulse extends StatelessWidget {
  const RingPulse({
    required this.scale,
    required this.opacity,
    super.key,
  });

  final double scale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 158,
        height: 158,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: opacity),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class FormatBadge extends StatelessWidget {
  const FormatBadge({
    required this.label,
    required this.color,
    required this.backgroundColor,
    super.key,
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
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}

class AmbientOrb extends StatelessWidget {
  const AmbientOrb({
    required this.alignment,
    required this.size,
    required this.opacity,
    super.key,
  });

  final Alignment alignment;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              colorScheme.primary.withValues(alpha: opacity),
              colorScheme.primary.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
