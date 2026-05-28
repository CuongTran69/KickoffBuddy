---
id: ops-accessibility
title: Accessibility
status: planned
phase: foundational
depends-on: [arch-tech-stack]
related: [ops-i18n, future-family-mode]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa yêu cầu accessibility cho Kickoff Buddy. Đảm bảo app dùng được với font lớn, screen reader và reduced motion.

## Phạm vi

### In scope

- Font scale (Dynamic Type iOS, Font Size Android)
- Screen reader (TalkBack, VoiceOver)
- Color contrast
- Reduced motion
- Touch target size

### Out of scope

- Full WCAG 2.1 AA audit (cần manual testing với assistive technology)
- Braille display support

---

## Font Scale

App phải hoạt động đúng khi user tăng font size hệ thống:

- iOS Dynamic Type: hỗ trợ từ Small đến Accessibility Extra Extra Extra Large
- Android Font Size: hỗ trợ từ 0.85x đến 1.3x (hoặc cao hơn)

### Flutter implementation

```dart
// Dùng MediaQuery.textScaleFactor để detect
// Không hardcode font size tuyệt đối cho text quan trọng
// Dùng sp (scalable pixels) thay vì dp cho font size
```

### Test cases

- [ ] Match card hiển thị đúng ở font 1.5x
- [ ] Rule card readable ở font 1.5x
- [ ] Countdown pill không bị cắt ở font 1.3x
- [ ] Button text không bị overflow ở font 1.5x

---

## Screen Reader

### Semantic labels

Tất cả interactive elements phải có semantic label:

```dart
Semantics(
  label: 'Thêm trận mới',
  child: IconButton(icon: Icon(Icons.add), onPressed: ...),
)
```

### Focus order

- Focus order phải theo thứ tự logic (top-left → bottom-right)
- Modal dialogs phải trap focus
- Sau khi đóng modal: focus trả về element đã mở modal

### Test cases

- [ ] TalkBack (Android) đọc được tất cả interactive elements
- [ ] VoiceOver (iOS) đọc được tất cả interactive elements
- [ ] Countdown hiển thị đúng khi screen reader bật

---

## Color Contrast

Tuân thủ WCAG 2.1 AA:
- Text thường: contrast ratio ≥ 4.5:1
- Text lớn (≥ 18sp hoặc 14sp bold): contrast ratio ≥ 3:1
- UI components: contrast ratio ≥ 3:1

### Dark mode (default)

- Background: #121212 hoặc tương đương
- Text chính: #FFFFFF hoặc #E0E0E0
- Accent: chọn màu đủ contrast với background tối

### Test tools

- Flutter DevTools: Accessibility inspector
- Contrast checker: https://webaim.org/resources/contrastchecker/

---

## Reduced Motion

Một số user bật "Reduce Motion" trên iOS hoặc "Remove Animations" trên Android:

```dart
final reduceMotion = MediaQuery.of(context).disableAnimations;

if (reduceMotion) {
  // Bỏ qua animation, hiển thị trực tiếp
} else {
  // Animation bình thường
}
```

Áp dụng cho:
- Countdown animation
- Card flip animation (nếu có)
- Transition animations

---

## Touch Target Size

Minimum touch target: 48×48dp (theo Material Design và Apple HIG)

```dart
// Đảm bảo button có minimum size
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(...),
)
```

---

## Edge cases

- User dùng external keyboard: tất cả actions phải accessible qua keyboard
- User dùng Switch Access (Android): focus order phải đúng

## Open questions

- Full WCAG 2.1 AA validation cần manual testing với assistive technologies và expert review

## Next steps

- Setup accessibility testing trong Sprint 4
- Test với TalkBack và VoiceOver trước khi submit store
