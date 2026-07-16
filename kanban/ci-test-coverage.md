---
title: CI and Test Infrastructure for Builder Work
status: backlog
gitlab-sync:
---

Close CI gaps as the Builder/OLC work lands. Current `.gitlab-ci.yml` runs
build, unit, smoke, and valgrind, but not the cas backend, and there is no
end-to-end harness for interactive sessions. Invest in shared test helpers
rather than copy-pasted expect scripts. See `doc/plan.md` section 5.

- [ ] add `make smoke-cas` to `.gitlab-ci.yml`
- [ ] register each new suite (UI layer, zone, builder_save) so it runs on
      every merge request
- [ ] end-to-end OLC/wizard harness: drive a build session, assert the
      saved OBJ
- [ ] scripted client driver shared across smoke tests
- [ ] consider an ARM cross-build job given the `.env` cross-compile hazard
