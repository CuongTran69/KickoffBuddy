import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'theme_extensions.dart';

/// ThemeData builders for Kickoff Buddy.
/// Uses Material 3 with custom color scheme and Inter typography.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.lightPrimary,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurface: AppColors.lightOnSurface,
      secondary: AppColors.lightAccent,
      error: AppColors.lightError,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme(Brightness.light),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.lightSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.lightSurfaceContainerHigh,
            width: 0.5,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTypography.textTheme(Brightness.light)
            .titleLarge
            ?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.lightOnSurface,
            ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
        side: BorderSide(color: AppColors.lightSurfaceContainerHigh),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightSurfaceContainerHigh,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        indicatorColor: AppColors.lightPrimary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.textTheme(Brightness.light).labelSmall?.copyWith(
                color: AppColors.lightOnSurface,
              ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.lightPrimary);
          }
          return IconThemeData(
              color: AppColors.lightOnSurface.withValues(alpha: 0.6));
        }),
      ),
      extensions: const [
        ReplayPlannerColors(
          bannerBackground: Color(0xFFFEF3C7), // Amber-100 light tint
          bannerForeground: Color(0xFF92400E), // Amber-800 dark text
        ),
      ],
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.darkPrimary,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurface: AppColors.darkOnSurface,
      secondary: AppColors.darkAccent,
      error: AppColors.darkError,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme(Brightness.dark),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.darkSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.darkSurfaceContainerHigh,
            width: 0.5,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTypography.textTheme(Brightness.dark)
            .titleLarge
            ?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkOnSurface,
            ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.darkPrimary.withValues(alpha: 0.2),
        side: BorderSide(color: AppColors.darkSurfaceContainerHigh),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkSurfaceContainerHigh,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        indicatorColor: AppColors.darkPrimary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.textTheme(Brightness.dark).labelSmall?.copyWith(
                color: AppColors.darkOnSurface,
              ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.darkPrimary);
          }
          return IconThemeData(
              color: AppColors.darkOnSurface.withValues(alpha: 0.6));
        }),
      ),
      extensions: const [
        ReplayPlannerColors(
          bannerBackground: AppColors.darkAccent, // Amber
          bannerForeground: Color(0xFF0F172A), // Slate-900 for contrast
        ),
      ],
    );
  }
}

