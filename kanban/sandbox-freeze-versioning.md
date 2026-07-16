---
title: Sandbox ABI Freeze + Program Versioning
status: backlog
gitlab-sync:
---

The freeze line, drawn only after gate items 1-4 are met AND have
survived a real workload. See doc/mud-cf-sandbox-design.md "Roadmap".

Do NOT start this until the gates are green. Adopting freeze discipline
early is the mistake this plan corrects. The elaborate versioning
machinery (NT_MUD_ABI used-hypercall bitmap, symbol-versioned syspage
helpers, append-only record governance) was dropped for being premature;
reintroduce only what independently-distributed binaries actually
require, which pre-release is nothing.

## Gate check (all must be true, proven under load)

- [ ] Unprivileged execution works (sandbox-unprivileged-exec).
- [ ] Single-writer-per-domain proven under multicore load
      (sandbox-domain-write-model).
- [ ] Credits + scheduler real and exercised (sandbox-credits-scheduler).
- [ ] Capability model real (sandbox-capability-model).

## Freeze tasks

- [ ] Freeze hypercall IDs, register conventions, record layouts.
- [ ] Add a single monotonic program-version check at load (refuse on
      mismatch). Nothing more elaborate.
- [ ] Adopt append-only discipline for structured records.
- [ ] Update the design doc: flip the status banner from EXPERIMENTAL /
      PRE-FREEZE to frozen, document the compatibility policy.

## Deferred past the freeze

Symbol-versioned syspage helpers, program-distribution story, GDB stub,
typed hypercalls for non-obj domains, multi-thread-per-task.
