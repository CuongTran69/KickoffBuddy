## Context

Sprints 1-4 delivered the full feature set: scaffold + onboarding (S1), Match Scheduler with 104 WC 2026 matches and Magic Add (S2), Reminders + Replay Planner (S3), Rule Cards + Vocabulary (S4). All 4 capabilities pass tests (131 tests at end of S4) and `flutter analyze` is clean.

Sprint 5 is the final sprint before MVP launch. It is dominated by submission-readiness: the app currently has Vietnamese-only hardcoded strings (no Apple/Play Store global review possible), no analytics (would launch blind), no app icon, no splash, no store listing assets, no privacy policy, and Vietnam's age rating regulatory deadline (2026-06-18) is 20 days away (today is 2026-05-29).

This sprint also lives under a real-world constraint: WC 2026 kicks off 2026-06-11, only 13 days away. App Store review typically takes 24-48 hours, Play Store hours-to-days. Realistic submission window is by 2026-06-08 to leave a 3-day buffer.

### Constraints

- Solo dev, MVP timeline (`docs/product/03-roadmap.md`).
- Vietnamese is the primary user language; English is required only for store review and global users.
- Privacy: Vietnamese users are sensitive to PII collection — analytics must be strictly category/aggregate.
- Some work cannot be automated by tooling: Firebase Console project creation, screenshot capture, store credential submission, physical-device screen-reader testing, VN age rating questionnaire submission.

### Stakeholders

- End users: Vietnamese fans (primary persona) and English-speaking fans (secondary, store reviewers in particular).
- Solo dev: needs clear manual-step documentation since several actions cannot be code-automated.
- Apple App Review and Google Play Review: need privacy policy URL, age rating questionnaire, screenshots, store description.
- Vietnam Ministry of Information and Communications: need age rating questionnaire submission before deadline.

## Goals / Non-Goals

**Goals:**

- ARB-based bilingual UI (VN default, EN fallback) wired through MaterialApp.
- All user-facing primary copy migrated from hardcoded Vietnamese to ARB keys.
- Firebase Analytics scaffolded with privacy-respecting event taxonomy and 8 firing points.
- App icon and splash screen configured and generated.
- Store listing copy ready (EN + VI), privacy policy written (EN + VI), VN age rating answers documented.
- Manual steps consolidated into a single `docs/sprint5-manual-steps.md` document.
- All 131 prior tests still pass; new analytics tests added.
- `flutter analyze` clean.

**Non-Goals:**

- Premium/IAP, backend, push notifications, LLM Magic Add, Sleep Plan, Fan Etiquette Guide, Quiz, Partner/Family/Venue Mode (post-MVP).
- Production icon design (placeholder used; production icon delivered by user before launch).
- Actual App Store Connect / Google Play Console submission (requires user credentials).
- Physical-device screen-reader testing (requires hardware).
- Firebase Console project creation (requires user account).
- Multi-language beyond EN/VI (e.g., Thai, Indonesian, Spanish — Phase 2).
- Privacy policy hosting (user hosts on GitHub Pages or own domain).

## Decisions

### D1: ARB instead of `intl_translation`

**Decision:** Use Flutter's built-in `flutter gen-l10n` from ARB files, not the older `intl_translation` package.

**Rationale:**
- ARB is the modern Flutter standard since Flutter 1.20+.
- No third-party package needed; just a config file and `flutter pub get` regenerates.
- Tooling support in IDEs (VS Code, IntelliJ) for ARB editing.

### D2: Default locale Vietnamese

**Decision:** `supportedLocales: [Locale('vi'), Locale('en')]`. The first entry is the fallback.

**Rationale:**
- Primary persona is Vietnamese.
- Apple/Google reviewers default to English, so EN must be available — but fallback for unsupported locales is VN.

### D3: Migrate user-facing primary copy only

**Decision:** Extract screen titles, button labels, snackbar messages, dialog text, form hints. Leave hardcoded: test labels, log strings, identifiers (e.g., route paths), developer-facing comments.

**Rationale:**
- Pragmatic scope — extracting every string explodes the work.
- Test/dev strings rarely face users.
- Future Phase 2 can extract more if needed (e.g., for Thai, Spanish).

### D4: ARB key naming `screen_section_purpose`

**Decision:** Underscored hierarchy. Examples: `matches_filter_groupStage`, `rules_detail_readTime`, `onboarding_welcome_title`.

**Rationale:**
- Predictable; supports IDE autocomplete by prefix.
- Mirrors folder structure for traceability.
- ARB metadata `description` per key documents intent for future translators.

### D5: Firebase initialization handles missing config gracefully

**Decision:** `Firebase.initializeApp()` is wrapped in try/catch; if it throws (because native config is missing in dev / pre-submission state), the app continues with analytics disabled.

**Rationale:**
- Users running the app pre-submission (manual setup not yet done) should still see the UI.
- Solo dev can develop locally without setting up Firebase Console first.
- Production builds will have config installed; no graceful path needed there.

### D6: Analytics payload allowlist enforced in service

**Decision:** `AnalyticsService.logEvent` filters params via an allowlist defined per event. If a caller passes a disallowed key, it is stripped (not throw — service should never crash production code).

**Rationale:**
- Defense in depth — even if a developer makes a mistake, no PII reaches Firebase.
- Allowlist is explicit and reviewable in `AnalyticsEvents`.

### D7: Event taxonomy follows `docs/ops/01-analytics.md`

**Decision:** 8 events, snake_case names, consistent param naming. Use only the param keys listed in spec.md.

**Rationale:**
- Doc was authored Sprint 1; treats analytics as a stable contract.
- Adding events later is fine; renaming requires migration in dashboards.

### D8: Placeholder icon — emerald + white "K"

**Decision:** Generate a 1024×1024 PNG with `#10B981` background and a white "K" centered. Run through `flutter_launcher_icons` to produce all platform variants.

**Rationale:**
- Pre-launch placeholder; the user can swap in a designer-made icon before final submission.
- Matches the design system primary color.
- "K" for Kickoff Buddy.

**Generation approach (autopilot):** Use a tiny Python+Pillow script (or shell+ImageMagick if available). If neither tooling is available in the environment, document the manual generation step (e.g., Figma export) in `docs/sprint5-manual-steps.md`.

### D9: Splash backgrounds match design system surfaces

**Decision:** Light mode splash `#FFFFFF`, dark mode splash `#0F172A`. Centered logo (smaller version of the icon).

**Rationale:**
- Tokens already locked in `docs/architecture/06-design-system.md`.
- Native splash + theme handoff feels seamless if colors match the first frame of the app's theme.

### D10: All non-automatable steps go to a single doc

**Decision:** `docs/sprint5-manual-steps.md` consolidates: Firebase Console setup, screenshot capture instructions, screen-reader manual testing, Vietnam age rating questionnaire submission, App Store / Play Store credential setup.

**Rationale:**
- Single source of truth — solo dev doesn't have to scan multiple docs.
- Ordered by criticality (deadline-driven items first).

### D11: Privacy policy lives in `docs/legal/`

**Decision:** Two files — `docs/legal/privacy-policy.md` (EN) and `docs/legal/privacy-policy-vi.md` (VI). Both link to a hosted URL the user provides during store submission.

**Rationale:**
- Apple/Google require a publicly accessible URL.
- Source of truth in repo, render via GitHub Pages or similar.

## Risks / Trade-offs

- **[Risk] i18n migration breaks 131 existing tests** → Mitigation: tests that asserted hardcoded VN strings now wrap widgets with `MaterialApp` providing the localizations delegates and assert via `find.text(AppLocalizations.of(...)!)` or via key matchers. If too brittle, mark such tests skipped temporarily and document — but verify report should call out any skip.

- **[Risk] Firebase native config missing in dev causes crash** → Mitigation: D5 (graceful try/catch); analytics no-op if init fails.

- **[Risk] Analytics PII leak from misuse** → Mitigation: D6 (allowlist enforcement in service); unit tests verify disallowed keys stripped.

- **[Risk] VN age rating deadline missed** → Mitigation: D10 manual-steps doc surfaces deadline at the top; user must execute submission before 2026-06-18. Cannot be automated.

- **[Risk] Placeholder icon looks unprofessional in store screenshots** → Mitigation: D8 documents that the user should swap a real icon before submission. Production icon = artist work.

- **[Risk] Screenshot capture from simulator is manual; user might forget device specs** → Mitigation: README in `app/store_assets/screenshots/` lists exact device/sizes/screens.

- **[Risk] Image-generation tooling (Pillow / ImageMagick) might not be available in environment** → Mitigation: D8 fallback to manual generation step in manual-steps doc. Try Pillow first.

- **[Trade-off] Test labels stay hardcoded** → Acceptable: tests are developer-facing; localizing them adds zero user value.

- **[Trade-off] Manual screen-reader testing is post-implementation** → Acceptable: code-side `Semantics` is added; only manual verification on real device is human-only.

## Migration Plan

This sprint is additive on top of Sprint 4. No data migration; only code/config additions and string relocations.

**Deploy sequence:**

1. Add new dependencies to `pubspec.yaml` (firebase_core, firebase_analytics, flutter_launcher_icons, flutter_native_splash). Run `flutter pub get`.
2. Configure `l10n.yaml`. Create `app_en.arb` + `app_vi.arb` with all keys. Run `flutter gen-l10n` (auto-runs as part of `flutter pub get` once configured).
3. Wire `MaterialApp.router` in `app.dart` with delegates and `supportedLocales`.
4. Migrate strings in feature screens (matches, rules, vocabulary, onboarding, reminders, replay_planner) one folder at a time. Run tests between each folder; fix breakage.
5. Build `core/analytics/` (events, service, provider). Wire `Firebase.initializeApp()` in `main.dart`. Wire 8 firing points across screens.
6. Generate placeholder icon. Configure `flutter_launcher_icons`. Run `dart run flutter_launcher_icons`.
7. Configure `flutter_native_splash`. Run `dart run flutter_native_splash:create`.
8. Write privacy policy (EN + VI). Write VN age rating doc. Write store listing copy (EN + VI). Write screenshots README. Write `docs/sprint5-manual-steps.md`.
9. Spot-check accessibility: add `Semantics` wrappers to icon-only buttons.
10. Run full check suite: `flutter pub get`, `flutter analyze`, `flutter test`.

**Rollback:** Sprint 5 is mostly additive (new files in `core/analytics/`, `l10n/`, `store_assets/`, `docs/legal/`, `docs/compliance/`). Modifications to feature screens (string lookups), `pubspec.yaml`, `main.dart`, `app.dart` can be reverted by reverting those specific files. The app reverts to Sprint 4 state (single-language, no analytics, no icon) cleanly.

## Open Questions

None. All architectural decisions are locked. Implementation-time decision (D8 image-generation tooling availability) has explicit fallback criteria.
