import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// The application name shown in the app bar and store listing
  ///
  /// In en, this message translates to:
  /// **'Kickoff Buddy'**
  String get appName;

  /// Home screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Kickoff Buddy'**
  String get home_title;

  /// Home screen subtitle tagline
  ///
  /// In en, this message translates to:
  /// **'Track your World Cup schedule'**
  String get home_subtitle;

  /// Home screen CTA button label for navigating to matches
  ///
  /// In en, this message translates to:
  /// **'Match Schedule'**
  String get home_cta_matches;

  /// Home screen CTA button label for navigating to rules
  ///
  /// In en, this message translates to:
  /// **'Football Rules'**
  String get home_cta_rules;

  /// Home screen CTA button label for navigating to vocabulary
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get home_cta_vocabulary;

  /// Welcome step app name title
  ///
  /// In en, this message translates to:
  /// **'Kickoff Buddy'**
  String get onboarding_welcome_title;

  /// Welcome step tagline below the app name
  ///
  /// In en, this message translates to:
  /// **'Never miss a kickoff.\nNo spoilers. No confusion.'**
  String get onboarding_welcome_tagline;

  /// Timezone step heading
  ///
  /// In en, this message translates to:
  /// **'Your Timezone'**
  String get onboarding_timezone_title;

  /// Timezone step explanatory body text
  ///
  /// In en, this message translates to:
  /// **'Match times will be shown in your local timezone.'**
  String get onboarding_timezone_body;

  /// Timezone step change button label (currently disabled)
  ///
  /// In en, this message translates to:
  /// **'Change timezone'**
  String get onboarding_timezone_changeBtn;

  /// Language step heading in English
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onboarding_language_title;

  /// Language step subtitle in Vietnamese (bilingual display)
  ///
  /// In en, this message translates to:
  /// **'Chọn ngôn ngữ của bạn'**
  String get onboarding_language_subtitle;

  /// Language option label for Vietnamese
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get onboarding_language_vietnamese;

  /// Language option label for English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get onboarding_language_english;

  /// Ready step heading
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get onboarding_ready_title;

  /// Ready step body text
  ///
  /// In en, this message translates to:
  /// **'Kickoff Buddy is ready.\nMatch times in your timezone, no spoilers.'**
  String get onboarding_ready_body;

  /// Ready step CTA button label
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get onboarding_ready_letsGo;

  /// Onboarding next button label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_btn_next;

  /// Match list screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Match Schedule'**
  String get matches_appBar_title;

  /// Match list filter chip: show all matches
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get matches_filter_all;

  /// Match list filter chip: group stage matches only
  ///
  /// In en, this message translates to:
  /// **'Group Stage'**
  String get matches_filter_groupStage;

  /// Match list filter chip: knockout round matches only
  ///
  /// In en, this message translates to:
  /// **'Knockouts'**
  String get matches_filter_knockouts;

  /// Date section header for today's matches
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get matches_section_today;

  /// Date section header for tomorrow's matches
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get matches_section_tomorrow;

  /// Date section header for matches this week
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get matches_section_thisWeek;

  /// Date section header for matches further in the future
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get matches_section_later;

  /// Date section header for past matches
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get matches_section_past;

  /// Empty state title on match list screen
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get matches_empty_title;

  /// Retry button label on error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get matches_retry;

  /// Tooltip for the Magic Add icon button in match list app bar
  ///
  /// In en, this message translates to:
  /// **'Magic Add'**
  String get matches_tooltip_magicAdd;

  /// Tooltip for the add match icon button in match list app bar
  ///
  /// In en, this message translates to:
  /// **'Add match'**
  String get matches_tooltip_add;

  /// Match card badge label for group stage matches
  ///
  /// In en, this message translates to:
  /// **'Group {group}'**
  String matches_badge_group(String group);

  /// Match card badge label for round of 32
  ///
  /// In en, this message translates to:
  /// **'Round of 32'**
  String get matches_badge_roundOf32;

  /// Match card badge label for round of 16
  ///
  /// In en, this message translates to:
  /// **'Round of 16'**
  String get matches_badge_roundOf16;

  /// Match card badge label for quarter-final
  ///
  /// In en, this message translates to:
  /// **'Quarter-final'**
  String get matches_badge_quarterFinal;

  /// Match card badge label for semi-final
  ///
  /// In en, this message translates to:
  /// **'Semi-final'**
  String get matches_badge_semiFinal;

  /// Match card badge label for third place match
  ///
  /// In en, this message translates to:
  /// **'Third place'**
  String get matches_badge_thirdPlace;

  /// Match card badge label for the final
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get matches_badge_final;

  /// Match detail screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Match Detail'**
  String get matchDetail_appBar_title;

  /// Match detail info row label for date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get matchDetail_label_date;

  /// Match detail info row label for kickoff time
  ///
  /// In en, this message translates to:
  /// **'Time (local)'**
  String get matchDetail_label_time;

  /// Match detail info row label for venue
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get matchDetail_label_venue;

  /// Match detail info row label for group
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get matchDetail_label_group;

  /// Match detail group value with group letter
  ///
  /// In en, this message translates to:
  /// **'Group {group}'**
  String matchDetail_label_groupValue(String group);

  /// Match detail info row label for round
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get matchDetail_label_round;

  /// Match detail info row label for matchday
  ///
  /// In en, this message translates to:
  /// **'Matchday'**
  String get matchDetail_label_matchday;

  /// Match detail matchday value
  ///
  /// In en, this message translates to:
  /// **'Matchday {day}'**
  String matchDetail_label_matchdayValue(int day);

  /// Match detail info row label for notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get matchDetail_label_notes;

  /// Button label to add a match to the user's list
  ///
  /// In en, this message translates to:
  /// **'Add to my matches'**
  String get matchDetail_btn_addToMyMatches;

  /// Button label to remove a match from the user's list
  ///
  /// In en, this message translates to:
  /// **'Remove from my matches'**
  String get matchDetail_btn_removeFromMyMatches;

  /// Button label to open the reminder sheet
  ///
  /// In en, this message translates to:
  /// **'Set reminder'**
  String get matchDetail_btn_setReminder;

  /// Disabled button label shown when the match has already kicked off
  ///
  /// In en, this message translates to:
  /// **'Match started'**
  String get matchDetail_btn_matchStarted;

  /// Button label to open the replay planner dialog
  ///
  /// In en, this message translates to:
  /// **'Plan replay'**
  String get matchDetail_btn_planReplay;

  /// Button label to cancel an existing replay plan
  ///
  /// In en, this message translates to:
  /// **'Cancel replay plan'**
  String get matchDetail_btn_cancelReplayPlan;

  /// Button label to edit a user-created match
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get matchDetail_btn_edit;

  /// Button label to delete a user-created match
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get matchDetail_btn_delete;

  /// Confirmation dialog title for cancelling a replay plan
  ///
  /// In en, this message translates to:
  /// **'Cancel replay plan?'**
  String get matchDetail_dialog_cancelPlan_title;

  /// Confirmation dialog body for cancelling a replay plan
  ///
  /// In en, this message translates to:
  /// **'The reminder notification will be cancelled.'**
  String get matchDetail_dialog_cancelPlan_body;

  /// Confirmation dialog title for deleting a match
  ///
  /// In en, this message translates to:
  /// **'Delete match?'**
  String get matchDetail_dialog_delete_title;

  /// Confirmation dialog body for deleting a match
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get matchDetail_dialog_delete_body;

  /// Snackbar message after cancelling a replay plan
  ///
  /// In en, this message translates to:
  /// **'Replay plan cancelled'**
  String get matchDetail_snackbar_cancelledPlan;

  /// Message shown when a match ID cannot be found
  ///
  /// In en, this message translates to:
  /// **'Match not found'**
  String get matchDetail_notFound;

  /// Button label to navigate back to the match list
  ///
  /// In en, this message translates to:
  /// **'Back to list'**
  String get matchDetail_btn_backToList;

  /// Round label for group stage
  ///
  /// In en, this message translates to:
  /// **'Group Stage'**
  String get matchDetail_round_groupStage;

  /// Round label for round of 32
  ///
  /// In en, this message translates to:
  /// **'Round of 32'**
  String get matchDetail_round_roundOf32;

  /// Round label for round of 16
  ///
  /// In en, this message translates to:
  /// **'Round of 16'**
  String get matchDetail_round_roundOf16;

  /// Round label for quarter-final
  ///
  /// In en, this message translates to:
  /// **'Quarter-final'**
  String get matchDetail_round_quarterFinal;

  /// Round label for semi-final
  ///
  /// In en, this message translates to:
  /// **'Semi-final'**
  String get matchDetail_round_semiFinal;

  /// Round label for third place match
  ///
  /// In en, this message translates to:
  /// **'Third place'**
  String get matchDetail_round_thirdPlace;

  /// Round label for the final
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get matchDetail_round_final;

  /// Manual add screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Add match'**
  String get manualAdd_appBar_title;

  /// Manual add screen app bar title in edit mode
  ///
  /// In en, this message translates to:
  /// **'Edit match'**
  String get manualAdd_appBar_title_edit;

  /// Manual add form field label for home team
  ///
  /// In en, this message translates to:
  /// **'Home team *'**
  String get manualAdd_field_homeTeam;

  /// Manual add form field hint for home team
  ///
  /// In en, this message translates to:
  /// **'e.g. Brazil'**
  String get manualAdd_field_homeTeam_hint;

  /// Manual add form field label for away team
  ///
  /// In en, this message translates to:
  /// **'Away team *'**
  String get manualAdd_field_awayTeam;

  /// Manual add form field hint for away team
  ///
  /// In en, this message translates to:
  /// **'e.g. Argentina'**
  String get manualAdd_field_awayTeam_hint;

  /// Manual add form field label for venue
  ///
  /// In en, this message translates to:
  /// **'Venue (optional)'**
  String get manualAdd_field_venue;

  /// Manual add form field hint for venue
  ///
  /// In en, this message translates to:
  /// **'e.g. Estadio Azteca'**
  String get manualAdd_field_venue_hint;

  /// Manual add form field label for notes
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get manualAdd_field_notes;

  /// Manual add form subtitle for date picker
  ///
  /// In en, this message translates to:
  /// **'Match date *'**
  String get manualAdd_field_date;

  /// Manual add form subtitle for time picker
  ///
  /// In en, this message translates to:
  /// **'Kickoff time (local) *'**
  String get manualAdd_field_time;

  /// Placeholder text for date picker before a date is selected
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get manualAdd_placeholder_date;

  /// Placeholder text for time picker before a time is selected
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get manualAdd_placeholder_time;

  /// Validation error message for required fields
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get manualAdd_validation_required;

  /// Validation error when home and away team names are the same
  ///
  /// In en, this message translates to:
  /// **'Home and away teams must be different'**
  String get manualAdd_validation_sameTeam;

  /// Save button label on manual add screen
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get manualAdd_btn_save;

  /// Retry button label after a save error
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get manualAdd_btn_retry;

  /// Snackbar message after successfully adding a match
  ///
  /// In en, this message translates to:
  /// **'Match added'**
  String get manualAdd_snackbar_saved;

  /// Prefix for save error messages
  ///
  /// In en, this message translates to:
  /// **'Error saving: '**
  String get manualAdd_error_prefix;

  /// Magic Add screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Magic Add'**
  String get magicAdd_appBar_title;

  /// Magic Add screen instruction text
  ///
  /// In en, this message translates to:
  /// **'Paste a text snippet containing match information'**
  String get magicAdd_instruction;

  /// Magic Add paste button label
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get magicAdd_btn_paste;

  /// Magic Add analyze button label
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get magicAdd_btn_analyze;

  /// Magic Add result label when teams are found
  ///
  /// In en, this message translates to:
  /// **'Teams found:'**
  String get magicAdd_result_teamsFound;

  /// Magic Add result hint when date/time is missing
  ///
  /// In en, this message translates to:
  /// **'Date/time not found — please fill in.'**
  String get magicAdd_result_missingDateTime;

  /// Magic Add button to navigate to manual add with prefilled fields
  ///
  /// In en, this message translates to:
  /// **'Fill in more details'**
  String get magicAdd_btn_fillMore;

  /// Magic Add failure message
  ///
  /// In en, this message translates to:
  /// **'Could not parse — try a format like:\n\"Team A vs Team B, June 11, 8 PM ET\"'**
  String get magicAdd_result_failed;

  /// Magic Add failure hint text
  ///
  /// In en, this message translates to:
  /// **'Could not parse — try a format like:\n\"Team A vs Team B, June 11, 8 PM ET\"'**
  String get magicAdd_result_failedHint;

  /// Magic Add button to navigate to manual add screen
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get magicAdd_btn_addManually;

  /// Magic Add confirmation card title
  ///
  /// In en, this message translates to:
  /// **'Parse result:'**
  String get magicAdd_confirmation_title;

  /// Magic Add confirmation card home team label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get magicAdd_field_home;

  /// Magic Add confirmation card away team label
  ///
  /// In en, this message translates to:
  /// **'Away'**
  String get magicAdd_field_away;

  /// Magic Add confirmation card date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get magicAdd_field_date;

  /// Magic Add confirmation card time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get magicAdd_field_time;

  /// Magic Add confirmation card timezone label
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get magicAdd_field_timezone;

  /// Magic Add timezone value when no timezone was parsed (uses local)
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get magicAdd_field_timezone_local;

  /// Magic Add save button label
  ///
  /// In en, this message translates to:
  /// **'Save match'**
  String get magicAdd_btn_save;

  /// Magic Add edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get magicAdd_btn_edit;

  /// Magic Add snackbar message after saving
  ///
  /// In en, this message translates to:
  /// **'Match added'**
  String get magicAdd_snackbar_saved;

  /// Magic Add snackbar error message shown when saving a match fails
  ///
  /// In en, this message translates to:
  /// **'Could not save the match. Please try again.'**
  String get magicAdd_snackbar_error;

  /// Reminder bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Remind before kickoff'**
  String get reminder_sheet_title;

  /// Cancel button label in reminder sheet
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reminder_btn_cancel;

  /// Save button label in reminder sheet
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get reminder_btn_save;

  /// Snackbar message after saving reminder offsets
  ///
  /// In en, this message translates to:
  /// **'Reminders saved'**
  String get reminder_snackbar_saved;

  /// Snackbar message after clearing all reminder offsets
  ///
  /// In en, this message translates to:
  /// **'Reminders cleared'**
  String get reminder_snackbar_cleared;

  /// Snackbar message when some reminder offsets were skipped because they are in the past
  ///
  /// In en, this message translates to:
  /// **'Skipped {labels} (already past)'**
  String reminder_snackbar_skipped(String labels);

  /// Dialog title when notification permission is denied
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get reminder_permission_title;

  /// Dialog body when notification permission is denied
  ///
  /// In en, this message translates to:
  /// **'Kickoff Buddy needs permission to send match notifications. Open Settings to enable notifications.'**
  String get reminder_permission_body;

  /// Button label to open app settings for notification permission
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get reminder_permission_openSettings;

  /// Dialog title when exact alarm permission is not granted on Android 12+
  ///
  /// In en, this message translates to:
  /// **'Exact alarm permission required'**
  String get reminder_exactAlarm_title;

  /// Dialog body explaining why exact alarm permission is needed
  ///
  /// In en, this message translates to:
  /// **'To deliver reminders at the exact kickoff time, Kickoff Buddy needs permission to schedule exact alarms. Tap \"Open Settings\" to grant it.'**
  String get reminder_exactAlarm_body;

  /// Button label to open the exact alarm settings page on Android 12+
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get reminder_exactAlarm_openSettings;

  /// Reminder offset chip label for 1 day before kickoff
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get reminder_offset_1day;

  /// Reminder offset chip label for 3 hours before kickoff
  ///
  /// In en, this message translates to:
  /// **'3 hours'**
  String get reminder_offset_3hours;

  /// Reminder offset chip label for 30 minutes before kickoff
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get reminder_offset_30min;

  /// Reminder offset chip label for 5 minutes before kickoff
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get reminder_offset_5min;

  /// Replay planner dialog title
  ///
  /// In en, this message translates to:
  /// **'Plan replay'**
  String get replayPlanner_dialog_title;

  /// Button label to cancel an existing replay plan in the dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel plan'**
  String get replayPlanner_btn_cancelPlan;

  /// Close button label in replay planner dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get replayPlanner_btn_close;

  /// Save button label in replay planner dialog
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get replayPlanner_btn_save;

  /// Confirmation dialog title for cancelling a replay plan
  ///
  /// In en, this message translates to:
  /// **'Cancel replay plan?'**
  String get replayPlanner_dialog_confirmCancel_title;

  /// Confirmation dialog body for cancelling a replay plan
  ///
  /// In en, this message translates to:
  /// **'The reminder notification will be cancelled.'**
  String get replayPlanner_dialog_confirmCancel_body;

  /// No button in confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get replayPlanner_btn_no;

  /// Snackbar message after saving a replay plan
  ///
  /// In en, this message translates to:
  /// **'Replay planned for {time}'**
  String replayPlanner_snackbar_saved(String time);

  /// Snackbar message after cancelling a replay plan
  ///
  /// In en, this message translates to:
  /// **'Replay plan cancelled'**
  String get replayPlanner_snackbar_cancelled;

  /// Validation error when replay time is not after kickoff
  ///
  /// In en, this message translates to:
  /// **'Replay time must be after kickoff'**
  String get replayPlanner_validation_mustBeAfterKickoff;

  /// Validation error when replay time is not in the future
  ///
  /// In en, this message translates to:
  /// **'Replay time must be in the future'**
  String get replayPlanner_validation_mustBeInFuture;

  /// Placeholder for date picker in replay planner
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get replayPlanner_placeholder_date;

  /// Placeholder for time picker in replay planner
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get replayPlanner_placeholder_time;

  /// Spoiler banner text showing the protection end time
  ///
  /// In en, this message translates to:
  /// **'Spoiler-protected until {time}'**
  String spoiler_banner_text(String time);

  /// Rule cards screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Football Rules'**
  String get rules_appBar_title;

  /// Error message when rule cards fail to load
  ///
  /// In en, this message translates to:
  /// **'Could not load football rules'**
  String get rules_error_load;

  /// Retry button on rule cards error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get rules_btn_retry;

  /// Rule card level filter chip: newbie level
  ///
  /// In en, this message translates to:
  /// **'Newbie'**
  String get rules_level_newbie;

  /// Rule card level filter chip: casual level
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get rules_level_casual;

  /// Rule card level filter chip: advanced level
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get rules_level_advanced;

  /// Rule card topic label for offside
  ///
  /// In en, this message translates to:
  /// **'Offside'**
  String get rules_topic_offside;

  /// Rule card topic label for penalty
  ///
  /// In en, this message translates to:
  /// **'Penalty'**
  String get rules_topic_penalty;

  /// Rule card topic label for VAR
  ///
  /// In en, this message translates to:
  /// **'VAR'**
  String get rules_topic_var;

  /// Rule card topic label for cards (yellow/red)
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get rules_topic_cards;

  /// Rule card topic label for stoppage time
  ///
  /// In en, this message translates to:
  /// **'Stoppage Time'**
  String get rules_topic_stoppageTime;

  /// Rule card topic label for extra time
  ///
  /// In en, this message translates to:
  /// **'Extra Time'**
  String get rules_topic_extraTime;

  /// Rule card topic label for penalty shootout
  ///
  /// In en, this message translates to:
  /// **'Penalty Shootout'**
  String get rules_topic_penaltyShootout;

  /// Rule card detail screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Football Rules'**
  String get rules_detail_appBar_title;

  /// Read time estimate on rule card detail
  ///
  /// In en, this message translates to:
  /// **'Read in: {seconds} seconds'**
  String rules_detail_readTime(int seconds);

  /// Section heading for related rule cards
  ///
  /// In en, this message translates to:
  /// **'See also'**
  String get rules_detail_seeAlso;

  /// Error message when a rule card fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get rules_detail_error_load;

  /// Message when a rule card ID cannot be found
  ///
  /// In en, this message translates to:
  /// **'Rule not found'**
  String get rules_detail_notFound;

  /// Back button label on rule card detail error/not-found states
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get rules_detail_btn_back;

  /// Label next to the EN/VN toggle switch on rule card detail
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get rules_detail_toggle_english;

  /// Vocabulary screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get vocabulary_appBar_title;

  /// Search bar hint text on vocabulary screen
  ///
  /// In en, this message translates to:
  /// **'Search terms...'**
  String get vocabulary_search_hint;

  /// Empty state title when vocabulary search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get vocabulary_empty_title;

  /// Button label to clear the vocabulary search query
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get vocabulary_empty_clearSearch;

  /// Generic cancel button label used across dialogs and sheets
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_btn_cancel;

  /// Generic no button label used in confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get common_btn_no;

  /// Generic yes button label used in confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get common_btn_yes;

  /// Generic close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_btn_close;

  /// Accessibility semantics label for the language toggle button
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get a11y_changeLanguage;

  /// Accessibility semantics label for the EN/VN toggle on rule card detail
  ///
  /// In en, this message translates to:
  /// **'Toggle English / Vietnamese'**
  String get a11y_toggleEnVi;

  /// Bottom navigation bar label for the Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// Bottom navigation bar label for the Matches tab
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get nav_matches;

  /// Bottom navigation bar label for the Rules tab
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get nav_rules;

  /// Bottom navigation bar label for the Vocabulary tab
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get nav_vocabulary;

  /// Bottom navigation bar label for the Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get nav_settings;

  /// Bottom navigation bar label for the Standings tab
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get nav_standings;

  /// Settings screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_appBar_title;

  /// Settings section label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// Settings section label for theme selection
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settings_themeMode;

  /// Label for light theme option
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settings_theme_light;

  /// Label for dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settings_theme_dark;

  /// Label for system default theme option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settings_theme_system;

  /// Label for Vietnamese language option
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get settings_language_vi;

  /// Label for English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_language_en;

  /// Settings About card title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about_title;

  /// Disclaimer text shown in the About card on the Settings screen
  ///
  /// In en, this message translates to:
  /// **'Kickoff Buddy is an unofficial fan app and is not affiliated with FIFA or any football federation.'**
  String get settings_about_disclaimer;

  /// Home dashboard section heading for the next match hero
  ///
  /// In en, this message translates to:
  /// **'Next Match'**
  String get home_section_nextMatch;

  /// Home dashboard section heading for quick learn rule chips
  ///
  /// In en, this message translates to:
  /// **'Quick Learn'**
  String get home_section_quickLearn;

  /// Hero card button label to set a reminder for the next match
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get home_btn_setReminder;

  /// Hero card button label to navigate to match detail
  ///
  /// In en, this message translates to:
  /// **'View Detail'**
  String get home_btn_viewDetail;

  /// Hero card empty state title when no future match exists
  ///
  /// In en, this message translates to:
  /// **'No upcoming matches'**
  String get home_hero_noMatch_title;

  /// Hero card empty state CTA button to browse the match list
  ///
  /// In en, this message translates to:
  /// **'Browse Schedule'**
  String get home_hero_noMatch_cta;

  /// Countdown format when more than 1 day remains (days + hours)
  ///
  /// In en, this message translates to:
  /// **'{days}d {hours}h'**
  String home_countdown_days(int days, int hours);

  /// Countdown format when less than 1 day remains (hours + minutes)
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String home_countdown_hours(int hours, int minutes);

  /// Countdown label when the match is imminent (less than 1 minute)
  ///
  /// In en, this message translates to:
  /// **'Starting soon'**
  String get home_countdown_soon;

  /// Live match indicator badge label on the home screen hero card
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get home_live_indicator;

  /// Button label on the live match hero card to navigate to match detail
  ///
  /// In en, this message translates to:
  /// **'View detail'**
  String get home_live_viewDetail;

  /// Section header for today's matches on the home screen
  ///
  /// In en, this message translates to:
  /// **'Today\'s matches'**
  String get home_today_sectionHeader;

  /// Empty state title on the standings screen when no group data is returned
  ///
  /// In en, this message translates to:
  /// **'No standings available'**
  String get standings_empty_title;

  /// Error state title on the standings screen
  ///
  /// In en, this message translates to:
  /// **'Could not load standings'**
  String get standings_error_title;

  /// Retry button label on the standings error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get standings_btn_retry;

  /// Group standings card header label for the group column
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get standings_col_group;

  /// Group standings card header label for the team column
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get standings_col_team;

  /// Group standings card header label for games played (abbreviated)
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get standings_col_played;

  /// Group standings card header label for wins-draws-losses
  ///
  /// In en, this message translates to:
  /// **'W-D-L'**
  String get standings_col_wdl;

  /// Group standings card header label for goals for and goals against
  ///
  /// In en, this message translates to:
  /// **'GF:GA'**
  String get standings_col_gfga;

  /// Group standings card header label for goal differential (abbreviated)
  ///
  /// In en, this message translates to:
  /// **'GD'**
  String get standings_col_gd;

  /// Group standings card header label for points (abbreviated)
  ///
  /// In en, this message translates to:
  /// **'Pts'**
  String get standings_col_points;

  /// Group standings card group header label
  ///
  /// In en, this message translates to:
  /// **'Group {letter}'**
  String standings_group_label(String letter);

  /// Legend hint for rank-3 teams that may advance as best third-placed teams in WC2026
  ///
  /// In en, this message translates to:
  /// **'May advance (best 3rd)'**
  String get standings_hint_bestThird;

  /// Snackbar message when score sync fails, with the error reason
  ///
  /// In en, this message translates to:
  /// **'Score sync error: {reason}'**
  String matches_syncError(String reason);

  /// Status badge label for a match currently in progress
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get matchDetail_status_live;

  /// Status badge label for a completed match (Full Time)
  ///
  /// In en, this message translates to:
  /// **'FT'**
  String get matchDetail_status_ft;

  /// Status badge label for a match not yet started
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get matchDetail_status_scheduled;

  /// Match detail info row label for the match winner
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get matchDetail_label_winner;

  /// Match detail info row label for attendance
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get matchDetail_label_attendance;

  /// Match detail label for penalty shootout scores
  ///
  /// In en, this message translates to:
  /// **'Penalties'**
  String get matchDetail_label_penalties;

  /// Penalty shootout score display, e.g. Pen 4–3
  ///
  /// In en, this message translates to:
  /// **'Pen {scoreA}–{scoreB}'**
  String matchDetail_score_penalties(int scoreA, int scoreB);

  /// Sleep Plan card title shown on Match Detail for late-night fixtures
  ///
  /// In en, this message translates to:
  /// **'Sleep Plan'**
  String get sleepPlan_cardTitle;

  /// Mandatory disclaimer at the bottom of the Sleep Plan card
  ///
  /// In en, this message translates to:
  /// **'This is a personal schedule suggestion, not medical advice.'**
  String get sleepPlan_disclaimer;

  /// Sleep Plan mode title: watch the match live
  ///
  /// In en, this message translates to:
  /// **'Late Watcher'**
  String get sleepPlan_mode_lateWatcher_title;

  /// Sleep Plan Late Watcher mode suggestion text
  ///
  /// In en, this message translates to:
  /// **'Nap before the match, then watch live.'**
  String get sleepPlan_mode_lateWatcher_body;

  /// Sleep Plan mode title: watch part of the match
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get sleepPlan_mode_balanced_title;

  /// Sleep Plan Balanced mode suggestion text
  ///
  /// In en, this message translates to:
  /// **'Watch the second half or highlights tomorrow.'**
  String get sleepPlan_mode_balanced_body;

  /// Sleep Plan mode title: skip live, watch replay
  ///
  /// In en, this message translates to:
  /// **'Healthy Replay'**
  String get sleepPlan_mode_healthyReplay_title;

  /// Sleep Plan Healthy Replay mode suggestion text
  ///
  /// In en, this message translates to:
  /// **'Sleep now, watch the replay in the morning.'**
  String get sleepPlan_mode_healthyReplay_body;

  /// CTA button label in the Healthy Replay mode row to open the Replay Planner dialog
  ///
  /// In en, this message translates to:
  /// **'Set up Replay Planner'**
  String get sleepPlan_mode_healthyReplay_cta;

  /// Etiquette list and detail screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Fan Etiquette'**
  String get etiquette_appBar_title;

  /// Error message when etiquette tips fail to load
  ///
  /// In en, this message translates to:
  /// **'Could not load etiquette tips'**
  String get etiquette_error_load;

  /// Retry button on etiquette error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get etiquette_btn_retry;

  /// Message when an etiquette tip ID cannot be found
  ///
  /// In en, this message translates to:
  /// **'Tip not found'**
  String get etiquette_notFound;

  /// Back button label on etiquette detail error/not-found states
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get etiquette_btn_back;

  /// Format guide list and detail screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Tournament Format'**
  String get formatGuide_appBar_title;

  /// Error message when format guide sections fail to load
  ///
  /// In en, this message translates to:
  /// **'Could not load format guide'**
  String get formatGuide_error_load;

  /// Retry button on format guide error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get formatGuide_btn_retry;

  /// Message when a format guide section ID cannot be found
  ///
  /// In en, this message translates to:
  /// **'Section not found'**
  String get formatGuide_notFound;

  /// Back button label on format guide detail error/not-found states
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get formatGuide_btn_back;

  /// home_dashboard_purpose: Dashboard header title shown on the home screen
  ///
  /// In en, this message translates to:
  /// **'Kickoff Buddy'**
  String get home_dashboard_title;

  /// home_dashboard_purpose: Dashboard header subtitle tagline on the home screen
  ///
  /// In en, this message translates to:
  /// **'Your football schedule & guide'**
  String get home_dashboard_subtitle;

  /// home_quickAction_purpose: Quick action label for match schedule
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get home_action_matches;

  /// home_quickAction_purpose: Quick action label for standings
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get home_action_standings;

  /// home_quickAction_purpose: Quick action label for football rules
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get home_action_rules;

  /// home_quickAction_purpose: Quick action label for vocabulary
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get home_action_vocabulary;

  /// home_quickAction_purpose: Quick action label for magic add
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get home_action_magicAdd;

  /// home_quickAction_purpose: Quick action label for manual add
  ///
  /// In en, this message translates to:
  /// **'Manual Add'**
  String get home_action_manualAdd;

  /// home_quickLearn_purpose: Quick learn card label for offside rule
  ///
  /// In en, this message translates to:
  /// **'Offside'**
  String get home_quickLearn_offside_label;

  /// home_quickLearn_purpose: Quick learn card description for offside
  ///
  /// In en, this message translates to:
  /// **'Basic offside rule for beginners.'**
  String get home_quickLearn_offside_desc;

  /// home_quickLearn_purpose: Quick learn card label for penalty rule
  ///
  /// In en, this message translates to:
  /// **'Penalty'**
  String get home_quickLearn_penalty_label;

  /// home_quickLearn_purpose: Quick learn card description for penalty
  ///
  /// In en, this message translates to:
  /// **'Learn when a penalty kick occurs.'**
  String get home_quickLearn_penalty_desc;

  /// home_quickLearn_purpose: Quick learn card label for VAR
  ///
  /// In en, this message translates to:
  /// **'VAR'**
  String get home_quickLearn_var_label;

  /// home_quickLearn_purpose: Quick learn card description for VAR
  ///
  /// In en, this message translates to:
  /// **'How does VAR work in a match?'**
  String get home_quickLearn_var_desc;

  /// home_quickLearn_purpose: Quick learn card label for vocabulary
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get home_quickLearn_vocabulary_label;

  /// home_quickLearn_purpose: Quick learn card description for vocabulary
  ///
  /// In en, this message translates to:
  /// **'Look up common football terms.'**
  String get home_quickLearn_vocabulary_desc;

  /// settings_resources_purpose: Settings screen section title for resources and reference links
  ///
  /// In en, this message translates to:
  /// **'Resources & Reference'**
  String get settings_resources_title;

  /// reminder_notification_purpose: Notification title for a match reminder, with time label
  ///
  /// In en, this message translates to:
  /// **'Match reminder: {label} to go'**
  String reminder_notification_title(String label);

  /// reminder_notification_purpose: Notification body for a match reminder showing the teams
  ///
  /// In en, this message translates to:
  /// **'{teamA} vs {teamB}'**
  String reminder_notification_body(String teamA, String teamB);

  /// replay_notification_purpose: Notification title for an upcoming replay reminder
  ///
  /// In en, this message translates to:
  /// **'Replay time coming up'**
  String get replay_notification_title;

  /// replay_notification_purpose: Notification body for an upcoming replay showing the teams
  ///
  /// In en, this message translates to:
  /// **'{teamA} vs {teamB}'**
  String replay_notification_body(String teamA, String teamB);

  /// reminder_offset_purpose: Unit word for a single day in offset labels
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get reminder_unit_day;

  /// reminder_offset_purpose: Unit word for multiple days in offset labels
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get reminder_unit_days;

  /// reminder_offset_purpose: Unit word for a single hour in offset labels
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get reminder_unit_hour;

  /// reminder_offset_purpose: Unit word for multiple hours in offset labels
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get reminder_unit_hours;

  /// reminder_offset_purpose: Unit word for a single minute in offset labels
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get reminder_unit_minute;

  /// reminder_offset_purpose: Unit word for multiple minutes in offset labels
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get reminder_unit_minutes;

  /// spoiler_badge_purpose: Label shown on the spoiler protection badge
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get spoiler_badge_label;

  /// rules_emptyState_purpose: Empty state message when no rule cards exist for the selected level
  ///
  /// In en, this message translates to:
  /// **'No rule cards available for this level.'**
  String get rules_empty_state;

  /// vocabulary_search_purpose: Accessibility tooltip for the clear button in the vocabulary search bar
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get vocabulary_search_clear_tooltip;

  /// common_error_purpose: User-facing message for network connectivity failures
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get common_error_network;

  /// common_error_purpose: User-facing message for generic unexpected errors
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get common_error_generic;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
