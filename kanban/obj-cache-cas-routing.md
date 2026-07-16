---
title: obj_cache_cas config-gated routing and import
status: done
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

- [x] mud_config fields, defaults, frees, config_watch entries
- [x] obj_store.c: obj_initialize_cas, obj_commit, dual shutdown
- [x] boris.c: backend selection at boot, periodic commit timer
- [x] muddb-tool to-cas command
- [x] boris.cfg commented example keys
- [x] verify: unit tests green; make smoke and make smoke-cas both
      pass 6/6 with the sandbox active

## Finding: landlock must allowlist the depot

First cas smoke run failed with rooms silently missing: landlock
allowlisted data/muddb but not the depot, and a depot the server
cannot read looks identical to an empty one (ref open fails ->
treated as no commit yet). Fixed by adding a landlock rule for
database.cas.path when the cas backend is selected, including
MAKE_DIR (fanout dirs), REMOVE_FILE (GC), and REFER on ABI 2+ (the
mkstemp + cross-directory rename write path). seccomp needed no
change; its deny-list does not cover any syscall CAS uses. The
smoke harness gained a BORIS_BACKEND=cas mode (make smoke-cas) so
both backends stay covered.
