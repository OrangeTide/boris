---
title: obj_cache_cas review follow-ups
status: done
gitlab-sync:
---

Remaining findings from the code review of the CAS backend work
(fd419bd..ec7c61f). The two code defects found, a realloc leak and
missing save-key validation, were fixed in 7ad96e9. What is left is
small hardening and tooling polish.

## Tasks

- [x] boot-time sanity check for database.cas.commit_seconds: warn
      when 0 (commits then happen only at clean shutdown, so a crash
      loses everything since boot) or clamp to a minimum; also guard
      the (int) millisecond conversion in boris.c, which goes
      negative above ~2.1M seconds
      -- warns on 0; values over INT_MAX/1000 seconds are clamped
      (written back to mud_config so the re-arming timer sees the
      clamped value too)
- [x] muddb-tool to-cas: report when more than 15 domains are given
      instead of silently dropping the extras (static given[16])
      -- went further: extracted a to_cas_one helper and iterate argv
      directly, so the static array and the cap are gone entirely
- [x] test_smoke.sh: capture muddb-tool to-cas output and show it on
      failure instead of discarding stderr

## Notes for future cards (not tasks here)

- Delete parity: struct obj_cache_ops has no delete operation, so
  neither backend deletes through the cache and parity holds. If
  delete is ever added to the ops, the CAS commit rebuild needs
  tombstone entries.
- Thread safety: the bridge's pending list, GC counters, and the
  static globals in obj_store.c are unsynchronized, and commit's
  read-rebuild-commit sequence assumes no concurrent writer on the
  ref. The multithreading work must add a lock around save/commit.
- Cosmetic: dir_set stamps time(NULL) per entry, so entries within
  one commit get slightly different mtimes.
