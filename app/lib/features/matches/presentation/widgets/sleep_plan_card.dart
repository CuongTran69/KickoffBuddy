import 'package:flutter/material.dart';

import '../../data/match.dart';
import '../../../replay_planner/presentation/replay_planner_dialog.dart';
import '../../../../l10n/app_localizations.dart';

/// A card shown on Match Detail for late-night fixtures (22:00–04:59 local).
///
/// Presents three watch/sleep modes — Late Watcher, Balanced, Healthy Replay —
/// each with a one-line suggestion. The Healthy Replay mode includes a CTA
/// that opens the Replay Planner dialog. A mandatory disclaimer is shown at
/// the bottom.
///
/// Styling matches `_PremiumSettingsCard` in settings_screen.dart:
/// translucent background, rounded corners (20), emerald border.
class SleepPlanCard extends StatelessWidget {
  const SleepPlanCard({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0x991E293B) // Slate-800 60% opacity
        : const Color(0xD9FFFFFF); // White 85% opacity
    final borderColor = isDark
        ? const Color(0x3310B981) // Translucent Emerald
        : Colors.white.withValues(alpha: 0.9);
    final double borderWidth = isDark ? 1.0 : 1.5;
    final emeraldColor =
        isDark ? const Color(0xFF10B981) : const Color(0xFF059669);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0x0A059669).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Icon(
                  Icons.bedtime_outlined,
                  color: emeraldColor,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.sleepPlan_cardTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mode rows
            _ModeRow(
              icon: Icons.nightlight_round,
              title: l10n.sleepPlan_mode_lateWatcher_title,
              body: l10n.sleepPlan_mode_lateWatcher_body,
              isDark: isDark,
              emeraldColor: emeraldColor,
            ),
            const SizedBox(height: 10),
            _ModeRow(
              icon: Icons.balance,
              title: l10n.sleepPlan_mode_balanced_title,
              body: l10n.sleepPlan_mode_balanced_body,
              isDark: isDark,
              emeraldColor: emeraldColor,
            ),
            const SizedBox(height: 10),
            _ModeRow(
              icon: Icons.hotel,
              title: l10n.sleepPlan_mode_healthyReplay_title,
              body: l10n.sleepPlan_mode_healthyReplay_body,
              isDark: isDark,
              emeraldColor: emeraldColor,
              cta: OutlinedButton(
                onPressed: () => showReplayPlannerDialog(context, match),
                style: OutlinedButton.styleFrom(
                  foregroundColor: emeraldColor,
                  side: BorderSide(color: emeraldColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: theme.textTheme.labelSmall,
                ),
                child: Text(l10n.sleepPlan_mode_healthyReplay_cta),
              ),
            ),

            const SizedBox(height: 14),

            // Disclaimer
            Text(
              l10n.sleepPlan_disclaimer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeRow extends StatelessWidget {
  const _ModeRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.isDark,
    required this.emeraldColor,
    this.cta,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool isDark;
  final Color emeraldColor;
  final Widget? cta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tileBgColor = isDark
        ? const Color(0x0AFFFFFF)
        : Colors.white.withValues(alpha: 0.45);
    final tileBorderColor = isDark
        ? const Color(0x2694A3B8)
        : Colors.white.withValues(alpha: 0.6);

    return Container(
      decoration: BoxDecoration(
        color: tileBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tileBorderColor, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: emeraldColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              body,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            if (cta != null) ...[
              const SizedBox(height: 8),
              cta!,
            ],
          ],
        ),
      ),
    );
  }
}
