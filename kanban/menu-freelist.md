---
title: Menu & Freelist Fixes
status: backlog
gitlab-sync: OrangeTide/boris#29
---

Small fixes in menu and freelist data structures.

Note: the menu duplicate-key fix is folded into `ui-layer-rebuild`, which
replaces menu.c wholesale (see `doc/plan.md` Phase 2). Keep that box here
for tracking, but expect it done as part of the rebuild. The freelist
fixes are independent of the UI work and stand on their own.

- [ ] menu duplicate key check (menu.c:76) -- subsumed by `ui-layer-rebuild`
- [ ] freelist bridge/grow cases (freelist.c:230/261)
