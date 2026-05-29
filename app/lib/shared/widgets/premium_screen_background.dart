import 'package:flutter/material.dart';

/// A shared wrapper widget that applies a premium background gradient.
///
/// Dark Mode: Midnight Pitch to Slate-900.
/// Light Mode: Soft Emerald to White.
class PremiumScreenBackground extends StatelessWidget {
  const PremiumScreenBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final gradientStart = isDark
        ? const Color(0xFF051811) // Deep stadium green
        : const Color(0xFFDCF2E8); // Rich soft mint green
    final gradientEnd = isDark
        ? const Color(0xFF080F16) // Midnight slate-blue
        : const Color(0xFFF3FAF6); // Minty white

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientStart, gradientEnd],
        ),
      ),
      child: child,
    );
  }
}
