---
id: ops-testing
title: Testing Checklist
status: planned
phase: mvp
depends-on: [arch-time-handling, feat-reminders, feat-replay-planner]
related: [arch-tech-stack, ops-accessibility]
last-updated: 2026-05-25
---

## Mục đích

Checklist testing cho MVP. Bao gồm timezone, notification, Replay Planner và content. Phải pass trước khi submit store.

## Phạm vi

### In scope

- Timezone conversion tests
- Notification tests (Android + iOS)
- Replay Planner tests
- Content tests
- Accessibility tests

### Out of scope

- Performance benchmarks
- Load testing
- Automated E2E tests (nice to have, không bắt buộc MVP)

---

## Timezone Tests

### Conversion

- [ ] Convert UTC → Asia/Ho_Chi_Minh (UTC+7, không có DST)
- [ ] Convert UTC → America/New_York (EDT mùa hè = UTC-4)
- [ ] Convert UTC → America/New_York (EST mùa đông = UTC-5)
- [ ] Convert UTC → America/Los_Angeles (PDT mùa hè = UTC-7)
- [ ] Convert UTC → Europe/London (BST mùa hè = UTC+1)
- [ ] Convert UTC → Europe/London (GMT mùa đông = UTC+0)
- [ ] Trận vào ngày đổi giờ mùa hè Mỹ (tháng 3, tháng 11)

### Magic Add Lite

- [ ] Parse "Man Utd vs Arsenal 20:00 BST Sunday" → đúng
- [ ] Parse "2h sáng giờ VN" → Asia/Ho_Chi_Minh
- [ ] Parse "8PM ET June 12" → America/New_York, 2026-06-12
- [ ] Parse text không có timezone → confidence MEDIUM, hiển thị cảnh báo
- [ ] Parse text không có thông tin trận → hiển thị fallback message
- [ ] Parse text > 500 ký tự → cắt bớt đúng

### Manual Add

- [ ] Lưu trận với timezone gốc khác timezone người dùng
- [ ] Override timezone người dùng → hiển thị đúng
- [ ] Ambiguous date "Sunday" → resolve đúng ngày gần nhất

---

## Notification Tests

### Android

- [ ] Reminder fires đúng giờ trên Android 12 (với exact-alarm permission)
- [ ] Reminder fires đúng giờ trên Android 13
- [ ] Reminder fires đúng giờ trên Android 14
- [ ] Reminder fires sau khi thiết bị reboot (RECEIVE_BOOT_COMPLETED)
- [ ] Exact-alarm permission dialog hiển thị đúng trên Android 12+
- [ ] Nếu từ chối exact-alarm: dùng inexact alarm, không crash
- [ ] Notification channel "kickoff_reminders" tạo đúng

### iOS

- [ ] Reminder fires đúng giờ trên iOS 16
- [ ] Reminder fires đúng giờ trên iOS 17
- [ ] Permission request hiển thị đúng lúc (khi lưu trận đầu tiên)
- [ ] Nếu từ chối permission: in-app reminder thay thế
- [ ] Hướng dẫn vào Settings nếu đã từ chối trước đó

### Notification Content

- [ ] Notification copy không chứa tỉ số khi Replay Planner bật
- [ ] Notification copy không chứa "won", "lost", "eliminated"
- [ ] Reminder cancel khi trận bị xóa
- [ ] Reminder update khi trận bị sửa giờ

---

## Replay Planner Tests

- [ ] Protected match không hiển thị score/result fields
- [ ] Protected match không hiển thị "won", "lost", "eliminated"
- [ ] Notification không leak kết quả
- [ ] Replay planned time reminder fires đúng giờ
- [ ] User bấm "Đã xem" → Replay Planner tắt, recap hiển thị
- [ ] Bật Replay Planner sau khi trận đã diễn ra → cảnh báo hiển thị

---

## Content Tests

- [ ] Rule cards readable trên màn hình nhỏ (iPhone SE)
- [ ] Vocabulary search hoạt động với tiếng Việt có dấu
- [ ] Vocabulary search hoạt động với tiếng Việt không dấu
- [ ] Không có trademark FIFA/World Cup trong UI (ngoài descriptive use)
- [ ] Disclaimer "unofficial" hiển thị trong About/Settings
- [ ] WC 2026 seed: 104 trận hiển thị đúng
- [ ] WC 2026 seed: giờ local đúng cho từng thành phố

---

## Accessibility Tests

- [ ] TalkBack (Android): tất cả interactive elements có label
- [ ] VoiceOver (iOS): tất cả interactive elements có label
- [ ] Font 1.5x: không có text bị cắt hoặc overflow
- [ ] Color contrast: text chính ≥ 4.5:1 trên background

---

## Store Submission Tests

- [ ] App icon không chứa FIFA/World Cup trademark
- [ ] Screenshots không chứa trademark
- [ ] Privacy Policy URL hoạt động
- [ ] App không crash khi không có internet
- [ ] App không crash khi notification permission bị từ chối
- [ ] App không crash khi clipboard permission bị từ chối (iOS)

---

## Edge cases

- Thiết bị đổi timezone sau khi đã lưu trận: display time cập nhật đúng
- Nhiều reminder cho cùng một trận: tất cả fires đúng
- Trận trong vòng 5 phút: bỏ qua reminder 30m và 3h

## Open questions

- —

## Next steps

- Chạy checklist này trong Sprint 5 trước khi submit
- Tạo test devices: Android 12, 13, 14 và iOS 16, 17
