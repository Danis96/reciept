import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../routing/app_router.dart';
import '../theme/app_theme.dart';
import 'features/scan/controllers/scan_controller.dart';
import 'features/settings/controllers/settings_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, _) {
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
                    _ScanAppNoticeListener.handle(scanController);
                    return child ?? const SizedBox.shrink();
                  },
            );
          },
          initialRoute: AppRouter.root,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}

class _ScanAppNoticeListener {
  const _ScanAppNoticeListener._();

  static void handle(ScanController controller) {
    final ScanForegroundNotice? notice = controller.consumeForegroundNotice();
    if (notice == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ScaffoldMessengerState? messenger =
          MyApp.scaffoldMessengerKey.currentState;
      if (messenger == null) {
        return;
      }
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(notice.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: notice.isError ? Colors.red.shade700 : null,
          ),
        );
    });
  }
}
