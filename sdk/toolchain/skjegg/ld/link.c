/* link.c : section merge, symbol resolution, relocation application */

#include "ld.h"

#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Big-endian write helpers
 ****************************************************************/

static void
put16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)(v >> 8);
    p[1] = (uint8_t)v;
}

static void
put32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v >> 24);
    p[1] = (uint8_t)(v >> 16);
    p[2] = (uint8_t)(v >> 8);
    p[3] = (uint8_t)v;
}

/****************************************************************
 * Symbol table
 ****************************************************************/

static int
sym_find(struct linker *ld, const char *name)
{
    for (int i = 0; i < ld->nsyms; i++) {
        if (strcmp(ld->syms[i].name, name) == 0)
            return i;
    }
    return -1;
}

static int
sym_add(struct linker *ld, const char *name, uint32_t value,
        int defined, int obj_idx, int sec_idx)
{
    if (ld->nsyms >= ld->sym_cap) {
        ld->sym_cap = ld->sym_cap ? ld->sym_cap * 2 : 64;
        ld->syms = realloc(ld->syms,
                           (size_t)ld->sym_cap * sizeof(struct ld_symbol));
        if (!ld->syms)
            die("out of memory");
    }

    int idx = ld->nsyms++;
    ld->syms[idx].name = name;
    ld->syms[idx].value = value;
    ld->syms[idx].defined = defined;
    ld->syms[idx].obj_idx = obj_idx;
    ld->syms[idx].sec_idx = sec_idx;
    return idx;
}

static void
collect_symbols(struct linker *ld)
{
    for (int oi = 0; oi < ld->nobjs; oi++) {
        struct ld_object *obj = &ld->objs[oi];
        obj->sym_map = arena_zalloc(&ld->arena,
                                    (size_t)obj->nsyms * sizeof(int));

        for (int si = 0; si < obj->nsyms; si++) {
            struct ld_input_sym *isym = &obj->syms[si];
            obj->sym_map[si] = -1;

            if (isym->binding == STB_LOCAL) {
                int gidx = sym_add(ld, isym->name, isym->value,
                                   isym->shndx != SHN_UNDEF, oi,
                                   isym->shndx);
                obj->sym_map[si] = gidx;
                continue;
            }

            int existing = sym_find(ld, isym->name);
            if (existing >= 0) {
                if (isym->shndx != SHN_UNDEF) {
                    if (ld->syms[existing].defined)
                        die("duplicate symbol: %s", isym->name);
                    ld->syms[existing].defined = 1;
                    ld->syms[existing].value = isym->value;
                    ld->syms[existing].obj_idx = oi;
                    ld->syms[existing].sec_idx = isym->shndx;
                }
                obj->sym_map[si] = existing;
            } else {
                int gidx = sym_add(ld, isym->name, isym->value,
                                   isym->shndx != SHN_UNDEF, oi,
                                   isym->shndx);
                obj->sym_map[si] = gidx;
            }
        }
    }
}

/****************************************************************
 * Section matching
 ****************************************************************/

static int
pattern_matches(const struct sec_pattern *pat, const char *name)
{
    if (strcmp(pat->name, "COMMON") == 0)
        return strcmp(name, "COMMON") == 0;

    if (pat->wildcard) {
        size_t plen = strlen(pat->name);
        if (strncmp(name, pat->name, plen) != 0)
            return 0;
        /* exact match or continues with '.' */
        return name[plen] == '\0' || name[plen] == '.';
    }

    return strcmp(pat->name, name) == 0;
}

/****************************************************************
 * Memory region lookup
 ****************************************************************/

static struct ld_mem_region *
find_region(struct ld_script *sc, const char *name)
{
    for (int i = 0; i < sc->nregions; i++) {
        if (strcmp(sc->regions[i].name, name) == 0)
            return &sc->regions[i];
    }
    die("unknown memory region: %s", name);
    return NULL;
}

static uint32_t
align_up(uint32_t v, uint32_t a)
{
    return (v + a - 1) & ~(a - 1);
}

/****************************************************************
 * Output section data management
 ****************************************************************/

static void
outsec_ensure(struct ld_output_sec *os, int need)
{
    if (need <= os->data_cap)
        return;
    os->data_cap = need * 2;
    os->data = realloc(os->data, (size_t)os->data_cap);
    if (!os->data)
        die("out of memory");
}

static void
outsec_append(struct ld_output_sec *os, const uint8_t *data,
              uint32_t size, uint32_t align)
{
    uint32_t abs_end = os->vaddr + os->size;
    uint32_t pad = align_up(abs_end, align) - abs_end;
    int need = (int)(os->size + pad + size);

    outsec_ensure(os, need);

    if (pad > 0)
        memset(os->data + os->size, 0, pad);
    os->size += pad;

    if (data)
        memcpy(os->data + os->size, data, size);
    else
        memset(os->data + os->size, 0, size);
    os->size += size;
}

/****************************************************************
 * Core linker
 ****************************************************************/

static void
process_assigns(struct linker *ld, struct ld_output_sec *os,
                int target_pattern, uint32_t cursor)
{
    for (int i = 0; i < os->nassigns; i++) {
        struct sym_assign *sa = &os->assigns[i];
        int match = 0;

        if (sa->before_inputs && target_pattern == 0)
            match = 1;
        else if (!sa->before_inputs && sa->after_pattern == target_pattern)
            match = 1;

        if (!match)
            continue;

        int existing = sym_find(ld, sa->name);
        if (existing >= 0) {
            ld->syms[existing].value = cursor;
            ld->syms[existing].defined = 1;
        } else {
            sym_add(ld, sa->name, cursor, 1, -1, -1);
        }
    }
}

/* Arch-neutral layout: symbol collection, section placement, final symbol
 * addresses and entry resolution.  Shared by the m68k and RISC-V linkers; the
 * relocation application that follows is target-specific. */
void
ld_layout(struct linker *ld)
{
    struct ld_script *sc = &ld->script;

    collect_symbols(ld);

    /* advance region cursors past ELF/phdr headers (included in segment) */
    int nphdrs = sc->nphdrs > 0 ? sc->nphdrs : 1;
    uint32_t headers_size = 52 + (uint32_t)nphdrs * 32;
    for (int i = 0; i < sc->nregions; i++)
        sc->regions[i].cursor = sc->regions[i].origin + headers_size;

    /* lay out sections */
    for (int si = 0; si < sc->nsections; si++) {
        struct ld_output_sec *os = &sc->sections[si];

        if (os->discard) {
            /* mark matched sections so they are skipped */
            for (int pi = 0; pi < os->npatterns; pi++) {
                for (int oi = 0; oi < ld->nobjs; oi++) {
                    struct ld_object *obj = &ld->objs[oi];
                    for (int s = 0; s < obj->nsections; s++) {
                        if (obj->sections[s].matched)
                            continue;
                        if (!(obj->sections[s].flags & SHF_ALLOC) &&
                            obj->sections[s].type != SHT_PROGBITS &&
                            obj->sections[s].type != SHT_NOBITS)
                            continue;
                        if (pattern_matches(&os->patterns[pi],
                                            obj->sections[s].name))
                            obj->sections[s].matched = 1;
                    }
                }
            }
            continue;
        }

        struct ld_mem_region *region = NULL;
        if (os->region)
            region = find_region(sc, os->region);

        if (region)
            os->vaddr = region->cursor;

        /* process symbol assignments before inputs */
        process_assigns(ld, os, 0, region ? region->cursor : os->vaddr);

        int pattern_count = 0;
        for (int pi = 0; pi < os->npatterns; pi++) {
            pattern_count++;
            for (int oi = 0; oi < ld->nobjs; oi++) {
                struct ld_object *obj = &ld->objs[oi];
                for (int s = 0; s < obj->nsections; s++) {
                    struct ld_input_sec *isec = &obj->sections[s];
                    if (isec->matched)
                        continue;
                    if (isec->type != SHT_PROGBITS &&
                        isec->type != SHT_NOBITS)
                        continue;

                    if (!pattern_matches(&os->patterns[pi], isec->name))
                        continue;

                    isec->matched = 1;

                    uint32_t abs_end = os->vaddr + os->size;
                    uint32_t pad = align_up(abs_end, isec->align) - abs_end;
                    isec->assigned_vaddr = os->vaddr + os->size + pad;

                    if (isec->type == SHT_NOBITS) {
                        os->nobits = 1;
                        outsec_append(os, NULL, isec->size, isec->align);
                    } else {
                        outsec_append(os, isec->data, isec->size,
                                      isec->align);
                    }
                }
            }
            /* symbol assignments after this pattern group */
            uint32_t cur = os->vaddr + os->size;
            process_assigns(ld, os, pattern_count, cur);
        }

        if (region) {
            region->cursor = os->vaddr + os->size;
            if (region->cursor > region->origin + region->length)
                die("section %s overflows region %s", os->name,
                    region->name);
        }
    }

    /* resolve symbol values to final addresses */
    for (int oi = 0; oi < ld->nobjs; oi++) {
        struct ld_object *obj = &ld->objs[oi];
        for (int si = 0; si < obj->nsyms; si++) {
            int gi = obj->sym_map[si];
            if (gi < 0)
                continue;
            struct ld_symbol *gsym = &ld->syms[gi];
            if (gsym->obj_idx < 0)
                continue;
            struct ld_input_sym *isym = &obj->syms[si];
            if (isym->binding == STB_LOCAL && isym->type == STT_SECTION) {
                gsym->value = obj->sections[isym->shndx].assigned_vaddr;
            } else if (isym->shndx != SHN_UNDEF &&
                       isym->shndx != (int)SHN_ABS) {
                gsym->value = obj->sections[isym->shndx].assigned_vaddr +
                              isym->value;
            }
        }
    }

    /* resolve entry point */
    if (sc->entry) {
        int ei = sym_find(ld, sc->entry);
        if (ei < 0)
            die("entry symbol '%s' not found", sc->entry);
        if (!ld->syms[ei].defined)
            die("entry symbol '%s' is undefined", sc->entry);
        ld->entry_vaddr = ld->syms[ei].value;
    }
}

/* Locate the output section whose address range holds an input section, so a
 * relocation can be patched into the merged output buffer.  Shared. */
struct ld_output_sec *
ld_find_output_sec(struct linker *ld, struct ld_input_sec *isec)
{
    struct ld_script *sc = &ld->script;
    for (int s = 0; s < sc->nsections; s++) {
        struct ld_output_sec *candidate = &sc->sections[s];
        if (candidate->discard)
            continue;
        uint32_t sec_start = candidate->vaddr;
        uint32_t sec_end = candidate->vaddr + candidate->size;
        if (isec->assigned_vaddr >= sec_start &&
            isec->assigned_vaddr < sec_end)
            return candidate;
    }
    return NULL;
}

/* Report any global symbol that stayed undefined after relocation.  Shared. */
void
ld_check_undefined(struct linker *ld)
{
    for (int i = 0; i < ld->nsyms; i++) {
        if (!ld->syms[i].defined && ld->syms[i].name[0] != '\0')
            die("undefined symbol: %s", ld->syms[i].name);
    }
}

int
ld_link(struct linker *ld)
{
    ld_layout(ld);

    /* apply relocations */
    for (int oi = 0; oi < ld->nobjs; oi++) {
        struct ld_object *obj = &ld->objs[oi];

        for (int ri = 0; ri < obj->nrelocs; ri++) {
            struct ld_reloc *rel = &obj->relocs[ri];
            int gi = obj->sym_map[rel->sym_idx];
            if (gi < 0)
                die("%s: reloc references unmapped symbol %d",
                    obj->path, rel->sym_idx);

            struct ld_symbol *gsym = &ld->syms[gi];
            if (!gsym->defined)
                die("%s: undefined symbol '%s'", obj->path, gsym->name);

            struct ld_input_sec *isec = &obj->sections[rel->section];
            if (!isec->matched)
                continue;

            struct ld_output_sec *os = ld_find_output_sec(ld, isec);
            if (!os)
                die("%s: cannot find output section for reloc", obj->path);

            uint32_t file_off = (isec->assigned_vaddr - os->vaddr) +
                                rel->offset;
            uint8_t *patch = os->data + file_off;

            uint32_t S = gsym->value;
            int32_t A = rel->addend;
            uint32_t P = isec->assigned_vaddr + rel->offset;

            switch (rel->type) {
            case R_68K_32:
                put32(patch, S + (uint32_t)A);
                break;
            case R_68K_PC32: {
                int32_t val = (int32_t)(S + (uint32_t)A - P);
                put32(patch, (uint32_t)val);
                break;
            }
            case R_68K_PC16: {
                int32_t val = (int32_t)(S + (uint32_t)A - P);
                if (val < -32768 || val > 32767)
                    die("%s: R_68K_PC16 relocation overflow for '%s' "
                        "(displacement %d)", obj->path, gsym->name, val);
                put16(patch, (uint16_t)(int16_t)val);
                break;
            }
            default:
                die("%s: unsupported relocation type %d", obj->path,
                    rel->type);
            }
        }
    }

    ld_check_undefined(ld);
    return 0;
}

/* Append a zeroed object slot, growing the (arena-backed) object array.  The
 * old array is abandoned to the arena; relocs pointers are carried by value so
 * ld_free still frees each once.  Used for archive members and the synthetic
 * GOT object. */
struct ld_object *
ld_add_object(struct linker *ld)
{
    struct ld_object *objs = arena_zalloc(&ld->arena,
        (size_t)(ld->nobjs + 1) * sizeof(struct ld_object));
    if (ld->nobjs)
        memcpy(objs, ld->objs, (size_t)ld->nobjs * sizeof(struct ld_object));
    ld->objs = objs;
    return &ld->objs[ld->nobjs++];
}

void
ld_free(struct linker *ld)
{
    for (int i = 0; i < ld->nobjs; i++) {
        mapfile_close(&ld->objs[i].mf);
        free(ld->objs[i].relocs);
    }
    for (int i = 0; i < ld->script.nsections; i++)
        free(ld->script.sections[i].data);
    free(ld->syms);
    arena_free(&ld->arena);
}
