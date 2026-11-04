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
        int defined, int weak, int obj_idx, int sec_idx)
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
    ld->syms[idx].weak = weak;
    ld->syms[idx].obj_idx = obj_idx;
    ld->syms[idx].sec_idx = sec_idx;
    ld->syms[idx].type = STT_NOTYPE;
    ld->syms[idx].size = 0;
    ld->syms[idx].binding = STB_GLOBAL;
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

            int is_def = (isym->shndx != SHN_UNDEF);
            int is_weak = (isym->binding == STB_WEAK);

            if (isym->binding == STB_LOCAL) {
                int gidx = sym_add(ld, isym->name, isym->value,
                                   is_def, 0, oi, isym->shndx);
                ld->syms[gidx].type = isym->type;
                ld->syms[gidx].size = isym->size;
                ld->syms[gidx].binding = STB_LOCAL;
                obj->sym_map[si] = gidx;
                continue;
            }

            int existing = sym_find(ld, isym->name);
            if (existing >= 0) {
                struct ld_symbol *g = &ld->syms[existing];
                if (is_def) {
                    if (g->defined) {
                        /* A strong definition overrides a weak one; two strong
                           definitions collide; a weak definition never
                           displaces an existing one. */
                        if (g->weak && !is_weak) {
                            g->value = isym->value;
                            g->weak = 0;
                            g->obj_idx = oi;
                            g->sec_idx = isym->shndx;
                            g->type = isym->type;
                            g->size = isym->size;
                        } else if (!g->weak && !is_weak) {
                            die("duplicate symbol: %s", isym->name);
                        }
                    } else {
                        /* first definition of a so-far-undefined symbol */
                        g->defined = 1;
                        g->value = isym->value;
                        g->weak = is_weak;
                        g->obj_idx = oi;
                        g->sec_idx = isym->shndx;
                        g->type = isym->type;
                        g->size = isym->size;
                    }
                } else if (!g->defined && !is_weak) {
                    /* a strong reference forces the symbol to be resolved */
                    g->weak = 0;
                }
                obj->sym_map[si] = existing;
            } else {
                int gidx = sym_add(ld, isym->name, isym->value,
                                   is_def, is_weak, oi, isym->shndx);
                ld->syms[gidx].type = isym->type;
                ld->syms[gidx].size = isym->size;
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

    if (size > 0) {
        if (data)
            memcpy(os->data + os->size, data, size);
        else
            memset(os->data + os->size, 0, size);
    }
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
            ld->syms[existing].weak = 0;
        } else {
            sym_add(ld, sa->name, cursor, 1, 0, -1, -1);
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
    uint32_t eh = ld->ehdr_size ? ld->ehdr_size : 52;
    uint32_t pe = ld->phent_size ? ld->phent_size : 32;
    uint32_t headers_size = eh + (uint32_t)nphdrs * pe;
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

/* Merge the input non-alloc debug sections (.debug_*) by name into ld->debug[],
 * concatenating same-named sections across objects.  Each input section's base
 * offset within its merged section is recorded in isec->assigned_vaddr (debug
 * sections are non-alloc, so that field is otherwise unused for them), which is
 * what lets the arch linker place a reloc inside the merged buffer.  Shared. */
void
ld_build_debug(struct linker *ld)
{
    for (int oi = 0; oi < ld->nobjs; oi++) {
        struct ld_object *obj = &ld->objs[oi];
        for (int s = 0; s < obj->nsections; s++) {
            struct ld_input_sec *isec = &obj->sections[s];
            struct ld_debug_sec *d = NULL;

            if (isec->type != SHT_PROGBITS)
                continue;
            if (strncmp(isec->name, ".debug_", 7) != 0)
                continue;

            for (int k = 0; k < ld->ndebug; k++) {
                if (strcmp(ld->debug[k].name, isec->name) == 0) {
                    d = &ld->debug[k];
                    break;
                }
            }
            if (!d) {
                if (ld->ndebug >= MAX_DEBUG_SECS)
                    die("too many debug sections (%s)", isec->name);
                d = &ld->debug[ld->ndebug++];
                d->name = isec->name;
            }

            if (d->size + isec->size > d->cap) {
                d->cap = (d->size + isec->size) * 2;
                d->data = realloc(d->data, d->cap);
                if (!d->data)
                    die("out of memory");
            }
            isec->assigned_vaddr = d->size;     /* base within merged buffer */
            if (isec->size > 0)
                memcpy(d->data + d->size, isec->data, isec->size);
            d->size += isec->size;
        }
    }
}

/* Report any global symbol that stayed undefined after relocation.  Shared. */
void
ld_check_undefined(struct linker *ld)
{
    for (int i = 0; i < ld->nsyms; i++) {
        /* a weak symbol that stayed undefined resolves to 0, not an error */
        if (!ld->syms[i].defined && !ld->syms[i].weak &&
            ld->syms[i].name[0] != '\0')
            die("undefined symbol: %s", ld->syms[i].name);
    }
}

/* Order two global symbols for the map: by address, then by name.  Shared. */
static int
map_sym_cmp(const void *pa, const void *pb)
{
    const struct ld_symbol *a = *(const struct ld_symbol *const *)pa;
    const struct ld_symbol *b = *(const struct ld_symbol *const *)pb;
    if (a->value < b->value) return -1;
    if (a->value > b->value) return 1;
    return strcmp(a->name, b->name);
}

/* Write a link map: the entry point, the memory regions, each output section
 * with the input sections that built it, and the defined global symbols by
 * address.  Called after the link (addresses are final).  Shared by every
 * target, since it reads only the arch-neutral layout result.  Shared. */
void
ld_write_map(struct linker *ld, const char *path)
{
    FILE *f = fopen(path, "w");
    if (!f)
        die("cannot create %s", path);

    struct ld_script *sc = &ld->script;

    fprintf(f, "Skjegg link map\n\n");
    fprintf(f, "Entry point: 0x%08x\n\n", ld->entry_vaddr);

    if (sc->nregions > 0) {
        fprintf(f, "Memory configuration:\n");
        for (int r = 0; r < sc->nregions; r++) {
            struct ld_mem_region *mr = &sc->regions[r];
            fprintf(f, "  %-12s origin 0x%08x  length 0x%08x (%u bytes)\n",
                    mr->name, mr->origin, mr->length, mr->length);
        }
        fprintf(f, "\n");
    }

    fprintf(f, "Output sections:\n");
    for (int s = 0; s < sc->nsections; s++) {
        struct ld_output_sec *os = &sc->sections[s];
        if (os->discard || os->size == 0)
            continue;
        fprintf(f, "  %-12s 0x%08x  0x%08x%s\n", os->name, os->vaddr,
                os->size, os->nobits ? "  (nobits)" : "");
        /* the input sections that landed in this output section */
        for (int o = 0; o < ld->nobjs; o++) {
            struct ld_object *obj = &ld->objs[o];
            for (int i = 0; i < obj->nsections; i++) {
                struct ld_input_sec *isec = &obj->sections[i];
                if (!isec->matched)
                    continue;
                if (ld_find_output_sec(ld, isec) != os)
                    continue;
                fprintf(f, "    0x%08x  0x%08x  %s(%s)\n",
                        isec->assigned_vaddr, isec->size, obj->path,
                        isec->name);
            }
        }
    }
    fprintf(f, "\n");

    /* defined global symbols, by address */
    const struct ld_symbol **order =
        arena_alloc(&ld->arena, (size_t)ld->nsyms * sizeof *order);
    int n = 0;
    for (int i = 0; i < ld->nsyms; i++) {
        if (ld->syms[i].defined && ld->syms[i].name[0] != '\0')
            order[n++] = &ld->syms[i];
    }
    qsort(order, (size_t)n, sizeof *order, map_sym_cmp);

    fprintf(f, "Symbols:\n");
    for (int i = 0; i < n; i++) {
        const struct ld_symbol *sym = order[i];
        const char *from = "";
        if (sym->obj_idx >= 0 && sym->obj_idx < ld->nobjs)
            from = ld->objs[sym->obj_idx].path;
        fprintf(f, "  0x%08x  %-24s %s\n", sym->value, sym->name, from);
    }

    fclose(f);
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
            if (!gsym->defined && !gsym->weak)
                die("%s: undefined symbol '%s'", obj->path, gsym->name);
            /* a weak-undefined symbol has value 0, so the reloc resolves to 0 */

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

    /* Debug sections are non-alloc, so the loop above skipped them (their
       input sections never matched an output section).  Merge them and apply
       the absolute address relocations (low_pc / high_pc / line-program
       set_address, all R_68K_32 against the text section symbol, now resolved)
       into the merged buffers, so the linked executable carries final big-
       endian addresses. */
    ld_build_debug(ld);
    for (int oi = 0; oi < ld->nobjs; oi++) {
        struct ld_object *obj = &ld->objs[oi];

        for (int ri = 0; ri < obj->nrelocs; ri++) {
            struct ld_reloc *rel = &obj->relocs[ri];
            struct ld_input_sec *isec = &obj->sections[rel->section];
            struct ld_debug_sec *d = NULL;
            struct ld_symbol *gsym;
            uint8_t *patch;
            int gi;

            if (isec->type != SHT_PROGBITS
                || strncmp(isec->name, ".debug_", 7) != 0)
                continue;
            for (int k = 0; k < ld->ndebug; k++) {
                if (strcmp(ld->debug[k].name, isec->name) == 0) {
                    d = &ld->debug[k];
                    break;
                }
            }
            if (!d)
                continue;

            gi = obj->sym_map[rel->sym_idx];
            if (gi < 0)
                die("%s: debug reloc references unmapped symbol", obj->path);
            gsym = &ld->syms[gi];
            patch = d->data + isec->assigned_vaddr + rel->offset;

            switch (rel->type) {
            case R_68K_32:
                put32(patch, gsym->value + (uint32_t)rel->addend);
                break;
            default:
                die("%s: unsupported debug relocation type %d in %s",
                    obj->path, rel->type, isec->name);
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
