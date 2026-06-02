import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../application/rule_cards_controller.dart';

/// A sliding segmented control for selecting the active rule level.
///
/// Renders three tabs: Newbie / Casual / Advanced (localized).
/// Animates the active selector indicator dynamically.
class LevelFilterChips extends StatelessWidget {
  const LevelFilterChips({
    super.key,
    required this.currentLevel,
    required this.onSelected,
  });

  final RuleLevel currentLevel;
  final void Function(RuleLevel) onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final containerBgColor = isDark
        ? const Color(0x331E293B) // Dark glass
        : Colors.white.withValues(alpha: 0.6); // Light glass
    final containerBorderColor = isDark
        ? const Color(0x1F94A3B8)
        : Colors.white.withValues(alpha: 0.8);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: containerBgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: containerBorderColor, width: 1.0),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final itemWidth = totalWidth / RuleLevel.values.length;
            final selectedIndex = RuleLevel.values.indexOf(currentLevel);

            return Stack(
              children: [
                // Sliding indicator
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment(
                    -1.0 + (selectedIndex * (2.0 / (RuleLevel.values.length - 1))),
                    0.0,
                  ),
                  child: Container(
                    width: itemWidth - 8,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _levelColor(context, currentLevel),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _levelColor(context, currentLevel).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Chips layer (using Row of LevelFilterChips to pass tests)
                Row(
                  children: RuleLevel.values.map((level) {
                    final isSelected = currentLevel == level;
                    final color = _levelColor(context, level);

                    return Expanded(
                      child: LevelFilterChip(
                        label: _levelLabel(level, l10n),
                        selected: isSelected,
                        color: color,
                        onTap: () => onSelected(level),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color _levelColor(BuildContext context, RuleLevel level) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (level) {
      case RuleLevel.newbie:
        return isDark ? const Color(0xFF00E5FF) : const Color(0xFF0891B2); // Cyan-600 in light mode
      case RuleLevel.casual:
        return const Color(0xFFFBBF24); // Amber
      case RuleLevel.advanced:
        return const Color(0xFFF87171); // Red
    }
  }

  String _levelLabel(RuleLevel level, AppLocalizations l10n) {
    switch (level) {
      case RuleLevel.newbie:
        return l10n.rules_level_newbie;
      case RuleLevel.casual:
        return l10n.rules_level_casual;
      case RuleLevel.advanced:
        return l10n.rules_level_advanced;
    }
  }
}

class LevelFilterChip extends StatelessWidget {
  const LevelFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final chipTextColor = selected
        ? (color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white)
        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: chipTextColor,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

