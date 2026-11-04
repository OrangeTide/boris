#include <stddef.h>
#include <stdint.h>

/* The memory seam for the allocator.  __libc_sbrk grows or shrinks the program
   break by `incr` bytes and returns the old break, or (void *)-1 if the request
   cannot be met.  The allocator (malloc.c) sits on top and does not care which
   backing is used.

   Two backings, chosen by data model:

   - ILP32 targets (ColdFire, RISC-V, MIPS) use the real Linux brk syscall, so
     the heap grows on demand up to the sandbox's heap region (skj-run reserves
     16 MiB by default; qemu likewise).  This is what lets the self-compiled
     skj-cc translate a real, large source in-guest, not only a toy one.

   - LP64 targets (x86-64, arm64) are ILP32-style: every live address must stay
     below 4 GiB, and the host brk hands back a high address, so they keep the
     portable fixed static region (a reserved .bss array the low-memory loader
     places).  A target wanting a different heap replaces only this file. */

#ifdef __skj_ilp32__

/* The raw Linux brk, from the crt: returns the new program break (or the
   unchanged break when the request cannot be satisfied). */
extern void *__sys_brk(void *addr);

/* The current break, queried lazily on first use rather than with a static
   initializer. */
static char *cur_brk;

void *
__libc_sbrk(long incr)
{
    char *old, *want, *got;

    if (cur_brk == 0) {
        cur_brk = (char *)__sys_brk((void *)0);
        if (cur_brk == (char *)-1 || cur_brk == 0)
            return (void *)-1;
    }
    old = cur_brk;
    want = old + incr;
    if (incr > 0 && want < old)         /* address wrap on grow */
        return (void *)-1;
    if (incr < 0 && want > old)         /* address wrap on shrink */
        return (void *)-1;
    got = (char *)__sys_brk(want);
    if (incr > 0 && got < want)         /* the region could not grow that far */
        return (void *)-1;
    cur_brk = got;
    return old;
}

#else   /* LP64: the fixed static region */

#ifndef __LIBC_HEAP_SIZE
#define __LIBC_HEAP_SIZE (1024 * 1024)      /* 1 MiB default */
#endif

/* An array of the widest scalar, so the region base is 8-byte aligned (the
   allocator needs no stronger alignment, long double is not used). */
static long long heap_store[(__LIBC_HEAP_SIZE + sizeof(long long) - 1)
                            / sizeof(long long)];

/* The current break.  Initialized lazily to the region base on first use
   rather than with a static initializer, since skj-cc does not yet emit a
   static pointer whose initializer is another object's address. */
static char *heap_brk;

void *
__libc_sbrk(long incr)
{
    /* Round the region base up to 8 bytes: the array's symbol alignment is not
       guaranteed to be 8 on every target, and the allocator hands out memory
       at the base, so a double or long long there must still be aligned. */
    uintptr_t raw = (uintptr_t)(char *)heap_store;
    char *base = (char *)((raw + 7u) & ~(uintptr_t)7u);
    char *limit = (char *)heap_store + sizeof heap_store;
    char *old, *next;

    if (heap_brk == 0)
        heap_brk = base;
    old = heap_brk;
    next = old + incr;

    if (next < base || next > limit)
        return (void *)-1;
    heap_brk = next;
    return old;
}

#endif
