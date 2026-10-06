/* cas-tree.c : tree-structured content layer on CAS */
/* Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 * Licensed under BSD-2-Clause-Patent OR MIT */

#define _POSIX_C_SOURCE 200809L

#include "cas-tree.h"
#include "cas-pack.h"

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#define REF_PATH_MAX 512

struct cas_tree {
    struct cas *store;
    unsigned flags;
};

/****************************************************************
 * Lifecycle
 ****************************************************************/

struct cas_tree *
cas_tree_new(struct cas *store)
{
    struct cas_tree *ct = calloc(1, sizeof(*ct));

    if (!ct)
        return NULL;
    ct->store = store;
    return ct;
}

void
cas_tree_free(struct cas_tree *ct)
{
    free(ct);
}

struct cas *
cas_tree_cas(struct cas_tree *ct)
{
    return ct->store;
}

void
cas_tree_set_flags(struct cas_tree *ct, unsigned flags)
{
    ct->flags = flags;
}

unsigned
cas_tree_get_flags(struct cas_tree *ct)
{
    return ct->flags;
}

/****************************************************************
 * Directory building
 ****************************************************************/

void
cas_tree_dir_init(struct cas_tree_dir *dir)
{
    dir->entries = NULL;
    dir->count = 0;
    dir->_cap = 0;
}

void
cas_tree_dir_free(struct cas_tree_dir *dir)
{
    free(dir->entries);
    dir->entries = NULL;
    dir->count = 0;
    dir->_cap = 0;
}

/****************************************************************
 * Name validation and canonical ordering
 ****************************************************************/

/** Compare two names in unsigned byte order.
 *
 *  This is the canonical order.  For well-formed UTF-8 it is also
 *  codepoint order, because UTF-8 is designed so that byte-wise
 *  comparison and codepoint comparison agree, so a single rule serves
 *  both and no table is needed to apply it.
 *
 *  Spelled out with memcmp rather than strcmp because the ordering is
 *  part of the format: it must be unsigned, and it must break a tie
 *  between a name and its own prefix by length.
 */
static int
name_cmp(const char *a, const char *b)
{
    size_t la = strlen(a);
    size_t lb = strlen(b);
    size_t n = la < lb ? la : lb;
    int c = memcmp(a, b, n);

    if (c != 0)
        return c;
    if (la != lb)
        return la < lb ? -1 : 1;
    return 0;
}

/** Reject anything that is not well-formed UTF-8.
 *
 *  Strict about the three encodings a lenient decoder would accept and
 *  a canonical form must not: an overlong sequence, a surrogate, and a
 *  codepoint past U+10FFFF.  Overlong forms matter most.  Without this
 *  check a name may carry C0 AF, which is not the byte 0x2F and so slips
 *  past the separator test below, yet decodes to U+002F in any consumer
 *  that is not equally strict.
 *
 *  Normalization is deliberately not attempted: NFC would need Unicode
 *  tables this library will not carry.  A producer that wants a name to
 *  address the same on every platform must normalize before storing it.
 *  Byte-distinct names are distinct entries here.
 */
static int
valid_utf8(const char *s, size_t len)
{
    const unsigned char *p = (const unsigned char *)s;
    size_t i = 0;

    while (i < len) {
        unsigned char c = p[i];
        uint32_t cp, min;
        int extra;

        if (c < 0x80) {
            i++;
            continue;
        } else if ((c & 0xe0) == 0xc0) {
            cp = c & 0x1fu; extra = 1; min = 0x80;
        } else if ((c & 0xf0) == 0xe0) {
            cp = c & 0x0fu; extra = 2; min = 0x800;
        } else if ((c & 0xf8) == 0xf0) {
            cp = c & 0x07u; extra = 3; min = 0x10000;
        } else {
            return 0;  // continuation byte, or a 5-byte or longer form
        }

        if (i + (size_t)extra >= len)
            return 0;

        for (int k = 1; k <= extra; k++) {
            unsigned char cc = p[i + k];

            if ((cc & 0xc0) != 0x80)
                return 0;
            cp = (cp << 6) | (cc & 0x3fu);
        }

        if (cp < min)
            return 0;  // overlong
        if (cp >= 0xd800 && cp <= 0xdfff)
            return 0;  // surrogate
        if (cp > 0x10ffff)
            return 0;

        i += (size_t)extra + 1;
    }
    return 1;
}

int
cas_tree_dir_add(struct cas_tree_dir *dir,
                 const struct cas_tree_entry *e)
{
    size_t nlen = strlen(e->name);

    if (nlen == 0 || nlen > CAS_TREE_NAME_MAX)
        return CAS_ERR;
    if (strchr(e->name, '/') || strchr(e->name, '\n'))
        return CAS_ERR;
    if (!valid_utf8(e->name, nlen))
        return CAS_ERR;

    if (dir->count >= dir->_cap) {
        int newcap = dir->_cap ? dir->_cap * 2 : 8;
        struct cas_tree_entry *p = realloc(dir->entries,
            (size_t)newcap * sizeof(*p));

        if (!p)
            return CAS_ENOMEM;
        dir->entries = p;
        dir->_cap = newcap;
    }
    dir->entries[dir->count++] = *e;
    return CAS_OK;
}

/****************************************************************
 * Htree (CDB-inspired binary format) helpers
 ****************************************************************/

#define HTREE_MAGIC         "HTv1"
#define HTREE_MAGIC_LEN     4
#define HTREE_FOOTER_LEN    8
#define HTREE_NBUCKETS      256
#define HTREE_HEADER_LEN    (HTREE_NBUCKETS * 8)
#define HTREE_ENTRY_DATA_LEN 56

static void
store_le32(unsigned char *p, uint32_t v)
{
    p[0] = (unsigned char)(v);
    p[1] = (unsigned char)(v >> 8);
    p[2] = (unsigned char)(v >> 16);
    p[3] = (unsigned char)(v >> 24);
}

static uint32_t
load_le32(const unsigned char *p)
{
    return (uint32_t)p[0] |
           ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) |
           ((uint32_t)p[3] << 24);
}

static void
store_le64(unsigned char *p, uint64_t v)
{
    for (int i = 0; i < 8; i++)
        p[i] = (unsigned char)(v >> (i * 8));
}

static uint64_t
load_le64(const unsigned char *p)
{
    uint64_t v = 0;

    for (int i = 0; i < 8; i++)
        v |= (uint64_t)p[i] << (i * 8);
    return v;
}

static uint32_t
adler32(const unsigned char *data, size_t len)
{
    uint32_t a = 1, b = 0;

    for (size_t i = 0; i < len; i++) {
        a = (a + data[i]) % 65521;
        b = (b + a) % 65521;
    }
    return (b << 16) | a;
}

static uint32_t
djb_hash(const char *key, size_t len)
{
    uint32_t h = 5381;

    for (size_t i = 0; i < len; i++)
        h = h * 33 ^ (unsigned char)key[i];
    return h;
}

static void
htree_unpack_entry(const unsigned char *data, const char *key,
                   size_t keylen, struct cas_tree_entry *e)
{
    memcpy(e->name, key, keylen);
    e->name[keylen] = '\0';
    e->mode = (int)load_le32(data);
    e->uid = (int)load_le32(data + 4);
    e->gid = (int)load_le32(data + 8);
    e->mtime_s = (int64_t)load_le64(data + 12);
    e->mtime_ns = (int32_t)load_le32(data + 20);
    cas_hex_encode(data + 24, CAS_HASH_LEN, e->hash);
}

static char *
tree_serialize(struct cas_tree_dir *dir, size_t *len_out)
{
    size_t bodylen = 1;

    for (int i = 0; i < dir->count; i++) {
        struct cas_tree_entry *e = &dir->entries[i];
        int n = snprintf(NULL, 0,
            "%06o %d %d %" PRId64 " %" PRId32 " %s %s\n",
            (unsigned)e->mode, e->uid, e->gid,
            e->mtime_s, e->mtime_ns, e->hash, e->name);

        if (n < 0)
            return NULL;
        bodylen += (size_t)n;
    }

    char *body = malloc(bodylen + 1);

    if (!body)
        return NULL;

    body[0] = '%';
    size_t pos = 1;

    for (int i = 0; i < dir->count; i++) {
        struct cas_tree_entry *e = &dir->entries[i];
        int n = snprintf(body + pos, bodylen + 1 - pos,
            "%06o %d %d %" PRId64 " %" PRId32 " %s %s\n",
            (unsigned)e->mode, e->uid, e->gid,
            e->mtime_s, e->mtime_ns, e->hash, e->name);

        if (n < 0 || (size_t)n >= bodylen + 1 - pos) {
            free(body);
            return NULL;
        }
        pos += (size_t)n;
    }

    *len_out = bodylen;
    return body;
}

static unsigned char *
htree_build(struct cas_tree_dir *dir, size_t *len_out)
{
    int n = dir->count;
    int bucket_count[HTREE_NBUCKETS];
    int table_nslots[HTREE_NBUCKETS];
    uint32_t *hashes = NULL;
    uint32_t *rec_offsets = NULL;
    int *bucket_of = NULL;

    memset(bucket_count, 0, sizeof(bucket_count));

    if (n > 0) {
        hashes = malloc((size_t)n * sizeof(*hashes));
        rec_offsets = malloc((size_t)n * sizeof(*rec_offsets));
        bucket_of = malloc((size_t)n * sizeof(*bucket_of));
        if (!hashes || !rec_offsets || !bucket_of) {
            free(hashes);
            free(rec_offsets);
            free(bucket_of);
            return NULL;
        }
    }

    size_t records_len = 0;

    for (int i = 0; i < n; i++) {
        size_t keylen = strlen(dir->entries[i].name);
        uint32_t h = djb_hash(dir->entries[i].name, keylen);
        int b = (int)(h % HTREE_NBUCKETS);

        hashes[i] = h;
        bucket_of[i] = b;
        bucket_count[b]++;
        records_len += 8 + keylen + HTREE_ENTRY_DATA_LEN;
    }

    size_t tables_len = 0;

    for (int b = 0; b < HTREE_NBUCKETS; b++) {
        table_nslots[b] = bucket_count[b] * 2;
        tables_len += (size_t)table_nslots[b] * 8;
    }

    size_t total = HTREE_HEADER_LEN + records_len + tables_len +
                   HTREE_FOOTER_LEN;
    unsigned char *buf = calloc(1, total);

    if (!buf) {
        free(hashes);
        free(rec_offsets);
        free(bucket_of);
        return NULL;
    }

    size_t pos = HTREE_HEADER_LEN;

    for (int i = 0; i < n; i++) {
        struct cas_tree_entry *e = &dir->entries[i];
        size_t keylen = strlen(e->name);
        unsigned char hash_bin[CAS_HASH_LEN];

        rec_offsets[i] = (uint32_t)pos;
        store_le32(buf + pos, (uint32_t)keylen);
        pos += 4;
        store_le32(buf + pos, HTREE_ENTRY_DATA_LEN);
        pos += 4;
        memcpy(buf + pos, e->name, keylen);
        pos += keylen;

        store_le32(buf + pos, (uint32_t)e->mode);
        pos += 4;
        store_le32(buf + pos, (uint32_t)e->uid);
        pos += 4;
        store_le32(buf + pos, (uint32_t)e->gid);
        pos += 4;
        store_le64(buf + pos, (uint64_t)e->mtime_s);
        pos += 8;
        store_le32(buf + pos, (uint32_t)e->mtime_ns);
        pos += 4;

        cas_hex_decode(e->hash, CAS_HASH_HEX, hash_bin, sizeof(hash_bin));
        memcpy(buf + pos, hash_bin, CAS_HASH_LEN);
        pos += CAS_HASH_LEN;
    }

    size_t table_pos = pos;

    for (int b = 0; b < HTREE_NBUCKETS; b++) {
        store_le32(buf + b * 8, (uint32_t)table_pos);
        store_le32(buf + b * 8 + 4, (uint32_t)table_nslots[b]);

        for (int i = 0; i < n; i++) {
            if (bucket_of[i] != b)
                continue;

            uint32_t slot = (hashes[i] / 256) %
                            (uint32_t)table_nslots[b];

            for (;;) {
                size_t spos = table_pos + (size_t)slot * 8;
                uint32_t sp = load_le32(buf + spos + 4);

                if (sp == 0) {
                    store_le32(buf + spos, hashes[i]);
                    store_le32(buf + spos + 4, rec_offsets[i]);
                    break;
                }
                slot = (slot + 1) % (uint32_t)table_nslots[b];
            }
        }

        table_pos += (size_t)table_nslots[b] * 8;
    }

    uint32_t checksum = adler32(buf, table_pos);

    store_le32(buf + table_pos, checksum);
    memcpy(buf + table_pos + 4, HTREE_MAGIC, HTREE_MAGIC_LEN);

    free(hashes);
    free(rec_offsets);
    free(bucket_of);

    *len_out = total;
    return buf;
}

static int
htree_parse_dir(const unsigned char *data, size_t len,
                struct cas_tree_dir *dir)
{
    if (len < HTREE_HEADER_LEN + HTREE_FOOTER_LEN)
        return CAS_ERR;

    if (memcmp(data + len - HTREE_MAGIC_LEN, HTREE_MAGIC,
               HTREE_MAGIC_LEN) != 0)
        return CAS_ERR;

    size_t cdb_len = len - HTREE_FOOTER_LEN;
    uint32_t stored = load_le32(data + cdb_len);
    uint32_t computed = adler32(data, cdb_len);

    if (stored != computed)
        return CAS_ERR;

    uint32_t rec_end = (uint32_t)cdb_len;

    for (int b = 0; b < HTREE_NBUCKETS; b++) {
        uint32_t tpos = load_le32(data + b * 8);
        uint32_t tslots = load_le32(data + b * 8 + 4);

        if (tslots > 0 && tpos < rec_end)
            rec_end = tpos;
    }

    cas_tree_dir_init(dir);

    size_t pos = HTREE_HEADER_LEN;

    while (pos + 8 <= rec_end) {
        uint32_t keylen = load_le32(data + pos);
        uint32_t datalen = load_le32(data + pos + 4);

        pos += 8;

        if (datalen != HTREE_ENTRY_DATA_LEN ||
            keylen == 0 || keylen > CAS_TREE_NAME_MAX ||
            pos + keylen + datalen > rec_end) {
            cas_tree_dir_free(dir);
            return CAS_ERR;
        }

        struct cas_tree_entry e;

        htree_unpack_entry(data + pos + keylen,
                           (const char *)(data + pos), keylen, &e);
        pos += keylen + datalen;

        /* Records are stored in ascending name order, so requiring it
         * here costs one comparison and rejects both a reordered object
         * and a duplicate name.  A duplicate is what matters: it would
         * let a listing and a lookup disagree about which child a name
         * has, the same divergence htree_verify exists to catch. */
        if (dir->count > 0 &&
            name_cmp(dir->entries[dir->count - 1].name, e.name) >= 0) {
            cas_tree_dir_free(dir);
            return CAS_ERR;
        }

        if (cas_tree_dir_add(dir, &e) != CAS_OK) {
            cas_tree_dir_free(dir);
            return CAS_ERR;
        }
    }

    return CAS_OK;
}

static int
htree_lookup_entry(const unsigned char *data, size_t len,
                   const char *name, struct cas_tree_entry *e_out)
{
    if (len < HTREE_HEADER_LEN + HTREE_FOOTER_LEN)
        return CAS_ERR;

    if (memcmp(data + len - HTREE_MAGIC_LEN, HTREE_MAGIC,
               HTREE_MAGIC_LEN) != 0)
        return CAS_ERR;

    size_t cdb_len = len - HTREE_FOOTER_LEN;
    size_t keylen = strlen(name);

    /* No valid record can carry a longer key, and matching one would
     * copy it into a fixed-size name field below. */
    if (keylen > CAS_TREE_NAME_MAX)
        return CAS_ENOTFOUND;

    uint32_t h = djb_hash(name, keylen);
    int b = (int)(h % HTREE_NBUCKETS);

    uint32_t tpos = load_le32(data + b * 8);
    uint32_t nslots = load_le32(data + b * 8 + 4);

    if (nslots == 0)
        return CAS_ENOTFOUND;

    uint32_t slot = (h / 256) % nslots;

    for (uint32_t i = 0; i < nslots; i++) {
        size_t spos = tpos + (size_t)((slot + i) % nslots) * 8;

        if (spos + 8 > cdb_len)
            return CAS_ERR;

        uint32_t sh = load_le32(data + spos);
        uint32_t rpos = load_le32(data + spos + 4);

        if (rpos == 0)
            return CAS_ENOTFOUND;
        if (sh != h)
            continue;

        /* Every bound here widens to size_t before it is added.  These
         * offsets come off the wire as uint32_t, so computing the sum in
         * that width lets a value near UINT32_MAX wrap past the limit it
         * is being tested against and the read go anywhere. */
        if ((size_t)rpos + 8 > cdb_len)
            return CAS_ERR;

        uint32_t rkeylen = load_le32(data + rpos);
        uint32_t rdatalen = load_le32(data + rpos + 4);

        if (rkeylen != (uint32_t)keylen)
            continue;
        if (rdatalen != HTREE_ENTRY_DATA_LEN)
            return CAS_ERR;
        if ((size_t)rpos + 8 + rkeylen + rdatalen > cdb_len)
            return CAS_ERR;
        if (memcmp(data + rpos + 8, name, keylen) != 0)
            continue;

        htree_unpack_entry(data + rpos + 8 + rkeylen,
                           name, keylen, e_out);
        return CAS_OK;
    }

    return CAS_ENOTFOUND;
}

static int parse_entry(const char *line, size_t linelen,
                       struct cas_tree_entry *e);

static int
tree_text_lookup(const unsigned char *data, size_t len,
                 const char *name, struct cas_tree_entry *e_out)
{
    if (len < 1 || data[0] != '%')
        return CAS_ERR;

    const char *p = (const char *)data + 1;
    const char *end = (const char *)data + len;
    struct cas_tree_entry prev;
    int have_prev = 0;

    /* Stops at the match, and validates only the lines it passed on the
     * way.  A read does not re-verify a whole object: objects are
     * checked as they enter the store, and what is in the store is
     * trusted (see cas_tree_put_checked).  Scanning past the answer to
     * re-prove a property that was established on write would be work
     * every lookup pays and no lookup needs.
     *
     * The prefix check is kept because it is free.  This loop compares
     * names anyway, and the early exit below is only sound while the
     * order holds, so noticing a break in it costs nothing and keeps the
     * function from silently reporting a name absent. */
    while (p < end) {
        const char *nl = memchr(p, '\n', (size_t)(end - p));

        if (!nl)
            return CAS_ERR;

        size_t linelen = (size_t)(nl - p);
        struct cas_tree_entry e;

        if (parse_entry(p, linelen, &e) != CAS_OK)
            return CAS_ERR;

        if (have_prev && name_cmp(prev.name, e.name) >= 0)
            return CAS_ERR;

        int cmp = name_cmp(e.name, name);

        if (cmp == 0) {
            *e_out = e;
            return CAS_OK;
        }
        if (cmp > 0)
            return CAS_ENOTFOUND;

        prev = e;
        have_prev = 1;
        p = nl + 1;
    }

    return CAS_ENOTFOUND;
}

/****************************************************************
 * Serialization
 ****************************************************************/

static int
entry_cmp(const void *a, const void *b)
{
    const struct cas_tree_entry *ea = a;
    const struct cas_tree_entry *eb = b;

    return name_cmp(ea->name, eb->name);
}

int
cas_tree_store(struct cas_tree *ct, struct cas_tree_dir *dir,
               char *hash_out)
{
    if (dir->count > 1)
        qsort(dir->entries, (size_t)dir->count,
              sizeof(*dir->entries), entry_cmp);

    /* Two entries under one name have no canonical order, so the
     * address they produce would depend on how qsort happened to break
     * the tie.  Refuse rather than mint an unstable address. */
    for (int i = 1; i < dir->count; i++) {
        if (name_cmp(dir->entries[i - 1].name, dir->entries[i].name) == 0)
            return CAS_ERR;
    }

    size_t textlen;
    char *text = tree_serialize(dir, &textlen);

    if (!text)
        return CAS_ENOMEM;

    int rc;

    if (ct->flags & CAS_TREE_USE_HTREE) {
        rc = cas_hash_object("tree", text, textlen, hash_out);
        free(text);
        if (rc != CAS_OK)
            return rc;

        if (cas_exists(ct->store, hash_out))
            return CAS_OK;

        size_t binlen;
        unsigned char *bin = htree_build(dir, &binlen);

        if (!bin)
            return CAS_ENOMEM;

        rc = cas_put_object_at(ct->store, "htree", bin, binlen,
                               hash_out);
        free(bin);
    } else {
        rc = cas_put_object(ct->store, "tree", text, textlen,
                            hash_out);
        free(text);
    }

    return rc;
}

/****************************************************************
 * Deserialization
 ****************************************************************/

static int
parse_entry(const char *line, size_t linelen,
            struct cas_tree_entry *e)
{
    unsigned int mode;
    long long mtime_s;
    int mtime_ns;
    int n = 0;

    if (sscanf(line, "%o %d %d %lld %d %n",
               &mode, &e->uid, &e->gid,
               &mtime_s, &mtime_ns, &n) < 5)
        return CAS_ERR;

    e->mode = (int)mode;
    e->mtime_s = (int64_t)mtime_s;
    e->mtime_ns = (int32_t)mtime_ns;

    if ((size_t)n + CAS_HASH_HEX + 2 > linelen)
        return CAS_ERR;

    memcpy(e->hash, line + n, CAS_HASH_HEX);
    e->hash[CAS_HASH_HEX] = '\0';

    if (line[n + CAS_HASH_HEX] != ' ')
        return CAS_ERR;

    const char *name = line + n + CAS_HASH_HEX + 1;
    size_t namelen = linelen - (size_t)(n + CAS_HASH_HEX + 1);

    if (namelen == 0 || namelen > CAS_TREE_NAME_MAX)
        return CAS_ERR;

    memcpy(e->name, name, namelen);
    e->name[namelen] = '\0';
    return CAS_OK;
}

static int
tree_text_load(const unsigned char *data, size_t len,
               struct cas_tree_dir *dir)
{
    cas_tree_dir_init(dir);

    if (len < 1 || data[0] != '%')
        return CAS_ERR;

    const char *p = (const char *)data + 1;
    const char *end = (const char *)data + len;

    while (p < end) {
        const char *nl = memchr(p, '\n', (size_t)(end - p));

        if (!nl) {
            cas_tree_dir_free(dir);
            return CAS_ERR;
        }

        size_t linelen = (size_t)(nl - p);
        struct cas_tree_entry e;

        if (parse_entry(p, linelen, &e) != CAS_OK) {
            cas_tree_dir_free(dir);
            return CAS_ERR;
        }

        /* ascending, strictly: see the same check in htree_parse_dir */
        if (dir->count > 0 &&
            name_cmp(dir->entries[dir->count - 1].name, e.name) >= 0) {
            cas_tree_dir_free(dir);
            return CAS_ERR;
        }

        if (cas_tree_dir_add(dir, &e) != CAS_OK) {
            cas_tree_dir_free(dir);
            return CAS_ERR;
        }

        p = nl + 1;
    }

    return CAS_OK;
}

int
cas_tree_load(struct cas_tree *ct, const char *hash,
              struct cas_tree_dir *dir)
{
    struct cas_file cf;
    char type[CAS_TYPE_MAX + 1];

    int rc = cas_open_object(ct->store, &cf, hash, type,
                             sizeof(type));

    if (rc != CAS_OK)
        return rc;

    if (strcmp(type, "tree") == 0) {
        rc = tree_text_load(cf.data, cf.len, dir);
    } else if (strcmp(type, "htree") == 0) {
        rc = htree_parse_dir(cf.data, cf.len, dir);
    } else {
        rc = CAS_ETYPE;
    }

    cas_close(&cf);
    return rc;
}

int
cas_tree_lookup(struct cas_tree *ct, const char *tree_hash,
                const char *name, struct cas_tree_entry *e_out)
{
    struct cas_file cf;
    char type[CAS_TYPE_MAX + 1];

    int rc = cas_open_object(ct->store, &cf, tree_hash, type,
                             sizeof(type));

    if (rc != CAS_OK)
        return rc;

    if (strcmp(type, "htree") == 0)
        rc = htree_lookup_entry(cf.data, cf.len, name, e_out);
    else if (strcmp(type, "tree") == 0)
        rc = tree_text_lookup(cf.data, cf.len, name, e_out);
    else
        rc = CAS_ETYPE;

    cas_close(&cf);
    return rc;
}

/****************************************************************
 * Ref helpers
 ****************************************************************/

static int
valid_ref_name(const char *name)
{
    size_t len = strlen(name);

    if (len == 0 || len > 255)
        return 0;
    if (strcmp(name, ".") == 0 || strcmp(name, "..") == 0)
        return 0;
    for (size_t i = 0; i < len; i++) {
        unsigned char c = (unsigned char)name[i];

        if (c < 0x20 || c == '/' || c == '\\')
            return 0;
    }
    return 1;
}

static int
valid_hex_hash(const char *hash)
{
    if (strlen(hash) != CAS_HASH_HEX)
        return 0;
    for (int i = 0; i < CAS_HASH_HEX; i++) {
        char c = hash[i];

        if (!((c >= '0' && c <= '9') ||
              (c >= 'a' && c <= 'f') ||
              (c >= 'A' && c <= 'F')))
            return 0;
    }
    return 1;
}

static int
fsync_dir(const char *dirpath)
{
    int fd = open(dirpath, O_RDONLY | O_DIRECTORY);

    if (fd < 0)
        return -1;
    fsync(fd);
    close(fd);
    return 0;
}

static int
ref_path(struct cas *store, const char *name, const char *ext,
         char *buf, size_t bufsz)
{
    int n = snprintf(buf, bufsz, "%s/refs/%s%s",
                     cas_basedir(store), name, ext);

    if (n < 0 || (size_t)n >= bufsz)
        return CAS_ERR;
    return CAS_OK;
}

static int
ensure_refs_dir(struct cas *store)
{
    char path[REF_PATH_MAX];
    int n = snprintf(path, sizeof(path), "%s/refs",
                     cas_basedir(store));

    if (n < 0 || (size_t)n >= sizeof(path))
        return CAS_ERR;
    mkdir(cas_basedir(store), 0755);
    if (mkdir(path, 0755) != 0 && errno != EEXIST)
        return CAS_EIO;
    return CAS_OK;
}

/****************************************************************
 * Refs and log
 ****************************************************************/

int
cas_tree_ref_read(struct cas_tree *ct, const char *name,
                  char *hash_out)
{
    if (!valid_ref_name(name))
        return CAS_ERR;

    char path[REF_PATH_MAX];

    if (ref_path(ct->store, name, ".root", path, sizeof(path))
        != CAS_OK)
        return CAS_ERR;

    FILE *fp = fopen(path, "r");

    if (!fp)
        return CAS_ENOTFOUND;

    char line[CAS_HASH_HEX + 2];

    if (!fgets(line, sizeof(line), fp)) {
        fclose(fp);
        return CAS_EIO;
    }
    fclose(fp);

    size_t len = strlen(line);

    if (len > 0 && line[len - 1] == '\n')
        line[--len] = '\0';
    if (len != CAS_HASH_HEX)
        return CAS_ERR;

    memcpy(hash_out, line, CAS_HASH_HEX + 1);
    return CAS_OK;
}

int
cas_tree_ref_commit(struct cas_tree *ct, const char *name,
                    const char *root_hash, const char *comment)
{
    if (!valid_ref_name(name) || !valid_hex_hash(root_hash))
        return CAS_ERR;

    if (ensure_refs_dir(ct->store) != CAS_OK)
        return CAS_EIO;

    char lockpath[REF_PATH_MAX];
    char logpath[REF_PATH_MAX];
    char rootpath[REF_PATH_MAX];
    char prevpath[REF_PATH_MAX];
    char roottmp[REF_PATH_MAX];

    if (ref_path(ct->store, name, ".lock", lockpath,
                 sizeof(lockpath)) != CAS_OK ||
        ref_path(ct->store, name, ".log", logpath,
                 sizeof(logpath)) != CAS_OK ||
        ref_path(ct->store, name, ".root", rootpath,
                 sizeof(rootpath)) != CAS_OK ||
        ref_path(ct->store, name, ".prev", prevpath,
                 sizeof(prevpath)) != CAS_OK)
        return CAS_ERR;

    if (snprintf(roottmp, sizeof(roottmp), "%s.tmp", rootpath) >=
        (int)sizeof(roottmp))
        return CAS_ERR;

    int lockfd = open(lockpath, O_CREAT | O_WRONLY, 0644);

    if (lockfd < 0)
        return CAS_EIO;
    if (flock(lockfd, LOCK_EX) != 0) {
        close(lockfd);
        return CAS_EIO;
    }

    unlink(roottmp);

    struct timespec ts;

    clock_gettime(CLOCK_REALTIME, &ts);

    FILE *logfp = fopen(logpath, "a");

    if (!logfp) {
        close(lockfd);
        return CAS_EIO;
    }
    if (fprintf(logfp, "%s %" PRId64 " %" PRId32 " %s\n",
                root_hash, (int64_t)ts.tv_sec, (int32_t)ts.tv_nsec,
                comment ? comment : "") < 0 ||
        fflush(logfp) != 0) {
        fclose(logfp);
        close(lockfd);
        return CAS_EIO;
    }
    fsync(fileno(logfp));
    fclose(logfp);

    if (access(rootpath, F_OK) == 0) {
        char prevtmp[REF_PATH_MAX];

        if (snprintf(prevtmp, sizeof(prevtmp), "%s.tmp",
                     prevpath) < (int)sizeof(prevtmp)) {
            unlink(prevtmp);
            if (link(rootpath, prevtmp) == 0)
                rename(prevtmp, prevpath);
        }
    }

    FILE *rootfp = fopen(roottmp, "w");

    if (!rootfp) {
        close(lockfd);
        return CAS_EIO;
    }
    if (fprintf(rootfp, "%s\n", root_hash) < 0 ||
        fflush(rootfp) != 0) {
        fclose(rootfp);
        unlink(roottmp);
        close(lockfd);
        return CAS_EIO;
    }
    fsync(fileno(rootfp));
    fclose(rootfp);

    if (rename(roottmp, rootpath) != 0) {
        unlink(roottmp);
        close(lockfd);
        return CAS_EIO;
    }

    char refsdir[REF_PATH_MAX];

    snprintf(refsdir, sizeof(refsdir), "%s/refs",
             cas_basedir(ct->store));
    fsync_dir(refsdir);

    close(lockfd);
    return CAS_OK;
}

int
cas_tree_log_read(struct cas_tree *ct, const char *name,
                  cas_tree_log_fn fn, void *ctx)
{
    if (!valid_ref_name(name))
        return CAS_ERR;

    char path[REF_PATH_MAX];

    if (ref_path(ct->store, name, ".log", path, sizeof(path))
        != CAS_OK)
        return CAS_ERR;

    FILE *fp = fopen(path, "r");

    if (!fp)
        return CAS_ENOTFOUND;

    char line[1024];

    while (fgets(line, sizeof(line), fp)) {
        size_t len = strlen(line);

        if (len > 0 && line[len - 1] != '\n') {
            if (feof(fp))
                break;
            fclose(fp);
            return CAS_ERR;
        }

        if (len > 0 && line[len - 1] == '\n')
            line[--len] = '\0';

        if (len < CAS_HASH_HEX + 1) {
            fclose(fp);
            return CAS_ERR;
        }

        char hash[CAS_HASH_HEX + 1];

        memcpy(hash, line, CAS_HASH_HEX);
        hash[CAS_HASH_HEX] = '\0';

        if (line[CAS_HASH_HEX] != ' ') {
            fclose(fp);
            return CAS_ERR;
        }

        long long time_s;
        int time_ns;
        int n = 0;

        if (sscanf(line + CAS_HASH_HEX + 1, "%lld %d %n",
                   &time_s, &time_ns, &n) < 2) {
            fclose(fp);
            return CAS_ERR;
        }

        const char *comment = line + CAS_HASH_HEX + 1 + n;

        if (fn(hash, (int64_t)time_s, (int32_t)time_ns,
               comment, ctx) != 0) {
            fclose(fp);
            return CAS_OK;
        }
    }

    fclose(fp);
    return CAS_OK;
}

/* Parse the leading "hash time_s" of a log line for retention.  Fills
 * *time_s from the second field; returns CAS_OK if the line has at
 * least a valid hash prefix and a parseable time_s. */
static int
log_line_time(const char *line, int64_t *time_s)
{
    if (strlen(line) < CAS_HASH_HEX + 1 ||
        line[CAS_HASH_HEX] != ' ')
        return CAS_ERR;

    long long v;

    if (sscanf(line + CAS_HASH_HEX + 1, "%lld", &v) != 1)
        return CAS_ERR;
    *time_s = (int64_t)v;
    return CAS_OK;
}

int
cas_tree_log_truncate(struct cas_tree *ct, const char *name,
                      int keep_count, time_t keep_since, int *removed)
{
    if (!valid_ref_name(name))
        return CAS_ERR;

    /* Refuse a request that would keep nothing: an empty log is almost
     * never what the caller means, and wiping every snapshot pointer is
     * too dangerous to do by accident. */
    if (keep_count <= 0 && keep_since <= 0)
        return CAS_ERR;

    char logpath[REF_PATH_MAX];
    char lockpath[REF_PATH_MAX];
    char logtmp[REF_PATH_MAX];

    if (ref_path(ct->store, name, ".log", logpath, sizeof(logpath))
        != CAS_OK ||
        ref_path(ct->store, name, ".lock", lockpath, sizeof(lockpath))
        != CAS_OK)
        return CAS_ERR;

    if (snprintf(logtmp, sizeof(logtmp), "%s.tmp", logpath) >=
        (int)sizeof(logtmp))
        return CAS_ERR;

    int lockfd = open(lockpath, O_CREAT | O_WRONLY, 0644);

    if (lockfd < 0)
        return CAS_EIO;
    if (flock(lockfd, LOCK_EX) != 0) {
        close(lockfd);
        return CAS_EIO;
    }

    FILE *fp = fopen(logpath, "r");

    if (!fp) {
        close(lockfd);
        return CAS_ENOTFOUND;
    }

    /* Slurp the log into memory, one entry per kept line, preserving
     * raw text so the rewrite is byte-for-byte faithful. */
    char **lines = NULL;
    int64_t *times = NULL;
    int count = 0, cap = 0;
    int rc = CAS_OK;
    char buf[1024];

    while (fgets(buf, sizeof(buf), fp)) {
        size_t len = strlen(buf);

        if (len > 0 && buf[len - 1] != '\n') {
            /* A torn trailing write: drop it, as log_read does. */
            if (feof(fp))
                break;
            rc = CAS_ERR;
            break;
        }
        if (len > 0 && buf[len - 1] == '\n')
            buf[--len] = '\0';

        int64_t t;

        if (log_line_time(buf, &t) != CAS_OK) {
            rc = CAS_ERR;
            break;
        }

        if (count == cap) {
            int ncap = cap ? cap * 2 : 64;
            char **nl = realloc(lines, (size_t)ncap * sizeof(*nl));

            if (!nl) {
                rc = CAS_ENOMEM;
                break;
            }
            lines = nl;

            int64_t *nt = realloc(times, (size_t)ncap * sizeof(*nt));

            if (!nt) {
                rc = CAS_ENOMEM;
                break;
            }
            times = nt;
            cap = ncap;
        }

        char *dup = strdup(buf);

        if (!dup) {
            rc = CAS_ENOMEM;
            break;
        }
        lines[count] = dup;
        times[count] = t;
        count++;
    }

    fclose(fp);

    if (rc != CAS_OK) {
        for (int i = 0; i < count; i++)
            free(lines[i]);
        free(lines);
        free(times);
        close(lockfd);
        return rc;
    }

    /* Decide which entries survive.  Lines are oldest-first, so the
     * last keep_count entries are indices [count - keep_count, count).
     * The two bounds are a union: an entry is kept if it is recent
     * enough by count OR by age.  The newest entry (index count - 1) is
     * always kept: a ref's live tree is protected during GC only by its
     * log entries, and the newest entry is the current root.  Dropping
     * it would let GC sweep the live world. */
    int first_by_count = keep_count > 0 && keep_count < count
                         ? count - keep_count : 0;
    int gone = 0;

    for (int i = 0; i < count; i++) {
        int keep = i == count - 1;

        if (keep_count > 0 && i >= first_by_count)
            keep = 1;
        if (keep_since > 0 && times[i] >= (int64_t)keep_since)
            keep = 1;
        if (!keep)
            gone++;
    }

    if (gone == 0) {
        for (int i = 0; i < count; i++)
            free(lines[i]);
        free(lines);
        free(times);
        close(lockfd);
        if (removed)
            *removed = 0;
        return CAS_OK;
    }

    unlink(logtmp);

    FILE *out = fopen(logtmp, "w");

    if (!out) {
        for (int i = 0; i < count; i++)
            free(lines[i]);
        free(lines);
        free(times);
        close(lockfd);
        return CAS_EIO;
    }

    for (int i = 0; i < count; i++) {
        int keep = i == count - 1;

        if (keep_count > 0 && i >= first_by_count)
            keep = 1;
        if (keep_since > 0 && times[i] >= (int64_t)keep_since)
            keep = 1;
        if (!keep)
            continue;
        if (fprintf(out, "%s\n", lines[i]) < 0) {
            rc = CAS_EIO;
            break;
        }
    }

    for (int i = 0; i < count; i++)
        free(lines[i]);
    free(lines);
    free(times);

    if (rc == CAS_OK && fflush(out) != 0)
        rc = CAS_EIO;
    if (rc == CAS_OK)
        fsync(fileno(out));
    fclose(out);

    if (rc != CAS_OK) {
        unlink(logtmp);
        close(lockfd);
        return rc;
    }

    if (rename(logtmp, logpath) != 0) {
        unlink(logtmp);
        close(lockfd);
        return CAS_EIO;
    }

    char refsdir[REF_PATH_MAX];

    snprintf(refsdir, sizeof(refsdir), "%s/refs",
             cas_basedir(ct->store));
    fsync_dir(refsdir);

    close(lockfd);
    if (removed)
        *removed = gone;
    return CAS_OK;
}

/****************************************************************
 * Ref iteration
 ****************************************************************/

int
cas_tree_ref_foreach(struct cas_tree *ct, cas_tree_ref_fn fn,
                     void *ctx)
{
    char refdir[REF_PATH_MAX];
    int n = snprintf(refdir, sizeof(refdir), "%s/refs",
                     cas_basedir(ct->store));

    if (n < 0 || (size_t)n >= sizeof(refdir))
        return CAS_ERR;

    DIR *dp = opendir(refdir);

    if (!dp)
        return CAS_OK;

    struct dirent *ent;

    while ((ent = readdir(dp)) != NULL) {
        size_t len = strlen(ent->d_name);
        const char *suffix = ".root";
        size_t slen = strlen(suffix);

        if (len <= slen)
            continue;
        if (strcmp(ent->d_name + len - slen, suffix) != 0)
            continue;

        char name[256];

        if (len - slen >= sizeof(name))
            continue;
        memcpy(name, ent->d_name, len - slen);
        name[len - slen] = '\0';

        if (fn(name, ctx) != 0) {
            closedir(dp);
            return CAS_OK;
        }
    }

    closedir(dp);
    return CAS_OK;
}

/****************************************************************
 * Fsck
 ****************************************************************/

/** Check that a text tree is spelled canonically.
 *
 *  Hashing the bytes already binds them to the address, so a
 *  non-canonical text is not a forgery: it is a second, self-consistent
 *  object for the same directory. That is still worth catching, because
 *  it means one directory has two addresses and will not dedup, and
 *  loading it and storing it back silently moves it.
 *
 *  The check is the same shape as the htree one: parse, re-serialize,
 *  compare. It rejects the spellings sscanf would otherwise accept, a
 *  signed uid or a differently padded mode among them.
 */
static int
tree_text_verify(const unsigned char *data, size_t len)
{
    struct cas_tree_dir dir;

    if (tree_text_load(data, len, &dir) != CAS_OK)
        return CAS_FSCK_CORRUPT;

    size_t textlen;
    char *text = tree_serialize(&dir, &textlen);

    cas_tree_dir_free(&dir);
    if (!text)
        return CAS_FSCK_CORRUPT;

    int canonical = textlen == len && memcmp(text, data, len) == 0;

    free(text);
    return canonical ? CAS_FSCK_OK : CAS_FSCK_CORRUPT;
}

/** Verify an htree against the address it is stored under.
 *
 *  Two checks are required, and the second is the one that is easy to
 *  leave out.  Recovering the entry set and hashing its canonical text
 *  form proves the object names the right children.  It does not prove
 *  the object answers a lookup with them: entries can be reached either
 *  by scanning the records region or by following the tables, and only
 *  the latter is the path htree_lookup_entry takes.  An htree whose
 *  tables point at records the scan never reaches -- one placed past the
 *  tables, say -- passes the first check while returning a different
 *  child from a lookup than from a listing.
 *
 *  Re-deriving the whole encoding and comparing bytes closes that,
 *  whichever way the entries were recovered, and covers anything else a
 *  forger might hide in the object.  It works because the encoding is
 *  canonical: htree_build is a function of the sorted entry set alone.
 *
 *  See FORMAT.md, "Verifying an htree", and ATOLL.md A4.1.
 */
static int
htree_verify(const unsigned char *data, size_t len, const char *hash)
{
    struct cas_tree_dir dir;

    /* checks the magic, the adler32, and the record framing */
    if (htree_parse_dir(data, len, &dir) != CAS_OK)
        return CAS_FSCK_CORRUPT;

    if (dir.count > 1)
        qsort(dir.entries, (size_t)dir.count,
              sizeof(*dir.entries), entry_cmp);

    size_t textlen;
    char *text = tree_serialize(&dir, &textlen);

    if (!text) {
        cas_tree_dir_free(&dir);
        return CAS_FSCK_CORRUPT;
    }

    char computed[CAS_HASH_HEX + 1];

    cas_hash_object("tree", text, textlen, computed);
    free(text);

    if (strcmp(computed, hash) != 0) {
        cas_tree_dir_free(&dir);
        return CAS_FSCK_CORRUPT;
    }

    size_t binlen;
    unsigned char *bin = htree_build(&dir, &binlen);

    cas_tree_dir_free(&dir);
    if (!bin)
        return CAS_FSCK_CORRUPT;

    int pinned = binlen == len && memcmp(bin, data, len) == 0;

    free(bin);
    return pinned ? CAS_FSCK_OK : CAS_FSCK_CORRUPT;
}

int
cas_tree_verify(struct cas_tree *ct, const char *hash)
{
    struct cas_file cf;
    char type[CAS_TYPE_MAX + 1];

    int rc = cas_open_object(ct->store, &cf, hash, type,
                             sizeof(type));

    if (rc == CAS_ENOTFOUND)
        return CAS_FSCK_IOERR;
    if (rc == CAS_ETYPE)
        return CAS_FSCK_NOCODEC;  /* compressed, no decoder */
    if (rc != CAS_OK)
        return CAS_FSCK_CORRUPT;

    if (strcmp(type, "tree") == 0) {
        int status = tree_text_verify(cf.data, cf.len);

        cas_close(&cf);
        if (status != CAS_FSCK_OK)
            return status;
        return cas_fsck_object(ct->store, hash);
    }

    if (strcmp(type, "htree") != 0) {
        cas_close(&cf);
        return CAS_FSCK_FOREIGN;
    }

    int status = htree_verify(cf.data, cf.len, hash);

    cas_close(&cf);
    return status;
}

int
cas_tree_check_object(const char *type, const void *data, size_t len,
                      const char *hash)
{
    if (!type || !hash || (!data && len > 0))
        return CAS_ERR;

    if (strcmp(type, "htree") == 0)
        return htree_verify(data, len, hash) == CAS_FSCK_OK
               ? CAS_OK : CAS_ERR;

    /* Every other type is addressed by its own plaintext, so the
     * address is the check. */
    char computed[CAS_HASH_HEX + 1];

    if (cas_hash_object(type, data, len, computed) != CAS_OK)
        return CAS_ERR;
    if (strcmp(computed, hash) != 0)
        return CAS_ERR;

    if (strcmp(type, "tree") == 0 &&
        tree_text_verify(data, len) != CAS_FSCK_OK)
        return CAS_ERR;

    return CAS_OK;
}

int
cas_tree_put_checked(struct cas_tree *ct, const char *type,
                     const void *data, size_t len, const char *hash)
{
    if (!ct)
        return CAS_ERR;
    if (cas_tree_check_object(type, data, len, hash) != CAS_OK)
        return CAS_ERR;

    return cas_put_object_at(ct->store, type, data, len, hash);
}

static int
fsck_tree(struct cas_tree *ct, const char *path,
          const char *tree_hash, cas_tree_fsck_fn fn, void *ctx,
          int *errors)
{
    int status = cas_tree_verify(ct, tree_hash);

    if (status == CAS_FSCK_NOCODEC) {
        /* compressed tree, no decoder: a skip.  Cannot descend into
         * a tree we cannot decode, so this subtree is left unchecked. */
        if (fn && fn(path, tree_hash, CAS_TREE_FSCK_NOCODEC, ctx))
            return 1;
        return 0;
    }
    if (status == CAS_FSCK_FOREIGN) {
        /* A ref may name any object, and a signed topic head names a
         * version record on purpose.  Report it and stop descending;
         * whoever understands the type is the one who can check it. */
        if (fn && fn(path, tree_hash, CAS_TREE_FSCK_FOREIGN, ctx))
            return 1;
        return 0;
    }
    if (status == CAS_FSCK_IOERR) {
        (*errors)++;
        if (fn && fn(path, tree_hash, CAS_TREE_FSCK_MISSING, ctx))
            return 1;
        return 0;
    }
    if (status != CAS_FSCK_OK) {
        (*errors)++;
        if (fn && fn(path, tree_hash, CAS_TREE_FSCK_CORRUPT, ctx))
            return 1;
        return 0;
    }

    struct cas_tree_dir dir;
    int rc = cas_tree_load(ct, tree_hash, &dir);

    if (rc != CAS_OK) {
        (*errors)++;
        if (fn && fn(path, tree_hash, CAS_TREE_FSCK_BAD_TREE, ctx))
            return 1;
        return 0;
    }

    for (int i = 0; i < dir.count; i++) {
        struct cas_tree_entry *e = &dir.entries[i];
        char childpath[4096];

        if (strcmp(path, "/") == 0)
            snprintf(childpath, sizeof(childpath), "/%s", e->name);
        else
            snprintf(childpath, sizeof(childpath), "%s/%s",
                     path, e->name);

        int type = e->mode & CAS_TREE_S_IFMT;

        if (type == CAS_TREE_S_IFDIR) {
            if (fsck_tree(ct, childpath, e->hash, fn, ctx, errors)) {
                cas_tree_dir_free(&dir);
                return 1;
            }
        } else {
            status = cas_fsck_object(cas_tree_cas(ct), e->hash);
            if (status == CAS_FSCK_NOCODEC) {
                /* compressed blob, no decoder: a skip, not an error */
                if (fn && fn(childpath, e->hash,
                             CAS_TREE_FSCK_NOCODEC, ctx)) {
                    cas_tree_dir_free(&dir);
                    return 1;
                }
            } else if (status == CAS_FSCK_IOERR) {
                (*errors)++;
                if (fn && fn(childpath, e->hash,
                             CAS_TREE_FSCK_MISSING, ctx)) {
                    cas_tree_dir_free(&dir);
                    return 1;
                }
            } else if (status != CAS_FSCK_OK) {
                (*errors)++;
                if (fn && fn(childpath, e->hash,
                             CAS_TREE_FSCK_CORRUPT, ctx)) {
                    cas_tree_dir_free(&dir);
                    return 1;
                }
            }
        }
    }

    cas_tree_dir_free(&dir);
    return 0;
}

int
cas_tree_fsck_root(struct cas_tree *ct, const char *root_hash,
                   cas_tree_fsck_fn fn, void *ctx)
{
    int errors = 0;

    fsck_tree(ct, "/", root_hash, fn, ctx, &errors);
    return errors ? CAS_ERR : CAS_OK;
}

struct fsck_ref_ctx {
    struct cas_tree *ct;
    cas_tree_fsck_fn fn;
    void *ctx;
    int errors;
};

static int
fsck_ref(const char *name, void *ctx)
{
    struct fsck_ref_ctx *fc = ctx;
    char hash[CAS_HASH_HEX + 1];

    if (cas_tree_ref_read(fc->ct, name, hash) != CAS_OK)
        return 0;

    int errors = 0;

    fsck_tree(fc->ct, "/", hash, fc->fn, fc->ctx, &errors);
    fc->errors += errors;
    return 0;
}

int
cas_tree_fsck(struct cas_tree *ct, cas_tree_fsck_fn fn, void *ctx)
{
    struct fsck_ref_ctx fc = {
        .ct = ct,
        .fn = fn,
        .ctx = ctx,
        .errors = 0,
    };

    cas_tree_ref_foreach(ct, fsck_ref, &fc);
    return fc.errors ? CAS_ERR : CAS_OK;
}
