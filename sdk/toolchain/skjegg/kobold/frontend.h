/* frontend.h : run the embedded Kobold front end (kpcom) in-process to compile
   Kobold-Pascal source to a KPM1 module.  This is what lets skj-kp-jit accept a
   `.pas` source file, not only a prebuilt `.kpm`: the front end is itself a KPM1
   module (the committed seed), JIT'd and called through its `compile` export. */

#ifndef KP_FRONTEND_H
#define KP_FRONTEND_H

#include <stddef.h>

/* Compile the Kobold-Pascal source file at `pas_path` to a KPM1 module.  The
   embedded front end is JIT'd and its `compile(srcName, srcText)` export is called
   in-process.  On success returns 0 and sets *module_text to a malloc'd,
   NUL-terminated buffer (the caller frees it) and *out_len to its byte length.  On
   a user source error returns 2 (kpcom has already written diagnostics to stderr;
   err is left empty).  On an infrastructure failure returns 1 with a one-line
   reason in err.  If the KPCOM_KPM environment variable is set, it names a `.kpm`
   file to use in place of the embedded front end (for development iteration). */
int kp_compile_pas(const char *pas_path, char **module_text, size_t *out_len,
                   char *err, size_t errlen);

#endif /* KP_FRONTEND_H */
