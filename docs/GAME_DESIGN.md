# Game Design

Updated 22 October 2026, Europe/Paris.

**Planning is complete for nine development stories; implementation has not started or been authorized. Wind Up a Toy is the working direction, and Inflate and Release remains an open alternative.** The rules below are the saved working design for the duck backlog, conditional on that concept being retained. They are not implemented behavior or a finalized economy.

This document brings the established [development stories](../../winning-ideas-rbx/docs/DEVELOPMENT_STORIES.md), [concept comparison](../../winning-ideas-rbx/docs/CONCEPT_DIRECTION.md) and [design principles](../../winning-ideas-rbx/docs/GAME_DESIGN_BASE.md) into the development repository. The local [backlog](../stories/BACKLOG.md) maps WT01–WT09 to GAME-001–GAME-009. Historical arrow-through-balloons work and the separate coconut prototype do not override this plan.

## Vision

Train by turning a small toy's key, then release an oversized wind-up duck onto a short obstacle course. Watch its key unwind, feet scramble, body slow, and final stall or flop. Return with more Winding Power and pass the exact obstacle that stopped the previous attempt. The attraction is the toy's readable behavior and visible improvement; expanding the economy follows a successful review of that repeated action.

The first complete version is bounded to one compact shared lobby, one duck at training and challenge scales, one course, three obstacle families, five reward flags, three winding benches and two rebirth unlock steps. New toys, worlds, pets, shops, monetization and scheduled events are outside the saved backlog. Completing it is not permission to publish.

## Target players and platforms

The intended experience is a simple, quickly understood train → release → improve loop. A precise age range, audience segment and acquisition strategy have not been selected; dated research does not establish demand or retention.

Mouse and touch controls, desktop views and a recorded phone viewport are required by the stories. Record orientation, resolution, graphics quality and whether testing used an emulator or a physical device. Console/controller and VR support are not established commitments. The baseline physical phone, intended server population and measured performance budgets remain to be chosen before representative load validation in M3.

## Core gameplay loop

1. Use the starter winding bench. The avatar repeatedly turns the small toy's key; validated training increases Winding Power and the derived Level.
2. Stop training and use the nearby launch area. A short winding animation releases one oversized duck and the camera follows it.
3. Watch the toy meet the ramp, step or loose blocks. The turning key, feet, struggle and slowdown communicate effort and remaining wind.
4. See a terminal distance result on exhaustion or reaching the finish. Retry or return to training with recovered controls and a clear previous stopping point.
5. Earn enough Power to pass the same obstacle. From M2 onward, pursue reward flags, earn Wins and rebirth to unlock faster training benches.

M1 demonstrates steps 1–4 and earned improvement with one bench and a short course. Currency, rebirth and cross-session saving follow later. WT03 targets 10–30 seconds of configured starter training to pass the early obstacle; record the selected gain rate and fixture values before verification. This is a prototype target, not a measured result.

## Mechanics

### Winding Power, remaining wind and Level

- Winding Power is earned through validated training, retained through ordinary attempts and reset on rebirth. Releasing the duck does not spend Power.
- Each attempt derives a temporary remaining-wind budget from Power captured at release. Movement and obstacle interactions consume that budget. Starting Power is 0 and starting Level is 1; baseline wind must still produce a readable starter attempt.
- Level is derived from Power using one configurable threshold table. There is no separate XP currency.
- The same course and captured inputs produce the same scored progress. Increasing Power cannot reduce progress; the finite course caps the result. Cosmetic wobble, flop and block scatter cannot change progression.
- Distance measures forward progress from the start, capped at the course end. Backtracking, wobbling or repeated motion cannot add scored distance.

WT01–WT03 establish these mechanics. Exact conversion, movement, costs and thresholds remain tuning inputs in one authoritative Config folder; see [ARCHITECTURE.md](ARCHITECTURE.md).

### Attempts and obstacles

The server owns each player's attempt, captures its identifier, course identifier, Power and relevant configuration, and rejects overlapping launches. Later stat changes cannot alter an active attempt. One player can train or run a challenge, never both.

The three obstacle families are a short ramp, low step and lightweight block section. The duck visibly contacts each before reacting: uphill effort, scrambling over the step, or pushing blocks. Insufficient wind leads to a bounded struggle and a terminal result. Prepared low/medium/high Power fixtures prove repeatability and the early obstacle's exact passing threshold; the low fixture is the actual fresh Power-0 profile. WT02 initially targets 8–20 seconds for a medium/high full attempt and at most two seconds of struggle before a failed step resolves; early failures may be shorter. Record tuning changes and their reason.

Exhaustion and reaching the finish are normal endings. Death, character reset, leaving the challenge or disconnect before settlement cancel the attempt without rewards. An already settled result is preserved. Retry clears the old duck, obstacles and temporary presentation and restores a usable start state. Cameras, controls and cleanup belong to the affected player; another player's run continues unchanged.

### Training and benches

Training starts through an explicit interaction and continues at a configured gain and interval until Stop, leaving, reset/death or another valid state transition ends it. The server validates timing and eligibility. Repeated activation cannot create stacked sessions; fractional gains accumulate rather than being rounded away.

| Bench | Required rebirths | Gain multiplier | Milestone |
|---|---|---|---|
| Starter | 0 | 1× | M1 |
| Second | 1 | 1.5× | M2 |
| Third | 2 | 2× | M2 |

These are the saved initial tuning fixtures. There is no additional hidden rebirth multiplier. Signs and displayed gains derive from the same values used by the server. Switching benches ends the old session before starting the new one. The highest initial tier does not advertise an unimplemented bench.

### Wins, flags and records

M2 adds five flags along the existing course. Each flag displays its distance and configured reward. A normally completed attempt grants the sum of crossed flags once on the server; zero flags means zero Wins, and a full clear grants the sum of all five. A new attempt can earn those rewards again. Repeated contacts, signals and result clicks cannot settle the same attempt twice.

Personal best is the farthest completed forward distance on this course. Equal or shorter results cannot reduce it. An interrupted unsettled attempt updates neither Wins nor best; interruption after settlement cannot revoke or duplicate them. The result shows distance, earned/total Wins and any new best, with Retry and Train actions. At the course end, it shows completion rather than an unreachable next flag.

### Rebirth

A rebirth requires both the displayed Level requirement and Wins cost. A single validated confirmation deducts that cost, resets Power to 0 and Level to 1, increments rebirth count and unlocks the eligible bench as one coherent change. Unspent Wins, personal best and prior bench unlocks remain.

Rebirth is unavailable during an attempt. Active training stops before reset; a delayed old tick cannot restore gains. Duplicate confirmations cannot create a second rebirth. The initial ladder stops after two rebirths. Costs and Level requirements are unselected tuning inputs and must be reachable with the current course, flags and benches. At least the first full rebirth cycle must be demonstrated through ordinary play.

### Onboarding

M2 finishes the compact lobby and introduces one current objective. From spawn, the starter bench and launch area must be recognizable. The introduction advances on actual training, an attempt and improvement, with a full clear satisfying the improvement step; clicking through text is insufficient. It can be dismissed without blocking play.

The next objective points to useful available progress: training, an attempt, more Power for a flag, replaying flags for Wins, or an eligible rebirth. It handles a full course clear, zero rewards and the two-rebirth cap without directing players to missing content.

## Progression and saving

Agree the profile field contract by WT03/GAME-003; implement cross-session persistence in WT08/GAME-008. The planned saved fields are profile version, Power, Wins, rebirth count, best distance and introduction status. Level and bench eligibility are derived from those fields. Exact storage schema, version value, keys, library/session strategy and test environment remain implementation decisions.

Save a consistent profile, including a complete rebirth state, rather than independent fragments. Do not persist a live duck, active training session, captured camera or pending attempt as resumable play. On rejoin, return to a safe lobby state.

Load failure cannot be treated as a new account or overwrite progress with defaults. Save failure retains the latest in-session state for retry and cannot display a false success. After a crash, only the last successfully saved profile is guaranteed; unconfirmed changes may be lost. Duplicate deliveries and older-session writes must not duplicate progression or overwrite a newer committed profile.

## Multiplayer and social

Players share a workshop and can see other players training and running ducks. Each player's Power, remaining wind, obstacle presentation, flags, results, camera and rewards remain independent from WT01 onward. Other avatars and ducks cannot block the scored route. Joining must not restart another player's attempt or spawn a duplicate presentation.

WT09/GAME-009 completes overlapping-run, rejoin, cleanup and representative load checks. At least two players are required for correctness checks; this does not establish server capacity. Racing, trading, party systems, co-op goals and competition rewards are outside the saved scope. No server population has been selected.

## Monetization

No game passes, developer products, paid boosts, premium rewards or commercial economy have been selected. Monetization is outside these nine stories. Product choices, prices and their effect on progression need a separate decision and scoped work if requested; reference images containing shops or boosts do not approve them.

## Art, world and audio direction

The working setting is a compact toy workshop/play area with simple original visuals for M1. The final palette, materials, fonts, approved Figma frames and sound assets are not selected. The separate coconut UI prototype demonstrates a workflow, not an approved art direction for this game. [References](../references/README.md) identifies available screenshots and what they can support.

Block out spawn → bench → launch → follow camera → result/return before decoration. Keep repeated trips short and the bench/launch relationship obvious. Judge access, clearances, contact and obstruction with the actual actor dimensions and gameplay camera, including phone views. A flat floor, straight course and simple Parts are valid; terrain, mesh-only construction and a fixed lighting preset are not requirements.

The toy, obstacle contact and stopping point have first visual priority, followed by training and launch controls. Keep scenery out of the route and camera, distinguish intentional collision from decorative detail, and make required distinctions readable without relying only on color. Check silhouette, key, feet and obstacle edges at intended and low graphics settings.

Author clear beats: winding, release, contact, effort, depletion, stall/flop and result. Review poses and full motion at normal speed. When audio/VFX is introduced, connect it to those events, listen/watch in the actual place and check retries and overlapping players. The loop must remain understandable with sound muted. Optional or missing cosmetic assets cannot block settlement or camera recovery, but missing required cues remain unfinished acceptance criteria.

Preserve native Roblox UI, reusable components, shared theme values and rendered comparison with approved references. Keep cosmetic asset IDs and theme values separate from balance config. Record asset provenance, dimensions, facing, pivot/contact and collision when importing. Builders replace only their owned content, preserving unrelated geometry, spawns and lighting. Identify saved sources/export procedures before editing a Studio-authored map.

## Concept alternative and review gate

Inflate and Release is still being explored: train by repeatedly inflating a small object, release a large visibly venting air toy, follow its flight, deflation and landing, then improve the next distance. The archived arrow-through-balloons concept is a different game. Neither current candidate has been prototyped here or demonstrated better enjoyment.

If inflation is selected, revise the first three stories and later theme-specific criteria before coding; do not build both systems or a generic multi-theme framework. If wind-up is retained, M1 must show a fresh player failing at a recognizable obstacle, training normally and passing it. Review five consecutive attempts, including an unchanged-Power repeat and improvement, and record an observer's explanation of what changed. Decide whether to retain the duck, revise its pacing or reconsider the alternative before M2. Technical correctness alone does not establish enjoyment.

## Decisions still open

| Decision | Needed by |
|---|---|
| Wind-up versus inflation-release, and explicit implementation request | Before starting GAME-001 |
| Actual Studio place and authoritative authored-asset workflow | Before Studio changes |
| Exact tuning, route dimensions and reproducible fixtures | Before verifying each relevant story |
| Profile field contract; later storage schema and save/session implementation | GAME-003; persistence details before GAME-008 |
| Final UI/world/audio art direction and any required asset rights | Before producing those assets |
| Intended server population, baseline physical device and performance budgets | Before representative GAME-009 checks/public-release consideration |
| Monetization, further platforms, future content and publishing | Separate requests/decisions outside this backlog |
