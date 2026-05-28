---
id: data-team-reference
title: Team Reference (48 Teams + 16 Host Cities)
status: planned
phase: mvp
depends-on: [data-seed-strategy]
related: [feat-match-scheduler, ops-i18n]
last-updated: 2026-05-25
---

## Mục đích

Bảng tham chiếu chính thức 48 đội tham dự WC 2026 (đã xác nhận), phân nhóm A-L, kèm FIFA code, ISO alpha-2 code, tên tiếng Anh và tên tiếng Việt chuẩn theo báo chí bóng đá Việt Nam. Dùng để validate seed data, curation i18n và hiển thị trong app.

## Phạm vi

### In scope

- 48 đội trong 12 nhóm A-L (4 đội/nhóm) — đã xác nhận
- FIFA 3-letter code và ISO 3166-1 alpha-2 code
- Tên tiếng Việt chuẩn (curated)
- Đánh dấu đội lần đầu dự World Cup (debutant)
- 16 thành phố tổ chức + IANA timezone
- Cấu trúc giải đấu (104 trận, vòng 32 mới)

### Out of scope

- Thống kê đội, lịch sử tham dự
- Danh sách cầu thủ
- Lịch thi đấu chi tiết (xem `feat-match-scheduler`)

---

## 48 Đội — Phân nhóm A-L

Ký hiệu: `†` = lần đầu dự World Cup (debutant)

### Nhóm A

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| MEX | MX | Mexico | Mexico |
| RSA | ZA | South Africa | Nam Phi |
| KOR | KR | South Korea | Hàn Quốc |
| CZE | CZ | Czechia | Cộng Hòa Séc |

### Nhóm B

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| CAN | CA | Canada | Canada |
| SUI | CH | Switzerland | Thụy Sĩ |
| QAT | QA | Qatar | Qatar |
| BIH | BA | Bosnia and Herzegovina | Bosnia & Herzegovina |

### Nhóm C

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| BRA | BR | Brazil | Brazil |
| MAR | MA | Morocco | Maroc |
| HAI | HT | Haiti | Haiti |
| SCO | GB-SCT | Scotland | Scotland |

### Nhóm D

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| USA | US | USA | Mỹ |
| PAR | PY | Paraguay | Paraguay |
| AUS | AU | Australia | Úc |
| TUR | TR | Türkiye | Thổ Nhĩ Kỳ |

### Nhóm E

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| GER | DE | Germany | Đức |
| CUW | CW | Curaçao † | Curaçao |
| CIV | CI | Ivory Coast | Bờ Biển Ngà |
| ECU | EC | Ecuador | Ecuador |

### Nhóm F

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| NED | NL | Netherlands | Hà Lan |
| JPN | JP | Japan | Nhật Bản |
| TUN | TN | Tunisia | Tunisia |
| SWE | SE | Sweden | Thụy Điển |

### Nhóm G

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| BEL | BE | Belgium | Bỉ |
| EGY | EG | Egypt | Ai Cập |
| IRN | IR | Iran | Iran |
| NZL | NZ | New Zealand | New Zealand |

### Nhóm H

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| ESP | ES | Spain | Tây Ban Nha |
| CPV | CV | Cape Verde † | Cape Verde |
| KSA | SA | Saudi Arabia | Ả Rập Xê Út |
| URU | UY | Uruguay | Uruguay |

### Nhóm I

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| FRA | FR | France | Pháp |
| SEN | SN | Senegal | Senegal |
| NOR | NO | Norway | Na Uy |
| IRQ | IQ | Iraq | Iraq |

### Nhóm J

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| ARG | AR | Argentina | Argentina |
| ALG | DZ | Algeria | Algeria |
| AUT | AT | Austria | Áo |
| JOR | JO | Jordan † | Jordan |

### Nhóm K

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| POR | PT | Portugal | Bồ Đào Nha |
| UZB | UZ | Uzbekistan † | Uzbekistan |
| COL | CO | Colombia | Colombia |
| COD | CD | DR Congo | CHDC Congo |

### Nhóm L

| FIFA Code | ISO alpha-2 | Tên tiếng Anh | Tên tiếng Việt |
|---|---|---|---|
| ENG | GB-ENG | England | Anh |
| CRO | HR | Croatia | Croatia |
| GHA | GH | Ghana | Ghana |
| PAN | PA | Panama | Panama |

---

## Đội lần đầu dự World Cup (Debutants)

| FIFA Code | Tên tiếng Anh | Nhóm |
|---|---|---|
| CPV | Cape Verde | H |
| CUW | Curaçao | E |
| JOR | Jordan | J |
| UZB | Uzbekistan | K |

---

## 16 Host Cities & IANA Timezone

| Thành phố | Quốc gia | IANA Timezone | UTC Offset (mùa hè) |
|---|---|---|---|
| New York / New Jersey | Mỹ | America/New_York | UTC-4 (EDT) |
| Los Angeles | Mỹ | America/Los_Angeles | UTC-7 (PDT) |
| Dallas | Mỹ | America/Chicago | UTC-5 (CDT) |
| San Francisco / Bay Area | Mỹ | America/Los_Angeles | UTC-7 (PDT) |
| Miami | Mỹ | America/New_York | UTC-4 (EDT) |
| Atlanta | Mỹ | America/New_York | UTC-4 (EDT) |
| Seattle | Mỹ | America/Los_Angeles | UTC-7 (PDT) |
| Houston | Mỹ | America/Chicago | UTC-5 (CDT) |
| Kansas City | Mỹ | America/Chicago | UTC-5 (CDT) |
| Philadelphia | Mỹ | America/New_York | UTC-4 (EDT) |
| Boston | Mỹ | America/New_York | UTC-4 (EDT) |
| Toronto | Canada | America/Toronto | UTC-4 (EDT) |
| Vancouver | Canada | America/Vancouver | UTC-7 (PDT) |
| Guadalajara | Mexico | America/Mexico_City | UTC-5 (CDT) |
| Mexico City | Mexico | America/Mexico_City | UTC-5 (CDT) |
| Monterrey | Mexico | America/Monterrey | UTC-5 (CDT) |

**Lưu ý DST:** Tất cả thành phố Mỹ và Canada áp dụng DST vào mùa hè (tháng 6-7). Phải dùng IANA timezone, không hardcode offset.

---

## Múi giờ Việt Nam so với các sân

| Thành phố | IANA Timezone | Giờ VN khi trận 20:00 local |
|---|---|---|
| New York | America/New_York (EDT) | 08:00 sáng hôm sau |
| Los Angeles | America/Los_Angeles (PDT) | 11:00 sáng hôm sau |
| Dallas | America/Chicago (CDT) | 09:00 sáng hôm sau |
| Toronto | America/Toronto (EDT) | 08:00 sáng hôm sau |
| Mexico City | America/Mexico_City (CDT) | 09:00 sáng hôm sau |

**Ý nghĩa:** Hầu hết trận WC 2026 sẽ diễn ra vào sáng sớm giờ Việt Nam (6:00-12:00). Đây là lý do Replay Planner quan trọng.

---

## Cấu trúc giải đấu WC 2026

```
48 đội → 12 nhóm (A-L) × 4 đội/nhóm
         ↓
Vòng bảng: 72 trận (mỗi nhóm 6 trận)
         ↓
Vòng 32 (Round of 32): 32 trận  ← vòng mới, lần đầu có ở WC 2026
  - Top 2 mỗi nhóm = 24 đội
  - 8 đội hạng 3 tốt nhất = 8 đội
  - Tổng: 32 đội
         ↓
Vòng 16 (Round of 16): 16 trận
         ↓
Tứ kết: 8 trận
         ↓
Bán kết: 4 trận
         ↓
Tranh hạng 3: 1 trận
Chung kết: 1 trận
         ↓
Tổng: 104 trận
```

---

## Edge cases

- Scotland không có ISO 3166-1 alpha-2 standalone; dùng subdivision code `GB-SCT`. England tương tự dùng `GB-ENG`. App cần xử lý riêng khi render flag icon.
- Tên "Türkiye" (không phải "Turkey") là tên chính thức FIFA từ 2022. Tên tiếng Việt chuẩn là "Thổ Nhĩ Kỳ".
- "Ivory Coast" là tên FIFA; tên chính thức quốc gia là "Côte d'Ivoire". Tên tiếng Việt chuẩn là "Bờ Biển Ngà".
- "DR Congo" (FIFA: COD) phân biệt với "Congo" (FIFA: CGO). Tên tiếng Việt: "CHDC Congo".
- Đội rút lui hoặc bị loại sau khi seed: cần app update cơ chế thay thế.
- Debutants (Cape Verde, Curaçao, Jordan, Uzbekistan) có thể thiếu dữ liệu lịch sử trong một số API.

## Open questions

- Tên tiếng Việt "Maroc" vs "Morocco": báo chí VN dùng "Maroc" (theo tiếng Pháp) — đã xác nhận dùng "Maroc".
- Tên "Thổ Nhĩ Kỳ" cho Türkiye — đã xác nhận là chuẩn theo báo chí bóng đá VN.
- Một số đội (Bosnia & Herzegovina, DR Congo) có tên dài — cần truncation strategy trong UI.

## Next steps

- Validate bảng nhóm với nguồn openfootball/worldcup CC0 khi có dữ liệu chính thức
- Curation flag asset cho 4 debutants (đặc biệt GB-SCT, GB-ENG)
- Xem `data/01-seed-strategy.md` để biết quy trình import
