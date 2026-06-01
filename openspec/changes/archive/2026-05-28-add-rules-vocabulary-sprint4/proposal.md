## Why

Sprint 1-3 delivered the Flutter scaffold, 104-match WC 2026 catalog with timezone-aware browsing, manual + Magic Add, local notifications for reminders, and replay planner with spoiler shield mode. The "Plan" and "Protect" pillars of the 3P framework are now complete.

Sprint 4 closes the "Understand" pillar — the third leg of the value proposition. Two read-only educational features (Rule Cards and Vocabulary) help newcomers and timezone-shifted fans learn football vocabulary and rules. The content (21 rule cards + 17 terms) is already bundled as JSON from initial parallel work; this sprint builds the UI surfaces that consume it.

This sprint also closes 5 non-blocking warnings from Sprint 3 verification (test coverage gaps, redundant test, and a theme token alignment).

## What Changes

### Rule Cards (new capability)
- New routes `/rules` (list) and `/rules/:id` (detail).
- List screen: 7 topic sections (offside, penalty, VAR, cards, stoppage time, extra time, penalty shootout); level filter chips (Newbie / Casual / Advanced); one card per topic at the active level.
- Detail screen: VN title, level badge, full body (VN default + EN toggle), tags, read-time estimate, related cards, prev/next pagination across topics.
- `RuleCardRepository` loads `app/assets/data/rule_cards.json` once via rootBundle, in-memory cache. No Isar.

### Vocabulary (new capability)
- New route `/vocabulary` (single screen, inline expand — no separate detail route).
- Search bar with diacritic-insensitive matching (uses bundled `term_vi_no_diacritics` field).
- Alphabetically-sorted list; tap row → inline expand showing full VN+EN definition, VN+EN example, related-term chips.
- Real-time filter with 200 ms debounce; empty results show "No matches" with clear button.
- `VocabularyRepository` loads `app/assets/data/vocabulary.json` once via rootBundle, in-memory cache. No Isar.

### Routing + Home
- 3 new routes registered in `app_router.dart`.
- Home screen extended with "Rules" and "Vocabulary" CTAs alongside the existing "Matches" CTA.

### Sprint 3 warning fixes (folded in)
- W1: Refactor `NotificationService` to support plugin injection; replace placeholder singleton-only test with real mock-plugin contract tests using `mocktail` (initialize idempotency, scheduleAt invocation, cancel invocation).
- W2: Add "Save with all chips → 'Đã lưu nhắc nhở' snackbar" widget test to `reminder_sheet_test.dart`.
- S1: Upgrade past-date assertion in `manual_add_screen_test.dart` to verify the date picker's `firstDate` parameter directly, not just "Save disabled when no date".
- S2: Remove redundant `instance is not null` test from `notification_service_test.dart`.
- S3: Re-evaluate `spoiler_banner.dart` background token. Switch to `surfaceVariant` if available, otherwise document the divergence in this sprint's design.md and keep `surfaceContainerHighest`.

### Out of scope
- Quiz / Situation Simulator (Phase 3 future feature).
- Sleep Plan, Fan Etiquette Guide (Phase 2).
- Cross-linking from Match Detail to relevant Rule Cards.
- Bookmarking, reading progress, audio pronunciation.
- Pull-to-refresh (content is bundled — no refresh needed).

## Capabilities

### New Capabilities
- `rule-cards`: Educational rule explanations grouped by topic with 3-level depth (Newbie/Casual/Advanced); VN-first with EN toggle; bilingual content from bundled JSON.
- `vocabulary`: Searchable bilingual football vocabulary (17 terms) with diacritic-insensitive matching and inline expand pattern.

### Modified Capabilities
- None. Sprint 3 specs (`match-reminders`, `replay-planner`) and Sprint 2 specs (`match-data-store`, `match-scheduler`) stay as-is. No requirement-level changes — only additive new capabilities and isolated fixes.

## Impact

### Affected code

**New feature directories:**
- `app/lib/features/rule_cards/` (data, application, presentation, widgets — 8 files).
- `app/lib/features/vocabulary/` (data, application, presentation, widgets — 6 files).

**Modified files:**
- `app/pubspec.yaml` — add `mocktail: ^1.0.4` dev_dependency.
- `app/lib/core/notifications/notification_service.dart` — add testable plugin injection.
- `app/lib/features/replay_planner/presentation/widgets/spoiler_banner.dart` — token review (S3).
- `app/test/core/notifications/notification_service_test.dart` — replace with mock-plugin tests (W1 + S2).
- `app/test/features/reminders/reminder_sheet_test.dart` — add W2 test.
- `app/test/features/matches/manual_add_screen_test.dart` — upgrade S1 past-date test.
- `app/lib/core/routing/routes.dart` — 3 new constants.
- `app/lib/core/routing/app_router.dart` — 3 new GoRoutes.
- `app/lib/features/home/presentation/home_screen.dart` — 2 new CTA buttons.

**New test files:**
- `app/test/features/rule_cards/` (3 files).
- `app/test/features/vocabulary/` (3 files).

### Data files
- No data file changes — content already bundled in Sprint 1.

### Build pipeline
- No new code-gen requirements (no Isar collections in this sprint).
- `mocktail` adds runtime mock support — no build_runner involvement.

### No backend / external systems
- All content is local. No notifications, no API calls.
