# GAME-009 — Play alongside others reliably

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **M** retained |
| Epic | M3 — Saved and shared sessions |
| Dependencies | [GAME-008 / WT08](GAME-008-saved-progress.md); concept decision and explicit implementation request |
| Source ID | WT09 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a player, I want to share the workshop with others while my own training and duck attempt remain dependable.

## Context

- **Problem:** The compact shared workshop must remain coherent when several players train, launch, reset, rejoin and rebirth concurrently.
- **Intended player experience:** As a player, I want to share the workshop with others while my own training and duck attempt remain dependable.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** All established gameplay/persistence adapters plus shared-lobby visibility and player/attempt presentation cleanup. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** Complete visibility of other players' training and ducks, independent attempts, shared-lobby behavior and recovery checks. Use the per-player state ownership established in WT01. This story does not add racing, trading or competition rewards.
- **Excluded:** Racing, trading, competition rewards, added progression systems and publication authorization.
- **Assumptions:** Per-player state ownership already exists from GAME-001. This story completes shared visibility/reliability; it does not replace a global single-player architecture. Intended population and physical device targets must be recorded before release-readiness load checks.
- **Deliverables:** Coherent other-player toy/training presentation, independent overlapping attempts, late-join behavior, repeated-loop cleanup and documented population/device evidence.

## Acceptance criteria

- [ ] AC1 — At least two test players train, stop, switch benches and launch overlapping attempts. Their Power, remaining wind, flags, camera state, bests and Wins remain independent.
- [ ] AC2 — One player stopping, resetting, rebirthing, leaving or rejoining does not move or reset another player's duck, blocks, progress or camera. Players and other ducks cannot physically block the scored route.
- [ ] AC3 — A joining player sees a coherent shared lobby and any visible in-progress toy presentations. Joining does not restart an existing attempt or create a duplicate duck. Each player can identify their own duck during overlapping runs.
- [ ] AC4 — Each participant completes repeated train, attempt, result and rebirth loops. Completed or abandoned runs clean up their temporary objects and connections rather than accumulating them.
- [ ] AC5 — Before public release is considered, record the intended server population and device target, then run a representative load check at that population. Record frame behavior, delays, active-object cleanup and any failures. A two-player correctness check alone is not a capacity claim.
- [ ] AC6 — Record the desktop and phone environments actually tested. A phone emulator is not described as physical-device validation. Any untested target remains an explicit release-readiness gap.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Keep stats, flags, transactions, obstacle state and attempts independently owned; ensure players/ducks cannot physically block the scored route; synchronize coherent in-progress presentation for joiners.
- **Client responsibilities:** Identify the local duck during overlap, show coherent other-player activity, and clean only the ending player's/session's presentation without disturbing other cameras or toys.
- **Remotes:** Review the existing central contract for owner/session identity, late-join state and bounded update frequency. Exact additions follow observed needs; no client can control another player's attempt or progression.
- **Persistence:** Reuse GAME-008's profile/session protection; shared presentation is temporary and never stored as resumable gameplay.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** Two-player correctness is not a capacity claim. Unrecorded device targets, leaked temporary objects, delayed callbacks and overlapping presentation can hide performance or ownership failures.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Run relevant production-rule/config checks and focused owner/session transition tests where pure logic applies. Performance, physical blocking and live multiplayer remain Studio checks.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. Use at least two players to train, Stop, switch and overlap attempts → independent Power/wind/flags/camera/bests/Wins.
  2. Stop/reset/rebirth/leave/rejoin one player while the other finishes → no effect on the other duck, obstacles, progress or camera.
  3. Join during visible toy activity → coherent lobby and existing presentations without restarted attempts or duplicate ducks.
  4. Repeat train/attempt/result/rebirth loops per participant → temporary objects/connections clean up for completed and abandoned runs.
  5. Record target population/devices and run representative load checks before release is considered → frame behavior, delays, cleanup/failures and all remaining gaps are documented.
- **Multiplayer:** At least two for correctness, then the recorded intended population for a representative load check; neither player count is a release authorization.
- **Regression:** Save/rejoin protection, once-only settlement, input/camera recovery and per-player obstacle reset remain correct under overlap.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Capture overlapping attempts and one player's interruption while the other finishes. Record participant count, population target, tested devices, repeated-run results and remaining performance gaps.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-009]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT09 planning story into the local GAME-009 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
