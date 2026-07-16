---
title: Builder Role (ACS flag B)
status: backlog
gitlab-sync: OrangeTide/boris#69
---

Define the Builder role as ACS flag `B` (plus a minimum level) and enforce
it on building commands. No command checks privilege today; the ACS layer
(`src/acs.c`, level + flag bitset) exists but is unenforced. Operators
promote players in-game rather than editing the store. See `doc/plan.md`
Phases 0 and 4. Related: `char-permissions` (#2), `char-set-corruption`
(#3).

- [ ] gate building commands on `acs_check(&u->acs, "sNfB")`
- [ ] wizard flag `W` implies Builder
- [ ] `@grant` / `@revoke` set/clear the `B` flag (wizard-only)
- [ ] per-Builder room/zone quota by `creator` count (advisory guardrail,
      not access control; edit scope stays open)
- [ ] unit tests for the ACS gate and grant/revoke paths
