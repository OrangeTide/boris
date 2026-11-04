/* threads.c : a cooperative C11 threads.h subset over the coroutine primitive.
 *
 * The scheduler is a plain client of coro.h (co_create / co_resume / co_yield /
 * co_done / co_self); it reaches into none of the coroutine internals. One rule
 * makes the asymmetric resume/yield API enough:
 *
 *   Main (the function that calls into this library) is thread 0 and the sole
 *   scheduler context. It runs on the host stack. Every spawned thread is a
 *   coroutine over an allocated stack. A spawned thread gives up control only
 *   by co_yield-ing back to main; it never runs a scheduler loop itself. When
 *   main blocks, it drives the run queue directly until its own wait is met.
 *
 * So only main ever holds a scheduler loop, which keeps the extra native stack
 * per blocking call O(1) and never nests pump loops.
 */

#include "threads.h"

#include <coro.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/* The private stack each spawned thread runs on. CO_OVERHEAD covers the
 * coroutine control block carved from the same buffer. */
#define THREAD_STACK_SIZE (64u * 1024u)

/* Thread-specific-storage key slots shared across all threads. */
#define TSS_MAX 32

enum {
    ST_READY,       /* on the run queue, not yet resumed */
    ST_RUNNING,     /* currently resumed (main, or a spawned coroutine) */
    ST_BLOCKED,     /* off every run queue, parked on a wait list */
    ST_DONE,        /* body returned or thrd_exit'd; awaiting reap */
};

struct thrd {
    coro_t *co;                 /* NULL for the main thread */
    void *buf;                  /* coroutine buffer (stack+control); NULL for main */
    int state;
    int ret;                    /* the thrd_start_t result */
    int detached;
    thrd_start_t fn;
    void *arg;
    struct thrd *qnext;         /* link for the run queue or one wait list */
    struct thrd *join_waiters;  /* threads blocked in thrd_join on this one */
    void *tss[TSS_MAX];
};

/* Thread 0: the host context. It has no coroutine; it is resumed by nothing. */
static struct thrd main_thread;
static struct thrd *cur;

/* The FIFO run queue holds only spawned threads that are ST_READY. Main is
 * never enqueued; it is "ready" by state alone (see ready()). */
static struct thrd *rq_head;
static struct thrd *rq_tail;

static int inited;

/* Shared TSS key table: a used flag and a destructor per slot. */
static tss_dtor_t tss_dtors[TSS_MAX];
static int tss_used[TSS_MAX];

static void
ensure_init(void)
{
    if (!inited) {
        inited = 1;
        main_thread.state = ST_RUNNING;
        cur = &main_thread;
    }
}

/* Run queue: push to the tail, pop from the head, for round-robin fairness. */
static void
rq_push(struct thrd *t)
{
    t->qnext = NULL;
    if (rq_tail != NULL)
        rq_tail->qnext = t;
    else
        rq_head = t;
    rq_tail = t;
}

static struct thrd *
rq_pop(void)
{
    struct thrd *t = rq_head;

    if (t != NULL) {
        rq_head = t->qnext;
        if (rq_head == NULL)
            rq_tail = NULL;
        t->qnext = NULL;
    }
    return t;
}

/* Mark a thread runnable. Main carries no run-queue slot; it becomes runnable
 * by state, which its own block loop polls. A spawned thread joins the queue. */
static void
ready(struct thrd *t)
{
    t->state = ST_READY;
    if (t != &main_thread)
        rq_push(t);
}

/* A FIFO wait list (mutex, cnd, join, once). A thread is on at most one list at
 * a time, so the single qnext link is shared with the run queue. */
static void
wq_push(struct thrd **head, struct thrd *t)
{
    struct thrd *p = *head;

    t->qnext = NULL;
    if (p == NULL) {
        *head = t;
        return;
    }
    while (p->qnext != NULL)
        p = p->qnext;
    p->qnext = t;
}

static struct thrd *
wq_pop(struct thrd **head)
{
    struct thrd *t = *head;

    if (t != NULL) {
        *head = t->qnext;
        t->qnext = NULL;
    }
    return t;
}

static void run_tss_dtors(struct thrd *t);

/* Free a finished thread's resources. The coroutine lives inside buf, so one
 * free reclaims the stack and the control block; the thrd struct is separate.
 * Main is never reaped. */
static void
reap(struct thrd *t)
{
    if (t == &main_thread)
        return;
    free(t->buf);
    free(t);
}

/* Resume a ready spawned thread for one slice. It returns here when it yields,
 * blocks, or finishes. On completion (a body return, or a thrd_exit that set
 * ST_DONE before switching away) wake its joiners and, if detached, reap it. */
static void
run(struct thrd *t)
{
    struct thrd *prev = cur;
    struct thrd *w;

    cur = t;
    t->state = ST_RUNNING;
    co_resume(t->co, NULL);
    cur = prev;

    if (co_done(t->co) || t->state == ST_DONE) {
        t->state = ST_DONE;
        while ((w = wq_pop(&t->join_waiters)) != NULL)
            ready(w);
        if (t->detached)
            reap(t);
    }
}

/* Give up the CPU until the current thread is runnable again. The caller has
 * already set cur->state (ST_BLOCKED to park on a wait list, or the yield path
 * re-readies cur first). Main drives the run queue; a spawned thread switches
 * back to main, which resumes it once its wait is satisfied. */
static void
block_current(void)
{
    if (cur == &main_thread) {
        while (cur->state == ST_BLOCKED) {
            struct thrd *t = rq_pop();
            if (t == NULL)
                abort();        /* main is blocked and nothing can run it: deadlock */
            run(t);
        }
        cur->state = ST_RUNNING;
    } else {
        co_yield(NULL);
        cur->state = ST_RUNNING;
    }
}

/* The body a spawned coroutine first enters. Run the user function, record its
 * result, run destructors, mark done, and return so the resuming run() reaps. */
static void *
thread_trampoline(void *arg)
{
    struct thrd *t = arg;

    t->ret = t->fn(t->arg);
    run_tss_dtors(t);
    t->state = ST_DONE;
    return NULL;
}

int
thrd_create(thrd_t *thr, thrd_start_t fn, void *arg)
{
    struct thrd *t;
    size_t bufsize = (size_t)CO_OVERHEAD + THREAD_STACK_SIZE;

    ensure_init();
    if (fn == NULL)
        return thrd_error;

    t = malloc(sizeof *t);
    if (t == NULL)
        return thrd_nomem;
    memset(t, 0, sizeof *t);

    t->buf = malloc(bufsize);
    if (t->buf == NULL) {
        free(t);
        return thrd_nomem;
    }
    t->fn = fn;
    t->arg = arg;
    t->co = co_create(t->buf, bufsize, thread_trampoline, t);
    if (t->co == NULL) {
        free(t->buf);
        free(t);
        return thrd_error;
    }

    ready(t);
    if (thr != NULL)
        *thr = t;
    return thrd_success;
}

int
thrd_join(thrd_t t, int *res)
{
    ensure_init();
    if (t == NULL || t == &main_thread || t->detached)
        return thrd_error;

    while (t->state != ST_DONE) {
        wq_push(&t->join_waiters, cur);
        cur->state = ST_BLOCKED;
        block_current();
    }
    if (res != NULL)
        *res = t->ret;
    reap(t);
    return thrd_success;
}

int
thrd_detach(thrd_t t)
{
    ensure_init();
    if (t == NULL || t == &main_thread || t->detached)
        return thrd_error;
    t->detached = 1;
    if (t->state == ST_DONE)
        reap(t);
    return thrd_success;
}

void
thrd_yield(void)
{
    ensure_init();
    if (cur == &main_thread) {
        struct thrd *t = rq_pop();
        if (t != NULL)
            run(t);
    } else {
        ready(cur);
        co_yield(NULL);
        cur->state = ST_RUNNING;
    }
}

void
thrd_exit(int res)
{
    ensure_init();
    if (cur == &main_thread) {
        run_tss_dtors(cur);
        exit(res);
    }
    cur->ret = res;
    run_tss_dtors(cur);
    cur->state = ST_DONE;
    co_yield(NULL);         /* run() sees ST_DONE and reaps; control never returns */
    for (;;)
        co_yield(NULL);
}

thrd_t
thrd_current(void)
{
    ensure_init();
    return cur;
}

int
thrd_equal(thrd_t a, thrd_t b)
{
    return a == b;
}

int
thrd_sleep(const struct timespec *duration, struct timespec *remaining)
{
    (void)duration;
    (void)remaining;
    thrd_yield();           /* cooperative: no timer, so sleep is a yield */
    return 0;
}

int
mtx_init(mtx_t *m, int type)
{
    m->type = type;
    m->locked = 0;
    m->count = 0;
    m->owner = NULL;
    m->waiters = NULL;
    return thrd_success;
}

void
mtx_destroy(mtx_t *m)
{
    (void)m;
}

int
mtx_lock(mtx_t *m)
{
    ensure_init();
    if (m->locked && m->owner == cur && (m->type & mtx_recursive)) {
        m->count++;
        return thrd_success;
    }
    while (m->locked) {
        wq_push(&m->waiters, cur);
        cur->state = ST_BLOCKED;
        block_current();
    }
    m->locked = 1;
    m->owner = cur;
    m->count = 1;
    return thrd_success;
}

int
mtx_trylock(mtx_t *m)
{
    ensure_init();
    if (m->locked) {
        if (m->owner == cur && (m->type & mtx_recursive)) {
            m->count++;
            return thrd_success;
        }
        return thrd_busy;
    }
    m->locked = 1;
    m->owner = cur;
    m->count = 1;
    return thrd_success;
}

int
mtx_timedlock(mtx_t *m, const struct timespec *ts)
{
    int r;

    (void)ts;
    r = mtx_trylock(m);
    return r == thrd_busy ? thrd_timedout : r;
}

int
mtx_unlock(mtx_t *m)
{
    struct thrd *w;

    ensure_init();
    if ((m->type & mtx_recursive) && --m->count > 0)
        return thrd_success;

    m->locked = 0;
    m->owner = NULL;
    m->count = 0;
    w = wq_pop(&m->waiters);
    if (w != NULL)
        ready(w);
    return thrd_success;
}

int
cnd_init(cnd_t *c)
{
    c->waiters = NULL;
    return thrd_success;
}

void
cnd_destroy(cnd_t *c)
{
    (void)c;
}

int
cnd_wait(cnd_t *c, mtx_t *m)
{
    struct thrd *w;
    int depth;

    ensure_init();

    /* Release the mutex fully (a recursive depth is saved and restored on
     * wake) and hand it to a waiter, then block on the condition variable. */
    depth = m->count;
    m->locked = 0;
    m->owner = NULL;
    m->count = 0;
    w = wq_pop(&m->waiters);
    if (w != NULL)
        ready(w);

    wq_push(&c->waiters, cur);
    cur->state = ST_BLOCKED;
    block_current();

    /* Re-acquire on wake. Another thread may hold it, so contend normally. */
    while (m->locked) {
        wq_push(&m->waiters, cur);
        cur->state = ST_BLOCKED;
        block_current();
    }
    m->locked = 1;
    m->owner = cur;
    m->count = depth > 0 ? depth : 1;
    return thrd_success;
}

int
cnd_timedwait(cnd_t *c, mtx_t *m, const struct timespec *ts)
{
    (void)ts;
    return cnd_wait(c, m);
}

int
cnd_signal(cnd_t *c)
{
    struct thrd *w;

    ensure_init();
    w = wq_pop(&c->waiters);
    if (w != NULL)
        ready(w);
    return thrd_success;
}

int
cnd_broadcast(cnd_t *c)
{
    struct thrd *w;

    ensure_init();
    while ((w = wq_pop(&c->waiters)) != NULL)
        ready(w);
    return thrd_success;
}

void
call_once(once_flag *flag, void (*func)(void))
{
    struct thrd *w;

    ensure_init();
    if (flag->state == 2)
        return;
    if (flag->state == 1) {
        /* The init function is in progress on another thread that yielded.
         * Wait for it to finish. */
        while (flag->state != 2) {
            wq_push(&flag->waiters, cur);
            cur->state = ST_BLOCKED;
            block_current();
        }
        return;
    }
    flag->state = 1;
    flag->owner = cur;
    func();
    flag->state = 2;
    while ((w = wq_pop(&flag->waiters)) != NULL)
        ready(w);
}

int
tss_create(tss_t *key, tss_dtor_t dtor)
{
    int i;

    ensure_init();
    for (i = 0; i < TSS_MAX; i++) {
        if (!tss_used[i]) {
            tss_used[i] = 1;
            tss_dtors[i] = dtor;
            *key = i + 1;           /* 1-based: 0 is never a valid key */
            return thrd_success;
        }
    }
    return thrd_error;
}

void *
tss_get(tss_t key)
{
    ensure_init();
    if (key < 1 || key > TSS_MAX)
        return NULL;
    return cur->tss[key - 1];
}

int
tss_set(tss_t key, void *value)
{
    ensure_init();
    if (key < 1 || key > TSS_MAX)
        return thrd_error;
    cur->tss[key - 1] = value;
    return thrd_success;
}

void
tss_delete(tss_t key)
{
    if (key < 1 || key > TSS_MAX)
        return;
    tss_used[key - 1] = 0;
    tss_dtors[key - 1] = NULL;
}

/* Run the current-thread destructors at exit, C11-style: repeat up to
 * TSS_DTOR_ITERATIONS times, clearing a slot before calling its destructor and
 * stopping once a pass finds nothing left to do. */
static void
run_tss_dtors(struct thrd *t)
{
    int iter, i, any;

    for (iter = 0; iter < TSS_DTOR_ITERATIONS; iter++) {
        any = 0;
        for (i = 0; i < TSS_MAX; i++) {
            if (tss_used[i] && tss_dtors[i] != NULL && t->tss[i] != NULL) {
                void *v = t->tss[i];
                t->tss[i] = NULL;
                tss_dtors[i](v);
                any = 1;
            }
        }
        if (!any)
            break;
    }
}
