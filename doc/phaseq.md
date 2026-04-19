# phaseq -- per-instance deadline-ordered event queue

`phaseq` is a small scheduler primitive. Each instance is a sorted
singly-linked list of `{deadline_ms, callback, arg, str}` entries. Owners
poll the head to learn when to wake, and call `phaseq_process()` to fire
all entries whose deadline has passed.

Originally from gredin (2007 J.Mayo). Imported into boris 2026.

## When to use phaseq vs pq.h

| concern                     | phaseq                                    | pq.h                              |
|-----------------------------|-------------------------------------------|-----------------------------------|
| shape                       | sorted linked list                        | flat binary heap                  |
| insert                      | O(n)                                      | O(log n)                          |
| pop                         | O(1)                                      | O(log n)                          |
| callback model              | built-in (`func(arg, str)`)               | none -- caller dispatches         |
| stable handle               | `event_id` from a pool                    | array index, invalidated on edits |
| cancel-by-owner             | `phaseq_scrub_arg(arg)`                   | open-coded                        |
| best when                   | small queues, callback-shaped events,     | large/hot queues, raw key order,  |
|                             | clean per-owner tear-down                 | no callback indirection           |

Rule of thumb: **phaseq is the gameplay scheduler** (combat, spell timers,
room programs, NPC ticks). **pq.h is the substrate** for the iox timer
wheel and any other low-level scheduler core.

## API (target shape after refactor)

```c
#include "util/phaseq.h"

struct phaseq;                          /* opaque */

typedef void (*phaseq_func_t)(void *arg, const char *str);

uint64_t phaseq_now_ms(void);           /* CLOCK_MONOTONIC, ms */

int  phaseq_init(struct phaseq *q);
void phaseq_done(struct phaseq *q);

poolid_t phaseq_add(struct phaseq *q, uint64_t deadline_ms,
                    phaseq_func_t func, void *arg, const char *str);

int phaseq_cancel(struct phaseq *q, poolid_t event_id);
int phaseq_scrub_arg(struct phaseq *q, const void *arg);

/* Absolute deadline of the head entry, or 0 if empty. */
uint64_t phaseq_head_deadline(const struct phaseq *q);

/* Fire all due entries. Returns ms-until-next-head, or -1 if empty. */
int64_t phaseq_process(struct phaseq *q);

/* Same, but using a caller-supplied 'now' (avoids a clock read when the
 * caller already has one, and lets tests advance time deterministically). */
int64_t phaseq_process_at(struct phaseq *q, uint64_t now_ms);
```

`struct phaseq` is exposed in the header (so callers can embed one in their
own struct) but its fields are implementation-only. Each instance owns its
own `id_pool` for `event_id`, so handles from different queues don't
collide and there is no global state.

### Time base

Deadlines are absolute `uint64_t` milliseconds from `CLOCK_MONOTONIC`.
Use `phaseq_now_ms() + delta_ms` to schedule "delta_ms from now".
A monotonic 64-bit ms counter has ~292M years of range -- no wrap to
worry about.

### What was removed

- **Group ids.** When each combat/spell/program owns its own queue
  instance, the queue *is* the group. Removed `phaseq_group_new`,
  `phaseq_group_release`, `phaseq_scrub_group`. `phaseq_scrub_arg` is
  retained for partial cleanup inside a multi-participant queue
  (e.g. one character logs out of an active combat).
- **Global init/done and `phaseq_ready`.** Each instance is independent.
- **`time_t` deadlines.** Replaced with monotonic `uint64_t` ms.

## Aggregating across many queues

`phaseq_process()` only handles one instance. When you have many
(e.g. one per active combat), use the existing iox timer wheel as the
global aggregator -- see [combat-queue.md](combat-queue.md).

## Refactor plan (status: not started)

The pre-refactor file (`src/util/phaseq.{h,c}`) has a single global
queue, `time_t` resolution, group ids, and `phaseq_ready` state. The
refactor replaces that with the API above.

1. Add `doc/phaseq.md` and `doc/combat-queue.md`. (this document, and a
   companion describing the layered design.)
2. Write `src/util/test_phaseq.c` against the **target** API. Wire into
   `src/util/module.mk` as `test_phaseq`. Tests should exercise:
   - per-instance init/done
   - ordered insertion regardless of insert order
   - `phaseq_head_deadline` matches the earliest entry
   - `phaseq_cancel` removes by event_id
   - `phaseq_scrub_arg` removes all entries for an arg
   - `phaseq_process` fires due entries in deadline order
   - `phaseq_process` returns ms-until-next-head, or -1 if empty
   - two independent instances do not interfere (event_ids, callbacks)
   - 64-bit ms deadlines well past 2^32 still order correctly
3. Refactor `phaseq.h` / `phaseq.c` to match. Tests turn green.
4. Update `TODO.md`: drop the "use pq.h for all priority queues" line
   in favor of the phaseq/pq division of responsibility.

A combat-queue implementation that consumes phaseq is **out of scope**
for this refactor; design captured in `combat-queue.md`.
