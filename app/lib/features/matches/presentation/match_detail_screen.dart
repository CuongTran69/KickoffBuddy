import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/analytics/analytics_events.dart';
import '../../../core/analytics/analytics_provider.dart';
import '../../../core/routing/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../application/team_lookup_service.dart';
import '../application/user_matches_provider.dart';
import '../data/match.dart';
import '../data/match_repository.dart';
import '../../reminders/presentation/reminder_sheet.dart';
import '../../replay_planner/application/replay_planner_controller.dart';
import '../../replay_planner/application/shield_status_provider.dart';
import '../../replay_planner/presentation/replay_planner_dialog.dart';
import '../../replay_planner/presentation/widgets/spoiler_banner.dart';
import 'widgets/flag_avatar.dart';

/// Provider that fetches a single match by its application-level ID.
final matchByIdProvider =
    FutureProvider.family<Match?, String>((ref, matchId) async {
  final repo = await ref.watch(matchRepositoryProvider.future);
  return repo.getById(matchId);
});

/// Displays full match details with timezone-aware kickoff time.
///
/// Shows: team flags + VN names, kickoff in user TZ with day-of-week,
/// venue city, group/round, matchday, notes.
/// "Add to / Remove from my matches" toggle.
/// "Set reminder" button (or "Match started" label if kicked off).
/// "Plan replay" button with spoiler shield integration.
/// Edit + Delete only for user-created matches (isSeeded == false).
class MatchDetailScreen extends ConsumerWidget {
  const MatchDetailScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchByIdProvider(matchId));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.matchDetail_appBar_title),
      ),
      body: matchAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _NotFoundState(
          message: e.toString(),
          onBack: () => context.go(Routes.matches),
        ),
        data: (match) {
          if (match == null) {
            return _NotFoundState(
              message: l10n.matchDetail_notFound,
              onBack: () => context.go(Routes.matches),
            );
          }
          return _MatchDetailBody(match: match);
        },
      ),
    );
  }
}

class _MatchDetailBody extends ConsumerStatefulWidget {
  const _MatchDetailBody({required this.match});

  final Match match;

  @override
  ConsumerState<_MatchDetailBody> createState() => _MatchDetailBodyState();
}

class _MatchDetailBodyState extends ConsumerState<_MatchDetailBody> {
  @override
  void initState() {
    super.initState();
    // Fire match_viewed analytics once on first build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final match = widget.match;
      final source = match.isSeeded
          ? 'seed'
          : (match.sourceText != null ? 'magic_add' : 'manual');
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvents.matchViewed,
        {'match_id': match.matchId, 'source': source},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    final teamLookup = ref.watch(teamLookupProvider);
    final userMatches = ref.watch(userMatchesProvider);
    final isSelected = userMatches.contains(match.matchId);
    final l10n = AppLocalizations.of(context);

    // Watch replay plan state for this match (may update after save/cancel).
    final planState =
        ref.watch(replayPlannerControllerProvider(match.matchId));
    // Watch the shield clock for spoiler shield evaluation.
    final clockAsync = ref.watch(shieldClockProvider);
    final now = clockAsync.valueOrNull ?? DateTime.now();

    // Build a merged match view: use planState for live enabled/plannedAt.
    final effectiveEnabled = planState.enabled;
    final effectivePlannedAt = planState.plannedAt;

    // Compute shield active using live state.
    final shieldActive = effectiveEnabled &&
        effectivePlannedAt != null &&
        now.toUtc().isAfter(match.kickoffAtUtc.toUtc()) &&
        now.toUtc().isBefore(effectivePlannedAt.toUtc());

    final teamAVi = teamLookup.viName(match.teamA);
    final teamBVi = teamLookup.viName(match.teamB);
    final teamAIso = teamLookup.isoAlpha2(match.teamA) ?? '';
    final teamBIso = teamLookup.isoAlpha2(match.teamB) ?? '';

    final localKickoff =
        tz.TZDateTime.from(match.kickoffAtUtc.toUtc(), tz.local);
    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(localKickoff);
    final timeStr = DateFormat('HH:mm').format(localKickoff);

    final theme = Theme.of(context);
    final isKickedOff =
        match.kickoffAtUtc.toUtc().isBefore(DateTime.now().toUtc());

    return Column(
      children: [
        // Spoiler banner at top of body (D7), shown only during shield window.
        if (shieldActive)
          SpoilerBanner(
            plannedAtLocal:
                tz.TZDateTime.from(effectivePlannedAt.toUtc(), tz.local),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero: teams
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _TeamColumn(
                              isoAlpha2: teamAIso,
                              name: teamAVi,
                              flagSize: 72,
                            ),
                            // Show scoreline when scores are available,
                            // otherwise show "vs".
                            if (match.scoreA != null && match.scoreB != null)
                              _ScoreDisplay(match: match, l10n: l10n)
                            else
                              Text(
                                'vs',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            _TeamColumn(
                              isoAlpha2: teamBIso,
                              name: teamBVi,
                              flagSize: 72,
                            ),
                          ],
                        ),
                        // Status badge
                        if (match.matchStatus != null) ...[
                          const SizedBox(height: 12),
                          _StatusBadge(status: match.matchStatus!, l10n: l10n),
                        ],
                        // Penalty line — only when both are non-null and > 0
                        if (match.penaltyA != null &&
                            match.penaltyB != null &&
                            (match.penaltyA! > 0 || match.penaltyB! > 0)) ...[
                          const SizedBox(height: 8),
                          Text(
                            l10n.matchDetail_score_penalties(
                                match.penaltyA!, match.penaltyB!),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Match info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.calendar_today,
                          label: l10n.matchDetail_label_date,
                          value: dateStr,
                        ),
                        _InfoRow(
                          icon: Icons.schedule,
                          label: l10n.matchDetail_label_time,
                          value: timeStr,
                        ),
                        if (match.venueCity != null)
                          _InfoRow(
                            icon: Icons.location_on,
                            label: l10n.matchDetail_label_venue,
                            value: match.venueCity!,
                          ),
                        // Full venue name from API (overrides venueCity when present)
                        if (match.venueName != null &&
                            match.venueName!.isNotEmpty &&
                            match.venueName != match.venueCity)
                          _InfoRow(
                            icon: Icons.stadium,
                            label: l10n.matchDetail_label_venue,
                            value: match.venueName!,
                          ),
                        if (match.winner != null && match.winner!.isNotEmpty)
                          _InfoRow(
                            icon: Icons.emoji_events,
                            label: l10n.matchDetail_label_winner,
                            value: match.winner!,
                          ),
                        if (match.attendance != null &&
                            match.attendance!.isNotEmpty)
                          _InfoRow(
                            icon: Icons.people,
                            label: l10n.matchDetail_label_attendance,
                            value: match.attendance!,
                          ),
                        if (match.worldCupRound == 'group_stage' &&
                            match.worldCupGroup != null)
                          _InfoRow(
                            icon: Icons.group,
                            label: l10n.matchDetail_label_group,
                            value: l10n.matchDetail_label_groupValue(match.worldCupGroup!),
                          ),
                        if (match.worldCupRound != null)
                          _InfoRow(
                            icon: Icons.emoji_events,
                            label: l10n.matchDetail_label_round,
                            value: _roundLabel(match.worldCupRound!, l10n),
                          ),
                        if (match.matchday != null)
                          _InfoRow(
                            icon: Icons.format_list_numbered,
                            label: l10n.matchDetail_label_matchday,
                            value: l10n.matchDetail_label_matchdayValue(match.matchday!),
                          ),
                        if (match.notes.isNotEmpty)
                          _InfoRow(
                            icon: Icons.notes,
                            label: l10n.matchDetail_label_notes,
                            value: match.notes,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Primary action: My matches toggle
                FilledButton.icon(
                  icon: Icon(
                      isSelected ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(
                    isSelected
                        ? l10n.matchDetail_btn_removeFromMyMatches
                        : l10n.matchDetail_btn_addToMyMatches,
                  ),
                  onPressed: () => ref
                      .read(userMatchesProvider.notifier)
                      .toggle(match.matchId),
                ),
                const SizedBox(height: 8),

                // Secondary actions row
                Row(
                  children: [
                    Expanded(
                      child: isKickedOff
                          ? OutlinedButton.icon(
                              icon: const Icon(Icons.notifications_off_outlined),
                              label: Text(l10n.matchDetail_btn_matchStarted),
                              onPressed: null,
                            )
                          : OutlinedButton.icon(
                              icon: const Icon(Icons.notifications_outlined),
                              label: Text(l10n.matchDetail_btn_setReminder),
                              onPressed: () =>
                                  showReminderSheet(context, match),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.replay),
                        label: Text(l10n.matchDetail_btn_planReplay),
                        onPressed: () =>
                            showReplayPlannerDialog(context, match),
                      ),
                    ),
                  ],
                ),

                // Cancel replay plan (only if plan exists)
                if (effectiveEnabled) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: theme.colorScheme.error,
                    ),
                    label: Text(
                      l10n.matchDetail_btn_cancelReplayPlan,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    onPressed: () =>
                        _confirmCancelPlan(context, l10n),
                  ),
                ],

                // Edit/Delete only for user-created matches — below a Divider
                if (!match.isSeeded) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: Text(l10n.matchDetail_btn_edit),
                          onPressed: () => context.push(
                            '${Routes.matchesAdd}?edit=${match.matchId}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          label: Text(
                            l10n.matchDetail_btn_delete,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          onPressed: () =>
                              _confirmDelete(context, l10n),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmCancelPlan(
      BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.matchDetail_dialog_cancelPlan_title),
        content: Text(l10n.matchDetail_dialog_cancelPlan_body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_btn_no),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.matchDetail_btn_cancelReplayPlan),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final controller = ref.read(
        replayPlannerControllerProvider(widget.match.matchId).notifier,
      );
      await controller.cancelPlan(widget.match);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.matchDetail_snackbar_cancelledPlan)),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.matchDetail_dialog_delete_title),
        content: Text(l10n.matchDetail_dialog_delete_body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_btn_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.matchDetail_btn_delete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final repo = await ref.read(matchRepositoryProvider.future);
      await repo.delete(widget.match.matchId);
      if (context.mounted) {
        context.go(Routes.matches);
      }
    }
  }

  String _roundLabel(String round, AppLocalizations l10n) {
    switch (round) {
      case 'group_stage':
        return l10n.matchDetail_round_groupStage;
      case 'round_of_32':
        return l10n.matchDetail_round_roundOf32;
      case 'round_of_16':
        return l10n.matchDetail_round_roundOf16;
      case 'quarter_final':
        return l10n.matchDetail_round_quarterFinal;
      case 'semi_final':
        return l10n.matchDetail_round_semiFinal;
      case 'third_place':
        return l10n.matchDetail_round_thirdPlace;
      case 'final':
        return l10n.matchDetail_round_final;
      default:
        return round;
    }
  }
}

class _TeamColumn extends StatelessWidget {
  const _TeamColumn({
    required this.isoAlpha2,
    required this.name,
    required this.flagSize,
  });

  final String isoAlpha2;
  final String name;
  final double flagSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlagAvatar(isoAlpha2: isoAlpha2, size: flagSize),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Text(value,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the live/final scoreline prominently.
class _ScoreDisplay extends StatelessWidget {
  const _ScoreDisplay({required this.match, required this.l10n});

  final Match match;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      '${match.scoreA} – ${match.scoreB}',
      style: theme.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.onSurface,
        letterSpacing: 2,
      ),
    );
  }
}

/// Status badge: LIVE (red), FT (grey), or Scheduled (primary).
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.l10n});

  final String status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'in_progress':
        bgColor = isDark ? const Color(0x33DC2626) : const Color(0x1FDC2626);
        textColor = Colors.redAccent;
        label = l10n.matchDetail_status_live;
      case 'completed':
        bgColor = isDark ? const Color(0x2694A3B8) : const Color(0x1F64748B);
        textColor = isDark ? Colors.white70 : Colors.black54;
        label = l10n.matchDetail_status_ft;
      default:
        bgColor = theme.colorScheme.primaryContainer;
        textColor = theme.colorScheme.onPrimaryContainer;
        label = l10n.matchDetail_status_scheduled;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: status == 'in_progress'
            ? Border.all(color: Colors.redAccent.withValues(alpha: 0.5))
            : null,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _NotFoundState extends StatelessWidget {
  const _NotFoundState({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onBack,
              child: Text(l10n.matchDetail_btn_backToList),
            ),
          ],
        ),
      ),
    );
  }
}

