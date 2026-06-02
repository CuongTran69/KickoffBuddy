import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A shared wrapper widget that applies a flat background color.
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

    final backgroundColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurfaceVariant;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor,
      child: child,
    );
  }
}
