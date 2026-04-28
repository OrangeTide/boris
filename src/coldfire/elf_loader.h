/* elf_loader.h : minimal ELF32 big-endian loader for ColdFire binaries */
/* Copyright (c) 2026 Jon Mayo -- MIT-0 OR Public Domain */
/* Written with AI assistance (Claude, Anthropic) */

#ifndef ELF_LOADER_H
#define ELF_LOADER_H

#include <stdint.h>

/* Load an ELF32 big-endian executable into memory via write callback.
 * Returns entry point address on success, 0 on failure.
 * The write_fn is called for each byte of loadable segment data. */
typedef void (*elf_write_fn)(void *ctx, uint32_t addr, uint8_t byte);

uint32_t elf_load(const char *path, elf_write_fn write, void *ctx);
uint32_t elf_load_fd(int fd, const char *name, elf_write_fn write, void *ctx);

#endif /* ELF_LOADER_H */
