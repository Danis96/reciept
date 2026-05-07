import 'package:flutter/material.dart';

import '../../../../models/introduction_step.dart';
import 'ai_visual.dart';
import 'budgets_visual.dart';
import 'export_visual.dart';
import 'organize_visual.dart';
import 'privacy_visual.dart';
import 'preview_shared.dart';
import 'scan_visual.dart';

class PreviewBody extends StatelessWidget {
  const PreviewBody({required this.step, super.key});

  final IntroductionStep step;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AmbientOrb(
          alignment: Alignment.topRight,
          size: 118,
          opacity: 0.16,
        ),
        const AmbientOrb(
          alignment: Alignment.bottomLeft,
          size: 144,
          opacity: 0.12,
        ),
        Center(
          child: switch (step.visualKind) {
            IntroductionVisualKind.scan => const ScanVisual(),
            IntroductionVisualKind.ai => const AiVisual(),
            IntroductionVisualKind.organize => const OrganizeVisual(),
            IntroductionVisualKind.budgets => const BudgetsVisual(),
            IntroductionVisualKind.export => const ExportVisual(),
            IntroductionVisualKind.privacy => const PrivacyVisual(),
          },
        ),
      ],
    );
  }
}
