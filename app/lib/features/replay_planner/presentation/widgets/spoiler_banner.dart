import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// Full-width banner shown on the match detail screen when the spoiler
/// shield is active.
///
/// Displays a shield icon and "Spoiler-protected until [day-of-week, HH:mm]".
/// Uses an Amber tint background with an Amber left border accent.
class SpoilerBanner extends StatelessWidget {
  const SpoilerBanner({super.key, required this.plannedAtLocal});

  /// The planned replay time in the user's local timezone.
  final DateTime plannedAtLocal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = DateFormat('EEE, HH:mm').format(plannedAtLocal);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor =
        isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final bgColor = accentColor.withValues(alpha: 0.15);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          left: BorderSide(color: accentColor, width: 3),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 18,
            color: accentColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.spoiler_banner_text(formatted),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


