/* aot_rt.c : the C start file and link-time runtime surface for skj-kp output.

   An AOT-compiled Kobold program (the assembly skj-kp emits) is a set of guest
   functions that call the Kobold runtime by symbol: the string, array, map,
   coroutine, and ARC routines (str_core.c, dynarr.c, map.c, co.c, co_shim.c,
   rt_host.c) and the console I/O (kp_host.c), all linked in directly rather than
   bound through a table as in the JIT.  This file supplies the rest the link needs:
   the process entry, the trap handlers and the kprun-compatible debug surface under
   the exact names the guest calls, since those are the ones the JIT's binding table
   renamed rather than provided verbatim.

   The entry sets up an execution stack and enters the program through
   kp_call_guest, exactly as the JIT driver does.  On an ILP32 target a guest
   address is a 32-bit value, so the stack and the guest heap (rt_host.c) must
   live below 4GB and the program is linked -no-pie to keep its code and data
   there too.  On an LP64 target a guest address is a full host pointer, so the
   stack can live anywhere and the -no-pie / low-memory constraints do not
   apply (and macOS, which is PIE-only, drops -no-pie). */

#if !defined(_DARWIN_C_SOURCE)
#define _DEFAULT_SOURCE                 /* glibc gates MAP_ANONYMOUS behind this */
#endif

#include "str.h"
#include "target.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/mman.h>

/* The renamed guest entry (skj-kp emits the program's entry under this name). */
extern void kp_guest_entry(void);

/* From jit/call_guest_x86.S and kobold/co_shim.c. */
uint64_t kp_call_guest(void *entry, void *stack_top,
                       const int64_t *iargs, const double *fargs, double *fret);
void kp_handle_sweep(void);

/* From kobold/kp_host.c. */
void kp_io_set_args(int argc, char **argv);

/* The file, directory, and whole-file string surface the stdlib units call by
   name (ReadFileStr/WriteFileStr and the kpf_ and kpd_ families) lives in
   kobold/kp_rt_io.c now, shared verbatim with the JIT driver; this AOT build
   links that object (KP_AOT_RT). The four debug/test stubs below stay here (and
   as statics in the JIT driver): the JIT byte sink owns the C symbols emit and
   emit64, so they cannot be one shared symbol, while the guest links an AOT
   program against these exact names. */

/****************************************************************
 * Traps (the guest calls these on a failed runtime check)
 ****************************************************************/

static void aot_trap(const char *what)
{
    fprintf(stderr, "skj-kp: runtime fault: %s\n", what);
    exit(70);
}
void kp_trap_div_zero(void) { aot_trap("divide by zero"); }
void kp_trap_overflow(void) { aot_trap("integer overflow"); }
void kp_trap_index(void)    { aot_trap("array index out of bounds"); }

/* The language fatals (abort / failed assert), the native-AOT twins of the
   freestanding kp_abort/kp_assert in rt_free.c. */
void kp_abort(void) { aot_trap("aborted"); }
void kp_assert(uint32_t cond) { if (!cond) aot_trap("assertion failed"); }

/****************************************************************
 * The kprun-compatible debug/test surface (mirrors jit_main.c)
 ****************************************************************/

/* The console seam writes straight to the fd (kp_io.c), so these printf-based
   debug stubs flush after each line to stay in order with a program's own
   writeln output. */
void printInt(int n) { printf("%d\n", n); fflush(stdout); }
void emit(int n)     { printf("%d\n", n); fflush(stdout); }
void emit64(int64_t n) { printf("%lld\n", (long long)n); fflush(stdout); }

/* emitf takes a real.  On rv32 the backend's soft-float call ABI hands it over as
   the double's bits in an integer register pair, not in a float register, so it
   arrives as a uint64_t (mirrors jit_main.c:h_emitf). */
#if defined(__riscv) && __riscv_xlen == 32
void emitf(uint64_t xb) { double x; memcpy(&x, &xb, sizeof x); printf("%g\n", x); fflush(stdout); }
#else
void emitf(double x) { printf("%g\n", x); fflush(stdout); }
#endif

/****************************************************************
 * Process entry
 ****************************************************************/

#define KP_STACK_BYTES ((size_t)8u << 20)   /* 8 MiB guest execution stack */

/* Map the execution stack.  An address-of-local is a pointer-width guest pointer
   on every target, so the stack can live wherever the kernel places an anonymous
   mapping; mirrors rt_host.c:rt_map_low. */
static void *aot_map_low(size_t len)
{
    return mmap(NULL, len, PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
}

/* ISO C does not define a function-pointer-to-void* cast; route it through a union
   to stay warning-clean under -Wpedantic, as the JIT drivers do. */
static void *entry_addr(void (*fn)(void))
{
    union { void (*f)(void); void *o; } u;
    u.f = fn;
    return u.o;
}

int main(int argc, char **argv)
{
    void *stack;
    uintptr_t top;
    int64_t iargs[6] = { 0 };
    double fargs[8] = { 0 };
    double fret = 0;

    /* Record the command line for ParamCount / ParamStr.  kp_io_set_args drops its
       first element, which in jit_main.c is the JIT launcher's own name (so the
       module name it is given leads the guest's view).  A standalone AOT program is
       different: its argv[0] is the program's own name, which Pascal's ParamStr(0)
       must keep.  So prepend a placeholder for the setter to drop, leaving argv[0]
       as ParamStr(0) and argv[1..] as ParamStr(1..ParamCount). */
    {
        char **gargv = malloc((size_t)(argc + 1) * sizeof *gargv);
        if (!gargv) {
            fprintf(stderr, "skj-kp: cannot allocate argument vector\n");
            return 70;
        }
        gargv[0] = argv[0];                 /* placeholder; dropped by the setter */
        for (int i = 0; i < argc; i++)
            gargv[i + 1] = argv[i];
        kp_io_set_args(argc + 1, gargv);
    }

    /* The execution stack (aot_map_low): low memory on an ILP32 target so an
       address-of-local fits the 32-bit guest model, anywhere on LP64, as the
       JIT's execution stack does. */
    stack = aot_map_low(KP_STACK_BYTES);
    if (stack == MAP_FAILED) {
        fprintf(stderr, "skj-kp: cannot map execution stack\n");
        return 70;
    }
    top = ((uintptr_t)stack + KP_STACK_BYTES) & ~(uintptr_t)15;

    kp_call_guest(entry_addr(kp_guest_entry), (void *)top, iargs, fargs, &fret);

    kp_handle_sweep();   /* finalize any live handle at teardown */
    return 0;
}
