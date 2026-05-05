import 'package:flutter/material.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_card_frame.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_section_header.dart';

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
          SettingsSectionHeader(
            icon: Icons.info_outline,
            title: context.l10n.about,
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Text(
                context.l10n.appVersion,
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
