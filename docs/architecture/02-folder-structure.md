---
id: arch-folder-structure
title: Folder Structure
status: planned
phase: foundational
depends-on: [arch-tech-stack]
related: [arch-data-model]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa cấu trúc thư mục Flutter project. Theo feature-first architecture để dễ scale và maintain.

## Phạm vi

### In scope

- Cấu trúc `lib/` directory
- Layering architecture
- Naming conventions

### Out of scope

- File cụ thể trong từng feature (xem feature docs)
- Test structure

---

## Cấu trúc `lib/`

```
lib/
├── app/
│   ├── router.dart              ← GoRouter config
│   ├── theme.dart               ← Material 3 theme
│   └── app.dart                 ← Root widget
│
├── core/
│   ├── time/
│   │   ├── timezone_service.dart    ← IANA timezone, TZDateTime utils
│   │   └── time_formatter.dart      ← Display formatting
│   ├── notifications/
│   │   ├── notification_service.dart
│   │   └── notification_channel.dart
│   ├── storage/
│   │   ├── isar_service.dart
│   │   └── preferences_service.dart
│   └── utils/
│       ├── string_utils.dart
│       └── date_utils.dart
│
├── features/
│   ├── onboarding/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── onboarding_provider.dart
│   ├── matches/
│   │   ├── screens/
│   │   │   ├── match_list_screen.dart
│   │   │   ├── match_detail_screen.dart
│   │   │   ├── add_match_screen.dart
│   │   │   └── confirm_match_screen.dart
│   │   ├── widgets/
│   │   │   ├── match_card.dart
│   │   │   └── countdown_pill.dart
│   │   ├── providers/
│   │   └── magic_add/
│   │       ├── regex_parser.dart
│   │       └── confidence_scorer.dart
│   ├── reminders/
│   │   ├── reminder_service.dart
│   │   └── reminder_settings_widget.dart
│   ├── replay_planner/
│   │   ├── screens/
│   │   ├── widgets/
│   │   │   └── replay_planner_banner.dart
│   │   └── replay_planner_provider.dart
│   ├── rules/
│   │   ├── screens/
│   │   │   ├── rule_list_screen.dart
│   │   │   └── rule_detail_screen.dart
│   │   ├── widgets/
│   │   │   └── rule_card_widget.dart
│   │   └── rules_provider.dart
│   ├── vocabulary/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── vocabulary_provider.dart
│   └── profile/
│       ├── screens/
│       └── profile_provider.dart
│
└── shared/
    ├── widgets/
    │   ├── app_bar.dart
    │   ├── empty_state.dart
    │   └── loading_indicator.dart
    ├── models/
    │   ├── match.dart
    │   ├── rule_card.dart
    │   ├── vocabulary_item.dart
    │   └── user_preference.dart
    └── constants/
        ├── app_constants.dart
        └── timezone_map.dart      ← Abbreviation → IANA map
```

---

## Layering Architecture

```
UI Layer (screens/, widgets/)
        ↓
State Management Layer (providers/ — Riverpod)
        ↓
Use Case / Service Layer (core/*, features/*/service)
        ↓
Repository Layer (storage/, JSON assets)
        ↓
Local DB (Isar) / JSON bundle / Notification Plugin
```

---

## Assets

```
assets/
├── data/
│   ├── wc2026_matches.json      ← 104 WC matches seed
│   ├── rule_cards.json          ← Rule cards content
│   └── vocabulary.json          ← Vocabulary content
├── images/
│   └── (generic illustrations, no trademark)
└── flags/
    └── (SVG flags từ flag-icons MIT)
```

---

## Naming Conventions

| Loại | Convention | Ví dụ |
|---|---|---|
| File | snake_case | `match_list_screen.dart` |
| Class | PascalCase | `MatchListScreen` |
| Variable | camelCase | `kickoffAtUtc` |
| Constant | SCREAMING_SNAKE | `DEFAULT_REMINDER_MINUTES` |
| Provider | camelCase + Provider | `matchListProvider` |

---

## Edge cases

- Feature mới: tạo thư mục riêng trong `features/`, không nhét vào `shared/`
- Shared widget dùng ở nhiều feature: đặt trong `shared/widgets/`

## Open questions

- —

## Next steps

- Setup project structure trong Sprint 1
- Tạo `core/time/timezone_service.dart` trước khi implement Match Scheduler
