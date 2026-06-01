import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

/// Renders a country flag from an ISO alpha-2 code.
///
/// Handles subdivision codes for Scotland (GB-SCT) and England (GB-ENG)
/// by falling back to the GB flag, since the `flag` package uses ISO 3166-1
/// alpha-2 codes only.
///
/// For TBD/unknown teams, shows a placeholder icon.
class FlagAvatar extends StatelessWidget {
  const FlagAvatar({
    super.key,
    required this.isoAlpha2,
    this.size = 32.0,
    this.isCircle = false,
  });

  /// ISO alpha-2 code (e.g. "US", "GB-SCT", "GB-ENG").
  final String isoAlpha2;

  /// Width and height of the flag widget.
  final double size;

  /// Whether to render the flag as a perfect circle.
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    // Handle subdivision codes — fall back to parent country flag
    final code = _normalizeCode(isoAlpha2);

    if (code == null) {
      // TBD or unknown team
      return SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.sports_soccer,
          size: size * 0.75,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    if (isCircle) {
      return ClipOval(
        child: Flag.fromString(
          code,
          width: size,
          height: size,
          fit: BoxFit.cover,
          replacement: Icon(
            Icons.flag,
            size: size * 0.75,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Flag.fromString(
        code,
        width: size,
        height: size * 0.67,
        fit: BoxFit.cover,
        replacement: Icon(
          Icons.flag,
          size: size * 0.75,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Normalizes subdivision codes to their parent country code.
  /// Returns null for unknown/TBD.
  static String? _normalizeCode(String code) {
    if (code.isEmpty || code == 'TBD') return null;
    // Scotland and England use GB subdivision codes
    if (code == 'GB-SCT' || code == 'GB-ENG') return 'GB';
    // Standard 2-letter codes
    if (code.length == 2) return code;
    return null;
  }
}
