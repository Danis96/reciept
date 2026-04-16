import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(Color color) {
    return TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
