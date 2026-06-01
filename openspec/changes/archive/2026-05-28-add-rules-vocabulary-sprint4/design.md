## Context

Sprint 1-3 delivered the scaffold, Match Scheduler with 104-match catalog, Reminders, Replay Planner with spoiler shield. The "Plan" and "Protect" pillars are complete.

Sprint 4 adds the third pillar: "Understand". Two read-only educational features ride on top of bundled JSON content already produced in initial parallel work — `app/assets/data/rule_cards.json` (21 cards: 7 topics × 3 levels) and `app/assets/data/vocabulary.json` (17 terms with VN+EN bilingual content).

These features are intentionally simpler than Sprint 2-3:
- No Isar persistence (per `docs/architecture/03-data-model.md` line 182)
- No notifications, no scheduling
- Read-only data, in-memory cache, simple JSON parsing
- Two screens for Rule Cards (list + detail), one for Vocabulary (single screen with inline expand)

Sprint 4 also folds in 5 small fixes for non-blocking warnings from Sprint 3 verification — they're not big enough to warrant a separate change.

### Constraints

- Solo dev, MVP timeline (`docs/product/03-roadmap.md`).
- WC 2026 starts 2026-06-11; the app must be store-submittable before that date.
- VN-first language preference (the primary user persona is a Vietnamese fan).
- Established VN football vocabulary must be used (e.g., "việt vị" not "ngoài lề"). Already curated in vocabulary.json.
- Time-handling rule from Sprint 1+ remains: never use raw `DateTime` for any scheduling work. (Not relevant to Sprint 4 since no notifications are involved, but stays as a global rule.)

### Stakeholders

- End users (especially the Newbie persona — needs Newbie-level cards; and the Vietnamese-fan persona — needs VN-first content).
- Solo dev (you).
- Future Sprint 5 polish — will add cross-linking from Match Detail to relevant rules; not in scope here.

## Goals / Non-Goals

**Goals:**

- Working `/rules` list with 7 topic sections and 3-level filter (Newbie default).
- Working `/rules/:id` detail with VN body + EN toggle.
- Working `/vocabulary` single screen with diacritic-insensitive search and inline expand.
- Repository pattern for both, in-memory cache, no Isar.
- Sprint 3 warning fixes complete (W1, W2, S1, S2, S3).
- 0 regressions on existing 86 tests.
- `flutter analyze` clean.

**Non-Goals:**

- Quiz / Situation Simulator (Phase 3 future feature).
- Sleep Plan, Fan Etiquette Guide (Phase 2).
- Cross-link from Match Detail to relevant Rule Cards (Sprint 5 polish).
- Bookmarking favorite rules / vocabulary (out of MVP).
- Reading progress tracking (out of MVP).
- Audio pronunciation for vocabulary (out of MVP).
- Pull-to-refresh on JSON content (it's bundled — no refresh needed).
- Editable content in-app (curated content only — devs update JSON, ship new app version).

## Decisions

### D1: No Isar for content

**Decision:** Rule Cards and Vocabulary load from JSON via `rootBundle`, cached in memory in their respective repositories. No Isar collection, no schema, no `build_runner` for these features.

**Rationale:**
- `docs/architecture/03-data-model.md` line 182 explicitly states this — read-only content is bundled, not persisted.
- Content is small (21 cards + 17 terms ≈ a few KB).
- Eliminates a code-gen step and keeps the simple feature simple.
- Updates ship via app updates, not data updates.

**Alternatives considered:**
- Isar storage with seed loader: overkill for read-only static content, wastes startup time + DB space.
- SharedPreferences blob: works but less natural for structured JSON.

### D2: VN-first UI with EN toggle on detail

**Decision:** Rule cards show VN content by default. Detail screen has a single VN/EN toggle that switches both title and body. Vocabulary shows VN+EN side-by-side (VN bold/primary, EN subdued).

**Rationale:**
- Primary user is Vietnamese; VN should be the default.
- Toggle (not always-bilingual) keeps the rule body uncluttered for the dominant case.
- Vocabulary inline-expand is short enough to show both bilingually without crowding.

### D3: Diacritic-insensitive search via existing field

**Decision:** Use the existing `term_vi_no_diacritics` field already populated in `vocabulary.json` (e.g., "Việt vị" → "viet vi"). Search compares the query (lowercased, diacritics stripped client-side via a small helper) against `term_vi`, `term_vi_no_diacritics`, AND `term_en`, all case-insensitive.

**Rationale:**
- `term_vi_no_diacritics` was generated in initial content work — reuse it.
- Avoids re-implementing VN diacritic normalization at runtime.
- Three-field match handles the common cases: native VN typing, ASCII-keyboard VN typing, and English typing.

### D4: 200 ms debounce on search input

**Decision:** Search controller wraps a `Timer` that fires `_runFilter()` 200 ms after the last keystroke. Empty query is applied immediately (no debounce).

**Rationale:**
- 200 ms is the standard UX threshold for "feels instant" without re-filtering on every keystroke.
- Empty query immediate ensures clearing filters feels responsive.

### D5: Inline expand for vocabulary, separate detail route for rule cards

**Decision:** Vocabulary uses inline expand (no `/vocabulary/:id` route). Rule Cards have a separate `/rules/:id` detail route.

**Rationale:**
- Vocabulary content is short — VN definition + EN definition + 1-2-line example. Fits inline without creating a "navigation jail".
- Rule Cards content is longer — full body paragraphs need a dedicated screen with proper scroll, EN toggle, related cards.
- Inline expand allows rapid scanning across many vocabulary terms; separate detail forces a focused read for rules.

### D6: Riverpod patterns mirror Sprint 2-3

**Decision:** 
- Repositories: `FutureProvider<Repository>` that loads JSON on first invocation.
- Filter/search state: `NotifierProvider` per feature (`ruleCardsLevelProvider`, `vocabularySearchControllerProvider`).
- Async data: `AsyncValue` for loading/error/data UI states.

**Rationale:**
- Consistent with established codebase patterns from Sprint 2 (`matchRepositoryProvider`) and Sprint 3 (`reminderControllerProvider`).
- Riverpod's `AsyncValue` handles all 3 UI states uniformly — no boilerplate.

### D7: NotificationService gets plugin injection (W1 fix)

**Decision:** Add a constructor parameter `FlutterLocalNotificationsPlugin? plugin` (nullable, defaults to `FlutterLocalNotificationsPlugin()`). Singleton pattern preserved via private static `_instance`. Tests instantiate `NotificationService(mockPlugin)` directly to bypass the singleton.

**Rationale:**
- Minimal API surface change.
- Singleton remains for production code (which uses the default real plugin).
- Tests get a fresh instance with a mock plugin — no global state leaks between tests.
- Avoids invasive refactoring like making the plugin a Riverpod-injected dependency (which would propagate through the call graph).

**Alternatives considered:**
- Move plugin to a Riverpod provider: too invasive, propagates through reminder_controller, replay_planner_controller.
- Setter for `plugin` field: makes singleton mutable, encourages bad patterns.

### D8: mocktail over mockito (W1 fix)

**Decision:** Add `mocktail: ^1.0.4` as a dev_dependency.

**Rationale:**
- No code-gen required (mockito needs `build_runner`).
- Modern API, lighter footprint.
- Ships with `Mock` base class and `when/verify` patterns we already know.

### D9: spoiler_banner.dart token (S3 fix)

**Decision:** Re-evaluate `theme.colorScheme.surfaceContainerHighest` vs `theme.colorScheme.surfaceVariant`. If `surfaceVariant` is available without deprecation warning in our Flutter version, switch. If it triggers deprecation, keep `surfaceContainerHighest` and document this divergence here.

**Rationale:**
- Sprint 3 design.md said `surfaceVariant`; implementation used `surfaceContainerHighest` because it's the M3 successor.
- Visually equivalent in current theme.
- Decision deferred to implementation — `flutter analyze` will tell us if `surfaceVariant` is deprecated; pick whichever passes.

**If `surfaceVariant` is deprecated in our Flutter version:** Keep `surfaceContainerHighest`. Document the rationale here so the divergence is traceable.

**If both work:** Use `surfaceVariant` to match the Sprint 3 design intent literally.

### D10: Folder structure mirrors Sprint 2-3

```
app/lib/features/rule_cards/
├── data/
│   ├── rule_card.dart                    # Immutable model
│   └── rule_card_repository.dart
├── application/
│   └── rule_cards_controller.dart        # level filter state
└── presentation/
    ├── rule_cards_screen.dart
    ├── rule_card_detail_screen.dart
    └── widgets/
        ├── rule_card_tile.dart
        ├── level_filter_chips.dart
        └── rule_topic_section.dart

app/lib/features/vocabulary/
├── data/
│   ├── vocabulary_item.dart
│   └── vocabulary_repository.dart
├── application/
│   └── vocabulary_search_controller.dart
└── presentation/
    ├── vocabulary_screen.dart
    └── widgets/
        ├── vocabulary_tile.dart           # collapsed + expanded states
        └── vocabulary_search_bar.dart
```

**Rationale:**
- Same pattern as `features/matches/`, `features/reminders/`, `features/replay_planner/`.

## Risks / Trade-offs

- **[Risk] JSON content has typos or missing fields → repository load throws** → Mitigation: defensive parsing — wrap in try/catch in repository, surface error via AsyncValue.error so UI shows error state with retry. Validation script in Sprint 1 already checked field presence; the risk is post-hoc edits introducing issues.

- **[Risk] Search debounce 200 ms feels sluggish on fast typers** → Mitigation: 200 ms is industry-standard for search; can A/B-test in Phase 2. If users complain, drop to 100 ms.

- **[Risk] Inline-expand vocabulary list scrolls awkwardly when expanding mid-list (rows below shift)** → Mitigation: standard Flutter `AnimatedSize` or `ExpansionTile` handles this gracefully. Visual feedback should make the shift feel intentional.

- **[Risk] Related-term chip target is filtered out by current search** → Mitigation: the spec scenario "Related term filtered out" handles this — clear search before scrolling.

- **[Risk] mocktail interaction with NotificationService refactor** → Mitigation: refactor is minimal (one constructor parameter). Tests will validate the interface contract, not implementation internals. If mocktail proves brittle, fall back to a manual fake class.

- **[Risk] `surfaceVariant` token divergence breaks if Flutter SDK changes M3 specs again** → Mitigation: D9 decision is conditional — pick whichever works in current SDK. If both work, prefer `surfaceVariant`.

- **[Trade-off] No detail route for vocabulary** → Acceptable: content is short, inline expand is more natural.

- **[Trade-off] No bookmarking** → Acceptable: deferred to Sprint 5 polish.

## Migration Plan

This is additive on top of Sprint 3. No data migration needed — content JSON files already exist from initial parallel work.

**Deploy sequence:**
1. Add `mocktail` to dev_dependencies; `flutter pub get`.
2. Refactor `NotificationService` to accept plugin parameter.
3. Replace `notification_service_test.dart` with mock-plugin tests (W1 + S2).
4. Add W2 test to `reminder_sheet_test.dart`.
5. Upgrade S1 past-date test in `manual_add_screen_test.dart`.
6. Re-evaluate `spoiler_banner.dart` token (S3) and adjust if `surfaceVariant` works.
7. Implement `features/rule_cards/` data + UI + tests.
8. Implement `features/vocabulary/` data + UI + tests.
9. Wire 3 new routes; add Home CTAs.
10. Run check suite: pub get, build_runner, flutter analyze, flutter test.

**Rollback:** Sprint 4 lives entirely under new files (`features/rule_cards/`, `features/vocabulary/`) plus surgical changes to:
- `app/pubspec.yaml`
- `app/lib/core/notifications/notification_service.dart` (constructor param)
- `app/lib/features/replay_planner/presentation/widgets/spoiler_banner.dart` (token)
- `app/lib/core/routing/routes.dart` + `app_router.dart`
- `app/lib/features/home/presentation/home_screen.dart` (CTAs)
- A few test files

Reverting these specific files restores Sprint 3 state.

## Open Questions

None. All decisions are locked. Implementation-time S3 decision (which surface token to use) has explicit fallback criteria in D9.
