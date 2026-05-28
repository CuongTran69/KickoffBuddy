---
id: ops-analytics
title: Analytics
status: planned
phase: ops
depends-on: [mvp-scope, product-roadmap]
related: [arch-backend-strategy, ops-monetization]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa KPI và event taxonomy cho Kickoff Buddy. Giúp đo lường product-market fit và ưu tiên tính năng.

## Phạm vi

### In scope

- KPI theo 4 nhóm: Activation / Engagement / Retention / Monetization
- Event taxonomy (tên event, properties)
- Analytics tool recommendation

### Out of scope

- Dashboard setup
- A/B testing framework

---

## Analytics Tool

**MVP:** Firebase Analytics (free, tích hợp tốt với Flutter)

**Phase 2+:** Có thể thêm Mixpanel hoặc Amplitude nếu cần funnel analysis phức tạp hơn.

---

## KPI

### Activation

| KPI | Định nghĩa | Target MVP |
|---|---|---|
| Onboarding completion rate | % user hoàn thành onboarding | > 70% |
| First match added | % user thêm trận đầu tiên | > 50% |
| First reminder set | % user bật reminder | > 40% |
| First rule card opened | % user mở rule card đầu tiên | > 30% |

### Engagement

| KPI | Định nghĩa | Target MVP |
|---|---|---|
| Matches per user | Số trận trung bình/user | > 3 |
| Reminders created | Số reminder được tạo | > 2/user |
| Rule cards read | Số rule card đã đọc | > 5/user |
| Vocabulary items viewed | Số vocabulary item đã xem | > 10/user |
| Replay Planner activations | Số lần bật Replay Planner | > 1/user |
| Magic Add usage | % user dùng Magic Add Lite | > 20% |

### Retention

| KPI | Định nghĩa | Target MVP |
|---|---|---|
| D1 retention | % user quay lại ngày 2 | > 40% |
| D7 retention | % user quay lại sau 7 ngày | > 20% |
| D30 retention | % user quay lại sau 30 ngày | > 10% |
| Match day return | % user mở app vào ngày có trận | > 60% |

### Monetization (Phase 2+)

| KPI | Định nghĩa |
|---|---|
| Free to premium conversion | % user upgrade lên premium |
| Remove ads purchase | % user mua remove ads |
| Premium feature usage | % premium user dùng tính năng premium |

---

## Event Taxonomy

### Onboarding Events

| Event | Properties | Khi nào |
|---|---|---|
| `onboarding_started` | — | Mở app lần đầu |
| `onboarding_timezone_set` | `timezone: string` | Chọn timezone |
| `onboarding_level_set` | `level: newbie\|casual\|advanced` | Chọn football level |
| `onboarding_goals_set` | `goals: string[]` | Chọn mục tiêu |
| `onboarding_completed` | `duration_seconds: number` | Hoàn thành onboarding |

### Match Events

| Event | Properties | Khi nào |
|---|---|---|
| `match_added_manual` | `has_notes: bool` | Thêm trận thủ công |
| `match_added_magic` | `confidence: high\|medium\|low` | Thêm trận qua Magic Add |
| `match_added_seed` | `tournament: string, round: string` | Thêm trận từ WC seed |
| `match_deleted` | — | Xóa trận |
| `match_detail_viewed` | `is_seeded: bool` | Xem chi tiết trận |

### Reminder Events

| Event | Properties | Khi nào |
|---|---|---|
| `reminder_created` | `minutes_before: number` | Tạo reminder |
| `reminder_cancelled` | — | Hủy reminder |
| `reminder_fired` | `minutes_before: number` | Notification fires |
| `reminder_tapped` | — | User tap notification |

### Replay Planner Events

| Event | Properties | Khi nào |
|---|---|---|
| `replay_planner_enabled` | — | Bật Replay Planner |
| `replay_planner_disabled` | — | Tắt Replay Planner |
| `replay_watched` | — | User bấm "Đã xem" |

### Rule Card Events

| Event | Properties | Khi nào |
|---|---|---|
| `rule_card_opened` | `card_id: string, level: string` | Mở rule card |
| `rule_card_level_changed` | `from: string, to: string` | Đổi level |
| `why_did_that_happen_opened` | `situation: string` | Mở Why Did That Happen |

### Vocabulary Events

| Event | Properties | Khi nào |
|---|---|---|
| `vocabulary_item_viewed` | `item_id: string` | Xem vocabulary item |
| `vocabulary_searched` | `query_length: number` | Tìm kiếm (không log query text) |

---

## Privacy Notes

- Không log nội dung text của user (Magic Add input, notes)
- Không log tên đội cụ thể (chỉ log metadata như `is_seeded`, `round`)
- Không log query text trong vocabulary search (chỉ log `query_length`)
- Tuân thủ GDPR / PDPA (Việt Nam)

---

## Edge cases

- User tắt analytics: app vẫn hoạt động bình thường
- Offline: events được queue và gửi khi có mạng (Firebase Analytics tự xử lý)

## Open questions

- —

## Next steps

- Setup Firebase Analytics trong Sprint 1
- Implement events theo taxonomy này
- Review KPI targets sau 1 tháng launch
