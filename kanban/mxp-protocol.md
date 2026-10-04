---
title: MXP Protocol (menus and links)
status: backlog
gitlab-sync: OrangeTide/boris#72
---

Enable MUD eXtensible Protocol for clickable menus and links on capable
TELNET clients (Mudlet, MUSHclient, zMUD/cMUD). MXP is present but disabled
in MTH (`{"MXP", 0}` at `src/thirdparty/mth/mth.c:211`), so this is an
enable-and-render task, not a from-scratch implementation. See `doc/plan.md`
section 3b and Phase 2, and `doc/ui-layer-spec.md` (Dependencies).

Dependency split: MXP negotiation and the `telnetclient_has_mxp()` query are
a **prerequisite** of `ui-layer-rebuild` (its renderer selection needs the
query). The MXP renderer itself depends on the UI layer's field/menu model.

- [ ] enable MXP option negotiation in MTH
- [ ] `telnetclient_has_mxp()` querying MTH per-connection MXP state
      (prerequisite for the UI layer capability selection)
- [ ] emit `<send>` clickable commands and `<a>` links
- [ ] right-click popup menus for enumerated choices
- [ ] MXP renderer bound to the UI layer's field/menu model
- [ ] safe fallback to plain text when the client does not negotiate MXP
- [ ] test against an MXP-capable client (or a captured negotiation)
