---
title: obj_cache_cas cross-domain %parent parity
status: done
gitlab-sync:
---

Bring cross-domain %parent resolution to the CAS backend, matching
obj_cache_muddb_link_parent. Promotion condition 4 from the
obj-cache-cas card.

## Design note

The muddb bridge treats any %parent containing a slash as a domain
reference and errors if the domain is not linked. The CAS backend
cannot copy that rule: its same-domain keys legitimately contain
slashes ("rooms/church", "programs/anim/fountain"). CAS semantics:
if the first path component of %parent matches a linked domain, the
lookup dispatches to that sibling cache with the remainder as the
id; otherwise the whole value is an id in the same cache (the
walker's NULL-return contract). Consequence: a linked domain name
shadows same-domain keys under that prefix, so do not link a domain
whose name collides with a top-level key component (users/objs/chars
vs rooms/programs today: no collision).

## Tasks

- [x] obj_cache_cas_link_parent(c, domain, parent_cache), links
      freed in obj_cache_cas_free
- [x] resolve_parent_cache op: linked prefix -> sibling cache,
      otherwise same-cache id (slashes allowed)
- [x] unit tests: cross-domain chain resolves via
      obj_cache_prop_resolve, slashed same-domain %parent still
      works, tombstones respected across the boundary (58 checks,
      valgrind clean)
