## ADDED Requirements

### Requirement: Initialize Firebase before app run

The system SHALL initialize Firebase via `Firebase.initializeApp()` during app boot, before `runApp` is called.

#### Scenario: Firebase ready before UI renders

- **WHEN** the app starts
- **THEN** `WidgetsFlutterBinding.ensureInitialized()`, `TimezoneService.initialize()`, `NotificationService.initialize()`, `SharedPreferences.getInstance()`, and `Firebase.initializeApp()` all complete before `runApp(...)` is invoked

#### Scenario: Firebase native config missing handled gracefully

- **WHEN** Firebase initialization throws because `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is missing
- **THEN** the app continues to run with analytics disabled
- **AND** an internal flag indicates analytics is unavailable
- **AND** subsequent `analyticsService.logEvent` calls are no-ops

### Requirement: Provide AnalyticsService Riverpod provider

The system SHALL expose `analyticsServiceProvider` as a Riverpod `Provider<AnalyticsService>`. The service SHALL offer a `logEvent(String name, [Map<String, Object?>? params])` method.

#### Scenario: Provider returns service instance

- **WHEN** any consumer reads `ref.read(analyticsServiceProvider)`
- **THEN** the returned object is an `AnalyticsService` instance with a working `logEvent` method

### Requirement: Define event taxonomy as constants

The system SHALL declare event names as static constants in `AnalyticsEvents`. Required events:

- `onboardingCompleted` = `"onboarding_completed"`
- `matchViewed` = `"match_viewed"`
- `matchAddedToMyMatches` = `"match_added_to_my_matches"`
- `reminderSet` = `"reminder_set"`
- `replayPlannerSet` = `"replay_planner_set"`
- `ruleCardViewed` = `"rule_card_viewed"`
- `vocabularySearched` = `"vocabulary_searched"`
- `languageChanged` = `"language_changed"`

#### Scenario: All required event names present

- **WHEN** code references `AnalyticsEvents.<eventName>`
- **THEN** each of the 8 names above resolves to its underscored snake_case string

### Requirement: Sanitize analytics payloads — no PII, no match names, no query text

The system SHALL strip personally identifiable information from analytics payloads. The following SHALL NEVER appear in event params, even if a caller mistakenly attempts to log them:

- Match names (use match_id only)
- Search query text (use query_length and has_results booleans only)
- User IDs, device IDs, IP addresses
- Email addresses, phone numbers, names
- Free-text user input (notes, manually added match names)

#### Scenario: match_viewed sanitized

- **WHEN** `analyticsService.logEvent(AnalyticsEvents.matchViewed, {'match_id': 'm1', 'source': 'seed', 'team_a': 'USA'})` is called
- **THEN** the event is logged with `{'match_id': 'm1', 'source': 'seed'}` — `team_a` is stripped

#### Scenario: vocabulary_searched sanitized

- **WHEN** `analyticsService.logEvent(AnalyticsEvents.vocabularySearched, {'query_length': 5, 'has_results': true, 'query': 'viet vi'})` is called
- **THEN** the event is logged with `{'query_length': 5, 'has_results': true}` — `query` is stripped

#### Scenario: Allowed param keys are passed through

- **WHEN** an event is logged with only allowed-list params
- **THEN** all params reach Firebase Analytics unchanged

### Requirement: Wire analytics firing across feature screens

The system SHALL invoke `AnalyticsService.logEvent` at these moments:

- After onboarding's "Get Started" tap → `onboardingCompleted`.
- When a match detail screen first renders → `matchViewed` with `{match_id, source}`.
- When user toggles "Add to my matches" on → `matchAddedToMyMatches` with `{match_id}`.
- When user saves reminder offsets → `reminderSet` with `{count_total, offsets_csv}` (offsets joined as comma-separated minutes string).
- When user saves a replay plan → `replayPlannerSet` with `{match_id}`.
- When a rule card detail screen first renders → `ruleCardViewed` with `{topic, level}`.
- When user submits a vocabulary search query (after debounce) → `vocabularySearched` with `{query_length, has_results}`.
- When user changes language in onboarding language step or future settings → `languageChanged` with `{locale}`.

#### Scenario: Onboarding completion fires

- **WHEN** the user taps "Get Started" on the onboarding ready step
- **THEN** `analyticsService.logEvent(AnalyticsEvents.onboardingCompleted)` is invoked

#### Scenario: Match view fires once per visit

- **WHEN** the user navigates to `/matches/match_001`
- **THEN** exactly one `matchViewed` event is logged with `match_id = "match_001"`
- **AND** if the user navigates away and back, a new `matchViewed` event is logged for the second visit
