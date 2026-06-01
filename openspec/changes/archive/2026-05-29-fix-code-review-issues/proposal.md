## Why

Code review identified 10 issues (1 critical, 7 warnings, 2 suggestions) that break i18n support, leave a core feature silently non-functional (Vietnamese team names), and leave dead/incomplete code paths. The critical issue means all team names display in English regardless of locale because `TeamLookupService.load()` is never called at boot.

## What Changes

- Call `TeamLookupService.instance.load()` in `main.dart` before `runApp` so Vietnamese team names actually work
- Replace hardcoded Vietnamese strings in `dateSectionLabel()`, `_badgeLabel()`, and `MagicAddScreen` with proper `AppLocalizations` lookups
- Eliminate duplicated `[1440, 180, 30, 5]` reminder offsets by importing `kReminderOffsets`
- Fix `ReplayPlannerDialog` to use `tz.TZDateTime` instead of raw `DateTime` for timezone correctness
- Implement edit mode in `ManualAddScreen` so the "Edit" button on match detail actually works
- Register `ReplayPlannerColors` theme extension in `AppTheme` so it's accessible at runtime
- Replace `print()` with `debugPrint()` in seed_loader
- Add `onboarding_btn_next` l10n key for the hardcoded "Next" button

## Capabilities

### New Capabilities

- `match-edit-mode`: ManualAddScreen gains an edit mode that loads existing match data and updates instead of creating

### Modified Capabilities

## Impact

- **Boot sequence** (`main.dart`): adds one async call
- **L10n** (`app_en.arb`, `app_vi.arb`, generated files): ~15 new keys for badge labels, magic add strings, onboarding button
- **Match list** (`match_list_controller.dart`): `dateSectionLabel()` signature changes to accept `AppLocalizations`
- **Match card** (`match_card.dart`): `_badgeLabel()` uses l10n from context
- **Magic Add** (`magic_add_screen.dart`): all UI strings go through l10n
- **Manual Add** (`manual_add_screen.dart`): new `editMatchId` parameter, edit-mode logic
- **Match Detail** (`match_detail_screen.dart`): edit route passes matchId correctly
- **Router** (`app_router.dart`): passes edit query param to ManualAddScreen
- **Replay Planner** (`replay_planner_dialog.dart`): timezone-correct DateTime construction
- **Theme** (`app_theme.dart`): registers ReplayPlannerColors extension
- **Seed loader** (`seed_loader.dart`): print → debugPrint
- **Onboarding** (`onboarding_screen.dart`): l10n for "Next" button
