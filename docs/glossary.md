---
id: glossary
title: Glossary
status: planned
phase: foundational
depends-on: []
related: [docs-readme, product-vision, arch-tech-stack]
last-updated: 2026-05-25
---

## Mục đích

Tra cứu nhanh các thuật ngữ dùng trong toàn bộ docs. Mỗi term có định nghĩa ngắn và link đến file liên quan.

## Phạm vi

### In scope

- Thuật ngữ sản phẩm (tên tính năng, khái niệm UX)
- Thuật ngữ kỹ thuật quan trọng
- Thuật ngữ pháp lý/compliance
- Thuật ngữ bóng đá dùng trong docs

### Out of scope

- Từ điển bóng đá đầy đủ (xem [feat-vocabulary](mvp/features/05-vocabulary.md))
- API reference

---

## Thuật ngữ sản phẩm

| Term | Định nghĩa |
|---|---|
| **Kickoff Buddy** | Tên app. Unofficial football companion app cho người xem bóng đá quốc tế. Không phải app chính thức của bất kỳ giải đấu nào. |
| **Magic Add Lite** | Tính năng MVP: nhận diện thông tin trận đấu từ text người dùng paste vào, dùng regex offline. Không gọi LLM. Xem [feat-match-scheduler](mvp/features/01-match-scheduler.md). |
| **Magic Add LLM** | Phiên bản Phase 2 của Magic Add: gọi LLM API khi regex không đủ. Xem [future-magic-add-llm](future/01-magic-add-llm.md). |
| **Replay Planner** | Tính năng giúp người dùng lên kế hoạch xem lại trận đấu mà không bị lộ kết quả. Tên cũ trong bản gốc: "No Spoiler Mode". Xem [feat-replay-planner](mvp/features/03-replay-planner.md). |
| **Confirm Screen** | Màn hình xác nhận bắt buộc sau khi Magic Add parse xong. Luôn hiển thị, không bỏ qua. |
| **Late Watcher** | Persona người dùng muốn xem lại trận khuya vào sáng hôm sau. Tên cũ: "Hardcore Fan". Xem [future-sleep-plan](future/02-sleep-plan.md). |
| **Sleep Plan** | Tính năng Phase 2: gợi ý lịch ngủ/thức phù hợp với giờ trận. Mang tính thông tin, không phải tư vấn y tế. |
| **Rule Cards** | Thẻ giải thích luật bóng đá ngắn gọn, có 3 level: newbie/casual/advanced. Xem [feat-rule-cards](mvp/features/04-rule-cards.md). |
| **5-Minute Brief** | Format card: đọc trong 5 phút trước trận để hiểu các luật hay gặp. |
| **Why Did That Happen** | Tính năng tra cứu nhanh khi gặp tình huống khó hiểu trong trận. |
| **Venue Mode** | Phase 4: phiên bản dành cho quán cafe/sports bar. B2B. Xem [future-venue-mode](future/07-venue-mode.md). |
| **Partner Mode** | Phase 3: chế độ xem cùng người không rành bóng đá. Xem [future-partner-mode](future/05-partner-mode.md). |
| **Family Mode** | Phase 3: chế độ cho trẻ em/phụ huynh, font lớn, nội dung nhẹ nhàng. Xem [future-family-mode](future/06-family-mode.md). |
| **WC seed** | 104 trận World Cup 2026 được seed sẵn vào app từ nguồn CC0. Xem [data-seed-strategy](data/01-seed-strategy.md). |
| **3P framework** | Ba lớp giá trị cốt lõi: Plan / Protect / Understand. |

---

## Thuật ngữ kỹ thuật

| Term | Định nghĩa |
|---|---|
| **IANA timezone** | Chuẩn tên múi giờ quốc tế, ví dụ `Asia/Ho_Chi_Minh`, `America/New_York`. Dùng thay vì offset cứng như `UTC+7`. |
| **TZDateTime** | Kiểu dữ liệu từ package `timezone` trong Dart/Flutter. Phải dùng thay vì `DateTime` thuần khi schedule notification để tránh lỗi DST. |
| **DST** | Daylight Saving Time — giờ mùa hè. Một số quốc gia (Mỹ, EU) dịch chuyển đồng hồ 1 giờ theo mùa. Phải xử lý đúng khi convert timezone. |
| **`timezone` package** | Flutter package cung cấp IANA timezone database. Dùng cùng `flutter_timezone` (dyu fork). |
| **`flutter_timezone` (dyu fork)** | Fork được maintain của `flutter_native_timezone`. Lấy timezone hiện tại của thiết bị. Không dùng package gốc `flutter_native_timezone` (abandoned). |
| **`flutter_local_notifications` v21+** | Package gửi local notification trên Android/iOS. Phải dùng v21+ với `TZDateTime`, không dùng raw `DateTime`. |
| **`home_widget`** | Package Flutter cho Android home screen widget. iOS dùng native WidgetKit + Pigeon. |
| **Pigeon** | Code generation tool của Flutter để tạo type-safe bridge giữa Dart và native (Swift/Kotlin). Dùng cho iOS WidgetKit và ActivityKit. |
| **Riverpod** | State management library cho Flutter. Lựa chọn cho Kickoff Buddy. |
| **GoRouter** | Navigation/routing library cho Flutter. |
| **Isar** | Local database cho Flutter. Dùng cho tất cả data phức tạp (Match, v.v.). UserPreference lưu trong SharedPreferences. |
| **Cloudflare Workers** | Serverless platform Phase 2. PoP tại HCM và HN. Không có cold start. ~$5/tháng. |
| **CC0** | Creative Commons Zero — public domain, không cần attribution. Dùng cho dữ liệu seed WC 2026. |
| **openfootball** | Repo GitHub CC0 chứa lịch đấu World Cup. Nguồn seed chính. |
| **Wikidata** | Knowledge base CC0 của Wikimedia. Dùng để lấy tên đội, thành phố, timezone. |
| **ARB** | Application Resource Bundle — format file i18n của Flutter (`app_en.arb`, `app_vi.arb`). |

---

## Thuật ngữ pháp lý / compliance

| Term | Định nghĩa |
|---|---|
| **FIFA** | Fédération Internationale de Football Association. Tên thương hiệu được bảo hộ. Không dùng trong app name, icon, screenshot. Chỉ dùng mô tả (descriptive use). |
| **Descriptive use** | Dùng tên thương hiệu để mô tả sản phẩm/dịch vụ, không phải để gắn kết thương hiệu. Ví dụ: "lịch trận World Cup 2026" trong mô tả app là descriptive use hợp lệ. |
| **Unofficial disclaimer** | Câu tuyên bố bắt buộc: "Kickoff Buddy is an unofficial football companion app. Not affiliated with any tournament organizer or football federation." |
| **Apple 1.4.1** | Guideline của App Store: app không được cung cấp thông tin y tế/sức khỏe sai lệch. Sleep Plan phải được framing là thông tin, không phải tư vấn y tế. |
| **Apple 5.1** | Guideline về privacy. Liên quan đến clipboard access (iOS yêu cầu permission). |
| **flag-icons** | Thư viện SVG cờ quốc gia, license MIT. Dùng thay vì federation crest (có bản quyền). |
| **IFAB** | International Football Association Board — tổ chức ban hành Laws of the Game. Nguồn tham chiếu cho rule cards. |

---

## Thuật ngữ bóng đá (dùng trong docs)

| Term | Tiếng Việt | Ghi chú |
|---|---|---|
| Offside | Việt vị | Luật phổ biến nhất cần giải thích |
| VAR | VAR | Video Assistant Referee |
| Penalty | Phạt đền | Trong trận (khác penalty shootout) |
| Penalty shootout | Đá luân lưu | Sau extra time trong knock-out |
| Extra time | Hiệp phụ | 2 × 15 phút |
| Stoppage time / Added time | Bù giờ | Thời gian cộng thêm cuối hiệp |
| Yellow card | Thẻ vàng | |
| Red card | Thẻ đỏ | |
| Throw-in | Ném biên | |
| Corner kick | Phạt góc | |
| Goal kick | Phát bóng lên | |
| Clean sheet | Giữ sạch lưới | |
| Own goal | Phản lưới nhà | |

---

## Open questions

- —

## Next steps

- Bổ sung term khi có tính năng mới
- Đồng bộ với [feat-vocabulary](mvp/features/05-vocabulary.md) để tránh trùng lặp
