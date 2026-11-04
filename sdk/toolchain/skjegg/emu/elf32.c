/* elf32.c : ELF32 loader for the guest machines, either endianness */

#include "elf32.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EI_NIDENT   16
#define ELFCLASS32  1
#define ELFDATA2LSB 1
#define ELFDATA2MSB 2
#define ET_EXEC     2
#define PT_LOAD     1
#define PF_X        1
#define PF_W        2
#define PF_R        4
#define SHT_SYMTAB  2

/****************************************************************
 * Endian-aware field readers
 ****************************************************************/

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

/****************************************************************
 * Whole-file read
 *
 * A guest image is small and read once, so slurping it keeps the header
 * walking free of seek bookkeeping.
 ****************************************************************/

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

/** Validate the header and fill info.  Returns 0 on success. */
static int
read_header(const char *what, const uint8_t *b, long size, elf32_info *info)
{
    int be;

    if (size < 52 || memcmp(b, "\177ELF", 4) != 0) {
        fprintf(stderr, "skj-run: %s is not an ELF file\n", what);
        return -1;
    }
    if (b[4] != ELFCLASS32) {
        fprintf(stderr, "skj-run: %s is not ELF32 (the guests are 32-bit)\n",
                what);
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
    info->entry = rd32(b + 24, be);
    if (rd16(b + 16, be) != ET_EXEC && info->entry == 0) {
        fprintf(stderr, "skj-run: %s is not an executable image\n", what);
        return -1;
    }
    return 0;
}

int
elf32_probe_mem(const uint8_t *b, long size, elf32_info *info)
{
    return read_header("<image>", b, size, info);
}

int
elf32_probe(const char *path, elf32_info *info)
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
elf32_load_mem(guest *g, const uint8_t *b, long size, elf32_info *info,
               const char *what)
{
    uint32_t phoff, i, phnum, phentsize;
    int be;

    if (read_header(what, b, size, info) != 0)
        return -1;
    be = info->big_endian;
    phoff = rd32(b + 28, be);
    phentsize = rd16(b + 42, be);
    phnum = rd16(b + 44, be);

    if (phnum == 0 || phoff == 0) {
        fprintf(stderr, "skj-run: %s has no program headers\n", what);
        return -1;
    }

    info->lo = 0xFFFFFFFFu;
    info->hi = 0;

    g->mem.loading = 1;
    for (i = 0; i < phnum; i++) {
        const uint8_t *ph = b + phoff + i * phentsize;
        uint32_t type, offset, vaddr, filesz, memsz, flags;
        uint32_t page_lo, page_hi;
        int prot = 0;

        if ((long)(phoff + (i + 1) * phentsize) > size) {
            fprintf(stderr, "skj-run: %s: program headers past end of file\n",
                    what);
            g->mem.loading = 0;
            return -1;
        }
        type = rd32(ph + 0, be);
        if (type != PT_LOAD)
            continue;
        offset = rd32(ph + 4, be);
        vaddr = rd32(ph + 8, be);
        filesz = rd32(ph + 16, be);
        memsz = rd32(ph + 20, be);
        flags = rd32(ph + 24, be);

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
elf32_load(guest *g, const char *path, elf32_info *info)
{
    long size;
    uint8_t *b = slurp(path, &size);
    int rc;

    if (!b)
        return -1;
    rc = elf32_load_mem(g, b, size, info, path);
    free(b);
    return rc;
}

uint32_t
elf32_load_raw(const char *path, elf32_poke_fn poke, void *ctx,
               elf32_info *info)
{
    long size;
    uint8_t *b = slurp(path, &size);
    uint32_t phoff, i, phnum, phentsize;
    int be;

    if (!b)
        return 0;
    if (read_header(path, b, size, info) != 0) {
        free(b);
        return 0;
    }
    be = info->big_endian;
    phoff = rd32(b + 28, be);
    phentsize = rd16(b + 42, be);
    phnum = rd16(b + 44, be);

    info->lo = 0xFFFFFFFFu;
    info->hi = 0;

    for (i = 0; i < phnum; i++) {
        const uint8_t *ph = b + phoff + i * phentsize;
        uint32_t type, offset, vaddr, filesz, memsz, j;

        if ((long)(phoff + (i + 1) * phentsize) > size)
            break;
        type = rd32(ph + 0, be);
        if (type != PT_LOAD)
            continue;
        offset = rd32(ph + 4, be);
        vaddr = rd32(ph + 8, be);
        filesz = rd32(ph + 16, be);
        memsz = rd32(ph + 20, be);
        if ((long)(offset + filesz) > size)
            continue;

        for (j = 0; j < filesz; j++)
            poke(ctx, vaddr + j, b[offset + j]);
        for (; j < memsz; j++)
            poke(ctx, vaddr + j, 0);

        if (vaddr < info->lo)
            info->lo = vaddr;
        if (vaddr + memsz > info->hi)
            info->hi = vaddr + memsz;
        info->nsegments++;
    }
    free(b);
    return info->nsegments ? info->entry : 0;
}

uint32_t
elf32_symbol_mem(const uint8_t *b, long size, const char *name)
{
    elf32_info info;
    uint32_t shoff, shentsize, shnum, i;
    uint32_t found = 0;
    int be;

    if (read_header("<image>", b, size, &info) != 0)
        return 0;
    be = info.big_endian;
    shoff = rd32(b + 32, be);
    shentsize = rd16(b + 46, be);
    shnum = rd16(b + 48, be);

    for (i = 0; i < shnum && !found; i++) {
        const uint8_t *sh = b + shoff + i * shentsize;
        uint32_t type, off, sz, link, entsize, j;
        const uint8_t *strtab;
        uint32_t stroff, strsz;

        if ((long)(shoff + (i + 1) * shentsize) > size)
            break;
        type = rd32(sh + 4, be);
        if (type != SHT_SYMTAB)
            continue;
        off = rd32(sh + 16, be);
        sz = rd32(sh + 20, be);
        link = rd32(sh + 24, be);
        entsize = rd32(sh + 36, be);
        if (!entsize || (long)(off + sz) > size)
            continue;

        stroff = rd32(b + shoff + link * shentsize + 16, be);
        strsz = rd32(b + shoff + link * shentsize + 20, be);
        if ((long)(stroff + strsz) > size)
            continue;
        strtab = b + stroff;

        for (j = 0; j < sz / entsize; j++) {
            const uint8_t *sym = b + off + j * entsize;
            uint32_t nameoff = rd32(sym + 0, be);
            if (nameoff >= strsz)
                continue;
            if (strcmp((const char *)strtab + nameoff, name) == 0) {
                found = rd32(sym + 4, be);
                break;
            }
        }
    }
    return found;
}

uint32_t
elf32_symbol(const char *path, const char *name)
{
    long size;
    uint8_t *b = slurp(path, &size);
    uint32_t found;

    if (!b)
        return 0;
    found = elf32_symbol_mem(b, size, name);
    free(b);
    return found;
}
