/* elf32.h : ELF32 loader for the guest machines, either endianness
 * SPDX-License-Identifier: 0BSD OR CC0-1.0
 * Copyright 2026 Jon Mayo
 */

#ifndef ELF32_H
#define ELF32_H

#include <stdint.h>

#define EM_RISCV    243

typedef struct elf32_info {
    uint32_t entry;
    uint32_t machine;           /* EM_RISCV, ... */
    int big_endian;
    uint32_t lo;                /* lowest mapped address */
    uint32_t hi;                /* one past the highest mapped address */
    int nsegments;
} elf32_info;

/* Read the file's header only.  Returns 0 on success, -1 with a message
 * on stderr otherwise.  Used to pick an architecture before a machine
 * exists. */
int elf32_probe(const char *path, elf32_info *info);
int elf32_probe_mem(const uint8_t *buf, long size, elf32_info *info);

/* Walk the PT_LOAD segments against a plain byte-write callback, so the
 * host keeps its own memory rather than the sparse guest one.  The mem
 * variant loads an in-memory image the caller owns; `what` names it in any
 * diagnostic.  The path variant reads the file into a buffer and calls it.
 * Both return the entry point, or 0 on failure. */
typedef void (*elf32_poke_fn)(void *ctx, uint32_t addr, uint8_t byte);

uint32_t elf32_load_raw(const char *path, elf32_poke_fn poke, void *ctx,
                        elf32_info *info);
uint32_t elf32_load_raw_mem(const uint8_t *buf, long size, elf32_poke_fn poke,
                            void *ctx, const char *what, elf32_info *info);

/* Address of a symbol, or 0 when absent. */
uint32_t elf32_symbol(const char *path, const char *name);
uint32_t elf32_symbol_mem(const uint8_t *buf, long size, const char *name);

/* Locate a named section's bytes within the file image and return a pointer
 * into buf, with its length in len_out.  This is for host-read metadata that
 * never enters guest memory, such as the host-call import table.  Returns
 * NULL when the section is absent, malformed, or runs past the file. */
const uint8_t *elf32_section_mem(const uint8_t *buf, long size,
                                 const char *name, uint32_t *len_out);

#endif /* ELF32_H */
