import 'package:flutter/material.dart';

import '../../application/reminder_scheduler.dart';

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
    return FilterChip(
      label: Text(offsetLabel(offsetMinutes)),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
