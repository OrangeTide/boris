---
title: Zone Model
status: backlog
gitlab-sync: OrangeTide/boris#77
---

Light grouping unit for content. A zone is a small OBJ in `objs`
(`zones/<id>`) and is the anchor for `dig` templates and per-Builder
quotas. Room ids inside a zone are namespaced `<zone>/<room>`. Kept
deliberately minimal; not the ColdFire sandbox area model. See `doc/plan.md`
Phase 1. Depends on nothing; `builder-commands` (#6) and `builder-role`
build on it.

- [ ] write `doc/zone-spec.md` before coding (data model, commands)
- [ ] zone record: title, creator, id-prefix, default `dig` template
- [ ] `<zone>/<room>` id namespacing
- [ ] load/save round-trip tests
