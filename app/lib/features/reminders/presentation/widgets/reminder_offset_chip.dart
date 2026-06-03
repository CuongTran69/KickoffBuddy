import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../reminder_l10n.dart';

/// A single chip for a reminder offset option.
///
/// Renders a [FilterChip] with a human-readable label derived from
/// [offsetMinutes] (1440 → "1 ngày", 180 → "3 giờ", 30 → "30 phút", 5 → "5 phút").
class ReminderOffsetChip extends StatelessWidget {
  const ReminderOffsetChip({
    super.key,
    required this.offsetMinutes,
    required this.selected,
    required this.onTap,
  });

  final int offsetMinutes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FilterChip(
      label: Text(l10n.offsetLabelLocalized(offsetMinutes)),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
