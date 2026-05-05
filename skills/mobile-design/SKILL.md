---
name: mobile-design
description: Design formula cho MOBILE APP (Flutter / React Native / SwiftUI / Jetpack Compose / iOS native / Android native). Auto-trigger khi chạm file .dart/.swift/.kt/.java mobile hoặc user nói build app mobile, màn hình mobile, screen, widget Flutter, RN component. KHÔNG dùng cho web — web có skill frontend-design riêng.
---

# Mobile Design Formula (MOBILE APP ONLY)

## AUTO-TRIGGER

Invoke **lần đầu tiên mỗi session** khi:
- User nói: "build app/màn hình/screen/widget Flutter/RN"
- User nói: "thêm/sửa UI mobile/app"
- Agent sắp edit/write file `.dart .swift .kt .java` (trong project mobile)
- Agent sắp chạm thư mục `mobile/` `lib/` `ios/` `android/`

## KHÔNG dùng khi
- Web (React, Next.js, Vue, Svelte, HTML/CSS) → dùng `frontend-design`
- Backend — không có UI

## Tư duy cốt lõi

Mobile ≠ Web thu nhỏ. Công thức khác hoàn toàn:

| | Web | Mobile |
|---|-----|--------|
| Typography scale | Dynamic clamp(44-72px) | Fixed scale (24/20/16/14/12sp) |
| Motion | Long (1.5-3s entrance) | Short (200-400ms) — instant feedback |
| Spacing | py-32 (128px) section | 16dp/24dp base unit |
| Touch target | N/A | Min 44pt iOS / 48dp Android |
| Navigation | Scroll/link | Tab bar / bottom nav / stack |
| Aesthetic | Can be experimental | Platform conventions (Material 3 / HIG) |
| Performance | Depends on device | **Critical** — 60fps mandatory |

## Platform conventions (BẮT BUỘC tuân thủ)

### Flutter
- Material 3 (Android) / Cupertino (iOS) — detect platform, render đúng widget
- Dùng `Theme.of(context)` thay hardcode color
- `MediaQuery` cho responsive, `SafeArea` cho notch
- `Hero` animation cho screen transition
- State: Riverpod / BLoC, KHÔNG setState cho state phức tạp

### React Native
- `Platform.OS` check để render iOS/Android khác nhau
- `SafeAreaView` (react-native-safe-area-context)
- `react-native-reanimated` cho animation (60fps), KHÔNG Animated API cũ
- Navigation: React Navigation (stack/tab/drawer)

### SwiftUI / Jetpack Compose
- Follow Apple HIG / Material 3 spec 100%
- System fonts, system colors (dark mode auto)
- Accessibility-first: VoiceOver / TalkBack

## Design tokens (cho Commerce mobile app)

```dart
// Flutter example — lib/core/theme.dart
class AppColors {
  // Light mode
  static const bgPrimary = Color(0xFFF5F5F7);
  static const bgCard = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textMuted = Color(0xFF666666);
  static const accent = Color(0xFF007AFF);  // iOS blue — hoặc Material 3 seed
  static const danger = Color(0xFFFF3B30);
  static const border = Color(0xFFE5E5E7);

  // Dark mode
  static const bgPrimaryDark = Color(0xFF000000);
  static const bgCardDark = Color(0xFF1C1C1E);
  static const textPrimaryDark = Color(0xFFF5F0EB);
  // ...
}

class AppSpacing {
  static const xs = 4.0;   // 4dp
  static const sm = 8.0;
  static const md = 16.0;  // base
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class AppTypography {
  static const display = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2);
  static const title = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.25);
  static const headline = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const body = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static const bodySmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5);
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;  // card/modal default
  static const xl = 24.0;
  static const pill = 999.0;
}
```

## Mobile UX rules

1. **Touch target ≥ 44pt (iOS) / 48dp (Android)** — không được nhỏ hơn
2. **Feedback trong 100ms** — haptic, visual press state
3. **Loading ≤ 300ms → không cần indicator** (user không kịp nhận ra)
4. **Loading > 1s → phải có skeleton/shimmer** (không spinner thuần)
5. **Gesture natural** — swipe back iOS, pull-to-refresh, long-press menu
6. **Offline-first** — cache data local, sync background (quan trọng với Commerce VN)
7. **Keyboard awareness** — scroll content lên khi keyboard mở, don't hide inputs
8. **Error recovery** — mọi error phải có CTA retry, không dead-end

## Anti-patterns

| Sai | Đúng |
|-----|------|
| Fixed pixel height | `MediaQuery.of(context).size.height * x` |
| setState cho toàn screen | Riverpod selector / BLoC state slice |
| `print()` debug | `debugPrint()` hoặc logger package |
| Hardcode color | `Theme.of(context).colorScheme.xxx` |
| Blocking main thread | `compute()` cho heavy work |
| Image.network không cache | `cached_network_image` package |
| `setState(() {})` sau async gap không check `mounted` | `if (!mounted) return;` |
| Web design system (liquid glass, GSAP) | Platform conventions — Material/Cupertino |

## Self-check trước khi ship mobile UI

```
□ Touch targets ≥ 44pt/48dp?
□ Theme tokens dùng nhất quán (không hardcode color/spacing)?
□ Dark mode support?
□ Loading state (skeleton, không spinner thuần)?
□ Empty state có illustration + CTA?
□ Error state có retry button?
□ Keyboard handling (scroll, dismiss, action button)?
□ SafeArea cho notch/home indicator?
□ Accessibility (semanticsLabel, contrast ≥ 4.5:1)?
□ 60fps khi scroll list dài? (flutter profile mode test)
□ Offline graceful (cached data + sync indicator)?
□ Haptic feedback trên action quan trọng?
```

## TODO — khi Commerce bắt đầu build mobile

Hiện chưa có project mobile nào của anh active. Khi bắt đầu Flutter admin app, expand skill này với:
- Riverpod patterns cho Commerce state (shops, orders, products)
- Hive/Isar offline storage cho order pipeline
- Image caching strategy cho product catalog
- Barcode scanner integration cho inventory
- Bluetooth printer cho in đơn (Commerce-specific)
- VNPay / MoMo SDK mobile integration
- Push notification (FCM/APNs) cho order updates
