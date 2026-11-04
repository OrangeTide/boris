/* ar/main.c : skj-ar, a minimal ar(1) archive tool.
 *
 * Creates GNU/SysV "!<arch>\n" archives with a symbol index, lists their
 * members, and extracts them.  The symbol index is what a linker uses to pull
 * only the members that resolve an undefined symbol, so skj-ar writes one for
 * every create (the "s" of "ar rcs"); skj-ld, skj-ld-rv, and skj-ld-mips read
 * it.  The tool is generic over the object machine and byte order: it parses
 * the ELF32 symbol table of each member (either endianness) to list the
 * defined global symbols, and copies member bytes verbatim, so one skj-ar
 * serves every target.
 *
 * Supported: create/replace (r, q, and the c/s/u/v/D modifiers, which build
 * the whole archive from the listed members with a fresh symbol index), list
 * (t), and extract (x).  Timestamps, uid, gid are written as zero
 * (deterministic); member mode is 0644.  Long member names go in the GNU "//"
 * string table.
 */

#include "util.h"
#include "arena.h"
#include "mapfile.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

/****************************************************************
 * ELF32 symbol reading (either endianness)
 ****************************************************************/

#define ELF_ST_BIND(i)  ((i) >> 4)
#define ELF_ST_TYPE(i)  ((i) & 0xf)

struct elf_view {
    const uint8_t *buf;
    size_t len;
    int le;                     /* 1 little-endian, 0 big-endian */
};

static uint16_t
rd16(const struct elf_view *e, size_t off)
{
    const uint8_t *p = e->buf + off;
    return e->le ? (uint16_t)(p[0] | (p[1] << 8))
                 : (uint16_t)((p[0] << 8) | p[1]);
}

static uint32_t
rd32(const struct elf_view *e, size_t off)
{
    const uint8_t *p = e->buf + off;
    return e->le
        ? (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
          ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24)
        : ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) |
          ((uint32_t)p[2] << 8) | (uint32_t)p[3];
}

/* True and fills *e if buf is an ELF32 relocatable object we can index. */
static int
elf_open(struct elf_view *e, const uint8_t *buf, size_t len)
{
    e->buf = buf;
    e->len = len;
    if (len < 52 || memcmp(buf, "\177ELF", 4) != 0)
        return 0;
    if (buf[4] != 1)            /* ELFCLASS32 */
        return 0;
    if (buf[5] == 1)
        e->le = 1;
    else if (buf[5] == 2)
        e->le = 0;
    else
        return 0;
    return 1;
}

/* Call cb(name, ctx) for each defined global/weak symbol of an ELF32 member.
 * A defined symbol is one whose st_shndx is not SHN_UNDEF (0); this includes
 * common and absolute symbols, matching what ar/ranlib index. */
static void
elf_each_defined_global(const struct elf_view *e,
                        void (*cb)(const char *, void *), void *ctx)
{
    uint32_t shoff = rd32(e, 32);
    uint16_t shnum = rd16(e, 48);

    for (uint16_t i = 0; i < shnum; i++) {
        size_t sh = shoff + (size_t)i * 40;
        if (sh + 40 > e->len)
            return;
        if (rd32(e, sh + 4) != 2)       /* SHT_SYMTAB */
            continue;

        uint32_t sym_off = rd32(e, sh + 16);
        uint32_t sym_size = rd32(e, sh + 20);
        uint32_t link = rd32(e, sh + 24);
        if ((size_t)link * 40 + 40 > shnum * 40u)
            return;
        uint32_t str_off = rd32(e, shoff + (size_t)link * 40 + 16);
        int count = (int)(sym_size / 16);

        for (int s = 0; s < count; s++) {
            size_t so = sym_off + (size_t)s * 16;
            if (so + 16 > e->len)
                break;
            uint32_t st_name = rd32(e, so + 0);
            uint8_t st_info = e->buf[so + 12];
            uint16_t st_shndx = rd16(e, so + 14);
            int bind = ELF_ST_BIND(st_info);

            if (st_shndx == 0)                  /* SHN_UNDEF */
                continue;
            if (bind != 1 && bind != 2)         /* GLOBAL, WEAK */
                continue;
            const char *name = (const char *)e->buf + str_off + st_name;
            if (name[0] == '\0')
                continue;
            cb(name, ctx);
        }
        return;                                 /* one symtab is enough */
    }
}

/****************************************************************
 * Members and symbols
 ****************************************************************/

struct member {
    const char *path;           /* path as given on the command line */
    const char *base;           /* basename, for the archive header */
    uint8_t *data;
    long size;
    int longname;               /* stored via the "//" table */
    long ext_off;               /* its offset in the "//" table */
    long hdr_off;               /* offset of its 60-byte header in the file */
};

struct symbol {
    const char *name;
    int member;                 /* index into members[] */
};

static struct member *members;
static int nmembers;
static struct symbol *symbols;
static int nsymbols;
static int sym_cap;
static int cur_member;          /* member being scanned, for the callback */

static void
add_symbol(const char *name, void *ctx)
{
    (void)ctx;
    if (nsymbols >= sym_cap) {
        sym_cap = sym_cap ? sym_cap * 2 : 64;
        symbols = realloc(symbols, (size_t)sym_cap * sizeof(*symbols));
        if (!symbols)
            die("out of memory");
    }
    symbols[nsymbols].name = name;
    symbols[nsymbols].member = cur_member;
    nsymbols++;
}

static const char *
basename_of(const char *path)
{
    const char *slash = strrchr(path, '/');
    return slash ? slash + 1 : path;
}

/****************************************************************
 * Writing an ar header
 ****************************************************************/

/* Left-justify s into field[0..width), space padded, no NUL. */
static void
field_set(uint8_t *field, int width, const char *s)
{
    int n = (int)strlen(s);
    if (n > width)
        n = width;
    memcpy(field, s, (size_t)n);
    for (int i = n; i < width; i++)
        field[i] = ' ';
}

/* Write a 60-byte member header.  name is the already-formatted name field
 * (e.g. "foo.o/" or "/12"); size is the member's data length. */
static void
write_header(FILE *f, const char *name, long size, const char *mode)
{
    uint8_t h[60];
    char num[16];

    field_set(h + 0, 16, name);
    field_set(h + 16, 12, "0");                 /* mtime */
    field_set(h + 28, 6, "0");                  /* uid */
    field_set(h + 34, 6, "0");                  /* gid */
    field_set(h + 40, 8, mode);                 /* mode (octal) */
    snprintf(num, sizeof(num), "%ld", size);
    field_set(h + 48, 10, num);                 /* size */
    h[58] = 0x60;                               /* "`\n" magic */
    h[59] = '\n';
    fwrite(h, 1, 60, f);
}

/* Even 2-byte alignment: members are padded with a newline. */
static void
pad_even(FILE *f, long size)
{
    if (size & 1)
        fputc('\n', f);
}

static uint8_t *
read_file(struct arena *a, const char *path, long *sizep)
{
    struct mapfile mf;
    uint8_t *copy;

    if (mapfile_open(&mf, path) != OK)
        die("cannot open %s", path);
    copy = arena_alloc(a, mf.len ? mf.len : 1);
    memcpy(copy, mf.data, mf.len);
    *sizep = (long)mf.len;
    mapfile_close(&mf);
    return copy;
}

/****************************************************************
 * Create
 ****************************************************************/

static void
be32_put(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v >> 24);
    p[1] = (uint8_t)(v >> 16);
    p[2] = (uint8_t)(v >> 8);
    p[3] = (uint8_t)v;
}

static int
create_archive(struct arena *a, const char *path, int nin, const char **in)
{
    /* read every member and collect its defined global symbols */
    members = calloc((size_t)(nin ? nin : 1), sizeof(*members));
    if (!members)
        die("out of memory");
    nmembers = nin;

    for (int i = 0; i < nin; i++) {
        struct elf_view e;
        members[i].path = in[i];
        members[i].base = basename_of(in[i]);
        members[i].data = read_file(a, in[i], &members[i].size);
        cur_member = i;
        if (elf_open(&e, members[i].data, (size_t)members[i].size))
            elf_each_defined_global(&e, add_symbol, NULL);
    }

    /* the "//" long-name table, for basenames that do not fit the 16-byte
       name field as "name/" (15 chars plus the slash) */
    long ext_size = 0;
    for (int i = 0; i < nmembers; i++) {
        if (strlen(members[i].base) > 15) {
            members[i].longname = 1;
            members[i].ext_off = ext_size;
            ext_size += (long)strlen(members[i].base) + 2;   /* name "/\n" */
        }
    }
    int have_ext = ext_size > 0;

    /* symbol index size: be32 count, count be32 offsets, then the NUL names */
    long names_bytes = 0;
    for (int i = 0; i < nsymbols; i++)
        names_bytes += (long)strlen(symbols[i].name) + 1;
    long idx_size = 4 + (long)nsymbols * 4 + names_bytes;

    /* file layout: magic, "/" index, optional "//" names, then members */
    long pos = 8;
    pos += 60 + idx_size + (idx_size & 1);
    if (have_ext)
        pos += 60 + ext_size + (ext_size & 1);
    for (int i = 0; i < nmembers; i++) {
        members[i].hdr_off = pos;
        pos += 60 + members[i].size + (members[i].size & 1);
    }

    /* build the symbol index payload now that member offsets are known */
    uint8_t *idx = arena_alloc(a, (size_t)(idx_size ? idx_size : 1));
    be32_put(idx, (uint32_t)nsymbols);
    for (int i = 0; i < nsymbols; i++)
        be32_put(idx + 4 + (size_t)i * 4,
                 (uint32_t)members[symbols[i].member].hdr_off);
    {
        char *np = (char *)idx + 4 + (size_t)nsymbols * 4;
        for (int i = 0; i < nsymbols; i++) {
            size_t n = strlen(symbols[i].name) + 1;
            memcpy(np, symbols[i].name, n);
            np += n;
        }
    }

    FILE *f = fopen(path, "wb");
    if (!f)
        die("cannot create %s", path);

    fwrite("!<arch>\n", 1, 8, f);

    write_header(f, "/", idx_size, "0");
    fwrite(idx, 1, (size_t)idx_size, f);
    pad_even(f, idx_size);

    if (have_ext) {
        write_header(f, "//", ext_size, "0");
        for (int i = 0; i < nmembers; i++) {
            if (!members[i].longname)
                continue;
            fwrite(members[i].base, 1, strlen(members[i].base), f);
            fputc('/', f);
            fputc('\n', f);
        }
        pad_even(f, ext_size);
    }

    for (int i = 0; i < nmembers; i++) {
        char name[24];
        if (members[i].longname)
            snprintf(name, sizeof(name), "/%ld", members[i].ext_off);
        else
            snprintf(name, sizeof(name), "%s/", members[i].base);
        write_header(f, name, members[i].size, "644");
        fwrite(members[i].data, 1, (size_t)members[i].size, f);
        pad_even(f, members[i].size);
    }

    fclose(f);
    return 0;
}

/****************************************************************
 * List and extract
 ****************************************************************/

/* Resolve a member header's name, using the "//" table for a "/N" long name. */
static void
resolve_name(const uint8_t *h, const char *ext, long extlen,
             char *out, size_t outsz)
{
    size_t k = 0;
    if (h[0] == '/' && h[1] >= '0' && h[1] <= '9') {
        long off = 0;
        for (int i = 1; i < 16 && h[i] >= '0' && h[i] <= '9'; i++)
            off = off * 10 + (h[i] - '0');
        while (off + (long)k < extlen && ext[off + k] != '/'
               && ext[off + k] != '\n' && k < outsz - 1) {
            out[k] = ext[off + k];
            k++;
        }
    } else {
        while (k < 16 && h[k] != '/' && h[k] != ' ' && k < outsz - 1) {
            out[k] = (char)h[k];
            k++;
        }
    }
    out[k] = '\0';
}

static long
ar_num(const uint8_t *p, int w)
{
    long v = 0;
    for (int i = 0; i < w; i++) {
        if (p[i] < '0' || p[i] > '9')
            break;
        v = v * 10 + (p[i] - '0');
    }
    return v;
}

static int
walk_archive(const char *path, int extract)
{
    struct mapfile mf;
    const uint8_t *buf;
    size_t len;
    const char *ext = NULL;
    long ext_size = 0;

    if (mapfile_open(&mf, path) != OK)
        die("cannot open %s", path);
    buf = mf.data;
    len = mf.len;
    if (len < 8 || memcmp(buf, "!<arch>\n", 8) != 0)
        die("%s: not an ar archive", path);

    /* find the "//" long-name table first */
    for (size_t pos = 8; pos + 60 <= len; ) {
        const uint8_t *h = buf + pos;
        long size = ar_num(h + 48, 10);
        if (h[0] == '/' && h[1] == '/') {
            ext = (const char *)(buf + pos + 60);
            ext_size = size;
        }
        pos += 60 + (size_t)size + (size & 1);
    }

    for (size_t pos = 8; pos + 60 <= len; ) {
        const uint8_t *h = buf + pos;
        long size = ar_num(h + 48, 10);

        /* the index "/" and the name table "//" are not real members */
        int special = (h[0] == '/' && (h[1] == ' ' || h[1] == '/'));

        if (!special) {
            char name[256];
            resolve_name(h, ext, ext_size, name, sizeof(name));
            if (extract) {
                FILE *o = fopen(name, "wb");
                if (!o)
                    die("cannot create %s", name);
                fwrite(buf + pos + 60, 1, (size_t)size, o);
                fclose(o);
            } else {
                printf("%s\n", name);
            }
        }
        pos += 60 + (size_t)size + (size & 1);
    }

    mapfile_close(&mf);
    return 0;
}

/****************************************************************
 * Driver
 ****************************************************************/

static void
usage(FILE *out)
{
    fprintf(out,
            "usage: skj-ar {rcs|t|x} archive.a [member.o ...]\n"
            "\n"
            "Minimal ar(1): create a GNU archive with a symbol index (r/c/s),\n"
            "list members (t), or extract them (x).  Generic over the object\n"
            "machine and byte order.\n");
}

int
main(int argc, char **argv)
{
    struct arena arena;
    const char *keys, *path;
    volatile int mode = 0;      /* 'r' create, 't' list, 'x' extract */

    util_set_progname("skj-ar");

    if (argc >= 2 && (strcmp(argv[1], "-h") == 0 ||
                      strcmp(argv[1], "--help") == 0)) {
        usage(stdout);
        return 0;
    }
    if (argc < 3) {
        usage(stderr);
        return 1;
    }
    keys = argv[1];
    path = argv[2];

    for (const char *k = keys; *k; k++) {
        switch (*k) {
        case 'r': case 'q':
            mode = 'r';
            break;
        case 't':
            mode = 't';
            break;
        case 'x':
            mode = 'x';
            break;
        case 'c': case 's': case 'u': case 'v': case 'D': case 'S':
            break;              /* accepted, no effect (always deterministic) */
        default:
            die("unknown operation '%c'", *k);
        }
    }
    if (mode == 0) {
        usage(stderr);
        return 1;
    }

    if (setjmp(util_die_env) != 0)
        return 1;
    util_die_active = 1;

    arena_init(&arena);

    if (mode == 'r')
        create_archive(&arena, path, argc - 3, (const char **)argv + 3);
    else
        walk_archive(path, mode == 'x');

    arena_free(&arena);
    return 0;
}
