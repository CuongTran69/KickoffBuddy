---
id: future-venue-mode
title: Venue Mode (Phase 4)
status: planned
phase: phase-4
depends-on: [feat-rule-cards, future-quiz-simulator]
related: [ops-monetization]
last-updated: 2026-05-25
---

## Mục đích

Phiên bản B2B dành cho quán cafe/sports bar — tạo trải nghiệm xem bóng tập thể với countdown, quiz giữa giờ và branding của quán.

## Phạm vi

### In scope

- QR code để khách join match room
- Countdown hiển thị trên TV
- Quiz luật bóng đá giữa giờ
- Poll dự đoán vui (không tiền thật)
- Rule explanation card cho người mới
- Branding của quán (logo, màu sắc)

### Out of scope

- Betting / odds / tiền thật
- Livestream
- POS integration
- Quản lý đặt bàn

---

## User stories

- As a cafe owner, I want to display a match countdown on my TV so that customers know when the match starts.
- As a cafe owner, I want to run a quiz during halftime so that customers stay engaged.
- As a customer, I want to join the venue's match room via QR so that I can participate in polls and quizzes.

---

## Acceptance criteria

- [ ] QR code tạo được match room
- [ ] Countdown hiển thị full-screen trên TV (landscape mode)
- [ ] Quiz giữa giờ: ít nhất 5 câu hỏi
- [ ] Poll: tối đa 4 lựa chọn, không tiền thật
- [ ] Branding: upload logo quán, chọn màu sắc

---

## B2B Monetization

Venue Mode là tính năng trả phí (B2B subscription):

| Tier | Giá | Tính năng |
|---|---|---|
| Basic | ~$10/tháng | Countdown TV, QR room |
| Pro | ~$25/tháng | + Quiz, Poll, Branding |
| Enterprise | Liên hệ | Custom features, multi-venue |

Xem chi tiết trong [ops-monetization](../ops/05-monetization.md).

---

## Edge cases

- Mất mạng tại quán: countdown vẫn hoạt động (offline), quiz/poll cần mạng
- Nhiều quán dùng cùng lúc: cần backend scale

## Open questions

- Cần xác định pricing phù hợp với thị trường Việt Nam
- Cần spike để đánh giá complexity của TV mode

## Next steps

- Implement trong Phase 4
- Nghiên cứu thị trường sports bar Việt Nam trước khi build
