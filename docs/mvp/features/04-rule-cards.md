---
id: feat-rule-cards
title: Rule Cards
status: done
phase: mvp
depends-on: [mvp-scope, content-rule-cards-spec, content-strategy]
related: [feat-vocabulary, future-quiz-simulator]
last-updated: 2026-05-29
---

## Mục đích

Giúp người mới hiểu nhanh các luật bóng đá phổ biến qua thẻ ngắn gọn, có 3 level (newbie/casual/advanced). Bao gồm cả "5-Minute Brief" trước trận và "Why Did That Happen" trong lúc xem.

**Trạng thái (2026-05-29):** 21 cards (7 chủ đề × 3 level) đã build xong. "Why Did That Happen" (10 tình huống tra cứu) được deferred sang Phase 2 — xem [mvp-status](../01-status.md).

## Phạm vi

### In scope

- 7 chủ đề MVP: offside, penalty, VAR, cards, stoppage time, extra time, penalty shootout
- 3 level: newbie / casual / advanced
- Format: 5-Minute Brief (đọc trước trận) + Why Did That Happen (tra cứu trong lúc xem)
- Cập nhật luật 2025/26 từ IFAB
- Nội dung tiếng Việt, thuật ngữ tiếng Anh giữ nguyên

### Out of scope

- Situation Simulator (Phase 3)
- Quiz (Phase 3)
- AI-generated explanations (Phase 2)
- Luật đầy đủ theo IFAB (quá kỹ thuật cho MVP)

---

## User stories

- As a new viewer, I want a 5-minute rule brief before a match so that I understand what's happening.
- As a viewer, I want to quickly look up "why did that happen" during a match so that I'm not confused.
- As a new viewer, I want explanations at my level (newbie) so that I'm not overwhelmed.
- As a casual fan, I want more detail when I'm ready so that I can deepen my understanding.

---

## Acceptance criteria

- [x] 7 chủ đề MVP có đủ nội dung level newbie
- [x] Mỗi card có: tên luật, giải thích 1 câu, ví dụ đời thường, khi nào thường xuất hiện
- [x] User có thể chọn level (newbie/casual/advanced) trong Settings
- [ ] "Why Did That Happen" có đủ 10 tình huống phổ biến _(deferred → Phase 2)_
- [x] Nội dung phản ánh luật IFAB 2025/26 (xem bên dưới)
- [x] Không có thông tin sai lệch về luật bóng đá

---

## 7 Chủ đề MVP

### 1. Offside (Việt vị)

**Newbie:** Cầu thủ không được đứng chờ sẵn quá gần khung thành đối phương khi đồng đội chuyền bóng.

**Casual:** Một cầu thủ có thể bị việt vị nếu đứng dưới hậu vệ áp chót tại thời điểm đồng đội chuyền bóng và tham gia vào pha bóng.

**Advanced:** Offside còn phụ thuộc vào việc cầu thủ có interfering with play, interfering with opponent hoặc gaining advantage hay không. VAR dùng semi-automated offside technology (SAOT) để vẽ đường.

**Nội dung cần có:**
- Khi nào bàn thắng bị hủy vì offside
- Passive offside (đứng offside nhưng không tham gia pha bóng)
- VAR check offside ra sao

---

### 2. Penalty (Phạt đền)

**Newbie:** Khi một cầu thủ bị phạm lỗi trong vòng cấm địa của đội mình, đội kia được đá phạt đền từ chấm 11m.

**Nội dung cần có:**
- Khi nào có penalty (foul trong penalty area, handball)
- Penalty trong trận khác penalty shootout thế nào
- Thủ môn được làm gì (phải đứng trên vạch, có thể di chuyển ngang)
- Đá bồi sau penalty trong trận

---

### 3. VAR (Video Assistant Referee)

**Newbie:** VAR giống như trọng tài xem lại replay để kiểm tra các tình huống lớn như bàn thắng, penalty hoặc thẻ đỏ.

**Nội dung cần có:**
- VAR can thiệp trong 4 tình huống: goal, penalty, red card, mistaken identity
- Vì sao trọng tài vẫn là người quyết định cuối
- Vì sao check VAR lâu (cần xem nhiều góc camera)
- OFR (On-Field Review): khi trọng tài ra màn hình xem lại

---

### 4. Yellow Card / Red Card (Thẻ vàng / Thẻ đỏ)

**Newbie:** Thẻ vàng là cảnh cáo. Hai thẻ vàng trong một trận = thẻ đỏ, phải rời sân.

**Nội dung cần có:**
- Khi nào bị thẻ vàng (foul thô bạo, câu giờ, phản đối trọng tài)
- Khi nào bị thẻ đỏ trực tiếp (violent conduct, DOGSO)
- Đội bị thẻ đỏ đá thiếu người (không được thay thế)
- **Luật 2025/26:** Chỉ đội trưởng được phép phản đối quyết định trọng tài

---

### 5. Stoppage Time / Added Time (Bù giờ)

**Newbie:** Bù giờ là thời gian được cộng thêm vì trong hiệp có các khoảng dừng.

**Nội dung cần có:**
- Các lý do được cộng giờ: chấn thương, thay người, VAR, ăn mừng bàn thắng, câu giờ
- Vì sao bù giờ có thể dài (8-10 phút ở World Cup)
- **Luật 2025/26:** Thủ môn phải phát bóng trong 8 giây (trước là 6 giây)
- **Luật 2025/26:** Ném biên phải thực hiện trong 5 giây (có đếm ngược)

---

### 6. Extra Time (Hiệp phụ)

**Newbie:** Nếu trận hòa sau 90 phút ở vòng knock-out, hai đội đá thêm 2 hiệp 15 phút.

**Nội dung cần có:**
- Khi nào có hiệp phụ (chỉ ở vòng knock-out, không phải vòng bảng)
- Hiệp phụ dài bao lâu (2 × 15 phút)
- Sau hiệp phụ vẫn hòa → đá luân lưu

---

### 7. Penalty Shootout (Đá luân lưu)

**Newbie:** Nếu vẫn hòa sau hiệp phụ, mỗi đội cử 5 cầu thủ đá luân lưu để phân định thắng thua.

**Nội dung cần có:**
- Luân lưu khác penalty trong trận ra sao (thủ môn có thể di chuyển trước khi đá)
- Nếu sau 5 lượt vẫn hòa: đá sudden death
- Tâm lý và chiến thuật (không cần đi sâu)

---

## Why Did That Happen — 10 Tình huống

| Câu hỏi | Liên quan đến |
|---|---|
| Vì sao bàn thắng bị hủy? | Offside, handball, foul trước đó |
| Vì sao bị thổi việt vị? | Offside |
| Vì sao có penalty? | Foul trong vòng cấm, handball |
| Vì sao VAR can thiệp? | VAR |
| Vì sao có thẻ vàng? | Yellow card |
| Vì sao có thẻ đỏ? | Red card |
| Vì sao bù giờ nhiều? | Stoppage time |
| Vì sao trận có hiệp phụ? | Extra time |
| Vì sao phải đá luân lưu? | Penalty shootout |
| Vì sao thủ môn bị phạt khi bắt penalty? | Penalty rules (thủ môn rời vạch sớm) |

---

## Cập nhật luật IFAB 2025/26

Các thay đổi quan trọng cần phản ánh trong rule cards:

| Luật | Thay đổi |
|---|---|
| Thủ môn phát bóng | Phải phát trong 8 giây (tăng từ 6 giây) |
| Ném biên | Phải thực hiện trong 5 giây (có đếm ngược hiển thị) |
| Phản đối trọng tài | Chỉ đội trưởng được phép phản đối |
| Thẻ vàng câu giờ | Áp dụng nghiêm hơn |

Nguồn tham chiếu: theifab.com — Laws of the Game 2025/26. Xem [content-strategy](../../content/01-content-strategy.md).

---

## Edge cases

- Người dùng đang xem trận và cần tra cứu nhanh: Why Did That Happen phải load offline, không cần mạng
- Luật thay đổi giữa mùa giải: cần update app, không thể update OTA nếu dùng JSON bundle

## Open questions

- —

## Next steps

- Viết nội dung đầy đủ cho 7 chủ đề (xem [content-rule-cards-spec](../../content/02-rule-cards-spec.md))
- Review nội dung với nguồn IFAB 2025/26
- Implement trong Sprint 4
