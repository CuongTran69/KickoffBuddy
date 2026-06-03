import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/error_messages.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../application/standings_provider.dart';
import 'widgets/group_standings_card.dart';

class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final standingsAsync = ref.watch(standingsProvider);

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: RefreshIndicator(
          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          onRefresh: () async {
            // Force refresh the standings provider
            ref.invalidate(standingsProvider);
            // Wait until it gets updated
            await ref.read(standingsProvider.future);
          },
          child: standingsAsync.when(
            data: (response) {
              if (response.groups.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 64,
                            color: isDark ? AppColors.darkOnSurfaceMuted : AppColors.lightOnSurfaceMuted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.standings_empty_title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => ref.invalidate(standingsProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(l10n.standings_btn_retry),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100), // padding for floating tabbar
                itemCount: response.groups.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                      child: Text(
                        l10n.nav_standings,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    );
                  }
                  final group = response.groups[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GroupStandingsCard(group: group),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (err, stack) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: isDark ? AppColors.darkError : AppColors.lightError,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.standings_error_title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        friendlyErrorMessage(l10n, err),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.darkOnSurfaceMuted : AppColors.lightOnSurfaceMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(standingsProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(l10n.standings_btn_retry),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
