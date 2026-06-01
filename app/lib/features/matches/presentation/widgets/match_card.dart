import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/team_lookup_service.dart';
import '../../data/match.dart';
import '../../../../core/routing/routes.dart';
import '../../../../features/replay_planner/application/shield_status_provider.dart';
import '../../../../features/replay_planner/presentation/widgets/spoiler_badge.dart';
import 'flag_avatar.dart';

/// Card widget for a single match in the list.
///
/// Displays: home flag + VN name, separator, away flag + VN name,
/// kickoff time in user local TZ, group/round badge, venue city.
/// Today's matches get an Amber left border accent.
class MatchCard extends ConsumerWidget {
  const MatchCard({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamLookup = ref.watch(teamLookupProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final teamAVi = teamLookup.viName(match.teamA);
    final teamBVi = teamLookup.viName(match.teamB);
    final teamAIso = teamLookup.isoAlpha2(match.teamA) ?? '';
    final teamBIso = teamLookup.isoAlpha2(match.teamB) ?? '';

    // Convert kickoff to local time
    final localKickoff = tz.TZDateTime.from(match.kickoffAtUtc.toUtc(), tz.local);
    final timeStr = DateFormat('EEE, MMM d • HH:mm').format(localKickoff);

    // Detect "today" in local timezone
    final now = tz.TZDateTime.now(tz.local);
    final isToday = localKickoff.year == now.year &&
        localKickoff.month == now.month &&
        localKickoff.day == now.day;

    // Badge label
    final badge = _badgeLabel(match, l10n);

    // Spoiler shield status
    final clockAsync = ref.watch(shieldClockProvider);
    final nowUtc = clockAsync.valueOrNull ?? DateTime.now();
    final shieldActive = isShieldActive(match, nowUtc);

    final isDark = theme.brightness == Brightness.dark;
    final hasScore = match.scoreA != null && match.scoreB != null;
    final isLive = match.matchStatus == 'in_progress';
    final amberColor =
        isDark ? AppColors.darkAccent : AppColors.lightAccent;

    final cardBgColor = isDark
        ? const Color(0xBF1E293B) // Translucent Slate-800
        : const Color(0xD9FFFFFF); // Translucent White
    final cardBorderColor = isToday
        ? amberColor.withValues(alpha: 0.6)
        : (isDark ? const Color(0x2694A3B8) : const Color(0x2664748B));

    final double borderWidth = isToday ? 1.8 : (isDark ? 1.0 : 1.5);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 19,
          top: 24,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday ? amberColor : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
              border: Border.all(
                color: isDark ? const Color(0xFF080F16) : const Color(0xFFDCF2E8),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isToday ? amberColor : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary))
                      .withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 48, right: 16, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cardBorderColor,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.25)
                    : const Color(0x0A059669).withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => context.push(Routes.matchDetail(match.matchId)),
              child: Stack(
                children: [
                  if (isToday)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              amberColor.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  if (isToday)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 4.5,
                        color: amberColor,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(isToday ? 16.5 : 12, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0x3310B981) : const Color(0x33059669),
                                  width: 1.5,
                                ),
                              ),
                              child: FlagAvatar(
                                isoAlpha2: teamAIso,
                                size: 32,
                                isCircle: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                teamAVi,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (hasScore) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: isLive
                                    ? BoxDecoration(
                                        color: isDark ? const Color(0x33DC2626) : const Color(0x1FDC2626),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                                      )
                                    : null,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isLive) ...[
                                      const _LivePulsingDot(),
                                      const SizedBox(width: 4),
                                    ],
                                    Text(
                                      '${match.scoreA} – ${match.scoreB}',
                                      style: AppTypography.tabularNumbers(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isLive 
                                            ? Colors.redAccent 
                                            : (isDark ? Colors.white : AppColors.lightOnSurface),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                            ] else ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                            ],
                            Expanded(
                              child: Text(
                                teamBVi,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0x3310B981) : const Color(0x33059669),
                                  width: 1.5,
                                ),
                              ),
                              child: FlagAvatar(
                                isoAlpha2: teamBIso,
                                size: 32,
                                isCircle: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 13,
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeStr,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            if (shieldActive) ...[
                              const SpoilerBadge(),
                              const SizedBox(width: 4),
                            ],
                            if (isToday) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: amberColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: amberColor.withValues(alpha: 0.3), width: 0.8),
                                ),
                                child: Text(
                                  'Hôm nay',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: amberColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                            if (badge != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  badge,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (match.venueCity != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                match.venueCity!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String? _badgeLabel(Match match, AppLocalizations l10n) {
    if (match.worldCupRound == 'group_stage' && match.worldCupGroup != null) {
      return l10n.matches_badge_group(match.worldCupGroup!);
    }
    switch (match.worldCupRound) {
      case 'round_of_32':
        return l10n.matches_badge_roundOf32;
      case 'round_of_16':
        return l10n.matches_badge_roundOf16;
      case 'quarter_final':
        return l10n.matches_badge_quarterFinal;
      case 'semi_final':
        return l10n.matches_badge_semiFinal;
      case 'third_place':
        return l10n.matches_badge_thirdPlace;
      case 'final':
        return l10n.matches_badge_final;
      default:
        return null;
    }
  }
}

class _LivePulsingDot extends StatefulWidget {
  const _LivePulsingDot();

  @override
  State<_LivePulsingDot> createState() => _LivePulsingDotState();
}

class _LivePulsingDotState extends State<_LivePulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

