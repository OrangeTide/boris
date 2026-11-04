/* x86_select.h : the shared x86-64 instruction selector.

   One selector drives both the AOT text sink (backend/mc_text.c) and the JIT
   byte sink (jit/mc_bytes.c, currently in jit_x86.c) through backend/mc.h.  The
   caller sets up the sink, then calls x86_select_func for each function. */

#ifndef X86_SELECT_H
#define X86_SELECT_H

#include <stddef.h>

struct mc;
struct ir_func;

/* How a divide by zero or a checked-overflow op is handled.  The two sinks want
   different behavior: the JIT runs in-process, where a bare idiv fault would
   SIGFPE the host, so it guards the divisor and calls a trap helper; the AOT
   emits a standalone program, where the hardware #DE / a checked op the C front
   end never produces is fine, so it emits the bare instruction with no guard
   (matching the historical x86_emit.c output, and no undefined trap symbol). */
enum trap_policy {
    TRAP_HARDWARE = 0,      /* bare idiv, rely on the CPU fault (AOT) */
    TRAP_GUARDED = 1,       /* guard the divisor, call the trap helper (JIT) */
};

/* Select machine code for one function, emitting through the sink m.  `tp` picks
   the divide/overflow trap policy.  Returns 0 on success; on an unsupported
   opcode fills err and returns -1.  A symbol the sink could not resolve is
   reported by the sink through its own error channel, which the caller checks
   after this returns. */
int x86_select_func(struct mc *m, struct ir_func *fn, int tp,
                    char *err, size_t errlen);

#endif /* X86_SELECT_H */
