import 'package:flutter/material.dart';

/// Maps a content-supplied icon name string to a Material [IconData].
///
/// Shared by the etiquette and format-guide list screens (design D10). Unknown
/// names fall back to [Icons.info_outline]. Add new names here as content needs
/// them rather than duplicating per-screen switch statements.
IconData iconFromName(String name) {
  switch (name) {
    // Etiquette
    case 'block':
      return Icons.block;
    case 'school':
      return Icons.school;
    case 'local_bar':
      return Icons.local_bar;
    case 'celebration':
      return Icons.celebration;
    case 'sports':
      return Icons.sports;
    case 'timer':
      return Icons.timer;
    // Format guide
    case 'public':
      return Icons.public;
    case 'trending_up':
      return Icons.trending_up;
    case 'compare_arrows':
      return Icons.compare_arrows;
    case 'format_list_numbered':
      return Icons.format_list_numbered;
    case 'emoji_events':
      return Icons.emoji_events;
    // Shared
    case 'groups':
      return Icons.groups;
    default:
      return Icons.info_outline;
  }
}
