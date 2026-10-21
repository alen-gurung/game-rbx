# Development Workflow

**Plan → Implement → Review → Validate → User Playtest → User Approval → Commit → Push**

Roles: **User** (product owner, playtester, approver) · **Claude** (architect, planner, reviewer) · **Codex** (implementer).

## 1. Story lifecycle

| Status | Meaning | Location |
|---|---|---|
| Proposed | Idea captured; not yet refined | `stories/BACKLOG.md` only |
| Ready | Story file written, criteria agreed, ambiguity resolved | `stories/active/` |
| In Progress | Being implemented | `stories/active/` |
| In Review | Implementation done; Claude reviewing and validating | `stories/active/` |
| Awaiting Playtest | Handed to user with playtest steps | `stories/active/` |
| Done | Approved, committed, pushed, verified | `stories/completed/` |
| Blocked | Waiting on a decision or dependency (note why) | wherever it was |

Every meaningful gameplay feature needs a story before implementation. Small fixes (typos, one-line bugs) don't, but they still go through review and the approval gate.

## 2. Planning (Claude)

1. Understand the request. Ask the user when intent is unclear.
2. Use [SYSTEMS.md](SYSTEMS.md) to locate the affected systems, and read only those sources and docs.
3. Visual features: find the relevant `references/**/README.md`, read it, and inspect only the images it points to. Turn what you find into acceptance criteria. Ask about significant ambiguity. See [references/README.md](../references/README.md).
4. Write the story from [stories/TEMPLATE.md](../stories/TEMPLATE.md) as `stories/active/GAME-###-short-slug.md`, and add a row to [BACKLOG.md](../stories/BACKLOG.md).
5. Get user approval of the design for consequential choices: new mechanics, data schema, monetization, and architecture changes (record those in [DECISIONS.md](DECISIONS.md)).

### Sizing
Points measure relative complexity, uncertainty, and risk, not hours. Use 1, 2, 3, 5, 8, 13.
- Prefer 3–5 point vertical slices: server logic + remotes + client/UI for one behaviour.
- Look at splitting an 8. Split a 13 before implementation.
- Don't split tightly coupled work just to hit a number, and don't create stories for trivial edits.
- Group related stories under an epic name in the backlog. Plan only as far ahead as current priorities need.

## 3. Delegation to Codex (T3 Code)

**Verified 2026-10-21:** `orchestrator_capabilities` lists a `codex` provider with `canRunCrossProviderChildTask: true`. Re-check model IDs at delegation time; don't hard-code them.

- Call `delegate_task` with target provider `codex`, keep the returned `taskId`, and track it with `task_status`. Every correction round is a **new** `delegate_task` call with a distinct `clientRequestId`. That call includes the original brief, the review findings, and any open objections.
- Child agents **do not** share this conversation. They get AGENTS.md from the repo and nothing else, so the brief must stand alone.
- **Shared checkout (default):** Codex edits the working tree directly. Claude must not edit the same files until the task finishes.
- **Worktree isolation** (`isolation:"worktree"`): use it for parallel stories touching disjoint files. It branches from the last *commit*, so uncommitted story files and docs are missing; paste their content into the brief.
- Never run two writers on overlapping files.

### Delegation brief template
```
Story: GAME-### — <title>   (full story: stories/active/GAME-###-slug.md; content inlined below if uncommitted)
Objective: <one or two sentences>
Files in scope: <paths to create/modify>
Do NOT change: <files/systems>, default.project.json, aftman.toml
Required behaviour: <bullets>
Acceptance criteria: <copied from story>
Relevant docs/references: <paths>
Validation: rojo build -o <temp-dir>/check.rbxlx; <other checks>
Report back: files changed, how each criterion is met, checks run + output, anything unverified or out of scope.
Do not commit or push.
```

### Manual fallback
If `delegate_task` is unavailable or fails, Claude reports the limitation and prints the brief above. The user pastes it into a Codex thread, then tells Claude when it's done so Claude can review.

## 4. Review (Claude)

Review the full `git diff` and new files against:
- Acceptance criteria, item by item.
- Scope: no unrelated or architectural changes slipped in.
- Security: every remote handler validates types, ranges, ownership, rate, and cooldown. No client-trusted values, and no RemoteFunction calls server→client that could yield forever.
- Data: DataStore calls are `pcall`-wrapped with retry. No data-loss paths. No schema change without a migration plan and approval.
- Lifecycle: connections are cleaned up and `PlayerRemoving` is handled. No leaks in respawn loops.
- Multiplayer: behaviour is correct with more than one player, including joins mid-session.
- Conventions in [AGENTS.md](../AGENTS.md), and visual references respected.

Send findings back as a new delegated task. Repeat until clean.

## 5. Validation

| Check | Command | Status |
|---|---|---|
| Rojo project builds | `rojo build -o <temp-dir>/check.rbxlx` (outside the repo, or the gitignored `game-rbx.rbxlx`) | Available |
| Lint / format / type-check | none configured (no selene, StyLua, or luau-lsp in repo) | Not available |
| Automated tests | none | Not available |
| Runtime behaviour | Roblox Studio playtest by the user | Manual only |

Agents can't run Roblox Studio. Runtime behaviour is unverified until the user playtests.

## 6. Playtest handoff

Give the user:
1. **Setup:** `rojo serve`, connect the Studio plugin, and any Studio settings needed (e.g. API Services access).
2. **Steps:** numbered actions and the expected result for each, mapped to acceptance criteria.
3. **Multiplayer:** Test → Clients and Servers → *N* players, when relevant.
4. **Regressions** to spot-check.
5. **Files changed**, known risks, and what was *not* verified.

Then set the story to *Awaiting Playtest* and wait.

**DataStores in Studio:** with "Enable Studio Access to API Services" on, Studio reads and writes the experience's **real** DataStores. Use a separate test experience or a dev-only key scope before testing persistence. Never point tests at production player data without explicit approval.

## 7. Approval gate and Git

Nothing is committed or pushed until the user explicitly approves *this* change set. If substantial changes happen after approval, ask again.

After approval:
1. Show the files to be committed (`git status`, diff summary). Include the story and doc updates.
2. Stage only those files, by explicit path. Never `git add -A` with unrelated changes present.
3. Commit as `type(scope): summary [GAME-###]`, for example `feat(inventory): add item equip flow [GAME-014]`. Types: feat, fix, refactor, docs, chore, test.
4. Push to the current branch's upstream (today `game-rbx/master`). If the branch or remote isn't the intended one, ask first.
5. Verify with `git status` and `git log -1`, and confirm the local and remote heads match.
6. Then move the story to `stories/completed/`, set it to Done, and update BACKLOG.md. Include that move in the same commit if it's done before committing, or ask before making a follow-up commit.
7. Report the commit hash, branch, and push result. If the push fails, report the failure. The story isn't Done.

Never force-push, rewrite pushed history, delete branches, or discard uncommitted work without explicit permission. Respect branch protection and PR rules if any are added.

## 8. Documentation upkeep

| Change | Update |
|---|---|
| New/changed mechanic | [GAME_DESIGN.md](GAME_DESIGN.md) |
| New/changed system, remote, DataStore | [ARCHITECTURE.md](ARCHITECTURE.md) + [SYSTEMS.md](SYSTEMS.md) |
| Significant technical choice | [DECISIONS.md](DECISIONS.md) |
| Priorities/milestones (user-confirmed) | [ROADMAP.md](ROADMAP.md) |
| Story progress | story file + [BACKLOG.md](../stories/BACKLOG.md) |
| Process change | this file |

Edit only the affected sections. Keep AGENTS.md and CLAUDE.md stable and short; they load into every session.
