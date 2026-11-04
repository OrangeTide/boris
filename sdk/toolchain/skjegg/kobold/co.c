/* co.c : stackful coroutine runtime, platform-neutral core */

#define _DEFAULT_SOURCE   /* mmap, mprotect, MAP_ANONYMOUS, sysconf under -std=c99 */

#include "co.h"
#include "handle.h"
#include "lowmem.h"

#include <setjmp.h>
#include <signal.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

/* Thread-local storage for the running-coroutine control state (see below). C11 spells it
   _Thread_local; under the project's -std=c99 GCC and clang provide __thread, which is the
   same local/initial-exec model. Threads share nothing else in a share-nothing VM model: a
   VM is confined to the thread that drives it, so each thread's coroutine control state is
   its own. */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
#  define KP_THREAD_LOCAL _Thread_local
#else
#  define KP_THREAD_LOCAL __thread
#endif

enum co_state {
    CO_SUSPENDED,
    CO_RUNNING,
    CO_DONE,
};

struct coro {
    struct co_ctx ctx;         /* saved context while this coroutine is suspended */
    struct co_ctx *resumer;    /* context to switch back to on yield or completion */
    void *map;                 /* the whole private-stack mapping, owned */
    size_t map_size;           /* its length: a guard page plus the usable stack */
    kp_co_entry entry;         /* the body routine */
    int64_t *argbuf;           /* an owned copy of the seed arguments, or NULL */
    int nargs;
    int64_t xfer;              /* value carried across a switch, both directions */
    enum co_state state;
    int started;               /* resumed at least once, so it has live frames */
    int cancelling;            /* being torn down: yields do not suspend (unwind) */
    int dead;                  /* last reference went while running: reclaim on unwind */
    kp_gptr id;
};

/* A coroutine lives in the VM handle table as a KP_H_CONT entry; its id is a handle
   id, so 0 means "none" (nil) and lookups share the id space with every other object.

   The running coroutine, or NULL on the initial host stack, and the VM pointer of
   the in-flight resume, threaded through to the trampoline. These are per-thread: each
   thread runs its own VM's coroutines and must not see another thread's running coroutine,
   and co_run saves and restores them so nested resumes on one stack still work. */
static KP_THREAD_LOCAL struct coro *current;
static KP_THREAD_LOCAL kp_vm *cur_vm;

/* The innermost co_run's guard-page landing pad, or NULL on the host stack. The SIGSEGV
   handler jumps here when a running coroutine faults inside its own guard page, and co_run
   turns that into a recoverable trap. It is a sigjmp_buf, not the ordinary jmp_buf trap
   pad, so siglongjmp restores the signal mask the fault left with SIGSEGV blocked. It is
   per-thread: the handler runs on the faulting thread and reads this thread's pad. */
static KP_THREAD_LOCAL sigjmp_buf *co_sig_pad;

/* The SIGSEGV disposition is process-wide (one handler for the whole process), installed
   once under co_handler_state (0 uninit, 1 installing, 2 done), which is synchronized so a
   concurrent first use in two threads still installs exactly once. co_old_segv and
   co_pagesize are written by the electing thread before it publishes state 2, so a thread
   that observes 2 sees them too. */
static struct sigaction co_old_segv;   /* the SIGSEGV disposition we replaced */
static size_t co_pagesize;             /* cached so the async-signal handler need not query */
static int co_handler_state;           /* process-once handler install, via __atomic */

/* The sigaltstack is per-thread in POSIX, so each thread registers its own once. This flag
   is thread-local, so no synchronization is needed. */
static KP_THREAD_LOCAL int co_altstack_ready;

static void co_reclaim(kp_vm *vm, struct coro *co);

#define CO_STACK_SIZE (64 * 1024)

/* Recover a coroutine stack overflow. The private stack has a PROT_NONE guard page at its
   low end, so a coroutine that grows past its stack faults with the address in that page.
   Recognize that case and unwind to the pad co_run armed, which raises STACK_OVERFLOW like
   any other trap. Any other fault is a real bug: reinstate the previous handler and return,
   so the faulting instruction re-runs and that handler (or the default core dump) takes it.

   The handler runs on a sigaltstack because the faulting coroutine has no stack room left.
   It touches only async-signal-safe operations (a compare, sigaction, siglongjmp). */
static void
co_segv_handler(int sig, siginfo_t *info, void *ucontext)
{
    struct coro *co = current;

    (void)ucontext;
    if (co && co_sig_pad && info) {
        char *guard = (char *)co->map;
        char *addr = (char *)info->si_addr;

        if (addr >= guard && addr < guard + co_pagesize)
            siglongjmp(*co_sig_pad, 1);
    }
    sigaction(sig, &co_old_segv, NULL);
}

/* Install the process-wide guard-page SIGSEGV handler exactly once, even if two threads
   first create a coroutine at the same time. The winner of the CAS installs the handler,
   publishes co_pagesize and co_old_segv, then marks the state done; a loser waits until it
   observes done, so it never runs a coroutine before the handler exists. If the install
   fails the runtime keeps the previous behaviour (a hard fault on overflow), not fatal. */
static void
co_install_handler_once(void)
{
    int expected = 0;
    struct sigaction sa;

    if (__atomic_load_n(&co_handler_state, __ATOMIC_ACQUIRE) == 2)
        return;
    if (__atomic_compare_exchange_n(&co_handler_state, &expected, 1, 0,
                                    __ATOMIC_ACQ_REL, __ATOMIC_ACQUIRE)) {
        co_pagesize = (size_t)sysconf(_SC_PAGESIZE);
        sa.sa_sigaction = co_segv_handler;
        sigemptyset(&sa.sa_mask);
        sa.sa_flags = SA_ONSTACK | SA_SIGINFO;
        sigaction(SIGSEGV, &sa, &co_old_segv);
        __atomic_store_n(&co_handler_state, 2, __ATOMIC_RELEASE);   /* publish */
    } else {
        while (__atomic_load_n(&co_handler_state, __ATOMIC_ACQUIRE) != 2)
            ;   /* another thread is installing; wait (first-use only) */
    }
}

/* Register this thread's sigaltstack once. The alt stack is per-thread in POSIX and the
   overflow handler runs on it because the faulting coroutine has no stack room left; each
   thread that runs coroutines needs its own. It is allocated for the thread's lifetime and
   not freed (a thread that ran coroutines leaks one alt stack at exit, as the process-wide
   one did before). A failure is not fatal: the thread just loses overflow recovery. */
static void
co_install_altstack(void)
{
    stack_t ss;

    if (co_altstack_ready)
        return;
    co_altstack_ready = 1;   /* set first: a failed install must not be retried each time */

    ss.ss_sp = malloc(SIGSTKSZ);
    if (!ss.ss_sp)
        return;
    ss.ss_size = SIGSTKSZ;
    ss.ss_flags = 0;
    if (sigaltstack(&ss, NULL) != 0)
        free(ss.ss_sp);
}

/* Install the guard-page overflow recovery on the first coroutine created: the process-wide
   handler once, and this thread's alt stack once. */
static void
co_install_segv(void)
{
    co_install_handler_once();
    co_install_altstack();
}

/* The first thing a new coroutine runs. It calls the body, records the completion
   value, marks the coroutine done, and switches back to its resumer. It never
   returns: a completed coroutine is resumed no further. */
static void
co_trampoline(void)
{
    struct coro *co = current;

    co->xfer = co->entry(cur_vm, co->argbuf, co->nargs);
    co->state = CO_DONE;
    co_switch(&co->ctx, co->resumer);
}

kp_gptr
kp_co_new(kp_vm *vm, void *entry, const void *args, int nargs)
{
    struct coro *co;
    uintptr_t *sp;
    char *top;
    int i;

    /* Arm the guard-page recovery handler before the first private stack exists. */
    co_install_segv();

    /* An allocation failure here raises the recoverable OOM trap rather than aborting, so
       each step first frees whatever earlier steps allocated. With no landing pad
       installed kp_raise still prints and aborts, so this never leaks on the fatal path. */
    co = calloc(1, sizeof(*co));
    if (!co)
        kp_raise(vm, KP_TRAP_OOM, "out of memory creating a coroutine");

    /* Carve the private stack from the guest arena with a guard page at its low end.
       The stack grows down from the high end, so an overflow runs into the PROT_NONE
       page and faults (SIGSEGV) instead of silently corrupting the mapping below it.
       The arena keeps every guest region reachable through one guest data base, so a
       frame address taken inside the coroutine is a valid guest pointer. */
    co->map = kp_arena_stack(kp_vm_arena(vm), CO_STACK_SIZE, &co->map_size);
    if (co->map == NULL) {
        free(co);
        kp_raise(vm, KP_TRAP_OOM, "out of memory mapping a coroutine stack");
    }
    co->entry = (kp_co_entry)entry;
    co->nargs = nargs;
    co->state = CO_SUSPENDED;

    /* Seed the private stack so the first co_switch restores a block of (unused)
       callee-saved slots and returns into the trampoline. The block's shape
       matches this target's co_switch, so the seed is per-target below. */
    top = (char *)co->map + co->map_size;
    top = (char *)((uintptr_t)top & ~(uintptr_t)15);

    /* Copy the seed arguments into the top of the private mapping, so they outlive the
       caller's stack slot (the body runs lazily) and sit in the guest arena where the
       coroutine entry thunk reads them back through a guest pointer. `args` is the guest
       address of the caller's seed buffer, so translate it to a real pointer for the copy;
       co->argbuf holds the guest address of the private copy, since the entry thunk reads
       it base-relative. Reserving a 16-byte multiple keeps the seeded stack pointer
       16-aligned. The buffer is freed with the mapping, so co_reclaim does not free it
       separately. */
    if (nargs > 0) {
        size_t resv = ((size_t)nargs * sizeof(int64_t) + 15) & ~(size_t)15;
        struct kp_arena *arena = kp_vm_arena(vm);
        int64_t *real_argbuf;

        top -= resv;
        real_argbuf = (int64_t *)top;
        memcpy(real_argbuf, kp_arena_ptr(arena, (kp_gptr)(uintptr_t)args),
               (size_t)nargs * sizeof(int64_t));
        co->argbuf = (int64_t *)(uintptr_t)kp_arena_addr(arena, real_argbuf);
    }

#if defined(__aarch64__)
    /* AArch64 co_switch restores d8-d15 (8 doubles) then x19-x30 (12 GPRs) with
       ldp, 160 bytes / 20 words, then ret into x30. Zero the block, set the x30
       slot to the trampoline; after the pops sp = top, the 16-aligned entry sp
       AAPCS64 expects. (x29/x30 are the 9th/10th words popped.) The x28 slot
       carries the guest data base, so the body runs with base-relative
       addressing set up exactly as a kp_call_guest entry does. */
    (void)sp;
    {
        uintptr_t *base;

        top -= 160;
        base = (uintptr_t *)top;
        for (i = 0; i < 20; i++)
            base[i] = 0;
        base[9] = (uintptr_t)co_trampoline;   /* x30 at word 9 (byte offset 72) */
        base[11] = kp_arena_base(kp_vm_arena(vm));  /* x28 at word 11 */
        co->ctx.sp = base;
    }
#elif defined(__riscv) && __riscv_xlen == 32
    /* RV32 co_switch restores ra and s0-s11 then fs0-fs11, a 160-byte / 40-word
       block, then ret into ra. Zero the block and set the ra slot (word 0) to the
       trampoline; after the loads sp = top, the 16-aligned entry sp the psABI
       expects. */
    (void)sp;
    {
        uintptr_t *base;

        top -= 160;
        base = (uintptr_t *)top;
        for (i = 0; i < 40; i++)
            base[i] = 0;
        base[0] = (uintptr_t)co_trampoline;   /* ra at word 0 */
        co->ctx.sp = base;
    }
#elif defined(__m68k__)
    /* ColdFire/m68k co_switch restores d2-d7 and a2-a6 then fp2-fp7 from a
       96-byte block, with the return address sitting just above it at offset 96
       (the rts pops it). Reserve 100 bytes so that slot is included, zero the
       block, and set the return-address slot (word 24) to the trampoline; after
       the restore and the rts sp = top, the 16-aligned entry top. Matches
       co_switch_cf.S. */
    (void)sp;
    {
        uintptr_t *base;

        top -= 100;
        base = (uintptr_t *)top;
        for (i = 0; i < 25; i++)
            base[i] = 0;
        base[24] = (uintptr_t)co_trampoline;   /* ra just above the 96-byte block */
        co->ctx.sp = base;
    }
#else
    /* x86-64 co_switch pops rbp,rbx,r12-r15 then rets. One pad word keeps the
       trampoline's entry rsp at 8 mod 16, as SysV expects just after a call. */
    sp = (uintptr_t *)top;
    *--sp = 0;                              /* alignment pad */
    *--sp = (uintptr_t)co_trampoline;       /* co_switch's ret target */
    for (i = 0; i < 6; i++)
        *--sp = 0;                          /* r15 r14 r13 r12 rbx rbp */
    co->ctx.sp = sp;
#endif

    /* Intern as a KP_H_CONT handle (refcount 1). kp_release reclaims it through
       kp_co_drop when the last reference goes; the id it returns is the process
       handle the front end holds. */
    co->id = kp_handle_intern(vm, KP_H_CONT, co, kp_co_drop);
    return co->id;
}

/* Switch into `co` and back, with `current`, `cur_vm`, and the trap landing pad saved
   across the switch. On a normal return (yield or completion) they are restored and the
   caller continues. If a trap is raised inside the coroutine, it unwinds past co_switch
   without running the restore, so a landing pad here catches it: it restores the caller's
   context and pad and marks the coroutine done (its C frames are abandoned mid-flight, so
   it cannot be cancel-unwound; a later release just frees its stack). Without this, a trap
   from a coroutine that resumed another would leave `current` dangling and leak the frame.

   `reraise` selects what happens next on that inner trap. A resume re-raises to the outer
   pad so the trap propagates as usual; a cancel swallows it and returns, because cancel
   runs from a finalizer inside co_reclaim, where a re-raise would longjmp out of kp_release
   and skip the object's own free. A resume of a coroutine that had already dropped its own
   last reference also reclaims it here, since its id is gone from the table and nothing
   else would. */
static void
co_run(kp_vm *vm, struct coro *co, struct co_ctx *resumer, int reraise)
{
    struct coro *prev = current;
    kp_vm *prev_vm = cur_vm;
    jmp_buf *outer = kp_trap_landing_get(vm);
    sigjmp_buf *prev_sig = co_sig_pad;
    sigjmp_buf sigenv;
    jmp_buf env;
    int trapped, overflowed;
    enum kp_trap_code code;
    const char *msg;

    /* Two pads guard the switch. sigenv catches a guard-page overflow the SIGSEGV handler
       redirects here (its mask is restored by siglongjmp); env catches an ordinary trap the
       coroutine raised through kp_raise. Both land back on this host stack and share the
       same recovery: restore the caller's context and pad, then re-raise from here so the
       coroutine's abandoned frames are left behind, as an inner trap already does. */
    overflowed = sigsetjmp(sigenv, 1);
    if (overflowed == 0) {
        co_sig_pad = &sigenv;
        trapped = setjmp(env);
        if (trapped == 0) {
            kp_trap_landing(vm, &env);
            current = co;
            cur_vm = vm;
            co_switch(resumer, &co->ctx);   /* into the coroutine; returns on yield or done */
            current = prev;
            cur_vm = prev_vm;
            kp_trap_landing(vm, outer);
            co_sig_pad = prev_sig;
            return;
        }
        code = (enum kp_trap_code)trapped;
        msg = kp_trap_message(vm);
    } else {
        code = KP_TRAP_STACK_OVERFLOW;
        msg = "coroutine stack overflow";
    }
    current = prev;
    cur_vm = prev_vm;
    kp_trap_landing(vm, outer);
    co_sig_pad = prev_sig;
    co->state = CO_DONE;
    if (!reraise)
        return;                    /* cancel: the enclosing co_reclaim frees the object */
    if (co->dead)
        co_reclaim(vm, co);        /* self-dropped then trapped: no other backstop */
    kp_raise(vm, code, msg);
}

int64_t
kp_co_resume(kp_vm *vm, kp_gptr id, int64_t value)
{
    struct coro *co = kp_handle_ptr(vm, id, KP_H_CONT);
    struct co_ctx resumer;
    int64_t result;

    /* Not forkable: a coroutine that is running, already resumed elsewhere, or
       completed cannot be resumed, nor can an unknown id (kp_handle_ptr gave NULL for
       a freed id or a wrong kind). Any of these raises the recoverable UNCONSUMED
       trap; the host's landing pad decides what to do. */
    if (!co || co->state != CO_SUSPENDED)
        kp_raise(vm, KP_TRAP_UNCONSUMED,
                 "resumed a running, completed, or unknown coroutine");

    co->xfer = value;
    co->resumer = &resumer;
    co->state = CO_RUNNING;
    co->started = 1;

    co_run(vm, co, &resumer, 1);   /* yield or done; re-raises on an inner trap */

    result = co->xfer;
    /* If the body released its own last reference while running (an over-release of a
       borrowed self handle), kp_co_drop could not free the stack it was on and deferred
       to here. The coroutine has now unwound back, so reclaim it. */
    if (co->dead)
        co_reclaim(vm, co);
    return result;
}

int64_t
kp_co_yield(kp_vm *vm, int64_t value)
{
    struct coro *co = current;

    if (!co)
        kp_raise(vm, KP_TRAP_NO_COROUTINE, "yield outside of a coroutine");

    /* Cancel-by-unwind: while tearing the coroutine down, a yield must not suspend.
       It returns at once so the body reaches its scope-exit release code and returns.
       The front end pairs each yield with a kp_co_cancelling check that then branches
       to that cleanup. */
    if (co->cancelling)
        return 0;

    co->xfer = value;
    co->state = CO_SUSPENDED;
    co_switch(&co->ctx, co->resumer);   /* back to the resumer */

    /* Resumed again: xfer now holds the value the resume passed in. */
    co->state = CO_RUNNING;
    return co->xfer;
}

kp_gptr
kp_co_self(kp_vm *vm)
{
    (void)vm;
    return current ? current->id : 0;
}

int
kp_co_cancelling(kp_vm *vm)
{
    (void)vm;
    return current ? current->cancelling : 0;
}

/* Drive a suspended coroutine through its scope-exit releases and off the end. Like
   kp_co_resume but in cancel mode: it sets `cancelling`, switches in, and the body
   runs its cleanup to completion (CO_DONE). The carried value is discarded. */
static void
co_cancel(kp_vm *vm, struct coro *co)
{
    struct co_ctx resumer;

    co->cancelling = 1;
    co->resumer = &resumer;
    co->state = CO_RUNNING;

    co_run(vm, co, &resumer, 0);   /* cleanup path; a trap in it is swallowed, not re-raised */
}

/* Reclaim a coroutine's object (its private stack and seed copy). A coroutine suspended
   mid-body still owns the handles in its frames, so first cancel-by-unwind runs its
   scope-exit releases: co_cancel resumes it in cancel mode, and the front end's
   per-yield and post-call cancel checks drive each frame, single- or multi-frame,
   through its releases. A never-started or completed coroutine has no frames to unwind.
   The caller must not be running on this coroutine's stack. */
static void
co_reclaim(kp_vm *vm, struct coro *co)
{
    if (co->state == CO_SUSPENDED && co->started)
        co_cancel(vm, co);
    /* argbuf lives in co->map (see kp_co_new), so freeing the mapping frees it too. */
    kp_arena_stack_free(kp_vm_arena(vm), co->map, co->map_size);
    free(co);
}

/* The KP_H_CONT reclaimer, run by kp_release when a coroutine's last reference goes.
   The handle table has already freed the id slot, so this reclaims only the object.

   If the coroutine is running, its last reference went from inside its own body (an
   over-release of the borrowed self handle from bind, typically release(self)). Freeing
   its stack now would pull it out from under the running body, so instead mark it dead
   and let kp_co_resume reclaim it once it unwinds back. */
void
kp_co_drop(kp_vm *vm, void *obj)
{
    struct coro *co = obj;

    if (co->state == CO_RUNNING) {
        co->dead = 1;
        return;
    }
    co_reclaim(vm, co);
}
