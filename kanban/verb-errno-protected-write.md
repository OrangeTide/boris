---
title: sys_errno Granularity for Protected Writes
status: backlog
gitlab-sync:
---

From the L7 authority review of the [[vm-object-model]] card. sys_setprop
reports VM_ERR_INVAL both for a malformed value and for a refused protected name
(a leading % or !, which obj_prop_set rejects), so a guest cannot tell the two
apart.

- [ ] give a refused protected name a distinct sys_errno code (reuse
      VM_ERR_DENIED, or add a VM_ERR_PROTECTED)
- [ ] see hc_setprop in src/verb/verb_dispatch.c
