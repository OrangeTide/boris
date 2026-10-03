---
title: Object Model, Verb Resolution, and Object-Access Host Calls
status: done
gitlab-sync:
---

Third slice split out of the old verb-agent-model card, and the largest. The
game-model foundations the verb layer needs, none of which exist yet, plus the
object-access host calls and the authority bridge that ride on them. Builds on
[[vm-oneshot-dispatch]] and [[vm-agent-events]]. See doc/mud-vm-design.md
"Object Association and Dispatch", "Host-Call Set", and "Capability and Security
Model".

## Why this is its own card

The object-store map found that boris has property storage and a `%parent`
prototype chain, but no containment/location model (a character's location is a
`room.current` string; rooms hold no contents list), no name-to-object
resolution, no owner field on objects, no persistent create-into-cache path
(`entity_create` is stubbed because the cache has no insert primitive), and
`acs_check` has no callers. There are also two parallel worlds: the OBJ/cache
prototype system (rooms, programs, entities, string-keyed) and the legacy
`struct character` system (players, unsigned-id keyed, stored directly through
muddb, not in the cache). Verb resolution and most object-access host calls
depend on building these first.

## Decisions

These were settled in the design interview and drive the plan below.

- **Full unification.** Characters become OBJs in the cache (`chars/<id>`,
  `%parent` = `templates/pc`). The numeric id stays the identity, so the char
  id, the VM `authority`, and `%owner` are one id space. `struct character`
  survives only as a thin adapter over the obj cache (see L3), so the session
  and command sites do not churn; the storage and cache form is the OBJ.
- **Containment.** An object carries `%location` (its container's key) as a
  cheap forward pointer. The reverse view (`container -> members`) is a
  **persisted secondary index** in the store, not a volatile in-memory table.
  Reverse and secondary queries in general (occupancy, ownership, parentage)
  are numerous and can cover a large fraction of the world, so a rebuilt-on-boot
  in-memory index would cost too much RAM and a full-DB boot scan. A persisted
  index avoids both: it is maintained incrementally on the write path, never
  scanned at boot, resident only to the OS page cache's working set, and read by
  a cursor over just the matching entries. See the index-architecture note below.
- **Handles.** A per-task, host-owned handle table addresses objects in the
  host calls. Adding an entry pins the object (`obj_get`); removing it releases
  (`obj_release`). Close removes one entry, task exit clears the table, and both
  run the same path, so an object cannot vanish mid-use or leak past exit. This
  is the ARC model over the obj cache. The table lives in the verb layer so
  `src/vm` stays game-agnostic.
- **Verbs.** A single packed property `verb.<word>` on an object holds the
  program reference plus its typed argument spec (the program expects a certain
  spec, so they travel together). Resolution follows the prototype OO walk:
  actor, then actor's location, then the root object, child-first along
  `%parent`, reusing `obj_cache_prop_resolve`.
- **Create path.** New `obj_create`/`obj_destroy` cache primitives, write-through
  like `obj_put`; `entity_create` and `sys_create` build on them.
- **Authority.** `authority` (uint32) is the acting character id. Objects carry
  `%owner` (a char id). An action is allowed if `authority == %owner` or the
  character holds a wizard ACS level. `sys_setpriv` is setuid-style elevation to
  the program owner, denied without the program's elevation bit.

## Assumed details (open to change)

- Characters are keyed `chars/<id>` in the `objs` domain (the unified cache
  namespace). No runtime migration of the legacy bare-key `chars` domain:
  start fresh and seed the id freelist so abandoned ids are not reused. An
  offline `muddb-tool` export of the old records can be offered separately.
- Name matching uses `name.short` plus an `aliases` property.
- The wizard level is an ACS level/flags property on the character OBJ. Today
  ACS lives on `struct user`/the descriptor and `acs_check` has no callers, so
  this move happens in L7, not L3.
- Program elevation is a `%setuid`/owner-mode property on the program object.

## Index architecture

Reverse and secondary queries (room occupancy, ownership, parentage, verb-bearing
objects) cannot be answered from an object's own record, so they need an index
or a full scan. These indexes will be numerous and can cover a large fraction of
the world, so a volatile in-memory index rebuilt at boot would cost too much RAM
and a full-DB boot scan. Instead, indexes are **persisted in LMDB and read
lazily**:

- Each index is a `DUPSORT` sub-db: one key maps to a sorted set of values. A
  reverse lookup is a cursor walk over one key's values, touching only the
  matching pages, O(matches) not O(world).
- Maintenance is on the write path (move/create/destroy), not the load path, so
  loading an object does no index work.
- No boot scan: the index is already on disk. Memory is bounded by the OS page
  cache's working set; cold index pages are not resident.
- The object keeps `%location` as its forward pointer; the object write and its
  index deltas go in one LMDB transaction, so the two cannot diverge.
- This is LMDB-specific. The CAS backend (opt-in) has no ordered range scan and
  would need its own scheme or a volatile fallback.

Containment is the first user (`contents` index); ownership (L7) and verbs (L6)
reuse the same facility.

## Plan (layered, one committed layer at a time)

L3 is the risk hotspot (session binding and command rewiring). The codebase
map (see the L3 notes) settled the shape that keeps it safe: `character.c`
becomes a thin adapter over the OBJ cache rather than a deleted struct, so the
~8 command sites and the descriptor field are untouched; account-to-character
persistence is deferred to its own card ([[char-account-persistence]]); and
there is no runtime data migration (start fresh in the new key scheme, seed the
id freelist so ids are not reused).

- [x] **L1 Create primitives.** `obj_cache_create`/`obj_cache_destroy` plus the
      `obj_create`/`obj_destroy` store wrappers; a new optional `del` backend op
      wired for muddb (CAS delete deferred). `entity_create` now builds on the
      cache insert instead of failing. Done.
- [x] **L2 Persisted index facility + containment.** A general secondary-index
      API in the store, with containment as its first user, tested standalone
      over OBJs. It becomes load-bearing at L3 when characters gain a location.
      No command rewiring here: until L3 nothing in the OBJ world has a location
      to index (characters are still legacy `room.current`; no items exist yet).
      Depends on L1. Done.
      - `%location` is a structural field, not a plain prop, so it never
        inherits down the prototype chain (a template must not set an instance's
        location) and is protected from guest writes. It is the cheap forward
        pointer; the reverse view is the index. Written only through `obj_move`.
      - Index facility in `src/database/muddb`: one `DUPSORT` named DB per index
        kind (key -> sorted set of values), with put/del and a cursor over one
        key's values. Index kinds are a small fixed set (~2-3), each its own DB
        named with an `idx.` prefix (e.g. `idx.contents`) to avoid colliding
        with data domains. The owning layer calls `muddb_index_register(db,
        name)` at init so muddb does not hardcode game-model index names and the
        DBI is pre-opened under the write lock. Raise `MUDDB_MAX_DBS`/`maxdbs`
        16 -> 32 for headroom. Plus transactional support (a `MUDDB_TXN` handle)
        to write an object and its index deltas in one LMDB transaction, so
        `%location` and the `contents` index cannot diverge across a crash;
        `muddb_put`/`muddb_del` become thin wrappers over it. LMDB-specific; the
        CAS backend either grows its own scheme or falls back to a volatile
        index (CAS is opt-in).
      - Containment (`src/obj/`): the `contents` index (key = container, values
        = members). `obj_move(member, container)` writes `%location` and the two
        index deltas in one transaction, with a cycle check (refuse moving M
        into its own descendant or itself) and a limbo case (`container` NULL
        clears `%location`). `obj_contents(container)` cursors the index;
        `obj_location(member)` reads `%location`. No permission check here; that
        is the `sys_move` path at L7. No boot scan, no cache-hook rebuild, and
        listings are complete (they include members that are not currently
        loaded).
      - F4 does not apply: the index is maintained on the write path, not by
        cache evict/destroy hooks, so there is no evict-vs-destroy signal to
        distinguish. F2 (obj_cache_destroy drop-before-del ordering) is an
        unrelated obj_cache nit, addressed whenever recycle touches destroy (L5).
- [x] **L3 Character migration and command rewiring.** Characters become OBJs
      in the unified cache, keyed `chars/<id>` in the `objs` domain (the same
      namespace as `rooms/<id>`), with `%parent` = `templates/pc` and
      `%location` in place of `room.current`. `struct character` survives only as
      a thin adapter so the session path and command sites do not churn. Depends
      on L1, L2. Three sub-steps, each its own commit.

      Findings that shaped this (from the codebase map):
      - Characters are a parallel cache today (`struct character` + a private
        `character_ht`/`character_lru`, domain `chars`, bare-numeric keys),
        separate from `obj_store`. On disk they are already an OBJ, so the
        migration collapses the in-memory struct layer onto the obj cache.
      - `room.current` is a string attr read at 8 sites and written at 2
        (`move.c:141`, the newuser seed `cmd.c:243`); it stores a *bare* room id
        and `room_get` prepends `rooms/`. So `%location` holds the full
        `rooms/<id>` id, and the adapter strips `rooms/` on a `room.current`
        read to preserve the bare-id contract the untouched readers rely on.
      - `show_room` never lists occupants (TODO at `show_room.c:209`), so
        occupant listing is net-new, built on the L2 contents index.
      - ACS lives on `struct user`/the descriptor, not the character, and
        `acs_check` is never called yet, so authority stays entirely in L7.
        `owner`/`controllers` ride along as plain props (they already exist as
        char attrs); `%owner` and ACS props are seeded only when L7 needs them.

      - **L3a Character adapter over obj_store.** Done. Rebuild `character.c`
        internals on the obj cache, keeping the public `character.h` API stable.
        `character_new` allocates an id from the freelist and `obj_create`s
        `chars/<id>` with `%parent` = `templates/pc`; `character_get` is
        `obj_get("chars/<id>")`; `character_put` is `obj_release` (the obj cache
        owns dirty tracking and write-through, replacing the private
        ht/LRU and the immediate save). `character_attr_get`/`_set` map to
        `obj_prop_get`/`_set` for every attr except `room.current`, which maps to
        `obj_location`/`obj_move` with the `rooms/` prefix stripped or prepended;
        the adapter caches the stripped string on the handle so the borrowed
        return keeps its lifetime contract. Expose `character_obj_id(ch)` for the
        rewired commands. `character_preflight` seeds the id freelist from the
        `chars/` keys in the `objs` domain and from the legacy `chars` domain
        (so abandoned ids are not reused), loading neither. Seed a minimal
        `templates/pc` prototype at init so later prototype walks (L6) resolve.
      - **L3b Room occupant listing.** Done. `show_room` lists the other
        characters in the room from `obj_contents`, filtering `chars/` members,
        skipping the viewer, and covering occupants that are not loaded. A new
        `obj_key` accessor returns an object's own cache id so `show_room` can
        query the index for the room it was handed with no signature change.
        `look.c` and `move.c` were left unchanged: the L3a adapter already
        routes their `room.current` reads and writes through `obj_location` and
        `obj_move`, so they operate on the new model, and the borrowed location
        pointer is consumed before any later attribute read. Exit lookup and
        `prog:` dispatch are untouched.
      - **L3c Verify the adapter-preserved paths.** Done, no code change needed.
        `telnetclient_room_broadcast`, `roll.c`, and the newuser seed (`cmd.c`)
        all read `room.current` through the adapter and use it synchronously;
        the broadcast reconstructs `rooms/<bare>` exactly as before. Behavior
        notes: setting `room.current` now requires the target room to exist,
        since `obj_move` validates the container (a missing newuser or exit room
        fails the move cleanly and logs, rather than storing a dangling id), and
        `room.home` is now a plain object property with no containment meaning.
      - **Known limitation (CAS backend).** Characters have no working location
        on the CAS backend: `obj_move` is muddb-only, so the newuser seed and
        movement fail there. `do_move` now checks the location-write result and
        refuses the move instead of showing the destination as if it succeeded
        (L3 review F1). boris defaults to muddb, so normal runs are unaffected;
        a CAS-backed world needs the CAS containment scheme from the L2 note
        before characters can move.
- [x] **L4 Name-to-object resolution.** Done. A new `src/resolve` module:
      `resolve_name(actor_id, name, players_only, out, out_sz)` searches the
      special names `me`/`self`/`here`, then the actor's inventory and location
      (its contents and the location object). An exact `name.short` or whole
      alias token wins outright; only when nothing matches exactly does it fall
      back to prefix matching (whole or per-word of `name.short`, or an alias
      token). Scope comes from the containment index. Returns none / one /
      ambiguous. It is independent of the character layer
      and muddb-only (scope comes from the index). Not yet wired into dispatch:
      the `VTOK_OBJ`/`VTOK_PLAYER` segments and `sys_objfind` call it in L5/L6
      once the handle table exists. Depends on L2, L3.
- [x] **L5 Handles and object-access host calls.** Done. A per-task ARC handle
      table and the object-access host calls, built on it. Depends on L2, L4.
      Three sub-steps, each its own commit.

      Settled design (from the codebase map and the L5 interview):
      - **Handle table lives in the verb layer.** It is an array of
        `{OBJ *ref; owned}` embedded in `struct verb_ctx` (so one-shots and the
        agent's embedded ctx both carry it), not in the game-agnostic VM core.
        Teardown runs at the two verb-layer task-exit points that cover every
        verb task: the `run_task` epilogue for one-shots (which run outside
        `vm_sched`) and `agent_reap` for residents. Teardown `obj_release`s every
        owned, live handle.
      - **Handle values.** `0` = none/invalid (so calls that return a handle use
        `0` for failure), `1` = self (reserved, pre-seeded, *borrowed*: the table
        does not release it, since the existing owner does -- `agent_reap` for an
        agent, the caller's object for a one-shot), `2..MAX-1` = dynamic handles
        the table pins via `obj_get` and releases on close or teardown. The SDK
        exposes `VM_HANDLE_SELF`. This is the ARC model: add = pin, close/exit =
        release. Host-seeded handles use the same add path, so the dispatcher can
        seed self now and direct/indirect objects at L6; the guest sees an opaque
        int.
      - **No authority yet.** `sys_setprop`/`sys_move` stay on the interim "any
        running verb may write" rule; the owner-or-wizard checks are L7.
      - **Event routing is left string-keyed.** Retiring the agent event-routing
        keys (`self_key`/`listen_key`/`verb_agent_deliver`) is out of L5 scope;
        that routing targets a canonical object id and works. Revisit with L6.

      - **L5a Handle table + handle-taking getprop/setprop.** Done. A small
        `src/verb/verb_handle` table (add/get/close/release-all, self reserved,
        owned vs borrowed, bounded size), unit-tested standalone over real OBJs.
        Embed it in `struct verb_ctx`; seed self as handle 1. Generalize
        `hc_getprop`/`hc_setprop` to read a handle in `a0` (name/buf/val shift
        right) and resolve it through the table instead of the implicit
        `vc->self`; `VM_HANDLE_SELF` reproduces today's behavior. Add `sys_close`
        so a guest can release a handle it is done with (needed so iteration does
        not exhaust the table). SDK: `getprop`/`setprop` prototypes in `vmsys.h`
        grow the leading handle arg (stubs and import indices 5/6 unchanged,
        since stubs forward registers); add `sys_close` as import 13.
      - **L5b Lookup and iteration.** Done. `sys_getobj(handle, name)` reads an
        object-reference property and returns a new handle to the referenced
        object; `sys_objfind(name, players_only)` resolves a name in the task's
        actor scope via `src/resolve` (L4) and returns a handle;
        `sys_next(container_handle, ordinal)` returns the ordinal-th member of a
        container as a new handle, `0` past the end (ordinal walk over the L2
        contents index; fine for MUD-sized containers). Add `actor_id` to
        `struct verb_ctx` for `sys_objfind`'s scope, seeded by the dispatcher
        (falls back to the self object's id when unset; the real command actor is
        fed at L6). New imports 14-16; `vmsys.h` prototypes; register in
        `verb_dispatch`. A program iterating a container with `sys_next` should
        `sys_close` each handle it finishes with, so its 30-slot table does not
        fill; the `vmsys.h` prototype notes this. On a full table the fresh
        `obj_get` reference is released, not leaked, and `sys_next` returns `0`.
      - **L5c Relocation.** Done. `sys_move(member_handle, container_handle)`
        relocates via `obj_move` (container `0`/none = limbo); returns `-1` on a
        bad handle or a move `obj_move` refuses (a cycle). No permission check
        yet (L7). New import 17.
      - **Deferred to L7:** `sys_create` and `sys_recycle`. Both are entangled
        with concerns L5 does not have: create needs an object-id allocation
        policy and sets `%owner`; recycle is defined as "destroy an object the
        caller owns", which is the authority check itself. They land with the
        ownership/authority work, reusing the handle table and `obj_create`/
        `obj_destroy`. (Card scope change from the original L5 list.)
- [x] **L6 Verb model.** Done. The packed `verb.<word>` property, prototype-walk
      resolution, typed argument matching filling object and preposition slots,
      and dispatch to the resolved program. Depends on L4, L5. Reuses the
      existing `verb_spec` matcher (`src/verb/verb_spec.c`).

      Settled design (from the L6 interview):
      - **Verbs have their own entry ABI, not `main(argc, argv)`.** A verb image
        is entered with `a0 = nslots`, `a1 = guest address of a slot array`.
        Each slot is `{u32 type, u32 value}`: `value` is an object handle for an
        `<obj>`/`<player>` token, or a guest string pointer for an
        `<atom>`/`<any>`/preposition token. Every spec token yields one slot in
        spec order, so an `<atom=in|on>` slot records which word matched.
      - **SDK command-verb runtime.** A `_start` stashes `a0`/`a1` and calls the
        verb's `main`; `cmd.h` provides va_arg-style `cmd_arg_obj()` (next
        handle) and `cmd_arg_str()` (next string), each type-checked against the
        slot tag. Pulling the wrong type returns an error sentinel rather than
        faulting. Named `cmd.*`, not `verb.*`, since the SDK already uses
        `verb.*` for the agent event loop.
      - **VM core stays game-agnostic.** A new `vm_task_set_typed_args(t, slots,
        n)` writes the typed array into guest memory and sets `a0`/`a1`/`sp`,
        mirroring `vm_task_set_args`. The type tag is opaque to the VM; the verb
        layer and the SDK agree on its meaning, kept in lockstep like the import
        table.
      - **Object args fail before dispatch.** If an `<obj>`/`<player>` segment
        does not resolve to a unique object (none or ambiguous), the match fails
        and the program never runs; the command layer reports it. A verb that
        wants to handle resolution itself uses `<any>` and calls `sys_objfind`.
      - **Scope and order.** Search for `verb.<word>` on the actor, then the
        actor's location, then the actor's held (direct-contents) items, then
        the room contents; each via a prototype walk (`%parent`). First match
        wins. A new `obj_prop_resolve` wrapper exposes the obj-cache prototype
        walk (`obj_cache_prop_resolve`) to the verb layer.
      - **Packing.** `verb.<word>` value is `"<prog_id>\t<argspec>"`; the word
        lives in the property name, so the spec is the argument pattern only.
      - **Scope note.** L6 is core plus tests: `verb_model` and the SDK verb
        runtime, no UI-layer change. Wiring typed verbs into the live command
        loop (telnet/SSE "unknown command -> verb") is a follow-up card.

      Sub-steps, each its own commit:
      - **L6a Verb entry ABI + SDK verb runtime.** Done. `vm_task_set_typed_args`
        in the VM core (generic typed-slot writer; the type tag is opaque to the
        VM). The SDK runtime is named `cmd.*` rather than `verb.*`, because the
        existing SDK `verb.h`/`verb_rt.c` already mean the agent event loop:
        `cmd_crt.S` (typed-slot entry), `cmd_rt.c` (va_arg-style `cmd_arg_obj`/
        `cmd_arg_str` with count/peek/reset, each type-checked), `include/cmd.h`,
        and `examples/look.c`. Tags `CMD_ARG_OBJ`/`CMD_ARG_STR` are the host/guest
        lockstep point. Tested in test_vm (slot count in a0, a handle slot, a
        string slot via its guest pointer).
      - **L6b Verb resolution.** Done. `obj_prop_resolve` (an obj_store wrapper
        over `obj_cache_prop_resolve`) plus `verb_resolve(actor, word, out)` in
        `src/verb/verb_model.c`, which walks the scope tiers (actor, location,
        held items, room contents), each prototype-walked, first match wins, and
        splits the packed `"<prog>\t<spec>"` value. The two contents tiers
        snapshot member ids before any `obj_get`, since the contents iterator
        holds an open read transaction. Store-backed tests cover each tier,
        prototype inheritance, no-tab packing, actor-over-location precedence, a
        miss, and bad arguments.
      - **L6c Bind and dispatch.** Done. `verb_dispatch_command(actor, word,
        rest)` resolves the verb, parses and matches the spec, resolves object
        args (fail-before-dispatch -> `VERB_CMD_BADARG`), pre-seeds owned
        handles, builds the typed slot vector, and runs the bound program with
        `vm_task_set_typed_args`. The verb's self is its holder object; output
        broadcasts to the actor's location. Returns `VERB_CMD_OK` (0) when a
        verb ran, or `VERB_CMD_NOVERB` / `_NOMATCH` / `_BADARG` / `_ERROR`. The
        program's own exit status is not surfaced (verbs return nothing), so a
        run can never alias a failure code. test_verb_command drives the full
        path with
        hand-assembled programs and, when the SDK built `data/vm/look.elf`, runs
        that real `cmd.*` program end to end (closing the L6a SDK-runtime gap).
      - **Packing convention.** The `verb.<word>` program field is a bare
        program id (e.g. `look`), which dispatch resolves through
        `verb_program_resolve` as `programs/<id>`.
      - **Follow-up (not L6).** Wiring `verb_dispatch_command` into the live
        telnet/SSE command loop, and allowing multiple verbs to share a word
        with different argspecs (today the first `verb.<word>` by scope wins and
        a spec mismatch is a usage error rather than a fall-through).
- [x] **L7 Authority and security.** Owner-or-wizard checks on property writes,
      move, and recycle; `sys_setpriv` elevation; `sys_create`/`sys_recycle`
      (moved here from L5, inseparable from ownership); and the errno-style
      failure codes. Depends on L3, L5.

      Settled model (from the L7 interview). Two orthogonal things travel with a
      running context (a player session or a process/task), seteuid-style:
      - **Effective owner (euid)** is the identity a write/move/recycle is
        checked against an object's `%owner`, and the owner stamped on objects
        the task creates. It defaults to the **initiator** (the player who ran
        the verb), *not* the program owner -- the reverse of Unix, chosen so a
        program cannot launder privilege by creating objects while elevated.
      - **Real owner (ruid)** is the attached object's `%owner`; a program may
        explicitly switch its effective owner to this to modify the object it is
        attached to, then drop back. The program/ELF object plays no part.
      - **Wizard (admin)** is an orthogonal flag. Process state holds whether
        wizard is *available* (the current effective identity is durably
        permitted it, from the account) and whether it is *enabled* (default
        off). A program enables it for the smallest region then drops; enabling
        is denied when the effective identity is not permitted.
      - **Durable permissions live on the account**, not the object; the session
        carries the live effective state and can elevate/drop within what the
        account allows. The permission check reads the task's effective state,
        never a field on the object.
      - Check on object O: `effective_owner == O.%owner` OR wizard enabled.

      L7 is the VM/process side; the session's effective state is injected by the
      caller (synthesized in tests). The player-facing elevate/drop command and
      the account's durable-permission storage ride with the later command-loop
      wiring.

      Sub-steps, each its own commit:
      - **L7a Owner-or-wizard check.** Done. `eff_owner` + `is_wizard` in
        `struct verb_ctx`; `verb_may_modify` gates `sys_setprop` and `sys_move`.
        A player command sets `eff_owner` to the initiator; host-initiated
        one-shots and agents leave it unset and run unrestricted (system), which
        preserves existing paths. An unowned object is writable only by the
        system or a wizard. Removes the "any running verb may write" interim.
        test_verb_command covers owned/other-owner/unowned writes.
      - **L7b `sys_setpriv` + effective-owner switch.** Done. `sys_setpriv(mode)`
        (import 18): `VM_PRIV_WIZ_ON`/`WIZ_OFF` enable/drop wizard (enable gated
        by `verb_dispatch_set_wizard_check`, a host-supplied durable-capability
        query keyed by the current effective identity; denied when unset), and
        `VM_PRIV_AS_OWNER`/`AS_CALLER` switch the effective owner between the
        attached object's `%owner` (captured at dispatch as `real_owner`) and the
        initiator. An owner switch recomputes wizard availability and drops
        wizard, so an identity change starts un-elevated. test_verb_command
        covers denied elevation (non-capable), enable-then-drop, a wizard write
        across owners, and a verb assuming its object's owner.
      - **L7c `sys_create` / `sys_recycle`.** Done. `sys_create(parent, id)`
        (import 19): the id is **guest-supplied**, fenced by `verb_create_id_ok`
        (structurally safe, not in a system namespace: programs/ chars/ rooms/
        templates/). The object is stamped `%owner` = effective owner and
        `%parent` = the parent handle's id (none for `VM_HANDLE_NONE`); the cache
        refuses a duplicate id, so uniqueness is free. `sys_recycle(obj)`
        (import 20) destroys an object the authority owns (or wizard); it refuses
        the self handle and a non-empty container, moves a contained object to
        limbo first so no stale index entry remains, and closes the handle
        (the cache rejects destroying a pinned object). test_verb_command covers
        the owner/parent stamp, a refused system-namespace create, a
        create-then-recycle round trip, and recycle denied by owner and by
        non-empty container.
      - **L7d errno-style failure codes.** Done. One `last_error` in `struct verb_ctx`
        and a `sys_errno()` import, a small fixed enum (denied / not-found /
        not-owner / ambiguous). It only refines a failure; the return ABI stays
        `0`/handle/`-1`, so existing programs are unchanged. Contract (in
        `vmsys.h`): errno is meaningful only immediately after a call that
        signaled failure and is not cleared on success; per-task placement is the
        thread-safe choice. Exposes `sys_objfind` NONE vs AMBIGUOUS through the
        enum (until now that was the verb model's job, so L5's `objfind` stayed
        as-is). Iteration end is not an error and is not routed through errno;
        add `sys_contents_count` so a guest bounds its `sys_next` loop and a
        premature `0` (before the count) is the real error.
- [x] **L8 Docs and close.** Done. doc/mud-vm-design.md reconciled with what
      shipped: the host-call set (object-access and authority calls marked
      implemented, sys_close/errno/contents_count added, the unshipped
      rollup/spawn/call/hasverb recorded as deferred), the four-tier verb
      resolution and typed-slot entry ABI, the command-verb runtime, and the
      seteuid-style authority model. Card closed.

## Tests (spread across the layers)

- L1: create inserts a live, dirty, cache-coherent object; destroy removes it.
- L2: index put/del/cursor round-trips; `obj_move` updates `%location` and the
      old and new index entries in one transaction; move between containers;
      move to limbo; cycle refused; contents listing and count; listings include
      members that are not currently loaded; no index work at boot.
- L3a: a character created through the adapter is a `chars/<id>` OBJ; attrs
      round-trip; `character_attr_get/_set("room.current")` bridges to
      `%location` and the contents index (bare id in, `rooms/<id>` stored);
      `character_get` reloads a released character; the freelist is seeded from
      existing ids. L3b: `move` updates `%location` and the index, `look` shows
      the room, and occupants list includes others while excluding the viewer
      and covers members that are not loaded. L3c: the adapter-preserved readers
      (`room_broadcast`, `roll`, newuser seed) still work unchanged.
- L4: name resolves in each scope; ambiguous and absent names.
- L5a: the handle table add/get/close pins and releases, self is reserved and
      borrowed (not released by the table), owned handles release on close and on
      teardown (no pin leak after task exit), and the table bounds are enforced;
      getprop/setprop act on the handle (self via VM_HANDLE_SELF). L5b: getobj
      follows an object-reference prop, objfind resolves a scoped name, next
      walks a container's members; each returns a usable handle. L5c: move
      relocates through obj_move (and to limbo).
- L6: verb resolution in prototype order with argument matching.
- L7: create/move/recycle and property writes under and against authority;
      `sys_setpriv` allowed with the bit, denied without.

## Review

- [x] **L7 authority review.** Done. No privilege-escalation path found: `%owner`
      cannot be rewritten by a guest, identity switches drop wizard and recompute
      availability, and a non-wizard cannot reach a wizard-capable identity.
      Fixes and dispositions:
      - Fixed: `sys_recycle` now restores an object to its original location when
        the destroy is refused by a second pin, rather than stranding it in limbo
        (regression test added).
      - Fixed (second pass): `sys_create` now destroys the just-created object
        when the handle table is full, so a create that returns NOSPACE persists
        nothing (regression test added).
      - Confirmed intended, now commented: `sys_getprop` reads internal `%`
        fields, `sys_move` checks only the moved object's owner, and
        `wiz_available` is a snapshot.
      - Deferred to backlog: [[verb-creation-quota]] (no per-task/owner creation
        limit) and [[verb-errno-protected-write]] (errno granularity for a
        refused protected name).

- [x] **Agent authority review.** Done. No defect in the agent path: the task
      context is always zeroed to system authority, handles are released on reap,
      and the self pin is protected (the recycle fix covers a concurrent destroy).
      Findings were trust/guidance, not bugs:
      - Agents run as unscoped system authority; the safeguard is that only admin
        config launches them (no guest/player spawn path). sys_notify/sys_post are
        not authority-gated, so agents must treat event input as untrusted
        (confused-deputy risk), and a long-lived agent must close its handles.
        Guidance recorded in doc/mud-vm-design.md.
      - Deferred to backlog: [[verb-agent-scoped-authority]] (run an agent as its
        object's owner instead of the system).
