## Why

WC 2026 matches frequently kick off between 22:00–05:00 local time for Vietnamese fans. There is no guidance in the app to help users decide whether to watch live, catch part of the match, or sleep and replay later. Sleep Plan fills this gap with a lightweight, non-medical suggestion card that appears automatically on the Match Detail screen for late-night fixtures.

## What Changes

- A `SleepPlanCard` widget appears in the Match Detail screen when the local kickoff hour is between 22:00 and 05:00 (inclusive of 22, exclusive of 05).
- The card presents three modes the user can read and act on:
  - **Late Watcher** — watch live; suggests a pre-match nap window based on kickoff time.
  - **Balanced** — watch the second half or highlights; suggests a sleep time and a partial-watch window.
  - **Healthy Replay** — skip live; suggests sleeping at a normal time and using Replay Planner to watch the next morning.
- The "Healthy Replay" mode includes a CTA button that opens the existing Replay Planner dialog for the match.
- A mandatory disclaimer is shown at the bottom of the card: "This is a personal schedule suggestion, not medical advice."
- The card is not shown for matches with kickoff between 05:00 and 21:59 local time.
- All strings are fully localized in Vietnamese and English.

## Capabilities

### New Capabilities

- `sleep-plan`: Late-night match sleep/watch suggestion card in Match Detail, with three modes and Replay Planner integration.

### Modified Capabilities

<!-- No existing spec-level requirements change. -->

## Impact

- `app/lib/features/matches/presentation/match_detail_screen.dart` — insert `SleepPlanCard` after the match info card, before action buttons.
- `app/lib/features/matches/presentation/widgets/sleep_plan_card.dart` — new widget file.
- `app/lib/l10n/app_en.arb` — add Sleep Plan i18n strings.
- `app/lib/l10n/app_vi.arb` — add Sleep Plan i18n strings.
- No new dependencies, no data model changes, no new providers.
