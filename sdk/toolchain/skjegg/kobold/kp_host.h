/* kp_host.h : the standard Kobold runtime an embedder installs into the JIT.

   A driver (skj-kp-jit, or a host that registers its own opaque types) fills a
   kp_binding table with the language runtime, then adds any host types of its
   own, then calls kp_jit.  The two helpers here provide that common surface. */

#ifndef KP_HOST_H
#define KP_HOST_H

#include "jit_common.h"      /* struct kp_binding */
#include <stddef.h>

/* Append the standard runtime bindings (console I/O, strings, dynamic arrays,
   maps, coroutines, ARC, traps, and the 64-bit divide helpers) to binds, starting
   at *n and not exceeding cap.  Updates *n.  An embedder calls this, then binds
   its own host factories and methods after it. */
void kp_install_runtime(struct kp_binding *binds, int *n, int cap);

/* Record the command line for ParamStr/ParamCount, mirroring Kobold's kprun:
   argv[0] is the host launcher (skipped), argv[1] the module name (ParamStr(0)),
   argv[2..] the program's own arguments.  Call before running the module. */
void kp_io_set_args(int argc, char **argv);

/* Read a whole file into a malloc'd, NUL-terminated buffer; length into *lenp. */
char *kp_read_file(const char *path, size_t *lenp);
int kp_write_file(const char *path, const char *data, size_t len);

/* Run the finalizer of every handle still live, at program teardown (the
   counterpart of Kobold's kp_vm_free sweep).  Call it after the program returns
   and before freeing the JIT, since a coroutine finalizer runs guest code. */
void kp_handle_sweep(void);

#endif /* KP_HOST_H */
