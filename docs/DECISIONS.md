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
