/* threads.h : a cooperative C11 <threads.h> subset.
 *
 * One OS thread, no preemption: a thread runs until it explicitly yields
 * (thrd_yield) or reaches a blocking point (a contended mutex, cnd_wait, a
 * join on a thread that has not finished). The scheduler rides the libc
 * coroutine primitive (coro.h): the main function is thread 0 and the sole
 * scheduler context, every spawned thread is a coroutine over a stack the
 * implementation allocates, and a spawned thread gives up control by switching
 * back to main.
 *
 * Because scheduling is cooperative, a thread that never yields and never
 * blocks starves the rest. Spread yields through long compute loops.
 *
 * This is a subset: the interface matches C11 so code reads the same, but the
 * timing-dependent corners collapse. thrd_sleep yields and ignores its
 * duration (there is no timer), and mtx_timedlock / cnd_timedwait behave as
 * their untimed forms.
 */

#ifndef THREADS_H
#define THREADS_H

#include <stddef.h>

/* thrd_* and mtx_* status codes. */
enum {
    thrd_success = 0,
    thrd_busy = 1,
    thrd_error = 2,
    thrd_nomem = 3,
    thrd_timedout = 4,
};

/* mtx_init type flags (combinable: mtx_timed | mtx_recursive, etc.). */
enum {
    mtx_plain = 0,
    mtx_recursive = 1,
    mtx_timed = 2,
};

#define TSS_DTOR_ITERATIONS 4
#define ONCE_FLAG_INIT { 0, 0, 0 }

/* A thread handle is a pointer to the implementation's control block, so the
 * public header needs nothing from coro.h. */
typedef struct thrd *thrd_t;
typedef int (*thrd_start_t)(void *arg);
typedef void (*tss_dtor_t)(void *value);
typedef int tss_t;

typedef struct mtx {
    int type;
    int locked;
    int count;              /* recursive re-lock depth */
    thrd_t owner;
    thrd_t waiters;         /* FIFO of threads blocked acquiring this mutex */
} mtx_t;

typedef struct cnd {
    thrd_t waiters;         /* FIFO of threads blocked in cnd_wait */
} cnd_t;

typedef struct once_flag {
    int state;              /* 0 uncalled, 1 running, 2 done */
    thrd_t owner;
    thrd_t waiters;         /* callers blocked while the init function runs */
} once_flag;

/* struct timespec is referenced only by pointer in the timed calls, so an
 * incomplete declaration is enough and this header pulls in no <time.h>. */
struct timespec;

/* thread */
int    thrd_create(thrd_t *thr, thrd_start_t fn, void *arg);
int    thrd_join(thrd_t thr, int *res);
int    thrd_detach(thrd_t thr);
void   thrd_yield(void);
void   thrd_exit(int res);
thrd_t thrd_current(void);
int    thrd_equal(thrd_t a, thrd_t b);
int    thrd_sleep(const struct timespec *duration, struct timespec *remaining);

/* mutex */
int  mtx_init(mtx_t *m, int type);
int  mtx_lock(mtx_t *m);
int  mtx_trylock(mtx_t *m);
int  mtx_timedlock(mtx_t *m, const struct timespec *ts);
int  mtx_unlock(mtx_t *m);
void mtx_destroy(mtx_t *m);

/* condition variable */
int  cnd_init(cnd_t *c);
int  cnd_wait(cnd_t *c, mtx_t *m);
int  cnd_timedwait(cnd_t *c, mtx_t *m, const struct timespec *ts);
int  cnd_signal(cnd_t *c);
int  cnd_broadcast(cnd_t *c);
void cnd_destroy(cnd_t *c);

/* one-time call */
void call_once(once_flag *flag, void (*func)(void));

/* thread-specific storage */
int   tss_create(tss_t *key, tss_dtor_t dtor);
void *tss_get(tss_t key);
int   tss_set(tss_t key, void *value);
void  tss_delete(tss_t key);

#endif /* THREADS_H */
