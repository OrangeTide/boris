/* guest.c : sparse guest memory, the syscall layer, and the initial stack */

/* This file is the host-agnostic guest syscall layer: it carries no host-OS
 * #ifdefs.  Every facility that differs by host (confined opens, directory
 * enumeration, the clock, random bytes) is reached through hostplat.h, whose
 * one implementation per OS lives in hostplat.c. */
#if defined(__APPLE__)
# define _DARWIN_C_SOURCE               /* the *at family, fdopendir, ...        */
#else
# define _POSIX_C_SOURCE 200809L        /* openat / fstatat / renameat, AT_FDCWD  */
# define _DEFAULT_SOURCE
#endif

#include "guest.h"
#include "elf32.h"
#include "elf64.h"
#include "fs.h"             /* the guest fs/ mount-table layout the launcher fills */
#include "ninefs.h"         /* P9_MSIZE: the 9p channel buffer size               */
#include "p9_server.h"      /* the host-side 9p file server the doorbell drives   */
#include "hostplat.h"       /* the host facilities that service the guest ABI     */
#include "procfs.h"         /* the proc: pseudo filesystem, served from the sched  */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <errno.h>
#include <poll.h>
#include <dirent.h>

/****************************************************************
 * Sparse memory
 ****************************************************************/

void
gm_init(guest_mem *m, uint64_t limit)
{
    memset(m, 0, sizeof(*m));
    m->limit = limit;
}

void
gm_free(guest_mem *m)
{
    int i, j;

    for (i = 0; i < GM_L1_ENTRIES; i++) {
        if (!m->dir[i])
            continue;
        for (j = 0; j < GM_L2_ENTRIES; j++)
            free(m->dir[i][j]);
        free(m->dir[i]);
        m->dir[i] = NULL;
    }
    for (i = 0; i < GM_L1_ENTRIES; i++) {       /* wdir borrows dir's pages */
        free(m->wdir[i]);
        m->wdir[i] = NULL;
    }
    if (m->pool) {                      /* return this guest's pages to the pool */
        if (m->pool->used >= m->committed)
            m->pool->used -= m->committed;
        else
            m->pool->used = 0;
    }
    m->committed = 0;
}

int
gm_map(guest_mem *m, uint32_t base, uint32_t size, int prot, const char *name)
{
    struct gm_region *r;

    if (m->nregions >= GM_MAX_REGIONS)
        return -1;
    r = &m->regions[m->nregions++];
    r->base = base;
    r->size = size;
    r->prot = prot;
    r->name = name;
    return 0;
}

/* The dynamic mapping area sits above the image, heap, and stack the loader
 * places, and grows upward. Each mapping is followed by a one-page gap so a
 * following guard page never abuts the previous mapping. */
#define GM_MMAP_BASE    0x70000000u

uint32_t
gm_mmap(guest_mem *m, uint32_t size, unsigned flags)
{
    uint32_t base;

    uint64_t next, base64, end, ceiling;
    int slots;

    size = (size + GM_PAGE_SIZE - 1) & ~(GM_PAGE_SIZE - 1);
    if (size == 0)
        return 0;
    /* An extern-backed guest (the HV tier) has one contiguous RAM buffer, so
     * the dynamic area lives inside it, above the stack (proc_finish seeds the
     * cursor).  A paged guest spans the whole 32-bit space, so it starts the
     * dynamic area high, well clear of the image/heap/stack. */
    if (m->mmap_next == 0)
        m->mmap_next = GM_MMAP_BASE;
    ceiling = m->extern_base ? (uint64_t)m->extern_size : 0x100000000ull;

    /* Lay out an optional guard page, the mapping, and a trailing gap, all in
     * 64-bit so a large request cannot wrap the 32-bit cursor and hand back a
     * low address that overlaps the image, the heap, or an earlier mapping.
     * The whole extent must stay inside the backing (RAM size, or the 32-bit
     * space for a paged guest). */
    next = m->mmap_next;
    base64 = next + ((flags & GM_MAP_GUARD_LO) ? GM_PAGE_SIZE : 0);
    end = base64 + (uint64_t)size + GM_PAGE_SIZE;   /* + the trailing gap */
    if (end > ceiling)
        return 0;

    /* Reserve the region slots up front, so a full table never leaves a guard
     * mapped with no mapping behind it. */
    slots = (flags & GM_MAP_GUARD_LO) ? 2 : 1;
    if (m->nregions + slots > GM_MAX_REGIONS)
        return 0;

    if (flags & GM_MAP_GUARD_LO)        /* an unmapped page below the region */
        gm_map(m, (uint32_t)next, GM_PAGE_SIZE, 0, "guard");

    base = (uint32_t)base64;
    gm_map(m, base, size, GM_R | GM_W, "mapping");
    m->mmap_next = (uint32_t)end;
    return base;
}

void
gm_munmap(guest_mem *m, uint32_t base, uint32_t size)
{
    uint32_t a, pages, k;
    int i;

    size = (size + GM_PAGE_SIZE - 1) & ~(GM_PAGE_SIZE - 1);
    if (size == 0)
        return;
    if ((uint64_t)base + size > 0x100000000ull)     /* a range that wraps: ignore */
        return;

    /* Free the committed pages of the mapping (its guard never commits). Count
     * pages rather than compare against base + size, which would wrap. */
    pages = size >> GM_PAGE_SHIFT;
    for (k = 0, a = base; k < pages; k++, a += GM_PAGE_SIZE) {
        uint32_t l1 = a >> 22;
        uint32_t l2 = (a >> GM_PAGE_SHIFT) & (GM_L2_ENTRIES - 1);

        if (m->dir[l1] && m->dir[l1][l2]) {
            free(m->dir[l1][l2]);
            m->dir[l1][l2] = NULL;
            if (m->wdir[l1])            /* drop the borrowed write-cache pointer */
                m->wdir[l1][l2] = NULL;
            if (m->committed >= GM_PAGE_SIZE)
                m->committed -= GM_PAGE_SIZE;
            if (m->pool && m->pool->used >= GM_PAGE_SIZE)
                m->pool->used -= GM_PAGE_SIZE;
        }
    }

    /* Drop the mapping's region entry, and the guard page just below it if it
     * has one, keeping the region table order. */
    for (i = 0; i < m->nregions; i++) {
        if (m->regions[i].base == base && m->regions[i].size == size) {
            int lo = i, drop, j;

            if (i > 0 && m->regions[i - 1].prot == 0 &&
                m->regions[i - 1].base + m->regions[i - 1].size == base)
                lo = i - 1;
            drop = i - lo + 1;
            for (j = lo; j + drop < m->nregions; j++)
                m->regions[j] = m->regions[j + drop];
            m->nregions -= drop;
            break;
        }
    }
    m->last = NULL;             /* the compaction may dangle the lookup cache */
}

/** Region containing addr, or NULL.  Accesses cluster, so the last hit is
 * tried first and the scan is the exception. */
static struct gm_region *
region_of(guest_mem *m, uint32_t addr)
{
    struct gm_region *r = m->last;
    int i;

    if (r && addr >= r->base && addr - r->base < r->size)
        return r;
    for (i = 0; i < m->nregions; i++) {
        r = &m->regions[i];
        if (addr >= r->base && addr - r->base < r->size) {
            m->last = r;
            return r;
        }
    }
    return NULL;
}

/** Record the first fault; later ones do not overwrite it. */
static void
gm_fault(guest_mem *m, uint32_t addr, int is_write, const char *why)
{
    if (m->fault)
        return;
    m->fault = 1;
    m->fault_addr = addr;
    m->fault_write = is_write;
    m->fault_guard = 0;         /* the guard-page path sets this after us */
    m->fault_why = why;
}

void
gm_set_extern(guest_mem *m, uint8_t *base, uint32_t size)
{
    m->extern_base = base;
    m->extern_size = size;
    gm_map(m, 0, size, GM_R | GM_W | GM_X, "ram");
}

uint8_t *
gm_page(guest_mem *m, uint32_t addr, int want_write)
{
    uint32_t l1 = addr >> 22;
    uint32_t l2 = (addr >> GM_PAGE_SHIFT) & (GM_L2_ENTRIES - 1);
    struct gm_region *r;
    uint8_t *page;

    /* Extern-backed guest: the whole range is one host buffer.  Honour the
     * region protection (guard pages, read-only during loading) but return the
     * arithmetic page pointer rather than a committed one. */
    if (m->extern_base) {
        if (addr >= m->extern_size) {
            gm_fault(m, addr, want_write, "unmapped");
            return NULL;
        }
        r = region_of(m, addr);
        if (!r) {
            gm_fault(m, addr, want_write, "unmapped");
            return NULL;
        }
        if (r->prot == 0) {
            gm_fault(m, addr, want_write, "stack overflow");
            m->fault_guard = 1;
            return NULL;
        }
        if (want_write && !(r->prot & GM_W) && !m->loading) {
            gm_fault(m, addr, 1, "read-only");
            return NULL;
        }
        return m->extern_base + (addr & ~(GM_PAGE_SIZE - 1));
    }

    /* The vDSO: one shared read-only host buffer aliased into this guest.  Reads
     * and fetches return bytes from the shared buffer directly, so no page is
     * committed here and no per-guest copy exists; a write faults read-only.
     * The pages are not in dir/wdir, so gm_free never touches the shared buffer. */
    if (m->vdso_host && addr >= m->vdso_vaddr
        && addr - m->vdso_vaddr < m->vdso_size) {
        if (want_write && !m->loading) {
            gm_fault(m, addr, 1, "read-only");
            return NULL;
        }
        return m->vdso_host + ((addr - m->vdso_vaddr) & ~(GM_PAGE_SIZE - 1));
    }

    /* A committed page satisfies a read outright. A write to a committed page
     * in a writable region is recorded in wdir, so it too returns without the
     * region-protection re-check (the common case for the hot store path). */
    if (want_write) {
        page = m->wdir[l1] ? m->wdir[l1][l2] : NULL;
        if (page)
            return page;
    } else {
        page = m->dir[l1] ? m->dir[l1][l2] : NULL;
        if (page)
            return page;
    }

    r = region_of(m, addr);
    if (!r) {
        gm_fault(m, addr, want_write, "unmapped");
        return NULL;
    }
    if (r->prot == 0) {         /* a guard page: any access is a stack overflow */
        gm_fault(m, addr, want_write, "stack overflow");
        m->fault_guard = 1;
        return NULL;
    }
    if (want_write && !(r->prot & GM_W) && !m->loading) {
        gm_fault(m, addr, 1, "read-only");
        return NULL;
    }

    page = m->dir[l1] ? m->dir[l1][l2] : NULL;
    if (!page) {
        if (m->committed + GM_PAGE_SIZE > m->limit) {
            gm_fault(m, addr, want_write, "memory limit");
            return NULL;
        }
        if (m->pool && m->pool->limit &&
            m->pool->used + GM_PAGE_SIZE > m->pool->limit) {
            gm_fault(m, addr, want_write, "memory pool exhausted");
            return NULL;
        }
        if (!m->dir[l1]) {
            m->dir[l1] = calloc(GM_L2_ENTRIES, sizeof(uint8_t *));
            if (!m->dir[l1]) {
                gm_fault(m, addr, want_write, "out of host memory");
                return NULL;
            }
        }
        page = calloc(1, GM_PAGE_SIZE);
        if (!page) {
            gm_fault(m, addr, want_write, "out of host memory");
            return NULL;
        }
        m->dir[l1][l2] = page;
        m->committed += GM_PAGE_SIZE;
        if (m->pool)
            m->pool->used += GM_PAGE_SIZE;
    }

    /* Warm the write fast path for a page that is writable in steady state.
     * A read commit warms it too, so the first store is already fast. During
     * loading a read-only region is transiently writable; it is deliberately
     * left out of wdir, so once loading ends a store to it faults here. */
    if ((r->prot & GM_W)) {
        if (!m->wdir[l1])
            m->wdir[l1] = calloc(GM_L2_ENTRIES, sizeof(uint8_t *));
        if (m->wdir[l1])
            m->wdir[l1][l2] = page;
    }
    return page;
}

uint8_t
gm_read8(guest_mem *m, uint32_t addr)
{
    uint8_t *p = gm_page(m, addr, 0);

    return p ? p[addr & (GM_PAGE_SIZE - 1)] : 0;
}

void
gm_write8(guest_mem *m, uint32_t addr, uint8_t val)
{
    uint8_t *p = gm_page(m, addr, 1);

    if (p)
        p[addr & (GM_PAGE_SIZE - 1)] = val;
}

uint32_t
gm_load(guest_mem *m, uint32_t addr, int size, int be)
{
    uint32_t off = addr & (GM_PAGE_SIZE - 1);
    uint8_t b[4];
    int i;

    if (off + (uint32_t)size <= GM_PAGE_SIZE) {
        uint8_t *p = gm_page(m, addr, 0);
        if (!p)
            return 0;
        memcpy(b, p + off, (size_t)size);
    } else {
        for (i = 0; i < size; i++)
            b[i] = gm_read8(m, addr + (uint32_t)i);
    }

    switch (size) {
    case 1:
        return b[0];
    case 2:
        return be ? (uint32_t)((b[0] << 8) | b[1])
                  : (uint32_t)(b[0] | (b[1] << 8));
    default:
        return be ? ((uint32_t)b[0] << 24) | ((uint32_t)b[1] << 16) |
                        ((uint32_t)b[2] << 8) | b[3]
                  : (uint32_t)b[0] | ((uint32_t)b[1] << 8) |
                        ((uint32_t)b[2] << 16) | ((uint32_t)b[3] << 24);
    }
}

void
gm_store(guest_mem *m, uint32_t addr, int size, int be, uint32_t val)
{
    uint32_t off = addr & (GM_PAGE_SIZE - 1);
    uint8_t b[4];
    int i;

    switch (size) {
    case 1:
        b[0] = (uint8_t)val;
        break;
    case 2:
        b[0] = be ? (uint8_t)(val >> 8) : (uint8_t)val;
        b[1] = be ? (uint8_t)val : (uint8_t)(val >> 8);
        break;
    default:
        for (i = 0; i < 4; i++)
            b[i] = be ? (uint8_t)(val >> (24 - 8 * i))
                      : (uint8_t)(val >> (8 * i));
        break;
    }

    if (off + (uint32_t)size <= GM_PAGE_SIZE) {
        uint8_t *p = gm_page(m, addr, 1);
        if (p)
            memcpy(p + off, b, (size_t)size);
        return;
    }
    for (i = 0; i < size; i++)
        gm_write8(m, addr + (uint32_t)i, b[i]);
}

void
gm_write(guest_mem *m, uint32_t addr, const void *src, uint32_t len)
{
    const uint8_t *s = src;
    uint32_t i;

    for (i = 0; i < len; i++)
        gm_write8(m, addr + i, s[i]);
}

void
gm_zero(guest_mem *m, uint32_t addr, uint32_t len)
{
    uint32_t i;

    for (i = 0; i < len; i++)
        gm_write8(m, addr + i, 0);
}

void
gm_read_out(guest_mem *m, uint32_t addr, void *dst, uint32_t len)
{
    uint8_t *d = dst;
    uint32_t i;

    for (i = 0; i < len; i++)
        d[i] = gm_read8(m, addr + i);
}

/****************************************************************
 * Syscalls
 *
 * Only the calls a freestanding guest can reach.  Everything else
 * answers -ENOSYS the way Linux would, so an unexpected call shows up as
 * a guest-visible error rather than a silent success.
 ****************************************************************/

#define GUEST_ENOENT    2
#define GUEST_EBADF     9
#define GUEST_ENOMEM    12
#define GUEST_EFAULT    14
#define GUEST_ENOSYS    38
#define GUEST_EINVAL    22

/** Copy a guest buffer into a host one.  Returns 0 on a fault. */
static int
copy_from_guest(guest *g, uint32_t addr, void *dst, uint32_t len)
{
    uint8_t *d = dst;
    uint32_t i;

    for (i = 0; i < len; i++) {
        uint8_t *p = gm_page(&g->mem, addr + i, 0);
        if (!p)
            return 0;
        d[i] = p[(addr + i) & (GM_PAGE_SIZE - 1)];
    }
    return 1;
}

/* ---- the sandbox fd table (see guest.h) --------------------------------
 *
 * A guest fd is an opaque index into g->fdtab; the host fd lives only in the
 * entry, so the guest can never name a host fd it was not granted.  0/1/2 are
 * pre-opened as the console; open/openat allocate a fresh index for the host
 * fd; close frees the index (and closes the real file, but not the console).
 */
#define GUEST_AT_FDCWD (-100)           /* same value on guest and host */

static void
gfd_init(guest *g)
{
    int i;
    if (g->fds_inited)
        return;
    for (i = 0; i < 3; i++) {
        /* Give the sandbox its own dup of the host fds its 0/1/2 bind to
         * (g->stdio, by default skj-run's own stdin/stdout/stderr; a host can
         * point them at a connection's socket instead).  Dup'ing makes them
         * ordinary owned host fds with no special case: closing one in the
         * guest closes only this sandbox's dup, never the shared source.  If the
         * dup fails, fall back to the source fd. */
        int src = g->stdio[i];
        int d = dup(src);
        g->fdtab[i].used = 1;
        g->fdtab[i].dev = GDEV_HOSTFS;
        g->fdtab[i].host_fd = d >= 0 ? d : src;
    }
    g->fds_inited = 1;
}

/* A guest fd -> its host fd, or -1 if the index is not an open entry. */
static int
gfd_host(guest *g, uint32_t gfd)
{
    if (gfd >= GUEST_MAX_FDS || !g->fdtab[gfd].used)
        return -1;
    return g->fdtab[gfd].host_fd;
}

/* A guest fd -> its table entry, or NULL if the index is not open.  getdents64
 * caches a directory stream (hp_dir) on the entry. */
static struct gfd *
gfd_entry(guest *g, uint32_t gfd)
{
    if (gfd >= GUEST_MAX_FDS || !g->fdtab[gfd].used)
        return 0;
    return &g->fdtab[gfd];
}

/* A guest dirfd -> host dirfd via *out.  AT_FDCWD passes straight through (it
 * names no table entry) only for an unconfined guest; once a grant is installed
 * the guest is confined to its capability mounts, so the ambient AT_FDCWD path
 * is refused here -- otherwise a hostile guest could reach any host path with a
 * raw openat(AT_FDCWD, "/abs", ...), bypassing the mounts entirely.  Returns 0,
 * or -1 on a bad index (or a refused ambient open in confined mode). */
static int
gfd_dir(guest *g, uint32_t dirfd, int *out)
{
    if ((int32_t)dirfd == GUEST_AT_FDCWD) {
        if (g->confined)
            return -1;
        *out = GUEST_AT_FDCWD;
        return 0;
    }
    *out = gfd_host(g, dirfd);
    return *out < 0 ? -1 : 0;
}

/* Record an opened host fd, returning the guest index (-1 if the table full). */
static int
gfd_alloc(guest *g, int dev, int host_fd)
{
    int i;
    for (i = 3; i < GUEST_MAX_FDS; i++)
        if (!g->fdtab[i].used) {
            g->fdtab[i].used = 1;
            g->fdtab[i].dev = dev;
            g->fdtab[i].host_fd = host_fd;
            g->fdtab[i].dirp = 0;       /* a directory stream is opened lazily */
            return i;
        }
    return -1;
}

static int32_t
gfd_close(guest *g, uint32_t gfd)
{
    int hf;
    if (gfd >= GUEST_MAX_FDS || !g->fdtab[gfd].used)
        return -GUEST_EBADF;
    if (g->fdtab[gfd].dev == GDEV_PROC) {   /* a proc: open holds a generated buffer
                                             * or a listing cursor, not a host fd */
        procfs_free(g->fdtab[gfd].dirp);
        g->fdtab[gfd].dirp = 0;
        g->fdtab[gfd].used = 0;
        return 0;
    }
    hf = g->fdtab[gfd].host_fd;
    if (g->fdtab[gfd].dirp) {           /* a getdents64 stream owns its own dup fd */
        hp_dirclose((hp_dir *)g->fdtab[gfd].dirp);
        g->fdtab[gfd].dirp = 0;
    }
    g->fdtab[gfd].used = 0;
    close(hf);                          /* each sandbox owns its host fds */
    return 0;
}

void
guest_fds_free(guest *g)
{
    uint32_t i;
    for (i = 0; i < GUEST_MAX_FDS; i++)
        if (g->fdtab[i].used)
            gfd_close(g, i);

    /* Remove this sandbox's own ephemeral scratch directory (each sandbox gets
       its own; see install_scratch).  Shallow cleanup: unlink the flat entries,
       then rmdir. */
    if (g->scratch_dir[0]) {
        DIR *d = opendir(g->scratch_dir);
        if (d) {
            struct dirent *de;
            while ((de = readdir(d))) {
                if (strcmp(de->d_name, ".") == 0 || strcmp(de->d_name, "..") == 0)
                    continue;
                unlinkat(dirfd(d), de->d_name, 0);
            }
            closedir(d);
        }
        rmdir(g->scratch_dir);
        g->scratch_dir[0] = 0;
    }
}

/* Write one 16-byte fs_mount entry at table slot `slot`:
 *   struct fs_mount { char name[8]; int16 fd; int16 cwd; u32 flags }
 * `fd` is the guest mount fd (a capability fd index, or 0 for a backend with no
 * backing fd); `kind` goes in the low byte of flags. */
static void
write_mount_entry(guest *g, uint32_t tbl, int slot, const char *name,
                  int namelen, int fd, uint32_t kind)
{
    uint32_t ent = tbl + (uint32_t)slot * 16u;
    int k;
    for (k = 0; k < FS_NAME_MAX; k++)
        gm_store(&g->mem, ent + (uint32_t)k, 1, 0,
                 (uint32_t)(k < namelen ? (unsigned char)name[k] : 0));
    gm_store(&g->mem, ent + 8, 2, g->big_endian, (uint32_t)(uint16_t)fd);
    gm_store(&g->mem, ent + 10, 2, g->big_endian, 0xffffu);    /* cwd = root */
    gm_store(&g->mem, ent + 12, 4, g->big_endian, kind);
}

/* Load a host romfs image file into a fresh guest memory region (the "host-
 * shared buffer" use gm_mmap exists for).  On success writes the region base
 * and byte length; returns -1 on any error. */
static int
load_rom_image(guest *g, const char *path, uint32_t *base_out, uint32_t *len_out)
{
    FILE *f = fopen(path, "rb");
    long sz;
    uint32_t base;
    uint8_t *buf;
    size_t got;

    if (!f) {
        fprintf(stderr, "skj-run: cannot open rom image '%s': %s\n", path,
                strerror(errno));
        return -1;
    }
    if (fseek(f, 0, SEEK_END) != 0 || (sz = ftell(f)) < 0) {
        fclose(f);
        return -1;
    }
    rewind(f);
    if (sz == 0 || sz > 0x40000000L) {  /* refuse empty or absurd sizes */
        fprintf(stderr, "skj-run: rom image '%s' has a bad size\n", path);
        fclose(f);
        return -1;
    }
    buf = malloc((size_t)sz);
    if (!buf) { fclose(f); return -1; }
    got = fread(buf, 1, (size_t)sz, f);
    fclose(f);
    if (got != (size_t)sz) { free(buf); return -1; }
    base = gm_mmap(&g->mem, (uint32_t)sz, 0);
    if (!base) {
        fprintf(stderr, "skj-run: no guest memory for rom image '%s'\n", path);
        free(buf);
        return -1;
    }
    gm_write(&g->mem, base, buf, (uint32_t)sz);
    free(buf);
    if (g->mem.fault)
        return -1;
    *base_out = base;
    *len_out = (uint32_t)sz;
    return 0;
}

/* The launcher: turn each grant into a guest fs_mount entry.  A --mount opens a
 * confined host directory as a hostfs capability fd; a --dev grants a devfs
 * mount with no backing fd; a --rom loads a read-only image into guest memory;
 * a --9p serves a host directory over a shared doorbell channel.  The guest
 * never mounts; it reads this pre-populated table (and fs_mount_aux for the
 * extra romfs/9pfs parameters).  A guest that links no fs_mounts symbol just
 * runs with no mounts (a warning if a grant was nonetheless given). */
/* Append one installed grant to a recorder, if one was given and has room. */
static void
grant_record(struct guest_grant *rec, int *nrec, const char *name, int namelen,
             uint32_t kind, int host_fd)
{
    struct guest_grant *g;
    int k;

    if (!rec || !nrec || *nrec >= FS_MAX_MOUNTS)
        return;
    g = &rec[*nrec];
    for (k = 0; k < FS_NAME_MAX; k++)
        g->name[k] = (char)(k < namelen ? name[k] : 0);
    g->namelen = namelen;
    g->kind = kind;
    g->host_fd = host_fd;
    (*nrec)++;
}

/* Install an ephemeral host scratch directory as a confined mount at table slot
 * `slot`, recording its path on the guest so guest_fds_free removes it.  Returns
 * the next free slot: slot+1 on success, slot unchanged on failure or a full
 * table.  Per-sandbox by design: the root and every spawned child each get their
 * own fresh directory (a child does not inherit the parent's), so a bare path
 * lands on an isolated scratch per process, matching the in-guest ramfs it
 * replaces.  It is deliberately not recorded as an inheritable grant. */
static int
install_scratch(guest *g, uint32_t tbl, int slot)
{
    const char *tmp = getenv("TMPDIR");
    char tmpl[64];
    int hostfd, idx;

    if (slot >= FS_MAX_MOUNTS)
        return slot;
    snprintf(tmpl, sizeof tmpl, "%s/skjrun-scratch-XXXXXX",
             tmp && *tmp ? tmp : "/tmp");
    if (!mkdtemp(tmpl))
        return slot;
    hostfd = open(tmpl, O_RDONLY | O_DIRECTORY);
    idx = hostfd >= 0 ? gfd_alloc(g, GDEV_HOSTFS, hostfd) : -1;
    if (idx < 0) {
        if (hostfd >= 0)
            close(hostfd);
        rmdir(tmpl);
        return slot;
    }
    write_mount_entry(g, tbl, slot, "scratch", 7, idx, (uint32_t)FS_KIND_HOST);
    snprintf(g->scratch_dir, sizeof g->scratch_dir, "%s", tmpl);
    return slot + 1;
}

/* Install the always-on read-only proc: mount at table slot `slot`.  Its root
 * is a GDEV_PROC capability fd; the hostcap backend drives it and the kernel
 * services the ops from the scheduler's process table (emu/procfs.c).  Returns
 * the next free slot. */
static int
install_proc(guest *g, uint32_t tbl, int slot)
{
    int idx;

    if (slot >= FS_MAX_MOUNTS)
        return slot;
    idx = gfd_alloc(g, GDEV_PROC, -1);
    if (idx < 0)
        return slot;
    write_mount_entry(g, tbl, slot, "proc", 4, idx,
                      (uint32_t)FS_KIND_HOST | FS_RO);
    return slot + 1;
}

void
guest_install_mounts(guest *g, const char *elf_path, const run_opts *o,
                     struct guest_grant *rec, int *nrec)
{
    uint32_t tbl, cnt_sym, cur_sym, aux_sym;
    int i, installed = 0;
    int ngrants = o->nmounts + o->nmounts_ro + o->ndevs + o->nroms + o->np9s;

    if (nrec)
        *nrec = 0;

    /* Resolve the launcher symbols with the resolver matching the root ELF's
     * class, so an LP64 root (x86-64, arm64) is handled as well as an ILP32 one
     * (rv, cf, mips).  Done before the zero-grant check because the always-on
     * proc: mount is installed even when no --mount grant was given. */
    {
        uint32_t (*symf)(const char *, const char *) = elf32_symbol;
        FILE *cf = fopen(elf_path, "rb");

        if (cf) {
            unsigned char id[5];
            if (fread(id, 1, 5, cf) == 5 && id[4] == 2 /* ELFCLASS64 */)
                symf = elf64_symbol;
            fclose(cf);
        }
        tbl = symf(elf_path, "fs_mounts");
        cnt_sym = symf(elf_path, "fs_mount_count");
        cur_sym = symf(elf_path, "fs_cur_mount");
        aux_sym = symf(elf_path, "fs_mount_aux");
    }
    if (!tbl || !cnt_sym) {             /* the guest links no fs/ table at all */
        if (ngrants)
            fprintf(stderr, "skj-run: a mount was given but %s links no fs_mounts "
                    "table; ignoring %d grant(s)\n", elf_path, ngrants);
        return;
    }

    gfd_init(g);                        /* reserve 0/1/2 before any grant fd */
    if (ngrants)
        g->confined = 1;                /* real host grants: the capability mounts
                                           are the only host access; refuse ambient.
                                           proc: alone does not confine (it grants
                                           no host-fs access). */

    for (i = 0; i < o->nmounts && installed < FS_MAX_MOUNTS; i++) {
        const char *spec = o->mounts[i];
        const char *colon = strchr(spec, ':');
        const char *dir;
        int hostfd, idx, nl;

        if (!colon) {
            fprintf(stderr, "skj-run: bad --mount '%s' (want name:hostdir)\n",
                    spec);
            continue;
        }
        nl = (int)(colon - spec);
        if (nl <= 0 || nl > FS_NAME_MAX) {
            fprintf(stderr, "skj-run: mount name in '%s' must be 1..%d bytes\n",
                    spec, FS_NAME_MAX);
            continue;
        }
        dir = colon + 1;
        hostfd = open(dir, O_RDONLY | O_DIRECTORY);
        if (hostfd < 0) {
            fprintf(stderr, "skj-run: cannot mount '%s': %s\n", dir,
                    strerror(errno));
            continue;
        }
        idx = gfd_alloc(g, GDEV_HOSTFS, hostfd);
        if (idx < 0) {
            fprintf(stderr, "skj-run: fd table full mounting '%s'\n", dir);
            close(hostfd);
            continue;
        }
        write_mount_entry(g, tbl, installed, spec, nl, idx, (uint32_t)FS_KIND_HOST);
        grant_record(rec, nrec, spec, nl, (uint32_t)FS_KIND_HOST, hostfd);
        installed++;
    }

    /* Read-only host mounts (--mount-ro): same as above with FS_RO set, so the
       backend rejects every mutating op.  A read-only /bin served from a host
       directory lands here; one host copy serves every sandbox. */
    for (i = 0; i < o->nmounts_ro && installed < FS_MAX_MOUNTS; i++) {
        const char *spec = o->mounts_ro[i];
        const char *colon = strchr(spec, ':');
        const char *dir;
        int hostfd, idx, nl;

        if (!colon) {
            fprintf(stderr, "skj-run: bad --mount-ro '%s' (want name:hostdir)\n",
                    spec);
            continue;
        }
        nl = (int)(colon - spec);
        if (nl <= 0 || nl > FS_NAME_MAX) {
            fprintf(stderr, "skj-run: mount name in '%s' must be 1..%d bytes\n",
                    spec, FS_NAME_MAX);
            continue;
        }
        dir = colon + 1;
        hostfd = open(dir, O_RDONLY | O_DIRECTORY);
        if (hostfd < 0) {
            fprintf(stderr, "skj-run: cannot mount '%s': %s\n", dir,
                    strerror(errno));
            continue;
        }
        idx = gfd_alloc(g, GDEV_HOSTFS, hostfd);
        if (idx < 0) {
            fprintf(stderr, "skj-run: fd table full mounting '%s'\n", dir);
            close(hostfd);
            continue;
        }
        write_mount_entry(g, tbl, installed, spec, nl, idx,
                          (uint32_t)FS_KIND_HOST | FS_RO);
        grant_record(rec, nrec, spec, nl, (uint32_t)FS_KIND_HOST | FS_RO, hostfd);
        installed++;
    }

    for (i = 0; i < o->ndevs && installed < FS_MAX_MOUNTS; i++) {
        const char *name = o->devs[i];
        int nl = (int)strlen(name);
        if (nl <= 0 || nl > FS_NAME_MAX) {
            fprintf(stderr, "skj-run: --dev name '%s' must be 1..%d bytes\n",
                    name, FS_NAME_MAX);
            continue;
        }
        write_mount_entry(g, tbl, installed, name, nl, 0, (uint32_t)FS_KIND_DEV);
        grant_record(rec, nrec, name, nl, (uint32_t)FS_KIND_DEV, -1);
        installed++;
    }

    for (i = 0; i < o->nroms && installed < FS_MAX_MOUNTS; i++) {
        const char *spec = o->roms[i];
        const char *colon = strchr(spec, ':');
        uint32_t base, len;
        int nl;

        if (!colon) {
            fprintf(stderr, "skj-run: bad --rom '%s' (want name:image)\n", spec);
            continue;
        }
        nl = (int)(colon - spec);
        if (nl <= 0 || nl > FS_NAME_MAX) {
            fprintf(stderr, "skj-run: rom name in '%s' must be 1..%d bytes\n",
                    spec, FS_NAME_MAX);
            continue;
        }
        if (!aux_sym) {
            fprintf(stderr, "skj-run: --rom given but %s links no fs_mount_aux; "
                    "ignoring '%s'\n", elf_path, spec);
            continue;
        }
        if (load_rom_image(g, colon + 1, &base, &len) != 0)
            continue;
        write_mount_entry(g, tbl, installed, spec, nl, 0, (uint32_t)FS_KIND_ROM);
        gm_store(&g->mem, aux_sym + (uint32_t)installed * 8u, 4,
                 g->big_endian, base);
        gm_store(&g->mem, aux_sym + (uint32_t)installed * 8u + 4u, 4,
                 g->big_endian, len);
        grant_record(rec, nrec, spec, nl, (uint32_t)FS_KIND_ROM, -1);
        installed++;
    }

    for (i = 0; i < o->np9s && installed < FS_MAX_MOUNTS; i++) {
        const char *spec = o->p9s[i];
        const char *colon = strchr(spec, ':');
        const char *dir;
        struct p9_server *srv;
        uint32_t chan, chansz = 8u + 2u * (uint32_t)P9_MSIZE;
        int hostfd, nl;

        if (!colon) {
            fprintf(stderr, "skj-run: bad --9p '%s' (want name:hostdir)\n", spec);
            continue;
        }
        nl = (int)(colon - spec);
        if (nl <= 0 || nl > FS_NAME_MAX) {
            fprintf(stderr, "skj-run: 9p name in '%s' must be 1..%d bytes\n",
                    spec, FS_NAME_MAX);
            continue;
        }
        if (!aux_sym) {
            fprintf(stderr, "skj-run: --9p given but %s links no fs_mount_aux; "
                    "ignoring '%s'\n", elf_path, spec);
            continue;
        }
        if (g->np9 >= GUEST_MAX_P9) {
            fprintf(stderr, "skj-run: too many 9p channels for '%s'\n", spec);
            continue;
        }
        dir = colon + 1;
        hostfd = open(dir, O_RDONLY | O_DIRECTORY);  /* a clear error if missing */
        if (hostfd < 0) {
            fprintf(stderr, "skj-run: cannot serve 9p '%s': %s\n", dir,
                    strerror(errno));
            continue;
        }
        close(hostfd);
        srv = p9_server_create(dir);
        if (!srv) {
            fprintf(stderr, "skj-run: no memory for 9p server '%s'\n", dir);
            continue;
        }
        chan = gm_mmap(&g->mem, chansz, 0);
        if (!chan) {
            fprintf(stderr, "skj-run: no guest memory for 9p channel '%s'\n", dir);
            p9_server_destroy(srv);
            continue;
        }
        gm_zero(&g->mem, chan, chansz);              /* req_len/rsp_len start 0 */
        write_mount_entry(g, tbl, installed, spec, nl, 0, (uint32_t)FS_KIND_9P);
        grant_record(rec, nrec, spec, nl, (uint32_t)FS_KIND_9P, -1);
        gm_store(&g->mem, aux_sym + (uint32_t)installed * 8u, 4,
                 g->big_endian, chan);
        gm_store(&g->mem, aux_sym + (uint32_t)installed * 8u + 4u, 4,
                 g->big_endian, 0);
        g->p9[g->np9].chan = chan;
        g->p9[g->np9].srv = srv;
        g->np9++;
        installed++;
    }

    /* Give this sandbox its own scratch, unless the caller named a "scratch"
       mount of its own.  Per-sandbox and never inherited (see install_scratch),
       so a bare path lands on an isolated directory per process.  Only when real
       grants were given: a guest launched with none keeps its own default
       landing (its in-guest ramfs, or the FS_AMBIENT_DEFAULT ambient host),
       which fs_init still reaches since no host "scratch" is in the table. */
    if (ngrants) {
        int have_scratch = 0, j;
        for (j = 0; j < o->nmounts; j++)
            if (strncmp(o->mounts[j], "scratch:", 8) == 0)
                have_scratch = 1;
        for (j = 0; j < o->nmounts_ro; j++)
            if (strncmp(o->mounts_ro[j], "scratch:", 8) == 0)
                have_scratch = 1;
        for (j = 0; j < o->ndevs; j++)
            if (strcmp(o->devs[j], "scratch") == 0)
                have_scratch = 1;
        for (j = 0; j < o->nroms; j++)
            if (strncmp(o->roms[j], "scratch:", 8) == 0)
                have_scratch = 1;
        if (!have_scratch)
            installed = install_scratch(g, tbl, installed);
    }

    /* The always-on read-only proc: mount.  With real grants the host owns the
       whole table from slot 0, so proc: is appended after scratch and the grants
       and the default mount is reset to slot 0.  With no grants the guest keeps
       its own built-in table and default landing (its in-guest ramfs, the
       FS_WITH_HOSTFS raw path backend, or the FS_AMBIENT_DEFAULT ambient host):
       proc: is appended after whatever the guest already declares and the
       built-in fs_cur_mount is left untouched, so a bare path still resolves the
       way it did before proc: existed. */
    if (!ngrants) {
        uint32_t base = gm_load(&g->mem, cnt_sym, 4, g->big_endian);
        installed = (base <= FS_MAX_MOUNTS) ? (int)base : FS_MAX_MOUNTS;
    }

    installed = install_proc(g, tbl, installed);

    gm_store(&g->mem, cnt_sym, 4, g->big_endian, (uint32_t)installed);
    if (cur_sym && ngrants)
        gm_store(&g->mem, cur_sym, 4, g->big_endian, 0);   /* default mount 0 */
    if (g->mem.fault)
        fprintf(stderr, "skj-run: fault writing the mount table into %s\n",
                elf_path);
}

/* Resolve a guest symbol's address from an in-memory child image, dispatching
 * on the ELF class so an ILP32 child (rv/cf/mips) and an LP64 child (x86-64,
 * arm64) are both handled.  The value fits 32 bits either way: every guest
 * lives in the 32-bit guest-memory space. */
static uint32_t
sym_mem(const uint8_t *img, long imglen, const char *name)
{
    if (imglen > 4 && img[4] == 2 /* ELFCLASS64 */)
        return elf64_symbol_mem(img, imglen, name);
    return elf32_symbol_mem(img, imglen, name);
}

void
guest_install_grants_mem(guest *g, const uint8_t *img, long imglen,
                         const struct guest_grant *in, int nin,
                         struct guest_grant *rec, int *nrec)
{
    uint32_t tbl, cnt_sym, cur_sym;
    int i, installed = 0;

    if (nrec)
        *nrec = 0;
    if (nin <= 0)
        return;

    tbl = sym_mem(img, imglen, "fs_mounts");
    cnt_sym = sym_mem(img, imglen, "fs_mount_count");
    cur_sym = sym_mem(img, imglen, "fs_cur_mount");
    if (!tbl || !cnt_sym)
        return;                         /* the child links no fs/ table */

    g->confined = 1;                    /* inherited grants: confine like the parent */
    gfd_init(g);                        /* reserve 0/1/2 before any grant fd */

    for (i = 0; i < nin && installed < FS_MAX_MOUNTS; i++) {
        const struct guest_grant *gr = &in[i];
        switch (gr->kind & FS_KIND_MASK) {
        case FS_KIND_HOST: {
            int newfd, idx;
            if (gr->host_fd < 0)
                continue;
            newfd = dup(gr->host_fd);   /* the child owns an independent fd */
            if (newfd < 0)
                continue;
            idx = gfd_alloc(g, GDEV_HOSTFS, newfd);
            if (idx < 0) {
                close(newfd);
                continue;
            }
            write_mount_entry(g, tbl, installed, gr->name, gr->namelen, idx,
                              gr->kind);           /* preserve FS_RO and friends */
            grant_record(rec, nrec, gr->name, gr->namelen, gr->kind, newfd);
            installed++;
            break;
        }
        case FS_KIND_DEV:
            write_mount_entry(g, tbl, installed, gr->name, gr->namelen, 0,
                              (uint32_t)FS_KIND_DEV);
            grant_record(rec, nrec, gr->name, gr->namelen,
                         (uint32_t)FS_KIND_DEV, -1);
            installed++;
            break;
        default:
            /* FS_KIND_ROM / FS_KIND_9P are not inheritable in this version. */
            break;
        }
    }

    /* The child gets its own fresh scratch, never a share of the parent's. */
    installed = install_scratch(g, tbl, installed);

    installed = install_proc(g, tbl, installed);    /* the child sees proc: too */

    gm_store(&g->mem, cnt_sym, 4, g->big_endian, (uint32_t)installed);
    if (cur_sym)
        gm_store(&g->mem, cur_sym, 4, g->big_endian, 0);
    if (g->mem.fault)
        fprintf(stderr, "skj-run: fault writing an inherited mount table\n");
}

int
guest_make_pipe(guest *g, uint32_t out_addr)
{
    int hp[2], idx_r, idx_w;

    gfd_init(g);                        /* reserve 0/1/2 before any pipe fd */
    if (pipe(hp) != 0)
        return -1;
    idx_r = gfd_alloc(g, GDEV_HOSTFS, hp[0]);
    if (idx_r < 0) {
        close(hp[0]);
        close(hp[1]);
        return -1;
    }
    idx_w = gfd_alloc(g, GDEV_HOSTFS, hp[1]);
    if (idx_w < 0) {
        gfd_close(g, (uint32_t)idx_r);  /* frees idx_r and closes hp[0] */
        close(hp[1]);
        return -1;
    }
    gm_store(&g->mem, out_addr, 4, g->big_endian, (uint32_t)idx_r);
    gm_store(&g->mem, out_addr + 4u, 4, g->big_endian, (uint32_t)idx_w);
    if (g->mem.fault) {
        g->mem.fault = 0;
        gfd_close(g, (uint32_t)idx_r);
        gfd_close(g, (uint32_t)idx_w);
        return -1;
    }
    return 0;
}

void
guest_install_fdmap_mem(guest *child, const uint8_t *img, long imglen,
                        guest *parent, const struct guest_fdpass *in, int nin)
{
    uint32_t tbl, cnt_sym;
    int i, installed = 0;

    if (nin <= 0)
        return;

    tbl = sym_mem(img, imglen, "fs_inherit_fds");
    cnt_sym = sym_mem(img, imglen, "fs_inherit_n");
    if (!tbl || !cnt_sym)
        return;                         /* the child links no inherit table */

    gfd_init(child);                    /* reserve 0/1/2 before any passed fd */

    for (i = 0; i < nin && installed < GUEST_MAX_FDS; i++) {
        int src = in[i].gfd, newfd, nidx;
        uint32_t ent;
        if (src < 0 || src >= GUEST_MAX_FDS || !parent->fdtab[src].used)
            continue;
        newfd = dup(parent->fdtab[src].host_fd);  /* the child's own fd */
        if (newfd < 0)
            continue;
        nidx = gfd_alloc(child, GDEV_HOSTFS, newfd);
        if (nidx < 0) {
            close(newfd);
            continue;
        }
        /* struct fs_inherit_fd is two ints {dst, gfd}, a fixed 8-byte layout on
         * every guest, so it marshals without the private fd_slot layout. */
        ent = tbl + (uint32_t)installed * 8u;
        gm_store(&child->mem, ent,      4, child->big_endian, (uint32_t)in[i].dst);
        gm_store(&child->mem, ent + 4u, 4, child->big_endian, (uint32_t)nidx);
        installed++;
    }

    gm_store(&child->mem, cnt_sym, 4, child->big_endian, (uint32_t)installed);
    if (child->mem.fault)
        fprintf(stderr, "skj-run: fault writing an inherited fd table\n");
}

int
guest_p9_doorbell(guest *g, uint32_t chan)
{
    struct p9_server *srv = 0;
    uint8_t req[P9_MSIZE], rsp[P9_MSIZE];
    uint32_t reqlen, rsplen;
    int i, n;

    for (i = 0; i < g->np9; i++)
        if (g->p9[i].chan == chan) {
            srv = (struct p9_server *)g->p9[i].srv;
            break;
        }
    if (!srv)
        return -1;                      /* no channel bound here */

    reqlen = gm_load(&g->mem, chan + 0, 4, g->big_endian);
    if (reqlen > P9_MSIZE)
        reqlen = P9_MSIZE;
    gm_read_out(&g->mem, chan + 8u, req, reqlen);
    /* The request buffer may hold several framed T-messages (the client batches
     * a walk+open or walk+stat+clunk into one ring); the stream handler runs
     * each in order and concatenates the framed replies.  One message is a
     * stream of one, so the common case is unchanged. */
    n = p9_server_handle_stream(srv, req, reqlen, rsp, sizeof rsp);
    rsplen = n < 0 ? 0 : (uint32_t)n;
    gm_write(&g->mem, chan + 8u + (uint32_t)P9_MSIZE, rsp, rsplen);
    gm_store(&g->mem, chan + 4u, 4, g->big_endian, rsplen);
    return 0;
}

void
guest_p9_free(guest *g)
{
    int i;
    for (i = 0; i < g->np9; i++) {
        p9_server_destroy((struct p9_server *)g->p9[i].srv);
        g->p9[i].srv = 0;
    }
    g->np9 = 0;
}

/* True when a write on host fd hf would block right now: the fd reports no room
 * and no end-of-file/error condition.  A regular file always polls writable, so
 * this only ever holds for a full pipe, socket, or terminal.  A closed read end
 * polls POLLHUP/POLLERR, which counts as not-blocked so the write proceeds and
 * returns the error as it would for a lone guest. */
static int
write_would_block(int hf)
{
    struct pollfd pfd;
    int r;

    pfd.fd = hf;
    pfd.events = POLLOUT;
    pfd.revents = 0;
    do {
        r = poll(&pfd, 1, 0);
    } while (r < 0 && errno == EINTR);
    if (r <= 0)                                 /* 0 = no room; <0 = give up, write */
        return r == 0;
    return (pfd.revents & (POLLOUT | POLLHUP | POLLERR | POLLNVAL)) == 0;
}

static int32_t
sys_write(guest *g, uint32_t fd, uint32_t buf, uint32_t len)
{
    uint8_t tmp[4096];
    uint32_t done = g->wr_parked_done;  /* resume point after a POLLOUT park */
    int hf = gfd_host(g, fd);

    g->wr_parked_done = 0;              /* consume it; set again only if we park */
    if (hf < 0)
        return -GUEST_EBADF;
    while (done < len) {
        uint32_t chunk = len - done;
        ssize_t n;
        if (chunk > sizeof(tmp))
            chunk = sizeof(tmp);
        if (!copy_from_guest(g, buf + done, tmp, chunk))
            return -GUEST_EFAULT;
        /* --quiet suppresses only the console streams, not a real file. */
        if (g->quiet && (fd == 1 || fd == 2)) {
            done += chunk;
            continue;
        }
        /* A write to a full pipe must not stall the one shared host thread, or
         * the sibling that has to drain the pipe can never run.  A parking core
         * yields and re-runs the syscall when the pipe has room; it remembers
         * the bytes already written (wr_parked_done) so the re-run resumes from
         * there and the guest still sees one full write, never a short count.
         * A core run alone (can_park = 0) does the blocking write below. */
        if (write_would_block(hf) && g->can_park) {
            g->wr_parked_done = done;
            g->park = GPARK_RETRY;
            g->park_fd = hf;
            g->park_events = POLLOUT;
            return 0;                   /* result not committed: the ecall re-runs */
        }
        n = write(hf, tmp, chunk);
        if (n <= 0)
            return done ? (int32_t)done : -GUEST_EBADF;
        done += (uint32_t)n;
    }
    return (int32_t)done;
}

/* A monotonic clock in nanoseconds, from the host-abstracted hp_clock.  Used for
 * the cooperative park deadlines (nanosleep) the scheduler waits out. */
static uint64_t
mono_ns(void)
{
    uint32_t sec = 0, nsec = 0;

    hp_clock(0, &sec, &nsec);                   /* 0 = monotonic */
    return (uint64_t)sec * 1000000000ull + nsec;
}

/* True when a read on host fd hf would block right now: the fd reports neither
 * readable data nor an end-of-file/error condition.  A regular file always polls
 * ready, so this only ever holds for a pipe, socket, or terminal with no pending
 * input. */
static int
read_would_block(int hf)
{
    struct pollfd pfd;
    int r;

    pfd.fd = hf;
    pfd.events = POLLIN;
    pfd.revents = 0;
    do {
        r = poll(&pfd, 1, 0);
    } while (r < 0 && errno == EINTR);
    if (r <= 0)                                 /* 0 = not ready; <0 = give up, read */
        return r == 0;
    return (pfd.revents & (POLLIN | POLLHUP | POLLERR | POLLNVAL)) == 0;
}

static int32_t
sys_read(guest *g, uint32_t fd, uint32_t buf, uint32_t len)
{
    uint8_t tmp[4096];
    ssize_t n;
    int hf;
    struct gfd *pent = gfd_entry(g, fd);

    if (pent && pent->dev == GDEV_PROC) {   /* served from the generated buffer */
        int r;
        if (len > sizeof(tmp))
            len = sizeof(tmp);
        r = procfs_read(pent->dirp, tmp, (int)len);
        if (r < 0)
            return -GUEST_EBADF;
        gm_write(&g->mem, buf, tmp, (uint32_t)r);
        if (g->mem.fault)
            return -GUEST_EFAULT;
        return r;
    }
    hf = gfd_host(g, fd);
    if (hf < 0)
        return -GUEST_EBADF;
    /* A read that would block must not stall the one host thread every guest in
     * the scheduler shares, or a sibling that still has to produce the bytes (or
     * close the pipe) can never run.  A parking core yields the slice and re-runs
     * the syscall when the fd is ready (the scheduler waits on park_fd); the read
     * has done nothing yet, so the re-run is a clean retry.  A core that is run
     * alone with no scheduler to yield to (the gdb stub sets can_park = 0) falls
     * through to a real blocking read, as a lone process would. */
    if (len > 0 && read_would_block(hf) && g->can_park) {
        g->park = GPARK_RETRY;
        g->park_fd = hf;
        g->park_events = POLLIN;
        return 0;
    }
    if (len > sizeof(tmp))
        len = sizeof(tmp);
    n = read(hf, tmp, len);
    if (n < 0)
        return -GUEST_EBADF;
    gm_write(&g->mem, buf, tmp, (uint32_t)n);
    if (g->mem.fault)
        return -GUEST_EFAULT;
    return (int32_t)n;
}

/* Host file access for the guest.  skj-run is a user-mode development
 * emulator, like qemu-user, so a guest may open real files with the invoking
 * user's own permissions; this is what lets a guest compiler such as kpcom
 * read its source and write its output.  The open flags and mode are the
 * asm-generic Linux values both the m68k and rv guests use, which match the
 * host's, so they pass through unchanged.  An opened descriptor is the host
 * fd, used directly by sys_read / sys_write / close. */
/* Copy a NUL-terminated guest path string into `out` (at most cap bytes).
 * Returns 0 on success, -GUEST_EFAULT on an unmapped byte, -GUEST_ENOENT if it
 * does not terminate within the buffer. */
static int32_t
copy_path(guest *g, uint32_t pathp, char *out, size_t cap)
{
    size_t i;

    for (i = 0; i < cap - 1; i++) {
        uint8_t *p = gm_page(&g->mem, pathp + (uint32_t)i, 0);
        if (!p)
            return -GUEST_EFAULT;
        out[i] = (char)p[(pathp + (uint32_t)i) & (GM_PAGE_SIZE - 1)];
        if (out[i] == '\0')
            return 0;
    }
    return -GUEST_ENOENT;
}

static int32_t
sys_open(guest *g, uint32_t pathp, uint32_t flags, uint32_t mode)
{
    char path[1024];
    int32_t e;
    int fd;

    if ((e = copy_path(g, pathp, path, sizeof(path))) != 0)
        return e;
    fd = open(path, (int)flags, mode);
    if (fd < 0)
        return -GUEST_ENOENT;
    e = gfd_alloc(g, GDEV_HOSTFS, fd);
    if (e < 0) {
        close(fd);
        return -GUEST_EBADF;            /* table full */
    }
    return e;
}

/* openat(dirfd, path, flags, mode): the form rv32 (and any asm-generic Linux
 * target) uses, since it has no bare open.  A capability dirfd resolves through
 * hp_open_beneath, confined to the granted tree; AT_FDCWD (-100, the same value
 * on the guest) stays the unconfined ambient path.  The flags and mode are the
 * asm-generic Linux values, which match the host's. */
static int32_t
sys_openat(guest *g, uint32_t dirfd, uint32_t pathp, uint32_t flags,
           uint32_t mode)
{
    char path[1024];
    int32_t e;
    int fd, hd;
    struct gfd *pent;

    if ((e = copy_path(g, pathp, path, sizeof(path))) != 0)
        return e;
    pent = gfd_entry(g, dirfd);
    if (pent && pent->dev == GDEV_PROC) {   /* a proc: capability: serve host-side */
        int err;
        void *h = procfs_open(g->sched, g->slot, path, &err);
        if (!h)
            return err == -ENOENT ? -GUEST_ENOENT : -GUEST_EBADF;
        e = gfd_alloc(g, GDEV_PROC, -1);
        if (e < 0) {
            procfs_free(h);
            return -GUEST_EBADF;
        }
        g->fdtab[e].dirp = h;               /* the open state hangs off the entry */
        return e;
    }
    if (gfd_dir(g, dirfd, &hd) < 0)
        return -GUEST_EBADF;
    fd = (hd == GUEST_AT_FDCWD)         /* ambient: unconfined, as before */
             ? openat(hd, path, (int)flags, (mode_t)mode)
             : hp_open_beneath(hd, path, (int)flags, (int)mode);  /* confined */
    if (fd < 0)
        return -GUEST_ENOENT;
    e = gfd_alloc(g, GDEV_HOSTFS, fd);
    if (e < 0) {
        close(fd);
        return -GUEST_EBADF;
    }
    return e;
}

/* lseek(fd, offset, whence): a 32-bit offset for the ILP32 guests, sign
 * extended to the host off_t.  Returns the new offset, or -errno.  This is the
 * simple form m68k uses; rv32/asm-generic use llseek below. */
static int32_t
sys_lseek(guest *g, uint32_t fd, uint32_t offset, uint32_t whence)
{
    off_t r;
    int hf;
    struct gfd *pent = gfd_entry(g, fd);

    if (pent && pent->dev == GDEV_PROC) {
        int64_t pr = procfs_lseek(pent->dirp, (int64_t)(int32_t)offset, (int)whence);
        return pr < 0 ? -GUEST_EBADF : (int32_t)pr;
    }
    hf = gfd_host(g, fd);
    if (hf < 0)
        return -GUEST_EBADF;
    r = lseek(hf, (off_t)(int32_t)offset, (int)whence);
    if (r < 0)
        return -GUEST_EBADF;
    return (int32_t)r;
}

/* _llseek(fd, off_hi, off_lo, loff_t *result, whence): the asm-generic (rv32)
 * form.  The 64-bit offset is split across two words; the new position is
 * written back through the guest pointer as a little-endian loff_t.  Returns 0
 * on success, -errno on failure. */
static int32_t
sys_llseek(guest *g, uint32_t fd, uint32_t off_hi, uint32_t off_lo,
           uint32_t resultp, uint32_t whence)
{
    int64_t off = (int64_t)(((uint64_t)off_hi << 32) | off_lo);
    int hf;
    off_t r;
    struct gfd *pent = gfd_entry(g, fd);

    if (pent && pent->dev == GDEV_PROC) {
        int64_t pr = procfs_lseek(pent->dirp, off, (int)whence);
        if (pr < 0)
            return -GUEST_EBADF;
        gm_store(&g->mem, resultp, 4, 0, (uint32_t)(uint64_t)pr);
        gm_store(&g->mem, resultp + 4, 4, 0, (uint32_t)((uint64_t)pr >> 32));
        return g->mem.fault ? -GUEST_EFAULT : 0;
    }
    hf = gfd_host(g, fd);
    if (hf < 0)
        return -GUEST_EBADF;
    r = lseek(hf, (off_t)off, (int)whence);
    if (r < 0)
        return -GUEST_EBADF;
    /* write the 8-byte loff_t result, little-endian, to the guest */
    gm_store(&g->mem, resultp, 4, 0, (uint32_t)(uint64_t)r);
    gm_store(&g->mem, resultp + 4, 4, 0, (uint32_t)((uint64_t)r >> 32));
    if (g->mem.fault)
        return -GUEST_EFAULT;
    return 0;
}

/* statx(dirfd, path, flags, mask, buf): the stat form the "new" Linux targets
 * (rv32) use, since they have no stat/fstat syscall.  The guest libc translates
 * the filled record into POSIX struct stat (libc/stat.c).  AT_EMPTY_PATH (the
 * 0x1000 flag bit, value matched numerically so the host needs no _GNU_SOURCE)
 * means "stat the fd in dirfd", the fstat case; otherwise it is a path stat
 * relative to dirfd (AT_FDCWD for an absolute or cwd-relative path).  The host
 * fd is the guest fd, as for read/write.  Only the STATX_BASIC_STATS fields the
 * guest reads are filled, at their fixed struct-statx offsets, in the guest's
 * byte order: the 32-bit fields with gm_store's be flag, the 16-bit stx_mode as
 * a halfword so it does not land in __spare0 on a big-endian guest, and the
 * 64-bit fields through store64 (low word placed by endianness). */
static void store64(guest *g, uint32_t addr, uint64_t v);

static int32_t
sys_statx(guest *g, uint32_t dirfd, uint32_t pathp, uint32_t flags,
          uint32_t mask, uint32_t bufp)
{
    int be = g->big_endian;
    char path[1024];
    struct stat hs;
    int r;
    uint32_t i;

    (void)mask;
    if (flags & 0x1000u) {                      /* AT_EMPTY_PATH: fstat the fd */
        struct gfd *pent = gfd_entry(g, dirfd);
        int hf;
        if (pent && pent->dev == GDEV_PROC) {
            struct fs_stat ps;
            procfs_fstat(pent->dirp, &ps);
            memset(&hs, 0, sizeof hs);
            hs.st_mode = ps.mode;
            hs.st_size = ps.size;
            hs.st_nlink = ps.nlink;
            hs.st_ino = ps.ino;
            r = 0;
        } else {
            hf = gfd_host(g, dirfd);
            if (hf < 0)
                return -GUEST_EBADF;
            r = fstat(hf, &hs);
        }
    } else {
        int hd;
        struct gfd *pent;
        int32_t e = copy_path(g, pathp, path, sizeof(path));
        if (e != 0)
            return e;
        pent = gfd_entry(g, dirfd);
        if (pent && pent->dev == GDEV_PROC) {   /* a proc: capability stat */
            struct fs_stat ps;
            if (procfs_stat(g->sched, g->slot, path, &ps) < 0)
                return -GUEST_ENOENT;
            memset(&hs, 0, sizeof hs);
            hs.st_mode = ps.mode;
            hs.st_size = ps.size;
            hs.st_nlink = ps.nlink;
            r = 0;
        } else if (gfd_dir(g, dirfd, &hd) < 0) {
            return -GUEST_EBADF;
        } else if (hd == GUEST_AT_FDCWD) {
            r = fstatat(hd, path, &hs, 0);          /* ambient: unconfined */
        } else {
            r = hp_stat_beneath(hd, path, &hs);     /* confined to the grant */
        }
    }
    if (r < 0)
        return -GUEST_ENOENT;

    for (i = 0; i < 256; i += 4)                /* zero the struct statx first */
        gm_store(&g->mem, bufp + i, 4, be, 0);
    gm_store(&g->mem, bufp + 0,  4, be, 0x000007ffu);                 /* stx_mask */
    gm_store(&g->mem, bufp + 4,  4, be, (uint32_t)hs.st_blksize);     /* stx_blksize */
    gm_store(&g->mem, bufp + 16, 4, be, (uint32_t)hs.st_nlink);       /* stx_nlink */
    gm_store(&g->mem, bufp + 20, 4, be, (uint32_t)hs.st_uid);         /* stx_uid */
    gm_store(&g->mem, bufp + 24, 4, be, (uint32_t)hs.st_gid);         /* stx_gid */
    gm_store(&g->mem, bufp + 28, 2, be, (uint32_t)(hs.st_mode & 0xffffu)); /* stx_mode (u16) */
    store64(g, bufp + 32, (uint64_t)hs.st_ino);                      /* stx_ino */
    store64(g, bufp + 40, (uint64_t)(int64_t)hs.st_size);            /* stx_size */
    store64(g, bufp + 48, (uint64_t)(int64_t)hs.st_blocks);          /* stx_blocks */
    store64(g, bufp + 64, (uint64_t)(int64_t)hs.st_atime);           /* stx_atime.sec */
    store64(g, bufp + 96, (uint64_t)(int64_t)hs.st_ctime);           /* stx_ctime.sec */
    store64(g, bufp + 112, (uint64_t)(int64_t)hs.st_mtime);          /* stx_mtime.sec */
    if (g->mem.fault)
        return -GUEST_EFAULT;
    return 0;
}

/* The *at directory/path operations the guest libc uses (via AT_FDCWD) for
 * mkdir/unlink/rmdir/rename.  dirfd is passed through to the host, as for
 * openat.  A failure returns -ENOENT (the guest libc only checks for nonzero,
 * and remove() retries with AT_REMOVEDIR on it), matching sys_open's style. */
static int32_t
sys_mkdirat(guest *g, uint32_t dirfd, uint32_t pathp, uint32_t mode)
{
    char path[1024];
    int32_t e;
    int hd;

    if ((e = copy_path(g, pathp, path, sizeof(path))) != 0)
        return e;
    if (gfd_dir(g, dirfd, &hd) < 0)
        return -GUEST_EBADF;
    if (hd == GUEST_AT_FDCWD)
        return mkdirat(hd, path, (mode_t)mode) == 0 ? 0 : -GUEST_ENOENT;
    {
        const char *base;
        int pf = hp_parent_beneath(hd, path, &base), rc;
        if (pf < 0)
            return -GUEST_ENOENT;
        rc = mkdirat(pf, base, (mode_t)mode);
        close(pf);
        return rc == 0 ? 0 : -GUEST_ENOENT;
    }
}

static int32_t
sys_unlinkat(guest *g, uint32_t dirfd, uint32_t pathp, uint32_t flags)
{
    char path[1024];
    int32_t e;
    int hd;

    if ((e = copy_path(g, pathp, path, sizeof(path))) != 0)
        return e;
    if (gfd_dir(g, dirfd, &hd) < 0)
        return -GUEST_EBADF;
    if (hd == GUEST_AT_FDCWD)
        return unlinkat(hd, path, (int)flags) == 0 ? 0 : -GUEST_ENOENT;
    {
        const char *base;
        int pf = hp_parent_beneath(hd, path, &base), rc;
        if (pf < 0)
            return -GUEST_ENOENT;
        rc = unlinkat(pf, base, (int)flags);
        close(pf);
        return rc == 0 ? 0 : -GUEST_ENOENT;
    }
}

/* fchmodat(dirfd, path, mode, flags): the guest libc's chmod backs on this, so
   the linker can make its output executable in-guest. */
static int32_t
sys_fchmodat(guest *g, uint32_t dirfd, uint32_t pathp, uint32_t mode,
             uint32_t flags)
{
    char path[1024];
    int32_t e;
    int hd;

    if ((e = copy_path(g, pathp, path, sizeof(path))) != 0)
        return e;
    if (gfd_dir(g, dirfd, &hd) < 0)
        return -GUEST_EBADF;
    if (hd == GUEST_AT_FDCWD)
        return fchmodat(hd, path, (mode_t)mode, (int)flags) == 0
                   ? 0 : -GUEST_ENOENT;
    {
        const char *base;
        int pf = hp_parent_beneath(hd, path, &base), rc;
        if (pf < 0)
            return -GUEST_ENOENT;
        rc = fchmodat(pf, base, (mode_t)mode, (int)flags);
        close(pf);
        return rc == 0 ? 0 : -GUEST_ENOENT;
    }
}

/* renameat2(olddirfd, oldpath, newdirfd, newpath, flags): the guest libc always
 * passes flags 0, which is plain renameat (no _GNU_SOURCE needed on the host);
 * a nonzero flag word is rejected rather than silently dropped. */
static int32_t
sys_renameat2(guest *g, uint32_t od, uint32_t oldp, uint32_t nd,
              uint32_t newp, uint32_t flags)
{
    char oldpath[1024], newpath[1024];
    int32_t e;
    int ho, hn;

    if (flags != 0)
        return -GUEST_EINVAL;
    if ((e = copy_path(g, oldp, oldpath, sizeof(oldpath))) != 0)
        return e;
    if ((e = copy_path(g, newp, newpath, sizeof(newpath))) != 0)
        return e;
    if (gfd_dir(g, od, &ho) < 0 || gfd_dir(g, nd, &hn) < 0)
        return -GUEST_EBADF;
    if (ho == GUEST_AT_FDCWD && hn == GUEST_AT_FDCWD)
        return renameat(ho, oldpath, hn, newpath) == 0 ? 0 : -GUEST_ENOENT;
    if (ho == GUEST_AT_FDCWD || hn == GUEST_AT_FDCWD)
        return -GUEST_EINVAL;           /* no rename across ambient and a capability */
    {
        /* Confine both ends beneath their capabilities, then rename within the
         * resolved parents.  fs/ only ever renames inside one mount, so both
         * capabilities are the same granted tree. */
        const char *ob, *nb;
        int opf = hp_parent_beneath(ho, oldpath, &ob), npf, rc;
        if (opf < 0)
            return -GUEST_ENOENT;
        npf = hp_parent_beneath(hn, newpath, &nb);
        if (npf < 0) {
            close(opf);
            return -GUEST_ENOENT;
        }
        rc = renameat(opf, ob, npf, nb);
        close(opf);
        close(npf);
        return rc == 0 ? 0 : -GUEST_ENOENT;
    }
}

/* Store a 64-bit value to guest memory honoring the guest's byte order: the low
 * word sits at the low address on a little-endian guest and the high address on
 * a big-endian one, and each 32-bit word is itself byte-ordered to match, so a
 * native 64-bit load reads the value back whole. */
static void
store64(guest *g, uint32_t addr, uint64_t v)
{
    int be = g->big_endian;

    gm_store(&g->mem, addr + (be ? 4 : 0), 4, be, (uint32_t)v);
    gm_store(&g->mem, addr + (be ? 0 : 4), 4, be, (uint32_t)(v >> 32));
}

/* Emit one directory entry into the guest buffer as a struct linux_dirent64:
 * ino and off as 64-bit guest-ordered words, d_reclen = round_up(19 + namelen +
 * 1, 8) as a guest halfword, d_type as a byte, then the NUL-terminated name with
 * the record padded out with zeroes.  Returns the record length.  The 19-byte
 * head is the same on every guest arch, so the layout matches what the guest's
 * linux_dirent64 reader (libc dirent.c, the fs/ backends) expects. */
static uint16_t
emit_dirent64(guest *g, uint32_t dirp, uint32_t gpos, uint64_t ino, uint64_t off,
              uint8_t type, const char *name, int namelen)
{
    uint16_t reclen = (uint16_t)((19 + namelen + 1 + 7) & ~7);
    int pad = reclen - 19 - namelen;    /* NUL + alignment padding */

    store64(g, dirp + gpos + 0, ino);
    store64(g, dirp + gpos + 8, off);
    gm_store(&g->mem, dirp + gpos + 16, 2, g->big_endian, reclen);
    gm_store(&g->mem, dirp + gpos + 18, 1, 0, type);
    gm_write(&g->mem, dirp + gpos + 19, name, (uint32_t)namelen);
    gm_zero(&g->mem, dirp + gpos + 19 + (uint32_t)namelen, (uint32_t)pad);
    return reclen;
}

/* getdents64(fd, dirp, count): read directory entries into the guest buffer as a
 * packed run of struct linux_dirent64 (0 at end of directory, -errno on error).
 *
 * The directory is read through hp_dir, a host directory stream cached on the fd
 * table (opened on the first call, kept across calls).  hp_dirnext yields one
 * entry at a time and hp_dirtell/hp_dirseek rewind the stream when the next entry
 * will not fit, so the guest resumes there on its next call. */
static int32_t
sys_getdents64(guest *g, uint32_t fd, uint32_t dirp, uint32_t count)
{
    struct gfd *ent = gfd_entry(g, fd);
    uint32_t gpos = 0;
    hp_dir *d;

    if (!ent)
        return -GUEST_EBADF;
    if (ent->dev == GDEV_PROC) {        /* synthesize entries from the process table */
        for (;;) {
            struct fs_dirent de;
            uint16_t reclen;
            int namelen, r;

            r = procfs_getdent(ent->dirp, &de);
            if (r < 0)
                return -GUEST_ENOENT;
            if (r == 0)
                break;                  /* end of directory */
            namelen = (int)strlen(de.name);
            reclen = (uint16_t)((19 + namelen + 1 + 7) & ~7);
            if (gpos + reclen > count) {    /* will not fit: re-offer it next call */
                procfs_rewind1(ent->dirp);
                if (gpos == 0)
                    return -GUEST_EINVAL;
                break;
            }
            emit_dirent64(g, dirp, gpos, de.ino, (uint64_t)de.ino,
                          de.type == FS_DT_DIR ? 4 /* DT_DIR */ : 8 /* DT_REG */,
                          de.name, namelen);
            gpos += reclen;
        }
        if (g->mem.fault)
            return -GUEST_EFAULT;
        return (int32_t)gpos;
    }
    d = (hp_dir *)ent->dirp;
    if (!d) {                           /* open the stream on the first call */
        d = hp_diropen(ent->host_fd);
        if (!d)
            return -GUEST_ENOENT;
        ent->dirp = d;
    }
    for (;;) {
        long cookie = hp_dirtell(d);
        uint64_t ino;
        unsigned type;
        const char *name;
        int namelen, r;
        uint16_t reclen;

        r = hp_dirnext(d, &ino, &type, &name);
        if (r < 0)
            return -GUEST_ENOENT;
        if (r == 0)
            break;                      /* end of directory */
        namelen = (int)strlen(name);
        reclen = (uint16_t)((19 + namelen + 1 + 7) & ~7);
        if (gpos + reclen > count) {    /* will not fit: resume here next call */
            hp_dirseek(d, cookie);
            if (gpos == 0)              /* not even one entry fits */
                return -GUEST_EINVAL;
            break;
        }
        emit_dirent64(g, dirp, gpos, ino, (uint64_t)hp_dirtell(d),
                      (uint8_t)type, name, namelen);
        gpos += reclen;
    }
    if (g->mem.fault)
        return -GUEST_EFAULT;
    return (int32_t)gpos;
}

/* Linux brk: return the new break, or the current one when the request
 * cannot be met.  The heap is a region mapped at startup, so growing the
 * break only moves a pointer inside it. */
static int32_t
sys_brk(guest *g, uint32_t want)
{
    if (want >= g->brk_base && want <= g->brk_limit)
        g->brk = want;
    return (int32_t)g->brk;
}

/* clock_gettime(clk_id, struct timespec *ts): write a 32-bit timespec
 * (tv_sec, tv_nsec, each one target-endian word) and return 0.  This seam uses
 * a 32-bit timespec rather than rv32 Linux's 64-bit one, a private convention
 * skj-run and boris share; a monotonic uptime fits in 32 bits of seconds.
 * clk_id 0 (CLOCK_REALTIME) reports wall-clock, anything else the monotonic
 * clock the guest's millisecond timer wants. */
static int32_t
sys_clock_gettime(guest *g, uint32_t clk_id, uint32_t ts_ptr)
{
    uint32_t sec, nsec;

    if (ts_ptr == 0)
        return -GUEST_EFAULT;
    if (hp_clock(clk_id == 0, &sec, &nsec) != 0)
        return -GUEST_EINVAL;
    gm_store(&g->mem, ts_ptr + 0, 4, g->big_endian, sec);
    gm_store(&g->mem, ts_ptr + 4, 4, g->big_endian, nsec);
    return 0;
}

/* getrandom(buf, len, flags): fill the guest buffer with len random bytes from
 * the host and return the count.  The guest seeds its own generators from this;
 * flags are ignored (the host source never blocks meaningfully here). */
static int32_t
sys_getrandom(guest *g, uint32_t buf, uint32_t len, uint32_t flags)
{
    uint8_t tmp[256];
    uint32_t done = 0;

    (void)flags;
    if (len == 0)
        return 0;
    if (buf == 0)
        return -GUEST_EFAULT;
    while (done < len) {
        uint32_t chunk = len - done;
        int n;

        if (chunk > sizeof tmp)
            chunk = sizeof tmp;
        n = hp_random(tmp, (int)chunk);
        if (n <= 0)
            return done > 0 ? (int32_t)done : -GUEST_EINVAL;
        gm_write(&g->mem, buf + done, tmp, (uint32_t)n);
        done += (uint32_t)n;
    }
    return (int32_t)done;
}

/* nanosleep(req, rem): park for the {tv_sec, tv_nsec} the guest timespec holds
 * (the 32-bit timespec convention, as clock_gettime above).  skj-run really
 * sleeps on the host clock; the guest's Sleep/park glue uses this.  rem (the
 * unslept remainder on a signal) is not written back; skj-run has no signals
 * delivered to the guest, so a sleep here always completes. */
static int32_t
sys_nanosleep(guest *g, uint32_t req_ptr, uint32_t rem_ptr)
{
    uint32_t sec, nsec;

    (void)rem_ptr;
    if (req_ptr == 0)
        return -GUEST_EFAULT;
    sec  = gm_load(&g->mem, req_ptr + 0, 4, g->big_endian);
    nsec = gm_load(&g->mem, req_ptr + 4, 4, g->big_endian);
    if (nsec >= 1000000000u)
        return -GUEST_EINVAL;
    if (!g->can_park) {
        hp_sleep(sec, nsec);                    /* no scheduler to yield to */
        return 0;
    }
    /* Cooperative park: fix the deadline once (the guest re-runs this syscall
     * with the same relative duration each retry), then yield the slice until
     * the scheduler's poll timeout carries us past it.  One pending sleep per
     * process, which suffices: the process runs one guest thread at a time. */
    if (!g->sleeping) {
        g->sleeping = 1;
        g->sleep_deadline = mono_ns()
                          + (uint64_t)sec * 1000000000ull + nsec;
    }
    if (mono_ns() < g->sleep_deadline) {
        g->park = GPARK_RETRY;
        g->park_fd = -1;
        g->park_deadline = g->sleep_deadline;
        return 0;
    }
    g->sleeping = 0;                            /* deadline reached: the sleep is done */
    return 0;
}

int32_t
guest_syscall(guest *g, int sys, uint32_t a0, uint32_t a1, uint32_t a2,
              uint32_t a3, uint32_t a4, uint32_t a5)
{
    (void)a5;

    g->syscalls++;
    g->park = GPARK_NONE;               /* only a parking syscall leaves this set */
    gfd_init(g);                        /* pre-open 0/1/2 on first syscall */

    switch (sys) {
    case GSYS_WRITE:
        return sys_write(g, a0, a1, a2);

    case GSYS_READ:
        return sys_read(g, a0, a1, a2);

    case GSYS_WRITEV: {
        /* struct iovec { void *base; size_t len; } laid out in guest
         * order; both targets are ILP32 so an entry is two words. */
        uint32_t i, total = 0;
        for (i = 0; i < a2; i++) {
            uint32_t ent = a1 + i * 8;
            uint8_t w[8];
            uint32_t base, len;
            int32_t r;
            if (!copy_from_guest(g, ent, w, 8))
                return -GUEST_EFAULT;
            if (g->big_endian) {
                base = ((uint32_t)w[0] << 24) | ((uint32_t)w[1] << 16) |
                       ((uint32_t)w[2] << 8) | w[3];
                len = ((uint32_t)w[4] << 24) | ((uint32_t)w[5] << 16) |
                      ((uint32_t)w[6] << 8) | w[7];
            } else {
                base = (uint32_t)w[0] | ((uint32_t)w[1] << 8) |
                       ((uint32_t)w[2] << 16) | ((uint32_t)w[3] << 24);
                len = (uint32_t)w[4] | ((uint32_t)w[5] << 8) |
                      ((uint32_t)w[6] << 16) | ((uint32_t)w[7] << 24);
            }
            r = sys_write(g, a0, base, len);
            if (r < 0)
                return total ? (int32_t)total : r;
            total += (uint32_t)r;
        }
        return (int32_t)total;
    }

    case GSYS_BRK:
        return sys_brk(g, a0);

    case GSYS_OPEN:
        return sys_open(g, a0, a1, a2);

    case GSYS_OPENAT:
        return sys_openat(g, a0, a1, a2, a3);

    case GSYS_CLOSE:
        return gfd_close(g, a0);

    case GSYS_LSEEK:
        return sys_lseek(g, a0, a1, a2);

    case GSYS_LLSEEK:
        return sys_llseek(g, a0, a1, a2, a3, a4);

    case GSYS_STATX:
        return sys_statx(g, a0, a1, a2, a3, a4);

    case GSYS_MKDIRAT:
        return sys_mkdirat(g, a0, a1, a2);

    case GSYS_UNLINKAT:
        return sys_unlinkat(g, a0, a1, a2);

    case GSYS_RENAMEAT2:
        return sys_renameat2(g, a0, a1, a2, a3, a4);

    case GSYS_FCHMODAT:
        return sys_fchmodat(g, a0, a1, a2, a3);

    case GSYS_GETDENTS64:
        return sys_getdents64(g, a0, a1, a2);

    case GSYS_CLOCK_GETTIME:
        return sys_clock_gettime(g, a0, a1);

    case GSYS_GETRANDOM:
        return sys_getrandom(g, a0, a1, a2);

    case GSYS_NANOSLEEP:
        return sys_nanosleep(g, a0, a1);

    case GSYS_SCHED_YIELD:
        if (g->can_park) {
            g->park = GPARK_YIELD;      /* end the slice; siblings run this round */
            return 0;
        }
        hp_yield();
        return 0;

    case GSYS_EXIT:
    case GSYS_EXIT_GROUP:
        g->exited = 1;
        g->exit_code = (int)(a0 & 0xFF);
        return 0;

    default:
        return -GUEST_ENOSYS;
    }
}

/****************************************************************
 * Initial stack
 *
 * The layout Linux hands a fresh process: argc, the argv pointers, a
 * NULL, the envp pointers, a NULL, then a terminated auxv.  The strings
 * live above it.  Skjegg's own start.S switches to a private stack and
 * ignores all of this, but a guest built against a real libc does not,
 * and building it costs nothing.
 ****************************************************************/

static void
poke32(guest *g, uint32_t addr, uint32_t val)
{
    if (g->big_endian) {
        gm_write8(&g->mem, addr + 0, (uint8_t)(val >> 24));
        gm_write8(&g->mem, addr + 1, (uint8_t)(val >> 16));
        gm_write8(&g->mem, addr + 2, (uint8_t)(val >> 8));
        gm_write8(&g->mem, addr + 3, (uint8_t)val);
    } else {
        gm_write8(&g->mem, addr + 0, (uint8_t)val);
        gm_write8(&g->mem, addr + 1, (uint8_t)(val >> 8));
        gm_write8(&g->mem, addr + 2, (uint8_t)(val >> 16));
        gm_write8(&g->mem, addr + 3, (uint8_t)(val >> 24));
    }
}

#define AT_NULL     0
#define AT_PAGESZ   6
#define AT_SKJ_VDSO 0x7001          /* keep in step with include/skj_vdso.h */

/* Build the shared vDSO buffer once from its ELF image: a flat host buffer
 * holding the loadable segments laid out at their guest addresses, which every
 * guest then aliases read-only.  The image is small and linked at a fixed guest
 * address (runtime/vdso.c, vdso_rv.ld).  Two passes over elf32_load_raw: the
 * first learns the address range (a no-op poke), the second fills the buffer.
 * Returns 0 and sets *buf (caller owns, free once), *vaddr, *size (page-rounded)
 * and *table (the exported skj_vdso_table address); -1 on any failure. */
struct vdso_build {
    uint8_t *buf;
    uint32_t lo;
    uint32_t size;
};

static void
vdso_poke(void *ctx, uint32_t addr, uint8_t b)
{
    struct vdso_build *v = ctx;

    if (v->buf && addr >= v->lo && addr - v->lo < v->size)
        v->buf[addr - v->lo] = b;
}

int
guest_vdso_image(const char *path, int word64, uint8_t **buf, uint32_t *vaddr,
                 uint32_t *size, uint32_t *table, uint32_t *sysinfo)
{
    elf32_info info;
    struct vdso_build v = { 0 };
    uint32_t sz, t;

    /* The LP64 (HV) guests carry an ELF64 image; the emulated ILP32 guests an
     * ELF32 one.  Either way the result is a flat host buffer holding the
     * segments at their guest addresses plus the exported table address.  The
     * optional system-page symbol (skj_vdso_sysinfo) is 0 when an older image
     * lacks it. */
    if (word64) {
        if (elf64_load_flat(path, buf, vaddr, size) != 0)
            return -1;
        t = elf64_symbol(path, "skj_vdso_table");
        if (!t) {
            fprintf(stderr, "skj-run: %s links no skj_vdso_table\n", path);
            free(*buf);
            return -1;
        }
        *table = t;
        *sysinfo = elf64_symbol(path, "skj_vdso_sysinfo");
        return 0;
    }

    if (elf32_load_raw(path, vdso_poke, &v, &info) == 0 || info.nsegments == 0) {
        fprintf(stderr, "skj-run: cannot load vDSO image %s\n", path);
        return -1;
    }
    sz = (info.hi - info.lo + GM_PAGE_SIZE - 1) & ~(GM_PAGE_SIZE - 1);
    t = elf32_symbol(path, "skj_vdso_table");
    if (!t) {
        fprintf(stderr, "skj-run: %s links no skj_vdso_table\n", path);
        return -1;
    }
    *sysinfo = elf32_symbol(path, "skj_vdso_sysinfo");
    v.buf = calloc(1, sz);
    if (!v.buf) {
        fprintf(stderr, "skj-run: out of memory for the vDSO image\n");
        return -1;
    }
    v.lo = info.lo;
    v.size = sz;
    elf32_load_raw(path, vdso_poke, &v, &info);   /* fill the buffer this time */

    *buf = v.buf;
    *vaddr = info.lo;
    *size = sz;
    *table = t;
    return 0;
}

/* Alias the shared vDSO buffer read-only into this guest and record the table
 * address the auxv will advertise.  The buffer is not owned by the guest. */
void
guest_vdso_attach(guest *g, uint8_t *buf, uint32_t vaddr, uint32_t size,
                  uint32_t table)
{
    g->mem.vdso_host = buf;
    g->mem.vdso_vaddr = vaddr;
    g->mem.vdso_size = size;
    /* An emulated guest runs the vDSO through gm_page, which aliases the shared
     * buffer for the [vaddr, vaddr+size) region (see gm_page).  An extern-backed
     * HV guest runs on real hardware instead: its vDSO is a read-only
     * hypervisor memory slot the core maps from these same fields, so no gm
     * region is needed (and gm_page's extern path would not consult one). */
    if (!g->mem.extern_base)
        gm_map(&g->mem, vaddr, size, GM_R | GM_X, "vdso");
    g->vdso_base = table;
}

uint32_t
guest_build_stack(guest *g, const run_opts *o)
{
    uint32_t sp = g->stack_top;
    uint32_t str[64] = { 0 };
    uint32_t env[64] = { 0 };
    int argc = o->argc;
    int envc = o->envp ? o->envc : 0;
    int i;

    if (argc > (int)(sizeof(str) / sizeof(str[0])))
        argc = (int)(sizeof(str) / sizeof(str[0]));
    if (envc > (int)(sizeof(env) / sizeof(env[0])))
        envc = (int)(sizeof(env) / sizeof(env[0]));

    /* strings, top down: argv then envp */
    for (i = argc - 1; i >= 0; i--) {
        uint32_t len = (uint32_t)strlen(o->argv[i]) + 1;
        sp -= len;
        gm_write(&g->mem, sp, o->argv[i], len);
        str[i] = sp;
    }
    for (i = envc - 1; i >= 0; i--) {
        uint32_t len = (uint32_t)strlen(o->envp[i]) + 1;
        sp -= len;
        gm_write(&g->mem, sp, o->envp[i], len);
        env[i] = sp;
    }
    sp &= ~15u;

    /* argc, argv[], argv NULL, envp[], envp NULL, auxv (AT_PAGESZ pair, an
       optional AT_SKJ_VDSO pair when a vDSO is injected, AT_NULL pair) */
    {
        uint32_t aux_pairs = g->vdso_base ? 3u : 2u;
        sp -= 4 * (1 + (uint32_t)argc + 1 + (uint32_t)envc + 1 + 2u * aux_pairs);
    }
    sp &= ~15u;

    {
        uint32_t p = sp;
        poke32(g, p, (uint32_t)argc);
        p += 4;
        for (i = 0; i < argc; i++, p += 4)
            poke32(g, p, str[i]);
        poke32(g, p, 0);            /* argv terminator */
        p += 4;
        for (i = 0; i < envc; i++, p += 4)
            poke32(g, p, env[i]);
        poke32(g, p, 0);            /* envp terminator */
        p += 4;
        poke32(g, p, AT_PAGESZ);
        p += 4;
        poke32(g, p, GM_PAGE_SIZE);
        p += 4;
        if (g->vdso_base) {
            poke32(g, p, AT_SKJ_VDSO);
            p += 4;
            poke32(g, p, g->vdso_base);
            p += 4;
        }
        poke32(g, p, AT_NULL);
        p += 4;
        poke32(g, p, 0);
    }
    return sp;
}

static void
poke64(guest *g, uint32_t addr, uint64_t val)
{
    int i;

    for (i = 0; i < 8; i++)             /* the HV guests are little-endian */
        gm_write8(&g->mem, addr + (uint32_t)i, (uint8_t)(val >> (8 * i)));
}

/* The LP64 initial stack for the hardware-virtualization guests: the System V
 * layout with 8-byte slots (argc, argv[], NULL, envp NULL, auxv, AT_NULL).  The
 * returned pointer is 16-byte aligned, which is what the amd64 and aarch64 entry
 * conventions expect at _start. */
uint32_t
guest_build_stack64(guest *g, const run_opts *o)
{
    uint32_t sp = g->stack_top;
    uint32_t str[64] = { 0 };
    uint32_t env[64] = { 0 };
    int argc = o->argc;
    int envc = o->envp ? o->envc : 0;
    int i;

    if (argc > (int)(sizeof(str) / sizeof(str[0])))
        argc = (int)(sizeof(str) / sizeof(str[0]));
    if (envc > (int)(sizeof(env) / sizeof(env[0])))
        envc = (int)(sizeof(env) / sizeof(env[0]));

    for (i = argc - 1; i >= 0; i--) {   /* strings, top down: argv then envp */
        uint32_t len = (uint32_t)strlen(o->argv[i]) + 1;
        sp -= len;
        gm_write(&g->mem, sp, o->argv[i], len);
        str[i] = sp;
    }
    for (i = envc - 1; i >= 0; i--) {
        uint32_t len = (uint32_t)strlen(o->envp[i]) + 1;
        sp -= len;
        gm_write(&g->mem, sp, o->envp[i], len);
        env[i] = sp;
    }
    sp &= ~15u;

    /* argc + argv + argv NULL + envp[] + envp NULL + auxv (AT_PAGESZ pair, an
     * optional AT_SKJ_VDSO pair when a vDSO is injected, AT_NULL pair), 8 bytes
     * each.  Keep the final sp 16-byte aligned by padding the slot count even. */
    {
        uint32_t aux_pairs = g->vdso_base ? 3u : 2u;
        uint32_t slots = 1 + (uint32_t)argc + 1 + (uint32_t)envc + 1
                       + 2u * aux_pairs;
        sp -= 8 * (slots + (slots & 1));
        sp &= ~15u;
    }

    {
        uint32_t p = sp;
        poke64(g, p, (uint64_t)(uint32_t)argc);
        p += 8;
        for (i = 0; i < argc; i++, p += 8)
            poke64(g, p, str[i]);
        poke64(g, p, 0);                /* argv terminator */
        p += 8;
        for (i = 0; i < envc; i++, p += 8)
            poke64(g, p, env[i]);
        poke64(g, p, 0);                /* envp terminator */
        p += 8;
        poke64(g, p, AT_PAGESZ);
        p += 8;
        poke64(g, p, GM_PAGE_SIZE);
        p += 8;
        if (g->vdso_base) {
            poke64(g, p, AT_SKJ_VDSO);
            p += 8;
            poke64(g, p, g->vdso_base);
            p += 8;
        }
        poke64(g, p, AT_NULL);
        p += 8;
        poke64(g, p, 0);
    }
    return sp;
}
