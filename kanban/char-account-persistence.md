---
title: Persist a character per account across sessions
status: backlog
gitlab-sync: OrangeTide/boris#93
---

Split out of [[vm-object-model]] L3. The migration map found that characters do
not persist per account today: every game-entry mints a fresh character, and
there is no link from a user account to a character. L3 preserves that
mint-fresh behavior on the new OBJ model; this card adds real persistence.

## Current behavior

- `command_start_lineinput` (src/cmd/cmd.c) calls `character_new()` on every
  entry and seeds `name.short` from the username and `room.current` from
  `mud_config.newuser_room`. There is no character selection or reload.
- `struct user` (src/user.c) has no character-id slot. Account creation
  (`user_create`, form path) makes only the account, never a character.
- Saved character records accumulate (each `character_new` saves immediately)
  but are never re-associated to an account on login.

## Goal

A returning player resumes the same character: one stable `chars/<id>` OBJ per
account, loaded and bound to the session on entry, saved on disconnect, and
dropped back into position (its `%location`) on the next login.

## Scope

- Add a character-id slot to the user record (persist alongside the other user
  OBJ fields in src/user.c).
- On entry: if the account has a character id, `character_get` it (which is now
  `obj_get("chars/<id>")`); otherwise create one and record its id on the user.
- Decide first-login character creation: inline on first entry (as today, but
  recorded) or an explicit creation form (the commented-out "Create Character"
  menu item in src/game.c is the seam).
- Disconnect already detaches and saves via `character_put` ->
  `obj_release`; confirm the character stays persisted and its `%location` is
  retained so the next login resumes in place.
- Multiple-session policy for one account (reconnect takeover vs. refuse) is a
  decision this card must settle.

## Dependencies

Depends on [[vm-object-model]] L3a (the character adapter over the obj cache),
since persistence is expressed as loading a stable OBJ id rather than minting
one. Does not block the rest of the object-model layers.

## Tests

- Create an account, enter, set a property and move to a room, disconnect,
  reconnect: same character id, same `%location`, properties intact.
- A fresh account with no character gets one created and recorded once.
- The chosen multiple-session policy behaves as specified.
