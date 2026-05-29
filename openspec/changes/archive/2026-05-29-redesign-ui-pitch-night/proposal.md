## Why

The current UI is essentially unstyled Material 3 defaults with a green seed color. The emerald/slate/amber palette and Inter font are solid, but they are barely used — no depth, no surface layering, no purposeful accent, and the Home screen is a dead-end launcher with three stacked buttons. The app does not feel like a polished sports companion. This redesign ("Pitch Night") makes the existing design tokens come alive without changing the brand palette.

## What Changes

- **Navigation model**: Replace the Home-screen CTA-button navigation with a persistent bottom `NavigationBar` wired via go_router `ShellRoute`. Four destinations: Home, Matches, Rules, Vocabulary. Onboarding stays outside the shell.
- **Theme depth**: Add `cardTheme`, `appBarTheme`, `chipTheme`, `dividerTheme`, and `navigationBarTheme` to both light and dark `ThemeData` so cards, app bars, chips, and dividers are styled consistently app-wide.
- **New color tokens**: Add Slate-700 (surfaceContainerHigh), Slate-400 (onSurfaceMuted), Emerald-700 (primaryDim), Red-400 (error) for both light and dark.
- **Home dashboard**: Replace the launcher with a real dashboard — Next Match Hero Card (gradient, large flags, Amber countdown pill), "Next match" section, and a "Quick learn" rule-card section. Requires a new provider to fetch the next upcoming match.
- **Match card / detail / section header polish**: Larger flags, better spacing, "today" Amber accent, prominent hero, grouped action buttons.
- **Spoiler banner, onboarding icon, rule-card level coloring, info-row spacing**: Tier-3 polish items.
- All new user-facing strings go through l10n (EN/VI).

## Capabilities

### New Capabilities

- `app-navigation`: Persistent bottom-navigation shell that hosts the four primary sections and preserves navigation context across them.
- `home-dashboard`: A Home dashboard showing the next upcoming match as a hero with a live countdown, plus quick-access sections.

### Modified Capabilities

## Impact

- **Routing**: `app/lib/core/routing/app_router.dart`, `routes.dart`, new `app_shell.dart` (NavigationBar shell)
- **Theme**: `app/lib/core/theme/app_colors.dart` (new tokens), `app_theme.dart` (component themes)
- **Home**: `app/lib/features/home/presentation/home_screen.dart` (dashboard), new `next_match_provider.dart`
- **Matches**: `widgets/match_card.dart`, `widgets/date_section_header.dart`, `match_detail_screen.dart`
- **Replay planner**: `widgets/spoiler_banner.dart`
- **Onboarding**: `steps/welcome_step.dart`
- **Rule cards**: `widgets/rule_card_tile.dart`
- **L10n**: `app_en.arb`, `app_vi.arb`, and the 3 generated Dart files (nav labels + home dashboard strings)
- **No behavioral/data changes** — purely presentational plus a new read-only provider and a navigation-structure change.
