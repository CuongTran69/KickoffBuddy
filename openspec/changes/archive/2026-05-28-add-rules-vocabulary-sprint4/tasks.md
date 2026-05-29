## 1. Sprint 3 warning fixes (folded in)

- [x] 1.1 Add `mocktail: ^1.0.4` to `app/pubspec.yaml` dev_dependencies; run `cd app && /Users/cuongtran/flutter/bin/flutter pub get`
- [x] 1.2 Refactor `app/lib/core/notifications/notification_service.dart` to accept an optional plugin via constructor: `NotificationService([FlutterLocalNotificationsPlugin? plugin])` storing it in a field; default singleton creation passes the production plugin; test code can call `NotificationService(mockPlugin)` directly
- [x] 1.3 Rewrite `app/test/core/notifications/notification_service_test.dart` to use `mocktail`:
  - Test "initialize is idempotent": call `initialize()` twice on the same instance, verify `plugin.initialize` called once OR channel registration called once (whichever the impl calls — verify via mocktail `.called(1)`)
  - Test "scheduleAt calls plugin.zonedSchedule with correct params": pass a fixed id, title, body, tz.TZDateTime; verify mock was invoked with those args
  - Test "cancel calls plugin.cancel with the correct id"
  - Remove the redundant `instance is not null` test (S2 — it's covered by singleton equality test)
  - Keep the `instance returns the same singleton` test if that path still exists
- [x] 1.4 Add to `app/test/features/reminders/reminder_sheet_test.dart` (W2) a test "Save with all chips → 'Đã lưu nhắc nhở' snackbar":
  - Pump the sheet with a future-dated mock match
  - Tap each of the 4 reminder chips
  - Tap the Save button
  - Pump and verify a SnackBar with text "Đã lưu nhắc nhở" is visible
- [x] 1.5 Upgrade `app/test/features/matches/manual_add_screen_test.dart` past-date test (S1):
  - Either: locate the date picker button, tap it, intercept the `showDatePicker` dialog parameters via a fake `DatePickerProvider` or `WidgetTester.runAsync`, assert `firstDate == today.startOfDay()`
  - OR (preferred if showDatePicker dialog can't be intercepted cleanly): use `package:clock` or pass an explicit "now" override into the screen and verify the screen's internal `_minDate` getter returns today's start. Test the date validation method's behavior with a past date input.
  - The test must clearly fail if a future change relaxes the firstDate constraint
- [x] 1.6 Re-evaluate `app/lib/features/replay_planner/presentation/widgets/spoiler_banner.dart` background (S3):
  - Try `theme.colorScheme.surfaceVariant`; run `flutter analyze`
  - If clean → keep `surfaceVariant`
  - If deprecation warning → revert to `surfaceContainerHighest`, document divergence here in a code comment ← (verify: chosen token compiles cleanly without deprecation warning)
- [x] 1.7 Run `cd app && /Users/cuongtran/flutter/bin/flutter test` — all 86 existing tests + W1/W2 additions pass; no regressions ← (verify: 86 + 4 new tests minimum, all green)

## 2. Rule Cards data layer

- [x] 2.1 Create `app/lib/features/rule_cards/data/rule_card.dart`:
  - Immutable class `RuleCard` with fields: `id` (String), `topic` (String), `level` (String), `titleEn`, `titleVi`, `summaryEn`, `summaryVi`, `bodyEn`, `bodyVi`, `tags` (List\<String\>), `lastReviewed` (String), `estimatedReadSeconds` (int?, optional), `relatedIds` (List\<String\>, default empty), `ifabReference` (String?, optional)
  - `factory RuleCard.fromJson(Map<String, dynamic> json)` constructor
  - `const` constructor + `==` + `hashCode` for value semantics
- [x] 2.2 Create `app/lib/features/rule_cards/data/rule_card_repository.dart`:
  - `class RuleCardRepository` with private `List<RuleCard>? _cache`
  - Method `Future<List<RuleCard>> getAll()`: lazy load from `rootBundle.loadString('assets/data/rule_cards.json')`, parse JSON, cache, return
  - Method `Future<RuleCard?> getById(String id)`: returns first card matching id or null
  - Method `Future<List<RuleCard>> getByTopic(String topic)`: filters by topic
  - Method `Future<List<RuleCard>> getByTopicAndLevel(String topic, String level)`: filters by both
- [x] 2.3 Expose `final ruleCardRepositoryProvider = FutureProvider<RuleCardRepository>(...)` (or simpler `Provider<RuleCardRepository>` if no async setup needed beyond first load)
- [x] 2.4 Add `final ruleCardsListProvider = FutureProvider<List<RuleCard>>` that returns `repository.getAll()` ← (verify: repo loads 21 cards, getByTopic returns 3 per topic, getByTopicAndLevel returns 1)

## 3. Rule Cards application layer

- [x] 3.1 Create `app/lib/features/rule_cards/application/rule_cards_controller.dart`:
  - `enum RuleLevel { newbie, casual, advanced }` with helper `String get jsonValue` returning lowercase string
  - `final ruleLevelFilterProvider = NotifierProvider<RuleLevelFilterNotifier, RuleLevel>`; default state = `RuleLevel.newbie`; method `void setLevel(RuleLevel level)`
  - Computed provider `final filteredRuleCardsProvider = FutureProvider<List<RuleCard>>` that returns cards matching current level filter (one per topic) ← (verify: switching level changes which cards are returned)

## 4. Rule Cards presentation — list screen

- [x] 4.1 Create `app/lib/features/rule_cards/presentation/widgets/level_filter_chips.dart`:
  - StatelessWidget receives `RuleLevel currentLevel`, `void Function(RuleLevel) onSelected`
  - Renders 3 ChoiceChips: "Newbie" / "Casual" / "Advanced" with i18n-friendly Vietnamese labels: "Người mới" / "Thỉnh thoảng" / "Nâng cao"
- [x] 4.2 Create `app/lib/features/rule_cards/presentation/widgets/rule_card_tile.dart`:
  - StatelessWidget receives `RuleCard card`, `VoidCallback onTap`
  - Renders Card with VN title (bold), VN summary (1-2 lines), tap → onTap
- [x] 4.3 Create `app/lib/features/rule_cards/presentation/widgets/rule_topic_section.dart`:
  - StatelessWidget receives `String topic`, `String topicLabelVi`, `RuleCard? card`
  - Section header with topic label, body shows the card tile (or "No card available" defensively)
- [x] 4.4 Create `app/lib/features/rule_cards/presentation/rule_cards_screen.dart`:
  - ConsumerWidget watching `ruleLevelFilterProvider` + `filteredRuleCardsProvider`
  - AppBar title "Luật bóng đá", body: level filter chips + 7 topic sections in fixed order [offside, penalty, var, cards, stoppage_time, extra_time, shootout]
  - Topic VN labels hardcoded const map: offside→"Việt vị", penalty→"Phạt đền", var→"VAR", cards→"Thẻ", stoppage_time→"Bù giờ", extra_time→"Hiệp phụ", shootout→"Sút luân lưu"
  - Loading state, error state with retry
  - Tap card → push `/rules/<card-id>` ← (verify: 7 sections render, default Newbie chip selected, switching changes visible cards, tap navigates correctly)

## 5. Rule Cards presentation — detail screen

- [x] 5.1 Create `app/lib/features/rule_cards/presentation/rule_card_detail_screen.dart`:
  - ConsumerStatefulWidget receives `String ruleId` from path param
  - Local state: `bool _showEnglish = false`
  - Watch repository via `ref`, fetch by ID; render based on AsyncValue
  - Hero: title (VN by default, EN if toggled), level badge ("Người mới" / "Thỉnh thoảng" / "Nâng cao")
  - VN/EN toggle Switch with label "English"
  - Body: full text, font size readable (theme bodyLarge), line height 1.5+
  - Tags chips
  - Read time row: "Đọc trong: X giây" (only if `estimatedReadSeconds` present)
  - Related cards section: list of cards from `relatedIds`, tap → push to that card's detail
  - 404 state: "Không tìm thấy luật" + "Quay lại" button
- [x] 5.2 Wire detail screen reads `ref.watch(ruleCardRepositoryProvider).whenData((repo) => repo.getById(ruleId))` or similar pattern ← (verify: VN body by default, toggle reveals EN, tags as chips, read time conditional, related cards navigate, 404 fallback)

## 6. Vocabulary data layer

- [x] 6.1 Create `app/lib/features/vocabulary/data/vocabulary_item.dart`:
  - Immutable class `VocabularyItem` with fields: `id`, `termEn`, `termVi`, `termViNoDiacritics`, `definitionEn`, `definitionVi`, `exampleEn`, `exampleVi`, `related` (List\<String\>), `category` (String?)
  - `factory VocabularyItem.fromJson(Map<String, dynamic> json)`
- [x] 6.2 Create `app/lib/features/vocabulary/data/vocabulary_repository.dart`:
  - `class VocabularyRepository` with `List<VocabularyItem>? _cache`
  - `Future<List<VocabularyItem>> getAll()`: lazy load from `rootBundle.loadString('assets/data/vocabulary.json')`, parse, sort alphabetically by `termVi`, cache, return
  - `Future<VocabularyItem?> getById(String id)`
  - `Future<List<VocabularyItem>> search(String query)`: lowercase query, also normalize diacritics; for empty/null query return all; otherwise return items where `termVi.toLowerCase().contains(query)` OR `termViNoDiacritics.toLowerCase().contains(normalizedQuery)` OR `termEn.toLowerCase().contains(query)`
  - Helper `String _stripVietnameseDiacritics(String input)` — small map of VN diacritic chars → ASCII equivalents (use the same logic as the JSON's `term_vi_no_diacritics` field generator, which strips diacritics deterministically)
- [x] 6.3 Expose `final vocabularyRepositoryProvider = FutureProvider<VocabularyRepository>` ← (verify: 17 items, search VN exact, search VN diacritic-insensitive, search EN, empty returns all)

## 7. Vocabulary application layer

- [x] 7.1 Create `app/lib/features/vocabulary/application/vocabulary_search_controller.dart`:
  - `class VocabularySearchState { String query; List<VocabularyItem> results; bool loading; }`
  - `class VocabularySearchNotifier extends Notifier<VocabularySearchState>`:
    - On init: load all items from repo, set results to all
    - Method `void setQuery(String q)`: cancel existing 200ms Timer, set new Timer that calls `_runFilter(q)`
    - If `q.isEmpty` → apply immediately (no debounce)
    - `_runFilter(q)` calls `repository.search(q)` and updates state
  - `final vocabularySearchControllerProvider = NotifierProvider<VocabularySearchNotifier, VocabularySearchState>` ← (verify: empty query immediate, non-empty debounced 200ms, results filter correctly)

## 8. Vocabulary presentation

- [x] 8.1 Create `app/lib/features/vocabulary/presentation/widgets/vocabulary_search_bar.dart`:
  - StatelessWidget with TextField, prefix search icon, suffix clear icon (when non-empty)
  - On change → call `ref.read(vocabularySearchControllerProvider.notifier).setQuery(value)`
- [x] 8.2 Create `app/lib/features/vocabulary/presentation/widgets/vocabulary_tile.dart`:
  - StatefulWidget receives `VocabularyItem item`, `void Function(String relatedId)? onRelatedTap`
  - Local state `bool _expanded = false`
  - Collapsed: VN term (bold large), EN term (subtitle subdued), tap toggles `_expanded`
  - Expanded (use AnimatedSize or ExpansionTile): VN definition, EN definition, VN example (italic), EN example (italic), related-term chips (each tappable → onRelatedTap)
- [x] 8.3 Create `app/lib/features/vocabulary/presentation/vocabulary_screen.dart`:
  - ConsumerStatefulWidget — needs ScrollController for scroll-to-related-term
  - Map\<String, GlobalKey\> for each item id (allows scroll-to)
  - AppBar title "Từ vựng"
  - Body: search bar at top, then ListView of VocabularyTile; if results empty after search → "Không có kết quả" with "Xóa tìm kiếm" button
  - Related-term tap handler:
    - If target item is in current results → scroll to its key + auto-expand
    - If target is filtered out → clear search via controller, then on next frame scroll to it + expand
- [x] 8.4 Compositional logic: tracking which tiles are expanded — keep this state in `vocabulary_screen.dart` (Map\<String, bool\>) so related-term taps can force-expand ← (verify: 17 terms render alphabetically, search filters real-time, tap expands inline, related-term chip scrolls and expands target)

## 9. Routing additions

- [x] 9.1 Update `app/lib/core/routing/routes.dart`: add constants `rules` (`/rules`), `ruleDetail` (helper `static String ruleDetail(String id) => '/rules/$id'`), `vocabulary` (`/vocabulary`)
- [x] 9.2 Update `app/lib/core/routing/app_router.dart`: register 3 new GoRoute entries; for `/rules/:id` extract path parameter via `state.pathParameters['id']`
- [x] 9.3 Update `app/lib/features/home/presentation/home_screen.dart`: add 2 more CTA buttons "Luật bóng đá" → `/rules` and "Từ vựng" → `/vocabulary`. Layout the 3 CTAs cleanly (matches, rules, vocabulary) — use ListTile or buttons in a Column ← (verify: all 3 routes resolve, deep link to /rules/offside_newbie works, home shows 3 CTAs)

## 10. Tests for Sprint 4 features

- [x] 10.1 Create `app/test/features/rule_cards/rule_card_repository_test.dart`:
  - Test "loads 21 cards from JSON"
  - Test "getByTopic('offside') returns 3 cards"
  - Test "getByTopicAndLevel('offside', 'newbie') returns 1 card"
  - Test "getById hit returns the card"
  - Test "getById miss returns null"
- [x] 10.2 Create `app/test/features/vocabulary/vocabulary_repository_test.dart`:
  - Test "loads 17 items from JSON"
  - Test "search VN exact: 'Việt vị' returns the offside term"
  - Test "search VN diacritic-insensitive: 'viet vi' returns the offside term"
  - Test "search EN: 'offside' returns the offside term"
  - Test "search empty returns all 17"
  - Test "search nonsense returns empty list"
- [x] 10.3 Create `app/test/features/vocabulary/vocabulary_search_controller_test.dart`:
  - Test "initial state has all 17 items as results"
  - Test "setQuery('') applies immediately"
  - Test "setQuery('viet') debounced 200ms before update" (use `fakeAsync` or `await Future.delayed`)
  - Test "rapid queries within 200ms result in single re-filter"
- [x] 10.4 Create `app/test/features/rule_cards/rule_cards_screen_test.dart`:
  - Widget test mounting RuleCardsScreen with ProviderScope overriding repository to a fake returning known cards
  - Verify 7 topic section headers render
  - Verify default Newbie chip is selected
  - Verify switching to Casual changes visible cards
- [x] 10.5 Create `app/test/features/rule_cards/rule_card_detail_screen_test.dart`:
  - Widget test pumping detail screen with a known card
  - Verify VN title and body shown by default
  - Tap EN toggle, verify EN title and body now shown
  - Verify tags rendered as chips
- [x] 10.6 Create `app/test/features/vocabulary/vocabulary_screen_test.dart`:
  - Widget test mounting VocabularyScreen with mock repository
  - Verify 17 items render (or fewer if mocked)
  - Type in search bar, verify list filters
  - Tap row, verify expansion shows VN+EN definition+example
- [x] 10.7 Create `app/test/features/vocabulary/widgets/vocabulary_tile_test.dart`:
  - Verify collapsed shows VN+EN
  - Tap expands
  - Tap again collapses
- [x] 10.8 Run `cd app && /Users/cuongtran/flutter/bin/flutter test` — verify all tests pass (86 prior + Group 1 additions + Group 10 additions, ~110 expected) ← (verify: full suite green, no Sprint 1-3 regressions, all new widget + unit tests pass)

## 11. Final verification

- [x] 11.1 `cd app && /Users/cuongtran/flutter/bin/flutter pub get` exits 0
- [x] 11.2 `cd app && dart run build_runner build --delete-conflicting-outputs` exits 0 (no new code-gen but confirm clean)
- [x] 11.3 `cd app && /Users/cuongtran/flutter/bin/flutter analyze` reports "No issues found"
- [x] 11.4 `cd app && /Users/cuongtran/flutter/bin/flutter test` all tests pass
- [ ] 11.5 Spot-check: open `/rules` in app — verify 7 topic sections, default Newbie filter; open `/vocabulary` — verify 17 items, search "viet vi" filters to "Việt vị" only ← (verify: all 4 checks pass; no regressions; deep link to /rules/penalty_newbie works; vocabulary search diacritic-insensitive works)
