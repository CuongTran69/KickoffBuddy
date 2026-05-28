---
id: docs-readme
title: Kickoff Buddy — Documentation Index
status: in-progress
phase: foundational
depends-on: []
related: [glossary, product-vision, mvp-scope]
last-updated: 2026-05-25
---

## Mục đích

Tài liệu này là điểm vào duy nhất cho toàn bộ docs của Kickoff Buddy. Nó liệt kê tất cả file, quy ước viết và trạng thái hiện tại.

## Phạm vi

### In scope

- Index tất cả file docs
- Quy ước frontmatter và section
- Status legend
- Hướng dẫn sử dụng docs set này

### Out of scope

- Nội dung chi tiết của từng file (xem file tương ứng)

---

## Cách dùng docs set này

Docs được viết cho 2 đối tượng: AI assistant và solo developer. Ngôn ngữ chính là tiếng Việt cho prose, tiếng Anh cho code identifier, tên file, giá trị frontmatter và thuật ngữ kỹ thuật.

Mỗi file bắt đầu bằng YAML frontmatter với các trường `id`, `title`, `status`, `phase`, `depends-on`, `related`, `last-updated`. Dùng `id` để cross-link giữa các file.

---

## Status legend

| Status | Ý nghĩa |
|---|---|
| `planned` | Đã có spec, chưa implement |
| `in-progress` | Đang làm |
| `done` | Hoàn thành |
| `deferred` | Tạm hoãn, có lý do |

## Phase legend

| Phase | Ý nghĩa |
|---|---|
| `foundational` | Nền tảng, không phụ thuộc phase |
| `mvp` | MVP — Phase 1 |
| `phase-2` | Phase 2 — Engagement |
| `phase-3` | Phase 3 — Differentiation |
| `phase-4` | Phase 4 — Monetization/B2B |
| `ops` | Vận hành liên tục |
| `compliance` | Tuân thủ pháp lý/store |

---

## File map

### Root

| File | ID | Phase | Status |
|---|---|---|---|
| [README.md](README.md) | docs-readme | foundational | in-progress |
| [glossary.md](glossary.md) | glossary | foundational | planned |

### product/

| File | ID | Phase | Status |
|---|---|---|---|
| [01-vision.md](product/01-vision.md) | product-vision | foundational | planned |
| [02-problems.md](product/02-problems.md) | product-problems | foundational | planned |
| [03-roadmap.md](product/03-roadmap.md) | product-roadmap | foundational | planned |
| [04-ux-flows.md](product/04-ux-flows.md) | product-ux-flows | mvp | planned |
| [05-risks.md](product/05-risks.md) | product-risks | foundational | planned |

### mvp/

| File | ID | Phase | Status |
|---|---|---|---|
| [00-scope.md](mvp/00-scope.md) | mvp-scope | mvp | planned |
| [features/01-match-scheduler.md](mvp/features/01-match-scheduler.md) | feat-match-scheduler | mvp | planned |
| [features/02-reminders.md](mvp/features/02-reminders.md) | feat-reminders | mvp | planned |
| [features/03-replay-planner.md](mvp/features/03-replay-planner.md) | feat-replay-planner | mvp | planned |
| [features/04-rule-cards.md](mvp/features/04-rule-cards.md) | feat-rule-cards | mvp | planned |
| [features/05-vocabulary.md](mvp/features/05-vocabulary.md) | feat-vocabulary | mvp | planned |

### future/

| File | ID | Phase | Status |
|---|---|---|---|
| [01-magic-add-llm.md](future/01-magic-add-llm.md) | future-magic-add-llm | phase-2 | planned |
| [02-sleep-plan.md](future/02-sleep-plan.md) | future-sleep-plan | phase-2 | planned |
| [03-fan-etiquette.md](future/03-fan-etiquette.md) | future-fan-etiquette | phase-2 | planned |
| [04-quiz-simulator.md](future/04-quiz-simulator.md) | future-quiz-simulator | phase-3 | planned |
| [05-partner-mode.md](future/05-partner-mode.md) | future-partner-mode | phase-3 | planned |
| [06-family-mode.md](future/06-family-mode.md) | future-family-mode | phase-3 | planned |
| [07-venue-mode.md](future/07-venue-mode.md) | future-venue-mode | phase-4 | planned |

### architecture/

| File | ID | Phase | Status |
|---|---|---|---|
| [01-tech-stack.md](architecture/01-tech-stack.md) | arch-tech-stack | foundational | planned |
| [02-folder-structure.md](architecture/02-folder-structure.md) | arch-folder-structure | foundational | planned |
| [03-data-model.md](architecture/03-data-model.md) | arch-data-model | foundational | planned |
| [04-time-handling.md](architecture/04-time-handling.md) | arch-time-handling | foundational | planned |
| [05-backend-strategy.md](architecture/05-backend-strategy.md) | arch-backend-strategy | phase-2 | planned |
| [06-design-system.md](architecture/06-design-system.md) | arch-design-system | foundational | planned |

### content/

| File | ID | Phase | Status |
|---|---|---|---|
| [01-content-strategy.md](content/01-content-strategy.md) | content-strategy | foundational | planned |
| [02-rule-cards-spec.md](content/02-rule-cards-spec.md) | content-rule-cards-spec | mvp | planned |
| [03-vocabulary-spec.md](content/03-vocabulary-spec.md) | content-vocabulary-spec | mvp | planned |

### data/

| File | ID | Phase | Status |
|---|---|---|---|
| [01-seed-strategy.md](data/01-seed-strategy.md) | data-seed-strategy | mvp | planned |
| [02-data-sources.md](data/02-data-sources.md) | data-sources | foundational | planned |
| [03-team-reference.md](data/03-team-reference.md) | data-team-reference | mvp | planned |

### ops/

| File | ID | Phase | Status |
|---|---|---|---|
| [01-analytics.md](ops/01-analytics.md) | ops-analytics | ops | planned |
| [02-i18n.md](ops/02-i18n.md) | ops-i18n | foundational | planned |
| [03-accessibility.md](ops/03-accessibility.md) | ops-accessibility | foundational | planned |
| [04-testing.md](ops/04-testing.md) | ops-testing | mvp | planned |
| [05-monetization.md](ops/05-monetization.md) | ops-monetization | phase-2 | planned |

### compliance/

| File | ID | Phase | Status |
|---|---|---|---|
| [01-trademark.md](compliance/01-trademark.md) | compliance-trademark | compliance | planned |
| [02-store-review.md](compliance/02-store-review.md) | compliance-store-review | compliance | planned |
| [03-store-listing.md](compliance/03-store-listing.md) | compliance-store-listing | compliance | planned |

### archive/

| File | Ghi chú |
|---|---|
| [2026-05-25-original-plan.md](archive/2026-05-25-original-plan.md) | Bản gốc 2026-05-25. Superseded. Giữ để tham khảo. |

---

## Quy ước frontmatter

```yaml
---
id: <kebab-case-id>
title: <Title Case>
status: planned        # planned | in-progress | done | deferred
phase: mvp             # foundational | mvp | phase-2 | phase-3 | phase-4 | ops | compliance
depends-on: [<id>, <id>]
related: [<id>, <id>]
last-updated: 2026-05-25
---
```

## Quy ước section (theo thứ tự)

1. `## Mục đích` — 1-3 câu lý do file này tồn tại
2. `## Phạm vi` — `### In scope` / `### Out of scope`
3. `## User stories` — nếu là feature file
4. `## Acceptance criteria` — checkboxes `- [ ]`
5. `## Edge cases` — bullet list
6. `## Open questions` — bullet list (dùng "—" nếu không có)
7. `## Next steps` — bullet list

## Open questions

- —

## Next steps

- Cập nhật status từng file khi bắt đầu implement
- Thêm `depends-on` links khi rõ dependency
