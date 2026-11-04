/* coro.c : stackful coroutines over a caller-provided buffer.
 *
 * The arch-specific half is co_switch (co_switch_<arch>.S): it saves the
 * callee-saved registers on the current stack, swaps the stack pointer through
 * the two co_ctx pointers, and returns on the switched-to stack. Everything
 * here is portable: carve a control block and a private stack from the caller's
 * buffer, seed the private stack so the first switch lands in co_trampoline,
 * and drive the resume/yield handoff. No allocation, single-threaded. */

#include "coro.h"

#include <stdint.h>

/* A saved machine context is just the stack pointer; the callee-saved registers
 * and the return address live on the switched-to stack. Must match the layout
 * co_switch_<arch>.S reads (co_ctx.sp at offset 0). */
struct co_ctx {
    void *sp;
};

void co_switch(struct co_ctx *from, struct co_ctx *to);

enum co_state {
    CO_SUSPENDED,
    CO_RUNNING,
    CO_DONE,
};

struct coro {
    struct co_ctx ctx;          /* saved context while suspended */
    struct co_ctx *resumer;     /* context to switch back to on yield/return */
    co_fn_t fn;                 /* the body */
    void *arg;                  /* its seed argument */
    void *xfer;                 /* value carried across a switch, both ways */
    uint32_t *canary;           /* just below the stack; checked after a switch */
    int state;
};

#define CO_CANARY 0xc0dec0deu

/* The running coroutine, or NULL on the initial host context. Single-threaded:
 * only one coroutine runs at a time, so a plain static needs no locking. */
static struct coro *current;

/* The first thing a new coroutine runs. It reads the control block from
 * `current` (the resume set it before switching in), calls the body, records
 * the result, marks the coroutine done, and switches back to its resumer. It
 * never returns: a completed coroutine is resumed no further. */
static void
co_trampoline(void)
{
    struct coro *co = current;

    co->xfer = co->fn(co->arg);
    co->state = CO_DONE;
    co_switch(&co->ctx, co->resumer);
}

coro_t *
co_create(void *buf, size_t size, co_fn_t fn, void *arg)
{
    struct coro *co;
    uintptr_t lo, hi, top, stack_lo;
    uint32_t *canary;

    if (buf == NULL || fn == NULL)
        return NULL;

    /* The control block sits at the low end of the buffer (16-aligned), the
     * canary just above it, and the private stack above that, growing down
     * from the 16-aligned top. An overrun of the stack runs into the canary
     * before the control block. */
    lo = (uintptr_t)buf;
    hi = lo + size;
    co = (struct coro *)((lo + 15u) & ~(uintptr_t)15);
    canary = (uint32_t *)((uintptr_t)co + sizeof(*co));
    stack_lo = (uintptr_t)canary + 4u;
    top = hi & ~(uintptr_t)15;

    /* Need room for the control block, the canary, a seed frame, and some
     * usable stack. 256 bytes of stack past the largest seed is the floor. */
    if (top < stack_lo || top - stack_lo < 256u)
        return NULL;

    co->fn = fn;
    co->arg = arg;
    co->xfer = NULL;
    co->canary = canary;
    co->state = CO_SUSPENDED;
    *canary = CO_CANARY;

    /* Seed the private stack so the first co_switch restores a block of
     * (unused) callee-saved slots and returns into co_trampoline. The block's
     * shape matches this target's co_switch, so the seed is per-target. */
#if defined(__skj_m68k__) || defined(__m68k__)
    /* ColdFire co_switch restores d2-d7 (movem), a2-a6, fp2-fp7, then rts into
     * the word just above the 96-byte block. */
    {
        uint32_t *b;
        int i;
        uintptr_t base = top - 100u;
        b = (uint32_t *)base;
        for (i = 0; i < 25; i++)        /* 96 bytes of regs + the ret slot */
            b[i] = 0;
        b[24] = (uint32_t)(uintptr_t)co_trampoline;   /* ret slot at base+96 */
        co->ctx.sp = (void *)base;
    }
#elif defined(__skj_riscv__) || (defined(__riscv) && __riscv_xlen == 32)
    /* RV32 co_switch restores ra and s0-s11 then fs0-fs11, a 160-byte block,
     * then ret into ra (word 0). */
    {
        uint32_t *b;
        int i;
        uintptr_t base = top - 160u;
        b = (uint32_t *)base;
        for (i = 0; i < 40; i++)
            b[i] = 0;
        b[0] = (uint32_t)(uintptr_t)co_trampoline;    /* ra at word 0 */
        co->ctx.sp = (void *)base;
    }
#elif defined(__skj_mips__) || defined(__mips__)
    /* MIPS co_switch restores s0-s7, s8/fp, ra, then f20-f31 (as single-word
     * pairs); a 96-byte block, jr ra with ra at offset 36 (word 9). */
    {
        uint32_t *b;
        int i;
        uintptr_t base = top - 96u;
        b = (uint32_t *)base;
        for (i = 0; i < 24; i++)
            b[i] = 0;
        b[9] = (uint32_t)(uintptr_t)co_trampoline;    /* ra at base+36 */
        co->ctx.sp = (void *)base;
    }
#elif defined(__skj_arm64__) || defined(__aarch64__)
    /* AArch64 co_switch restores d8-d15 then x19-x30 with ldp, a 160-byte /
     * 20-word block, then ret into x30 (word 9); after the pops sp = top. */
    {
        uintptr_t *b;
        int i;
        uintptr_t base = top - 160u;
        b = (uintptr_t *)base;
        for (i = 0; i < 20; i++)
            b[i] = 0;
        b[9] = (uintptr_t)co_trampoline;              /* x30 at word 9 */
        co->ctx.sp = (void *)base;
    }
#elif defined(__skj_x86_64__) || defined(__x86_64__)
    /* x86-64 co_switch pops rbp,rbx,r12-r15 then rets. One pad word keeps the
     * trampoline's entry rsp at 8 mod 16, as SysV expects just after a call. */
    {
        uintptr_t *sp = (uintptr_t *)top;
        int i;
        *--sp = 0;                                    /* alignment pad */
        *--sp = (uintptr_t)co_trampoline;             /* co_switch's ret target */
        for (i = 0; i < 6; i++)
            *--sp = 0;                                /* r15 r14 r13 r12 rbx rbp */
        co->ctx.sp = (void *)sp;
    }
#else
#error "co_create: no coroutine seed for this target"
#endif

    return co;
}

void *
co_resume(coro_t *co, void *value)
{
    struct co_ctx here;
    struct coro *prev;

    if (co == NULL || co->state == CO_DONE)
        return NULL;

    co->xfer = value;
    co->resumer = &here;
    co->state = CO_RUNNING;
    prev = current;
    current = co;
    co_switch(&here, &co->ctx);     /* into co; returns on yield or completion */
    current = prev;

    /* A tripped canary means the body overran its stack into the control
     * region. Memory is already corrupt, but reporting done here keeps a
     * caller from resuming into a broken context. */
    if (*co->canary != CO_CANARY)
        co->state = CO_DONE;

    return co->xfer;
}

void *
co_yield(void *value)
{
    struct coro *co = current;

    co->xfer = value;
    co->state = CO_SUSPENDED;
    co_switch(&co->ctx, co->resumer);   /* back to the resumer */

    /* Resumed again: xfer now holds the value the resume passed in. */
    co->state = CO_RUNNING;
    return co->xfer;
}

int
co_done(const coro_t *co)
{
    return co == NULL || co->state == CO_DONE;
}

coro_t *
co_self(void)
{
    return current;
}
