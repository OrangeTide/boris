/* rv_ld.h : RISC-V RV32 static linker — constants and entry points.
 *
 * Reuses the arch-neutral structures and the shared layout core from ld.h
 * (ld_layout / ld_find_output_sec / ld_check_undefined / ld_free) plus the
 * script parser and mapfile reader.  Only the ELF byte order, machine id and
 * the relocation set differ, and they live here. */

#ifndef RV_LD_H
#define RV_LD_H

#include "ld.h"

#define ELFDATA2LSB   1
#define EM_RISCV      243

enum {
    R_RISCV_NONE = 0,
    R_RISCV_32 = 1,
    R_RISCV_BRANCH = 16,
    R_RISCV_JAL = 17,
    R_RISCV_CALL = 18,
    R_RISCV_CALL_PLT = 19,
    R_RISCV_GOT_HI20 = 20,
    R_RISCV_PCREL_HI20 = 23,
    R_RISCV_PCREL_LO12_I = 24,
    R_RISCV_PCREL_LO12_S = 25,
    R_RISCV_HI20 = 26,
    R_RISCV_LO12_I = 27,
    R_RISCV_LO12_S = 28,
    R_RISCV_ADD32 = 35,
    R_RISCV_SUB32 = 39,
    R_RISCV_RELAX = 51,
    R_RISCV_32_PCREL = 57,
};

/* rv_elf_read.c */
int rv_ld_read_object(struct arena *a, struct ld_object *obj, const char *path);
int rv_parse_elf(struct arena *a, struct ld_object *obj, const uint8_t *buf,
                 size_t fsize, const char *path);

/* rv_archive.c: ar(1) archive support */
int rv_ld_is_archive(const char *path);
/* pull the members that resolve currently-undefined symbols; returns how many
 * were added (a caller loops over archives while any still pulls members) */
int rv_ld_read_archive(struct linker *ld, const char *path);
/* clear the loaded-member set before a link (leaves no state between links) */
void rv_ld_archive_reset(void);

/* rv_link.c */
int rv_ld_link(struct linker *ld);

/* rv_elf_write.c */
int rv_ld_write_exec(struct linker *ld, const char *path);

/* rv_main.c / rv_link.c: the built-in RV32 user-mode script (base 0x10000) */
void rv_default_script(struct arena *a, struct ld_script *script);

#endif /* RV_LD_H */
