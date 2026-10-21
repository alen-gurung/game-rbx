# GAME-008 — Leave and return to saved progress

| Field | Value |
|---|---|
| Status | Blocked — not started |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | Unestimated; original relative size **M** retained |
| Epic | M3 — Saved and shared sessions |
| Dependencies | [GAME-006 / WT06](GAME-006-rebirth-and-faster-training.md), [GAME-007 / WT07](GAME-007-first-visit-guidance.md); concept decision and explicit implementation request |
| Source ID | WT08 — retained as the original planning alias |

**Planning record only.** Confirm the concept and obtain an explicit request to implement before starting. Wind Up a Toy is the working direction; Inflate and Release remains an alternative. An implementation request must also refine this story's exact file scope and unresolved technical/tuning choices before it becomes Ready. No behavior or verification is complete merely because this file is populated.

## User story

As a player, I want my earned progression to be there when I return, without duplicate rewards or unexpected resets.

## Context

- **Problem:** Returning players must recover their committed progression without duplicate transactions, unsafe resets or older-session overwrites.
- **Intended player experience:** As a player, I want my earned progression to be there when I return, without duplicate rewards or unexpected resets.
- **Design decisions:** Follow the working rules and concept boundary in [GAME_DESIGN.md](../../docs/GAME_DESIGN.md), the open decisions in [DECISIONS.md](../../docs/DECISIONS.md), and milestone membership in [ROADMAP.md](../../docs/ROADMAP.md).
- **References:** [Reference index](../../references/README.md). Bottle-game screenshots inform readability, controls and next-goal presentation; they do not establish this game's economy or automation rules. Use only approved references for the affected work.
- **Existing systems affected:** All source profile fields, settlement/rebirth transactions and onboarding state from GAME-003..007 plus a new persistence adapter. Check [SYSTEMS.md](../../docs/SYSTEMS.md) for implemented versus planned systems before editing.

## Scope

- **Included:** Save and load Power, Wins, rebirth count, best distance and introduction status with a profile version. Derive Level and bench eligibility from the saved source fields. Save one consistent profile rather than independent currency/reset fragments. Never save a live duck as resumable gameplay.
- **Excluded:** Resuming live ducks/attempts, independent currency fragments, silent destructive migrations and production-data changes without explicit approval.
- **Assumptions:** Save one versioned profile with Power, Wins, rebirth count, best distance and introduction status; derive Level/bench eligibility. A server crash guarantees only the last successfully saved profile; unconfirmed changes may be lost.
- **Deliverables:** Versioned profile load/save, safe new-profile detection, failed-load retry state, failed-save retry, transaction consistency and older-session conflict protection.

## Acceptance criteria

- [ ] AC1 — After a successful save, leave and rejoin. Restore the exact saved Power, Wins, rebirth count, personal best and introduction state; derive the expected Level and bench availability.
- [ ] AC2 — A returning player starts in a safe lobby state with no old training session, live attempt, pending result payment or captured camera. An interrupted attempt cannot resume or earn its previous flags again.
- [ ] AC3 — Repeated delivery or retry of a saved completion or rebirth cannot increase the committed values twice. Verify disconnection before settlement, after settlement but before confirmed saving, and after confirmed saving.
- [ ] AC4 — A load failure must not be treated as a new account or overwrite an existing profile with defaults. Show a clear retry state and keep progression actions unavailable until the profile is safely loaded. A confirmed new profile starts with the declared defaults.
- [ ] AC5 — A failed save keeps the latest in-session state available for retry and does not display a false saved confirmation. Record the save/retry behavior. After a server crash, the guarantee is recovery of the last successfully saved profile; unconfirmed changes may be lost.
- [ ] AC6 — Prevent an older session from overwriting a newer committed profile during rapid reconnect or overlapping sessions. A malformed or unsupported profile version is handled without silently deleting earned progression.
- [ ] AC7 — Save and reload a complete rebirth snapshot. It contains either the committed pre-reset state or committed post-reset state, never deducted Wins with an old rebirth count or unlocked bench with unreset Power.

## Implementation considerations

- **Likely files:** Refine explicit paths within the existing `src/shared`, `src/server` and `src/client` mapping when implementation is requested. Introduce the required dedicated Rules/Config boundaries according to [ARCHITECTURE.md](../../docs/ARCHITECTURE.md); exact modules and filenames are deliberately deferred. This planning description is not an approved edit scope.
- **Server responsibilities:** Load before enabling progression; distinguish confirmed absence from load failure; save one coherent snapshot; wrap DataStore calls with pcall and retry/backoff; save on leave/BindToClose; prevent stale-session writes and duplicate committed operations.
- **Client responsibilities:** Show clear loading/retry/save-failure states, never a false saved confirmation, and restore a safe lobby with normal camera/controls after successful load.
- **Remotes:** Define only necessary profile-readiness/status notifications and safe retry semantics centrally. Clients cannot supply authoritative profile values or bypass loading. Exact names/payloads await persistence design.
- **Persistence:** Introduced here. Exact DataStore names, key scope, profile version encoding, concurrency strategy, retry policy and any migration plan remain decisions to refine/approve before Ready. Use a separate test experience or explicitly scoped development data; no production-data operation is authorized by this story file.
- **Architecture:** Pure production Luau rules and their dependencies accept plain data and explicit time/config inputs, with no Roblox objects, services, hierarchy, saving or hidden clocks. One authoritative data-only Config folder owns balance values with explicit units. Keep transport, world queries, clocks and persistence in adapters; keep feature handlers separate behind the central contract.
- **Do not change:** Unrelated authored geometry, spawns, lighting or assets; `default.project.json` or `aftman.toml` without explicit approval; other stories' scope. Builders/cleanup may replace only their owned objects. Do not commit, push or publish as part of this planning record.
- **Risks:** Load failures mistaken for new users can destroy data; older sessions can overwrite newer saves; partial reset snapshots can corrupt progression. Record which failures are simulated versus tested against the configured save environment.

## Testing and verification

**Current result: not run; all implementation and runtime acceptance remains unverified.** Use the procedure and actual available tools in [WORKFLOW.md](../../docs/WORKFLOW.md).

- **Static/build:** Run `rojo build -o <temp-dir>/check.rbxlx` for implementation changes. The repeatable build/offline-rules/static/format check procedure must be established within GAME-001; absent or skipped checks must be reported as unverified.
- **Automated:** Test pure profile validation, defaults, supported/unsupported versions and transaction snapshot validation where applicable; adapter tests must exercise retry/conflict behavior without treating a simulated service as real DataStore evidence.
- **Studio playtest:** Inspect the intended development destination, verify source revision/content, then perform the following:
  1. Save, leave and rejoin → exact source fields return and derived Level/bench eligibility match.
  2. Reconnect after an interrupted attempt → safe lobby, no old session/duck/camera/payment.
  3. Exercise disconnect before settlement, after settlement before confirmed save, and after confirmed save → documented last-commit recovery and no duplicate values.
  4. Force load/save failures → no default overwrite or false saved confirmation; loading gates progression and save retry retains latest in-session state.
  5. Save/reload rebirth snapshots and test rapid reconnect/older-session conflict plus malformed versions → coherent pre/post states and no silent data loss.
- **Multiplayer:** Test rapid reconnect and overlapping sessions for the same profile plus independent players; identify real-service versus simulated conflict cases.
- **Regression:** Training, attempts, rewards, rebirth and introduction behave normally after successful load; retries never reapply a completed payment or reset.
- **Visual evidence:** Preserve the Figma/native Roblox shared-component and theme workflow when applicable. Judge the actual gameplay camera and tested phone viewport; record emulation versus physical hardware. Numerical checks cannot prove contact, readability or enjoyment. Record reproduced engine pitfalls with cause, fix and regression evidence.

### Required completion evidence

Verify normal leave/rejoin, a saved rebirth, each disconnect timing case, load/save failures and an older-session write conflict. State which cases were simulated and which used the actual configured save environment.

Record fixture values, configuration/source revision, commands/results, recordings or screenshots, tested devices, and any unverified criteria with the implementation review. Do not fill these with guessed outcomes.

## Definition of Done

- [ ] Dependencies and the concept/implementation gates resolved; exact implementation file scope recorded.
- [ ] Every acceptance criterion demonstrated with the required completion evidence; relevant mouse/touch behavior verified.
- [ ] Review against [AGENTS.md](../../AGENTS.md), working design and architecture rules passed.
- [ ] Configured build, production-rule tests, static and formatting checks run; missing/unverified checks disclosed.
- [ ] Relevant Studio, multiplayer and device evidence recorded; simulated tests distinguished from actual environments.
- [ ] User playtested and explicitly approved the implementation.
- [ ] Affected SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS documentation and this story's evidence/log updated.
- [ ] After explicit user approval of this change set, committed as `type(scope): summary [GAME-008]`, pushed and push verified under [WORKFLOW.md](../../docs/WORKFLOW.md).
- [ ] Story moved to `stories/completed/` and [BACKLOG.md](../BACKLOG.md) updated consistently with that approved delivery.

## Notes / log

- **22 October 2026:** Migrated the established WT08 planning story into the local GAME-008 format. Original acceptance criteria, relative size, dependencies and completion-evidence requirements retained. Status is Blocked/not started because the concept is undecided and game implementation has not been requested. No implementation, tests, Studio verification, user playtest, approval, commit or push is claimed.
