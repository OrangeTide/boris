---
title: In-Game Mail core model and mailstore interface
status: backlog
gitlab-sync: OrangeTide/boris#84
---

Foundation for the in-game mail feature. Transport-neutral operation set,
per-identity mailboxes (an account OOC mailbox plus one per character),
name addressing, standalone anti-abuse, and the backend-agnostic `mailstore`
vtable all bindings call. See doc/mail-protocol-proposal.md. Mail is
self-contained; the contacts extension is optional.

Immutable message content is split from mutable metadata so the backend can
de-duplicate (by content hash) and support undo. In muddb this is the
[[mail-dedup-undo]] enhancement, not a separate store.

## Tasks

- [ ] Message header/full-message JSON schema (one schema for all bindings),
      from/to as character names (IC) or OOC handles (OOC).
- [ ] Mailboxes: enumerate op returns the account OOC mailbox plus one per
      owned character; a `mailbox` selector ("ooc" or a character name) on
      stat/list/fetch/flag/send/delete/expunge/undo. Access limited to the
      account's own OOC mailbox and owned characters.
- [ ] Operation set: mailboxes, stat, list (since_modseq/gen delta, unseen
      filter), fetch, flag, send (from the acting mailbox), delete, expunge,
      undo, block, unblock, prefs. No search in v1.
- [ ] Name addressing: IC character name -> that character's mailbox; OOC
      handle -> account OOC mailbox; login name never exposed.
- [ ] Anti-abuse: account-level block list (account resolved from any identity)
      and send rate limits/quotas; per-mailbox player-set receive mode
      open|contacts-only (contacts-only needs the contacts extension), reported
      in the mailboxes enumerate.
- [ ] Settings via prefs: account-level OOC handle (no mailbox) and per-mailbox
      receive_mode + signature (with mailbox); per-mailbox settings are an
      open-ended bag. Storage is server-defined; block list shared with contacts
      when present.
- [ ] `struct mailstore` vtable keyed per mailbox; undo NULL on non-history
      backends. modseq/gen per mailbox.
