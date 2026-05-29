import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_models.dart';

/// Provider for currently live matches from `/matches/current`.
///
/// Auto-dispose — data is only kept while a listener is active.
/// Returns an empty list on error (graceful degradation).
final currentMatchesProvider =
    FutureProvider.autoDispose<List<ApiMatch>>((ref) async {
  final client = ref.watch(apiClientProvider);
  try {
    return await client.getCurrentMatches();
  } catch (e) {
    debugPrint('[LiveMatchProvider] currentMatches error: $e');
    return [];
  }
});

/// Provider for today's matches from `/matches/today`.
///
/// Auto-dispose — data is only kept while a listener is active.
/// Returns an empty list on error (graceful degradation).
final todayMatchesProvider =
    FutureProvider.autoDispose<List<ApiMatch>>((ref) async {
  final client = ref.watch(apiClientProvider);
  try {
    return await client.getTodayMatches();
  } catch (e) {
    debugPrint('[LiveMatchProvider] todayMatches error: $e');
    return [];
  }
});
