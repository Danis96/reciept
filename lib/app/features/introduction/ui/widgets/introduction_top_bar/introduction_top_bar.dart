import 'package:flutter/material.dart';

class IntroductionTopBar extends StatelessWidget {
  const IntroductionTopBar({
    required this.currentIndex,
    required this.totalSteps,
    required this.onSkipPressed,
    super.key,
  });

  final int currentIndex;
  final int totalSteps;
  final VoidCallback? onSkipPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: [
          const Spacer(),
          TextButton(
            onPressed: onSkipPressed,
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
}
