import 'package:flutter/material.dart';

/// Color tokens for Kickoff Buddy.
/// Locked palette — see docs/architecture/06-design-system.md "Decisions (locked 2026-05-28)".
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Light mode
  // ---------------------------------------------------------------------------
  static const Color lightPrimary = Color(0xFF059669); // Emerald-600
  static const Color lightSurface = Color(0xFFFFFFFF); // White
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9); // Slate-100
  static const Color lightOnSurface = Color(0xFF0F172A); // Slate-900
  static const Color lightAccent = Color(0xFFFBBF24); // Amber

  // ---------------------------------------------------------------------------
  // Dark mode (priority)
  // ---------------------------------------------------------------------------
  static const Color darkPrimary = Color(0xFF10B981); // Emerald — "pitch green"
  static const Color darkSurface = Color(0xFF0F172A); // Slate-900
  static const Color darkSurfaceVariant = Color(0xFF1E293B); // Slate-800
  static const Color darkOnSurface = Color(0xFFF1F5F9); // Slate-100
  static const Color darkAccent = Color(0xFFFBBF24); // Amber — countdown "kickoff in X"
}
