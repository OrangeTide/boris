---
title: Multithreading
status: backlog
gitlab-sync: OrangeTide/boris#15
---

Thread-safe room/character caches, concurrent tick updates.
muddb already has a write mutex. The RV32 VM runtime is single-threaded and
cooperative by design (see doc/mud-vm-design.md), so all multicore work
lives here, not in the sandbox. Deferred until the VM runtime stabilizes;
the right locking interface depends on it.

- [ ] thread-safe room/character cache access patterns
- [ ] concurrent tick updates (NPCs, resident programs)
- [ ] identify locking boundaries between I/O and VM task execution
