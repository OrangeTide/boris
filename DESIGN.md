# Design and Architecture

## Core Components

### Session Environment

Holds environment non-persistent variables mutable by the current program.

### Programs

Executable object and persistent data file. An API for reading and writint persistent data is provided to the runtime.

### Offline Compiling

Provide an offline process of generating an executable for every source file in the database.

## Session flow

 * new connection arrives.
 * if IP checks fail, disconnect.
 * initialize environment. (PEERADDRESS, CONNECTTIMESTAMP, TERM, COLUMNS, LINES, ...)
 * run Login process.
 * set process timeout - disconnects on timeout.
 * if Login failed, disconnect.
 * if Login requests new user account, leave Login process, enter AccountRequest process.
 * if Login successful, leave Login process, enter Game process.

# See Also

## Pending Further Investigation

 * [SQLcipher](https://github.com/sqlcipher/sqlcipher)

