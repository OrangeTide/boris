---
title: Re-vendor smolvfs (v0.2.0 -> v0.5.0)
status: backlog
gitlab-sync:
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

## To do

- [ ] Pull the chosen tag's CAS modules into src/thirdparty/smolvfs,
      keeping the current file subset, and update UPSTREAM.
- [ ] Reconcile any API changes against obj_cache_cas.c and muddb-tool's
      to-cas path.
- [ ] Verify the UTF-8 / validate-on-write boundary accepts boris's keys.
- [ ] Run `make check` (covers test_obj_cache_cas / test_cas / test_cas_tree)
      and a `muddb-tool to-cas` round-trip on the sample world.
- [ ] Relicense the vendored files to boris' license per project policy
      (authorized for OrangeTide sources).
