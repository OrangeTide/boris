/* sched.h : the arch-neutral process sandbox and scheduler
 *
 * One scheduler drives every CPU core through a small vtable over an opaque
 * CPU handle (void *cpu).  It owns the process table, the round-robin slices,
 * spawn, the shared gm_pool memory budget, the handle generations, the fault
 * backtrace cache, and the emulator-private host-call selectors.  A core
 * supplies a `struct skj_cpu_ops` that knows how to build, run, stop and
 * inspect its own CPU; rv_user.c, mips_user.c and cf_user.c are those cores.
 */

#ifndef SKJ_SCHED_H
#define SKJ_SCHED_H

#include <stdint.h>
#include <stdio.h>

#include "guest.h"
#include "run_reason.h"

#ifdef SKJ_DWARF_BACKTRACE
#include "dwread.h"
#include "arena.h"
#endif

/* Emulator-private host-call selectors, far above the Linux syscall space, so a
 * real host kernel answers each with -ENOSYS.  The values and meanings match
 * across every core (and boris's VM_SYS_TRAP for FATAL), so a guest built for
 * one sandbox runs on another.
 *
 *   FATAL  arg0=exit code -> symbolize the stack, then end the process
 *   MAP    arg0=size, arg1=flags -> base (0 on failure)
 *   MUNMAP arg0=base, arg1=size  -> 0
 *   SPAWN  arg0=image ptr, arg1=len -> child handle (0 on failure)
 *   YIELD  give up the rest of the scheduling slice
 *   SPAWNV arg0=guest ptr to a size-prefixed spawn request -> child handle
 */
#define SKJ_SYS_FATAL   0x000f0000u
#define SKJ_SYS_MAP     0x000f0001u
#define SKJ_SYS_MUNMAP  0x000f0002u
#define SKJ_SYS_SPAWN   0x000f0003u
#define SKJ_SYS_YIELD   0x000f0004u
#define SKJ_SYS_P9      0x000f0005u     /* arg0 = 9p channel addr -> 0, or -1 */
#define SKJ_SYS_SPAWNV  0x000f0006u
#define SKJ_SYS_WAIT    0x000f0007u     /* arg0 = child handle -> status, or a sentinel */
#define SKJ_SYS_KILL    0x000f0008u     /* arg0 = child handle, arg1 = status -> 0 or -1 */
#define SKJ_SYS_PIPE    0x000f0009u     /* arg0 = guest addr for 2 u32 ends -> 0 or -1 */

/* SKJ_SYS_WAIT result sentinels, above any real status (exit codes 0..255 and
 * 128+signal).  BADHANDLE: not a live child of the caller.  WOULDBLOCK: the
 * child is still running and this core cannot park (the HV cores), so the guest
 * must retry. */
#define SKJ_WAIT_BADHANDLE  0xffffffffu
#define SKJ_WAIT_WOULDBLOCK 0xfffffffeu

/* The guest-memory spawn request SKJ_SYS_SPAWNV points at: a size-prefixed,
 * extensible descriptor of 32-bit guest words.  The host reads `size` (the byte
 * count the guest filled) and honors only the fields that fit, so later fields
 * (env, mounts, fds) can be added without a new selector; a guest that fills
 * only through argc gets argv passing and host defaults for the rest.  All words
 * are in the guest's byte order. */
enum {
    SKJ_SPAWN_OFF_SIZE      = 0,    /* bytes the guest filled                   */
    SKJ_SPAWN_OFF_IMAGE     = 4,    /* guest addr of the ELF image              */
    SKJ_SPAWN_OFF_IMAGE_LEN = 8,
    SKJ_SPAWN_OFF_ARGV      = 12,   /* guest addr of argc u32 string pointers   */
    SKJ_SPAWN_OFF_ARGC      = 16,
    SKJ_SPAWN_OFF_FLAGS     = 20,   /* u32 SKJ_SPAWN_FLAG_* request bits         */
    SKJ_SPAWN_OFF_FDMAP     = 24,   /* guest addr of fdmap_n {src,dst} u32 pairs */
    SKJ_SPAWN_OFF_FDMAP_N   = 28,   /* u32 count of fd-map pairs                 */
    SKJ_SPAWN_MIN           = 12,   /* image + image_len is the minimum request */
    SKJ_SPAWN_WITH_ARGV     = 20,   /* through argc: argv passing is present     */
    SKJ_SPAWN_WITH_FDS      = 32    /* through fdmap_n: flags + fd map present   */
};

/* Spawn request flags (SKJ_SPAWN_OFF_FLAGS). */
#define SKJ_SPAWN_FLAG_SHARE_MOUNTS 0x1u  /* give the child the parent's mounts */

/* Marshalling caps for a spawn request (host-side bounds on untrusted input). */
#define SKJ_SPAWN_MAX_ARGC   64
#define SKJ_SPAWN_ARG_MAX    256
#define SKJ_SPAWN_ARGBUF     4096
#define SKJ_SPAWN_MAX_FDMAP  16

#define SKJ_MAX_PROC    64
#define SKJ_QUANTUM     8192            /* instructions per scheduling slice */

struct sched;
struct skj_cpu_ops;

/* One process: its CPU (a core-owned struct reached through the vtable), its
 * guest memory and host bindings, and the scheduler's bookkeeping. */
typedef struct proc {
    void *cpu;                  /* the core's CPU struct (ops->alloc) */
    guest g;
    struct sched *sched;        /* for spawn, to reach the process table */
    const struct skj_cpu_ops *ops;
    int slot;                   /* its index in the process table */
    uint32_t gen;               /* the slot's generation when this process took it */
    uint32_t handle;            /* the token spawn returns (slot + generation) */
    int done;                   /* it has stopped and needs no more slices */
    int rc;                     /* a nonzero process exit status (a fault) */
    int fatal;                  /* it exited through SKJ_SYS_FATAL (abort/trap) */
    uint32_t fatal_pc;          /* the call site to root the fatal backtrace at */
    uint64_t insns;             /* instructions retired by this process */
    uint64_t insn_budget;       /* its instruction cap, 0 = unlimited */
    int io_blocked;             /* parked on a blocking syscall (GPARK_RETRY); the
                                 * scheduler skips its slices until park_fd is
                                 * ready or park_deadline passes */
    int park_fd;                /* host fd it waits on, or -1 (a pure sleeper) */
    short park_events;          /* poll events it waits for (POLLIN / POLLOUT) */
    uint64_t park_deadline;     /* monotonic ns to wake a sleeper, 0 if none */
    int parent;                 /* spawner's slot; -1 for the root */
    uint32_t parent_handle;     /* spawner's handle (slot+generation); 0 for the
                                 * root.  Identifies the parent across slot reuse,
                                 * so an orphan is told from a reparented slot. */
    int zombie;                 /* exited: heavy resources freed, status kept for wait */
    int wait_slot;              /* slot it is blocked in SKJ_SYS_WAIT on, else -1 */
    struct guest_grant grants[RUN_MAX_MOUNTS]; /* its mounts, for a child to inherit */
    int ngrants;                /* live entries in grants[] */
#ifdef SKJ_DWARF_BACKTRACE
    uint8_t *bt_image;          /* this process's retained ELF bytes, or NULL (a file
                                 * root keeps none and reads its path from disk) */
    long bt_image_len;          /* length of bt_image */
    struct arena bt_arena;      /* holds this process's lazily built reader tables */
    struct dw_reader bt_reader; /* its DWARF line + symbol tables, when bt_state == 1 */
    int bt_state;               /* 0 untried, 1 ready, -1 unavailable */
#endif
} proc;

typedef struct sched {
    proc *procs[SKJ_MAX_PROC];      /* a NULL slot is free for reuse */
    uint32_t slot_gen[SKJ_MAX_PROC];/* per-slot generation, bumped on reuse */
    int nprocs;                     /* high-water mark of slots ever used */
    const run_opts *o;
    const struct skj_cpu_ops *ops;
    struct gm_pool pool;            /* aggregate memory budget shared by all */
    uint8_t *vdso_buf;              /* the one shared vDSO image, aliased RO into
                                       every guest; built lazily, freed once */
    uint32_t vdso_vaddr;
    uint32_t vdso_size;
    uint32_t vdso_table;
    uint32_t vdso_sys;              /* guest address of the host-updated system
                                       page in the vDSO image, 0 if absent */
    int vdso_state;                 /* 0 untried, 1 ready, -1 unavailable */
    uint64_t insns;                 /* instructions retired across all processes */
    int limited;                    /* the global instruction budget was hit */
} sched;

/* What the shared private-selector handler decided. */
enum skj_priv {
    SKJ_PRIV_NO = 0,    /* not a private selector: do the normal guest syscall */
    SKJ_PRIV_OK,        /* handled; *result holds the value for the result reg */
    SKJ_PRIV_FATAL,     /* FATAL: the process is ending; the shim halts the cpu */
    SKJ_PRIV_YIELD,     /* YIELD: the shim sets the core's park flag */
    SKJ_PRIV_RETRY,     /* WAIT park: re-execute the call next slice, do not
                         * advance past it; the shim parks like GPARK_RETRY */
};

/* Handle MAP/MUNMAP/SPAWN/FATAL/YIELD.  arg0/arg1 are the call's two arguments
 * from wherever the core's ABI puts them; pc is the call site (for FATAL's
 * backtrace).  On SKJ_PRIV_OK, *result is the value to place in the result
 * register.  A non-private selector returns SKJ_PRIV_NO and the core shim then
 * runs the normal guest_syscall path. */
enum skj_priv sched_private(proc *p, uint32_t nr, uint32_t arg0, uint32_t arg1,
                            uint32_t pc, uint32_t *result);

/* The shared guest-memory bus callbacks (ctx is the proc; the signatures are
 * identical across the cores).  A faulting access halts the CPU through
 * ops->halt so a batched run stops on the offending instruction. */
uint32_t skj_bus_r8(void *ctx, uint32_t addr);
uint32_t skj_bus_r16(void *ctx, uint32_t addr);
uint32_t skj_bus_r32(void *ctx, uint32_t addr);
void skj_bus_w8(void *ctx, uint32_t addr, uint32_t val);
void skj_bus_w16(void *ctx, uint32_t addr, uint32_t val);
void skj_bus_w32(void *ctx, uint32_t addr, uint32_t val);

/* A core's binding for the shared scheduler.  The scheduler never names a
 * concrete CPU type: it holds `void *cpu` and reaches the core only here. */
typedef struct skj_cpu_ops {
    const char *name;           /* "rv32" / "mipsel" / "coldfire" */
    uint32_t machine;           /* EM_RISCV / EM_MIPS / EM_68K (image check) */
    int arch;                   /* GUEST_ARCH_* for guest.arch */
    int big_endian;             /* image endianness; also the bus `be` */
    int word64;                 /* the image is ELF64 (the HV cores); else ELF32 */

    void *(*alloc)(void);                   /* allocate a zeroed CPU struct */
    void  (*free)(void *cpu);               /* release it (rv also frees its dec cache) */

    /* Optional: lay out this process's guest memory for a core that cannot use
     * the sparse page-committed layout (the hardware-virtualization cores back
     * their RAM with one contiguous buffer shared with a vcpu).  Called after
     * gm_init, before the image loads.  Returns 0 on success, -1 on failure.
     * NULL leaves the default sparse memory in place. */
    int   (*mem_init)(proc *p, const run_opts *o);

    /* Make a fresh process runnable: bind the shared bus (ctx=p), configure
     * features, install the core's syscall shim, reset to `entry`, and set the
     * stack pointer to `sp`.  The guest memory, heap and stack are already laid
     * out; `sp` is the built initial stack pointer. */
    void  (*ready)(proc *p, uint32_t entry, uint32_t sp);

    /* Run the process for up to `budget` instructions, servicing its own
     * syscalls, and return why it stopped (and the count via *ran).  rv/mips
     * service syscalls in a step callback; cf services its TRAP #0 inside this
     * wrapper, so all three present the same contract to the scheduler. */
    enum skj_run_reason (*run)(proc *p, int budget, int *ran);

    void  (*halt)(void *cpu);               /* stop cleanly */
    void  (*clear_yield)(void *cpu);        /* clear the park flag at a slice start */

    uint32_t (*fault_pc)(void *cpu);        /* live pc for a bus fault + its backtrace */
    uint32_t (*trap_pc)(void *cpu);         /* faulting pc for a CPU trap's backtrace */
    uint32_t (*bt_fp)(void *cpu);           /* frame pointer the backtrace walks */
    int   bt_bigendian;                     /* read backtrace slots big-endian (cf) */

    void  (*report_trap)(FILE *out, int slot, void *cpu); /* the trap one-liner */
    int   (*trap_signal)(void *cpu);        /* process rc = 128 + this */
    void  (*dump_regs)(FILE *out, int slot, void *cpu);
    void  (*dump_trace)(FILE *out, void *cpu);

    /* Optional: serve the GDB remote protocol on the root process instead of
     * the scheduler (rv only; NULL elsewhere).  The exit code is returned via
     * *ec and whether the guest exited via g.exited on the root. */
    void  (*gdb)(proc *root, int port, int *ec);
} skj_cpu_ops;

/* The whole run: load the root image, install mounts, schedule to completion
 * (or serve GDB), print --stats, and report the status.  Returns 0 on a normal
 * run, -1 if the root image could not be loaded.  It is a thin wrapper over the
 * reusable scheduler below: a host that wants several process trees, or wants to
 * bind a tree's stdio to a socket, or wants to interleave the scheduler with its
 * own event loop, uses those directly instead. */
int run_sandbox(const run_opts *o, const skj_cpu_ops *ops, int *status);

/* One root process to add to a scheduler.  argv/envp/stdio may each be NULL: the
 * argv then falls back to the run options' argv, the environment is empty, and
 * 0/1/2 bind to skj-run's own.  argv/envp are the usual NUL-terminated string
 * arrays (envp entries are "KEY=VALUE"); argc/envc give their lengths.  stdio is
 * the three host fds {stdin, stdout, stderr}, e.g. a connection's socket. */
typedef struct sched_root {
    const char *path;           /* ELF image to load, or its label when image is set */
    const uint8_t *image;       /* an in-memory ELF image; when set, load it instead
                                   of opening path, which is then only a diagnostic
                                   label (fault/trace messages).  A host whose guest
                                   images are byte buffers, not files, uses this. */
    long image_len;             /* the image's length in bytes (when image is set) */
    char **argv;                /* argv, or NULL for the run options' */
    int argc;
    char **envp;                /* environment, or NULL for none */
    int envc;
    const int *stdio;           /* host fds for 0/1/2, or NULL for skj-run's own */
} sched_root;

/* The reusable scheduler, for a host that drives it itself (a shell server
 * binding each connection to its own sandbox tree, say).  Lifecycle:
 *
 *   sched_init(&S, o, skj_ops_rv32());     // the arch's vtable, see guest.h
 *   sched_root r = { .path = img, .argv = av, .argc = ac,
 *                    .envp = ev, .envc = ec, .stdio = conn_fds };
 *   sched_add_root(&S, &r);                // one or more, each its own argv/env/fds
 *   // then either the built-in loop:
 *   sched_run(&S);
 *   // or the host's own event loop:
 *   for (;;) {
 *       int ran, live = sched_step(&S, &ran);   // one round of slices
 *       if (S.limited || !live) break;
 *       int fds[SKJ_MAX_PROC]; short ev[SKJ_MAX_PROC]; uint64_t dl;
 *       int n = sched_waits(&S, fds, ev, SKJ_MAX_PROC, &dl);
 *       // poll fds (plus the host's own: a listen socket, timers) with a
 *       // timeout from dl, then report readiness back:
 *       //   sched_mark_ready(&S, fd)  for each ready guest fd
 *       //   sched_wake_deadlines(&S)  after the poll returns
 *   }
 *   sched_destroy(&S);
 *
 * The cores and the shared memory pool are not thread-safe, so a server drives
 * many scheds from one event loop, not from threads.  The HV cores do not park
 * on blocking I/O (they spin-retry), so connection-bound shells run best on an
 * emulated core. */
void sched_init(sched *S, const run_opts *o, const skj_cpu_ops *ops);
int  sched_add_root(sched *S, const sched_root *r);
int  sched_step(sched *S, int *ran);
int  sched_waits(sched *S, int *fds, short *events, int max,
                 uint64_t *deadline_ns);
void sched_mark_ready(sched *S, int fd);
void sched_wake_deadlines(sched *S);
void sched_run(sched *S);
void sched_destroy(sched *S);

#endif /* SKJ_SCHED_H */
