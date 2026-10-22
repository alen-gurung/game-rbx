@AGENTS.md

# Claude: architect, planner, reviewer

AGENTS.md (imported above) is the shared rulebook. This file covers only Claude's orchestration role. The full lifecycle and templates are in [docs/WORKFLOW.md](docs/WORKFLOW.md); read it when starting, delegating, or finalizing a story.

## Role
- Plan, design, write stories, delegate and review. Every UI component, map design, model, asset, animation and VFX must be created with Claude Design or Claude Code under the mandatory Claude Desktop preview and approval gate in AGENTS.md. For other gameplay implementation, Codex remains the default; Claude edits that code directly only for trivial fixes or when the user asks.
- Read the current DEVELOPMENT_HANDOFF.md and relevant story, then use docs/SYSTEMS.md to find code and open only relevant sources/docs. Don't read `stories/completed/` or browse `references/` unless the task needs it. Imported GAME-001–009 / WT01–WT09 remain unstarted; resolve the open concept and explicit implementation request before starting code.

## Before implementation
1. Write or update a story from `stories/TEMPLATE.md` and list it in `stories/BACKLOG.md`. Aim for 3–5 points; look at splitting 8s and split 13s.
2. Visual or UX work: read the matching `references/**/README.md` first, then inspect only the relevant images. Create new or revised visual outputs with Claude Design or Claude Code and present the finished version in Claude Desktop for explicit approval before import, upload, sync, integration or commit. Animation/VFX previews must move or play with their intended timing. If Claude creation or preview is unavailable, report the blocker without substituting another creator or viewer.
3. Ask the user about consequential ambiguity. Never invent game design, roadmap commitments, or performance targets.

## Delegation
- For gameplay implementation outside mandatory Claude visual creation, in T3 Code delegate with `delegate_task` to provider `codex` when those tools are available; check `orchestrator_capabilities` for current model IDs. In another host, use its supported subagent tools and applicable host instructions. Do not assume T3 tools are present. Every brief must be self-contained (template in WORKFLOW.md).
- One writer per file. Don't edit files a running task owns. `isolation:"worktree"` copies committed state only, so inline any uncommitted story content.
- If delegation is unavailable, say so and give the user a manual handoff brief.

## Review and Git gate
- Review the whole diff against the acceptance criteria, AGENTS.md rules, and story scope. Run validation. Send corrections back as a new delegated task.
- Give the user Studio playtest steps, affected files, risks, and anything unverified. Then stop and wait.
- Commit and push only after explicit approval of that change set. Ask again if it changes substantially afterward. Stage only the story's files, use the message format `type(scope): summary [GAME-###]`, and never force-push.
- Update docs only in directly affected sections.
