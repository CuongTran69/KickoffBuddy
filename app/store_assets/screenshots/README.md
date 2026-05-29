# Screenshots Guide

This directory holds store screenshots. Screenshots must be captured manually from a running simulator or device — they cannot be generated automatically.

---

## Required Dimensions

### App Store (iOS)

| Device | Resolution | Status |
|---|---|---|
| 6.7" iPhone (iPhone 15 Pro Max) | 1290 × 2796 px | **Required** |
| 12.9" iPad Pro | 2048 × 2732 px | Optional but recommended |

### Google Play (Android)

| Device | Resolution | Status |
|---|---|---|
| Phone (16:9 or 9:16) | 1080 × 1920 px or larger | **Required** |
| Tablet | Any standard tablet resolution | Optional |

---

## Required Captures (6 screenshots)

Capture these 6 screens in order. Use Vietnamese locale (default) for all captures.

| # | Screen | What to show | Notes |
|---|---|---|---|
| 1 | Match list | World Cup 2026 matches with kickoff times in local timezone | Show "Hôm nay" and "Ngày mai" sections visible |
| 2 | Match detail | A match with reminder set | Show the "Đặt nhắc nhở" button and match info card |
| 3 | Rule card detail | Offside rule at Newbie level | Navigate to Rules → Việt vị → Người mới |
| 4 | Vocabulary search | Search "viet vi" showing "Việt vị" result | Type "viet vi" in search bar, expand the result |
| 5 | Spoiler shield mode | Match detail with spoiler banner active | Requires a match with replay plan set and kickoff in the past |
| 6 | Onboarding welcome | Welcome screen | First launch or clear app data |

---

## How to Capture

### iOS (App Store screenshots)

1. Boot iPhone 15 Pro Max simulator: `xcrun simctl boot "iPhone 15 Pro Max"`
2. Open Simulator app and select the booted device.
3. Run the app: `cd app && /Users/cuongtran/flutter/bin/flutter run`
4. Navigate to each required screen.
5. Capture: `Cmd + S` in Simulator, or `xcrun simctl io booted screenshot screenshot.png`
6. Save to `app/store_assets/screenshots/ios/` with descriptive names.

### Android (Google Play screenshots)

1. Boot Pixel 7 emulator (API 33+) in Android Studio or via `emulator -avd Pixel_7`.
2. Run the app: `cd app && /Users/cuongtran/flutter/bin/flutter run`
3. Navigate to each required screen.
4. Capture: `adb exec-out screencap -p > screenshot.png`
5. Save to `app/store_assets/screenshots/android/` with descriptive names.

---

## Naming Convention

```
ios/
  01-match-list.png
  02-match-detail-reminder.png
  03-rule-card-offside.png
  04-vocabulary-search.png
  05-spoiler-shield.png
  06-onboarding-welcome.png

android/
  01-match-list.png
  02-match-detail-reminder.png
  03-rule-card-offside.png
  04-vocabulary-search.png
  05-spoiler-shield.png
  06-onboarding-welcome.png
```

---

## Notes

- Do **not** include any FIFA, World Cup, or other trademarked logos in screenshots.
- Use real team names (e.g., "Brazil", "Argentina") — team logos are not shown in the app.
- Screenshots should use the Vietnamese locale (default app language).
- Dark mode screenshots are preferred for visual appeal.
