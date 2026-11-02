/* rv_select.h : the shared RISC-V RV32 (ILP32 psABI) instruction selector.

   One selector drives both the AOT text sink (backend/rv_mc_text.c) and the JIT
   byte sink (jit/jit_rv.c) through backend/rv_mc.h.  The caller sets up the sink,
   then calls rv_select_func for each function.  This is the RISC-V parallel of
   backend/x86_select.h and backend/arm64_select.h.

   The RISC-V backend emits one convention (the platform ILP32 psABI; the
   toolkit's old stack convention was retired).  RV32's integer divide does not
   fault on a zero divisor by hardware (it returns -1 / the dividend), so a
   front end that wants a trap passes RV_TRAP_GUARDED and the selector
   synthesises a divisor guard calling kp_trap_div_zero, like arm64/x86.
   RV_TRAP_HARDWARE emits the bare divide (C's undefined behaviour, and
   Excelsior, which checks a fallible divisor in its own lowering). */

#ifndef RV_SELECT_H
#define RV_SELECT_H

#include <stddef.h>

struct rv_mc;
struct ir_func;

enum {
    RV_TRAP_HARDWARE = 0,   /* bare divide, no divisor guard (cc, Excelsior) */
    RV_TRAP_GUARDED = 1,    /* guard the divisor, call kp_trap_div_zero (Kobold) */
};

/* Select machine code for one function, emitting through the sink m.  tp is the
   divide-by-zero trap policy (RV_TRAP_*).  Returns 0 on success; on an
   unsupported opcode fills err and returns -1.  A symbol the sink could not
   resolve is reported by the sink through its own error channel, which the
   caller checks after this returns. */
int rv_select_func(struct rv_mc *m, struct ir_func *fn, int tp,
                   char *err, size_t errlen);

#endif /* RV_SELECT_H */
