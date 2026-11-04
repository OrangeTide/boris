/* dwarf.c : DWARF 4 debug-info serializer (see dwarf.h). */

#include "dwarf.h"
#include "arena.h"
#include "util.h"

#include <string.h>

/* DWARF 4 line-number program opcodes (DWARF 4 section 6.2.5). */
enum {
    DW_LNS_copy = 1,
    DW_LNS_advance_pc = 2,
    DW_LNS_advance_line = 3,
    DW_LNS_set_file = 4,
    DW_LNS_set_column = 5,
    DW_LNS_negate_stmt = 6,
    DW_LNS_set_basic_block = 7,
    DW_LNS_const_add_pc = 8,
    DW_LNS_fixed_advance_pc = 9,
    DW_LNS_set_prologue_end = 10,
    DW_LNS_set_epilogue_begin = 11,
    DW_LNS_set_isa = 12,
};

enum {
    DW_LNE_end_sequence = 1,
    DW_LNE_set_address = 2,
};

/* DWARF 4 tags, attributes, and forms used by the skeleton compilation unit
   (DWARF 4 sections 7.5.3, 7.5.4). */
enum {
    DW_TAG_compile_unit = 0x11,
    DW_CHILDREN_no = 0x00,
    DW_AT_name = 0x03,
    DW_AT_stmt_list = 0x10,
    DW_AT_low_pc = 0x11,
    DW_AT_high_pc = 0x12,
    DW_AT_language = 0x13,
    DW_AT_comp_dir = 0x1b,
    DW_AT_producer = 0x25,
    DW_FORM_addr = 0x01,
    DW_FORM_data2 = 0x05,
    DW_FORM_string = 0x08,
    DW_FORM_sec_offset = 0x17,
    DW_LANG_C99 = 0x0c,
};

/* The single abbreviation code the CU DIE uses. */
#define DW_ABBREV_COMPILE_UNIT 1

/* A fixed-capacity byte writer.  The caller sizes the buffer to a computed
   upper bound, so a write never overflows; w_room asserts that invariant. */
struct writer {
    uint8_t *p;
    size_t len;
    size_t cap;
    int big;            /* 1 = big-endian multi-byte fields (ColdFire), 0 = LE */
};

static void
w_room(struct writer *w, size_t n)
{
    if (w->len + n > w->cap)
        die("dwarf: writer overflow (%zu + %zu > %zu)", w->len, n, w->cap);
}

static void
w_u8(struct writer *w, uint8_t v)
{
    w_room(w, 1);
    w->p[w->len++] = v;
}

static void
w_u16(struct writer *w, uint16_t v)
{
    if (w->big) {
        w_u8(w, (uint8_t)(v >> 8));
        w_u8(w, (uint8_t)v);
    } else {
        w_u8(w, (uint8_t)v);
        w_u8(w, (uint8_t)(v >> 8));
    }
}

static void
w_u32(struct writer *w, uint32_t v)
{
    if (w->big) {
        w_u8(w, (uint8_t)(v >> 24));
        w_u8(w, (uint8_t)(v >> 16));
        w_u8(w, (uint8_t)(v >> 8));
        w_u8(w, (uint8_t)v);
    } else {
        w_u8(w, (uint8_t)v);
        w_u8(w, (uint8_t)(v >> 8));
        w_u8(w, (uint8_t)(v >> 16));
        w_u8(w, (uint8_t)(v >> 24));
    }
}

static void
w_u64(struct writer *w, uint64_t v)
{
    int i;
    if (w->big)
        for (i = 7; i >= 0; i--) w_u8(w, (uint8_t)(v >> (i * 8)));
    else
        for (i = 0; i < 8; i++) w_u8(w, (uint8_t)(v >> (i * 8)));
}

/* A DWARF address (DW_FORM_addr / the set_address operand): addr_size bytes. */
static void
w_addr(struct writer *w, uint64_t v, int addr_size)
{
    if (addr_size == 8)
        w_u64(w, v);
    else
        w_u32(w, (uint32_t)v);
}

static void
w_uleb(struct writer *w, uint64_t v)
{
    do {
        uint8_t c = v & 0x7f;
        v >>= 7;
        if (v)
            c |= 0x80;
        w_u8(w, c);
    } while (v);
}

static void
w_sleb(struct writer *w, int64_t v)
{
    int more = 1;
    while (more) {
        uint8_t c = v & 0x7f;
        v >>= 7;    /* arithmetic shift: sign-propagating */
        if ((v == 0 && !(c & 0x40)) || (v == -1 && (c & 0x40)))
            more = 0;
        else
            c |= 0x80;
        w_u8(w, c);
    }
}

static void
w_str(struct writer *w, const char *s)
{
    size_t n = strlen(s) + 1;
    w_room(w, n);
    memcpy(w->p + w->len, s, n);
    w->len += n;
}

/* Patch a 4-byte field written earlier (the unit_length and header_length
   placeholders, back-filled once their spans are known), in the writer's byte
   order. */
static void
w_patch_u32(struct writer *w, size_t at, uint32_t v)
{
    if (w->big) {
        w->p[at + 0] = (uint8_t)(v >> 24);
        w->p[at + 1] = (uint8_t)(v >> 16);
        w->p[at + 2] = (uint8_t)(v >> 8);
        w->p[at + 3] = (uint8_t)v;
    } else {
        w->p[at + 0] = (uint8_t)v;
        w->p[at + 1] = (uint8_t)(v >> 8);
        w->p[at + 2] = (uint8_t)(v >> 16);
        w->p[at + 3] = (uint8_t)(v >> 24);
    }
}

/* line_base/line_range/opcode_base: the standard GCC-style values, which fix
   how the special opcodes fold a line advance and a pc advance into one byte.
   v1 does not emit special opcodes (it uses the explicit advance opcodes for
   clarity over compactness), but the header must still declare a consistent
   set so a consumer decodes the program. */
#define DW_LINE_BASE   (-5)
#define DW_LINE_RANGE  14
#define DW_OPCODE_BASE 13

size_t
dw_line_build(struct arena *a, const char *const *files, int nfiles,
              const struct dw_line_row *rows, int nrows,
              uint32_t end_addr, uint8_t **out, size_t *set_addr_off,
              int big, int addr_size)
{
    struct writer w;
    size_t unit_len_at, after_len, hdr_len_at, after_hdr, files_len = 0;
    int i, cur_file, cur_col;

    for (i = 0; i < nfiles; i++)
        files_len += strlen(files[i]) + 4;

    /* Upper bound: the fixed header, the file table, and per row at most
       set_file (1 + 5 ULEB), set_column (1 + 5 ULEB), advance_pc (1 + 5 ULEB),
       advance_line (1 + 5 SLEB) and copy (1), plus the set_address
       (3 + addr_size) and end_sequence (3) framing. */
    size_t cap = 64 + files_len + (size_t)nrows * 28 + 16 + addr_size;
    w.p = arena_alloc(a, cap);
    w.len = 0;
    w.cap = cap;
    w.big = big;

    /* ---- Unit header (DWARF 4, 32-bit DWARF format). */
    unit_len_at = w.len;
    w_u32(&w, 0);                   /* unit_length, patched below */
    after_len = w.len;
    w_u16(&w, 4);                   /* version */
    hdr_len_at = w.len;
    w_u32(&w, 0);                   /* header_length, patched below */
    after_hdr = w.len;
    w_u8(&w, 1);                    /* minimum_instruction_length */
    w_u8(&w, 1);                    /* maximum_operations_per_instruction */
    w_u8(&w, 1);                    /* default_is_stmt */
    w_u8(&w, (uint8_t)DW_LINE_BASE);
    w_u8(&w, DW_LINE_RANGE);
    w_u8(&w, DW_OPCODE_BASE);
    /* standard_opcode_lengths[1 .. opcode_base-1]: operand counts. */
    w_u8(&w, 0);                    /* DW_LNS_copy */
    w_u8(&w, 1);                    /* DW_LNS_advance_pc */
    w_u8(&w, 1);                    /* DW_LNS_advance_line */
    w_u8(&w, 1);                    /* DW_LNS_set_file */
    w_u8(&w, 1);                    /* DW_LNS_set_column */
    w_u8(&w, 0);                    /* DW_LNS_negate_stmt */
    w_u8(&w, 0);                    /* DW_LNS_set_basic_block */
    w_u8(&w, 0);                    /* DW_LNS_const_add_pc */
    w_u8(&w, 1);                    /* DW_LNS_fixed_advance_pc */
    w_u8(&w, 0);                    /* DW_LNS_set_prologue_end */
    w_u8(&w, 0);                    /* DW_LNS_set_epilogue_begin */
    w_u8(&w, 1);                    /* DW_LNS_set_isa */
    /* include_directories: none (each file carries its own path). */
    w_u8(&w, 0);
    /* file_names: nfiles entries, each dir 0, mtime 0, size 0; then the
       terminating null name. */
    for (i = 0; i < nfiles; i++) {
        w_str(&w, files[i]);
        w_uleb(&w, 0);
        w_uleb(&w, 0);
        w_uleb(&w, 0);
    }
    w_u8(&w, 0);
    w_patch_u32(&w, hdr_len_at, (uint32_t)(w.len - after_hdr));

    /* ---- Line-number program.  The file register starts at 1 and the column
       register at 0 (DWARF defaults); emit set_file / set_column only on a
       change, so a single-file, column-less table encodes neither. */
    cur_file = 1;
    cur_col = 0;
    /* Set the starting address with the extended opcode. */
    w_u8(&w, 0);                    /* extended opcode escape */
    w_uleb(&w, (uint64_t)(1 + addr_size)); /* length: sub-opcode + address */
    w_u8(&w, DW_LNE_set_address);
    if (set_addr_off)
        *set_addr_off = w.len;      /* the address operand a reloc fixes */
    w_addr(&w, rows[0].addr, addr_size);
    for (i = 0; i < nrows; i++) {
        int f = rows[i].file ? rows[i].file : 1;
        if (i > 0) {
            w_u8(&w, DW_LNS_advance_pc);
            w_uleb(&w, (uint64_t)(rows[i].addr - rows[i - 1].addr));
        }
        if (f != cur_file) {
            w_u8(&w, DW_LNS_set_file);
            w_uleb(&w, (uint64_t)f);
            cur_file = f;
        }
        if (rows[i].col != cur_col) {
            w_u8(&w, DW_LNS_set_column);
            w_uleb(&w, (uint64_t)rows[i].col);
            cur_col = rows[i].col;
        }
        w_u8(&w, DW_LNS_advance_line);
        w_sleb(&w, (int64_t)rows[i].line - (i ? rows[i - 1].line : 1));
        w_u8(&w, DW_LNS_copy);
    }
    /* Advance to the end address and close the sequence. */
    w_u8(&w, DW_LNS_advance_pc);
    w_uleb(&w, (uint64_t)(end_addr - rows[nrows - 1].addr));
    w_u8(&w, 0);                    /* extended opcode escape */
    w_uleb(&w, 1);                  /* length: sub-opcode only */
    w_u8(&w, DW_LNE_end_sequence);

    w_patch_u32(&w, unit_len_at, (uint32_t)(w.len - after_len));

    *out = w.p;
    return w.len;
}

/* The abbreviation table and the compilation-unit DIE share one attribute
   list, in this exact order and with these forms.  Keeping the two builders
   adjacent is what keeps them in agreement: a consumer reads the abbrev to
   learn the DIE's shape, so the info DIE below must write the same attributes
   in the same order. */

size_t
dw_abbrev_build(struct arena *a, uint8_t **out)
{
    struct writer w;

    w.p = arena_alloc(a, 64);
    w.len = 0;
    w.cap = 64;
    w.big = 0;              /* the abbrev table is all u8/ULEB: endian-neutral */

    /* One abbreviation: a childless compile_unit. */
    w_uleb(&w, DW_ABBREV_COMPILE_UNIT);
    w_uleb(&w, DW_TAG_compile_unit);
    w_u8(&w, DW_CHILDREN_no);
    w_uleb(&w, DW_AT_producer);  w_uleb(&w, DW_FORM_string);
    w_uleb(&w, DW_AT_language);  w_uleb(&w, DW_FORM_data2);
    w_uleb(&w, DW_AT_name);      w_uleb(&w, DW_FORM_string);
    w_uleb(&w, DW_AT_comp_dir);  w_uleb(&w, DW_FORM_string);
    w_uleb(&w, DW_AT_low_pc);    w_uleb(&w, DW_FORM_addr);
    w_uleb(&w, DW_AT_high_pc);   w_uleb(&w, DW_FORM_addr);
    w_uleb(&w, DW_AT_stmt_list); w_uleb(&w, DW_FORM_sec_offset);
    w_uleb(&w, 0); w_uleb(&w, 0); /* the (0,0) attribute-list terminator */
    w_uleb(&w, 0);               /* end of the abbreviation table */

    *out = w.p;
    return w.len;
}

size_t
dw_info_build(struct arena *a, const char *producer, const char *file_name,
              const char *comp_dir, uint32_t low_pc, uint32_t high_pc,
              uint32_t stmt_list_off, uint8_t **out,
              size_t *low_pc_off, size_t *high_pc_off, int big, int addr_size)
{
    struct writer w;
    size_t unit_len_at, after_len;
    size_t cap = 32 + strlen(producer) + 1 + strlen(file_name) + 1
                 + strlen(comp_dir) + 1 + 16 + 2 * addr_size;

    w.p = arena_alloc(a, cap);
    w.len = 0;
    w.cap = cap;
    w.big = big;

    /* ---- Compilation-unit header (DWARF 4, 32-bit DWARF format). */
    unit_len_at = w.len;
    w_u32(&w, 0);                   /* unit_length, patched below */
    after_len = w.len;
    w_u16(&w, 4);                   /* version */
    w_u32(&w, 0);                   /* debug_abbrev_offset (one CU at 0) */
    w_u8(&w, (uint8_t)addr_size);   /* address_size (4 ILP32, 8 LP64) */

    /* ---- The single compile_unit DIE, matching dw_abbrev_build's order. */
    w_uleb(&w, DW_ABBREV_COMPILE_UNIT);
    w_str(&w, producer);
    w_u16(&w, DW_LANG_C99);
    w_str(&w, file_name);
    w_str(&w, comp_dir);
    if (low_pc_off)
        *low_pc_off = w.len;        /* each an address operand a reloc fixes */
    w_addr(&w, low_pc, addr_size);
    if (high_pc_off)
        *high_pc_off = w.len;
    w_addr(&w, high_pc, addr_size);
    w_u32(&w, stmt_list_off);       /* DW_AT_stmt_list -> .debug_line offset */

    w_patch_u32(&w, unit_len_at, (uint32_t)(w.len - after_len));

    *out = w.p;
    return w.len;
}
