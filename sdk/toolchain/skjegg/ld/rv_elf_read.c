/* rv_elf_read.c : ELF32 little-endian RISC-V relocatable object reader */

#include "rv_ld.h"

#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Little-endian read helpers
 ****************************************************************/

static uint16_t
get16(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}

static uint32_t
get32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static int32_t
get32s(const uint8_t *p)
{
    return (int32_t)get32(p);
}

static const uint8_t *
shdr_at(const uint8_t *buf, uint32_t shoff, int idx)
{
    return buf + shoff + (uint32_t)idx * 40;
}

/****************************************************************
 * Reader
 ****************************************************************/

/* Parse an ELF32 LE RISC-V relocatable object out of an in-memory buffer.
 * Used both for a mapped file (rv_ld_read_object) and for an archive member,
 * whose bytes live in an arena copy; it never touches obj->mf. */
int
rv_parse_elf(struct arena *a, struct ld_object *obj, const uint8_t *buf,
             size_t fsize, const char *path)
{
    uint32_t shoff;
    int shnum, shstrndx;
    const uint8_t *shstrtab_hdr;
    const char *shstrtab;
    int i;
    int symtab_idx = -1;

    obj->path = path;

    if (fsize < 52)
        die("%s: too small for ELF header", path);
    if (memcmp(buf, "\177ELF", 4) != 0)
        die("%s: not an ELF file", path);
    if (buf[4] != ELFCLASS32)
        die("%s: not ELF32", path);
    if (buf[5] != ELFDATA2LSB)
        die("%s: not little-endian", path);
    if (get16(buf + 16) != ET_REL)
        die("%s: not a relocatable object", path);
    if (get16(buf + 18) != EM_RISCV)
        die("%s: not RISC-V", path);

    shoff = get32(buf + 32);
    shnum = get16(buf + 48);
    shstrndx = get16(buf + 50);

    if (shstrndx >= shnum)
        die("%s: bad shstrndx", path);

    shstrtab_hdr = shdr_at(buf, shoff, shstrndx);
    shstrtab = (const char *)buf + get32(shstrtab_hdr + 16);

    obj->nsections = shnum;
    obj->sections = arena_zalloc(a, (size_t)shnum * sizeof(struct ld_input_sec));
    obj->relocs = NULL;
    obj->nrelocs = 0;
    obj->reloc_cap = 0;
    obj->syms = NULL;
    obj->nsyms = 0;

    for (i = 0; i < shnum; i++) {
        const uint8_t *sh = shdr_at(buf, shoff, i);
        uint32_t sh_name = get32(sh + 0);
        uint32_t sh_type = get32(sh + 4);
        uint32_t sh_flags = get32(sh + 8);
        uint32_t sh_offset = get32(sh + 16);
        uint32_t sh_size = get32(sh + 20);
        uint32_t sh_addralign = get32(sh + 32);

        obj->sections[i].name = shstrtab + sh_name;
        obj->sections[i].type = (int)sh_type;
        obj->sections[i].flags = sh_flags;
        obj->sections[i].size = sh_size;
        obj->sections[i].align = sh_addralign ? sh_addralign : 1;
        obj->sections[i].assigned_vaddr = 0;
        obj->sections[i].matched = 0;

        if (sh_type == SHT_PROGBITS || sh_type == SHT_NOBITS) {
            if (sh_type == SHT_PROGBITS && sh_size > 0)
                obj->sections[i].data = buf + sh_offset;
            else
                obj->sections[i].data = NULL;
        }

        if (sh_type == SHT_SYMTAB)
            symtab_idx = i;
    }

    if (symtab_idx < 0)
        die("%s: no symbol table", path);

    {
        const uint8_t *symsh = shdr_at(buf, shoff, symtab_idx);
        uint32_t sym_off = get32(symsh + 16);
        uint32_t sym_size = get32(symsh + 20);
        int link = (int)get32(symsh + 24);
        int count = (int)(sym_size / 16);
        const uint8_t *strtab_sh = shdr_at(buf, shoff, link);
        const char *strtab = (const char *)buf + get32(strtab_sh + 16);

        obj->nsyms = count;
        obj->syms = arena_zalloc(a, (size_t)count * sizeof(struct ld_input_sym));

        for (i = 0; i < count; i++) {
            const uint8_t *s = buf + sym_off + (uint32_t)i * 16;
            uint32_t st_name = get32(s + 0);
            uint32_t st_value = get32(s + 4);
            uint8_t st_info = s[12];
            uint16_t st_shndx = get16(s + 14);

            obj->syms[i].name = strtab + st_name;
            obj->syms[i].value = st_value;
            obj->syms[i].shndx = (int)st_shndx;
            obj->syms[i].binding = ELF32_ST_BIND(st_info);
            obj->syms[i].type = ELF32_ST_TYPE(st_info);
        }
    }

    for (i = 0; i < shnum; i++) {
        const uint8_t *sh = shdr_at(buf, shoff, i);
        uint32_t sh_type = get32(sh + 4);
        uint32_t rela_off, rela_size;
        int info_sec, count;

        if (sh_type != SHT_RELA)
            continue;

        rela_off = get32(sh + 16);
        rela_size = get32(sh + 20);
        info_sec = (int)get32(sh + 28);
        count = (int)(rela_size / 12);

        int need = obj->nrelocs + count;
        if (need > obj->reloc_cap) {
            obj->reloc_cap = need * 2;
            obj->relocs = realloc(obj->relocs,
                                  (size_t)obj->reloc_cap *
                                  sizeof(struct ld_reloc));
            if (!obj->relocs)
                die("out of memory");
        }

        for (int j = 0; j < count; j++) {
            const uint8_t *r = buf + rela_off + (uint32_t)j * 12;
            struct ld_reloc *rel = &obj->relocs[obj->nrelocs++];
            uint32_t r_info = get32(r + 4);

            rel->offset = get32(r + 0);
            rel->sym_idx = (int)ELF32_R_SYM(r_info);
            rel->type = (int)ELF32_R_TYPE(r_info);
            rel->addend = get32s(r + 8);
            rel->section = info_sec;
        }
    }

    return 0;
}

int
rv_ld_read_object(struct arena *a, struct ld_object *obj, const char *path)
{
    if (mapfile_open(&obj->mf, path) != OK)
        die("cannot open %s", path);
    return rv_parse_elf(a, obj, obj->mf.data, obj->mf.len, path);
}
