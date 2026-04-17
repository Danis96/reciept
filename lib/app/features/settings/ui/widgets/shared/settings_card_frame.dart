import 'package:flutter/material.dart';

import '../../utils/settings_pallete.dart';

class SettingsCardFrame extends StatelessWidget {
  const SettingsCardFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SettingsPagePalette.cardBorder(context)),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
