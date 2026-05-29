## Context

Kickoff Buddy is a Flutter (Material 3, Riverpod, go_router, Isar) World Cup companion app for Vietnamese casual fans (EN/VI). The osf-uiux-designer report ("Pitch Night") found that the palette is fine but barely applied. Current routing pushes Matches/Rules/Vocabulary from a Home launcher screen — a dead-end model. L10n uses ARB files with `generate: true`; the generated Dart files are committed and edited manually to match.

Existing tokens (`app_colors.dart`):
- Dark: primary `#10B981`, surface `#0F172A`, surfaceVariant `#1E293B`, onSurface `#F1F5F9`, accent `#FBBF24`
- Light: primary `#059669`, surface `#FFFFFF`, surfaceVariant `#F1F5F9`, onSurface `#0F172A`, accent `#FBBF24`

`AppTypography.tabularNumbers()` already exists but is unused — used for the countdown pill.

## Goals / Non-Goals

**Goals:**
- Persistent bottom navigation replacing CTA-button navigation
- Themed cards/appbars/chips/dividers/navbar app-wide via ThemeData
- A Home dashboard with a next-match hero + countdown
- Visual polish on match card, match detail, section headers, spoiler banner, onboarding, rule tiles
- All new strings localized (EN/VI)

**Non-Goals:**
- Changing the brand palette (emerald/slate/amber stays)
- Data model / business logic changes
- New features beyond the dashboard (which surfaces existing data)
- Adding tests (separate concern)
- Light-mode visual perfection — dark-first; light mode gets the same tokens but dark is the priority

## Decisions

### D1: Navigation = go_router ShellRoute + NavigationBar, 4 destinations
Wrap Home/Matches/Rules/Vocabulary in a `StatefulShellRoute.indexedStack` (preserves each tab's state and scroll position). Destinations: Home (`home_outlined`/`home`, "Trang chủ"), Matches (`calendar_month_outlined`/`calendar_month`, "Trận đấu"), Rules (`menu_book_outlined`/`menu_book`, "Luật"), Vocabulary (`translate`, "Từ vựng"). Onboarding and detail/add routes (match detail, magic add, manual add, rule detail) stay as top-level routes outside the shell so they push over the nav bar.

Decision: keep Home as a dashboard (4th tab), since the next-match hero is high-value and distinct from the full match list.

Alternative considered: Matches as the landing tab (3 destinations) — rejected because the dashboard hero + quick-learn sections are valuable and don't belong inside the match list.

### D2: Component theming centralized in AppTheme
Add to both light and dark `ThemeData`:
- `cardTheme`: elevation 0, color surfaceVariant, `RoundedRectangleBorder(12)` with Slate-700 0.5px border, margin h12/v6
- `appBarTheme`: bg surface, `surfaceTintColor: Colors.transparent`, elevation 0, scrolledUnderElevation 0, Inter w600 title
- `chipTheme`: surfaceVariant bg, selected = primary 0.2 alpha, Slate-700 side
- `dividerTheme`: Slate-700, thickness 1
- `navigationBarTheme`: bg surfaceVariant, indicator primary 0.15 alpha, label/icon styles

This fixes invisible card borders and AppBar tint across every screen at once.

### D3: New color tokens
Add to `AppColors` (light + dark): `surfaceContainerHigh` Slate-700 `#334155`, `onSurfaceMuted` Slate-400 `#94A3B8`, `primaryDim` Emerald-700 `#047857`, `error` Red-400 `#F87171`. Light-mode variants use appropriately adjusted values (e.g. muted = Slate-500 `#64748B`, error = `#DC2626`).

### D4: Next match provider
Add `nextMatchProvider` (FutureProvider) in `app/lib/features/home/application/`. It reads `matchRepositoryProvider`, gets all matches, filters to `kickoffAtUtc.isAfter(now)`, sorts ascending, returns the first (or null). Home watches it for the hero card. Returns null → show "no upcoming match" empty hero with a CTA to browse matches.

### D5: Countdown
Compute remaining duration from `DateTime.now()` to `kickoffAtUtc`. Display via a 60s periodic rebuild (reuse the `shieldClockProvider` pattern or a local `Stream.periodic`). Format as "Còn X ngày Y giờ" / "Còn Y giờ Z phút" with `AppTypography.tabularNumbers`. Localized with a parameterized l10n string.

### D6: L10n keys
New keys (EN/VI), added to both ARB files and all 3 generated Dart files following the existing pattern:
- Nav: `nav_home`, `nav_matches`, `nav_rules`, `nav_vocabulary`
- Home: `home_section_nextMatch`, `home_section_quickLearn`, `home_btn_setReminder`, `home_btn_viewDetail`, `home_hero_noMatch_title`, `home_hero_noMatch_cta`, `home_countdown_days(days, hours)`, `home_countdown_hours(hours, minutes)`, `home_countdown_soon`

### D7: Match card "today" detection
Compare `tz.TZDateTime.from(kickoffAtUtc, tz.local)` day with today in local tz (reuse the `_startOfDay` logic already in match_list_controller). Today → Amber `BorderSide(1.5)` on the card shape.

## Risks / Trade-offs

- [ShellRoute migration breaks existing `context.push`/`context.go` calls] → Audit all navigation calls. Tab destinations use `goBranch`; detail/add routes stay push-based outside the shell. Mitigation: keep route paths identical, only restructure the route tree.
- [StatefulShellRoute state retention changes provider lifecycle] → Tabs are kept alive (IndexedStack), so providers stay mounted. This is desired (no reload on tab switch) but means `ref.watch` in tabs won't re-trigger on return. Acceptable for this app's data.
- [Manually editing 3 generated l10n files] → Follow exact existing patterns; verify all keys present in all 3 files. Mitigation: cross-check after editing.
- [Home dashboard depends on seeded match data] → If repository is empty/seeding, show loading then empty hero. Handle AsyncValue loading/error/empty explicitly.
- [Light mode less tested] → Dark-first priority; light gets same tokens. Acceptable per non-goals.
