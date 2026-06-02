import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/match_list_controller.dart';

/// Section header for a date group in the match list.
///
/// Features an primary colored left accent bar, surfaceVariant background,
/// and rounded corners for visual anchoring.
class DateSectionHeader extends StatelessWidget {
  const DateSectionHeader({super.key, required this.section});

  final DateSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    final bgColor = accentColor.withValues(alpha: 0.1);

    final screenBgColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: screenBgColor,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.3),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: accentColor,
              ),
              const SizedBox(width: 6),
              Text(
                dateSectionLabel(section, l10n),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}


