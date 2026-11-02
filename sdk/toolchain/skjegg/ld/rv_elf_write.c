/* rv_elf_write.c : ELF32 little-endian RISC-V executable writer */

#include "rv_ld.h"

#include <stdlib.h>
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

    /* Non-alloc debug sections ride after the loadable ones: real file bytes,
       no vaddr, so they are not part of any program header. */
    struct {
        int dbg_idx;
        uint32_t file_off;
        uint32_t shname_off;
    } debug_map[MAX_DEBUG_SECS];
    int ndmap = 0;

    for (int k = 0; k < ld->ndebug; k++) {
        if (ld->debug[k].size == 0)
            continue;
        debug_map[ndmap].dbg_idx = k;
        debug_map[ndmap].file_off = file_offset;
        size_t nlen = strlen(ld->debug[k].name) + 1;
        debug_map[ndmap].shname_off = (uint32_t)shstrtab_len;
        memcpy(shstrtab + shstrtab_len, ld->debug[k].name, nlen);
        shstrtab_len += (int)nlen;
        file_offset += ld->debug[k].size;
        ndmap++;
    }

    /* Re-emit a .symtab (+ its .strtab): the defined functions (STT_FUNC, local
       statics and globals) and defined global symbols, with final addresses and
       sizes, so addr2line -f and a backtrace resolve names.  ELF orders local
       symbols before global ones, and sh_info names the first global. */
    int *symsel = xmalloc((size_t)(ld->nsyms + 1) * sizeof(int));
    int nsymsel = 0, nlocal = 0;
    size_t symstr_cap = 1;
    for (int pass = 0; pass < 2; pass++) {
        for (int s = 0; s < ld->nsyms; s++) {
            struct ld_symbol *g = &ld->syms[s];
            if (!g->defined || g->name[0] == '\0')
                continue;
            if (g->type != STT_FUNC && g->binding != STB_GLOBAL)
                continue;
            if ((g->binding == STB_LOCAL) != (pass == 0))
                continue;
            symsel[nsymsel++] = s;
            symstr_cap += strlen(g->name) + 1;
        }
        if (pass == 0)
            nlocal = nsymsel;
    }
    int first_global = 1 + nlocal;      /* the null symbol at index 0 is local */

    char *symstr = xmalloc(symstr_cap);
    int symstr_len = 0;
    symstr[symstr_len++] = '\0';
    uint32_t symtab_size = (uint32_t)(1 + nsymsel) * 16;
    uint8_t *symtab = xmalloc(symtab_size);
    memset(symtab, 0, symtab_size);     /* entry 0 is the null symbol */
    for (int i = 0; i < nsymsel; i++) {
        struct ld_symbol *g = &ld->syms[symsel[i]];
        uint8_t *e = symtab + (uint32_t)(i + 1) * 16;
        uint16_t shndx = SHN_ABS;
        size_t nlen = strlen(g->name) + 1;
        for (int m = 0; m < nmap; m++) {
            struct ld_output_sec *os = &sc->sections[alloc_map[m].sec_idx];
            if (g->value >= os->vaddr && g->value < os->vaddr + os->size) {
                shndx = (uint16_t)(1 + m);      /* section 0 is the null shdr */
                break;
            }
        }
        put32(e + 0, (uint32_t)symstr_len);
        memcpy(symstr + symstr_len, g->name, nlen);
        symstr_len += (int)nlen;
        put32(e + 4, g->value);
        put32(e + 8, g->size);
        e[12] = (uint8_t)ELF32_ST_INFO(g->binding, g->type);
        e[13] = 0;
        put16(e + 14, shndx);
    }

    uint32_t symtab_name_off = (uint32_t)shstrtab_len;
    {
        const char *nm = ".symtab";
        size_t nlen = strlen(nm) + 1;
        memcpy(shstrtab + shstrtab_len, nm, nlen);
        shstrtab_len += (int)nlen;
    }
    uint32_t strtab_name_off = (uint32_t)shstrtab_len;
    {
        const char *nm = ".strtab";
        size_t nlen = strlen(nm) + 1;
        memcpy(shstrtab + shstrtab_len, nm, nlen);
        shstrtab_len += (int)nlen;
    }

    int shnum = 1 + nalloc + ndmap + 3;   /* +.symtab +.strtab +.shstrtab */
    int strtab_shndx = 1 + nalloc + ndmap + 1;  /* .strtab follows .symtab */

    uint32_t shstrtab_name_off = (uint32_t)shstrtab_len;
    {
        const char *nm = ".shstrtab";
        size_t nlen = strlen(nm) + 1;
        memcpy(shstrtab + shstrtab_len, nm, nlen);
        shstrtab_len += (int)nlen;
    }

    uint32_t symtab_file_off = file_offset;
    file_offset += symtab_size;
    uint32_t symstr_file_off = file_offset;
    file_offset += (uint32_t)symstr_len;
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

    for (int i = 0; i < ndmap; i++)
        fwrite(ld->debug[debug_map[i].dbg_idx].data, 1,
               ld->debug[debug_map[i].dbg_idx].size, f);

    fwrite(symtab, 1, symtab_size, f);
    fwrite(symstr, 1, (size_t)symstr_len, f);

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

    for (int i = 0; i < ndmap; i++) {
        struct ld_debug_sec *d = &ld->debug[debug_map[i].dbg_idx];
        uint8_t sh[40];
        memset(sh, 0, sizeof(sh));
        put32(sh + 0, debug_map[i].shname_off);
        put32(sh + 4, SHT_PROGBITS);    /* non-alloc: flags 0, vaddr 0 */
        put32(sh + 16, debug_map[i].file_off);
        put32(sh + 20, d->size);
        put32(sh + 32, 1);              /* byte-aligned */
        fwrite(sh, 1, 40, f);
    }

    {
        uint8_t sh[40];                 /* .symtab */
        memset(sh, 0, sizeof(sh));
        put32(sh + 0, symtab_name_off);
        put32(sh + 4, SHT_SYMTAB);
        put32(sh + 16, symtab_file_off);
        put32(sh + 20, symtab_size);
        put32(sh + 24, (uint32_t)strtab_shndx);     /* sh_link = .strtab */
        put32(sh + 28, (uint32_t)first_global);     /* sh_info = 1st global */
        put32(sh + 32, 4);
        put32(sh + 36, 16);                         /* entsize */
        fwrite(sh, 1, 40, f);
    }

    {
        uint8_t sh[40];                 /* .strtab (symbol names) */
        memset(sh, 0, sizeof(sh));
        put32(sh + 0, strtab_name_off);
        put32(sh + 4, SHT_STRTAB);
        put32(sh + 16, symstr_file_off);
        put32(sh + 20, (uint32_t)symstr_len);
        put32(sh + 32, 1);
        fwrite(sh, 1, 40, f);
    }

    {
        uint8_t sh[40];                 /* .shstrtab */
        memset(sh, 0, sizeof(sh));
        put32(sh + 0, shstrtab_name_off);
        put32(sh + 4, SHT_STRTAB);
        put32(sh + 16, shstrtab_file_off);
        put32(sh + 20, (uint32_t)shstrtab_len);
        put32(sh + 32, 1);
        fwrite(sh, 1, 40, f);
    }

    free(symsel);
    free(symstr);
    free(symtab);
    fclose(f);
    chmod(path, 0755);
    return 0;
}
