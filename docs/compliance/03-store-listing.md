---
id: compliance-store-listing
title: Store Listing
status: planned
phase: compliance
depends-on: [compliance-trademark, compliance-store-review]
related: [product-vision]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa nội dung store listing cho App Store và Google Play. Tối ưu cho discovery mà không vi phạm trademark.

## Phạm vi

### In scope

- App name và subtitle
- Short description và full description
- Keywords (App Store)
- Screenshots guidance
- Privacy Policy

### Out of scope

- ASO (App Store Optimization) chi tiết
- Paid UA campaigns

---

## App Name

**Primary:** `Kickoff Buddy`

**Alternatives (nếu cần):**
- Match Time Buddy
- Football Watch Guide
- Soccer Companion
- Kickoff Guide

---

## Subtitle (App Store — max 30 ký tự)

```
Football rules & match planner
```

(30 ký tự — đúng giới hạn App Store)

Alternatives đã loại:
- ~~`Match times, rules & spoiler shield`~~ — 36 ký tự (vượt limit) + dùng tên cũ "spoiler shield"
- ~~`Plan matches, learn football rules`~~ — 34 ký tự (vượt limit)

---

## Short Description (Google Play — max 80 ký tự)

```
Plan football match times, avoid spoilers, and learn the rules in minutes.
```

---

## Full Description

### Tiếng Anh

```
Kickoff Buddy helps international football fans plan match times, set reminders,
avoid spoilers, and learn football rules through simple guides and vocabulary cards.

Perfect for:
• Fans watching matches across time zones
• New viewers who want to understand the game
• Anyone who wants to watch replays without being spoiled

KEY FEATURES:

⏰ Match Scheduler
• World Cup 2026 matches pre-loaded (104 matches)
• Add any match manually or via Smart Paste (Magic Add)
• Automatic timezone conversion — no more confusion with BST, ET, or ICT

🔔 Smart Reminders
• Default reminders: 1 day, 3 hours, 30 minutes, 5 minutes before kickoff
• Custom reminder messages
• Works offline, no internet required

🛡️ Replay Planner
• Plan your replay time so you can watch without being spoiled
• App hides match results until you're ready
• Reminder at your planned replay time

📚 Football Rules in 5 Minutes
• Simple explanations for offside, VAR, penalty, cards, stoppage time, extra time
• 3 levels: Newbie, Casual, Advanced
• "Why Did That Happen?" — quick lookup during a match

🔤 Football Vocabulary
• English-Vietnamese football dictionary
• Search in English or Vietnamese
• Example sentences from real commentary

DISCLAIMER: Kickoff Buddy is an unofficial football companion app. Not affiliated with
FIFA, UEFA, or any tournament organizer. All trademarks belong to their respective owners.
```

### Tiếng Việt

```
Kickoff Buddy giúp người xem bóng đá quốc tế lên kế hoạch xem trận, đặt nhắc lịch,
tránh bị spoil và hiểu luật bóng đá qua các thẻ giải thích đơn giản.

Phù hợp với:
• Fan xem trận ở múi giờ lệch
• Người mới xem bóng đá muốn hiểu luật
• Người muốn xem lại trận mà không bị lộ kết quả

TÍNH NĂNG CHÍNH:

⏰ Lịch trận
• 104 trận World Cup 2026 được tải sẵn
• Thêm trận thủ công hoặc qua Magic Add (dán text)
• Tự động đổi múi giờ — không còn nhầm BST, ET hay ICT

🔔 Nhắc lịch thông minh
• Nhắc mặc định: 1 ngày, 3 giờ, 30 phút, 5 phút trước trận
• Tin nhắn nhắc tùy chỉnh
• Hoạt động offline, không cần mạng

🛡️ Replay Planner
• Lên kế hoạch xem lại để không bị spoil
• App ẩn kết quả cho đến khi bạn sẵn sàng
• Nhắc vào giờ xem lại đã chọn

📚 Luật bóng đá trong 5 phút
• Giải thích đơn giản: việt vị, VAR, penalty, thẻ phạt, bù giờ, hiệp phụ
• 3 cấp độ: Người mới, Fan thỉnh thoảng, Fan hiểu bóng đá
• "Vì sao vậy?" — tra cứu nhanh trong lúc xem

🔤 Từ điển bóng đá Anh - Việt
• Từ điển thuật ngữ bóng đá
• Tìm kiếm bằng tiếng Anh hoặc tiếng Việt
• Ví dụ câu từ bình luận thực tế

TUYÊN BỐ: Kickoff Buddy là app đồng hành bóng đá không chính thức. Không liên kết với
FIFA, UEFA hoặc bất kỳ ban tổ chức giải đấu nào.
```

---

## Keywords (App Store — max 100 ký tự)

```
football rules,soccer rules,kickoff time,match reminder,spoiler free,offside guide,penalty guide
```

(96 ký tự — trong giới hạn 100 của App Store)

**Đã loại để giữ ≤ 100 ký tự** (có thể xoay vòng theo mùa):
- `football vocabulary` (19 ký tự) — đã có trong description, ít search volume
- `VAR guide` (9 ký tự) — gộp vào `offside guide` về mặt search intent

**Tránh keyword:**
- FIFA (trademark)
- World Cup official (misleading)
- Official tournament app (misleading)
- Live stream (không có tính năng này)
- Betting (không có tính năng này)

---

## Screenshots Guidance

### Thứ tự screenshots (App Store: tối đa 10, Google Play: tối đa 8)

1. Match list với WC 2026 seed + countdown
2. Magic Add / Manual Add screen
3. Reminder settings
4. Replay Planner screen
5. Rule Cards (offside explanation)
6. Vocabulary screen
7. Onboarding screen

### Yêu cầu screenshots

- Không có trademark FIFA/World Cup trong UI
- Dùng tên đội generic hoặc tên đội thực (không có logo)
- Không có ảnh cầu thủ có bản quyền
- Dark mode (phù hợp với positioning)
- Tiếng Việt (thị trường chính)

---

## Privacy Policy

Phải có trước khi submit. Nội dung tối thiểu:

- Dữ liệu thu thập: timezone, football level, match data (local only)
- Dữ liệu KHÔNG thu thập: tên thật, email, location, contacts
- Clipboard: chỉ đọc khi user bấm Magic Add
- Analytics: Firebase Analytics (anonymized)
- Third-party: Firebase (Google)
- Contact: [email]

---

## Edge cases

- App Store reject vì description: chuẩn bị response template (xem [compliance-store-review](02-store-review.md))
- Keyword bị reject: có danh sách backup keywords

## Open questions

- —

## Next steps

- Viết Privacy Policy đầy đủ trước Sprint 5
- Tạo screenshots trong Sprint 5
- Submit store listing trong Sprint 5
