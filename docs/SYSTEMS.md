# Systems Index

Navigation index: find a system's source files here, then read only those. Add a row when a system is created and update its status when it changes.

Status values: Template · Planned · In Progress · Implemented · Deprecated

| System | Source paths | Runs on | Depends on | Story | Status | Notes |
|---|---|---|---|---|---|---|
| Server entry | `src/server/init.server.luau` | Server | none | none | Template | Prints a hello message only |
| Client entry | `src/client/init.client.luau` | Client | none | none | Template | Prints a hello message only |
| Hello module | `src/shared/Hello.luau` | Shared | none | none | Template | Not required anywhere; safe to remove when real code arrives |
| Baseplate / Lighting | `default.project.json` | Workspace | none | none | Template | Defined inline in the Rojo project |

## Remotes
None yet. Format: `Name | Direction | Payload | Server validation | Handler path`.

## DataStores
None yet. Format: `Store name | Key format | Schema version | Owner module`.
