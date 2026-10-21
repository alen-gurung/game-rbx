# UI references

Choose a folder by the interface being studied. Full-screen composition, persistent HUD, reusable controls and individual feature panels are separate concerns. UI inside the 3D world, such as bench labels, still belongs to its relevant UI feature; the sign's geometry belongs under models.

| Folder | Use |
|---|---|
| [Full-screen UI](full-screens/README.md) | Complete gameplay screens used to study overall composition: HUD placement, visual hierarchy, modal layering and the space left for the game. |
| [HUD and persistent indicators](hud/README.md) | In-play counters, Power/Level displays, remaining-wind meters, current objectives, navigation and persistent status indicators. |
| [Reusable UI components and icons](components/README.md) | Buttons, panels, cards, tabs, progress bars, counters, icon treatments, typography and state styling reused across screens. |
| [Training and bench UI](training/README.md) | Start/Stop controls, gain feedback, Power/Level progress and bench requirement labels, including readable UI placed in the world. |
| [Attempt results and retry UI](results/README.md) | End-of-attempt distance, best markers, earned rewards, Retry and Train actions, including finish and cancellation states where applicable. |
| [Daily reward UI](daily-rewards/README.md) | Calendar/day-based reward panels, streak presentation and unclaimed/claimed/locked states. |
| [Playtime reward UI](playtime-rewards/README.md) | Rewards displayed against elapsed play time, including timer milestones, available claims and completed claims. |
| [Shop UI](shop/README.md) | Catalog panels, item cards, offer details, displayed prices and purchase feedback. |
| [Inventory UI](inventory/README.md) | Owned-item grids/lists, categories, selection details, equipped indicators and empty/full states. |
| [Rebirth UI](rebirth/README.md) | Eligibility, requirements, reset-versus-retained preview, confirmation and the highest-tier state. |
| [Onboarding and objective UI](onboarding/README.md) | First-visit instructions, current objectives, contextual hints and directional guidance into the world. |
| [Boost and temporary-status UI](boosts/README.md) | Temporary-effect indicators, active duration, counts and related activation controls. |
| [Event announcements and notification UI](events/README.md) | Announcement panels, event details, close controls, notification prompts and event-entry presentation. |
| [Settings and accessibility UI](settings/README.md) | Preferences panels such as sound, music, presentation and supported input options. |

Daily rewards and playtime rewards stay separate because they communicate different schedules. Shop, inventory and rebirth stay separate because they present different player decisions and states. A button leading to a feature is not evidence for its full panel. Cross-link shared screenshots instead of copying them into every feature folder.

Each folder states whether it has material and whether the feature belongs to the current backlog. An empty reference folder does not add that feature to the plan. For future captures, keep desktop/phone variants together with descriptive filenames; add device/state subfolders only when a collection becomes large enough to need them.

Use [the reference guide](../README.md) for provenance and scope, and the existing native Roblox/Figma workflow for implementation. These folders contain visual input; live values, rules, balance and network handling remain in the documented source architecture.
