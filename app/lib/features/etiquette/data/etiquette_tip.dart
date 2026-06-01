import 'package:flutter/foundation.dart';

/// Immutable model for a single fan etiquette tip.
///
/// 7 tips total, loaded from `assets/data/etiquette_tips.json`.
/// Content is Vietnamese-only for MVP.
@immutable
class EtiquetteTip {
  const EtiquetteTip({
    required this.id,
    required this.titleVi,
    required this.bodyVi,
    required this.icon,
  });

  final String id;
  final String titleVi;
  final String bodyVi;

  /// Material icon name string (e.g. "block", "groups", "school").
  final String icon;

  factory EtiquetteTip.fromJson(Map<String, dynamic> json) {
    return EtiquetteTip(
      id: json['id'] as String,
      titleVi: json['titleVi'] as String,
      bodyVi: json['bodyVi'] as String,
      icon: json['icon'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EtiquetteTip &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'EtiquetteTip(id: $id)';
}
