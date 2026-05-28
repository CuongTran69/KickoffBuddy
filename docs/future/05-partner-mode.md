---
id: future-partner-mode
title: Watch With Partner Mode (Phase 3)
status: planned
phase: phase-3
depends-on: [feat-rule-cards, feat-vocabulary, future-fan-etiquette]
related: [future-family-mode, future-quiz-simulator]
last-updated: 2026-05-25
---

## Mục đích

Chế độ dành cho người xem cùng một người không rành bóng đá — giúp cả hai tận hưởng trận đấu mà không có khoảng cách kiến thức.

## Phạm vi

### In scope

- Chế độ "Xem cùng người mới"
- Giải thích ngắn gọn, thân thiện trong lúc xem
- Mini quiz vui trước trận
- After match: hỏi người mới học được gì

### Out of scope

- Multiplayer real-time (Phase 4)
- Chat giữa 2 người dùng

---

## User stories

- As a fan, I want a "watch with newbie" mode so that I can help my partner understand the game.
- As a new viewer, I want simple explanations during the match so that I'm not lost.

---

## Acceptance criteria

- [ ] User có thể bật "Watch With Partner" mode
- [ ] App hiển thị giải thích ngắn gọn cho các tình huống phổ biến
- [ ] Mini quiz trước trận (3-5 câu)
- [ ] After match: prompt hỏi người mới học được gì

---

## Flow

1. User chọn "Tôi đang xem cùng người mới"
2. App gợi ý các giải thích ngắn
3. App hiển thị mini quiz vui trước trận
4. Trong lúc xem: user có thể tap "Giải thích tình huống này" để mở explanation card
5. Sau trận: app hỏi người mới hiểu thêm điều gì

---

## Ví dụ giải thích

```
VAR giống như trọng tài xem lại replay để kiểm tra các tình huống lớn
như bàn thắng, penalty hoặc thẻ đỏ.
```

```
Bù giờ là thời gian được cộng thêm vì trong hiệp có các khoảng dừng
như chấn thương, thay người, VAR hoặc ăn mừng bàn thắng.
```

---

## Edge cases

- Người dùng xem một mình: không cần bật mode này
- Người mới không muốn quiz: có thể bỏ qua

## Open questions

- —

## Next steps

- Implement trong Phase 3
- Tích hợp với Fan Etiquette Guide
