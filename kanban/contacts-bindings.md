---
title: Contacts extension bindings, presence, and UI
status: backlog
gitlab-sync: OrangeTide/boris#78
---

Transport bindings, presence, and client UI for the contacts extension. See
doc/contacts-protocol-proposal.md "Transport bindings" and "Presence and live
updates", and the formal GMCP spec doc/gmcp/POST_contacts.txt. Depends on
contacts-core. Same three transports and shared JSON schema as mail; the web
binding is phase 1 so the web MUA can show a contact list. Contacts is
optional; mail works without it.

Presence is an IM-style pub/sub: subscribe once, receive contacts.delta
pushes (presence and relationship-state changes) over each transport's
existing server-push channel, with a seq for gap detection and re-snapshot.

## Tasks

- [ ] Presence model: online/away/idle/offline folded into entries, derived
      from live sessions (not persisted); presence op with a visible flag for
      appear-offline.
- [ ] contacts.delta pub/sub with per-account seq: presence, request,
      accepted, removed, denied, changed. Blocking is silent; a plain
      unfriend sends the other party a removed delta.
- [ ] HTTP/JSON (web client, priority): GET/POST /contacts, PATCH/DELETE
      /contacts/{id}, POST /contacts/requests, /contacts/{id}/accept|decline|
      unfriend, /contacts/{id}/block, POST /contacts/blocks, DELETE
      /contacts/{id}/block, POST /contacts/presence, GET/PUT /contacts/prefs;
      full parity with GMCP; reuse the web session token; contacts.delta over
      the existing /events SSE.
- [ ] MCP 2.1 (Birdie): package dns-org-mud-boris-contacts 1.0, one json*
      multiline payload per message; deltas as server-initiated MCP messages.
- [ ] GMCP (Mudlet): module Post.Contacts per the publishable spec
      POST_contacts.txt (List/Add/Update/Remove/Request/Accept/Decline/
      Unfriend/Block/Unblock/Presence/Prefs + Delta), gated on
      Core.Supports.Set ["Post.Contacts 1"].
- [ ] Contact-list UI in the web MUA, the Birdie MUA, and the Mudlet package:
      confirmed contacts in user groups, other states in separate sections.
