import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/introduction_step.dart';
import '../introduction_preview_card/widgets/introduction_preview_card.dart';
import '../introduction_step_panel/introduction_step_panel.dart';

class CompactIntroductionStep extends StatelessWidget {
  const CompactIntroductionStep({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final previewHeight = math.min(
          300.0,
          math.max(260.0, constraints.maxHeight * 0.42),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: constraints.maxHeight - 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: previewHeight,
                  child: IntroductionPreviewCard(step: step),
                ),
                const SizedBox(height: 5),
                IntroductionStepPanel(
                  step: step,
                  currentIndex: currentIndex,
                  totalSteps: totalSteps,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
