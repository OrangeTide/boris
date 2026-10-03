---
title: Smoke Test for @-Commands
status: done
gitlab-sync:
---

## Resolution

Implemented in src/tests/test_smoke.sh + smoke.exp as the `at_commands`
test. It takes Option A below: the smoke config sets newuser.flags to
0x400002 so the account is a wizard, and the deny path is proven by the
account revoking its own 'w' flag mid-session (user_lookup returns the
live session user, so the loss of authority takes effect at once). The
test runs last because it strips that flag.

Covered: @chown success (to the seeded chars/system) and its
missing-object, missing-owner and non-chars/ owner rejections; @grant
and @revoke on the account; the post-revoke permission refusal.

Not covered here: @edit / @view. Those go through the web/MCP path, so
they belong in test_web_smoke.sh and are left as a follow-up.

The admin @-commands (@grant, @revoke, @chown, @edit, @view) have unit coverage
at the layers below them, but no end-to-end smoke test drives them through a
live session the way test_smoke.sh drives the player commands. This card plans
that coverage before writing it.

## What exists

- src/tests/test_smoke.sh: bash + expect. smoke.exp logs in and drives telnet to
  the "> " prompt (enter_game), then runs player commands. test_web_smoke.sh does
  the curl/web path.
- Smoke tests are manual. They are NOT wired into `make check` (they need a built
  boris, a telnet/expect toolchain, and a scratch database).
- The smoke account is newuser with flags = 0x2 (acs flag 'b'). It is NOT a
  wizard: the wizard flag is 'w' = bit 22 = 0x400000.

## The obstacle

Every @-command here is wizard-gated (user_is_wizard, acs_check "fw"). The smoke
account cannot run any of them as configured, so a smoke test would only ever see
"Permission denied."

Two ways to give the smoke session wizard authority, to be decided when
implementing:

- [x] Option A (chosen): set newuser.flags to include bit 22 (0x400002) in the
      smoke config only. Simplest. It makes every smoke login a wizard, but that
      does not change what the existing player-command assertions observe, and
      the deny path is still reachable by self-revoking the 'w' flag.
- [ ] Option B: seed a separate wizard account (users/ record with flag 'w') and
      have smoke.exp log in as that identity for the @-command checks, keeping the
      plain newuser path for the non-admin assertions. More faithful, but needs a
      valid password hash seeded out of band, which the harness cannot produce
      cheaply today.

## Scope to cover

- [x] @grant / @revoke: set and clear an acs flag on an account, then observe the
      effect (a gated command is refused after the wizard flag is revoked).
- [x] @chown: assign an object's %owner to a seeded reserved identity. chars/system
      and chars/nobody now exist from character_initialize, so the test can @chown
      an object to chars/system without creating a player first. The failure paths
      (non-wizard refused, missing object, missing owner, non-chars/ owner) are
      asserted too.
- [ ] @edit / @view: round-trip a room property through the web/MCP path
      (test_web_smoke.sh is the better host for these two). Follow-up.

## Notes

- Keep the @-command checks in their own expect block (or their own script) so a
  wizard login does not contaminate the player-command assertions.
- Decide whether any of this can be made cheap enough to wire into `make check`,
  or whether it stays a manual smoke step like the current scripts.
