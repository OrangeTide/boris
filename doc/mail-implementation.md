# BorisMUD Mail and Contacts: Implementation Design

Audience: implementers. This is the buildable internal engineering spec: module
layout, storage schema, C APIs, integration points, and sequencing. It is
authoritative for Boris internals. The GMCP specs (`doc/gmcp/*.txt`) are
authoritative for the wire protocol; the protocol proposals cover the binding and
semantics rationale; the UX design (`doc/mail-design.md`) covers the player
experience. The kanban cards decompose the work described here.

Where this document and the protocol proposals both describe storage or the
mailstore API, this document is the concrete reference and the proposals are the
rationale.

## Module layout

New source directories, each with a `module.mk` added to `SUBDIRS`:

- `src/mail/`
  - `mail.h` / `mail.c` -- the `mailstore` interface, operation dispatch, id and
    identity types, the mail controller.
  - `mail_muddb.c` -- the default muddb backend.
  - `mail_cas.c` -- the content-addressed backend (phase 3; provides `undo`).
  - `mail_form.c` -- the text compose form (callback state machine).
- `src/contacts/`
  - `contacts.h` / `contacts.c` -- the contacts store, operation dispatch,
    presence, delta publication.
  - `contacts_muddb.c` -- the default backend.

Bindings hook existing subsystems rather than living in new files where possible:

- GMCP dispatch extends the telnet/GMCP layer (see "GMCP" below; option 201
  negotiation is a prerequisite, tracked by the `gmcp` card).
- MCP dispatch extends `src/mcp.c` (`input_message()` and the `mcp-negotiate-can`
  advertisement).
- HTTP routes extend `src/web/server/webserver.c` (`process_request()`).

## Constants (`src/boris.h`)

- `DOMAIN_MAIL "mail"` and `DOMAIN_CONTACTS "contacts"`, alongside the existing
  `DOMAIN_USER`/`DOMAIN_OBJS`/`DOMAIN_CHARACTER`/... domains. Both auto-vivify on
  first write.
- `MAIL_BODY_MAX` (suggested 32768), kept below `MCP_CONTENT_MAX` (65536).
- Per-account quotas: `MAIL_MAX_MESSAGES`, `MAIL_MAX_BYTES`,
  `CONTACTS_MAX_ENTRIES` (starting references from OSCAR caps).

## Storage schema

All records are OBJ instances (copy-on-write JSON), read and written with
`muddb_get`/`muddb_put`/`muddb_del`. Keys are strings within a domain.

### Domain `mail`

Mailbox index, key `u:<mailbox>` where `<mailbox>` is the account key (OOC) or
the character key (IC):

```
{
  "gen": 1,                       generation counter (undo/resync)
  "modseq": 42,                   change counter
  "receive_mode": "open",         "open" | "contacts-only"
  "signature": "-- Gandalf",      per-mailbox compose signature
  "messages": [ <header>, ... ]   ordered headers (the tree/metadata layer)
}
```

Header object (the compact form; the mutable metadata lives here, not in
content):

```
{ "id": "42", "class": "ic", "from": "Gandalf", "to": ["Frodo"], "cc": [],
  "subject": "...", "date": 1752624000, "flags": ["seen"], "size": 1180,
  "attach": 0 }
```

Message content, key `m:<mailbox>:<id>` (the immutable, hashable part):

```
{ "class": "ic", "from": "Gandalf", "to": ["Frodo"], "cc": [],
  "subject": "...", "date": 1752624000, "in_reply_to": null,
  "body": "...", "attach": [ <descriptor>, ... ] }
```

Attachment descriptor:

```
{ "name": "old map", "desc": "...",
  "escrow": { "service": "default", "token": "esc_...", "expires": 1753228800 } }
```

Account mail state, key `a:<account>`:

```
{ "handle": "greywizard",        public OOC address (unique; see registry)
  "blocks": [ "<account>", ... ] account-level block list, shared with contacts
}
```

### Domain `contacts`

Per-account record, key `u:<account>`:

```
{
  "seq": 17,                      delta sequence counter
  "request_policy": "anyone",     "anyone" | "none"
  "entries": [ <entry>, ... ],    one per identity
  "confirmed": [ "<identity>", ...] denormalized confirmed identities
}
```

Entry object:

```
{ "id": "c17", "address": "Gandalf", "kind": "character",
  "state": "confirmed", "name": "...", "note": "...",
  "groups": [...], "color": "#5b8f3a", "icon": "wizard" }
```

The block list is not stored here; contacts reads and writes `a:<account>.blocks`
under `DOMAIN_MAIL`, so mail and contacts share one list and mail owns it with no
contacts extension present. `presence` on an entry is computed at read time from
live sessions, never stored.

### Handle registry

OOC handles must be unique and resolvable to an account. Keep a reverse index in
`DOMAIN_MAIL` at `h:<handle>` -> `<account>`, written when a handle is set and
checked for collision. Setting a handle updates both `a:<account>.handle` and the
`h:` index.

## The mailstore API

Per-mailbox, backend-agnostic. `mail_id` names one mailbox (an account OOC
identity or a character).

```c
typedef struct mail_id mail_id;

struct mail_stat   { unsigned count, unseen; uint64_t size, modseq, gen; };
struct mail_index  { uint64_t modseq, gen; OBJ *headers; /* + removed[] on delta */ };
struct mail_removed{ char **ids; unsigned n; uint64_t modseq; };

struct mailstore {
    int  (*stat)(void *ctx, const mail_id *box, struct mail_stat *out);
    int  (*list)(void *ctx, const mail_id *box, uint64_t since_modseq,
                 unsigned offset, unsigned limit, struct mail_index *out);
    OBJ *(*fetch)(void *ctx, const mail_id *box, const char *id, int part);
    int  (*store)(void *ctx, const mail_id *box, OBJ *msg, char id_out[]);
    int  (*flag)(void *ctx, const mail_id *box, const char *id,
                 uint32_t add, uint32_t remove);
    int  (*del)(void *ctx, const mail_id *box, const char *id);
    int  (*expunge)(void *ctx, const mail_id *box, struct mail_removed *out);
    int  (*undo)(void *ctx, const mail_id *box, struct mail_stat *out); /* or NULL */
    void *ctx;
};
```

Account-level state (handle, block list, per-mailbox settings) is reached through
small helpers on top of the store, not through the per-mailbox vtable:

```c
int  mail_handle_get(const char *account, char out[]);
int  mail_handle_set(const char *account, const char *handle); /* checks h: index */
int  mail_block_add(const char *account, const char *target_account);
int  mail_block_remove(const char *account, const char *target_account);
int  mail_is_blocked(const char *account, const char *sender_account);
int  mail_prefs_get(const mail_id *box, OBJ **out); /* receive_mode, signature */
int  mail_prefs_set(const mail_id *box, OBJ *patch);
```

The muddb backend (`mail_muddb.c`) implements the vtable over the schema above.
`store` appends a header (bumping `modseq`, assigning an id from a per-mailbox
counter derived from the current max), writes the content record first, then the
index. `undo` is `NULL` here; the CAS backend provides it.

## Identity resolution

The bindings receive names; the store keys off accounts and characters.

```c
/* IC: character name -> character -> owning account. OOC: handle -> account. */
int mail_resolve_recipient(const char *name, int class,
                           char account_out[], char character_out[]);
/* Which mailbox key does a delivered message land in? */
mail_id *mail_box_for(const char *account, const char *character /* or NULL for OOC */);
```

Delivery resolves each `to` name, checks `mail_is_blocked` and the recipient
mailbox's `receive_mode` (consulting `contacts_is_confirmed` when
`contacts-only`), then `store`s into the recipient's mailbox. Sending validates
that the acting `mailbox` belongs to the authenticated account before anything
else.

## The mail controller and integration

One controller serves both entry points and all three surfaces. A controller
context carries the authenticated account, the selected `mailbox`, and the
session's capability flags.

- Account menu entry. The account menu (a callback state-machine menu, as used by
  login and character selection) gains "Mail" and "Contacts" items that enter the
  controller with the account context and the full mailbox list.
- Mailbox object verb. A mailbox object in the world defines a verb that enters
  the controller with the acting character's mailbox selected. This uses the
  normal object-verb path; no global command is added.
- Capability flag. When a session's `Core.Supports` advertises `Post.Mail`, set a
  per-session flag. The controller uses it to choose the GMCP window path over the
  text menu, and to gate all `Post.Mail.*` emission.

### Compose: two paths

- Text path (`mail_form.c`): a callback form collects recipient, subject, body
  (multi-line, terminated by a lone `.`), and optional attachment, then calls the
  `send` operation. Reuses the form state-machine pattern from login and character
  creation.
- GMCP path: the client owns the compose UI and sends one `Post.Mail.Send`. The
  server runs no form; it validates and replies `Sent` or `Error`.

The controller picks the path from the capability flag on a compose trigger.

### Notification path

On delivery, look up the recipient account's connected sessions and, for each:

- emit a text notice framed to the mailbox class (IC: an in-world courier line via
  the character's descriptor; OOC: an `[OOC]` line), using the descriptor print
  path (`telnetclient_printf`) or the appropriate channel; and
- if the session advertised `Post.Mail`, emit `Post.Mail.Notify { mailbox,
  unseen, latest }`.

Offline recipients simply have unread mail on next open.

## Bindings

All three carry the identical JSON payloads; only framing differs.

- GMCP. Requires telnet option 201 negotiation and `Core.Supports` handling
  (prerequisite, `gmcp` card). A dispatch table maps `Post.Mail.*` and
  `Post.Contacts.*` messages to controller operations; server-initiated `Notify`
  and `Delta` are pushed to advertised sessions. Payloads per `POST_mail.txt` /
  `POST_contacts.txt`.
- MCP 2.1. Extend `src/mcp.c`: advertise the packages in `mcp-negotiate-can`, add
  handlers to `input_message()`, carry each message as a single multiline `json*`
  value. Body multiline stays under `MCP_CONTENT_MAX`.
- HTTP/JSON. Extend `webserver.c` `process_request()` with the `/mail` and
  `/contacts` route sets from the proposals. Resolve the bearer session token via
  `webclient_find_session()` to the account. `Notify`/`Delta` ride the existing
  `/events` SSE stream.

Each binding is a thin adapter: parse into an operation call, format the result.
Keep all policy (blocks, receive mode, ownership, quotas) in the controller and
store, never in a binding.

## Contacts specifics

- Operations mirror the proposal: list/add/update/remove/request/accept/decline/
  unfriend/block/unblock/presence/prefs.
- `request`/`accept` write both accounts' records (the requester's `entries` and
  the target's `entries`), and on confirm add each side's identity to the other's
  `confirmed` set.
- `block` resolves to the account and updates `a:<account>.blocks` (shared with
  mail), and drops any relationship and pending requests both ways.
- Presence: derive from live sessions; publish `contacts.delta { kind: presence }`
  to a contact's confirmed peers who have the session open. Respect
  `visible: false`.
- `seq` bumps on every change; a client that missed a delta re-lists.

## Sequencing and concurrency

- `modseq`/`gen` (mail) and `seq` (contacts) bump on every mutating write, per
  account or per mailbox. Bindings return them so clients reconcile.
- Delivery writes the content record before the index (an orphan content record is
  collectable; a header with no content is the failure to avoid).
- Store operations are mailbox-scoped, which keeps them independent for the
  planned multithreaded server; a mailbox is the natural lock granularity.

## Testing

Per the project's `module.mk` test pattern (`EXECUTABLES +=`, `TEST_TARGETS +=`,
`<name>_TESTCMD`), tests `#include` the source directly:

- `test_mail`: deliver, list delta by `since_modseq`, flag, soft delete + expunge,
  IC vs OOC mailbox routing, block enforcement, receive-mode enforcement, handle
  uniqueness, undo on the CAS backend.
- `test_contacts`: request/accept writes both sides, decline -> denied, block
  drops relationship and shares the mail block list, presence delta on
  login/logout, request-policy `none` refusal.

## Dependencies and open questions

- GMCP option 201 negotiation and `Core.Supports` must land first (the `gmcp`
  card). Until then, MCP and HTTP carry the feature.
- Handle registry: the `h:<handle>` index location and case-folding rules.
- Content-addressed backend and `undo` reuse the CAS store's retention/GC (the
  `obj-cache-cas` card family); confirm the interface fit before phase 3.
- Escrow service is unbuilt; attachments depend on the pinned contract in the mail
  proposal.
