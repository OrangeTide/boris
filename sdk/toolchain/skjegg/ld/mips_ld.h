/* mips_ld.h : MIPS I static linker, constants and entry points.
 *
 * Reuses the arch-neutral structures and the shared layout core from ld.h
 * (ld_layout / ld_find_output_sec / ld_check_undefined / ld_free) plus the
 * script parser and mapfile reader.  Only the ELF byte order, machine id and
 * the relocation set differ, and they live here.  MIPS uses the REL form (the
 * addend rides in the relocated field, not the relocation entry), and the
 * HI16/LO16 pair combine their addends the way the o32 ABI specifies. */

#ifndef MIPS_LD_H
#define MIPS_LD_H

#include "ld.h"

#define ELFDATA2LSB   1
#define EM_MIPS       8
#define SHT_REL       9

enum {
    R_MIPS_NONE = 0,
    R_MIPS_16 = 1,
    R_MIPS_32 = 2,
    R_MIPS_26 = 4,
    R_MIPS_HI16 = 5,
    R_MIPS_LO16 = 6,
    R_MIPS_PC16 = 10,
};

/* mips_elf_read.c */
int mips_ld_read_object(struct arena *a, struct ld_object *obj,
                        const char *path);
int mips_parse_elf(struct arena *a, struct ld_object *obj, const uint8_t *buf,
                   size_t fsize, const char *path);

/* mips_link.c */
int mips_ld_link(struct linker *ld);

/* mips_elf_write.c */
int mips_ld_write_exec(struct linker *ld, const char *path);

/* mips_psexe_write.c: the PlayStation "PS-X EXE" writer */
int mips_ld_write_psexe(struct linker *ld, const char *path);

/* mips_link.c: the built-in scripts (Linux text base 0x00400000, and the
 * PlayStation RAM base 0x80010000 for the PS-EXE output) */
void mips_default_script(struct arena *a, struct ld_script *script);
void mips_default_psx_script(struct arena *a, struct ld_script *script);

/* mips_archive.c: ar(1) archive support */
int mips_ld_is_archive(const char *path);
/* pull members that resolve still-undefined symbols; returns how many members
 * were added (a caller loops over archives while any still pulls members) */
int mips_ld_read_archive(struct linker *ld, const char *path);
void mips_ld_archive_reset(void);

#endif /* MIPS_LD_H */
