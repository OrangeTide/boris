/* pascal_rt.c : runtime helpers for Compact Pascal (cross-compiled) */

#ifdef PAS_HOST
#include <unistd.h>
#include <stdio.h>
#include <math.h>
#else
extern int read(int fd, char *buf, int n);
extern int write(int fd, const char *buf, int n);
#endif

/****************************************************************
 * Heap strings (FPC-style ansistring; the Kobold string descriptor)
 *
 * A string value is a pointer to a {refcount, kind, len, cap} header (four
 * 32-bit words, 16 bytes) followed by the bytes and a trailing NUL.  The
 * pointer addresses the header; the bytes live at offset 16.  A NULL pointer
 * is the empty string.  A static literal carries refcount 0xffffffff and is
 * never freed.  The layout matches the backend's `strobj` global emission, so
 * a string literal is one of these objects sitting in rodata, endian-correct
 * on every target.
 *
 * Assignment shares a value by reference count (__pascal_str_retain /
 * __pascal_str_release) rather than copying; release frees at zero on the
 * host.  Allocation is libc malloc on the host and a static bump arena on the
 * freestanding targets, which run only small programs.
 ****************************************************************/

#ifdef PAS_HOST
#include <stdlib.h>
#define P_ALLOC(n) malloc((unsigned long)(n))
#define P_FREE(p)  free(p)
#else
static char p_arena[1u << 20];
static unsigned long p_arena_used;
static void *
P_ALLOC(unsigned long n)
{
    void *r;

    n = (n + 7u) & ~7u;
    if (p_arena_used + n > sizeof(p_arena))
        return 0;
    r = &p_arena[p_arena_used];
    p_arena_used += n;
    return r;
}
/* The bump arena has no free list; released storage is reclaimed only when
   the program exits.  The refcount still drops so logic stays uniform. */
#define P_FREE(p)  ((void)(p))
#endif

struct pstr {
    unsigned int refcount;
    unsigned int kind;
    int len;
    int cap;
    char bytes[1];
};

#define PSTR_HDR    16
#define PSTR_KIND   1u
#define PSTR_STATIC 0xffffffffu

/* Allocate a descriptor of logical length len with room for cap characters
   (cap >= len), so a later in-place append can reuse the spare capacity. */
static struct pstr *
pstr_make_cap(int len, int cap)
{
    struct pstr *d;

    if (len < 0)
        len = 0;
    if (cap < len)
        cap = len;
    if (cap <= 0)
        return 0;
    d = P_ALLOC((unsigned long)PSTR_HDR + (unsigned long)cap + 1u);
    if (!d)
        return 0;
    d->refcount = 1;
    d->kind = PSTR_KIND;
    d->len = len;
    d->cap = cap;
    d->bytes[len] = '\0';
    return d;
}

static struct pstr *
pstr_make(int len)
{
    struct pstr *d;

    if (len <= 0)
        return 0;
    d = P_ALLOC((unsigned long)PSTR_HDR + (unsigned long)len + 1u);
    if (!d)
        return 0;
    d->refcount = 1;
    d->kind = PSTR_KIND;
    d->len = len;
    d->cap = len;
    d->bytes[len] = '\0';
    return d;
}

static int
pstr_len(const void *s)
{
    return s ? ((const struct pstr *)s)->len : 0;
}

static const char *
pstr_bytes(const void *s)
{
    return s ? ((const struct pstr *)s)->bytes : "";
}

void *
__pascal_str_new(const char *b, int len)
{
    struct pstr *d;
    int i;

    if (len < 0)
        len = 0;
    d = pstr_make(len);
    if (d)
        for (i = 0; i < len; i++)
            d->bytes[i] = b[i];
    return d;
}

int
__pascal_str_length(const void *s)
{
    return pstr_len(s);
}

/* A fresh one-character heap string from a character code.  Used when a char
   value is an operand of string concatenation or a self-append. */
void *
__pascal_str_ofchar(int c)
{
    char ch = (char)c;
    return __pascal_str_new(&ch, 1);
}

/* An owned copy of s (a fresh heap string), or NULL for the empty string.
   Assignment uses this to give each variable an independent value. */
void *
__pascal_str_dup(const void *s)
{
    return s ? __pascal_str_new(pstr_bytes(s), pstr_len(s)) : (void *)0;
}

/* Add a reference.  A NULL (the empty string) and a static literal (refcount
   0xffffffff) are immortal and left alone.  Returns s so a caller can retain
   and store in one expression. */
void *
__pascal_str_retain(void *s)
{
    struct pstr *d = s;

    if (d && d->refcount != PSTR_STATIC)
        d->refcount++;
    return s;
}

/* Drop a reference and free the descriptor at zero.  A NULL and a static
   literal are left alone. */
void
__pascal_str_release(void *s)
{
    struct pstr *d = s;

    if (!d || d->refcount == PSTR_STATIC)
        return;
    if (--d->refcount == 0)
        P_FREE(d);
}

/* Return a uniquely owned, writable copy of s for an in-place mutation (copy
   on write).  A value already held by exactly one owner is returned as is; a
   shared or static value is copied to a fresh refcount-1 descriptor and the
   caller's shared reference dropped, so the destination slot ends up owning
   the private copy.  NULL (the empty string) has nothing to mutate. */
void *
__pascal_str_unique(void *s)
{
    struct pstr *d = s;
    void *copy;

    /* refcount 1 means the sole owner (a static literal is 0xffffffff). */
    if (!d || d->refcount == 1u)
        return s;
    copy = __pascal_str_dup(s);
    __pascal_str_release(s);
    return copy;
}

/* Append e to s for the self-append idiom (x := x + e), consuming s's
   reference and returning an owned result.  When s is the sole owner with
   spare capacity the bytes go in place and s is returned; otherwise a fresh
   (over-allocated) string is built and s's reference dropped.  Reading e
   before growing s keeps x := x + x correct. */
void *
__pascal_str_append(void *s, const void *e)
{
    struct pstr *d = s;
    int slen = pstr_len(s);
    int elen = pstr_len(e);
    const char *eb;
    struct pstr *r;
    int i, cap;

    if (elen == 0)
        return s;
    eb = pstr_bytes(e);
    if (d && d->refcount == 1u && d->cap >= slen + elen) {
        for (i = 0; i < elen; i++)
            d->bytes[slen + i] = eb[i];
        d->len = slen + elen;
        d->bytes[d->len] = '\0';
        return d;
    }
    cap = slen + elen;
    cap = cap + cap / 2 + 16;    /* headroom so repeated appends amortize */
    r = pstr_make_cap(slen + elen, cap);
    if (r) {
        const char *sb = pstr_bytes(s);
        for (i = 0; i < slen; i++)
            r->bytes[i] = sb[i];
        for (i = 0; i < elen; i++)
            r->bytes[slen + i] = eb[i];
    }
    __pascal_str_release(s);
    return r;
}

/****************************************************************
 * Dynamic arrays
 *
 * A dynamic array shares the string descriptor layout ({refcount, kind, len,
 * cap} header, elements at +PSTR_HDR) with kind PSTR_KIND_ARR.  len and cap
 * count elements; the retain/release helpers above work unchanged on the
 * header.  NULL is the empty array.  When the elements are managed (an array of
 * string, or of a record with string members) the compiler passes per-element
 * finalize and retain callbacks to the helpers below, so freeing or shrinking a
 * descriptor also drops the references its elements hold.
 ****************************************************************/

#define PSTR_KIND_ARR 2u

static struct pstr *
arr_alloc(int nelem, int elsize, int cap)
{
    struct pstr *d;
    unsigned long bytes;

    if (nelem < 0)
        nelem = 0;
    if (cap < nelem)
        cap = nelem;
    bytes = (unsigned long)PSTR_HDR + (unsigned long)cap * (unsigned long)elsize;
    d = P_ALLOC(bytes);
    if (!d)
        return 0;
    d->refcount = 1;
    d->kind = PSTR_KIND_ARR;
    d->len = nelem;
    d->cap = cap;
    return d;
}

int
__pascal_arr_length(const void *a)
{
    return pstr_len(a);
}

/* SetLength(a, n): resize to n elements, consuming a's reference and returning
   the owned result.  Resizes in place when a is uniquely owned with capacity,
   otherwise copies into a fresh (over-allocated) descriptor and drops the old
   reference (copy on write for a shared array).  New elements are zeroed. */
void *
__pascal_arr_setlength(void *a, int newlen, int elsize)
{
    struct pstr *d = a;
    int oldlen = pstr_len(a);
    struct pstr *r;
    int copyn, i;

    if (newlen <= 0) {
        __pascal_str_release(a);
        return 0;
    }
    if (d && d->refcount == 1u && d->cap >= newlen) {
        char *base = (char *)d + PSTR_HDR;
        for (i = oldlen * elsize; i < newlen * elsize; i++)
            base[i] = 0;
        d->len = newlen;
        return d;
    }
    r = arr_alloc(newlen, elsize, newlen + newlen / 2 + 4);
    if (r) {
        const char *src = pstr_bytes(a);
        char *dst = (char *)r + PSTR_HDR;
        copyn = oldlen < newlen ? oldlen : newlen;
        for (i = 0; i < copyn * elsize; i++)
            dst[i] = src[i];
        for (i = copyn * elsize; i < newlen * elsize; i++)
            dst[i] = 0;
    }
    __pascal_str_release(a);
    return r;
}

/* Element reference counting for an array whose elements are a single managed
   pointer (an array of string, or of a scalar dynamic array): the element at
   `elem` is that pointer.  These are the fixed callbacks the compiler passes
   for such element types, in place of a generated per-record finalizer. */
void
__pascal_elem_release_ptr(void *elem)
{
    __pascal_str_release(*(void **)elem);
}

void
__pascal_elem_retain_ptr(void *elem)
{
    __pascal_str_retain(*(void **)elem);
}

/* Release a reference to a dynamic array of managed elements.  At the last
   reference `dtor` finalizes each live element before the descriptor is freed.
   NULL and static descriptors are left alone, matching __pascal_str_release. */
void
__pascal_arr_release(void *a, int elsize, void (*dtor)(void *))
{
    struct pstr *d = a;
    int i;

    if (!d || d->refcount == PSTR_STATIC)
        return;
    if (--d->refcount == 0) {
        char *base = (char *)d + PSTR_HDR;
        for (i = 0; i < d->len; i++)
            dtor(base + i * elsize);
        P_FREE(d);
    }
}

/* SetLength for a dynamic array of managed elements.  Like
   __pascal_arr_setlength, but it finalizes the elements a shrink drops (dtor)
   and, when copying a shared array (copy on write), retains the managed value
   in each copied element so the old and new descriptors each own a reference.
   A uniquely owned reallocation moves the elements, transferring ownership, so
   the old shell is freed by the plain release without finalizing them. */
void *
__pascal_arr_setlength_mgd(void *a, int newlen, int elsize,
                           void (*dtor)(void *), void (*retain)(void *))
{
    struct pstr *d = a;
    int oldlen = pstr_len(a);
    struct pstr *r;
    int copyn, i;
    char *base;

    if (newlen <= 0) {
        __pascal_arr_release(a, elsize, dtor);
        return 0;
    }
    if (d && d->refcount == 1u && d->cap >= newlen) {
        base = (char *)d + PSTR_HDR;
        if (newlen < oldlen)
            for (i = newlen; i < oldlen; i++)
                dtor(base + i * elsize);
        else
            for (i = oldlen * elsize; i < newlen * elsize; i++)
                base[i] = 0;
        d->len = newlen;
        return d;
    }
    r = arr_alloc(newlen, elsize, newlen + newlen / 2 + 4);
    if (r) {
        const char *src = pstr_bytes(a);
        char *dst = (char *)r + PSTR_HDR;
        copyn = oldlen < newlen ? oldlen : newlen;
        for (i = 0; i < copyn * elsize; i++)
            dst[i] = src[i];
        for (i = copyn * elsize; i < newlen * elsize; i++)
            dst[i] = 0;
        if (d && d->refcount != 1u)       /* shared: the copies now co-own */
            for (i = 0; i < copyn; i++)
                retain(dst + i * elsize);
    }
    __pascal_str_release(a);
    return r;
}

/* The current output stream for Write/WriteLn: 1 (Output) by default, set to 2
   (ErrOutput) around a WriteLn(ErrOutput, ...) by the compiler.  Output is
   unbuffered (direct write), so Flush is a no-op. */
static int g_outfd = 1;

/* Write exactly n bytes to the current output fd, advancing over a short write
   and stopping on error.  Every output path funnels through here, so checking
   write()'s result (the host libc marks it warn_unused_result) and completing a
   partial write are both handled in one place. */
static void
out_write(const char *p, int n)
{
    while (n > 0) {
        int w = write(g_outfd, p, n);
        if (w <= 0)
            break;              /* error, or nothing written: stop this chunk */
        p += w;
        n -= w;
    }
}

void
__pascal_set_outfd(int fd)
{
    g_outfd = fd;
}

void
__pascal_flush(void)
{
}

void
__pascal_write_raw(const char *p, int n)
{
    out_write(p, n);
}

/* Command-line arguments (ParamStr/ParamCount).  main captures argc/argv here
   at entry; a freestanding host that passes none leaves these zero. */
static int g_argc;
static char **g_argv;

void
__pascal_set_args(int argc, char **argv)
{
    g_argc = argc;
    g_argv = argv;
}

/* ParamCount: the number of arguments after the program name. */
int
__pascal_param_count(void)
{
    return g_argc > 0 ? g_argc - 1 : 0;
}

/* ParamStr(i): argument i as a heap string (0 is the program name); an index
   out of range is the empty string. */
void *
__pascal_param_str(int i)
{
    const char *s;
    int n = 0;

    if (i < 0 || i >= g_argc || !g_argv)
        return 0;
    s = g_argv[i];
    if (!s)
        return 0;
    while (s[n])
        n++;
    return __pascal_str_new(s, n);
}

void
__pascal_write_int(int v)
{
    char buf[12];
    int i, neg;
    unsigned int u;

    if (v == 0) {
        out_write("0", 1);
        return;
    }

    neg = 0;
    if (v < 0) {
        neg = 1;
        u = (unsigned int)(-(v + 1)) + 1;
    } else {
        u = (unsigned int)v;
    }

    i = sizeof(buf);
    while (u > 0) {
        buf[--i] = '0' + (u % 10);
        u /= 10;
    }
    if (neg)
        buf[--i] = '-';
    out_write(buf + i, (int)(sizeof(buf) - i));
}

void
__pascal_write_int64(long long v)
{
    char buf[24];
    int i, neg;
    unsigned long long u;

    if (v == 0) {
        out_write("0", 1);
        return;
    }

    neg = 0;
    if (v < 0) {
        neg = 1;
        u = (unsigned long long)(-(v + 1)) + 1;
    } else {
        u = (unsigned long long)v;
    }

    i = sizeof(buf);
    while (u > 0) {
        buf[--i] = '0' + (int)(u % 10);
        u /= 10;
    }
    if (neg)
        buf[--i] = '-';
    out_write(buf + i, (int)(sizeof(buf) - i));
}

#ifdef PAS_HOST
void
__pascal_write_real(double v)
{
    char buf[40];
    int n = snprintf(buf, sizeof(buf), "%.15g", v);

    if (n > 0)
        out_write(buf, (int)n);
}

void *
__pascal_str_from_real(double v)
{
    char buf[64];
    int n = snprintf(buf, sizeof(buf), "%.15g", v);

    if (n < 0)
        n = 0;
    if (n > (int)sizeof(buf))
        n = (int)sizeof(buf);
    return __pascal_str_new(buf, n);
}

int
__pascal_round(double v)
{
    return (int)llround(v);
}

double
__pascal_sqrt(double v)
{
    return sqrt(v);
}
#else
/* Freestanding (no libc): the ColdFire corpus does not exercise reals, so these
   are minimal placeholders that keep the object link-complete. */
void
__pascal_write_real(double v)
{
    (void)v;
    out_write("0", 1);
}

void *
__pascal_str_from_real(double v)
{
    (void)v;
    return __pascal_str_new("0", 1);
}

int
__pascal_round(double v)
{
    return (int)v;
}

double
__pascal_sqrt(double v)
{
    return v;
}
#endif

void
__pascal_write_char(int v)
{
    char c = (char)v;
    out_write(&c, 1);
}

void
__pascal_write_str(const void *s)
{
    int len = pstr_len(s);

    if (len > 0)
        out_write(pstr_bytes(s), len);
}

int
__pascal_str_compare(const void *a, const void *b)
{
    int la = pstr_len(a), lb = pstr_len(b);
    const char *pa = pstr_bytes(a), *pb = pstr_bytes(b);
    int n = la < lb ? la : lb, i;

    for (i = 0; i < n; i++) {
        unsigned char ca = (unsigned char)pa[i];
        unsigned char cb = (unsigned char)pb[i];
        if (ca != cb)
            return (int)ca - (int)cb;
    }
    return la - lb;
}

void *
__pascal_str_concat(const void *a, const void *b)
{
    int la = pstr_len(a), lb = pstr_len(b), i;
    const char *pa = pstr_bytes(a), *pb = pstr_bytes(b);
    struct pstr *d = pstr_make(la + lb);

    if (d) {
        for (i = 0; i < la; i++)
            d->bytes[i] = pa[i];
        for (i = 0; i < lb; i++)
            d->bytes[la + i] = pb[i];
    }
    return d;
}

void *
__pascal_str_copy(const void *s, int index, int count)
{
    int len = pstr_len(s), avail, i;
    const char *p = pstr_bytes(s);
    struct pstr *d;

    if (index < 1)
        index = 1;
    if (count < 0 || index > len)
        count = 0;
    else {
        avail = len - (index - 1);
        if (count > avail)
            count = avail;
    }
    d = pstr_make(count);
    if (d)
        for (i = 0; i < count; i++)
            d->bytes[i] = p[index - 1 + i];
    return d;
}

int
__pascal_str_pos(const void *needle, const void *haystack)
{
    int ln = pstr_len(needle), lh = pstr_len(haystack), i, j;
    const char *pn = pstr_bytes(needle), *ph = pstr_bytes(haystack);

    if (ln == 0 || ln > lh)
        return 0;
    for (i = 0; i + ln <= lh; i++) {
        for (j = 0; j < ln; j++)
            if (ph[i + j] != pn[j])
                break;
        if (j == ln)
            return i + 1;
    }
    return 0;
}

void *
__pascal_str_delete(const void *s, int index, int count)
{
    int len = pstr_len(s), start = index - 1, i, k;
    const char *p = pstr_bytes(s);
    struct pstr *d;

    if (start < 0 || start >= len || count <= 0)
        return __pascal_str_dup(s);
    if (start + count > len)
        count = len - start;
    d = pstr_make(len - count);
    if (d) {
        k = 0;
        for (i = 0; i < start; i++)
            d->bytes[k++] = p[i];
        for (i = start + count; i < len; i++)
            d->bytes[k++] = p[i];
    }
    return d;
}

void *
__pascal_str_insert(const void *src, const void *dst, int index)
{
    int ld = pstr_len(dst), ls = pstr_len(src), pos = index - 1, i, k;
    const char *pd = pstr_bytes(dst), *ps = pstr_bytes(src);
    struct pstr *d;

    if (pos < 0)
        pos = 0;
    if (pos > ld)
        pos = ld;
    d = pstr_make(ld + ls);
    if (d) {
        k = 0;
        for (i = 0; i < pos; i++)
            d->bytes[k++] = pd[i];
        for (i = 0; i < ls; i++)
            d->bytes[k++] = ps[i];
        for (i = pos; i < ld; i++)
            d->bytes[k++] = pd[i];
    }
    return d;
}

void *
__pascal_str_from_int(int v)
{
    char buf[12];
    int i = (int)sizeof(buf), neg = 0;
    unsigned int u;

    if (v == 0)
        return __pascal_str_new("0", 1);
    if (v < 0) {
        neg = 1;
        u = (unsigned int)(-(v + 1)) + 1;
    } else {
        u = (unsigned int)v;
    }
    while (u > 0) {
        buf[--i] = (char)('0' + (u % 10));
        u /= 10;
    }
    if (neg)
        buf[--i] = '-';
    return __pascal_str_new(buf + i, (int)sizeof(buf) - i);
}

void *
__pascal_str_from_int64(long long v)
{
    char buf[24];
    int i = (int)sizeof(buf), neg = 0;
    unsigned long long u;

    if (v == 0)
        return __pascal_str_new("0", 1);
    if (v < 0) {
        neg = 1;
        u = (unsigned long long)(-(v + 1)) + 1;
    } else {
        u = (unsigned long long)v;
    }
    while (u > 0) {
        buf[--i] = (char)('0' + (int)(u % 10));
        u /= 10;
    }
    if (neg)
        buf[--i] = '-';
    return __pascal_str_new(buf + i, (int)sizeof(buf) - i);
}

static char rd_buf[256];
static int rd_pos;
static int rd_len;
static int rd_eof;

static int
rd_getc(void)
{
    if (rd_eof)
        return -1;
    if (rd_pos >= rd_len) {
        rd_len = read(0, rd_buf, sizeof(rd_buf));
        rd_pos = 0;
        if (rd_len <= 0) {
            rd_eof = 1;
            return -1;
        }
    }
    return (unsigned char)rd_buf[rd_pos++];
}

void
__pascal_read_char(int *dst)
{
    int c = rd_getc();

    *dst = (c >= 0) ? c : 0;
}

int
__pascal_eof(void)
{
    return rd_eof;
}

void
__pascal_read_int(int *dst)
{
    int c, neg;
    unsigned int v;

    /* skip whitespace (not newlines for read vs readln distinction) */
    for (;;) {
        c = rd_getc();
        if (c < 0) {
            *dst = 0;
            return;
        }
        if (c != ' ' && c != '\t' && c != '\r' && c != '\n')
            break;
    }

    neg = 0;
    if (c == '-') {
        neg = 1;
        c = rd_getc();
    } else if (c == '+') {
        c = rd_getc();
    }

    v = 0;
    while (c >= '0' && c <= '9') {
        v = v * 10 + (unsigned int)(c - '0');
        c = rd_getc();
    }

    /* push back the non-digit character */
    if (c >= 0)
        rd_pos--;

    *dst = neg ? -(int)v : (int)v;
}

void *
__pascal_read_str(void)
{
    char buf[1024];
    int c, len = 0;

    for (;;) {
        c = rd_getc();
        if (c < 0 || c == '\n')
            break;
        if (len < (int)sizeof(buf))
            buf[len++] = (char)c;
    }
    return __pascal_str_new(buf, len);
}

void
__pascal_readln(void)
{
    int c;

    for (;;) {
        c = rd_getc();
        if (c < 0 || c == '\n')
            return;
    }
}

/****************************************************************
 * Set operations (256-bit sets, 32 bytes)
 ****************************************************************/

void
__pascal_set_clear(char *s)
{
    for (int i = 0; i < 32; i++)
        s[i] = 0;
}

void
__pascal_set_add(char *s, int elem)
{
    if (elem >= 0 && elem <= 255)
        s[elem >> 3] |= (1 << (elem & 7));
}

void
__pascal_set_addrange(char *s, int lo, int hi)
{
    for (int i = lo; i <= hi; i++)
        if (i >= 0 && i <= 255)
            s[i >> 3] |= (1 << (i & 7));
}

void
__pascal_set_union(char *dst, char *a, char *b)
{
    for (int i = 0; i < 32; i++)
        dst[i] = a[i] | b[i];
}

void
__pascal_set_intersect(char *dst, char *a, char *b)
{
    for (int i = 0; i < 32; i++)
        dst[i] = a[i] & b[i];
}

void
__pascal_set_diff(char *dst, char *a, char *b)
{
    for (int i = 0; i < 32; i++)
        dst[i] = a[i] & ~b[i];
}

int
__pascal_set_in(int elem, char *s)
{
    if (elem < 0 || elem > 255)
        return 0;
    return (s[elem >> 3] >> (elem & 7)) & 1;
}

int
__pascal_set_eq(char *a, char *b)
{
    for (int i = 0; i < 32; i++)
        if (a[i] != b[i])
            return 0;
    return 1;
}

int
__pascal_set_ne(char *a, char *b)
{
    return !__pascal_set_eq(a, b);
}

int
__pascal_set_subset(char *a, char *b)
{
    for (int i = 0; i < 32; i++)
        if (a[i] & ~b[i])
            return 0;
    return 1;
}

void
__pascal_set_copy(char *dst, char *src)
{
    for (int i = 0; i < 32; i++)
        dst[i] = src[i];
}

void
__pascal_val(const void *s, int *result, int *code)
{
    int len = pstr_len(s);
    const char *p = pstr_bytes(s);
    int i = 0, neg = 0, val = 0;

    while (i < len && p[i] == ' ')
        i++;
    if (i < len && p[i] == '-') {
        neg = 1;
        i++;
    } else if (i < len && p[i] == '+') {
        i++;
    }
    if (i >= len || p[i] < '0' || p[i] > '9') {
        *result = 0;
        *code = i + 1;
        return;
    }
    while (i < len && p[i] >= '0' && p[i] <= '9') {
        val = val * 10 + (p[i] - '0');
        i++;
    }
    if (i < len) {
        *result = 0;
        *code = i + 1;
        return;
    }
    *result = neg ? -val : val;
    *code = 0;
}

/* Val for an Int64 destination: like __pascal_val but 64-bit. */
void
__pascal_val_int64(const void *s, long long *result, int *code)
{
    int len = pstr_len(s);
    const char *p = pstr_bytes(s);
    int i = 0, neg = 0;
    long long val = 0;

    while (i < len && p[i] == ' ')
        i++;
    if (i < len && p[i] == '-') {
        neg = 1;
        i++;
    } else if (i < len && p[i] == '+') {
        i++;
    }
    if (i >= len || p[i] < '0' || p[i] > '9') {
        *result = 0;
        *code = i + 1;
        return;
    }
    while (i < len && p[i] >= '0' && p[i] <= '9') {
        val = val * 10 + (p[i] - '0');
        i++;
    }
    if (i < len) {
        *result = 0;
        *code = i + 1;
        return;
    }
    *result = neg ? -val : val;
    *code = 0;
}

#ifdef PAS_HOST
/* Val for a real destination: strtod over the whole (trimmed) string. */
void
__pascal_val_real(const void *s, double *result, int *code)
{
    int len = pstr_len(s);
    const char *p = pstr_bytes(s);
    char buf[64];
    char *end;
    int i = 0, n = 0;
    double v;

    while (i < len && p[i] == ' ')
        i++;
    while (i < len && n < (int)sizeof(buf) - 1)
        buf[n++] = p[i++];
    buf[n] = '\0';
    if (n == 0) {
        *result = 0;
        *code = 1;
        return;
    }
    v = strtod(buf, &end);
    if (*end != '\0') {
        *result = 0;
        *code = (int)(end - buf) + 1;
        return;
    }
    *result = v;
    *code = 0;
}
#else
void
__pascal_val_real(const void *s, double *result, int *code)
{
    (void)s;
    *result = 0;
    *code = 1;
}
#endif

#ifndef PAS_HOST
void *
memset(void *s, int c, unsigned int n)
{
    unsigned char *p = s;
    while (n--)
        *p++ = (unsigned char)c;
    return s;
}

void *
memmove(void *dst, const void *src, unsigned int n)
{
    unsigned char *d = dst;
    const unsigned char *s = src;
    if (d < s) {
        while (n--)
            *d++ = *s++;
    } else if (d > s) {
        d += n;
        s += n;
        while (n--)
            *--d = *--s;
    }
    return dst;
}
#endif
