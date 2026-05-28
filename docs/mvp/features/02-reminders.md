---
id: feat-reminders
title: Reminders
status: planned
phase: mvp
depends-on: [mvp-scope, arch-time-handling, arch-tech-stack]
related: [feat-match-scheduler, feat-replay-planner, ops-testing]
last-updated: 2026-05-25
---

## Mục đích

Cho phép người dùng đặt nhắc lịch trước trận đấu bằng local notification. Không cần backend hay internet. Phải dùng `TZDateTime` (không phải raw `DateTime`) để tránh lỗi DST.

## Phạm vi

### In scope

- Default reminders: 1 ngày / 3 giờ / 30 phút / 5 phút trước trận
- Custom reminder messages
- Notification permission flow (Android + iOS)
- Android exact-alarm permission UX (Android 12+)
- Notification copy không leak kết quả khi Replay Planner bật

### Out of scope

- Push notification từ server (Phase 2)
- Reminder cho nhiều người dùng cùng lúc
- Reminder dựa trên live score

---

## User stories

- As a fan, I want default reminders at 1 day, 3 hours, 30 minutes, and 5 minutes before a match so that I'm always prepared.
- As a fan, I want to customize reminder messages so that I get relevant prompts (e.g., "prepare snacks", "set up TV").
- As a late watcher, I want a reminder at my planned replay time so that I remember to watch without being spoiled.
- As an Android user, I want the app to guide me through exact-alarm permission so that reminders fire on time.

---

## Acceptance criteria

- [ ] Default reminders (1d/3h/30m/5m) được tạo tự động khi lưu trận
- [ ] User có thể bật/tắt từng reminder riêng lẻ
- [ ] User có thể chọn custom message cho reminder
- [ ] Notification fires đúng giờ trên Android (kể cả khi app bị kill)
- [ ] Notification fires đúng giờ trên iOS
- [ ] Android 12+: app hướng dẫn user cấp exact-alarm permission nếu chưa có
- [ ] Khi Replay Planner bật: notification copy không chứa tỉ số hoặc từ khóa lộ kết quả
- [ ] User có thể cancel reminder bất kỳ lúc nào
- [ ] Reminder tự cancel khi trận đã qua

---

## Default Reminders

| Thời điểm | Notification copy mẫu |
|---|---|
| 1 ngày trước | "Trận [Đội A vs Đội B] diễn ra vào ngày mai lúc [giờ local]. Chuẩn bị sẵn sàng!" |
| 3 giờ trước | "Còn 3 tiếng nữa là đến trận [Đội A vs Đội B]. Bạn đã sẵn sàng chưa?" |
| 30 phút trước | "Trận của bạn bắt đầu sau 30 phút. Mở Kickoff Buddy để xem 5-minute rule brief." |
| 5 phút trước | "Còn 5 phút! Trận [Đội A vs Đội B] sắp bắt đầu." |

### Notification copy khi Replay Planner bật

```
Bạn định xem lại trận này lúc [giờ replay]. Replay Planner đang bật.
```

Không dùng: tên đội thắng, tỉ số, "eliminated", "won", "lost", "goal".

---

## Custom Reminder Messages

Người dùng có thể chọn từ danh sách gợi ý hoặc nhập tự do:

- "Nhắc chuẩn bị đồ ăn"
- "Nhắc ngủ trước"
- "Nhắc bật TV/livestream hợp pháp"
- "Nhắc xem replay"
- (Tự nhập)

---

## Notification Permission Flow

### iOS

1. App request permission khi user lưu trận đầu tiên (không request ngay khi mở app)
2. Nếu user từ chối: hiển thị in-app reminder thay thế, không push notification
3. Nếu user đã từ chối trước đó: hiển thị hướng dẫn vào Settings để bật lại

### Android

1. Android 13+: request `POST_NOTIFICATIONS` permission khi lưu trận đầu tiên
2. Android 12+: request `SCHEDULE_EXACT_ALARM` permission
   - Hiển thị dialog giải thích: "Để nhắc lịch đúng giờ, app cần quyền đặt báo thức chính xác."
   - Nút "Cấp quyền" → mở Settings của hệ thống
   - Nút "Bỏ qua" → dùng inexact alarm (có thể trễ vài phút)
3. Nếu không có exact-alarm permission: dùng `setAndAllowWhileIdle` thay vì `setExact`

---

## Kỹ thuật

- Package: `flutter_local_notifications` v21+
- Timezone: `TZDateTime` từ package `timezone` — KHÔNG dùng raw `DateTime`
- Android notification channel: `kickoff_reminders` (importance: HIGH)
- iOS: request `alert`, `sound`, `badge` permissions

```
// Đúng
final scheduledDate = TZDateTime.from(kickoffUtc, local).subtract(Duration(minutes: 30));
await flutterLocalNotifications.zonedSchedule(id, title, body, scheduledDate, ...);

// Sai — không dùng
await flutterLocalNotifications.schedule(id, title, body, kickoffUtc.subtract(...), ...);
```

---

## Edge cases

- Trận bị xóa: cancel tất cả reminder liên quan
- Trận bị sửa giờ: cancel reminder cũ, tạo reminder mới
- Thiết bị tắt nguồn rồi bật lại: Android cần `RECEIVE_BOOT_COMPLETED` để reschedule
- Người dùng thay đổi timezone thiết bị: reminder cần recalculate
- Trận diễn ra trong vòng 5 phút: bỏ qua reminder 30m và 3h, chỉ giữ 5m

## Open questions

- —

## Next steps

- Implement trong Sprint 3
- Test trên Android 12, 13, 14 và iOS 16, 17
- Test DST transition (ví dụ: trận vào ngày đổi giờ mùa hè Mỹ)
