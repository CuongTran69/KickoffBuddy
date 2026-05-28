---
id: future-quiz-simulator
title: Quiz & Situation Simulator (Phase 3)
status: planned
phase: phase-3
depends-on: [feat-rule-cards, feat-vocabulary]
related: [future-partner-mode, future-family-mode]
last-updated: 2026-05-25
---

## Mục đích

Gamify việc học luật bóng đá qua quiz và mô phỏng tình huống. Tăng engagement và retention sau MVP.

## Phạm vi

### In scope

- Quiz luật bóng đá (trước trận, giữa giờ, sau trận)
- Situation Simulator: mô phỏng tình huống bằng hình ảnh đơn giản
- After Match Learning: quiz sau trận về tình huống đã xảy ra
- Badge / gamification
- 3 level: newbie / casual / advanced

### Out of scope

- Quiz có tiền thưởng / betting
- Multiplayer quiz real-time (Phase 4)
- AI-generated quiz questions (Phase 2+)

---

## User stories

- As a new viewer, I want a quick quiz before a match so that I can test my knowledge.
- As a viewer, I want to simulate offside scenarios so that I understand the rule visually.
- As a viewer, I want to learn from situations that happened in the match I just watched.

---

## Acceptance criteria

- [ ] Quiz có ít nhất 20 câu hỏi cho level newbie
- [ ] Situation Simulator có ít nhất 5 tình huống (offside, penalty, handball, goal kick vs corner, throw-in)
- [ ] After Match Learning: user chọn tình huống khó hiểu → app giải thích
- [ ] Badge system: ít nhất 4 badge MVP

---

## Quiz Format

Mỗi câu hỏi:
- Mô tả tình huống
- 2-4 lựa chọn
- Sau khi trả lời: giải thích đúng/sai

Ví dụ:
```
Tình huống này có việt vị không?
[Hình minh họa đơn giản]
A. Có
B. Không

→ Đúng! Cầu thủ đứng dưới hậu vệ áp chót khi bóng được chuyền.
```

---

## Situation Simulator

| Tình huống | Mô tả |
|---|---|
| Offside | Vẽ vị trí cầu thủ, hỏi có offside không |
| Penalty | Mô tả foul trong vòng cấm, hỏi có penalty không |
| Handball | Mô tả bóng chạm tay, hỏi có lỗi không |
| Goal kick vs Corner | Bóng ra ngoài, ai phát bóng? |
| Throw-in | Bóng ra biên, ai ném? |
| Back pass to GK | Thủ môn có được bắt bóng không? |
| Advantage rule | Trọng tài có nên thổi phạt không? |

---

## After Match Learning

Sau trận, app hỏi:
```
Bạn gặp tình huống nào khó hiểu trong trận này?
```

Options:
- VAR hủy bàn thắng
- Penalty
- Thẻ đỏ
- Offside
- Bù giờ nhiều
- Hiệp phụ
- Luân lưu

User chọn → app mở explanation card tương ứng.

---

## Badge System

| Badge | Điều kiện |
|---|---|
| New Fan | Học 5 luật |
| Commentary Ready | Học 20 thuật ngữ |
| Replay Master | Xem 5 trận không bị spoil (Replay Planner) |
| Night Owl Fan | Thức xem 3 trận khuya |

---

## Edge cases

- Người dùng đã biết luật: có thể bỏ qua quiz, không bắt buộc
- Quiz phải hoạt động offline

## Open questions

- —

## Next steps

- Implement trong Phase 3
- Thiết kế hình minh họa cho Situation Simulator (generic, không dùng trademark)
