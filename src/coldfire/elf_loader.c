/* elf_loader.c : minimal ELF32 big-endian loader for ColdFire binaries */
/* Copyright (c) 2026 Jon Mayo -- MIT-0 OR Public Domain */
/* Written with AI assistance (Claude, Anthropic) */

#include "elf_loader.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

/****************************************************************
 * ELF32 Structures (big-endian, manually decoded)
 ****************************************************************/

#define EI_NIDENT   16
#define ET_EXEC     2
#define EM_68K      4
#define PT_LOAD     1
#define ELFCLASS32  1
#define ELFDATA2MSB 2   /* big-endian */

/****************************************************************
 * Byte-order helpers
 ****************************************************************/

static uint16_t
rd16be(const uint8_t *p)
{
    return (uint16_t)((p[0] << 8) | p[1]);
}

static uint32_t
rd32be(const uint8_t *p)
{
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) |
           ((uint32_t)p[2] << 8)  | (uint32_t)p[3];
}

/****************************************************************
 * ELF parser (operates on a buffer)
 ****************************************************************/

static uint32_t
elf_parse(const uint8_t *buf, size_t fsize, const char *name,
          elf_write_fn write, void *ctx)
{
    uint32_t entry, phoff;
    uint16_t phnum, phentsize;
    int i;

    if (fsize < 52) {
        fprintf(stderr, "elf_load(%s): file too small\n", name);
        return 0;
    }

    if (buf[0] != 0x7f || buf[1] != 'E' || buf[2] != 'L' || buf[3] != 'F') {
        fprintf(stderr, "elf_load(%s): bad ELF magic\n", name);
        return 0;
    }

    if (buf[4] != ELFCLASS32) {
        fprintf(stderr, "elf_load(%s): not ELF32\n", name);
        return 0;
    }
    if (buf[5] != ELFDATA2MSB) {
        fprintf(stderr, "elf_load(%s): not big-endian\n", name);
        return 0;
    }

    if (rd16be(buf + 16) != ET_EXEC) {
        fprintf(stderr, "elf_load(%s): not executable\n", name);
        return 0;
    }
    if (rd16be(buf + 18) != EM_68K) {
        fprintf(stderr, "elf_load(%s): not m68k (machine=%u)\n",
                name, rd16be(buf + 18));
        return 0;
    }

    entry     = rd32be(buf + 24);
    phoff     = rd32be(buf + 28);
    phentsize = rd16be(buf + 42);
    phnum     = rd16be(buf + 44);

    for (i = 0; i < phnum; i++) {
        const uint8_t *ph = buf + phoff + (uint32_t)i * phentsize;
        uint32_t p_type, p_offset, p_vaddr, p_filesz, p_memsz;
        uint32_t j;

        if (ph + phentsize > buf + fsize)
            break;

        p_type   = rd32be(ph + 0);
        p_offset = rd32be(ph + 4);
        p_vaddr  = rd32be(ph + 8);
        p_filesz = rd32be(ph + 16);
        p_memsz  = rd32be(ph + 20);

        if (p_type != PT_LOAD)
            continue;

        if (p_offset + p_filesz > (uint32_t)fsize) {
            fprintf(stderr, "elf_load(%s): segment %d exceeds file bounds\n",
                    name, i);
            return 0;
        }

        for (j = 0; j < p_filesz; j++)
            write(ctx, p_vaddr + j, buf[p_offset + j]);

        for (j = p_filesz; j < p_memsz; j++)
            write(ctx, p_vaddr + j, 0);
    }

    return entry;
}

/****************************************************************
 * Public entry points
 ****************************************************************/

uint32_t
elf_load(const char *path, elf_write_fn write, void *ctx)
{
    FILE *f;
    uint8_t *buf;
    long fsize;
    uint32_t entry;

    f = fopen(path, "rb");
    if (!f) {
        fprintf(stderr, "elf_load: cannot open '%s'\n", path);
        return 0;
    }

    fseek(f, 0, SEEK_END);
    fsize = ftell(f);
    fseek(f, 0, SEEK_SET);

    buf = malloc(fsize);
    if (!buf) {
        fprintf(stderr, "elf_load(%s): out of memory\n", path);
        fclose(f);
        return 0;
    }

    if (fread(buf, 1, fsize, f) != (size_t)fsize) {
        fprintf(stderr, "elf_load(%s): read error\n", path);
        free(buf);
        fclose(f);
        return 0;
    }
    fclose(f);

    entry = elf_parse(buf, (size_t)fsize, path, write, ctx);
    free(buf);
    return entry;
}

uint32_t
elf_load_fd(int fd, const char *name, elf_write_fn write, void *ctx)
{
    struct stat st;
    uint8_t *buf;
    ssize_t nread;
    size_t total, fsize;
    uint32_t entry;

    if (fstat(fd, &st) < 0) {
        fprintf(stderr, "elf_load(%s): fstat failed\n", name);
        return 0;
    }

    fsize = (size_t)st.st_size;
    buf = malloc(fsize);
    if (!buf) {
        fprintf(stderr, "elf_load(%s): out of memory\n", name);
        return 0;
    }

    total = 0;
    while (total < fsize) {
        nread = read(fd, buf + total, fsize - total);
        if (nread <= 0) {
            fprintf(stderr, "elf_load(%s): read error\n", name);
            free(buf);
            return 0;
        }
        total += (size_t)nread;
    }

    entry = elf_parse(buf, fsize, name, write, ctx);
    free(buf);
    return entry;
}
