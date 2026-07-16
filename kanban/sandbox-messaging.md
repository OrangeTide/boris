---
title: Sandbox Synchronous Messaging
status: backlog
gitlab-sync: OrangeTide/boris#55
---

Messaging is load-bearing, not optional: it is the concurrency model and
the path for domain writes (see sandbox-domain-write-model). Build after
the capability model since fd-passing depends on it. See
doc/mud-cf-sandbox-design.md "Messaging".

## Tasks

- [ ] HC_MSG_SEND (blocking RPC), HC_MSG_POST (fire-and-forget),
      HC_MSG_RECV (block on channel), HC_MSG_REPLY (unblock sender).
- [ ] Reply-handle table: system-wide, concurrency-safe (sender and
      receiver may be on different cores). 64-bit random bearer tokens IF
      delegation is in scope; otherwise validated table slots.
- [ ] Decide whether reply delegation is needed at freeze. If not, drop
      the bearer-token requirement (random tokens) for validated slots.
- [ ] Reaper: scan the table on a configurable timeout (30-300s),
      unblock timed-out senders with -ETIMEDOUT.
- [ ] fd passing in message payloads (SCM_RIGHTS style): resolve
      sender's fd at send, receiver gets a new fd in its table.
      Revocation = close.
