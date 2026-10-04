---
title: UI_BOOL fields in the step wizard
status: done
gitlab-sync: OrangeTide/boris#116
---

A `UI_BOOL` field could not be used inside the step wizard. When the wizard
advanced to a bool, `enter_field` (`src/ui/ui.c`) called `toggle_bool`
immediately: it flipped the stored value, redrew, and returned without waiting
for input and without advancing. `s->mode` was left `UI_MODE_EDITING` on the
bool field, so the builder's next line (meant for the following field) was
consumed as a raw value for the bool and the whole walk desynced.

Surfaced building `@oedit` (`olc-object-editors`): the `Fixed` field is the
first real bool in an editor. It shipped as a yes/no `UI_ENUM` to work around
this; the stored value ("yes"/"no") is the same a bool would write.

- [x] wizard-aware bool: `enter_field` takes an `in_wizard` flag -- in the
      wizard a `UI_BOOL` prompts yes/no (`enter_field_line`) and advances
      like any other field; browse-mode toggle-on-select is unchanged
- [x] prompt shape: the text renderer shows `Fixed (yes/no) [no]:`;
      `handle_edit_input` accepts y/n/yes/no/1/0/t/f, rejects anything else,
      and leaves the field unchanged on an empty line
- [x] `test_ui` case `test_wizard_bool`: a wizard bool prompts (no
      auto-toggle), rejects a bad answer, sets on yes/no, and advances
- [x] reverted `@oedit`'s `Fixed` field to `UI_BOOL` (`src/cmd/oedit.c`) and
      updated the `olc-spec.md` 6 note; `oedit_item` smoke drives the prompt
