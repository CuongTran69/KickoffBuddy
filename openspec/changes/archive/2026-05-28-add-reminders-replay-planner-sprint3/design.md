## Context

Sprint 2 delivered the Match Scheduler — 104 World Cup 2026 matches in Isar, list/detail/manual-add/magic-add screens. The Match Detail screen has two placeholder buttons: "Set reminder" and "Plan replay", both disabled with tooltips saying "Coming in Sprint 3".

The Sprint 1 stub `core/notifications/notification_service.dart` defines the class and provider but its methods are all no-op. The `flutter_local_notifications: ^18.0.1` package is already in `pubspec.yaml`. The `timezone` and `flutter_timezone` packages are wired up. The `Match` Isar collection already has `reminders: List<int>`, `replayPlannerEnabled: bool`, and `replayPlannedAt: DateTime?` fields.

Sprint 3 turns the placeholders into real features. The core architectural rule from `docs/architecture/04-time-handling.md` — never use raw `DateTime` for scheduling, always `tz.TZDateTime` — must be enforced everywhere. Both features schedule local notifications, so the same notification service is shared.

This sprint also closes 3 test coverage gaps from Sprint 2 verification.

### Constraints

- Solo dev, MVP timeline (`docs/product/03-roadmap.md`).
- WC 2026 begins 2026-06-11; the app must be store-submittable before that.
- VN age rating regulatory deadline 2026-06-18 (Risk 5 in `docs/product/05-risks.md`).
- iOS notification permission UX is sensitive — Apple rejects apps that prompt at launch (`docs/compliance/02-store-review.md`).
- Android 13+ adds runtime POST_NOTIFICATIONS permission, older versions auto-grant — must handle both.
- All time math goes through `TimezoneService` and `tz.TZDateTime`, never raw `DateTime` for schedule operations.

### Stakeholders

- End users (4 personas in `docs/product/01-vision.md`, especially the timezone-shifted fan persona).
- Solo dev (you).
- Future Sprint 4 (Rule Cards + Vocabulary) — independent, no shared state.
- Future Sprint 5 polish — may add custom reminder offset input, recurring reminders.

## Goals / Non-Goals

**Goals:**

- Real, working `flutter_local_notifications` integration for both Reminders and Replay Planner.
- Permission flow that respects Apple's "deferred prompting" guidance (request at first interaction, not at launch).
- Reminder UI: bottom sheet with 4 preset chips, multi-select, persists per match.
- Replay Planner UI: dialog with datetime picker, validates against kickoff, schedules pre-replay reminder.
- Spoiler shield visual mode: badge + banner during the active shield window.
- 3 Sprint 2 test gaps closed: integration test for Isar CRUD, mock-repo widget test for MatchListScreen, past-date error widget test.
- 0 regressions in existing 44 Sprint 2 tests.
- `flutter analyze` clean.

**Non-Goals:**

- Match scores / live results (not in MVP).
- Custom reminder offset input UI (Sprint 5 polish).
- Recurring reminders / weekly notifications.
- Reminder history / firing log.
- iOS provisional notifications.
- iOS critical alerts entitlement.
- Push notifications (no backend in MVP).
- Notification action buttons (Snooze, Dismiss).
- Notification grouping for multi-match days.

## Decisions

### D1: Permission request triggered on first "Set reminder" tap, not at app launch

**Decision:** Request notification permission only when user first taps "Set reminder". NOT during onboarding, NOT at boot.

**Rationale:**
- Apple App Review historically rejects apps that prompt for notifications without context (`docs/compliance/02-store-review.md` mentions this).
- Onboarding-time prompts have low grant rates because users have no context yet.
- First "Set reminder" tap is exactly the right moment — the user has explicitly opted into the feature.
- Android 13+ requires runtime POST_NOTIFICATIONS prompt; pre-13 auto-grants — both flows funnel through the same trigger.

**Alternatives considered:**
- Onboarding step: rejected — see above.
- App-launch prompt: rejected — same Apple risk.
- Defer to Settings only: rejected — too friction-heavy for first-time users.

### D2: Cancel-then-reschedule pattern on every save

**Decision:** Every reminder save calls `cancelAllForMatch(matchId)` first, then schedules new notifications for each selected offset.

**Rationale:**
- Avoids duplicate notifications when user edits selection.
- Avoids stale notifications when user removes an offset.
- Simpler than diff-based update; cancel is idempotent and cheap.
- Same pattern works for replay planner (cancel old replay reminder before scheduling new one).

**Alternatives considered:**
- Diff and patch: more code, more bugs, no measurable performance benefit at our scale (max 4 per match).

### D3: Notification ID = stable hash of (match.id + suffix)

**Decision:** `notificationIdFor(matchId, offsetMinutes)` returns `(matchId + "_" + offsetMinutes).hashCode.abs()`. Replay reminder uses suffix `"_replay"` instead of an offset number.

**Rationale:**
- Cancellation by ID requires deterministic, recomputable IDs.
- Hash collision risk is low given the small offset namespace (4 values + replay) per match.
- Avoids needing to persist a separate notification-ID-to-match mapping.

**Alternatives considered:**
- Persist an Isar table mapping IDs to (match, offset): overkill for the small set.
- Use auto-incrementing IDs from a counter: makes cancellation harder.

**Edge case:** If `(matchId + "_30").hashCode == (otherMatchId + "_5").hashCode`, the cancel for one will cancel the other. Across 104 matches × 5 offsets = 520 IDs out of 2³¹ space, collision probability is ~2.5e-7. Acceptable for MVP.

### D4: All schedule arithmetic uses `tz.TZDateTime`

**Decision:** Every notification schedule call computes the fire time as `tz.TZDateTime.from(match.kickoffAtUtc, tz.local).subtract(Duration(minutes: offset))`. Never a plain `DateTime`.

**Rationale:**
- `flutter_local_notifications.zonedSchedule` requires `tz.TZDateTime`.
- Plain `DateTime.subtract` then convert silently breaks during DST transitions (the canonical bug from `docs/architecture/04-time-handling.md`).
- Single rule: pass through `TimezoneService` → `tz.TZDateTime` → scheduler.

### D5: "Match started" disabled label vs hide button

**Decision:** When `kickoffAtUtc < now`, replace "Set reminder" with a disabled label "Match started" — keep visual placement, indicate state.

**Rationale:**
- Hiding the button creates layout shift between matches.
- Disabled label communicates "this feature exists but isn't applicable right now" — better than disappearing.

### D6: Spoiler shield is visual only in Sprint 3

**Decision:** Sprint 3 adds the badge + banner UI but does NOT mask any score-bearing UI (because there are no scores in MVP). The visual is a placeholder so Sprint 4+ feature additions know to honor the shield.

**Rationale:**
- No scores yet → nothing to actually hide.
- But the spoiler-shield contract must be visually testable now so future contributors know to wrap any new score widget with `if (!shieldActive)`.

### D7: Banner placement on Match Detail — top of body, below AppBar

**Decision:** Spoiler banner is the first widget in the body Column, full-width, with neutral surface background (theme `surfaceVariant`), shield icon, and text.

**Rationale:**
- Top placement is the conventional "info banner" location.
- Neutral color (not red/error) — this is a positive feature, not a warning.
- Below AppBar so navigation isn't visually compressed.

### D8: Replay reminder offset is fixed at 5 min

**Decision:** Replay Planner schedules a single 5-min-before-replay reminder. Configurable offset deferred to Sprint 5.

**Rationale:**
- One offset is enough to deliver the value; multiple offsets here add complexity without proportional benefit.
- Configurability is a polish-tier nice-to-have.

### D9: Test gap fixes folded into Sprint 3 spec

**Decision:** The 3 Sprint 2 test gaps (Isar CRUD via integration_test, mock-repo widget test, past-date widget test) are tasks within this Sprint 3 change.

**Rationale:**
- They're small enough to bundle.
- Better to close them under a single change with clear traceability than create a separate "test debt" change.
- Keeps the Sprint 2 archive clean (it remains a feature change, not a debt change).

### D10: Folder structure feature-first under `features/reminders/` and `features/replay_planner/`

**Decision:** Two separate feature folders, mirroring the Sprint 2 `features/matches/` pattern.

```
app/lib/features/reminders/
├── application/
│   ├── reminder_controller.dart
│   └── reminder_scheduler.dart
├── data/
│   └── reminder_storage.dart
└── presentation/
    ├── reminder_sheet.dart
    └── widgets/
        └── reminder_offset_chip.dart

app/lib/features/replay_planner/
├── application/
│   └── replay_planner_controller.dart
└── presentation/
    ├── replay_planner_dialog.dart
    └── widgets/
        ├── spoiler_badge.dart
        └── spoiler_banner.dart
```

**Rationale:**
- Clean separation — both features deliver independently and could ship as separate releases if needed.
- Mirrors the existing pattern from Sprint 2.

## Risks / Trade-offs

- **[Risk] iOS notification permission denied → user can't reach Settings easily** → Mitigation: explanatory dialog with `app_settings` deep link button on denial. Documented in compliance/02-store-review.md notification permission handling.

- **[Risk] Android exact-alarm permission may be needed for kickoff-precise notifications on some Android versions** → Mitigation: `flutter_local_notifications` v18 handles this internally with `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle`. If verification reveals it's not, document the fallback (5-minute slop is acceptable per `docs/mvp/features/02-reminders.md`).

- **[Risk] User changes timezone mid-trip — scheduled notifications fire at wrong wall-clock time** → Mitigation: `tz.TZDateTime` resolves at fire time relative to current device timezone, so this is automatic. But we should test it. Add a note in testing checklist.

- **[Risk] Notification ID hash collision** → Mitigation: see D3 — collision probability ~2.5e-7 across the entire app catalog. Acceptable for MVP. Documented for Sprint 5+ to revisit if user reports.

- **[Risk] Replay planner banner is verbose, may clutter Match Detail** → Mitigation: subtle styling (neutral background, single line of text), only shown during the active shield window. Can be A/B tested in Phase 2.

- **[Risk] Spoiler shield window check requires a clock-tick to update UI** → Mitigation: spoiler banner watches a periodic timer (e.g., 60-second tick) provided by a Riverpod provider; banner re-renders each minute and disappears when the window ends. Document the timer pattern in design.

- **[Risk] Permission denied silently re-prompted by OS on each "Set reminder" tap** → Mitigation: track last-prompt result in SharedPreferences; if denied previously, skip OS prompt and go straight to the explanatory dialog with "Open Settings" link.

- **[Risk] Integration test for Isar CRUD requires device/simulator → can't run in pure CI** → Mitigation: mark integration_test/ as opt-in, document in README that it must run on device. Sprint 5 sets up CI matrix; Sprint 3 only requires it runs on local dev machine.

- **[Trade-off] Replay reminder offset is fixed at 5 min — power users may want 15 min or 1 hr** → Acceptable: configurable offset is Sprint 5 polish.

- **[Trade-off] No notification action buttons (snooze/dismiss)** → Acceptable: deferred to v2.

## Migration Plan

This is additive on top of Sprint 2. No data migration needed (the `Match` schema fields `reminders`, `replayPlannerEnabled`, `replayPlannedAt` already exist with default empty/false values).

**Deploy sequence:**
1. Add `app_settings` to pubspec; `flutter pub get`.
2. Implement `NotificationService` real methods (replace stub).
3. Wire `NotificationService.initialize()` into `main.dart`.
4. Implement reminder feature folder.
5. Implement replay planner feature folder.
6. Wire Match Detail buttons to new sheets/dialogs.
7. Wire Match Card spoiler badge.
8. Close 3 test gaps from Sprint 2.
9. Add new tests for Reminders + Replay Planner.
10. Run check suite: pub get, build_runner, flutter analyze, flutter test, flutter test integration_test.

**Rollback:** Sprint 3 lives entirely under new files (`features/reminders/`, `features/replay_planner/`) plus modifications to:
- `app/pubspec.yaml`
- `app/lib/core/notifications/notification_service.dart`
- `app/lib/main.dart`
- `app/lib/features/matches/presentation/match_detail_screen.dart`
- `app/lib/features/matches/presentation/widgets/match_card.dart`

Reverting these specific files restores Sprint 2 state. Match Isar schema fields (`reminders`, `replayPlannerEnabled`, `replayPlannedAt`) remain valid because Sprint 2 already had them.

## Open Questions

None. All architectural decisions are locked. Implementation-time edge cases (e.g., exact-alarm permission detection on Android) have explicit fallback strategies in the Risks section.
