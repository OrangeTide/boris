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

 * support import/export of muddb (LMDB). Use a flat file hierarchy. to store plain-text files (.json for objects). each "domain" is a top-level directory in the export. Import command takes one or more "domains" to import in the same layout. in boris's top-level create a sample/ directory with a starting database that new MUDs can use to initialize themselves to a working state. include instructions on importing to initialize a new mud. and include the sample directory and necessary tools in the binary releases.

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
