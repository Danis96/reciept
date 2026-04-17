import 'package:flutter/material.dart';

import '../utils/settings_pallete.dart';

class SettingsTitleBlock extends StatelessWidget {
  const SettingsTitleBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Settings',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your preferences',
          style: textTheme.titleMedium?.copyWith(
            fontSize: 16,
            color: SettingsPagePalette.mutedText(context),
          ),
        ),
      ],
    );
  }
}
