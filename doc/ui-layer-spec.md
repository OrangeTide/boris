# Interactive UI Layer Spec

Design spec for the rebuilt interactive UI layer that replaces `src/menu.c`
and `src/form.c`. This is the deliverable named in the `ui-layer-rebuild`
kanban card and `doc/plan.md` Phase 2. It is the foundation the menu OLC
(`@redit`/`@oedit`/`@medit`) is built on.

Status: agreed, signed off 2026-07-18. Implementation may begin
(`doc/plan.md` section 5).

## 1. Purpose and scope

Provide one per-session, data-driven UI layer that renders the same
abstract screen model to plain TELNET, MXP, and the web/SSE client. It
serves three surfaces:

1. The login menu and new-user application (ported off `menu.c`/`form.c`).
2. The builder OLC editors (rooms first, then items and NPCs).
3. Any future in-game menu or form.

Out of scope: the OLC field sets themselves (see `doc/olc-spec.md`), the
zone model (`doc/zone-spec.md`), and GMCP rendering (a later add).

## 2. Goals and non-goals

Goals:

- One screen model authored once, rendered per client capability.
- A typed field model bound to either a fixed C struct or an OBJ.
- A per-session navigation stack with clean back/cancel.
- Deterministic input dispatch shared by every screen (section 6).
- Explicit lifecycle including free-on-disconnect and suspend/resume.
- Minimal allocation, following the single-buffer preference used
  elsewhere in the tree.

Non-goals:

- No general layout engine. Screens are a title, a field list, and an
  action set. Rendering is linear.
- No client-side scripting. The web renderer draws native HTML from a
  server-sent spec; it does not run app logic.
- No backward-compatible shim for the old `menu.c`/`form.c` ABI. Callers
  are ported (section 10).

## 3. What is being replaced

`menu.c` and `form.c` are login-era callback state machines. Their limits
are documented in `doc/plan.md` section 3a: a type-unsafe
`(void*, long, void*)` action ABI, global single-instance state, display
and selection numbering that can desync, unchecked allocations, and no
nesting, cancel, context, or suspend. The rebuild addresses each of these
by construction rather than patching them in place.

## 4. Architecture

Three separated concerns:

- **Model.** `ui_field`, `ui_frame`, and `ui_session` describe what a
  screen contains. No I/O. Testable without a client.
- **Controller.** Owns the frame stack, runs the input contract, drives
  the lifecycle, and calls back into field accessors. No I/O of its own;
  it asks the renderer to draw and to prompt.
- **Renderer.** A vtable (`ui_renderer`) that turns a frame into output
  for one transport and reports raw input lines back to the controller.
  One implementation per client capability.

Proposed module: `src/ui/` with `ui.h`, `ui.c` (model + controller),
`ui_render_text.c`, `ui_render_mxp.c`, `ui_render_web.c`. Names are a
proposal; the review may rename.

## 5. Core data model

### 5.1 Value types

```
enum ui_type {
    UI_STRING,      /* short single-line text */
    UI_INT,         /* signed integer, optional min/max */
    UI_BOOL,        /* yes/no toggle */
    UI_ENUM,        /* one of a fixed, named set of choices */
    UI_OBJREF,      /* reference to an object id (e.g. a room) */
    UI_TEXT,        /* long multi-line text; edited out of band */
    UI_SUBFRAME,    /* selecting it pushes a child frame */
};
```

String editing splits by field type, so simple screens do not depend on the
rich editor:

- **`UI_STRING`** (short single line) is entered with a plain one-line prompt
  (`enter_field`, section 8). A `UI_F_HIDDEN` string is prompted with echo
  off and no editor, which is what login passwords need. The value replaces
  the field; there is no `.`-command edit-existing on a short field.
- **`UI_TEXT`** (long, multi-line) is edited through the online string editor
  (see Dependencies), which owns "edit existing / clear / replace" via its
  `.` commands. On a capable client it may hand off to the existing `@edit`
  path (web SSE editor or MCP simpleedit); that handoff suspends the session
  and resumes on return (section 7).

Consequently the online string editor is a prerequisite only for `UI_TEXT`
(the OLC long descriptions), not for the login and new-user port, which uses
only `UI_STRING`. This matches `doc/olc-spec.md` 5.7.2, which already prompts
`UI_STRING` inline and reserves the editor for `UI_TEXT`.

`UI_SUBFRAME` is how nesting is declared (for example, a room's exit list
opens a child frame). The child is built by a callback when the field is
selected, so child content can depend on live state.

### 5.2 Field descriptor

```
struct ui_field {
    const char *label;          /* shown to the user */
    const char *key;            /* stable id: struct member or OBJ prop */
    enum ui_type type;
    unsigned flags;             /* UI_F_HIDDEN, UI_F_READONLY, ... */

    /* backing-store accessors; ctx is the frame's binding (5.4).
     * get() copies into buf and returns the length written, or -1.
     * set() returns 0 on success, -1 on failure; NULL if readonly. */
    int  (*get)(void *ctx, const char *key, char *buf, size_t buflen);
    int  (*set)(void *ctx, const char *key, const char *value);

    /* UI_ENUM only: choice list */
    const char *const *choices;
    unsigned nr_choices;

    /* optional validation, run before set(); returns 0 on ok */
    int  (*validate)(void *ctx, const char *value, const char **err);

    /* UI_SUBFRAME only: build the child frame on demand */
    struct ui_frame *(*open_child)(struct ui_session *s, void *ctx);
};
```

`label` is display text ("Short description"); `key` is the stable
identifier the accessors use (a struct member name, or a dotted OBJ prop
like `desc.short`). Keeping them separate lets one generic pair of OBJ
accessors serve every field rather than a bespoke closure per field.

Field flags:

- `UI_F_HIDDEN` renders the value as `<hidden>` (passwords).
- `UI_F_READONLY` shows the value but offers no edit; `set` is NULL.
- `UI_F_REQUIRED` blocks Submit while empty.

The `get`/`set` split, keyed by `key`, is what makes the model bindable to
different backing stores without the model knowing which (section 5.4).
`set` bounds the value length to a fixed maximum (`UI_VALUE_MAX`); input
from a client is never trusted to be short.

### 5.3 Frame

A frame is one screen.

```
struct ui_frame {
    const char *title;
    struct ui_field *fields;    /* array */
    unsigned nr_fields;
    unsigned action_mask;       /* which universal actions are enabled */
    void *binding;              /* passed as ctx to field accessors */

    /* on_submit returns 0 to accept (frame pops) or -1 to stay
     * (validation/save failed; the error is already shown). */
    int  (*on_submit)(struct ui_session *s, void *binding);
    void (*on_cancel)(struct ui_session *s, void *binding);

    /* frees anything this frame owns (fields, binding, scratch OBJ);
     * NULL for a frame that owns nothing. Called by the session on pop
     * and on teardown. */
    void (*free)(struct ui_frame *f);
};
```

`action_mask` is a bitset over the reserved universal actions (section 6),
so a leaf edit frame can disable, for example, `List`, while a top menu
disables `Submit`.

**Ownership.** Every frame is owned by the `ui_session`, which is owned by
the connection. Frames are never shared between connections. There are no
global static frames; even the login and new-user frames are built per
connection when it enters that state and are freed when the session tears
down. The session frees each frame through its `free` hook on pop and frees
the whole stack on teardown (section 7). A frame that builds its own
`fields` array or holds a scratch OBJ frees them in `free`; a frame pointing
at static `const` field templates sets `free` to NULL.

`on_submit` returning -1 keeps the frame open, so a `builder_save()` that
rejects a duplicate id or an unresolved exit does not lose the edit.

### 5.4 Backing-store binding

The `binding` pointer is opaque to the model and passed to every accessor
as `ctx`. Two standard bindings ship:

- **Struct binding.** `binding` points at a C struct; each field's
  `get`/`set` reads and writes the member named by `key`. Used by login and
  the new-user application.
- **OBJ binding.** `binding` points at:

  ```
  struct ui_obj_binding {
      OBJ *scratch;           /* the working copy the user edits */
      OBJ *baseline;          /* source for Undo; NULL when creating new */
      const char *prefix;     /* prepended to each field key */
      const char *commit_key; /* target (domain/key) for builder_save() */
  };
  ```

  `get`/`set` call `obj_prop_get`/`obj_prop_set` on `scratch` using
  `prefix + field.key`. Editing never touches the live object. On Submit,
  `on_submit` calls `builder_save` (now built, `src/builder/`) through the
  zone-aware ops (`builder_zone_ops`), which enforce the Builder flag, the
  zone allow-list, and `creator` stamping. The actor's `acs_info` and name
  come from the session's descriptor; the create-vs-edit distinction is
  `baseline == NULL` (create) so `builder_save`'s `is_create` follows it. On
  Cancel the scratch is dropped; Undo of one field re-copies that prop from
  `baseline` (or removes it when `baseline` lacks it or is NULL).

### 5.4.1 The scratch OBJ

The working copy is a **scratch OBJ**: an OBJ with no live database key, so
edits are isolated until commit. Two lifetimes:

- **Ephemeral** (default). Created in memory, seeded from the live object
  (edit) or empty/from a template (create), and destroyed when the frame
  pops or the connection drops. This is exactly what `obj_new` already
  produces: a detached OBJ with no store key, not registered until an
  explicit commit. `@dig` / `room_create` already build and edit such a
  scratch, so the ephemeral case needs no new constructor.
- **Account-scratch** (opt-in, resumable). Persisted in a scratch area under
  the player's account so an interrupted edit survives a disconnect and can
  be resumed on reconnect. The exact storage key is left to the muddb/zone
  specs; the UI layer only needs "give me the scratch for this edit" and
  "commit it" / "discard it".

The same scratch OBJ also serves new-object creation: it collects the
parameters as fields are filled, and `builder_save()` turns it into a live
object on Submit.

New backings (a file, an external service) are added by writing accessor
functions; the model and renderers do not change.

### 5.4.2 Account-scratch storage (proposed, deferred)

Account-scratch is not built in v1, but fixing its mechanism now keeps the
ephemeral path forward-compatible and answers the open question in section 13.

**Location.** Drafts live under a reserved top-level key prefix `scratch/` in
the `objs` domain, keyed `scratch/<username>/<commit_key>`. `scratch/` is a
fourth namespace category beside `zone/` (instances), `templates/` (classes),
and `olc/` (starters) (`doc/olc-spec.md` 3.2), config-driven
(`olc.scratch.base`). Because only `zone/` marks a game instance, a draft is
never resolved by `room_get` / `zone_resolve` and never leaks into the world.
Keying by the target gives a 1:1 map: the draft for `@redit zone/world/closet`
by builder `rhea` is `scratch/rhea/zone/world/closet`. Several concurrent
drafts are several such keys, which is how the "several named contexts later"
growth (5.6) lands with no model change.

**What is stored.** The draft *is* the scratch OBJ (the working copy), so it
reuses `obj_new` / `obj_put` / `obj_get` / `obj_delete` unchanged. Edit-context
metadata rides as protected props (written with `obj_prop_set_internal`, so a
builder never edits them):

- `%draft.target` -- the commit_key the draft saves to.
- `%draft.baseline` -- the live object key the Undo baseline came from, or
  empty for a create.
- `%draft.updated` -- last-write timestamp, for staleness sweeps.

**Mechanism.**

- *Open (opt-in):* if `scratch/<user>/<key>` exists, offer resume (5.6);
  otherwise create it, seeded from the live object (edit) or a template
  (create).
- *Persist:* written through with `obj_put` on leave/suspend (and optionally
  a checkpoint on each field `set`), so a disconnect loses nothing.
- *Submit:* `builder_save` commits the scratch to the live object, then the
  draft is deleted (`obj_delete scratch/<user>/<key>`).
- *Discard:* deletes the draft.
- *Sweep:* stale drafts are reclaimed by `%draft.updated` age; an account's
  drafts (`scratch/<user>/...`) are removed with the account.

**Resume UX.** On reconnect, or on re-entering the editor on the same target,
the builder is offered the draft: "You have an unsaved draft of <target> from
<time>. Resume? [Y/n]." Declining keeps the draft; only Submit, Discard, or
the staleness sweep drops it.

**Backend note.** Deletion uses `obj_delete`, which the muddb backend
supports; on the CAS backend (no key removal yet) a superseded draft is
overwritten and swept later rather than removed immediately -- the same
limitation as `@destroy`.

**Alternative considered.** A separate muddb domain (`scratch` / `drafts`)
would isolate drafts from the world store and allow independent retention, at
the cost of a second obj cache or direct muddb access. The
`scratch/`-prefix-in-`objs` proposal is preferred: it reuses the existing obj
facade and the category-first namespace with no new infrastructure.

### 5.5 Session

```
struct ui_session {
    struct ui_frame *stack[UI_MAX_DEPTH];  /* navigation stack, session-owned */
    unsigned depth;
    unsigned cursor;            /* field being edited in top frame */
    int dirty;                  /* staged, uncommitted edits exist */
    const struct ui_renderer *renderer;
    void *render_ctx;
    enum ui_mode mode;          /* browsing | editing | suspended */

    /* where to return the descriptor when the last frame pops */
    void (*on_close)(DESCRIPTOR_DATA *cl);

    DESCRIPTOR_DATA *cl;
};
```

One `ui_session` is owned per descriptor. It replaces the current
`telnetclient_set_menu` / `telnetclient_set_form` slots with a single
`telnetclient_set_ui` slot (section 10). `UI_MAX_DEPTH` is 10, a small fixed
bound so the stack is a plain array, no heap growth.

`on_close` is captured at `ui_open` and re-installs the descriptor's prior
line input when the session ends. There is no automatic handler stack in
`telnetclient` (confirmed: `telnetclient_start_lineinput` just replaces the
handler), so the caller states the return explicitly. For a builder who ran
`@redit` from the game loop it re-installs `command_lineinput`; for login it
advances to the game.

`dirty` is set on the first staged edit and drives the prompt: rows show the
staged value, not the original, so a builder always sees the edit in
progress.

### 5.6 Edit context lifetime

An OBJ edit (its scratch, baseline, and dirty state) is an **edit context**
owned by the connection, not by a single `ui_session`. Leaving the editor
does not discard it:

- **Leaving** (Quit from an edit frame) suspends the editor and returns to
  the game while the ephemeral edit context stays alive on the connection.
  Re-entering (`@redit <same id>`) resumes the same staged edits.
- **Ephemeral edits stick for the life of the connection.** A disconnect
  frees them (until account-scratch resume lands, 5.4.1); nothing short of
  disconnect, an explicit Discard, or Submit drops them.
- **Discard** (an explicit, confirmed action) runs `on_cancel`, drops the
  scratch, and ends the context. **Submit** commits and ends it.

There is **one edit context per connection** for now, so opening a second
edit while one is live either resumes or refuses. The context lives on the
connection precisely so this can grow to several named contexts later without
reworking the frame model.

## 6. Input contract (two-namespace model)

Every screen splits input into two non-overlapping key spaces. This is the
decision recorded in `doc/plan.md` section 4.

- **Numbers `1`..`N`** select a positional, variable choice the current
  screen offers: a field to edit, an enumerated `UI_ENUM` option, or an
  item in a `UI_SUBFRAME` list. Numbering is always contiguous over the
  visible, selectable rows.
- **Letters and symbols** are fixed, universal actions, identical on every
  screen. Reserved set:

  | Key | Action    | Meaning                                  |
  |-----|-----------|------------------------------------------|
  | `N` | Next      | wizard: next step; paged list: next page  |
  | `P` | Previous  | wizard: previous step; paged list: prev page |
  | `S` | Submit    | validate all, run `on_submit`, commit, end context |
  | `U` | Undo      | revert the current field's staged edit    |
  | `R` | Refresh   | redraw the current frame                  |
  | `L` | List      | present a set of choices to pick from      |
  | `Q` | Quit      | leave the editor, keeping the edit context alive (5.6) |
  | `X` | Discard   | confirmed: drop staged edits, end the context |
  | `?` | Help      | show help for the current frame/field     |

  `Q` and `X` differ deliberately, and both are kept: `Q` leaves without
  losing work (the edit context persists on the connection, 5.6), while `X`
  discards it behind a confirm prompt. On a plain menu with no edit context,
  `Q` just closes and `X` is not offered.

  **`List` versus `Next`/`Previous`** are different tools:

  - `Next`/`Previous` walk a **wizard**: a fixed sequence of steps, so a
    builder can go back and revisit an earlier choice before Submit.
  - `List` **presents a set to choose from** (a dynamic or generated list,
    for example a color picker or the exit-direction set). When the set is
    larger than the **page size of 10**, it paginates, and there
    `Next`/`Previous` move between pages. OLC field lists are short and are
    not paged in v1; only generated lists page.

  A list is chosen from by number (the two-namespace model); the wizard is
  navigated by these actions.

  The set is extensible; new actions take an unused letter or symbol.

Dispatch algorithm for a raw input line, in browsing mode:

1. Trim leading spaces.
2. If the first token parses as a positive integer `k`, it selects the
   `k`-th visible selectable row. Out of range is an error, redraw.
   - If text follows the number (`"2 cave"`), it is an **inline value**:
     set row `k` directly to that value (through validate/set). This is
     how the web client and power users edit in one line.
   - If nothing follows (`"2"`), **enter** row `k`: a string field opens
     the string editor, an enum opens its numbered choice list, a bool
     toggles, a subframe pushes its child.
3. Otherwise lowercase the first character; if it is an enabled reserved
   action (present in `action_mask`), run it.
4. Otherwise it is invalid input; show the invalid-selection message and
   redraw.

The single `N [value]` grammar makes the terminal two-step ("2" then a
value) and the web one-line post ("2 cave") reach the same `set` on the
server, so the two clients are genuinely dispatched identically.

Because selectable choices are always digits and actions are always
alpha/symbol, the two never collide, and an enumerated choice is never
assigned a reserved letter. A single prompt can therefore offer both at
once (for example, a field list with `[N]ext [S]ubmit [Q]uit` on the
action line and `1..N` for the fields).

## 7. Lifecycle

`ui_mode` states:

- **browsing.** The top frame is shown; input selects a row or runs an
  action (section 6).
- **editing.** A single field is being entered. What "editing" means
  depends on the field type:
  - `UI_STRING`: a one-line prompt (`enter_field`); the entered line runs
    through `validate` then `set`, replacing the value. A `UI_F_HIDDEN`
    string prompts with echo off. An empty line leaves the field unchanged.
  - `UI_TEXT`: control passes to the online string editor, whose `.`
    commands decide edit-existing (default), clear, or replace; on return the
    result runs through `validate` then `set`. Aborting inside the editor
    leaves the field unchanged. The editor, not this layer, defines
    empty-vs-clear, so it is a dependency for `UI_TEXT`.
  - `UI_ENUM`: a numbered choice sub-view is shown; a digit picks a choice,
    `Q` returns without changing the field.
  - `UI_BOOL`: selecting it toggles and returns to browsing; no sub-view.
  - `UI_OBJREF`: entered as a string (an id), validated for existence.
  On a valid value, `set` runs and control returns to browsing; on
  validation failure the field is unchanged and the error is shown.
- **suspended.** Entered when the string editor hands off to `@edit` on a
  capable client. The session is inert; the descriptor's line input belongs
  to the editor. On completion the controller resumes to browsing and
  redraws.

Operations:

- `ui_open(cl, frame, on_close)` allocates the session, installs the
  capability-matched renderer, records `on_close`, pushes `frame`,
  registers the free hook, draws.
- `ui_push(s, child)` / `ui_pop(s)` manage the stack. `ui_pop` frees the
  popped frame through its `free` hook. Popping the last frame ends the
  session and calls `on_close` to restore the descriptor's prior line input.
- `ui_suspend(s)` / `ui_resume(s)` bracket the `@edit` handoff.
- **Submit** runs `on_submit`. If it returns 0 the frame pops and the edit
  context ends; if it returns -1 (validation or `builder_save()` rejected)
  the frame stays open with the error shown and the staged edits intact.
- **Quit (leave)** pops the frame and ends the `ui_session`, but keeps the
  ephemeral edit context alive on the connection (5.6), so re-entering
  resumes. For a plain menu with no edit context, Quit just closes.
- **Discard** is the explicit, confirmed action that runs `on_cancel`, drops
  the scratch OBJ, and ends the edit context. It is separate from Quit so
  leaving is never a silent data loss.
- **Resume.** Opening an edit while a context for the same object is live on
  the connection resumes it (staged edits shown) instead of starting fresh.
  The account-scratch case (across a disconnect) is the same flow, later.
- **Free-on-disconnect.** `ui_free` is registered via
  `telnetclient_set_state_free`. It pops every frame through their `free`
  hooks, runs no user callbacks (so no half-finished Submit fires), zeroes
  sensitive buffers (passwords), drops the ephemeral edit context, and frees
  the session. A client dropping mid-edit leaks nothing and corrupts nothing;
  once account-scratch lands, an opted-in edit survives for resume.

## 8. Renderer interface

The controller never writes to the socket directly. It calls a vtable of
high-level UI events. Every renderer implements the same set; where an event
does not apply to a transport it is a documented no-op, but most map on both
sides.

```
struct ui_renderer {
    const char *name;
    void  *(*open)(DESCRIPTOR_DATA *cl);   /* per-session render_ctx */
    void   (*close)(void *render_ctx);

    /* draw the whole frame: text prints the numbered list; web sends the
     * JSON spec (8.4); MXP prints the list with clickable tags. Required. */
    void (*render)(struct ui_session *s, const struct ui_frame *f);

    /* prompt for one field's value: text prints a prompt line; web is a
     * no-op (the control is already on screen). Terminal-oriented. */
    void (*enter_field)(struct ui_session *s, const struct ui_field *f);

    /* transient notice or validation error. Both map. Required. */
    void (*notify)(struct ui_session *s, const char *text);
};
```

`render` is the one required method and carries the semantics; `enter_field`
is the terminal prompt and a no-op on the web (which submits values without
a per-field prompt). This keeps one controller path while letting the
declarative web client and the prompt/response terminal each do what fits.

Input always arrives as a raw line through the existing
`telnetclient_start_lineinput` callback, which forwards to the controller.
Renderers differ only in output and in how a client expresses a choice.

### 8.1 Capability selection

At `ui_open`, pick the renderer from the descriptor:

- `cl->type == CLIENT_TYPE_WEB` -> web renderer.
- `cl->type == CLIENT_TYPE_USER` and `telnetclient_has_mxp(cl)` -> MXP
  renderer.
- otherwise -> text renderer.

`telnetclient_has_mxp()` does not exist yet; it queries MTH's per-connection
MXP negotiation state and is delivered by the `mxp-protocol` prerequisite
(section 10, Dependencies).

MCP simpleedit and the web SSE editor remain the string-editor handoff
targets regardless of the chosen renderer; they are orthogonal to it.

### 8.2 Text renderer

The universal fallback and the reference for the model's semantics. Draws
a title box, one numbered line per visible field with its current value,
and an action line listing the enabled reserved actions. `UI_F_HIDDEN`
prints `<hidden>`. This renderer must work on a dumb TELNET client with no
negotiation. The title-box helper currently in `menu.c` (`menu_titledraw`)
moves into a shared util when `menu.c` is deleted, so the text renderer does
not depend on the module being replaced.

### 8.3 MXP renderer

Same content as text, but numbered choices and action keys are emitted as
MXP `<send>` links so a capable client can click them, and enumerated
choices use MXP menu hints. Falls back to plain text tokens if the client
did not actually negotiate MXP. Requires the MXP option enabled in MTH
(`mxp-protocol` card). The clickable command a link sends is exactly the
same line a user could type, so the controller path is identical.

### 8.4 Web/SSE UI protocol (the `U` message)

The web renderer sends UI over one SSE command char, `U`, via
`telnetclient_send_sse(cl, 'U', json)`. Rather than a single frame format,
`U` carries a small **extensible envelope** so it can grow to many UI needs
(forms, menus, partial updates, notices, dialogs, side panels) without
minting a new SSE char each time.

Envelope:

```
{ "v": 1, "t": "<kind>", "id": "<correlation-id>", ... }
```

- `v` is the protocol version. A client ignores a `U` message whose `v` it
  does not understand, and ignores unknown `t` kinds, so new message types
  and fields are backward compatible.
- `t` is the message kind (below). `id` correlates later updates and the
  client's replies to a specific frame or widget.

Message kinds in the first cut:

- `frame` -- render a whole screen (the OLC/menu form):

  ```
  { "v":1, "t":"frame", "id":"redit-42",
    "title":"Room: The Fantastic Closet",
    "fields":[ {"n":1,"key":"name","label":"Title","kind":"string",
                "value":"...","flags":["required"]},
               {"n":2,"key":"terrain","label":"Terrain","kind":"enum",
                "value":"forest","choices":["forest","cave","road"]} ],
    "actions":["next","prev","submit","quit","help"] }
  ```

- `patch` -- update named fields on an existing frame without a full redraw:
  `{ "v":1, "t":"patch", "id":"redit-42", "fields":[{"n":2,"value":"cave"}] }`
- `list` -- a selection set (the `List` action, 6), optionally paged:
  `{ "v":1, "t":"list", "id":"color", "title":"Pick a color",
     "items":[{"n":1,"label":"red"},{"n":2,"label":"blue"}],
     "page":{"cur":1,"total":3} }`
- `notify` -- a transient notice or validation error:
  `{ "v":1, "t":"notify", "level":"error", "text":"..." }`
- `close` -- dismiss a frame or the session: `{ "v":1, "t":"close", "id":"redit-42" }`

The `t` set is open; `dialog`, `panel`, and `status` are natural later
additions.

**Inbound stays the line grammar.** `U` is server-to-client only. The client
replies over its existing input channel using the same `N [value]` grammar as
the terminal (section 6): a field post is `"2 cave"`, a list pick is `"3"`, an
action is its letter. The field numbers `n` are the same positional numbers
the text renderer prints, so the server dispatches web and terminal input
through one path. `UI_TEXT` fields carry a handoff hint rather than an inline
value.

## 9. Allocation and error discipline

- The frame stack is a fixed array; no per-navigation heap growth.
- Field values are read into caller-provided buffers via `get(ctx, key,
  buf, len)`. Staged edits live on the scratch OBJ's own copy-on-write
  buffer; the live object is untouched until Submit.
- Every allocation is checked. There is no path that continues with a
  half-built frame or session.
- Validation errors never mutate the backing store; `set` runs only after
  `validate` returns 0, and only against the scratch, never the live object.
- Each frame frees what it owns through its `free` hook; the session owns
  every frame and frees the stack on teardown (5.3). Ephemeral scratch OBJs
  are dropped with their frame.
- Password and other `UI_F_HIDDEN` buffers are zeroed on free.

## 10. Integration and porting

Descriptor state:

- Replace the `menu` and `form` slots on the descriptor with one
  `ui_session *`. Add `telnetclient_set_ui` / `telnetclient_get_ui`;
  remove `set_menu`/`get_menu`/`set_form`/`get_form` once callers are
  ported.
- Line input continues to flow through `telnetclient_start_lineinput`; the
  UI installs a single controller callback and restores the prior handler
  via the session's `on_close`.
- `telnetclient_set_state_free(cl, ui_free)` registers cleanup.

Port order (each step keeps the build green and tests passing):

1. Land the model, controller, text renderer, and unit tests. No caller uses
   it yet. The ephemeral scratch OBJ (`obj_new`) and `builder_save` already
   exist; the online string editor is deferred to before the OLC (it is
   needed only for `UI_TEXT`, not for the login/new-user port).
2. Port the login menu to a per-connection `ui_frame`. Run smoke.
3. Port the new-user application to a `ui_frame` with a struct binding and
   field validators. Run smoke and smoke-cas end to end.
4. Delete `menu.c` and `form.c` and their descriptor slots; move the
   title-box helper to a shared util.
5. Land the online string editor, then add the MXP renderer (needs the
   `mxp-protocol` prerequisite) and the web renderer. The OLC editors, which
   need the string editor for `UI_TEXT`, are built after this on the finished
   layer.

The OLC editors are built after this card, on the finished layer.

### 10.1 Dependencies

This layer does not stand alone. Current state of each (2026-07-18):

- **`builder_save()` -- built.** The Submit target for OBJ-bound frames, in
  `src/builder/`, reached through `builder_zone_ops` (Builder flag, zone
  allow-list, `creator` stamping). No longer a blocker.
- **Ephemeral scratch OBJ -- available.** `obj_new` already yields a detached
  OBJ (5.4.1); the OBJ binding needs nothing further for the ephemeral case.
  Only **account-scratch** persistence (resume across disconnect) is
  outstanding, and it is the sole deferred open question (13).
- **Online string editor -- prerequisite for `UI_TEXT` only.** The in-band
  editor that owns edit/clear/replace via `.` commands, with an optional
  `@edit` handoff. Needed before the OLC long-description fields, **not**
  before the login / new-user port, which uses only prompted `UI_STRING`
  (5.1). Card active, no code yet.
- **`mxp-protocol` -- gates the MXP renderer only.** Enabling MXP in MTH and
  adding `telnetclient_has_mxp()` for capability selection (8.1). The text
  renderer ships first; MXP is added later (10, step 6), so this does not
  block v1.

## 11. Testing plan

- **Model unit tests.** Build frames with struct and OBJ bindings; assert
  `get`/`set`/`validate` behavior, required-field blocking, and enum
  bounds.
- **Dispatch unit tests.** Feed raw lines to the controller with a mock
  renderer; assert digit-to-choice mapping, reserved-action routing,
  out-of-range and invalid-input handling, and that actions absent from
  `action_mask` are rejected.
- **Lifecycle unit tests.** Push/pop depth bounds and per-frame `free` on
  pop; cancel drops the scratch and discards staged edits; a failing
  `on_submit` keeps the frame and preserves edits; submit commits once;
  free-on-disconnect frees the stack, drops ephemeral scratch, and zeroes
  hidden buffers.
- **Scratch OBJ tests.** Edits land on the scratch, not the baseline; Undo
  restores a field from the baseline; ephemeral scratch is gone after
  teardown; an account-scratch edit survives and resumes.
- **Renderer tests.** Golden-output test for the text renderer; a JSON
  shape test for the web renderer.
- **End to end.** Extend `make smoke` and `make smoke-cas` to drive the
  ported login and new-user flows to completion. These must pass unchanged
  in observable behavior across the port.

New suites are wired into their `module.mk` (`EXECUTABLES +=`,
`TEST_TARGETS +=`, `<name>_TESTCMD`) so they run in CI, per the
`ci-test-coverage` card.

## 12. Resolved in review

- **OBJ editing uses a scratch OBJ** (5.4.1), ephemeral by default or
  account-backed for resume. The live object is untouched until Submit, so
  Cancel and Undo are cheap and safe.
- **All frames are session-owned** (5.3), freed on pop and teardown; no
  global static frames, login included.
- **`ui_field` carries `key` separate from `label`** (5.2), so one generic
  OBJ accessor pair serves every field.
- **`on_submit` returns status** (5.3); a failed save keeps the frame.
- **`ui_open` captures an `on_close` continuation** (5.5) to restore the
  prior line input, since `telnetclient` has no handler stack.
- **The renderer vtable is high-level UI events** (section 8), most mapping
  to both terminal and web, with `enter_field` a web no-op.
- **One `N [value]` input grammar** (section 6) unifies terminal and web.
- **String editing splits by type** (5.1, 7): `UI_STRING` uses a one-line
  prompt (hidden for passwords), `UI_TEXT` uses the online string editor.
  The editor is therefore an OLC-only prerequisite; the login / new-user port
  needs no editor.
- **MXP gates only the MXP renderer** (10.1); the text renderer ships first,
  so MXP does not block v1.
- **`UI_MAX_DEPTH` is 10** (5.5).
- **Web/SSE UI rides one extensible `U` envelope** (8.4), versioned and typed
  so it grows to many UI needs without new SSE chars.
- **`List` and `Next`/`Previous` are distinct tools** (6): List presents a
  selection set (paged when large); Next/Previous walk wizard steps.
- **`Q` leaves keeping edits, `X` discards behind a confirm** (6); both are
  kept.
- **`U` is a free SSE char.** Checked against the chars in use today (server
  sends `! + E V`; the web client parses `! + - = ^ _ 2 5 E I s V`); `U`/`u`
  are unused.
- **List pages at 10 items** (6); OLC field lists are short and not paged in
  v1.

## 13. Open questions

- **Account-scratch is proposed in 5.4.2** (`scratch/<user>/<commit_key>` in
  the objs domain; the draft is the scratch OBJ plus `%draft.*` metadata) but
  **deferred**: v1 ships only the ephemeral path. Left for implementation
  time: the persist cadence (checkpoint-per-`set` vs write-on-leave) and the
  staleness-sweep policy (age threshold, when it runs).
