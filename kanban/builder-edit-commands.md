---
title: Builder Edit Commands (@create/@link/@set/@destroy)
status: backlog
gitlab-sync: OrangeTide/boris#68
---

The `@`-command building layer that the menu OLC later calls into. Useful
on its own for power users and for testing. Complements `builder-commands`
(#6, `dig`/`return`). All writes go through `builder_save()`. See
`doc/plan.md` Phase 1.

- [ ] `@create` -- item/NPC from template
- [ ] `@link` / `@unlink` -- add/remove exits, both directions
- [ ] `@set <prop> <value>` -- `B`-flag guarded property edit
- [ ] `@destroy` -- remove an object with confirmation
- [ ] wire all to `builder_save()` (flag check + validation + creator
      stamping)
- [ ] command tests exercising each verb against a scratch zone
