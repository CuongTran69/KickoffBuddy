---
id: feat-match-scheduler
title: Match Scheduler
status: planned
phase: mvp
depends-on: [mvp-scope, arch-data-model, arch-time-handling, data-seed-strategy]
related: [feat-reminders, feat-replay-planner, future-magic-add-llm]
last-updated: 2026-05-25
---

## Mục đích

Tính năng cốt lõi của Kickoff Buddy: cho phép người dùng thêm và quản lý lịch trận đấu với 3 chế độ nhập liệu. Luôn lưu kickoff theo UTC, chỉ convert sang local time khi hiển thị.

## Phạm vi

### In scope

- Chế độ 1: WC 2026 seed (104 trận pre-loaded từ CC0)
- Chế độ 2: Manual Add (form nhập tay)
- Chế độ 3: Magic Add Lite (regex offline)
- Confirm screen (bắt buộc, không bỏ qua)
- Match list và match detail
- Countdown display

### Out of scope

- Magic Add LLM (Phase 2 — xem [future-magic-add-llm](../../future/01-magic-add-llm.md))
- Calendar export (Phase 2)
- Scrape lịch đấu tự động
- Live score / live data

---

## User stories

- As a fan, I want WC 2026 matches pre-loaded so that I don't have to enter 104 matches manually.
- As a fan, I want to add a match by pasting text so that I can quickly add matches from messages or websites.
- As a fan, I want to manually enter match details so that I can add any match from any tournament.
- As a fan, I want to always confirm parsed match info before saving so that I don't save wrong data.
- As a fan, I want to see match kickoff time in my local timezone so that I know exactly when to watch.

---

## Acceptance criteria

- [ ] 104 trận WC 2026 hiển thị đúng trong match list khi mở app lần đầu
- [ ] Manual Add form có đủ các trường bắt buộc: Đội A, Đội B, Ngày, Giờ, Timezone gốc
- [ ] Magic Add Lite nhận diện được 7 pattern (xem bảng bên dưới)
- [ ] Confidence score được tính và hiển thị cảnh báo phù hợp
- [ ] Confirm screen luôn hiển thị, có nút Sửa và Lưu trận
- [ ] Kickoff được lưu theo UTC trong database
- [ ] Hiển thị local time được convert đúng (kể cả DST)
- [ ] Countdown hiển thị ngay sau khi lưu trận
- [ ] Cảnh báo hiển thị khi trận rơi vào đêm khuya (22:00–05:00 local)

---

## Chế độ 1: WC 2026 Seed

104 trận World Cup 2026 được seed sẵn từ nguồn CC0 (openfootball/worldcup + Wikidata). Chi tiết xem [data-seed-strategy](../../data/01-seed-strategy.md).

Người dùng có thể:
- Browse danh sách trận theo ngày / vòng đấu / đội
- Thêm trận vào "My Matches" để theo dõi
- Đặt reminder cho trận đã chọn

---

## Chế độ 2: Manual Add

Dùng khi người dùng không có text để paste, hoặc muốn nhập chính xác từ đầu.

```
┌─────────────────────────────────────────────────────┐
│                  Add Match Screen                   │
├──────────────────────┬──────────────────────────────┤
│   ✨ Magic Add       │   ✏️ Manual Add              │
│   (Smart Paste)      │   (Form nhập tay)            │
└──────────────────────┴──────────────────────────────┘
```

### Các trường Manual Add

| Trường | Bắt buộc | Ghi chú |
|---|---|---|
| Tên trận | Không | Tự động tạo từ "Đội A vs Đội B" nếu để trống |
| Đội A | Có | |
| Đội B | Có | |
| Ngày kickoff | Có | Date picker |
| Giờ kickoff | Có | Time picker |
| Timezone gốc | Có | Dropdown, default = timezone phổ biến của giải |
| Timezone người dùng | Tự động | Lấy từ profile, user có thể override |
| Ghi chú cá nhân | Không | Free text |
| Bật Replay Planner | Không | Toggle, default = off |

---

## Chế độ 3: Magic Add Lite (Regex Offline)

Parser chạy hoàn toàn trên thiết bị, không cần mạng, không tốn chi phí API.

### Flow Magic Add Lite

```
User copy text
      │
      ▼
Mở app → bấm "Magic Add"
      │
      ▼
App đọc clipboard tự động
(hoặc user paste thủ công nếu từ chối clipboard permission)
      │
      ▼
┌─────────────────────────────┐
│  Parser Layer (offline)     │
│  Regex + rule-based         │
│  - "vs", "8PM", "BST"       │
│  - Ngày tháng phổ biến      │
│  - Timezone abbreviation    │
└──────────┬──────────────────┘
           │
     Confidence score?
     ┌─────┴──────┐
   HIGH          LOW / MISSING FIELDS
     │                │
     ▼                ▼
  Dùng kết quả   Hiển thị form với
  parser          các trường còn trống
      │
      ▼
Màn hình Confirm (luôn hiển thị)
```

**Lưu ý MVP:** Khi confidence thấp, Magic Add Lite KHÔNG gọi LLM. Chỉ mở form với các trường đã điền được. LLM là Phase 2 (xem [future-magic-add-llm](../../future/01-magic-add-llm.md)).

### 7 Regex Patterns

| Pattern | Ví dụ | Kết quả |
|---|---|---|
| `Team A vs Team B` | `Man Utd vs Arsenal` | teamA, teamB |
| `Team A - Team B` | `Argentina - Brazil` | teamA, teamB |
| `HH:MM TZ` | `20:00 BST` | time, timezone |
| `H:MM AM/PM TZ` | `8PM ET` | time, timezone |
| `Xh sáng/tối giờ VN` | `2h sáng giờ VN` | time, timezone=Asia/Ho_Chi_Minh |
| Ngày trong tuần | `Sunday`, `Thứ Bảy` | dayOfWeek |
| Ngày tháng | `June 20`, `20/6` | date |

### Timezone Abbreviation Map (MVP)

| Abbreviation | IANA Timezone | Ghi chú |
|---|---|---|
| BST | Europe/London | UTC+1, summer |
| GMT | Europe/London | UTC+0 |
| ET | America/New_York | |
| EST | America/New_York | UTC-5 |
| EDT | America/New_York | UTC-4, summer |
| CT | America/Chicago | |
| PT | America/Los_Angeles | |
| ICT | Asia/Bangkok | UTC+7 |
| VN / giờ VN | Asia/Ho_Chi_Minh | |
| WIB | Asia/Jakarta | |
| JST | Asia/Tokyo | |
| KST | Asia/Seoul | |

### Confidence Scoring

| Level | Điều kiện | Hành động |
|---|---|---|
| HIGH (≥ 0.8) | Có đủ teamA, teamB, time, date, timezone | Dùng kết quả parser |
| MEDIUM (0.5–0.8) | Có time + date nhưng thiếu timezone | Dùng kết quả + cảnh báo timezone |
| LOW (< 0.5) | Chỉ có một phần, hoặc ngày mơ hồ | Mở form với các trường đã điền được |

---

## Confirm Screen (bắt buộc)

Luôn hiển thị màn hình xác nhận trước khi lưu, dù parse thành công 100%.

```
┌─────────────────────────────────────────┐
│  Magic Add — Xác nhận thông tin         │
├─────────────────────────────────────────┤
│  Trận:   Man Utd vs Arsenal             │
│  Ngày:   Chủ Nhật, 22/6/2026           │
│  Giờ gốc: 20:00 BST                    │
│  Giờ của bạn: 02:00 sáng, 23/6/2026   │
│           (Asia/Ho_Chi_Minh)            │
│                                         │
│  Trận này rơi vào đêm trước ngày       │
│  làm việc. Bật Replay Planner?          │
│     ○ Có   ● Không                      │
├─────────────────────────────────────────┤
│  Nguồn text gốc (để kiểm tra):         │
│  "Man Utd vs Arsenal 20:00 BST Sunday" │
│                              [Xóa text] │
├─────────────────────────────────────────┤
│        [Sửa]        [Lưu trận]         │
└─────────────────────────────────────────┘
```

### Cảnh báo trên Confirm Screen

| Tình huống | Cảnh báo |
|---|---|
| Thiếu timezone | "Mình đoán timezone là [X]. Bạn kiểm tra lại nhé." |
| Ngày mơ hồ ("Sunday") | "Mình hiểu là Chủ Nhật ngày [DD/MM]. Đúng không?" |
| Trận rơi vào đêm khuya | "Trận này lúc 02:00 sáng. Bật Replay Planner?" |
| Trận đã qua | "Trận này có vẻ đã diễn ra rồi. Bạn muốn lưu để xem lại?" |
| Parse confidence thấp | "Mình không chắc về [field]. Bạn kiểm tra lại trước khi lưu." |

---

## Nguyên tắc kỹ thuật

- Luôn lưu kickoff theo UTC. Chỉ convert sang local time khi hiển thị.
- Không tự động lưu sau khi parse — Confirm screen là bắt buộc.
- Không scrape lịch đấu từ nguồn bên ngoài. Magic Add chỉ xử lý text user chủ động cung cấp.
- Lưu `sourceText` để user có thể kiểm tra lại, nhưng cho phép xóa bất kỳ lúc nào.
- Không gửi `sourceText` lên server (MVP không có backend).
- DST: dùng package `timezone` với IANA database, không hardcode offset.
- Ambiguous date: nếu user nhập "Sunday" mà không có năm/tháng, tính Sunday gần nhất trong tương lai.

---

## Edge cases

| Edge case | Xử lý |
|---|---|
| Input không có thông tin trận | "Mình không tìm thấy thông tin trận trong đoạn này. Bạn thử nhập thủ công nhé." |
| Có nhiều hơn 1 trận trong text | Parse trận đầu tiên, thông báo: "Mình thấy có thể có nhiều trận." |
| Timezone không có trong map | Hỏi user: "Timezone [X] mình chưa nhận ra. Bạn chọn timezone đúng nhé." |
| Giờ đã qua | Cảnh báo, hỏi user có muốn lưu để xem lại không |
| Input quá dài (> 500 ký tự) | Cắt bớt, ưu tiên 200 ký tự đầu |
| Clipboard rỗng | Hiển thị text field để user paste thủ công |
| Không có quyền đọc clipboard (iOS) | Hiển thị text field, không yêu cầu permission lại |

## Open questions

- —

## Next steps

- Implement regex parser trong Sprint 2
- Seed WC 2026 data (xem [data-seed-strategy](../../data/01-seed-strategy.md))
- Viết unit test cho từng regex pattern và confidence scoring
