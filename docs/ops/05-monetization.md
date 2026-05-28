---
id: ops-monetization
title: Monetization
status: planned
phase: phase-2
depends-on: [product-roadmap, mvp-scope]
related: [future-venue-mode, ops-analytics]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa chiến lược monetization cho Kickoff Buddy. MVP hoàn toàn miễn phí. Monetization bắt đầu từ Phase 2.

## Phạm vi

### In scope

- Free tier (MVP)
- Premium subscription (Phase 2)
- One-time purchase (Phase 2)
- B2B Venue Mode (Phase 4)

### Out of scope

- Advertising (không phù hợp với positioning)
- Betting / odds (ngoài scope hoàn toàn)
- In-app currency

---

## Free Tier (MVP — tất cả miễn phí)

MVP hoàn toàn miễn phí để tối đa hóa adoption:

- Thêm không giới hạn trận
- Reminder cơ bản (1d/3h/30m/5m)
- Rule cards cơ bản (7 chủ đề)
- Vocabulary cơ bản
- Replay Planner
- WC 2026 seed

---

## Premium Tier (Phase 2)

Subscription hàng tháng hoặc hàng năm:

| Tính năng | Free | Premium |
|---|---|---|
| Số trận | Không giới hạn | Không giới hạn |
| Reminder | Cơ bản | Cơ bản + Custom messages |
| Rule cards | 7 chủ đề | Đầy đủ + Advanced level |
| Vocabulary | Cơ bản | Đầy đủ + Idioms |
| Replay Planner | Có | Có |
| Sleep Plan | Không | Có |
| Before Match Brief | Không | Có |
| After Match Learning | Không | Có |
| Quiz | Không | Có |
| Calendar export | Không | Có |
| Custom themes | Không | Có |
| Offline full rule guide | Không | Có |
| Widget | Không | Có |

**Giá gợi ý:** $2.99/tháng hoặc $19.99/năm (cần validate với thị trường VN)

---

## One-time Purchase (Phase 2)

| Item | Mô tả | Giá gợi ý |
|---|---|---|
| Remove ads | Xóa quảng cáo (nếu có) | $1.99 |
| Premium rule pack | Rule cards nâng cao | $2.99 |
| Tournament season pack | Lịch đấu + rule pack cho 1 giải | $0.99 |
| Theme pack | Custom themes | $0.99 |

---

## B2B Venue Mode (Phase 4)

Subscription cho quán cafe/sports bar:

| Tier | Giá/tháng | Tính năng |
|---|---|---|
| Basic | ~$10 | Countdown TV, QR room |
| Pro | ~$25 | + Quiz, Poll, Branding |
| Enterprise | Liên hệ | Custom features, multi-venue |

Xem chi tiết trong [future-venue-mode](../future/07-venue-mode.md).

---

## Pricing Strategy

- **Freemium:** Core features miễn phí, premium features trả phí
- **No ads trong MVP:** Tránh làm xấu UX khi mới launch
- **Giá thấp cho thị trường VN:** $2.99/tháng phù hợp hơn $9.99/tháng
- **Annual discount:** Khuyến khích subscription dài hạn

---

## Edge cases

- User hủy premium: downgrade về free tier, không mất data
- Refund request: tuân thủ chính sách App Store / Google Play

## Open questions

- Cần validate pricing với user research trước khi launch premium
- Cần xác định có dùng RevenueCat hay implement in-app purchase trực tiếp

## Next steps

- Implement free tier trong MVP
- Evaluate RevenueCat cho Phase 2 in-app purchase
- User research về willingness to pay trước Phase 2
