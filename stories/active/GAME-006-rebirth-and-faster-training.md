# GAME-006 — Rebirth and train faster

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **M** retained |
| Epic | M2 — Progression and first session |
| Dependencies | [GAME-004 / WT04](GAME-004-wins-and-flags.md), [GAME-005 / WT05](GAME-005-eligible-winding-benches.md); concept decision and explicit implementation request |
| Source ID | WT06 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a player, I want to exchange earned progress for access to faster training and understand exactly what the reset changes.

## Context

- **Problem:** Players need a clear, atomic exchange of earned progress for faster training, with the reset and retained values understood before confirmation.
- **Intended player experience:** As a player, I want to exchange earned progress for access to faster training and understand exactly what the reset changes.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** Power/Level, Wins/best, training sessions and bench eligibility from GAME-003..005. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** One rebirth action, its preview, eligibility rules and reset transaction. Support the two unlock steps needed to reach the third initial bench. Stop at that initial cap with an explicit top-tier state; no infinite rebirth economy is required.
- **Excluded:** An infinite rebirth economy, more than two initial unlock steps, a hidden multiplier, new courses and saving.
- **Assumptions:** Requirements are configurable Level plus Wins cost, reachable with the existing course and benches. Spend only the cost; retain unspent Wins, personal best and prior unlocks. The initial cap is two rebirths.
- **Deliverables:** Rebirth preview/confirmation, eligibility checks, one atomic profile transition, both bench unlocks and explicit capped state.

## Acceptance criteria

- [ ] AC1 — Before confirmation, show the required Level, Wins cost, current eligibility, next bench multiplier, Power/Level reset, and retained unspent Wins and personal best. The displayed cost is the cost charged.
- [ ] AC2 — A profile below either requirement cannot rebirth and loses nothing. Reaching both exact thresholds makes it eligible. The server validates the request and current profile; client-edited values cannot qualify it.
- [ ] AC3 — A valid confirmation changes the profile as one operation: deduct the Wins cost, reset Power to 0, derive Level 1, increment rebirth count and expose the newly eligible bench. There is no intermediate half-reset player state.
- [ ] AC4 — Repeated confirmation or duplicate requests produce only one rebirth for that confirmation. Rebirth is unavailable during an active challenge. If training is active, it stops before the reset so an old tick cannot restore pre-reset gains.
- [ ] AC5 — Complete the first rebirth through ordinary training and earned Wins, then demonstrate the new bench's increased gain over the same tick count. Verify the second unlock and cap as well; record whether that second test used a prepared profile.
- [ ] AC6 — Personal best, previously unlocked benches and unspent Wins remain. A new attempt receives fresh remaining wind based on the new Power. No separate rebirth multiplier is added on top of bench gains.
- [ ] AC7 — The configured requirements are achievable using the current course and reward rules. The next-goal display updates after a rebirth and clearly reports the initial cap at two rebirths.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Validate current requirements and state, deduplicate a confirmation, stop training before reset and atomically deduct Wins/reset Power/increment rebirth count. Deny rebirth during an active challenge.
- **Client responsibilities:** Show actual cost and eligibility, next multiplier, resets and retained values before confirmation; refresh the objective and top-tier state afterward.
- **Remotes:** Plan client-to-server confirmation requests and server-to-client authoritative transition/result updates. The confirmation needs a defined duplicate/retry policy in the central contract; exact message names/fields are deferred. Client-edited costs or stats cannot qualify.
- **Persistence:** No saving introduced here. The complete pre/post rebirth state must form a coherent profile transition so GAME-008 can save an all-or-nothing snapshot.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** Late training ticks may restore old gains, duplicate requests may spend twice, and unreachable requirements may stall the loop. Do not silently add a second multiplier on top of bench gains.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Test below/exact requirements, affordability, atomic state transitions, retained fields, deduplication, active-challenge rejection, late-tick exclusion, reachability and the cap.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. Inspect the preview and attempt rebirth below each requirement → exact displayed cost/requirements and no lost values.
  2. Meet both exact thresholds and confirm → one complete reset transaction with Power 0/Level 1 and the correct new bench.
  3. Repeat confirmation requests and try during a challenge or active training → no duplicate rebirth; challenge rejects; training stops before reset.
  4. Earn the first rebirth through ordinary play, then compare equal-tick bench gains → visible faster training without an extra multiplier.
  5. Verify the second unlock/cap and retained Wins/best/unlocks; label any prepared profile used for the second test.
- **Multiplayer:** One player rebirths while another trains or attempts; verify no changes to the other player's state, course or camera.
- **Regression:** Old training callbacks cannot apply after reset; new attempts capture new Power; existing settlement still pays exactly once.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Record below-threshold and exact-threshold cases, one full earned rebirth cycle, both bench unlocks, duplicate input, retained values and the top-tier state.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-006]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT06 planning story into the local GAME-006 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
