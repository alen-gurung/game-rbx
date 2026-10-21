# GAME-### — Title

| Field | Value |
|---|---|
| Status | Proposed / Ready / In Progress / In Review / Awaiting Playtest / Done / Blocked |
| Priority | High / Medium / Low |
| Points | 1 / 2 / 3 / 5 / 8 / 13 |
| Epic | — |
| Dependencies | GAME-### / D-### / none |

## User story
As a [type of player], I want [functionality], so that [benefit].
_Technical stories: "To [enable X], the [system] needs [change], so that [outcome]."_

## Context
- **Problem:**
- **Intended player experience:**
- **Design decisions:** (links to GAME_DESIGN.md / DECISIONS.md)
- **References:** (`references/...` folders and what to take from them)
- **Existing systems affected:** (from SYSTEMS.md)

## Scope
- **Included:**
- **Excluded:**
- **Assumptions:**
- **Deliverables:**

## Acceptance criteria
- [ ] AC1 — expected behaviour (observable, testable)
- [ ] AC2 — edge case
- [ ] AC3 — security: server validates …; client cannot …
- [ ] AC4 — failure handling: when … fails, …
- [ ] AC5 — multiplayer: with 2+ players, …
- [ ] AC6 — UI/visual: … (desktop / mobile / controller as applicable)

## Implementation considerations
- **Likely files:**
- **Server responsibilities:**
- **Client responsibilities:**
- **Remotes:** (name, direction, payload, validation)
- **Persistence:** (none / DataStore changes and migration)
- **Do not change:**
- **Risks:**

## Testing and verification
- **Static:** `rojo build -o <temp-dir>/check.rbxlx`
- **Automated:** (if available)
- **Studio playtest:** numbered steps → expected results
- **Multiplayer:** (Clients and Servers, N players), if needed
- **Regression:**

## Definition of Done
- [ ] Acceptance criteria met, and the review against AGENTS.md rules passed
- [ ] Validation run; unverified items disclosed
- [ ] User playtested and explicitly approved
- [ ] Docs updated (SYSTEMS / ARCHITECTURE / GAME_DESIGN / DECISIONS as relevant)
- [ ] Committed `type(scope): summary [GAME-###]` and pushed; push verified
- [ ] Story moved to `stories/completed/`, BACKLOG updated

## Notes / log
_Brief dated entries: decisions made during implementation, review rounds, playtest results._
