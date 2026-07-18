---
title: Mail content-addressed backend (dedup + undo)
status: backlog
gitlab-sync: OrangeTide/boris#81
---

`mailstore` implementation over a content-addressed store (smolvfs or a
git-style tree) that realizes the content/metadata split from mail-core. See
doc/mail-protocol-proposal.md "Content-addressed backend" and "Undo". Depends
on mail-core; reuses the CAS retention/GC design from the obj-cache-cas card
family.

Properties: identical content stored once (a guild-wide message is one blob
plus N tree entries), and a single-step non-destructive undo built on an
immutable generation chain with a TOP pointer.

## Tasks

- [ ] Store message content keyed by content hash (from/to names in content);
      identical content collapses across mailboxes.
- [ ] Mailbox index as a reference tree (hash + id/flags/receipt-time); flag
      changes rewrite the tree, never the hashed content.
- [ ] undo: re-commit the generation below TOP as a new TOP, advancing it
      (TOP: A->B->C becomes B'->A->B->C). History only grows; bump gen.
- [ ] Server-configurable retention: keep newest N generations, retain N-1 and
      older 90 days before compaction (N and window are config).
- [ ] Out of scope note: read-only snapshot browsing and per-message restore
      from a snapshot are a later feature on the same chain.
