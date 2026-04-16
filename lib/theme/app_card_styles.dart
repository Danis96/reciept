import 'package:flutter/material.dart';

class AppCardStyles {
  const AppCardStyles._();

  static CardThemeData cardTheme(Color color, Color borderColor) {
    return CardThemeData(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor.withValues(alpha: 0.2)),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
    );
  }
}
