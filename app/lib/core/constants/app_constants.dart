/// App-wide named constants for magic numbers.
///
/// Co-locating constants here avoids repeated literals and documents intent.
abstract final class AppConstants {
  /// Bottom padding on screens with a floating tab bar.
  ///
  /// Applied to list padding so content is not hidden behind the tab bar.
  static const double listBottomPadding = 100.0;

  /// How many years ahead the date pickers allow selection.
  ///
  /// Used in manual-add and replay-planner date pickers.
  static const int datePickerHorizonYears = 5;

  /// Pre-fire offset for replay planner notifications.
  ///
  /// The notification is scheduled this duration before the planned replay time.
  static const Duration replayPrefireOffset = Duration(minutes: 5);
}
