/* iox_timer.c : I/O multiplexer -- one-shot timers via priority queue */

#include "iox_timer.h"
#include "iox_internal.h"
#include "iox_plat.h"

#include <limits.h>
#include <stdint.h>
#include <stdlib.h>

#define IOX_MAX_TIMERS 16

struct iox_timer_entry {
    int64_t deadline_ns;
    iox_timer_cb cb;
    void *arg;
    int id;
};

#define PQ_NAME       timer_pq
#define PQ_ENTRY_TYPE struct iox_timer_entry
#define PQ_KEY(e)     ((e).deadline_ns)
#define PQ_STATIC
#define PQ_IMPLEMENTATION
#include "pq.h"

struct iox_timers {
    struct timer_pq pq;
    int next_id;
};

static int64_t
now_ns(void)
{
    return (int64_t)iox_plat_mono_ns();
}

static int
id_in_use(struct iox_timers *t, int id)
{
    unsigned i;

    for (i = 0; i < timer_pq_size(&t->pq); i++) {
        struct iox_timer_entry *e = timer_pq_peek(&t->pq, i);

        if (e && e->id == id)
            return 1;
    }
    return 0;
}

/* Hand out a non-negative ID that no pending timer is using.
 *
 * next_id wraps at INT_MAX rather than overflowing. Wrapping can collide
 * with a long-lived pending timer, so the in-use scan skips those. The
 * queue is small, and the scan only ever runs after a wrap. */
static int
alloc_id(struct iox_timers *t)
{
    unsigned tries, limit;

    limit = timer_pq_size(&t->pq) + 1;

    for (tries = 0; tries < limit; tries++) {
        int id = t->next_id;

        t->next_id = (t->next_id == INT_MAX) ? 0 : t->next_id + 1;
        if (!id_in_use(t, id))
            return id;
    }

    return IOX_ERR;
}

int
iox_timer_init(struct iox_loop *loop)
{
    struct iox_timers *t;

    if (loop->timers)
        return IOX_OK;

    t = calloc(1, sizeof(*t));
    if (!t)
        return IOX_ERR;

    if (!timer_pq_init(&t->pq, IOX_MAX_TIMERS)) {
        free(t);
        return IOX_ERR;
    }

    t->next_id = 0;
    loop->timers = t;
    return IOX_OK;
}

void
iox_timer_shutdown(struct iox_loop *loop)
{
    if (!loop->timers)
        return;

    timer_pq_free(&loop->timers->pq);
    free(loop->timers);
    loop->timers = NULL;
}

int
iox_timer_add(struct iox_loop *loop, int ms, iox_timer_cb cb, void *arg)
{
    struct iox_timers *t = loop->timers;
    struct iox_timer_entry e;

    if (!t)
        return IOX_ERR;

    if (ms < 0)
        ms = 0;

    e.deadline_ns = now_ns() + (int64_t)ms * 1000000LL;
    e.cb = cb;
    e.arg = arg;
    e.id = alloc_id(t);
    if (e.id < 0)
        return IOX_ERR;

    if (!timer_pq_enqueue(&t->pq, e)) {
        /* queue full -- try to grow */
        if (!timer_pq_resize(&t->pq, t->pq.max * 2))
            return IOX_ERR;
        if (!timer_pq_enqueue(&t->pq, e))
            return IOX_ERR;
    }

    return e.id;
}

void
iox_timer_remove(struct iox_loop *loop, int id)
{
    struct iox_timers *t = loop->timers;
    struct iox_timer_entry probe;
    unsigned i;

    if (!t)
        return;

    /* linear scan by ID -- fine for small timer counts */
    for (i = 0; i < timer_pq_size(&t->pq); i++) {
        struct iox_timer_entry *e = timer_pq_peek(&t->pq, i);

        if (e && e->id == id) {
            timer_pq_remove(&t->pq, i, &probe);
            return;
        }
    }
}

int
iox_timer_next_ms(struct iox_loop *loop)
{
    struct iox_timers *t = loop->timers;
    struct iox_timer_entry *top;
    int64_t diff;

    /* -1 here is poll()'s "block indefinitely", not IOX_ERR. With no
     * timers pending there is no deadline to wake up for. */
    if (!t)
        return -1;

    top = timer_pq_top(&t->pq);
    if (!top)
        return -1;

    diff = (top->deadline_ns - now_ns() + 999999LL) / 1000000LL;
    if (diff < 0)
        diff = 0;
    if (diff > (int64_t)0x7FFFFFFF)
        diff = 0x7FFFFFFF;
    return (int)diff;
}

void
iox_timer_dispatch(struct iox_loop *loop)
{
    struct iox_timers *t = loop->timers;
    struct iox_timer_entry e;
    int64_t deadline;

    if (!t)
        return;

    /* Snapshot the cutoff before dispatching. A callback that re-arms
     * with ms == 0 then lands past the cutoff and runs on the next
     * iteration, rather than spinning inside this loop. */
    deadline = now_ns();

    while (timer_pq_top(&t->pq) &&
        timer_pq_top(&t->pq)->deadline_ns <= deadline) {
        if (!timer_pq_dequeue(&t->pq, &e))
            break;
        if (e.cb)
            e.cb(loop, e.arg);
    }
}
