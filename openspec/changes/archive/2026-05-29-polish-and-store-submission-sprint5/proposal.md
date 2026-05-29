## Why

Sprints 1-4 delivered the full feature set: Flutter scaffold with onboarding, 104-match WC 2026 catalog with timezone-aware browsing, manual + Magic Add, local reminders, replay planner with spoiler shield, rule cards, and vocabulary. The app is feature-complete for MVP.

Sprint 5 makes it shippable. Three concerns dominate: (1) the app is currently single-language (Vietnamese hardcoded throughout) — needs ARB-based i18n with English fallback for App Store/Play Store global review. (2) there is zero analytics — needs Firebase Analytics scaffolding so the launch generates retention/funnel data. (3) the binary lacks an app icon and splash screen, has no store listing assets, no privacy policy, and Vietnam's age rating regulatory deadline (2026-06-18) is approaching fast — WC 2026 kicks off 2026-06-11, leaving roughly 12 days from today to submit and get reviewed.

This sprint is the final sprint before launch. After it, the app should be submittable to App Store Connect and Google Play Console.

## What Changes

### App localization (new capability)
- Add `flutter_localizations` SDK dependency (already present from Sprint 1) + generate-from-ARB pipeline.
- Create `app/l10n.yaml` config and `app/lib/l10n/app_en.arb` + `app/lib/l10n/app_vi.arb` source files.
- Migrate user-facing primary copy across screens (match list/detail, manual add, magic add, reminder sheet, replay planner, rule cards, vocabulary, onboarding) from hardcoded Vietnamese strings to ARB keys consumed via `AppLocalizations.of(context)!`.
- Default locale Vietnamese; English fallback.
- Test labels, log strings, IDs, and developer-facing comments stay hardcoded.

### Privacy-respecting analytics (new capability)
- Add `firebase_core: ^3.6.0` and `firebase_analytics: ^11.3.3` to `pubspec.yaml`.
- Scaffold `app/lib/core/analytics/` with `AnalyticsService`, `AnalyticsEvents` constant table, and `analyticsServiceProvider` Riverpod provider.
- Initialize `Firebase.initializeApp()` in `main.dart` after timezone + before `runApp`.
- Wire firing points across the app for the 8 events in `docs/ops/01-analytics.md`: `onboarding_completed`, `match_viewed`, `match_added_to_my_matches`, `reminder_set`, `replay_planner_set`, `rule_card_viewed`, `vocabulary_searched`, `language_changed`.
- Privacy enforcement: payload sanitization rules (no match names, no search query text, no user IDs) baked into `AnalyticsService` API.
- Native config (google-services.json + GoogleService-Info.plist) deferred to manual setup (documented in `docs/sprint5-manual-steps.md`).

### App distribution scaffolding (new capability)
- Add `flutter_launcher_icons` and `flutter_native_splash` dev dependencies.
- Generate placeholder icon (emerald `#10B981` + white "K" letter, 1024×1024 PNG) at `app/store_assets/icon/source-1024.png`.
- Configure splash screen with dark `#0F172A` / light `#FFFFFF` backgrounds.
- Run icon and splash generation tools (output committed).
- Create `app/store_assets/screenshots/README.md` with screenshot capture instructions and required device specs.
- Create `app/store_assets/store_listing/listing-en.md` and `listing-vi.md` with deploy-ready store description copy.
- Write `docs/legal/privacy-policy.md` (English) and `docs/legal/privacy-policy-vi.md` (Vietnamese).
- Write `docs/compliance/04-vn-age-rating.md` documenting questionnaire answers (rating: 3+; no violence, no gambling, no IAP, no UGC, no chat, no location tracking).
- Create `docs/sprint5-manual-steps.md` consolidating all human-only steps before submission (Firebase Console setup, screenshot capture from simulator, store credentials submission, screen-reader manual testing, VN age rating questionnaire submission).

### Accessibility polish
- Add `Semantics` wrappers to icon-only buttons (language toggle, EN/VN switch, close, dismiss).
- Spot-check 48dp touch target compliance across interactive widgets.

### Tests
- New unit tests: `analytics_service_test.dart` (event names match constants, payloads sanitized).
- Existing 131 tests must still pass after i18n migration (test helpers may need to wrap widgets with `MaterialApp` providing the localizations delegates).

### Out of scope
- Premium/IAP, backend, push notifications, LLM Magic Add, Sleep Plan, Fan Etiquette Guide, Quiz, Partner/Family/Venue Mode (post-MVP).
- Production icon design (placeholder used; artist-designed icon delivered before launch by user).
- Actual App Store Connect / Google Play Console submission (requires user credentials).
- Physical-device screen-reader testing (requires hardware; documented as manual step).

## Capabilities

### New Capabilities
- `app-localization`: ARB-based bilingual UI (VN default, EN fallback) covering all user-facing primary copy.
- `app-analytics`: Privacy-respecting event taxonomy backed by Firebase Analytics. Payload sanitization (no PII, no match names, no query text).
- `app-distribution`: Store-ready assets (icon, splash, screenshots README, listing copy, privacy policy) and compliance documents (Vietnam age rating questionnaire answers).

### Modified Capabilities
- None. Sprint 1-4 specs (match-data-store, match-scheduler, match-reminders, replay-planner, rule-cards, vocabulary) stay as-is. Sprint 5 is additive infrastructure.

## Impact

### Affected code

**New directories:**
- `app/lib/l10n/` — ARB source files.
- `app/lib/core/analytics/` — analytics service, events, provider.
- `app/store_assets/` — icon source, screenshots, store listing copy.
- `docs/legal/` — privacy policy in EN + VI.

**Modified files:**
- `app/pubspec.yaml` — new deps (firebase_core, firebase_analytics, flutter_launcher_icons, flutter_native_splash) + l10n config.
- `app/lib/main.dart` — Firebase initialization, AppLocalizations wiring.
- `app/lib/app.dart` — localizationsDelegates, supportedLocales, default locale `vi`.
- `app/l10n.yaml` (new) — flutter_gen config.
- All feature screen files (matches, rules, vocabulary, onboarding, reminders, replay_planner) — replace hardcoded VN strings with localization key lookups.
- All event firing points across screens — invoke `analyticsService.logEvent(...)`.
- Icon-only buttons across the app — wrap with `Semantics`.

**New test files:**
- `app/test/core/analytics/analytics_service_test.dart`.

**Generated files (committed):**
- `app/lib/l10n/app_localizations.dart` (gen'd by `flutter gen-l10n`).
- `app/lib/l10n/app_localizations_en.dart`, `app_localizations_vi.dart` (gen'd).
- iOS + Android icon variants under `app/ios/Runner/Assets.xcassets/` and `app/android/app/src/main/res/`.
- Splash screen native config under iOS + Android.

### Build pipeline
- New step: `flutter gen-l10n` runs as part of `flutter pub get` (when configured in `pubspec.yaml`).
- New step: `dart run flutter_launcher_icons` (manual, once per icon update).
- New step: `dart run flutter_native_splash:create` (manual, once per splash update).

### External systems
- Firebase Analytics will start collecting events post-launch — requires Firebase Console project (manual user setup; the Dart side gracefully handles initialization failure if config files are missing).

### Compliance
- Vietnam age rating questionnaire submission — manual user action before 2026-06-18.
- App Store / Play Store submission — manual user action with credentials.
