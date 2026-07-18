# Contacts and Address Book: Protocol Proposal

Status: proposal / draft.
Scope: a server-side contact list with an address book, friend requests,
presence, and a shared block list, as an optional protocol extension. It
enhances mail (address book, presence, and the `contacts-only` receive mode) but
mail does not require it: mail is name-addressed and self-contained. Other
features (tells, who-lists, party invites) can reuse the same contact data.

This is a Boris project document: it covers Boris's implementation, its storage,
and its MCP and HTTP bindings, and it is internal planning. The wire protocol is
published separately and vendor-neutrally as the GMCP module spec
`doc/gmcp/POST_contacts.txt`, which any server or client may implement. Where
this document and the published spec overlap, the published spec is the authority
for the wire schema. Storage is a server's own concern; the muddb layout below is
Boris's reference implementation, not a protocol requirement.

Related documents: `doc/mail-and-contacts.md` maps the whole design;
`doc/mail-design.md` covers the end-user experience; `doc/mail-implementation.md`
is the concrete internal engineering design.

## Why an extension, and why optional

A contact list is a basic mail-user-agent function that other features can
reuse, but mail does not require it. The MUD client is zero-knowledge, so the
data lives on the server. Making it a separate, optional extension keeps mail
shippable on its own and lets other features depend on contacts without
depending on mail.

The extension mirrors mail's shape: one transport-neutral model, three bindings
(MCP 2.1 for Birdie, GMCP for Mudlet, HTTP/JSON for the web client), a
backend-agnostic store, one JSON schema everywhere.

## Concepts

Contacts are addressed by name, matching mail: a contact is referenced by an OOC
handle or by a character name. Each addressable identity is its own entry, so a
person you know through several characters appears as several entries, and you
need not learn that those characters share one account.

- Address book. The owner's list of contact entries, one per identity, each with
  player-controlled display metadata (name, note, groups, color, icon) that is
  opaque to the server.
- Friendship. A relationship confirmed by a request the other side accepts. It is
  per identity: you confirm the specific character or handle you addressed. The
  set of confirmed identities is what the mail `contacts-only` receive mode
  checks.
- Block list. A denylist shared with mail, and account-level: blocking any entry
  blocks the whole underlying account, so a blocked player cannot reach you from
  any of their characters. Block is broad on purpose (a safety action), while
  friendship stays per identity (trust extended to one known character); keeping
  confirmation narrow also avoids revealing which characters share an account.
  This is the same block list mail manages directly; contacts is the richer
  manager of it.
- Presence. A live online/away/idle/offline flag folded into the list and pushed
  as deltas. Presence is session state, not stored history.

### Relationship state

Every person the account has a relationship with is auto-materialized as an
entry. `state` is one of:

- `confirmed` -- a request was accepted; both sides are connected.
- `pending` -- I sent a request, awaiting their accept.
- `incoming` -- they sent a request, awaiting mine.
- `denied` -- a request was declined; the entry lingers so the UI can show it and
  re-requests can be throttled.
- `blocked` -- on my block list.
- `none` -- a saved address-book entry with no relationship yet.

The server reports state; the UI decides presentation, typically confirmed
contacts in their user groups and other states in separate sections or tabs.

## Player-controlled metadata

Per-entry metadata (`name`, `note`, `groups`, `color`, `icon`) is user-editable,
purely for the owner's own display, and opaque to the server. The server stores
and returns it verbatim, never interprets it, and never uses it to drive policy.
Groups are free-form labels with no server-defined taxonomy.

This is deliberate: player control is the priority. Group membership never gates
anything server-side; a policy like "friends in group X can mail me" is out of
scope, because it would make a display label load-bearing.

## Data model

An entry:

```json
{
  "id": "c17",
  "address": "Gandalf",
  "kind": "character",
  "state": "confirmed",
  "presence": "online",
  "name": "Gandalf the Grey",
  "note": "guildmate, runs the Tuesday raid",
  "groups": ["guild", "raid"],
  "color": "#5b8f3a",
  "icon": "wizard"
}
```

- `address` is the single identity this entry names, and `kind` is `character`
  (an IC character name) or `handle` (an OOC handle). Multiple characters of the
  same person are separate entries.
- `state` is the relationship state. `presence` is present only for `confirmed`
  contacts whose presence is visible.
- `name`, `note`, `groups`, `color`, `icon` are player-controlled metadata.

## Operations

Transport-neutral. One canonical list; the rest are mutations and presence.

| Operation      | Inputs                                          | Result |
|----------------|-------------------------------------------------|--------|
| `list`         | `state?`, `group?`                              | `{seq, entries:[entry...]}` |
| `add`          | `{address, name?, note?, groups?, color?, icon?}` | `{id}` (book-only entry, state none) |
| `update`       | `{id, name?, note?, groups?, color?, icon?}`    | updated entry |
| `remove`       | `{id}`                                          | ok (clears metadata; an entry with a relationship persists) |
| `request`      | `{address, note?}`                              | `{id, state}` (pending, or confirmed if it completes an incoming) |
| `accept`       | `{id}`                                          | `{state: confirmed}` |
| `decline`      | `{id}`                                          | ok (requester moves to denied) |
| `unfriend`     | `{id, block?}`                                  | ok (drop the relationship; also block if `block`) |
| `block`        | `{id}` or `{address}`                           | ok (drops relationship and pending both ways) |
| `unblock`      | `{id}`                                          | ok |
| `presence`     | `{state, visible?}`                            | ok (my own online/away/idle and visibility) |
| `prefs`        | `{request_policy?}` (omit to read)             | `{request_policy}` (account-level) |

`list` is the single source of truth: it returns every auto-materialized entry
across all states; a client renders the whole list from it and filters by
`state`/`group` locally.

You reference someone by the name the game already exposes: their OOC handle or a
character name. There is no separate discovery step for v1.

## Presence and live updates

The list is live. A client subscribes once (implicitly on session setup) and the
server pushes deltas. A full snapshot comes from `list`; everything after is
incremental.

- `contacts.delta` `{seq, kind, id, ...}` is the push event. `kind` is one of:
  `presence`, `request`, `accepted`, `removed`, `denied`, `changed`.
- `seq` is a per-account monotonically increasing number on the snapshot and
  every delta, so a client that missed events detects the gap and re-lists.

Presence is derived from live sessions, not persisted. Any visible connected
session makes an account `online` (or `away`/`idle` per its own `presence`);
none makes it `offline`. A player may set `visible: false` to appear offline.

### Unfriend and block notifications

- Blocking is silent to the other party: no delta tells them.
- A plain unfriend (without block) sends the other party a `removed` delta. The
  unfriend UI presents "block" as an option on the confirmation dialog, so a
  player who wants a silent removal, or wants to stop future contact, chooses
  block.

## Anti-abuse

Contacts adds richer controls over the block list mail already provides.

- Block overrides everything: a blocked account's request is dropped and its mail
  refused, with a generic "not permitted" result.
- Per-account incoming-request policy: `anyone` (default) or `none`, set through
  the `prefs` operation (`request_policy`). Existing contacts are unaffected.
- A `denied` request throttles re-requests from the same account.
- Rate-limit outbound requests and presence churn, and cap the request `note`
  length. OSCAR's hard caps (roughly 200 buddies, 200 permits, 200 denies, 61
  groups) are a reference for comparable per-account quotas.

## Storage

Backend-agnostic. Reference implementation over muddb:

- New domain `DOMAIN_CONTACTS = "contacts"` (auto-vivifies on first write).
- Per-account record at `u:<account>`: `{seq, request_policy,
  entries:[entry...], confirmed:[identity...]}`. `confirmed` is a denormalized
  set of confirmed identities (character names and handles), so the mail
  `contacts-only` check is a single `muddb_get` plus a membership test on the
  sender identity.
- The block list is not duplicated here. It is the account-level list mail owns
  (in the Boris reference, `a:<account>` under `DOMAIN_MAIL`, holding `handle`
  and `blocks:[account...]`); contacts reads and writes that same set. Blocking
  is account-level, so the block check resolves a sender identity to its account
  first. This keeps one block list across mail and contacts and lets mail own it
  with no contacts extension present.
- Establishing a relationship writes both accounts' records, kept consistent.
- Presence is not stored; it is computed from connected sessions and published
  through the delta channel.

Other backends (SQL, a graph store) implement the same operations.

## Transport bindings

Same three transports and one JSON schema. Each transport has a server-push
channel that carries `contacts.delta`.

- MCP 2.1 (Birdie): package `dns-org-mud-boris-contacts` 1.0, each message a
  single multiline `json*` payload, announced in `mcp-negotiate-can` and
  dispatched in `input_message()`. Deltas are server-initiated MCP messages.
- GMCP (Mudlet): formal module spec at `doc/gmcp/POST_contacts.txt` (module
  `Post.Contacts`, capability `Post.Contacts 1`), per `doc/gmcp/README.md`.
- HTTP/JSON (web client): base path `/contacts`, reusing the existing web session
  token. Every operation has a route, for parity with GMCP: `GET /contacts`
  (list), `POST /contacts` (add), `PATCH/DELETE /contacts/{id}`
  (update/remove), `POST /contacts/requests` (request),
  `POST /contacts/{id}/accept|decline|unfriend`, `POST /contacts/{id}/block` and
  `POST /contacts/blocks {address}` (block by id or address), `DELETE
  /contacts/{id}/block` (unblock), `POST /contacts/presence` (presence), and
  `GET/PUT /contacts/prefs` (request policy). `contacts.delta` rides the existing
  `/events` SSE stream.

## Design notes: comparison with OSCAR (AIM)

OSCAR is the closest documented prior art for a server-stored buddy list with
presence. Two open-source reimplementations are worth reading:
`github.com/mk6i/open-oscar-server` and `github.com/ox/aim-oscar-server`.

| This extension                     | OSCAR equivalent |
|------------------------------------|------------------|
| Server-stored contacts + groups    | Feedbag / SSI service (SNAC family 0x0013) |
| Per-entry display metadata          | Feedbag buddy comments and group items |
| Block list                          | Permit and deny lists |
| Request / accept / decline          | "Requires authorization" add flow |
| Presence + `contacts.delta`         | Location service (SNAC family 0x0002) |
| Per-account quotas and rate limits  | Feedbag caps and rate classes |

We drop OSCAR's FLAP framing and binary SNAC encoding (JSON over the existing
bindings), its multi-service login and rendezvous machinery, and its
client-visibility subtleties beyond a simple appear-offline. Addressing is by
name, as OSCAR did with screennames, without OSCAR's separate directory services.

## Suggested phasing

Contacts is optional and parallel to mail.

1. Core model and store (entries, relationship states, the shared block list,
   metadata) with the muddb backend and the HTTP binding.
2. Presence and the `contacts.delta` pub/sub channel across all bindings.
3. MCP and GMCP bindings (`POST_contacts.txt`) and the contact-list UI in the
   Birdie MUA and the Mudlet package. Wire the mail `contacts-only` mode to the
   `confirmed` set.

## Resolved decisions

- Contacts is an optional enhancement; mail works without it.
- Addressing is by name (OOC handle or character name); no capability tokens.
- Each identity is its own entry; a person's several characters are separate
  entries. Friendship is per identity; block is account-level.
- One canonical `list` returns all auto-materialized entries; state buckets are
  client-side filters.
- The block list is shared with mail; blocking is silent; a plain unfriend
  notifies with a `removed` delta; the unfriend UI offers block on confirm.
- Per-entry metadata is client-side display only and never drives server policy.

## Open questions

1. Whether a "find a contact by a known email or phone" convenience is worth
   adding later (opt-in, throttled, CAPTCHA-gated against bulk scanning), or
   whether name-based addressing is sufficient.
