import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography for Kickoff Buddy using Inter (Google Fonts).
/// - Display / Title: SemiBold (w600)
/// - Body: Regular (w400)
/// - Numerals / Time: SemiBold (w600) + tabular figures
abstract final class AppTypography {
  /// Base Inter TextTheme for Material 3.
  static TextTheme textTheme(Brightness brightness) {
    final base = GoogleFonts.interTextTheme(
      brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    );

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w600),
      displayMedium: base.displayMedium?.copyWith(fontWeight: FontWeight.w600),
      displaySmall: base.displaySmall?.copyWith(fontWeight: FontWeight.w600),
      headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
      headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
      headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
      bodyMedium: base.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      bodySmall: base.bodySmall?.copyWith(fontWeight: FontWeight.w400),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w400),
      labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w400),
      labelSmall: base.labelSmall?.copyWith(fontWeight: FontWeight.w400),
    );
  }

  /// TextStyle for time/countdown displays — SemiBold + tabular figures to
  /// prevent layout shift as digits change.
  static TextStyle tabularNumbers({
    double fontSize = 16,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
