# Roadmap

Updated 22 October 2026, Europe/Paris.

**Planning complete; all implementation is not started.** This is the established three-milestone plan, conditional on the working Wind Up a Toy direction. The concept choice is still open and the saved backlog does not authorize coding. There are no delivery dates or release commitments.

Local GAME-001–GAME-009 IDs map one-to-one to the original WT01–WT09 IDs in the [backlog](../stories/BACKLOG.md). This is a naming adaptation, not nine additional stories. M1 contains exactly WT01–WT03. The full acceptance criteria and evidence requirements live in the linked story files.

## M1 — Initial playable loop (Status: Planned)

**Goal:** A fresh player releases a duck, watches it stop at a recognizable obstacle, trains normally, and then passes that same obstacle.

| Story | Original ID | Player outcome | Depends on |
|---|---|---|---|
| GAME-001 | WT01 | Release a duck and complete an attempt | Concept choice and implementation request |
| GAME-002 | WT02 | Pass an obstacle with more Power | GAME-001 |
| GAME-003 | WT03 | Train and improve the next attempt | GAME-002 |

Use one duck, one bench, one start area and one short course. WT02 introduces ramp, step and loose-block sections. Wins, rebirth, the full bench ladder, saving and a finished decorated lobby are outside M1. Local source/check tooling and per-player ownership are requirements inside the stories, not additional milestone stories.

**Exit evidence:** All three stories' criteria; actual earned improvement; normal completion/interruption and camera recovery; clean retries and basic player isolation; desktop/mouse and recorded phone/touch checks. Review five consecutive attempts, including equal-Power repetition and earned improvement. Record what an observer thinks caused the stop and improvement, and which moments are engaging, slow or unclear. Keep missing checks open. Decide whether to retain the duck, revise it or reconsider inflation-release before expanding progression.

## M2 — Progression and first session (Status: Planned)

**Goal:** Give successful attempts a visible next flag, reward, bench and rebirth goal, and teach the loop through the compact lobby.

| Story | Original ID | Player outcome | Depends on |
|---|---|---|---|
| GAME-004 | WT04 | Earn Wins and pursue the next flag | GAME-003 |
| GAME-005 | WT05 | Choose an eligible winding bench | GAME-003 |
| GAME-006 | WT06 | Rebirth and train faster | GAME-004, GAME-005 |
| GAME-007 | WT07 | Understand the first visit | GAME-006 |

**Depends on:** M1 evidence and its concept/pacing review. GAME-004 and GAME-005 can proceed independently after GAME-003. Keep the existing course and obstacle families; add five reward flags, three benches and exactly two initial rebirth unlock steps. WT07 finishes the compact layout and guidance, not a large world.

**Exit evidence:** Correct once-only rewards, locked/eligible bench behavior, one earned rebirth cycle, both unlocks and cap, consistent retained/reset state, and a fresh-profile walkthrough. Identify prepared profiles versus progress earned through play. Exact rewards, thresholds and costs are recorded fixtures, not preselected economy values.

## M3 — Saved and shared sessions (Status: Planned)

**Goal:** Preserve earned progression across visits and verify dependable overlapping play in the shared workshop.

| Story | Original ID | Player outcome | Depends on |
|---|---|---|---|
| GAME-008 | WT08 | Leave and return to saved progress | GAME-006, GAME-007 |
| GAME-009 | WT09 | Play alongside others reliably | GAME-008 |

**Depends on:** M2, a deliberate persistence design and a safe test environment. Basic player isolation already belongs to WT01; WT09 completes shared visibility and load/recovery verification.

**Exit evidence:** Save/load and failure/conflict cases; coherent rebirth snapshots; overlapping attempts and one player's interruption while another finishes; repeated-loop cleanup; the recorded target population and representative device/load checks. A two-player Studio check is not a capacity claim, and a phone viewport emulator is not physical-device validation. Untested release targets remain gaps. Finishing M3 does not authorize publication.

## Future candidates — no milestone or schedule assigned

These came from the [concept comparison](../../winning-ideas-rbx/docs/CONCEPT_DIRECTION.md). Select and scope them only after the initial experience proves worth repeating. They are not backlog commitments or M1 dependencies.

| Working concept | Candidate | New interaction or behavior |
|---|---|---|
| Wind-up | Conveyor workshop | Duck effort against a backward-moving belt |
| Wind-up | Hopping frog | Hopping gait, ledge hesitation and belly-flop ending |
| Wind-up | Marching robot factory | Marching/power-down motion and a seesaw bridge |
| Wind-up | Rotating toy challenge | Configured course variations, separate records and cosmetic goals |
| Inflation-release | Long balloon rockets | Distinct controlled burst and fluttering landing |
| Inflation-release | Fan tunnel course | Readable fixed-air-current interaction |
| Inflation-release | Cartoon air animals | New silhouette, visible venting and deflation behavior |
| Inflation-release | Rotating distance challenge | Familiar flight interactions in a new route |

Future updates should add a recognizable interaction as well as any new appearance or larger numbers. New toys, worlds, shops, pets, monetization, competitive modes and events require separate selection and stories. No market or retention outcome is established by these candidates.
