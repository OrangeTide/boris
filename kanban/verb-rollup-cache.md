---
title: Containment Rollup Cache (sys_rollup)
status: backlog
gitlab-sync: OrangeTide/boris#101
---

Captured while implementing [[verb-creation-quota]]. Per-owner counts turned out
to need only a flat secondary index (owner id -> objects), counted with
mdb_cursor_count. A hierarchical, partial-sum structure is the wrong tool for
that, but it is the right tool for a different, still-wanted feature: aggregate
rollups over the containment tree.

The idea (the old sys_rollup host call from doc/mud-vm-design.md, recorded as not
shipped): maintain a cached aggregate per container, for example the total count
or total weight of everything transitively contained, updated incrementally up
the %location parent chain as objects move or change, so a query is O(depth)
rather than a full subtree walk. This is a Fenwick/partial-sum style rollup
riding on the existing containment index, not a flat count.

- [ ] decide which aggregates to roll up (count, weight, a named numeric field)
- [ ] maintain the cached rollup incrementally on obj_move and on the relevant
      property writes, up the containment chain
- [ ] expose it to guests as sys_rollup (host call + SDK stub/import/vmsys.h)
- [ ] bound the chain walk (reuse OBJ_CONTAIN_MAX_DEPTH) and handle cycles

Deferred: only build it when a concrete need appears (e.g. encumbrance or a
container capacity rule). Not required by the object model as it stands.
