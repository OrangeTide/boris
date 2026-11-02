/* dwread.c : DWARF 4 reader (see dwread.h).

   Builds an address-sorted line table from .debug_line and an address-sorted
   function table from .symtab, both once, so lookups are allocation-free binary
   searches.  The line-number program interpreter handles the full DWARF 4 state
   machine (standard, special, and extended opcodes), so it reads a GNU-produced
   table as well as skjegg's own explicit-advance form. */

#include "dwread.h"
#include "arena.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Scalar reads with bounds checks (endianness per the ELF being read)
 ****************************************************************/

/* A bounded cursor over a byte span; every read checks room and clamps. */
struct rd {
    const uint8_t *p;
    size_t len;
    size_t pos;
    int bad;            /* set once a read ran past the end */
    int big;            /* 1 = big-endian multi-byte fields (ColdFire) */
};

static uint8_t
rd_u8(struct rd *c)
{
    if (c->pos + 1 > c->len) { c->bad = 1; return 0; }
    return c->p[c->pos++];
}

static uint16_t
rd_u16(struct rd *c)
{
    const uint8_t *q;
    uint16_t v;
    if (c->pos + 2 > c->len) { c->bad = 1; c->pos = c->len; return 0; }
    q = c->p + c->pos;
    v = c->big ? (uint16_t)((q[0] << 8) | q[1])
               : (uint16_t)(q[0] | (q[1] << 8));
    c->pos += 2;
    return v;
}

static uint32_t
rd_u32(struct rd *c)
{
    const uint8_t *q;
    uint32_t v;
    if (c->pos + 4 > c->len) { c->bad = 1; c->pos = c->len; return 0; }
    q = c->p + c->pos;
    if (c->big)
        v = ((uint32_t)q[0] << 24) | ((uint32_t)q[1] << 16)
            | ((uint32_t)q[2] << 8) | (uint32_t)q[3];
    else
        v = (uint32_t)q[0] | ((uint32_t)q[1] << 8)
            | ((uint32_t)q[2] << 16) | ((uint32_t)q[3] << 24);
    c->pos += 4;
    return v;
}

static uint64_t
rd_uleb(struct rd *c)
{
    uint64_t v = 0;
    int shift = 0;
    for (;;) {
        uint8_t b = rd_u8(c);
        if (shift < 64)
            v |= (uint64_t)(b & 0x7f) << shift;
        shift += 7;
        if (!(b & 0x80))
            break;
        if (c->bad)
            break;
    }
    return v;
}

static int64_t
rd_sleb(struct rd *c)
{
    int64_t v = 0;
    int shift = 0;
    uint8_t b;
    do {
        b = rd_u8(c);
        if (shift < 64)
            v |= (int64_t)(b & 0x7f) << shift;
        shift += 7;
        if (c->bad)
            break;
    } while (b & 0x80);
    if (shift < 64 && (b & 0x40))
        v |= -((int64_t)1 << shift);        /* sign-extend */
    return v;
}

/* A NUL-terminated string at the cursor; advances past the terminator. */
static const char *
rd_str(struct rd *c)
{
    const char *s = (const char *)(c->p + c->pos);
    while (c->pos < c->len && c->p[c->pos] != 0)
        c->pos++;
    if (c->pos >= c->len) { c->bad = 1; return ""; }
    c->pos++;                               /* skip the NUL */
    return s;
}

/****************************************************************
 * ELF32 section lookup (endianness per the ELF's EI_DATA)
 ****************************************************************/

struct elf_sec {
    const uint8_t *data;
    uint32_t size;
    uint32_t link;      /* sh_link (for .symtab -> its .strtab) */
    uint32_t entsize;
};

static uint32_t
le32(const uint8_t *p, int big)
{
    if (big)
        return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16)
             | ((uint32_t)p[2] << 8) | (uint32_t)p[3];
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8)
         | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static uint16_t
le16(const uint8_t *p, int big)
{
    return big ? (uint16_t)((p[0] << 8) | p[1]) : (uint16_t)(p[0] | (p[1] << 8));
}

/* Fill `out` for section index `idx`; returns 1 on success. */
static int
elf_section(const uint8_t *elf, size_t len, int idx, struct elf_sec *out,
            int big)
{
    uint32_t shoff = le32(elf + 32, big);
    uint16_t shentsize = le16(elf + 46, big);
    uint16_t shnum = le16(elf + 48, big);
    const uint8_t *sh;
    uint32_t off, size;

    if (idx < 0 || idx >= shnum)
        return 0;
    if ((size_t)shoff + (size_t)shentsize * shnum > len)
        return 0;
    sh = elf + shoff + (size_t)idx * shentsize;
    off = le32(sh + 16, big);
    size = le32(sh + 20, big);
    if ((size_t)off + size > len)
        return 0;
    out->data = elf + off;
    out->size = size;
    out->link = le32(sh + 24, big);
    out->entsize = le32(sh + 36, big);
    return 1;
}

/* Find a section by name; returns its index or -1. */
static int
elf_find(const uint8_t *elf, size_t len, const char *name, int big)
{
    uint32_t shoff = le32(elf + 32, big);
    uint16_t shentsize = le16(elf + 46, big);
    uint16_t shnum = le16(elf + 48, big);
    uint16_t shstrndx = le16(elf + 50, big);
    struct elf_sec strs;

    if (!elf_section(elf, len, shstrndx, &strs, big))
        return 0 - 1;
    if ((size_t)shoff + (size_t)shentsize * shnum > len)
        return -1;
    for (int i = 0; i < shnum; i++) {
        const uint8_t *sh = elf + shoff + (size_t)i * shentsize;
        uint32_t nm = le32(sh + 0, big);
        if (nm < strs.size
            && strcmp((const char *)strs.data + nm, name) == 0)
            return i;
    }
    return -1;
}

/****************************************************************
 * Line-number program
 ****************************************************************/

struct lrow_buf {
    struct dw_lrow *rows;
    int n, cap;
};

static void
lrow_push(struct arena *a, struct lrow_buf *b, uint32_t addr, int file,
          int line, int end)
{
    if (b->n >= b->cap) {
        int nc = b->cap ? b->cap * 2 : 128;
        struct dw_lrow *nr = arena_alloc(a, (size_t)nc * sizeof *nr);
        if (b->rows)
            memcpy(nr, b->rows, (size_t)b->n * sizeof *nr);
        b->rows = nr;
        b->cap = nc;
    }
    b->rows[b->n].addr = addr;
    b->rows[b->n].file = file;
    b->rows[b->n].line = line;
    b->rows[b->n].end = end;
    b->n++;
}

/* Interpret one line-program unit starting at c->pos; collect its rows and the
   file-name table (on the first unit, which is all skjegg emits). */
static void
run_line_unit(struct arena *a, struct rd *c, struct lrow_buf *rows,
              const char ***files, int *nfiles)
{
    uint32_t unit_len = rd_u32(c);
    size_t unit_end = c->pos + unit_len;
    uint16_t version;
    uint32_t header_len;
    size_t prog_start;
    uint8_t min_inst, line_range, opcode_base, default_is_stmt;
    int8_t line_base;
    uint8_t std_len[32];
    const char **ftab;
    int fcount;

    if (unit_len == 0 || unit_end > c->len) {
        c->pos = c->len;
        return;
    }
    version = rd_u16(c);
    header_len = rd_u32(c);
    prog_start = c->pos + header_len;
    min_inst = rd_u8(c);
    if (version >= 4)
        (void)rd_u8(c);                 /* maximum_operations_per_instruction */
    default_is_stmt = rd_u8(c);
    (void)default_is_stmt;
    line_base = (int8_t)rd_u8(c);
    line_range = rd_u8(c);
    opcode_base = rd_u8(c);
    for (int i = 1; i < opcode_base && i < 32; i++)
        std_len[i] = rd_u8(c);
    for (int i = 32; i < opcode_base; i++)
        (void)rd_u8(c);                 /* unlikely, but stay in step */

    /* include_directories: skip. */
    for (;;) {
        const char *s = rd_str(c);
        if (s[0] == '\0' || c->bad)
            break;
    }
    /* file_names: name, dir, mtime, size.  Build a 1-based table. */
    fcount = 0;
    ftab = arena_alloc(a, 64 * sizeof(const char *));
    ftab[0] = NULL;
    fcount = 1;
    for (;;) {
        const char *s = rd_str(c);
        if (s[0] == '\0' || c->bad)
            break;
        rd_uleb(c);                     /* dir index */
        rd_uleb(c);                     /* mtime */
        rd_uleb(c);                     /* size */
        if (fcount < 64)
            ftab[fcount++] = s;
    }
    if (*files == NULL) {               /* keep the first unit's file table */
        *files = ftab;
        *nfiles = fcount;
    }

    /* Run the state machine from prog_start to unit_end. */
    c->pos = prog_start;
    uint32_t addr = 0;
    int file = 1, line = 1;
    while (c->pos < unit_end && !c->bad) {
        uint8_t op = rd_u8(c);
        if (op == 0) {                  /* extended */
            uint64_t elen = rd_uleb(c);
            size_t enext = c->pos + elen;
            uint8_t sub = rd_u8(c);
            switch (sub) {
            case 1:                     /* DW_LNE_end_sequence */
                lrow_push(a, rows, addr, file, line, 1);
                addr = 0; file = 1; line = 1;
                break;
            case 2:                     /* DW_LNE_set_address */
                addr = rd_u32(c);
                break;
            default:                    /* set_discriminator, vendor: skip */
                break;
            }
            c->pos = enext;             /* honor the stated length */
        } else if (op < opcode_base) {  /* standard */
            switch (op) {
            case 1:                     /* copy */
                lrow_push(a, rows, addr, file, line, 0);
                break;
            case 2:                     /* advance_pc */
                addr += (uint32_t)(rd_uleb(c) * min_inst);
                break;
            case 3:                     /* advance_line */
                line += (int)rd_sleb(c);
                break;
            case 4:                     /* set_file */
                file = (int)rd_uleb(c);
                break;
            case 8:                     /* const_add_pc */
                addr += (uint32_t)(((255 - opcode_base) / line_range)
                                   * min_inst);
                break;
            case 9:                     /* fixed_advance_pc */
                addr += rd_u16(c);
                break;
            default:                    /* skip this opcode's ULEB operands */
                for (int k = 0; k < std_len[op]; k++)
                    rd_uleb(c);
                break;
            }
        } else {                        /* special opcode */
            int adj = op - opcode_base;
            addr += (uint32_t)((adj / line_range) * min_inst);
            line += line_base + (adj % line_range);
            lrow_push(a, rows, addr, file, line, 0);
        }
    }

    c->pos = unit_end;
}

static int
lrow_cmp(const void *pa, const void *pb)
{
    const struct dw_lrow *a = pa, *b = pb;
    if (a->addr < b->addr) return -1;
    if (a->addr > b->addr) return 1;
    return b->end - a->end;             /* at one address, end rows sort first */
}

/****************************************************************
 * Symbol table (.symtab) -> function table
 ****************************************************************/

#define DW_STT_FUNC 2
#define DW_ELF_ST_TYPE(i) ((i) & 0xf)

static int
func_cmp(const void *pa, const void *pb)
{
    const struct dw_func *a = pa, *b = pb;
    if (a->addr < b->addr) return -1;
    if (a->addr > b->addr) return 1;
    return 0;
}

static void
read_symtab(struct arena *a, struct dw_reader *r,
            const uint8_t *elf, size_t len, int big)
{
    int si = elf_find(elf, len, ".symtab", big);
    struct elf_sec sym, str;
    int count, keep = 0;

    if (si < 0)
        return;
    if (!elf_section(elf, len, si, &sym, big) || sym.entsize == 0)
        return;
    if (!elf_section(elf, len, (int)sym.link, &str, big))
        return;

    count = (int)(sym.size / sym.entsize);
    r->funcs = arena_alloc(a, (size_t)(count ? count : 1) * sizeof *r->funcs);
    for (int i = 0; i < count; i++) {
        const uint8_t *e = sym.data + (size_t)i * sym.entsize;
        uint32_t nm = le32(e + 0, big);
        uint32_t val = le32(e + 4, big);
        uint32_t sz = le32(e + 8, big);
        uint8_t info = e[12];
        if (DW_ELF_ST_TYPE(info) != DW_STT_FUNC)
            continue;
        if (nm >= str.size)
            continue;
        r->funcs[keep].addr = val;
        r->funcs[keep].size = sz;
        r->funcs[keep].name = (const char *)str.data + nm;
        keep++;
    }
    r->nfuncs = keep;
    if (keep > 1)
        qsort(r->funcs, (size_t)keep, sizeof *r->funcs, func_cmp);
}

/****************************************************************
 * Public reader
 ****************************************************************/

int
dw_read_elf(struct arena *a, struct dw_reader *r, const uint8_t *elf, size_t len)
{
    struct lrow_buf rows = { 0 };
    int li, big;

    memset(r, 0, sizeof *r);
    r->arena = a;

    if (len < 52 || memcmp(elf, "\177ELF", 4) != 0)
        return 1;
    if (elf[4] != 1 /* ELFCLASS32 */)
        return 1;
    if (elf[5] == 1)            /* ELFDATA2LSB: RISC-V, MIPS */
        big = 0;
    else if (elf[5] == 2)       /* ELFDATA2MSB: ColdFire/m68k */
        big = 1;
    else
        return 1;

    li = elf_find(elf, len, ".debug_line", big);
    if (li >= 0) {
        struct elf_sec ls;
        if (elf_section(elf, len, li, &ls, big)) {
            struct rd c = { ls.data, ls.size, 0, 0, big };
            while (c.pos < ls.size && !c.bad)
                run_line_unit(a, &c, &rows, &r->files, &r->nfiles);
        }
    }
    r->lines = rows.rows;
    r->nlines = rows.n;
    if (r->nlines > 1)
        qsort(r->lines, (size_t)r->nlines, sizeof *r->lines, lrow_cmp);

    read_symtab(a, r, elf, len, big);
    return 0;
}

int
dw_lookup_line(const struct dw_reader *r, uint32_t addr,
               const char **file, int *line)
{
    int lo = 0, hi = r->nlines - 1, best = -1;

    while (lo <= hi) {                  /* last row with addr <= query */
        int mid = lo + (hi - lo) / 2;
        if (r->lines[mid].addr <= addr) {
            best = mid;
            lo = mid + 1;
        } else {
            hi = mid - 1;
        }
    }
    if (best < 0 || r->lines[best].end)
        return 0;                       /* before any row, or in a gap */
    if (file) {
        int fi = r->lines[best].file;
        *file = (fi > 0 && fi < r->nfiles) ? r->files[fi] : NULL;
    }
    if (line)
        *line = r->lines[best].line;
    return 1;
}

int
dw_lookup_func(const struct dw_reader *r, uint32_t addr, const char **name)
{
    int lo = 0, hi = r->nfuncs - 1, best = -1;

    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (r->funcs[mid].addr <= addr) {
            best = mid;
            lo = mid + 1;
        } else {
            hi = mid - 1;
        }
    }
    if (best < 0)
        return 0;
    if (r->funcs[best].size != 0
        && addr >= r->funcs[best].addr + r->funcs[best].size)
        return 0;                       /* past this function, in a gap */
    if (name)
        *name = r->funcs[best].name;
    return 1;
}

/****************************************************************
 * Backtrace
 ****************************************************************/

int
dw_backtrace(uint32_t pc, uint32_t fp, dw_readmem read, void *ctx,
             uint32_t *pcs, int max)
{
    int n = 0;

    if (max <= 0)
        return 0;
    pcs[n++] = pc;

    /* Walk the saved-ra / prev-fp chain the prologue builds.  prev-fp lives at
     * [fp+0] and the return address at [fp+4].  A null or non-increasing fp
     * ends the walk (so a bootstrap or corrupt frame stops it rather than
     * spinning), as does an unreadable slot. */
    while (n < max && fp != 0) {
        uint32_t ra = 0, prev = 0;

        if (!read(ctx, fp + 4, &ra, 4) || !read(ctx, fp, &prev, 4))
            break;
        if (ra == 0)
            break;
        pcs[n++] = ra;
        if (prev <= fp)                 /* must climb toward the stack base */
            break;
        fp = prev;
    }
    return n;
}

/* Append to buf at *off, never past buflen-1, keeping buf NUL-terminated. */
static void
bt_append(char *buf, size_t buflen, size_t *off, const char *s)
{
    while (*s && *off + 1 < buflen)
        buf[(*off)++] = *s++;
    buf[*off] = '\0';
}

int
dw_backtrace_format(const struct dw_reader *r, const uint32_t *pcs, int n,
                    char *buf, size_t buflen)
{
    size_t off = 0;
    int i;

    if (buflen == 0)
        return 0;
    buf[0] = '\0';

    for (i = 0; i < n; i++) {
        /* A return address points just past its call; look up addr-1 for every
         * frame but the live one so it lands in the call's line range. */
        uint32_t look = (i == 0 || pcs[i] == 0) ? pcs[i] : pcs[i] - 1;
        const char *fn = NULL, *file = NULL;
        int line = 0;
        char head[64];
        int known = (r && dw_lookup_func(r, look, &fn) && fn);

        /* The fp walk is already bounded against a corrupt chain, but a
         * monotonic fp can still carry a garbage return address.  A caller
         * frame (i > 0) that lands in no known function means the chain has
         * wandered out of real code, so stop with one marker rather than print
         * bogus frames up to the depth cap.  Only when a reader is present: with
         * none every frame is unknown, so raw addresses are all there is to
         * show, and the live pc (frame 0) can be a wild address and still is the
         * fault site worth printing. */
        if (r && i > 0 && !known) {
            char note[96];
            snprintf(note, sizeof note, "#%-2d 0x%08x  ?? (trace truncated: "
                     "return address in no known function)\n", i, pcs[i]);
            bt_append(buf, buflen, &off, note);
            return i + 1;
        }

        snprintf(head, sizeof head, "#%-2d 0x%08x  ", i, pcs[i]);
        bt_append(buf, buflen, &off, head);

        if (known)
            bt_append(buf, buflen, &off, fn);
        else
            bt_append(buf, buflen, &off, "??");

        if (r && dw_lookup_line(r, look, &file, &line) && line > 0) {
            char tail[80];
            snprintf(tail, sizeof tail, " at %s:%d",
                     file ? file : "??", line);
            bt_append(buf, buflen, &off, tail);
        }
        bt_append(buf, buflen, &off, "\n");
    }
    return n;
}
