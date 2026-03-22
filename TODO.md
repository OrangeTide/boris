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


## P3 -- caching

   Room and character caches use a linked list with refcount.
   Objects are freed immediately at refcount 0. All three items
   below should be designed with eventual multithreading in mind
   (shared caches will need a mutex or rwlock).

 * room.c / character.c: hold objects in cache after refcount
   hits 0 instead of freeing immediately. use an LRU eviction
   policy with a configurable cap. avoids repeated muddb reads
   for frequently accessed rooms/characters.

 * room.c / character.c: replace linear list scan in _get()
   with a hash table keyed by id. O(1) lookup instead of O(n).
   the hash table becomes the single point of locking when
   multithreaded.

 * help.c: loads from disk on every help_show() call. cache
   file contents in a hash table on first access (topics are
   small, few dozen files). invalidate on SIGHUP or similar
   for live editing.


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
