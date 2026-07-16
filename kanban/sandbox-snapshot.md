---
title: Sandbox Snapshot / Restore
status: backlog
gitlab-sync: OrangeTide/boris#56
---

Deferred until the fd table, capability table, and tmp policy are stable
(after the gate items). The snapshot is NOT memcpy(cf_cpu)+memcpy(RAM):
substantial task state lives host-side. See doc/mud-cf-sandbox-design.md
"Snapshot / Restore".

## State to serialize

- [ ] CPU registers, minus the host function pointers in cf_cpu
      (read8/hypercall/bus_ctx/hypercall_ctx), which are rebuilt on
      restore, not restored.
- [ ] Guest RAM block.
- [ ] fd table (struct machine_file: types, strdup'd names, host
      callback pointers).
- [ ] Capability table ((domain handle, prefix, type, flags) per fd),
      re-resolved by name on restore. Deleted domains come back as a
      closed fd yielding -EBADF.
- [ ] tmp: ramdisk.
- [ ] In-flight HC_MSG_SEND: stale reply handles expired, sender
      unblocked with -EINTR, must retry.

## Restore

- [ ] Rebuild host-side pointers.
- [ ] Recreate syspage at its fixed address with the guest's layout so
      guest-held argv/environ pointers stay valid.
