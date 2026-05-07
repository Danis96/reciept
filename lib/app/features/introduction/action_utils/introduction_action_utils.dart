import 'package:flutter/material.dart';

import '../provider/introduction_provider.dart';

class IntroductionActionUtils {
  const IntroductionActionUtils({
    required IntroductionProvider provider,
    required PageController pageController,
    required VoidCallback onCompleted,
  }) : _provider = provider,
       _pageController = pageController,
       _onCompleted = onCompleted;

  final IntroductionProvider _provider;
  final PageController _pageController;
  final VoidCallback _onCompleted;

  Future<void> onSkipPressed() async {
    await _provider.complete();
    _onCompleted();
  }

  Future<void> onNextPressed() async {
    if (_provider.isLastPage) {
      await _provider.complete();
      _onCompleted();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }
}
