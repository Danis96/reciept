import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_button_styles.dart';
import 'app_card_styles.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final ColorScheme colorScheme = const ColorScheme.light(
      primary: AppColors.brandPrimary,
      onPrimary: AppColors.brandOnPrimary,
      primaryContainer: AppColors.brandPrimaryContainerLight,
      onPrimaryContainer: AppColors.brandOnPrimaryContainerLight,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      // Text stays on the deep navy ink — orange is reserved for accents/CTAs.
      textTheme: AppTypography.textTheme(AppColors.lightPrimary),
      cardTheme: AppCardStyles.cardTheme(
        AppColors.lightSurface,
        AppColors.lightSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary(
          AppColors.brandPrimary,
          AppColors.brandOnPrimary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: AppButtonStyles.primary(
          AppColors.brandPrimary,
          AppColors.brandOnPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.brandPrimary.withValues(alpha: 0.16),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) =>
              states.contains(WidgetState.selected) ? AppColors.brandPrimary : null,
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AppColors.brandPrimary.withValues(alpha: 0.40)
              : null,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brandPrimary,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.brandPrimary,
        thumbColor: AppColors.brandPrimary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.brandPrimary,
        selectionColor: AppColors.brandPrimary.withValues(alpha: 0.24),
        selectionHandleColor: AppColors.brandPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final ColorScheme colorScheme = const ColorScheme.dark(
      primary: AppColors.brandPrimaryDark,
      onPrimary: AppColors.brandOnPrimaryDark,
      primaryContainer: AppColors.brandPrimaryContainerDark,
      onPrimaryContainer: AppColors.brandOnPrimaryContainerDark,
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
          AppColors.brandPrimaryDark,
          AppColors.brandOnPrimaryDark,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: AppButtonStyles.primary(
          AppColors.brandPrimaryDark,
          AppColors.brandOnPrimaryDark,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.brandPrimaryDark.withValues(alpha: 0.22),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AppColors.brandPrimaryDark
              : null,
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AppColors.brandPrimaryDark.withValues(alpha: 0.40)
              : null,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brandPrimaryDark,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.brandPrimaryDark,
        thumbColor: AppColors.brandPrimaryDark,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.brandPrimaryDark,
        selectionColor: AppColors.brandPrimaryDark.withValues(alpha: 0.24),
        selectionHandleColor: AppColors.brandPrimaryDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
    );
  }
}
