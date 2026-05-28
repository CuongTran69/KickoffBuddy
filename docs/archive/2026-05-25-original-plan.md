> **ARCHIVE NOTE:** This is the original 2026-05-25 plan. Superseded by the structured docs above. Kept for reference.

# Kickoff Buddy — Product Plan

> **Unofficial football companion app** giúp người xem bóng đá quốc tế xem đúng giờ, tránh bị spoil, hiểu luật nhanh và tự tin hơn khi xem cùng bạn bè.

---

## 1. Tóm tắt sản phẩm

**Kickoff Buddy** là app Flutter kết hợp 2 ý tưởng:

1. **Football Timezone Buddy** — đổi giờ trận đấu theo múi giờ cá nhân, nhắc lịch, đếm ngược trên màn hình khóa/widget, gợi ý lịch ngủ/xem lại, chống spoil.
2. **Football Etiquette & Rules Buddy** — trợ lý AI giải thích luật bóng đá, thuật ngữ, tình huống trọng tài và văn hóa xem bóng linh hoạt cho người mới.

App không định vị là app chính thức của bất kỳ giải đấu nào. Không livestream, không highlight, không dùng logo/tài sản chính thức, không betting. Sản phẩm tập trung vào trải nghiệm “đồng hành cùng người xem”.

### Định vị ngắn

> Không phải app xem tỉ số. Đây là app giúp bạn xem bóng đá thông minh hơn, đúng giờ hơn và hiểu trận đấu hơn.

### One-liner

> Kickoff Buddy helps international football fans plan kickoff times, avoid spoilers, and understand match rules in minutes.

---

## 2. Mục tiêu sản phẩm

### Mục tiêu chính

- Giúp người dùng biết trận mình muốn xem diễn ra lúc mấy giờ theo local time.
- Giúp người dùng đặt nhắc lịch trước trận và theo dõi countdown bằng notification/widget; riêng iOS có thể mở rộng bằng Live Activities.
- Giúp người xem ở múi giờ lệch có kế hoạch ngủ, thức xem hoặc xem lại.
- Trợ lý AI/LLM giúp người mới hiểu nhanh các luật phổ biến như offside, VAR, penalty, stoppage time, extra time, penalty shootout qua ví dụ đời thường.
- Tạo một trải nghiệm “match preparation” khác biệt với các app live score.

### Mục tiêu phụ

- Có thể dùng quanh năm cho nhiều giải bóng đá, không chỉ mùa World Cup.
- Dễ upload lên App Store/Google Play nhờ tránh trademark và nội dung bản quyền.
- MVP đủ nhỏ để làm nhanh bằng Flutter.
- Có thể tích hợp native module cho các tính năng đặc thù nền tảng: iOS Live Activities/WidgetKit, Android Glance/App Widgets.
- Có khả năng mở rộng thành quiz, simulator, partner mode, venue mode.

---

## 3. Người dùng mục tiêu

## 3.1. Người mới xem bóng đá

Ví dụ:

- Người chỉ xem bóng dịp giải lớn.
- Bạn gái/bạn trai xem cùng người yêu.
- Người không hiểu offside, VAR, penalty, hiệp phụ.
- Người xem cùng nhóm bạn nhưng không muốn bị “ngơ”.

Nhu cầu:

- Giải thích ngắn, dễ hiểu.
- Có ví dụ trực quan.
- Không cần thống kê chuyên sâu.
- Có thể tra cứu nhanh trong lúc xem.

## 3.2. Fan ở múi giờ lệch

Ví dụ:

- Người Việt Nam xem các trận diễn ra ở Mỹ, Canada, Mexico hoặc châu Âu.
- Người bận đi làm nhưng vẫn muốn xem trận quan trọng.
- Người không thể thức khuya và muốn xem lại mà không bị spoil.

Nhu cầu:

- Đổi giờ trận sang local time.
- Reminder trước trận.
- Gợi ý sleep plan.
- No spoiler mode.
- Calendar export.

## 3.3. Người xem cùng bạn bè/gia đình

Nhu cầu:

- Giải thích luật cho người mới.
- Quiz vui trước trận hoặc giữa giờ.
- Từ điển thuật ngữ Anh - Việt.
- Etiquette khi xem chung.

## 3.4. Phụ huynh/trẻ em

Nhu cầu:

- Nội dung nhẹ nhàng, dễ hiểu.
- Không betting, không chat công khai.
- Giao diện lớn, rõ ràng.
- Quiz luật bóng đá cơ bản.

---

## 4. Vấn đề người dùng

### Problem 1: Lệch múi giờ

Người dùng biết có trận hay nhưng không chắc trận đó rơi vào mấy giờ ở Việt Nam/local time. Việc tự đổi giờ dễ sai, đặc biệt khi có daylight saving time.

### Problem 2: Không muốn bị spoil

Nhiều trận diễn ra lúc đêm muộn. Người dùng muốn xem lại vào sáng hôm sau nhưng rất dễ bị lộ kết quả qua notification, mạng xã hội, bạn bè hoặc app thể thao.

### Problem 3: Không hiểu luật khi xem

Người mới thường gặp các câu hỏi:

- Sao bàn thắng bị hủy?
- Sao lại việt vị?
- Sao có VAR?
- Sao được penalty?
- Sao bù giờ tận 8 phút?
- Sao hết 90 phút vẫn đá tiếp?

### Problem 4: App live score quá chuyên sâu

Các app như live score, thống kê, line-up, xG, news thường phục vụ fan đã hiểu bóng đá. Người mới cần app giải thích và chuẩn bị trước trận, không cần quá nhiều số liệu.

---

## 5. Giá trị cốt lõi

Kickoff Buddy giải quyết bằng 3 lớp giá trị:

1. **Plan** — biết trận diễn ra lúc nào, đặt nhắc lịch, chọn live hoặc replay.
2. **Protect** — tránh bị spoil nếu không xem trực tiếp.
3. **Understand** — hiểu luật, tình huống và thuật ngữ khi xem.

---

## 6. Tính năng chính

## 6.1. Smart Kickoff Time & Magic Add

### Mô tả

Người dùng thêm trận đấu thủ công hoặc cực nhanh thông qua **Magic Add / Smart Paste**. App tự nhận diện thông tin trong đoạn text người dùng copy, bóc tách dữ liệu, chuẩn hóa thời gian và đổi sang múi giờ cá nhân.

Tính năng này giúp MVP khác biệt hơn so với form nhập liệu thông thường: người dùng có thể copy lịch từ web, tin nhắn bạn bè, bài post, email hoặc note cá nhân rồi paste vào app.

---

### Hai chế độ nhập liệu

```
┌─────────────────────────────────────────────────────┐
│                  Add Match Screen                   │
├──────────────────────┬──────────────────────────────┤
│   ✨ Magic Add       │   ✏️ Manual Add              │
│   (Smart Paste)      │   (Form nhập tay)            │
│                      │                              │
│  Paste text bất kỳ  │  Điền từng trường            │
│  → App tự bóc tách  │  → Không cần mạng            │
│  → Confirm & lưu    │  → Luôn hoạt động            │
└──────────────────────┴──────────────────────────────┘
```

---

### Flow Magic Add — Chi tiết

```
User copy text
      │
      ▼
Mở app → bấm “Magic Add”
      │
      ▼
App đọc clipboard tự động
(hoặc user paste thủ công nếu từ chối clipboard permission)
      │
      ▼
┌─────────────────────────────┐
│  Parser Layer (offline)     │  ← thử trước, không tốn tiền
│  Regex + rule-based         │
│  - “vs”, “8PM”, “BST”       │
│  - Ngày tháng phổ biến      │
│  - Timezone abbreviation    │
└──────────┬──────────────────┘
           │
     Confidence score?
     ┌─────┴──────┐
   HIGH          LOW / MISSING FIELDS
     │                │
     ▼                ▼
  Dùng kết quả   Gọi LLM API (online)
  parser          để bóc tách thêm
                       │
                       ▼
                  Vẫn thiếu?
                  → Hiển thị form
                    với các trường
                    còn trống để
                    user điền tay
      │
      ▼
Màn hình Confirm (luôn hiển thị)
  - Tên trận
  - Giờ local đã convert
  - Timezone gốc đã detect
  - Cảnh báo nếu có ambiguity
      │
      ▼
User xác nhận → Lưu match
```

---

### Parser Layer (Offline — ưu tiên dùng trước)

Parser chạy hoàn toàn trên thiết bị, không cần mạng, không tốn chi phí API.

**Các pattern parser nhận diện được:**

| Pattern | Ví dụ | Kết quả |
|---|---|---|
| `Team A vs Team B` | `Man Utd vs Arsenal` | teamA, teamB |
| `Team A - Team B` | `Argentina - Brazil` | teamA, teamB |
| `HH:MM TZ` | `20:00 BST` | time, timezone |
| `H:MM AM/PM TZ` | `8PM ET` | time, timezone |
| `Xh sáng/tối giờ VN` | `2h sáng giờ VN` | time, timezone=Asia/Ho_Chi_Minh |
| Ngày trong tuần | `Sunday`, `Thứ Bảy` | dayOfWeek |
| Ngày tháng | `June 20`, `20/6` | date |
| Timezone abbreviation | `BST`, `ET`, `ICT`, `UTC+7` | timezone |

**Timezone abbreviation map (MVP):**

```
BST  → Europe/London (UTC+1, summer)
GMT  → Europe/London (UTC+0)
ET   → America/New_York
EST  → America/New_York (UTC-5)
EDT  → America/New_York (UTC-4, summer)
CT   → America/Chicago
PT   → America/Los_Angeles
ICT  → Asia/Bangkok (UTC+7)
VN / giờ VN → Asia/Ho_Chi_Minh
WIB  → Asia/Jakarta
JST  → Asia/Tokyo
KST  → Asia/Seoul
```

**Confidence scoring:**

```
HIGH   (≥ 0.8): có đủ teamA, teamB, time, date, timezone
MEDIUM (0.5–0.8): có time + date nhưng thiếu timezone
LOW    (< 0.5): chỉ có một phần, hoặc ngày mơ hồ
```

- `HIGH` → dùng kết quả parser, không gọi LLM
- `MEDIUM` → dùng kết quả parser + hiển thị cảnh báo timezone
- `LOW` → thử gọi LLM nếu có mạng, nếu không thì mở form với các trường đã điền được

---

### LLM Layer (Online — chỉ dùng khi parser không đủ)

**Khi nào gọi LLM:**
- Parser confidence < 0.5
- Thiếu timezone và không thể suy luận từ context
- Input là câu tự nhiên phức tạp (tiếng Việt, tiếng Anh lẫn lộn, viết tắt không chuẩn)

**Prompt template gửi LLM:**

```
Extract football match information from this text.
Return JSON only. If a field cannot be determined, return null.

Text: “{userInput}”

User's local timezone: “{userTimezone}”
Today's date: “{todayDate}”

Return:
{
  “teamA”: string | null,
  “teamB”: string | null,
  “date”: “YYYY-MM-DD” | null,
  “time”: “HH:MM” | null,
  “sourceTimezone”: “IANA timezone string” | null,
  “confidence”: “high” | “medium” | “low”,
  “ambiguities”: [“list of unclear parts”]
}
```

**Chi phí và giới hạn:**
- Dùng model nhỏ (ví dụ: `claude-haiku` hoặc `gpt-4o-mini`) để giảm chi phí
- Mỗi request ước tính < 200 token input + 100 token output → < $0.001/lần
- Rate limit phía client: tối đa 10 lần Magic Add/ngày ở free tier
- Timeout: 5 giây — nếu quá thời gian, fallback về form thủ công
- Không gửi thông tin nhạy cảm; chỉ gửi đoạn text user cung cấp

**Offline fallback:**
- Nếu không có mạng và parser confidence thấp → mở form với các trường đã điền được, các trường còn lại để trống cho user điền tay
- Không block user, không hiển thị lỗi đáng sợ

---

### Màn hình Confirm (bắt buộc, không bỏ qua)

Luôn hiển thị màn hình xác nhận trước khi lưu, dù parse thành công 100%.

```
┌─────────────────────────────────────────┐
│  ✨ Magic Add — Xác nhận thông tin      │
├─────────────────────────────────────────┤
│  Trận:   Man Utd vs Arsenal             │
│  Ngày:   Chủ Nhật, 22/6/2026           │
│  Giờ gốc: 20:00 BST                    │
│  Giờ của bạn: 02:00 sáng, 23/6/2026   │
│           (Asia/Ho_Chi_Minh)            │
│                                         │
│  ⚠️ Trận này rơi vào đêm trước ngày   │
│     làm việc. Bật No Spoiler Mode?      │
│     ○ Có   ● Không                      │
├─────────────────────────────────────────┤
│  Nguồn text gốc (để kiểm tra):         │
│  “Man Utd vs Arsenal 20:00 BST Sunday” │
│                              [Xóa text] │
├─────────────────────────────────────────┤
│        [Sửa]        [Lưu trận]         │
└─────────────────────────────────────────┘
```

**Các cảnh báo hiển thị trên màn hình Confirm:**

| Tình huống | Cảnh báo |
|---|---|
| Thiếu timezone | “Mình đoán timezone là [X]. Bạn kiểm tra lại nhé.” |
| Ngày mơ hồ (“Sunday”) | “Mình hiểu là Chủ Nhật ngày [DD/MM]. Đúng không?” |
| Trận rơi vào đêm khuya | “Trận này lúc 02:00 sáng. Bật No Spoiler Mode?” |
| Trận đã qua | “Trận này có vẻ đã diễn ra rồi. Bạn muốn lưu để xem lại?” |
| Parse confidence thấp | “Mình không chắc về [field]. Bạn kiểm tra lại trước khi lưu.” |

---

### Input thủ công (Manual Add)

Dùng khi user không có text để paste, hoặc muốn nhập chính xác từ đầu.

**Các trường:**

| Trường | Bắt buộc | Ghi chú |
|---|---|---|
| Tên trận | Không | Tự động tạo từ “Đội A vs Đội B” nếu để trống |
| Đội A | Có | |
| Đội B | Có | |
| Ngày kickoff | Có | Date picker |
| Giờ kickoff | Có | Time picker |
| Timezone gốc | Có | Dropdown, default = timezone phổ biến của giải |
| Timezone người dùng | Tự động | Lấy từ profile, user có thể override |
| Ghi chú cá nhân | Không | Free text |
| Bật No Spoiler | Không | Toggle, default = off |

---

### Sub-features liên quan

**Countdown & Reminder:**
- Countdown hiển thị ngay sau khi lưu trận
- Reminder mặc định: 1 ngày, 3 giờ, 30 phút trước trận
- User có thể tùy chỉnh reminder ngay trên màn hình Confirm

**Cảnh báo lịch sinh hoạt:**
- Nếu trận rơi vào 22:00–05:00 theo local time → gợi ý Sleep Plan
- Nếu trận rơi vào đêm trước ngày làm việc (Mon–Fri) → cảnh báo thêm

**Calendar Export (Phase 2):**
- Tạo file `.ics` với thông tin trận đã convert sang local time
- Share intent để thêm vào Google Calendar / Apple Calendar

**Widget & Live Activities (Phase 2):**
- Lock Screen / Home Screen Widget: hiển thị countdown trận sắp tới
- iOS Live Activities: countdown trên Dynamic Island (native module)
- Android Glance Widget: countdown trên home screen

---

### Nguyên tắc kỹ thuật

- **Luôn lưu kickoff theo UTC.** Chỉ convert sang local time khi hiển thị.
- **Không tự động lưu** sau khi parse — màn hình Confirm là bắt buộc.
- **Không scrape** lịch đấu từ nguồn bên ngoài. Magic Add chỉ xử lý text user chủ động cung cấp.
- **Lưu `sourceText`** để user có thể kiểm tra lại, nhưng cho phép xóa bất kỳ lúc nào.
- **Không gửi `sourceText` lên server** trừ khi cần gọi LLM — và chỉ gửi đúng đoạn text đó, không kèm thông tin cá nhân khác.
- **Daylight Saving Time:** dùng package `timezone` với IANA database, không tự hardcode offset.
- **Ambiguous date resolution:** nếu user nhập “Sunday” mà không có năm/tháng, app tính Sunday gần nhất trong tương lai và hiển thị ngày cụ thể để confirm.

---

### Các edge case cần xử lý

| Edge case | Xử lý |
|---|---|
| Input không có thông tin trận nào | Hiển thị: “Mình không tìm thấy thông tin trận trong đoạn này. Bạn thử nhập thủ công nhé.” |
| Có nhiều hơn 1 trận trong text | Parse trận đầu tiên, thông báo: “Mình thấy có thể có nhiều trận. Bạn kiểm tra lại nhé.” |
| Timezone không có trong map | Hỏi user: “Timezone [X] mình chưa nhận ra. Bạn chọn timezone đúng nhé.” |
| Giờ đã qua (trận hôm qua) | Cảnh báo, hỏi user có muốn lưu để xem lại không |
| Input quá dài (> 500 ký tự) | Cắt bớt trước khi gửi LLM, ưu tiên 200 ký tự đầu |
| Clipboard rỗng | Hiển thị text field để user paste thủ công |
| Không có quyền đọc clipboard (iOS) | Hiển thị text field, không yêu cầu permission lại |
| Mất mạng khi đang gọi LLM | Fallback về form với các trường parser đã điền được |

---

### Fallback messages

```text
// Parse thất bại hoàn toàn
Mình chưa chắc giờ trận trong đoạn này.
Bạn kiểm tra lại ngày, giờ và múi giờ trước khi lưu nhé.

// Thiếu timezone
Mình không tìm thấy timezone trong đoạn này.
Mình đoán là [timezone phổ biến]. Bạn xác nhận lại nhé.

// Mất mạng, không gọi được LLM
Không có kết nối mạng. Bạn điền thêm các trường còn thiếu nhé.

// Nhiều trận trong text
Mình thấy có thể có nhiều trận trong đoạn này.
Mình chỉ lấy trận đầu tiên. Bạn kiểm tra lại nhé.
```

---

## 6.2. Reminder Modes

### Reminder cơ bản

- 1 ngày trước trận.
- 3 giờ trước trận.
- 30 phút trước trận.
- 5 phút trước trận.

### Reminder tùy chỉnh

Người dùng có thể chọn:

- Nhắc chuẩn bị đồ ăn.
- Nhắc ngủ trước.
- Nhắc bật TV/livestream hợp pháp.
- Nhắc xem replay.

### Notification copy mẫu

```text
Trận của bạn bắt đầu sau 30 phút. Mở Kickoff Buddy để xem 5-minute rule brief.
```

```text
Bạn định xem lại trận này lúc 07:00. No Spoiler Mode đang bật.
```

---

## 6.3. No Spoiler Mode

### Mô tả

Chế độ dành cho người không xem live và muốn xem lại sau.

### Flow

1. User chọn trận.
2. User chọn “I will watch replay later”.
3. App hỏi giờ dự kiến xem lại.
4. App ẩn mọi trạng thái có thể lộ kết quả.
5. App chỉ nhắc người dùng xem lại vào giờ đã chọn.
6. Sau khi user bấm “Đã xem”, app mới mở journal/recap cá nhân.

### Nội dung hiển thị khi No Spoiler bật

```text
Trận này đang được bảo vệ khỏi spoil.
Bạn dự kiến xem lại lúc 07:00.
```

Không hiển thị:

- Tỉ số.
- Trạng thái thắng/thua.
- Từ khóa như “eliminated”, “won”, “lost”.
- Recap.

### Checklist chống spoil

- Tắt notification từ app thể thao khác.
- Hạn chế mở mạng xã hội.
- Nhắn bạn bè không spoil.
- Chọn nguồn xem lại hợp pháp.

---

## 6.4. Sleep Plan

### Mô tả

App gợi ý lịch ngủ/xem phù hợp với giờ trận.

### Các mode

#### Hardcore Fan

Dành cho người muốn xem live bằng mọi giá.

Ví dụ:

```text
Trận bắt đầu lúc 02:00.
Gợi ý: ngủ từ 21:30 đến 01:30, xem trận, sau đó ngủ bù nếu có thể.
```

#### Balanced

Dành cho người vẫn cần giữ sức.

```text
Trận bắt đầu lúc 02:00.
Bạn có thể ngủ sớm, thức xem hiệp 2 hoặc xem lại vào sáng mai.
```

#### Healthy Replay

Dành cho người ưu tiên giấc ngủ.

```text
Trận này quá muộn. Gợi ý bật No Spoiler Mode và xem lại lúc 07:00.
```

### Lưu ý

Sleep Plan chỉ là gợi ý sinh hoạt cá nhân, không phải tư vấn y tế.

---

## 6.5. 5-Minute Rule Brief

### Mô tả

Trước mỗi trận, app hiển thị một gói học luật ngắn trong 5 phút.

### Nội dung MVP

- Offside.
- Penalty.
- VAR.
- Yellow card / red card.
- Stoppage time.
- Extra time.
- Penalty shootout.

### Format card

Mỗi card gồm:

- Tên luật.
- Giải thích 1 câu.
- Ví dụ đời thường.
- Khi nào thường xuất hiện.
- Nút “Xem chi tiết”.

### Ví dụ card

```text
Offside trong 10 giây
Một cầu thủ có thể bị việt vị nếu đứng gần khung thành đối phương hơn bóng và hậu vệ áp chót tại thời điểm đồng đội chuyền bóng, rồi tham gia vào pha bóng.
```

---

## 6.6. Why Did That Happen?

### Mô tả

Nút tra cứu nhanh khi người dùng thấy một tình huống khó hiểu trong trận.

### Các tình huống phổ biến

- Vì sao bàn thắng bị hủy?
- Vì sao bị thổi việt vị?
- Vì sao có penalty?
- Vì sao VAR can thiệp?
- Vì sao có thẻ vàng?
- Vì sao có thẻ đỏ?
- Vì sao bù giờ nhiều?
- Vì sao trận có hiệp phụ?
- Vì sao phải đá luân lưu?
- Vì sao thủ môn bị phạt khi bắt penalty?

### UX

User bấm vào câu hỏi → app mở explanation card → có ví dụ và hình minh họa đơn giản.

---

## 6.7. Football Vocabulary Anh - Việt

### Mô tả

Từ điển thuật ngữ bóng đá cho người xem stream/commentary tiếng Anh.

### Nội dung MVP

| English | Vietnamese |
|---|---|
| Kickoff | Bắt đầu trận |
| Offside | Việt vị |
| Penalty | Phạt đền |
| Penalty shootout | Đá luân lưu |
| Extra time | Hiệp phụ |
| Added time / Stoppage time | Bù giờ |
| Handball | Lỗi chạm tay |
| Foul | Phạm lỗi |
| Booking | Thẻ phạt |
| Yellow card | Thẻ vàng |
| Red card | Thẻ đỏ |
| Equalizer | Bàn gỡ hòa |
| Own goal | Phản lưới nhà |
| Clean sheet | Giữ sạch lưới |
| Corner kick | Phạt góc |
| Goal kick | Phát bóng lên |
| Throw-in | Ném biên |

### Feature mở rộng

- “He was miles offside” nghĩa là gì?
- “Clinical finish” nghĩa là gì?
- “Parking the bus” nghĩa là gì?
- “Man of the match” nghĩa là gì?

---

## 6.8. Fan Etiquette Guide

### Mô tả

Không chỉ giải thích luật, app còn hướng dẫn văn hóa xem bóng.

### Nội dung

- Không spoil kết quả cho người xem lại.
- Không tranh cãi quá căng khi xem chung.
- Cách giải thích luật cho người mới mà không tỏ ra khó chịu.
- Cách xem bóng ở quán/cafe/sports bar.
- Khi nào nên reo hò, khi nào nên tôn trọng người khác.
- Vì sao fan phản ứng với trọng tài.
- Vì sao cầu thủ câu giờ.

---

## 7. Các ý tưởng mở rộng

## 7.1. Explain Like I’m New

Người dùng chọn level hiểu bóng đá:

- Newbie.
- Casual fan.
- Advanced fan.

Cùng một khái niệm nhưng app giải thích theo level.

### Ví dụ: Offside

#### Newbie

```text
Cầu thủ không được đứng chờ sẵn quá gần khung thành đối phương khi đồng đội chuyền bóng.
```

#### Casual

```text
Một cầu thủ có thể bị việt vị nếu đứng dưới hậu vệ áp chót tại thời điểm đồng đội chuyền bóng và tham gia vào pha bóng.
```

#### Advanced

```text
Offside còn phụ thuộc vào việc cầu thủ có interfering with play, interfering with opponent hoặc gaining advantage hay không.
```

---

## 7.2. Watch With Partner Mode

### Mô tả

Chế độ dành cho người xem cùng một người không rành bóng đá.

### Flow

1. User chọn “I’m watching with a newbie”.
2. App gợi ý các giải thích ngắn.
3. App hiển thị mini quiz vui trước trận.
4. Sau trận, app hỏi người mới hiểu thêm điều gì.

### Ví dụ giải thích

```text
VAR giống như trọng tài xem lại replay để kiểm tra các tình huống lớn như bàn thắng, penalty hoặc thẻ đỏ.
```

```text
Bù giờ là thời gian được cộng thêm vì trong hiệp có các khoảng dừng như chấn thương, thay người, VAR hoặc ăn mừng bàn thắng.
```

---

## 7.3. Situation Simulator

### Mô tả

Mô phỏng luật bằng hình ảnh đơn giản.

### Simulator nên làm

- Offside simulator.
- Penalty scenario.
- Handball scenario.
- Goal kick vs corner.
- Throw-in.
- Back pass to goalkeeper.
- Advantage rule.

### Gameplay

App hiển thị một tình huống, hỏi:

```text
Tình huống này có việt vị không?
A. Có
B. Không
```

Sau khi user trả lời, app giải thích.

---

## 7.4. Before Match Brief

### Mô tả

Tự động tạo brief ngắn trước trận.

### Ví dụ

```text
Bạn cần biết trước khi xem trận này:

- Trận bắt đầu lúc 02:00 giờ Việt Nam.
- Nếu đây là vòng knock-out, có thể có hiệp phụ và luân lưu.
- 3 luật dễ gặp: offside, VAR, penalty.
- Nên bật báo thức lúc 01:30.
- Nếu không thức được, bật No Spoiler Mode.
```

---

## 7.5. After Match Learning

### Mô tả

Sau trận, app hỏi người dùng gặp tình huống nào khó hiểu.

### Options

- VAR hủy bàn thắng.
- Penalty.
- Thẻ đỏ.
- Offside.
- Bù giờ nhiều.
- Hiệp phụ.
- Luân lưu.

### Gamification

- Học 5 luật: New Fan.
- Học 20 thuật ngữ: Commentary Ready.
- Xem 5 trận không bị spoil: Replay Master.
- Thức xem 3 trận khuya: Night Owl Fan.

---

## 7.6. Family Mode

### Mô tả

Chế độ cho trẻ em, phụ huynh hoặc người lớn tuổi.

### Điều chỉnh UI

- Font lớn hơn.
- Ít thuật ngữ.
- Nhiều hình minh họa.
- Không chat công khai.
- Không betting.
- Nội dung nhẹ nhàng.

---

## 7.7. Venue Mode

### Mô tả

Phiên bản dành cho quán cafe/sports bar.

### Tính năng

- QR để khách join match room.
- Countdown lên TV.
- Quiz luật bóng đá giữa giờ.
- Poll dự đoán vui, không tiền thật.
- Rule explanation card cho người mới.
- Branding của quán.

---

## 8. MVP đề xuất

## MVP Version 1

Nên tập trung vào 5 tính năng:

1. Manual Match Scheduler.
2. Local Time Converter + Reminder.
3. No Spoiler Mode.
4. 5-Minute Rule Cards.
5. Football Vocabulary Anh - Việt.

### Không nên làm trong MVP

- Live score.
- Highlight/video.
- Betting/odds.
- User chat public.
- Scrape lịch đấu tự động.
- Dùng logo/asset chính thức.
- Situation simulator phức tạp.

### Lý do

MVP này đủ khác biệt, nhỏ gọn, ít rủi ro pháp lý, dễ build bằng Flutter và không cần dữ liệu chính thức.

---

## 9. Roadmap

## Phase 1 — MVP

Thời lượng gợi ý: 3-5 tuần nếu 1 developer Flutter.

### Scope

- Onboarding.
- Chọn timezone.
- Thêm trận thủ công.
- Countdown.
- Reminder local notification.
- No Spoiler Mode.
- Rule cards cơ bản.
- Vocabulary cơ bản.
- Profile local.

### Deliverable

- Android internal test.
- iOS TestFlight.
- Privacy Policy.
- Store screenshots generic.

---

## Phase 2 — Engagement

### Scope

- Sleep Plan.
- Before Match Brief.
- After Match Learning.
- Quiz cơ bản.
- Badge.
- Calendar export.
- Cloud sync optional.

---

## Phase 3 — Differentiation

### Scope

- Situation Simulator.
- Watch With Partner Mode.
- Family Mode.
- Advanced vocabulary.
- Custom themes.
- Share cards.

---

## Phase 4 — Monetization/B2B

### Scope

- Premium subscription.
- Venue Mode.
- QR room.
- Quiz for cafe/sports bar.
- Export PDF/Calendar.

---

## 10. Information Architecture

```text
App
├── Home
│   ├── Next Match Card
│   ├── Countdown
│   ├── Prepare Button
│   ├── Learn Rules Button
│   └── No Spoiler Button
│
├── Matches
│   ├── Match List
│   ├── Add Match
│   ├── Match Detail
│   ├── Reminder Settings
│   └── Replay Plan
│
├── Learn
│   ├── Rule Cards
│   ├── Situations
│   ├── Vocabulary
│   ├── Etiquette
│   └── Quiz
│
├── Spoiler Shield
│   ├── Protected Matches
│   ├── Replay Time
│   └── Spoiler Checklist
│
└── Profile
    ├── Timezone
    ├── Football Level
    ├── Preferences
    ├── Badges
    └── Settings
```

---

## 11. UX Flow chi tiết

## 11.1. Onboarding Flow

### Step 1: Welcome

```text
Welcome to Kickoff Buddy
Plan match times, avoid spoilers, and learn football rules in minutes.
```

### Step 2: Chọn timezone

App tự detect timezone nhưng cho phép user sửa.

```text
Your timezone: Asia/Ho_Chi_Minh
```

### Step 3: Chọn football level

- I’m new to football.
- I watch sometimes.
- I know the game well.

### Step 4: Chọn mục tiêu

- Watch matches on time.
- Avoid spoilers.
- Learn rules.
- Watch with friends/family.

---

## 11.2. Add Match Flow

Fields:

- Match title.
- Team A.
- Team B.
- Kickoff date.
- Kickoff time.
- Source timezone.
- User timezone.
- Reminder settings.
- Enable No Spoiler Mode.

CTA:

```text
Save Match
```

---

## 11.3. Prepare Match Flow

User vào match detail → bấm Prepare.

App hiển thị:

- Local kickoff time.
- Countdown.
- Sleep suggestion.
- Reminder state.
- 5-minute rules.
- Vocabulary for this match.
- No Spoiler toggle.

---

## 11.4. Learn During Match Flow

User bấm “Why did that happen?”

App hiển thị category:

- Goal cancelled.
- Offside.
- Penalty.
- VAR.
- Cards.
- Added time.
- Extra time.
- Penalty shootout.

User chọn → app mở explanation card.

---

## 12. UI/Design Direction

### Style

- Clean, friendly, sporty.
- Không dùng official tournament style.
- Không dùng logo/cúp/mascot chính thức.
- Dùng hình minh họa generic: sân bóng, đồng hồ, thẻ vàng, còi, quả bóng generic.

### Color direction

- Dark mode ưu tiên vì người dùng xem bóng buổi tối.
- Accent màu xanh sân cỏ hoặc xanh điện.
- Tránh phối màu giống branding chính thức của giải.

### Component chính

- Match card.
- Countdown pill.
- Rule card.
- Vocabulary row.
- Spoiler shield banner.
- Sleep plan card.
- Quiz card.
- Badge.

---

## 13. Data Model gợi ý

## 13.1. Match

```json
{
  "id": "match_001",
  "title": "Team A vs Team B",
  "teamA": "Team A",
  "teamB": "Team B",
  "kickoffAtUtc": "2026-06-12T01:00:00Z",
  "sourceTimezone": "America/New_York",
  "userTimezone": "Asia/Ho_Chi_Minh",
  "reminders": [1440, 180, 30],
  "noSpoilerEnabled": true,
  "replayPlannedAt": "2026-06-12T07:00:00+07:00",
  "createdAt": "2026-05-25T08:00:00Z"
}
```

## 13.2. RuleCard

```json
{
  "id": "offside_basic",
  "title": "Offside",
  "level": "newbie",
  "shortExplanation": "A player cannot wait too close to the opponent's goal when a teammate passes the ball.",
  "detail": "A player may be offside if they are nearer to the opponent's goal line than both the ball and the second-last opponent when the ball is played, and they become involved in active play.",
  "tags": ["offside", "goal", "VAR"],
  "estimatedReadSeconds": 30
}
```

## 13.3. VocabularyItem

```json
{
  "id": "stoppage_time",
  "term": "Stoppage time",
  "translation": "Bù giờ",
  "description": "Extra minutes added because play was stopped during the half.",
  "example": "There will be six minutes of stoppage time."
}
```

## 13.4. UserPreference

```json
{
  "timezone": "Asia/Ho_Chi_Minh",
  "footballLevel": "newbie",
  "defaultReminderMinutes": [1440, 180, 30],
  "preferNoSpoiler": true,
  "theme": "dark"
}
```

---

## 14. Tech Stack Flutter

## 14.1. App Framework

- Flutter stable.
- Dart.
- Material 3.
- Riverpod hoặc Bloc cho state management.
- GoRouter cho navigation.

## 14.2. Local Data

- Isar hoặc Hive cho local database.
- SharedPreferences cho setting đơn giản.
- JSON local bundle cho rule cards/vocabulary.

## 14.3. Timezone Handling

Packages gợi ý:

- `timezone`
- `intl`
- `flutter_native_timezone` hoặc package tương đương còn maintained

Yêu cầu:

- Luôn lưu kickoff theo UTC.
- Chỉ convert sang local khi hiển thị.
- Cẩn thận daylight saving time.

## 14.4. Notification

Packages gợi ý:

- `flutter_local_notifications`
- Android notification channel.
- iOS permission handling.

Yêu cầu:

- Local notification cho MVP.
- Không cần backend push ở version đầu.

## 14.5. Calendar Export

Có thể thêm ở Phase 2:

- Tạo file `.ics`.
- Share intent.
- Add to calendar nếu dùng package phù hợp.

## 14.6. Cloud Sync

Phase 2 hoặc 3:

- Firebase Auth.
- Firestore.
- Firebase Cloud Messaging nếu cần push.
- Firebase Analytics.
- Firebase Crashlytics.

MVP có thể chưa cần login.

---

## 15. Architecture đề xuất

```text
lib/
├── app/
│   ├── router.dart
│   ├── theme.dart
│   └── app.dart
│
├── core/
│   ├── time/
│   ├── notifications/
│   ├── storage/
│   └── utils/
│
├── features/
│   ├── onboarding/
│   ├── matches/
│   ├── reminders/
│   ├── spoiler_shield/
│   ├── rules/
│   ├── vocabulary/
│   └── profile/
│
└── shared/
    ├── widgets/
    ├── models/
    └── constants/
```

### Layering

```text
UI Layer
↓
State Management Layer
↓
Use Case / Service Layer
↓
Repository Layer
↓
Local DB / JSON / Notification Plugin
```

---

## 16. Nội dung rule cards MVP

## 16.1. Offside

Nội dung cần có:

- Giải thích newbie.
- Giải thích casual.
- Khi nào bàn thắng bị hủy vì offside.
- Passive offside là gì ở mức đơn giản.
- VAR check offside ra sao.

## 16.2. Penalty

Nội dung cần có:

- Khi nào có penalty.
- Penalty khác penalty shootout thế nào.
- Thủ môn được làm gì.
- Đá bồi sau penalty trong trận.

## 16.3. VAR

Nội dung cần có:

- VAR là gì.
- VAR can thiệp trong tình huống nào.
- Vì sao trọng tài vẫn là người quyết định cuối.
- Vì sao check VAR lâu.

## 16.4. Yellow/Red Card

Nội dung cần có:

- Thẻ vàng.
- Hai thẻ vàng thành thẻ đỏ.
- Thẻ đỏ trực tiếp.
- Đội bị thẻ đỏ đá thiếu người.

## 16.5. Stoppage Time

Nội dung cần có:

- Vì sao có bù giờ.
- Các lý do được cộng giờ.
- Vì sao bù giờ có thể dài.

## 16.6. Extra Time & Penalty Shootout

Nội dung cần có:

- Khi nào có hiệp phụ.
- Hiệp phụ dài bao lâu.
- Khi nào đá luân lưu.
- Luân lưu khác penalty trong trận ra sao.

---

## 17. Monetization

## 17.1. Free Tier

- Thêm số trận giới hạn.
- Reminder cơ bản.
- Rule cards cơ bản.
- Vocabulary cơ bản.
- No Spoiler cho 1-3 trận cùng lúc.

## 17.2. Premium Tier

- Unlimited match reminders.
- Advanced sleep plan.
- Unlimited No Spoiler Mode.
- Situation Simulator.
- Quiz packs.
- Family Mode.
- Calendar export.
- Custom themes.
- Offline full rule guide.

## 17.3. One-time Purchase

- Remove ads.
- Premium rule pack.
- Tournament season pack generic.
- Theme pack.

## 17.4. B2B Venue Mode

Dành cho quán cafe/sports bar:

- QR room.
- Countdown TV mode.
- Quiz giữa giờ.
- Poll vui.
- Branding của quán.

---

## 18. Compliance & Store Review

## 18.1. Không nên dùng

- Không dùng “FIFA” trong app name, icon, screenshot.
- Không dùng “World Cup 2026” như tên chính hoặc gây hiểu nhầm official.
- Không dùng logo, cúp, mascot, poster, font chính thức.
- Không dùng ảnh cầu thủ/đội tuyển nếu không có license.
- Không livestream.
- Không highlight lậu.
- Không scrape lịch/tỉ số từ nguồn không cho phép.
- Không betting/odds/cash prize.

## 18.2. Nên dùng

- Tên generic: football, soccer, kickoff, match, fan, rules, time.
- Ghi rõ unofficial nếu có nhắc bối cảnh giải đấu.
- Tự thiết kế icon/illustration.
- Cho user tự nhập lịch trong MVP.
- Privacy Policy rõ ràng.
- Không thu thập dữ liệu nhạy cảm không cần thiết.
- Nếu có user-generated content, cần report/moderation.

## 18.3. Disclaimer gợi ý

```text
Kickoff Buddy is an unofficial football companion app. It is not affiliated with, endorsed by, or sponsored by any tournament organizer, football federation, team, club, broadcaster, or governing body. All trademarks belong to their respective owners.
```

## 18.4. Store description gợi ý

```text
Kickoff Buddy helps football fans plan match times, set reminders, avoid spoilers, and learn football rules through simple guides and vocabulary cards. Perfect for international fans, new viewers, and anyone watching matches across time zones.
```

---

## 19. App Store / Google Play Listing

## 19.1. App Name

Ưu tiên:

```text
Kickoff Buddy
```

Alternative:

- Match Time Buddy.
- Football Watch Guide.
- Soccer Companion.
- Kickoff Guide.

## 19.2. Subtitle

```text
Match times, rules & spoiler shield
```

## 19.3. Short Description

```text
Plan football match times, avoid spoilers, and learn the rules in minutes.
```

## 19.4. Keywords

- football rules
- soccer rules
- kickoff time
- match reminder
- football vocabulary
- spoiler free
- offside guide
- penalty guide
- VAR guide

Tránh keyword:

- FIFA
- World Cup official
- Official tournament app
- Live stream
- Betting

---

## 20. KPI cần theo dõi

## Activation

- % user hoàn thành onboarding.
- % user thêm trận đầu tiên.
- % user bật reminder.
- % user mở rule card đầu tiên.

## Engagement

- Số trận/user.
- Số reminder được tạo.
- Số rule card đã đọc.
- Số vocabulary item đã xem.
- Số lần bật No Spoiler Mode.

## Retention

- D1 retention.
- D7 retention.
- D30 retention.
- Returning users trong ngày có trận.

## Monetization

- Free to premium conversion.
- Remove ads purchase.
- Premium feature usage.

---

## 21. Rủi ro sản phẩm

## 21.1. Rủi ro pháp lý/trademark

Cách giảm:

- Không dùng brand chính thức.
- Không dùng asset chính thức.
- Dùng wording “unofficial”.
- MVP cho user tự nhập lịch.

## 21.2. Rủi ro dữ liệu lịch đấu

Cách giảm:

- Phase 1: user tự nhập.
- Phase 2: chỉ dùng nguồn API có license.
- Không scrape nếu ToS không cho phép.

## 21.3. Rủi ro app quá nhỏ

Cách giảm:

- Thêm No Spoiler Mode.
- Thêm Vocabulary.
- Thêm Rule Brief.
- Thêm Sleep Plan.
- Sau MVP thêm Quiz/Simulator.

## 21.4. Rủi ro cạnh tranh với app live score

Cách giảm:

- Không cạnh tranh trực diện live score.
- Định vị là companion app cho người mới và fan quốc tế.
- Tập trung vào timezone, spoiler shield và education.

---

## 22. Backlog chi tiết

## Must-have

- Onboarding.
- Timezone detection.
- Manual add match.
- Match list.
- Match detail.
- Countdown.
- Local notification.
- Rule cards.
- Vocabulary.
- No Spoiler Mode.
- Settings.

## Should-have

- Sleep Plan.
- Calendar export.
- Before Match Brief.
- After Match Learning.
- Badge.
- Search vocabulary.

## Could-have

- Quiz.
- Situation Simulator.
- Partner Mode.
- Family Mode.
- Share card.
- Widget.
- Wear OS / Apple Watch support.

## Won’t-have trong MVP

- Live score.
- News feed.
- Video highlight.
- Betting.
- Public chat.
- Official tournament data without license.

---

## 23. Sprint plan gợi ý

## Sprint 1 — Foundation

- Setup Flutter project.
- App theme.
- Routing.
- Local storage.
- Basic models.
- Onboarding.
- Timezone detection.

## Sprint 2 — Match Scheduler

- Add match screen.
- Match list.
- Match detail.
- Time conversion.
- Countdown.
- Reminder setup.

## Sprint 3 — Rules & Vocabulary

- Rule card data.
- Rule list screen.
- Rule detail screen.
- Vocabulary list.
- Search/filter.

## Sprint 4 — Spoiler & Polish

- No Spoiler Mode.
- Replay plan.
- Spoiler checklist.
- Settings.
- Empty states.
- App icon.
- Store screenshots.
- Privacy Policy.

## Sprint 5 — Testing & Release

- Android internal testing.
- iOS TestFlight.
- Notification permission testing.
- Timezone edge cases.
- Store review preparation.

---

## 24. Testing checklist

## Timezone

- Convert UTC to Asia/Ho_Chi_Minh.
- Convert from America/New_York to Asia/Ho_Chi_Minh.
- Convert around daylight saving time.
- Manual timezone override.

## Notification

- Reminder fires correctly.
- Notification permission handling.
- Android channel works.
- iOS scheduled notification works.
- Reminder update/cancel works.

## No Spoiler

- Protected match does not show score/result fields.
- Notification does not leak result.
- Replay planned time works.
- User can mark match as watched.

## Content

- Rule cards readable.
- Vocabulary search works.
- No official trademark/asset in UI.
- Disclaimer visible in About screen.

---

## 25. Kết luận

Kickoff Buddy nên bắt đầu như một app nhỏ nhưng sắc nét:

> **Timezone + Reminder + No Spoiler + Rule Cards + Vocabulary**

Đây là tổ hợp đủ khác biệt so với live score app, phù hợp với Flutter, ít phụ thuộc API/licensing và có nhiều hướng mở rộng sau MVP. Sản phẩm có thể tận dụng mùa bóng đá quốc tế lớn như một thời điểm marketing, nhưng vẫn sống được quanh năm nhờ nhu cầu xem bóng ở nhiều múi giờ và học luật bóng đá cơ bản.
