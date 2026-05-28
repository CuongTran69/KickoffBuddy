---
id: content-strategy
title: Content Strategy
status: planned
phase: foundational
depends-on: []
related: [content-rule-cards-spec, content-vocabulary-spec, feat-rule-cards, feat-vocabulary]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa cách tạo, review và maintain nội dung rule cards và vocabulary. Đảm bảo nội dung chính xác, thân thiện với người mới và tuân thủ nguồn tham chiếu IFAB.

## Phạm vi

### In scope

- Nguồn tham chiếu (IFAB Laws of the Game 2025/26)
- Attribution và licensing
- Plain-language paraphrase guidelines
- Review process
- Vietnamese translation checklist

### Out of scope

- Nội dung cụ thể của từng rule card (xem [content-rule-cards-spec](02-rule-cards-spec.md))
- Nội dung vocabulary (xem [content-vocabulary-spec](03-vocabulary-spec.md))

---

## Nguồn tham chiếu

### IFAB Laws of the Game 2025/26

- URL: https://www.theifab.com/laws-of-the-game/
- Cập nhật hàng năm (thường tháng 6)
- Phiên bản 2025/26 có hiệu lực từ 1/7/2025

**Cách dùng:**
- Dùng làm nguồn sự thật cho nội dung rule cards
- Không copy nguyên văn (copyright của IFAB)
- Paraphrase bằng ngôn ngữ đơn giản, có ví dụ đời thường
- Ghi rõ "Law X" trong metadata của card để truy xuất nguồn

**Attribution:**
```
Nội dung rule cards được paraphrase từ IFAB Laws of the Game 2025/26.
Kickoff Buddy không phải sản phẩm chính thức của IFAB.
```

**Liên hệ IFAB:** Nếu muốn dùng nội dung chính thức, liên hệ info@theifab.com để xin license. Hiện tại dùng paraphrase.

---

## Plain-Language Guidelines

### Nguyên tắc viết

1. **Ngắn gọn:** Mỗi card level newbie không quá 2 câu
2. **Ví dụ đời thường:** Dùng ví dụ mà người không biết bóng đá cũng hiểu
3. **Tránh jargon:** Giải thích thuật ngữ kỹ thuật nếu phải dùng
4. **Tiếng Việt tự nhiên:** Không dịch máy, không dùng cấu trúc câu tiếng Anh

### Ví dụ tốt vs xấu

| Xấu | Tốt |
|---|---|
| "A player is in an offside position if any part of the head, body or feet is in the opponents' half" | "Cầu thủ không được đứng chờ sẵn quá gần khung thành đối phương khi đồng đội chuyền bóng" |
| "The goalkeeper must remain on the goal line until the ball is kicked" | "Thủ môn phải đứng trên vạch khung thành cho đến khi cầu thủ đá bóng" |

### Level guidelines

| Level | Đối tượng | Độ dài | Thuật ngữ |
|---|---|---|---|
| newbie | Người chưa biết bóng đá | 1-2 câu | Tối thiểu, giải thích nếu dùng |
| casual | Fan thỉnh thoảng xem | 3-5 câu | Thuật ngữ cơ bản OK |
| advanced | Fan hiểu bóng đá | Không giới hạn | Thuật ngữ kỹ thuật OK |

---

## Review Process

### Trước khi publish

1. **Fact-check:** Đối chiếu với IFAB Laws 2025/26
2. **Plain-language check:** Đọc lại với góc nhìn người mới
3. **Vietnamese review:** Kiểm tra ngữ pháp và tự nhiên
4. **Consistency check:** Thuật ngữ nhất quán với glossary

### Checklist review tiếng Việt

- [ ] Không dùng cấu trúc câu dịch máy
- [ ] Thuật ngữ tiếng Anh giữ nguyên (offside, VAR, penalty) — không dịch sang tiếng Việt khi không cần
- [ ] Dấu câu đúng (dấu phẩy, dấu chấm)
- [ ] Không dùng "bạn" và "mình" lẫn lộn trong cùng một card
- [ ] Ví dụ phù hợp với văn hóa Việt Nam

### Cập nhật luật hàng năm

- IFAB thường công bố luật mới vào tháng 5-6
- Cần review và update rule cards trước mùa giải mới
- Đánh dấu cards đã được review với `lastReviewedDate`

---

## Cập nhật luật 2025/26 (đã áp dụng)

| Luật | Thay đổi | Card cần update |
|---|---|---|
| Thủ môn phát bóng | 8 giây (tăng từ 6 giây) | stoppage_time, goalkeeper |
| Ném biên | 5 giây countdown | throw_in |
| Phản đối trọng tài | Chỉ đội trưởng | yellow_card |
| Câu giờ | Áp dụng nghiêm hơn | stoppage_time |

---

## Edge cases

- Luật thay đổi giữa mùa giải: update JSON bundle, release app update
- Nội dung sai lệch được báo cáo: có cơ chế feedback trong app (Phase 2)

## Open questions

- Cần xác định có liên hệ IFAB để xin license không, hay dùng paraphrase là đủ

## Next steps

- Viết nội dung đầy đủ cho 7 rule cards MVP
- Setup review checklist trước Sprint 3
