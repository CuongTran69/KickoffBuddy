---
id: mvp-status
title: MVP Implementation Status
status: in-progress
phase: mvp
depends-on: [mvp-scope]
related: [feat-match-scheduler, feat-reminders, feat-replay-planner, feat-rule-cards, feat-vocabulary, ops-analytics, ops-i18n, ops-testing]
last-updated: 2026-05-29
---

## Mục đích

Ghi lại trạng thái thực tế của MVP tính đến 2026-05-29. Tài liệu này là nguồn sự thật duy nhất về những gì đã build, những gì còn thiếu, và những gì được chuyển sang Phase 2.

## Phạm vi

### In scope

- Trạng thái từng feature theo verified code review
- Danh sách launch blockers (phải xong trước khi submit store)
- Danh sách items deferred sang Phase 2 kèm lý do
- Số liệu data và test suite

### Out of scope

- Chi tiết implementation từng feature (xem file spec tương ứng trong `mvp/features/`)
- Kế hoạch sprint (xem [product-roadmap](../product/03-roadmap.md))

---

## Tổng quan

App Kickoff Buddy đã đạt khoảng **75% MVP** tính đến 2026-05-29. Toàn bộ 5 tính năng chính đều functional. Codebase có ~14.700 LOC, 22 file test, và store assets đã có sẵn.

---

## Trạng thái từng feature

| Feature | Status | Gaps còn lại |
|---|---|---|
| Match Scheduler | BUILT | Không có confidence score trên confirm screen; không có cảnh báo đêm khuya (22:00–05:00); Manual Add thiếu dropdown "Timezone gốc"; Magic Add chỉ parse được 6/7 pattern (thiếu "Xh sáng/tối giờ VN") |
| Reminders | BUILT | AndroidManifest thiếu `SCHEDULE_EXACT_ALARM` + `RECEIVE_BOOT_COMPLETED`; chưa có UX dialog xin exact-alarm permission (Android 12+); chưa có UI custom reminder message. Notification channel ID trong code là `match_reminders` (spec ghi `kickoff_reminders`) |
| Replay Planner | BUILT | Chưa có nút "Đã xem"; chưa có spoiler-avoidance checklist |
| Rule Cards | DONE | "Why Did That Happen" (10 tình huống tra cứu) chưa build — deferred Phase 2. 21 cards = 7 chủ đề × 3 level đã đủ |
| Vocabulary | DONE | 17 term, khớp hoàn toàn với spec |
| Onboarding | PARTIAL | Bước timezone + language đã xong; bước football level + goals chưa có. Nút "Change" timezone là no-op TODO |
| Settings | PARTIAL | Theme + language đã xong; chưa có timezone override, notification prefs, và disclaimer "unofficial" |
| Analytics | DONE | Firebase wired (`firebase_core` + `firebase_analytics`), graceful fallback khi không có config, event taxonomy đã implement |
| i18n | DONE | ARB files vi + en, language switching được persist |
| Testing | SOLID | 20 file unit/widget test + 1 integration test. Manual/device testing theo sprint5-manual-steps chưa chạy đủ |

---

## Dữ liệu đã có

- **104 trận** WC 2026 trong `app/assets/data/wc2026_matches.json`
- **21 rule cards** (7 chủ đề × 3 level) trong `app/assets/data/`
- **17 vocabulary terms** trong `app/assets/data/`
- i18n: ARB files `vi` + `en` trong `app/lib/l10n/`
- Firebase Analytics: wired với graceful fallback
- Test suite: 20 unit/widget tests (`app/test/`) + 1 integration test (`app/integration_test/`)

---

## Launch blockers — phải xong trước khi submit store

Đây là 3 items **KEEP IN MVP** — không thể launch nếu thiếu:

1. **Disclaimer "unofficial" trong About/Settings**
   - Yêu cầu compliance: app phải hiển thị rõ không liên kết với FIFA/liên đoàn bóng đá nào.
   - Xem [mvp-scope](00-scope.md) và [compliance-store-review](../compliance/02-store-review.md).

2. **AndroidManifest: thêm `SCHEDULE_EXACT_ALARM` + `RECEIVE_BOOT_COMPLETED`**
   - Thiếu 2 permission này khiến reminder không fire đúng giờ trên Android và không reschedule sau reboot.
   - Files: `app/android/app/src/main/AndroidManifest.xml`

3. **UX dialog xin exact-alarm permission (Android 12+)**
   - Không có dialog → user không biết cần cấp quyền → reminder bị trễ hoặc không fire.
   - Spec chi tiết: [feat-reminders](features/02-reminders.md)

---

## Deferred to Phase 2

Các items dưới đây được chuyển sang Phase 2 vì phức tạp hoặc giá trị thấp hơn so với effort:

| Item | Lý do defer |
|---|---|
| "Why Did That Happen" (10 tình huống — Rule Cards) | Content + UI phức tạp; core rule cards đã đủ cho MVP |
| Onboarding: bước football level + goals | Onboarding timezone/language đã đủ để app hoạt động; level/goals cần thêm personalization logic |
| Replay Planner: nút "Đã xem" + spoiler-avoidance checklist | Core flow (ẩn kết quả + reminder) đã hoạt động; "Đã xem" là polish |
| Magic Add: confidence scoring trên confirm screen | Parser hoạt động; hiển thị score là UX enhancement, không blocking |
| Cảnh báo đêm khuya (22:00–05:00) trong Match Scheduler | Nice-to-have; không ảnh hưởng đến core functionality |
| Vietnamese-time parsing trong Magic Add ("2h sáng giờ VN") | 6/7 pattern đã đủ cho MVP; pattern này cần thêm test coverage |
| Custom reminder messages UI | Default reminders đã hoạt động; custom message là enhancement |
| Manual Add: dropdown "Timezone gốc" | Manual Add hoạt động với timezone mặc định; dropdown là UX improvement |

---

## Ghi chú kỹ thuật

- Notification channel ID trong code là `match_reminders`, spec ghi `kickoff_reminders`. Cần thống nhất trước khi launch (nếu đổi sau khi user đã cài app sẽ mất notification cũ).
- Nút "Change" timezone trong Onboarding là no-op TODO — cần fix hoặc ẩn trước launch.

---

## Open questions

- Notification channel ID: giữ `match_reminders` (code hiện tại) hay đổi về `kickoff_reminders` (spec)? Quyết định trước launch vì không thể migrate sau khi app đã publish.
- Onboarding "Change" timezone button: fix thành functional hay ẩn đi cho MVP?

## Next steps

- Fix 3 launch blockers trước khi submit store
- Quyết định notification channel ID
- Chạy manual/device testing checklist (xem [ops-testing](../ops/04-testing.md))
- Archive doc này sau khi launch thành công
