# game-rbx

Roblox development repository for the working **Wind Up a Toy** concept. Train by winding a small toy, release an oversized duck, and improve enough to pass the obstacle that stopped the previous attempt.

**As of 22 October 2026:** planning is complete for nine stories; gameplay implementation has not started. Wind-up versus inflation-release remains open. This documentation update does not authorize coding or publishing. The source still contains the Rojo starter scripts.

## Start here

- [Development handoff](DEVELOPMENT_HANDOFF.md): current state, boundaries and next step.
- [Game design](docs/GAME_DESIGN.md): working rules, bounded scope and unresolved decisions.
- [Roadmap](docs/ROADMAP.md): M1, M2, M3 and optional future candidates.
- [Backlog](stories/BACKLOG.md): nine local story files, mapped from WT01–WT09 to GAME-001–GAME-009.
- [Architecture](docs/ARCHITECTURE.md) and [systems index](docs/SYSTEMS.md): existing starter source versus planned systems.
- [Workflow](docs/WORKFLOW.md), [decisions](docs/DECISIONS.md), [agent rules](AGENTS.md) and [Claude role](CLAUDE.md): planning, implementation, verification and approval.
- [References](references/README.md): inspected screenshot inventory and usage limits.

M1 contains exactly the original WT01–WT03: complete a duck attempt, pass an obstacle with more Power, then earn that improvement through training. The other six stories add flags/Wins, benches, rebirth, onboarding, saving and shared-session verification.

## Local source and Studio

The project uses Luau and Rojo 7.7.1, pinned in `aftman.toml`. Existing mapping:

| Local folder | Studio destination |
|---|---|
| `src/shared/` | `ReplicatedStorage.Shared` |
| `src/server/` | `ServerScriptService.Server` |
| `src/client/` | `StarterPlayer.StarterPlayerScripts.Client` |

To build a fresh starter place when development is requested:

```powershell
rojo build -o "game-rbx.rbxlx"
rojo serve
```

Open the built place in Studio and connect the Rojo plugin to the server. The generated place is gitignored. For a build check, prefer a temporary output path as described in [WORKFLOW.md](docs/WORKFLOW.md). Inspect the actual development place and preserve any authored content before syncing or rebuilding; a generated code-only place is not a backup of unmapped Studio work.

Only the Rojo configuration is present. Offline production-rule tests, static analysis, formatting and a combined verification command still need to be established in GAME-001 when implementation begins. No gameplay or Studio acceptance checks have passed in this documentation task.

## Planning provenance

The established plan comes from the sibling [research/planning handoff](../winning-ideas-rbx/DEVELOPMENT_HANDOFF.md). Current rules and stories are now recorded locally so development does not depend on reading that entire research archive. Links to the sibling research folder provide historical context and are local-machine links; a standalone checkout may not contain it.

The separate [Roblox Game Base](../Roblox-Game-Base-template/README.md) supplies reusable guidance for future projects. Its generic template is not a replacement for this repository's existing mapping, tools or game-specific scope.
