# game-rbx development handoff

Updated 22 October 2026, Europe/Paris.

## Current state and authorization

The user requested filling the Markdown documentation in this repository from the established planning work. The working design, roadmap, architecture requirements and nine stories are recorded here. This is documentation work; the earlier instruction not to start coding remains in force. That initial update changed documentation only. A subsequent user request organized the reference library into UI features, mechanics, environments, models, animation, VFX and audio. Existing screenshots were moved intact; no gameplay source, image content, build mapping, toolchain settings, Studio place or publishing changed.

**22 October 2026 update:** The user selected Wind Up a Toy for this prototype (D-008) and explicitly authorized implementing **GAME-001 / WT01 only**. Inflate and Release remains a possible future reconsideration at the M1 review. The user approved pinning Lune 0.11.1, selene 0.32.0 and StyLua 2.6.0 in `aftman.toml` (D-009). They also approved a new Rojo-built `game-rbx.rbxlx` in the repository root (gitignored) as the Studio destination. GAME-001 is In Progress with a refined file scope, tuning and contract in its story file. GAME-002–GAME-009 remain Blocked. The user playtests GAME-001 before GAME-002 begins, and nothing is committed, pushed or published without their approval.

## Mandatory visual creation and approval

Every new or revised UI component, map design, model, asset, animation and VFX must be created with Claude Design or Claude Code, including prototypes, placeholders and blockouts. Present the finished version in Claude Desktop and obtain explicit user approval before import, upload, sync, integration or commit. Animations and VFX require a moving or playable timing preview, not still images or source code alone. If the required creator or Desktop preview is unavailable, report the blocker and leave that work pending without substituting another creator/viewer.

This gate applies within the current GAME-001 authorization and does not change story scope or statuses. Preserve existing authored content and prior approvals for unchanged work. Relevant Studio/gameplay-camera/device verification follows visual approval. The shared [AGENTS.md](AGENTS.md) rule and [workflow](docs/WORKFLOW.md) govern this sequence over older role defaults or direct-to-Studio instructions.

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

Finish the GAME-001 review and hand it to the user for a Studio playtest using the steps in the story's verification log. Wait for their results and approval before committing, and don't start GAME-002 until they request it. Don't create a general framework, implement later milestones early, or treat an unrelated open place as the destination.

## Provenance and verification limits

This plan was reconciled from the sibling [planning handoff](../winning-ideas-rbx/DEVELOPMENT_HANDOFF.md), its current stories, concept comparison and development/design guidance dated 22 October 2026. The local docs preserve the same scope and open choice. Later approved changes should update these local documents together; avoid conflicting copies.

The repository still has three hello-only Luau files and template baseplate/lighting settings. No offline gameplay suite, Studio playtest, physical-device test or enjoyment review is claimed. The reusable [Roblox Game Base](../Roblox-Game-Base-template/README.md) and personal Roblox skills are supporting guidance, not game implementation or validation evidence. Historical arrow-through-balloons plans and unrelated prototype work remain background only.
