/* rv_elf_write.c : ELF32 little-endian RISC-V executable writer */

#include "rv_ld.h"

#include <string.h>
#include <sys/stat.h>

static void
put16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static void
put32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

int
rv_ld_write_exec(struct linker *ld, const char *path)
{
    struct ld_script *sc = &ld->script;
    FILE *f;
    int nalloc = 0;

    for (int i = 0; i < sc->nsections; i++) {
        if (!sc->sections[i].discard && sc->sections[i].size > 0)
            nalloc++;
    }

    int nphdrs = sc->nphdrs;
    if (nphdrs == 0)
        nphdrs = 1;

    uint32_t ehdr_size = 52;
    uint32_t phdr_size = (uint32_t)nphdrs * 32;
    uint32_t headers_size = ehdr_size + phdr_size;
    uint32_t file_offset = headers_size;

    char shstrtab[512];
    int shstrtab_len = 0;
    shstrtab[shstrtab_len++] = '\0';

    int shnum = 1 + nalloc + 1;

    struct {
        int sec_idx;
        uint32_t file_off;
        uint32_t shname_off;
    } alloc_map[MAX_OUT_SECS];
    int nmap = 0;

    for (int i = 0; i < sc->nsections; i++) {
        struct ld_output_sec *os = &sc->sections[i];
        if (os->discard || os->size == 0)
            continue;
        alloc_map[nmap].sec_idx = i;
        alloc_map[nmap].file_off = os->nobits ? 0 : file_offset;
        size_t nlen = strlen(os->name) + 1;
        alloc_map[nmap].shname_off = (uint32_t)shstrtab_len;
        memcpy(shstrtab + shstrtab_len, os->name, nlen);
        shstrtab_len += (int)nlen;
        if (!os->nobits)
            file_offset += os->size;
        nmap++;
    }

    uint32_t shstrtab_name_off = (uint32_t)shstrtab_len;
    {
        const char *nm = ".shstrtab";
        size_t nlen = strlen(nm) + 1;
        memcpy(shstrtab + shstrtab_len, nm, nlen);
        shstrtab_len += (int)nlen;
    }

    uint32_t shstrtab_file_off = file_offset;
    file_offset += (uint32_t)shstrtab_len;
    uint32_t shoff = file_offset;

    uint32_t load_vaddr = sc->nregions > 0 ?
        sc->regions[0].origin : 0x00010000;
    uint32_t load_end = 0, load_filesz = 0, load_memsz = 0;

    for (int i = 0; i < sc->nsections; i++) {
        struct ld_output_sec *os = &sc->sections[i];
        if (os->discard || os->size == 0)
            continue;
        uint32_t end = os->vaddr + os->size;
        if (end > load_end)
            load_end = end;
    }
    load_memsz = load_end - load_vaddr;

    for (int i = 0; i < nmap; i++) {
        struct ld_output_sec *os = &sc->sections[alloc_map[i].sec_idx];
        if (!os->nobits) {
            uint32_t end = alloc_map[i].file_off + os->size;
            if (end > load_filesz)
                load_filesz = end;
        }
    }

    f = fopen(path, "wb");
    if (!f)
        die("cannot create %s", path);

    uint8_t ehdr[52];
    memset(ehdr, 0, sizeof(ehdr));
    memcpy(ehdr, "\177ELF", 4);
    ehdr[4] = ELFCLASS32;
    ehdr[5] = ELFDATA2LSB;
    ehdr[6] = EV_CURRENT;
    put16(ehdr + 16, ET_EXEC);
    put16(ehdr + 18, EM_RISCV);
    put32(ehdr + 20, EV_CURRENT);
    put32(ehdr + 24, ld->entry_vaddr);
    put32(ehdr + 28, ehdr_size);
    put32(ehdr + 32, shoff);
    put32(ehdr + 36, 0);            /* e_flags: ilp32 soft-float, no RVC */
    put16(ehdr + 40, 52);
    put16(ehdr + 42, 32);
    put16(ehdr + 44, (uint16_t)nphdrs);
    put16(ehdr + 46, 40);
    put16(ehdr + 48, (uint16_t)shnum);
    put16(ehdr + 50, (uint16_t)(shnum - 1));
    fwrite(ehdr, 1, 52, f);

    for (int i = 0; i < nphdrs; i++) {
        uint8_t phdr[32];
        uint32_t flags = sc->nphdrs > 0 ? sc->phdrs[i].flags
                                        : (uint32_t)(PF_R | PF_W | PF_X);
        uint32_t type = sc->nphdrs > 0 ? sc->phdrs[i].type
                                       : (uint32_t)PT_LOAD;
        memset(phdr, 0, sizeof(phdr));
        put32(phdr + 0, type);
        put32(phdr + 4, 0);
        put32(phdr + 8, load_vaddr);
        put32(phdr + 12, load_vaddr);
        put32(phdr + 16, load_filesz);
        put32(phdr + 20, load_memsz);
        put32(phdr + 24, flags);
        put32(phdr + 28, 0x1000);
        fwrite(phdr, 1, 32, f);
    }

    for (int i = 0; i < nmap; i++) {
        struct ld_output_sec *os = &sc->sections[alloc_map[i].sec_idx];
        if (os->nobits)
            continue;
        fwrite(os->data, 1, os->size, f);
    }

    fwrite(shstrtab, 1, (size_t)shstrtab_len, f);

    {
        uint8_t null_sh[40];
        memset(null_sh, 0, sizeof(null_sh));
        fwrite(null_sh, 1, 40, f);
    }

    for (int i = 0; i < nmap; i++) {
        struct ld_output_sec *os = &sc->sections[alloc_map[i].sec_idx];
        uint8_t sh[40];
        uint32_t sflags = SHF_ALLOC;
        memset(sh, 0, sizeof(sh));
        put32(sh + 0, alloc_map[i].shname_off);
        put32(sh + 4, os->nobits ? SHT_NOBITS : SHT_PROGBITS);
        if (strstr(os->name, ".text"))
            sflags |= SHF_EXECINSTR;
        if (strstr(os->name, ".data") || strstr(os->name, ".bss"))
            sflags |= SHF_WRITE;
        put32(sh + 8, sflags);
        put32(sh + 12, os->vaddr);
        put32(sh + 16, os->nobits ? 0 : alloc_map[i].file_off);
        put32(sh + 20, os->size);
        put32(sh + 32, 4);
        fwrite(sh, 1, 40, f);
    }

    {
        uint8_t sh[40];
        memset(sh, 0, sizeof(sh));
        put32(sh + 0, shstrtab_name_off);
        put32(sh + 4, SHT_STRTAB);
        put32(sh + 16, shstrtab_file_off);
        put32(sh + 20, (uint32_t)shstrtab_len);
        put32(sh + 32, 1);
        fwrite(sh, 1, 40, f);
    }

    fclose(f);
    chmod(path, 0755);
    return 0;
}
