/* sched.c : the arch-neutral process sandbox and scheduler (see sched.h) */

#include "sched.h"
#include "elf32.h"
#include "elf64.h"
#include "hostplat.h"           /* hp_clock: the monotonic clock for park deadlines */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <poll.h>

#define PROC_HANDLE(slot, gen)  ((uint32_t)((slot) + 1) | ((uint32_t)(gen) << 8))

static int proc_new_mem(sched *S, const uint8_t *img, long len,
                        const char *what, char **argv, int argc, int parent);
static void reap_child(sched *S, int slot);
static proc *proc_from_handle(sched *S, uint32_t handle);

#ifdef SKJ_DWARF_BACKTRACE
/* Retain a copy of a process's ELF image so its own DWARF can symbolize a fault
 * in it, long after the loader's buffer is gone (a spawned child's image is
 * freed right after loading).  Only an accepted process keeps one; a failed
 * copy just leaves the process unsymbolized. */
static void
bt_retain_image(proc *p, const uint8_t *img, long len)
{
    if (len <= 0)
        return;
    p->bt_image = malloc((size_t)len);
    if (p->bt_image) {
        memcpy(p->bt_image, img, (size_t)len);
        p->bt_image_len = len;
    }
}

/* Release a process's retained image and its built reader.  Idempotent: the
 * cleared state makes a second call a no-op, so the zombie, reap, and shutdown
 * paths can each call it. */
static void
bt_free(proc *p)
{
    if (p->bt_state == 1)
        arena_free(&p->bt_arena);
    free(p->bt_image);
    p->bt_image = NULL;
    p->bt_image_len = 0;
    p->bt_state = 0;
}
#else
#define bt_retain_image(p, img, len)    ((void)0)
#define bt_free(p)                      ((void)0)
#endif

/****************************************************************
 * Memory bus
 *
 * ctx is the whole process, so a faulting access halts the CPU through the
 * vtable: the batched run then stops on the offending instruction (the
 * guest-memory fault flag records the address and reason).  The `be` argument
 * is the process's image endianness, so the one set of callbacks serves the
 * big-endian ColdFire guest and the little-endian rv/MIPS guests alike.
 ****************************************************************/

uint32_t
skj_bus_r8(void *ctx, uint32_t addr)
{
    proc *p = ctx;
    uint32_t v = gm_load(&p->g.mem, addr, 1, p->g.big_endian);

    if (p->g.mem.fault)
        p->ops->halt(p->cpu);
    return v;
}

uint32_t
skj_bus_r16(void *ctx, uint32_t addr)
{
    proc *p = ctx;
    uint32_t v = gm_load(&p->g.mem, addr, 2, p->g.big_endian);

    if (p->g.mem.fault)
        p->ops->halt(p->cpu);
    return v;
}

uint32_t
skj_bus_r32(void *ctx, uint32_t addr)
{
    proc *p = ctx;
    uint32_t v = gm_load(&p->g.mem, addr, 4, p->g.big_endian);

    if (p->g.mem.fault)
        p->ops->halt(p->cpu);
    return v;
}

void
skj_bus_w8(void *ctx, uint32_t addr, uint32_t val)
{
    proc *p = ctx;

    gm_store(&p->g.mem, addr, 1, p->g.big_endian, val);
    if (p->g.mem.fault)
        p->ops->halt(p->cpu);
}

void
skj_bus_w16(void *ctx, uint32_t addr, uint32_t val)
{
    proc *p = ctx;

    gm_store(&p->g.mem, addr, 2, p->g.big_endian, val);
    if (p->g.mem.fault)
        p->ops->halt(p->cpu);
}

void
skj_bus_w32(void *ctx, uint32_t addr, uint32_t val)
{
    proc *p = ctx;

    gm_store(&p->g.mem, addr, 4, p->g.big_endian, val);
    if (p->g.mem.fault)
        p->ops->halt(p->cpu);
}

/****************************************************************
 * The emulator-private host calls
 ****************************************************************/

/* Load a child from an image the guest holds in its own memory, and return the
 * child's handle (0 on any failure: a bad length, out of host memory, or an
 * image the loader rejects). */
static uint32_t
do_spawn(proc *p, uint32_t ptr, uint32_t len)
{
    static char *child_argv[] = { "child", NULL };
    uint8_t *buf;
    int h;

    if (len == 0 || len > (16u * 1024u * 1024u))        /* SPAWN image cap */
        return 0;
    buf = malloc(len);
    if (!buf)
        return 0;
    gm_read_out(&p->g.mem, ptr, buf, len);
    if (p->g.mem.fault) {
        /* The image range was not fully mapped. That is a bad spawn argument,
         * not a fault of the calling process, so clear it (the process is mid
         * call and was not faulted before this) and fail the spawn rather than
         * let the parent's next access see the stale flag and die. */
        p->g.mem.fault = 0;
        free(buf);
        return 0;
    }
    h = proc_new_mem(p->sched, buf, (long)len, "<spawned image>", child_argv, 1,
                     p->slot);
    free(buf);
    return (uint32_t)h;
}

/* Read a 32-bit word out of the calling guest's memory in its byte order,
 * without faulting the process: an unmapped address clears the transient fault
 * flag and reports failure, so a malformed spawn request fails the spawn rather
 * than killing the caller mid host-call. */
static int
gread_u32(proc *p, uint32_t addr, uint32_t *out)
{
    uint32_t v = gm_load(&p->g.mem, addr, 4, p->g.big_endian);

    if (p->g.mem.fault) {
        p->g.mem.fault = 0;
        return -1;
    }
    *out = v;
    return 0;
}

/* Copy a NUL-terminated string out of the calling guest's memory into dst (up
 * to cap bytes, always NUL-terminated).  Non-faulting like gread_u32. */
static int
gread_cstr(proc *p, uint32_t addr, char *dst, int cap)
{
    int i;

    for (i = 0; i < cap - 1; i++) {
        uint32_t c = gm_load(&p->g.mem, addr + (uint32_t)i, 1, p->g.big_endian);
        if (p->g.mem.fault) {
            p->g.mem.fault = 0;
            return -1;
        }
        dst[i] = (char)c;
        if (c == 0)
            return 0;
    }
    dst[cap - 1] = 0;
    return 0;                           /* truncated, but a valid C string */
}

/* Spawn from a size-prefixed request in guest memory (SKJ_SYS_SPAWNV): read the
 * image and, when the request is long enough, an argv vector, marshalling both
 * out of guest memory under fixed caps.  Returns the child handle, 0 on any
 * failure.  Later request fields (env, mounts, fds) are not read yet. */
static uint32_t
do_spawnv(proc *p, uint32_t desc)
{
    char argbuf[SKJ_SPAWN_ARGBUF];
    char *argv[SKJ_SPAWN_MAX_ARGC + 1];
    uint32_t size, image, image_len, argv_ptr = 0, argc = 0;
    uint32_t flags = 0, fdmap_ptr = 0, fdmap_n = 0;
    struct guest_fdpass fdpass[SKJ_SPAWN_MAX_FDMAP];
    int nfdpass = 0;
    uint8_t *buf;
    int i, off = 0, h;
    /* The descriptor is a row of pointer-width words: an address field holds a
     * guest pointer, so the field width (and the argv[] stride) is the guest's
     * pointer size.  Scalars (size, counts, flags) just occupy a word; their
     * value fits 32 bits and gread_u32 reads the low word (both LP64 tiers are
     * little-endian).  On ILP32 ps is 4, so the layout is unchanged. */
    uint32_t ps = p->sched->ops->word64 ? 8u : 4u;

    if (gread_u32(p, desc + 0u * ps, &size))
        return 0;
    if (size < 3u * ps)                 /* image + image_len is the minimum */
        return 0;
    if (gread_u32(p, desc + 1u * ps, &image)
        || gread_u32(p, desc + 2u * ps, &image_len))
        return 0;
    if (image_len == 0 || image_len > (16u * 1024u * 1024u))
        return 0;

    if (size >= 5u * ps) {              /* through argc: argv passing present */
        if (gread_u32(p, desc + 3u * ps, &argv_ptr)
            || gread_u32(p, desc + 4u * ps, &argc))
            return 0;
        if (argc > SKJ_SPAWN_MAX_ARGC)
            return 0;
    }

    if (size >= 8u * ps) {              /* through fdmap_n: flags + fd map */
        if (gread_u32(p, desc + 5u * ps, &flags)
            || gread_u32(p, desc + 6u * ps, &fdmap_ptr)
            || gread_u32(p, desc + 7u * ps, &fdmap_n))
            return 0;
        if (fdmap_n > SKJ_SPAWN_MAX_FDMAP)
            return 0;
        /* The fd map is {gfd, dst} pairs: the guest resolved each of its fds to
         * the index into its own sandbox capability table (fs_fd_backing), so
         * the host passes it without reading the guest's private fd table.  An
         * inherited fd is always a host-fd stream the child owns. */
        for (i = 0; i < (int)fdmap_n; i++) {
            uint32_t gfd, dst;
            if (gread_u32(p, fdmap_ptr + (uint32_t)i * 8u, &gfd)
                || gread_u32(p, fdmap_ptr + (uint32_t)i * 8u + 4u, &dst))
                return 0;
            if (dst >= 64u)                 /* dst < FS_MAX_FDS */
                return 0;
            fdpass[nfdpass].gfd = (int)gfd;
            fdpass[nfdpass].dst = (int)dst;
            nfdpass++;
        }
    }
    for (i = 0; i < (int)argc; i++) {
        uint32_t sptr;
        int room = SKJ_SPAWN_ARGBUF - off;
        int cap = room < SKJ_SPAWN_ARG_MAX ? room : SKJ_SPAWN_ARG_MAX;

        if (cap < 2)                    /* out of argv string space */
            return 0;
        if (gread_u32(p, argv_ptr + (uint32_t)i * ps, &sptr))
            return 0;
        if (gread_cstr(p, sptr, argbuf + off, cap))
            return 0;
        argv[i] = argbuf + off;
        off += (int)strlen(argbuf + off) + 1;
    }
    argv[argc] = 0;

    buf = malloc(image_len);
    if (!buf)
        return 0;
    gm_read_out(&p->g.mem, image, buf, image_len);
    if (p->g.mem.fault) {
        p->g.mem.fault = 0;
        free(buf);
        return 0;
    }
    h = proc_new_mem(p->sched, buf, (long)image_len, "<spawned image>",
                     argv, (int)argc, p->slot);

    /* Hand the child its namespace while the image buffer is still live (the
     * child's fs_mounts symbol is resolved from it).  Without the flag the
     * child keeps the default: no mounts, console on 0/1/2 from gfd_init. */
    if (h) {
        proc *c = proc_from_handle(p->sched, (uint32_t)h);
        if (c && (flags & SKJ_SPAWN_FLAG_SHARE_MOUNTS))
            guest_install_grants_mem(&c->g, buf, (long)image_len,
                                     p->grants, p->ngrants,
                                     c->grants, &c->ngrants);
        if (c && nfdpass > 0)
            guest_install_fdmap_mem(&c->g, buf, (long)image_len,
                                    &p->g, fdpass, nfdpass);
    }
    free(buf);
    return (uint32_t)h;
}

/* Resolve a spawn handle to a live process in the table, or NULL.  A handle is
 * a slot-plus-generation token (PROC_HANDLE), so a handle kept past a child's
 * death does not match the different process that later reuses the slot. */
static proc *
proc_from_handle(sched *S, uint32_t handle)
{
    int slot = (int)(handle & 0xff) - 1;
    proc *p;

    if (slot < 0 || slot >= S->nprocs)
        return 0;
    p = S->procs[slot];
    if (!p || p->handle != handle)
        return 0;
    return p;
}

/* SKJ_SYS_WAIT: wait on a child of the caller and return its status, reaping it.
 * A child that has already exited is a zombie whose status is kept until this
 * reads it.  If the child is still running, park the caller and re-execute the
 * call next slice (the scheduler skips it until the child exits); a core that
 * cannot park reports WOULDBLOCK so the guest retries.  A handle that is not a
 * live child of the caller is BADHANDLE. */
static uint32_t
do_wait(proc *p, uint32_t handle, enum skj_priv *how)
{
    proc *c = proc_from_handle(p->sched, handle);

    *how = SKJ_PRIV_OK;
    if (!c || c->parent_handle != p->handle)
        return SKJ_WAIT_BADHANDLE;
    if (c->done) {
        /* Mask to 8 bits (the POSIX exit-status width) so a real status can
         * never alias SKJ_WAIT_WOULDBLOCK / SKJ_WAIT_BADHANDLE, which share this
         * return channel.  A child that exited 0xfffffffe would otherwise read
         * back as "would block" and spin the waiter forever. */
        uint32_t status = (uint32_t)(c->rc ? c->rc : c->g.exit_code) & 0xffu;
        reap_child(p->sched, c->slot);
        p->wait_slot = -1;
        return status;
    }
    if (!p->g.can_park)                 /* the HV cores: cannot cooperatively park */
        return SKJ_WAIT_WOULDBLOCK;

    /* Park: record the awaited child and re-run the call next slice.  Setting
     * GPARK_RETRY makes proc_slice mark this process io_blocked (no fd), and the
     * scheduler clears that once the child exits. */
    p->wait_slot = c->slot;
    p->g.park = GPARK_RETRY;
    p->g.park_fd = -1;
    p->g.park_events = 0;
    p->g.park_deadline = 0;
    *how = SKJ_PRIV_RETRY;
    return 0;
}

/* SKJ_SYS_KILL: terminate a child of the caller, setting its wait status.  The
 * child is marked done and never runs again (cooperative: it simply drops out
 * of the schedule), becoming a zombie the caller can then wait on to read the
 * status.  Reaches only the caller's own children; a stale or foreign handle,
 * or a child that already exited, is reported but harmless. */
static uint32_t
do_kill(proc *p, uint32_t handle, uint32_t status)
{
    proc *c = proc_from_handle(p->sched, handle);

    if (!c || c->parent_handle != p->handle)
        return SKJ_WAIT_BADHANDLE;
    if (!c->done) {
        c->rc = (int)status;            /* a kill status wait() will read back */
        c->done = 1;
    }
    return 0;
}

enum skj_priv
sched_private(proc *p, uint32_t nr, uint32_t arg0, uint32_t arg1,
              uint32_t pc, uint32_t *result)
{
    switch (nr) {
    case SKJ_SYS_MAP:
        *result = gm_mmap(&p->g.mem, arg0, (unsigned)arg1);
        return SKJ_PRIV_OK;
    case SKJ_SYS_MUNMAP:
        gm_munmap(&p->g.mem, arg0, arg1);
        *result = 0;
        return SKJ_PRIV_OK;
    case SKJ_SYS_SPAWN:
        *result = do_spawn(p, arg0, arg1);
        return SKJ_PRIV_OK;
    case SKJ_SYS_SPAWNV:
        *result = do_spawnv(p, arg0);
        return SKJ_PRIV_OK;
    case SKJ_SYS_WAIT: {
        enum skj_priv how;
        *result = do_wait(p, arg0, &how);
        return how;
    }
    case SKJ_SYS_KILL:
        *result = do_kill(p, arg0, arg1);
        return SKJ_PRIV_OK;
    case SKJ_SYS_PIPE:
        *result = (uint32_t)guest_make_pipe(&p->g, arg0);
        return SKJ_PRIV_OK;
    case SKJ_SYS_FATAL:
        p->fatal = 1;
        p->fatal_pc = pc;
        p->g.exited = 1;
        p->g.exit_code = (int)(arg0 & 0xFF);
        return SKJ_PRIV_FATAL;
    case SKJ_SYS_YIELD:
        return SKJ_PRIV_YIELD;
    case SKJ_SYS_P9:
        *result = (uint32_t)guest_p9_doorbell(&p->g, arg0);
        return SKJ_PRIV_OK;
    default:
        return SKJ_PRIV_NO;
    }
}

/****************************************************************
 * Building a process
 ****************************************************************/

/* A fresh process with its own CPU and guest memory, sharing the aggregate
 * budget, or NULL if the table is full or host memory runs out. The image is
 * not loaded yet. */
static proc *
proc_alloc(sched *S)
{
    proc *p;
    int slot = -1, i;

    for (i = 0; i < S->nprocs; i++)     /* reuse a retired slot before growing */
        if (!S->procs[i]) {
            slot = i;
            break;
        }
    if (slot < 0) {
        if (S->nprocs >= SKJ_MAX_PROC)
            return NULL;
        slot = S->nprocs++;
    }
    p = calloc(1, sizeof *p);
    if (!p)
        return NULL;
    p->ops = S->ops;
    p->cpu = S->ops->alloc();
    if (!p->cpu) {
        free(p);
        return NULL;
    }
    gm_init(&p->g.mem, S->o->mem_limit);
    p->g.mem.pool = &S->pool;           /* share the aggregate memory budget */
    p->g.stdio[0] = 0;                  /* 0/1/2 dup from skj-run's own by default; */
    p->g.stdio[1] = 1;                  /* a host can rebind a root before it runs  */
    p->g.stdio[2] = 2;
    p->g.arch = S->ops->arch;
    p->g.big_endian = S->ops->big_endian;
    p->g.quiet = S->o->quiet;
    p->sched = S;
    p->slot = slot;
    p->g.sched = S;                     /* the syscall path reaches the process */
    p->g.slot = slot;                   /* table through these (the proc: fs)    */
    p->gen = S->slot_gen[slot];
    p->parent = -1;                     /* the root; a spawn overrides it */
    p->wait_slot = -1;
    if (S->ops->mem_init && S->ops->mem_init(p, S->o) != 0) {
        S->ops->free(p->cpu);
        gm_free(&p->g.mem);
        free(p);
        return NULL;
    }
    S->procs[slot] = p;
    return p;
}

/* Discard a process that failed to build: free its CPU and memory and release
 * its slot without bumping the generation (the slot never hosted a live
 * process). */
static void
proc_discard(sched *S, proc *p)
{
    S->procs[p->slot] = NULL;
    S->ops->free(p->cpu);
    guest_fds_free(&p->g);
    guest_p9_free(&p->g);
    gm_free(&p->g.mem);
    bt_free(p);
    free(p);
}

/* With the image loaded and its header validated, lay out the heap and stack,
 * seed the initial stack from argv, and ready the CPU. It already holds a table
 * slot; fill in its handle and return it. */
static int
proc_finish(sched *S, proc *p, const elf32_info *info,
            char **argv, int argc, char **envp, int envc)
{
    run_opts so;
    uint32_t stack_base, sp, heap_base;

    heap_base = (info->hi + GM_PAGE_SIZE - 1) & ~(GM_PAGE_SIZE - 1);
    p->g.brk_base = p->g.brk = heap_base;
    p->g.brk_limit = heap_base + S->o->heap_size;
    gm_map(&p->g.mem, heap_base, S->o->heap_size, GM_R | GM_W, "heap");

    stack_base = p->g.brk_limit + GM_PAGE_SIZE;
    gm_map(&p->g.mem, stack_base, S->o->stack_size, GM_R | GM_W, "stack");
    p->g.stack_top = stack_base + S->o->stack_size;

    /* An extern-backed guest (HV tier) has one contiguous RAM buffer, not the
     * full 32-bit space a paged guest enjoys.  Start its dynamic mmap area just
     * above the stack so gm_mmap hands out addresses that fall inside RAM, not
     * at the paged default of GM_MMAP_BASE (which lies past the RAM end). */
    if (p->g.mem.extern_base)
        p->g.mem.mmap_next = p->g.stack_top + GM_PAGE_SIZE;

    /* Inject the vDSO (if one was given) before the stack is built, so the auxv
     * can advertise it. The image is built once and shared read-only across
     * every process: an emulated guest aliases it through gm_page, an HV guest
     * maps it as a read-only hypervisor memory slot. The image is ELF32 for the
     * ILP32 cores and ELF64 for the LP64 (HV) cores, matched to word64. */
    if (S->o->vdso && S->vdso_state >= 0) {
        if (S->vdso_state == 0)
            S->vdso_state = guest_vdso_image(S->o->vdso, S->ops->word64,
                                             &S->vdso_buf, &S->vdso_vaddr,
                                             &S->vdso_size, &S->vdso_table,
                                             &S->vdso_sys) == 0 ? 1 : -1;
        if (S->vdso_state < 0)
            return -1;
        guest_vdso_attach(&p->g, S->vdso_buf, S->vdso_vaddr, S->vdso_size,
                          S->vdso_table);
    }

    so = *S->o;                 /* keep the driver's sizes; take this root's argv/env */
    so.argv = argv;
    so.argc = argc;
    so.envp = envp;
    so.envc = envc;
    sp = S->ops->word64 ? guest_build_stack64(&p->g, &so)
                        : guest_build_stack(&p->g, &so);

    p->ops->ready(p, info->entry, sp);

    p->handle = PROC_HANDLE(p->slot, p->gen);
    return (int)p->handle;
}

/* Common tail: the image must match the core (machine and endianness). Returns
 * 0 (and frees p) on any rejection. */
static int
proc_accept(sched *S, proc *p, const elf32_info *info, const char *what,
            char **argv, int argc, char **envp, int envc)
{
    if (info->machine != S->ops->machine) {
        fprintf(stderr, "skj-run: %s is not a %s image\n", what, S->ops->name);
        goto fail;
    }
    if (info->big_endian != S->ops->big_endian) {
        fprintf(stderr, "skj-run: %s has the wrong byte order for %s\n",
                what, S->ops->name);
        goto fail;
    }
    return proc_finish(S, p, info, argv, argc, envp, envc);
fail:
    proc_discard(S, p);
    return 0;
}

/* The root process, from a file, with its own argv and environment. */
static int
proc_new_file(sched *S, const char *path, char **argv, int argc,
              char **envp, int envc)
{
    proc *p = proc_alloc(S);
    elf32_info info;

    if (!p)
        return 0;
    if ((S->ops->word64 ? elf64_load(&p->g, path, &info)
                        : elf32_load(&p->g, path, &info)) != 0) {
        proc_discard(S, p);
        return 0;
    }
    return proc_accept(S, p, &info, path, argv, argc, envp, envc);
}

/* The root process, from an in-memory image, with its own argv and environment.
 * The file sibling of this is proc_new_file; the difference is only the loader,
 * so this is a true root too (proc_alloc defaults parent = -1 and no instruction
 * budget).  `what` is the diagnostic label a path would otherwise supply. */
static int
proc_new_mem_root(sched *S, const uint8_t *img, long len, const char *what,
                  char **argv, int argc, char **envp, int envc)
{
    proc *p = proc_alloc(S);
    elf32_info info;
    int h;

    if (!p)
        return 0;
    if ((S->ops->word64 ? elf64_load_mem(&p->g, img, len, &info, what)
                        : elf32_load_mem(&p->g, img, len, &info, what)) != 0) {
        proc_discard(S, p);
        return 0;
    }
    h = proc_accept(S, p, &info, what, argv, argc, envp, envc);
    if (h > 0)
        bt_retain_image(p, img, len);
    return h;
}

/* A spawned child, from an in-memory image. */
static int
proc_new_mem(sched *S, const uint8_t *img, long len, const char *what,
             char **argv, int argc, int parent)
{
    proc *p = proc_alloc(S);
    elf32_info info;
    int h;

    if (!p)
        return 0;
    p->parent = parent;                         /* who may wait on it */
    p->parent_handle = (parent >= 0 && parent < S->nprocs && S->procs[parent])
                       ? S->procs[parent]->handle : 0;
    p->insn_budget = S->o->child_max_insns;     /* a spawned child is budgeted */
    if ((S->ops->word64 ? elf64_load_mem(&p->g, img, len, &info, what)
                        : elf32_load_mem(&p->g, img, len, &info, what)) != 0) {
        proc_discard(S, p);
        return 0;
    }
    /* A spawned child inherits no environment yet; the spawn descriptor could
     * carry one later, the way it grew argv and the fd map. */
    h = proc_accept(S, p, &info, what, argv, argc, NULL, 0);
    if (h > 0)
        bt_retain_image(p, img, len);
    return h;
}

/****************************************************************
 * Fault backtrace (optional, SKJ_DWARF_BACKTRACE)
 ****************************************************************/

#ifdef SKJ_DWARF_BACKTRACE

#define BT_MAX_FRAMES   32

/* Guest-memory read adapter for dw_backtrace.  gm_read_out never faults (an
 * unmapped byte reads as zero), so a frame pointer off the end of the stack
 * yields a zero return address, which ends the walk.  A big-endian core (cf)
 * composes each 4-byte slot into host order; a little-endian one reads the
 * native uint32 straight through. */
struct bt_ctx {
    guest_mem *mem;
    int big_endian;
};

static int
bt_read(void *ctx, uint32_t addr, void *dst, uint32_t len)
{
    struct bt_ctx *b = ctx;

    gm_read_out(b->mem, addr, dst, len);
    if (b->big_endian && len == 4) {
        uint8_t *p = dst;
        uint32_t v = (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16
                   | (uint32_t)p[2] << 8 | (uint32_t)p[3];
        memcpy(dst, &v, 4);
    }
    return 1;
}

/* Build (once) and return the DWARF reader for a faulting process's own image,
 * so any process is symbolized, not just the root.  A spawned child and a
 * mem-image root keep their ELF bytes in p->bt_image (retained at load); a file
 * root keeps none, so slot 0 reads its ELF from disk here the first time.
 * Returns NULL when no image is available or it carries no usable debug info. */
static const struct dw_reader *
proc_reader(sched *S, proc *p)
{
    if (p->bt_state != 0)
        return p->bt_state == 1 ? &p->bt_reader : NULL;
    p->bt_state = -1;                   /* assume failure until built */

    /* A file root (no retained image) reads its ELF from disk once. */
    if (!p->bt_image && p->slot == 0 && S->o->path) {
        FILE *f = fopen(S->o->path, "rb");
        long n;
        size_t got;

        if (!f)
            return NULL;
        if (fseek(f, 0, SEEK_END) != 0 || (n = ftell(f)) <= 0) {
            fclose(f);
            return NULL;
        }
        rewind(f);
        p->bt_image = malloc((size_t)n);
        if (!p->bt_image) {
            fclose(f);
            return NULL;
        }
        got = fread(p->bt_image, 1, (size_t)n, f);
        fclose(f);
        if (got != (size_t)n) {
            free(p->bt_image);
            p->bt_image = NULL;
            return NULL;
        }
        p->bt_image_len = n;
    }
    if (!p->bt_image)
        return NULL;

    arena_init(&p->bt_arena);
    if (dw_read_elf(&p->bt_arena, &p->bt_reader, p->bt_image,
                    (size_t)p->bt_image_len) != 0) {
        arena_free(&p->bt_arena);
        return NULL;
    }
    p->bt_state = 1;
    return &p->bt_reader;
}

/* Print a symbolized backtrace for a faulting process to stderr.  pc is the
 * live instruction; the frame pointer comes from the vtable. */
static void
print_backtrace(sched *S, proc *p, uint32_t pc)
{
    uint32_t pcs[BT_MAX_FRAMES];
    const struct dw_reader *r = proc_reader(S, p);
    struct bt_ctx bc;
    char buf[2048];
    int n;

    bc.mem = &p->g.mem;
    bc.big_endian = S->ops->bt_bigendian;
    n = dw_backtrace(pc, S->ops->bt_fp(p->cpu), bt_read, &bc, pcs, BT_MAX_FRAMES);
    if (n <= 0)
        return;
    dw_backtrace_format(r, pcs, n, buf, sizeof buf);
    fprintf(stderr, "skj-run: [proc %d] backtrace:\n%s", p->slot + 1, buf);
}

#else
#define print_backtrace(S, p, pc)      ((void)0)
#endif /* SKJ_DWARF_BACKTRACE */

/****************************************************************
 * The scheduler
 ****************************************************************/

/* Run one process for up to a quantum, or until it stops or an instruction
 * budget is hit; on a stop, record its status and mark it done.  The core's
 * run() returns the reason it handed control back, so the checks happen once
 * per slice rather than once per instruction. */
static void
proc_slice(sched *S, proc *p)
{
    const run_opts *o = S->o;
    const skj_cpu_ops *ops = S->ops;
    uint64_t budget = SKJ_QUANTUM;
    enum skj_run_reason reason;
    int ran = 0;

    /* This process is getting a slice, so it is runnable: clear any cooperative
     * yield from a previous slice (rv's wfi park, or the MAP-range YIELD host
     * call on mips/cf).  User mode has no interrupt to clear it, so without this
     * a single yield would park the task forever. */
    ops->clear_yield(p->cpu);

    /* Shrink the batch so a per-process or global instruction limit is met
     * exactly rather than overshot by up to a quantum. A live process has room
     * left, so budget stays positive. */
    if (p->insn_budget && p->insn_budget - p->insns < budget)
        budget = p->insn_budget - p->insns;
    if (o->max_insns && o->max_insns - S->insns < budget)
        budget = o->max_insns - S->insns;
    if (budget == 0)
        budget = 1;

    reason = ops->run(p, (int)budget, &ran);
    S->insns += (uint64_t)ran;
    p->insns += (uint64_t)ran;

    /* A memory fault halts through the bus, so it reads as a halt with the
     * fault flag set; report it before the plain halt cases. */
    if (p->g.mem.fault) {
        uint32_t pc = ops->fault_pc(p->cpu);

        if (p->g.mem.fault_guard)
            fprintf(stderr, "skj-run: [proc %d] stack overflow at 0x%08x "
                    "(pc=0x%08x)\n", p->slot + 1, p->g.mem.fault_addr, pc);
        else
            fprintf(stderr, "skj-run: [proc %d] bad memory %s at 0x%08x "
                    "(%s), pc=0x%08x\n", p->slot + 1,
                    p->g.mem.fault_write ? "write" : "read",
                    p->g.mem.fault_addr, p->g.mem.fault_why, pc);
        ops->dump_regs(stderr, p->slot, p->cpu);
        if (o->trace)
            ops->dump_trace(stderr, p->cpu);
        print_backtrace(S, p, pc);
        p->rc = 128 + 11;               /* SIGSEGV */
        p->done = 1;
        return;
    }
    if (reason == SKJ_RUN_TRAP && !p->g.exited) {
        ops->report_trap(stderr, p->slot, p->cpu);
        ops->dump_regs(stderr, p->slot, p->cpu);
        if (o->trace)
            ops->dump_trace(stderr, p->cpu);
        print_backtrace(S, p, ops->trap_pc(p->cpu));
        p->rc = 128 + ops->trap_signal(p->cpu);
        p->done = 1;
        return;
    }
    if (p->g.exited) {                  /* a clean exit through the exit syscall */
        if (p->fatal)                   /* ... or SKJ_SYS_FATAL: show the stack first */
            print_backtrace(S, p, p->fatal_pc);
        p->done = 1;
        return;
    }
    if (reason == SKJ_RUN_HALT) {       /* halted without exiting: a double fault */
        fprintf(stderr, "skj-run: [proc %d] stopped without calling exit "
                "(pc=0x%08x)\n", p->slot + 1, ops->fault_pc(p->cpu));
        if (o->trace)
            ops->dump_trace(stderr, p->cpu);
        p->rc = 128 + 6;
        p->done = 1;
        return;
    }
    if (p->insn_budget && p->insns >= p->insn_budget) {
        /* the child overran its own budget: kill it alone, not the run */
        fprintf(stderr, "skj-run: [proc %d] instruction budget (%llu) "
                "exceeded\n", p->slot + 1, (unsigned long long)p->insn_budget);
        p->rc = 128 + 24;               /* SIGXCPU */
        p->done = 1;
        return;
    }
    if (o->max_insns && S->insns >= o->max_insns) {
        fprintf(stderr, "skj-run: instruction limit (%llu) reached\n",
                (unsigned long long)o->max_insns);
        p->rc = 128 + 24;               /* SIGXCPU */
        p->done = 1;
        S->limited = 1;
        return;
    }
    /* A cooperative park on a blocking syscall (read/nanosleep): record what the
     * process is waiting on so the scheduler can skip its slices and poll on its
     * behalf, rather than spinning the syscall every round.  A plain yield
     * (sched_yield / SKJ_SYS_YIELD) leaves io_blocked clear and just reschedules. */
    if (reason == SKJ_RUN_YIELD && p->g.park == GPARK_RETRY) {
        p->io_blocked = 1;
        p->park_fd = p->g.park_fd;
        p->park_events = p->g.park_events;
        p->park_deadline = p->g.park_deadline;
    }
    p->g.park = GPARK_NONE;

    /* SKJ_RUN_BUDGET or SKJ_RUN_YIELD with room left: still runnable, reschedule. */
}

/* Free a process's heavy resources (its CPU and guest memory, returning the
 * pages to the pool), leaving the small proc struct so its exit status can
 * still be read.  Idempotent via the zombie flag: never frees twice. */
static void
free_proc_resources(proc *p)
{
    if (p->zombie)
        return;
    p->ops->free(p->cpu);
    guest_fds_free(&p->g);              /* close its host fds (pipe ends -> EOF) */
    guest_p9_free(&p->g);
    gm_free(&p->g.mem);
    bt_free(p);                         /* the fault backtrace, if any, is long printed */
    p->zombie = 1;
}

/* A finished child turns into a zombie: its resources are freed but its slot and
 * exit status are kept until a wait reaps it (or it is orphaned). */
static void
zombify_child(sched *S, int slot)
{
    free_proc_resources(S->procs[slot]);
}

/* Reap a child for good: free whatever resources remain, then free its slot for
 * reuse with a bumped generation so a stale handle no longer matches. The root
 * process (slot 0) is kept for the run's status and freed at the end. */
static void
reap_child(sched *S, int slot)
{
    proc *p = S->procs[slot];

    free_proc_resources(p);             /* no-op if already a zombie */
    free(p);
    S->procs[slot] = NULL;
    S->slot_gen[slot]++;
}

/* A monotonic clock in nanoseconds, matching guest.c's sleep deadlines. */
static uint64_t
mono_ns(void)
{
    uint32_t sec = 0, nsec = 0;

    hp_clock(0, &sec, &nsec);                   /* 0 = monotonic */
    return (uint64_t)sec * 1000000000ull + nsec;
}

static uint64_t
real_ns(void)
{
    uint32_t sec = 0, nsec = 0;

    hp_clock(1, &sec, &nsec);                   /* 1 = realtime */
    return (uint64_t)sec * 1000000000ull + nsec;
}

/* Field offsets and size of struct skj_vdso_sys (include/skj_vdso.h).  The host
 * avoids that guest header because its sibling struct skj_vdso carries
 * pointer-width members; the system page is all fixed-width integers, so these
 * mirror its layout.  Keep them in step with the header. */
#define VDSO_SYS_SEQ      8u
#define VDSO_SYS_MONO_NS  24u
#define VDSO_SYS_REAL_NS  32u
#define VDSO_SYS_SIZE     104u

static void
st32(uint8_t *p, uint32_t v, int be)
{
    int i;

    for (i = 0; i < 4; i++)
        p[be ? 3 - i : i] = (uint8_t)(v >> (8 * i));
}

static void
st64(uint8_t *p, uint64_t v, int be)
{
    int i;

    for (i = 0; i < 8; i++)
        p[be ? 7 - i : i] = (uint8_t)(v >> (8 * i));
}

static uint32_t
ld32(const uint8_t *p, int be)
{
    uint32_t v = 0;
    int i;

    for (i = 0; i < 4; i++)
        v |= (uint32_t)p[be ? 3 - i : i] << (8 * i);
    return v;
}

/* Refresh the vDSO system page's clock, so a guest reading it (through the
 * SKJ_VDSO_MONO_NS / SKJ_VDSO_REAL_NS functions or the page directly) gets the
 * time with no doorbell.  Called just before a process runs; the guest is
 * stopped here, so the write cannot race a read, but the seqlock is still
 * driven (odd, write, even) to honour the page's documented contract.  The
 * clock advances at slice granularity, which is the fast path's tradeoff: no
 * trap per read, freshness bounded by the quantum.  Fields are written in the
 * guest's byte order, since the guest reads them with its own toolchain. */
static void
sched_update_sysinfo(sched *S)
{
    uint8_t *base;
    uint32_t off, seq;
    int be = S->ops->big_endian;

    if (!S->vdso_buf || !S->vdso_sys)
        return;
    off = S->vdso_sys - S->vdso_vaddr;          /* offset into the shared image */
    if (off + VDSO_SYS_SIZE > S->vdso_size)
        return;
    base = S->vdso_buf + off;

    seq = ld32(base + VDSO_SYS_SEQ, be) + 1;     /* odd: a write is in flight */
    st32(base + VDSO_SYS_SEQ, seq, be);
    st64(base + VDSO_SYS_MONO_NS, mono_ns(), be);
    st64(base + VDSO_SYS_REAL_NS, real_ns(), be);
    st32(base + VDSO_SYS_SEQ, seq + 1, be);      /* even: the write is complete */
}

/* Collect the wait set of the I/O-parked processes: each one's host fd into
 * fds[] and its poll events into events[] (up to max entries), and the nearest
 * sleep deadline into *deadline_ns (0 if none).  Returns the fd count.  A host
 * driving the scheduler from its own event loop calls this, polls the fds
 * alongside its own (a listen socket, a timer), and reports readiness back
 * through sched_mark_ready / sched_wake_deadlines. */
int
sched_waits(sched *S, int *fds, short *events, int max, uint64_t *deadline_ns)
{
    int n = 0, i;
    uint64_t deadline = 0;

    for (i = 0; i < S->nprocs; i++) {
        proc *p = S->procs[i];

        if (!p || p->done || !p->io_blocked)
            continue;
        if (p->park_fd >= 0 && n < max) {
            fds[n] = p->park_fd;
            events[n] = p->park_events;
            n++;
        }
        if (p->park_deadline && (deadline == 0 || p->park_deadline < deadline))
            deadline = p->park_deadline;
    }
    if (deadline_ns)
        *deadline_ns = deadline;
    return n;
}

/* Wake every process parked on host fd (there may be more than one, e.g. two
 * readers of a pipe); the scheduler runs each again next round. */
void
sched_mark_ready(sched *S, int fd)
{
    int i;

    for (i = 0; i < S->nprocs; i++) {
        proc *p = S->procs[i];
        if (p && !p->done && p->io_blocked && p->park_fd == fd)
            p->io_blocked = 0;
    }
}

/* Wake every sleeper whose deadline has passed (monotonic ns). */
void
sched_wake_deadlines(sched *S)
{
    uint64_t now = mono_ns();
    int i;

    for (i = 0; i < S->nprocs; i++) {
        proc *p = S->procs[i];
        if (p && !p->done && p->io_blocked && p->park_deadline &&
            now >= p->park_deadline)
            p->io_blocked = 0;
    }
}

/* The scheduler's own poll over sched_waits: build a pollfd set, take the
 * nearest sleep deadline as the timeout, and poll.  When `block` is 0 the poll
 * returns at once (timeout 0), just harvesting fds already ready; when 1 it
 * blocks until something is ready or the nearest deadline passes.  A host that
 * runs its own event loop uses sched_waits + sched_mark_ready + the deadline
 * wake directly instead of this. */
static void
poll_blocked(sched *S, int block)
{
    struct pollfd fds[SKJ_MAX_PROC];
    int pfd[SKJ_MAX_PROC];
    short pev[SKJ_MAX_PROC];
    int nfds, i, timeout;
    uint64_t now, deadline = 0;

    nfds = sched_waits(S, pfd, pev, SKJ_MAX_PROC, &deadline);

    if (!block) {
        timeout = 0;
    } else if (deadline) {
        now = mono_ns();
        if (deadline <= now) {
            timeout = 0;
        } else {
            uint64_t ms = (deadline - now + 999999ull) / 1000000ull;
            /* Cap a very long sleep: poll wakes early, the deadline wake below
             * leaves the sleeper parked, and the scheduler polls again. */
            timeout = ms > 3600000ull ? 3600000 : (int)ms;
        }
    } else {
        timeout = -1;                   /* only fd waiters: block indefinitely */
    }

    if (nfds > 0) {
        int r;
        for (i = 0; i < nfds; i++) {
            fds[i].fd = pfd[i];
            fds[i].events = pev[i];
            fds[i].revents = 0;
        }
        do {
            r = poll(fds, (nfds_t)nfds, timeout);
        } while (r < 0 && errno == EINTR);
        for (i = 0; i < nfds; i++)
            if (fds[i].revents)
                sched_mark_ready(S, fds[i].fd);
    } else if (block && deadline) {
        /* Pure sleepers, nothing to poll: wait out the nearest deadline. */
        if (timeout > 0)
            hp_sleep((uint32_t)(timeout / 1000),
                     (uint32_t)((timeout % 1000) * 1000000));
    }

    sched_wake_deadlines(S);
}

/* One scheduler round: give every runnable process a slice, then do the
 * end-of-round bookkeeping.  Turn finished children into zombies (keeping their
 * exit status for a wait), wake any parent blocked in wait() whose child has
 * exited, and reap any zombie whose parent is gone or itself finished so an
 * unwaited child does not leak its slot.  A child spawned this round is picked
 * up on the next one.  Sets *ran to 1 if any process ran.  Returns the number
 * of live (not done) processes; 0 means the run is over OR, if S->limited is
 * set, the global instruction budget was hit mid-round (the round returns early
 * then, before the bookkeeping) -- a caller distinguishes the two by S->limited. */
int
sched_step(sched *S, int *ran)
{
    int live = 0, i;

    *ran = 0;
    for (i = 0; i < S->nprocs; i++) {
        proc *p = S->procs[i];

        if (!p || p->done || p->io_blocked)
            continue;
        sched_update_sysinfo(S);        /* refresh the doorbell-free clock */
        proc_slice(S, p);
        *ran = 1;
        if (S->limited)
            return 0;                   /* the whole run stops at the budget */
    }
    for (i = 1; i < S->nprocs; i++)
        if (S->procs[i] && S->procs[i]->done)
            zombify_child(S, i);
    for (i = 0; i < S->nprocs; i++) {
        proc *w = S->procs[i];
        if (w && w->io_blocked && w->wait_slot >= 0) {
            proc *c = S->procs[w->wait_slot];
            if (!c || c->done)
                w->io_blocked = 0;      /* re-run wait(): it reaps and returns */
        }
    }
    for (i = 1; i < S->nprocs; i++) {
        proc *c = S->procs[i];
        if (c && c->done) {
            /* Resolve the parent by handle, not by slot: if the slot was reaped
             * and reused, proc_from_handle returns NULL (generation mismatch),
             * so an orphan is reaped rather than leaked and falsely reparented
             * onto the slot's new occupant. */
            proc *par = proc_from_handle(S, c->parent_handle);
            if (!par || par->done)
                reap_child(S, i);
        }
    }
    for (i = 0; i < S->nprocs; i++)
        if (S->procs[i] && !S->procs[i]->done) {
            live = 1;
            break;
        }
    return live;
}

/* The built-in run loop: step, then wait on parked I/O, until no process is
 * live or the global budget is hit.  A process parked on a blocking syscall is
 * skipped until its fd is ready or its sleep deadline passes; when nothing ran
 * this round every live process is parked, so poll_blocked blocks rather than
 * spins.  A host embedding the scheduler can drive sched_step + sched_waits +
 * sched_mark_ready from its own event loop instead of calling this. */
void
sched_run(sched *S)
{
    for (;;) {
        int ran, live = sched_step(S, &ran);

        if (S->limited)
            return;                     /* budget hit mid-round */
        if (!live)
            return;                     /* every process has exited */
        /* If anything ran this round, more work is immediately available, so
         * only harvest already-ready parked fds without waiting.  If nothing
         * ran, every live process is I/O-parked: block until one is ready. */
        poll_blocked(S, !ran);
    }
}

/****************************************************************
 * The run loop
 ****************************************************************/

/* Set up an empty scheduler over a core and the run options.  A host then adds
 * one or more roots with sched_add_root and drives it with sched_run (the whole
 * run) or sched_step + the wait primitives (its own event loop). */
void
sched_init(sched *S, const run_opts *o, const skj_cpu_ops *ops)
{
    memset(S, 0, sizeof *S);
    S->o = o;
    S->ops = ops;
    S->pool.limit = o->total_mem;       /* aggregate commit cap, 0 = unlimited */
}

/* Load a root process described by `r` and install its mounts.  Each root gets
 * its own argv, environment, and stdio binding, so a host can run several
 * independent trees under one scheduler, each bound to its own connection.  Any
 * of r->argv / r->envp / r->stdio may be NULL: argv then falls back to the run
 * options' argv, envp to an empty environment, and stdio to skj-run's own
 * 0/1/2.  When r->image is set the image is loaded from that in-memory buffer
 * (r->path then names it only in diagnostics), else it is opened from r->path.
 * Returns the process handle (>0) or 0 if the image failed to load. */
int
sched_add_root(sched *S, const sched_root *r)
{
    char **argv = r->argv ? r->argv : S->o->argv;
    int argc = r->argv ? r->argc : S->o->argc;
    int h = r->image
            ? proc_new_mem_root(S, r->image, r->image_len, r->path,
                                argv, argc, r->envp, r->envc)
            : proc_new_file(S, r->path, argv, argc, r->envp, r->envc);
    proc *p;

    if (h <= 0)
        return 0;
    p = proc_from_handle(S, (uint32_t)h);
    if (!p)
        return 0;
    guest_install_mounts(&p->g, r->path, S->o, p->grants, &p->ngrants);
    if (r->stdio) {
        p->g.stdio[0] = r->stdio[0];
        p->g.stdio[1] = r->stdio[1];
        p->g.stdio[2] = r->stdio[2];
    }
    return h;
}

/* Free every process and the shared resources (vDSO image, backtrace reader). */
void
sched_destroy(sched *S)
{
    int i;

    for (i = 0; i < S->nprocs; i++) {   /* the root, plus any child not yet retired */
        if (!S->procs[i])
            continue;
        S->ops->free(S->procs[i]->cpu);
        guest_fds_free(&S->procs[i]->g);    /* close host fds, remove scratch dir */
        guest_p9_free(&S->procs[i]->g);
        gm_free(&S->procs[i]->g.mem);
        bt_free(S->procs[i]);               /* its retained image + built reader */
        free(S->procs[i]);
    }
    free(S->vdso_buf);                  /* the one shared vDSO image */
}

int
run_sandbox(const run_opts *o, const skj_cpu_ops *ops, int *status)
{
    sched S;
    sched_root root = { 0 };
    proc *rp;
    int rc;

    sched_init(&S, o, ops);
    root.path = o->path;                /* argv falls back to the run options; env */
    root.envp = o->envp;                /* and stdio come from the CLI (--env / own) */
    root.envc = o->envc;
    root.image = o->root_image;         /* --mem: load the root from memory, path */
    root.image_len = o->root_image_len; /* then only labels it (fault/trace text)  */
    if (sched_add_root(&S, &root) <= 0) /* the root image failed to load */
        return -1;
    rp = S.procs[0];

    if (ops->gdb && o->gdb_port > 0) {
        /* Debug the root process under the GDB remote protocol instead of
         * running the scheduler.  Single-process: a guest that spawns while
         * debugged leaves its child unscheduled. */
        int ecode = 0;
        ops->gdb(rp, o->gdb_port, &ecode);
        rp->done = 1;
        if (rp->g.exited)
            rp->g.exit_code = ecode;
    } else {
        sched_run(&S);
    }

    rc = rp->rc;
    if (S.limited && !rc)
        rc = 128 + 24;

    if (o->stats)
        fprintf(stderr, "skj-run: %llu instructions, %llu syscalls, "
                "%llu KB guest memory (proc 1)\n", (unsigned long long)S.insns,
                (unsigned long long)rp->g.syscalls,
                (unsigned long long)(rp->g.mem.committed / 1024));

    *status = rc ? rc : rp->g.exit_code;

    sched_destroy(&S);
    return 0;
}
