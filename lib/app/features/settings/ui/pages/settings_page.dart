import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/settings/action_utils/settings_action_utils.dart';
import 'package:reciep/app/features/settings/controllers/settings_controller.dart';
import 'package:reciep/app/features/settings/ui/widgets/settings_about_card.dart';
import 'package:reciep/app/features/settings/ui/widgets/settings_export_card.dart';
import 'package:reciep/app/features/settings/ui/widgets/settings_language_card.dart';
import 'package:reciep/app/features/settings/ui/widgets/settings_legal_card.dart';
import 'package:reciep/app/features/settings/ui/widgets/settings_theme_card.dart';
import 'package:reciep/app/features/settings/ui/widgets/settings_title_block.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (BuildContext context, SettingsController controller, _) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SettingsTitleBlock(),
                const SizedBox(height: 16),
                SettingsThemeCard(
                  selectedMode: controller.themeMode,
                  onChanged: (ThemeMode mode) =>
                      SettingsActionUtils.onThemeModeChanged(context, mode),
                ),
                const SizedBox(height: 14),
                SettingsLanguageCard(
                  languageCode: controller.locale.languageCode,
                  onChanged: (String code) => SettingsActionUtils
                      .onLanguageChanged(context, Locale(code)),
                ),
                const SizedBox(height: 14),
                SettingsExportCard(
                  exporting: controller.exporting,
                  onExportCsvPressed: () =>
                      SettingsActionUtils.exportCsv(context),
                  onExportJsonPressed: () =>
                      SettingsActionUtils.exportJson(context),
                ),
                const SizedBox(height: 14),
                SettingsLegalCard(
                  onPrivacyPolicyTap: () =>
                      SettingsActionUtils.showPrivacyPolicy(context),
                  onTermsOfServiceTap: () =>
                      SettingsActionUtils.showTermsOfService(context),
                ),
                const SizedBox(height: 14),
                const SettingsAboutCard(appVersion: _appVersion),
              ],
            ),
          ),
        );
      },
    );
  }
}
