import 'package:flutter/material.dart';

import '../../utils/settings_pallete.dart';

class SettingsDropdownSurface extends StatelessWidget {
  const SettingsDropdownSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: SettingsPagePalette.fieldBackground(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(child: child),
    );
  }
}
