# game-rbx development handoff

Updated 22 October 2026, Europe/Paris.

## Current state and authorization

The user requested filling the Markdown documentation in this repository from the established planning work. The working design, roadmap, architecture requirements and nine stories are recorded here. This is documentation work; the earlier instruction not to start coding remains in force. That initial update changed documentation only. A subsequent user request organized the reference library into UI features, mechanics, environments, models, animation, VFX and audio. Existing screenshots were moved intact; no gameplay source, image content, build mapping, toolchain settings, Studio place or publishing changed.

Wind Up a Toy remains the working concept. Inflate and Release is an open alternative, not a second implementation. All nine stories are not started and are recorded as Blocked pending concept resolution and an explicit implementation request, plus their story dependencies. The starter scripts are not completed gameplay.

## Read next

- [GAME_DESIGN.md](docs/GAME_DESIGN.md): working mechanics, scope, presentation and open decisions.
- [ROADMAP.md](docs/ROADMAP.md): the three milestones and exit evidence.
- [BACKLOG.md](stories/BACKLOG.md): local story files and original-ID mapping.
- [ARCHITECTURE.md](docs/ARCHITECTURE.md), [SYSTEMS.md](docs/SYSTEMS.md), [WORKFLOW.md](docs/WORKFLOW.md): actual source, planned boundaries and verification.
- [DECISIONS.md](docs/DECISIONS.md): existing decisions and the imported planning requirements.
- [References](references/README.md): category and feature folders, available images, visible evidence and scope limits. Empty feature folders are collection slots, not additional backlog commitments.

## Milestone boundary

M1 contains exactly WT01–WT03, named GAME-001–GAME-003 locally: complete an attempt, pass an obstacle with more Power, and earn improvement through training. Use one duck, one bench and one short course. The decisive demonstration is a fresh player failing at the early obstacle, training normally, then passing it. Review readable motion, contact, camera/control recovery, player isolation and enjoyment before expanding progression.

M2 adds Wins/flags, the three-bench ladder, two rebirth unlock steps and onboarding through WT04–WT07. M3 adds saving and completes shared-session verification through WT08–WT09. The entire first version remains one lobby, one course, three obstacle families, five flags and three benches. Optional future updates are not release commitments.

## Engineering and presentation requirements

Keep pure production rules, plain balance configuration and Roblox adapters separate. Use one balance-config folder and a central network contract, preserving the existing Rojo mapping unless a change is approved. The server owns state, captures attempt inputs and settles rewards once. Maintain per-player presentation and cleanup from the first story.

Establish repeatable build, offline rules, static and formatting checks when coding begins. Verify the same production Luau modules offline, confirm local/Studio source freshness and collect relevant runtime/device evidence. Missing checks stay unverified. Preserve the native Roblox/Figma UI workflow and the map-first, gameplay-camera approach; models and mathematical checks do not prove visual quality or enjoyment.

## Next action

The documentation is ready for a concept decision or further planning. When the user requests implementation, resolve the concept from the latest instruction, inspect this repository and the intended Studio place, refine GAME-001's exact file scope and tool choices, and begin only the first story. If inflation-release is selected, revise the themed story criteria before coding. Do not create a general framework, implement later milestones early or treat an unrelated open place as the destination.

## Provenance and verification limits

This plan was reconciled from the sibling [planning handoff](../winning-ideas-rbx/DEVELOPMENT_HANDOFF.md), its current stories, concept comparison and development/design guidance dated 22 October 2026. The local docs preserve the same scope and open choice. Later approved changes should update these local documents together; avoid conflicting copies.

The repository still has three hello-only Luau files and template baseplate/lighting settings. No offline gameplay suite, Studio playtest, physical-device test or enjoyment review is claimed. The reusable [Roblox Game Base](../Roblox-Game-Base-template/README.md) and personal Roblox skills are supporting guidance, not game implementation or validation evidence. Historical arrow-through-balloons plans and unrelated prototype work remain background only.
