---
title: Sandbox Capability / dirfd Model
status: backlog
gitlab-sync:
---

Gate item 4 for freezing the sandbox ABI. Replaces the two hardcoded
verb:/event: prefixes the prototype recognizes with the real security
boundary. See doc/mud-cf-sandbox-design.md "Capabilities and Filesystem".

The fd table is meant to BE the security boundary. Today HC_OPEN only
parses verb:/event: (machine.c:230-243); there is no dirfd, capability,
blob/object domain, or filesystem. Build the model.

## Tasks

- [ ] HC_OPENAT: dirfd + path + intent flags -> capability-scoped fd.
      Path resolution rules: reject "..", collapse "//", leading "/" and
      "." mean root of the dirfd scope.
- [ ] Capability flags: 2-bit access mode + family bits (O_BLOB,
      O_OBJECT, O_DIRECTORY, O_PROGRAM, O_MSGCHAN) + blob modifiers.
      O_ACC_NONE only with O_PROGRAM.
- [ ] Domain type tag on each dirfd. Blob hypercalls (HC_READ/HC_WRITE)
      accept only blob-domain fds; object domains use HC_OBJ_PROP_* on
      O_OBJECT fds.
- [ ] Standard domains: tmp: (per-task RAM), bin: (blob), obj: (object),
      session:, local:, area:, world:, service:.
- [ ] Env block in syspage maps well-known names to fd numbers
      (DIR_/OBJ_/MSGCHAN_/PROG_). mud_getenv(key) in guest libc.
- [ ] HC_SPAWN delegation: (dirfd, flags) pairs, host validates against
      parent fd table, clamps flags (child <= parent), installs as child
      initial caps.
- [ ] Reconcile fd-table size to one number (prototype uses 256; earlier
      draft stated a cap of 127).
