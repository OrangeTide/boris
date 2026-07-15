---
title: obj_cache_cas config-gated routing and import
status: active
gitlab-sync:
---

Config-gated backend selection for the object store plus a
muddb -> CAS import path. Promotion condition 5, the last one, from
the obj-cache-cas card.

## Scope

Backend selection applies to the global object store (the objs
domain served by obj_store.c). Users, characters, and invites call
muddb directly and stay on LMDB regardless of the setting; moving
them is a separate future card (it needs iteration support in the
CAS shim, among other things). The LMDB database opens either way.

## Design

- boris.cfg keys: database.backend (muddb | cas, default muddb),
  database.cas.path (default data/casdb), database.cas.ref (default
  world), database.cas.retain (keep last N snapshots, 0 = keep all),
  database.cas.commit_seconds (periodic commit interval, default 60).
- obj_initialize_cas(path, ref, cache_size, retain) in obj_store.c
  owns the cas store and tree (htree), applies retention, and
  obj_shutdown handles both backends (flush, commit, free).
- obj_commit(): flush dirty objects and commit the CAS tree; no-op
  on the muddb backend. boris.c arms a re-arming iox timer for it
  when the cas backend is active, since evict-driven saves only
  buffer until a commit.
- muddb-tool to-cas <dbpath> <depot> [ref] [domain ...]: import
  muddb domains into a CAS depot for cutover.

## Tasks

- [ ] mud_config fields, defaults, frees, config_watch entries
- [ ] obj_store.c: obj_initialize_cas, obj_commit, dual shutdown
- [ ] boris.c: backend selection at boot, periodic commit timer
- [ ] muddb-tool to-cas command
- [ ] boris.cfg commented example keys
- [ ] verify: unit tests green, server boots and runs on the cas
      backend against imported real data, clean shutdown commits
