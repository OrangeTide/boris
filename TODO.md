# TODO

Prioritized by: bugs first, then missing functionality,
testing, caching, and longer-term features.


## P1 -- missing functionality

 * telnetclient.c: client disconnect does not notify other users
   or clean up channel membership properly (lines 235, 238).

 * telnetclient.c: IAC escape not implemented in output path
   (line 298). will corrupt binary data sent to telnet clients.

 * crypt/sha1crypt.c: random salt generation is weak (line 37).
   should use /dev/urandom or getrandom().

 * task/command.c: strtoul calls with no error checking in
   roomget/char debug commands (lines 187, 215).

## P2 -- testing

 * add unit tests for room and character load/save round-trips
   through muddb.

 * stackvm/kernel/prioq_test.c exists but is incomplete.

 * valgrind (make smoke-valgrind) reports 8 definitely-lost blocks:
   - channel.c:226 (channel_public_add) -- 7 strdup leaks, one per
     default channel. channels_done() does not free the public
     channel list.
   - form.c:372 (form_createaccount_start) -- 40-byte form state
     allocation not freed when account creation completes.
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
   A global version number is tracked in boris.c (and extracted in  Makefile). 
   Use semver for our version numbers. We will start at 0.7.1 
   Any major merge request should increment at least the patch number. The maintainer will handle trivial conflicts, but the general policy will be to combine multiple MRs that were in-flight into the same version number. 
   For example, if 3 MRs showed up tomorrow. I would bump to version 0.7.2 and not 0.7.4

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

 * consolidate text file caching in help.c with other areas that reach into
   data/text for settings (like welcome.txt). A textfile API that can refresh
   cache on SIGHUP so that on-disk files can be edited and updated in the mud
   would be good. The way the welcome message works would have to be re-wired to
   instead reference the file path. we could eliminate the hardcoded default value
   since we will provide data/text as part of the sample data in the distribution.
