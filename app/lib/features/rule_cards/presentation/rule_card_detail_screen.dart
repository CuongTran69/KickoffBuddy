import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_events.dart';
import '../../../core/analytics/analytics_provider.dart';
import '../../../core/routing/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../application/rule_cards_controller.dart';
import '../data/rule_card.dart';
import '../data/rule_card_repository.dart';

/// Detail screen for a single rule card.
///
/// Shows VN content by default with a toggle to switch to English.
/// Includes: title, level badge, body, tags, read time, related cards.
class RuleCardDetailScreen extends ConsumerStatefulWidget {
  const RuleCardDetailScreen({super.key, required this.ruleId});

  final String ruleId;

  @override
  ConsumerState<RuleCardDetailScreen> createState() =>
      _RuleCardDetailScreenState();
}

class _RuleCardDetailScreenState extends ConsumerState<RuleCardDetailScreen> {
  bool _showEnglish = false;
  Future<RuleCard?>? _cardFuture;
  bool _analyticsLogged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache the future so FutureBuilder doesn't re-run on every setState.
    _cardFuture ??= ref.read(ruleCardRepositoryProvider).getById(widget.ruleId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rules_detail_appBar_title),
        actions: [
          // VN/EN toggle with accessibility semantics
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.rules_detail_toggle_english,
                style: theme.textTheme.labelMedium,
              ),
              Semantics(
                label: l10n.a11y_toggleEnVi,
                child: Switch(
                  value: _showEnglish,
                  onChanged: (v) => setState(() => _showEnglish = v),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: FutureBuilder<RuleCard?>(
        future: _cardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    l10n.rules_detail_error_load,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.rules_detail_btn_back),
                  ),
                ],
              ),
            );
          }

          final card = snapshot.data;

          if (card == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    l10n.rules_detail_notFound,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.rules_detail_btn_back),
                  ),
                ],
              ),
            );
          }

          final title = _showEnglish ? card.titleEn : card.titleVi;
          final body = _showEnglish ? card.bodyEn : card.bodyVi;
          final levelLabel = _levelLabel(
            RuleLevel.values.firstWhere(
              (l) => l.jsonValue == card.level,
              orElse: () => RuleLevel.newbie,
            ),
            l10n,
          );

          // Fire rule_card_viewed once on first successful load.
          if (!_analyticsLogged) {
            _analyticsLogged = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(analyticsServiceProvider).logEvent(
                AnalyticsEvents.ruleCardViewed,
                {'topic': card.topic, 'level': card.level},
              );
            });
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Title
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Level badge
              Chip(
                label: Text(levelLabel),
                visualDensity: VisualDensity.compact,
                backgroundColor: theme.colorScheme.secondaryContainer,
                labelStyle: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              // Body text
              Text(
                body,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              // Tags
              if (card.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: card.tags
                      .map(
                        (tag) => Chip(
                          label: Text('#$tag'),
                          visualDensity: VisualDensity.compact,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          labelStyle: theme.textTheme.labelSmall,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              // Read time
              if (card.estimatedReadSeconds != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.rules_detail_readTime(card.estimatedReadSeconds!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              // Related cards
              if (card.relatedIds.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  l10n.rules_detail_seeAlso,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _RelatedCardsList(
                  relatedIds: card.relatedIds,
                  repo: ref.watch(ruleCardRepositoryProvider),
                ),
              ],
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  String _levelLabel(RuleLevel level, AppLocalizations l10n) {
    switch (level) {
      case RuleLevel.newbie:
        return l10n.rules_level_newbie;
      case RuleLevel.casual:
        return l10n.rules_level_casual;
      case RuleLevel.advanced:
        return l10n.rules_level_advanced;
    }
  }
}

/// Loads and displays related cards as tappable list items.
class _RelatedCardsList extends StatelessWidget {
  const _RelatedCardsList({
    required this.relatedIds,
    required this.repo,
  });

  final List<String> relatedIds;
  final RuleCardRepository repo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: relatedIds.map((id) {
        return FutureBuilder<RuleCard?>(
          future: repo.getById(id),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const SizedBox.shrink();
            }
            final related = snapshot.data!;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.article_outlined),
              title: Text(related.titleVi),
              subtitle: Text(
                related.summaryVi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.ruleDetail(id)),
            );
          },
        );
      }).toList(),
    );
  }
}
