# Changelog

Highlights per tagged version, newest first.

## 2026-11

### v0.8

#### Added

- Builder world history: every accepted builder edit is snapshotted to a
  content-addressed depot, with in-game `@history`, `@undo`, `@redo`,
  `@restore`, `@checkout`, `@publish`, and `@checkpoint` (ACS-gated and
  zone-scoped). Restore is Subversion-style path-copy -- check a zone out to a
  private `zone/scratch/<user>/` area, edit it, and publish back under a
  fork-point guard -- with referential-integrity checks and log retention/GC.
  Object references became a `~`-marked key type (converted by a one-time
  `muddb-tool migrate-refs` pass).
- In-game `@export` (wizard) dumps the live world to `data/export/<timestamp>/`
  in the JSON-record format, over a shared `muddb_export` library that
  `muddb-tool export` also uses.
- OBJ object model: in-memory mutable JSON over a single copy-on-write buffer,
  with prototype walking, containment and owner indexes, and object lifecycle.
- muddb persistence layer on LMDB, serving the `objs`, `users`, `chars`,
  `entities`, and `templates` domains, plus an LRU object cache.
- Guest VM runtime over a new RV32IMA emulator and ELF32 loader, with a verb
  dispatch layer that binds guest programs as object verbs and a resolver that
  maps player commands to objects.
- Guest toolchain and runtime (skjegg), with C and Kobold/Pascal as first-class
  guest languages, built offline to the RV32 ELFs the server loads.
- In-world authoring: CAS-backed 9P server and VFS commands, plus `@compile`,
  `@run`, `@program`, and `@setverb` to build and bind guest programs live.
- OLC builder commands (`@redit`, `@medit`, `@oedit`, `@zedit`, `@check`), a
  UI layer for login, new-user, and main-menu flows, a string editor, and the
  zone/instance namespace for rooms.
- SSE web server on the net_stream layer, with a login overlay, invite codes,
  property editor, ANSI colors, and `@edit`/`@view` commands.
- seccomp-bpf syscall filter and Landlock filesystem sandbox, gated by
  `CONFIG_SECCOMP` and `CONFIG_LANDLOCK`.
- libiox network layer (poll loop, fd watchers, timers, signals) with a TCP
  layer, replacing the previous event library.
- RPG foundation: dice engine, character skills, stat and roll commands, a
  position engine, scene tags, and stress/harm/condition/resist mechanics.
- Combat scheduling over a per-instance phase queue with millisecond deadlines.
- Word wrap with greedy and Knuth-Plass algorithms, integrated into the telnet
  client with NAWS terminal-width sync.
- MCP client-side editing, legacy charset conversion for non-UTF-8 clients,
  `muddb-tool` for database import/export, a sample starter world, and the
  `look`/`go`/`enter` movement commands.
- `ctest.h` unit-test harness and a valgrind leak-check CI job.
- Per-card work tracking in `kanban/`, synced one-way to GitLab issues by CI.

#### Changed

- Reorganized the command subsystem from `src/task` to `src/cmd` and migrated
  the build to the modular-make system.
- Unified room and object storage under a single `objs` domain and converted
  room IDs from numeric to string-based.
- Rebased the guest runtime onto the embedded skjrun scheduler and demoted the
  content-addressed store from a live backend to an offline export format.

#### Removed

- The ColdFire emulator and the earlier stack VM, retired in favor of the RV32
  guest VM.

#### Fixed

- Several use-after-free and double-free crashes in telnet, web, and net-layer
  shutdown and close-during-dispatch paths.
- JSON string escaping in object storage to prevent record corruption, and a
  segfault when iterating over corrupt user records.

## 2020-04

### v0.7

#### Added

- Game clock and `time` command.
- Channel plugin to broadcast messages to groups of clients.
- Webserver request parsing.
- `room.current` and `room.home` attributes.
- Travis CI configuration and a `release-tar` source tarball script.

#### Changed

- Reorganized the project into multiple directories and broke up the
  monolithic `boris.c`, splitting out config, util, debug, sha1, sha1crypt,
  and base64 into their own files.
- Keep Makefile modules in alphabetical order.
- Updated the copyright to a 1-clause BSD license.
- Enabled debugging by default.

#### Removed

- Plugin support, including the chan, char, room, and fdb plugins and the
  plugin loader itself.

#### Fixed

- User registration process.
- Uninitialized variable used in an error path.
- Extra checking in the room code to avoid room 0.
- Printf warnings from `int` and `ptrdiff_t`, plus assorted formatting and
  coding-style cleanups.

## 2009-12

### v0.4

#### Added

- Plugin loading support, starting with the logging plugin.
- Character plugin (`char new` allocates the next entry).
- Room plugin that can load, save, and query rooms.
- fdb database plugin using a file backend, with `write_begin_uint()` and
  `read_begin_uint()` helpers.
- Example plugin to get authors started.
- Linked-list macros in `list.h`, with asserts on the macros.

#### Changed

- Drastically simplified the Makefile.
- Tagged many functions with the `EXPORT` macro.
- Use `.makedep` instead of `.d` for dependency files.
- `config_load()` now dequotes the value part.
- Exported the freelist API.
- Adopted the OSI-approved Ms-RL open source license and updated copyright
  notices.

#### Fixed

- Bug in string escaping.
- Bug in `attr_add()` when copying the value.
- Errors and warnings when `NDEBUG` was not defined.
- Plugin `initialize()` can now report failure.

### v0.3

#### Added

- Version information in the build.
- Copyright and license text.

#### Changed

- Use a table for command parsing.
- Use `strcasecmp()` for commands and config keys.

### v0.2

#### Added

- Initial MUD server with a single-threaded network event loop.
- BSD and WIN32 socket support, including cross-compiling with mingw32.
- TELNET protocol handling: IAC codes, terminal size and type, and echo mode
  control.
- Output buffering, line input, and a menu-driven main menu for users.
- Basic command input handling.
- User accounts with access control strings (acs), access levels, and flags.
- SHA1 password hashing using the OpenLDAP salted SHA format.
- Configuration file system (`config_setup`, `config_watch`, `config_load`,
  `config_free`) with a `-c` option to select the config file.
- Channel system for broadcasting messages.
- Small built-in webserver (default port 8080) that logs GET actions.
- Event log component.
- Hash map, heap priority queue, freelist allocator, and bitmap support
  routines.
- Reference counting for tracking users and client handles.
- DLL and `.so` loading via `dll_open`/`dll_close`/`dll_func` on POSIX and
  Win32.
- Clean shutdown on SIGINT and SIGTERM.

#### Changed

- Switched password crypto from XTEA/teacrypt to SHA1.
- Moved forms and text files into `data/`.
- Store each user in an individual file, replacing sjdb, record, recordcache,
  and BIDB.
- New, more compact makefiles.

#### Fixed

- Numerous warnings on Darwin/OSX and other compilers.
- Winsock2 error handling using `WSAGetLastError()` instead of `errno`.
- Incorrect network code design.
- Printf format warnings.
