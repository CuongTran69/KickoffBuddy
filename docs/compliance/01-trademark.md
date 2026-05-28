---
id: compliance-trademark
title: Trademark Guidelines
status: planned
phase: compliance
depends-on: []
related: [compliance-store-review, compliance-store-listing, product-vision]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa các quy tắc trademark để Kickoff Buddy tránh vi phạm pháp lý và được chấp nhận trên App Store / Google Play.

## Phạm vi

### In scope

- FIFA và World Cup trademark
- UEFA và các liên đoàn khác
- App name và icon guidelines
- Descriptive use vs trademark use
- Disclaimer bắt buộc

### Out of scope

- Copyright cho nội dung (xem [content-strategy](../content/01-content-strategy.md))
- Privacy law

---

## Tên thương hiệu cần tránh

### Tuyệt đối không dùng trong app name, icon, screenshot

| Tên | Chủ sở hữu | Lý do |
|---|---|---|
| FIFA | FIFA | Registered trademark |
| World Cup | FIFA | Registered trademark |
| FIFA World Cup | FIFA | Registered trademark |
| UEFA | UEFA | Registered trademark |
| Champions League | UEFA | Registered trademark |
| Premier League | Premier League Ltd | Registered trademark |
| La Liga | RFEF | Registered trademark |
| Bundesliga | DFL | Registered trademark |

### Không dùng visual assets

- Logo FIFA, cúp vàng FIFA, mascot chính thức
- Logo UEFA, Champions League trophy
- Logo các liên đoàn quốc gia
- Ảnh cầu thủ/đội tuyển có bản quyền
- Font chữ chính thức của giải đấu
- Poster/banner chính thức

---

## Descriptive Use (Hợp lệ)

Dùng tên thương hiệu để **mô tả** sản phẩm/dịch vụ là hợp lệ:

| Hợp lệ | Không hợp lệ |
|---|---|
| "Lịch trận World Cup 2026" trong mô tả app | "World Cup 2026 Official App" |
| "Xem trận FIFA World Cup" trong mô tả | App name: "FIFA Buddy" |
| "Hỗ trợ theo dõi các giải UEFA" | Icon có logo UEFA |
| "Unofficial football companion" | Không có disclaimer |

---

## App Name: "Kickoff Buddy"

"Kickoff Buddy" là tên an toàn vì:
- "Kickoff" là từ thông thường trong bóng đá, không phải trademark
- "Buddy" là từ thông thường
- Không gây nhầm lẫn với app chính thức của bất kỳ tổ chức nào

**Tên thay thế an toàn (nếu cần):**
- Match Time Buddy
- Football Watch Guide
- Soccer Companion
- Kickoff Guide

---

## Cờ quốc gia

| Nguồn | Hợp lệ | Ghi chú |
|---|---|---|
| `flag-icons` (lipis/flag-icons) | Có | MIT license, cờ quốc gia generic |
| Wikimedia Commons SVG | Thường có | Check từng file, nhiều là public domain |
| Federation crests/logos | Không | Copyright của liên đoàn |
| FIFA official flags | Không | Copyright của FIFA |

**Dùng `flag-icons` (MIT)** — cờ quốc gia generic, không phải logo liên đoàn.

---

## Disclaimer Bắt buộc

Phải hiển thị trong About screen và store listing:

```
Kickoff Buddy is an unofficial football companion app. It is not affiliated with,
endorsed by, or sponsored by any tournament organizer, football federation, team,
club, broadcaster, or governing body. All trademarks belong to their respective owners.
```

Tiếng Việt:
```
Kickoff Buddy là app đồng hành bóng đá không chính thức. App không liên kết, được
chứng nhận hoặc tài trợ bởi bất kỳ ban tổ chức giải đấu, liên đoàn bóng đá, đội
tuyển, câu lạc bộ, đài truyền hình hoặc tổ chức quản lý nào. Tất cả thương hiệu
thuộc về chủ sở hữu tương ứng.
```

---

## Checklist trước khi submit

- [ ] App name không chứa FIFA, World Cup, UEFA hoặc tên giải đấu chính thức
- [ ] App icon không chứa logo, cúp, mascot chính thức
- [ ] Screenshots không chứa trademark
- [ ] Store description dùng descriptive use, không gây nhầm lẫn official
- [ ] Disclaimer hiển thị trong About screen
- [ ] Không có ảnh cầu thủ/đội tuyển có bản quyền
- [ ] Cờ quốc gia từ nguồn MIT/CC0, không phải federation crest

---

## Edge cases

- User upload ảnh có trademark (nếu có UGC feature): cần moderation
- Store reviewer có thể hỏi về trademark: chuẩn bị response template

## Open questions

- —

## Next steps

- Review checklist này trước Sprint 5 (store submission)
- Chuẩn bị response template nếu store reviewer hỏi về trademark
