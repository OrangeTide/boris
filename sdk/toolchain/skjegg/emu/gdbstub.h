/* gdbstub.h : the architecture-neutral GDB remote-serial-protocol server.
 *
 * One shared implementation of the RSP subset skj-run serves (`?`, g/G, p/P,
 * m/M, c, s, Z0/z0 software breakpoints, Z2/z2 write watchpoints, the raw
 * Ctrl-C interrupt byte, qSupported and the qXfer target description), the
 * packet transport, and the host-side breakpoint/watchpoint tables.  The three
 * per-backend stubs (rv_gdb.c, mips_gdb.c, hv_gdb.c) reduce to a `gdb_target`
 * vtable plus a serve wrapper; they carried byte-identical copies of the
 * transport and dispatch before, and the HV copy had begun to drift.
 *
 * Addresses are 64-bit throughout so the one core serves both the ILP32 cores
 * (RV32, MIPS) and the LP64 HV cores; a 32-bit backend's callbacks take the low
 * word.  Registers cross the boundary as the gdb hex byte stream, so the core
 * needs no register-layout knowledge: a backend marshals its own file.
 *
 * Breakpoints and watchpoints are kept in host-side tables checked while
 * single-stepping, so guest memory is never patched.  v1 debugs the root
 * process only. */

#ifndef SKJ_GDBSTUB_H
#define SKJ_GDBSTUB_H

#include <stddef.h>
#include <stdint.h>

/* step() return: whether the guest advanced, exited, or stopped on its own
 * (a fault, a trap, or a halt that is not a breakpoint or watchpoint). */
enum {
    GDB_RUN_OK = 0,     /* one instruction retired; keep going                 */
    GDB_RUN_EXITED,     /* the guest process exited                            */
    GDB_RUN_STOP,       /* a fault/trap/halt: stop and report stop_signal()    */
};

/* The per-backend seam.  `ctx` is the backend's own state (its cpu + guest, or
 * the HV proc + vcpu), passed to every callback.  A NULL optional callback is
 * simply not used.  Register calls move the gdb hex byte stream; memory and
 * execution calls take a 64-bit address a 32-bit backend narrows. */
struct gdb_target {
    const char *target_xml;     /* served over qXfer; NULL advertises none     */

    /* Registers.  read_* fill `out` (cap bytes) with a NUL-terminated hex
     * byte stream and return 0, or return -1 on error/out-of-range.  write_*
     * consume hex and return 0 or -1.  read_reg/write_reg may be NULL when the
     * backend serves no p/P (the core then replies the empty "unsupported"). */
    int (*read_regs)(void *ctx, char *out, size_t cap);
    int (*write_regs)(void *ctx, const char *hex);
    int (*read_reg)(void *ctx, int n, char *out, size_t cap);
    int (*write_reg)(void *ctx, int n, const char *hex);

    /* Memory.  mem_mapped bounds-checks; read8/write8 touch one byte. */
    int     (*mem_mapped)(void *ctx, uint64_t addr);
    uint8_t (*read8)(void *ctx, uint64_t addr);
    void    (*write8)(void *ctx, uint64_t addr, uint8_t v);

    /* Execution. */
    uint64_t (*get_pc)(void *ctx);
    void     (*set_pc)(void *ctx, uint64_t pc);
    int      (*step)(void *ctx);            /* one instruction; GDB_RUN_*       */
    int      (*exited)(void *ctx);          /* guest process has exited         */
    int      (*exit_code)(void *ctx);       /* its status (valid when exited)   */
    int      (*stop_signal)(void *ctx);     /* signal for the current stop      */

    /* Optional run bracketing.  The HV backend toggles the vcpu's hardware
     * single-step mode around a run region; NULL on the emulated backends. */
    void (*run_begin)(void *ctx);
    void (*run_end)(void *ctx);
};

/* Serve the protocol for one process on `port` until the guest exits or the
 * debugger detaches or kills it.  The guest's exit status is written through
 * *exit_code when non-NULL.  Returns 0 when the session ends in an orderly way,
 * -1 if the server could not be set up (listen/accept failed). */
int gdb_serve(const struct gdb_target *t, void *ctx, int port, int *exit_code);

#endif /* SKJ_GDBSTUB_H */
