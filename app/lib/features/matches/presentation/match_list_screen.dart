import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../application/match_list_controller.dart';
import '../application/match_sync_service.dart';
import 'widgets/date_section_header.dart';
import 'widgets/filter_chips.dart';
import 'widgets/match_card.dart';

/// Displays all WC 2026 matches grouped by date in the user's local timezone.
///
/// Filter chips: All / Group Stage / Knockouts.
/// Date sections: Today / Tomorrow / This Week / Later / Past.
class MatchListScreen extends ConsumerWidget {
  const MatchListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(matchFilterProvider);
    final groupedAsync = ref.watch(groupedMatchesProvider);
    final l10n = AppLocalizations.of(context);

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.auto_fix_high),
              tooltip: l10n.matches_tooltip_magicAdd,
              onPressed: () => context.push(Routes.matchesMagicAdd),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.matches_tooltip_add,
              onPressed: () => context.push(Routes.matchesAdd),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                l10n.matches_appBar_title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            MatchFilterChips(
              selected: filter,
              onSelected: (f) =>
                  ref.read(matchFilterProvider.notifier).setFilter(f),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: 24,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 1.5,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkPrimary.withValues(alpha: 0.2)
                          : AppColors.lightPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                  groupedAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => _ErrorState(
                      message: error.toString(),
                      onRetry: () => ref.invalidate(groupedMatchesProvider),
                    ),
                    data: (groups) {
                      Future<void> onRefresh() async {
                        try {
                          await ref.read(matchSyncServiceProvider)?.syncScores();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.matches_syncError(e.toString())),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      }

                      if (groups.isEmpty) {
                        return RefreshIndicator(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          onRefresh: onRefresh,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                              const _EmptyState(),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                        onRefresh: onRefresh,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: _itemCount(groups),
                          itemBuilder: (context, index) =>
                              _buildItem(context, groups, index),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _itemCount(List<MatchDateGroup> groups) {
    return groups.fold(0, (sum, g) => sum + 1 + g.matches.length);
  }

  Widget _buildItem(
      BuildContext context, List<MatchDateGroup> groups, int index) {
    int offset = 0;
    for (final group in groups) {
      if (index == offset) {
        return DateSectionHeader(section: group.section);
      }
      offset++;
      final matchIndex = index - offset;
      if (matchIndex < group.matches.length) {
        return MatchCard(match: group.matches[matchIndex]);
      }
      offset += group.matches.length;
    }
    return const SizedBox.shrink();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_soccer,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.matches_empty_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.matches_retry),
            ),
          ],
        ),
      ),
    );
  }
}

