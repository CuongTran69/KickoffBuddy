## Context

Kickoff Buddy targets Vietnamese fans who frequently watch WC 2026 matches at unusual hours (many fixtures kick off between 01:00–04:00 local time). The app already has a Replay Planner feature that lets users schedule a spoiler-free replay. Sleep Plan bridges the gap between "I see the match is at 02:00" and "I know what to do about it" — without requiring any new data, backend, or state management.

The Match Detail screen (`match_detail_screen.dart`) already computes `localKickoff` as a `tz.TZDateTime` and has a scrollable `Column` body. The Replay Planner dialog is already accessible via `showReplayPlannerDialog(context, match)`.

## Goals / Non-Goals

**Goals:**
- Show a contextual card on Match Detail when kickoff is between 22:00–04:59 local time.
- Present three named modes with a one-line suggestion each.
- Provide a "Set up Replay Planner" CTA in the Healthy Replay mode that opens the existing dialog.
- Display a mandatory disclaimer that this is not medical advice.
- Fully localize all strings (vi + en).

**Non-Goals:**
- Tracking which mode the user selects (no persistence, no analytics for MVP).
- Showing Sleep Plan on the Home screen or Match List screen.
- Integrating with device health/sleep APIs.
- Calculating exact sleep durations algorithmically (suggestions are fixed copy, not computed).
- Showing Sleep Plan for matches that have already kicked off.

## Decisions

**D1: Placement in Match Detail**
Insert `SleepPlanCard` between the match info card and the primary action buttons (My Matches toggle). This keeps it contextual — the user has just seen the kickoff time and is deciding what to do. Placing it after the info card and before actions follows the existing visual hierarchy: info → context → actions.

**D2: Trigger condition**
`localKickoff.hour >= 22 || localKickoff.hour < 5`. This covers 22:00–04:59. The card is also hidden if the match has already kicked off (`isKickedOff == true`) — no point suggesting a sleep plan for a past match.

**D3: Three modes as a segmented card, not a dialog**
Inline card (not a bottom sheet or dialog) keeps the flow non-interruptive. The user can scroll past it. Each mode is a tappable row that expands to show its suggestion text, or all three are shown statically — static display chosen for simplicity (no expand/collapse state needed).

**D4: Healthy Replay CTA**
The "Set up Replay Planner" button calls `showReplayPlannerDialog(context, match)` — the same function used by the existing "Plan replay" button. No new controller or provider needed.

**D5: Widget file location**
`app/lib/features/matches/presentation/widgets/sleep_plan_card.dart` — consistent with `match_card.dart`, `flag_avatar.dart`, etc. in the same widgets directory.

**D6: Styling**
Use the same glassmorphism card style as `_PremiumSettingsCard` in `settings_screen.dart` — translucent background, rounded corners (20), emerald border. Icon: `Icons.bedtime_outlined`. This matches the existing premium design system without introducing new design tokens.

**D7: Suggestion copy**
Fixed strings in ARB files, not computed. The three suggestions are:
- Late Watcher: "Nap before the match, then watch live."
- Balanced: "Watch the second half or highlights tomorrow."
- Healthy Replay: "Sleep now, watch the replay in the morning."

## Risks / Trade-offs

- [Risk] The card adds visual weight to an already-long Match Detail screen. → Mitigation: card is compact (single card, three rows, no expand/collapse), and only appears for late-night matches.
- [Risk] "Healthy Replay" CTA opens Replay Planner dialog — if the match has already kicked off, the dialog may behave differently. → Mitigation: the card is hidden when `isKickedOff == true`, so this path cannot be reached.
- [Risk] Fixed copy may not match every kickoff time precisely (e.g., a 22:30 match vs a 03:00 match have different optimal sleep windows). → Mitigation: copy is intentionally generic ("nap before the match") to avoid being wrong for any specific time. Phase 2 can add time-aware copy.
