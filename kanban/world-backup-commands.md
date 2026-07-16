---
title: In-Game World Backup Commands
status: backlog
gitlab-sync:
---

Protect builder data with in-game snapshot and export commands so a bad
edit, wipe, or crash does not cost a builder their work, without shell
access. First cut only; full snapshot / rollback / gc / diff follow
`doc/snapshot-proposal.md` in a later phase. Distinct from the ColdFire
`sandbox-snapshot` (#56), which is emulator task state, not the world DB.
See `doc/plan.md` Phase 0.

- [ ] `@checkpoint <label>` -- named snapshot before risky work
- [ ] world export/dump command over the `muddb-tool` JSON-record format
- [ ] wizard-only, wired through the ACS gate
- [ ] extend `doc/snapshot-proposal.md` with the in-game command surface
- [ ] tests: checkpoint then export round-trips the world store
