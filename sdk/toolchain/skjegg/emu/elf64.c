/* elf64.c : ELF64 loader for the hardware-virtualization guests.
 *
 * The HV guest runs under 4 GiB, so its addresses fit the 32-bit fields of
 * elf32_info and the 32-bit guest-memory layer the sandbox shares.  Only the
 * file format is 64-bit. */

#if defined(__APPLE__)
# define _DARWIN_C_SOURCE
#else
# define _POSIX_C_SOURCE 200809L        /* posix_memalign */
# define _DEFAULT_SOURCE
#endif

#include "elf64.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EI_NIDENT   16
#define ELFCLASS64  2
#define ELFDATA2LSB 1
#define ELFDATA2MSB 2
#define ET_EXEC     2
#define ET_DYN      3
#define PT_LOAD     1
#define PF_X        1
#define PF_W        2
#define PF_R        4

static uint16_t
rd16(const uint8_t *p, int be)
{
    return be ? (uint16_t)((p[0] << 8) | p[1])
              : (uint16_t)(p[0] | (p[1] << 8));
}

static uint32_t
rd32(const uint8_t *p, int be)
{
    if (be)
        return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) |
               ((uint32_t)p[2] << 8) | p[3];
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static uint64_t
rd64(const uint8_t *p, int be)
{
    if (be)
        return ((uint64_t)rd32(p, 1) << 32) | rd32(p + 4, 1);
    return (uint64_t)rd32(p, 0) | ((uint64_t)rd32(p + 4, 0) << 32);
}

static uint8_t *
slurp(const char *path, long *size)
{
    FILE *f = fopen(path, "rb");
    uint8_t *buf;
    long n;

    if (!f) {
        fprintf(stderr, "skj-run: cannot open %s\n", path);
        return NULL;
    }
    if (fseek(f, 0, SEEK_END) != 0) {
        fclose(f);
        fprintf(stderr, "skj-run: cannot seek %s\n", path);
        return NULL;
    }
    n = ftell(f);
    rewind(f);
    if (n < EI_NIDENT) {
        fclose(f);
        fprintf(stderr, "skj-run: %s is too small to be an ELF file\n", path);
        return NULL;
    }
    buf = malloc((size_t)n);
    if (!buf) {
        fclose(f);
        fprintf(stderr, "skj-run: out of memory reading %s\n", path);
        return NULL;
    }
    if (fread(buf, 1, (size_t)n, f) != (size_t)n) {
        fclose(f);
        free(buf);
        fprintf(stderr, "skj-run: short read on %s\n", path);
        return NULL;
    }
    fclose(f);
    *size = n;
    return buf;
}

static int
read_header(const char *what, const uint8_t *b, long size, elf32_info *info)
{
    int be;
    uint16_t type;

    if (size < 64 || memcmp(b, "\177ELF", 4) != 0) {
        fprintf(stderr, "skj-run: %s is not an ELF file\n", what);
        return -1;
    }
    if (b[4] != ELFCLASS64) {
        fprintf(stderr, "skj-run: %s is not ELF64\n", what);
        return -1;
    }
    if (b[5] != ELFDATA2LSB && b[5] != ELFDATA2MSB) {
        fprintf(stderr, "skj-run: %s has an unknown byte order\n", what);
        return -1;
    }
    be = (b[5] == ELFDATA2MSB);

    memset(info, 0, sizeof(*info));
    info->big_endian = be;
    info->machine = rd16(b + 18, be);
    info->entry = (uint32_t)rd64(b + 24, be);
    type = rd16(b + 16, be);
    if (type != ET_EXEC && type != ET_DYN && info->entry == 0) {
        fprintf(stderr, "skj-run: %s is not an executable image\n", what);
        return -1;
    }
    return 0;
}

int
elf64_probe_mem(const uint8_t *b, long size, elf32_info *info)
{
    return read_header("<image>", b, size, info);
}

int
elf64_probe(const char *path, elf32_info *info)
{
    long size;
    uint8_t *b = slurp(path, &size);
    int rc;

    if (!b)
        return -1;
    rc = read_header(path, b, size, info);
    free(b);
    return rc;
}

int
elf64_load_mem(guest *g, const uint8_t *b, long size, elf32_info *info,
               const char *what)
{
    uint64_t phoff;
    uint32_t i, phnum, phentsize;
    int be;

    if (read_header(what, b, size, info) != 0)
        return -1;
    be = info->big_endian;
    phoff = rd64(b + 32, be);
    phentsize = rd16(b + 54, be);
    phnum = rd16(b + 56, be);

    if (phnum == 0 || phoff == 0) {
        fprintf(stderr, "skj-run: %s has no program headers\n", what);
        return -1;
    }

    info->lo = 0xFFFFFFFFu;
    info->hi = 0;

    g->mem.loading = 1;
    for (i = 0; i < phnum; i++) {
        const uint8_t *ph = b + phoff + (uint64_t)i * phentsize;
        uint32_t type, flags, vaddr, filesz, memsz;
        uint64_t offset;
        uint32_t page_lo, page_hi;
        int prot = 0;

        if ((long)(phoff + (uint64_t)(i + 1) * phentsize) > size) {
            fprintf(stderr, "skj-run: %s: program headers past end of file\n",
                    what);
            g->mem.loading = 0;
            return -1;
        }
        type = rd32(ph + 0, be);
        if (type != PT_LOAD)
            continue;
        flags = rd32(ph + 4, be);
        offset = rd64(ph + 8, be);
        vaddr = (uint32_t)rd64(ph + 16, be);
        filesz = (uint32_t)rd64(ph + 32, be);
        memsz = (uint32_t)rd64(ph + 40, be);

        if ((long)(offset + filesz) > size) {
            fprintf(stderr, "skj-run: %s: segment %u past end of file\n",
                    what, i);
            g->mem.loading = 0;
            return -1;
        }

        if (flags & PF_R)
            prot |= GM_R;
        if (flags & PF_W)
            prot |= GM_W;
        if (flags & PF_X)
            prot |= GM_X;
        if (!prot)
            prot = GM_R;

        page_lo = vaddr & ~(GM_PAGE_SIZE - 1);
        page_hi = (vaddr + memsz + GM_PAGE_SIZE - 1) & ~(GM_PAGE_SIZE - 1);
        if (gm_map(&g->mem, page_lo, page_hi - page_lo, prot, "image") != 0) {
            fprintf(stderr, "skj-run: %s: too many loadable segments\n", what);
            g->mem.loading = 0;
            return -1;
        }
        gm_write(&g->mem, vaddr, b + offset, filesz);
        if (memsz > filesz)
            gm_zero(&g->mem, vaddr + filesz, memsz - filesz);

        if (page_lo < info->lo)
            info->lo = page_lo;
        if (page_hi > info->hi)
            info->hi = page_hi;
        info->nsegments++;
    }
    g->mem.loading = 0;

    if (info->nsegments == 0) {
        fprintf(stderr, "skj-run: %s has no loadable segments\n", what);
        return -1;
    }
    if (g->mem.fault) {
        fprintf(stderr, "skj-run: %s: cannot map the image (%s at 0x%08x)\n",
                what, g->mem.fault_why, g->mem.fault_addr);
        return -1;
    }
    return 0;
}

int
elf64_load(guest *g, const char *path, elf32_info *info)
{
    long size;
    uint8_t *b = slurp(path, &size);
    int rc;

    if (!b)
        return -1;
    rc = elf64_load_mem(g, b, size, info, path);
    free(b);
    return rc;
}

int
elf64_load_flat(const char *path, uint8_t **buf, uint32_t *lo, uint32_t *size)
{
    elf32_info info;
    long fsize;
    uint8_t *b = slurp(path, &fsize);
    uint64_t phoff;
    uint32_t i, phnum, phentsize, plo = 0xFFFFFFFFu, phi = 0, span;
    uint8_t *out;
    int be, nseg = 0;

    if (!b)
        return -1;
    if (read_header(path, b, fsize, &info) != 0) {
        free(b);
        return -1;
    }
    be = info.big_endian;
    phoff = rd64(b + 32, be);
    phentsize = rd16(b + 54, be);
    phnum = rd16(b + 56, be);
    if (phnum == 0 || phoff == 0) {
        fprintf(stderr, "skj-run: %s has no program headers\n", path);
        free(b);
        return -1;
    }

    /* First pass: learn the mapped address range. */
    for (i = 0; i < phnum; i++) {
        const uint8_t *ph = b + phoff + (uint64_t)i * phentsize;
        uint32_t vaddr, memsz, page_lo, page_hi;

        if ((long)(phoff + (uint64_t)(i + 1) * phentsize) > fsize)
            break;
        if (rd32(ph + 0, be) != PT_LOAD)
            continue;
        vaddr = (uint32_t)rd64(ph + 16, be);
        memsz = (uint32_t)rd64(ph + 40, be);
        page_lo = vaddr & ~(GM_PAGE_SIZE - 1);
        page_hi = (vaddr + memsz + GM_PAGE_SIZE - 1) & ~(GM_PAGE_SIZE - 1);
        if (page_lo < plo)
            plo = page_lo;
        if (page_hi > phi)
            phi = page_hi;
        nseg++;
    }
    if (nseg == 0) {
        fprintf(stderr, "skj-run: %s has no loadable segments\n", path);
        free(b);
        return -1;
    }
    span = phi - plo;
    /* Page-align the buffer: a hypervisor memory slot (the HV vDSO) needs a
       page-aligned host address.  posix_memalign's result is released with the
       plain free() the caller uses. */
    if (posix_memalign((void **)&out, GM_PAGE_SIZE, span) != 0) {
        fprintf(stderr, "skj-run: out of memory for the vDSO image\n");
        free(b);
        return -1;
    }
    memset(out, 0, span);

    /* Second pass: copy each segment's file bytes into the flat buffer. */
    for (i = 0; i < phnum; i++) {
        const uint8_t *ph = b + phoff + (uint64_t)i * phentsize;
        uint32_t vaddr, filesz;
        uint64_t offset;

        if ((long)(phoff + (uint64_t)(i + 1) * phentsize) > fsize)
            break;
        if (rd32(ph + 0, be) != PT_LOAD)
            continue;
        offset = rd64(ph + 8, be);
        vaddr = (uint32_t)rd64(ph + 16, be);
        filesz = (uint32_t)rd64(ph + 32, be);
        if ((long)(offset + filesz) > fsize) {
            fprintf(stderr, "skj-run: %s: segment %u past end of file\n",
                    path, i);
            free(out);
            free(b);
            return -1;
        }
        memcpy(out + (vaddr - plo), b + offset, filesz);
    }

    free(b);
    *buf = out;
    *lo = plo;
    *size = span;
    return 0;
}

/* Resolve a global symbol's value from an in-memory ELF64 image, the ELF64
 * analogue of elf32_symbol_mem.  The guest lives under 4 GiB, so the value
 * fits 32 bits and is returned as such; 0 means not found.  Used to locate a
 * spawned LP64 child's fs_mounts / fs_inherit_fds tables for inheritance. */
#define SHT_SYMTAB 2
uint32_t
elf64_symbol_mem(const uint8_t *b, long size, const char *name)
{
    elf32_info info;
    uint64_t shoff;
    uint32_t shentsize, shnum, i, found = 0;
    int be;

    if (read_header("<image>", b, size, &info) != 0)
        return 0;
    be = info.big_endian;
    shoff = rd64(b + 40, be);
    shentsize = rd16(b + 58, be);
    shnum = rd16(b + 60, be);

    for (i = 0; i < shnum && !found; i++) {
        const uint8_t *sh = b + shoff + (uint64_t)i * shentsize;
        uint64_t off, sz, entsize, stroff, strsz, j;
        uint32_t type, link;
        const uint8_t *strtab;

        if ((long)(shoff + (uint64_t)(i + 1) * shentsize) > size)
            break;
        type = rd32(sh + 4, be);
        if (type != SHT_SYMTAB)
            continue;
        off = rd64(sh + 24, be);
        sz = rd64(sh + 32, be);
        link = rd32(sh + 40, be);
        entsize = rd64(sh + 56, be);
        if (!entsize || (long)(off + sz) > size)
            continue;

        stroff = rd64(b + shoff + (uint64_t)link * shentsize + 24, be);
        strsz = rd64(b + shoff + (uint64_t)link * shentsize + 32, be);
        if ((long)(stroff + strsz) > size)
            continue;
        strtab = b + stroff;

        for (j = 0; j < sz / entsize; j++) {
            const uint8_t *sym = b + off + j * entsize;
            uint32_t nameoff = rd32(sym + 0, be);
            if (nameoff >= strsz)
                continue;
            if (strcmp((const char *)strtab + nameoff, name) == 0) {
                found = (uint32_t)rd64(sym + 8, be);
                break;
            }
        }
    }
    return found;
}

/* File-based wrapper: slurp the ELF64 image and resolve a symbol from it. */
uint32_t
elf64_symbol(const char *path, const char *name)
{
    long size;
    uint8_t *b = slurp(path, &size);
    uint32_t found;

    if (!b)
        return 0;
    found = elf64_symbol_mem(b, size, name);
    free(b);
    return found;
}
