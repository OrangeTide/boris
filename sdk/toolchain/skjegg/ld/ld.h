/* ld.h : static linker for ELF32 big-endian (ColdFire/m68k) — shared types */

#ifndef LD_H
#define LD_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#include "arena.h"
#include "mapfile.h"
#include "util.h"

/****************************************************************
 * ELF constants
 ****************************************************************/

#define ELFCLASS32      1
#define ELFDATA2MSB     2
#define EV_CURRENT      1

#define ET_REL          1
#define ET_EXEC         2
#define EM_68K          4

#define SHT_NULL        0
#define SHT_PROGBITS    1
#define SHT_SYMTAB      2
#define SHT_STRTAB      3
#define SHT_RELA        4
#define SHT_NOBITS      8

#define SHF_WRITE       0x1
#define SHF_ALLOC       0x2
#define SHF_EXECINSTR   0x4

#define STB_LOCAL       0
#define STB_GLOBAL      1

#define STT_NOTYPE      0
#define STT_SECTION     3

#define SHN_UNDEF       0
#define SHN_ABS         0xFFF1

#define PT_LOAD         1

#define PF_X            0x1
#define PF_W            0x2
#define PF_R            0x4

#define R_68K_32        1
#define R_68K_PC32      4
#define R_68K_PC16      5

#define ELF32_ST_BIND(i)    ((i) >> 4)
#define ELF32_ST_TYPE(i)    ((i) & 0xF)
#define ELF32_ST_INFO(b,t)  (((b) << 4) | ((t) & 0xF))
#define ELF32_R_SYM(i)      ((i) >> 8)
#define ELF32_R_TYPE(i)     ((i) & 0xFF)

/****************************************************************
 * Input object
 ****************************************************************/

struct ld_input_sec {
    const char *name;
    int type;
    uint32_t flags;
    const uint8_t *data;
    uint32_t size;
    uint32_t align;
    uint32_t assigned_vaddr;
    int matched;
};

struct ld_reloc {
    uint32_t offset;
    int sym_idx;
    int32_t addend;
    int type;
    int section;
};

struct ld_input_sym {
    const char *name;
    uint32_t value;
    int shndx;
    int binding;
    int type;
};

struct ld_object {
    const char *path;
    struct mapfile mf;
    struct ld_input_sec *sections;
    int nsections;
    struct ld_input_sym *syms;
    int nsyms;
    struct ld_reloc *relocs;
    int nrelocs;
    int reloc_cap;
    int *sym_map;
};

/****************************************************************
 * Global symbol table
 ****************************************************************/

struct ld_symbol {
    const char *name;
    uint32_t value;
    int defined;
    int obj_idx;
    int sec_idx;
};

/****************************************************************
 * Linker script
 ****************************************************************/

#define MAX_PATTERNS    16
#define MAX_ASSIGNS     16
#define MAX_REGIONS     8
#define MAX_PHDRS       8
#define MAX_OUT_SECS    16

struct sec_pattern {
    const char *name;
    int wildcard;
};

struct sym_assign {
    const char *name;
    int before_inputs;
    int after_pattern;
};

struct ld_output_sec {
    const char *name;
    int discard;
    int nobits;
    uint32_t vaddr;
    uint32_t size;
    uint8_t *data;
    int data_cap;
    const char *region;
    const char *phdr;
    struct sec_pattern patterns[MAX_PATTERNS];
    int npatterns;
    struct sym_assign assigns[MAX_ASSIGNS];
    int nassigns;
};

struct ld_mem_region {
    const char *name;
    uint32_t origin;
    uint32_t length;
    uint32_t flags;
    uint32_t cursor;
};

struct ld_phdr {
    const char *name;
    uint32_t type;
    uint32_t flags;
};

struct ld_script {
    const char *output_format;
    const char *output_arch;
    const char *entry;
    struct ld_mem_region regions[MAX_REGIONS];
    int nregions;
    struct ld_phdr phdrs[MAX_PHDRS];
    int nphdrs;
    struct ld_output_sec sections[MAX_OUT_SECS];
    int nsections;
};

/****************************************************************
 * Linker state
 ****************************************************************/

struct linker {
    struct ld_object *objs;
    int nobjs;
    struct ld_symbol *syms;
    int nsyms;
    int sym_cap;
    struct ld_script script;
    uint32_t entry_vaddr;
    struct arena arena;
};

/****************************************************************
 * Public API
 ****************************************************************/

/* elf_read.c */
int ld_read_object(struct arena *a, struct ld_object *obj, const char *path);

/* script.c */
void ld_parse_script(struct arena *a, struct ld_script *script, const char *src);
void ld_default_script(struct arena *a, struct ld_script *script);

/* link.c */
int ld_link(struct linker *ld);
/* shared layout core used by both the m68k and RISC-V linkers */
void ld_layout(struct linker *ld);
/* append a zeroed object slot, growing the object array (arena-backed) */
struct ld_object *ld_add_object(struct linker *ld);
struct ld_output_sec *ld_find_output_sec(struct linker *ld,
                                         struct ld_input_sec *isec);
void ld_check_undefined(struct linker *ld);

/* elf_write.c */
int ld_write_exec(struct linker *ld, const char *path);

/* linker lifecycle */
void ld_free(struct linker *ld);

#endif /* LD_H */
