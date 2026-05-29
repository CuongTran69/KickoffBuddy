# app-distribution Specification

## Purpose
TBD - created by archiving change polish-and-store-submission-sprint5. Update Purpose after archive.
## Requirements
### Requirement: Provide app icon for iOS and Android

The system SHALL configure `flutter_launcher_icons` to generate platform-specific app icons from a 1024×1024 source PNG. The placeholder source icon SHALL use the design system's emerald primary `#10B981` as background with a white "K" letter glyph centered.

#### Scenario: Icon source exists

- **WHEN** the build pipeline runs `dart run flutter_launcher_icons`
- **THEN** the source file `app/store_assets/icon/source-1024.png` is read
- **AND** iOS icon variants are written to `app/ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- **AND** Android icon variants are written to `app/android/app/src/main/res/mipmap-*/`

#### Scenario: pubspec configures launcher icons

- **WHEN** `pubspec.yaml` is inspected
- **THEN** a `flutter_launcher_icons:` configuration block exists with `image_path: "store_assets/icon/source-1024.png"`, `android: true`, `ios: true`, adaptive icon background and foreground configured

### Requirement: Provide splash screen for iOS and Android

The system SHALL configure `flutter_native_splash` with dark mode background `#0F172A` and light mode background `#FFFFFF`. The centered logo SHALL be a smaller version of the app icon.

#### Scenario: Splash configured in pubspec

- **WHEN** `pubspec.yaml` is inspected
- **THEN** a `flutter_native_splash:` configuration block exists with `color: "#FFFFFF"`, `color_dark: "#0F172A"`, `image:` pointing to a logo asset

#### Scenario: Splash assets generated

- **WHEN** `dart run flutter_native_splash:create` runs
- **THEN** native splash assets are produced under iOS and Android directories

### Requirement: Provide store listing copy in EN and VI

The system SHALL include `app/store_assets/store_listing/listing-en.md` and `listing-vi.md` containing the App Store / Play Store description copy, with subtitle, short description, full description, keywords, and any required disclaimers per `docs/compliance/03-store-listing.md`.

#### Scenario: Listing files exist with required sections

- **WHEN** the listing files are inspected
- **THEN** each contains sections: App Name, Subtitle (max 30 chars), Short Description (max 80 chars), Full Description, Keywords, Promotional Text, Disclaimers

### Requirement: Document required screenshot specifications

The system SHALL include `app/store_assets/screenshots/README.md` documenting required device sizes, screenshot count per platform, and the specific screens to capture (match list with kickoff times, match detail with reminder, rule card detail, vocabulary search, spoiler shield mode, onboarding welcome).

#### Scenario: Screenshot README is complete

- **WHEN** the README is inspected
- **THEN** it lists App Store (6.7" iPhone, 12.9" iPad) and Play Store (Pixel 7 phone, tablet) device specs
- **AND** lists exactly 6 screen captures with their target screens
- **AND** notes that capture must be done from a running simulator (manual step)

### Requirement: Provide privacy policy in EN and VI

The system SHALL include `docs/legal/privacy-policy.md` (English) and `docs/legal/privacy-policy-vi.md` (Vietnamese) covering: data collected (analytics events, no PII), data retention, third parties (Firebase Analytics), user rights, contact information.

#### Scenario: Privacy policy files exist with required sections

- **WHEN** either file is inspected
- **THEN** sections present: Introduction, What We Collect, How We Use It, Third Parties, User Rights, Contact, Last Updated

### Requirement: Document Vietnam age rating questionnaire answers

The system SHALL include `docs/compliance/04-vn-age-rating.md` documenting the answers to the Vietnam Ministry of Information and Communications age rating questionnaire. Expected rating: ages 3+. Documented answers SHALL state: no violence, no gambling, no in-app purchases, no user-generated content visible to others, no chat, no location tracking.

#### Scenario: Questionnaire answers documented

- **WHEN** the file is inspected
- **THEN** it lists each questionnaire category with the chosen answer and brief justification
- **AND** notes the submission deadline 2026-06-18 and recommended submission date 2026-06-08

### Requirement: Provide manual submission steps document

The system SHALL include `docs/sprint5-manual-steps.md` consolidating all human-only steps required before App Store / Play Store submission. The document SHALL cover Firebase Console project creation, native config file installation, screenshot capture from simulator, screen-reader manual testing on physical device, and Vietnam age rating questionnaire submission.

#### Scenario: Manual steps document is complete

- **WHEN** the file is inspected
- **THEN** each manual step is described with explicit commands, URLs, and expected outcomes
- **AND** the document is ordered by criticality (deadline-driven items first)

