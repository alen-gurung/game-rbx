# Systems Index

Updated 22 October 2026, Europe/Paris. This index separates inspected source from planned responsibilities. Read only the systems relevant to the selected story; add actual module paths and evidence as implementation occurs.

System status values: Template · Planned · In Progress · Implemented · Deprecated. A **Planned** system is not implemented or authorized. All GAME-001–GAME-009 development stories are **Blocked** pending final concept selection and an explicit implementation request, plus their dependencies. Original aliases are WT01–WT09. M1 contains exactly GAME-001–GAME-003 (WT01–WT03).

## Existing source

| System | Source paths | Runs on | Dependencies | Story | Status | Observed behavior |
|---|---|---|---|---|---|---|
| Server entry | `src/server/init.server.luau` | Server | None | None | Template | Prints a hello message only |
| Client entry | `src/client/init.client.luau` | Client | None | None | Template | Prints a hello message only |
| Hello module | `src/shared/Hello.luau` | Shared | None | None | Template | Returns a hello-print function; not required by either entry |
| Baseplate and environment properties | `default.project.json` | Workspace, Lighting, SoundService | Existing Rojo mapping | None | Template | Inline template objects/properties; not a gameplay course or chosen art direction |

The three Luau files above are the complete current source inventory. No gameplay build, sync or Studio test was run for this documentation update. Preserve `default.project.json` and `aftman.toml` unless the user approves a change.

## Planned responsibilities

Paths below are proposed locations within the current Rojo mapping, not files that already exist. One authoritative `src/shared/Config/` folder and one `src/shared/Rules/` folder serve the features; do not duplicate tuning or rules inside each handler. Shared files are replicated, so they contain no secrets. See [ARCHITECTURE.md](ARCHITECTURE.md) for boundaries and remaining choices.

| System | Proposed source area | Runs on | Depends on | Story | Status | Required outcome |
|---|---|---|---|---|---|---|
| Pure rules and balance data | `src/shared/Rules/`, `src/shared/Config/` | Server; Rules also run offline | Verified compatible module loader | GAME-001 (WT01), extended by later stories | Planned | Plain data only, including dependencies; explicit units; production rules used by offline tests |
| Network contract and adapters | `src/shared/Net/Contract.luau`, feature handlers under server/client roots | Shared declaration, separate server/client handlers | Authoritative state and payload validation | GAME-001 onward | Planned | Central message names/shapes/states; validated requests; feature handlers remain separate |
| Player state and attempt lifecycle | `src/server/Features/`, `src/server/Services/`, relevant Rules/Config modules | Server | Rules, Config, contract | GAME-001 (WT01) | Planned | Captured attempt inputs; repeatable capped forward progress; completion, cancellation, retry and isolation |
| Duck, camera and result presentation | `src/client/Controllers/`, `src/client/Presentation/`, native UI components/theme | Client; server-authoritative state | Attempt state, recoverable source assets | GAME-001 (WT01) | Planned | Readable key/feet, slowdown, terminal outcome, result/Retry, camera/control recovery and cleanup |
| Obstacles and deterministic progress | Rules/Config extensions, server feature handlers, client presentation | Server rules and owned presentation | Attempt lifecycle | GAME-002 (WT02) | Planned | Ramp, step and blocks; threshold fixtures; real contact matches score; per-attempt reset |
| Training, Power and derived Level | Rules/Config extensions, server feature handler, client controller/UI | Server progression, client display | Obstacles and validated sessions | GAME-003 (WT03) | Planned | One session per player; validated ticks and fractional gains; earned improvement; profile fields agreed |
| Flags, Wins and completed-run best | Rules/Config extensions, server settlement handler, client results | Server settlement, client display | Training loop | GAME-004 (WT04) | Planned | Five flags; once-only settlement; interruption rules; retained best and explicit course completion |
| Bench eligibility and multipliers | Rules/Config extensions, server training handler, client bench UI | Server eligibility, client display | Training loop | GAME-005 (WT05) | Planned | Three benches at 1x/1.5x/2x, unlocked at 0/1/2 rebirths; no stacked sessions |
| Rebirth transaction | Rules/Config extensions, server progression handler, client preview | Server transaction, client confirmation | Flags/Wins and benches | GAME-006 (WT06) | Planned | Exact eligibility and atomic reset; duplicate protection; two unlock steps and clear initial cap |
| Lobby guidance and onboarding | Server action/progress state, client UI and scoped world presentation | Server-observed actions, client guidance | Rebirth loop | GAME-007 (WT07) | Planned | Training, attempt and improvement advance the introduction; useful current objective; readable phone flow |
| Versioned profile persistence | `src/server/Services/` plus pure validation/transition rules where applicable | Server | Profile fields and progression/onboarding | GAME-008 (WT08) | Planned | Consistent saved snapshots, safe load/save failure handling, session conflicts, no resumable live attempt |
| Shared-session completion and load evidence | Existing features/presentation; focused validation helpers when justified | Server and clients | Persistence and all earlier features | GAME-009 (WT09) | Planned | Overlapping players, late joins and cleanup; stated device/population checks; no racing/trading system |
| Repeatable project checks | `tests/rules/` and a documented check entry point chosen during implementation | Local verification | Selected compatible tools | GAME-001 onward | Planned | Build, production-rule tests, static checks and format checks with honest per-check results |

Player ownership and basic multiplayer isolation start in GAME-001; GAME-009 completes shared-session evidence rather than introducing ownership at the end. GAME-004 and GAME-005 may proceed independently after GAME-003 once implementation is authorized. No later progression or finished lobby is needed to pass M1.

## Remotes

**None implemented.** The central contract path above is proposed. Exact transport, names, instance location, payloads and rate limits remain unresolved until implementation. Record each introduced message with:

| Required field | What to record |
|---|---|
| Name and direction | Exact declared name; client → server or server → client |
| Payload and allowed states | Data types, finite ranges, identifiers and valid lifecycle states |
| Server validation | Ownership, eligibility, timing/rate, current state and authoritative calculation |
| Duplicate behavior | What happens on repeated or late requests and stale attempt/session IDs |
| Handler path | Actual server/client handler file and owning story |

Launch, training, results and later progression are planned request/state responsibilities, not existing API names. Clients do not determine authoritative Power, distance, costs, rewards or saved progress.

## DataStores

**None implemented.** GAME-008 owns saving; profile fields must be agreed by GAME-003. Proposed source fields are Power, Wins, rebirth count, personal best, introduction status and profile version. Level and bench eligibility are derived. Store/key names, schema version value, session strategy, persistence library and isolated test environment are still open decisions.

When introduced, record the exact store name, key format, schema version, owner module, test/production separation, migration policy and verification evidence. Do not record secrets. Never save a live attempt or treat a failed load as a new account.

## Verification and navigation

- [GAME_DESIGN.md](GAME_DESIGN.md): working concept, rules and open tuning.
- [ROADMAP.md](ROADMAP.md) and [BACKLOG.md](../stories/BACKLOG.md): milestone membership, dependency order and story state.
- [ARCHITECTURE.md](ARCHITECTURE.md): current mapping, proposed boundaries, ownership and unresolved technical choices.
- [WORKFLOW.md](WORKFLOW.md): required checks, Studio evidence, user playtest and explicit Git approval.

No placeholder in this index is an implementation claim. Replace proposed areas with verified file paths as systems are created, and keep failed or unrun checks visible in their story evidence.
