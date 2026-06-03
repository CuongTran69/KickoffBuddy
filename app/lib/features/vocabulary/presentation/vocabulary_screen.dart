import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../application/vocabulary_search_controller.dart';
import 'widgets/vocabulary_search_bar.dart';
import 'widgets/vocabulary_tile.dart';

/// Single-screen vocabulary browser with search and inline expand.
///
/// Features:
/// - Search bar with 200ms debounce (D4).
/// - Alphabetically sorted list (sorted in repository).
/// - Tap row → inline expand showing full content.
/// - Related-term chip → scroll to and expand that term.
/// - Multi-expand allowed (each tile tracks its own state here).
class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  /// Tracks which item IDs are currently expanded.
  final Map<String, bool> _expandedState = {};

  /// GlobalKeys for each item — used for scroll-to-item.
  final Map<String, GlobalKey> _itemKeys = {};

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpanded(String id) {
    setState(() {
      _expandedState[id] = !(_expandedState[id] ?? false);
    });
  }

  void _forceExpand(String id) {
    setState(() {
      _expandedState[id] = true;
    });
  }

  /// Handle related-term chip tap.
  ///
  /// If the target is in the current results → scroll to it and expand.
  /// If filtered out → clear search, then on next frame scroll and expand.
  void _onRelatedTap(String relatedId, List<String> currentResultIds) {
    if (currentResultIds.contains(relatedId)) {
      _forceExpand(relatedId);
      _scrollToItem(relatedId);
    } else {
      // Clear search first, then scroll on next frame.
      _searchController.clear();
      ref.read(vocabularySearchControllerProvider.notifier).setQuery('');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _forceExpand(relatedId);
        _scrollToItem(relatedId);
      });
    }
  }

  void _scrollToItem(String id) {
    final key = _itemKeys[id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(vocabularySearchControllerProvider);
    final results = searchState.results;
    final currentResultIds = results.map((i) => i.id).toList();
    final termNames =
        ref.watch(vocabularyTermNamesProvider).valueOrNull ?? const {};
    // Keep keys only for currently-displayed items so the map cannot grow
    // without bound as the user searches (design D11).
    final resultIdSet = currentResultIds.toSet();
    _itemKeys.removeWhere((id, _) => !resultIdSet.contains(id));
    for (final item in results) {
      _itemKeys.putIfAbsent(item.id, () => GlobalKey());
    }

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                AppLocalizations.of(context).vocabulary_appBar_title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: VocabularySearchBar(controller: _searchController),
            ),
            // Results list
            Expanded(
              child: searchState.loading && results.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : results.isEmpty && searchState.query.isNotEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4).copyWith(bottom: 20),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final item = results[index];
                            return KeyedSubtree(
                              key: _itemKeys[item.id],
                              child: VocabularyTile(
                                item: item,
                                expanded: _expandedState[item.id] ?? false,
                                onToggle: () => _toggleExpanded(item.id),
                                onRelatedTap: (relatedId) =>
                                    _onRelatedTap(relatedId, currentResultIds),
                                relatedNameResolver: (id) => termNames[id] ?? id,
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48),
          const SizedBox(height: 16),
          Text(
            l10n.vocabulary_empty_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              _searchController.clear();
              ref
                  .read(vocabularySearchControllerProvider.notifier)
                  .setQuery('');
            },
            child: Text(l10n.vocabulary_empty_clearSearch),
          ),
        ],
      ),
    );
  }
}
