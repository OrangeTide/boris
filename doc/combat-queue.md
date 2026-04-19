# Combat queue

How combat sessions schedule their own time-driven events on top of
[phaseq](phaseq.md) and the [iox](../src/iox/) timer wheel.

## Layering

```
   combat session ---> phaseq instance (per session)
                          |
                          | head deadline
                          v
                     iox timer slot (one per session)
                          |
                          | global min() across all timers
                          v
                     iox loop (poll/epoll wakeup)
```

Each active combat session owns:

- One `struct phaseq` -- the combat's own deadline-ordered queue of
  attack ticks, status effects, recovery timers, etc.
- One iox timer slot -- the bridge to the main loop. It is always set to
  the head deadline of the combat's phaseq, and re-armed whenever that
  head changes.

The iox timer wheel is backed by `pq.h` (a binary heap), so iox already
computes the global minimum across every registered timer. The combat
layer does not need a "queue of queues."

## Lifecycle

```c
struct combat {
    struct phaseq pq;
    int           iox_timer_id;     /* -1 if none scheduled */
    /* ... combatants, state, ... */
};

void combat_open(struct combat *c, struct iox_loop *loop) {
    phaseq_init(&c->pq);
    c->iox_timer_id = -1;
}

void combat_close(struct combat *c, struct iox_loop *loop) {
    if (c->iox_timer_id >= 0)
        iox_timer_remove(loop, c->iox_timer_id);
    phaseq_done(&c->pq);
}
```

## Re-arming the iox timer

Any code path that mutates the phaseq head must re-arm the iox timer.
That's any of: `phaseq_add`, `phaseq_cancel`, `phaseq_scrub_arg`,
`phaseq_process`. Wrap the rearm logic once:

```c
static void combat_rearm(struct combat *c, struct iox_loop *loop) {
    uint64_t head = phaseq_head_deadline(&c->pq);
    if (c->iox_timer_id >= 0) {
        iox_timer_remove(loop, c->iox_timer_id);
        c->iox_timer_id = -1;
    }
    if (head == 0) return;                  /* queue empty */
    uint64_t now = phaseq_now_ms();
    int delay = (head <= now) ? 0 : (int)(head - now);
    c->iox_timer_id = iox_timer_add(loop, delay, combat_tick_cb, c);
}
```

`iox_timer_add` takes an `int` ms; combats deeper than ~24 days in the
future would saturate. Combat events live in the seconds-to-minutes
range, so this is a non-issue in practice.

## Tick callback

```c
static void combat_tick_cb(struct iox_loop *loop, void *arg) {
    struct combat *c = arg;
    c->iox_timer_id = -1;                   /* iox owns one-shot timers */
    int64_t next = phaseq_process(&c->pq);
    if (next < 0) {
        /* queue drained -- combat may be over, or just idle */
        return;
    }
    combat_rearm(c, loop);
}
```

`phaseq_process` fires every entry whose deadline has passed and returns
ms-until-next-head (or -1 if drained). The callback rearms iox using
that value.

## Per-combatant cleanup

When a combatant disconnects or dies mid-fight, drop their pending
events without disturbing the rest:

```c
phaseq_scrub_arg(&c->pq, combatant);
combat_rearm(c, loop);                       /* head may have changed */
```

This is the main reason combat uses phaseq instead of registering each
event directly with iox: bulk cancel by owner is one call.

## Why not register every event with iox directly?

You could -- iox can hold thousands of timers. But:

- **Tear-down would be O(events) per combat,** and you'd need an
  external map of `combatant -> [iox_timer_id ...]` to do bulk cancel.
  phaseq's `scrub_arg` replaces that bookkeeping.
- **Event ordering inside a combat is a domain concern,** not iox's.
  Keeping it inside `struct combat` means combat-specific introspection
  (e.g. "show me what's pending in this fight") stays local.
- **One iox slot per combat caps timer-wheel pressure** at the number
  of active combats, not the number of pending events.

The trade-off is one extra indirection per fired event (iox -> combat
callback -> phaseq_process). For combat scale (handfuls to dozens of
active sessions, each with a few pending events) this is negligible.

## Scope

This document specifies the **integration pattern**. The combat
subsystem itself does not exist yet. When it lands, it should follow
this layering rather than reinventing scheduling.
