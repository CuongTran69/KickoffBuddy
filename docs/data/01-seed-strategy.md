---
id: data-seed-strategy
title: WC 2026 Seed Strategy
status: planned
phase: mvp
depends-on: [arch-data-model]
related: [data-sources, data-team-reference, feat-match-scheduler]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa cách seed 104 trận World Cup 2026 vào app từ nguồn CC0, không cần license từ FIFA. Dữ liệu được bundle trong app, không cần API call.

## Phạm vi

### In scope

- Nguồn dữ liệu CC0: openfootball/worldcup + Wikidata
- Schema mapping từ nguồn → Match model
- Tên đội tiếng Việt (manual curation)
- Update mechanism
- Validation

### Out of scope

- Live score / real-time data
- Official FIFA data
- Scraping từ nguồn không cho phép

---

## Nguồn dữ liệu

### 1. openfootball/worldcup (CC0)

- URL: https://github.com/openfootball/worldcup
- License: CC0 (public domain)
- Nội dung: lịch đấu, kết quả, đội tuyển
- Format: plain text (.txt) và JSON
- Cập nhật: community-maintained

### 2. Wikidata (CC0)

- URL: https://www.wikidata.org
- License: CC0
- SPARQL endpoint: https://query.wikidata.org
- Dùng để lấy: tên đội đầy đủ, thành phố, IANA timezone của sân

### 3. Manual curation — Tên tiếng Việt

- Tên đội tiếng Việt không có nguồn CC0 chuẩn
- Cần manual curation cho 48 đội
- Nguồn tham khảo: Wikipedia tiếng Việt, báo thể thao Việt Nam
- Lưu trong file riêng: `assets/data/team_names_vi.json`

---

## 104 Trận WC 2026

### Cấu trúc giải đấu

| Vòng | Số trận | Ghi chú |
|---|---|---|
| Vòng bảng (Group Stage) | 72 | 12 nhóm × 3 trận × 2 = 72 |
| Vòng 32 (Round of 32) | 32 | Mới — 48 đội, top 2 + 8 best 3rd |
| Vòng 16 (Round of 16) | 16 | |
| Tứ kết (Quarter-final) | 8 | |
| Bán kết (Semi-final) | 4 | |
| Tranh hạng 3 | 1 | |
| Chung kết (Final) | 1 | |
| **Tổng** | **104** | |

**Lưu ý:** WC 2026 có thêm Round of 32 — vòng đấu mới so với các kỳ trước (trước đây là Round of 16 trực tiếp).

### Thời gian

- Khai mạc: 11/6/2026
- Chung kết: 19/7/2026
- Địa điểm: 16 thành phố tại Mỹ, Canada, Mexico

---

## Schema Mapping

### openfootball → Match model

```
openfootball format:
"Group A: Argentina vs Saudi Arabia  21:00  Lusail"

→ Match model:
{
  "teamA": "Argentina",
  "teamB": "Saudi Arabia",
  "kickoffAtUtc": "2026-06-12T14:00:00Z",  // 21:00 local → UTC
  "venueCity": "Lusail",
  "venueIanaTimezone": "America/Los_Angeles",  // từ Wikidata
  "worldCupGroup": "A",
  "worldCupRound": "group_stage",
  "tournamentId": "wc2026",
  "isSeeded": true
}
```

### Wikidata SPARQL query (ví dụ)

```sparql
SELECT ?city ?timezone WHERE {
  ?city wdt:P31 wd:Q515 .
  ?city wdt:P421 ?timezone .
  VALUES ?city { wd:Q65 }  # Los Angeles
}
```

---

## Tên đội tiếng Việt

File `assets/data/team_names_vi.json`:

```json
{
  "Argentina": "Argentina",
  "Brazil": "Brazil",
  "France": "Pháp",
  "Germany": "Đức",
  "Spain": "Tây Ban Nha",
  "England": "Anh",
  "Portugal": "Bồ Đào Nha",
  "Netherlands": "Hà Lan",
  "USA": "Mỹ",
  "Mexico": "Mexico",
  "Canada": "Canada",
  "Japan": "Nhật Bản",
  "South Korea": "Hàn Quốc",
  "Australia": "Úc",
  "Vietnam": "Việt Nam",
  ...
}
```

**Lưu ý:** Một số tên đội có thể cần curation thêm (ví dụ: tên đội châu Phi ít phổ biến). Đánh dấu `"needsReview": true` trong file nếu chưa chắc.

---

## Update Mechanism

### MVP: Bundle trong app

- Dữ liệu seed được bundle trong `assets/data/wc2026_matches.json`
- Cập nhật qua app update (không cần OTA update)
- Phù hợp vì lịch đấu WC 2026 đã cố định

### Phase 2: Remote config (nếu cần)

- Nếu lịch đấu thay đổi (hoãn, đổi sân): cần mechanism update
- Option: Firebase Remote Config hoặc Cloudflare KV
- Chỉ implement nếu thực sự cần

---

## Validation

Trước khi bundle:

- [ ] 104 trận đủ, không thiếu, không trùng
- [ ] Tất cả `kickoffAtUtc` là UTC hợp lệ
- [ ] Tất cả `venueIanaTimezone` là IANA timezone hợp lệ
- [ ] Tất cả `worldCupGroup` là A-L
- [ ] Tất cả `worldCupRound` là giá trị hợp lệ
- [ ] Tên đội nhất quán (không có "USA" và "United States" lẫn lộn)

---

## Attribution

Trong About screen của app:

```
Dữ liệu lịch đấu World Cup 2026 từ openfootball (CC0) và Wikidata (CC0).
Kickoff Buddy không phải sản phẩm chính thức của FIFA.
```

---

## Edge cases

- Lịch đấu vòng knock-out chưa biết đội: lưu giá trị thực `"TBD vs TBD"` trong field `title`, update khi có kết quả vòng trước. (Đây là giá trị data thực, không phải placeholder của docs.)
- Trận bị hoãn: cần app update để cập nhật

## Open questions

- Cần xác nhận 48 đội tham dự WC 2026 (qualification chưa hoàn tất tại thời điểm viết docs)

## Next steps

- Download và parse openfootball/worldcup data
- Chạy Wikidata SPARQL để lấy timezone cho 16 thành phố
- Manual curation tên tiếng Việt cho 48 đội
- Validate và bundle trước Sprint 2
