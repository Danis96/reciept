import 'package:flutter/material.dart';

import '../../../models/introduction_step.dart';
import 'widgets/introduction_step_header.dart';
import 'widgets/introduction_step_point.dart';

class IntroductionStepPanel extends StatelessWidget {
  const IntroductionStepPanel({
    required this.step,
    required this.currentIndex,
    required this.totalSteps,
    super.key,
  });

  final IntroductionStep step;
  final int currentIndex;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          StepHeader(
            badge: step.badge,
            currentIndex: currentIndex,
            totalSteps: totalSteps,
          ),
          const SizedBox(height: 16),
          Text(
            step.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.0,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            step.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ...step.points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: StepPoint(text: point),
            ),
          ),
        ],
      ),
    );
  }
}
