import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
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
        ? AppColors.darkSurfaceVariant.withValues(alpha: 0.8)
        : AppColors.lightSurface;
    final cardBorderColor = isDark
        ? AppColors.darkSurfaceContainerHigh.withValues(alpha: 0.4)
        : AppColors.lightSurfaceContainerHigh;

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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cardBorderColor,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Group letter badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.25),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    l10n.standings_group_label(group.letter),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: cardBorderColor.withValues(alpha: 0.5)),
          // Table Headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Rank
                const SizedBox(
                  width: 24,
                  child: Text(
                    '#',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Team name
                Expanded(
                  child: Text(
                    l10n.standings_col_team,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textMutedColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 0.2,
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
          Divider(height: 1, color: cardBorderColor.withValues(alpha: 0.5)),
          // Team Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.teams.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: cardBorderColor.withValues(alpha: 0.25),
            ),
            itemBuilder: (context, index) {
              final team = group.teams[index];
              final rank = index + 1;
              final isQualifying = rank <= 2;
              final isBestThird = rank == 3;

              final teamVi = teamLookup.viName(team.name);
              final teamIso = teamLookup.isoAlpha2(team.name) ?? '';

              final gdString = team.goalDifferential > 0
                  ? '+${team.goalDifferential}'
                  : '${team.goalDifferential}';

              final rankColor = isQualifying
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : isBestThird
                      ? bestThirdColor
                      : (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface);

              return Container(
                decoration: isQualifying
                    ? BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.03),
                      )
                    : isBestThird
                        ? BoxDecoration(
                            color: bestThirdColor.withValues(alpha: 0.02),
                          )
                        : null,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      // Rank Badge
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isQualifying
                                ? primaryColor.withValues(alpha: 0.12)
                                : isBestThird
                                    ? bestThirdColor.withValues(alpha: 0.1)
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                            border: isQualifying || isBestThird
                                ? Border.all(
                                    color: isQualifying
                                        ? primaryColor.withValues(alpha: 0.2)
                                        : bestThirdColor.withValues(alpha: 0.2),
                                    width: 1.0,
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$rank',
                            style: AppTypography.tabularNumbers(
                              fontSize: 11,
                              color: rankColor,
                              fontWeight: isQualifying || isBestThird
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Team Info (Flag + Name)
                      Expanded(
                        child: Row(
                          children: [
                            FlagAvatar(isoAlpha2: teamIso, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                teamVi,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isQualifying
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
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
                        color: isDark ? AppColors.darkOnSurface.withValues(alpha: 0.8) : AppColors.lightOnSurface,
                        theme: theme,
                      ),
                      // W-D-L
                      _DataCell(
                        label: '${team.wins}-${team.draws}-${team.losses}',
                        width: 48,
                        color: isDark ? AppColors.darkOnSurface.withValues(alpha: 0.8) : AppColors.lightOnSurface,
                        theme: theme,
                        fontSize: 11,
                      ),
                      // GF:GA
                      _DataCell(
                        label: '${team.goalsFor}:${team.goalsAgainst}',
                        width: 44,
                        color: isDark ? AppColors.darkOnSurface.withValues(alpha: 0.8) : AppColors.lightOnSurface,
                        theme: theme,
                        fontSize: 11,
                      ),
                      // Goal Differential
                      _DataCell(
                        label: gdString,
                        width: 28,
                        color: team.goalDifferential > 0
                            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                            : (team.goalDifferential < 0
                                ? (isDark ? AppColors.darkError : AppColors.lightError)
                                : textMutedColor),
                        theme: theme,
                        fontWeight: team.goalDifferential != 0
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      // Points
                      _DataCell(
                        label: '${team.groupPoints}',
                        width: 32,
                        color: isQualifying
                            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                            : (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface),
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
            Divider(height: 1, color: cardBorderColor.withValues(alpha: 0.5)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: bestThirdColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
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
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

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
        style: AppTypography.tabularNumbers(
          fontSize: fontSize ?? 12,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
