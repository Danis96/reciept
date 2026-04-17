import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/settings/controllers/settings_controller.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_simple_message_dialog.dart';

class SettingsActionUtils {
  const SettingsActionUtils._();

  static Future<void> onThemeModeChanged(
      BuildContext context,
      ThemeMode themeMode,
      ) {
    return context.read<SettingsController>().updateThemeMode(themeMode);
  }

  static Future<void> onLanguageChanged(BuildContext context, Locale locale) {
    return context.read<SettingsController>().updateLanguage(locale);
  }

  static Future<void> exportCsv(BuildContext context) async {
    final String path = await context.read<SettingsController>().exportCsv();
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('CSV saved: $path')));
    }
  }

  static Future<void> exportJson(BuildContext context) async {
    final String path = await context.read<SettingsController>().exportJson();
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('JSON saved: $path')));
    }
  }

  static Future<void> showPrivacyPolicy(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return const SettingsSimpleMessageDialog(
          title: 'Privacy Policy',
          message: 'Privacy policy details will be added in a future phase.',
        );
      },
    );
  }

  static Future<void> showTermsOfService(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return const SettingsSimpleMessageDialog(
          title: 'Terms of Service',
          message: 'Terms of service details will be added in a future phase.',
        );
      },
    );
  }
}
