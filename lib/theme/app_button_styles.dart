import 'package:flutter/material.dart';

import 'app_spacing.dart';

class AppButtonStyles {
  const AppButtonStyles._();

  static ButtonStyle primary(Color background, Color foreground) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: background,
      foregroundColor: foreground,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}
