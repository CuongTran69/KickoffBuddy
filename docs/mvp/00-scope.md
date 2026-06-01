---
id: mvp-scope
title: MVP Scope
status: in-progress
phase: mvp
depends-on: [product-vision, product-problems, product-roadmap]
related: [feat-match-scheduler, feat-reminders, feat-replay-planner, feat-rule-cards, feat-vocabulary, data-seed-strategy]
last-updated: 2026-05-29
---

## Mục đích

Định nghĩa rõ ràng những gì có và không có trong MVP (Phase 1). Là tài liệu tham chiếu để tránh scope creep.

## Phạm vi

### In scope

- Match Scheduler: WC 2026 seed (104 trận CC0), Manual Add, Magic Add Lite (regex offline)
- Reminders: local notification, default 1d/3h/30m/5m, custom messages
- Replay Planner: kế hoạch xem lại, ẩn tỉ số/kết quả trong app khi bật
- Rule Cards: 7 chủ đề MVP, 3 level (newbie/casual/advanced)
- Vocabulary: bảng Anh - Việt cơ bản
- Onboarding: chọn timezone, football level, mục tiêu
- Settings: timezone override, notification preferences, disclaimer
- Profile local (không cần login)

### Out of scope (MVP)

- Live score, live data
- Video highlight
- Betting / odds / cash prize
- Public chat / user-generated content
- Official tournament data without license
- Magic Add LLM (Phase 2)
- Sleep Plan (Phase 2)
- Calendar export (Phase 2)
- Widget / Live Activities (Phase 2, sau spike)
- Cloud sync / login (Phase 2)
- Quiz / Simulator (Phase 3)
- Partner Mode / Family Mode (Phase 3)
- Venue Mode (Phase 4)
- Scrape lịch đấu tự động từ nguồn bên ngoài

---

## User stories

- As a Vietnamese fan, I want to see match kickoff times in my local timezone so that I don't miss matches due to timezone confusion.
- As a fan, I want to set reminders before a match so that I'm prepared when it starts.
- As a late watcher, I want to plan my replay time so that I can watch without being spoiled.
- As a new viewer, I want to quickly understand football rules so that I can follow the match.
- As a new viewer, I want an Anh-Việt vocabulary reference so that I understand English commentary.
- As a fan, I want WC 2026 matches pre-loaded so that I don't have to manually enter all 104 matches.

---

## Acceptance criteria

- [x] App hiển thị 104 trận WC 2026 được seed sẵn với giờ local chính xác
- [x] Manual Add form hoạt động offline, lưu trận với UTC kickoff time
- [ ] Magic Add Lite nhận diện được ít nhất 7 regex pattern (xem [feat-match-scheduler](features/01-match-scheduler.md)) _(6/7 pattern done — "Xh sáng/tối giờ VN" deferred → Phase 2)_
- [x] Confirm screen luôn hiển thị sau Magic Add, không bỏ qua được
- [x] Reminder fires đúng giờ trên Android và iOS
- [ ] Android exact-alarm permission được xử lý đúng (Android 12+) _(blocker — chưa làm)_
- [x] Replay Planner ẩn tỉ số/kết quả khi đang bật
- [x] Notification của Replay Planner không leak kết quả
- [x] Rule Cards có đủ 7 chủ đề MVP với ít nhất level newbie
- [x] Vocabulary có ít nhất 17 term từ bảng gốc
- [ ] Onboarding hoàn chỉnh: timezone detect + football level + mục tiêu _(timezone done; football level + mục tiêu deferred → Phase 2)_
- [ ] Disclaimer "unofficial" hiển thị trong About/Settings _(blocker — chưa làm)_
- [x] Không có trademark FIFA/World Cup trong app name, icon, screenshot

---

## Edge cases

- Người dùng thay đổi timezone thiết bị sau khi đã lưu trận: recalculate display time, không thay đổi UTC stored value
- Người dùng từ chối notification permission: app vẫn hoạt động, hiển thị reminder trong app
- Người dùng từ chối clipboard permission (iOS): hiển thị text field để paste thủ công
- WC 2026 seed data có lỗi: cần mechanism để update qua app update

## Open questions

- —

## Next steps

- Implement theo sprint plan trong [product-roadmap](../product/03-roadmap.md)
- Xem chi tiết từng feature trong `mvp/features/`
