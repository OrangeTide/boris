/* coro.h : stackful coroutines over a caller-provided buffer.
 *
 * A coroutine is a function that can suspend itself with co_yield and later be
 * resumed where it left off, carrying a value across each switch. It is the
 * substrate a cooperative scheduler (a threads.h subset) sits on.
 *
 * The primitive never allocates. The caller hands co_create one buffer; the
 * control block and the private stack are carved from it, so the coroutine
 * lives entirely inside memory the caller owns and controls the lifetime of.
 *
 * Single-threaded: exactly one coroutine runs at a time, tracked in a file
 * static, so these calls are not safe to use from more than one thread at once.
 *
 * There is no guard page (this libc has no mmap), so a coroutine that overruns
 * its stack has undefined behavior. Size the buffer for the deepest call the
 * body makes. co_resume checks a canary as a cheap smoke test for a shallow
 * overrun, but it is not a guarantee.
 */

#ifndef CORO_H
#define CORO_H

#include <stddef.h>

/* An opaque coroutine handle. It points into the caller's buffer. */
typedef struct coro coro_t;

/* A coroutine body: receives the value from the first co_resume and returns a
 * final value that the resume ending it reports. */
typedef void *(*co_fn_t)(void *arg);

/* Bytes co_create reserves in the buffer before any usable stack remains. A
 * caller budgets its buffer as CO_OVERHEAD plus the stack depth the body needs.
 * This is a conservative upper bound across every target. */
#define CO_OVERHEAD 256u

/* Carve a coroutine from buf (size bytes). No allocation is performed. Returns
 * a handle into buf, or NULL when buf is too small (size <= CO_OVERHEAD) or
 * misaligned beyond repair. buf must outlive the coroutine. The body does not
 * run until the first co_resume. */
coro_t *co_create(void *buf, size_t size, co_fn_t fn, void *arg);

/* Resume co, handing it value. Returns the value co passes to co_yield, or the
 * value its body returns when it finishes. Resuming a finished coroutine
 * returns NULL. */
void *co_resume(coro_t *co, void *value);

/* Suspend the running coroutine, handing value to its resumer. Returns the
 * value the next co_resume hands back. Calling it outside a coroutine (co_self
 * would be NULL) is undefined. */
void *co_yield(void *value);

/* Nonzero once the coroutine's body has returned. */
int co_done(const coro_t *co);

/* The running coroutine, or NULL on the initial (host) context. */
coro_t *co_self(void);

#endif /* CORO_H */
