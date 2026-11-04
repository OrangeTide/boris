/* guest.h : sparse guest memory and the user-mode machine shared by the
 * ColdFire and RV32 emulators */

#ifndef GUEST_H
#define GUEST_H

#include <stdint.h>

/****************************************************************
 * Sparse guest memory
 *
 * The guest address space is 32 bits wide but a program touches very
 * little of it, so pages are committed on first access inside a mapped
 * region.  A read or write outside every region is a fault, which is
 * what a host kernel would answer with SIGSEGV.
 ****************************************************************/

#define GM_PAGE_SHIFT   12
#define GM_PAGE_SIZE    (1u << GM_PAGE_SHIFT)
#define GM_L1_ENTRIES   1024            /* addr >> 22 */
#define GM_L2_ENTRIES   1024            /* (addr >> 12) & 1023 */
#define GM_MAX_REGIONS  256             /* image segments plus dynamic mappings */

enum {
    GM_R = 1,
    GM_W = 2,
    GM_X = 4,
};

struct gm_region {
    uint32_t base;
    uint32_t size;
    int prot;
    const char *name;
};

/* An aggregate commit budget shared by several guests (the scheduler's
 * processes). Each guest still has its own per-guest limit; the pool caps the
 * total committed across all of them, so many children cannot together exhaust
 * host memory. limit 0 means no aggregate cap. */
struct gm_pool {
    uint64_t used;
    uint64_t limit;
};

typedef struct guest_mem {
    uint8_t **dir[GM_L1_ENTRIES];       /* lazily allocated leaf tables */
    uint8_t **wdir[GM_L1_ENTRIES];      /* write fast path: mirrors dir, set only
                                           for committed pages in a writable region
                                           (steady state), so a store skips the
                                           per-access region protection re-check */
    struct gm_region regions[GM_MAX_REGIONS];
    int nregions;
    struct gm_region *last;             /* one-entry lookup cache */
    uint32_t mmap_next;                 /* next free address for gm_mmap, 0 until first use */
    uint64_t committed;                 /* bytes of host memory handed out */
    uint64_t limit;                     /* cap on this guest's committed */
    struct gm_pool *pool;               /* shared aggregate budget, or NULL */
    int loading;                        /* loader writes ignore GM_W */
    uint8_t *extern_base;               /* a contiguous host buffer backing
                                           [0, extern_size), used by the
                                           hardware-virtualization guest whose RAM
                                           is one buffer mapped into its vcpu;
                                           NULL for a sparse (page-committed) guest */
    uint32_t extern_size;
    uint8_t *vdso_host;                 /* a shared read-only host buffer backing
                                           [vdso_vaddr, vdso_vaddr+vdso_size); one
                                           copy aliased into every guest, never
                                           owned or freed by the guest.  NULL when
                                           no vDSO is mapped */
    uint32_t vdso_vaddr;
    uint32_t vdso_size;
    int fault;                          /* set on the first bad access */
    uint32_t fault_addr;
    int fault_write;
    const char *fault_why;
    int fault_guard;                    /* the fault hit a guard page (a stack overflow) */
} guest_mem;

void gm_init(guest_mem *m, uint64_t limit);
void gm_free(guest_mem *m);

/* Back [0, size) with a single contiguous host buffer rather than committed
 * pages, and map it read/write/execute.  The buffer is the guest's whole RAM,
 * shared with a vcpu (the hardware-virtualization cores); its lifetime is the
 * caller's.  Every gm_* access in range then reads or writes this buffer, so
 * the shared syscall layer reaches guest memory unchanged. */
void gm_set_extern(guest_mem *m, uint8_t *base, uint32_t size);

/* Declare an accessible range.  Returns 0 on success, -1 if the region
 * table is full. */
int gm_map(guest_mem *m, uint32_t base, uint32_t size, int prot,
           const char *name);

/* Page containing addr, committing it if it lies in a mapped region.
 * Returns NULL and records a fault otherwise. */
uint8_t *gm_page(guest_mem *m, uint32_t addr, int want_write);

/* Map a fresh region of `size` bytes (rounded up to pages) at an
 * emulator-chosen address, readable and writable, and return its base (0 on
 * failure). With GM_MAP_GUARD_LO an unmapped guard page sits just below it, so a
 * downward-growing stack that overruns faults on the guard rather than
 * corrupting other memory. This is the one mapping primitive the sandbox tier
 * uses for guarded coroutine stacks (and, later, host-shared buffers). */
#define GM_MAP_GUARD_LO 1u
uint32_t gm_mmap(guest_mem *m, uint32_t size, unsigned flags);

/* Release a region gm_mmap returned, freeing its committed pages and its guard
 * page. base and size are the values gm_mmap returned and was asked for. */
void gm_munmap(guest_mem *m, uint32_t base, uint32_t size);

/* Byte access.  A fault reads as zero and swallows the write. */
uint8_t gm_read8(guest_mem *m, uint32_t addr);
void gm_write8(guest_mem *m, uint32_t addr, uint8_t val);

/* Sized access in the guest's byte order; size is 1, 2 or 4.  These are
 * what the CPU bus callbacks are built from. */
uint32_t gm_load(guest_mem *m, uint32_t addr, int size, int be);
void gm_store(guest_mem *m, uint32_t addr, int size, int be, uint32_t val);

/* Copy a host buffer in, committing pages as needed (loader path). */
void gm_write(guest_mem *m, uint32_t addr, const void *src, uint32_t len);

/* Zero a range without faulting on unmapped pages inside a region. */
void gm_zero(guest_mem *m, uint32_t addr, uint32_t len);

/* Copy a guest range out to a host buffer.  A byte in an unmapped page reads
 * as zero (gm_read8), so the caller checks the region is mapped when that
 * matters. */
void gm_read_out(guest_mem *m, uint32_t addr, void *dst, uint32_t len);

/****************************************************************
 * The user-mode machine
 *
 * One structure serves both CPUs.  The syscall layer is arch-neutral:
 * each front end decodes its own register convention and number space
 * into a call on guest_syscall().
 ****************************************************************/

enum guest_arch {
    GUEST_ARCH_NONE = 0,
    GUEST_ARCH_COLDFIRE,
    GUEST_ARCH_RV32,
    GUEST_ARCH_MIPS32,
    GUEST_ARCH_X86_64,          /* hardware-virtualization (KVM) */
    GUEST_ARCH_AARCH64,         /* hardware-virtualization (KVM) */
};

/* Arch-neutral syscall selectors.  The per-arch tables map Linux numbers
 * onto these, so a call added here reaches both targets at once. */
enum guest_sys {
    GSYS_UNKNOWN = 0,
    GSYS_READ,
    GSYS_WRITE,
    GSYS_WRITEV,
    GSYS_OPEN,
    GSYS_OPENAT,
    GSYS_CLOSE,
    GSYS_LSEEK,
    GSYS_LLSEEK,
    GSYS_BRK,
    GSYS_EXIT,
    GSYS_EXIT_GROUP,
    GSYS_STATX,
    GSYS_MKDIRAT,
    GSYS_UNLINKAT,
    GSYS_RENAMEAT2,
    GSYS_FCHMODAT,
    GSYS_GETDENTS64,
    GSYS_CLOCK_GETTIME,
    GSYS_GETRANDOM,
    GSYS_NANOSLEEP,
    GSYS_SCHED_YIELD,
};

/* How a syscall that could not complete asks the core shim to yield the slice.
 * GPARK_RETRY means the syscall did nothing and must be re-executed on the next
 * slice (the shim rewinds the PC and commits no result); the scheduler parks the
 * process until park_fd is ready or park_deadline passes.  GPARK_YIELD means the
 * syscall completed normally (the shim commits its result and advances) but the
 * slice should still end so siblings run this round.  Only the cooperative
 * sandbox cores opt in (guest.can_park); the hardware-virtualization cores leave
 * it clear and keep the plain blocking host behavior. */
enum {
    GPARK_NONE = 0,
    GPARK_YIELD,
    GPARK_RETRY,
};

/* The sandbox fd table.  A guest fd is an opaque INDEX into this table; the
 * host fd lives only in the entry and is never handed to the guest, so a guest
 * cannot name a host fd it was not given.  Each entry routes to a device
 * driver; its param is the host fd.  (Only hostfs exists today, backed by a
 * host fd; the tag is there for ramfs / 9p / null drivers later.) */
#define GUEST_MAX_FDS 64

enum guest_dev {
    GDEV_NONE = 0,
    GDEV_HOSTFS,                /* param is a host fd (file, dir, pipe, stdio) */
    GDEV_PROC,                  /* a proc: capability: content generated host-side
                                 * from the scheduler's process table; the open
                                 * state (generated bytes or a listing cursor)
                                 * hangs off the fd entry's `dirp` as a
                                 * procfs_open (see emu/procfs.c) */
};

struct gfd {
    int used;
    int dev;                    /* enum guest_dev */
    int host_fd;                /* the driver's parameter */
    void *dirp;                 /* a cached host directory stream (hp_dir *) for
                                 * getdents64, opened on first use; NULL until then */
};

/* A 9p channel the launcher bound: a doorbell names its channel's guest address,
 * which this maps to the host-side p9 server serving it. */
struct sched;                   /* the owning scheduler; see the guest back-pointer */

#define GUEST_MAX_P9 16
struct guest_p9bind {
    uint32_t chan;              /* channel region's guest address */
    void    *srv;              /* struct p9_server * serving it */
};

typedef struct guest {
    guest_mem mem;
    int arch;
    int exited;
    int exit_code;
    int quiet;                  /* suppress guest stdout/stderr */
    uint64_t syscalls;
    uint32_t brk;               /* current program break */
    uint32_t brk_base;          /* start of the heap region */
    uint32_t brk_limit;         /* end of the heap region */
    uint32_t stack_top;
    int big_endian;
    int fds_inited;
    int confined;               /* a grant was installed, so the capability mounts
                                   are the only host access: the unconfined ambient
                                   AT_FDCWD path is refused (see gfd_dir). A guest
                                   with no grant keeps the ambient default. */
    int stdio[3];               /* host fds the sandbox's 0/1/2 dup from; default
                                   {0,1,2} (skj-run's own), but a host embedding
                                   the scheduler can bind them to a connection's
                                   socket before the first fd use */
    struct gfd fdtab[GUEST_MAX_FDS];
    int np9;                    /* bound 9p channels */
    struct guest_p9bind p9[GUEST_MAX_P9];

    /* Cooperative blocking-syscall park (see the GPARK_* enum).  can_park is set
     * by a core's ready() to opt in; a core run alone with no scheduler to yield
     * to (the gdb stub) leaves it 0 and blocks on the host instead. */
    int can_park;               /* this core services parks; 0 = block on the host */
    int park;                   /* GPARK_* result of the last syscall, else NONE */
    int park_fd;                /* host fd to wait on (GPARK_RETRY); -1 if none */
    short park_events;          /* poll events to wait for (POLLIN / POLLOUT) */
    uint64_t park_deadline;     /* monotonic ns to wake a sleeper; 0 if none */
    int sleeping;               /* a nanosleep is pending (its deadline is live) */
    uint64_t sleep_deadline;    /* that sleep's absolute monotonic ns deadline */
    uint32_t wr_parked_done;    /* bytes already written by a POLLOUT-parked write,
                                   so its re-run resumes mid-buffer (never a short
                                   count to the guest); 0 when no write is parked */

    char scratch_dir[64];       /* host-owned ephemeral scratch dir to remove at
                                   teardown, "" if none (only the root owns it) */
    uint32_t vdso_base;         /* injected vDSO table address, 0 if none; the
                                   auxv advertises it to the guest */

    /* Back-pointer to the owning scheduler and this process's slot, set by
     * sched.c at proc_alloc.  The syscall path reaches the process table
     * through these (for the proc: filesystem) without guest.c needing to know
     * the proc/sched layout; procfs.c is the only file that bridges the two. */
    struct sched *sched;
    int slot;
} guest;

/* Service a 9p doorbell: find the server bound to channel `chan`, read the
 * T-message out of guest memory, dispatch it, and write the R-message back.
 * Returns 0, or -1 if no server is bound to that channel. */
int guest_p9_doorbell(guest *g, uint32_t chan);

/* Release the 9p servers bound to this guest (called at process teardown). */
void guest_p9_free(guest *g);

/* Service one syscall.  args are already in host order; the return value
 * is the Linux return convention (negative errno on failure). */
int32_t guest_syscall(guest *g, int sys, uint32_t a0, uint32_t a1,
                      uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5);

/****************************************************************
 * Run options, filled by the driver and read by the arch front ends
 ****************************************************************/

#define RUN_MAX_MOUNTS 16       /* matches fs/fs.h FS_MAX_MOUNTS */

typedef struct run_opts {
    const char *path;
    char **argv;                /* guest argv, argv[0] is the program */
    int argc;
    char **envp;                /* guest environment ("KEY=VALUE"), or NULL for none */
    int envc;                   /* number of envp entries */
    const char *mounts[RUN_MAX_MOUNTS]; /* --mount name:hostdir grants */
    int nmounts;
    const char *mounts_ro[RUN_MAX_MOUNTS]; /* --mount-ro name:hostdir grants (FS_RO) */
    int nmounts_ro;
    const char *devs[RUN_MAX_MOUNTS];   /* --dev name grants (devfs)        */
    int ndevs;
    const char *roms[RUN_MAX_MOUNTS];   /* --rom name:image.img grants      */
    int nroms;
    const char *p9s[RUN_MAX_MOUNTS];    /* --9p name:hostdir grants         */
    int np9s;
    const char *vdso;           /* --vdso PATH: a vDSO image to inject, or NULL */
    const uint8_t *root_image;  /* --mem-root: the root ELF in memory, or NULL to
                                   open path; path stays the diagnostic label */
    long root_image_len;        /* its length in bytes (when root_image is set) */
    uint64_t mem_limit;
    uint32_t stack_size;
    uint32_t heap_size;
    uint64_t max_insns;         /* 0 = unlimited */
    uint64_t total_mem;         /* aggregate commit cap across all processes, 0 = unlimited */
    uint64_t child_max_insns;   /* per-spawned-child instruction budget, 0 = unlimited */
    int trace;                  /* dump the CPU trace ring on a fault */
    int stats;                  /* instruction count to stderr on exit */
    int quiet;
    int gdb_port;               /* >0: serve the GDB remote protocol on this port (RV32) */
} run_opts;

/* One installed mount recorded host-side, so a spawned child can inherit its
 * parent's namespace (the guest's own fd_tab is a static the host cannot read,
 * and the guest's live fs_mounts is post-adoption, so the inheritable form is
 * kept here instead).  `host_fd` is the real directory fd a FS_KIND_HOST grant
 * is confined to, which a child inherits through a dup; other kinds carry -1.
 * FS_KIND_ROM/9P are recorded for an accurate count but are not inheritable in
 * this version (their backing lives in the parent's guest memory / a host
 * server bound to the parent). */
struct guest_grant {
    char     name[8];           /* FS_NAME_MAX, NUL-padded                      */
    int      namelen;
    uint32_t kind;              /* FS_KIND_* (low byte)                         */
    int      host_fd;           /* FS_KIND_HOST: a host dir fd; else -1         */
};

/* The launcher: open each --mount host directory as a hostfs capability in the
 * guest fd table and write the fs/ mount table (the fs_mounts / fs_mount_count /
 * fs_cur_mount symbols) into guest memory.  A no-op if the guest links no fs/
 * table or no mounts were granted.  When `rec` is non-NULL it records each
 * installed grant there (up to FS_MAX_MOUNTS) and writes the count to `*nrec`,
 * so the root process can later hand its namespace to a child. */
void guest_install_mounts(guest *g, const char *elf_path, const run_opts *o,
                          struct guest_grant *rec, int *nrec);

/* Build the shared vDSO buffer once from its ELF image (pure leaf functions):
 * a flat host buffer holding the loadable segments at their guest addresses,
 * which every guest aliases read-only. Sets *buf (caller owns, free once),
 * *vaddr, *size, and *table (the skj_vdso_table address). Returns 0 or -1. */
int guest_vdso_image(const char *path, int word64, uint8_t **buf,
                     uint32_t *vaddr, uint32_t *size, uint32_t *table,
                     uint32_t *sysinfo);

/* Point a guest at the shared vDSO buffer and record its table address in
 * g->vdso_base, which guest_build_stack(64) advertises through the auxv tag
 * AT_SKJ_VDSO. An emulated guest aliases it read-only through gm_page; an
 * extern-backed HV guest leaves the gm_map to its core, which maps the buffer
 * as a read-only hypervisor memory slot from the recorded fields. The buffer is
 * shared, not owned by the guest. */
void guest_vdso_attach(guest *g, uint8_t *buf, uint32_t vaddr, uint32_t size,
                       uint32_t table);

/* Install a recorded grant list into a freshly spawned child's guest, resolving
 * the child's fs_mounts table from its in-memory ELF image.  Each FS_KIND_HOST
 * grant's host fd is dup'd so the child owns an independent fd; FS_KIND_DEV is
 * stateless.  Records what it installed into `rec`/`*nrec` (nullable) so the
 * child can pass the namespace on in turn.  A no-op if the image links no
 * fs_mounts (a non-fs or 64-bit child). */
void guest_install_grants_mem(guest *g, const uint8_t *img, long imglen,
                              const struct guest_grant *in, int nin,
                              struct guest_grant *rec, int *nrec);

/* Close every host fd a sandbox holds in its capability table (its own 0/1/2
 * dups, mount capability fds, pipe ends).  Called when a process is torn down,
 * so a writer's exit closes its pipe ends and the reader sees EOF. */
void guest_fds_free(guest *g);

/* SKJ_SYS_PIPE: create a host pipe and allocate a guest capability fd for each
 * end, writing the two indices (read, then write) as u32 at guest address
 * `out_addr`.  Returns 0, or -1 on any failure (nothing is written on failure).
 */
int guest_make_pipe(guest *g, uint32_t out_addr);

/* One descriptor a parent passes to a child at spawn: `gfd` is the index into
 * the parent sandbox's own capability table that backs the fd, `dst` the id the
 * child should see it as.  The resource is dup'd into the child, which owns it. */
struct guest_fdpass {
    int gfd;
    int dst;
};

/* Pass descriptors from a parent to a freshly spawned child: dup each parent
 * capability fd into the child's fd table and record the child's fs_inherit_fds
 * table (resolved from the child's in-memory ELF image) for its fs_init to
 * install.  A no-op if the child links no fs_inherit_fds. */
void guest_install_fdmap_mem(guest *child, const uint8_t *img, long imglen,
                             guest *parent, const struct guest_fdpass *in,
                             int nin);

/* Each front end loads the ELF, builds the machine, runs it, and returns
 * the process exit status the driver should adopt. */
int run_coldfire(const run_opts *o, int *status);
int run_rv32(const run_opts *o, int *status);
int run_mips32(const run_opts *o, int *status);
int run_x86_64hv(const run_opts *o, int *status);
int run_arm64hv(const run_opts *o, int *status);

/* The per-arch CPU vtable, for a host that drives the scheduler itself
 * (sched_init/sched_add_root, see sched.h) rather than through run_*.  Each is
 * defined only when its core is built in (EMU_COLDFIRE / EMU_RV32 / EMU_MIPS32 /
 * EMU_HV), so call the one for an arch this build carries.  Never NULL. */
const struct skj_cpu_ops *skj_ops_coldfire(void);
const struct skj_cpu_ops *skj_ops_rv32(void);
const struct skj_cpu_ops *skj_ops_mips32(void);
const struct skj_cpu_ops *skj_ops_x86_64hv(void);
const struct skj_cpu_ops *skj_ops_arm64hv(void);

/* Shared stack image: writes argc/argv/envp/auxv and returns the stack
 * pointer the guest should start with.  The _64 variant uses 8-byte slots for
 * the LP64 hardware-virtualization guests. */
uint32_t guest_build_stack(guest *g, const run_opts *o);
uint32_t guest_build_stack64(guest *g, const run_opts *o);

#endif /* GUEST_H */
