import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:refyn/generated/assets.dart';
import 'package:wiggly_loaders/wiggly_loaders.dart';

import '../l10n/app_localizations.dart';
import '../routing/routes.dart';
import '../routing/routing_generator.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'features/scan/controllers/scan_controller.dart';
import 'features/settings/controllers/settings_controller.dart';
import 'widgets/app_snackbar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, _) {
        Intl.defaultLocale = settingsController.locale.toLanguageTag();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppLocalizations.fallback.appTitle,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settingsController.themeMode,
          scaffoldMessengerKey: scaffoldMessengerKey,
          locale: settingsController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (BuildContext context, Widget? child) {
            return Consumer<ScanController>(
              builder:
                  (
                    BuildContext context,
                    ScanController scanController,
                    Widget? _,
                  ) {
                    _ScanAppNoticeListener.handle(context, scanController);
                    return child ?? const SizedBox.shrink();
                  },
            );
          },
          home: const _AppFlow(),
        );
      },
    );
  }
}

class _AppFlow extends StatefulWidget {
  const _AppFlow();

  @override
  State<_AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<_AppFlow> {
  static const Duration _minimumSplashDuration = Duration(milliseconds: 1050);

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_dismissInitialSplash());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(Assets.assetsSplash), context);
  }

  Future<void> _dismissInitialSplash() async {
    await Future<void>.delayed(_minimumSplashDuration);
    if (!mounted) {
      return;
    }

    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Navigator(
          key: _navigatorKey,
          initialRoute: root,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
        IgnorePointer(
          ignoring: !_showSplash,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeOutCubic,
            child: _showSplash
                ? const _StartupSplashScreen(key: ValueKey('app-flow-splash'))
                : const SizedBox.shrink(key: ValueKey('app-flow-no-splash')),
          ),
        ),
      ],
    );
  }
}

class _StartupSplashScreen extends StatelessWidget {
  const _StartupSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        const ColoredBox(
          color: Color(0xFFDE6834),
          child: SizedBox.expand(
            child: Image(
              image: AssetImage(Assets.assetsSplash),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 100,
                child: WigglyLinearLoader.indeterminate(
                  progressColor: AppColors.lightBackground,
                ),
              ),
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

class _ScanAppNoticeListener {
  const _ScanAppNoticeListener._();

  static void handle(BuildContext context, ScanController controller) {
    final ScanForegroundNotice? notice = controller.consumeForegroundNotice();
    if (notice == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      if (notice.isError) {
        AppSnackBar.error(context, notice.message);
        return;
      }
      AppSnackBar.success(context, notice.message);
    });
  }
}
