# GAME-004 — Earn Wins and pursue the next flag

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **M** retained |
| Epic | M2 — Progression and first session |
| Dependencies | [GAME-003 / WT03](GAME-003-train-and-improve.md); concept decision and explicit implementation request |
| Source ID | WT04 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a player, I want each completed run to reward my progress and show the next reachable goal.

## Context

- **Problem:** Completed progress needs a clear reward and next reachable course goal.
- **Intended player experience:** As a player, I want each completed run to reward my progress and show the next reachable goal.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** Existing planned attempt/obstacle/training behavior plus flag/reward rules and result presentation. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** Five reward flags along the existing course, a Wins balance, best-distance record, and a result panel with Retry and Train. Reuse the three obstacle families; do not add a world or another obstacle family.
- **Excluded:** Another world, additional obstacle families, rebirth, saving, shops and monetization.
- **Assumptions:** Five flags use recorded distance/reward fixtures. Running out of wind is a normal reward-eligible ending. Only completed forward progress updates best; repeats can earn the same flags in a new attempt.
- **Deliverables:** Five reward flags, a server-owned Wins balance, completed-run best, idempotent settlement and a result panel with Retry and Train.

## Acceptance criteria

- [ ] AC1 — Each flag displays its distance and reward. The next flag is identifiable during the run, and progression credit follows the duck's actual forward crossing.
- [ ] AC2 — On a normally completed run, add each crossed flag's configured reward once to the result. A zero-flag run awards zero; a full clear awards the sum of all five flags.
- [ ] AC3 — Settle the result once per attempt on the server. Repeated contacts, completion signals, result clicks and retries cannot grant it twice. Client-provided distance, flag count or reward amounts cannot determine the award.
- [ ] AC4 — An interrupted, unsettled run grants zero and does not update the completed-run best. An interruption after settlement preserves the earned balance and best and cannot trigger another payment.
- [ ] AC5 — The result shows distance, Wins gained, total Wins and whether a new best was achieved. Equal or shorter completed runs do not reduce the stored best. Repeating a completed route can earn its flags again in a new attempt.
- [ ] AC6 — Retry produces a fresh run with clean flags and obstacles. Train returns to the training area with normal controls. At the course end, show a clear completion result instead of an unreachable next flag.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Credit each crossed flag once per attempt, settle the sum once, update best only for completed runs and preserve settled values after later interruption. Validate crossings from authoritative progression rather than client totals.
- **Client responsibilities:** Display flag distances/rewards, the next flag, distance, gained/total Wins, best status, Retry/Train and the course-end completion state.
- **Remotes:** Extend the central result/action contract as needed; reward totals and crossed flags are server outputs. Repeated contacts, completion signals and result actions must be idempotent. Exact names and payloads remain unassigned.
- **Persistence:** Wins and best remain in-session until GAME-008. Settlement must be structured for later consistent profile saving without introducing a separate save feature now.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** Contacts and result actions can arrive repeatedly or after cancellation; distinguish cancellation before settlement from interruption after settlement. Backward movement must never add distance.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Test zero/partial/all-flag sums, unique flag credit, once-only settlement, duplicate inputs, best-distance monotonicity and cancellation before/after settlement.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. Complete zero-flag, partial and all-five-flag attempts → correct configured sums and clear next-goal/completion displays.
  2. Repeat contacts, completion messages, result actions and retries → each attempt pays once.
  3. Interrupt before settlement → zero reward and unchanged completed best; interrupt after settlement → earned values remain without another payment.
  4. Complete the same route twice → each new attempt can earn its flags; equal/shorter results never reduce best.
  5. Choose Retry and Train → clean course state or usable training-area controls respectively.
- **Multiplayer:** Two players cross flags and settle simultaneously; verify independent flag sets, bests and Wins.
- **Regression:** GAME-001..003 camera recovery, training/challenge exclusion, captured Power and obstacle reset still hold.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Check zero flags, partial completion, all flags, duplicate settlement attempts, interruption before and after settlement, and the same route completed twice.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-004]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT04 planning story into the local GAME-004 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
