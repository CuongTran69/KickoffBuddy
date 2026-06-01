import 'package:flutter/foundation.dart';

/// Immutable model for a single tournament format guide section.
///
/// Six sections total, loaded from `assets/data/format_guide.json`.
/// Content is Vietnamese-primary for MVP.
@immutable
class FormatGuideSection {
  const FormatGuideSection({
    required this.id,
    required this.titleVi,
    required this.bodyVi,
    required this.icon,
    this.bullets = const [],
  });

  final String id;
  final String titleVi;
  final String bodyVi;

  /// Material icon name string (e.g. "public", "groups", "trending_up").
  final String icon;

  /// Optional ordered bullet list (e.g. tiebreaker steps, knockout rounds).
  final List<String> bullets;

  factory FormatGuideSection.fromJson(Map<String, dynamic> json) {
    return FormatGuideSection(
      id: json['id'] as String,
      titleVi: json['titleVi'] as String,
      bodyVi: json['bodyVi'] as String,
      icon: json['icon'] as String,
      bullets: (json['bullets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormatGuideSection &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FormatGuideSection(id: $id)';
}
