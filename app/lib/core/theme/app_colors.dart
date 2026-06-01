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

  // New tokens — light
  static const Color lightSurfaceContainerHigh = Color(0xFFE2E8F0); // Slate-200
  static const Color lightOnSurfaceMuted = Color(0xFF64748B); // Slate-500
  static const Color lightPrimaryDim = Color(0xFF047857); // Emerald-700
  static const Color lightError = Color(0xFFDC2626); // Red-600

  // ---------------------------------------------------------------------------
  // Dark mode (priority)
  // ---------------------------------------------------------------------------
  static const Color darkPrimary = Color(0xFF10B981); // Emerald — "pitch green"
  static const Color darkSurface = Color(0xFF0F172A); // Slate-900
  static const Color darkSurfaceVariant = Color(0xFF1E293B); // Slate-800
  static const Color darkOnSurface = Color(0xFFF1F5F9); // Slate-100
  static const Color darkAccent = Color(0xFFFBBF24); // Amber — countdown "kickoff in X"

  // New tokens — dark
  static const Color darkSurfaceContainerHigh = Color(0xFF334155); // Slate-700
  static const Color darkOnSurfaceMuted = Color(0xFF94A3B8); // Slate-400
  static const Color darkPrimaryDim = Color(0xFF047857); // Emerald-700
  static const Color darkError = Color(0xFFF87171); // Red-400
}
