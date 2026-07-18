---
title: Contacts extension core (address book, friends, blocks)
status: backlog
gitlab-sync: OrangeTide/boris#79
---

Optional server-side contact list: address book, friend requests, block list,
and relationship state, addressed by name. Enhances mail (address book,
presence, contacts-only mode) but mail does not require it. See
doc/contacts-protocol-proposal.md, which includes an OSCAR (AIM) comparison.

Contacts are referenced by OOC handle or character name; each identity is its
own entry. One canonical list returns every auto-materialized entry; state
buckets are client-side filters.

## Tasks

- [ ] Entry JSON schema (one schema for all bindings): address (one identity)
      + kind (character|handle), state, and player-controlled metadata
      (name/note/groups/color/icon) stored verbatim and opaque to the server.
      A person's several characters are separate entries.
- [ ] Operation set: list (state/group filters), add, update, remove, request,
      accept, decline, unfriend(block?), block, unblock, presence, prefs
      (request_policy). Every op on both HTTP and GMCP for parity.
- [ ] Relationship states confirmed/pending/incoming/denied/blocked/none;
      auto-materialize an entry per relationship. Friendship is per identity.
- [ ] Store over muddb: DOMAIN_CONTACTS, per-account record {seq,
      request_policy, entries, confirmed(identities)}. The block list is not
      duplicated here; it is the account-level list mail owns (a:<account> in
      DOMAIN_MAIL); contacts reads/writes the same set, resolving
      identity->account first (block is account-level).
- [ ] Establishing a relationship writes both accounts' records; keep
      consistent.
- [ ] Anti-abuse: block overrides all; incoming-request policy anyone/none;
      denied throttles re-requests; rate-limit requests; per-account quotas
      (OSCAR caps as reference); non-enumerating errors.
