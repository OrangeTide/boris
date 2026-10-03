/* asm_obj.c : arch-neutral section and symbol-table helpers */

#include "asm_obj.h"

#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Section helpers
 ****************************************************************/

void
sec_emit8(struct section *s, uint8_t val)
{
    if (s->len + 1 > s->cap) {
        s->cap = s->cap ? s->cap * 2 : 256;
        s->data = realloc(s->data, s->cap);
    }
    s->data[s->len++] = val;
}

void
sec_emit16(struct section *s, uint16_t val)
{
    if (s->little_endian) {
        sec_emit8(s, (uint8_t)(val & 0xFF));
        sec_emit8(s, (uint8_t)(val >> 8));
    } else {
        sec_emit8(s, (uint8_t)(val >> 8));
        sec_emit8(s, (uint8_t)(val & 0xFF));
    }
}

void
sec_emit32(struct section *s, uint32_t val)
{
    if (s->little_endian) {
        sec_emit8(s, (uint8_t)(val & 0xFF));
        sec_emit8(s, (uint8_t)(val >> 8));
        sec_emit8(s, (uint8_t)(val >> 16));
        sec_emit8(s, (uint8_t)(val >> 24));
    } else {
        sec_emit8(s, (uint8_t)(val >> 24));
        sec_emit8(s, (uint8_t)(val >> 16));
        sec_emit8(s, (uint8_t)(val >> 8));
        sec_emit8(s, (uint8_t)(val & 0xFF));
    }
}

void
sec_align(struct section *s, int alignment)
{
    while (s->len % alignment)
        sec_emit8(s, 0);
}

void
sec_space(struct section *s, int nbytes)
{
    int k;
    for (k = 0; k < nbytes; k++)
        sec_emit8(s, 0);
}

void
sec_add_reloc_t(struct section *s, uint32_t offset, int sym_idx,
                int32_t addend, int type)
{
    if (s->nrelocs >= s->reloc_cap) {
        s->reloc_cap = s->reloc_cap ? s->reloc_cap * 2 : 16;
        s->relocs = realloc(s->relocs, s->reloc_cap * sizeof(struct reloc));
    }
    s->relocs[s->nrelocs].offset = offset;
    s->relocs[s->nrelocs].sym_idx = sym_idx;
    s->relocs[s->nrelocs].addend = addend;
    s->relocs[s->nrelocs].type = type;
    s->nrelocs++;
}

void
sec_add_reloc(struct section *s, uint32_t offset, int sym_idx, int32_t addend)
{
    sec_add_reloc_t(s, offset, sym_idx, addend, 0);
}

/****************************************************************
 * Symbol table
 ****************************************************************/

int
sym_lookup(struct symtab *st, const char *name)
{
    int k;
    for (k = 0; k < st->nsyms; k++) {
        if (strcmp(st->syms[k].name, name) == 0)
            return k;
    }
    return -1;
}

int
sym_add(struct symtab *st, const char *name)
{
    int idx;

    if (st->nsyms >= st->cap) {
        st->cap = st->cap ? st->cap * 2 : 32;
        st->syms = realloc(st->syms, st->cap * sizeof(struct symbol));
    }
    idx = st->nsyms++;
    st->syms[idx].name = arena_strdup(st->arena, name);
    st->syms[idx].section = -1;
    st->syms[idx].value = 0;
    st->syms[idx].global = 0;
    st->syms[idx].defined = 0;
    return idx;
}

void
sym_define(struct symtab *st, int idx, int section, uint32_t value)
{
    st->syms[idx].section = section;
    st->syms[idx].value = value;
    st->syms[idx].defined = 1;
}

void
sym_set_global(struct symtab *st, int idx)
{
    st->syms[idx].global = 1;
}
