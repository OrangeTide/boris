---
title: Multithreading
status: backlog
gitlab-sync: OrangeTide/boris#15
---

Thread-safe room/character caches, concurrent tick updates.
muddb already has a write mutex. Deferred until VM work stabilizes --
the right locking interface depends on VM design.

- [ ] thread-safe room/character cache access patterns
- [ ] concurrent tick updates (NPCs, room programs)
- [ ] identify locking boundaries between I/O and VM threads
