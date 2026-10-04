---
title: UI field-change hook (live type-dependent fields)
status: done
gitlab-sync: OrangeTide/boris#117
---

The UI layer had no way for editing one field to change the visible field
set. `@oedit` (`olc-object-editors`) needed this: Capacity should appear the
moment `type` becomes `container`, Wear slot when it becomes `wearable`.
Originally the field set was built from `type` only when the editor opened,
so a type change was revealed only on the next open.

Two obstacles in the current controller (`src/ui/ui.c`):

- A field's `set` callback gets `(ctx, key, value)`, not the `ui_session`,
  so it cannot ask the frame to refresh.
- `ui_swap_top` resets the cursor to 0 and calls `wizard_start`, so swapping
  a wizard frame restarts the whole walk. Rebuilding the frame from inside
  `set_value` would also dangle the `fld` pointer `handle_edit_input` still
  holds after the swap (use-after-free).

Done: `on_change` fires from `set_value`; `ui_fields_rebuilt` publishes the
new count without freeing/moving the array (in-place rebuild sidesteps the
UAF -- callers use `s->cursor`, not `fld`, after `set_value`). `@oedit` reveals
Capacity / Wear slot live, including mid-wizard.

- [x] add an optional `on_change(struct ui_session *s, void *binding)` hook
      to `ui_field`, called by `set_value` after a successful set
- [x] a safe refresh primitive: `ui_fields_rebuilt` updates the field count
      and clamps the cursor in place (no free, no move); the wizard walks
      into any newly-revealed field via the normal `finish_edit` advance
- [x] `@oedit`: on `type` change, rebuild the field list so Capacity /
      Wear slot appear (or disappear) live; `olc-spec.md` 6 note updated
- [x] `test_ui` coverage: `test_on_change` (reveal/hide a field, index and
      cursor preserved) plus the `oedit_item` smoke case (Capacity revealed
      mid-wizard)
- [x] `ui-bool-wizard` stays separate; still open as its own card
