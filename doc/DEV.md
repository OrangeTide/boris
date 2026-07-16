# Developer Guide

Information for developers working on Boris MUD.

## Building and Running

Build requires GNU Make 4.2.1+, GCC or Clang. On Debian/Ubuntu install
`build-essential zlib1g-dev`.

```sh
make -j                    # Build (parallel, default GCC)
make -j USE_CLANG=1        # Build with Clang
make install               # Build and install web client to bin/www/
make clean                 # Remove build objects
make distclean             # Remove all build artifacts including binaries
```

Build output binaries are `boris`, `mkpass`, and `muddb-tool` under
`_out/<triplet>/bin/`. `make install` stages them (and the web client) into
`bin/`, which is where the `./bin/...` run and tool examples below expect
them.

```sh
make tests                 # Run unit tests (obj, muddb, hashtable)
make tests-valgrind        # Run unit tests under valgrind (leak check)
make smoke                 # Run smoke tests (requires expect)
make release               # Build + package release tarball
make deploy                # Build + package + deploy (needs DEPLOY_DEST)
```

Local configuration (deploy destination, etc.) goes in `.env` (see
`doc/env.example`). The Makefile reads it automatically via `-include .env`.

Run the server:

```sh
./bin/boris                # Start server (telnet on 4444, web on 8080)
```

Configuration lives in `boris.cfg` (server.port, webserver.port, channels,
messages, new user settings).

The build system internals are described under [Build System](#build-system)
below.

## Project Layout

| Directory              | Description                                                    |
|------------------------|----------------------------------------------------------------|
| src/                   | Main source and miscellaneous modules                          |
| src/obj/               | OBJ -- mutable JSON objects with property iteration            |
| src/database/          | muddb -- LMDB persistence layer (OBJ-centric API)              |
| src/room/              | Room subsystem (load/save/cache with refcount)                 |
| src/character/         | Character subsystem (load/save/cache with refcount + freelist) |
| src/channel/           | Chat channel pub/sub system                                    |
| src/cmd/               | Command dispatch and handlers (look, go, say, etc.)            |
| src/help/              | Online help system (reads plain text from data/help/)          |
| src/log/               | Subsystem-tagged logging and event log                         |
| src/iox/               | I/O multiplexing                                               |
| src/net/               | TCP networking layer on top of iox                             |
| src/entity/            | RPG-capable entity layer on top of objects                     |
| src/rpg/               | RPG attribute/skills helper functions                          |
| src/combat/            | Combat session management and tick scheduler                   |
| src/web/server/        | SSE web server (built-in, on net_stream)                       |
| src/crypt/             | SHA1 hash and base-64 encoding                                 |
| src/scrypt/            | scrypt key derivation for password hashing                     |
| src/security/          | Seccomp and Landlock sandboxing                                |
| src/daemonize/         | Daemonize support (-d flag)                                    |
| src/passwd/            | Password crypt utility (mkpass)                                |
| src/muddb-tool/        | muddb import/export CLI tool                                   |
| src/util/              | Miscellaneous utilities (wordwrap, etc.)                       |
| src/worldclock/        | In-game time tracking                                          |
| src/thirdparty/        | Third-party libraries (separate licenses)                      |
| src/thirdparty/jsmn/   | Minimal JSON parser (zero-copy)                                |
| src/thirdparty/lmdb/   | LMDB embedded key-value database                               |
| src/thirdparty/mth/    | MUD Telopt Handler (TELNET protocol)                           |
| src/thirdparty/tiny-aes/| AES-256 block cipher (public domain, Unlicense)               |
| src/coldfire/          | ColdFire V4e CPU emulator                                      |
| src/machine/           | Machine runtime (task lifecycle, fd table, ELF loader)         |
| sdk/machine/           | SDK and source for machine programs (cross-compiled to m68k)   |
| data/machine/          | Pre-built machine ELF binaries loaded at server startup        |
| sample/                | Starter database for new MUDs (import with muddb-tool)         |

## Build System

The build uses `GNUmakefile` with per-directory `module.mk` files discovered
via `SUBDIRS`. Each `module.mk` declares targets using:

- `LIBRARIES += <name>` -- static library (.a)
- `EXECUTABLES += <name>` -- executable binary
- Per-target variables: `<name>_DIR`, `<name>_SRCS`, `<name>_LIBS`

The top-level GNUmakefile includes all `module.mk` files and generates build
rules for each target via `$(eval $(call ...))` templates. Libraries produce
static archives (.a) that executables link against.

Object files go to `_build/<triplet>/`, mirroring the source tree. The triplet
is derived from `$(CC) -dumpmachine` (e.g. `_build/x86_64-linux-gnu/`), so
cross-compiled object files don't clobber native ones. Binaries go to
`_out/<triplet>/bin/`. Auto-dependency tracking uses `-MMD -MP`. LTO is enabled
automatically if the compiler supports it.

### Adding a new source file

Add it to the appropriate `<name>_SRCS` in its directory's `module.mk`. If
adding a new directory, create a `module.mk` there and add the directory to
`SUBDIRS` in the parent `module.mk`.

### Tests

`make tests` (alias for `run-tests`) builds and runs all test binaries. Tests
are declared in each module's `module.mk` via `EXECUTABLES +=`,
`TEST_TARGETS +=`, and a `<name>_TESTCMD` define. Tests use
`#include "source.c"` for internal access and print
`%%%%%%%%%%%% START-TEST` / `%%%%%%%%%%%% END-TEST` markers.

Current test suites:
- `test_obj` -- OBJ mutable JSON objects
- `test_obj_cache` -- OBJ cache layer
- `test_muddb` -- LMDB persistence layer
- `test_obj_cache_cas` -- CAS object store shim (smolvfs bridge)
- `test_cas`, `test_cas_tree` -- vendored smolvfs CAS and tree layers
- `test_hashtable` -- hash table (uint and string keyed)
- `test_mcp` -- MUD Client Protocol parsing, negotiation, simpleedit

`make smoke` starts the server in a temporary directory and exercises telnet
login flows via expect. Requires `expect` (`apt install expect` on
Debian/Ubuntu, `apk add expect` on Alpine). Test cases: connect and quit,
bad credentials rejection, new user creation and login. `make smoke-cas`
runs the same suite with the cas object store backend (imports the sample
world into a depot via `muddb-tool to-cas` first).

For memory checking, `make smoke-valgrind` is as above and wrapped in
[Valgrind][1].

## OBJ -- Mutable JSON Objects

OBJ (`src/obj/obj.c`) is the in-memory representation for all game objects.
Each OBJ wraps a flat JSON object (`{"key":"value",...}`) with property
get/set/delete and iteration. muddb serializes OBJ instances to and from
LMDB.

### Internal layout

An OBJ has two arrays:

- **data** (`char *`) -- byte buffer holding the original JSON text followed
  by any strings appended by mutations.  Original JSON occupies
  `data[0..json_len-1]`.  New keys and values are appended past `json_len`
  via `data_append()`.

- **tokens** (`jsmntok_t *`) -- array of jsmn tokens parsed from `data`.
  Token 0 is always `JSMN_OBJECT` (the root).  Each property is a key-value
  pair: the key is `JSMN_STRING`, the value is `JSMN_STRING`, `JSMN_PRIMITIVE`,
  `JSMN_OBJECT`, or `JSMN_ARRAY`.  `tokens[0].size` is the number of
  key-value pairs.

For an object created from `{"name":"house","color":"red"}`, the token
array looks like:

```
tokens[0]: JSMN_OBJECT  size=2
tokens[1]: JSMN_STRING   "name"   (key)
tokens[2]: JSMN_STRING   "house"  (value)
tokens[3]: JSMN_STRING   "color"  (key)
tokens[4]: JSMN_STRING   "red"    (value)
```

Token `start`/`end` fields are byte offsets into `data`.  For `JSMN_STRING`
tokens, `start`/`end` exclude the surrounding quotes.  For `JSMN_PRIMITIVE`
tokens, they include the full literal.

### Mutations

**Set** (`obj_prop_set`): appends the value string to `data`, then either
updates the existing value token in place (if the key exists) or inserts two
new tokens (key + value) at the end of the token array via `memmove`.  New
values are stored as `JSMN_PRIMITIVE` tokens pointing into the appended
region of `data`.

**Delete** (`obj_prop_delete`): finds the key token and removes it plus its
value token(s) from the array via `memmove`.  Decrements `tokens[0].size`.

**Empty objects**: `obj_new()` creates a synthetic root token
(`JSMN_OBJECT`, `size=0`) with no data buffer, so set/delete work uniformly
without special-casing the "no JSON yet" path.

### Serialization

`obj_get_json` walks the token array in a single forward pass.  For each
key-value pair it emits the key as a quoted string and the value according
to its token type: `JSMN_STRING` values get re-wrapped in quotes,
everything else is emitted as raw bytes from `data`.

If the object is not dirty (no mutations since last parse or compact), the
fast path copies the original JSON directly.

### Compaction

After many mutations the `data` buffer accumulates dead space from replaced
values.  `obj_compact` serializes to a fresh buffer, replaces `data`, and
re-parses.  This reclaims dead space and resets `dirty` to false.

### Value encoding

Values passed to `obj_prop_set` are stored verbatim as raw JSON fragments.
Callers can pass:

- Quoted strings: `"\"blue\""` -- serializes as `"blue"` in JSON
- Numbers: `"42"` -- serializes as `42`
- Bare strings: `"A white house"` -- works because jsmn is lenient with
  primitives; serializes as-is

`obj_prop_get` returns the raw fragment, so the caller sees exactly what was
stored (including surrounding quotes if they were part of the value).
Round-tripping through `obj_get_json` + `obj_new_from_json` strips the
outer layer: a stored `"\"blue\""` becomes `"blue"` after re-parse because
jsmn treats the quotes as JSON string delimiters.

### Iteration

`obj_iter` is a single forward walk over token pairs:

```c
OBJ_ITER *it = obj_iter_begin(obj);
const char *key, *value;

while (obj_iter_next(it, &key, &value)) {
	/* key and value are borrowed pointers into obj->data */
}

obj_iter_end(it);
```

The iterator tracks a token position and advances past each value using
`token_span`.  Do not mutate the object during iteration.

### Things to watch

- **memmove on every set/delete.**  Inserting or deleting tokens shifts the
  tail of the array.  For typical MUD objects (5-20 properties) this is a
  few hundred bytes.  Would matter at thousands of properties, but game
  objects stay small.

- **Data buffer only grows.**  Replaced values leave dead space until
  `obj_compact` is called.  This is intentional -- compact is called on the
  muddb write path, so normal save cycles reclaim space.

- **json_token_tostr writes null terminators.**  Every `obj_prop_get` and
  `obj_iter_next` call writes `'\0'` at `data[token->end]`.  For original
  `JSMN_STRING` tokens this overwrites the closing quote.  Harmless because
  `find_prop` uses length-bounded comparison (`json_token_streq`) and
  serialization uses `start`/`end` offsets directly.  But `data` is not
  pristine after any read.

- **token_span walks recursively.**  Called from `find_prop`, set, delete,
  serialize, and iterate.  For flat objects (all values are primitives or
  strings) it returns 1 immediately.  Only nested objects/arrays recurse.

## muddb -- LMDB Persistence Layer

muddb (`src/database/muddb.c`) stores OBJ instances as JSON blobs in LMDB.
A global `MUDDB *mud_db` is opened in boris.c and declared extern in muddb.h.

### Domains

A **domain** is a named LMDB database within the environment -- a separate
key-value namespace, analogous to a table in SQL. Each game subsystem uses
its own domain:

| Domain        | Constant           | Consumer     | Key                           |
|---------------|----------------------|--------------|-------------------------------|
| `"users"`     | `DOMAIN_USER`        | user.c       | username                      |
| `"objs"`      | `DOMAIN_OBJS`        | room.c       | `rooms/<id>` (prefixed key)   |
| `"chars"`     | `DOMAIN_CHARACTER`   | character.c  | character id (decimal string) |
| `"entities"`  | `DOMAIN_ENTITY`      | entity.c     | entity id                     |
| `"templates"` | `DOMAIN_TEMPLATE`    | --           | template id                   |

Domain constants are defined in boris.h. Domains are created on first write
(auto-vivify) -- read operations on a missing domain return NULL/empty rather
than an error.

The `objs` domain can alternatively be served by the CAS backend
(`src/obj/obj_cache_cas.c`, selected with `database.backend = cas`); the
other domains always use muddb. See the Configuration section below.

### API

Single-object operations take a domain string and a key:

- `muddb_get(db, domain, key)` -- returns an OBJ parsed from stored JSON,
  or NULL
- `muddb_put(db, domain, key, obj)` -- serializes OBJ to JSON and stores it
- `muddb_del(db, domain, key)` -- removes a key

Read operations (`muddb_get`) use read-only LMDB transactions. Write
operations (`muddb_put`, `muddb_del`) use write transactions serialized
by a pthread mutex.

### Iteration

`muddb_iter` walks all keys in a domain using a read-only LMDB cursor:

```c
MUDDB_ITER *it = muddb_iter_begin(mud_db, DOMAIN_ROOM);
const char *id;

while ((id = muddb_iter_next(it))) {
	/* id is a null-terminated key string, valid until next call */
}

muddb_iter_end(it);
```

`muddb_iter_begin` returns NULL if the domain does not exist (normal on first
run with an empty database). The returned key pointer is valid only until the
next `muddb_iter_next` call (backed by a static buffer). Callers must copy
the key if they need it to persist.

Iteration is used at startup by room.c and character.c for preflight
validation, and by user.c to load the user index.

## Architecture

Boris MUD is a C99 multi-user dungeon server supporting both TELNET and
SSE web clients simultaneously.

### Connection Flow

1. Client connects via TELNET (net_stream) or SSE web client (GET /events)
2. TELNET connections go through MTH protocol negotiation (MSDP, TELOPT)
3. Login state machine: username -> password -> account creation (if new)
   -> main menu
4. Menu/form system drives UI via callback-based state machines
5. Main menu "Enter the game" creates a character, places it in the starting
   room, and enters command mode
6. Command processing dispatches to handlers; broadcast via channel pub/sub

### Key Subsystems

- **Networking**: `src/iox/` -- I/O multiplexing for TELNET connections
- **TELNET protocol**: `src/thirdparty/mth/` -- MTH (Mud Telopt Handler)
  for protocol negotiation
- **MUD Client Protocol**: `src/mcp.c` -- MCP 2.1 out-of-band messages on
  the telnet line stream. Supports the `dns-org-mud-moo-simpleedit`
  package so capable clients edit server text in a local editor
  (used by `@edit` for telnet clients; web clients use the SSE editor)
- **Web server**: `src/web/server/webserver.c` (SSE on net_stream) + client
  assets in `src/web/client/`
- **User management**: `src/user.c` -- accounts, password auth (scrypt/SHA1),
  ref-counted user objects
- **Database**: `src/obj/` (OBJ JSON objects) + `src/database/` (muddb LMDB
  wrapper). Global `mud_db` opened in boris.c
- **Game world**: `src/room/` (rooms), `src/character/` (player characters),
  `src/channel/` (communication channels)
- **Commands**: `src/cmd/cmd.c` -- command dispatch (look, go, enter,
  direction aliases, say, pose, etc.). Characters are associated with
  descriptors via `telnetclient_setcharacter()`
- **Login/Menu/Forms**: `src/login.c`, `src/menu.c`, `src/form.c` --
  state-machine-driven UI layers
- **Logging**: `src/log/eventlog.c` -- subsystem-tagged event logging to
  boris.log
- **Crypto**: `src/crypt/` (SHA1, base64), `src/scrypt/` (key derivation)

### Code Patterns

- **Reference counting**: macro-based `REFCOUNT_GET`/`REFCOUNT_PUT` for
  memory management (see user objects)
- **State machines**: login, menu, and form systems use callback functions
  with state data unions for transitions
- **Attribute lists**: game objects (rooms, characters, users) store
  properties as OBJ JSON objects via muddb; unknown fields preserved in
  extra_values via obj_iter. Room exits use `exit.<dir>` attributes
  (e.g. `exit.n`, `exit.enter`); multiple exits can alias to the same
  destination
- **Channel pub/sub**: in-game communication uses named channels (`@system`,
  `@wiz`, `OOC`, `chat`, etc.) with subscribe/publish

### Third-Party Libraries

In `src/thirdparty/`:
- jsmn (JSON parser, zero-copy)
- lmdb (embedded key-value database)
- mth (MUD Telopt Handler, TELNET protocol)
- tiny-aes (AES-256 block cipher, public domain)

In `src/scrypt/`: scrypt key derivation for password hashing (no upstream
maintainer, maintained in-tree).

In `src/security/`: seccomp and Landlock sandboxing, enabled at startup via
`security_init()`.  Restricts syscalls and filesystem access after
initialization.

### ColdFire Machine Programs

Objects can have ColdFire V4e programs attached that run inside a
ColdFire V4e CPU emulator (`src/coldfire/`). Programs are standard ELF32
big-endian m68k binaries, cross-compiled with `m68k-linux-gnu-gcc`.

**Architecture:**

- `src/coldfire/` -- instruction-level ColdFire V4e emulator.
- `src/machine/machine.c` -- task lifecycle, memory image, fd table, ELF
  loader, hypercall dispatch.
- `src/machine/obj_program.c` -- glue between machine tasks and the game
  loop. A periodic `iox_timer` tick runs each task for up to 4096
  instructions, handles sleep/wake transitions, and re-schedules itself.

**Memory layout** (per task):

| Address       | Contents                                    |
|---------------|---------------------------------------------|
| 0x0000-0x03FF | Exception vector table (all point to halt)  |
| 0x0400        | Halt stub (infinite loop)                   |
| 0x1000+       | Program code and data (loaded from ELF)     |

The linker script (`sdk/machine/lib/machine.ld`) places `.text` at 0x1000 with
explicit `PHDRS` so the LOAD segment starts above the vector table.

**Hypercalls** use LINE_A opcodes (0xAxxx). Arguments are passed in data and
address registers:

| Name        | Opcode | Registers              | Description              |
|-------------|--------|------------------------|--------------------------|
| HC_ABORT    | 0xA000 | --                     | Terminate immediately    |
| HC_YIELD    | 0xA002 | --                     | Yield remaining time     |
| HC_SLEEP    | 0xA003 | d0=ticks               | Sleep for N seconds      |
| HC_EXIT     | 0xA004 | d0=status              | Exit with status code    |
| HC_PRINT    | 0xA005 | d0=len, a0=buf         | Debug print (log only)   |
| HC_MSG_POST | 0xA013 | d0=fd, d1=len, a0=buf  | Post message to room     |

The fd table (`MACHINE_MAX_FILES` entries) maps integer file descriptors to
message callbacks. `obj_program_attach()` opens fd 1 with a callback that
broadcasts to all players in the room.

**SDK** (`sdk/machine/`):

- `include/machine_hc.h` -- inline assembly wrappers for each hypercall,
  using GCC register constraints to place arguments in the correct registers.
- `lib/machine.ld` -- linker script for the machine memory layout.
- `lib/crt0.S` -- CRT startup code with verb registration and dispatch loop.
- `Makefile` -- cross-compiles `.c` files to ELF binaries in `data/machine/`.

To rebuild machine programs:

```sh
cd sdk/machine
make            # builds data/machine/*.elf
make disasm     # disassemble all programs
make clean      # remove objects and ELFs
```

**Attaching to an object** (via obj cache callbacks):

```c
obj_program_attach("rooms/tower-entrance", image_fd,
                   "anim/fountain", 64 * 1024, "exit");
```

Programs are attached automatically when an object with a
`program.continuous` property enters the obj cache. The tick timer
runs each machine task every second.

### Entry Point

`src/boris.c` -- signal handling, config loading, main event loop. Start
reading here, then follow to `src/telnetclient.c` -> `src/user.c` ->
`src/cmd/cmd.c`.

## Configuration

Server configuration is in `boris.cfg`. Key settings:

| Setting              | Default                                  | Description                      |
|----------------------|------------------------------------------|----------------------------------|
| `server.port`        | 4444                                     | TELNET listen port               |
| `webserver.port`     | 8080                                     | Web client listen port           |
| `channels.default`   | `@system,@wiz,OOC,auction,chat,newbie`   | Default communication channels   |
| `eventlog.filename`  | `boris.log`                              | Event log output file            |
| `newuser.allowed`    | 1                                        | Allow new account creation       |
| `newuser.room`       | `tower-entrance`                         | Starting room for new characters |
| `database.backend`   | `muddb`                                  | Object store backend: `muddb` or `cas` |
| `database.cas.path`  | `data/casdb`                             | Depot directory (cas backend)    |
| `database.cas.ref`   | `world`                                  | Snapshot reference name (cas backend) |
| `database.cas.retain` | 0                                       | Keep last N snapshots, 0 = all (cas backend) |
| `database.cas.commit_seconds` | 60                              | Automatic commit interval (cas backend) |

The `database.*` keys select the backend for the `objs` domain only; users,
characters, and invites always use muddb. Admin-facing setup and migration
instructions are in the README under "Object Store Backends". When the cas
backend is selected, the landlock sandbox (`src/security/landlock.c`) adds a
rule for `database.cas.path`; a depot outside the allowlist fails silently,
reading as an empty world.


## GitLab Merge Request Process

Development happens on feature branches merged via GitLab merge requests (MRs).

### Workflow

1. Create a branch from `main` for your work.
2. Make commits on the branch. Reference GitLab work items or issues in commit
   messages using `#<number>` (e.g. `Add room save tests (#12)`). GitLab
   automatically links the commit to the referenced item.
3. Push the branch and open a merge request on GitLab.
4. The MR title should be concise. The description should explain what changed
   and why, and list any work items it addresses.
5. After review, merge into `main`. Use "Delete source branch" to keep the
   branch list clean.

### Commit messages

- Start with a short summary line (imperative mood, under 72 characters).
- Reference the GitLab work item or issue number with `#<number>` so the
  commit appears in the item's activity feed.
- If a commit fully resolves an item, use `Closes #<number>` or
  `Fixes #<number>` in the commit body -- GitLab will close the item
  automatically when the MR merges.

Example:

```
Add room/character load/save round-trip tests (#12)

Unit tests verifying that muddb_put + muddb_get produces identical OBJ
output for rooms and characters.

Closes #12
```

### Version bumps

See work item #13 for the version policy. Any major MR should increment at
least the patch number in `boris.h` (`BORIS_VERSION_PAT`). Multiple MRs
merged in the same cycle share a single bump.

### Kanban board

Work items are tracked as Markdown cards in `kanban/`, one file per card,
versioned with the repository. When you start a card set its `status` to
`active`; when you finish, set it to `done` in the same commit that completes
the work. Card status syncs one-way to GitLab issues via CI. See
[KANBAN.md](KANBAN.md) for the card format, status values, and GitLab sync
details.

[1] https://valgrind.org Valgrind
