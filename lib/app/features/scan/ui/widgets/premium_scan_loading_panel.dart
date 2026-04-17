import 'dart:io';
import 'package:flutter/material.dart';
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
      duration: const Duration(milliseconds: 3500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int clampedStep = widget.loadingStep.clamp(0, widget.steps.length);
    final double progress =
    widget.steps.isEmpty ? 0 : clampedStep / widget.steps.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _LoadingHeader(
          imagePath: widget.imagePath,
          animation: _controller,
          // TODO: Replace with l10n
          headerText: 'Processing with AI',
          analysisText: 'Analyzing receipt image',
        ),
        const SizedBox(height: AppSpacing.sm),
        _LoadingProgressBar(progress: progress, animation: _controller),
        const SizedBox(height: AppSpacing.md),
        _LoadingStepsList(
          steps: widget.steps,
          loadingStep: clampedStep,
          animation: _controller,
        ),
      ],
    );
  }
}

// --- Decomposed UI Widgets ---

class _LoadingHeader extends StatelessWidget {
  const _LoadingHeader({
    required this.imagePath,
    required this.animation,
    required this.headerText,
    required this.analysisText,
  });

  final String? imagePath;
  final Animation<double> animation;
  final String headerText;
  final String analysisText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LoadingPreview(
          imagePath: imagePath,
          animation: animation,
          analysisText: analysisText,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.1,
                valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              headerText,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

class _LoadingPreview extends StatelessWidget {
  const _LoadingPreview({
    required this.imagePath,
    required this.animation,
    required this.analysisText,
  });

  final String? imagePath;
  final Animation<double> animation;
  final String analysisText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? path = imagePath;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 3 / 4,
            child: path == null
                ? Container(color: Colors.grey.shade200)
                : Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) =>
              const Center(child: Icon(Icons.broken_image_outlined)),
            ),
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
                        theme.colorScheme.surface.withValues(alpha:0.34),
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
                color: Colors.black.withValues(alpha:0.34),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                analysisText,
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

class _LoadingProgressBar extends StatelessWidget {
  const _LoadingProgressBar({required this.progress, required this.animation});

  final double progress;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth * progress.clamp(0, 1);
        return Container(
          height: 10,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha:0.16),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      theme.colorScheme.primary.withValues(alpha:0.95),
                      theme.colorScheme.tertiary.withValues(alpha:0.92),
                    ],
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

class _LoadingStepsList extends StatelessWidget {
  const _LoadingStepsList({
    required this.steps,
    required this.loadingStep,
    required this.animation,
  });

  final List<String> steps;
  final int loadingStep;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(steps.length, (int index) {
        final bool isDone = index < loadingStep;
        final bool isActive = index == loadingStep && loadingStep < steps.length;
        return Padding(
          padding: EdgeInsets.only(bottom: index == steps.length - 1 ? 0 : 10),
          child: _LoadingStepRow(
            title: steps[index],
            done: isDone,
            active: isActive,
            animation: animation,
          ),
        );
      }),
    );
  }
}

class _LoadingStepRow extends StatelessWidget {
  const _LoadingStepRow({
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
        color: active ? theme.colorScheme.primary.withValues(alpha:0.10) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          if (done)
            const Icon(Icons.check_circle, color: Color(0xFF20B46A), size: 22)
          else if (active)
            _ActiveIndicator(
              animation: animation,
              color: theme.colorScheme.primary,
            )
          else
            Icon(
              Icons.radio_button_unchecked,
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
                    : theme.colorScheme.onSurface.withValues(alpha:0.86),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveIndicator extends StatelessWidget {
  const _ActiveIndicator({required this.animation, required this.color});

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
              Container(
                height: 19 * pulse,
                width: 19 * pulse,
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.28),
                  shape: BoxShape.circle,
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
