# Backlog

Updated 22 October 2026, Europe/Paris.

This is the local index of the nine established development stories. **Planning is complete; every story is not started and Blocked.** Wind Up a Toy is the working concept, while Inflate and Release remains an open alternative. Confirm the concept and explicitly request implementation before starting game work. These populated documents do not grant implementation, commit, push or publishing approval.

- **Local IDs:** `GAME-###`, sequential and never reused. **Next ID: GAME-010.**
- **Original IDs:** `WT01`–`WT09` remain permanent aliases for the matching `GAME-001`–`GAME-009` stories below. This migration creates no extra story and changes no dependency.
- **Files:** Planned story records are in `active/`; completed/approved delivery records move to `completed/` under [WORKFLOW.md](../docs/WORKFLOW.md). None are complete.
- **Template:** [TEMPLATE.md](TEMPLATE.md) remains a reusable blank template. Its example fields are not unanswered project decisions.
- **Sizing:** Original **M** means one bounded player behavior with several states; **S** means a narrow extension to established behavior. Neither is a delivery-date estimate. No conversion to numeric points has been established; all points remain unestimated. Numeric sizing and explicit file scope are refined before a story becomes Ready.
- **Priority:** No individual High/Medium/Low assignments were established. Follow the milestones and dependencies; do not infer new priorities from the migration.
- **Design and open decisions:** [GAME_DESIGN.md](../docs/GAME_DESIGN.md), [ROADMAP.md](../docs/ROADMAP.md) and [DECISIONS.md](../docs/DECISIONS.md).
- **Implementation guidance:** [ARCHITECTURE.md](../docs/ARCHITECTURE.md), [SYSTEMS.md](../docs/SYSTEMS.md) and [WORKFLOW.md](../docs/WORKFLOW.md).

## Active and planned

| Local story / original alias | Title | Epic | Original size | Points | Status | Direct story dependencies |
|---|---|---|---|---|---|---|
| [GAME-001 / WT01](active/GAME-001-release-duck-attempt.md) | Release a duck and complete an attempt | M1 — Initial playable loop | M | Unestimated | Blocked — not started | None |
| [GAME-002 / WT02](active/GAME-002-obstacles-and-power.md) | Pass an obstacle with more Power | M1 — Initial playable loop | M | Unestimated | Blocked — not started | [GAME-001 / WT01](active/GAME-001-release-duck-attempt.md) |
| [GAME-003 / WT03](active/GAME-003-train-and-improve.md) | Train and improve the next attempt | M1 — Initial playable loop | M | Unestimated | Blocked — not started | [GAME-002 / WT02](active/GAME-002-obstacles-and-power.md) |
| [GAME-004 / WT04](active/GAME-004-wins-and-flags.md) | Earn Wins and pursue the next flag | M2 — Progression and first session | M | Unestimated | Blocked — not started | [GAME-003 / WT03](active/GAME-003-train-and-improve.md) |
| [GAME-005 / WT05](active/GAME-005-eligible-winding-benches.md) | Choose an eligible winding bench | M2 — Progression and first session | S | Unestimated | Blocked — not started | [GAME-003 / WT03](active/GAME-003-train-and-improve.md) |
| [GAME-006 / WT06](active/GAME-006-rebirth-and-faster-training.md) | Rebirth and train faster | M2 — Progression and first session | M | Unestimated | Blocked — not started | [GAME-004 / WT04](active/GAME-004-wins-and-flags.md), [GAME-005 / WT05](active/GAME-005-eligible-winding-benches.md) |
| [GAME-007 / WT07](active/GAME-007-first-visit-guidance.md) | Understand the first visit | M2 — Progression and first session | S | Unestimated | Blocked — not started | [GAME-006 / WT06](active/GAME-006-rebirth-and-faster-training.md) |
| [GAME-008 / WT08](active/GAME-008-saved-progress.md) | Leave and return to saved progress | M3 — Saved and shared sessions | M | Unestimated | Blocked — not started | [GAME-006 / WT06](active/GAME-006-rebirth-and-faster-training.md), [GAME-007 / WT07](active/GAME-007-first-visit-guidance.md) |
| [GAME-009 / WT09](active/GAME-009-shared-session-reliability.md) | Play alongside others reliably | M3 — Saved and shared sessions | M | Unestimated | Blocked — not started | [GAME-008 / WT08](active/GAME-008-saved-progress.md) |

Every row also depends on the shared concept decision and explicit implementation request. When those gates are resolved, refine the affected story's file scope, tuning fixtures and remaining implementation choices; do not treat a Blocked story as Ready merely because its acceptance criteria are written.

GAME-004 / WT04 and GAME-005 / WT05 may proceed independently after GAME-003 / WT03. Other dependencies follow the table. Per-player state ownership and isolation begin in GAME-001 / WT01; GAME-009 / WT09 completes shared-session behavior rather than replacing a single global run.

## M1 — Initial playable loop

**M1 contains exactly GAME-001, GAME-002 and GAME-003 — the same three stories as WT01, WT02 and WT03.** They use one duck, one starter bench and one short course with a simple lobby area. Wins, rebirth, the three-bench ladder, cross-session saving and a fully decorated lobby are not M1 requirements. Architecture/tooling work belongs inside these stories and does not create additional milestone stories.

The central demonstration is a fresh player whose duck stops at a recognizable obstacle, trains normally by winding a small toy, then passes that same obstacle. Key motion, feet, struggle, slowdown and the terminal result must remain readable; completion, interruption and Retry must recover camera/controls.

M1 is ready for review only when:

- [ ] GAME-001..003 / WT01..WT03 acceptance criteria are demonstrated; unchecked behavior remains explicitly unchecked.
- [ ] A fresh test profile fails at a recognizable obstacle, trains normally and passes that same obstacle on the next attempt.
- [ ] Camera and controls recover from normal completion and interruption, and a second player's activity does not change the result.
- [ ] Five consecutive attempts have been reviewed, including an unchanged-Power repeat and an improved result. Record engaging, slow or confusing moments. Ask an observer why the duck stopped and what changed after training, and record the answer.
- [ ] Decide whether to retain the duck, revise pacing or reconsider Inflate and Release before expanding into M2. Technical completion alone does not establish enjoyment; this is a small qualitative prototype review, not a retention claim.

If Inflate and Release is selected, revise the first three stories around inflation, escaping-air flight, deflation and a farther landing after training, then update theme-specific later criteria before implementation. Do not build both concepts or a generic interchangeable framework by default.

## M2 and M3

- **M2 — Progression and first session:** GAME-004..007 / WT04..WT07 add five reward flags and Wins, three benches, two rebirth unlock steps and first-visit guidance.
- **M3 — Saved and shared sessions:** GAME-008..009 / WT08..WT09 add versioned saved progression and complete shared-session/device/load evidence.

The first complete version is bounded to one compact shared lobby, one duck at training/challenge scales, one course, three obstacle families, five flags, three benches and two rebirth unlock steps. New toys, worlds, pets, shops, monetization and events are future candidates outside this backlog. Completing these stories does not authorize public release.

## Shared planning and acceptance rules

Use [GAME_DESIGN.md](../docs/GAME_DESIGN.md) as the local reference for the full working rules. The following requirements apply throughout the stories:

- Launch captures the player's Power and relevant attempt/configuration inputs. Earned Power is not spent by launching; remaining wind is a separate temporary attempt budget.
- Fixed course plus fixed captured Power produces the same scored progress; more Power cannot reduce progress. Scored distance is forward progress, capped at the finite course end. Cosmetic variations cannot change the result.
- One player has one training session or one challenge at a time. Start/Stop, interruption and delayed callbacks must not stack gains or alter another player.
- Normal exhaustion can settle rewards in GAME-004 onward. Death, reset, leaving or disconnect before settlement cancels without rewards; a settled result remains settled and cannot pay again.
- Agree source profile fields by GAME-003 even though saving begins in GAME-008. Save Power, Wins, rebirth count, completed best, introduction status and a version as one consistent profile; derive Level and bench eligibility.
- Record exact fixture values before relevant acceptance checks: baseline wind, movement/obstacle costs, gain/interval, Level thresholds, flag values and rebirth requirements as introduced. These are not a finished economy. Requirements must remain reachable with the current course and benches.
- Establish the local repeatable build/offline-rule/static/format procedure within GAME-001. Test the same production Luau rule modules used in-game. Add focused rule checks with the story that introduces the behavior; do not use a separate language rewrite as proof.
- Preserve the native Roblox/Figma UI workflow, shared theme/components, actual rendered comparisons and scoped world ownership. Missing cosmetic assets must not block settlement or recovery, but unmet presentation criteria remain open.
- Judge the route using the real gameplay camera and recorded phone viewport. Emulator checks must not be reported as physical-device checks; arithmetic cannot prove readable contact, recovery or enjoyment.

## Completing and maintaining stories

Each story file preserves the original acceptance criteria and required completion evidence and adds local implementation/planning context. None contains completed evidence yet.

Close a story only when its dependencies and criteria are met with evidence, relevant controls work with mouse/touch, the required checks are reported accurately, and the [workflow](../docs/WORKFLOW.md) delivery gates are satisfied. Keep missing environments, skipped checks and unverified behavior open. Record configuration/source revision, fixture values, commands/results, relevant Studio evidence and tested devices; distinguish simulations from actual environments.

Keep each implemented story in its own reviewable change. Record tuning decisions and material scope changes beside the story. A new toy gait, obstacle family, world or additional economy needs a future scoped story rather than an unbounded addition. Do not invent numeric estimates, exact remote names, module paths, data keys or approvals while resolving documentation blanks.

## Completed

No development story is complete, and no game implementation, Studio acceptance, user playtest approval, commit or push is claimed by this documentation migration.

## Provenance and migration note

The local stories were populated on 22 October 2026 from the established planning records in `C:/Users/ag/Desktop/winning-ideas-rbx/DEVELOPMENT_HANDOFF.md`, `docs/DEVELOPMENT_STORIES.md` and `docs/DEVELOPMENT_WORKFLOW.md`. The source WT aliases are retained for traceability; local GAME story links are used for future work in this project. Historical balloon/arrow prototype requests do not override this backlog or its authorization boundary.
