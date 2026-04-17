import 'package:flutter/material.dart';

class SettingsPagePalette {
  const SettingsPagePalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color mutedText(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .secondary
        .withValues(alpha:_dark(context) ? 0.82 : 0.92);
  }

  static Color cardBorder(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha:_dark(context) ? 0.22 : 0.12);
  }

  static Color fieldBackground(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha:_dark(context) ? 0.14 : 0.06);
  }

  static Color rowBackground(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha:_dark(context) ? 0.10 : 0.03);
  }

  static Color rowHighlightBackground(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha:_dark(context) ? 0.18 : 0.08);
  }
}
