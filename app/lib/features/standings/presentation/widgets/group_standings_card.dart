import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../matches/application/team_lookup_service.dart';
import '../../../matches/presentation/widgets/flag_avatar.dart';
import '../../../../core/network/api_models.dart';

class GroupStandingsCard extends ConsumerWidget {
  const GroupStandingsCard({
    super.key,
    required this.group,
  });

  final ApiGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final teamLookup = ref.watch(teamLookupProvider);
    final l10n = AppLocalizations.of(context);

    final cardBgColor = isDark
        ? const Color(0xBF1E293B) // Translucent Slate-800
        : const Color(0xD9FFFFFF); // Translucent White
    final cardBorderColor = isDark
        ? const Color(0x2694A3B8)
        : const Color(0x2664748B);

    final textMutedColor =
        isDark ? AppColors.darkOnSurfaceMuted : AppColors.lightOnSurfaceMuted;
    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    // Lighter colour for rank-3 "best third" hint.
    final bestThirdColor = isDark
        ? primaryColor.withValues(alpha: 0.55)
        : primaryColor.withValues(alpha: 0.45);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cardBorderColor,
          width: isDark ? 1.0 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Group letter badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    l10n.standings_group_label(group.letter),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x1F94A3B8)),
          // Table Headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Rank
                SizedBox(
                  width: 20,
                  child: Text(
                    '#',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textMutedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Team name
                Expanded(
                  child: Text(
                    l10n.standings_col_team,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textMutedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Played
                _HeaderCell(label: l10n.standings_col_played, width: 24, textMutedColor: textMutedColor, theme: theme),
                // W-D-L
                _HeaderCell(label: l10n.standings_col_wdl, width: 48, textMutedColor: textMutedColor, theme: theme),
                // GF:GA
                _HeaderCell(label: l10n.standings_col_gfga, width: 44, textMutedColor: textMutedColor, theme: theme),
                // GD
                _HeaderCell(label: l10n.standings_col_gd, width: 28, textMutedColor: textMutedColor, theme: theme),
                // Points
                _HeaderCell(label: l10n.standings_col_points, width: 32, textMutedColor: textMutedColor, theme: theme),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x1F94A3B8)),
          // Team Rows
          // A-L, 12 groups (WC2026 format)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.teams.length,
            padding: const EdgeInsets.symmetric(vertical: 4),
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 12,
              endIndent: 12,
              color: Color(0x0F94A3B8),
            ),
            itemBuilder: (context, index) {
              final team = group.teams[index];
              final rank = index + 1;
              // Ranks 1-2: strong qualify; rank 3: possible best-third advance.
              final isQualifying = rank <= 2;
              final isBestThird = rank == 3;

              final teamVi = teamLookup.viName(team.name);
              final teamIso = teamLookup.isoAlpha2(team.name) ?? '';

              final gdString = team.goalDifferential > 0
                  ? '+${team.goalDifferential}'
                  : '${team.goalDifferential}';

              final rankColor = isQualifying
                  ? primaryColor
                  : isBestThird
                      ? bestThirdColor
                      : (isDark ? Colors.white70 : Colors.black87);

              return Container(
                decoration: isQualifying
                    ? BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.05),
                      )
                    : isBestThird
                        ? BoxDecoration(
                            color: bestThirdColor.withValues(alpha: 0.04),
                          )
                        : null,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      // Rank
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: Text(
                            '$rank',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: rankColor,
                              fontWeight: isQualifying
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Team Info (Flag + Name)
                      Expanded(
                        child: Row(
                          children: [
                            FlagAvatar(isoAlpha2: teamIso, size: 20),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                teamVi,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isQualifying
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Games Played
                      _DataCell(
                        label: '${team.gamesPlayed}',
                        width: 24,
                        color: isDark ? Colors.white70 : Colors.black87,
                        theme: theme,
                      ),
                      // W-D-L
                      _DataCell(
                        label:
                            '${team.wins}-${team.draws}-${team.losses}',
                        width: 48,
                        color: isDark ? Colors.white70 : Colors.black87,
                        theme: theme,
                        fontSize: 11,
                      ),
                      // GF:GA
                      _DataCell(
                        label: '${team.goalsFor}:${team.goalsAgainst}',
                        width: 44,
                        color: isDark ? Colors.white70 : Colors.black87,
                        theme: theme,
                        fontSize: 11,
                      ),
                      // Goal Differential
                      _DataCell(
                        label: gdString,
                        width: 28,
                        color: team.goalDifferential > 0
                            ? Colors.green
                            : (team.goalDifferential < 0
                                ? Colors.redAccent
                                : textMutedColor),
                        theme: theme,
                        fontWeight: team.goalDifferential != 0
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      // Points
                      _DataCell(
                        label: '${team.groupPoints}',
                        width: 32,
                        color: isQualifying
                            ? primaryColor
                            : (isDark ? Colors.white : Colors.black87),
                        theme: theme,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Best-third legend hint
          if (group.teams.length >= 3) ...[
            const Divider(height: 1, color: Color(0x1F94A3B8)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: bestThirdColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.standings_hint_bestThird,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textMutedColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact header cell for the standings table.
class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    required this.width,
    required this.textMutedColor,
    required this.theme,
  });

  final String label;
  final double width;
  final Color textMutedColor;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textMutedColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

/// Compact data cell for the standings table.
class _DataCell extends StatelessWidget {
  const _DataCell({
    required this.label,
    required this.width,
    required this.color,
    required this.theme,
    this.fontWeight = FontWeight.normal,
    this.fontSize,
  });

  final String label;
  final double width;
  final Color color;
  final ThemeData theme;
  final FontWeight fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
