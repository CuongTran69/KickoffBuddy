## 1. Localization setup

- [x] 1.1 Create `app/l10n.yaml` with `arb-dir: lib/l10n`, `template-arb-file: app_en.arb`, `output-localization-file: app_localizations.dart`, `output-class: AppLocalizations`, `nullable-getter: false`
- [x] 1.2 Add `generate: true` flag and explicit `flutter_localizations` SDK dependency in `app/pubspec.yaml` (already present from Sprint 1; verify)
- [x] 1.3 Create `app/lib/l10n/app_en.arb` template file with all required keys (see Group 2 for inventory) and metadata blocks (`@key` with `description`)
- [x] 1.4 Create `app/lib/l10n/app_vi.arb` with Vietnamese translations of every key
- [x] 1.5 Run `cd app && /Users/cuongtran/flutter/bin/flutter pub get` — `gen-l10n` runs as a side effect, generates `app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_vi.dart`
- [x] 1.6 Update `app/lib/app.dart`: add `localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate]`, `supportedLocales: const [Locale('vi'), Locale('en')]` ← (verify: build clean, MaterialApp configured)

## 2. Migrate user-facing strings to ARB

- [x] 2.1 **Onboarding** (`app/lib/features/onboarding/presentation/`): extract welcome step, timezone step, language step, ready step strings; keys like `onboarding_welcome_title`, `onboarding_timezone_useThis`, `onboarding_ready_letsGo`
- [x] 2.2 **Home screen** (`app/lib/features/home/presentation/home_screen.dart`): app name, 3 CTA labels (matches, rules, vocabulary)
- [x] 2.3 **Match list + detail** (`app/lib/features/matches/presentation/`): screen titles, filter chip labels, date section headers (Today/Tomorrow/...), add-match CTAs, "Match started" disabled label, related to spoiler banner
- [x] 2.4 **Manual add + Magic add** screens: form labels, validation messages, save snackbar
- [x] 2.5 **Reminder sheet + replay planner dialog**: "Set reminder", "Plan replay", "Cancel replay plan", chip labels (1d/3h/30m/5m), snackbars ("Đã lưu nhắc nhở"), explanatory dialog text, "Open Settings"
- [x] 2.6 **Spoiler banner + badge**: "Spoiler-protected until X", "Protected"
- [x] 2.7 **Rule cards**: screen title, level filter chips, topic labels (offside/penalty/var/cards/stoppage_time/extra_time/shootout in VN+EN), detail screen sections
- [x] 2.8 **Vocabulary**: screen title, search hint, empty state message, expanded sections (definition, example, related)
- [x] 2.9 Run `cd app && /Users/cuongtran/flutter/bin/flutter analyze` — fix any unused-import warnings from removed hardcoded constants
- [x] 2.10 Run `cd app && /Users/cuongtran/flutter/bin/flutter test` — update tests that asserted hardcoded VN strings to wrap widgets with `MaterialApp(localizationsDelegates: AppLocalizations.localizationsDelegates, supportedLocales: ...)` and use `AppLocalizations.of(context)!` or `find.text(...)` against known translations ← (verify: all 131 tests pass after migration; if any are skipped, justify in test comment)

## 3. Firebase Analytics scaffolding

- [x] 3.1 Add to `app/pubspec.yaml` dependencies: `firebase_core: ^3.6.0`, `firebase_analytics: ^11.3.3`. Run `flutter pub get`
- [x] 3.2 Create `app/lib/core/analytics/analytics_events.dart`:
  - Class `AnalyticsEvents` with 8 static const String fields: `onboardingCompleted`, `matchViewed`, `matchAddedToMyMatches`, `reminderSet`, `replayPlannerSet`, `ruleCardViewed`, `vocabularySearched`, `languageChanged`
  - Static const Map<String, Set<String>> `_allowedParams` mapping each event to allowed param keys (e.g., `matchViewed → {match_id, source}`, `vocabularySearched → {query_length, has_results}`, etc.)
- [x] 3.3 Create `app/lib/core/analytics/analytics_service.dart`:
  - Class `AnalyticsService` with optional `FirebaseAnalytics?` field (nullable so missing config doesn't crash)
  - Constructor accepts optional `FirebaseAnalytics? analytics`; `_isAvailable` field tracks whether analytics is wired
  - Method `Future<void> logEvent(String name, [Map<String, Object?>? params])`:
    - If `_isAvailable == false` → return immediately
    - Filter params via `AnalyticsEvents._allowedParams[name]` allowlist (strip disallowed keys)
    - Call `_analytics?.logEvent(name: name, parameters: filtered)`
- [x] 3.4 Create `app/lib/core/analytics/analytics_provider.dart`:
  - `final analyticsServiceProvider = Provider<AnalyticsService>((ref) { try { return AnalyticsService(FirebaseAnalytics.instance); } catch (_) { return AnalyticsService(null); } });`
- [x] 3.5 Update `app/lib/main.dart`: import `firebase_core`; wrap `Firebase.initializeApp()` in try/catch; if catch fires, log warning (debug only) and continue ← (verify: app boots even when google-services.json/GoogleService-Info.plist absent)

## 4. Wire analytics firing points

- [x] 4.1 **onboarding_completed**: in `onboarding_controller.dart` `complete()` method (after persisting prefs), invoke `ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.onboardingCompleted)`
- [x] 4.2 **match_viewed**: in `match_detail_screen.dart` `initState` (or after first build), log with `{'match_id': match.id, 'source': match.isSeeded ? 'seed' : (match.sourceText != null ? 'magic_add' : 'manual')}`
- [x] 4.3 **match_added_to_my_matches**: in user_matches_provider when `add()` called, log with `{'match_id': matchId}`
- [x] 4.4 **reminder_set**: in `reminder_controller.dart` `save()` after persistence, log with `{'count_total': offsets.length, 'offsets_csv': offsets.join(',')}`
- [x] 4.5 **replay_planner_set**: in `replay_planner_controller.dart` `savePlan()` after persistence, log with `{'match_id': match.id}`
- [x] 4.6 **rule_card_viewed**: in `rule_card_detail_screen.dart` first build with non-null card, log with `{'topic': card.topic, 'level': card.level}`
- [x] 4.7 **vocabulary_searched**: in `vocabulary_search_controller.dart` after debounce filter applied (only when query non-empty), log with `{'query_length': query.length, 'has_results': results.isNotEmpty}`
- [x] 4.8 **language_changed**: in onboarding language step on selection (or future settings if exists), log with `{'locale': 'vi' | 'en'}` ← (verify: each event fires at exactly the documented moment, payload contains only allowlisted keys)

## 5. Analytics tests

- [x] 5.1 Create `app/test/core/analytics/analytics_service_test.dart`:
  - Test "service no-ops when analytics unavailable" — construct with `null`, call `logEvent`, assert no throw
  - Test "logEvent with allowlisted params passes through" — use a fake FirebaseAnalytics-like recorder, assert recorded params
  - Test "logEvent strips disallowed params" — pass `{match_id: 'm1', team_a: 'USA'}` to `matchViewed`, assert recorded params are `{match_id: 'm1'}` only
  - Test "all 8 event names are defined" — iterate const keys
- [x] 5.2 Run `cd app && /Users/cuongtran/flutter/bin/flutter test` — all pass ← (verify: PII leak prevention proven by sanitization tests)

## 6. App icon

- [x] 6.1 Generate placeholder icon at `app/store_assets/icon/source-1024.png` (1024×1024 PNG, emerald `#10B981` background, white "K" letter centered, ~600px font size, system sans-serif). Approach: Python+Pillow if available; fallback to ImageMagick `convert`; if neither tool present, create the directory + a `README.md` placeholder describing how to generate manually (Figma, Canva)
- [x] 6.2 Add to `app/pubspec.yaml` dev_dependencies: `flutter_launcher_icons: ^0.14.1`
- [x] 6.3 Add `flutter_launcher_icons:` config block to `pubspec.yaml`: `image_path: "store_assets/icon/source-1024.png"`, `android: true`, `ios: true`, `min_sdk_android: 23`, adaptive icon foreground = source, background_color: `"#10B981"`
- [x] 6.4 Run `cd app && dart run flutter_launcher_icons` — generates iOS Assets.xcassets and Android mipmap variants ← (verify: icon assets generated at expected paths, build still clean)

## 7. Splash screen

- [x] 7.1 Add to `app/pubspec.yaml` dev_dependencies: `flutter_native_splash: ^2.4.2`
- [x] 7.2 Add `flutter_native_splash:` config block: `color: "#FFFFFF"`, `color_dark: "#0F172A"`, `image: "store_assets/icon/source-1024.png"` (use icon as splash logo for now; production may swap), `android: true`, `ios: true`
- [x] 7.3 Run `cd app && dart run flutter_native_splash:create` — generates splash assets under iOS + Android directories ← (verify: splash assets generated, no breakage)

## 8. Privacy policy

- [x] 8.1 Create `docs/legal/privacy-policy.md` (English) with sections: Introduction, What Data We Collect (analytics events, no PII), How We Use It, Third Parties (Firebase Analytics), User Rights (under GDPR/CCPA terminology), Contact, Last Updated 2026-05-29
- [x] 8.2 Create `docs/legal/privacy-policy-vi.md` (Vietnamese) with same sections, professionally translated, using Vietnamese legal/professional language (e.g., "Chính sách quyền riêng tư", "Dữ liệu chúng tôi thu thập") ← (verify: both files exist, all required sections present, last-updated date matches today)

## 9. Vietnam age rating questionnaire

- [x] 9.1 Create `docs/compliance/04-vn-age-rating.md` with:
  - Header: target rating 3+ (ages 3 and up)
  - Submission deadline: 2026-06-18
  - Recommended submission date: 2026-06-08 (3-day store-review buffer)
  - Submission portal URL placeholder
  - Section "Questionnaire answers": list each Vietnam Ministry of Information and Communications questionnaire category with answer + brief justification
    - Violence: None (football is non-violent sport)
    - Gambling: None
    - In-app purchases: None (MVP free)
    - User-generated content visible to others: None
    - Chat or messaging: None
    - Location tracking: None
    - Sexual content: None
    - Drug/alcohol/tobacco references: None
    - Profanity: None
    - Horror: None
  - Section "Justification for 3+ rating": brief paragraph
  - Section "Submission steps": link to `docs/sprint5-manual-steps.md` ← (verify: file complete, deadline highlighted, all questionnaire categories answered)

## 10. Store listing copy

- [x] 10.1 Create `app/store_assets/store_listing/listing-en.md` with sections: App Name, Subtitle (max 30 chars), Short Description (max 80 chars), Full Description, Keywords, Promotional Text, Disclaimer ("Not affiliated with FIFA. World Cup is a registered trademark...")
- [x] 10.2 Create `app/store_assets/store_listing/listing-vi.md` with same structure, in Vietnamese
- [x] 10.3 Use copy from `docs/compliance/03-store-listing.md` if already drafted; otherwise compose:
  - Name: "Kickoff Buddy"
  - Subtitle: "Football kickoff in your time"
  - Short: "Plan, protect, understand the World Cup"
  - Disclaimer must be visible on both files ← (verify: both files exist, character limits respected, disclaimer present)

## 11. Screenshots README

- [x] 11.1 Create `app/store_assets/screenshots/README.md` documenting:
  - App Store: 6.7" iPhone (1290×2796) — required; 12.9" iPad Pro (2048×2732) — optional but recommended
  - Play Store: phone (any 16:9 or 9:16, e.g., 1080×1920+); tablet (optional)
  - Required 6 captures: (1) match list with kickoff times, (2) match detail with reminder, (3) rule card detail (offside_newbie), (4) vocabulary search showing "viet vi" → "Việt vị", (5) spoiler shield mode, (6) onboarding welcome
  - Note: capture must be done from a running simulator/device — manual step ← (verify: README is complete, lists all required captures)

## 12. Sprint 5 manual steps document

- [x] 12.1 Create `docs/sprint5-manual-steps.md` with sections (ordered by criticality):
  - **Section A: Vietnam age rating submission (DEADLINE 2026-06-18)** — link to questionnaire portal, reference `docs/compliance/04-vn-age-rating.md`
  - **Section B: Firebase Console setup** — create project, add iOS+Android apps, download `google-services.json` to `app/android/app/`, download `GoogleService-Info.plist` to `app/ios/Runner/`, document the package name `com.kickoffbuddy.app`
  - **Section C: Screenshot capture** — boot simulator (iPhone 15 Pro for App Store, Pixel 7 for Play Store), seed each required screen, capture with screenshot tool, save to `app/store_assets/screenshots/`
  - **Section D: Privacy policy hosting** — recommend GitHub Pages; provide URL pattern
  - **Section E: Production icon** — note placeholder; commission designer or use Canva/Figma to produce final icon; replace `app/store_assets/icon/source-1024.png` and re-run `dart run flutter_launcher_icons`
  - **Section F: Screen-reader manual testing** — TalkBack steps (Android), VoiceOver steps (iOS) for onboarding, match list, match detail
  - **Section G: App Store Connect submission** — link to portal, upload screenshots, paste store listing copy, paste privacy URL
  - **Section H: Google Play Console submission** — link to portal, same flow ← (verify: file complete, deadline-driven sections at top, all manual steps with explicit URLs and commands)

## 13. Accessibility polish

- [x] 13.1 Wrap icon-only buttons across the app with `Semantics` widgets:
  - Language toggle in onboarding language step → `semanticsLabel: AppLocalizations.of(context)!.a11y_changeLanguage` (or hardcoded "Change language")
  - EN/VN switch on rule card detail → `semanticsLabel: 'Toggle English / Vietnamese'`
  - Close buttons on dialogs/sheets → `semanticsLabel: 'Close'`
- [x] 13.2 Verify 48dp touch targets: spot-check filter chips, action buttons, list tiles — Material 3 widgets default to 48dp so this should be passive verification ← (verify: no obvious icon-only buttons missing semantics; widgets used are M3 defaults)

## 14. Final verification

- [x] 14.1 `cd app && /Users/cuongtran/flutter/bin/flutter pub get` exits 0
- [x] 14.2 `cd app && dart run build_runner build --delete-conflicting-outputs` exits 0
- [x] 14.3 `cd app && /Users/cuongtran/flutter/bin/flutter analyze` reports "No issues found"
- [x] 14.4 `cd app && /Users/cuongtran/flutter/bin/flutter test` all tests pass (131 prior + analytics tests; ~135-140 expected)
- [x] 14.5 Spot-check: open `lib/l10n/app_localizations.dart` (generated) — verify class compiled. Open `core/analytics/analytics_service.dart` — verify allowlist enforcement code present. Open `app/store_assets/icon/source-1024.png` — verify exists. Open `docs/sprint5-manual-steps.md` — verify deadline section at top ← (verify: ALL 4 build checks pass; manual steps document complete; analytics tests prove PII sanitization; all generated artifacts present)
