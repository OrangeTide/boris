# BorisMUD Mail and Contacts

In-game mail with an optional contacts extension, reachable from a MUD client and
the web client. This page is the entry point to the design. Read the documents in
this order.

## Documents

1. `mail-design.md` -- the end-user experience. How a player reaches mail (the
   account menu for out-of-character mail, an in-world mailbox object for
   in-character mail), what each screen looks like, and how the experience scales
   from a plain telnet client up to a GMCP client with a real mail window.
2. `mail-protocol-proposal.md` and `contacts-protocol-proposal.md` -- the
   BorisMUD HTTP/GMCP proposal. The semantic model, the MCP and HTTP bindings, the
   storage approach, phasing, and the decisions behind them.
3. `mail-implementation.md` -- the internal engineering design. Module layout,
   the concrete storage schema, the C `mailstore` API, identity resolution, the
   controller and its integration points, and the binding wiring. The reference
   the implementation cards decompose.
4. `gmcp/POST_mail.txt` and `gmcp/POST_contacts.txt` -- the published GMCP
   module specs. Self-contained, vendor-neutral wire protocol; any server or
   client may implement them. See `gmcp/README.md` for the spec format and
   registry.

## Authority, so the documents do not drift

- The GMCP specs are authoritative for the wire protocol.
- `mail-implementation.md` is authoritative for Boris internals (schema, C API,
  storage layout).
- The proposals carry the rationale and the non-GMCP bindings; where they restate
  the wire schema or internal schema, the spec and the implementation doc win
  respectively.

## What ships on this branch

- Two GMCP module specs (mail, contacts).
- The HTTP/GMCP proposal (the two protocol proposals).
- The mail system design, covering the end-user experience and the internal
  engineering (this design doc plus the implementation doc).
- Kanban cards decomposing the implementation (`kanban/mail-*.md`,
  `kanban/contacts-*.md`, `kanban/gmcp-module-specs.md`).

## Shape of the feature, in one paragraph

Mail is name-addressed and self-contained: a player has one out-of-character
mailbox for the account plus one in-character mailbox per character, addressed by
a public OOC handle or by character name. Abuse is handled by an account-level
block list, send rate limits, and a per-mailbox `open` or `contacts-only` receive
mode, with no capability system and no hard dependency on contacts. The optional
contacts extension adds an address book, friend requests, presence, and the
shared block list. Storage is server-defined behind a per-mailbox `mailstore`
interface; the muddb backend can key content by hash to add de-duplication and a
non-destructive undo. The player reaches all of it from the account menu and from mailbox objects
in the world, as text on any client and as a windowed mail client under GMCP.
