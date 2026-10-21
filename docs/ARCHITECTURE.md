# Architecture

_Last verified against the repo: 2026-10-21 (commit `bbed4e4`)._

## Current state
The repository is the unmodified **Rojo 7.7.1 starter template**. No gameplay systems, remotes, persistence, or UI exist in source yet. Client and server architecture patterns are **not yet decided**; see the open questions below.

## Tooling
- **Rojo 7.7.1**, pinned in `aftman.toml` and installed via Aftman.
- **Studio sync:** `rojo serve` plus the Rojo Studio plugin. Build a place from scratch with `rojo build -o game-rbx.rbxlx` (the output is gitignored).
- **No** package manager (Wally), linter (selene), formatter (StyLua), type checker (luau-lsp CLI), test framework, or CI is configured.

## Rojo mapping (`default.project.json`)

| Filesystem | Studio instance | Notes |
|---|---|---|
| `src/shared/` | `ReplicatedStorage.Shared` (Folder) | ModuleScripts visible to client and server |
| `src/server/` | `ServerScriptService.Server` (Script, via `init.server.luau`) | Child `.luau` files become ModuleScripts under the Script |
| `src/client/` | `StarterPlayer.StarterPlayerScripts.Client` (LocalScript, via `init.client.luau`) | Same, under the LocalScript |
| (inline) | `Workspace.Baseplate` | Anchored 512×20×512 Part defined in the project file |
| (inline) | `Lighting`, `SoundService` properties | Template defaults (Lighting.Technology = Voxel) |

Not mapped: `ServerStorage`, `ReplicatedFirst`, `StarterGui`, `StarterPack`, `StarterCharacterScripts`, `Teams`. Rojo doesn't manage these, so anything in them exists only in Studio. Changing the mapping requires approval (see [DECISIONS.md](DECISIONS.md)).

`Workspace.FilteringEnabled = true` in the project file is a legacy no-op. FilteringEnabled is always on.

## Client/server boundary
No `RemoteEvent` or `RemoteFunction` objects exist yet. When they're introduced, document each one here: name, direction, payload, server validation, and rate limit.

## Persistence
No DataStore usage. Before the first persistent feature, decide on the schema, key format, session locking, and the dev/test vs production separation (record this in DECISIONS.md).

## UI and assets
No UI code or asset references in source. Studio-built UI or models would not be in Git.

## Environments
Only local Studio exists so far. No published experience IDs, test places, or production environment are documented. Add them here once they exist; never commit secrets or API keys.

## Known risks and gaps
- **Studio-only content isn't versioned.** The place file is gitignored, so maps, models, or UI built in Studio and outside the Rojo mapping can be lost or diverge from Git.
- **No static analysis.** Validation is limited to `rojo build`, so Luau type and syntax errors only surface in Studio.
- `src/shared/Hello.luau` is an unused template module, and both entry scripts only print.

## Open architecture questions (decide before the first gameplay story that needs them)
- Module loading pattern: single-script bootstrapper with service/controller modules, or another approach.
- Networking: plain RemoteEvents in a known folder, or a library.
- Data: raw DataStoreService wrapper, or a library such as ProfileStore.
- Whether to add Wally packages and selene/StyLua/luau-lsp tooling.
