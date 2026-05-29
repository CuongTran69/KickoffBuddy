import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_models.dart';

/// Provider for group standings from `/teams`.
///
/// Returns the full [ApiTeamsResponse] with groups sorted A-L (12 groups,
/// WC2026 format), teams within each group sorted by points then goal
/// differential.
///
/// Genuine network/API errors are rethrown so the screen shows its error UI.
/// An empty dataset (no groups) returns an empty [ApiTeamsResponse] so the
/// screen shows its empty state.
final standingsProvider =
    FutureProvider.autoDispose<ApiTeamsResponse>((ref) async {
  final client = ref.watch(apiClientProvider);
  try {
    return await client.getTeams();
  } catch (e) {
    debugPrint('[StandingsProvider] error: $e');
    rethrow;
  }
});
