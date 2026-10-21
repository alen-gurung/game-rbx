# Visual & Design References

Inspiration material for planning features. References are **design input, not approved designs**, and not permission to copy anyone's artwork or assets.

## Layout
```
references/
  ui/             menus, HUD, inventory, shops
  environments/   maps, lighting, mood, terrain
  mechanics/      gameplay clips/screens showing interactions
  assets/         models, characters, props, VFX style
  <category>/<feature>/README.md + images
```
These categories are starting points. Add or reorganize them when useful, and update this file if you do.

## Adding a reference
1. Create a folder per feature, e.g. `references/ui/inventory/`.
2. Add the images with descriptive names (`example-01-grid-layout.png`, not `IMG_4021.png`).
3. Add a `README.md` using the template below. Images without explanation are ambiguous.

### Feature reference README template
```markdown
# <Feature> references
Related story/epic: GAME-### / <epic>
Status: inspiration | direction agreed

## Purpose
What this reference is for.

## Images
- `example-01.png` — what it shows; what to look at.

## Replicate / adapt
- Layout, interaction, feel, spacing, animation details I want.

## Do not copy
- Branding, artwork, icons, exact assets, anything not wanted.

## Roblox constraints
- Device targets (mobile/desktop/controller), scaling, performance notes.
```

## How agents use references
- Read a feature's README **first**, then inspect only the images it lists as relevant. Never scan the whole folder.
- Turn the agreed details into story acceptance criteria. Ask the user when an image is ambiguous or conflicts with the README.
- Never load references into startup context, and never reproduce copyrighted artwork or assets.

## Size and licensing
- Prefer PNG, JPG, or WebP screenshots under ~2 MB each. Don't commit videos, PSDs, or raw source files; link to them or keep them local instead.
- Only commit material you have the right to keep in this repo (it's pushed to GitHub).
