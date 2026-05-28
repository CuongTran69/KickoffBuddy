---
id: arch-tech-stack
title: Tech Stack
status: planned
phase: foundational
depends-on: []
related: [arch-folder-structure, arch-time-handling, arch-data-model, arch-backend-strategy]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa tech stack cho Kickoff Buddy Flutter app. Mỗi lựa chọn có lý do rõ ràng. Là tài liệu tham chiếu khi setup project và onboard.

## Phạm vi

### In scope

- Flutter framework và core packages
- State management, navigation, local storage
- Timezone và notification packages
- Widget và native bridge
- Phase 2 additions

### Out of scope

- Backend stack (xem [arch-backend-strategy](05-backend-strategy.md))
- CI/CD pipeline
- Design system / UI components

---

## Core Framework

| Package | Version | Lý do |
|---|---|---|
| Flutter | stable channel | Ổn định, ít breaking change |
| Dart | (theo Flutter stable) | |
| Material 3 | (built-in) | Dark mode support tốt, modern UI |

---

## State Management & Navigation

| Package | Lý do |
|---|---|
| `flutter_riverpod` | Type-safe, testable, không cần BuildContext |
| `go_router` | Declarative routing, deep link support |

---

## Local Storage

| Package | Dùng cho | Lý do |
|---|---|---|
| `isar` | Match, RuleCard, VocabularyItem | Fast, type-safe, query phức tạp |
| `shared_preferences` | UserPreference, settings đơn giản | Lightweight cho key-value |
| JSON bundle (assets) | Rule cards, vocabulary data | Offline, không cần DB cho read-only content |

---

## Timezone Handling

| Package | Lý do |
|---|---|
| `timezone` | IANA timezone database, `TZDateTime` type |
| `flutter_timezone` (dyu fork) | Lấy timezone hiện tại của thiết bị |

**QUAN TRỌNG:**
- Dùng `flutter_timezone` từ fork của **dyu** (pub.dev: `flutter_timezone`), KHÔNG phải `flutter_native_timezone` (abandoned).
- Luôn dùng `TZDateTime` khi schedule notification, KHÔNG dùng raw `DateTime`.

```
// pubspec.yaml
dependencies:
  timezone: ^0.9.x
  flutter_timezone: ^1.x.x  # dyu fork
```

---

## Notifications

| Package | Version | Lý do |
|---|---|---|
| `flutter_local_notifications` | v21+ | Hỗ trợ `TZDateTime`, Android exact alarm, iOS |

**QUAN TRỌNG:** Phải dùng v21+ để có `zonedSchedule` với `TZDateTime`. Các version cũ dùng raw `DateTime` sẽ sai khi có DST.

Android requirements:
- `SCHEDULE_EXACT_ALARM` permission (Android 12+)
- `RECEIVE_BOOT_COMPLETED` để reschedule sau reboot
- Notification channel: `kickoff_reminders`

---

## Widget & Native Bridge

| Package / Tool | Phase | Lý do |
|---|---|---|
| `home_widget` | Phase 2 | Android home screen widget |
| iOS WidgetKit (native) | Phase 2 (spike) | iOS home screen widget, không có Flutter package đủ tốt |
| iOS ActivityKit (native) | Phase 2 (spike) | Live Activities / Dynamic Island |
| `pigeon` | Phase 2 | Type-safe Dart ↔ Swift/Kotlin bridge |

**Spike estimate:** iOS WidgetKit + ActivityKit via Pigeon = 2-4 tuần. Không làm trong MVP.

---

## Internationalization

| Package | Lý do |
|---|---|
| `flutter_localizations` | Built-in, ARB format |
| `intl` | Date/number formatting theo locale |

Xem chi tiết trong [ops-i18n](../ops/02-i18n.md).

---

## Utilities

| Package | Dùng cho |
|---|---|
| `freezed` | Immutable data classes |
| `json_serializable` | JSON serialization |
| `path_provider` | File paths |

---

## MVP Additions (Sprint 1 setup)

| Package / Service | Dùng cho | Ghi chú |
|---|---|---|
| Firebase Analytics | Analytics | Setup trong Sprint 1 (event scaffold + free tier). Full event taxonomy lights up in Phase 2. Xem [ops-analytics](../ops/01-analytics.md). |

---

## Phase 2 Additions

| Package / Service | Dùng cho |
|---|---|
| Cloudflare Workers | Backend proxy cho Magic Add LLM |
| Gemini API (Google) | Magic Add LLM default |
| Anthropic API (Claude) | Magic Add LLM fallback |
| Firebase Analytics | Full event taxonomy (Sprint 1 setup, full taxonomy Phase 2) |
| Firebase Crashlytics | Crash reporting |
| `firebase_auth` | Cloud sync (optional) |

---

## Packages KHÔNG dùng

| Package | Lý do không dùng |
|---|---|
| `flutter_native_timezone` | Abandoned, không maintain |
| `bloc` / `flutter_bloc` | Riverpod đủ tốt, ít boilerplate hơn |
| `provider` | Superseded bởi Riverpod |

---

## Edge cases

- Flutter version upgrade: test kỹ trước khi upgrade stable channel
- Package deprecation: monitor pub.dev cho `flutter_timezone` và `flutter_local_notifications`

## Open questions

- —

## Next steps

- Setup project với packages này trong Sprint 1
- Verify `flutter_timezone` dyu fork hoạt động trên iOS 17+ và Android 14+
