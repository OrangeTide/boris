# TODO

Prioritized by: bugs first, then missing functionality,
testing, caching, and longer-term features.


## P1 -- testing

 * add unit tests for room and character load/save round-trips
   through muddb.


## P2 -- longer term

 * redo the version number policy in boris. Remove per-file version numbers, except in boris.c
   A global version number is tracked in boris.h (BORIS_VERSION_MAJ/MIN/PAT,
   currently 0.7.0). 21 source files still have per-file @version headers
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

 * web client is proof-of-concept. websocket transport works
   but no real game UI or interaction logic.

 * create a docs/ directory for quarterly mud reports.

 * consolidate text file caching. help.c already has a complete
   caching system (string-keyed hash table, SIGHUP invalidation
   via help_cache_invalidate). welcome.txt is loaded via
   do_config_msgfile() with a hardcoded fallback. the remaining
   work is wiring welcome.txt and other data/text consumers to
   use the same cache/invalidation pattern as help.c.
