---
title: Re-vendor smolvfs (v0.2.0 -> v0.5.1)
status: done
gitlab-sync: OrangeTide/boris#111
---

smolvfs is vendored at v0.2.0 (2026-07-15), recorded in
src/thirdparty/smolvfs/UPSTREAM. Upstream has since released v0.2.1
through v0.5.0. Re-vendor to pick up the CAS improvements and fixes.

Scope note: smolvfs/CAS is no longer a live backend (see
[[obj-cache-cas]]); it now backs only the `muddb-tool to-cas` snapshot/
export path. So this re-vendor serves the export/backup format, and the
v0.3.0 UTF-8 / validate-on-write boundary needs checking only against the
to-cas writer, not a live object store. Lower priority accordingly.

## What newer versions bring

From the commits v0.2.0..v0.5.0 (github.com/OrangeTide/smolvfs):

- v0.5.0: online loose-object reclaim and compacting garbage collection.
- v0.4.1: fsync the object directory after a loose-object rename
  (durability across crashes).
- v0.4.0: signed refs (version records, chain verification, key storage).
- v0.3.0: validate-on-write trust boundary; htree lookup-probe bounded
  against malformed objects; htree verified by re-deriving its bytes;
  directory canonicalization hardening.
- v0.2.1: musl build fix (realpath via _DEFAULT_SOURCE).

## Caution: incompatible changes

- v0.3.0 makes UTF-8 entry names a requirement (flagged upstream as an
  incompatible change) and adds a validate-on-write trust boundary. The
  obj_cache_cas bridge in boris builds tree paths like "objs/chars/1";
  confirm those keys still pass the stricter write-side validation, and
  check the smoke `to-cas` import path against the new boundary.
- Re-vet which files boris actually vendors (currently only the CAS
  modules, per UPSTREAM) and keep the same subset.

## Not a fix for the room-entry bug

This does not resolve [[cas-room-entry-display]]. That bug is a
read-after-write miss in boris's obj_cache_cas (a freshly created object
is absent from both the pending buffer and the committed ref), and none
of the v0.3.0..v0.5.0 changes is an in-process fresh-write-not-found fix.
Re-vendoring has its own value, but it is a separate task.

## Done

Re-vendored at v0.5.1 (2026-10-05).

- [x] Pulled v0.5.1's CAS modules into src/thirdparty/smolvfs and updated
      UPSTREAM. The subset gained one file: cas-gc.c. In v0.2.0
      `cas_tree_gc` lived in cas-tree.c; v0.5.0 moved it (and the new
      `cas_tree_gc_pack`) into cas-gc.c, and boris calls `cas_tree_gc`, so
      cas-gc.c is now vendored and added to module.mk's smolvfs_SRCS.
- [x] Reconciled API against obj_cache_cas.c and the to-cas path. No
      source changes needed; the only break was the moved `cas_tree_gc`
      symbol, fixed by vendoring cas-gc.c.
- [x] Verified the UTF-8 / validate-on-write boundary accepts boris's
      keys: the to-cas round-trip commits the `world` ref through
      cas_tree_store without rejection.
- [x] `make check` passes (1354 tests, 40 suites, including
      test_obj_cache_cas / test_cas / test_cas_tree). A `muddb-tool
      import` + `to-cas zone` round-trip on sample/ writes the depot and
      commits cleanly.
- [x] Licensing: the vendored .c/.h already carry the upstream
      BSD-2-Clause-Patent OR MIT dual-license header (upstream author is
      the project owner). cas-gc.c ships with no header upstream and was
      left as-is; no notices were added or altered.
