/* elf32.h : ELF32 loader for the guest machines, either endianness */

#ifndef ELF32_H
#define ELF32_H

#include <stdint.h>
#include "guest.h"

#define EM_68K      4
#define EM_MIPS     8
#define EM_RISCV    243

typedef struct elf32_info {
    uint32_t entry;
    uint32_t machine;           /* EM_68K, EM_RISCV, ... */
    int big_endian;
    uint32_t lo;                /* lowest mapped address */
    uint32_t hi;                /* one past the highest mapped address */
    int nsegments;
} elf32_info;

/* Read the file's header only.  Returns 0 on success, -1 with a message
 * on stderr otherwise.  Used to pick an architecture before a machine
 * exists. */
int elf32_probe(const char *path, elf32_info *info);

/* Load every PT_LOAD segment into g's memory, mapping a region per
 * segment.  Returns 0 on success, -1 on failure. */
int elf32_load(guest *g, const char *path, elf32_info *info);

/* The same walk against a plain byte-write callback, for a machine that
 * keeps its own memory rather than the sparse guest one (the arch-test
 * harness has a flat RAM and its own devices).  Returns the entry point,
 * or 0 on failure. */
typedef void (*elf32_poke_fn)(void *ctx, uint32_t addr, uint8_t byte);

uint32_t elf32_load_raw(const char *path, elf32_poke_fn poke, void *ctx,
                        elf32_info *info);

/* Address of a symbol, or 0 when absent. */
uint32_t elf32_symbol(const char *path, const char *name);

/* The same three operations against an in-memory image rather than a file:
 * a buffer of `size` bytes the caller owns.  `what` names the image in any
 * diagnostic (the file variants pass the path).  These are what a memory
 * region loader (spawn_image, a VFS blob) reaches for; the path variants are
 * thin wrappers that read the file into a buffer and call these. */
int elf32_probe_mem(const uint8_t *buf, long size, elf32_info *info);
int elf32_load_mem(guest *g, const uint8_t *buf, long size, elf32_info *info,
                   const char *what);
uint32_t elf32_symbol_mem(const uint8_t *buf, long size, const char *name);

#endif /* ELF32_H */
