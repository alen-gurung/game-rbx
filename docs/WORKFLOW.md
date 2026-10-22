# Development Workflow

Updated 22 October 2026, Europe/Paris.

**Plan → Authorized implementation → Review → Validate → User Playtest → User Approval → Commit → Push**

The user owns product choices, playtest approval and Git authorization. Claude handles planning/review and mandatory creation of every UI component, map design, model, asset, animation and VFX using Claude Design or Claude Code; Codex may implement other gameplay systems within the user's request. Use the shared rules in [AGENTS.md](../AGENTS.md) and the applicable current story.

**Mandatory visual gate:** Claude Design or Claude Code creation → finished preview in Claude Desktop → explicit user approval of the presented version → import/upload/sync/integration → relevant Studio verification. This covers prototypes, placeholders, blockouts and revisions. Animation and VFX previews must move or play to show timing; still images or code alone do not suffice. No affected output may be committed before approval. If Claude creation or Desktop preview is unavailable, report the blocker and leave the visual work pending without a substitute creator/viewer. Preserve existing authored content and approvals for unchanged work. Implementation authorization and later Studio playtesting do not waive this gate; commit/push approval remains required.

## 1. Current authorization and story lifecycle

The established work is planning. Wind Up a Toy is the working concept; inflation-release remains an open alternative. This documentation update does not request or authorize game implementation. All GAME-001–GAME-009 stories are **Blocked** on final concept selection and an explicit implementation request, with later stories also waiting for their listed dependencies. The original planning aliases are WT01–WT09. M1 contains exactly GAME-001–GAME-003 (WT01–WT03); do not add setup, polish or economy stories to that milestone.

| Status | Meaning | Location |
|---|---|---|
| Proposed | Idea captured, not yet refined | `stories/BACKLOG.md` only |
| Ready | Story and criteria agreed, consequential ambiguity resolved, dependencies satisfied and implementation authorized | `stories/active/` |
| In Progress | Authorized implementation is underway | `stories/active/` |
| In Review | Implementation complete; review and validation underway | `stories/active/` |
| Awaiting Playtest | Review/check results and playtest steps handed to the user | `stories/active/` |
| Done | Acceptance evidence complete, user approved, committed and pushed with push verified | `stories/completed/` |
| Blocked | Waiting on a stated decision, authorization or dependency | Keep the existing location and state the blocker |

Meaningful gameplay features need a story before implementation. Small documentation fixes and one-line corrections need not invent a gameplay story, but still need appropriate review and the explicit approval gate before committing or pushing. A polished plan is not permission to build it, and completing a game backlog is not permission to publish.

## 2. Planning and scope

1. Read [GAME_DESIGN.md](GAME_DESIGN.md), [ROADMAP.md](ROADMAP.md), the relevant story and decision entries. Use [SYSTEMS.md](SYSTEMS.md) to locate affected source. Preserve the final-concept question until the user resolves it.
2. For gameplay engineering, use the personal `roblox-gameplay` skill when available. For native UI/Figma work use `roblox-figma-ui`; for map, lighting and world-feedback work use `roblox-world-design`. Skills add discipline-specific guidance; they do not authorize implementation or change scope.
3. For visual work, read the matching `references/**/README.md` and relevant images when present. Preserve approved Figma/native components and shared themes. Supplied bottle screenshots inform readability and flow; they do not establish exact economics or automation rules. Prior coconut UI evidence does not validate this game.
4. Create or update a story using [stories/TEMPLATE.md](../stories/TEMPLATE.md), store it in `stories/active/GAME-###-short-slug.md`, and maintain [BACKLOG.md](../stories/BACKLOG.md). Keep the original WT alias when importing the existing nine stories so their acceptance criteria remain traceable.
5. Resolve consequential game design, data schema, monetization and architecture choices with the user when needed, recording actual decisions in [DECISIONS.md](DECISIONS.md). The imported pure Rules, one Config folder, central network contract and ownership requirements are established planning constraints; concrete unresolved tools and APIs remain open.
6. Before importing, uploading, syncing or integrating new or revised visual outputs, complete the mandatory Claude Desktop review and explicit approval gate above. Before any Studio mutation, establish the intended development project/place and inspect its current state and applicable instructions. An unrelated open place is not the destination. Preserve authored content and confirm the source/export procedure.

### Sizing

Points measure relative complexity, uncertainty and risk, not hours. Use 1, 2, 3, 5, 8 and 13 for newly estimated work; prefer 3–5 point vertical slices, review an 8 for splitting, and split a 13 before implementation. The imported plan's M/S sizes are relative labels, not approved point estimates or dates; do not silently convert them. Keep tightly coupled acceptance work together, and do not turn buttons, counters or check setup into extra M1 stories.

## 3. Delegation and ownership

Delegation capabilities depend on the host. Inspect the tools available in the current session before selecting an orchestration path; do not assume a T3 API or provider/model exists in every environment.

- **T3 Code:** the prior 2026-10-21 record reported a Codex cross-provider capability. Treat that as historical evidence. When running in T3, re-check `orchestrator_capabilities` and current model IDs before using `delegate_task`; retain its task identifier and use the supported status API. Follow that host's correction/retry rules, including distinct request IDs where required.
- **Built-in agent delegation:** use it when the current host actually exposes it and the work benefits from parallelism. Describe ownership and dependencies explicitly; whether children inherit history depends on that tool's contract.
- **Manual handoff:** when no suitable delegation tool is available, report that limit and provide a self-contained handoff brief. Do not claim a task was delegated when it was not.
- Give each file one writer. Do not edit files a running worker owns. Shared checkouts share uncommitted changes; verify the actual isolation behavior before choosing a worktree. If worktrees start from committed state, include any needed uncommitted story content in the brief.
- Claude Design or Claude Code workers may prepare independent visual assets at distinct paths. After Claude Desktop review and explicit approval of those versions, one coordinator applies mutations to the shared Studio place and verifies the combined result.

### Delegation brief

```text
Story: GAME-### — title (original WT alias, if applicable)
Story path: stories/active/GAME-###-slug.md
Authorization: actual user request and any unresolved blocker
Objective: one or two sentences describing the player outcome
Files owned: exact paths to create or modify
Do not change: other workers' files, out-of-scope systems, default.project.json or aftman.toml without approval
Required behavior and acceptance criteria: include the full relevant criteria
Source/design references: exact paths; inline content unavailable in the worker's checkout
Architecture: pure production Rules, one Config source, central contract, separate validated feature handlers, explicit player/attempt ownership
Validation: configured build/rule/static/format commands, then relevant Studio evidence; disclose unavailable checks
Report: files changed, criterion evidence, checks actually run, risks and open items
Do not commit, push or publish.
```

## 4. Implementation and review boundaries

Only begin after the concept is selected and implementation is explicitly requested. If inflation-release is chosen, revise the first three stories around inflation, escaping-air flight, deflation and improved landing distance, and update later theme-specific criteria before coding. Do not build both concepts or an interchangeable framework by default.

For each authorized story, review the full diff and new files against:

- Acceptance criteria, file scope and milestone boundaries. GAME-001 establishes the local check workflow; M1 does not include Wins, rebirth, saving or a finished decorated lobby.
- Production Rules and dependencies use ordinary data with explicit inputs and no Roblox objects/services, hidden clocks, `script` hierarchy, network or persistence. Test the same modules used by the game.
- Balance values have one data-only source with explicit units and config validation. Displays and calculations use that source; fixtures record the tested values and revision.
- The server validates message shape, finite ranges, ownership, current state, eligibility and rate/timing. No client-supplied totals, prices or progress determine rewards. Feature handlers remain separate from the central contract.
- Player/session state, captured launch inputs, deterministic scored progress, once-only settlement and cancellation are correct. Delayed callbacks cannot revive an old session; temporary objects, effects and connections clean up without affecting another player.
- Persistence changes use safe load/failure behavior, protected calls and retry/backoff, consistent snapshots and session conflict protection. Schema or production-data changes require the applicable approval; saving is not introduced before its story.
- UI/reference fidelity, toy contact/readability, camera recovery and actual input flows have evidence. Cosmetic failures cannot block settlement/recovery, but required visual cues remain open until demonstrated.
- Authored assets have recoverable sources and provenance. Builders replace only owned content and preserve unrelated geometry, spawns, lighting and user edits.

Send concrete review findings to the owning worker or fix within the authorized file ownership, then rerun the affected checks. Do not expand tests repeatedly after sufficient passing evidence unless a new change or unresolved concern warrants it.

## 5. Verification

### Actual repository state

| Check | Current setup | Evidence from this documentation update |
|---|---|---|
| Build and mapping | Rojo 7.7.1 pin and `default.project.json` exist; command is `rojo build -o <temp-dir>/check.rbxlx` | Configuration inspected; command not run |
| Offline production-rule tests | No Rules modules, compatible runner or tests configured | Not available; no pass claimed |
| Static analysis and formatting | No configured analyzer, type checker or formatter | Not available; no pass claimed |
| Studio behavior | Depends on access to the intended place and current tools | No sync, runtime or visual verification performed |
| Physical devices and representative load | No target or results established | Unverified |

During GAME-001 implementation, establish and document one repeatable check entry point covering build/mapping, offline production-rule tests, static analysis and formatting. Record actual tool versions and commands. Do not change the approved map/tool pin or install a broad stack as part of a documentation task. Missing tools, missing test targets, skipped checks and unrun checks must remain explicit; they cannot produce an overall pass.

Prove that the selected runner executes the same production Luau Rules used in Studio. Independent expected values should follow the specification; a Python/JavaScript rewrite of the rules is not a substitute. Validate production Config as well. If adding a custom verifier, exercise it against a deliberately broken small case and a missing target so it cannot silently pass.

### Evidence by story

| Story | Offline evidence as implemented | Studio/player evidence |
|---|---|---|
| GAME-001 (WT01) | Starter wind, exhaustion/finish, forward-distance cap and attempt transitions | Key/feet and terminal motion; follow camera; interruption and ten retries; basic isolation |
| GAME-002 (WT02) | Below/at/above obstacle thresholds, repeated fixed fixtures and monotonic progress | Actual contact/reactions, obstacle resets and readable low/medium/high attempts |
| GAME-003 (WT03) | Fractional gains, Level boundaries, positive tick interval and training sufficient to pass the early obstacle | Validated timing, Stop/no stacking, earned improvement and full touch flow |
| GAME-004–GAME-006 (WT04–WT06) | Once-only rewards, bench eligibility, affordability and complete rebirth transitions | Duplicate requests, interruptions, displayed costs and authoritative state changes |
| GAME-007 (WT07) | Focused action/objective-state checks where pure logic applies | Fresh-player guidance and actual training/attempt/improvement; phone readability |
| GAME-008–GAME-009 (WT08–WT09) | Pure profile/transition validation where applicable | Real save/load/retry and conflict cases, overlapping players, late joins, device/load checks |

Run relevant local checks before using a Studio playtest as acceptance evidence. Necessary Studio inspection and debugging may occur earlier. Agents may inspect or run Studio checks when the current environment provides the capability; otherwise hand those checks to the user and keep them unverified. Tool access does not prove a test occurred.

Before acceptance testing, confirm that local source and assets reached the intended Studio place through content comparison or a meaningful revision/hash check. Equal source lengths alone do not prove freshness. Exercise the actual player inputs and shipped handlers; a diagnostic probe or successful asset import does not establish integration.

Capture the actual camera and tested phone viewport, selected tuning fixtures, device/environment, result and limitations. Distinguish emulation from a physical phone, prepared profiles from earned progression, simulated failures from real save-environment behavior, and two-player correctness from representative capacity. Numerical tests cannot demonstrate visual quality or enjoyment.

Record reproduced engine pitfalls in the owning story's verification log, with the trigger, evidence/cause, fix and regression check. Add a reusable helper when a repeated need is demonstrated; do not accumulate speculative traps or claim imported helpers are verified.

## 6. User playtest and approval

Agent-run checks supplement the user's playtest. They do not remove the established user playtest and explicit approval gate. Hand off:

1. **Setup:** the verified source revision, intended place, `rojo serve`/plugin connection and relevant settings. Preserve unmapped authored content.
2. **Steps:** numbered actions and expected outcomes mapped to acceptance criteria, with reproducible profile/course/config fixtures.
3. **Multiplayer:** relevant clients-and-server count and overlapping actions; name any population target that remains untested.
4. **Regressions and recovery:** interruption, reset, Retry, cleanup and affected existing behavior.
5. **Evidence and limits:** changed files, executed check results, captures, tested device/viewport, risks and every unverified criterion.

Set the story to **Awaiting Playtest** when that handoff is ready and wait for the user's results/approval. Keep failed or blocked criteria open. For M1, also record five consecutive attempts, including an unchanged-Power repeat and earned improvement; record an observer's explanation of why the toy stopped and what changed. Review engagement/pacing before expanding into M2. Technical completion alone does not establish enjoyment.

**Persistence testing:** Studio API access can reach an experience's real DataStores. Establish a separate test experience or deliberate development-only key scope before testing GAME-008. Do not run tests against production player data without explicit approval. Do not enable or change save-environment settings speculatively during documentation work.

## 7. Git gate

Nothing is committed or pushed until the user explicitly approves that change set. Reconfirm only if substantial changes occur after approval. Preserve unrelated work and existing branch rules.

After approval:

1. Inspect current status, branch and remote; show the exact files and diff summary to be included. D-003 records the intended `master` branch and `game-rbx` remote, but inspect actual state rather than assuming it.
2. Stage only the approved paths. Never stage unrelated changes with a blanket command.
3. Commit as `type(scope): summary [GAME-###]` for story work. Supported types include feat, fix, refactor, docs, chore and test; do not invent a gameplay story number for a documentation-only cleanup.
4. Push to the intended branch upstream; resolve any destination mismatch with the user before changing it. Never force-push or rewrite published history without explicit permission.
5. Verify the commit, working-tree status and local/remote heads. Report the hash, branch and push result. A failed push or incomplete approval/evidence leaves the story short of Done.
6. Ensure the story move to `stories/completed/` and backlog update are part of the approved change set. They may be prepared in the same commit only after acceptance and user approval are complete; if a later follow-up commit is needed, obtain approval for it. The Done status is effective only after the push is verified.

No destructive Git commands, branch deletion, discarded local work or publication are authorized by ordinary documentation upkeep.

## 8. Documentation upkeep

| Change | Update |
|---|---|
| Mechanic or concept choice | [GAME_DESIGN.md](GAME_DESIGN.md), affected stories and decision entry |
| System, remote or DataStore | [ARCHITECTURE.md](ARCHITECTURE.md) and [SYSTEMS.md](SYSTEMS.md) |
| Significant technical choice | [DECISIONS.md](DECISIONS.md) |
| Confirmed scope or milestone | [ROADMAP.md](ROADMAP.md) and [BACKLOG.md](../stories/BACKLOG.md) |
| Story state, fixtures or test evidence | Story file and [BACKLOG.md](../stories/BACKLOG.md) |
| Reproduced engine pitfall/fix | Owning story verification log; reusable helper only when warranted |
| Process change or configured check commands | This file |

Edit affected sections, distinguish current implementation from planned behavior, and retain genuinely unresolved decisions as explicit open items. Keep AGENTS.md and CLAUDE.md short. Historical prototypes, source reviews and portable base templates provide context; they do not override the current concept question, story criteria or authorization boundary.
