/* mc_text.h : the NASM text sink for the shared x86-64 selector.

   Implements the backend/mc.h sink interface by writing NASM (elf64) assembly,
   the form the AOT compiler emits and nasm assembles.  The driver creates a
   sink over an output stream, resets the label namespace before each function,
   and (after selecting a function) checks whether the sink hit an unresolved
   symbol. */

#ifndef MC_TEXT_H
#define MC_TEXT_H

#include <stdio.h>

struct mc;

/* Create a text sink writing to `out`, or NULL on allocation failure. */
struct mc *mct_new(FILE *out);
void mct_free(struct mc *m);

/* Begin a function: `serial` namespaces the local labels so labels from
   different functions in one file never collide. */
void mct_begin_func(struct mc *m, int serial);

/* The unresolved-symbol channel (always NULL for the text sink: symbol
   resolution is the linker's job), kept for parity with the byte sink. */
const char *mct_errsym(struct mc *m);

#endif /* MC_TEXT_H */
