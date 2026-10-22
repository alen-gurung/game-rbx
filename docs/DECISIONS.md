# Decisions

Lightweight decision log. Add an entry for choices that are hard to reverse or that shape future work. Newest at the bottom. Never delete entries; mark them **Superseded by D-###** instead.

Format: `## D-### — Title (YYYY-MM-DD, Status)` then Context · Decision · Alternatives · Consequences.

---

## D-001 — Rojo is the source of truth for scripts (2026-10-20, Accepted)
**Context:** The project was initialised from the Rojo 7.7.1 template.
**Decision:** All Luau code lives in `src/` and syncs into Studio through Rojo using `default.project.json`.
**Alternatives:** Studio-only scripting, or Team Create with script drafts.
**Consequences:** Code is versioned in Git. Content outside the Rojo mapping (Studio-built models, UI, terrain) isn't, and must be handled deliberately. Mapping changes require user approval.

## D-002 — AI-assisted, approval-gated workflow (2026-10-21, Accepted)
**Context:** Development uses T3 Code with Claude (planning and review) and Codex (implementation).
**Decision:** Shared rules live in `AGENTS.md`, which Codex reads natively and CLAUDE.md imports with `@AGENTS.md`. Details live in `docs/`, `stories/`, and `references/`, and are read on demand. Features are story-driven and go through review and a user playtest. Commit and push happen only after explicit user approval. Lifecycle: [WORKFLOW.md](WORKFLOW.md).
**Alternatives:** Separate full instruction files per agent, rejected because the rules would drift. Auto-loading all docs, rejected because of token cost.
**Consequences:** Startup context stays small. Agents must read docs selectively. Nothing reaches Git without user sign-off.

## D-003 — Commit directly to `master` on remote `game-rbx` (2026-10-21, Accepted, revisit when collaborators join)
**Context:** Solo developer, a single branch, and no PR tooling (`gh` isn't installed).
**Decision:** After approval, approved stories are committed to `master` and pushed to `game-rbx/master`.
**Alternatives:** A feature branch per story with PRs.
**Consequences:** Simple and fast. No PR-level review history. Switch to branches and PRs if collaborators or branch protection are added.

## D-004 — Reconcile the saved plan into game-rbx (2026-10-22, Accepted documentation scope; concept open)

**Context:** The research workspace already contains a current handoff, nine development stories, a concept comparison and architecture/presentation guidance. This repository's design, roadmap and backlog still contained starter placeholders. The user requested filling the Markdown documents from established information.

**Decision:** Record the established plan in local docs and stories. Wind Up a Toy remains the working direction, with Inflate and Release explicitly open. The request authorizes documentation only; the saved instruction not to start coding remains in force. GAME-001–GAME-009 are local aliases of WT01–WT09, not new scope. All remain not started, with Blocked status until concept resolution, an explicit implementation request and relevant dependencies are satisfied.

**Alternatives:** Leave known decisions blank; silently choose a concept; or implement both themes. None follows the current request.

**Consequences:** [GAME_DESIGN.md](GAME_DESIGN.md), [ROADMAP.md](ROADMAP.md), the [backlog](../stories/BACKLOG.md) and [handoff](../DEVELOPMENT_HANDOFF.md) carry the working plan locally. Original S/M sizes remain source sizing, without invented numerical points or delivery dates. Further approved changes must update these local records together. Historical arrow-through-balloons work and separate coconut prototype evidence do not override them.

**Source:** [Planning handoff](../../winning-ideas-rbx/DEVELOPMENT_HANDOFF.md), [stories](../../winning-ideas-rbx/docs/DEVELOPMENT_STORIES.md) and [concept comparison](../../winning-ideas-rbx/docs/CONCEPT_DIRECTION.md), dated 22 October 2026. Sibling-folder links are local provenance, not dependencies for reading the local plan.

## D-005 — Preserve the three-story initial milestone and bounded progression (2026-10-22, Established planning scope)

**Context:** The user asked for meaningful development stories, with the first three forming the initial milestone before expanding the game.

**Decision:** M1 contains exactly WT01–WT03 / GAME-001–GAME-003: complete a duck attempt, pass an obstacle with more Power, and train to earn that improvement. Use one duck, one bench and one short course. M2 contains WT04–WT07 for Wins/flags, the bench ladder, rebirth and onboarding; M3 contains WT08–WT09 for saving and shared-session verification.

**Alternatives:** Add economy, a finished lobby or extra technical milestone stories to M1; expand to multiple toys/worlds before testing the loop.

**Consequences:** The full working version is one lobby, one course, three obstacle families, five flags, three benches and two rebirth unlock steps. Per-player ownership begins in WT01, and tooling belongs inside that story. Review visible earned improvement, repeatability, recovery and enjoyment before M2. Future content packages remain candidates, without dates or publishing authorization. Exact economy tuning remains open.

## D-006 — Pure rules, one balance source and explicit network contracts (2026-10-22, Established architecture requirements; not implemented)

**Context:** The reviewed engineering guidance adds an explicit offline-testable boundary and reproducible checks to the existing server-authoritative plan. The actual source is still the Rojo starter.

**Decision:** Separate production Rules, plain Config data and Roblox adapters. Rules and their dependencies use plain values without engine objects, services, script hierarchy or live clocks. Use one authoritative balance folder with explicit units and no duplicate display/calculation defaults. Define network message names, direction, payloads and allowed states centrally with separate feature handlers. The server validates requests, owns per-player state, captures attempt inputs and settles each result once.

**Alternatives:** Service-dependent rules tested only inside Studio; scattered tuning; client-computed rewards; a monolithic network handler or speculative general-purpose game framework.

**Consequences:** [ARCHITECTURE.md](ARCHITECTURE.md) proposes equivalent folders inside the existing `src/shared`, `src/server` and `src/client` mapping. No folders/modules or mapping changes are created by documenting this. Establish build/mapping, offline production-rule tests, static and formatting checks within GAME-001 when implementation starts. Tool/loader choices remain open and must prove the same production Luau modules run offline and in Studio. Missing checks are not a pass.

**Source:** [Development workflow review](../../winning-ideas-rbx/docs/DEVELOPMENT_WORKFLOW.md) and the reusable personal `roblox-gameplay` guidance.

## D-007 — Player-owned presentation and evidence from the actual experience (2026-10-22, Established design/verification requirements)

**Context:** The game's proposed appeal depends on seeing the toy's effort, contact and improvement. A numeric result or unrelated prototype screenshot cannot prove that experience.

**Decision:** Build the route before decoration and inspect it through the gameplay camera and phone viewport. Preserve native Roblox UI, approved Figma references, shared components/theme values and rendered comparison. Select lighting/assets for the game's approved direction and tested device, checking reduced graphics quality. Presentation belongs to a player/attempt with explicit cleanup; cosmetic failure cannot block authoritative progression or recovery. Builders replace only owned content and preserve unrelated authored geometry, spawns and lighting.

**Alternatives:** Universal terrain/mesh/lighting presets; treating the separate coconut UI prototype as approved game art; using geometry calculations or a still image as proof of readable motion or fun.

**Consequences:** Asset provenance, actual imported scale/pivots/contact, playback, input recovery and device conditions are verified when relevant. Physical-device performance and intended population must be recorded before representative load acceptance. Record reproduced engine pitfalls with evidence, fix and regression check. The complete third-party skill pack is not adopted or installed by this decision.

**Source:** [Game design principles](../../winning-ideas-rbx/docs/GAME_DESIGN_BASE.md) and reusable personal Roblox gameplay/UI/world-design skills.

## Clarifications to existing decisions (2026-10-22)

- D-001 remains in force. Local scripts/build mapping do not by themselves preserve unmapped Studio-authored content; establish its saved source/export procedure before rebuilding.
- D-002 remains in force for story review, user playtest and Git approval. T3 commands are host-specific. Use supported delegation/Studio tools when available and report exactly what ran; no current tool availability or test result is implied by an older verification note.
- D-003 remains the saved Git policy. This documentation request does not approve a commit or push. Recheck branch/upstream and tools when such work is requested; the historical statement about `gh` availability is not a current installation check.
- Persistence requirements promise recovery of the last successfully saved profile after a crash. Unconfirmed changes may be lost; a failed load must not overwrite progress and a failed save must not claim success. This clarifies error handling rather than selecting a storage library/schema.

## D-008 — Wind Up a Toy selected for the first prototype (2026-10-22, Accepted)

**Context:** D-004 kept the concept open between Wind Up a Toy and Inflate and Release, and every story was Blocked on that choice and an explicit implementation request.

**Decision:** The user chose **Wind Up a Toy for this prototype** and explicitly authorized implementing **GAME-001 / WT01 only**. The existing duck-themed stories stand without revision. Inflate and Release remains a possible future reconsideration at the M1 review gate; it isn't built in parallel and gets no interchangeable framework.

**Alternatives:** Select Inflate and Release and revise the first three stories first; keep both open and prototype neither.

**Consequences:** GAME-001 is In Progress. GAME-002–GAME-009 stay Blocked on their dependencies and a further explicit request. The M1 review still decides whether to retain the duck, revise its pacing or reconsider inflation-release before M2.

## D-009 — Local check toolchain (2026-10-22, Accepted)

**Context:** D-006 and GAME-001 require a repeatable build, offline production-rule tests, static analysis and formatting. Only Rojo was pinned.

**Decision:** With user approval, `aftman.toml` pins `lune-org/lune@0.11.1` (offline runner that loads the production Luau modules directly), `Kampfkarren/selene@0.32.0` (lint: Roblox std for adapters, Luau-only std for Rules/Config so engine globals fail there) and `JohnnyMorganz/StyLua@2.6.0` (format check), with Rojo unchanged at 7.7.1. `default.project.json` is unchanged; `tests/` and `tools/` are outside the Rojo map. One entry point, `lune run tools/check`, runs all checks.

**Alternatives:** The `luau` CLI with `luau-analyze` (no Roblox std, separate distribution); a Studio-only test harness (doesn't prove offline purity).

**Consequences:** Rules and Config must stay loadable by relative path in Lune and by instance in Roblox. Selene doesn't type-check, so there is no full type checker. That gap is recorded rather than claimed.
