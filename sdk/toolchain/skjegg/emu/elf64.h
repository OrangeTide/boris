/* elf64.h : ELF64 loader for the hardware-virtualization guests */

#ifndef ELF64_H
#define ELF64_H

#include <stdint.h>
#include "guest.h"
#include "elf32.h"       /* elf32_info, reused: HV guests live under 4 GiB */

#define EM_X86_64   62
#define EM_AARCH64  183

/* Read the header only, filling info (entry/machine/endianness).  Returns 0 on
 * success, -1 with a message on stderr otherwise. */
int elf64_probe(const char *path, elf32_info *info);

/* Load every PT_LOAD segment into g's memory by p_vaddr.  The guest image lies
 * under 4 GiB, so the 32-bit fields of elf32_info address it.  Returns 0 on
 * success, -1 on failure. */
int elf64_load(guest *g, const char *path, elf32_info *info);

/* The same against an in-memory image the caller owns. */
int elf64_probe_mem(const uint8_t *buf, long size, elf32_info *info);
int elf64_load_mem(guest *g, const uint8_t *buf, long size, elf32_info *info,
                   const char *what);

/* Load every PT_LOAD segment of an ELF64 image into a freshly allocated flat
 * host buffer laid out at the segments' guest addresses (the ELF64 analogue of
 * elf32_load_raw's two-pass buffer build).  Sets *buf (caller frees), *lo (the
 * lowest page address) and *size (the page-rounded span).  Used to build the
 * shared LP64 vDSO image the HV guests map read-only.  Returns 0 or -1. */
int elf64_load_flat(const char *path, uint8_t **buf, uint32_t *lo,
                    uint32_t *size);

/* Resolve a global symbol's value from an in-memory ELF64 image (the ELF64
 * analogue of elf32_symbol_mem).  The HV guest lives under 4 GiB, so the value
 * is returned as a 32-bit address; 0 means not found. */
uint32_t elf64_symbol_mem(const uint8_t *buf, long size, const char *name);
uint32_t elf64_symbol(const char *path, const char *name);

#endif /* ELF64_H */
