---
id: data-sources
title: Data Sources Comparison
status: planned
phase: foundational
depends-on: []
related: [data-seed-strategy, data-team-reference, arch-backend-strategy]
last-updated: 2026-05-25
---

## Mục đích

So sánh các nguồn dữ liệu lịch đấu bóng đá. Giúp quyết định nguồn nào dùng cho từng phase.

## Phạm vi

### In scope

- Nguồn CC0/free cho MVP seed
- API thương mại cho Phase 2+
- Comparison table

### Out of scope

- Live score data (ngoài scope của Kickoff Buddy)
- Dữ liệu cầu thủ/thống kê

---

## Tier 1: CC0 / Free (Dùng cho MVP)

| Nguồn | License | Nội dung | Chất lượng | Ghi chú |
|---|---|---|---|---|
| **openfootball/worldcup** | CC0 | Lịch đấu WC, kết quả | Tốt | GitHub repo, community-maintained |
| **Wikidata** | CC0 | Đội, thành phố, timezone | Tốt | SPARQL endpoint, cần query |
| **Wikipedia** | CC BY-SA | Thông tin đội, giải đấu | Tốt | Cần attribution, không CC0 |
| **flag-icons** | MIT | SVG cờ quốc gia | Tốt | Không phải federation crest |

**Khuyến nghị MVP:** openfootball + Wikidata + manual curation tên tiếng Việt.

---

## Tier 2: Freemium API (Phase 2+)

| API | Free Tier | Paid | Nội dung | Ghi chú |
|---|---|---|---|---|
| **API-Football** | 100 req/ngày | $10-50/tháng | Lịch đấu, live score, thống kê | Phổ biến, docs tốt |
| **Football-Data.org** | 10 req/phút | €10-50/tháng | Lịch đấu, kết quả | Tập trung châu Âu |
| **TheSportsDB** | Free (limited) | $5/tháng | Lịch đấu, logo đội | Logo có thể có copyright |
| **Sportmonks** | Trial | $29+/tháng | Đầy đủ nhất | Đắt, nhiều tính năng |

---

## Tier 3: Official / Licensed (Không dùng)

| Nguồn | Vấn đề |
|---|---|
| FIFA Official API | Không public, cần license |
| WC2026 Official API | Không public |
| UEFA API | Không public |
| Opta / StatsBomb | Rất đắt, dành cho media/club |

---

## Recommendation

| Phase | Nguồn | Lý do |
|---|---|---|
| MVP | openfootball + Wikidata | CC0, không cần API key, bundle trong app |
| Phase 2 | API-Football (free tier) | 100 req/ngày đủ cho basic use case |
| Phase 3+ | API-Football (paid) hoặc Football-Data.org | Nếu cần real-time data |

**Lưu ý:** Kickoff Buddy không cần live score. Chỉ cần lịch đấu (kickoff time, đội, địa điểm). API-Football free tier là đủ cho Phase 2.

---

## Flags

| Nguồn | License | Ghi chú |
|---|---|---|
| **flag-icons** (lipis/flag-icons) | MIT | SVG cờ quốc gia, không phải federation crest |
| Wikimedia Commons | CC BY-SA hoặc public domain | Cần check từng file |
| FIFA official flags | Copyright | KHÔNG dùng |
| Federation crests/logos | Copyright | KHÔNG dùng |

**Dùng `flag-icons` (MIT)** — đây là thư viện SVG cờ quốc gia chuẩn, không phải logo liên đoàn.

---

## Edge cases

- openfootball có thể chậm cập nhật lịch đấu vòng knock-out: cần manual update
- API-Football free tier có rate limit: cần cache response

## Validation: openfootball WC 2026 (confirmed 2026-05-28)

Repo `openfootball/worldcup` (CC0) đã có đầy đủ dữ liệu WC 2026 tại `2026--usa/`:

- `cup.txt` — 72 trận vòng bảng (12 nhóm A-L, 6 trận/nhóm), đầy đủ giờ UTC offset, sân, đội
- `cup_finals.txt` — 32 trận knock-out (Round of 32 → Final), đánh số match 73-103
- `cup_stadiums.csv` — 16 sân thi đấu
- Tổng: **104 trận** (72 vòng bảng + 16 Round of 32 + 8 Round of 16 + 4 QF + 2 SF + 1 3rd place + 1 Final)
- 48 đội đã liệt kê đầy đủ trong 12 nhóm
- Venue + city info có sẵn cho tất cả trận
- Giờ dùng UTC offset (ví dụ `UTC-6`), cần convert sang IANA timezone khi import

**Kết luận:** openfootball là nguồn seed chính đủ dùng cho MVP. Không cần fallback Wikidata cho lịch đấu vòng bảng. Wikidata vẫn hữu ích cho metadata đội (timezone thành phố, tên chuẩn).

**Lưu ý khi import:** openfootball dùng UTC offset tĩnh (ví dụ `UTC-6`), không phải IANA timezone. Khi convert sang `kickoffAtUtc`, cần map offset → IANA timezone theo bảng host cities trong `data/03-team-reference.md` để xử lý DST đúng.

## Open questions

- (resolved — xem Validation section bên trên)

## Next steps

- Import `cup.txt` và `cup_finals.txt` vào `assets/data/wc2026_matches.json` trước Sprint 2
- Map UTC offset → IANA timezone cho 16 host cities khi import
- Setup Wikidata SPARQL queries cho metadata đội nếu cần
- Evaluate API-Football cho Phase 2
