# AyronCast

Native iOS client for [Ayron](https://github.com/aalonsomavin/Ayron) — the AI analytics agent platform.

AyronCast brings the Ayron chat, dashboard, data sources, and automations experience to iPhone and iPad using SwiftUI. It talks to the same Django backend as the web app.

## Requirements

- macOS with **Xcode 16+**
- **XcodeGen** (`brew install xcodegen`)
- Ayron backend running locally or deployed (see [Ayron README](https://github.com/aalonsomavin/Ayron))

## Quick start

```bash
git clone https://github.com/aalonsomavin/AyronCast.git
cd AyronCast
cp Config/LocalSecrets.example.xcconfig Config/LocalSecrets.xcconfig
xcodegen generate
open AyronCast.xcodeproj
```

Select the **AyronCast** scheme, pick an iOS 17+ simulator or device, and run.

### Backend (local)

```bash
git clone https://github.com/aalonsomavin/Ayron.git
cd Ayron
cp .env.example .env
docker compose up --build
```

Default API URL in Debug: `http://localhost:8000` (set in `Config/Debug.xcconfig`).

## Project layout

| Path | Purpose |
|------|---------|
| `project.yml` | XcodeGen spec — run `xcodegen generate` after changes |
| `project_plan.md` | Technical plan and implementation phases |
| `AyronCast/` | SwiftUI app source |
| `Config/` | Build configuration (API URL, bundle ID) |
| `.cursor/` | Cursor Cloud Agent environment |

## Implementation plan

See [project_plan.md](./project_plan.md) for architecture, API mapping, streaming design, and phased roadmap.

**Current phase:** Fase 1 — repo setup, app shell, design tokens. Next: login, API client, chat streaming.

## Design system

Visual identity follows the Ayron design system in the main repo (`design_system/Ayron/`). Swift tokens live in `AyronCast/Design/AyronTokens.swift`. Cloud Agents can read the canonical web tokens via the linked Ayron repository.

## Cloud Agents

This repository includes `.cursor/environment.json` with a dependency on `github.com/aalonsomavin/Ayron` so agents can reference backend APIs and design assets.

iOS builds and simulator testing require macOS; Cloud Agents on Linux can edit Swift source but cannot compile the app.

## License

Private — Ayron project.
