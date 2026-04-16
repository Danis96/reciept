import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../routing/app_router.dart';
import '../theme/app_theme.dart';
import 'features/settings/controllers/settings_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          locale: settingsController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: AppRouter.root,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
