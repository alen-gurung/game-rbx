# GAME-003 — Train and improve the next attempt

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **M** retained |
| Epic | M1 — Initial playable loop |
| Dependencies | [GAME-002 / WT02](GAME-002-obstacles-and-power.md); concept decision and explicit implementation request |
| Source ID | WT03 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a player, I want to wind a small toy to earn Power, then release the large duck and see a better result.

## Context

- **Problem:** The player must earn enough Power through normal training to pass the same obstacle that stopped the fresh profile.
- **Intended player experience:** As a player, I want to wind a small toy to earn Power, then release the large duck and see a better result.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** Planned attempt state from GAME-001/002 plus training/level rules, bench interaction and HUD feedback. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** One starter bench, a repeated key-turning training action, Power gains, derived Level feedback, Start and Stop controls, and an in-session previous-best marker. No Wins, rebirth or saving yet.
- **Excluded:** Wins, rebirth, saving, the three-bench ladder and a finished lobby.
- **Assumptions:** One starter bench uses a declared base gain and positive tick interval. Level derives from one threshold table, starting at Level 1 for Power 0; training gains may be fractional and must accumulate. Agree the future profile source fields by this story without implementing saving.
- **Deliverables:** Starter-bench training, validated gains, derived Level feedback, Start/Stop, distinct Power and remaining-wind displays, in-session best marker and the M1 improvement demonstration.

## Acceptance criteria

- [ ] AC1 — Activating the starter bench repeats a visible winding action on a small duck. Validated ticks increase Power at the declared base rate and show readable gain feedback. A gain cannot be granted faster by sending repeated input.
- [ ] AC2 — The Power display and derived Level update from the same threshold table. Test a tick below a level threshold, one that reaches it and one that passes it. Level-up feedback occurs once for each newly crossed level.
- [ ] AC3 — Stop, leaving the bench, death, reset and starting a challenge end training. Repeated Start input cannot stack sessions. Power cannot continue growing from training during an active challenge.
- [ ] AC4 — Starting and finishing an ordinary challenge leave earned Power unchanged. The HUD distinguishes persistent Winding Power from that attempt's temporary remaining wind.
- [ ] AC5 — Starting from the low-Power fixture in WT02, a configured training interval moves the player to a Power that passes the same early obstacle. Target 10 to 30 seconds of training for this prototype demonstration and record the selected rate. Developer stat changes cannot substitute for this acceptance run.
- [ ] AC6 — The player can see their previous stopping point or best marker, the new distance and the visibly passed obstacle. Resetting the physical course does not erase the in-session best.
- [ ] AC7 — A player can complete train, Stop, launch, result and retry using touch controls without opening a developer panel or needing keyboard input.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Own training state and tick timing; enforce training/challenge mutual exclusion; grant configured gains only for valid ticks; derive Level from Power; preserve earned Power across ordinary launches and completions.
- **Client responsibilities:** Show a small duck's repeated winding action and accurate gain/level feedback, usable Start/Stop controls, the previous stopping point and the improved result.
- **Remotes:** Plan client-to-server training start/stop requests and server-to-client authoritative Power/Level/training-state updates; the server validates bench eligibility, location/state and timing. Exact names and payload fields remain to be scoped.
- **Persistence:** No cross-session saving. Record the agreed source profile fields for later GAME-008: Power, Wins, rebirth count, best distance, introduction status and a profile version; Level and bench eligibility are derived. Later fields are not a requirement to build the M2/M3 systems now.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** Repeated Start input, late ticks after Stop, or a challenge transition could create duplicate gains. A developer stat edit cannot substitute for the earned-improvement demonstration.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Test fractional gains, positive intervals, below/at/above level thresholds, multi-level crossing feedback inputs and the configured training duration needed to clear the early obstacle.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. Start training, repeat Start and attempt excess input → one session and gains limited to the declared valid tick rate.
  2. Exercise below/at/above level-threshold ticks → accurate Power/Level and one feedback event per newly crossed level.
  3. Stop, leave, die, reset and launch during training → old session ends and no training gains continue during the challenge.
  4. From the actual low fixture, fail at the early obstacle, train for the recorded 10–30 second target interval, then launch → pass the same obstacle with earned Power.
  5. Complete train, Stop, launch, result and Retry using touch only → marker, distance and obstacle improvement remain readable.
- **Multiplayer:** Two players train and attempt independently; verify one player's Stop/reset does not change the other's gains, camera or attempt.
- **Regression:** Power survives ordinary attempts; attempt snapshots remain fixed; prior obstacle determinism and retry cleanup remain intact. Complete the M1 exit review in the backlog before expanding progression.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Record a continuous low-Power attempt, training session and improved attempt. Include the starting and ending Power, threshold table, training interval and selected fixture values.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-003]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT03 planning story into the local GAME-003 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
