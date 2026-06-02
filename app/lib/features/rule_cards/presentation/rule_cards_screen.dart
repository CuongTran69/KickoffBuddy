import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../application/rule_cards_controller.dart';
import 'widgets/level_filter_chips.dart';
import 'widgets/rule_topic_section.dart';

/// List screen showing 7 topic sections with one card per topic.
///
/// Supports 3-level filter (Newbie / Casual / Advanced).
/// Default level: Newbie.
class RuleCardsScreen extends ConsumerWidget {
  const RuleCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLevel = ref.watch(ruleLevelFilterProvider);
    final filteredAsync = ref.watch(filteredRuleCardsProvider);
    final l10n = AppLocalizations.of(context);

    // Localized topic labels map
    final topicLabels = <String, String>{
      'offside': l10n.rules_topic_offside,
      'penalty': l10n.rules_topic_penalty,
      'VAR': l10n.rules_topic_var,
      'cards': l10n.rules_topic_cards,
      'stoppage_time': l10n.rules_topic_stoppageTime,
      'extra_time': l10n.rules_topic_extraTime,
      'penalty_shootout': l10n.rules_topic_penaltyShootout,
    };

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: filteredAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  l10n.rules_error_load,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(filteredRuleCardsProvider),
                  child: Text(l10n.rules_btn_retry),
                ),
              ],
            ),
          ),
          data: (cards) {
            // Build a map from topic → card for quick lookup.
            final cardByTopic = {for (final c in cards) c.topic: c};

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(bottom: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: Text(
                    l10n.rules_appBar_title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                // Level filter chips
                LevelFilterChips(
                  currentLevel: currentLevel,
                  onSelected: (level) {
                    ref.read(ruleLevelFilterProvider.notifier).setLevel(level);
                  },
                ),
                const SizedBox(height: 8),
                // 7 topic sections in fixed order
                ...kRuleTopicOrder.map((topic) {
                  final label = topicLabels[topic] ?? topic;
                  final card = cardByTopic[topic];
                  return RuleTopicSection(
                    topic: topic,
                    topicLabelVi: label,
                    card: card,
                    onCardTap: card != null
                        ? () => context.push(Routes.ruleDetail(card.id))
                        : () {},
                  );
                }),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
