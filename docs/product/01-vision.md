---
id: product-vision
title: Product Vision
status: planned
phase: foundational
depends-on: []
related: [product-problems, product-roadmap, mvp-scope, glossary]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa lý do tồn tại của Kickoff Buddy, định vị sản phẩm và mô tả 4 persona người dùng chính.

## Phạm vi

### In scope

- One-liner và positioning statement
- 3P framework (Plan / Protect / Understand)
- 4 user personas
- Competitive landscape

### Out of scope

- Roadmap chi tiết (xem [product-roadmap](03-roadmap.md))
- Feature spec (xem [mvp-scope](../mvp/00-scope.md))

---

## One-liner

> Kickoff Buddy helps international football fans plan kickoff times, avoid spoilers, and understand match rules in minutes.

## Positioning

Kickoff Buddy **không phải** app xem tỉ số. Đây là app giúp người xem bóng đá thông minh hơn, đúng giờ hơn và hiểu trận đấu hơn.

App không định vị là app chính thức của bất kỳ giải đấu nào. Không livestream, không highlight, không dùng logo/tài sản chính thức, không betting. Tập trung vào trải nghiệm "đồng hành cùng người xem".

---

## 3P Framework

Ba lớp giá trị cốt lõi:

| Layer | Tên | Mô tả |
|---|---|---|
| 1 | **Plan** | Biết trận diễn ra lúc nào theo local time. Đặt nhắc lịch. Chọn live hoặc replay. |
| 2 | **Protect** | Tránh bị lộ kết quả nếu không xem trực tiếp. Replay Planner. |
| 3 | **Understand** | Hiểu luật, tình huống và thuật ngữ khi xem. Rule Cards. Vocabulary. |

---

## 4 User Personas

### Persona 1: Người mới xem bóng đá

**Ví dụ:** Bạn gái/bạn trai xem cùng người yêu. Người chỉ xem dịp giải lớn. Người không hiểu offside, VAR, penalty.

**Nhu cầu:**
- Giải thích ngắn, dễ hiểu, có ví dụ trực quan
- Không cần thống kê chuyên sâu
- Có thể tra cứu nhanh trong lúc xem
- Không bị "ngơ" khi xem cùng nhóm bạn

**Feature phù hợp:** Rule Cards (newbie level), Vocabulary, Why Did That Happen

---

### Persona 2: Fan ở múi giờ lệch

**Ví dụ:** Người Việt Nam xem trận diễn ra ở Mỹ, Canada, Mexico hoặc châu Âu. Người bận đi làm nhưng vẫn muốn xem trận quan trọng.

**Nhu cầu:**
- Đổi giờ trận sang local time chính xác (kể cả DST)
- Reminder trước trận
- Kế hoạch xem lại không bị spoil
- Calendar export

**Feature phù hợp:** Match Scheduler, Reminders, Replay Planner, Sleep Plan (Phase 2)

---

### Persona 3: Người xem cùng bạn bè / gia đình

**Nhu cầu:**
- Giải thích luật cho người mới trong nhóm
- Quiz vui trước trận hoặc giữa giờ
- Từ điển thuật ngữ Anh - Việt
- Etiquette khi xem chung

**Feature phù hợp:** Rule Cards, Vocabulary, Fan Etiquette (Phase 2), Quiz (Phase 3), Partner Mode (Phase 3)

---

### Persona 4: Phụ huynh / trẻ em

**Nhu cầu:**
- Nội dung nhẹ nhàng, dễ hiểu
- Không betting, không chat công khai
- Giao diện lớn, rõ ràng
- Quiz luật bóng đá cơ bản

**Feature phù hợp:** Rule Cards (newbie), Vocabulary, Family Mode (Phase 3)

---

## Competitive Landscape

Nghiên cứu thị trường (2026-05-25):

| App | Điểm mạnh | Điểm yếu | Liên quan đến KB |
|---|---|---|---|
| FIFA Official App | Brand chính thức, live score | Rating 1.5/5 trên App Store, nặng, phức tạp | KB không cạnh tranh trực tiếp |
| Apple Sports | Tích hợp iOS, clean UI | Không có timezone converter, không có rule guide | Gap: timezone + education |
| Turf (football social) | Community, social features | Không có timezone, không có rule guide | Khác segment |
| Learn The Pitch | Rule education | Không có match scheduler, không có timezone | Overlap: education |
| IFAB Rules App | Luật chính thức đầy đủ | Quá kỹ thuật, không thân thiện người mới | KB dùng IFAB làm nguồn, không cạnh tranh |
| Live score apps (SofaScore, etc.) | Real-time data | Quá chuyên sâu, không phù hợp người mới | KB là companion, không phải replacement |

**Kết luận:** Không có app nào kết hợp timezone converter + spoiler protection + rule education cho người mới. Đây là white space của Kickoff Buddy.

---

## Mục tiêu sản phẩm

### Mục tiêu chính

- Giúp người dùng biết trận mình muốn xem diễn ra lúc mấy giờ theo local time
- Đặt nhắc lịch và theo dõi countdown bằng notification/widget
- Giúp người xem ở múi giờ lệch có kế hoạch xem lại
- Giúp người mới hiểu nhanh các luật phổ biến qua ví dụ đời thường
- Tạo trải nghiệm "match preparation" khác biệt với live score app

### Mục tiêu phụ

- Dùng được quanh năm cho nhiều giải bóng đá, không chỉ World Cup
- Dễ upload lên App Store/Google Play nhờ tránh trademark và nội dung bản quyền
- MVP đủ nhỏ để làm nhanh bằng Flutter (1 developer, 3-5 tuần)
- Có khả năng mở rộng thành quiz, simulator, partner mode, venue mode

---

## Edge cases

- Người dùng ở quốc gia không có DST: timezone handling vẫn phải đúng
- Người dùng thay đổi timezone thiết bị sau khi đã lưu trận: cần recalculate display time
- Người dùng không biết tiếng Anh: UI tiếng Việt là default

## Open questions

- —

## Next steps

- Validate personas với user research khi có beta tester
- Cập nhật competitive landscape sau khi app ra mắt
