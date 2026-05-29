---
id: feat-replay-planner
title: Replay Planner
status: in-progress
phase: mvp
depends-on: [mvp-scope, feat-match-scheduler, feat-reminders]
related: [future-sleep-plan, ops-testing]
last-updated: 2026-05-29
---

## Mục đích

Giúp người dùng lên kế hoạch xem lại trận đấu mà không bị lộ kết quả. Tính năng này được định vị là "kế hoạch xem lại" (informational), không phải "chống spoil tuyệt đối" (không thể đảm bảo 100%).

**Tên cũ trong bản gốc:** "No Spoiler Mode" — đã đổi thành "Replay Planner" để tránh overpromise.

## Phạm vi

### In scope

- Toggle bật/tắt Replay Planner cho từng trận
- Chọn giờ dự kiến xem lại
- Ẩn tỉ số/kết quả trong app khi Replay Planner bật
- Reminder vào giờ xem lại
- Checklist gợi ý (user guidance, không phải app capability)
- Notification copy không leak kết quả

### Out of scope

- Chặn notification từ app khác (không thể làm trên iOS/Android)
- Chặn mạng xã hội
- Đảm bảo 100% không bị spoil
- Live Activities / Dynamic Island (Phase 2)

---

## User stories

- As a late watcher, I want to mark a match as "watch later" so that the app hides the result until I'm ready.
- As a late watcher, I want to set a replay time so that I get a reminder when it's time to watch.
- As a late watcher, I want the app to not show scores or results so that my experience isn't ruined.
- As a late watcher, I want a checklist of tips so that I can minimize spoiler risk from other sources.

---

## Acceptance criteria

- [x] User có thể bật Replay Planner cho từng trận riêng lẻ
- [x] User có thể chọn giờ xem lại (time picker)
- [x] Khi Replay Planner bật: match card không hiển thị tỉ số, trạng thái thắng/thua
- [x] Khi Replay Planner bật: không hiển thị từ khóa "eliminated", "won", "lost", "goal scored"
- [x] Reminder fires vào giờ xem lại đã chọn
- [x] Notification copy không chứa thông tin lộ kết quả
- [ ] User có thể bấm "Đã xem" để tắt Replay Planner và xem recap _(deferred → Phase 2)_
- [ ] Checklist gợi ý hiển thị khi bật Replay Planner _(deferred → Phase 2)_

---

## Flow

```
User chọn trận
      │
      ▼
Bật toggle "Replay Planner"
      │
      ▼
App hỏi: "Bạn dự kiến xem lại lúc mấy giờ?"
      │
      ▼
User chọn giờ xem lại
      │
      ▼
App ẩn kết quả trận này
App đặt reminder vào giờ xem lại
App hiển thị checklist gợi ý
      │
      ▼
[Đến giờ xem lại]
Notification: "Đến giờ xem lại trận [Đội A vs Đội B] rồi!"
      │
      ▼
User bấm "Đã xem"
      │
      ▼
App tắt Replay Planner
App mở recap/journal cá nhân (nếu có)
```

---

## Nội dung hiển thị khi Replay Planner bật

```
Trận này đang trong chế độ Replay Planner.
Bạn dự kiến xem lại lúc 07:00.
```

Không hiển thị:
- Tỉ số
- Trạng thái thắng/thua
- Từ khóa: "eliminated", "won", "lost", "goal", "scored"
- Recap

---

## Checklist gợi ý (user guidance)

Đây là hướng dẫn cho người dùng, không phải tính năng app thực hiện tự động:

- Tắt notification từ app thể thao khác
- Hạn chế mở mạng xã hội trước khi xem
- Nhắn bạn bè không spoil
- Chọn nguồn xem lại hợp pháp

**Lưu ý framing:** Checklist này là "gợi ý để giảm rủi ro", không phải "đảm bảo không bị spoil". App không thể kiểm soát các nguồn bên ngoài.

---

## Notification Copy

### Reminder xem lại

```
Đến giờ xem lại trận [Đội A vs Đội B] rồi! Mở Kickoff Buddy để bắt đầu.
```

### Reminder trước trận (khi Replay Planner bật)

```
Trận [Đội A vs Đội B] sắp bắt đầu. Replay Planner đang bật — bạn sẽ xem lại lúc [giờ].
```

Không dùng: tên đội thắng, tỉ số, bất kỳ thông tin nào về kết quả.

---

## Edge cases

- User bật Replay Planner sau khi trận đã diễn ra: cảnh báo "Trận này đã diễn ra. Bạn có chắc muốn bật Replay Planner không?"
- User quên bấm "Đã xem": Replay Planner vẫn bật cho đến khi user tắt thủ công
- User thay đổi giờ xem lại: cancel reminder cũ, tạo reminder mới
- Nhiều trận cùng ngày: mỗi trận có Replay Planner độc lập

## Open questions

- —

## Next steps

- Implement trong Sprint 4
- Review notification copy để đảm bảo không leak kết quả
- Test: protected match không hiển thị score/result fields
