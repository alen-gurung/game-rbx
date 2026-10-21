# GAME-002 — Pass an obstacle with more Power

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **M** retained |
| Epic | M1 — Initial playable loop |
| Dependencies | [GAME-001 / WT01](GAME-001-release-duck-attempt.md); concept decision and explicit implementation request |
| Source ID | WT02 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a player, I want a stronger wind to carry my duck past the obstacle that stopped it before, so progress is visible in the world.

## Context

- **Problem:** More Power must produce a visible improvement at the obstacle that previously stopped the duck.
- **Intended player experience:** As a player, I want a stronger wind to carry my duck past the obstacle that stopped it before, so progress is visible in the world.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** Planned attempt rules, course/obstacle adapters and duck presentation introduced by GAME-001. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** One short ramp, one low step and one lightweight block section on the same fixed route. Each uses a bounded reaction: uphill effort, scrambling over the step, or pushing blocks aside. Reuse the same duck and camera. This is not a general physics or navigation system.
- **Excluded:** A general physics/navigation framework, steering, additional obstacle families, new worlds and reward currency.
- **Assumptions:** Use the same fixed course, duck and camera from GAME-001. Low Power is the actual fresh profile at Power 0, not a substituted developer profile. Exact obstacle costs and pass thresholds are tuning inputs to record before acceptance.
- **Deliverables:** One ramp, one step and one block section; bounded reactions; deterministic obstacle outcomes; per-attempt obstacle reset; recorded low/medium/high fixtures.

## Acceptance criteria

- [ ] AC1 — The duck visibly meets each obstacle before its reaction starts. It stays aligned to the course and does not clip straight through the step or untouched blocks.
- [ ] AC2 — Record low, medium and high Power fixtures. Low is the actual fresh profile: Power 0 with the configured baseline wind. It stops at a named early obstacle; medium Power passes that obstacle and stops farther along; high Power clears all three sections and reaches the prototype finish. The starter profile must be below the early obstacle's pass threshold.
- [ ] AC3 — Repeat each fixture three times on the same course. Each repetition produces the same cleared sections and scored stopping distance. Cosmetic variations cannot improve or worsen that result.
- [ ] AC4 — Record the Power threshold for passing the early obstacle. A run just below the threshold fails there; a run at the threshold succeeds. Increasing Power beyond it cannot reduce progress.
- [ ] AC5 — Insufficient remaining wind produces a brief struggle followed by a terminal result. No obstacle can leave the duck scrambling indefinitely. Blocks return to their initial state for the next attempt.
- [ ] AC6 — Keep the next obstacle and the duck's response readable in the phone viewport. Use an initial target of 8 to 20 seconds for the medium or high full attempt, with a maximum two-second struggle before a failed step resolves. These are tuning targets; record changes and their reason. Early failures may be shorter.
- [ ] AC7 — Two players can exercise the prototype without sharing mutable obstacles or run outcomes. One reset does not reset the other player's course.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Compute scored progress from the captured Power/configuration and fixed course. Keep obstacle state owned by the appropriate attempt; ensure more Power cannot reduce scored progress and struggle always resolves.
- **Client responsibilities:** Show contact before each reaction, bounded struggle, slowdown and block scatter while preserving the authoritative outcome and phone-camera readability.
- **Remotes:** Extend the central attempt contract only where obstacle-state presentation needs it. Clients cannot supply cleared obstacles, progress, costs or outcomes as authority; exact names/fields await scope refinement.
- **Persistence:** None. Obstacle state resets per attempt and does not become saved progression.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** Cosmetic collision or scattered blocks may disagree with scored progress, leak between players, or obscure the route. The 8–20 second full-attempt and two-second failed-step struggle targets require runtime tuning.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Add below/at/above threshold tests, fixed-input repeatability, nondecreasing progress over increasing Power and production obstacle-config validation. Expected outcomes must be independently reasoned.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. Run recorded low, medium and high Power fixtures three times each on the same course → identical cleared sections and scored stopping distance for each fixture.
  2. Run just below and exactly at the early obstacle threshold → failure below and success at the threshold; higher Power never scores less.
  3. Observe ramp, step and block contacts → reactions begin after visible contact without untouched-block clipping.
  4. Exhaust wind at an obstacle → brief struggle ends in a result; Retry restores obstacle state.
  5. Record full-attempt and failed-step timings plus phone-view footage → visible next obstacle and reaction, with any target changes explained.
- **Multiplayer:** Two players run and reset independently; one reset must not reset the other's course or outcome.
- **Regression:** GAME-001 launch, finish, exhaustion, interruption, ten-retry cleanup and camera/input recovery still work.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Capture the same obstacle at low and medium Power, a full clear and the repeated-fixture results. The visible interaction and scored result must agree.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-002]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT02 planning story into the local GAME-002 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
