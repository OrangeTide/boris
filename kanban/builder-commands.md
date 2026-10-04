---
title: Builder Commands (@dig, return)
status: done
gitlab-sync: OrangeTide/boris#6
---

OLC commands for building new rooms and navigating back.
Implemented in `src/cmd/dig.c` (@dig) and `src/cmd/move.c` (return);
verified in-game.

- [x] @dig <direction> <id> [title] -- create room from zone template
      (%parent), link the forward exit and the reverse exit, through
      builder_save
- [x] return -- return player to their last location (movement records
      room.previous; return toggles current/previous)
