## 1. Critical: Boot-time TeamLookupService

- [x] 1.1 Add `await TeamLookupService.instance.load()` in `main.dart` after `TimezoneService.initialize()` and before `runApp` ← (verify: TeamLookupService._loaded is true before any widget builds, Vietnamese names display correctly)

## 2. L10n: Add new ARB keys

- [x] 2.1 Add badge keys to `app_en.arb`: `matches_badge_group` (with `{group}` param), `matches_badge_roundOf32`, `matches_badge_roundOf16`, `matches_badge_quarterFinal`, `matches_badge_semiFinal`, `matches_badge_thirdPlace`, `matches_badge_final`
- [x] 2.2 Add magic add keys to `app_en.arb`: `magicAdd_btn_paste`, `magicAdd_btn_analyze`, `magicAdd_result_teamsFound`, `magicAdd_result_missingDateTime`, `magicAdd_btn_fillMore`, `magicAdd_result_failed`, `magicAdd_result_failedHint`, `magicAdd_btn_addManually`, `magicAdd_confirmation_title`, `magicAdd_field_home`, `magicAdd_field_away`, `magicAdd_field_date`, `magicAdd_field_time`, `magicAdd_field_timezone`, `magicAdd_field_timezone_local`, `magicAdd_btn_save`, `magicAdd_btn_edit`, `magicAdd_snackbar_saved`, `magicAdd_snackbar_error`
- [x] 2.3 Add onboarding key to `app_en.arb`: `onboarding_btn_next`
- [x] 2.4 Add edit mode key to `app_en.arb`: `manualAdd_appBar_title_edit`
- [x] 2.5 Add all corresponding keys to `app_vi.arb` with Vietnamese translations
- [x] 2.6 Update generated `app_localizations.dart` (add abstract getters/methods for new keys)
- [x] 2.7 Update generated `app_localizations_en.dart` (add override implementations)
- [x] 2.8 Update generated `app_localizations_vi.dart` (add override implementations) ← (verify: all new keys exist in all 3 generated files, parameterized keys use correct syntax)

## 3. Fix hardcoded strings in match list

- [x] 3.1 Change `dateSectionLabel(DateSection)` signature to `dateSectionLabel(DateSection, AppLocalizations)` in `match_list_controller.dart` and use `l10n.matches_section_today` etc.
- [x] 3.2 Update `DateSectionHeader` widget to pass `AppLocalizations.of(context)` to `dateSectionLabel()` ← (verify: date section headers display correctly in both EN and VI locales)

## 4. Fix hardcoded strings in match card

- [x] 4.1 Refactor `_badgeLabel()` in `match_card.dart` to use `AppLocalizations.of(context)` with the new badge l10n keys ← (verify: badge labels display correctly in both locales)

## 5. Fix hardcoded strings in magic add screen

- [x] 5.1 Replace all hardcoded Vietnamese strings in `magic_add_screen.dart` with `AppLocalizations.of(context)` lookups using the new keys ← (verify: all UI text in magic add screen uses l10n, no hardcoded Vietnamese remains)

## 6. Fix duplicated reminder offsets

- [x] 6.1 In `magic_add_screen.dart`, import `kReminderOffsets` from `reminder_scheduler.dart` and replace `[1440, 180, 30, 5]` with `kReminderOffsets`
- [x] 6.2 In `manual_add_screen.dart`, import `kReminderOffsets` from `reminder_scheduler.dart` and replace `[1440, 180, 30, 5]` with `kReminderOffsets` ← (verify: both files reference the single source of truth constant)

## 7. Fix replay planner timezone

- [x] 7.1 In `replay_planner_dialog.dart`, replace `DateTime(...)` in `_pickedDateTime` getter with `tz.TZDateTime(tz.local, ...)` and add the timezone import ← (verify: _pickedDateTime returns a tz.TZDateTime, DST transitions handled correctly)

## 8. Implement ManualAddScreen edit mode

- [x] 8.1 Add `editMatchId` parameter to `ManualAddScreen` constructor
- [x] 8.2 In `app_router.dart`, read `edit` query parameter and pass as `editMatchId` to `ManualAddScreen`
- [x] 8.3 In `_ManualAddScreenState.initState`, when `editMatchId` is non-null, load the match from repository and pre-fill all form fields (teamA, teamB, date, time, venue, notes)
- [x] 8.4 On save in edit mode: reuse existing matchId, preserve createdAt/isSeeded/metadata, call upsert
- [x] 8.5 Show edit-specific app bar title when in edit mode
- [x] 8.6 Fix `match_detail_screen.dart` edit button to navigate to `/matches/add?edit=${match.matchId}` (remove the non-functional `?edit=` that was there) ← (verify: edit button loads existing data, save updates the match, navigating back shows updated data)

## 9. Register ReplayPlannerColors theme extension

- [x] 9.1 In `app_theme.dart`, add `extensions: [const ReplayPlannerColors(...)]` to both light and dark ThemeData with appropriate color values per D3 ← (verify: Theme.of(context).extension<ReplayPlannerColors>() returns non-null in both light and dark mode)

## 10. Minor fixes

- [x] 10.1 In `seed_loader.dart`, replace `print(...)` with `debugPrint(...)` and remove the `// ignore: avoid_print` comment
- [x] 10.2 In `onboarding_screen.dart`, replace hardcoded `'Next'` with `AppLocalizations.of(context).onboarding_btn_next` ← (verify: onboarding Next button shows localized text)
