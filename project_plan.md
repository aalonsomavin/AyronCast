# AyronCast — Plan técnico del cliente iOS

## 1. Visión general

**AyronCast** es el cliente nativo iOS de [Ayron](https://github.com/aalonsomavin/Ayron): una plataforma multi-tenant de conversación con datos empresariales. La app permite a usuarios de una empresa conectarse al backend Ayron, chatear con el agente de IA, consultar dashboards, gestionar fuentes de datos y automatizaciones.

El backend Django (repo **Ayron**) es la fuente de verdad para auth, conversaciones, streaming de eventos del agente, archivos e integraciones. AyronCast consume esas APIs y replica la experiencia del UI kit web (`design_system/Ayron/ui_kits/ayron-app/`) en SwiftUI.

---

## 2. Estado actual del repositorio

| Componente | Estado |
|---|---|
| Repositorio Git + Cloud Agent env | ✅ Configurado |
| `project_plan.md` | ✅ Este documento |
| XcodeGen (`project.yml`) | ✅ Esqueleto del proyecto |
| SwiftUI App Shell (4 pantallas) | ✅ Placeholder inicial |
| Design tokens Swift | ✅ `AyronTokens` |
| Cliente API + auth | ❌ Pendiente |
| SSE / replay de eventos | ❌ Pendiente |
| Chat funcional | ❌ Pendiente |
| Dashboard / Sources / Automations | ❌ Pendiente |
| Descarga de archivos generados | ❌ Pendiente |
| TestFlight / App Store | ❌ Pendiente |

### Estructura del repositorio

```
AyronCast/
├── project.yml                 # XcodeGen — genera AyronCast.xcodeproj
├── project_plan.md
├── README.md
├── .cursor/
│   ├── environment.json        # Cloud Agent: depende de repo Ayron
│   ├── rules/
│   └── skills/
├── Config/
│   ├── Debug.xcconfig
│   └── Release.xcconfig
├── scripts/
│   └── cloud-agent-install.sh
└── AyronCast/
    ├── AyronCastApp.swift
    ├── Design/                 # Tokens y componentes base
    ├── Features/               # Pantallas (Chat, Dashboard, …)
    ├── Networking/             # API client, SSE
    └── Resources/
```

---

## 3. Stack tecnológico

### Cliente iOS

| Tecnología | Rol |
|---|---|
| **Swift 6** | Lenguaje |
| **SwiftUI** | UI declarativa |
| **iOS 17+** | Deployment target (Observable, NavigationStack) |
| **URLSession** | HTTP + SSE streaming |
| **Keychain** | Persistencia segura de sesión |
| **XcodeGen** | Generación reproducible del `.xcodeproj` |

### Backend (repo Ayron)

| Endpoint | Uso en iOS |
|---|---|
| `POST /accounts/login/` | Autenticación (session cookie) |
| `GET /chat/` | Lista de conversaciones |
| `POST /chat/start/` | Nueva conversación |
| `GET /chat/{id}/` | Detalle + mensajes |
| `POST /chat/{id}/send/` | Enviar mensaje al agente |
| `GET /chat/{id}/events/` | Replay de `AgentEvent` |
| `GET /chat/{id}/stream/` | SSE en vivo |
| `POST /chat/{id}/stop/` | Detener agente |
| `GET /files/{id}/download/` | Descargar artefactos |
| `GET /health` | Health check |

Referencia completa del backend: `project_plan.md` en [aalonsomavin/Ayron](https://github.com/aalonsomavin/Ayron).

### Diseño

Los tokens visuales de Ayron (`--ay-*`) se portan a Swift en `Design/AyronTokens.swift`. Referencia canónica: `Ayron/design_system/Ayron/` (accesible vía `repositoryDependencies` en Cloud Agents).

---

## 4. Arquitectura de alto nivel

```
┌─────────────────────────────────────────────────────────┐
│                    AyronCast (SwiftUI)                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────┐  │
│  │   Chat   │ │Dashboard │ │ Sources  │ │Automations│  │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └─────┬─────┘  │
│       └────────────┴────────────┴─────────────┘        │
│                         │                               │
│              ┌──────────▼──────────┐                    │
│              │   AyronAPIClient    │                    │
│              │  (URLSession + SSE) │                    │
│              └──────────┬──────────┘                    │
└─────────────────────────┼───────────────────────────────┘
                          │ HTTPS / SSE
┌─────────────────────────▼───────────────────────────────┐
│              Ayron Django Backend                        │
│         (chat, agent, files, auth, …)                   │
└─────────────────────────────────────────────────────────┘
```

### Principios de diseño

1. **Backend-first**: la app no duplica lógica de negocio; consume las mismas APIs que el front HTMX.
2. **Event-sourced UI**: el chat reconstruye estado desde `AgentEvent` (replay + SSE), igual que el web.
3. **Design parity**: mismas pantallas y copy que `ui_kits/ayron-app/`.
4. **Offline mínimo**: cache de conversaciones recientes; sin modo offline completo en MVP.
5. **Secrets fuera del repo**: `API_BASE_URL` vía `.xcconfig` local; credenciales en Keychain.

---

## 5. Modelo de dominio (cliente)

### 5.1 Sesión

```
Session
├── cookies: HTTPCookieStorage (Django session)
├── userEmail: String
├── companyName: String?
└── expiresAt: Date?
```

### 5.2 Conversación

```
Conversation
├── id: UUID
├── title: String
├── status: idle | processing | completed | error
├── lastSequence: Int
├── messages: [Message]
└── updatedAt: Date
```

### 5.3 Mensaje

```
Message
├── id: UUID
├── role: user | assistant
├── content: String
├── attachments: [FileAttachment]
└── createdAt: Date
```

### 5.4 AgentEvent (streaming)

Tipos alineados con el backend (§7 de Ayron `project_plan.md`):

| Tipo | UI |
|---|---|
| `token` | Append texto al bubble assistant |
| `plan` | Checklist de todos |
| `tool_start` / `tool_end` | Card de tool invocada |
| `file_created` | Link de descarga |
| `skill_proposal` | Badge pendiente |
| `error` | Banner de error |
| `done` | Cierra turno, habilita input |

---

## 6. Capa de networking

### 6.1 Configuración

```swift
enum APIConfiguration {
    static var baseURL: URL { /* Config/AyronCast.xcconfig → API_BASE_URL */ }
}
```

Valores por entorno en `Config/Debug.xcconfig` / `Release.xcconfig`. Para desarrollo local contra Docker Compose de Ayron: `http://localhost:8000`.

### 6.2 Autenticación

Django usa session cookies. `URLSession` con `HTTPCookieStorage.shared` persiste la sesión tras login. Logout: `POST /accounts/logout/`.

### 6.3 SSE

`EventSource`-style sobre `URLSession.bytes(for:)`:

1. `GET /chat/{id}/events/?after=0` — replay completo al abrir chat.
2. Si `status == processing`: `GET /chat/{id}/stream/?after={lastSeq}` — eventos nuevos.
3. Cliente aplica eventos por `sequence_number` ascendente; ignora duplicados.

---

## 7. Pantallas (paridad con UI kit)

| Pantalla | Ruta web | Vista SwiftUI |
|---|---|---|
| Login | `/accounts/login/` | `LoginView` |
| Chat | `/chat/{id}/` | `ChatView` |
| Dashboard | `/` (dashboard) | `DashboardView` |
| Sources | `/integrations/` | `SourcesView` |
| Automations | `/automations/` | `AutomationsView` |

Navegación: `TabView` o sidebar en iPad (`NavigationSplitView`).

---

## 8. Seguridad

| Área | Medida |
|---|---|
| Credenciales | Keychain; nunca en código fuente |
| API URL | `.xcconfig` gitignored local override |
| ATS | HTTPS en producción; excepción localhost en Debug |
| Session | Cookie HttpOnly gestionada por URLSession |
| Archivos | Descarga vía signed URLs del backend |

---

## 9. Variables de configuración

`Config/Debug.xcconfig`:

```
API_BASE_URL = http:/$()/localhost:8000
PRODUCT_BUNDLE_IDENTIFIER = com.ayron.cast.debug
```

`Config/Release.xcconfig`:

```
API_BASE_URL = https:/$()/app.ayron.example
PRODUCT_BUNDLE_IDENTIFIER = com.ayron.cast
```

Copiar `Config/LocalSecrets.example.xcconfig` → `Config/LocalSecrets.xcconfig` para overrides locales (gitignored).

---

## 10. Fases de implementación

### Fase 1 — Fundamentos (actual)
- [x] Repositorio, plan, Cloud Agent env
- [x] XcodeGen + esqueleto SwiftUI
- [x] Design tokens base
- [ ] Login + persistencia de sesión
- [ ] `AyronAPIClient` con health check

### Fase 2 — Chat con agente
- [ ] Lista y creación de conversaciones
- [ ] Envío de mensajes
- [ ] Replay de eventos (`/events/`)
- [ ] SSE streaming (`/stream/`)
- [ ] UI de mensajes + estado "thinking"
- [ ] Stop / retry

### Fase 3 — Artefactos y archivos
- [ ] Evento `file_created` → preview / share sheet
- [ ] Descarga vía `/files/{id}/download/`
- [ ] Upload de archivos al chat (multipart)

### Fase 4 — Dashboard, Sources, Automations
- [ ] Endpoints REST (cuando existan en backend) o WebView híbrida temporal
- [ ] Paridad visual con UI kit

### Fase 5 — Pulido y distribución
- [ ] iPad layout (`NavigationSplitView`)
- [ ] Push notifications (automation runs)
- [ ] TestFlight
- [ ] App Store

---

## 11. Desarrollo local

Requisitos: **macOS**, **Xcode 16+**, **XcodeGen** (`brew install xcodegen`).

```bash
git clone https://github.com/aalonsomavin/AyronCast.git
cd AyronCast
cp Config/LocalSecrets.example.xcconfig Config/LocalSecrets.xcconfig
xcodegen generate
open AyronCast.xcodeproj
```

Backend Ayron en paralelo:

```bash
git clone https://github.com/aalonsomavin/Ayron.git
cd Ayron && cp .env.example .env && docker compose up --build
```

---

## 12. Cloud Agents

Este repo está configurado para Cursor Cloud Agents con dependencia al repo **Ayron** (`repositoryDependencies`). Los agentes pueden leer el design system y el plan del backend durante el desarrollo.

**Nota:** los builds iOS requieren macOS + Xcode. Cloud Agents en Linux preparan código; compilar y probar en simulador es local o CI macOS (Xcode Cloud / self-hosted runner).

---

## 13. Referencias

- [Ayron — project_plan.md](https://github.com/aalonsomavin/Ayron/blob/main/project_plan.md)
- [Ayron Design System](https://github.com/aalonsomavin/Ayron/tree/main/design_system/Ayron)
- [Ayron UI Kit (ayron-app)](https://github.com/aalonsomavin/Ayron/tree/main/design_system/Ayron/ui_kits/ayron-app)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)
- [Apple: URLSession streaming](https://developer.apple.com/documentation/foundation/urlsession)
