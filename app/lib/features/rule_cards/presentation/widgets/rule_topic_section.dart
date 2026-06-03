import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/rule_card.dart';
import 'rule_card_tile.dart';

/// A section in the rule cards list for a single topic.
///
/// Shows a topic header and the single card for the active level.
class RuleTopicSection extends StatelessWidget {
  const RuleTopicSection({
    super.key,
    required this.topic,
    required this.topicLabelVi,
    required this.card,
    required this.onCardTap,
  });

  final String topic;
  final String topicLabelVi;

  /// The card to display (one per topic at the active level).
  /// May be null if no card exists for this topic/level (defensive).
  final RuleCard? card;

  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 4),
          child: Text(
            topicLabelVi,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        if (card != null)
          RuleCardTile(card: card!, onTap: onCardTap)
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.rules_empty_state,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
