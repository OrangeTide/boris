---
title: Verb Object-Creation Quota
status: done
gitlab-sync:
---

From the L7 authority review of the [[vm-object-model]] card. A verb can call
sys_create in a loop, and each object is persisted (obj_save) and survives the
task. The per-task instruction cap bounds a single invocation, but there is no
per-task or per-owner limit on how many objects a verb may create, so a runaway
or hostile verb can persist many objects owned by its effective owner and spam
the object store.

- [x] cap the number of objects a single task may create. Done. A counter in
      verb_ctx; sys_create refuses with VM_ERR_NOSPACE past the cap.
- [x] consider a per-owner limit as well. Done. Added an obj-layer owner index
      (owner id -> owned object ids, a muddb secondary index like the contents
      index), so obj_owner_count is a cheap per-owner tally; sys_create refuses
      past the per-owner cap. obj_set_owner maintains the index; obj_destroy
      clears it.
- [x] see hc_create in src/verb/verb_dispatch.c

Both limits are operator-tunable (vm.create_max, vm.owned_max; 0 = unlimited,
defaults 64 and 1024) and apply only to tasks that act as an owner; system and
agent tasks are exempt. The per-owner index is muddb-only and counts objects
whose owner was set through obj_set_owner. A hierarchical rollup over the
containment tree (a different aggregation, the old sys_rollup idea) is captured
separately in [[verb-rollup-cache]].
