# Visual and asset references

Updated 22 October 2026, Europe/Paris. The user requested a useful folder structure for Roblox UI and asset references. All eight existing images were inspected and moved into the categories below with their filenames and contents preserved.

This is a reference library. [Game design](../docs/GAME_DESIGN.md) and the [backlog](../stories/BACKLOG.md) define what is being built. Daily rewards, playtime rewards, shop, inventory and other optional folders reserve a place to collect ideas; creating them adds no gameplay commitment. Wind-up versus inflation-release remains open, and M1 is still exactly GAME-001–GAME-003 / WT01–WT03.

## Folder map

```text
references/
  ui/
    full-screens/       complete screen composition
    hud/                persistent counters, meters and navigation
    components/         reusable buttons, panels, icons and states
    training/           Start/Stop, gains and bench labels
    results/            distance, rewards, Retry and Train
    daily-rewards/      calendar/day-based reward panels
    playtime-rewards/   elapsed-play-time reward panels
    shop/               catalogs, prices and purchase feedback
    inventory/          owned items, selection and equipped states
    rebirth/            eligibility, reset preview and confirmation
    onboarding/         tutorial prompts and current objectives
    boosts/             temporary-effect indicators and controls
    events/             announcements and notification panels
    settings/           preferences and accessibility options
  mechanics/
    training/
    attempts-and-obstacles/
    progression/
  environments/
    layout/
    lighting-and-mood/
  models/
    toys-and-characters/
    training-stations/
    obstacles/
    props/
  animation/
  vfx/
  audio/
```

Every folder has a short README explaining its purpose, current material and scope. These README files preserve the structure in version control, including folders with no images yet. The former empty `assets/` bucket is replaced by the specific model, motion, effect and audio categories. Add more subfolders when references need them; do not prebuild a full taxonomy of every possible game feature.

## Choose a destination

| Category | Organizing question | Guide |
|---|---|---|
| UI | How is information or an action presented on a screen or world-space label? | [UI index](ui/README.md) |
| Mechanics | What does the player do, and what observable sequence follows? | [Mechanics index](mechanics/README.md) |
| Environments | How are spaces arranged and how does the whole scene read? | [Environment index](environments/README.md) |
| Models | What should an individual 3D object look like? | [Model index](models/README.md) |
| Animation | How does the subject move or change pose over time? | [Motion guide](animation/README.md) |
| VFX | What transient visual cue accompanies an event? | [Effect guide](vfx/README.md) |
| Audio | What should a cue or ambience sound like? | [Audio guide](audio/README.md) |

Choose by primary purpose, not image size. A complete screenshot can primarily explain training; a complete HUD composition belongs in `ui/full-screens`. Keep each original once and cross-link it from other relevant READMEs. A Shop button visible on a full screen does not constitute a shop-panel reference. Do not copy a full screenshot into daily rewards, inventory and rebirth simply because those buttons are present.

The three training frames remain together in `mechanics/training`; `ui/training` and `ui/hud` link to them for their interface cues. This preserves context without duplicating files. New crops or annotated variants should link to their original and state what changed.

## References, production assets and game logic

- This library holds inspiration, observable behavior, source links and explanation. It is not an asset export directory, approved Figma library or source of Roblox asset IDs.
- Recoverable editable models, UI artwork, exports and licensed sounds belong in the production asset workflow when introduced. Record provenance, source and import/upload status in the relevant manifest; do not mix them into inspiration folders by default.
- Gameplay rules, tuning, network contracts, server handlers, client controllers and persistence stay in the source structure described in [ARCHITECTURE.md](../docs/ARCHITECTURE.md). Do not create parallel `server`, `Rules`, `Config` or `DataStores` folders inside references.
- Put actual design decisions and acceptance criteria in docs/stories. A reference folder or image does not approve a feature, economy, palette or copy of another game's artwork.

## Current reference inventory

The bottle-training screenshots inform the established planning cues: a readable interaction position, Power and Level feedback, visible station multipliers and lock requirements, an immediate next objective, and a large Stop control. Their values, terrain, props and other systems are not this game's specification. Still images do not establish timing, exact reward rules, automatic behavior, persistence, performance or enjoyment.

| File | Observable content | Relationship to the current plan |
|---|---|---|
| [Screenshot 2026-10-19 234856.png](<mechanics/training/Screenshot 2026-10-19 234856.png>) | An avatar at the front of a training lane; adjacent stations labeled 1x, 1.5x and higher Power; unlocked/locked signs and requirements; Power, multiplier and Level displays; a top objective to reach a level. | Relevant to GAME-003 / WT03 training feedback, GAME-005 / WT05 bench eligibility and GAME-007 / WT07 next-action guidance. Adapt the readable relationships to the small winding toy. The screenshot's higher tiers and values are not approved tuning. |
| [Screenshot 2026-10-19 234911.png](<mechanics/training/Screenshot 2026-10-19 234911.png>) | The same training area with gain feedback, Power and Level progress, and a prominent red Stop button during the displayed interaction. | Relevant to GAME-003 / WT03 Start/Stop, visible gains and Level feedback. It supports the intended feedback layout, not the training tick rate or gain calculation. The repeat-session rules come from the story. |
| [Screenshot 2026-10-02 224604.png](<environments/layout/Screenshot 2026-10-02 224604.png>) | Several adjacent colored lanes with large multiplier and locked/unlocked labels; later lanes also show premium-currency prices. | An older layout reference for comparing nearby station eligibility. Current scope is three winding benches, with the story's 1x / 1.5x / 2x defaults and 0 / 1 / 2 rebirth requirements. The number of lanes, large multipliers, premium lanes, palette and environment are not approved. |
| [Screenshot 2026-10-02 224548.png](<mechanics/training/Screenshot 2026-10-02 224548.png>) | An avatar on a station pad, visible skill-gain numbers, an unlocked multiplier label and locked stations behind it. | An older example of immediate gain feedback and a visible next station. No current requirement to reproduce its props, pets, skill currency, amounts or exact layout. |
| [tutorial.png](ui/onboarding/tutorial.png) | A large "Collect the loot!" prompt, pointing-hand cue and a yellow route toward a pickup; level/currency indicators and distant locked areas. | General onboarding inspiration relevant to GAME-007 / WT07's actionable guidance. The approved criteria require learning through actual training, an attempt and improvement; loot collection, the route graphic and the depicted world are not committed features. |
| [Screenshot 2026-10-03 025316.png](<ui/full-screens/Screenshot 2026-10-03 025316.png>) | A dense simulator HUD with a Level bar, skill/multiplier values, rebirth and Wins counters, shop/pet/inventory buttons, premium offers and an offline-earnings notification. | Context for the older reference collection only. No current approval for its density, styling, pets, shops, paid boosts, offline earnings or automation. Read current stories for the limited Power, Level, Wins and rebirth displays actually planned. |
| [boosts-bottom-left.png](ui/boosts/boosts-bottom-left.png) | A cropped Release Pass banner and three lower-edge controls showing "Off", "0/3" and "Open", including potion imagery. | Retained reference with no agreed use in the current backlog. The crop does not establish those controls' behavior. Passes, boost systems and this control grouping are not approved features. |
| [admin-abuse-notif.png](ui/events/admin-abuse-notif.png) | A Join Event modal with a dated promotional image, event text, close control and Notify Me button. | Retained reference with no agreed use in the current backlog. Scheduled events and event notifications are outside the planned first version; the date and event text belong to the source screenshot. |

No image in this folder is an approved duck asset, inflation asset, final UI mockup, lighting preset or complete world brief. The current visual requirement is readable toy motion, obstacle contact, improvement and usable mouse/touch controls. Original simple visuals are sufficient for M1; art direction and rendered comparison belong to the relevant story when implementation is requested.

## Adding and using references

1. Read this index, then only the category/feature guide relevant to the task. Store the file under its primary purpose and link other relevant uses.
2. Give new files descriptive names such as `training-stop-phone.png` or `inventory-empty-state.png`. Existing filenames were retained in this reorganization for traceability. Keep related devices/states in the same feature folder unless volume warrants a further split.
3. Record the source URL or owner, capture details when known, observed UI state/device, the detail to study, what not to carry over, related story and status (`inspiration` or `direction agreed`). Record unknowns explicitly.
4. Preserve the Figma-to-native-Roblox workflow, shared components/theme values and rendered comparisons. Static references cannot prove input behavior, contact, timing, physical-device performance or enjoyment.
5. If a new source shows a feature outside the backlog, label it as possible future inspiration; do not silently add it to implementation. Keep empty folders honest about having no dedicated examples.

### Entry template

Use this within the relevant folder README when adding material:

```markdown
### <Reference name>
- File or source link: <relative file link or stable source URL>
- Source/creator and rights: <known facts, or unknown>
- Captured state/device: <what is known>
- Observe/adapt: <specific visual or interaction cue>
- Do not carry over: <unrelated systems, branding, artwork or numbers>
- Related story: <existing ID, or future inspiration only>
- Status: inspiration | direction agreed
- Unknowns: <behavior, provenance or measurements not established>
```

## Provenance and preservation

The source-game URLs, original creators and reuse permissions of the eight existing screenshots are not documented. Their presence does not establish a license to use the depicted artwork. Keep them as discussion references and record provenance when available. Prefer reasonably sized PNG/JPG/WebP captures; link large videos or editable source files through their appropriate source workflow.

This reorganization moved the existing files into subfolders; no image was edited, replaced or duplicated. Original basenames remain unchanged. The training and environment filenames are therefore still searchable, while the reference inventory points to their new paths. No game code, story scope, Studio place or runtime asset was changed.
