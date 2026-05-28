import 'package:flutter/material.dart';

/// Placeholder ThemeExtension for Replay Planner feature-specific color tokens.
/// Sprint 3 will populate the actual values.
@immutable
class ReplayPlannerColors extends ThemeExtension<ReplayPlannerColors> {
  const ReplayPlannerColors({
    this.bannerBackground,
    this.bannerForeground,
  });

  final Color? bannerBackground;
  final Color? bannerForeground;

  @override
  ReplayPlannerColors copyWith({
    Color? bannerBackground,
    Color? bannerForeground,
  }) {
    return ReplayPlannerColors(
      bannerBackground: bannerBackground ?? this.bannerBackground,
      bannerForeground: bannerForeground ?? this.bannerForeground,
    );
  }

  @override
  ReplayPlannerColors lerp(ReplayPlannerColors? other, double t) {
    if (other == null) return this;
    return ReplayPlannerColors(
      bannerBackground: Color.lerp(bannerBackground, other.bannerBackground, t),
      bannerForeground: Color.lerp(bannerForeground, other.bannerForeground, t),
    );
  }
}
