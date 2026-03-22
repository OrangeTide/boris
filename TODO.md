# TODO

Prioritized by: bugs first, then missing functionality,
testing, caching, and longer-term features.


## P1 -- missing functionality

 * telnetclient.c: client disconnect does not notify other users
   or clean up channel membership properly (lines 210, 231, 234).

 * telnetclient.c: IAC escape not implemented in output path
   (line 294). will corrupt binary data sent to telnet clients.

 * crypt/sha1crypt.c: random salt generation is weak (line 37).
   should use /dev/urandom or getrandom().

 * task/command.c: multiple strtoul calls with no error checking
   (lines 130, 190, 218).


## P2 -- testing

 * add unit tests for room and character load/save round-trips
   through muddb.

 * stackvm/kernel/prioq_test.c exists but is incomplete.


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
