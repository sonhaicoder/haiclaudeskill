# Hai Claude Skill — Personal Skill Pack

> Bộ skill cá nhân cho Claude Code (và các AI coding agent khác). Tổng hợp **14 skill** Hải build hoặc curate, install bằng 1 lệnh.

## Skills (14 — 5 categories)

### 🎨 Frontend / UI Design (5)

| Skill | Trigger | Mục đích |
|-------|---------|----------|
| [`web-taste`](skills/web-taste) | Mọi web file (.tsx/.jsx/.vue/.svelte/.html/.css) hoặc keyword build/design/render web | **Anti-slop web frontend** — Discovery Form + 5 deterministic directions + 27 anti-patterns + ready-to-paste hero/section/motion blueprints. Target Kimi/Lovable-tier. |
| [`frontend-design`](skills/frontend-design) | Mọi web UI task | Kimi formula 7 công thức bí mật typography/spacing/color |
| [`kimi-render`](skills/kimi-render) | Build landing/storefront/marketing page mới | 7 pattern Wanderlust render + spec-first workflow + HTML template |
| [`mobile-design`](skills/mobile-design) | Flutter/RN/iOS/Android UI task | Mobile design formula |
| [`lme-flutter`](skills/lme-flutter) | Project có `lme_ui` dependency | Build Flutter UI bằng package LME |

### ⚙️ Backend / Architecture (2)

| Skill | Trigger | Mục đích |
|-------|---------|----------|
| [`backend-fastapi`](skills/backend-fastapi) | File backend/**/*.py với FastAPI/SQLAlchemy | **Multi-tenant SaaS patterns** — 7 luật cứng: shop_id filter / Decimal money / async / atomic stock / order state machine / JWT auth / Settings env. Plus Alembic migration recipes. |
| [`flutter-architecture`](skills/flutter-architecture) | File .dart với riverpod/dio/go_router | **Flutter production architecture** — Riverpod patterns / Dio interceptors / GoRouter type-safe / Result type / repository pattern / feature-based folder. |

### 🔍 Code Quality (1)

| Skill | Trigger | Mục đích |
|-------|---------|----------|
| [`code-review`](skills/code-review) | "review/check/audit" hoặc trước commit/PR | **6 audit lenses** — security / multi-tenant leak / money precision / race conditions / state machine / API↔frontend boundary. Plus grep recipes + OWASP top 10 mapping. |

### 🛠️ Engineering Workflow (3)

| Skill | Trigger | Mục đích |
|-------|---------|----------|
| [`debug-first`](skills/debug-first) | Error message, traceback, bug, crash, "không chạy", "bị lỗi" | **Đọc error TRƯỚC** — 3-layer error protocol / Python+JS+Flutter error anatomy / git bisect workflow. Stop Googling before understanding the error. |
| [`git-pr`](skills/git-pr) | git commit/push/PR, "viết commit message", rebase, changelog | **Conventional Commits** — types table / atomic commits / PR templates (feature/bugfix/refactor) / branch naming / git recovery recipes. KHÔNG --no-verify. |
| [`deploy`](skills/deploy) | "deploy", Railway/Vercel/VPS, env vars, Dockerfile, "production" | **Pre-deploy checklist** — env vars / port management / Railway+Vercel recipes / DB migration order / CORS / health checks / zero-downtime / rollback. |

### 💬 Workflow / Meta (3)

| Skill | Trigger | Mục đích |
|-------|---------|----------|
| [`brief-recap`](skills/brief-recap) | Sau mọi task code/edit/fix | Trả lời ngắn gọn + giải thích cho dev mobile (Flutter) |
| [`harness`](skills/harness) | "하네스 구성" / harness engineering | Meta skill — define agents + build child skills |
| [`obsidian-skills`](skills/obsidian-skills) | Obsidian vault tasks | Curated từ obsidian-skills repo (defuddle / json-canvas / obsidian-bases / obsidian-cli / obsidian-markdown) |

---

## Cài đặt nhanh

### Option 1 — Symlink toàn bộ (recommended)

```bash
git clone https://github.com/sonhaicoder/haiclaudeskill.git ~/haiclaudeskill
cd ~/haiclaudeskill && ./install.sh
```

`install.sh` symlink TỪNG skill từ repo → `~/.claude/skills/<skill-name>`. Skills cũ sẽ được backup vào `~/.claude/skills.bak/<timestamp>/` (không xoá).

### Option 2 — Symlink 1 skill cụ thể

```bash
ln -s "$(pwd)/skills/web-taste" ~/.claude/skills/web-taste
```

### Option 3 — Copy vào project local (`.claude/skills/`)

```bash
cp -r skills/web-taste <your-project>/.claude/skills/
```

### Option 4 — Vercel `npx skills add`

```bash
npx skills add https://github.com/sonhaicoder/haiclaudeskill
# Hoặc 1 skill cụ thể:
npx skills add https://github.com/sonhaicoder/haiclaudeskill --skill web-taste
```

---

## Gỡ cài đặt

```bash
cd ~/haiclaudeskill && ./uninstall.sh
```

Script remove symlinks. Skills backup ở `~/.claude/skills.bak/<timestamp>/` được giữ nguyên — anh restore manual nếu cần.

---

## Cấu trúc repo

```
haiclaudeskill/
├── README.md                    # File này
├── LICENSE                      # MIT
├── install.sh                   # Symlink 14 skills → ~/.claude/skills/
├── uninstall.sh                 # Remove symlinks
└── skills/
    │
    ├── 🎨 web-taste/             # Anti-slop web (Kimi/Lovable-tier)
    ├── 🎨 frontend-design/       # Kimi 7 công thức
    ├── 🎨 kimi-render/           # 7 Wanderlust patterns + HTML templates
    ├── 🎨 mobile-design/         # Mobile UI formula
    ├── 🎨 lme-flutter/           # LME Flutter package
    │
    ├── ⚙️ backend-fastapi/       # Multi-tenant SaaS — 7 luật cứng
    ├── ⚙️ flutter-architecture/  # Riverpod + Dio + GoRouter patterns
    │
    ├── 🔍 code-review/           # 6 audit lenses + OWASP top 10
    │
    ├── 🛠️ debug-first/           # Đọc error TRƯỚC + git bisect workflow
    ├── 🛠️ git-pr/                # Conventional commits + PR templates
    ├── 🛠️ deploy/                # Railway + Vercel + pre-deploy checklist
    │
    ├── 💬 brief-recap/           # Ngắn gọn + giải thích
    ├── 🛠 harness/                # Meta skill (Korean)
    └── 📝 obsidian-skills/        # Obsidian skills bundle
```

---

## Triết lý skill design (Hải's preferences)

1. **Auto-trigger thay vì user nhớ** — skill kích hoạt theo file extension hoặc keywords, không cần invoke manual
2. **Deterministic > free-form** — 5 directions cụ thể, 7 patterns cụ thể, KHÔNG "AI tự quyết"
3. **Ready-to-paste > rules** — code blueprints copy-paste được, không chỉ best practice abstract
4. **Quality tier scoring** — Kimi/Lovable-tier có checklist 24-26 aspects, không vague "premium"
5. **Anti-AI-slop guardrails** — 27 anti-patterns deterministic, force fix trước ship
6. **Vietnamese-first comm** — em xưng "em" gọi "anh", text Việt có dấu

---

## Standalone repos liên quan

| Repo | Note |
|------|------|
| [web-taste-skill](https://github.com/sonhaicoder/web-taste-skill) | Standalone web-taste skill (đã import vào đây) — có thể fork/share riêng |

---

## License

MIT — fork, edit, remix thoải mái. Credit không bắt buộc nhưng appreciated nếu bạn ship cái gì hay.
