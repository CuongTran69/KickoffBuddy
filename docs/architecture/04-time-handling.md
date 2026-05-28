---
id: arch-time-handling
title: Time Handling
status: planned
phase: foundational
depends-on: [arch-tech-stack, arch-data-model]
related: [feat-match-scheduler, feat-reminders, ops-testing]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa cách xử lý timezone và thời gian trong toàn bộ app. Đây là phần dễ sai nhất — DST và timezone conversion phải được xử lý đúng từ đầu.

## Phạm vi

### In scope

- Nguyên tắc lưu trữ (UTC)
- IANA timezone database
- DST pitfalls
- TZDateTime vs DateTime
- Notification scheduling
- Display formatting

### Out of scope

- Server-side time handling (Phase 2)
- Calendar export (.ics format)

---

## Nguyên tắc cốt lõi

**Luôn lưu kickoff theo UTC. Chỉ convert sang local time khi hiển thị.**

```
Storage:  kickoffAtUtc = "2026-06-12T01:00:00Z"  ← UTC, không bao giờ thay đổi
Display:  "02:00 sáng, 12/6/2026 (Asia/Ho_Chi_Minh)"  ← convert khi render
```

---

## Packages

```yaml
dependencies:
  timezone: ^0.9.x          # IANA database + TZDateTime
  flutter_timezone: ^1.x.x  # Lấy timezone thiết bị (dyu fork)
  intl: ^0.19.x             # Date/number formatting
```

**KHÔNG dùng `flutter_native_timezone`** — package này đã abandoned.

---

## Khởi tạo

```dart
// main.dart — phải gọi trước khi dùng timezone
await initializeTimeZones();
final String localTimezone = await FlutterTimezone.getLocalTimezone();
```

---

## TZDateTime vs DateTime

| | `DateTime` | `TZDateTime` |
|---|---|---|
| DST aware | Không | Có |
| IANA timezone | Không | Có |
| Dùng cho notification | Sai | Đúng |
| Dùng cho storage | Đúng (UTC) | Không cần |

### Đúng — dùng TZDateTime cho notification

```dart
final location = getLocation(userTimezone);  // "Asia/Ho_Chi_Minh"
final kickoffLocal = TZDateTime.from(kickoffUtc, location);
final reminderTime = kickoffLocal.subtract(Duration(minutes: 30));

await flutterLocalNotifications.zonedSchedule(
  id,
  title,
  body,
  reminderTime,  // TZDateTime
  notificationDetails,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
);
```

### Sai — KHÔNG dùng raw DateTime

```dart
// SAI: DateTime không biết về DST
final reminderTime = kickoffUtc.subtract(Duration(minutes: 30));
await flutterLocalNotifications.schedule(id, title, body, reminderTime, ...);
```

---

## DST Pitfalls

### Ví dụ: World Cup 2026 tại Mỹ

Mỹ áp dụng DST (Daylight Saving Time):
- Mùa hè (tháng 6): EDT = UTC-4 (không phải EST = UTC-5)
- Nếu hardcode offset -5 cho New York → sai 1 giờ vào mùa hè

```dart
// Đúng: dùng IANA timezone
final nyLocation = getLocation("America/New_York");
final kickoffNy = TZDateTime(nyLocation, 2026, 6, 12, 21, 0);  // 9PM EDT
// → UTC: 2026-06-13T01:00:00Z

// Sai: hardcode offset
final kickoffUtc = DateTime(2026, 6, 12, 21 + 5, 0);  // Sai! EDT là UTC-4, không phải UTC-5
```

### Timezone abbreviation ambiguity

`ET` có thể là EST (UTC-5) hoặc EDT (UTC-4) tùy mùa. Luôn dùng IANA timezone `America/New_York` thay vì abbreviation.

---

## Timezone Abbreviation Map

Dùng trong Magic Add Lite để convert abbreviation → IANA:

```dart
const Map<String, String> timezoneAbbreviationMap = {
  'BST': 'Europe/London',
  'GMT': 'Europe/London',
  'ET': 'America/New_York',
  'EST': 'America/New_York',
  'EDT': 'America/New_York',
  'CT': 'America/Chicago',
  'PT': 'America/Los_Angeles',
  'ICT': 'Asia/Bangkok',
  'VN': 'Asia/Ho_Chi_Minh',
  'WIB': 'Asia/Jakarta',
  'JST': 'Asia/Tokyo',
  'KST': 'Asia/Seoul',
};
```

**Lưu ý:** Map này chỉ dùng để parse input. Khi lưu, luôn lưu IANA timezone string, không lưu abbreviation.

---

## Ambiguous Date Resolution

Khi user nhập "Sunday" mà không có năm/tháng:

```dart
DateTime resolveAmbiguousDate(String dayOfWeek, DateTime referenceDate) {
  // Tìm ngày dayOfWeek gần nhất trong tương lai
  // Hiển thị ngày cụ thể trên Confirm Screen để user xác nhận
}
```

---

## Display Formatting

```dart
// Hiển thị local time
String formatKickoffLocal(DateTime kickoffUtc, String userTimezone) {
  final location = getLocation(userTimezone);
  final local = TZDateTime.from(kickoffUtc, location);
  return DateFormat('HH:mm, dd/MM/yyyy', 'vi').format(local);
}

// Hiển thị countdown
Duration getCountdown(DateTime kickoffUtc) {
  return kickoffUtc.difference(DateTime.now().toUtc());
}
```

---

## Testing Checklist

- [ ] Convert UTC → Asia/Ho_Chi_Minh (UTC+7, không có DST)
- [ ] Convert UTC → America/New_York (EDT mùa hè, EST mùa đông)
- [ ] Convert UTC → Europe/London (BST mùa hè, GMT mùa đông)
- [ ] Trận vào ngày đổi giờ mùa hè Mỹ (tháng 3, tháng 11)
- [ ] Notification fires đúng giờ sau khi thiết bị reboot
- [ ] User thay đổi timezone thiết bị: display time cập nhật đúng

---

## Edge cases

- Thiết bị không có IANA timezone database: `timezone` package bundle sẵn, không phụ thuộc OS
- Timezone thiết bị không hợp lệ: fallback về UTC, hiển thị cảnh báo
- Trận vào đúng thời điểm đổi giờ: TZDateTime xử lý đúng, DateTime thuần sẽ sai

## Open questions

- —

## Next steps

- Implement `core/time/timezone_service.dart` trong Sprint 1
- Viết unit tests cho tất cả timezone conversion cases
