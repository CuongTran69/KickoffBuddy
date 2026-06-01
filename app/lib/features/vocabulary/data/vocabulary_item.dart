import 'package:flutter/foundation.dart';

/// Immutable model for a single vocabulary term.
///
/// 17 terms total, loaded from `assets/data/vocabulary.json`.
@immutable
class VocabularyItem {
  const VocabularyItem({
    required this.id,
    required this.termEn,
    required this.termVi,
    required this.termViNoDiacritics,
    required this.definitionEn,
    required this.definitionVi,
    required this.exampleEn,
    required this.exampleVi,
    this.related = const [],
    this.category,
  });

  final String id;
  final String termEn;
  final String termVi;

  /// Pre-computed diacritic-stripped version of [termVi] for search.
  /// Example: "Việt vị" → "viet vi".
  final String termViNoDiacritics;

  final String definitionEn;
  final String definitionVi;
  final String exampleEn;
  final String exampleVi;

  /// IDs of related vocabulary terms.
  final List<String> related;

  final String? category;

  factory VocabularyItem.fromJson(Map<String, dynamic> json) {
    return VocabularyItem(
      id: json['id'] as String,
      termEn: json['term_en'] as String,
      termVi: json['term_vi'] as String,
      termViNoDiacritics: json['term_vi_no_diacritics'] as String? ?? '',
      definitionEn: json['definition_en'] as String,
      definitionVi: json['definition_vi'] as String,
      exampleEn: json['example_en'] as String? ?? '',
      exampleVi: json['example_vi'] as String? ?? '',
      related: (json['related'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      category: json['category'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'VocabularyItem(id: $id, termVi: $termVi)';
}
