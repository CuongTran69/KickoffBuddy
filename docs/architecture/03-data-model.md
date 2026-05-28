---
id: arch-data-model
title: Data Model
status: planned
phase: foundational
depends-on: [arch-tech-stack]
related: [arch-time-handling, feat-match-scheduler, data-seed-strategy]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa data model cho các entity chính của Kickoff Buddy. Là nguồn sự thật duy nhất cho schema.

## Phạm vi

### In scope

- Match (bao gồm WC 2026 fields)
- RuleCard
- VocabularyItem
- UserPreference

### Out of scope

- Database migration strategy
- API response schema (Phase 2)

---

## Match

```json
{
  "id": "match_001",
  "title": "Team A vs Team B",
  "teamA": "Team A",
  "teamB": "Team B",
  "kickoffAtUtc": "2026-06-12T01:00:00Z",
  "sourceTimezone": "America/New_York",
  "userTimezone": "Asia/Ho_Chi_Minh",
  "reminders": [1440, 180, 30, 5],
  "replayPlannerEnabled": false,
  "replayPlannedAt": null,
  "sourceText": "Team A vs Team B 8PM ET June 12",
  "notes": "",
  "createdAt": "2026-05-25T08:00:00Z",
  "isSeeded": true,
  "tournamentId": "wc2026",
  "worldCupGroup": "A",
  "worldCupRound": "group_stage",
  "matchday": 1,
  "venueCity": "Los Angeles",
  "venueIanaTimezone": "America/Los_Angeles"
}
```

### Field definitions

| Field | Type | Bắt buộc | Ghi chú |
|---|---|---|---|
| `id` | String | Có | UUID hoặc sequential |
| `title` | String | Không | Auto-generated từ teamA vs teamB |
| `teamA` | String | Có | |
| `teamB` | String | Có | |
| `kickoffAtUtc` | DateTime (UTC) | Có | Luôn lưu UTC |
| `sourceTimezone` | String (IANA) | Có | Timezone của nguồn lịch |
| `userTimezone` | String (IANA) | Có | Timezone hiển thị |
| `reminders` | List\<int\> | Không | Phút trước trận, ví dụ [1440, 180, 30, 5] |
| `replayPlannerEnabled` | bool | Không | Default false |
| `replayPlannedAt` | DateTime? | Không | Giờ dự kiến xem lại (UTC) |
| `sourceText` | String? | Không | Text gốc từ Magic Add, có thể xóa |
| `notes` | String | Không | Ghi chú cá nhân |
| `createdAt` | DateTime (UTC) | Có | |
| `isSeeded` | bool | Không | True nếu từ WC 2026 seed |
| `tournamentId` | String? | Không | "wc2026" hoặc null |
| `worldCupGroup` | String? | Không | "A"-"L" cho vòng bảng |
| `worldCupRound` | String? | Không | Xem enum bên dưới |
| `matchday` | int? | Không | 1-3 cho vòng bảng |
| `venueCity` | String? | Không | Thành phố tổ chức |
| `venueIanaTimezone` | String? | Không | IANA timezone của sân |

### worldCupRound enum

```
group_stage
round_of_32
round_of_16
quarter_final
semi_final
third_place
final
```

---

## RuleCard

```json
{
  "id": "offside_basic",
  "title": "Offside",
  "titleVi": "Việt vị",
  "level": "newbie",
  "shortExplanation": "Cầu thủ không được đứng chờ sẵn quá gần khung thành đối phương khi đồng đội chuyền bóng.",
  "shortExplanationEn": "A player cannot wait too close to the opponent's goal when a teammate passes the ball.",
  "detail": "Một cầu thủ có thể bị việt vị nếu đứng dưới hậu vệ áp chót tại thời điểm đồng đội chuyền bóng và tham gia vào pha bóng.",
  "tags": ["offside", "goal", "VAR"],
  "estimatedReadSeconds": 30,
  "relatedIds": ["offside_casual", "offside_advanced", "var_basic"],
  "ifabReference": "Law 11",
  "lastReviewedDate": "2026-05-25"
}
```

### level enum

```
newbie    ← người mới, giải thích đơn giản nhất
casual    ← fan thỉnh thoảng xem
advanced  ← fan hiểu bóng đá
```

---

## VocabularyItem

```json
{
  "id": "stoppage_time",
  "term": "Stoppage time",
  "termAlternatives": ["Added time"],
  "translation": "Bù giờ",
  "description": "Thời gian được cộng thêm vào cuối hiệp vì có các khoảng dừng trong trận.",
  "descriptionEn": "Extra minutes added because play was stopped during the half.",
  "example": "There will be six minutes of stoppage time.",
  "exampleVi": "Sẽ có sáu phút bù giờ.",
  "tags": ["time", "referee"]
}
```

---

## UserPreference

```json
{
  "timezone": "Asia/Ho_Chi_Minh",
  "footballLevel": "newbie",
  "defaultReminderMinutes": [1440, 180, 30, 5],
  "preferReplayPlanner": false,
  "theme": "dark",
  "language": "vi",
  "onboardingCompleted": true,
  "goals": ["watch_on_time", "avoid_spoilers", "learn_rules"]
}
```

### footballLevel enum

```
newbie    ← mới xem bóng đá
casual    ← xem thỉnh thoảng
advanced  ← hiểu bóng đá
```

### goals enum values

```
watch_on_time
avoid_spoilers
learn_rules
watch_with_friends
```

---

## Isar Schema Notes

- `Match.kickoffAtUtc` lưu dưới dạng `DateTime` với UTC flag (Isar storage). **CẢNH BÁO:** Khi schedule notification, phải convert `kickoffAtUtc` sang `TZDateTime` trước rồi mới truyền vào `flutter_local_notifications.zonedSchedule()`. KHÔNG được truyền raw `DateTime` cho scheduler — sẽ sai sau khi DST chuyển. Xem `architecture/04-time-handling.md`.
- `Match.replayPlannedAt` nullable
- `RuleCard` và `VocabularyItem` load từ JSON bundle (assets), không lưu trong Isar
- `UserPreference` lưu trong `SharedPreferences` (single object, không cần Isar)

---

## Edge cases

- `sourceText` phải có thể null/empty (user có thể xóa)
- `worldCupGroup` chỉ có giá trị cho `worldCupRound == "group_stage"`
- `venueIanaTimezone` phải khớp với IANA database

## Open questions

- —

## Next steps

- Generate Isar schema từ model classes trong Sprint 1
- Validate WC 2026 seed data khớp với schema này
