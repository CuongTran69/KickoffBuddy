---
id: feat-vocabulary
title: Football Vocabulary Anh - Việt
status: planned
phase: mvp
depends-on: [mvp-scope, content-vocabulary-spec]
related: [feat-rule-cards, future-fan-etiquette]
last-updated: 2026-05-25
---

## Mục đích

Cung cấp từ điển thuật ngữ bóng đá Anh - Việt cho người xem stream/commentary tiếng Anh. Giúp người mới không bị "ngơ" khi nghe bình luận viên.

## Phạm vi

### In scope

- Bảng từ vựng cơ bản (17+ term từ bản gốc)
- Tìm kiếm/lọc theo từ khóa
- Giải thích ngắn + ví dụ câu

### Out of scope

- Idioms và slang phức tạp (Phase 2)
- Audio pronunciation
- Flashcard / spaced repetition (Phase 3)

---

## User stories

- As a new viewer, I want an Anh-Việt vocabulary reference so that I understand English commentary.
- As a viewer, I want to search for a term quickly so that I can look it up during a match.
- As a new viewer, I want example sentences so that I understand how terms are used in context.

---

## Acceptance criteria

- [ ] Có ít nhất 17 term từ bảng MVP
- [ ] Mỗi term có: tiếng Anh, tiếng Việt, mô tả ngắn, ví dụ câu
- [ ] Search hoạt động theo cả tiếng Anh và tiếng Việt
- [ ] Vocabulary load offline, không cần mạng
- [ ] Hiển thị rõ ràng trên màn hình nhỏ (font đủ lớn)

---

## Bảng từ vựng MVP

| English | Vietnamese | Mô tả ngắn | Ví dụ |
|---|---|---|---|
| Kickoff | Bắt đầu trận | Cú đá bắt đầu trận hoặc hiệp | "The kickoff is at 8PM." |
| Offside | Việt vị | Cầu thủ đứng sai vị trí khi nhận bóng | "He was caught offside." |
| Penalty | Phạt đền | Đá phạt từ chấm 11m trong vòng cấm | "That's a clear penalty!" |
| Penalty shootout | Đá luân lưu | Loạt đá luân lưu sau hiệp phụ | "It goes to a penalty shootout." |
| Extra time | Hiệp phụ | 2 × 15 phút thêm ở vòng knock-out | "We're going to extra time." |
| Added time / Stoppage time | Bù giờ | Thời gian cộng thêm cuối hiệp | "Six minutes of stoppage time." |
| Handball | Lỗi chạm tay | Bóng chạm tay/cánh tay không hợp lệ | "Handball! That's a penalty." |
| Foul | Phạm lỗi | Vi phạm luật khi tranh bóng | "That was a terrible foul." |
| Booking | Thẻ phạt | Nhận thẻ vàng hoặc thẻ đỏ | "He's been booked for that challenge." |
| Yellow card | Thẻ vàng | Cảnh cáo chính thức | "Yellow card for time-wasting." |
| Red card | Thẻ đỏ | Bị đuổi khỏi sân | "Straight red card!" |
| Equalizer | Bàn gỡ hòa | Bàn thắng làm tỉ số bằng nhau | "And it's the equalizer!" |
| Own goal | Phản lưới nhà | Cầu thủ tự đá vào lưới đội mình | "Oh no, that's an own goal." |
| Clean sheet | Giữ sạch lưới | Không để thủng lưới trong trận | "The goalkeeper kept a clean sheet." |
| Corner kick | Phạt góc | Đá phạt từ góc sân | "Corner kick for the home team." |
| Goal kick | Phát bóng lên | Thủ môn phát bóng từ vùng cấm | "Goal kick, no corner." |
| Throw-in | Ném biên | Ném bóng vào sân từ đường biên | "Throw-in to the away team." |

---

## Feature mở rộng (Phase 2)

Các cụm từ phổ biến trong commentary:

| Cụm từ | Nghĩa |
|---|---|
| "He was miles offside" | Việt vị rõ ràng, không cần VAR |
| "Clinical finish" | Dứt điểm lạnh lùng, chính xác |
| "Parking the bus" | Chiến thuật phòng thủ đông người |
| "Man of the match" | Cầu thủ xuất sắc nhất trận |
| "Worldie" | Bàn thắng đẹp xuất sắc |
| "Nutmeg" | Luồn bóng qua háng đối thủ |
| "Howler" | Sai lầm nghiêm trọng (thường của thủ môn) |

---

## Edge cases

- Người dùng tìm kiếm bằng tiếng Việt có dấu: search phải normalize (bỏ dấu) để tìm được
- Term có nhiều nghĩa (ví dụ: "booking" = đặt chỗ hoặc thẻ phạt): hiển thị context bóng đá

## Open questions

- —

## Next steps

- Viết đầy đủ schema theo [content-vocabulary-spec](../../content/03-vocabulary-spec.md)
- Implement search với normalize tiếng Việt
- Implement trong Sprint 4
