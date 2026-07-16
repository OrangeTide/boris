---
title: MXP Protocol (menus and links)
status: backlog
gitlab-sync:
---

Enable MUD eXtensible Protocol for clickable menus and links on capable
TELNET clients (Mudlet, MUSHclient, zMUD/cMUD). MXP is present but disabled
in MTH (`{"MXP", 0}` at `src/thirdparty/mth/mth.c:211`), so this is an
enable-and-render task, not a from-scratch implementation. Serves as the
MXP renderer for the rebuilt UI layer. See `doc/plan.md` section 3b and
Phase 2. Depends on `ui-layer-rebuild`.

- [ ] enable MXP option negotiation in MTH
- [ ] emit `<send>` clickable commands and `<a>` links
- [ ] right-click popup menus for enumerated choices
- [ ] MXP renderer bound to the UI layer's field/menu model
- [ ] safe fallback to plain text when the client does not negotiate MXP
- [ ] test against an MXP-capable client (or a captured negotiation)
