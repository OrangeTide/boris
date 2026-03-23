# Developer Guide

Information for developers working on Boris MUD.

## Project Layout

| Directory              | Description                                              |
|------------------------|----------------------------------------------------------|
| src/                   | Main source and miscellaneous modules                    |
| src/obj/               | OBJ -- mutable JSON objects with property iteration      |
| src/database/          | muddb -- LMDB persistence layer (OBJ-centric API)       |
| src/room/              | Room subsystem (load/save/cache with refcount)           |
| src/character/         | Character subsystem (load/save/cache with refcount + freelist) |
| src/channel/           | Chat channel pub/sub system                              |
| src/help/              | Online help system (reads plain text from data/help/)    |
| src/log/               | Subsystem-tagged logging and event log                   |
| src/task/              | Command dispatch and processing                          |
| src/web/server/        | WebSocket server (mongoose)                              |
| src/crypt/             | SHA1 hash and base-64 encoding                           |
| src/scrypt/            | scrypt key derivation for password hashing               |
| src/passwd/            | Password crypt utility (mkpass)                          |
| src/util/              | Miscellaneous utility functions                          |
| src/worldclock/        | In-game time tracking                                    |
| src/thirdparty/        | Third-party libraries (separate licenses)                |
| src/thirdparty/dyad/   | Async event-driven networking                            |
| src/thirdparty/lmdb/   | LMDB embedded key-value database                         |
| src/thirdparty/jsmn/   | Minimal JSON parser (zero-copy)                          |
| src/thirdparty/mth/    | MUD Telopt Handler (TELNET protocol)                     |
| src/thirdparty/mongoose/| HTTP/WebSocket server                                   |
| src/thirdparty/tiny-aes/| AES-256 block cipher (public domain, Unlicense)         |

## Build System

The build uses a plain GNU Makefile with per-directory `module.mk` files.
Each `module.mk` appends to three variables:

- `BORIS_SRCS` -- source files for the `boris` server binary
- `MKPASS_SRCS` -- source files for the `mkpass` password utility
- `INCLUDES` -- `-I` flags shared across all compilation units

The top-level Makefile includes all `module.mk` files and compiles everything
with a single pattern rule. There are no intermediate static archives -- all
`.o` files link flat, which avoids circular dependency issues between modules.

Object files go to `build/<triplet>/`, mirroring the source tree. The triplet
is derived from `$(CC) -dumpmachine` (e.g. `build/x86_64-linux-gnu/`), so
cross-compiled object files don't clobber native ones. Binaries go to `bin/`.
Auto-dependency tracking uses `-MMD -MP`. LTO is enabled automatically if the
compiler supports it.

### Adding a new source file

Add it to the appropriate `module.mk` in its directory. If adding a new
directory, create a `module.mk` there and add an `include` line in the
top-level Makefile.

### Tests

`make tests` builds and runs all test binaries. Test sources and binaries are
declared in each module's `module.mk` via `TEST_SRCS` and `TEST_BINS`. Tests
use `#include "source.c"` for internal access and print
`%%%%%%%%%%%% START-TEST` / `%%%%%%%%%%%% END-TEST` markers.

Current test suites:
- `bin/test_obj` -- OBJ mutable JSON objects (77 tests)
- `bin/test_muddb` -- LMDB persistence layer (39 tests)
- `bin/test_hashtable` -- hash table (uint and string keyed) (58 tests)

`make smoke` starts the server in a temporary directory and exercises telnet
login flows via expect. Requires `expect` (`apt install expect` on
Debian/Ubuntu, `apk add expect` on Alpine). Test cases: connect and quit,
bad credentials rejection, new user creation and login.

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

| Domain     | Constant           | Consumer     | Key                        |
|------------|--------------------|--------------|----------------------------|
| `"users"`  | `DOMAIN_USER`      | user.c       | username                   |
| `"rooms"`  | `DOMAIN_ROOM`      | room.c       | room id (decimal string)   |
| `"chars"`  | `DOMAIN_CHARACTER` | character.c  | character id (decimal string) |

Domain constants are defined in boris.h. Domains are created on first write
(auto-vivify) -- read operations on a missing domain return NULL/empty rather
than an error.

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
WebSocket clients simultaneously.

### Connection Flow

1. Client connects via TELNET (dyad) or WebSocket (mongoose)
2. TELNET connections go through MTH protocol negotiation (MSDP, TELOPT)
3. Login state machine: username -> password -> account creation (if new)
   -> main menu
4. Menu/form system drives UI via callback-based state machines
5. Command processing dispatches to handlers; broadcast via channel pub/sub

### Key Subsystems

- **Networking**: `src/thirdparty/dyad/` -- async event-driven I/O for
  TELNET connections
- **TELNET protocol**: `src/thirdparty/mth/` -- MTH (Mud Telopt Handler)
  for protocol negotiation
- **Web server**: `src/web/server/webserver.c` (mongoose) + client assets
  in `src/web/client/`
- **User management**: `src/user.c` -- accounts, password auth (scrypt/SHA1),
  ref-counted user objects
- **Database**: `src/obj/` (OBJ JSON objects) + `src/database/` (muddb LMDB
  wrapper). Global `mud_db` opened in boris.c
- **Game world**: `src/room/` (rooms), `src/character/` (player characters),
  `src/channel/` (communication channels)
- **Commands**: `src/task/command.c` -- command dispatch and processing
- **Login/Menu/Forms**: `src/login.c`, `src/menu.c`, `src/form.c` --
  state-machine-driven UI layers
- **StackVM**: `src/stackvm/` -- 32-bit word-addressable VM (Quake 3 bytecode
  style) for game scripting
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
  extra_values via obj_iter
- **Channel pub/sub**: in-game communication uses named channels (`@system`,
  `@wiz`, `OOC`, `chat`, etc.) with subscribe/publish

### Third-Party Libraries

All in `src/thirdparty/`:
- dyad (async networking)
- lmdb (database)
- mongoose (HTTP/WebSocket)
- mth (TELNET)
- jsmn (JSON parser)
- tiny-AES-c (AES-256 block cipher)
- scrypt (password hashing)

### Entry Point

`src/boris.c` -- signal handling, config loading, main event loop. Start
reading here, then follow to `src/telnetclient.c` -> `src/user.c` ->
`src/task/command.c`.

## Configuration

Server configuration is in `boris.cfg`. Key settings:

| Setting              | Default                                  | Description                    |
|----------------------|------------------------------------------|--------------------------------|
| `server.port`        | 4444                                     | TELNET listen port             |
| `webserver.port`     | 8080                                     | Web client listen port         |
| `channels.default`   | `@system,@wiz,OOC,auction,chat,newbie`   | Default communication channels |
| `eventlog.filename`  | `boris.log`                              | Event log output file          |
| `newuser.allowed`    | 1                                        | Allow new account creation     |
