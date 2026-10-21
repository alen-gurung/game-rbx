# GAME-001 — Release a duck and complete an attempt

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **M** retained |
| Epic | M1 — Initial playable loop |
| Dependencies | No story dependency; concept decision and explicit implementation request |
| Source ID | WT01 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a player, I want to wind and release an oversized duck so I can watch a complete run and immediately try again.

## Context

- **Problem:** The working concept needs one complete, recoverable attempt before obstacles or progression can be judged.
- **Intended player experience:** As a player, I want to wind and release an oversized duck so I can watch a complete run and immediately try again.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** The existing Rojo scaffold only; attempt rules, server ownership and client presentation are planned systems. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** One start pad, one duck, a straight test strip, basic key and feet movement, slowdown, one stall or flop, a follow camera, distance result and Retry. Use controlled travel and simple original visuals. No steering, reward currency or obstacle system in this story.
- **Excluded:** Steering, obstacles, reward currency, training progression, rebirth, saving and a finished lobby.
- **Assumptions:** The wind-up concept is confirmed before implementation. Start with Power 0 and Level 1; configurable baseline wind must still make the starter attempt readable. Controlled travel and simple original visuals are sufficient for this milestone.
- **Deliverables:** A complete attempt state flow, owned duck presentation, follow camera, forward-distance result, Retry, interruption recovery and the initial local verification procedure.

## Acceptance criteria

- [ ] AC1 — From the ready state, one click or tap starts a brief winding animation and releases exactly one duck. Repeated input during winding or travel cannot start another attempt.
- [ ] AC2 — Every attempt belongs to one player and captures an attempt identifier, course identifier and that player's Power at release. Later stat changes cannot alter an active attempt.
- [ ] AC3 — The camera keeps the duck and its direction of travel readable. Its key and feet move; remaining wind declines; exhaustion produces an unmistakable slowdown and terminal stall or flop.
- [ ] AC4 — Both exhaustion before the finish and reaching the finish produce a distance result and usable Retry action. Distance is measured forward from the start, not total path length.
- [ ] AC5 — Retry clears the previous duck and temporary effects, restores the start state and allows another complete attempt. Ten consecutive attempts do not leave extra ducks, stacked interfaces or active camera controls behind.
- [ ] AC6 — Character reset, death or leaving the attempt ends it without a result reward. The camera and controls recover for the affected player. Another player's ready state and camera are unchanged.
- [ ] AC7 — The launch and result controls work with mouse and touch in the tested phone viewport. The duck and its stopping point remain visible; important text does not cover them. Record whether this was emulation or a physical device.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Own each player's attempt state; validate launch, cancellation and retry requests; capture attempt/course identifiers, launch Power and relevant configuration; determine completion and forward-distance outcome. Never allow a second active attempt for the same player.
- **Client responsibilities:** Provide mouse/touch launch and Retry input, key/feet motion, slowdown and terminal presentation. Restore camera/controls and remove owned temporary presentation on normal end, retry and interruption.
- **Remotes:** Plan client-to-server launch/retry/cancel requests and server-to-client attempt-state/result updates in the central contract. Exact message names and payload fields remain unassigned until the implementation plan; the sender determines ownership, and server state governs valid transitions.
- **Persistence:** None. State is in-session only; no resumable live duck or cross-session save behavior is introduced.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** A completed numerical run can still feel unclear or dull. Missing cosmetics must not block authoritative completion or recovery. Stale callbacks must not recreate a previous attempt.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Add direct tests of production Luau rules for starter wind, exhaustion versus finish, forward-distance cap and attempt transitions; validate finite configuration and prove the chosen loader works offline.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. Launch at a recorded Power that exhausts before the finish → one duck, readable depletion, terminal result and usable Retry.
  2. Use a recorded finish fixture → capped forward distance and a normal finish result.
  3. Repeat ten complete attempts → no extra ducks, stacked UI or active camera controls remain.
  4. Reset, die and leave during an attempt → that attempt cancels, camera/controls recover, and another player's state stays intact.
  5. Repeat launch/result inputs with mouse and touch in the recorded phone viewport → controls stay usable and the stopping point remains visible.
- **Multiplayer:** At least two players: one launches or resets while the other remains ready or in an attempt; verify ownership and camera isolation.
- **Regression:** The source matches the intended Studio place, retries return to a usable start state, and unrelated authored geometry/spawns/lighting remain intact.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Capture one exhaustion, one finish, one interruption and repeated retries. Record the test Power, strip length and device or viewport. Later stories can extend the result panel; this story must already end cleanly.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-001]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT01 planning story into the local GAME-001 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
