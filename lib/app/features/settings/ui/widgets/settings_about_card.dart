import 'package:flutter/material.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_card_frame.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_section_header.dart';

import '../utils/settings_pallete.dart';

class SettingsAboutCard extends StatelessWidget {
  const SettingsAboutCard({super.key, required this.appVersion});

  final String appVersion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsSectionHeader(icon: Icons.info_outline, title: 'About'),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Text(
                'App Version',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: SettingsPagePalette.mutedText(context),
                ),
              ),
              const Spacer(),
              Text(
                appVersion,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
