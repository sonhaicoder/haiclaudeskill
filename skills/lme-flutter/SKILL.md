---
name: lme-flutter
description: Build Flutter UI bằng package lme_ui (lme-ui-flutter). Auto-trigger khi project có dependency `lme_ui`, file Dart import `package:lme_ui/lme_ui.dart`, hoặc user nói "build screen/feature LME", "dùng Lme component", hoặc đang code trong lsite-mobile/itg-mobile/các project dùng LME design system. Workflow: parse Figma → match LME pattern → compose component (KHÔNG tự build), apply tokens (LmeColors/LmeTypography/LmeSpacing/LmeRadius), dùng LmeIcons (CẤM Material Icons).
---

# LME Flutter Skill — Build với lme_ui design system

## AUTO-TRIGGER

Invoke **lần đầu mỗi session** khi:
- Project pubspec có `lme_ui:` dependency
- File Dart sắp edit có `import 'package:lme_ui/lme_ui.dart'`
- User nói: "build chat screen LME", "dùng Lme component", "code feature trong lsite/itg-mobile"
- User gửi link Figma kèm yêu cầu code Flutter UI cho project có lme_ui

## KHÔNG dùng khi
- Project Flutter KHÔNG dùng lme_ui → dùng `mobile-design` skill
- Web → dùng `frontend-design` / `kimi-render`

---

## Tư duy cốt lõi

```
KHÔNG tự build component nếu LME đã có.
KHÔNG hardcode color/font/spacing — luôn dùng LmeTheme.of(context) tokens.
KHÔNG dùng Material Icons — luôn LmeIcons.*
KHÔNG extend Material widget — chỉ compose.
LUÔN check pattern reference TRƯỚC khi code feature mới.
```

---

## Workflow chuẩn (5 bước)

### Bước 1 — RECON (đọc context)

**Path quan trọng** (cache vào memory mỗi session đầu):
- LME repo root: `/Volumes/hai/lme-ui-flutter`
- Component list: `/Volumes/hai/lme-ui-flutter/lib/src/components/lme_*/README.md`
- Patterns (cực giá trị): `/Volumes/hai/lme-ui-flutter/example/lib/patterns/`
- Demo pages: `/Volumes/hai/lme-ui-flutter/example/lib/demo/lme_*_demo_page.dart`
- Icon set: `/Volumes/hai/lme-ui-flutter/lib/src/icons/lme_icons.dart` (202 icons)
- Foundations: `/Volumes/hai/lme-ui-flutter/lib/src/foundations/lme_*.dart`
- Project rules: `/Volumes/hai/lme-ui-flutter/CLAUDE.md`

**Đọc trước khi code:**
1. Liệt kê file pattern liên quan: `ls /Volumes/hai/lme-ui-flutter/example/lib/patterns/`
2. Nếu pattern khớp use case → đọc full → copy adapt (NHANH HƠN build từ 0 rất nhiều)
3. README component nào sắp dùng → đọc props bảng để biết API chính xác

### Bước 2 — PARSE FIGMA

Khi user gửi link Figma:
1. Extract `fileKey` + `nodeId` từ URL (`figma.com/design/:fileKey/...?node-id=:nodeId` → đổi `-` thành `:`)
2. Gọi `mcp__claude_ai_figma__get_design_context` với fileKey + nodeId
3. Đọc screenshot + structure
4. **MAP NGAY** mỗi element trong design → LME component:
   - Avatar tròn → `LmeAvatar` (`.image` / `.text` / empty + `showDot`/`pinned`)
   - List item chat → row tự build với `LmeAvatar` + `LmeBadge.dot` + tokens (LME KHÔNG có `LmeChatTile` sẵn)
   - Header với leading/trailing → `LmeHeader`
   - Tabs → `LmeTabs` + `LmeTabItem`
   - Bottom sheet → `LmeBottomSheet.show` + `LmeBottomSheetHeader.close` + `LmeBottomSheetAction`
   - Popover menu → `LmePopoverMenu.show` + `LmePopoverMenuItem` (anchor bằng `GlobalKey`)
   - Empty state → `LmeEmpty` + `LmeEmptyIllust.*`
   - Multi-select check → `LmeCheckCircle`
   - Chat input bar → `LmeMessageInput` (có sẵn reply preview, attach, send)
   - Keyboard toolbar → `LmeKeyboardActions` + `LmeToolbarAction`
   - Insert menu (sticker/file) → `LmeInsertMenu.show`
   - Tag pill → `LmeTag` (hoặc tự build nếu Figma khác)
   - Button → `LmeButton`
   - Input field → `LmeInputTextField`
   - Modal → `LmeModal`
   - Drawer → `LmeDrawer`
   - Dialog → `LmeDialog`
   - Toast → `LmeToast`
   - Status pill → `LmeStatus`
   - Switch / Radio / Checkbox → `LmeSwitch` / `LmeRadio` / `LmeCheckBox`
   - Date / Time picker → `LmeDatePicker` / `LmeTimePicker` / `LmeCalendar`
   - Stepper → `LmeStepper` / `LmeStep`
   - Walkthrough overlay → `LmeWalkthrough`
   - Swipe action row → `LmeSwipeAction`
   - Image preview → `LmePreviewImage`
   - Uploader → `LmeUploader`
   - Select dropdown / bottom sheet picker → `LmeSelect`
   - Breadcrumb → `LmeBreadcrumb`
   - Headline → `LmeHeadline`
   - Nav bar (bottom) → `LmeNavBar`

### Bước 3 — CHECK ICONS

Trước khi code, đọc `/Volumes/hai/lme-ui-flutter/lib/src/icons/lme_icons.dart` (202 icons có sẵn).

**Cheatsheet 10 icon hay dùng:**

| Material `Icons.*` | LME equivalent |
|---|---|
| `Icons.chevron_right` | `LmeIcons.arrowChevronRight` |
| `Icons.chevron_left` | `LmeIcons.arrowChevronLeft` |
| `Icons.keyboard_arrow_down` | `LmeIcons.arrowChevronDown` / `arrowTransitionDown` |
| `Icons.check` | `LmeIcons.statusCheck` |
| `Icons.close` / `Icons.clear` | `LmeIcons.actionClose` |
| `Icons.search` | `LmeIcons.actionSearch` / `inputSearch` |
| `Icons.add` | `LmeIcons.moveAdd` |
| `Icons.delete_outline` | `LmeIcons.editDelete` |
| `Icons.person` | `LmeIcons.userUser` |
| `Icons.error` / warning | `LmeIcons.systemAlertFill` |
| `Icons.tune` / filter control | `LmeIcons.actionControl` |
| `Icons.filter_list` | `LmeIcons.actionFilter` |

Không match? Grep trong `lme_icons.dart` hoặc check `tools/config.mjs` `NAME_MAP` (Japanese name từ Mishona set).

**CẤM tuyệt đối Material `Icons.*` trong code mới.** Chỉ 3 ngoại lệ legacy đã biết: `format_bold`/`format_italic`/`format_strikethrough` trong `lme_keyboard_toolbar.dart`.

### Bước 4 — CODE (compose, never extend)

**Skeleton chuẩn:**
```dart
import 'package:flutter/material.dart';
import 'package:lme_ui/lme_ui.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = LmeTheme.of(context); // ← lấy tokens, KHÔNG hardcode

    return Scaffold(
      backgroundColor: tokens.colors.background,
      body: Column(
        children: [
          LmeHeader(title: 'Title'),
          // ... compose Lme components
        ],
      ),
    );
  }
}
```

**Rules cứng:**
- Mọi color → `tokens.colors.*` (CẤM `Color(0xFF...)` trừ khi pattern Figma đã pixel-perfect lock — copy cả block `_kPageBg` constants từ pattern reference)
- Mọi spacing → `tokens.spacing.*` (xs/sm/md/lg/xl/xxl/xxxl)
- Mọi font → `tokens.typography.*` (display/title/body/label)
- Mọi radius → `tokens.radius.*`
- Mọi icon → `LmeIcons.*`
- Component với onPressed nullable = disabled state (KHÔNG tạo `disabled: bool` riêng)

**Khi LME không có sẵn (vd message bubble bóng chat):**
- Tự build, nhưng **dùng tokens hết** — không hardcode
- Đặt trong `widgets/` của feature, không global

### Bước 5 — VERIFY

Trước khi báo "xong":
- [ ] `flutter analyze` pass
- [ ] Không còn `Icons.*` Material trong file mới (`grep -n "Icons\." <file>`)
- [ ] Không còn `Color(0xFF...)` hardcode (trừ pattern lock)
- [ ] Không extend Material widget (`extends ElevatedButton/TextField/...`)
- [ ] Không `Platform.isIOS/Android` trong UI
- [ ] Test trên device/simulator nếu có thể

---

## Pattern reference đã verify (CẬP NHẬT KHI THÊM)

| Use case | Pattern file | Components |
|----------|--------------|------------|
| Chat/message list với search/filter/select/bulk action | `example/lib/patterns/lme_message_list_pattern.dart` | LmeAvatar, LmeBadge.dot, LmeTabs, LmeCheckCircle, LmeBottomSheet, LmePopoverMenu, LmeHeader, LmeEmpty |
| Swipe row 1-chiều (right→left) reveal actions | `example/lib/demo/lme_swipe_action_demo_page.dart` (`_SwipeableRow`) | LmeSwipeAction.preset + GestureDetector + AnimationController + SlideTransition (KHÔNG cần flutter_slidable) |
| Swipe row 2-chiều (left↔right) | lsite-mobile `swipeable_message_row.dart` | Stack + Transform.translate + clamp drag từ -98 → +98, OverflowBox để action không squish |

> Khi build feature mới và **không thấy pattern khớp** → check lại `ls /Volumes/hai/lme-ui-flutter/example/lib/patterns/` xem có pattern mới không. Nếu thật sự không có, build từ component README.

---

## Common pitfalls (đã từng sai, đừng lặp)

1. ❌ Nhầm `LmeList` cho chat conversation list → `LmeList` là **key-value list** (form/profile), KHÔNG phải chat list. Chat list phải tự compose row.
2. ❌ Nhầm `LmeMessageCreation` cho 1-1 chat → đó là **builder cho campaign message** (compose nhiều message gửi hàng loạt).
3. ❌ Quên `LmeTheme.of(context)` ancestor — components cần `MaterialApp` wrap `LmeTheme.light()` ở root.
4. ❌ Wrap demo page trong `MaterialApp` thứ 2 — ko cần, gallery đã wrap rồi.
5. ❌ Resize `LmeAvatar` bằng `SizedBox` → dùng prop `size: LmeAvatarSize.sm/md/lg`.
6. ❌ Đoán tên icon → check `/Volumes/hai/lme-ui-flutter/lib/src/icons/lme_icons.dart` trước. VD: KHÔNG có `systemInformation`, đúng là `LmeIcons.systemInfo` / `systemInfoFill`.
7. ❌ Dùng `LmeTabs` mặc định cho > 4 tabs → set `variant: LmeTabsVariant.scrollable` cho 5-6 tab horizontal scroll.
8. ❌ `LmeSwipeAction` width 98 với label katakana 6 ký tự (vd "ブックマーク") sẽ wrap 2 dòng. Công thức: katakana CJK full-width ≈ 12px/char × N + padding 40 = min width. "ブックマーク" 6 chữ → cần ≥ 112, set **width 120** an toàn (110 vẫn thiếu).

---

## Project context (cập nhật khi đổi)

### lsite-mobile
- Path: `/Volumes/hai/lsite-mobile`
- pubspec dep: `lme_ui` từ git ref `build_phase_1`
- LmeTheme: đã wrap ở `lib/app/app.dart:19`
- Feature đang code: chat (`lib/features/home/presentation/`)
  - `tabs/chat_tab.dart` — CHA, list conversations
  - `page/messages/` — CON, detail page + widgets
- Pattern target: `lme_message_list_pattern.dart` (đã verify gần khớp)

---

## Self-update rule

Mỗi khi học được điều mới về LME (component mới, pattern mới, pitfall mới, project mới dùng LME), **cập nhật vào skill này**, không chỉ memory cá nhân. Skill này là source of truth cho mọi session sau.

Section cần update khi:
- Phát hiện component LME mới chưa list ở Bước 2 → thêm vào bảng map
- Tìm thấy pattern mới giá trị → thêm vào bảng "Pattern reference"
- Sai một lần → ghi vào "Common pitfalls"
- Project mới adopt LME → thêm vào "Project context"
- Icon mapping mới hay dùng → thêm vào cheatsheet
