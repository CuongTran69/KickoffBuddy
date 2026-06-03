import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared decoration helpers for reusable visual patterns.
abstract final class AppDecorations {
  /// The glassmorphism card decoration used across multiple list screens.
  ///
  /// Background: Slate-800 (60% opacity) in dark / White (85% opacity) in light.
  /// Border: primary-tinted in dark / near-white in light.
  /// Shadow: blur 14, offset (0, 6).
  ///
  /// Preserves identical visual output to the original duplicated BoxDecorations.
  static BoxDecoration glassCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0x991E293B) // Slate-800 with 60% opacity
        : const Color(0xD9FFFFFF); // White with 85% opacity
    final borderColor = isDark
        ? AppColors.darkPrimary.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.9);
    final double borderWidth = isDark ? 1.0 : 1.5;

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.2)
              : AppColors.lightPrimary.withValues(alpha: 0.04),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
