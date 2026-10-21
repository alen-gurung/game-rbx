# AGENTS.md — game-rbx

Shared engineering rules for every AI agent (Codex, Claude). Detail lives in `docs/`; read only what the task needs.

## Project
- Roblox game, early stage. Design: [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md). Never invent design decisions.
- Stack: Luau, Rojo 7.7.1 (pinned in `aftman.toml`), Roblox Studio, Git remote `game-rbx`, branch `master`.
- Rojo map (`default.project.json`): `src/shared` → `ReplicatedStorage.Shared`, `src/server` → `ServerScriptService.Server`, `src/client` → `StarterPlayer.StarterPlayerScripts.Client`. Anything built only in Studio is **not** in Git.

## Engineering rules
- Server-authoritative. Clients send requests; the server validates (type, range, rate, ownership, cooldown) and decides. Never trust client values for currency, damage, inventory, or position.
- DataStores: `pcall` + retry/backoff, save on leave and in `BindToClose`, no data loss on failure. No destructive migrations or production-data changes without explicit user approval.
- Clean up connections and instances on player leave or object removal. Avoid needless per-frame work and remote spam.
- Code: `.luau` files, tab indentation, ModuleScripts for logic, `init.server.luau` / `init.client.luau` as entry points, type annotations on new modules. Follow existing patterns; escalate architectural changes instead of making them.
- Don't change `default.project.json` or `aftman.toml`, and don't delete assets, without approval. Never commit secrets, place files, or oversized media.

## Process
- Implement against a story in `stories/active/`, staying inside its file scope. Report out-of-scope needs instead of acting on them. Lifecycle: [docs/WORKFLOW.md](docs/WORKFLOW.md).
- Navigation: [docs/SYSTEMS.md](docs/SYSTEMS.md) (where code lives), [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) (how it fits).
- Validate: `rojo build -o <temp-dir>/check.rbxlx` must succeed, plus any linters or tests that exist. Report exactly what was verified; never claim Studio testing that didn't happen.
- Never commit, push, or run destructive Git commands without the user's explicit approval.
