---
title: Mail content dedup and undo (muddb)
status: backlog
gitlab-sync: OrangeTide/boris#81
---

Originally scoped as a mail backend over a live content-addressed store
(smolvfs). CAS is no longer a live backend (see [[obj-cache-cas]]), so this
is re-scoped: realize the two properties that actually mattered, dedup and
non-destructive undo, as a layer over the muddb mailstore. No live CAS is
involved. See doc/mail-protocol-proposal.md "De-duplication and undo over
muddb" and "Undo". Depends on [[mail-store-muddb]] (which already
splits immutable content records from the mutable index).

Properties, unchanged in intent:

- Dedup: identical message content is stored once. A guild-wide message is
  one content record plus N index references.
- Undo: a single-step, non-destructive undo over an immutable generation
  chain with a TOP pointer. History only grows.

## Tasks

- [ ] Key immutable content records by a content hash in `DOMAIN_MAIL`
      (from/to names live in content), so identical content collapses across
      mailboxes. This extends mail-store-muddb's content records; it is an
      app-level hash key, not a CAS store.
- [ ] Mailbox index references content by hash plus id/flags/receipt-time; a
      flag change rewrites the index entry, never the hashed content.
- [ ] Undo as muddb records: keep prior generations and a TOP pointer;
      re-commit the generation below TOP as a new TOP (A->B->C becomes
      B'->A->B->C), advancing it. Bump gen; history only grows.
- [ ] Server-configurable retention of generations: keep newest N, retain
      N-1 and older 90 days before compaction (N and window are config).
      This is a muddb record-pruning policy now, not CAS GC.

## Out of scope / delegated

- Read-only snapshot browsing and per-message restore from a snapshot are
  not mail-specific here. They fall out of the general world snapshot/export
  path: `muddb-tool to-cas` already captures the whole muddb world
  (mail included) as deduplicated, immutable snapshots, and a cas-to-muddb
  import (not yet built) would restore them. Track that under
  [[world-backup-commands]], not this card.
