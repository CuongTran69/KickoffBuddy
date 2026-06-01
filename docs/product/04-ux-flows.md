---
id: product-ux-flows
title: UX Flows
status: in-progress
phase: mvp
depends-on: [product-vision]
related: [feat-match-scheduler, feat-reminders, feat-replay-planner, feat-rule-cards, mvp-scope]
last-updated: 2026-05-29
---

## Mục đích

Mô tả 4 luồng UX chính của MVP Kickoff Buddy. Mỗi flow là một hành trình người dùng từ điểm vào đến kết quả mong muốn. Tài liệu này là nguồn tham chiếu cho thiết kế màn hình và implementation.

## Phạm vi

### In scope

- Flow 1: Onboarding (lần đầu mở app)
- Flow 2: Add Match (thêm trận đấu)
- Flow 3: Prepare Match (chuẩn bị xem trận)
- Flow 4: Learn During Match (tra cứu luật trong lúc xem)

### Out of scope

- Flow Phase 2+: Magic Add LLM, Sleep Plan chi tiết, Quiz, Partner Mode
- Flow admin/settings nâng cao
- Flow monetization/premium

---

### Flow 1: Onboarding

Người dùng mở app lần đầu. App dẫn qua 4 bước để cá nhân hóa trải nghiệm.

```
[Welcome Screen]
       ↓
[Detect Timezone] → user có thể override
       ↓
[Choose Football Level]
       ↓
[Choose Goals] → multi-select
       ↓
[Home Screen]
```

**Step 1 — Welcome screen**

```
Welcome to Kickoff Buddy
Plan match times, avoid spoilers, and learn football rules in minutes.

[Get Started]
```

**Step 2 — Detect timezone**

App tự detect timezone từ hệ thống nhưng cho phép user sửa thủ công.

```
Your timezone: Asia/Ho_Chi_Minh (UTC+7)
[Change timezone ▾]
[Continue]
```

**Step 3 — Choose football level**

Ba lựa chọn (single-select):

- Newbie — "I'm new to football"
- Casual — "I watch sometimes"
- Advanced — "I know the game well"

Level này ảnh hưởng độ phức tạp của Rule Cards và Vocabulary hiển thị.

**Step 4 — Choose goals**

Multi-select (user chọn 1 hoặc nhiều):

- Watch matches on time
- Avoid spoilers / plan replay
- Learn rules
- Watch with friends / family

---

### Flow 2: Add Match

Ba chế độ thêm trận. Xem chi tiết tại [`mvp/features/01-match-scheduler.md`](../mvp/features/01-match-scheduler.md).

```
[Home] → [+ Add Match]
              ↓
    ┌─────────────────────┐
    │  Chọn chế độ:       │
    │  1. WC Seed Pick    │
    │  2. Manual Add      │
    │  3. Magic Add Lite  │
    └─────────────────────┘
```

**Chế độ 1 — WC Seed Pick**

User chọn trận từ danh sách WC 2026 đã seed sẵn. App tự điền thông tin, user chỉ cần xác nhận timezone và reminder.

**Chế độ 2 — Manual Add**

User nhập thủ công:

- Match title
- Team A / Team B
- Kickoff date + time
- Source timezone (múi giờ của sân)
- Reminder settings (1440 phút / 180 phút / 30 phút trước)
- Bật/tắt Replay Planner

CTA: `[Save Match]`

**Chế độ 3 — Magic Add Lite (MVP)**

User paste text chứa thông tin trận (ví dụ: "Brazil vs Morocco, June 18, 8pm ET"). App dùng regex để parse và điền form. User review và confirm.

> Magic Add LLM (Phase 2) sẽ thay thế regex bằng model. Xem [`future/01-magic-add-llm.md`](../future/01-magic-add-llm.md).

---

### Flow 3: Prepare Match

User vào match detail và bấm "Prepare" để xem tổng quan trước trận.

```
[Match List] → [Match Detail] → [Prepare]
                                     ↓
                          ┌──────────────────────┐
                          │ Local kickoff time   │
                          │ Countdown            │
                          │ Sleep suggestion     │
                          │ Reminder state       │
                          │ 5-min rules          │
                          │ Vocabulary           │
                          │ Replay Planner toggle│
                          └──────────────────────┘
```

App hiển thị:

- **Local kickoff time** — giờ trận theo timezone của user
- **Countdown** — đếm ngược đến giờ kickoff
- **Sleep suggestion** — gợi ý thông tin (informational, không phải alarm); xem [`future/02-sleep-plan.md`](../future/02-sleep-plan.md) cho Phase 2
- **Reminder state** — trạng thái notification đã đặt
- **5-minute rules** — 3-5 Rule Cards liên quan đến trận (ví dụ: offside, VAR)
- **Vocabulary** — 3-5 thuật ngữ Anh-Việt liên quan
- **Replay Planner toggle** — bật để app ẩn kết quả cho đến giờ xem lại đã đặt

---

### Flow 4: Learn During Match

User đang xem trận, có tình huống không hiểu, bấm "Why did that happen?" từ home hoặc match detail.

```
[Home / Match Detail]
       ↓
[Why did that happen?]
       ↓
[Category list]
       ↓
[Explanation Card]
```

**Category list:**

- Goal cancelled
- Offside
- Penalty
- VAR
- Cards (Yellow / Red)
- Added time (Stoppage time)
- Extra time
- Penalty shootout

User chọn category → app mở Rule Card tương ứng với giải thích ngắn gọn, ví dụ đời thường, phù hợp với football level đã chọn ở onboarding.

Xem spec nội dung tại [`content/02-rule-cards-spec.md`](../content/02-rule-cards-spec.md).

---

## Edge cases

- User từ chối cấp quyền notification: app vẫn hoạt động, nhưng reminder không gửi được. Hiển thị banner nhắc nhở trong match detail.
- User từ chối cấp quyền clipboard (Magic Add Lite): fallback về Manual Add, hiển thị thông báo giải thích.
- User không có trận nào: home screen hiển thị empty state với CTA "Add your first match".
- User thay đổi timezone sau khi đã thêm trận: app cần recalculate local kickoff time cho tất cả trận hiện có.
- User bật Replay Planner nhưng không đặt giờ xem lại: app dùng default (24 giờ sau kickoff).
- Onboarding bị gián đoạn (app crash, force close): lần mở lại tiếp tục từ bước cuối hoặc bắt đầu lại từ đầu (cần quyết định).
- User chọn timezone không hợp lệ hoặc timezone thay đổi do DST: dùng IANA timezone, không hardcode offset.

## Open questions

- Onboarding có thể skip không? Nếu skip thì default football level là gì?
- Magic Add Lite có cần confirm screen riêng hay inline trong form?
- Replay Planner toggle trong Prepare Match có sync với setting trong Add Match không?
- Flow 4 có nên accessible từ notification không (deep link)?

## Next steps

- Wireframe 4 flows trong Figma/Pencil
- Xác định màn hình nào cần native permission dialog (notification, clipboard)
- Viết acceptance criteria chi tiết cho từng flow trong feature files tương ứng
- Xem [`mvp/00-scope.md`](../mvp/00-scope.md) để confirm flow nào thuộc MVP
