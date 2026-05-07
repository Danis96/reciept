import 'package:flutter/material.dart';

class IntroductionBottomBar extends StatelessWidget {
  const IntroductionBottomBar({
    required this.isLastPage,
    required this.isCompleting,
    required this.currentIndex,
    required this.totalSteps,
    required this.onNextPressed,
    super.key,
  });

  final bool isLastPage;
  final bool isCompleting;
  final int currentIndex;
  final int totalSteps;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  isLastPage
                      ? 'Ready to scan with Refyn'
                      : '${currentIndex + 1}/$totalSteps features previewed',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: isCompleting ? null : onNextPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCompleting)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      )
                    else
                      Icon(
                        isLastPage
                            ? Icons.rocket_launch_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                    const SizedBox(width: 10),
                    Text(isLastPage ? 'Open Refyn' : 'Next'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
