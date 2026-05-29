import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/analytics/analytics_events.dart';
import '../../../core/analytics/analytics_provider.dart';
import '../../../core/storage/prefs_provider.dart';

/// SharedPreferences key for the user's selected match IDs.
const _myMatchesKey = 'my_matches';

/// Controller for the user's "my matches" selection.
///
/// Persists a [Set<String>] of match IDs to SharedPreferences under
/// key [_myMatchesKey]. Independent of the Isar match catalog — survives
/// re-seeding and schema bumps.
class UserMatchesController extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getStringList(_myMatchesKey);
    return stored != null ? Set<String>.from(stored) : <String>{};
  }

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  /// Adds [matchId] to the selection and persists.
  void add(String matchId) {
    final updated = {...state, matchId};
    state = updated;
    _persist(updated);
    // Fire analytics event.
    ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvents.matchAddedToMyMatches, {'match_id': matchId});
  }

  /// Removes [matchId] from the selection and persists.
  void remove(String matchId) {
    final updated = {...state}..remove(matchId);
    state = updated;
    _persist(updated);
  }

  /// Toggles [matchId] in the selection.
  void toggle(String matchId) {
    if (state.contains(matchId)) {
      remove(matchId);
    } else {
      add(matchId);
    }
  }

  /// Returns true if [matchId] is in the selection.
  bool contains(String matchId) => state.contains(matchId);

  void _persist(Set<String> ids) {
    _prefs.setStringList(_myMatchesKey, ids.toList());
  }
}

/// Riverpod provider for [UserMatchesController].
final userMatchesProvider =
    NotifierProvider<UserMatchesController, Set<String>>(
  UserMatchesController.new,
);
