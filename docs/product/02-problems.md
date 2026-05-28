---
id: product-problems
title: Problem Statements
status: planned
phase: foundational
depends-on: [product-vision]
related: [mvp-scope, feat-match-scheduler, feat-replay-planner, feat-rule-cards]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa 4 vấn đề người dùng mà Kickoff Buddy giải quyết. Mỗi problem statement là cơ sở để ưu tiên feature.

## Phạm vi

### In scope

- 4 problem statements với context và evidence
- Mapping problem → feature

### Out of scope

- Solution design (xem feature files)
- Competitive analysis (xem [product-vision](01-vision.md))

---

## Problem 1: Lệch múi giờ

**Mô tả:** Người dùng biết có trận hay nhưng không chắc trận đó rơi vào mấy giờ ở Việt Nam/local time. Việc tự đổi giờ dễ sai, đặc biệt khi có Daylight Saving Time.

**Context:**
- World Cup 2026 tổ chức tại Mỹ, Canada, Mexico — tất cả đều có DST
- Người Việt Nam xem trận lúc 2-3 giờ sáng là bình thường với các giải lớn
- Lỗi phổ biến: nhầm giờ BST vs GMT, nhầm ET vs EDT

**Feature giải quyết:** [Match Scheduler](../mvp/features/01-match-scheduler.md), [Reminders](../mvp/features/02-reminders.md)

---

## Problem 2: Không muốn bị spoil

**Mô tả:** Nhiều trận diễn ra lúc đêm muộn. Người dùng muốn xem lại vào sáng hôm sau nhưng rất dễ bị lộ kết quả qua notification, mạng xã hội, bạn bè hoặc app thể thao.

**Context:**
- Notification từ app thể thao khác thường hiển thị tỉ số
- Mạng xã hội (Facebook, Twitter/X) tràn ngập kết quả ngay sau trận
- Người dùng không có cách chủ động "bảo vệ" trải nghiệm xem lại

**Feature giải quyết:** [Replay Planner](../mvp/features/03-replay-planner.md)

---

## Problem 3: Không hiểu luật khi xem

**Mô tả:** Người mới thường gặp các câu hỏi trong lúc xem mà không có chỗ tra cứu nhanh, thân thiện.

**Câu hỏi phổ biến:**
- Sao bàn thắng bị hủy?
- Sao lại việt vị?
- Sao có VAR?
- Sao được penalty?
- Sao bù giờ tận 8 phút?
- Sao hết 90 phút vẫn đá tiếp?

**Context:**
- IFAB Rules App quá kỹ thuật cho người mới
- Wikipedia quá dài, không có ví dụ đời thường
- Không có app nào giải thích bằng tiếng Việt, ngắn gọn, trong lúc xem

**Feature giải quyết:** [Rule Cards](../mvp/features/04-rule-cards.md), [Vocabulary](../mvp/features/05-vocabulary.md)

---

## Problem 4: App live score quá chuyên sâu

**Mô tả:** Các app như SofaScore, FotMob, ESPN phục vụ fan đã hiểu bóng đá. Người mới cần app giải thích và chuẩn bị trước trận, không cần quá nhiều số liệu.

**Context:**
- Live score app hiển thị xG, heat map, line-up, possession % — quá nhiều với người mới
- Không có "onboarding" cho người không biết bóng đá
- Người mới cần context trước khi xem, không phải data trong lúc xem

**Feature giải quyết:** Toàn bộ Kickoff Buddy — định vị là companion app, không phải live score app

---

## Mapping Problem → Feature

| Problem | MVP Feature | Phase 2+ Feature |
|---|---|---|
| Lệch múi giờ | Match Scheduler, Reminders | Calendar Export, Widget |
| Bị spoil | Replay Planner | — |
| Không hiểu luật | Rule Cards, Vocabulary | Quiz, Simulator |
| App quá chuyên sâu | Onboarding, Rule Cards | Partner Mode, Family Mode |

---

## Edge cases

- Người dùng ở cùng timezone với địa điểm tổ chức: vẫn cần reminder, không cần convert
- Người dùng đã biết luật: có thể bỏ qua Rule Cards, vẫn dùng Match Scheduler

## Open questions

- —

## Next steps

- Validate problem statements với user interviews sau khi có beta
- Thêm problem statement nếu phát hiện nhu cầu mới qua analytics
