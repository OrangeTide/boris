# Web Client Architecture

## Overview

The web client uses Server-Sent Events (SSE) for server-to-client streaming
and plain HTTP POST for client-to-server commands. This replaces WebSocket
with a simpler protocol that needs no framing library and works through
HTTP proxies.

## Transport

### SSE stream: GET /events

Server pushes events as `data:` lines with a single-character command prefix.
Multi-line messages are split across multiple `data:` lines within the same
event (SSE reassembles them on the client side).

#### Framing protocol (smolmoo-style)

The first character of each `data:` line determines message type:

| Range   | Category          | Description                              |
|---------|-------------------|------------------------------------------|
| `A`-`Z` | Server commands   | Client MUST parse. Unknown = bug/error   |
| `a`-`z` | Terminal messages  | Display in the game terminal              |
| `0`-`9` | Status line        | Reserved for status updates (ignore now) |
| `+`     | Input enabled     | Enable the input field, user is connected |
| `-`     | Input disabled    | Disable the input field                   |
| `=`     | Status line       | Status line text (ignored for now)        |
| `!`     | Alert             | Display in red                            |
| `^`     | Reload            | Client should reload the page             |
| `_`     | Idle/ticket       | Keepalive, ignore                         |

Currently defined server commands (`A`-`Z`):

| Prefix | Meaning         | Payload example                   |
|--------|-----------------|-----------------------------------|
| `I`    | session ID      | `I7a3f...` (32-char hex token)    |

Future server commands (not yet implemented):

| Prefix | Meaning         | Payload example               |
|--------|-----------------|-------------------------------|
| `O`    | open URL        | `O/edit?obj=123&prop=desc`    |
| `W`    | watch-notify    | `W123.desc.42` (obj.prop.gen) |

The browser's `EventSource` handles reconnection automatically.

#### SSE wire format

Single-line message:
```
data: mYou are in the town square\n\n
```

Multi-line message (newlines within the message produce separate `data:` lines,
all part of the same event -- the final line gets the double-newline terminator):
```
data: mFirst line\n
data: mSecond line\n\n
```

### Commands: POST /cmd

Client sends commands as `SESSION command` in the POST body (session token,
space, command text). The session token is the 32-character hex string
received via the `I` server command. One HTTP request per user command.
Negligible overhead for a MUD.

### Static files: GET /

Serves `index.html` and assets (CSS, fonts, icons) from `./bin/www/`.
Path traversal is rejected (any path containing `..` returns 403).

## Authentication

Session tokens are generated server-side from 16 bytes of /dev/urandom,
hex-encoded to 32 characters. The token is sent to the client via the `I`
SSE command immediately after the EventSource connection is established.
The client includes this token in POST /cmd requests.

Login is handled in-band through the terminal (same as telnet). A
dedicated login page is deferred to a later phase.

## Terminal Page

The main page is a text-based MUD client. It opens an SSE connection to
`/events`, displays terminal messages (`a`-`z` prefixed), and sends user
input via POST to `/cmd` with the session token.

The `+` and `-` commands control whether the input field is enabled (the
server sends `+` when the client is ready to accept commands, `-` during
login prompts or when input should be suppressed).

## Editor Tab

Opened via the `o` SSE command (e.g., `o/edit?obj=123&prop=desc`).

### Lifecycle

1. GET `/edit?obj=123&prop=desc&sid=TOKEN` -- serves the editor page.
2. Editor fetches content: GET `/api/prop?obj=123&prop=desc&sid=TOKEN`
   -- returns `{ "content": "...", "gen": N }`.
3. User edits client-side (undo/redo are local operations).
4. Save: POST `/api/prop` with `{ "obj": 123, "prop": "desc",
   "content": "...", "gen": N, "sid": "TOKEN" }`.
   - If `gen` matches, save succeeds, server returns new gen.
   - If `gen` doesn't match, server returns 409 with current content.
     Client shows both versions for manual resolution.

### Cross-Tab Watch Notifications

The terminal tab relays `w` (watch-notify) SSE events to editor tabs
via `BroadcastChannel("boris")`:

```
Terminal tab (SSE handler):
  bc.postMessage({ type: "watch", obj: 123, prop: "desc", gen: 42 });

Editor tab (status line):
  bc.onmessage = (e) => {
      if (e.data.obj === myObj && e.data.prop === myProp)
          show "stale" warning in status bar
  };
```

This is advisory. The save-time generation check is the real safety net.
If the terminal tab closes or reconnects, the editor tab goes deaf but
still has the gen-check on save.

No second SSE connection per editor tab. No SharedWorker.
BroadcastChannel is supported in all current browsers.

### Conflict Resolution

v1: on 409, show "your version" and "server version" side by side, let
the user pick one.

Future: a JS diff library (e.g., diff-match-patch, ~50KB) could show a
visual three-way diff. Real collaborative merge is out of scope.

## Server Implementation

The server is a single-threaded `select()` loop, matching the existing
telnet connection model. No threads, no producer-consumer queues, no
external HTTP library.

HTTP parsing is minimal: extract method, path, headers, and body for
three endpoints (`/events`, `/cmd`, `/api/prop`) plus static file serving.

Based on the approach proven in smolmoo.c.

## TLS

TLS wraps the transport layer, below both HTTP and telnet. A shared
connection wrapper that holds either a raw fd or a TLS context, with
`conn_read()`/`conn_write()` dispatching accordingly, gives TLS to both
protocols for the cost of one implementation. HTTPS for the web client
and TELNETS (port 992, or STARTTLS) for MUD clients use the same layer.

Candidate libraries: BearSSL or LibreSSL (small, embeddable).
Estimated size: ~100-150 lines for the wrapper.
