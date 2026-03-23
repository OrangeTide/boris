# TODO

Prioritized by: bugs first, then missing functionality,
testing, caching, and longer-term features.


## P1 -- missing functionality (done)

 * (done) telnetclient.c: disconnect now broadcasts departure
   message to all joined channels before cleanup.

 * (done) telnetclient.c: write_escaped() now doubles IAC (0xFF)
   bytes in the output path.

 * (done) crypt/sha1crypt.c: salt generation uses getrandom()
   with /dev/urandom fallback. full byte range, not just printable
   ASCII.

 * (done) task/command.c: strtoul calls now validate with endptr
   and report invalid character IDs to the user.

## P2 -- testing

 * add unit tests for room and character load/save round-trips
   through muddb.

 * stackvm/kernel/prioq_test.c exists but is incomplete.

 * valgrind (make smoke-valgrind) reports definitely-lost blocks:
   - (done) channel.c: channel_public_close() now frees cp->name
     before freeing the struct.
   - (done) form.c:372 (form_createaccount_start) -- form_state_free()
     was not freeing the form_state struct itself. now calls free(fs).
   26 still-reachable blocks are global state not freed at shutdown
   (menus, user cache, mth, base64 table). not urgent but worth
   adding cleanup routines for cleaner valgrind runs.


## P3 -- caching (done)

   Room and character caches use an open-addressing hash table
   (hashtable.c) for O(1) lookup by ID, with an LRU list for
   unreferenced objects. Configurable via cache.room.size and
   cache.character.size in boris.cfg (default 128). Help topics
   are cached in a string-keyed hash table on first access,
   invalidated by SIGHUP. The hash table is the single point
   of locking when multithreading is added later.

   character_shutdown now properly drains its cache and saves
   dirty objects (was a no-op before).

   Covered by test_hashtable (58 tests).


## P4 -- longer term

 * redo the version number policy in boris. Remove per-file version numbers, except in boris.c
   A global version number is tracked in boris.h (BORIS_VERSION_MAJ/MIN/PAT,
   currently 0.7.0). ~30 source files still have per-file version headers
   that need removal. Use semver for our version numbers. We will start
   at 0.7.1. Any major merge request should increment at least the patch
   number. The maintainer will handle trivial conflicts, but the general
   policy will be to combine multiple MRs that were in-flight into the
   same version number. For example, if 3 MRs showed up tomorrow. I would
   bump to version 0.7.2 and not 0.7.4

 * object versioning system for the online object editor.
   wikipedia-like history where each save creates a new version.
   RCS-style storage or LMDB version chains. primarily for class
   templates, not frequently-written live objects.

 * multithreading for complex tick updates, NPCs, and room
   programs. muddb already has a write mutex. room/character
   caches would need thread-safe access patterns.

 * stackvm is early/incomplete (61 TODOs, abort() calls for
   unimplemented features). needs syscall infrastructure, stack
   bounds checking, proper error handling, task scheduling.

 * web client is proof-of-concept. websocket transport works
   but no real game UI or interaction logic.

 * create a docs/ directory for quarterly mud reports.

 * consolidate text file caching with other areas that reach into
   data/text for settings (like welcome.txt). help.c already has a
   complete caching system (string-keyed hash table, SIGHUP
   invalidation via help_cache_invalidate). the remaining work is
   wiring welcome.txt and other data/text consumers to use the same
   pattern. the way the welcome message works would have to be
   re-wired to instead reference the file path. we could eliminate
   the hardcoded default value since we will provide data/text as
   part of the sample data in the distribution.
