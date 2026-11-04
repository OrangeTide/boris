/* rv_gdb.h : a GDB remote-serial-protocol server for the RV32 user machine.

   skj-run opens this stub with --gdb PORT: it listens on a TCP port, waits for
   a debugger (gdb, or the in-tree skj-dbg) to connect, and drives one process
   under the RSP subset the debugger plan calls for: `?`, `g`/`G`, `p`/`P`,
   `m`/`M` (bound checked), `c`, `s`, `Z0`/`z0` software breakpoints,
   `Z2`/`z2` write watchpoints, the raw Ctrl-C interrupt byte, and `qSupported`
   with a RISC-V target description (integer and FP registers).

   Breakpoints are kept in a host-side table checked while single-stepping, so
   guest memory is never patched: that sidesteps the decoded-instruction cache
   (which has no per-PC invalidator) and the mtvec-vectoring of a guest ebreak.
   v1 debugs the root process only. */

#ifndef SKJ_RV_GDB_H
#define SKJ_RV_GDB_H

#include "rv32.h"
#include "guest.h"

/* Serve the protocol for one RV32 process on `port` until the guest exits or
   the debugger detaches or kills it.  cpu and g are the process's CPU and guest
   (memory and exit state); the CPU's bus must already be wired (so rv_step
   runs).  The guest's exit status is written through *exit_code.  Returns 0
   when the session ends in an orderly way (guest exit, detach, or kill),
   non-zero if the server could not be set up. */
int rv_gdb_serve(rv_cpu *cpu, guest *g, int port, int *exit_code);

#endif /* SKJ_RV_GDB_H */
