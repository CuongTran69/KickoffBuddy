---
id: product-roadmap
title: Product Roadmap
status: in-progress
phase: foundational
depends-on: [product-vision, product-problems, mvp-scope]
related: [arch-tech-stack, ops-monetization]
last-updated: 2026-05-29
---

## Mục đích

Phác thảo 4 phase phát triển và sprint plan cho Phase 1 (MVP). Là tài liệu tham chiếu để ưu tiên công việc.

## Phạm vi

### In scope

- 4 phase với scope và deliverable
- Sprint plan cho Phase 1
- Backlog phân loại Must/Should/Could/Won't

### Out of scope

- Feature spec chi tiết (xem từng file trong `mvp/features/` và `future/`)
- Timeline cụ thể (phụ thuộc vào tiến độ thực tế)

---

## Phase 1 — MVP

**Thời lượng gợi ý:** 3-5 tuần (1 developer Flutter)

**Mục tiêu:** App đủ nhỏ, đủ khác biệt, ít rủi ro pháp lý, có thể submit store.

### Scope

- Onboarding (chọn timezone, football level, mục tiêu)
- Match Scheduler: WC 2026 seed (104 trận), Manual Add, Magic Add Lite (regex)
- Local time converter + countdown
- Reminder (local notification)
- Replay Planner (kế hoạch xem lại)
- Rule Cards cơ bản (7 chủ đề)
- Vocabulary Anh - Việt
- Profile local (timezone, level, preferences)
- Settings

### Deliverable

- Android internal test track
- iOS TestFlight
- Privacy Policy
- Store screenshots (generic, không dùng trademark)

---

## Phase 2 — Engagement

**Mục tiêu:** Tăng retention, thêm tính năng giá trị cao.

### Scope

- Sleep Plan (reframe thông tin, không tư vấn y tế)
- Before Match Brief (tự động tạo brief trước trận)
- After Match Learning (quiz sau trận)
- Magic Add LLM (Gemini Flash-Lite default, Claude Haiku fallback)
- Backend: Cloudflare Workers (HCM/HN PoP)
- Calendar export (.ics)
- Cloud sync optional (Firebase)
- Badge / gamification cơ bản
- Widget: Android (`home_widget`), iOS WidgetKit (spike 2-4 tuần)
- Fan Etiquette Guide
- **Deferred từ MVP:**
  - "Why Did That Happen" — 10 tình huống tra cứu (Rule Cards)
  - Onboarding: bước football level + goals
  - Replay Planner: nút "Đã xem" + spoiler-avoidance checklist
  - Magic Add: confidence scoring trên confirm screen
  - Magic Add: parse Vietnamese-time format ("2h sáng giờ VN")
  - Cảnh báo đêm khuya (22:00–05:00) trong Match Scheduler
  - Custom reminder messages UI
  - Manual Add: dropdown "Timezone gốc"

### Deliverable

- Backend deployed trên Cloudflare Workers
- Widget trên cả 2 platform
- Analytics dashboard

---

## Phase 3 — Differentiation

**Mục tiêu:** Tạo tính năng độc đáo, tăng word-of-mouth.

### Scope

- Situation Simulator (offside, penalty, handball)
- Watch With Partner Mode
- Family Mode (font lớn, nội dung nhẹ nhàng)
- Advanced vocabulary (idioms, commentary phrases)
- Custom themes
- Share cards (chia sẻ rule card lên mạng xã hội)
- iOS Live Activities / Dynamic Island (sau spike Phase 2)

---

## Phase 4 — Monetization / B2B

**Mục tiêu:** Doanh thu bền vững.

### Scope

- Premium subscription
- Venue Mode (quán cafe/sports bar)
- QR room
- Quiz giữa giờ cho venue
- Poll vui (không tiền thật)
- Export PDF/Calendar
- Branding của quán

---

## Sprint Plan — Phase 1

> **Sprint 1–5: phần lớn đã hoàn thành tính đến 2026-05-29 — xem [mvp-status](../mvp/01-status.md) để biết chi tiết trạng thái từng feature và danh sách launch blockers còn lại.**

### Sprint 1 — Foundation (tuần 1)

- Setup Flutter project (stable channel)
- App theme (Material 3, dark mode ưu tiên)
- Routing (GoRouter)
- Local storage (Isar/Hive)
- Basic models (Match, UserPreference)
- Onboarding screens
- Timezone detection (`flutter_timezone` dyu fork)

### Sprint 2 — Match Scheduler (tuần 2)

- WC 2026 seed data (104 trận từ openfootball CC0)
- Add match screen (Manual Add form)
- Magic Add Lite (regex parser)
- Confirm screen (bắt buộc)
- Match list screen
- Match detail screen
- Time conversion (UTC → local, dùng `timezone` package)
- Countdown display

### Sprint 3 — Reminders & Replay Planner (tuần 3)

- Notification permission flow (Android + iOS)
- Android exact-alarm permission UX
- Local notification scheduling (`flutter_local_notifications` v21+, `TZDateTime`)
- Default reminders: 1d / 3h / 30m / 5m
- Custom reminder messages
- Replay Planner flow
- Replay Planner Banner UI

### Sprint 4 — Rules & Vocabulary (tuần 3-4)

- Rule card data (JSON bundle)
- Rule list screen
- Rule detail screen (newbie/casual/advanced)
- Why Did That Happen flow
- Vocabulary list
- Vocabulary search/filter

### Sprint 5 — Polish & Release (tuần 4-5)

- Settings screen
- Empty states
- App icon (generic, không dùng trademark)
- Store screenshots
- Privacy Policy
- Disclaimer text
- Android internal testing
- iOS TestFlight

---

## Backlog

### Must-have (MVP)

- Onboarding
- Timezone detection
- WC 2026 seed (104 trận)
- Manual add match
- Magic Add Lite (regex)
- Match list + detail
- Countdown
- Local notification
- Replay Planner
- Rule cards (7 chủ đề)
- Vocabulary
- Settings

### Should-have (Phase 2)

- Sleep Plan
- Calendar export
- Before Match Brief
- After Match Learning
- Badge
- Search vocabulary
- Magic Add LLM
- Widget
- "Why Did That Happen" (10 tình huống — Rule Cards) _(deferred từ MVP)_
- Onboarding: football level + goals _(deferred từ MVP)_
- Replay Planner: nút "Đã xem" + spoiler-avoidance checklist _(deferred từ MVP)_
- Magic Add: confidence scoring + Vietnamese-time parsing _(deferred từ MVP)_
- Cảnh báo đêm khuya trong Match Scheduler _(deferred từ MVP)_
- Custom reminder messages _(deferred từ MVP)_
- Manual Add: dropdown "Timezone gốc" _(deferred từ MVP)_

### Could-have (Phase 3)

- Quiz
- Situation Simulator
- Partner Mode
- Family Mode
- Share card
- Wear OS / Apple Watch

### Won't-have trong MVP

- Live score
- News feed
- Video highlight
- Betting / odds
- Public chat
- Official tournament data without license
- Magic Add LLM
- Live Activities

---

## Edge cases

- Nếu WC 2026 bị hoãn/thay đổi lịch: cần update seed data qua app update
- Nếu Cloudflare Workers thay đổi pricing: có fallback plan (Firebase Functions)

## Open questions

- —

## Next steps

- Bắt đầu Sprint 1 sau khi docs set hoàn chỉnh
- Review roadmap sau mỗi phase dựa trên user feedback và analytics
