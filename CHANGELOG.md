# Changelog

Highlights per tagged version, newest first.

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
