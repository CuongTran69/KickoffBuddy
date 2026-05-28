---
id: product-risks
title: Product Risks
status: planned
phase: foundational
depends-on: [product-vision]
related: [compliance-trademark, data-seed-strategy, product-roadmap]
last-updated: 2026-05-25
---

## Mục đích

Liệt kê và phân tích các rủi ro sản phẩm chính của Kickoff Buddy, kèm chiến lược giảm thiểu. Tài liệu này cần được review mỗi sprint để đảm bảo rủi ro được theo dõi liên tục.

## Phạm vi

### In scope

- 4 rủi ro sản phẩm chính: pháp lý, dữ liệu, scope, cạnh tranh
- Chiến lược giảm thiểu cho từng rủi ro
- Cross-link đến tài liệu liên quan

### Out of scope

- Rủi ro kỹ thuật chi tiết (xem architecture docs)
- Rủi ro vận hành (xem ops docs)
- Risk matrix định lượng (probability × impact)

---

### Risk 1: Pháp lý / Trademark

**Mô tả:** Sử dụng branding FIFA/World Cup (tên, logo, màu sắc, mascot) có thể dẫn đến app bị reject khỏi App Store/Google Play hoặc bị kiện bản quyền. FIFA enforcement đặc biệt nghiêm trong window thi đấu (tháng 6-7/2026).

**Mức độ:** Cao — ảnh hưởng trực tiếp đến khả năng publish app.

**Chiến lược giảm thiểu:**

- Tên app "Kickoff Buddy" là generic descriptor, không gắn với giải cụ thể
- Không dùng logo, cúp vàng, mascot, font chính thức của WC 2026
- Thêm disclaimer "Unofficial — not affiliated with FIFA or any football organization"
- MVP: user tự nhập lịch đấu hoặc dùng CC0 dataset (openfootball/worldcup)
- Illustration chỉ dùng hình generic (sân bóng, quả bóng generic, đồng hồ)

Xem chi tiết tại [`compliance/01-trademark.md`](../compliance/01-trademark.md).

---

### Risk 2: Dữ liệu lịch đấu

**Mô tả:** Scrape lịch đấu từ website chính thức vi phạm Terms of Service. Dữ liệu từ nguồn không chính thức có thể sai (giờ, địa điểm, đội thi đấu), gây trải nghiệm tệ cho user.

**Mức độ:** Trung bình — ảnh hưởng đến chất lượng dữ liệu và rủi ro pháp lý phụ.

**Chiến lược giảm thiểu:**

- Phase 1 (MVP): dùng [openfootball/worldcup](https://github.com/openfootball/worldcup) (CC0 license) + Wikidata (CC0)
- Phase 2+: dùng API có license rõ ràng (ví dụ: football-data.org, API-Football)
- Không scrape bất kỳ website nào nếu ToS không cho phép
- Hiển thị nguồn dữ liệu và disclaimer "Data may not be 100% accurate" trong app

Xem [`data/01-seed-strategy.md`](../data/01-seed-strategy.md) và [`data/02-data-sources.md`](../data/02-data-sources.md).

---

### Risk 3: App scope quá nhỏ

**Mô tả:** Nếu chỉ có Magic Add + countdown, app sẽ chìm giữa hàng trăm app football trên store. User không có lý do để chọn Kickoff Buddy thay vì app có sẵn.

**Mức độ:** Trung bình — ảnh hưởng đến retention và organic growth.

**Chiến lược giảm thiểu:**

Combo USP (Unique Selling Proposition) của Kickoff Buddy:

- **Replay Planner** — tính năng độc đáo, không có trên SofaScore/Onefootball
- **Vocabulary Anh-Việt** — phục vụ thị trường VN cụ thể
- **Rule Cards** — giải thích luật cho người mới, không phải thống kê
- **Sleep Plan** (Phase 2) — gợi ý lịch sinh hoạt theo giờ trận
- **WC Seed** — onboarding nhanh với lịch WC 2026 có sẵn

Định vị rõ ràng: không phải app live score, mà là **companion app** cho người mới và fan timezone-lệch.

Xem gap analysis tại [`product/01-vision.md`](../product/01-vision.md).

---

### Risk 4: Cạnh tranh với app live score

**Mô tả:** SofaScore, Onefootball, FlashScore, FIFA Official App đã chiếm lĩnh thị trường app football. Các app này có team lớn, dữ liệu real-time, và brand recognition mạnh.

**Mức độ:** Thấp-Trung bình — nếu định vị đúng thì không cạnh tranh trực tiếp.

**Chiến lược giảm thiểu:**

- KHÔNG cạnh tranh trực diện về live score, thống kê, highlight
- Định vị là **companion app** — dùng song song với app live score, không thay thế
- Target segment cụ thể: người mới xem bóng + fan ở múi giờ lệch (đặc biệt VN)
- Tập trung vào timezone management, Replay Planner và education — các gap mà app lớn không fill

Xem [`product/01-vision.md`](../product/01-vision.md) để biết gap analysis đầy đủ.

---

### Risk 5: Vietnam age rating deadline 2026-06-18

**Mô tả:** Quy định xếp hạng độ tuổi mới của Việt Nam có hiệu lực từ ngày 18/6/2026 — chỉ 7 ngày sau khi WC 2026 khai mạc (11/6/2026). App có thể bị gỡ khỏi VN App Store / Google Play giữa chừng giải đấu nếu không tuân thủ đúng hạn.

**Mức độ:** Cao — deadline cố định, không thể thương lượng. Impact: Critical nếu app bị gỡ trong window thi đấu.

**Chiến lược giảm thiểu:**

- Submit age rating questionnaire (App Store Connect + Google Play Console) trước ngày **2026-06-10** (1 ngày trước khai mạc)
- Thêm vào Sprint 5 store-submission checklist như một **hard blocker** — không release nếu chưa hoàn thành
- Review nội dung app (quiz, gamification, nội dung bạo lực/người lớn) để đảm bảo phù hợp với rating đã khai báo
- Theo dõi hướng dẫn chính thức từ Bộ TT&TT và Apple/Google về yêu cầu cụ thể cho thị trường VN

Xem checklist chi tiết tại [`compliance/02-store-review.md`](../compliance/02-store-review.md) (line 113).

---

## Edge cases

- Apple/Google thay đổi policy về app football trong window WC 2026 (tháng 6-7/2026) — cần theo dõi App Store Review Guidelines và Google Play Policy updates
- FIFA tăng cường enforcement trademark trong window thi đấu — cần review app trước khi submit, đặc biệt screenshot và app description
- Vietnam age rating thay đổi từ ngày 18/6/2026 — cần kiểm tra xem nội dung app có bị ảnh hưởng không (đặc biệt nếu có quiz hoặc gamification)
- Nguồn CC0 (openfootball) cập nhật chậm hoặc có lỗi — cần fallback plan (user tự nhập)

## Open questions

- Có nên có premium tier cho VN market không? Nếu có, tính năng nào là premium?
- Vietnam age rating change ngày 18/6/2026 ảnh hưởng đến nội dung gì trong app?
- Có nên submit app trước window WC 2026 (trước tháng 6) để tránh review backlog không?

## Next steps

- Review risks mỗi sprint (đặc biệt Risk 1 và Risk 2)
- Track app store rejection metrics sau khi submit
- Theo dõi FIFA trademark enforcement news trong Q1-Q2 2026
- Xem [`compliance/02-store-review.md`](../compliance/02-store-review.md) để biết checklist trước khi submit
