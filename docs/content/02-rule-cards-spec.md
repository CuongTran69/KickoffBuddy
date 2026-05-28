---
id: content-rule-cards-spec
title: Rule Cards Content Spec
status: planned
phase: mvp
depends-on: [content-strategy, arch-data-model]
related: [feat-rule-cards]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa schema và content spec cho rule cards. Là tài liệu hướng dẫn viết nội dung và implement JSON bundle.

## Phạm vi

### In scope

- JSON schema cho RuleCard
- Level definitions
- Tag taxonomy
- Content requirements cho 7 chủ đề MVP

### Out of scope

- Nội dung đầy đủ (viết riêng trong JSON bundle)
- UI rendering (xem [feat-rule-cards](../mvp/features/04-rule-cards.md))

---

## JSON Schema

```json
{
  "id": "string (kebab-case, unique)",
  "title": "string (English)",
  "titleVi": "string (Vietnamese)",
  "level": "newbie | casual | advanced",
  "shortExplanation": "string (Vietnamese, max 100 chars)",
  "shortExplanationEn": "string (English, max 100 chars)",
  "detail": "string (Vietnamese, markdown supported)",
  "detailEn": "string (English, markdown supported)",
  "whenItHappens": "string (Vietnamese, khi nào xuất hiện trong trận)",
  "example": "string (Vietnamese, ví dụ đời thường)",
  "tags": ["string"],
  "estimatedReadSeconds": "number",
  "relatedIds": ["string (other card IDs)"],
  "ifabReference": "string (e.g. 'Law 11')",
  "lastReviewedDate": "YYYY-MM-DD",
  "ruleUpdates2526": "string | null (thay đổi trong luật 2025/26 nếu có)"
}
```

---

## Level Definitions

### newbie

- Đối tượng: người chưa bao giờ xem bóng đá
- Độ dài: 1-2 câu
- Ngôn ngữ: đơn giản nhất có thể, dùng ví dụ đời thường
- Không dùng thuật ngữ kỹ thuật nếu không giải thích

### casual

- Đối tượng: fan thỉnh thoảng xem, biết cơ bản
- Độ dài: 3-5 câu
- Ngôn ngữ: thuật ngữ cơ bản OK, có thêm context
- Có thể đề cập VAR, offside line, v.v.

### advanced

- Đối tượng: fan hiểu bóng đá, muốn biết chi tiết
- Độ dài: không giới hạn
- Ngôn ngữ: thuật ngữ kỹ thuật OK
- Bao gồm edge cases, exceptions, IFAB reference

---

## Tag Taxonomy

| Tag | Dùng cho |
|---|---|
| `offside` | Luật việt vị |
| `goal` | Liên quan đến bàn thắng |
| `penalty` | Phạt đền |
| `var` | VAR |
| `cards` | Thẻ vàng/đỏ |
| `time` | Bù giờ, hiệp phụ |
| `goalkeeper` | Thủ môn |
| `foul` | Phạm lỗi |
| `set-piece` | Phạt góc, ném biên, phạt trực tiếp |
| `shootout` | Đá luân lưu |

---

## 7 Chủ đề MVP — Content Requirements

### 1. Offside (Law 11)

Cards cần có:
- `offside_newbie`: giải thích 1 câu đơn giản
- `offside_casual`: thêm "hậu vệ áp chót", "tham gia pha bóng"
- `offside_advanced`: passive offside, SAOT, interfering with play/opponent/gaining advantage

Tags: `offside`, `goal`, `var`

### 2. Penalty (Law 12, 14)

Cards cần có:
- `penalty_newbie`: foul trong vòng cấm → đá từ chấm 11m
- `penalty_casual`: handball, DOGSO, thủ môn phải đứng trên vạch
- `penalty_advanced`: đá bồi, thủ môn rời vạch sớm, VAR check

Tags: `penalty`, `foul`, `goalkeeper`

### 3. VAR (Law 12 — Video Assistant Referee)

Cards cần có:
- `var_newbie`: VAR = xem lại replay để kiểm tra
- `var_casual`: 4 tình huống VAR can thiệp, OFR
- `var_advanced`: SAOT, minimum interference principle, check vs review

Tags: `var`, `goal`, `penalty`, `cards`

### 4. Yellow/Red Card (Law 12)

Cards cần có:
- `cards_newbie`: thẻ vàng = cảnh cáo, thẻ đỏ = rời sân
- `cards_casual`: 2 thẻ vàng = thẻ đỏ, DOGSO, violent conduct
- `cards_advanced`: accumulation, suspension, captain-only protest (2025/26)

Tags: `cards`, `foul`

### 5. Stoppage Time (Law 7)

Cards cần có:
- `stoppage_newbie`: thời gian cộng thêm vì có khoảng dừng
- `stoppage_casual`: các lý do cộng giờ, trọng tài quyết định
- `stoppage_advanced`: 8-second GK rule (2025/26), 5-second throw-in (2025/26)

Tags: `time`, `goalkeeper`

### 6. Extra Time (Law 7)

Cards cần có:
- `extra_time_newbie`: 2 hiệp 15 phút thêm ở vòng knock-out
- `extra_time_casual`: khi nào có, khi nào không (vòng bảng không có)
- `extra_time_advanced`: golden goal không còn dùng, substitution rules

Tags: `time`

### 7. Penalty Shootout (Law 10)

Cards cần có:
- `shootout_newbie`: 5 cầu thủ đá luân lưu để phân định
- `shootout_casual`: sudden death, thủ môn có thể di chuyển
- `shootout_advanced`: order selection, goalkeeper swap, VAR in shootout

Tags: `shootout`, `goalkeeper`, `penalty`

---

## File Structure

```
assets/data/rule_cards.json
```

```json
{
  "version": "2025-26",
  "lastUpdated": "2026-05-25",
  "cards": [
    { ... },
    { ... }
  ]
}
```

---

## Edge cases

- Card với `ruleUpdates2526` không null: hiển thị badge "Luật mới 2025/26" trong UI
- `estimatedReadSeconds` dùng để hiển thị "Đọc trong X giây" trên card

## Open questions

- —

## Next steps

- Viết JSON content cho 7 chủ đề trước Sprint 3
- Review với IFAB Laws 2025/26
