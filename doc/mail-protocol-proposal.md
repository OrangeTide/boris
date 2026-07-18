# In-Game Mail: Protocol Proposal

Status: proposal / draft.
Scope: server-stored mail for players, reachable from a MUD client and the web
client, with a backend-agnostic storage layer. An account has several mailboxes,
one OOC mailbox for the account plus one per character, and the protocol reads
across all of them. Mail is self-contained: it addresses by name, gates abuse
with a block list and rate limits, and works with no other subsystem installed.
The contacts extension (`doc/contacts-protocol-proposal.md`) is an optional
enhancement, not a dependency.

This is a Boris project document: it covers Boris's implementation, its storage,
and its MCP and HTTP bindings, and it is internal planning. The wire protocol
itself is published separately and vendor-neutrally as the GMCP module spec
`doc/gmcp/POST_mail.txt`, which any server or client may implement; the mail
feature is not intended to be exclusive to Boris. Where this document and the
published spec overlap, the published spec is the authority for the wire schema.

Storage is a server's own concern. The protocol defines only the client-to-server
interface; a server decides where and how mailbox data and per-mailbox metadata
are kept. The muddb layout below is Boris's reference implementation, not a
protocol requirement.

Related documents: `doc/mail-and-contacts.md` maps the whole design;
`doc/mail-design.md` covers the end-user experience; `doc/mail-implementation.md`
is the concrete internal engineering design (schema, C API, integration).

## Goals

- IMAP-lite semantics: server-side storage, cheap header/index fetch, lazy body
  fetch, a small fixed flag set.
- POP-like simplicity: no folder tree, no subscriptions. The only structure is
  the set of a player's mailboxes.
- Name-addressed, like the game itself: address by character name (IC) or a
  public OOC handle (OOC). The account login name stays private behind the
  handle.
- Standalone anti-abuse: per-account block list, send rate limits, and an
  optional `contacts-only` receive mode. No hard dependency on contacts.
- One semantic model, several transport bindings (MCP 2.1, GMCP, HTTP/JSON) over
  one identical JSON schema.
- Backend-agnostic storage: muddb/OBJ (default), a content-addressed store
  (smolvfs or a git-style tree), Maildir, mbox, or SQL.
- Split immutable content from mutable metadata so a content-addressed backend
  de-duplicates and supports a non-destructive undo.
- Live "new mail" notification without polling.
- Implementable from a scripting language (Lua on Mudlet/Blightmud, Birdie's
  scripting VM): JSON-first, coarse-grained, no low-level assumptions.

Non-goals: multiple folders per mailbox, threading, MIME, external SMTP interop,
server-side search, and history browsing beyond the single-step undo below.

## Terms

- Account: a login identity (`DOMAIN_USER`). It owns one OOC mailbox and the
  mailboxes of its characters. The login name is private; the account's public
  OOC address is a handle it chooses.
- Character: an in-game persona owned by an account. Each character has its own
  mailbox.
- Mailbox: the ordered set of messages for one identity, either an account (OOC)
  or a character (IC). A `mailbox` selector on every operation names which one.
- Message id: an opaque, stable, per-mailbox string. Never reused or renumbered.
- Content hash: the identity of a message's immutable content. Identical messages
  share one hash, so a content-addressed backend stores them once.
- modseq: a per-mailbox integer bumped on every change. Clients cache the last
  value and fetch only what changed since.
- gen: a per-mailbox generation counter. It changes when history is rewritten
  (see "Undo"), telling clients to discard their cache and resync.

## Mailboxes

A player has several mailboxes: the account's OOC mailbox and one per character.
The protocol enumerates them and operates on any one by its `mailbox` selector.

- The `mailbox` selector is `"ooc"` for the account's OOC mailbox, or a character
  name for that character's mailbox. A client owns these identities, so it names
  them directly.
- `mailboxes` returns the caller's mailboxes with a per-mailbox summary, so a UI
  can show one combined view or a folder per identity.
- Access control: a session may operate only on the OOC mailbox of its
  authenticated account and the mailboxes of characters that account owns. The
  server derives the allowed set from the account, never from client input.

## Addressing

Mail is addressed by name, the same names the game already exposes.

- IC mail addresses a character by name and is delivered to that character's
  mailbox, tagged `class: "ic"`, with the character name in `to`. Reply goes
  back to the character.
- OOC mail addresses an account by its public handle and is delivered to that
  account's OOC mailbox. The login name is never exposed; a player who wants OOC
  privacy picks a handle unrelated to their login.
- Sending. `send` acts from one of the caller's own mailboxes, named by the
  `mailbox` selector; that fixes both the sender identity (`from`) and the class
  (a character mailbox sends IC, the OOC mailbox sends OOC). `to` is a list of
  names/handles.
- A recipient that does not exist yields "not found"; a recipient that has
  blocked the sender's account or is in `contacts-only` mode without a
  relationship yields "not permitted".

## Anti-abuse

Self-contained, and the familiar block/allow model rather than a capability
system. The block list and rate limits are account-level; the receive mode is
per-mailbox.

- Block list. A per-account block list; a blocked sender's mail is refused.
  Blocking is account-level: blocking a character or an OOC handle blocks the
  whole underlying account, so a blocked player cannot reach any of your
  mailboxes from any of their characters. Mail manages the list directly, and the
  contacts extension shares it when present.
- Rate limits. Per-account send rate limits and per-mailbox quotas blunt bots and
  mail-bombing.
- Receive mode. A per-mailbox setting the player controls: `open` (default) or
  `contacts-only` (accept only from confirmed contacts). Each of a player's
  mailboxes has its own mode, so a character can accept IC mail openly while the
  OOC mailbox is `contacts-only`. `contacts-only` requires the contacts
  extension; without it, only `open` is available.

A harassed player blocks the sender, or flips the affected mailbox to
`contacts-only`. Weaker than "no unsolicited contact ever", but it matches how
players expect to reach each other and keeps mail decoupled.

## The content / metadata split

Everything mutable about a message lives in the mailbox tree, outside the content
blob, so the content hash never changes once the message exists.

- Immutable content (hashed, shared): `class`, `from`, `to`, `cc`, `subject`,
  `date`, `in_reply_to`, `body`, attachment descriptors. Names and handles are
  stable and public, so they live directly in content.
- Mutable metadata (mailbox tree, never hashed): the per-mailbox `id`, `flags`,
  the receipt timestamp, and placement.

Why it matters:

- De-duplication. One message delivered to twenty recipients stores its content
  once; recipients differ only in their tree metadata. A guild-wide notice is one
  content blob plus twenty small tree entries.
- Undo. Each mailbox change is a new generation over unchanged content blobs,
  which makes the undo below cheap.

Rule for any backend: mutating a flag or moving a message changes only the tree,
never the hashed bytes. A backend that folds flags into the message file still
works but forfeits de-duplication and undo.

## Data model

A message header, the cheap object returned by list:

```json
{
  "id": "42",
  "class": "ic",
  "from": "Gandalf",
  "to": ["Frodo"],
  "cc": [],
  "subject": "Concerning the ring",
  "date": 1752624000,
  "flags": ["seen", "flagged"],
  "size": 1180,
  "attach": 0
}
```

- `class` is `ic` or `ooc`. It is implied by the mailbox (a character mailbox
  holds IC, the OOC mailbox holds OOC) and echoed in the header for convenience.
  `from`/`to`/`cc` are character names (IC) or handles (OOC).
- `date` is Unix epoch seconds. `flags` is a fixed set: `seen`, `flagged`,
  `answered`, `draft`, `deleted`. `attach` is the attachment count.

A full message adds `in_reply_to`, `body`, and attachment descriptors (see the
escrow section for the `attach` entry shape). Bodies are UTF-8 text, opaque to
the server, capped at `MAIL_BODY_MAX` (suggested 32 KiB, which keeps the MCP
binding inside its 64 KiB multiline ceiling).

## Operations

Transport-neutral. Each binding maps onto it. Every mailbox operation names its
target with a `mailbox` selector.

| Operation    | Inputs                                                | Result |
|--------------|-------------------------------------------------------|--------|
| `mailboxes`  | none                                                  | `{mailboxes:[{mailbox, kind, label, count, unseen, receive_mode}...]}` |
| `stat`       | `mailbox`                                             | `{count, unseen, size, modseq, gen}` |
| `list`       | `mailbox`, `since_modseq?`, `offset?`, `limit?`, `unseen?` | `{modseq, gen, messages:[header...], removed:[id...]}` |
| `fetch`      | `mailbox`, `id`, `part = full \| header \| body`      | message |
| `flag`       | `mailbox`, `id`, `add:[flag...]`, `remove:[flag...]`  | updated header |
| `send`       | `mailbox`, `to:[name...]`, `cc?`, `subject`, `body`, `attach?`, `in_reply_to?` | `{id}` |
| `delete`     | `mailbox`, `id`                                       | ok (sets `deleted`) |
| `expunge`    | `mailbox`                                             | `{removed:[id...], modseq}` |
| `undo`       | `mailbox`                                             | `{modseq, gen}` (history-capable backends only) |
| `block`      | `{name}`                                              | ok (account-level) |
| `unblock`    | `{name}`                                              | ok (account-level) |
| `prefs`      | `{mailbox?, receive_mode?, signature?, handle?}` (omit values to read) | `{handle, receive_mode?, signature?}` |

Notes:

- `mailboxes` enumerates the OOC mailbox plus one per owned character (`kind` is
  `ooc` or `character`).
- `list` without `since_modseq` returns the current page and omits `removed`.
  With it, only headers changed since, plus ids expunged since. A `gen` mismatch
  means the client discards and does a full `list`.
- `send` acts from the named mailbox, which sets `from` and `class`. An unknown,
  blocked, or `contacts-only`-refused recipient yields the matching error. The
  sender's own copy lands in the acting mailbox; a "Sent" view is a `from`-filter.
- `delete` is soft; `expunge` purges deleted messages.
- `block`/`unblock` are account-level. `prefs` reads or sets the account `handle`
  (no `mailbox`) and a mailbox's `receive_mode` and `signature` (with `mailbox`);
  a read returns the per-mailbox fields only when a `mailbox` was given.

### Undo

`undo` reverts the named mailbox to its state before the last change, and is
itself recorded so nothing is lost. On a content-addressed backend the mailbox is
a chain of immutable generations with a `TOP` pointer, git-style. `undo` takes
the generation below `TOP` and re-commits its tree as a new generation on top:

```
before:  TOP: A -> B -> C -> ...
undo:    TOP: B' -> A -> B -> C -> ...
undo:    TOP: A' -> B' -> A -> B -> C -> ...
```

`B'` carries `B`'s tree, parented to the old `TOP`. History only grows; content
blobs are shared, so undo is cheap. Each `undo` bumps `gen`. It is a safety net
over an accidental `delete`, `expunge`, or `flag`. Out of v1 scope: browsing an
older generation read-only and copying individual messages back onto `TOP`.

### Server-initiated events

- `notify` `{mailbox, unseen, latest:{id, from, subject, class}}` is pushed on
  delivery, naming which mailbox received mail, so a client shows "new mail" per
  mailbox without polling.

## Storage: backend-agnostic interface

All bindings call one narrow, coarse-grained interface. `mail_id` identifies a
mailbox (an account OOC identity or a character). Default backend: muddb.

```c
typedef struct mail_id mail_id;   /* a mailbox: account OOC identity or character */

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
    /* optional, history-capable backends only; NULL otherwise */
    int  (*undo)(void *ctx, const mail_id *box, struct mail_stat *out);
    void *ctx;
};
```

The mailstore is per-mailbox. Enumerating an account's mailboxes (the `mailboxes`
operation) sits above it: the mail layer lists the account's OOC identity and its
characters, then calls `stat` on each. Bindings depend only on this vtable,
keeping object representation in `src/obj/` and persistence in `src/database/`.
`undo` is NULL on backends without history.

### Reference backend over muddb

- New domain `DOMAIN_MAIL = "mail"` in `boris.h` (auto-vivifies on first write).
- A mailbox key identifies the identity: the account key for its OOC mailbox, the
  character key for a character mailbox.
- `u:<mailbox>` holds the index OBJ `{gen, modseq, receive_mode, signature,
  messages:[header...]}`; `stat` and `list` are one `muddb_get` plus a walk of an
  in-memory array. Per-mailbox settings ride on this record.
- `m:<mailbox>:<id>` holds one message content OBJ, fetched lazily.
- `a:<account>` holds account-level mail state `{handle, blocks:[account...]}`.
  This is where the block list and OOC handle live, so mail owns them with no
  contacts extension present; the contacts extension reads and writes the same
  `blocks` set when installed.
- Delivery writes the content record first (an orphan content record is
  collectable garbage; an index entry with no content is the failure to avoid),
  then updates the index and raises `notify`.
- Plain muddb does not de-duplicate or support `undo`.

### Content-addressed backend (smolvfs / git-style)

- Content OBJs are stored by content hash; identical content collapses to one
  blob across mailboxes. Mail to a character and a copy retained by the sender in
  another mailbox share the blob.
- The index is a tree of references (hash plus id/flags/receipt-time); flag
  changes rewrite a tree node, never the hashed content.
- Each change appends a generation; `undo` works as above. Retention is
  server-configurable: keep the newest N generations, retain N-1 and older for 90
  days before compaction collects unreferenced blobs. Reuses the CAS store's
  retention and GC design (see the `obj-cache-cas` card family).

Maildir, mbox, and SQL backends implement the same interface, one store per
mailbox. A Maildir that folds flags into filenames keeps correctness but loses
hash-stable de-duplication and `undo`.

## Settings

Because the client is zero-knowledge, all settings live on the server, read and
written through `prefs`.

- `handle` (account-level): the account's public OOC address. Unset means the
  account is not OOC-addressable until it picks one.
- `receive_mode` (per-mailbox): `open` (default) or `contacts-only` (available
  only with the contacts extension). Set on each mailbox independently.
- `signature` (per-mailbox): a text signature appended when composing from that
  mailbox. Per-mailbox because the sending identity is the mailbox, so each
  identity carries its own signature.

`prefs` reads or sets the account `handle` with no `mailbox`, and a mailbox's
`receive_mode` and `signature` with a `mailbox`. Per-mailbox settings are an
open-ended bag; a server may store more. The block list is managed through
`block`/`unblock`.

## Transport binding A: MCP 2.1 (Birdie)

Boris implements MCP 2.1 (`src/mcp.c`), and Birdie speaks MCP today (GMCP
planned), so this is the near-term path.

- Package `dns-org-mud-boris-mail` version `1.0` (reverse-DNS, matching
  `dns-org-mud-moo-simpleedit`), announced in `mcp-negotiate-can`, dispatched in
  `input_message()`.
- Every message carries a single multiline `json*` value holding the shared JSON
  object. One schema across transports; a scripted client decodes one document.
- Messages mirror the operations, each a `json*` payload. `MAIL_BODY_MAX` sits
  under the 64 KiB `MCP_CONTENT_MAX`. Auth uses MCP's existing per-message key.

## Transport binding B: GMCP

Published as a formal module spec at `doc/gmcp/POST_mail.txt` (module
`Post.Mail`, capability token `Post.Mail 1`), per `doc/gmcp/README.md`. Wire
payloads are the same JSON objects as the other bindings.

## Transport binding C: HTTP/JSON REST (web client)

The web client already holds a 32-char session token from the SSE `/events`
stream, so mail reuses it with no second login. Send it as
`Authorization: Bearer <token>`; the server resolves it via
`webclient_find_session()` to the account. The mailbox is a path segment.

| Method | Path                       | Maps to | Notes |
|--------|----------------------------|---------|-------|
| GET    | `/mail`                    | mailboxes | enumerate the account's mailboxes |
| GET    | `/mail/{box}`              | stat + list | `?since=&offset=&limit=&unseen=1` |
| POST   | `/mail/{box}`              | send    | send from `{box}`; `201 {id}` |
| GET    | `/mail/{box}/{id}`         | fetch   | `?part=header\|body` |
| PATCH  | `/mail/{box}/{id}`         | flag    | `{add:[...], remove:[...]}`; `200` header |
| DELETE | `/mail/{box}/{id}`         | delete  | soft; `?expunge=1` purges; `204` |
| POST   | `/mail/{box}/expunge`      | expunge | `200 {removed, modseq}` |
| POST   | `/mail/{box}/undo`         | undo    | `200 {modseq, gen}`, or `501` without history |
| GET/PUT| `/mail/{box}/prefs`        | prefs   | that mailbox's `receive_mode` and `signature` |
| GET/PUT| `/mail/prefs`              | prefs   | account `handle` |
| POST   | `/mail/blocks`             | block   | `{name}`; `DELETE /mail/blocks/{name}` to unblock |

`{box}` is `ooc` or a character name the account owns. Status codes: `200`/`201`/
`204` success, `400` malformed, `401` bad token, `403` blocked, `contacts-only`
refusal, or a mailbox the account does not own, `404` unknown recipient, id, or
mailbox, `409` `gen` mismatch, `413` over cap, `501` `undo` without history. Live
`notify` rides the existing `/events` SSE stream.

### Optional: open webmail pre-authenticated from a MUD client

The server can mint a single-use, short-lived token bound to the account, return
`https://host/mail/#t=<token>`, and the page exchanges it via
`POST /mail/session {token}` for a normal session token. Optional; unnecessary
for the in-house web client.

## Attachments: delegate to an escrow service

Mail does not carry objects. An attachment references an escrow service that
holds custody, so mail stays free of item-duplication hazards and unclaimed
objects return to sender. No escrow service exists yet; the contract mail depends
on is pinned below.

- The descriptor carries `name`, a human `desc`, and an `escrow` block
  `{service, token, expires}`:

```json
{ "name": "old map", "desc": "a brittle parchment map of Moria",
  "escrow": { "service": "default", "token": "esc_7Yb3", "expires": 1753228800 } }
```

- On `send`, the flow deposits the object and records the token. On claim, the
  recipient presents it. On expiry, the object returns to the sender. The escrow
  reference is part of the immutable content, so reading, flagging, or moving mail
  never touches it.

### Escrow service contract (pinned)

Transport-neutral; realizable in-process or as an external service. A token is an
unguessable bearer capability.

| Operation | Inputs | Result |
|-----------|--------|--------|
| `deposit` | `{depositor, object, expires}` | `{service, token}` |
| `claim`   | `{token, claimant}`            | `{object}` |
| `status`  | `{token}`                      | `{state, expires, desc?}` |
| `cancel`  | `{token, depositor}`           | `{object}` (recall before claim) |

State machine: `held` at deposit, then one terminal transition, `claimed` or
`returned` (via `cancel`, or automatically at `expires`).

Guarantees mail relies on:

- Exclusive custody. The object is at every instant in exactly one place:
  escrow, the claimant, or the depositor. This anti-duplication property is why
  mail is safe to copy and forward: the object never rides inside it.
- Automatic return to sender on expiry of an unclaimed token.
- Single claimant per object (first-claim-wins). To give the same item to several
  recipients, attach several distinct objects.

Bearer-token trade-off: possession authorizes the claim, so a forwarded message
hands over the claim. Identity-bound claims are an option the service may offer;
v1 assumes bearer tokens.

## Security and limits

- A session operates only on its own account's OOC mailbox and the mailboxes of
  characters that account owns; derive the allowed set from the authenticated
  descriptor, never from client input.
- Enforce the block list (account-level) and receive mode at delivery.
- Quotas: cap messages and total bytes per mailbox; cap body at `MAIL_BODY_MAX`.
- Rate-limit `send`. Bodies are opaque text, never interpreted server-side.

## Versioning

GMCP advertises `Post.Mail 1` (integer version); MCP negotiates the package
version; HTTP embeds a `version` field. A breaking change increments the number.

## Client targets

Priority: Birdie and Mudlet first, Blightmud a stretch.

- Birdie (in-house). C, retained-mode GUI (data table, inventory grid, libvt
  terminal, window manager) sufficient for a Eudora/Claws-style MUA with a folder
  per mailbox. Speaks MCP today, so binding A is the near-term path; moves to GMCP
  when Birdie's GMCP support lands.
- Mudlet. GPL, Lua. GMCP event handlers on `gmcp.Post.Mail.*`, `sendGMCP`
  requests, Geyser UI.
- Blightmud (stretch). Rust core, Lua scripting with GMCP; a thin Lua plugin.

Guidance: JSON-first, one document per message, coarse operations, no binary
framing. A Lua author and a C author write the same logic against the same
schema.

## Suggested phasing

Mail stands alone; contacts is parallel and optional.

1. Mail core and the `mailstore` interface, the muddb backend, per-identity
   mailboxes with the `mailboxes` enumerate and `mailbox` selector, IC/OOC name
   addressing, block list and rate limits, the HTTP binding, `notify` over SSE,
   and a webmail view. Ships end-to-end with no contacts dependency.
2. MCP binding and the Birdie MUA; GMCP binding (`POST_mail.txt`) and a Mudlet
   package.
3. Content-addressed backend with de-duplication and `undo`; escrow attachments.
4. `contacts-only` receive mode once the contacts extension exists. Blightmud
   plugin as a stretch.

## Resolved decisions

- A player has several mailboxes: the account OOC mailbox plus one per character.
  Every operation names its target with a `mailbox` selector; `mailboxes`
  enumerates them.
- Addressing is by name: character name to a character's mailbox (IC), public OOC
  handle to the account's OOC mailbox (OOC). The login name stays private.
- Anti-abuse is a block list, rate limits, and an optional `contacts-only` mode.
  The block list and rate limits are account-level; the receive mode is
  per-mailbox and player-set. Mail has no capability system and no hard
  dependency on contacts.
- History is a single-step, non-destructive `undo`; snapshot browsing and
  per-message restore are out of v1 scope.
- No search in v1; `list` keeps only the `unseen` filter within a mailbox.
- Object attachments use the pinned escrow contract; the service is unbuilt.

## Open questions

1. Escrow service: in-process or separate, and bearer versus identity-bound
   claims.
