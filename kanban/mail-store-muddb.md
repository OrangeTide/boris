---
title: Mail muddb backend
status: backlog
gitlab-sync:
---

Default `mailstore` implementation over muddb. See
doc/mail-protocol-proposal.md "Reference backend over muddb". Depends on
mail-core.

Keys live in a new `DOMAIN_MAIL = "mail"` (auto-vivifies on first write).
One store per mailbox, keyed by identity (account key for the OOC mailbox,
character key for a character mailbox). The index OBJ is the tree/metadata
layer; content records are separate and immutable, honoring the
content/metadata split even though plain muddb does not de-duplicate or keep
history.

## Tasks

- [ ] Add `DOMAIN_MAIL = "mail"` to boris.h.
- [ ] Index OBJ at `u:<mailbox>`: `{gen, modseq, receive_mode, signature,
      messages:[header]}`; stat/list are one muddb_get plus an in-memory walk.
- [ ] Account OBJ at `a:<account>`: `{handle, blocks:[account]}` (OOC handle and
      the shared block list mail owns; contacts reads/writes the same blocks).
- [ ] Handle registry `h:<handle>` -> account for unique, resolvable OOC
      handles; collision-checked on set; updated with a:<account>.handle.
- [ ] Content OBJ at `m:<mailbox>:<id>`: immutable from/to names, body, and
      attach descriptors, fetched lazily.
- [ ] mailboxes enumerate: list the account's OOC identity + owned characters,
      stat each.
- [ ] Delivery order: write content record first, then update index, then
      raise notify (with the mailbox) if the recipient is connected.
- [ ] Enforce MAIL_BODY_MAX and per-mailbox quotas; send errors when full.
- [ ] Unit tests: deliver, list delta by since_modseq, flag, soft delete +
      expunge, IC vs OOC mailbox routing (IC mail lands in the character's
      mailbox), block and receive-mode enforcement, handle uniqueness.
