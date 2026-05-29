# Sprint 5 Manual Steps

This document lists all manual steps required to complete the Sprint 5 store submission. Steps are ordered by criticality — deadline-driven items first.

---

## Section A: Vietnam Age Rating Submission (DEADLINE: 2026-06-18)

**Recommended submission date: 2026-06-08** (3-day buffer before deadline)

Full questionnaire answers and justification: see `docs/compliance/04-vn-age-rating.md`

**Steps:**

1. Prepare required documents:
   - App description (use `app/store_assets/store_listing/listing-vi.md`)
   - Screenshots (see Section C)
   - Privacy policy URL (see Section D)
   - App package name: `com.kickoffbuddy.app`

2. Visit the Ministry of Information and Communications portal:
   - URL: [https://www.mic.gov.vn/](https://www.mic.gov.vn/) *(confirm the exact submission URL)*

3. Complete the age rating questionnaire using answers from `docs/compliance/04-vn-age-rating.md`.

4. Submit and save the confirmation receipt.

5. If the portal requires a Vietnamese business registration, consult a local legal advisor.

---

## Section B: Firebase Console Setup

Firebase is required for analytics. The app boots gracefully without it, but analytics will be silent until configured.

**Steps:**

1. Go to [https://console.firebase.google.com/](https://console.firebase.google.com/) and create a new project named "kickoff-buddy".

2. Add an **Android app**:
   - Package name: `com.kickoffbuddy.app`
   - Download `google-services.json`
   - Place it at: `app/android/app/google-services.json`

3. Add an **iOS app**:
   - Bundle ID: `com.kickoffbuddy.app`
   - Download `GoogleService-Info.plist`
   - Place it at: `app/ios/Runner/GoogleService-Info.plist`

4. Enable **Firebase Analytics** in the Firebase console (it is enabled by default for new projects).

5. Run `cd app && /Users/cuongtran/flutter/bin/flutter pub get` to ensure dependencies are resolved.

6. Build and run the app. Verify in the Firebase console (DebugView) that events are being received.

> **Security note**: Do NOT commit `google-services.json` or `GoogleService-Info.plist` to version control. Add them to `.gitignore`.

---

## Section C: Screenshot Capture

See `app/store_assets/screenshots/README.md` for full instructions and required dimensions.

**Quick steps:**

1. Boot iPhone 15 Pro Max simulator (for App Store):
   ```
   xcrun simctl boot "iPhone 15 Pro Max"
   ```

2. Boot Pixel 7 emulator (for Google Play):
   - Use Android Studio AVD Manager or `emulator -avd Pixel_7`

3. Run the app:
   ```
   cd app && /Users/cuongtran/flutter/bin/flutter run
   ```

4. Navigate to each of the 6 required screens and capture.

5. Save screenshots to:
   - `app/store_assets/screenshots/ios/`
   - `app/store_assets/screenshots/android/`

---

## Section D: Privacy Policy Hosting

The privacy policy must be publicly accessible via a URL before submitting to either store.

**Recommended approach: GitHub Pages**

1. Enable GitHub Pages on your repository (Settings → Pages → Source: main branch, `/docs` folder or root).

2. The privacy policy will be available at:
   - English: `https://<your-username>.github.io/<repo-name>/legal/privacy-policy`
   - Vietnamese: `https://<your-username>.github.io/<repo-name>/legal/privacy-policy-vi`

3. Alternatively, host on any static hosting service (Netlify, Vercel, etc.).

4. Update the contact email placeholder in both privacy policy files before publishing:
   - `docs/legal/privacy-policy.md`
   - `docs/legal/privacy-policy-vi.md`

---

## Section E: Production Icon

The current icon (`app/store_assets/icon/source-1024.png`) is a placeholder with an emerald background and white "K". For production, commission a proper icon design.

**Steps to replace:**

1. Create or commission a 1024×1024 PNG icon.
2. Replace `app/store_assets/icon/source-1024.png` with the new file.
3. Regenerate launcher icons:
   ```
   cd app && dart run flutter_launcher_icons
   ```
4. Regenerate splash screen:
   ```
   cd app && dart run flutter_native_splash:create
   ```
5. Rebuild the app and verify the new icon appears.

**Tools for DIY icon creation:**
- Figma (free tier available): [https://figma.com](https://figma.com)
- Canva: [https://canva.com](https://canva.com)
- App Icon Generator: [https://appicon.co](https://appicon.co)

---

## Section F: Screen-Reader Manual Testing

Test with assistive technologies before submission.

### Android — TalkBack

1. Enable TalkBack: Settings → Accessibility → TalkBack → On.
2. Test the following flows:
   - **Onboarding**: Navigate through all 4 steps. Verify language buttons announce "Change language" (or equivalent).
   - **Match list**: Verify match cards are announced with team names and kickoff time.
   - **Match detail**: Verify all buttons (Add to my matches, Set reminder, Plan replay) are announced.
   - **Rule card detail**: Verify the EN/VN toggle switch is announced as "Toggle English / Vietnamese".
3. Disable TalkBack after testing.

### iOS — VoiceOver

1. Enable VoiceOver: Settings → Accessibility → VoiceOver → On.
2. Test the same flows as TalkBack above.
3. Verify swipe navigation works correctly through all interactive elements.
4. Disable VoiceOver after testing.

---

## Section G: App Store Connect Submission

1. Go to [https://appstoreconnect.apple.com/](https://appstoreconnect.apple.com/).
2. Create a new app with bundle ID `com.kickoffbuddy.app`.
3. Upload screenshots from `app/store_assets/screenshots/ios/`.
4. Paste store listing copy from `app/store_assets/store_listing/listing-en.md`.
5. Enter the privacy policy URL (from Section D).
6. Set age rating to 4+ (App Store minimum; our content qualifies for 4+).
7. Build and upload via Xcode or `flutter build ipa`.
8. Submit for review.

---

## Section H: Google Play Console Submission

1. Go to [https://play.google.com/console/](https://play.google.com/console/).
2. Create a new app with package name `com.kickoffbuddy.app`.
3. Upload screenshots from `app/store_assets/screenshots/android/`.
4. Paste store listing copy from `app/store_assets/store_listing/listing-vi.md` (Vietnamese) and `listing-en.md` (English).
5. Enter the privacy policy URL (from Section D).
6. Complete the content rating questionnaire (answers in `docs/compliance/04-vn-age-rating.md`).
7. Build and upload: `cd app && /Users/cuongtran/flutter/bin/flutter build appbundle`
8. Upload the `.aab` file to the Play Console.
9. Submit for review.
