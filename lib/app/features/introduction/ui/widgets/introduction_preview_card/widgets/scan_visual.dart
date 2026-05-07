import 'package:flutter/material.dart';

import 'preview_shared.dart';

class ScanVisual extends StatefulWidget {
  const ScanVisual({super.key});

  @override
  State<ScanVisual> createState() => _ScanVisualState();
}

class _ScanVisualState extends State<ScanVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _receiptIn;
  late final Animation<double> _trayIn;
  late final Animation<double> _scanIn;
  late final Animation<double> _badgeIn;
  late final Animation<double> _buttonIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 980),
    );
    _receiptIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.34, curve: Curves.easeOutCubic),
    );
    _trayIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.16, 0.52, curve: Curves.easeOutCubic),
    );
    _scanIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.36, 0.82, curve: Curves.easeInOut),
    );
    _badgeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.52, 0.90, curve: Curves.easeOutBack),
    );
    _buttonIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.62, 1.00, curve: Curves.easeOutBack),
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
    final double scanY = 70 + (_scanIn.value * 56);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final double receiptOpacity = _receiptIn.value.clamp(0.0, 1.0);
        final double trayOpacity = _trayIn.value.clamp(0.0, 1.0);
        final double scanOpacity = _scanIn.value.clamp(0.0, 1.0);
        final double badgeOpacity = _badgeIn.value.clamp(0.0, 1.0);
        final double buttonOpacity = _buttonIn.value.clamp(0.0, 1.0);
        return SizedBox(
          width: 226,
          height: 188,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: RingPulse(scale: 1.12, opacity: 0.07),
                ),
              ),
              Positioned(
                top: 18 + (10 * (1 - _trayIn.value)),
                child: Opacity(
                  opacity: trayOpacity,
                  child: _CaptureStage(colorScheme: colorScheme),
                ),
              ),
              Positioned(
                top: 30 + (18 * (1 - _receiptIn.value)),
                child: Opacity(
                  opacity: receiptOpacity,
                  child: Transform.rotate(
                    angle: -0.09,
                    child: _FloatingReceipt(colorScheme: colorScheme),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                right: 40,
                top: scanY,
                child: Opacity(
                  opacity: scanOpacity,
                  child: _ScanBeam(colorScheme: colorScheme),
                ),
              ),
              Positioned(
                top: 10 - (4 * (1 - _badgeIn.value)),
                right: 12,
                child: Opacity(
                  opacity: badgeOpacity,
                  child: Transform.scale(
                    scale: 0.92 + (0.08 * badgeOpacity),
                    child: _CaptureBadge(colorScheme: colorScheme),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                child: Opacity(
                  opacity: buttonOpacity,
                  child: Transform.scale(
                    scale: 0.88 + (0.12 * buttonOpacity),
                    child: _ShutterButton(colorScheme: colorScheme),
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

class _CaptureStage extends StatelessWidget {
  const _CaptureStage({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 178,
      height: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 94,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: _CornerMark(color: colorScheme.primary, top: true, left: true),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: _CornerMark(color: colorScheme.primary, top: true, left: false),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: _CornerMark(color: colorScheme.primary, top: false, left: true),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: _CornerMark(color: colorScheme.primary, top: false, left: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingReceipt extends StatelessWidget {
  const _FloatingReceipt({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'RECEIPT',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Fresh\nMarket',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 8),
          ...List<Widget>.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Container(
                height: 3,
                width: 52 - (index * 8),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(
                    alpha: index == 0 ? 0.20 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '\$42.85',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
                fontSize: 9.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanBeam extends StatelessWidget {
  const _ScanBeam({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            colorScheme.primary.withValues(alpha: 0),
            colorScheme.primary.withValues(alpha: 0.16),
            colorScheme.primary.withValues(alpha: 0.55),
            colorScheme.primary.withValues(alpha: 0.16),
            colorScheme.primary.withValues(alpha: 0),
          ],
        ),
      ),
      child: Center(
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                colorScheme.primary.withValues(alpha: 0),
                colorScheme.primary.withValues(alpha: 0.9),
                colorScheme.primary.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CaptureBadge extends StatelessWidget {
  const _CaptureBadge({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flash_on_rounded,
            size: 13,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 5),
          Text(
            'One tap',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary.withValues(alpha: 0.12),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.26),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          Icons.camera_alt_rounded,
          color: colorScheme.onPrimary,
          size: 21,
        ),
      ),
    );
  }
}

class _CornerMark extends StatelessWidget {
  const _CornerMark({
    required this.color,
    required this.top,
    required this.left,
  });

  final Color color;
  final bool top;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(
        painter: _CornerMarkPainter(
          color: color,
          top: top,
          left: left,
        ),
      ),
    );
  }
}

class _CornerMarkPainter extends CustomPainter {
  const _CornerMarkPainter({
    required this.color,
    required this.top,
    required this.left,
  });

  final Color color;
  final bool top;
  final bool left;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    if (top && left) {
      path
        ..moveTo(size.width, 0)
        ..lineTo(0, 0)
        ..lineTo(0, size.height);
    } else if (top && !left) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height);
    } else if (!top && left) {
      path
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height);
    } else {
      path
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerMarkPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.top != top ||
        oldDelegate.left != left;
  }
}
