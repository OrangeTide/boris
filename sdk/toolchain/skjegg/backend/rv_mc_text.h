/* rv_mc_text.h : the GAS text sink for the RISC-V selector (backend/rv_mc_text.c).

   Constructs a struct rv_mc that writes RV32 GAS assembly, the form the AOT
   compiler emits.  The driver (target_emit, defined in the same file) creates
   one, begins each function's label namespace, and runs rv_select_func against
   it.  The RISC-V parallel of backend/arm64_mc_text.h. */

#ifndef RV_MC_TEXT_H
#define RV_MC_TEXT_H

#include <stdio.h>

struct rv_mc;

struct rv_mc *rvt_new(FILE *out);
void rvt_free(struct rv_mc *m);
void rvt_begin_func(struct rv_mc *m, int serial);
const char *rvt_errsym(struct rv_mc *m);   /* parity with the byte sink */

#endif /* RV_MC_TEXT_H */
