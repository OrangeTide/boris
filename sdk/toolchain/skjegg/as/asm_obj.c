/* asm_obj.c : arch-neutral section and symbol-table helpers */

#include "asm_obj.h"

#include <limits.h>
#include <stdlib.h>
#include <string.h>

#include "util.h"

/****************************************************************
 * Section helpers
 ****************************************************************/

/* Ensure the section can hold `need` more bytes, growing to fit.  A section
 * length is an int, so a request that would push it past INT_MAX is a fatal
 * error (a hostile or corrupt `.zero`/`.space` count), not a silent wrap; the
 * growth arithmetic runs in size_t so the capacity doubling never overflows. */
static void
sec_reserve(struct section *s, int need)
{
    size_t want, ncap;

    if (need < 0 || s->len < 0)
        die("section fill count out of range");
    want = (size_t)s->len + (size_t)need;
    if (want > (size_t)INT_MAX)
        die("section too large");
    if (want <= (size_t)s->cap)
        return;
    ncap = s->cap ? (size_t)s->cap : 256;
    while (ncap < want)
        ncap *= 2;                      /* size_t: no signed overflow */
    if (ncap > (size_t)INT_MAX)
        ncap = want;                    /* a single huge request: grow to fit */
    s->data = realloc(s->data, ncap);
    if (!s->data)
        die("out of memory growing section");
    s->cap = (int)ncap;
}

void
sec_emit8(struct section *s, uint8_t val)
{
    sec_reserve(s, 1);
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
    if (nbytes <= 0)
        return;
    sec_reserve(s, nbytes);
    memset(s->data + s->len, 0, (size_t)nbytes);
    s->len += nbytes;
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
    st->syms[idx].weak = 0;
    st->syms[idx].defined = 0;
    st->syms[idx].is_func = 0;
    st->syms[idx].size = 0;
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

/* A weak symbol binds like a global for symbol-table ordering (it is not a
   local), but the ELF writer emits STB_WEAK so the linker lets a strong
   definition override it and an unresolved weak reference stay 0. */
void
sym_set_weak(struct symtab *st, int idx)
{
    st->syms[idx].global = 1;
    st->syms[idx].weak = 1;
}

/* .type sym,@function : the symbol names code, so the ELF writer types it
   STT_FUNC.  A debugger's address-to-function map and a backtrace both read
   this in .symtab; the DWARF line table (file:line) is separate. */
void
sym_set_func(struct symtab *st, int idx)
{
    st->syms[idx].is_func = 1;
}

/* .size sym,expr : the symbol's extent in bytes, written as st_size. */
void
sym_set_size(struct symtab *st, int idx, uint32_t size)
{
    st->syms[idx].size = size;
}
