---
title: Builder Edit Commands (@create/@link/@set/@destroy)
status: done
gitlab-sync: OrangeTide/boris#68
---

The `@`-command building layer that the menu OLC later calls into. Useful
on its own for power users and for testing. Complements `builder-commands`
(#6, `@dig`/`return`). All writes go through `builder_save()`. See
`doc/plan.md` Phase 1. Implemented in `src/cmd/builder_edit.c`; verified
in-game.

- [x] `@create <item|npc|creature> <id> [name]` -- new object in the
      current zone (`%kind`, name, placeholder desc)
- [x] `@link` / `@unlink` -- add/remove exits, both directions (shared
      `cmd_dir_resolve` opposite map)
- [x] `@set <prop> <value>` -- `B`-flag guarded property edit on the
      current room; `%`-prefixed props refused
- [x] `@destroy <id> [confirm]` -- delete via `obj_delete` with a confirm
      step; refuses zones and your own room
- [x] wire all to `builder_save()` via `builder_zone_ops` (flag check +
      zone allow-list + creator stamping); `@destroy` checks
      `zone_edit_allowed`
- [x] verified in-game against `zone/world`
- [ ] LATER: `@destroy` on the CAS backend (needs cas-tree key removal);
      `@create` template seeding (`%parent` per kind); dangling-exit
      cleanup on destroy
