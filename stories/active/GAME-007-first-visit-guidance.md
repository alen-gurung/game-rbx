# GAME-007 — Understand the first visit

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **S** retained |
| Epic | M2 — Progression and first session |
| Dependencies | [GAME-006 / WT06](GAME-006-rebirth-and-faster-training.md); concept decision and explicit implementation request |
| Source ID | WT07 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a new player, I want the space and short prompts to show me what to do next without an external explanation.

## Context

- **Problem:** A first-time player must find the loop and next useful action without an external explanation.
- **Intended player experience:** As a new player, I want the space and short prompts to show me what to do next without an external explanation.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** Existing training/attempt/progression states, compact lobby layout and shared HUD components. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** Finish the compact lobby layout around the existing benches and start pad. Add a brief action-based introduction and one current objective. This does not add new gameplay systems or a large decorated world.
- **Excluded:** New gameplay systems, a large decorated world, unavailable content promises and a text-only completion shortcut.
- **Assumptions:** Use the existing compact lobby, benches and start pad. Introduction progress follows actual training, attempt and improvement; a full clear also qualifies as improvement, even on the first attempt.
- **Deliverables:** Readable spawn-to-bench/start route, brief dismissible action-based introduction, one current objective and phone-compatible guidance.

## Acceptance criteria

- [ ] AC1 — From spawn, a player can identify the starter bench and challenge entrance. Benches show their existing requirements and the challenge shows the route ahead. Labels do not depend on another player's position or block the principal interaction.
- [ ] AC2 — The introduction advances after actual training, an actual attempt and a subsequent improvement; a full course clear also satisfies the improvement step, including on the first attempt. Clicking through text alone cannot mark those actions complete. The introduction can be dismissed and cannot prevent normal play.
- [ ] AC3 — The immediate objective points to the next useful action: first training, a run, more Power for the next flag, or the next eligible rebirth. After a full clear, direct a player missing Wins to replay reward flags and a player missing the required Level to train toward rebirth. Handle zero rewards and the initial rebirth cap without pointing to unavailable content.
- [ ] AC4 — A fresh player completes the first train-to-improvement loop using only the in-game guidance. Record where help was needed and fix any blocking ambiguity before closing the story.
- [ ] AC5 — In the tested phone viewport, touch targets are usable, text fits, and training, launch and result controls remain available without overlapping critical information. Existing mouse input still works.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Derive eligible objective and introduction progress from authoritative actions/profile state. Dismissing guidance must not award gameplay progress or block play.
- **Client responsibilities:** Show the route and one useful objective, advance/dismiss short prompts, and keep touch controls and critical information unobstructed.
- **Remotes:** Reuse authoritative state/action notifications; add only the required introduction-dismissal/status semantics after scope refinement. Exact names/fields are deferred; clicking text cannot certify an unperformed gameplay action.
- **Persistence:** Introduction status is in-session until GAME-008; document its intended source representation before persistence work.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** Developer familiarity may hide unclear guidance. Objective logic must handle full clears, missing Wins versus missing Level, zero reward and the initial rebirth cap without pointing at nonexistent content.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Add focused pure-rule checks for objective/introduction branches if this logic is introduced in production rules; do not mirror every text or layout detail with tests.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. Start a fresh profile at spawn → starter bench and challenge entrance are identifiable without outside help.
  2. Train, attempt and improve/full-clear → introduction advances on actions; text clicks alone cannot complete it; dismissal leaves normal play available.
  3. Exercise full clear with missing Wins, missing Level, zero rewards and rebirth cap → objective points to an available useful action.
  4. Have a fresh player complete the first improvement loop using guidance only → record help needed and remove blocking ambiguity.
  5. Check the recorded phone viewport and mouse input → usable touch targets, fitting text and unobscured launch/training/result controls.
- **Multiplayer:** Observe labels/guidance with other players nearby; another player's position or actions must not block or advance the current player's introduction.
- **Regression:** All training, launch, result and rebirth interactions work while guidance is visible or dismissed.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Record a fresh-profile walkthrough and phone-view checks, distinguishing an independent tester from the developer's own walkthrough.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-007]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT07 planning story into the local GAME-007 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
