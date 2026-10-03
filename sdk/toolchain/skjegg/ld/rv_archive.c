/* rv_archive.c : ar(1) archive (.a) support for skj-ld-rv.
 *
 * A static archive is a symbol index plus a bag of relocatable objects.  The
 * linker pulls in only the members that define a symbol some already-loaded
 * object references but nothing defines, iterating until the set is stable
 * (a pulled member can reference further symbols).  We rely on the GNU/SysV
 * symbol index (member "/"); "ar rcs" and ranlib write it.
 *
 * Member selection is driven entirely by "is this symbol still undefined?"
 * (sym_needed): once a member is pulled its symbols become defined, so no
 * later index entry re-pulls it, which is why no explicit loaded-set is kept.
 */

#include "rv_ld.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/****************************************************************
 * ar field helpers
 ****************************************************************/

static uint32_t
be32(const uint8_t *p)
{
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) |
           ((uint32_t)p[2] << 8) | (uint32_t)p[3];
}

/* Decimal ASCII field of width w, space padded. */
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

/* The member's own name, resolving a GNU long name ("/N" -> offset N in the
 * "//" string table), formatted as "archive.a(member.o)" for diagnostics. */
static const char *
member_name(struct arena *a, const uint8_t *h, const char *ext,
            uint32_t extlen, const char *arpath)
{
    char mem[64];
    int k = 0;

    if (h[0] == '/' && h[1] >= '0' && h[1] <= '9') {
        long off = ar_num(h + 1, 15);
        while (off + k < (long)extlen && ext[off + k] != '/'
               && ext[off + k] != '\n' && k < (int)sizeof(mem) - 1) {
            mem[k] = ext[off + k];
            k++;
        }
    } else {
        while (k < 16 && h[k] != '/' && h[k] != ' '
               && k < (int)sizeof(mem) - 1) {
            mem[k] = (char)h[k];
            k++;
        }
    }
    mem[k] = '\0';

    size_t n = strlen(arpath) + strlen(mem) + 3;
    char *out = arena_alloc(a, n);
    snprintf(out, n, "%s(%s)", arpath, mem);
    return out;
}

/****************************************************************
 * Loaded-member set
 *
 * A member is pulled at most once even if a (malformed) index keeps listing a
 * symbol the member does not actually define, which would otherwise leave the
 * symbol undefined and re-pull the member without end.  Keyed by (archive,
 * offset) since a member offset is unique within its archive but not across
 * archives, and offset (not name) so duplicate member names still each load.
 * rv_ld_archive_reset() clears it per link so no state survives a call.
 ****************************************************************/

struct loaded_member {
    const char *path;
    uint32_t off;
};

static struct loaded_member *g_loaded;
static int g_nloaded;
static int g_loaded_cap;

void
rv_ld_archive_reset(void)
{
    free(g_loaded);
    g_loaded = NULL;
    g_nloaded = 0;
    g_loaded_cap = 0;
}

static int
member_seen(const char *path, uint32_t off)
{
    for (int i = 0; i < g_nloaded; i++)
        if (g_loaded[i].off == off && strcmp(g_loaded[i].path, path) == 0)
            return 1;
    return 0;
}

static void
member_mark(const char *path, uint32_t off)
{
    if (g_nloaded >= g_loaded_cap) {
        g_loaded_cap = g_loaded_cap ? g_loaded_cap * 2 : 16;
        g_loaded = realloc(g_loaded,
                           (size_t)g_loaded_cap * sizeof(*g_loaded));
        if (!g_loaded)
            die("out of memory");
    }
    g_loaded[g_nloaded].path = path;
    g_loaded[g_nloaded].off = off;
    g_nloaded++;
}

/****************************************************************
 * Symbol state over the currently loaded objects
 ****************************************************************/

/* A symbol is "needed" when some loaded object references it (a GLOBAL UNDEF)
 * and none defines it, so pulling a member that provides it is warranted. */
static int
sym_needed(struct linker *ld, const char *name)
{
    int undef = 0, def = 0;

    for (int oi = 0; oi < ld->nobjs; oi++) {
        struct ld_object *obj = &ld->objs[oi];
        for (int si = 0; si < obj->nsyms; si++) {
            struct ld_input_sym *s = &obj->syms[si];
            if (s->binding != STB_GLOBAL || strcmp(s->name, name) != 0)
                continue;
            if (s->shndx == SHN_UNDEF)
                undef = 1;
            else
                def = 1;
        }
    }
    return undef && !def;
}

/****************************************************************
 * Archive reader
 ****************************************************************/

int
rv_ld_is_archive(const char *path)
{
    FILE *f = fopen(path, "rb");
    char magic[8];
    size_t n;

    if (!f)
        return 0;
    n = fread(magic, 1, 8, f);
    fclose(f);
    return n == 8 && memcmp(magic, "!<arch>\n", 8) == 0;
}

int
rv_ld_read_archive(struct linker *ld, const char *path)
{
    struct mapfile mf;
    const uint8_t *buf;
    size_t len;
    const uint8_t *symtab = NULL;
    uint32_t symtab_size = 0;
    const char *ext = NULL;
    uint32_t ext_size = 0;
    int added = 0;

    if (mapfile_open(&mf, path) != OK)
        die("cannot open %s", path);
    buf = mf.data;
    len = mf.len;

    if (len < 8 || memcmp(buf, "!<arch>\n", 8) != 0)
        die("%s: not an ar archive", path);

    /* first pass: find the symbol index ("/") and the long-name table ("//") */
    for (size_t pos = 8; pos + 60 <= len; ) {
        const uint8_t *h = buf + pos;
        long size = ar_num(h + 48, 10);

        if (h[0] == '/' && h[1] == ' ') {
            symtab = buf + pos + 60;
            symtab_size = (uint32_t)size;
        } else if (h[0] == '/' && h[1] == '/') {
            ext = (const char *)(buf + pos + 60);
            ext_size = (uint32_t)size;
        }
        pos += 60 + (size_t)size;
        if (size & 1)
            pos++;                      /* members are 2-byte aligned */
    }

    if (!symtab || symtab_size < 4)
        die("%s: no symbol index (build the archive with 'ar rcs' or ranlib)",
            path);

    /* A corrupt or truncated archive must be rejected, not walked off the end
       of the mapping: the index and long-name members must lie within it. */
    if ((size_t)(symtab - buf) + symtab_size > len)
        die("%s: symbol index runs past the end of the archive", path);
    if (ext && (size_t)((const uint8_t *)ext - buf) + ext_size > len)
        die("%s: long-name table runs past the end of the archive", path);

    /* GNU index: be32 count, count be32 member offsets, count NUL names */
    uint32_t nsym = be32(symtab);
    if ((uint64_t)4 + (uint64_t)nsym * 4 > symtab_size)
        die("%s: symbol index count exceeds its member", path);
    const uint8_t *offs = symtab + 4;
    const char *names = (const char *)(symtab + 4 + (size_t)nsym * 4);
    const char *names_end = (const char *)(symtab + symtab_size);

    int changed = 1;
    while (changed) {
        changed = 0;
        const char *np = names;
        for (uint32_t i = 0; i < nsym; i++) {
            const char *name = np;
            const void *nul = memchr(np, '\0', (size_t)(names_end - np));
            if (!nul)
                die("%s: unterminated name in symbol index", path);
            np = (const char *)nul + 1;
            if (!sym_needed(ld, name))
                continue;

            uint32_t moff = be32(offs + (size_t)i * 4);
            if (member_seen(path, moff))
                continue;               /* never pull one member twice */
            if ((size_t)moff + 60 > len)
                die("%s: bad member offset in symbol index", path);
            const uint8_t *h = buf + moff;
            long msize = ar_num(h + 48, 10);
            if ((size_t)moff + 60 + (size_t)msize > len)
                die("%s: member overruns the archive", path);

            /* copy the member out so it survives closing the archive */
            uint8_t *copy = arena_alloc(&ld->arena, (size_t)msize);
            memcpy(copy, buf + moff + 60, (size_t)msize);
            const char *mname = member_name(&ld->arena, h, ext, ext_size, path);

            struct ld_object *obj = ld_add_object(ld);
            rv_parse_elf(&ld->arena, obj, copy, (size_t)msize, mname);
            member_mark(path, moff);
            added++;
            changed = 1;
        }
    }

    mapfile_close(&mf);
    return added;
}
