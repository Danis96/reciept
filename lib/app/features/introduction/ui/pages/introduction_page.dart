import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../action_utils/introduction_action_utils.dart';
import '../../provider/introduction_provider.dart';
import '../widgets/compact_introduction_step/compact_introduction_step.dart';
import '../widgets/introduction_bottom_bar/introduction_bottom_bar.dart';
import '../widgets/introduction_page_indicator/introduction_page_indicator.dart';
import '../widgets/introduction_top_bar/introduction_top_bar.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({required this.onCompleted, super.key});

  final VoidCallback onCompleted;

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.08),
              colorScheme.primary.withValues(alpha: 0.03),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _IntroductionBackground(),
            SafeArea(
              left: false,
              right: false,
              child: Consumer<IntroductionProvider>(
                builder: (context, controller, _) {
                  if (!controller.hasSteps) {
                    return const SizedBox.shrink();
                  }
                  final actionUtils = IntroductionActionUtils(
                    provider: controller,
                    pageController: _pageController,
                    onCompleted: widget.onCompleted,
                  );
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                        child: Column(
                          children: [
                            IntroductionTopBar(
                              currentIndex: controller.currentPage,
                              totalSteps: controller.steps.length,
                              onSkipPressed: controller.isCompleting
                                  ? null
                                  : actionUtils.onSkipPressed,
                            ),
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: controller.setCurrentPage,
                                itemCount: controller.steps.length,
                                itemBuilder: (context, index) {
                                  final step = controller.steps[index];
                                  return CompactIntroductionStep(
                                    key: ValueKey('compact-$index'),
                                    step: step,
                                    currentIndex: controller.currentPage,
                                    totalSteps: controller.steps.length,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            IntroductionPageIndicator(
                              count: controller.steps.length,
                              currentIndex: controller.currentPage,
                              activeColor: colorScheme.primary,
                              inactiveColor:
                                  colorScheme.primary.withValues(alpha: 0.18),
                            ),
                            const SizedBox(height: 18),
                            IntroductionBottomBar(
                              isLastPage: controller.isLastPage,
                              isCompleting: controller.isCompleting,
                              currentIndex: controller.currentPage,
                              totalSteps: controller.steps.length,
                              onNextPressed: actionUtils.onNextPressed,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroductionBackground extends StatelessWidget {
  const _IntroductionBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -90,
            left: -40,
            child: _BackgroundOrb(
              size: 240,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            top: 180,
            right: -70,
            child: _BackgroundOrb(
              size: 210,
              color: colorScheme.primary.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: -60,
            left: 40,
            child: _BackgroundOrb(
              size: 190,
              color: colorScheme.primary.withValues(alpha: 0.06),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  const _BackgroundOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
