---
title: Template Class Hierarchy
status: backlog
gitlab-sync:
---

Class templates for every object kind (room, item, container, mob, player)
organized in the `templates` domain, so shared defaults are defined once and
specialized by `%parent` inheritance. Instances (`@dig`/`@create`/OLC) seed
from a class and override only what differs. Prerequisite for zone default
templates and all OLC editors. See `doc/template-hierarchy.md`.

- [ ] kind roots under `templates/` (room, item, container, mob, player)
- [ ] `-d/` descendant-directory naming with the `%parent`-matches-path
      invariant, plus a consistency check
- [ ] seed instances via `scratch_from_template` (`%parent` set to the class)
- [ ] raise `obj_cache_prop_resolve` depth to 10 and add `%parent` cycle
      detection (refuse loops); robust/scalable resolver later
- [ ] ship a small starter set of templates in `sample/`
- [ ] tests: multi-level inheritance, invariant check, depth boundary
