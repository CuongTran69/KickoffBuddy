import 'package:flutter/material.dart';

/// Color tokens for Kickoff Buddy.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Light mode
  // ---------------------------------------------------------------------------
  static const Color lightPrimary = Color(0xFF0066FF); // Vibrant Royal Blue
  static const Color lightSurface = Color(0xFFFAFAFA); // Clean Off-White
  static const Color lightSurfaceVariant = Color(0xFFF0F4F8); // Soft Blue-Gray
  static const Color lightOnSurface = Color(0xFF0F172A); // Navy-Slate
  static const Color lightAccent = Color(0xFF7C3AED); // Royal Purple

  // New tokens — light
  static const Color lightSurfaceContainerHigh = Color(0xFFE1E8F0); // Border Gray
  static const Color lightOnSurfaceMuted = Color(0xFF64748B); // Cool Gray
  static const Color lightPrimaryDim = Color(0xFF0052D4); // Dimmed Royal Blue
  static const Color lightError = Color(0xFFDC2626); // Red-600

  // ---------------------------------------------------------------------------
  // Dark mode (priority)
  // ---------------------------------------------------------------------------
  static const Color darkPrimary = Color(0xFF00E5FF); // Electric Neon Cyan
  static const Color darkSurface = Color(0xFF080C16); // Deep Midnight Space Blue
  static const Color darkSurfaceVariant = Color(0xFF151C2C); // Rich Navy-Slate
  static const Color darkOnSurface = Color(0xFFF8FAFC); // Ice White
  static const Color darkAccent = Color(0xFFFF9F00); // Sunset Amber

  // New tokens — dark
  static const Color darkSurfaceContainerHigh = Color(0xFF222C44); // Border Navy-Slate
  static const Color darkOnSurfaceMuted = Color(0xFF94A3B8); // Cool Grey
  static const Color darkPrimaryDim = Color(0xFF00B8D4); // Dimmed Neon Cyan
  static const Color darkError = Color(0xFFFF4D4D); // Vibrant Red
}
