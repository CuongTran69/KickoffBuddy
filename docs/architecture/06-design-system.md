---
id: arch-design-system
title: Design System
status: planned
phase: foundational
depends-on: [arch-tech-stack]
related: [feat-match-scheduler, feat-reminders, feat-replay-planner, ops-accessibility, compliance-trademark]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa hướng thiết kế, bảng màu, typography và danh sách component UI của Kickoff Buddy. Tài liệu này là nguồn tham chiếu cho mọi quyết định visual trong app, đảm bảo nhất quán giữa các feature và tránh vi phạm trademark.

## Phạm vi

### In scope

- Style direction (tone, illustration)
- Color direction (dark mode, accent)
- Danh sách component chính với tên đã xác nhận
- Ràng buộc trademark liên quan đến visual

### Out of scope

- Animation spec (beyond Sprint 1 motion tokens)
- Advanced theming (dynamic color, per-feature palette overrides)
- Storybook / golden test infrastructure (deferred post-Sprint 2)

HEX palette, typography scale, and icon set are locked — see "Decisions (locked 2026-05-28)" below.

---

## Style

Kickoff Buddy dùng phong cách **clean, friendly, sporty** — thân thiện với người mới, không nặng nề như app thống kê chuyên nghiệp.

**Ràng buộc bắt buộc** (xem [`compliance/01-trademark.md`](../compliance/01-trademark.md)):

- KHÔNG dùng official tournament style (màu sắc, font, layout của FIFA WC 2026)
- KHÔNG dùng logo, cúp vàng, mascot chính thức của giải
- KHÔNG dùng tên "World Cup", "FIFA", "WC 2026" như branding của app

**Illustration direction:**

Dùng hình minh họa generic, không gắn với giải cụ thể:

- Sân bóng (generic pitch)
- Đồng hồ / countdown
- Thẻ vàng, thẻ đỏ
- Còi trọng tài
- Quả bóng generic (không phải official match ball)

---

## Color direction

- **Dark mode ưu tiên** — người dùng chủ yếu xem bóng buổi tối, dark mode giảm mỏi mắt
- **Accent** — xanh sân cỏ (`grass green`) hoặc xanh điện (`electric blue`); quyết định cuối trong Sprint 1
- **Tránh** phối màu giống branding chính thức của WC 2026 (xem compliance)
- Light mode cần hỗ trợ nhưng không phải ưu tiên MVP

Contrast ratio tối thiểu theo WCAG 2.1 AA: 4.5:1 cho text thường, 3:1 cho text lớn. Xem [`ops/03-accessibility.md`](../ops/03-accessibility.md).

---

## Components

Danh sách component chính. Tên đã được xác nhận (một số đã đổi tên so với bản gốc).

| Component | Tên cũ | Mục đích |
|---|---|---|
| Match Card | — | Hiển thị 1 trận trên list/home: tên đội, giờ local, countdown pill |
| Countdown Pill | — | Đếm ngược nhỏ gọn, dùng trên home và widget |
| Rule Card | — | 1 luật bóng đá kèm giải thích ngắn, ví dụ đời thường |
| Vocabulary Row | — | 1 thuật ngữ Anh-Việt, dùng trong Prepare Match và Vocabulary list |
| **Replay Planner Banner** | Spoiler Shield Banner | Thông báo trận đang được bảo vệ khỏi spoil + giờ xem lại đã đặt |
| Sleep Plan Card | — | Gợi ý lịch sinh hoạt theo giờ trận (informational, Phase 2) |
| Quiz Card | — | 1 câu hỏi quiz với đáp án (Phase 3) |
| Badge | — | Thành tích gamification (Phase 3) |
| Hype Meter | — | Thước đo độ nhiệt kịch tính của trận đấu không spoil (Phase 4) |
| Commentary Decoder Card | — | Thẻ tra cứu/giải nghĩa tiếng lóng bóng đá kèm hình vui nhộn (Phase 4) |
| Crowd Soundboard Button | — | Các nút bấm âm thanh cổ động đồng bộ nhóm (Phase 4) |

**Lưu ý đổi tên:** "Spoiler Shield Banner" → "Replay Planner Banner" theo quyết định đã lock. Code identifier mới:

- Dart class / widget: `ReplayPlannerBanner`
- Variable / instance: `replayPlannerBanner`
- String key (i18n / asset): `replay_planner_banner`

Không dùng `spoilerShield*` ở bất kỳ identifier nào.

---

## Decisions (locked 2026-05-28)

Các quyết định dưới đây đã được lock. Không cần mở lại trong Sprint 1.

### Color palette

**Dark mode (ưu tiên):**

| Role | HEX | Tên |
|---|---|---|
| Primary | `#10B981` | Emerald — "pitch green" |
| Surface | `#0F172A` | Slate-900 |
| Surface variant | `#1E293B` | Slate-800 |
| On-surface | `#F1F5F9` | Slate-100 |
| Accent | `#FBBF24` | Amber — dùng cho countdown "kickoff in X" |

**Light mode:**

| Role | HEX | Tên |
|---|---|---|
| Primary | `#059669` | Emerald-600 |
| Surface | `#FFFFFF` | White |
| Surface variant | `#F1F5F9` | Slate-100 |
| On-surface | `#0F172A` | Slate-900 |

Rationale: Football pitch green + neutral slate đạt WCAG AA (4.5:1 text contrast). Amber accent cho countdown "kickoff in X" — màu warm nổi bật trên nền tối.

### Typography

**Font family:** Inter (Google Fonts) — free, hỗ trợ tiếng Việt đầy đủ (dấu), legible ở size nhỏ.

| Role | Weight | Ghi chú |
|---|---|---|
| Display / Title | SemiBold (600) | Tên đội, tiêu đề màn hình |
| Body | Regular (400) | Mô tả, nội dung |
| Numerals / Time | SemiBold (600) + `tabular-nums` | Countdown, giờ trận — tránh layout shift |

### Component library

**Material 3 base** (Flutter built-in `material` package) với custom theming qua `ThemeExtension`. Không dùng third-party UI kit.

Custom widgets chỉ build khi M3 không cover: `MatchCard`, `ReplayPlannerBanner`, `RuleCard`, `CountdownPill`.

Rationale: Solo dev, MVP — minimize dependencies, leverage Flutter defaults.

### Iconography

- **Icons:** Material Symbols (rounded variant) via `material_symbols_icons` package
- **Flags:** `flag-icons` (MIT license) — SVG cờ quốc gia, không phải federation crest

Rationale: Material Symbols comprehensive, free, M3-native. Rounded variant phù hợp tone friendly của app.

---

## Quy tắc Giao diện Cao cấp & Tính năng mới (Cập nhật 2026-05-29)

Để duy trì giao diện cao cấp (Premium look), hiện đại và đồng bộ khi phát triển các tính năng tiếp theo, mọi thành phần giao diện mới cần tuân thủ các quy tắc thiết kế sau:

### 1. Phong cách Kính mờ & Viền phát sáng (Glassmorphism & Glowing Borders)
- **Container / Cards**:
  - Sử dụng bo góc bo góc lớn `borderRadius: 16` đến `18` cho các thẻ thông tin.
  - Sử dụng viền siêu mỏng độ dày từ `0.8` đến `1.2` với màu bán trong suốt (`withValues(alpha: 0.25)`) để tạo hiệu ứng lớp kính đè lên nền.
  - Áp dụng đổ bóng mờ nhẹ (`blurRadius: 8` đến `10`) với độ mờ thấp (`alpha: 0.1` đến `0.15`).
- **Gradients**:
  - Không sử dụng màu phẳng đơn sắc cho các Hero Card lớn.
  - **Dark Mode**: Sử dụng dải màu gradient từ xanh lá thẫm đêm (`#042F1A`) chuyển dần sang màu Slate tối (`#0F172A`).
  - **Light Mode**: Sử dụng màu xanh lá nhạt dịu mắt (`#E8F5E9`) sang màu Trắng (`#FFFFFF`).

### 2. Vi tương tác & Chỉ báo Trực quan (Micro-interactions)
- **Chỉ báo Countdown / Live**:
  - Đi kèm chấm tròn nhấp nháy chuyển động thở (Pulsing Dot) sử dụng `AnimationController` chu kỳ `1.5 giây` để biểu thị nội dung đang cập nhật hoặc sắp diễn ra.
  - Trận đấu diễn ra trong ngày sẽ có dải màu hổ phách (Amber) chạy dọc lề trái `4.5px` và hiển thị viền vàng nhẹ để phân biệt nhanh.

### 3. Giao diện Sa bàn & Đồ họa Tương tác (Pitch/Simulation Graphics)
- Khi phát triển sa bàn ảo (Situation Simulator ở Phase 3):
  - Sử dụng đồ họa phẳng tối giản (Minimalist Flat 2D/2.5D), không dùng hình vẽ quá chi tiết hoặc ảnh chụp thực tế.
  - Đường kẻ việt vị hoặc chỉ thị hành vi phạm lỗi phải phát sáng màu Neon nổi bật (Đỏ Neon báo lỗi vi phạm, Xanh Neon báo an toàn/hợp lệ).

### 4. Bố cục biểu đồ lịch ngủ (Sleep Plan Circadian Chart ở Phase 2)
- Trực quan hóa thời gian ngủ dưới dạng timeline ngang hoặc vòng tròn màu sắc thể hiện nhịp sinh học trong 24 giờ.
- Luôn hiển thị khung cảnh báo y tế (Disclaimer) rõ ràng ở cuối biểu đồ: *"Đây là gợi ý sinh hoạt cá nhân, không thay thế tư vấn y khoa từ bác sĩ"*.

---

## Edge cases

- **Color contrast dark mode:** ✓ Resolved 2026-05-28: WCAG AA contrast verified. Primary `#10B981` on dark surface `#0F172A` = 6.95:1 (AA pass for normal text). Accent `#FBBF24` on dark surface `#0F172A` = 10.55:1 (AAA pass).
- **Component reuse:** Match Card dùng ở home list, search result và widget — cần thiết kế responsive/adaptive từ đầu.
- **Iconography:** Nếu dùng Material Symbols, một số icon football có thể không có sẵn — cần custom icon hoặc illustration. Nếu dùng Phosphor, kiểm tra license cho commercial use.
- **Replay Planner Banner** cần hiển thị rõ ràng khi Replay Planner đang active để user không vô tình thấy kết quả.
- **Debutant flag icons** (Cape Verde, Curaçao, Jordan, Uzbekistan): kiểm tra asset availability trong icon library đã chọn.

## Open questions

- (resolved — xem Decisions section bên trên)

## Next steps

- Build golden tests cho các component chính (Match Card, Countdown Pill, Rule Card, Replay Planner Banner) — defer đến sau Sprint 2
- Xem [`ops/03-accessibility.md`](../ops/03-accessibility.md) để đảm bảo contrast ratio đạt WCAG 2.1 AA khi implement screen đầu tiên
