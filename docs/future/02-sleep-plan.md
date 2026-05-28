---
id: future-sleep-plan
title: Sleep Plan (Phase 2)
status: planned
phase: phase-2
depends-on: [feat-match-scheduler, feat-replay-planner]
related: [compliance-store-review]
last-updated: 2026-05-25
---

## Mục đích

Gợi ý lịch ngủ/thức phù hợp với giờ trận cho người xem ở múi giờ lệch. Tính năng mang tính **thông tin cá nhân**, không phải tư vấn y tế. Framing phải rõ ràng để tránh vi phạm Apple Guideline 1.4.1.

## Phạm vi

### In scope

- 3 chế độ: Late Watcher (tên cũ: Hardcore Fan), Balanced, Healthy Replay
- Gợi ý dựa trên giờ kickoff local
- Disclaimer rõ ràng: không phải tư vấn y tế
- Tích hợp với Replay Planner

### Out of scope

- Theo dõi giấc ngủ thực tế
- Tích hợp với Health app (Apple Health / Google Fit)
- Tư vấn y tế

---

## User stories

- As a late watcher, I want sleep schedule suggestions so that I can plan my night around the match.
- As a balanced viewer, I want options for watching part of the match live so that I don't miss everything.
- As a health-conscious viewer, I want to know when to sleep and watch the replay so that I don't sacrifice sleep.

---

## Acceptance criteria

- [ ] 3 chế độ hiển thị dựa trên giờ kickoff
- [ ] Disclaimer "Đây là gợi ý sinh hoạt cá nhân, không phải tư vấn y tế" hiển thị rõ ràng
- [ ] Tên "Late Watcher" (không dùng "Hardcore Fan")
- [ ] Tích hợp với Replay Planner: chế độ Healthy Replay tự gợi ý bật Replay Planner

---

## 3 Chế độ

### Late Watcher

Dành cho người muốn xem live bằng mọi giá.

```
Trận bắt đầu lúc 02:00.
Gợi ý: ngủ từ 21:30 đến 01:30, xem trận, sau đó ngủ bù nếu có thể.
```

### Balanced

Dành cho người vẫn cần giữ sức.

```
Trận bắt đầu lúc 02:00.
Bạn có thể ngủ sớm, thức xem hiệp 2 hoặc xem lại vào sáng mai.
```

### Healthy Replay

Dành cho người ưu tiên giấc ngủ.

```
Trận này quá muộn. Gợi ý bật Replay Planner và xem lại lúc 07:00.
```

---

## Disclaimer (bắt buộc)

Phải hiển thị rõ ràng, không ẩn trong fine print:

```
Đây là gợi ý sinh hoạt cá nhân dựa trên giờ trận. Không phải tư vấn y tế.
Nếu bạn có vấn đề về giấc ngủ, hãy tham khảo bác sĩ.
```

**Lý do:** Apple Guideline 1.4.1 yêu cầu app không cung cấp thông tin y tế sai lệch hoặc gây hiểu nhầm. Sleep Plan phải được framing là thông tin, không phải prescription.

---

## Edge cases

- Trận diễn ra vào giờ bình thường (18:00-22:00): không hiển thị Sleep Plan
- Người dùng ở timezone khác với Việt Nam: tính theo local time của người dùng

## Open questions

- —

## Next steps

- Implement trong Phase 2 sau khi MVP ổn định
- Review disclaimer với Apple Guideline 1.4.1 trước khi submit
