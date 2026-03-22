# Developer Guide

Information for developers working on Boris MUD.

## Project Layout

| Directory | Description |
|-----------|-------------|
| src/ | Main source and miscellaneous modules |
| src/obj/ | OBJ -- copy-on-write JSON objects with property iteration |
| src/database/ | muddb -- LMDB persistence layer (OBJ-centric API) |
| src/fdb/ | FDB -- legacy flat-file database (only used by help.c) |
| src/room/ | Room subsystem (load/save/cache with refcount) |
| src/character/ | Character subsystem (load/save/cache with refcount + freelist) |
| src/channel/ | Chat channel pub/sub system |
| src/help/ | Online help system (reads flat files via FDB) |
| src/log/ | Subsystem-tagged logging and event log |
| src/task/ | Command dispatch and processing |
| src/web/server/ | WebSocket server (mongoose) |
| src/crypt/ | SHA1 hash and base-64 encoding |
| src/scrypt/ | scrypt key derivation for password hashing |
| src/passwd/ | Password crypt utility (mkpass) |
| src/util/ | Miscellaneous utility functions |
| src/worldclock/ | In-game time tracking |
| src/thirdparty/ | Third-party libraries (separate licenses) |
| src/thirdparty/dyad/ | Async event-driven networking |
| src/thirdparty/lmdb/ | LMDB embedded key-value database |
| src/thirdparty/jsmn/ | Minimal JSON parser (zero-copy) |
| src/thirdparty/mth/ | MUD Telopt Handler (TELNET protocol) |
| src/thirdparty/mongoose/ | HTTP/WebSocket server |

## Build System

The build uses a plain GNU Makefile with per-directory `module.mk` files. Each `module.mk` appends to three variables:

- `BORIS_SRCS` --source files for the `boris` server binary
- `MKPASS_SRCS` --source files for the `mkpass` password utility
- `INCLUDES` --`-I` flags shared across all compilation units

The top-level Makefile includes all `module.mk` files and compiles everything with a single pattern rule. There are no intermediate static archives --all `.o` files link flat, which avoids circular dependency issues between modules.

Object files go to `build/`, mirroring the source tree. Auto-dependency tracking uses `-MMD -MP`. LTO is enabled automatically if the compiler supports it.

### Adding a new source file

Add it to the appropriate `module.mk` in its directory. If adding a new directory, create a `module.mk` there and add an `include` line in the top-level Makefile.

### Tests

`make tests` builds and runs all test binaries. Test sources and binaries are declared in each module's `module.mk` via `TEST_SRCS` and `TEST_BINS`. Tests use `#include "source.c"` for internal access and print `%%%%%%%%%%%% START-TEST` / `%%%%%%%%%%%% END-TEST` markers.

Current test suites:
- `bin/test_obj` -- OBJ copy-on-write JSON objects (78 tests)
- `bin/test_muddb` -- LMDB persistence layer (29 tests)

## Architecture

Boris MUD is a C99 multi-user dungeon server supporting both TELNET and WebSocket clients simultaneously.

### Connection Flow

1. Client connects via TELNET (dyad async networking) or WebSocket (mongoose HTTP server)
2. TELNET connections go through MTH protocol negotiation (MSDP, TELOPT)
3. Login state machine: username -> password -> account creation (if new) -> main menu
4. Menu/form system drives UI via callback-based state machines
5. Command processing dispatches to handlers; broadcast via channel pub/sub

### Key Subsystems

- **Networking**: `src/thirdparty/dyad/` --async event-driven I/O for TELNET connections
- **TELNET protocol**: `src/thirdparty/mth/` --MTH (Mud Telopt Handler) for protocol negotiation
- **Web server**: `src/web/server/webserver.c` (mongoose) + client assets in `src/web/client/`
- **User management**: `src/user.c` --accounts, password auth (scrypt/SHA1), ref-counted user objects
- **Database**: `src/obj/` (OBJ JSON objects) + `src/database/` (muddb LMDB wrapper). Global `mud_db` opened in boris.c. FDB in `src/fdb/` is legacy, only used by help.c
- **Game world**: `src/room/` (rooms), `src/character/` (player characters), `src/channel/` (communication channels)
- **Commands**: `src/task/command.c` --command dispatch and processing
- **Login/Menu/Forms**: `src/login.c`, `src/menu.c`, `src/form.c` --state-machine-driven UI layers
- **StackVM**: `src/stackvm/` --32-bit word-addressable VM (Quake 3 bytecode style) for game scripting
- **Logging**: `src/log/eventlog.c` --subsystem-tagged event logging to boris.log
- **Crypto**: `src/crypt/` (SHA1, base64), `src/scrypt/` (key derivation)

### Code Patterns

- **Reference counting**: macro-based `REFCOUNT_GET`/`REFCOUNT_PUT` for memory management (see user objects)
- **State machines**: login, menu, and form systems use callback functions with state data unions for transitions
- **Attribute lists**: game objects (rooms, characters, users) store properties as OBJ JSON objects via muddb; unknown fields preserved in extra_values via obj_iter
- **Channel pub/sub**: in-game communication uses named channels (`@system`, `@wiz`, `OOC`, `chat`, etc.) with subscribe/publish

### Third-Party Libraries

All in `src/thirdparty/`: dyad (async networking), lmdb (database), mongoose (HTTP/WebSocket), mth (TELNET), jsmn (JSON parser), scrypt (password hashing).

### Entry Point

`src/boris.c` --signal handling, config loading, main event loop. Start reading here, then follow to `src/telnetclient.c` -> `src/user.c` -> `src/task/command.c`.

## Configuration

Server configuration is in `boris.cfg`. Key settings:

| Setting | Default | Description |
|---------|---------|-------------|
| `server.port` | 4444 | TELNET listen port |
| `webserver.port` | 8080 | Web client listen port |
| `channels.default` | `@system,@wiz,OOC,auction,chat,newbie` | Default communication channels |
| `eventlog.filename` | `boris.log` | Event log output file |
| `newuser.allowed` | 1 | Allow new account creation |
