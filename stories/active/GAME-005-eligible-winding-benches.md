# GAME-005 — Choose an eligible winding bench

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **S** retained |
| Epic | M2 — Progression and first session |
| Dependencies | [GAME-003 / WT03](GAME-003-train-and-improve.md); concept decision and explicit implementation request |
| Source ID | WT05 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a player, I want to understand which winding benches I can use and how much faster each one trains me.

## Context

- **Problem:** Players need to understand which bench is available and the improvement offered by the next one.
- **Intended player experience:** As a player, I want to understand which winding benches I can use and how much faster each one trains me.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** Starter training and Level feedback from GAME-003 plus bench eligibility/configuration and reusable bench UI. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** Three adjacent benches, their multipliers and lock requirements. Reuse the starter interaction and animation. Prepared profiles with 0, 1 and 2 rebirths validate this story; the actual rebirth action is WT06.
- **Excluded:** The actual rebirth transaction (GAME-006), additional benches, hidden rebirth multipliers and saving.
- **Assumptions:** Initial tuning fixtures are 1x at 0 rebirths, 1.5x at 1, and 2x at 2. Prepared 0/1/2-rebirth profiles are valid evidence for this story and must be labelled as prepared.
- **Deliverables:** Three adjacent benches with shared interaction, visible multipliers/requirements, correct eligibility messaging and safe switching.

## Acceptance criteria

- [ ] AC1 — Every bench displays its multiplier and exact rebirth requirement using the same values that govern eligibility. Locked and available states are visually distinguishable.
- [ ] AC2 — A profile below a bench's requirement cannot start training there and receives a specific requirement message. A profile at or above it can start immediately.
- [ ] AC3 — Over the same number of valid ticks, the three benches grant base gain times 1, 1.5 and 2 respectively. Fractional gains accumulate correctly. Displayed gains agree with the actual changes.
- [ ] AC4 — Switching benches stops the old training session before the new one begins. Standing between benches or repeatedly activating them cannot combine gains.
- [ ] AC5 — The visible next bench identifies an attainable next rebirth goal. At the highest initial tier, the interface does not promise another unimplemented bench.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Validate current profile eligibility at start, apply the authoritative multiplier to each valid gain tick and stop the previous session before starting another bench.
- **Client responsibilities:** Display the same multiplier/requirement values used for validation, distinct locked/available states, a specific rejection reason and an honest top-tier state.
- **Remotes:** Extend training-start semantics to identify the requested bench; the server resolves its requirement and multiplier. Client-provided multipliers or rebirth counts cannot authorize training. Exact message names/fields remain deferred.
- **Persistence:** None added. Bench eligibility is derived from rebirth count; do not introduce a second independently saved unlock truth.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** Fractional 1.5x gains may be rounded away, repeated switches may stack sessions, or displayed requirements may drift from authoritative config.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Test below/at/above bench eligibility, equal-tick gain multiplication, fractional accumulation and exclusive session switching.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. With labelled 0/1/2-rebirth prepared profiles, inspect and activate each bench → exact requirement messages and correct eligibility.
  2. Train for equal valid tick counts at all three tiers → gains equal base gain times 1, 1.5 and 2, with fractions preserved.
  3. Switch while training and repeatedly activate adjacent benches → old session stops and gains never combine.
  4. Inspect the highest initial tier → no unavailable further bench is promised.
- **Multiplayer:** Two players use or switch benches; verify sessions and gains remain independently owned.
- **Regression:** Starter training still grants the declared base rate, Stop/interruption works, and starting a challenge ends training.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Record equal-duration training at all three tiers, attempts to use a locked bench, switching during training and the top-tier state. The prepared-profile tests must be identified as such.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-005]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT05 planning story into the local GAME-005 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
