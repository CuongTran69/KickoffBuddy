import '../../../l10n/app_localizations.dart';
import '../application/reminder_scheduler.dart';

/// Presentation-layer bridge that feeds localized unit words from the ARB into
/// the pure [offsetLabel] function (design D8 — keeps the scheduler testable
/// without a BuildContext dependency).
extension ReminderL10n on AppLocalizations {
  /// Localized human-readable label for a reminder [offsetMinutes] value.
  String offsetLabelLocalized(int offsetMinutes) {
    return offsetLabel(
      offsetMinutes,
      dayUnit: reminder_unit_day,
      daysUnit: reminder_unit_days,
      hourUnit: reminder_unit_hour,
      hoursUnit: reminder_unit_hours,
      minuteUnit: reminder_unit_minute,
      minutesUnit: reminder_unit_minutes,
    );
  }
}
