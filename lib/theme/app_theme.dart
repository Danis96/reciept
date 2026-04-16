import 'package:flutter/material.dart';

import 'app_button_styles.dart';
import 'app_card_styles.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final ColorScheme colorScheme = const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.textTheme(AppColors.lightPrimary),
      cardTheme: AppCardStyles.cardTheme(
        AppColors.lightSurface,
        AppColors.lightSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary(
          AppColors.lightPrimary,
          AppColors.lightOnPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.lightPrimary.withValues(alpha: 0.12),
      ),
    );
  }

  static ThemeData get dark {
    final ColorScheme colorScheme = const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.textTheme(Colors.white),
      cardTheme: AppCardStyles.cardTheme(
        AppColors.darkSurface,
        AppColors.darkPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary(
          AppColors.darkPrimary,
          AppColors.darkOnPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.darkPrimary.withValues(alpha: 0.2),
      ),
    );
  }
}
