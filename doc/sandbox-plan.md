# Sandbox Scripting System -- Implementation Plan

This document describes the plan for the ColdFire sandbox scripting
system: persistent sandbox instances with unified handle-based verb
dispatch, cooperative event delivery, and a WaitForMultipleObjects-style
wait primitive.

## Design Summary

Script objects live in LMDB domain `"scripts"`. Room properties reference
them via domain-qualified names (e.g. `"script:anim/fountain"`). All
sandbox instances are **persistent** -- they live as long as the room is
loaded in the cache. Verbs and events are dispatched cooperatively into
a running instance, not by spawning ephemeral sandboxes.

File descriptors and verbs are **unified into a single handle type**.
Regular I/O (stdin, stdout, stderr, files, pipes) and verb registrations
all live in the same fd table as `struct sandbox_file` entries. Handle
numbers are `uint16_t`. HC_CLOSE returns a domain kind enum so the CRT
can perform type-specific cleanup without needing to know handle ranges.

### Execution model

Inspired by Palm OS PilotMain: events are delivered as normal function
calls when the sandbox is in a known quiescent state (parked in
HC_WAIT). No async interruption, no reentrancy, no signal-handler
restrictions. Every handler runs with full C semantics and valid global
state.

## Object Reference System

### Domain-qualified references

Property values can include a domain prefix matching
`[a-zA-Z_-][a-zA-Z0-9_-]*:`. Without a prefix, the domain is inferred
from context:

| Property context | Default domain | Default base path          |
|------------------|----------------|----------------------------|
| `exit.<dir>`     | `rooms`        | same hierarchy as this room |
| `script.*`       | `scripts`      | `/` (root)                 |

Examples:
- `"exit.n": "town-square"` -- resolves to `rooms:town-square`
- `"exit.n": "script:exits/random-portal"` -- resolves to a script
- `"script.continuous": "anim/fountain"` -- resolves to `scripts:anim/fountain`

### Hierarchical path resolution

Object keys support path-like hierarchy:

- `"town-square"` and `"/town-square"` are equivalent at the root level.
- `"../someroom"` resolves relative to the referring object's path.
- `"/path/to/deep/room"` is an absolute path.

Path resolution normalizes the key before LMDB lookup. Slashes are part
of the key string -- LMDB treats them as opaque bytes.

## Script Domain and Objects

### Domain

`DOMAIN_SCRIPT "scripts"` in `boris.h`.

### Script object properties

| Property             | Required | Description                                |
|----------------------|----------|--------------------------------------------|
| `elf.path`           | yes      | Path to ELF binary                         |
| `ram.size`           | no       | RAM allocation in bytes (default 65536)    |
| `interface`          | no       | Comma-separated supported interfaces       |

Example (`scripts/anim/fountain`):

```json
{"id":"anim/fountain","elf.path":"data/machine/anim/fountain.elf","ram.size":"65536"}
```

## Sandbox Instance Lifecycle

### Task states

```
         _start begins
              |
              v
    +--------------------+
    |  TASK_STATE_INIT   |  CRT runs: zero .bss, HC_OPEN each verb
    |                    |  from .data.verb_regs, call main() if present
    +--------------------+
              |
              | first HC_WAIT from _start
              v
    +--------------------+
    |  TASK_STATE_READY  |  Parked. Host may dispatch verbs/events.
    |                    |  HC_WAIT returns index of signaled handle.
    +--------------------+
              |
              | host dispatches verb/event
              v
    +--------------------+
    |  TASK_STATE_BUSY   |  Handler executing. May call HC_WAIT
    |                    |  internally (e.g. sleep in a loop).
    +--------------------+
              |
              | handler returns, CRT calls HC_WAIT
              v
         TASK_STATE_READY (loop)

    Any state --[HC_EXIT or force-kill]--> TASK_STATE_DEAD
```

During TASK_STATE_INIT, verb handles are not yet open. The host must not
dispatch verbs until the sandbox reaches READY.

### Room lifecycle integration

Sandbox instances are tied to the room cache, not to boot:

- **On room load** (first `room_get()` from database): if the room has
  `script.continuous` or other script properties, create a sandbox
  instance and begin INIT.
- **On room evict** (`room_ll_free()`): initiate termination sequence,
  then free the sandbox.
- **At boot with no users**: no rooms loaded, no sandboxes running.

Callbacks registered via `room_set_load_cb()` / `room_set_evict_cb()`
in `room.h`.

### Continuous scripts

A room's `script.continuous` property names a script object. The CRT
calls `main()` during INIT (before the first HC_WAIT). For the fountain,
`main()` loops calling HC_WAIT with timeouts to sleep, post messages,
and sleep again. The sandbox stays in BUSY, periodically waking on
timeout. When `main()` returns, _start enters the HC_WAIT dispatch
loop.

### Termination sequence

On room evict (or explicit kill):

1. If `_event_term` was opened via HC_OPEN and the sandbox is in
   TASK_STATE_READY: dispatch it as a normal event. Run with an
   instruction cap.
2. If the handler calls HC_EXIT: clean shutdown.
3. If it exceeds the instruction cap, or `_event_term` is not
   registered, or the sandbox is in INIT/BUSY: force-kill (free
   immediately).

Analogous to SIGTERM/SIGKILL: cooperative if listening, forced otherwise.

## Unified Handle System

File descriptors and verbs share a single `uint16_t` handle space.
Every open handle is a `struct sandbox_file` in the task's fd table.

### Handle allocation

HC_OPEN allocates the next available fd from the task's fd table. The
host may use internal allocation strategies (e.g. reserving low numbers
for I/O, higher numbers for verbs), but the guest does not depend on
this. The CRT learns handle types from HC_CLOSE return values, not
from fd number ranges.

### struct sandbox_file

Replaces the old `struct sandbox_fd`:

```c
struct sandbox_file {
    uint16_t          type;     /* SF_NONE, SF_IO, SF_VERB, SF_EVENT, ... */
    uint16_t          flags;
    union {
        struct {                /* SF_IO */
            sandbox_msg_fn  msg_post;
            void           *ctx;
        } io;
        struct {                /* SF_VERB */
            char           *name;       /* "go", "look", etc. */
            uint32_t        handler_pc; /* function pointer from CRT */
        } verb;
    };
};
```

The task's fd table is an array of `struct sandbox_file` indexed by
`uint16_t`. On sandbox creation, fds 0 (stdin), 1 (stdout), 2 (stderr)
are opened as SF_IO entries.

### Host-side verb lookup

The host finds verbs by searching the task's fd table for SF_VERB
entries with matching names. This is the **source of truth** -- no ELF
symbol scanning, no verb table in sandbox RAM. The `struct sandbox_file`
entries are created by HC_OPEN calls from the CRT during INIT.

Verb dispatch for "go":

1. Host searches fd table for SF_VERB with name "go" -> finds fd 128
2. Host reads handler_pc from that entry
3. Host writes verb context to context area in sandbox RAM
4. Host sets PC to handler_pc, resumes execution

## Hypercalls

### HC_YIELD -- Cheap tick yield

Zero-argument, zero-return. Tells the host "I'm done for this tick,
resume me next time." Keeps register pressure minimal for tight loops
that just need to not hog the instruction budget.

```c
void hc_yield(void);
```

Host returns SANDBOX_RUN_YIELD. The tick loop resumes the task on the
next tick without changing task state.

### HC_OPEN -- Open a handle

```c
int hc_open(const char *name, int flags);
```

| Parameter | Description                                          |
|-----------|------------------------------------------------------|
| `name`    | Domain-qualified name: `"verb:go"`, `"event:term"`   |
| `flags`   | Reserved, pass 0                                     |

Returns: handle number (>= 0), or negative errno on error.

The domain prefix determines the handle range and type:
- `"verb:NAME"` -- allocates from 128+, creates SF_VERB entry
- `"event:NAME"` -- allocates from 128+, creates SF_EVENT entry

For verb handles, the guest must write the handler function pointer
into the sandbox_file's handler_pc field via a follow-up mechanism
(register pair in the hypercall return, or a subsequent HC_IOCTL).

### HC_CLOSE -- Close a handle

```c
int hc_close(int fd);
```

Synchronous. The fd is dead when HC_CLOSE returns. Returns a domain
enum on success (KIND_IO, KIND_VERB, KIND_EVENT, ...) or negative
errno on error. The CRT's `close()` wrapper uses the returned kind to
perform type-specific cleanup without needing to know handle ranges
or maintain parallel bookkeeping:

```c
int close(int fd)
{
    int kind = HC_CLOSE(fd);
    if (kind < 0) {
        errno = -kind;
        return -1;
    }
    if (kind == KIND_VERB) {
        __dispatch_table[fd] = _panic_dispatch;
        __remove_verb_fd(fd);
    }
    return 0;
}
```

Setting the slot to `_panic_dispatch` (instead of NULL) gives a clear
trap if anything attempts to dispatch to a stale verb fd.

### HC_WAIT -- WaitForMultipleObjects-style wait

Replaces HC_SLEEP, HC_SUSPEND, and the proposed HC_SELECT with a
single unified primitive.

```c
int hc_wait(int ncount, uint16_t *handles, int timeout_ms);
```

| Parameter    | Description                                         |
|--------------|-----------------------------------------------------|
| `ncount`     | Number of handles in the array (0 = no handles)     |
| `handles`    | Guest RAM pointer to array of uint16_t handle numbers |
| `timeout_ms` | -1 = infinite, 0 = poll, >0 = sleep N ms           |

Returns: index into handles[] of the signaled handle, -1 on timeout,
negative errno on error.

No in-place modification of the handles array. No bWaitAll.

**Special case:** `hc_wait(0, NULL, -1)` -- no handles to wait on,
infinite timeout. Returns immediately with an error (no handles).
The CRT uses this as the loop exit condition: when no verb fds remain
open, the dispatch loop terminates cleanly.

Guest runtime wrappers:

```c
void hc_sleep(int ms)     { hc_wait(0, NULL, ms); }
void hc_suspend(void)     { hc_wait(0, NULL, -1); }
```

Host-side behavior:

| HC_WAIT call                    | Host action                        |
|---------------------------------|------------------------------------|
| First call from _start          | INIT -> READY transition           |
| ncount > 0, timeout > 0        | Sleep, wake on signal or timeout   |
| ncount > 0, timeout = -1       | Block until a handle is signaled   |
| ncount = 0, timeout > 0        | Pure sleep (no handle check)       |
| ncount = 0, timeout = -1       | Returns immediately (nothing to wait on) |

## CRT Verb Registration

### .data.verb_regs section

The CRT tooling generates a static registration table in a
`.data.verb_regs` ELF section. Each entry is a name/handler pair.
The `_start` function iterates this table and calls HC_OPEN for each
entry during INIT.

```c
struct verb_reg {
    const char *name;       /* "verb:go", "event:term", etc. */
    void      (*handler)(void);
};
```

### VERB_HANDLER macro

```c
#define VERB_HANDLER(name, fn)                                   \
    static void fn(void);                                        \
    __attribute__((section(".data.verb_regs"), used))             \
    static const struct verb_reg _vreg_##name = { "verb:" #name, fn }

#define EVENT_HANDLER(name, fn)                                  \
    static void fn(void);                                        \
    __attribute__((section(".data.verb_regs"), used))             \
    static const struct verb_reg _vreg_##name = { "event:" #name, fn }
```

Script author writes `VERB_HANDLER(go, my_go);` and the CRT handles
the rest at startup.

### CRT dispatch_table

The CRT maintains a `dispatch_table[]` array in .bss, indexed by fd
number. When HC_OPEN returns a handle, the CRT stores the function
pointer at `dispatch_table[fd]`. When `close()` is called, HC_CLOSE
returns the handle kind. If it was KIND_VERB, the CRT sets
`dispatch_table[fd] = _panic_dispatch` and removes the fd from the
`verb_fds[]` wait set.

## CRT _start Lifecycle

```
_start:
    zero .bss

    iterate .data.verb_regs:
        for each entry (name, handler):
            fd = HC_OPEN(name, 0)
            dispatch_table[fd] = handler
            verb_fds[nfds++] = fd

    if (main != NULL) call main()

    loop:
        idx = HC_WAIT(nfds, verb_fds, -1)
        if (idx < 0) break
        dispatch_table[verb_fds[idx]]()
        goto loop

    HC_EXIT(0)
```

For ported C programs (shell, compiler): `main(argc, argv)` runs to
completion, returns to _start. If no verbs were registered (nfds == 0),
HC_WAIT(0, NULL, -1) returns immediately and the sandbox exits.

For the fountain: `main()` loops with `hc_wait(0, NULL, sleep_ms)` and
never returns. The _start dispatch loop is never reached.

For verb scripts: `main()` returns quickly (or is absent). The dispatch
loop handles all verb events cooperatively.

## Verb Context Block

Written into sandbox RAM at a fixed address (e.g. 0x0800) before
dispatch. Big-endian (ColdFire byte order):

```
offset  size  field
0x00    4     verb fd (handle number)
0x04    4     verb string pointer (address of name in RAM)
0x08    4     room_id string pointer
0x0C    4     player_id string pointer
0x10    4     direction string pointer (for exit verbs)
0x14    ...   null-terminated string data for above pointers
```

## Interfaces

An **interface** is a named set of verbs. A script object declares
compatibility via its `interface` property.

### Exit interface

The `exit` interface requires: `verb:go`, `verb:look`.

### Interface checking

After the sandbox reaches TASK_STATE_READY (all HC_OPEN calls
complete), the host inspects the fd table for the required SF_VERB
entries. If any are missing, log a warning. This is a runtime check
after CRT init, not a static ELF symbol check.

## Implementation Phases and Milestones

### Milestone 1: Script domain and object references (DONE)

**Commit: `20908a4` "script: add script domain and object reference parsing"**

- `DOMAIN_SCRIPT` in boris.h
- `src/sandbox/script.c`, `script.h`: script_load, script_free,
  script_elf_path, script_ram_size
- `src/sandbox/objref.c`, `objref.h`: objref_parse, objref_resolve_path
- `sample/scripts/anim/fountain.json`

### Milestone 2: Room lifecycle hooks (DONE)

**Commits: `fe9c63e`, `78737da`**

- Room load/evict callbacks in `room.h` / `room.c`
- `room_sandbox.c`: attach on room load, detach on room evict
- `script.continuous` property on `tower-entrance.json`
- Removed hardcoded `room_sandbox_attach()` from `boris.c`

---

### Milestone 3: Unified handle system and HC_OPEN/HC_CLOSE

**Commit: "sandbox: unified handle system with struct sandbox_file"**

Files: `src/sandbox/sandbox.c`, `src/sandbox/sandbox.h`

1. Replace `struct sandbox_fd` with `struct sandbox_file`
2. Expand fd table to `uint16_t` indexing
3. Create stdin/stdout/stderr as SF_IO handles on sandbox creation
4. Implement HC_OPEN: parse domain prefix, allocate fd,
   create SF_VERB/SF_EVENT entries
5. Implement HC_CLOSE: free slot, return domain kind enum
6. Keep HC_YIELD unchanged

**Testable:** existing fountain still works (stdout is fd 1, SF_IO).
HC_OPEN("verb:test", 0) returns a valid fd. HC_CLOSE returns KIND_VERB.

---

### Milestone 4: HC_WAIT and task state machine

**Commit: "sandbox: WaitForMultipleObjects-style HC_WAIT"**

Files: `src/sandbox/sandbox.c`, `src/sandbox/sandbox.h`,
`src/sandbox/room_sandbox.c`

1. Implement HC_WAIT(ncount, handles, timeout_ms), remove HC_SLEEP
2. Add task lifecycle states: INIT, READY, BUSY, DEAD
3. First HC_WAIT from _start triggers INIT -> READY
4. HC_WAIT(0, NULL, ms) behaves like old HC_SLEEP for fountain
5. HC_WAIT(0, NULL, -1) returns immediately (loop exit)
6. Update room_sandbox tick_cb for new states

**Testable:** fountain works using hc_wait(0, NULL, sleep_ms).
Sandbox reaches READY after main returns.

---

### Milestone 5: CRT verb registration and dispatch loop

**Commit: "sandbox-dev: CRT with HC_OPEN verb registration"**

Files: `sdk/machine/include/machine.h`, `sdk/machine/lib/crt0.S`,
`sdk/machine/lib/machine.ld`

1. VERB_HANDLER / EVENT_HANDLER macros generate .data.verb_regs entries
2. CRT _start: zero .bss, iterate .data.verb_regs calling HC_OPEN,
   populate dispatch_table, run main(), enter HC_WAIT dispatch loop
3. CRT close() wrapper: check HC_CLOSE return kind, clean up dispatch_table
4. Linker script: collect .data.verb_regs section

**Testable:** fountain works with new CRT. A test verb script registers
a verb and receives dispatch.

---

### Milestone 6: Verb dispatch from commands (DONE)

**Commit: "script: dispatch verbs to persistent sandbox instances"**

Files: `src/sandbox/sandbox.c`, `src/sandbox/sandbox.h`,
`src/sandbox/room_sandbox.c`, `src/sandbox/room_sandbox.h`,
`src/cmd/move.c`, `src/sandbox/test_sandbox.c`

1. `sandbox_task_find_verb(t, name)`: search fd table for SF_VERB
   with matching name, return fd or -1.
2. `sandbox_task_write_context(t, fd, verb, room_id, player_id, dir)`:
   write verb context block at 0x0800 in guest RAM.
3. `room_sandbox_dispatch_verb(room_id, verb, player_id, direction)`:
   find room's sandbox, look up verb, write context, dispatch, run
   inline with 8192 instruction cap.
4. `do_move()`: `objref_parse()` on exit value. If domain is "script",
   dispatch verb "go" to the room's sandbox instance.
5. `show_room()` exit listing: script exits still appear (exit attribute
   exists regardless of value domain).
6. Unit tests: test_find_verb (multi-verb registration + lookup),
   test_context (context block write + dispatch + handler reads verb
   string from context).

---

### Milestone 7: Termination and interface checking (DONE)

**Commit: "sandbox: cooperative termination and interface checking"**

Files: `src/sandbox/sandbox.c`, `src/sandbox/sandbox.h`,
`src/sandbox/room_sandbox.c`, `src/sandbox/room_sandbox.h`,
`src/sandbox/script.c`, `src/sandbox/script.h`,
`src/sandbox/test_sandbox.c`

1. `sandbox_task_find_event(t, name)`: search fd table for SF_EVENT
   with matching name, return fd or -1.
2. `script_interface(obj)`: return script object's `interface` property.
3. On room evict: if `event:term` handle exists in fd table and sandbox
   is READY, dispatch it with instruction cap. If handler calls HC_EXIT,
   log clean shutdown. Otherwise force-kill.
4. Interface checking after READY: parse comma-separated interface
   names from script object, scan fd table for required SF_VERB entries.
   Log warning for unknown interfaces or missing verbs.
5. Interface table: `exit` requires `verb:go`, `verb:look`.
6. `room_sandbox_attach()` accepts optional interface string, stored
   in room_task for deferred checking.
7. Unit tests: test_find_event (SF_EVENT lookup vs SF_VERB), 
   test_termination (event:term dispatch with clean exit status 42).

**Testable:** script with `event:term` logs clean shutdown on room
evict. Missing interface verbs produce warning.

---

### Milestone 8: SDK and examples (DONE)

**Commit: "sandbox-dev: verb script SDK with examples"**

Files: `sdk/machine/include/machine.h`, `sdk/machine/anim/fountain.c`,
`sdk/machine/exits/random-portal.c`, `sdk/machine/Makefile`,
`sample/scripts/exits/random-portal.json`

1. SDK header: added `struct verb_context` and `VERB_CONTEXT` macro
   for reading the host-written context block at 0x0800.
2. Example: `exits/random-portal.c` with `verb:go` and `verb:look`
   handlers using VERB_HANDLER macro and CRT dispatch loop.
3. Fountain updated to use `<machine.h>` and `hc_wait()` instead of
   `hc_sleep()`.
4. Makefile updated for subdirectory builds (exits/).
5. Sample script object `exits/random-portal.json` with `interface`
   property set to `"exit"`.

**Testable:** full round trip -- write verb script, cross-compile,
import script object, assign to room exit, walk through it.

---

### Future milestones (not yet scheduled)

- **Capability system**: handle passing between sandboxes via
  sendmsg/SCM_RIGHTS-like mechanism. dup/dup2 on verb handles. Another
  sandbox holding your verb handle can trigger it.
- **Async dispatch**: player connection suspension, sandbox scheduled
  via tick timer. Needed when verb handlers require HC_WAIT internally.
- **Player connections as sandboxes**: each player runs a sandbox that
  handles all commands.
- **Script persistent state**: shared read/write state across sandbox
  restarts (`script.state` property).
- **Line input forwarding**: sandbox receives typed input from player.
- **main() with argc/argv**: for ported C programs (shell, compiler).

## File Summary

New files:
- `src/sandbox/script.c` -- script domain access (DONE)
- `src/sandbox/script.h` -- public API (DONE)
- `src/sandbox/objref.c` -- object reference parsing (DONE)
- `src/sandbox/objref.h` -- public API (DONE)
- `sample/scripts/anim/fountain.json` -- fountain script object (DONE)

Files to create:
- `sdk/machine/include/machine.h` -- SDK header with verb/handle macros
- `sdk/machine/lib/crt0.S` -- unified CRT with HC_OPEN loop and dispatch
- `sdk/machine/lib/machine.ld` -- linker script with .data.verb_regs
- `sdk/machine/exits/random-portal.c` -- example verb script
- `sample/scripts/exits/random-portal.json` -- example script object

Modified files:
- `src/room/room.h` -- load/evict callbacks (DONE)
- `src/room/room.c` -- callback registration and firing (DONE)
- `src/sandbox/room_sandbox.c` -- lifecycle-driven attach/detach (DONE)
- `src/boris.h` -- DOMAIN_SCRIPT (DONE)
- `src/boris.c` -- removed hardcoded attach (DONE)
- `src/sandbox/sandbox.c` -- struct sandbox_file, HC_OPEN/CLOSE/WAIT
- `src/sandbox/sandbox.h` -- new types, state enum, handle ranges
- `src/cmd/move.c` -- script exit dispatch
- `src/cmd/look.c` -- script exit display
- `src/cmd/cmdutil.c` -- exit listing with script awareness
