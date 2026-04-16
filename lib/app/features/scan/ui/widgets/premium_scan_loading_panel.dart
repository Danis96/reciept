import 'package:flutter/material.dart';
import 'package:reciep/app/features/scan/ui/widgets/scan_receipt_image_preview.dart';
import 'package:reciep/theme/app_spacing.dart';

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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int clampedStep = widget.loadingStep.clamp(0, widget.steps.length);
    final double progress = widget.steps.isEmpty
        ? 0
        : clampedStep / widget.steps.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PremiumLoadingPreview(
          imagePath: widget.imagePath,
          animation: _controller,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.1,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Processing with AI',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        PremiumLoadingProgressBar(progress: progress, animation: _controller),
        const SizedBox(height: AppSpacing.md),
        Column(
          children: List<Widget>.generate(widget.steps.length, (int index) {
            final bool done = index < clampedStep;
            final bool active =
                index == clampedStep && clampedStep < widget.steps.length;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == widget.steps.length - 1 ? 0 : 10,
              ),
              child: PremiumLoadingStepRow(
                title: widget.steps[index],
                done: done,
                active: active,
                animation: _controller,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class PremiumLoadingPreview extends StatelessWidget {
  const PremiumLoadingPreview({
    super.key,
    required this.imagePath,
    required this.animation,
  });

  final String? imagePath;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ScanReceiptImagePreview(imagePath: imagePath),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                final double alignmentX = -1.8 + (animation.value * 3.6);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(alignmentX, -0.3),
                      end: Alignment(alignmentX + 0.65, 0.3),
                      colors: <Color>[
                        Colors.transparent,
                        theme.colorScheme.surface.withValues(alpha: 0.34),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Analyzing receipt image',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumLoadingProgressBar extends StatelessWidget {
  const PremiumLoadingProgressBar({
    super.key,
    required this.progress,
    required this.animation,
  });

  final double progress;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double width = constraints.maxWidth * progress.clamp(0, 1);
          return Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    colors: <Color>[
                      theme.colorScheme.primary.withValues(alpha: 0.95),
                      theme.colorScheme.tertiary.withValues(alpha: 0.92),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final double glow = 0.45 + (animation.value * 0.3);
                    return Opacity(
                      opacity: progress > 0 ? glow : 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Colors.transparent,
                              Colors.white70,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PremiumLoadingStepRow extends StatelessWidget {
  const PremiumLoadingStepRow({
    super.key,
    required this.title,
    required this.done,
    required this.active,
    required this.animation,
  });

  final String title;
  final bool done;
  final bool active;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: active
            ? theme.colorScheme.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          if (done)
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF20B46A),
              size: 22,
            ),
          if (active)
            PremiumActiveIndicator(
              animation: animation,
              color: theme.colorScheme.primary,
            ),
          if (!done && !active)
            Icon(
              Icons.radio_button_unchecked_rounded,
              color: theme.colorScheme.secondary,
              size: 22,
            ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.86),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumActiveIndicator extends StatelessWidget {
  const PremiumActiveIndicator({
    super.key,
    required this.animation,
    required this.color,
  });

  final Animation<double> animation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      width: 22,
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double pulse = 0.72 + ((animation.value - 0.5).abs() * 0.45);
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: 0.28,
                child: Container(
                  height: 19 * pulse,
                  width: 19 * pulse,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          );
        },
      ),
    );
  }
}
