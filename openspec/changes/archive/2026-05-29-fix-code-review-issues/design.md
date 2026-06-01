## Context

Kickoff Buddy is a Flutter app (Dart, Riverpod, Isar, go_router) supporting EN/VI locales. A code review found 10 issues ranging from a critical boot-time bug to i18n gaps and dead code paths. The app uses ARB-based l10n with `generate: true` in pubspec (Flutter gen_l10n auto-generates Dart classes). The generated l10n files are committed directly.

## Goals / Non-Goals

**Goals:**
- Fix the critical TeamLookupService boot issue so Vietnamese team names display correctly
- Eliminate all hardcoded Vietnamese strings in favor of proper l10n lookups
- Implement working edit mode for user-created matches
- Register the ReplayPlannerColors theme extension so it's usable
- Fix timezone correctness in replay planner dialog
- Remove duplicated magic numbers

**Non-Goals:**
- Refactoring the overall architecture
- Adding new features beyond edit mode (which is already routed but non-functional)
- Changing the l10n generation approach (keep ARB + committed generated files)
- Adding tests for these fixes (separate concern)

## Decisions

### D1: dateSectionLabel() signature change
Change `dateSectionLabel(DateSection)` to `dateSectionLabel(DateSection, AppLocalizations)`. The function is standalone (not a widget method), so it cannot access BuildContext. Callers (match_list_screen.dart's `DateSectionHeader`) already have access to l10n and will pass it through.

Alternative considered: Make it a static method on a widget — rejected because it's used as a utility function across the codebase.

### D2: ManualAddScreen edit mode
Add optional `editMatchId` parameter. When non-null, load the match from repository in `initState`, pre-fill all form fields, and on save call `upsert` (which already handles updates via the unique matchId index). The router passes `editMatchId` from the query parameter.

Alternative considered: Separate EditMatchScreen — rejected because the form is identical, only the data source and save behavior differ.

### D3: ReplayPlannerColors values
Use `AppColors.darkAccent` (Amber) for banner background and white for foreground in dark mode. Use a light amber tint for light mode. These match the existing design system's accent color usage.

### D4: Replay planner timezone fix
Replace `DateTime(_pickedDate.year, ..., _pickedTime.hour, _pickedTime.minute)` with `tz.TZDateTime(tz.local, _pickedDate.year, ..., _pickedTime.hour, _pickedTime.minute)`. This ensures DST transitions are handled correctly.

### D5: L10n key naming convention
Follow existing pattern: `feature_component_element` (e.g., `magicAdd_btn_paste`, `matches_badge_group`). Parameterized strings use function syntax in ARB.

## Risks / Trade-offs

- [dateSectionLabel signature change] → All callers must be updated. Mitigation: grep for all usages (only DateSectionHeader widget uses it).
- [ManualAddScreen edit mode] → Async load in initState adds brief loading state. Mitigation: Show existing prefill values immediately, load full match data in background — form is usable instantly with prefilled team names.
- [Generated l10n files] → Must manually update 3 generated Dart files alongside ARB files. Mitigation: Follow exact existing patterns in the generated files.
