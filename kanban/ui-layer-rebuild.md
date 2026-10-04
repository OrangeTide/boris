---
title: Interactive UI Layer Rebuild (menu/form)
status: done
gitlab-sync: OrangeTide/boris#75
---

Rebuild menu.c and form.c into one per-session, data-driven, type-safe UI
layer. This is the critical path for the menu OLC, which cannot be built
cleanly on the current modules. Full rebuild, not incremental hardening, so
we review the design as a whole. The field model is protocol-neutral with a
per-transport renderer. See `doc/plan.md` sections 3a/3b/4 and Phase 2.
Supersedes the small fixes in `menu-freelist` (#29); relates to
`web-client-ui` (#11).

Prerequisites (from spec review, see `doc/ui-layer-spec.md` 10.1):
`scratch-obj` (OBJ binding working copy), `string-editor` (field editing),
and `mxp-protocol` (MXP negotiation + `telnetclient_has_mxp()` for renderer
selection). `builder_save` is the Submit target but the layer can land and
be tested with struct bindings before it exists.

Landed in `src/ui/` (43 unit tests): model + controller + text renderer;
login-menu, new-user-form, and main-menu ports; `menu.c` and `form.c` deleted
along with the `state.menu`/`state.form` slots. All login and menu flows are
on the UI layer, and `@redit` (OBJ binding + `UI_TEXT` string-editor handoff)
is built on it. smoke green, valgrind clean vs baseline. The two
open items below are cross-referenced deferrals owned by other cards
(`scratch-obj`, `web-client-ui`); the MXP renderer rides with `mxp-protocol`.

- [x] write `doc/ui-layer-spec.md` before coding (field model, frame
      stack, input contract, renderer interface) -- signed off 2026-07-18
- [x] navigation-stack frames + per-session state (`ui_session`, depth
      bound); descriptor ownership wires in with the login port
- [x] typed field model `{label, type, get/set, validate, flags}`;
      string/int/enum/objref/bool/subframe. `UI_TEXT` handoff deferred
- [x] backing-store binding: model is get/set-per-field (struct or OBJ);
      struct binding landed with the login port, OBJ binding with `@redit`
      (`redit_get`/`redit_set` over the scratch OBJ)
- [x] single typed context pointer (`binding`), replacing `(void*, long, void*)`
- [x] two-namespace input: numbers select rows (with inline-value
      shortcut), letters run masked universal actions
- [x] lifecycle: commit (Submit) / cancel (Discard) / free done;
      free-on-disconnect wired (`ui_telnet.c`); suspend/resume later
- [ ] connection-scoped edit context: staged edits stick for the
      connection's life; Quit leaves keeping edits, Discard drops them.
      DEFERRED -> tracked by `scratch-obj` (account-scratch); today a scratch
      is per-editor and freed on leave.
- [x] menu duplicate-key check and freelist bridge/grow cases (#29) --
      MOOT: `menu.c` was deleted, so the old freelist path is gone
- [x] form close-out callback (form.c:306, part of #39) -- MOOT: `form.c`
      was deleted; close-out is the frame `free` hook now
- [x] plain TELNET text renderer (`ui_render_text.c`)
- [ ] web/SSE `U` protocol: versioned, typed, extensible envelope
      (frame/patch/list/notify/close) -> native HTML forms.
      DEFERRED -> tracked by `web-client-ui` (#11)
- [x] port login menu, new-user form, and main menu to the new layer
      (`login_ui.c`, `newuser_ui.c`; wizard + validators)
- [x] unit tests for the layer (40); `make smoke`
      drive the login menu, new-user application, and main menu end to end
- [x] delete `menu.c` / `form.c` and the `state.menu`/`state.form` slots
