import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/match_list_controller.dart';

/// Filter chip row for the match list: All / Group Stage / Knockouts.
class MatchFilterChips extends StatelessWidget {
  const MatchFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MatchFilter selected;
  final ValueChanged<MatchFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _customChip(context, MatchFilter.all, l10n.matches_filter_all, isDark),
          const SizedBox(width: 8),
          _customChip(context, MatchFilter.groupStage, l10n.matches_filter_groupStage, isDark),
          const SizedBox(width: 8),
          _customChip(context, MatchFilter.knockouts, l10n.matches_filter_knockouts, isDark),
        ],
      ),
    );
  }

  Widget _customChip(BuildContext context, MatchFilter filter, String label, bool isDark) {
    final isSelected = selected == filter;
    final activeColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    final chipBgColor = isSelected
        ? activeColor
        : (isDark ? const Color(0x661E293B) : Colors.white.withValues(alpha: 0.65));
    final chipTextColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkOnSurfaceMuted : AppColors.lightOnSurfaceMuted);
    final chipBorderColor = isSelected
        ? activeColor
        : (isDark ? const Color(0x2694A3B8) : Colors.white.withValues(alpha: 0.8));

    return GestureDetector(
      onTap: () => onSelected(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: chipBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: chipBorderColor, width: 1.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: chipTextColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

