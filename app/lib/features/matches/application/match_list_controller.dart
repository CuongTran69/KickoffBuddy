import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../l10n/app_localizations.dart';
import '../data/match.dart';
import '../data/match_repository.dart';

/// Filter options for the match list.
enum MatchFilter { all, groupStage, knockouts }

/// Knockout round identifiers.
const _knockoutRounds = {
  'round_of_32',
  'round_of_16',
  'quarter_final',
  'semi_final',
  'third_place',
  'final',
};

/// Date section labels for the match list.
enum DateSection { today, tomorrow, thisWeek, later, past }

/// A group of matches under a date section.
class MatchDateGroup {
  const MatchDateGroup({required this.section, required this.matches});

  final DateSection section;
  final List<Match> matches;
}

/// Controller that combines repository data with filter state and date grouping.
class MatchListController extends StateNotifier<MatchFilter> {
  MatchListController() : super(MatchFilter.all);

  void setFilter(MatchFilter filter) => state = filter;
}

/// Provider for the filter state.
final matchFilterProvider =
    StateNotifierProvider<MatchListController, MatchFilter>(
  (_) => MatchListController(),
);

/// Provider that returns the filtered + date-grouped match list.
///
/// Backed by [MatchRepository.watchAll] so Isar write-transactions (e.g. from
/// background score polling) automatically surface on the UI without requiring
/// a manual pull-to-refresh.
///
/// Depends on [matchRepositoryProvider] and [matchFilterProvider].
/// Returns [AsyncValue<List<MatchDateGroup>>].
final groupedMatchesProvider =
    StreamProvider<List<MatchDateGroup>>((ref) async* {
  final repo = await ref.watch(matchRepositoryProvider.future);
  final filter = ref.watch(matchFilterProvider);

  yield* repo.watchAll().map((allMatches) {
    // Apply filter
    final filtered = allMatches.where((m) {
      switch (filter) {
        case MatchFilter.all:
          return true;
        case MatchFilter.groupStage:
          return m.worldCupRound == 'group_stage';
        case MatchFilter.knockouts:
          return _knockoutRounds.contains(m.worldCupRound);
      }
    }).toList();

    return _groupByDate(filtered);
  });
});

/// Groups matches into date sections using the device's local timezone.
List<MatchDateGroup> _groupByDate(List<Match> matches) {
  final now = tz.TZDateTime.now(tz.local);
  final todayStart = _startOfDay(now);
  final tomorrowStart = todayStart.add(const Duration(days: 1));
  final thisWeekEnd = todayStart.add(const Duration(days: 7));

  final Map<DateSection, List<Match>> buckets = {
    DateSection.today: [],
    DateSection.tomorrow: [],
    DateSection.thisWeek: [],
    DateSection.later: [],
    DateSection.past: [],
  };

  for (final match in matches) {
    final local = tz.TZDateTime.from(match.kickoffAtUtc.toUtc(), tz.local);
    final matchDay = _startOfDay(local);

    if (matchDay.isBefore(todayStart)) {
      buckets[DateSection.past]!.add(match);
    } else if (matchDay.isAtSameMomentAs(todayStart)) {
      buckets[DateSection.today]!.add(match);
    } else if (matchDay.isAtSameMomentAs(tomorrowStart)) {
      buckets[DateSection.tomorrow]!.add(match);
    } else if (matchDay.isBefore(thisWeekEnd)) {
      buckets[DateSection.thisWeek]!.add(match);
    } else {
      buckets[DateSection.later]!.add(match);
    }
  }

  // Build result in display order: upcoming first, past last
  final result = <MatchDateGroup>[];
  for (final section in [
    DateSection.today,
    DateSection.tomorrow,
    DateSection.thisWeek,
    DateSection.later,
    DateSection.past,
  ]) {
    if (buckets[section]!.isNotEmpty) {
      result.add(MatchDateGroup(section: section, matches: buckets[section]!));
    }
  }
  return result;
}

tz.TZDateTime _startOfDay(tz.TZDateTime dt) {
  return tz.TZDateTime(dt.location, dt.year, dt.month, dt.day);
}

/// Human-readable label for a [DateSection].
String dateSectionLabel(DateSection section, AppLocalizations l10n) {
  switch (section) {
    case DateSection.today:
      return l10n.matches_section_today;
    case DateSection.tomorrow:
      return l10n.matches_section_tomorrow;
    case DateSection.thisWeek:
      return l10n.matches_section_thisWeek;
    case DateSection.later:
      return l10n.matches_section_later;
    case DateSection.past:
      return l10n.matches_section_past;
  }
}
