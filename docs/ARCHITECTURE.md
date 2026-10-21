# Architecture

Updated 22 October 2026, Europe/Paris. Repository source and configuration inspected on this date; no gameplay build, sync or Studio verification was performed for this documentation update.

## Current state and authorization

The repository contains the Rojo starter: two entry scripts that print hello messages, one unused shared hello module, and the baseplate and environment properties in `default.project.json`. No gameplay rules, balance modules, remotes, persistence, UI or asset references exist in source yet.

The imported plan uses Wind Up a Toy as its working concept. Inflation-release remains an alternative; the user has not selected the final concept or requested game implementation. Every development story is **Blocked**, pending that choice and an explicit implementation request, plus its listed dependencies. [GAME_DESIGN.md](GAME_DESIGN.md) defines the working rules, [ROADMAP.md](ROADMAP.md) defines scope, and [the backlog](../stories/BACKLOG.md) maps local GAME-001–GAME-009 to original WT01–WT09. M1 contains exactly GAME-001–GAME-003 (WT01–WT03).

The architecture below records established requirements and a proposed fit to the existing mapping. Proposed paths are not implemented systems and are not instructions to create empty folders or a generic framework. See D-004–D-007 in [DECISIONS.md](DECISIONS.md).

## Tooling and source ownership

- Rojo **7.7.1** is pinned in `aftman.toml`. The pin does not establish that the executable or Studio plugin is installed in a particular environment.
- Scripts are authored in local `src/` files. The intended sync flow is `rojo serve` plus the Rojo Studio plugin. A build check is `rojo build -o <temp-dir>/check.rbxlx`; record the actual command and result when it runs.
- No package manager, linter, formatter, standalone type checker, offline test runner or CI is configured in this repository.
- GAME-001 must establish a repeatable build, offline production-rule tests, static-analysis and formatting check, using verified compatible tool versions. Selecting or installing that tooling has not happened in this documentation task. Changes to `aftman.toml` or `default.project.json` require user approval.
- Keep editable asset sources, generated builders, imported asset IDs and transfer instructions recoverable when those assets are introduced. Choose and document an authored place/model export procedure before relying on Studio-only geometry. A code-only build must not replace a place containing unmapped authored content.

## Existing Rojo mapping

| Filesystem or project entry | Studio destination | Current contents |
|---|---|---|
| `src/shared/` | `ReplicatedStorage.Shared` (Folder) | `Hello.luau`; accessible to server and clients |
| `src/server/` | `ServerScriptService.Server` (Script through `init.server.luau`) | Hello print; future child modules sit under this Script |
| `src/client/` | `StarterPlayer.StarterPlayerScripts.Client` (LocalScript through `init.client.luau`) | Hello print; future child modules sit under this LocalScript |
| Inline `Workspace.Baseplate` | Workspace | Anchored 512 × 20 × 512 template Part |
| Inline Lighting and SoundService properties | Respective services | Template properties, including `Lighting.Technology = Voxel`; no chosen art direction is implied |

`ServerStorage`, `ReplicatedFirst`, `StarterGui`, `StarterPack`, `StarterCharacterScripts` and `Teams` have no source mapping. Do not assume Studio-authored content in those locations is versioned. The project also contains the legacy `Workspace.FilteringEnabled` property; this documentation update leaves the mapping unchanged.

## Planned code responsibilities

These paths preserve the existing lowercase source roots and fit the current mapping. Add only the modules needed by the authorized story.

| Proposed location | Responsibility | First relevant story |
|---|---|---|
| `src/shared/Config/` | One authoritative folder of small plain-data balance modules with explicit units: starting values, wind, movement, obstacle costs, training rates and thresholds; later rewards and rebirth costs | GAME-001; extend with each feature |
| `src/shared/Rules/` | Pure calculations and state transitions for attempts, obstacles, training, derived Level, and later progression | GAME-001; extend with each feature |
| `src/shared/Net/Contract.luau` | Central message names, directions, payload shapes and allowed states; no feature handlers | GAME-001 |
| `src/shared/Types/` | Shared data types where needed; dependencies used by Rules remain engine-free | As needed |
| `src/server/Features/`, `src/server/Services/` | Request validation, player and attempt ownership, clocks, world queries, state changes and later saving | GAME-001 onward |
| `src/client/Controllers/`, `src/client/Presentation/` | Input, follow camera, received state, key/feet/struggle motion, results and presentation cleanup | GAME-001 onward |
| `src/client/UI/Components/`, `src/client/UI/Theme/` | Reusable native controls, shared visual values and state binding following approved Figma/reference work | As needed by the story |
| `tests/rules/` | Offline tests that load the production Luau rules and validate production balance data | GAME-001 onward |

All files under `src/shared` are replicated by the existing map. Proposed balance data there must therefore be safe for clients to read; it is never a secret or a source of client authority. If a future requirement needs private balance data, agree a suitable mapping while preserving one authoritative Config source. Do not duplicate values in server, UI and tests to work around that decision. Credentials never belong in shared code or config.

### Pure rules and balance

Rules accept ordinary numbers, strings, booleans and data tables, including explicit configuration and time/random inputs where needed. They return results without mutating inputs. Their transitive dependencies cannot require Instances, Roblox datatypes, services, the `script` hierarchy, live clocks, waits, networking or saving. Adapters convert world measurements into rule inputs and apply rule outputs to Roblox objects and authoritative state.

The chosen loader must prove that the same production Luau modules run offline and in Studio. A second implementation in another language, a directory named Rules, or a Studio test harness does not establish that boundary.

Config holds tunable gameplay values once, with clear units and validated finite values, positive intervals, ordered thresholds, known identifiers and reachable progression. UI and server calculations use those values or derived authoritative snapshots. Theme colors, asset IDs and runtime state belong outside balance Config. Record the fixture/config revision used for verification, and snapshot the relevant attempt values at launch so later Power or tuning changes cannot alter an active result.

### Player, attempt and presentation ownership

Server-owned per-player state starts in GAME-001. The player may have one training session or one challenge at a time. Each launch captures the player, attempt identifier, course identifier, Power and relevant attempt configuration. Distinguish persistent Power from temporary remaining wind. Fixed course and captured Power produce repeatable scored forward progress; increasing Power cannot reduce that progress, and the finite course caps it.

The server owns transitions through ready, winding, travel and terminal outcomes; the concrete state representation is an implementation decision. Normal exhaustion and finishing are completed outcomes. Death, reset, leaving or disconnect before settlement cancel the attempt. GAME-004 adds once-only flag reward settlement and completed-run personal best; a settled result is not undone or paid again by later interruption or result input.

Keep obstacles and temporary presentation associated with the correct player/attempt. One player's reset must not reset another player's obstacles or camera. Cleanup invalidates old callbacks, disconnects listeners, removes owned temporary objects, and restores the affected camera and controls. Missing or late cosmetic assets cannot block authoritative completion or recovery, but required missing visual cues still fail their acceptance criteria.

Builders may replace only their owned objects. Preserve unrelated geometry, spawns and lighting. Parallel workers can prepare distinct local outputs; one coordinator applies shared Studio mutations and checks their combined result.

## Client/server contract

No remotes currently exist. The initial contract will cover action requests and authoritative state/results needed by the selected concept. Declare each concrete message in `src/shared/Net/Contract.luau` when its story is implemented, then index its name, direction, payload, allowed states, validation, duplicate behavior and handler in [SYSTEMS.md](SYSTEMS.md).

Clients request actions such as launch or training start/stop. The server validates types, finite ranges, ownership, current state, eligibility, rate and timing, then computes outcomes from its own state and config. Client-provided Power, distance, reward totals, prices, inventory or positions are never authoritative. Keep feature handlers separate from the contract. The transport choice, remote object location, exact payloads and rate limits remain decisions for the first story that needs them; no networking library is selected.

## Persistence

No DataStore or save implementation exists. Agree profile fields by GAME-003; cross-session saving belongs to GAME-008. The planned saved source fields are Power, Wins, rebirth count, personal best, introduction status and a profile version. Derive Level and bench eligibility from source fields. Never save a live duck, camera, training session or pending attempt as resumable gameplay.

Before GAME-008, decide and record the schema, store/key format, session ownership/conflict strategy, migration policy, retry behavior and separate test environment. Raw DataStoreService versus a library remains open. Use protected calls and bounded retry/backoff, save on leave and shutdown, retain failed-save state for retry, and never treat a load failure as a new player. Restore the last successfully saved profile after a crash; unconfirmed changes may be lost. Duplicate settlement/rebirth delivery must not apply progression twice, and old sessions must not overwrite newer committed state.

## UI, world and evidence

No implemented UI, assets, course or game lighting has been verified here. Preserve the existing Figma/native Roblox workflow: shared components/theme, recoverable assets, relevant references and rendered Studio comparisons. The separate coconut UI prototype is prior work, not evidence for this game's HUD or gameplay.

Block out the player route and judge it through the actual follow camera and phone viewport. Keep the toy, obstacle contact, stopping point and improvement readable before decoration. Choose lighting/detail for the approved art direction and tested device, including low graphics quality. The current template lighting is not an art decision.

Record intended Studio place identity and meaningful local-to-Studio source freshness before playtest acceptance. Record screenshots/captures, device or viewport, fixture values, interruption and retry behavior, and multiplayer isolation. Phone emulation is not physical-device validation. Numerical passes cannot establish contact readability, timing, camera recovery or enjoyment. See [WORKFLOW.md](WORKFLOW.md) for the verification and approval gates.

## Open decisions and current gaps

- Final concept and explicit implementation authorization; if inflation-release is selected, revise all affected story criteria before coding.
- Exact starter tuning, obstacle costs, thresholds and later economy fixtures; existing timing ranges are prototype targets, not a finished balance.
- Module loading/bootstrap and compatible offline runner; concrete build/static/format commands and tool versions.
- Network transport, concrete contract and handler layout within the approved mapping.
- Recoverable map/model authoring and export procedure; final UI references and asset provenance.
- Save schema/library/session strategy and isolated test experience before GAME-008.
- Intended Studio destination, published/test experience IDs, target physical devices and representative server population. None is documented as verified by this update.

These gaps do not authorize tool installation, mapping edits, source changes, Studio mutations or publication. Record decisions as they are actually made and evidence as checks actually run.
