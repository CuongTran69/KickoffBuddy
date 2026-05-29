// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kickoff Buddy';

  @override
  String get home_title => 'Kickoff Buddy';

  @override
  String get home_subtitle => 'Track your World Cup schedule';

  @override
  String get home_cta_matches => 'Match Schedule';

  @override
  String get home_cta_rules => 'Football Rules';

  @override
  String get home_cta_vocabulary => 'Vocabulary';

  @override
  String get onboarding_welcome_title => 'Kickoff Buddy';

  @override
  String get onboarding_welcome_tagline =>
      'Never miss a kickoff.\nNo spoilers. No confusion.';

  @override
  String get onboarding_timezone_title => 'Your Timezone';

  @override
  String get onboarding_timezone_body =>
      'Match times will be shown in your local timezone.';

  @override
  String get onboarding_timezone_changeBtn => 'Change timezone';

  @override
  String get onboarding_language_title => 'Choose your language';

  @override
  String get onboarding_language_subtitle => 'Chọn ngôn ngữ của bạn';

  @override
  String get onboarding_language_vietnamese => 'Tiếng Việt';

  @override
  String get onboarding_language_english => 'English';

  @override
  String get onboarding_ready_title => 'You\'re all set!';

  @override
  String get onboarding_ready_body =>
      'Kickoff Buddy is ready.\nMatch times in your timezone, no spoilers.';

  @override
  String get onboarding_ready_letsGo => 'Let\'s go';

  @override
  String get onboarding_btn_next => 'Next';

  @override
  String get matches_appBar_title => 'Match Schedule';

  @override
  String get matches_filter_all => 'All';

  @override
  String get matches_filter_groupStage => 'Group Stage';

  @override
  String get matches_filter_knockouts => 'Knockouts';

  @override
  String get matches_section_today => 'Today';

  @override
  String get matches_section_tomorrow => 'Tomorrow';

  @override
  String get matches_section_thisWeek => 'This Week';

  @override
  String get matches_section_later => 'Later';

  @override
  String get matches_section_past => 'Past';

  @override
  String get matches_empty_title => 'No matches yet';

  @override
  String get matches_retry => 'Retry';

  @override
  String get matches_tooltip_magicAdd => 'Magic Add';

  @override
  String get matches_tooltip_add => 'Add match';

  @override
  String matches_badge_group(String group) {
    return 'Group $group';
  }

  @override
  String get matches_badge_roundOf32 => 'Round of 32';

  @override
  String get matches_badge_roundOf16 => 'Round of 16';

  @override
  String get matches_badge_quarterFinal => 'Quarter-final';

  @override
  String get matches_badge_semiFinal => 'Semi-final';

  @override
  String get matches_badge_thirdPlace => 'Third place';

  @override
  String get matches_badge_final => 'Final';

  @override
  String get matchDetail_appBar_title => 'Match Detail';

  @override
  String get matchDetail_label_date => 'Date';

  @override
  String get matchDetail_label_time => 'Time (local)';

  @override
  String get matchDetail_label_venue => 'Venue';

  @override
  String get matchDetail_label_group => 'Group';

  @override
  String matchDetail_label_groupValue(String group) {
    return 'Group $group';
  }

  @override
  String get matchDetail_label_round => 'Round';

  @override
  String get matchDetail_label_matchday => 'Matchday';

  @override
  String matchDetail_label_matchdayValue(int day) {
    return 'Matchday $day';
  }

  @override
  String get matchDetail_label_notes => 'Notes';

  @override
  String get matchDetail_btn_addToMyMatches => 'Add to my matches';

  @override
  String get matchDetail_btn_removeFromMyMatches => 'Remove from my matches';

  @override
  String get matchDetail_btn_setReminder => 'Set reminder';

  @override
  String get matchDetail_btn_matchStarted => 'Match started';

  @override
  String get matchDetail_btn_planReplay => 'Plan replay';

  @override
  String get matchDetail_btn_cancelReplayPlan => 'Cancel replay plan';

  @override
  String get matchDetail_btn_edit => 'Edit';

  @override
  String get matchDetail_btn_delete => 'Delete';

  @override
  String get matchDetail_dialog_cancelPlan_title => 'Cancel replay plan?';

  @override
  String get matchDetail_dialog_cancelPlan_body =>
      'The reminder notification will be cancelled.';

  @override
  String get matchDetail_dialog_delete_title => 'Delete match?';

  @override
  String get matchDetail_dialog_delete_body => 'This action cannot be undone.';

  @override
  String get matchDetail_snackbar_cancelledPlan => 'Replay plan cancelled';

  @override
  String get matchDetail_notFound => 'Match not found';

  @override
  String get matchDetail_btn_backToList => 'Back to list';

  @override
  String get matchDetail_round_groupStage => 'Group Stage';

  @override
  String get matchDetail_round_roundOf32 => 'Round of 32';

  @override
  String get matchDetail_round_roundOf16 => 'Round of 16';

  @override
  String get matchDetail_round_quarterFinal => 'Quarter-final';

  @override
  String get matchDetail_round_semiFinal => 'Semi-final';

  @override
  String get matchDetail_round_thirdPlace => 'Third place';

  @override
  String get matchDetail_round_final => 'Final';

  @override
  String get manualAdd_appBar_title => 'Add match';

  @override
  String get manualAdd_appBar_title_edit => 'Edit match';

  @override
  String get manualAdd_field_homeTeam => 'Home team *';

  @override
  String get manualAdd_field_homeTeam_hint => 'e.g. Brazil';

  @override
  String get manualAdd_field_awayTeam => 'Away team *';

  @override
  String get manualAdd_field_awayTeam_hint => 'e.g. Argentina';

  @override
  String get manualAdd_field_venue => 'Venue (optional)';

  @override
  String get manualAdd_field_venue_hint => 'e.g. Estadio Azteca';

  @override
  String get manualAdd_field_notes => 'Notes (optional)';

  @override
  String get manualAdd_field_date => 'Match date *';

  @override
  String get manualAdd_field_time => 'Kickoff time (local) *';

  @override
  String get manualAdd_placeholder_date => 'Select date';

  @override
  String get manualAdd_placeholder_time => 'Select time';

  @override
  String get manualAdd_validation_required => 'Required';

  @override
  String get manualAdd_validation_sameTeam =>
      'Home and away teams must be different';

  @override
  String get manualAdd_btn_save => 'Save';

  @override
  String get manualAdd_btn_retry => 'Retry';

  @override
  String get manualAdd_snackbar_saved => 'Match added';

  @override
  String get manualAdd_error_prefix => 'Error saving: ';

  @override
  String get magicAdd_appBar_title => 'Magic Add';

  @override
  String get magicAdd_instruction =>
      'Paste a text snippet containing match information';

  @override
  String get magicAdd_btn_paste => 'Paste from clipboard';

  @override
  String get magicAdd_btn_analyze => 'Analyze';

  @override
  String get magicAdd_result_teamsFound => 'Teams found:';

  @override
  String get magicAdd_result_missingDateTime =>
      'Date/time not found — please fill in.';

  @override
  String get magicAdd_btn_fillMore => 'Fill in more details';

  @override
  String get magicAdd_result_failed =>
      'Could not parse — try a format like:\n\"Team A vs Team B, June 11, 8 PM ET\"';

  @override
  String get magicAdd_result_failedHint =>
      'Could not parse — try a format like:\n\"Team A vs Team B, June 11, 8 PM ET\"';

  @override
  String get magicAdd_btn_addManually => 'Add manually';

  @override
  String get magicAdd_confirmation_title => 'Parse result:';

  @override
  String get magicAdd_field_home => 'Home';

  @override
  String get magicAdd_field_away => 'Away';

  @override
  String get magicAdd_field_date => 'Date';

  @override
  String get magicAdd_field_time => 'Time';

  @override
  String get magicAdd_field_timezone => 'Timezone';

  @override
  String get magicAdd_field_timezone_local => 'Local';

  @override
  String get magicAdd_btn_save => 'Save match';

  @override
  String get magicAdd_btn_edit => 'Edit';

  @override
  String get magicAdd_snackbar_saved => 'Match added';

  @override
  String get magicAdd_snackbar_error => 'Error saving: ';

  @override
  String get reminder_sheet_title => 'Remind before kickoff';

  @override
  String get reminder_btn_cancel => 'Cancel';

  @override
  String get reminder_btn_save => 'Save';

  @override
  String get reminder_snackbar_saved => 'Reminders saved';

  @override
  String get reminder_snackbar_cleared => 'Reminders cleared';

  @override
  String reminder_snackbar_skipped(String labels) {
    return 'Skipped $labels (already past)';
  }

  @override
  String get reminder_permission_title => 'Notification permission required';

  @override
  String get reminder_permission_body =>
      'Kickoff Buddy needs permission to send match notifications. Open Settings to enable notifications.';

  @override
  String get reminder_permission_openSettings => 'Open Settings';

  @override
  String get reminder_offset_1day => '1 day';

  @override
  String get reminder_offset_3hours => '3 hours';

  @override
  String get reminder_offset_30min => '30 min';

  @override
  String get reminder_offset_5min => '5 min';

  @override
  String get replayPlanner_dialog_title => 'Plan replay';

  @override
  String get replayPlanner_btn_cancelPlan => 'Cancel plan';

  @override
  String get replayPlanner_btn_close => 'Close';

  @override
  String get replayPlanner_btn_save => 'Save';

  @override
  String get replayPlanner_dialog_confirmCancel_title => 'Cancel replay plan?';

  @override
  String get replayPlanner_dialog_confirmCancel_body =>
      'The reminder notification will be cancelled.';

  @override
  String get replayPlanner_btn_no => 'No';

  @override
  String replayPlanner_snackbar_saved(String time) {
    return 'Replay planned for $time';
  }

  @override
  String get replayPlanner_snackbar_cancelled => 'Replay plan cancelled';

  @override
  String get replayPlanner_validation_mustBeAfterKickoff =>
      'Replay time must be after kickoff';

  @override
  String get replayPlanner_validation_mustBeInFuture =>
      'Replay time must be in the future';

  @override
  String get replayPlanner_placeholder_date => 'Select date';

  @override
  String get replayPlanner_placeholder_time => 'Select time';

  @override
  String spoiler_banner_text(String time) {
    return 'Spoiler-protected until $time';
  }

  @override
  String get rules_appBar_title => 'Football Rules';

  @override
  String get rules_error_load => 'Could not load football rules';

  @override
  String get rules_btn_retry => 'Retry';

  @override
  String get rules_level_newbie => 'Newbie';

  @override
  String get rules_level_casual => 'Casual';

  @override
  String get rules_level_advanced => 'Advanced';

  @override
  String get rules_topic_offside => 'Offside';

  @override
  String get rules_topic_penalty => 'Penalty';

  @override
  String get rules_topic_var => 'VAR';

  @override
  String get rules_topic_cards => 'Cards';

  @override
  String get rules_topic_stoppageTime => 'Stoppage Time';

  @override
  String get rules_topic_extraTime => 'Extra Time';

  @override
  String get rules_topic_penaltyShootout => 'Penalty Shootout';

  @override
  String get rules_detail_appBar_title => 'Football Rules';

  @override
  String rules_detail_readTime(int seconds) {
    return 'Read in: $seconds seconds';
  }

  @override
  String get rules_detail_seeAlso => 'See also';

  @override
  String get rules_detail_error_load => 'Error loading data';

  @override
  String get rules_detail_notFound => 'Rule not found';

  @override
  String get rules_detail_btn_back => 'Back';

  @override
  String get rules_detail_toggle_english => 'English';

  @override
  String get vocabulary_appBar_title => 'Vocabulary';

  @override
  String get vocabulary_search_hint => 'Search terms...';

  @override
  String get vocabulary_empty_title => 'No results';

  @override
  String get vocabulary_empty_clearSearch => 'Clear search';

  @override
  String get common_btn_cancel => 'Cancel';

  @override
  String get common_btn_no => 'No';

  @override
  String get common_btn_yes => 'Yes';

  @override
  String get common_btn_close => 'Close';

  @override
  String get a11y_changeLanguage => 'Change language';

  @override
  String get a11y_toggleEnVi => 'Toggle English / Vietnamese';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_matches => 'Matches';

  @override
  String get nav_rules => 'Rules';

  @override
  String get nav_vocabulary => 'Vocabulary';

  @override
  String get nav_settings => 'Settings';

  @override
  String get nav_standings => 'Standings';

  @override
  String get settings_appBar_title => 'Settings';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_themeMode => 'Theme Mode';

  @override
  String get settings_theme_light => 'Light Mode';

  @override
  String get settings_theme_dark => 'Dark Mode';

  @override
  String get settings_theme_system => 'System Default';

  @override
  String get settings_language_vi => 'Tiếng Việt';

  @override
  String get settings_language_en => 'English';

  @override
  String get home_section_nextMatch => 'Next Match';

  @override
  String get home_section_quickLearn => 'Quick Learn';

  @override
  String get home_btn_setReminder => 'Set Reminder';

  @override
  String get home_btn_viewDetail => 'View Detail';

  @override
  String get home_hero_noMatch_title => 'No upcoming matches';

  @override
  String get home_hero_noMatch_cta => 'Browse Schedule';

  @override
  String home_countdown_days(int days, int hours) {
    return '${days}d ${hours}h';
  }

  @override
  String home_countdown_hours(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get home_countdown_soon => 'Starting soon';

  @override
  String get home_live_indicator => 'LIVE';

  @override
  String get home_live_viewDetail => 'View detail';

  @override
  String get home_today_sectionHeader => 'Today\'s matches';

  @override
  String get standings_empty_title => 'No standings available';

  @override
  String get standings_error_title => 'Could not load standings';

  @override
  String get standings_btn_retry => 'Retry';

  @override
  String get standings_col_group => 'Group';

  @override
  String get standings_col_team => 'Team';

  @override
  String get standings_col_played => 'P';

  @override
  String get standings_col_wdl => 'W-D-L';

  @override
  String get standings_col_gfga => 'GF:GA';

  @override
  String get standings_col_gd => 'GD';

  @override
  String get standings_col_points => 'Pts';

  @override
  String standings_group_label(String letter) {
    return 'Group $letter';
  }

  @override
  String get standings_hint_bestThird => 'May advance (best 3rd)';

  @override
  String matches_syncError(String reason) {
    return 'Score sync error: $reason';
  }

  @override
  String get matchDetail_status_live => 'LIVE';

  @override
  String get matchDetail_status_ft => 'FT';

  @override
  String get matchDetail_status_scheduled => 'Scheduled';

  @override
  String get matchDetail_label_winner => 'Winner';

  @override
  String get matchDetail_label_attendance => 'Attendance';

  @override
  String get matchDetail_label_penalties => 'Penalties';

  @override
  String matchDetail_score_penalties(int scoreA, int scoreB) {
    return 'Pen $scoreA–$scoreB';
  }
}
