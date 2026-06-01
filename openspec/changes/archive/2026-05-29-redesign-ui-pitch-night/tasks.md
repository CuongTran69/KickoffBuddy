## 1. Color tokens & theme foundation

- [x] 1.1 Add new tokens to `app_colors.dart` (dark + light): `surfaceContainerHigh` (#334155 / appropriate light), `onSurfaceMuted` (#94A3B8 / #64748B), `primaryDim` (#047857), `error` (#F87171 / #DC2626)
- [x] 1.2 Add `cardTheme` to AppTheme.dark and AppTheme.light (elevation 0, surfaceVariant color, rounded 12, Slate-700 0.5px border, margin h12/v6)
- [x] 1.3 Add `appBarTheme` (bg surface, surfaceTintColor transparent, elevation 0, scrolledUnderElevation 0, Inter w600 title)
- [x] 1.4 Add `chipTheme` and `dividerTheme` (Slate-700)
- [x] 1.5 Add `navigationBarTheme` (bg surfaceVariant, indicator primary 0.15 alpha, label/icon styling) ← (verify: cards have visible borders in dark mode, app bars have no tint, all themes compile)

## 2. Navigation shell (app-navigation capability)

- [x] 2.1 Create `app/lib/core/routing/app_shell.dart` — StatefulShellRoute-based scaffold with bottom NavigationBar, 4 destinations (Home/Matches/Rules/Vocabulary) with outlined+filled icons
- [x] 2.2 Add nav label l10n keys (`nav_home`, `nav_matches`, `nav_rules`, `nav_vocabulary`) to both ARB files and all 3 generated Dart files
- [x] 2.3 Restructure `app_router.dart` to use `StatefulShellRoute.indexedStack` wrapping Home/Matches/Rules/Vocabulary; keep onboarding and detail/add routes (match detail, magic add, manual add, rule detail) as top-level routes outside the shell
- [x] 2.4 Verify initial route still respects `onboarding_completed` flag → shell defaults to Home tab
- [x] 2.5 Audit all `context.push`/`context.go` calls — tab navigation uses branch switching, detail/add stays push-based ← (verify: nav bar persists across tabs, tab state preserved on switch, onboarding has no nav bar, detail pushes over nav bar, all spec scenarios pass)

## 3. Home dashboard (home-dashboard capability)

- [x] 3.1 Create `app/lib/features/home/application/next_match_provider.dart` — FutureProvider reading matchRepositoryProvider, filtering future matches, sorting ascending, returning first or null
- [x] 3.2 Add home dashboard l10n keys (`home_section_nextMatch`, `home_section_quickLearn`, `home_btn_setReminder`, `home_btn_viewDetail`, `home_hero_noMatch_title`, `home_hero_noMatch_cta`, `home_countdown_days`, `home_countdown_hours`, `home_countdown_soon`) to ARB + 3 generated files
- [x] 3.3 Build Next Match Hero Card widget (gradient Slate-800→Slate-900, emerald border 0.3 alpha, flags 64px, team names 28sp w700, Amber countdown pill via AppTypography.tabularNumbers, date/venue line, set-reminder + view-detail buttons)
- [x] 3.4 Add live countdown (60s periodic refresh, day/hour vs hour/minute formatting, localized)
- [x] 3.5 Add "next match" + "quick learn" sections (2 rule card chips linking to rules)
- [x] 3.6 Replace `home_screen.dart` body: handle AsyncValue loading/error/empty, render hero + sections ← (verify: hero shows next match with countdown, no-match state shows CTA, loading shows spinner, quick actions navigate correctly — all home-dashboard scenarios pass)

## 4. Match list polish (Tier 2)

- [x] 4.1 `match_card.dart`: flag 28→32px, vertical margin 4→6px, replace muted "vs" text with cleaner separator
- [x] 4.2 `match_card.dart`: detect "today" match (local tz day comparison) and apply Amber left border 1.5px on card shape
- [x] 4.3 `date_section_header.dart`: emerald left accent bar 3px + surfaceVariant background + rounded 8 ← (verify: today's matches visually distinct, section headers anchored, locale labels intact)

## 5. Match detail polish (Tier 2)

- [x] 5.1 Hero card: flag 56→72px, team name →titleLarge, "vs" bold headlineMedium onSurface (not muted)
- [x] 5.2 Group action buttons: primary FilledButton, secondary actions in a Row, destructive actions below a Divider
- [x] 5.3 `_InfoRow`: vertical padding 6→8, icon 18→20px, label labelSmall→labelMedium ← (verify: hero prominent, buttons grouped sensibly, no overflow with replay plan active)

## 6. Remaining polish (Tier 2 + 3)

- [x] 6.1 `spoiler_banner.dart`: Amber tint background (darkAccent 0.15 alpha) + Amber left border
- [x] 6.2 `welcome_step.dart`: replace plain icon with gradient circle container (radial emerald→slate, emerald border 2px, icon 64px)
- [x] 6.3 `rule_card_tile.dart`: colored left border by level (newbie emerald #10B981, casual amber #FBBF24, advanced red #F87171) ← (verify: spoiler banner stands out, onboarding icon styled, rule tiles color-coded by level)

## 7. Final checks

- [x] 7.1 Run `flutter analyze` in app/ — resolve any errors introduced by the redesign
- [x] 7.2 Verify no `Colors.white`/`Colors.black` direct usage, no `withOpacity`, no `surfaceTintColor` in changed files ← (verify: clean analyze, constraints honored, all new l10n keys present in all 3 generated files)
