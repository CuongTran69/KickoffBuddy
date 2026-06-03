import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics_events.dart';
import '../../../core/analytics/analytics_provider.dart';
import '../data/vocabulary_item.dart';
import '../data/vocabulary_repository.dart';

/// State for the vocabulary search controller.
class VocabularySearchState {
  const VocabularySearchState({
    required this.query,
    required this.results,
    this.loading = false,
  });

  final String query;
  final List<VocabularyItem> results;
  final bool loading;

  VocabularySearchState copyWith({
    String? query,
    List<VocabularyItem>? results,
    bool? loading,
  }) {
    return VocabularySearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      loading: loading ?? this.loading,
    );
  }
}

/// Notifier that manages vocabulary search state with 200ms debounce.
///
/// Design decisions:
/// - D4: 200ms debounce on non-empty queries.
/// - Empty query is applied immediately (no debounce) for responsive clearing.
class VocabularySearchNotifier extends Notifier<VocabularySearchState> {
  Timer? _debounceTimer;

  @override
  VocabularySearchState build() {
    // Load all items on init.
    _loadAll();
    return const VocabularySearchState(query: '', results: [], loading: true);
  }

  Future<void> _loadAll() async {
    try {
      final repo = ref.read(vocabularyRepositoryProvider);
      final items = await repo.getAll();
      state = state.copyWith(results: items, loading: false);
    } catch (e) {
      // Clear the loading flag so the UI isn't stuck on a spinner; log for
      // diagnostics (design D7).
      debugPrint('[VocabularySearchNotifier] _loadAll error: $e');
      state = state.copyWith(loading: false);
    }
  }

  /// Update the search query.
  ///
  /// Empty query is applied immediately.
  /// Non-empty query is debounced by 200ms.
  void setQuery(String q) {
    _debounceTimer?.cancel();

    if (q.isEmpty) {
      // Apply immediately — no debounce for clearing.
      _runFilter(q);
      return;
    }

    // Debounce non-empty queries.
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      _runFilter(q);
    });
  }

  Future<void> _runFilter(String q) async {
    state = state.copyWith(query: q, loading: true);
    final repo = ref.read(vocabularyRepositoryProvider);
    final results = await repo.search(q);
    state = state.copyWith(results: results, loading: false);

    // Fire analytics event for non-empty queries after debounce.
    if (q.isNotEmpty) {
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvents.vocabularySearched,
        {
          'query_length': q.length,
          'has_results': results.isNotEmpty,
        },
      );
    }
  }
}

/// Provider for the vocabulary search controller.
final vocabularySearchControllerProvider =
    NotifierProvider<VocabularySearchNotifier, VocabularySearchState>(
  VocabularySearchNotifier.new,
);

/// Maps each vocabulary term ID to its Vietnamese display name.
///
/// Used to render related-term chips with readable names instead of raw IDs
/// (design D14). Loaded once from the repository.
final vocabularyTermNamesProvider =
    FutureProvider<Map<String, String>>((ref) async {
  final repo = ref.read(vocabularyRepositoryProvider);
  final items = await repo.getAll();
  return {for (final item in items) item.id: item.termVi};
});
