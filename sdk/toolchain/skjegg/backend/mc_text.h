/* mc_text.h : the GNU intel-syntax text sink for the shared x86-64 selector.

   Implements the backend/mc.h sink interface by writing GNU `.intel_syntax
   noprefix` (elf64) assembly, the form the AOT compiler emits and the host
   assembler (later skj-as-x86-64) assembles.  The driver creates a sink over an
   output stream, resets the label namespace before each function, and (after
   selecting a function) checks whether the sink hit an unresolved symbol. */

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

/* Normalize a guest symbol name for GNU `as`: strips the single leading `.` of a
   compiler-generated name so it is an ordinary global (not a `.L` local label);
   other names pass through unchanged.  Returns one of a few rotating buffers, so
   use the result before the next few calls. */
const char *asm_sym(const char *name);

#endif /* MC_TEXT_H */
