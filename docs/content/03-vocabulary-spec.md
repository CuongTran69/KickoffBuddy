---
id: content-vocabulary-spec
title: Vocabulary Content Spec
status: planned
phase: mvp
depends-on: [content-strategy, arch-data-model]
related: [feat-vocabulary]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa schema và content spec cho vocabulary items. Là tài liệu hướng dẫn viết nội dung và implement JSON bundle.

## Phạm vi

### In scope

- JSON schema cho VocabularyItem
- Content requirements cho MVP vocabulary
- Search/filter spec

### Out of scope

- Nội dung đầy đủ (viết riêng trong JSON bundle)
- UI rendering (xem [feat-vocabulary](../mvp/features/05-vocabulary.md))

---

## JSON Schema

```json
{
  "id": "string (kebab-case, unique)",
  "term": "string (English, primary)",
  "termAlternatives": ["string (alternative English terms)"],
  "translation": "string (Vietnamese)",
  "description": "string (Vietnamese, 1-2 câu)",
  "descriptionEn": "string (English, 1-2 câu)",
  "example": "string (English example sentence from commentary)",
  "exampleVi": "string (Vietnamese translation of example)",
  "tags": ["string"],
  "difficulty": "basic | intermediate | advanced",
  "relatedIds": ["string (other vocabulary IDs)"]
}
```

---

## Difficulty Levels

| Level | Mô tả | Ví dụ |
|---|---|---|
| `basic` | Thuật ngữ cơ bản, hay gặp nhất | offside, penalty, yellow card |
| `intermediate` | Thuật ngữ phổ biến, cần context | DOGSO, clean sheet, nutmeg |
| `advanced` | Thuật ngữ kỹ thuật hoặc slang | xG, pressing, false nine |

---

## Tag Taxonomy

| Tag | Dùng cho |
|---|---|
| `rules` | Thuật ngữ liên quan đến luật |
| `scoring` | Bàn thắng, tỉ số |
| `positions` | Vị trí cầu thủ |
| `tactics` | Chiến thuật |
| `time` | Thời gian, hiệp |
| `referee` | Trọng tài, thẻ |
| `set-piece` | Phạt góc, ném biên, phạt trực tiếp |
| `commentary` | Cụm từ hay dùng trong bình luận |
| `slang` | Tiếng lóng bóng đá |

---

## MVP Vocabulary List (17 terms)

| ID | Term | Translation | Tags |
|---|---|---|---|
| `kickoff` | Kickoff | Bắt đầu trận | `rules`, `time` |
| `offside` | Offside | Việt vị | `rules` |
| `penalty` | Penalty | Phạt đền | `rules`, `referee` |
| `penalty_shootout` | Penalty shootout | Đá luân lưu | `rules` |
| `extra_time` | Extra time | Hiệp phụ | `time` |
| `stoppage_time` | Stoppage time / Added time | Bù giờ | `time`, `referee` |
| `handball` | Handball | Lỗi chạm tay | `rules`, `referee` |
| `foul` | Foul | Phạm lỗi | `rules`, `referee` |
| `booking` | Booking | Thẻ phạt | `referee` |
| `yellow_card` | Yellow card | Thẻ vàng | `referee` |
| `red_card` | Red card | Thẻ đỏ | `referee` |
| `equalizer` | Equalizer | Bàn gỡ hòa | `scoring` |
| `own_goal` | Own goal | Phản lưới nhà | `scoring` |
| `clean_sheet` | Clean sheet | Giữ sạch lưới | `scoring` |
| `corner_kick` | Corner kick | Phạt góc | `set-piece` |
| `goal_kick` | Goal kick | Phát bóng lên | `set-piece` |
| `throw_in` | Throw-in | Ném biên | `set-piece` |

---

## Phase 2 Vocabulary (Commentary Phrases)

| ID | Term | Translation |
|---|---|---|
| `miles_offside` | "Miles offside" | Việt vị rõ ràng |
| `clinical_finish` | "Clinical finish" | Dứt điểm lạnh lùng |
| `parking_the_bus` | "Parking the bus" | Chiến thuật phòng thủ đông người |
| `man_of_the_match` | "Man of the match" | Cầu thủ xuất sắc nhất trận |
| `worldie` | "Worldie" | Bàn thắng đẹp xuất sắc |
| `nutmeg` | "Nutmeg" | Luồn bóng qua háng đối thủ |
| `howler` | "Howler" | Sai lầm nghiêm trọng |

---

## Search Spec

- Search theo `term` (English)
- Search theo `translation` (Vietnamese, normalize dấu)
- Search theo `termAlternatives`
- Filter theo `tags`
- Filter theo `difficulty`

### Vietnamese normalization

Khi search tiếng Việt, normalize để tìm được dù có/không có dấu:

```
"viet vi" → tìm được "Việt vị"
"ban thang" → tìm được "Bàn thắng"
```

---

## File Structure

```
assets/data/vocabulary.json
```

```json
{
  "version": "1.0",
  "lastUpdated": "2026-05-25",
  "items": [
    { ... },
    { ... }
  ]
}
```

---

## Edge cases

- Term có nhiều nghĩa: thêm context bóng đá trong `description`
- Term tiếng Anh có nhiều cách viết: dùng `termAlternatives`

## Open questions

- —

## Next steps

- Viết JSON content cho 17 terms MVP trước Sprint 3
- Implement Vietnamese search normalization
