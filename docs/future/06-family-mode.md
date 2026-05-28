---
id: future-family-mode
title: Family Mode (Phase 3)
status: planned
phase: phase-3
depends-on: [feat-rule-cards, feat-vocabulary]
related: [future-partner-mode, ops-accessibility]
last-updated: 2026-05-25
---

## Mục đích

Chế độ dành cho trẻ em, phụ huynh hoặc người lớn tuổi — giao diện lớn hơn, nội dung nhẹ nhàng hơn, không có nội dung không phù hợp.

## Phạm vi

### In scope

- Font lớn hơn, ít thuật ngữ kỹ thuật
- Nhiều hình minh họa
- Không chat công khai
- Không betting
- Nội dung nhẹ nhàng
- Quiz luật bóng đá cơ bản cho trẻ em

### Out of scope

- Parental controls (quá phức tạp cho Phase 3)
- Tài khoản trẻ em riêng biệt

---

## User stories

- As a parent, I want a family-friendly mode so that my child can use the app safely.
- As an older viewer, I want larger text and simpler UI so that I can use the app comfortably.

---

## Acceptance criteria

- [ ] Font size tăng ít nhất 20% so với default
- [ ] Không có nội dung betting, odds, gambling
- [ ] Không có chat công khai
- [ ] Quiz có level "trẻ em" với câu hỏi đơn giản
- [ ] Hình minh họa nhiều hơn, text ít hơn

---

## Điều chỉnh UI

| Yếu tố | Default | Family Mode |
|---|---|---|
| Font size | 14-16sp | 18-20sp |
| Thuật ngữ | Đầy đủ | Đơn giản hóa |
| Hình minh họa | Ít | Nhiều |
| Chat | Không có (MVP) | Không có |
| Betting | Không có | Không có |
| Nội dung | Trung tính | Nhẹ nhàng |

---

## Edge cases

- Người dùng chuyển qua lại giữa Family Mode và default: settings phải persist

## Open questions

- —

## Next steps

- Implement trong Phase 3
- Xem xét accessibility guidelines trong [ops-accessibility](../ops/03-accessibility.md)
