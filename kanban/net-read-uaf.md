---
title: net do_read use-after-free on close-during-dispatch
status: done
gitlab-sync:
---

`do_read` read `s->state` after `dispatch` may have freed the stream, a
use-after-free surfaced by `make smoke-valgrind` (7 errors, 2 contexts;
pre-existing, not from the UI login-menu port).

Sequence (`src/net/net.c`):

1. `do_read(s)` loops: `dispatch(s, NET_EVENT_DATA, ...)` (net.c:252), then
   `if (s->state != NET_STATE_CONNECTED) return;` (net.c:253).
2. `dispatch` runs the data callback. If that callback closes the connection
   (e.g. a line-input handler runs `signoff` -> `telnetclient_close`), the
   stream is queued on `g_pending_free`.
3. `dispatch` decrements `g_dispatch_depth`; at 0 it calls
   `flush_pending_frees()` (net.c:89), which `stream_free`s `s`.
4. `dispatch` returns to `do_read`, which then reads `s->state` on the freed
   block -> invalid read.

Trigger: any connection close driven from inside a data-dispatch callback,
which is the normal path for menu/line-input Quit and end-of-session.
Benign in practice (the freed memory is usually intact for the one read),
but a real UAF and a latent crash/corruption risk under load or a
different allocator.

Fixed by wrapping the whole fd callback in one dispatch scope: `net_fd_cb`
bumps `g_dispatch_depth` around `net_fd_process` and calls
`flush_pending_frees()` only after it returns. A connection closed from inside
a data/accept callback is queued (deferred free) and reclaimed only once we
have stopped touching `s`, so every post-`dispatch` read of `s->state` sees a
valid (now CLOSED) stream instead of freed memory.

- [x] chose the defer-flush approach: the fd callback is the outermost
      dispatch scope, so `flush_pending_frees` runs after `do_read`'s loop
      unwinds and `s` stays valid for the post-dispatch state check
- [x] covers the other post-`dispatch` reads in the same callback path:
      `do_accept`'s accept loop and the `wbuf_drain` -> state-check path are
      inside the same scope, so their closes defer too
- [x] `make smoke-valgrind` now reports 1 error / 1 context: only the
      pre-existing startup obj-cache leak (`obj_cache_muddb_new` <-
      `obj_initialize`), down from 12 errors / 2 contexts. The `do_read`
      invalid-read context is gone.
