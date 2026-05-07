import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refyn/generated/assets.dart';
import 'package:refyn/theme/app_colors.dart';
import 'package:wiggly_loaders/wiggly_loaders.dart';

import '../../../../../database/app_database.dart';
import '../../../dashboard/ui/pages/dashboard_shell_page.dart';
import '../../provider/introduction_provider.dart';
import '../../repository/introduction_repository.dart';
import 'introduction_page.dart';

class IntroductionFlowPage extends StatelessWidget {
  const IntroductionFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IntroductionProvider>(
      create: (_) => IntroductionProvider(
        repository: IntroductionRepository(
          settingsDao: context.read<AppSettingsDao>(),
        ),
      )..initialize(),
      child: const _IntroductionFlowView(),
    );
  }
}

class _IntroductionFlowView extends StatelessWidget {
  const _IntroductionFlowView();

  @override
  Widget build(BuildContext context) {
    return Consumer<IntroductionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const _IntroductionBootstrapLoader();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
                child: child,
              ),
            );
          },
          child: provider.shouldShowIntroduction
              ? IntroductionPage(
                  key: const ValueKey<String>('introduction'),
                  onCompleted: () {},
                )
              : const DashboardShellPage(
                  key: ValueKey<String>('dashboard'),
                ),
        );
      },
    );
  }
}

class _IntroductionBootstrapLoader extends StatelessWidget {
  const _IntroductionBootstrapLoader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: .bottomCenter,
      children: [
        Image.asset(Assets.assetsSplash, fit: .cover),
        Positioned(
          bottom: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                  width: 100,
                  child: WigglyLinearLoader.indeterminate(progressColor: AppColors.lightBackground, )),
              const SizedBox(height: 14),
              Text(
                'Preparing Refyn',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
