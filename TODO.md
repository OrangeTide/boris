# TODO

Prioritized by: bugs first, then missing functionality,
testing, caching, and longer-term features.

## P1 -- testing

  * add unit tests for room and character load/save round-trips
    through muddb.


## P1 -- priority queue / timers

  * use pq.h for all priority queues.

  * add timer-wheel semantics (realtime clock + run dispatcher)
    to pq.h. a thin wrapper -- entries hold {deadline, func, args},
    PQ_KEY is deadline, and the run loop peeks top() and dequeues
    while deadline <= now.


## P1 -- RPG next phases

  Phases 1-3 landed (dice, skills, positions, scene tags, stress,
  harm, conditions, resist). Remaining per doc/rpg-system.md:

  * Phase 4: teamwork (assist, protect, group action).
  * Phase 5: fortune rolls and clocks (progress/danger timers).
  * Phase 6: server-side GM actions -- spending stress to alter
    position/effect, offering devil's bargains.
  * Phase 7: playbooks and starting budgets; ancestry modifiers.

## P1 -- in-flight utilities

  * src/util/variables.c :: expand_string() done -- named vars via
    caller-supplied lookup, $0-$9, $#, $*/$@, $?, $$, quoting, and
    unit tests (bin/test_variables). $(cmd) is out of scope (emits
    literal). Still to do: wire into the command interpreter so
    aliases and room/character descriptions run through it.

  * wordwrap utility landed; audit callers of printf/telnetclient
    output that should flow through it (help text, room desc,
    channel messages).


### P2 -- longer term

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

  * Feature Request : virtual whiteboard/blackboard. 
    - multiple clients editing the same whiteboard
    - multiple whiteboard windows open. with global copy/cut/paste buffer between them.
    - support paste of images into a whiteboard object (resizable image object)
    - local undo/redo (limited history, perhaps 10 operations)
    - shapes, drawing, selection. 
    - export as .json or image to VFS or download.
    - share controls palette with map. try to leverage and share as much as possible and keep the same key bindings.
    - map window supports an export-to-whiteboard option. basically save a .json for the map layout and open in a whiteboard.

  * Feature Request : variables and command-line expansion in COMMAND.COM
  * Feature Request : secret "sh" command. gives a full unix-like shell. (see jsh.c)
