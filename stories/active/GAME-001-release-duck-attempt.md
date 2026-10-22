# GAME-001 — Release a duck and complete an attempt

| Field | Value |
|---|---|
| Status | In Progress — animations approved; placeholder models approved temporarily; Studio integration open for playtest |
| Priority | Not assigned; use the established milestone/dependency order |
| Points | 8 (original relative size **M**). Kept whole: the required check tooling belongs inside this story (D-005), and splitting the attempt flow would leave an unrecoverable half-attempt |
| Epic | M1 — Initial playable loop |
| Dependencies | None. Concept gate resolved by D-008; implementation explicitly requested 22 October 2026 |
| Source ID | WT01 — retained as the original planning alias |

**Authorized 22 October 2026.** The user selected Wind Up a Toy for this prototype (D-008) and explicitly authorized implementing GAME-001 / WT01 only. Inflate and Release remains a possible future reconsideration. The refined file scope, tuning, contract and check tooling are under **Refined implementation plan** below. GAME-002 onward stay Blocked until the user playtests this story and requests the next one.

## Mandatory presentation prerequisite

The implementation authorization above remains limited to GAME-001. Its new or revised UI, strip/map design, duck model/assets, animations and VFX must be created with Claude Design or Claude Code and presented as a finished version in Claude Desktop for explicit user approval before import, upload, sync, integration or commit. This includes simple original visuals, placeholders, prototypes and blockouts. Key/feet, winding, slowdown and terminal-motion previews must move or play so their timing can be reviewed; still images or source code alone do not satisfy this gate. If the required Claude creator or Desktop preview is unavailable, report the blocker without substituting another creator/viewer.

Preserve existing authored content and prior approvals for unchanged work. Apply this prerequisite before using the build/open/sync path below for new or revised visual outputs; after approval, complete the required Studio, camera, input and device verification. Revised visual versions require renewed approval. Follow [AGENTS.md](../../AGENTS.md) and the [workflow](../../docs/WORKFLOW.md); this note does not change the story's status, scope or acceptance criteria.

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

## Refined implementation plan (22 October 2026)

Approved environment changes: the user approved pinning `lune-org/lune@0.11.1`, `Kampfkarren/selene@0.32.0` and `JohnnyMorganz/StyLua@2.6.0` in `aftman.toml`; Rojo stays at 7.7.1 (D-009). `default.project.json` is unchanged. The Studio destination is a new `game-rbx.rbxlx` in the repository root. It is built with Rojo (already gitignored), opened in Studio and synced with `rojo serve`.

### File scope

| Path | Responsibility |
|---|---|
| `src/shared/Config/Attempt.luau` | Balance data: starter Power, winding time, wind per Power, speed and slowdown window, with explicit units |
| `src/shared/Config/Course.luau` | Course identifier and finite forward length |
| `src/shared/Rules/AttemptRules.luau` | Pure: capture the attempt snapshot; forward position, speed and remaining wind at an elapsed time; outcome and travel duration |
| `src/shared/Rules/AttemptStateMachine.luau` | Pure: Ready → Winding → Running → Ended → Ready, Cancel from Winding/Running, rejected transitions |
| `src/shared/Rules/ConfigRules.luau` | Pure: validate finite, positive and ordered Config values and the known course |
| `src/shared/Net/Contract.luau` | Central message names, directions, payload shapes, allowed states, rate limit and remote folder name |
| `src/shared/World/TestStripLayout.luau` | Plain-number world placement of the strip (not balance), shared by the builder and the client |
| `src/server/init.server.luau` | Server bootstrap (replaces the hello print) |
| `src/server/Net/Remotes.luau` | Creates the contract's RemoteEvents and provides send/receive helpers |
| `src/server/Services/PlayerPower.luau` | Per-player session Power: starter value plus a Studio-only test fixture override |
| `src/server/Features/AttemptFeature.luau` | Per-player attempt ownership, request validation, scheduling, settlement and cancellation on death, reset or leave |
| `src/server/World/TestStripBuilder.luau` | Builds or replaces only the owned `Workspace.DuckTestStrip` folder: pad, strip, markers, finish and spawn |
| `src/client/init.client.luau` | Client bootstrap (replaces the hello print) |
| `src/client/Controllers/AttemptController.luau` | Receives state, sends requests, owns the per-attempt presentation session and its cleanup |
| `src/client/Presentation/DuckModel.luau` | Simple original Part duck with a key and feet |
| `src/client/Presentation/DuckRun.luau` | Per-attempt animation driven by the same AttemptRules functions |
| `src/client/Presentation/FollowCamera.luau` | Follow camera plus camera and control restoration |
| `src/client/UI/AttemptHud.luau`, `src/client/UI/Theme.luau` | Native launch button, wind meter, Leave, result panel with Retry; shared visual values |
| `tests/run.luau`, `tests/rules/*.spec.luau`, `tests/selfcheck/**` | Offline Lune runner, production-rule and config specs, deliberately broken self-check fixture |
| `tools/check.luau`, `tools/digest.luau`, `tools/studio-digest.luau` | One check entry point; local and Studio command-bar source digests |
| `selene.toml`, `tools/selene-pure.toml`, `stylua.toml`, `.gitignore` | Lint settings (Roblox std for adapters, Luau-only std for Rules/Config) and format settings |

`src/shared/Hello.luau` stays untouched.

Added during the visual gate (Claude-authored, 22 October 2026):

| Path | Responsibility |
|---|---|
| `src/client/Presentation/DuckPose.luau` | Engine-free duck parts, pose timing (winding, stride, slowdown, stall, flop, kicks, finish hop) and follow-camera math, shared by DuckModel/FollowCamera and the preview |
| `src/server/World/TestStripSpec.luau` | Engine-free strip part list, used by TestStripBuilder and the preview |
| `tests/rules/DuckPose.spec.luau` | No part below the strip in any phase, orthonormal transforms, flop rest pose, phase/wind mapping, stride slowdown, camera placement, determinism, finish placement |
| `tools/preview.luau`, `tools/preview-template.html` | `lune run tools/preview` writes `previews/GAME-001/duck-attempt-preview.html` from the shipped modules |

Visual ownership: Codex's earlier map/duck/animation/camera/HUD drafts were replaced. TestStripBuilder, TestStripLayout, DuckModel, DuckRun, FollowCamera, AttemptHud and Theme are Claude-authored under the AGENTS.md gate. Codex authored Rules, Config, Contract, server feature/services/remotes, AttemptController and tooling. Claude fixed server rate limiting, result visibility after presentation failure, and result-time camera framing.

### Initial tuning fixtures (prototype values, not a finished balance)

| Value | Fixture | Unit |
|---|---|---|
| Starter Power | 0 | Power |
| Winding animation before release | 1.0 | seconds |
| Base wind at Power 0 | 6.0 | seconds of unwinding |
| Wind per Power | 0.1 | seconds per Power |
| Top speed | 8 | studs per second |
| Slowdown window | 2.5 | final seconds of wind; speed falls linearly to 0 |
| Course `test-strip` length | 100 | studs, measured forward from the start line |

Expected results, calculated independently from this specification:

- Power 0: 6 s of wind, 38 studs, exhaustion after 6 s of travel.
- Power 40: 10 s of wind, 70 studs, exhaustion.
- Power 100: 16 s of wind, 118 studs uncapped, so the duck reaches the finish at 100 studs after 12.5 s.

Power is session-only. In Studio only, the server reads a `DevPower` attribute set on the Player from the server command bar as the finish/test fixture. It is captured at release and ignored outside Studio.

### Contract (C = client, S = server)

- `RequestSync` C→S, no payload. The server replies with the current `AttemptState`.
- `RequestLaunch` C→S, no payload. Valid only in Ready.
- `RequestRetry` C→S `{ attemptId: integer }`. Valid only in Ended, for the current attempt.
- `RequestCancel` C→S `{ attemptId: integer }`. Valid only in Winding/Running, for the current attempt; ends without a result.
- `AttemptState` S→C, owner only: `{ seq, state, attemptId?, courseId?, power?, snapshot?, releaseServerTime?, outcome?, distance? }`. The client ignores a stale `seq`.
- Invalid, stale or rate-limited requests (under 0.2 s apart, per player per message) change nothing. A rejected request re-sends the current state so the client resyncs.

### Implementation notes

- Per-player ownership and isolation start here. Each client renders only its own duck locally, so GAME-001 doesn't show other players' ducks. Shared visibility of other players' runs is completed in GAME-009 (WT09).
- Scored distance comes from the server's captured snapshot through AttemptRules. Client motion uses the same pure functions, for presentation only.

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

### Verification log

**22 October 2026 — local checks (Windows, Rojo 7.7.1, Lune 0.11.1, selene 0.32.0, StyLua 2.6.0):**

- `lune run tools/check` → **OVERALL PASS**: Rojo build; Roblox lint and pure lint (Rules, Config, TestStripLayout, TestStripSpec, DuckPose, Theme) at 0 errors/warnings; StyLua check; 51 production tests, 0 failures. Self-checks: the runner fails on a failing spec and on a missing directory, and pure lint rejects `workspace`.
- `lune run tools/digest` → combined local source digest `57dee82e`. Compare it with `tools/studio-digest.luau` in the Studio command bar after syncing.
- Fixtures (Config revision as above): Power 0 → 38.0 studs exhausted after 6.00 s; Power 40 → 70.0 studs exhausted after 10.00 s; Power 100 → finished at 100.0 studs after 12.50 s.
- Engine pitfall found offline: rotating whole feet about the hip dipped the toe 0.2 studs into the strip on the backswing, and roll wobble about a single edge sank the near side. Fixed by keeping soles level along the hip arc, pivoting pitch/roll on the edge being tipped over, and moving the lunge pivot past the toe reach. Regression check: `no duck part sinks below the strip in any phase`.
- Preview HUD clearance (computed in the preview, every 1/30 s, all fixtures; conservative projected duck bounds versus HUD rectangles, assuming a 58 px top-bar inset): 0 overlaps and 0 off-screen frames in 3,849 frames. Minimum gaps: 844×390 meter 15 px / result 53 px; 667×375 meter 11 px / result 47 px; 1280×720 meter 109 px / result 179 px. Real Roblox inset and rendering still need Studio confirmation.

**Visual gate:** moving preview `previews/GAME-001/duck-attempt-preview.html` generated for Claude Desktop review. **Not yet approved.** The client presentation bootstrap and map builder stay disabled, and `game-rbx.rbxlx` hasn't been built or opened, as the user chose on 22 October 2026.

**Not run:** Studio sync/digest comparison, every runtime AC (AC1–AC7), two-player isolation, mouse/touch in the emulator, physical device, user playtest.

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
- **22 October 2026:** The user selected Wind Up a Toy for the prototype (D-008) and authorized GAME-001 only. Approved the tool pins (D-009) and a new Rojo-built `game-rbx.rbxlx` as the Studio destination. Refined file scope, tuning and contract recorded above; status set to In Progress and implementation delegated to Codex.
- **22 October 2026:** Codex delivered Rules/Config/contract/server/controller/tooling and stopped at the new visual gate with its drafts disabled. Claude reviewed the work, fixed three defects, authored all visuals, and generated the moving preview for Claude Desktop approval. Local gate OVERALL PASS. The user chose to keep Studio closed until visual approval.
- **22 October 2026 — visual gate decision:** The user reviewed the preview and **approved the animations** (winding, stride, slowdown, stall/flop/kicks, finish hop, camera timing). They **did not approve the model visuals** but accepted them **for now as temporary placeholders**, and will create the models themselves later. Any replacement or revised model, map or HUD visual needs a new Claude Desktop approval. Bootstraps enabled; `game-rbx.rbxlx` built with `rojo build` and opened in Studio; `rojo serve` running on localhost:34872. Local gate OVERALL PASS; source digest `38b7e42b`.
