import 'package:flutter/foundation.dart';

/// Immutable model for a single rule card.
///
/// 21 cards total: 7 topics × 3 levels (newbie, casual, advanced).
/// Content is loaded from `assets/data/rule_cards.json`.
@immutable
class RuleCard {
  const RuleCard({
    required this.id,
    required this.topic,
    required this.level,
    required this.titleEn,
    required this.titleVi,
    required this.summaryEn,
    required this.summaryVi,
    required this.bodyEn,
    required this.bodyVi,
    required this.tags,
    required this.lastReviewed,
    this.estimatedReadSeconds,
    this.relatedIds = const [],
    this.ifabReference,
  });

  final String id;
  final String topic;

  /// Level: "newbie", "casual", or "advanced".
  final String level;

  final String titleEn;
  final String titleVi;
  final String summaryEn;
  final String summaryVi;
  final String bodyEn;
  final String bodyVi;
  final List<String> tags;
  final String lastReviewed;
  final int? estimatedReadSeconds;
  final List<String> relatedIds;
  final String? ifabReference;

  factory RuleCard.fromJson(Map<String, dynamic> json) {
    return RuleCard(
      id: json['id'] as String,
      topic: json['topic'] as String,
      level: json['level'] as String,
      titleEn: json['title_en'] as String,
      titleVi: json['title_vi'] as String,
      summaryEn: json['summary_en'] as String,
      summaryVi: json['summary_vi'] as String,
      bodyEn: json['body_en'] as String,
      bodyVi: json['body_vi'] as String,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastReviewed: json['lastReviewed'] as String? ?? '',
      estimatedReadSeconds: json['estimatedReadSeconds'] as int?,
      relatedIds: (json['relatedIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ifabReference: json['ifabReference'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuleCard &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'RuleCard(id: $id, topic: $topic, level: $level)';
}
