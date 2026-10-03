---
title: CAS backend shows no room on game entry
status: done
gitlab-sync: OrangeTide/boris#92
---

## Resolution

Resolved by removing the live CAS backend. CAS was an opt-in second
object-store backend, never the default and not in use for play. Rather
than carry a second live backend at parity with muddb (which this bug
showed is a recurring cost: obj_move, the containment index, and owner
counts all had to be reimplemented for CAS), CAS was demoted to an offline
snapshot/export format reached through `muddb-tool to-cas`. The live store
is now muddb only, so obj_move's muddb-only path is no longer a defect, and
this failure mode cannot occur. See the decision in [[obj-cache-cas]].

An earlier fix made obj_move backend-agnostic with an in-memory CAS index;
it was reverted when CAS was demoted, since the live CAS path it supported
no longer exists.

## Original diagnosis (kept for the record)

Under the `cas` object store backend, entering the game (menu 'E',
command_start_lineinput in src/cmd/cmd.c) does not display the starting
room. The same path works on the default `muddb` backend.

## Repro (historical; no longer runnable)

The live CAS backend and its smoke path have since been removed, so this
command no longer exists. At the time:

    BORIS_BACKEND=cas ./src/tests/test_smoke.sh

The `enter_game` smoke test fails with "no room description on entry":
after sending 'E' the client never sees the room name ("Tower
Entrance"). On the muddb backend the identical test passes. This is not
caused by the @-command work; it reproduces on a build from before that
work too.

## What is and isn't broken

- The room object itself resolves on CAS. The `at_commands` smoke test,
  running later in the same server, does `@chown rooms/tower-entrance ...`
  and obj_get("rooms/tower-entrance") returns the object, so room_get on
  a known room id is fine under CAS.
- So the failure is in the entry path specifically, not in loading an
  already-committed room.

## Confirmed (logging, 2026-10-02)

Temporary LOG_INFO in command_start_lineinput, driven by a CAS smoke
session, showed:

    INFO:command:ENTRY-DEBUG: char=chars/1 room.current=(null)

room.current reads back NULL immediately after it was set, so room_get is
never called. One line above it, the CAS cache layer logged:

    DEBUG:obj_cache_cas:"objs/chars/1" not found

So the freshly created character object chars/1 cannot be read back on the
CAS backend. The miss is in obj_cache_cas bridge_load
(src/obj/obj_cache_cas.c): the id is found in neither the pending buffer
(pending_find returns NULL) nor the committed ref (walk_path returns
CAS_ENOTFOUND). On muddb (write-through) the same entry succeeds.

The hypothesis is confirmed, and a second trace pinned the actual cause.
The data is not lost in storage, it is never written. The server log
under CAS shows:

    ERROR:obj:obj_move requires the muddb backend

Chain of events:

1. command_start_lineinput sets the new character's location with
   character_attr_set(ch, "room.current", "tower-entrance").
2. character.c special-cases room.current to the %location forward
   pointer and writes it via obj_move(ch->obj_id, "rooms/...")
   (src/character/character.c:126-135).
3. obj_move opens with a hard backend guard
   (src/obj/obj_store.c:287-290): db = store_muddb() returns NULL
   whenever obj_cas_tree is set (the CAS backend), so obj_move logs the
   error above and returns OBJ_ERR.
4. character_attr_set returns 0; %location is never set.
5. At the display step character_attr_get("room.current") ->
   obj_location -> no %location -> NULL -> room_get is never called.

The earlier obj_cache_cas "objs/chars/1 not found" was a red herring: it
is the existence probe inside obj_create, before the object exists.

This is wider than room display. obj_move is the only path that sets
%location and maintains the containment index, so on CAS all containment
silently no-ops: room entry, movement, pick-up, and obj_contents_*
traversal. obj_move depends on muddb transactions (muddb_txn_begin/put/
index_add/commit) and the muddb secondary-index facility, which the CAS
bridge does not provide. Re-vendoring smolvfs cannot fix this; the gap is
obj_move being muddb-only.

## smolvfs re-vendor assessment

smolvfs is vendored at v0.2.0 (2026-07-15, src/thirdparty/smolvfs/UPSTREAM).
Upstream is now at v0.5.0. Reviewing the commits v0.2.0..v0.5.0, the
CAS-relevant changes are: an htree lookup-probe bound against malformed
objects (78916aae), htree re-derivation on verify (be57a09c), fsync of
the object directory after a loose-object rename (18bccd18), online
loose-object reclaim and compacting GC (v0.5.0), signed refs (v0.4.0),
and musl/analyzer build fixes. None of these is an in-process
read-after-write / fresh-write-not-found fix, which is this bug. v0.3.0
also introduces an incompatible UTF-8 entry-name rule and a
validate-on-write trust boundary that boris would have to adapt to.

Conclusion: re-vendoring has independent value (reclaim/compaction,
hardening) but is unlikely to fix this bug, and it is a breaking change.
Track it as its own task rather than as the fix here.

## Leading hypothesis (original)

command_start_lineinput creates the session character with
character_new() (obj_create + obj_save), then
character_attr_set(ch, "room.current", newuser_room), which writes the
%location forward pointer via obj_move, then reads it straight back with
character_attr_get(ch, "room.current") to pick the room to show. The
show_room block is skipped when that read returns NULL.

The likely cause is a read-after-write visibility gap on the CAS backend
for a just-created / just-moved object: the %location write is not
visible to the immediately following read, so room.current comes back
NULL and the room is never shown. CAS commits are deferred
(database.cas.commit_seconds), which is consistent with freshly written
state not being readable yet. muddb is write-through, which is why it
does not show the bug.

## To do

- [x] Confirm the hypothesis: logging showed character_attr_get returns
      NULL because obj_cache_cas cannot find the just-created chars/1 (see
      "Confirmed" above).
- [x] Pin down where chars/1 is lost: it is not lost in storage, obj_move
      refuses to run on CAS (see "Confirmed" above), so %location is never
      written.
- [x] Decide the fix. Decided to demote CAS to an offline snapshot/export
      format and keep the live store muddb-only, which removes the defect
      class entirely (see Resolution and [[obj-cache-cas]]).

Related: [[obj-cache-cas]], [[smolvfs-revendor]],
[[char-account-persistence]].
