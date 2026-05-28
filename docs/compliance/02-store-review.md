---
id: compliance-store-review
title: Store Review Guidelines
status: planned
phase: compliance
depends-on: [compliance-trademark]
related: [compliance-store-listing, future-sleep-plan]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa các rủi ro store review và cách giảm thiểu. Bao gồm Apple App Store và Google Play.

## Phạm vi

### In scope

- Apple App Store guidelines liên quan
- Google Play policies liên quan
- Sleep Plan wording (Apple 1.4.1)
- Vietnam age rating (June 2026)

### Out of scope

- Full App Store Review Guidelines (quá dài)
- Legal advice

---

## Apple App Store

### Guideline 1.4.1 — Medical/Health Claims

**Rủi ro:** Sleep Plan có thể bị reject nếu framing như tư vấn y tế.

**Cách giảm:**
- Framing rõ ràng: "gợi ý sinh hoạt cá nhân", không phải "tư vấn y tế"
- Disclaimer bắt buộc trong Sleep Plan UI
- Không dùng từ ngữ như "healthy sleep", "optimize sleep", "sleep therapy"

**Wording an toàn:**
```
Đây là gợi ý lịch sinh hoạt dựa trên giờ trận. Không phải tư vấn y tế.
```

**Wording cần tránh:**
```
Tối ưu hóa giấc ngủ của bạn
Cải thiện sức khỏe giấc ngủ
Chế độ ngủ lành mạnh
```

### Guideline 5.1 — Privacy

**Rủi ro:** Clipboard access (iOS) cần permission và giải thích rõ ràng.

**Cách giảm:**
- Chỉ đọc clipboard khi user bấm "Magic Add"
- Không đọc clipboard tự động khi mở app
- Privacy Policy mô tả rõ clipboard usage
- Nếu user từ chối: hiển thị text field thay thế

### Guideline 4.2 — Minimum Functionality

**Rủi ro:** App quá đơn giản có thể bị reject.

**Cách giảm:**
- MVP có đủ 5 tính năng khác biệt: Match Scheduler, Reminders, Replay Planner, Rule Cards, Vocabulary
- WC 2026 seed (104 trận) tăng giá trị ngay khi mở app

### Guideline 2.3 — Accurate Metadata

**Rủi ro:** Store description không khớp với app thực tế.

**Cách giảm:**
- Screenshots phản ánh đúng UI thực tế
- Description không overpromise (ví dụ: không nói "chống spoil 100%")
- Không dùng keyword nhồi nhét

---

## Google Play

### Health Policy

**Rủi ro:** Tương tự Apple 1.4.1 — Sleep Plan wording.

**Cách giảm:** Giống Apple — framing thông tin, không phải tư vấn y tế.

### Gambling Policy

**Rủi ro:** App bóng đá có thể bị nhầm với betting app.

**Cách giảm:**
- Không có odds, betting, cash prize
- Store description nhấn mạnh: "No betting, no live score"
- App category: Sports hoặc Lifestyle, không phải Casino

### Notification Policy

**Rủi ro:** Notification spam có thể bị report.

**Cách giảm:**
- User chủ động bật reminder, không có default notification
- User có thể tắt từng reminder riêng lẻ
- Không gửi marketing notification

---

## Vietnam Age Rating (Quan trọng)

**Thay đổi từ 18/6/2026:** Việt Nam yêu cầu age rating mới cho app trên Google Play và App Store.

- Cần submit age rating questionnaire trước ngày 18/6/2026
- Kickoff Buddy: không có violence, không có adult content, không có gambling → rating thấp (4+ hoặc Everyone)
- Nếu không submit trước deadline: app có thể bị gỡ khỏi store tại Việt Nam

**Action item:** Submit age rating questionnaire trước 18/6/2026.

---

## Checklist trước khi submit

### Apple App Store

- [ ] Privacy Policy URL hoạt động
- [ ] Sleep Plan có disclaimer rõ ràng (không phải tư vấn y tế)
- [ ] Clipboard usage được giải thích trong Privacy Policy
- [ ] Screenshots phản ánh đúng UI thực tế
- [ ] App không crash khi không có internet
- [ ] App không crash khi notification permission bị từ chối
- [ ] Disclaimer "unofficial" hiển thị trong About screen
- [ ] Không có trademark trong app name, icon, screenshots

### Google Play

- [ ] Privacy Policy URL hoạt động
- [ ] Age rating questionnaire hoàn thành
- [ ] Không có betting/gambling content
- [ ] Notification chỉ gửi khi user đã opt-in
- [ ] App hoạt động đúng trên Android 8+ (API 26+)

---

## Response Template (nếu bị reject)

Nếu Apple/Google reject vì trademark:

```
Kickoff Buddy is an unofficial football companion app that helps fans plan match times,
set reminders, and learn football rules. The app does not use any official tournament
trademarks, logos, or assets. Any mention of tournaments (e.g., "World Cup 2026") is
purely descriptive to help users understand the app's use case, not to imply official
affiliation. The app includes a clear disclaimer stating it is not affiliated with any
football federation or tournament organizer.
```

---

## Edge cases

- Store reviewer hỏi về Sleep Plan: chuẩn bị response nhấn mạnh "informational, not medical advice"
- App bị gỡ vì Vietnam age rating: submit questionnaire ngay

## Open questions

- Cần xác nhận deadline chính xác cho Vietnam age rating change

## Next steps

- Submit age rating questionnaire trước 18/6/2026
- Review Sleep Plan wording trước Phase 2 launch
- Chuẩn bị response templates cho store review
