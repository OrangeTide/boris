---
title: Interactive UI Layer Rebuild (menu/form)
status: backlog
gitlab-sync:
---

Rebuild menu.c and form.c into one per-session, data-driven, type-safe UI
layer. This is the critical path for the menu OLC, which cannot be built
cleanly on the current modules. Full rebuild, not incremental hardening, so
we review the design as a whole. The field model is protocol-neutral with a
per-transport renderer. See `doc/plan.md` sections 3a/3b/4 and Phase 2.
Supersedes the small fixes in `menu-freelist` (#29); relates to
`web-client-ui` (#11).

- [ ] write `doc/ui-layer-spec.md` before coding (field model, frame
      stack, input contract, renderer interface)
- [ ] per-session UI state owned by the descriptor, navigation-stack frames
- [ ] typed field model `{label, type, get/set, validate, flags}`;
      types: string, int, enum, room-ref, long-text (hand off to `@edit`)
- [ ] backing-store binding: fixed struct (login/account) or OBJ (OLC)
- [ ] single typed context pointer, replacing `(void*, long, void*)`
- [ ] two-namespace input: numbers for enumerated variable choices,
      letters/symbols for fixed universal actions (Next/Prev/Quit/Help/
      Submit/Undo/Refresh/List)
- [ ] open / suspend / commit / cancel / free-on-disconnect lifecycle
- [ ] menu duplicate-key check and freelist bridge/grow cases (#29)
- [ ] form close-out callback (form.c:306, part of #39)
- [ ] plain TELNET text renderer
- [ ] web/SSE structured UI message type -> native HTML forms (#11)
- [ ] port login menu and newuser form to the new layer
- [ ] unit tests for the layer; extend `make smoke` / `make smoke-cas` to
      cover the newuser application and login end to end
