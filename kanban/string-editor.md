---
title: Online String Editor
status: done
gitlab-sync:
---

In-band server-side string editor for editing text fields from a terminal.
Owns the edit-existing (default) / clear / replace semantics through `.`
commands, so higher layers do not reinvent them. Used by every `UI_STRING`
and `UI_TEXT` field in the interactive UI layer and by the OLC. On a capable
client it may hand off to the existing `@edit` path (MCP simpleedit or web
SSE editor). Prerequisite for `ui-layer-rebuild` field editing and the OLC
editors. Design: `doc/string-editor-spec.md` (also `doc/ui-layer-spec.md`
Dependencies, `doc/plan.md` Phase 3).

Implemented in `src/stred/` (`stred.c` core, `stred_telnet.c` wiring);
17 unit tests. Signed off spec 2026-07-19.

- [x] implement the `/` command set (`/s /a /c /r /l /f /h /d /i`), short
      letter / long name / unambiguous prefix, `//` literal-slash escape
- [x] single-line and multi-line modes
- [x] clear vs empty vs cancel semantics, resolved in the editor
- [x] entry/return contract (`stred_start` + `done(result, changed)`) with
      the suspend/resume teardown
- [x] unit tests for the parser and the clear/replace/cancel paths
- [ ] wire `UI_TEXT` field editing to `stred_start` (lands with `@redit`)
- [ ] capability handoff to `@edit` on MCP/web clients (deferred, spec 8.1)
