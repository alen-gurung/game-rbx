# AGENTS.md — game-rbx

Shared engineering rules for every AI agent (Codex, Claude). Detail lives in `docs/`; read only what the task needs.

## Project
- Roblox game, planning complete and gameplay not started. Read [DEVELOPMENT_HANDOFF.md](DEVELOPMENT_HANDOFF.md) and the relevant story before continuing. Design: [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md). Never invent design decisions.
- Wind Up a Toy is the working backlog; inflation-release remains open. M1 is exactly WT01–WT03 (local GAME-001–GAME-003). The saved backlog and documentation request do not authorize implementation; start only when the user requests it. Historical research and unrelated prototypes do not override the current plan.
- Stack: Luau, Rojo 7.7.1 (pinned in `aftman.toml`), Roblox Studio, Git remote `game-rbx`, branch `master`.
- Rojo map (`default.project.json`): `src/shared` → `ReplicatedStorage.Shared`, `src/server` → `ServerScriptService.Server`, `src/client` → `StarterPlayer.StarterPlayerScripts.Client`. Anything built only in Studio is **not** in Git.

## Engineering rules
- Server-authoritative. Clients send requests; the server validates (type, range, rate, ownership, cooldown) and decides. Never trust client values for currency, damage, inventory, or position.
- DataStores when introduced: `pcall` + retry/backoff, save on leave and in `BindToClose`. Never replace a failed load with defaults or falsely confirm a save. Preserve in-session state for retry; after a crash, only the last successfully saved profile is guaranteed. No destructive migrations or production-data changes without explicit user approval.
- Pure production rules belong in a dedicated Rules folder using plain numbers/data tables, including dependencies; no Roblox objects/services, live clocks or saving. Keep those in adapters. Use one authoritative Config folder for balance with explicit units, separate from UI/theme/assets; share calculation/display values.
- Declare message names/payload contracts centrally with separate feature handlers. Capture attempt inputs, preserve per-player state and idempotent settlement, and clean up owned effects/connections. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the proposed layout within the existing mapping.
- Clean up connections and instances on player leave or object removal. Avoid needless per-frame work and remote spam.
- Code: `.luau` files, tab indentation, ModuleScripts for logic, `init.server.luau` / `init.client.luau` as entry points, type annotations on new modules. Follow existing patterns; escalate architectural changes instead of making them.
- Don't change `default.project.json` or `aftman.toml`, and don't delete assets, without approval. Never commit secrets, place files, or oversized media.

## Presentation
- Follow [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md): block out the player route first, then judge toy motion/contact/improvement through the actual gameplay camera and phone viewport. Preserve readable low-quality graphics; no universal terrain, lighting or mesh preset.
- Preserve native Roblox UI, approved Figma references, shared components/theme values and rendered comparisons. Missing cosmetics cannot block progression or recovery. Builders replace only owned objects and preserve unrelated geometry, spawns and lighting; inspect the actual Studio destination before changing it.
- Use the personal `roblox-gameplay`, `roblox-figma-ui` and `roblox-world-design` skills when relevant and available. Their generic base does not replace this project's scope or mapping.

## Process
- Implement against a story in `stories/active/`, staying inside its file scope. Report out-of-scope needs instead of acting on them. Lifecycle: [docs/WORKFLOW.md](docs/WORKFLOW.md).
- Navigation: [docs/SYSTEMS.md](docs/SYSTEMS.md) (where code lives), [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) (how it fits).
- For code changes, establish/run the configured build, offline tests of the production Luau rules, static checks and formatting, then relevant Studio verification. The Rojo build command is `rojo build -o <temp-dir>/check.rbxlx`; the other checks are not configured yet and belong within GAME-001. Record missing checks as unverified, verify local/Studio source freshness, and do not equate arithmetic with visual quality or enjoyment.
- Record reproduced engine pitfalls and regression checks in the relevant story's verification notes; build reusable helpers when a repeated need is demonstrated.
- Never commit, push, or run destructive Git commands without the user's explicit approval.
