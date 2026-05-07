import 'package:flutter/material.dart';

import '../../../../models/introduction_step.dart';
import 'preview_body.dart';
import 'preview_header.dart';

class IntroductionPreviewCard extends StatelessWidget {
  const IntroductionPreviewCard({required this.step, super.key});

  final IntroductionStep step;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.28),
              colorScheme.primary.withValues(alpha: 0.14),
              colorScheme.primary.withValues(alpha: 0.06),
            ],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(31),
            color: colorScheme.surface.withValues(alpha: 0.92),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PreviewHeader(step: step),
                const SizedBox(height: 5),
                Expanded(child: PreviewBody(step: step)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
