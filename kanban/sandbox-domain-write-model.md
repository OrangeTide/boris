---
title: Sandbox Single-Writer-Per-Domain Write Model
status: backlog
gitlab-sync:
---

Gate item 2 for freezing the sandbox ABI. This most shapes the eventual
ABI, so prove it before freezing object-write semantics. See
doc/mud-cf-sandbox-design.md "Object Writes".

LMDB permits one write transaction at a time per environment. The old
"implicit transaction, commit on yield" model does not survive a
multicore scheduler: two tasks on two cores cannot both hold an open
write txn, and holding one across a quantum serializes every writer.
Replace it with single-writer-per-domain.

## Tasks

- [ ] Object reads via short-lived MVCC read transactions
      (HC_OBJ_PROP_GET, HC_OBJ_PROP_LIST). Confirm LMDB parallelizes
      these across cores with no contention.
- [ ] One trusted owner task per writable domain (area:, world:, ...)
      holds the write transaction for that domain.
- [ ] HC_OBJ_PROP_PUT on a non-private domain becomes an RPC to the
      owner: guest expresses a write, libc turns it into a message send,
      owner validates + applies + replies.
- [ ] tmp: exempt (per-task RAM, no transaction).
- [ ] Define write visibility/atomicity in terms of owner commit; guests
      observe no partial writes and do not depend on commit-on-yield.
- [ ] Load test: parallel readers + writers across cores, confirm
      coherence and that parallelism is not lost to the write lock.
