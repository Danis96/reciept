import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

///
/// Layout — compact horizontal card:
///   ┌──────────────────────────────────────────┐
///   │  ┌──────────┐  header + % + progress     │
///   │  │  image   │  ─────────────────────      │
///   │  │ + scan   │  • step 1                   │
///   │  │ overlay  │  • step 2  ← active         │
///   │  └──────────┘  ○ step 3                   │
///   └──────────────────────────────────────────┘
///
/// Entry sequence (1 100 ms one-shot):
///   0 – 420 ms   card slides up from below + scale pop (easeOutBack)
///   220 – 720 ms scan overlay wipes left→right across thumbnail
///   440 – 820 ms right panel fades + slides in from right
///   560 – 1100ms step rows stagger in one-by-one
///
/// Loop animations:
///   scan line sweeps top↔bottom (ping-pong, 2 s)
///   concentric pulse rings (1.8 s reverse)
///   5 particles orbit the centre (4 s)
///   progress-bar shimmer (1.5 s)
///
/// 100 % theme-aware — every colour comes from [ColorScheme].
class PremiumScanLoadingPanel extends StatefulWidget {
  const PremiumScanLoadingPanel({
    super.key,
    required this.imagePath,
    required this.loadingStep,
    required this.steps,
  });

  final String? imagePath;
  final int loadingStep;
  final List<String> steps;

  @override
  State<PremiumScanLoadingPanel> createState() =>
      _PremiumScanLoadingPanelState();
}

class _PremiumScanLoadingPanelState extends State<PremiumScanLoadingPanel>
    with TickerProviderStateMixin {
  // ── One-shot entry ───────────────────────────────────────────
  late final AnimationController _entryCtrl;
  late final Animation<double> _cardSlide;
  late final Animation<double> _cardScale;
  late final Animation<double> _scanReveal;
  late final Animation<double> _panelFade;
  late final Animation<Offset> _panelSlide;

  // ── Looping ──────────────────────────────────────────────────
  late final AnimationController _scanCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _orbitCtrl;
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();

    // Entry 1 100 ms
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _cardSlide = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.42, curve: Curves.easeOutBack),
    );

    _cardScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.80, end: 1.04)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.04, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 55,
      ),
    ]).animate(CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.50),
    ));

    _scanReveal = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.20, 0.68, curve: Curves.easeOutCubic),
    );

    _panelFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.40, 0.80, curve: Curves.easeOut),
    );

    _panelSlide = Tween<Offset>(
      begin: const Offset(0.10, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.40, 0.82, curve: Curves.easeOutCubic),
    ));

    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    _orbitCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final int clamped = widget.loadingStep.clamp(0, widget.steps.length);
    final double progress =
    widget.steps.isEmpty ? 0 : clamped / widget.steps.length;

    // All colours from the theme
    final Color accent = cs.primary;
    final Color scanBg = isDark
        ? Color.lerp(cs.surface, Colors.black, 0.60)!
        : Color.lerp(cs.surface, cs.primary, 0.07)!;

    return AnimatedBuilder(
      animation: _entryCtrl,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, 44 * (1 - _cardSlide.value)),
          child: Opacity(
            opacity: _cardSlide.value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: _cardScale.value,
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest
                      .withValues(alpha: isDark ? 0.55 : 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.20),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: isDark ? 0.10 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Compact scan thumbnail ───────────────────
                    _ScanThumbnail(
                      imagePath: widget.imagePath,
                      scanReveal: _scanReveal,
                      scanAnim: _scanCtrl,
                      pulseAnim: _pulseCtrl,
                      orbitAnim: _orbitCtrl,
                      accent: accent,
                      scanBg: scanBg,
                    ),

                    const SizedBox(width: 14),

                    // ── Right panel ─────────────────────────────
                    Expanded(
                      child: SlideTransition(
                        position: _panelSlide,
                        child: FadeTransition(
                          opacity: _panelFade,
                          child: _RightPanel(
                            steps: widget.steps,
                            loadingStep: clamped,
                            progress: progress,
                            pulseAnim: _pulseCtrl,
                            shimmerAnim: _shimmerCtrl,
                            entryValue: _entryCtrl.value,
                            accent: accent,
                            onSurface: cs.onSurface,
                            secondary: cs.secondary,
                            tertiaryColor: cs.tertiary,
                            progressBg:
                            cs.secondary.withValues(alpha: 0.14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Scan Thumbnail  (110 × 148 px compact card on the left)
// ══════════════════════════════════════════════════════════════════

class _ScanThumbnail extends StatelessWidget {
  const _ScanThumbnail({
    required this.imagePath,
    required this.scanReveal,
    required this.scanAnim,
    required this.pulseAnim,
    required this.orbitAnim,
    required this.accent,
    required this.scanBg,
  });

  final String? imagePath;
  final Animation<double> scanReveal;
  final Animation<double> scanAnim;
  final Animation<double> pulseAnim;
  final Animation<double> orbitAnim;
  final Color accent;
  final Color scanBg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 148,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Receipt image (base layer, always visible)
            if (imagePath != null)
              Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _FallbackBg(color: scanBg, accent: accent),
              )
            else
              _FallbackBg(color: scanBg, accent: accent),

            // Scan overlay wipes left → right over the image
            AnimatedBuilder(
              animation: scanReveal,
              builder: (_, __) {
                return ClipRect(
                  clipper: _LeftWipeClipper(scanReveal.value),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Tinted backing
                      ColoredBox(
                        color: scanBg.withValues(alpha: 0.80),
                      ),
                      // Dot grid
                      CustomPaint(
                          painter: _DotGridPainter(accent)),
                      // Orbiting particles
                      AnimatedBuilder(
                        animation: orbitAnim,
                        builder: (_, __) => CustomPaint(
                          painter: _OrbitPainter(
                            progress: orbitAnim.value,
                            color: accent,
                          ),
                        ),
                      ),
                      // Corner brackets
                      CustomPaint(
                          painter: _BracketPainter(accent)),
                      // Sweeping scan line
                      AnimatedBuilder(
                        animation: scanAnim,
                        builder: (_, __) => CustomPaint(
                          painter: _ScanLinePainter(
                            progress: scanAnim.value,
                            color: accent,
                          ),
                        ),
                      ),
                      // Pulsing rings
                      AnimatedBuilder(
                        animation: pulseAnim,
                        builder: (_, __) => Center(
                          child: CustomPaint(
                            painter: _PulseRingPainter(
                              pulse: pulseAnim.value,
                              color: accent,
                            ),
                            size: const Size(52, 52),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Bright wipe-edge flash
            AnimatedBuilder(
              animation: scanReveal,
              builder: (_, __) {
                final double v = scanReveal.value;
                if (v <= 0 || v >= 1) return const SizedBox.shrink();
                return Positioned(
                  left: v * 110 - 12,
                  top: 0,
                  bottom: 0,
                  width: 24,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          accent.withValues(alpha: 0.70),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackBg extends StatelessWidget {
  const _FallbackBg({required this.color, required this.accent});
  final Color color;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Center(
        child: Icon(Icons.receipt_long_outlined,
            size: 36, color: accent.withValues(alpha: 0.35)),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Right Panel
// ══════════════════════════════════════════════════════════════════

class _RightPanel extends StatelessWidget {
  const _RightPanel({
    required this.steps,
    required this.loadingStep,
    required this.progress,
    required this.pulseAnim,
    required this.shimmerAnim,
    required this.entryValue,
    required this.accent,
    required this.onSurface,
    required this.secondary,
    required this.tertiaryColor,
    required this.progressBg,
  });

  final List<String> steps;
  final int loadingStep;
  final double progress;
  final Animation<double> pulseAnim;
  final Animation<double> shimmerAnim;
  final double entryValue;
  final Color accent;
  final Color onSurface;
  final Color secondary;
  final Color tertiaryColor;
  final Color progressBg;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header row: live dot + label + %
        Row(
          children: [
            AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(
                          alpha: 0.45 + pulseAnim.value * 0.45),
                      blurRadius: 5 + pulseAnim.value * 5,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Scanning…',
                style: tt.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: tt.labelSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        // Slim progress bar
        _ProgressBar(
          progress: progress,
          shimmerAnim: shimmerAnim,
          accent: accent,
          tertiaryColor: tertiaryColor,
          bgColor: progressBg,
        ),

        const SizedBox(height: 10),

        // Steps — stagger in as entryValue crosses each threshold
        ...List.generate(steps.length, (i) {
          final bool done = i < loadingStep;
          final bool active =
              i == loadingStep && loadingStep < steps.length;

          // Each step appears ~70 ms after the previous
          final double start = 0.52 + i * 0.07;
          final double localT =
          ((entryValue - start) / (1.0 - start)).clamp(0.0, 1.0);
          final double opacity = Curves.easeOut.transform(localT);

          return Transform.translate(
            offset: Offset((1 - opacity) * 10, 0),
            child: Opacity(
              opacity: opacity,
              child: _StepRow(
                title: steps[i],
                done: done,
                active: active,
                pulseAnim: pulseAnim,
                accent: accent,
                secondary: secondary,
                onSurface: onSurface,
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Progress Bar
// ══════════════════════════════════════════════════════════════════

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.progress,
    required this.shimmerAnim,
    required this.accent,
    required this.tertiaryColor,
    required this.bgColor,
  });

  final double progress;
  final Animation<double> shimmerAnim;
  final Color accent;
  final Color tertiaryColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double filled =
          constraints.maxWidth * progress.clamp(0.0, 1.0);
      return Container(
        height: 6,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              width: filled,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: [accent, tertiaryColor],
                ),
              ),
            ),
            if (progress > 0 && progress < 1)
              AnimatedBuilder(
                animation: shimmerAnim,
                builder: (_, __) {
                  final double sx =
                      shimmerAnim.value * filled - 20;
                  return Positioned(
                    left: sx,
                    top: 0,
                    bottom: 0,
                    width: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.40),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      );
    });
  }
}

// ══════════════════════════════════════════════════════════════════
//  Step Row
// ══════════════════════════════════════════════════════════════════

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.title,
    required this.done,
    required this.active,
    required this.pulseAnim,
    required this.accent,
    required this.secondary,
    required this.onSurface,
  });

  final String title;
  final bool done;
  final bool active;
  final Animation<double> pulseAnim;
  final Color accent;
  final Color secondary;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    // Done colour: tint the theme accent toward green
    final Color doneColor =
    Color.lerp(accent, const Color(0xFF22C77A), 0.68)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding:
        const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: active ? accent.withValues(alpha: 0.09) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: done
                  ? Icon(Icons.check_circle_rounded,
                  color: doneColor, size: 16)
                  : active
                  ? AnimatedBuilder(
                animation: pulseAnim,
                builder: (_, __) {
                  final double s = 0.70 +
                      (pulseAnim.value - 0.5).abs() * 0.60;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 15 * s,
                        height: 15 * s,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent
                              .withValues(alpha: 0.22),
                        ),
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent,
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(
                                  alpha: 0.55),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
                  : Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondary.withValues(alpha: 0.30),
                ),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tt.bodySmall?.copyWith(
                  fontWeight:
                  active ? FontWeight.w700 : FontWeight.w500,
                  color: done
                      ? onSurface.withValues(alpha: 0.70)
                      : active
                      ? onSurface
                      : onSurface.withValues(alpha: 0.40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Custom Painters — all theme-aware via accent colour
// ══════════════════════════════════════════════════════════════════

/// Clips a rectangle from the left edge up to [fraction] of the width
class _LeftWipeClipper extends CustomClipper<Rect> {
  const _LeftWipeClipper(this.fraction);
  final double fraction;

  @override
  Rect getClip(Size s) => Rect.fromLTWH(0, 0, s.width * fraction, s.height);

  @override
  bool shouldReclip(_LeftWipeClipper o) => o.fraction != fraction;
}

/// Small dots arranged in a regular grid
class _DotGridPainter extends CustomPainter {
  _DotGridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()..color = color.withValues(alpha: 0.14);
    const double gap = 14.0;
    for (double x = gap / 2; x < size.width; x += gap) {
      for (double y = gap / 2; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1.1, p);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter o) => o.color != color;
}

/// Four corner L-brackets
class _BracketPainter extends CustomPainter {
  _BracketPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double arm = 12.0, m = 9.0;
    final Paint p = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void b(Offset o, double dx, double dy) {
      canvas.drawLine(o, o.translate(dx, 0), p);
      canvas.drawLine(o, o.translate(0, dy), p);
    }

    b(Offset(m, m), arm, arm);
    b(Offset(size.width - m, m), -arm, arm);
    b(Offset(m, size.height - m), arm, -arm);
    b(Offset(size.width - m, size.height - m), -arm, -arm);
  }

  @override
  bool shouldRepaint(_BracketPainter o) => o.color != color;
}

/// Ping-pong scan line with trailing fill and soft glow
class _ScanLinePainter extends CustomPainter {
  _ScanLinePainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double t =
    progress < 0.5 ? progress * 2 : (1 - progress) * 2;
    final double y =
        size.height * 0.10 + Curves.easeInOut.transform(t) * size.height * 0.80;

    // Trailing tinted fill
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, y),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.0),
            color.withValues(alpha: 0.08),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, y)),
    );

    // Glow halo
    canvas.drawRect(
      Rect.fromLTWH(0, y - 9, size.width, 18),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            color.withValues(alpha: 0.38),
            color.withValues(alpha: 0.58),
            color.withValues(alpha: 0.38),
            Colors.transparent,
          ],
          stops: const [0, 0.28, 0.5, 0.72, 1.0],
        ).createShader(Rect.fromLTWH(0, y - 9, size.width, 18))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Crisp bright edge
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      Paint()
        ..color = color
        ..strokeWidth = 1.4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8),
    );
  }

  @override
  bool shouldRepaint(_ScanLinePainter o) =>
      o.progress != progress || o.color != color;
}

/// Two concentric pulsing rings + solid core dot
class _PulseRingPainter extends CustomPainter {
  _PulseRingPainter({required this.pulse, required this.color});
  final double pulse;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final double r = size.width / 2;

    // Outer expanding ring
    canvas.drawCircle(
      c,
      r * (0.62 + pulse * 0.38),
      Paint()
        ..color = color.withValues(alpha: (1 - pulse) * 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
    // Inner ring
    canvas.drawCircle(
      c,
      r * 0.42,
      Paint()
        ..color = color.withValues(alpha: 0.32 + pulse * 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    // Glowing core
    canvas.drawCircle(
      c,
      5.5,
      Paint()
        ..color = color
        ..maskFilter =
        MaskFilter.blur(BlurStyle.normal, 3 + pulse * 3),
    );
    canvas.drawCircle(c, 3.2, Paint()..color = Colors.white.withValues(alpha: 0.90));
  }

  @override
  bool shouldRepaint(_PulseRingPainter o) =>
      o.pulse != pulse || o.color != color;
}

/// Five particles orbiting the thumbnail centre
class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  static const List<_Op> _ps = [
    _Op(rf: 0.30, sz: 2.2, sp: 1.00, ph: 0.00),
    _Op(rf: 0.38, sz: 1.6, sp: 0.72, ph: 0.33),
    _Op(rf: 0.26, sz: 1.9, sp: 1.35, ph: 0.67),
    _Op(rf: 0.44, sz: 1.4, sp: 0.52, ph: 0.15),
    _Op(rf: 0.20, sz: 2.0, sp: 1.80, ph: 0.82),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final double maxR = math.min(size.width, size.height) / 2;

    for (final p in _ps) {
      final double angle =
          (progress * p.sp + p.ph) * 2 * math.pi;
      final Offset pos = c +
          Offset(
            math.cos(angle) * maxR * p.rf,
            math.sin(angle) * maxR * p.rf,
          );
      final double alpha =
          0.35 + 0.45 * math.sin(angle + math.pi / 2).abs();
      canvas.drawCircle(
        pos,
        p.sz,
        Paint()
          ..color = color.withValues(alpha: alpha)
          ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, p.sz * 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter o) => o.progress != progress;
}

class _Op {
  const _Op(
      {required this.rf,
        required this.sz,
        required this.sp,
        required this.ph});
  final double rf, sz, sp, ph;
}