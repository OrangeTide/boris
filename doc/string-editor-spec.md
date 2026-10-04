# Online String Editor Spec

Design spec for the in-band string editor used to edit text fields from a
terminal. From the `string-editor` kanban card and `doc/ui-layer-spec.md`
(Dependencies). Prerequisite for the UI layer's field editing and the OLC.

Status: agreed, signed off 2026-07-19. Implementation may begin
(`doc/plan.md` section 5).

Scope note (reconciled with `doc/ui-layer-spec.md` 5.1): the editor is the
edit path for **`UI_TEXT`** (long, multi-line) fields. `UI_STRING` fields are
entered with a one-line renderer prompt (already built), not this editor, so
"single-line mode" below is a thin convenience for any caller that wants the
command set on a one-line value; the OLC does not need it in v1.

## 1. Purpose and scope

Every `UI_STRING` and `UI_TEXT` field is edited through this one editor, so
the "keep the old value / clear it / write a new one" question is answered in
one place instead of ad-hoc per field. It works on a dumb TELNET client with
no negotiation, and on a capable client it hands off to the richer
client-side editor that already exists (`@edit`: web SSE editor or MCP
simpleedit). It returns a result to its caller (the UI layer field-edit
state); it does not know about OBJ or fields.

Out of scope: the field model and validation (the UI layer runs `validate`
and `set` on the returned value), and the client-side editors themselves
(already built, `src/cmd/edit.c`, `src/mcp.c`).

## 2. Modes

- **Single-line** (`UI_STRING`). One value, no newlines. The editor shows the
  current value and takes one line of input, with dot-commands for keep,
  clear, and replace.
- **Multi-line** (`UI_TEXT`). A line buffer built until the user ends input.
  Paragraphs are kept as entered; the OBJ stores them as one string with
  `\n`.

## 3. Entry and return contract

The UI layer invokes:

```
void stred_start(DESCRIPTOR_DATA *cl,
                 const char *current,     /* existing value, may be NULL */
                 enum stred_mode mode,    /* single or multi line */
                 void (*done)(DESCRIPTOR_DATA *cl, const char *result,
                              int changed, void *ctx),
                 void *ctx);
```

- `stred_start` takes over line input via `telnetclient_start_lineinput`,
  showing the current value.
- On save it calls `done` with the new `result` and `changed = 1`; on abort
  it calls `done` with the original value and `changed = 0`.
- `done` (the UI layer's callback) runs `validate` then `set`, then restores
  the UI controller's line input and redraws. This is the suspend/resume
  bracket from UI spec section 7.
- The editor allocates nothing the caller must free; `result` is valid only
  during the `done` call.

## 4. Editor commands

Lines beginning with `/` are commands; everything else is content. The prefix
and set follow CircleMUD/tbaMUD, the most widely deployed modern convention
(section 9). Each command has a **short and a long form** and may take
**arguments**, so a new user can type the discoverable `/help` while a regular
gets by with `/h`:

| Short | Long       | Args      | Effect                                     |
|-------|------------|-----------|--------------------------------------------|
| `/s`  | `/save`    |           | Save: finish and return the buffer.        |
| `/a`  | `/abort`   |           | Abort: return unchanged (`changed = 0`).   |
| `/c`  | `/clear`   |           | Clear the buffer to empty.                 |
| `/r`  | `/replace` |           | Replace: discard current, start fresh.     |
| `/l`  | `/list`    |           | List the buffer with line numbers.         |
| `/f`  | `/format`  |           | Format: reflow the buffer (multi-line).    |
| `/h`  | `/help`    | `[topic]` | Help; with a topic, help on that command.  |
| `/d`  | `/delete`  | `<n>`     | Delete line `n` (multi-line only).         |
| `/i`  | `/insert`  | `<n>`     | Insert before line `n` (multi-line only).  |

Parsing: `/` followed by a command word (case-insensitive) and optional
whitespace-separated arguments. The short form is the command's first letter;
any unambiguous prefix of a long form also matches, so `/he`, `/hel`, and
`/help` all reach help. `/h format` (or `/help format`) explains one command.
A content line that must start with a literal `/` is entered as `//` (leading
slash doubled). This is the only escape.

The default on entry is **edit existing**: the current value is loaded and
the user appends or, in single-line mode, replaces by typing. `/c` clears,
`/r` starts over. This is the "edit / clear / replace" behavior the UI layer
delegates here.

## 5. Clear vs empty vs cancel

This is the ambiguity the UI layer explicitly punts to this editor:

- **Keep** the current value: `/s` with no edits (single-line: an empty input
  line means "keep", it does not clear).
- **Clear** to empty: `/c` then `/s`. An empty result is a real value; the UI
  layer's `UI_F_REQUIRED` is what rejects empty on Submit, not the editor.
- **Cancel** the edit: `/a`. The field is unchanged and `changed = 0`, so the
  UI layer does not run `set`.

Defining these three here, once, is the whole reason the OLC depends on the
editor rather than reinventing per field.

## 6. Capability handoff

On entry, if the client can edit out of band, hand off instead of running
the in-band editor, mirroring `@edit` (`src/cmd/edit.c:114-125`):

- `cl->type == CLIENT_TYPE_WEB` with a client context: open the web SSE
  editor (`telnetclient_send_sse(cl, 'E', url)`).
- else if `mcp_simpleedit_ok(cl)`: offer the value over MCP simpleedit
  (`mcp_simpleedit_start`).
- else: run the in-band command editor (section 4).

Either way the result comes back through the same `done` callback, so the UI
layer does not care which path was taken. The handoff is a suspend (UI spec
section 7): the descriptor's line input belongs to the editor until it
returns.

## 7. Testing plan

- **Command parser.** Each command in isolation: save, abort, clear,
  replace, list, delete-line, insert-line, format, help, and the `//` escape.
- **Clear vs empty vs cancel.** `/c`+`/s` yields empty and `changed = 1`;
  `/a` yields the original and `changed = 0`; `/s` with no edit keeps the
  value.
- **Multi-line assembly.** Lines join with `\n`; delete-line renumbers.
- **Return contract.** `done` fires exactly once with the right `changed`
  flag; line input is restored afterward.
- Handoff selection is unit-tested with a mock client type; the client-side
  editors themselves are already covered (`test_mcp`).
- Wired into `module.mk` for CI (`ci-test-coverage` card).

## 8. Resolved

- **The editor is the `UI_TEXT` (multi-line) edit path;** `UI_STRING` uses the
  renderer's one-line prompt (scope note above). Single-line mode stays in the
  API as a convenience but is not on the OLC v1 path.
- **Keep both `/r` and `/c`.** `/r` (replace: clear and start fresh) is a
  common shortcut and reads more clearly than `/c` then retyping.

## 8.1 Deferred

- **Capability handoff (section 6) is a follow-up.** v1 ships the in-band
  command editor for every client; the web-SSE / MCP-simpleedit handoff (which
  `@edit` already implements) is wired in after the in-band editor and its
  tests land, behind the same `done` contract so nothing above changes.

## 9. Convention research

Surveyed the major MUD codebases to choose the prefix and command set. There
is no single interactive-editor convention; the split is:

| Codebase           | Prefix | Save | Abort | Notes |
|--------------------|--------|------|-------|-------|
| CircleMUD / tbaMUD | `/`    | `/s` | `/c`  | `/d /l /i /r /a /f /h`; most deployed |
| SMAUG / AFKMud     | `.`    | `@`  | `.a`  | `.f .h .ld .li .lr`; `@` line saves |
| ROM 2.4 / Merc     | words  | DONE | DONE  | `~` terminates strings in area files |
| DikuMUD (original) | n/a    | n/a  | n/a   | `~` string terminator |
| LPMud / Discworld  | menu   | `S`  | `Q`   | `I/D/L/M/C/E/S/Q/H`; `**` ends input |

**Decision: the `/` prefix and the CircleMUD command set.** It is the most
widely deployed modern convention, the most discoverable (players try
`/help`), and it separates commands from content cleanly, avoiding the `~`
terminator's "how do I finish" confusion. The `.` prefix (SMAUG/AFKMud) is the
close alternative and was the first instinct; it is a one-line change here if
preferred. The `~` terminator is rejected as a per-line-content hazard.

Sources: tbaMUD `lib/text/help/help.hlp`; Merc/ROM `doc/area.txt` and
`area/olc.hlp`; SMAUG `doc/area.txt`; DikuMUD source (Seifert69/DikuMUD);
Discworld `/concepts/editor` documentation.
