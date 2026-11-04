/* str_core.c : the guest-owned string object, shared by the hosted VM and the
   freestanding sandbox through rt_glue.h. Only the object model and the byte-level
   operations live here; number formatting and parsing (Str, Val) are tier-specific
   (str_fmt.c hosted, rt_sandbox.c freestanding), since they need libc on the host
   and a hand-rolled implementation with no libc in the sandbox.

   A string is a guest-heap object: a {refcount, kind} header, then the byte length,
   an allocated byte capacity, and the bytes inline (len bytes plus a trailing NUL,
   with room up to cap). The value the front end holds is the object's guest address;
   nil (0) is the empty string. A read-only string presents as immutable: a reader
   sees len bytes that never change under it. The one in-place mutation is append
   (kp_str_append*), and it is only taken when the string is uniquely owned
   (refcount 1) with spare capacity, so no value another owner can see is disturbed;
   every other case allocates an independent copy and releases the handed-in
   reference. A static string (saturated refcount) never takes the in-place path. */

#include "str.h"
#include "rt_glue.h"

struct kp_str {
    uint32_t refcount;          /* width-neutral header, matching kp_obj_hdr */
    uint32_t kind;              /* KP_OBJ_STRING */
    int32_t  len;
    int32_t  cap;               /* allocated byte capacity (>= len); bytes[cap] is the NUL slot */
    char     bytes[1];         /* len bytes then a trailing NUL, with room up to cap */
};

#define STRHDR  ((kp_gptr)(4 * sizeof(uint32_t)))   /* 16: refcount, kind, len, cap */

/* The string object at a guest address, or NULL for nil. */
static struct kp_str *
str_ptr(KP_VM_P kp_gptr s)
{
    return s ? (struct kp_str *)RT_PTR(s) : (struct kp_str *)0;
}

/* The KP_OBJ_STRING reclaimer: the bytes are inline, so the whole object is one block. */
static void
str_finalize(KP_VM_P kp_gptr s)
{
    RT_FREE(s);
}

/* Create a string of len bytes with room for cap bytes, at refcount 1, returning its
   guest address and, through out, its object pointer. An empty string (len 0) is nil
   (address 0) regardless of cap, which keeps the "nil is the empty string" invariant.
   The bytes are uninitialized apart from the trailing NUL; the caller fills them. */
static kp_gptr
str_make(KP_VM_P int32_t len, int32_t cap, struct kp_str **out)
{
    kp_gptr s;
    struct kp_str *d;

    RT_REGISTER(KP_OBJ_STRING, str_finalize);   /* idempotent */
    if (len <= 0) {
        *out = 0;
        return 0;
    }
    if (cap < len)
        cap = len;
    s = RT_ALLOC(STRHDR + (kp_gptr)cap + 1u);
    d = RT_PTR(s);
    d->refcount = 1;
    d->kind = KP_OBJ_STRING;
    d->len = len;
    d->cap = cap;
    d->bytes[len] = '\0';
    *out = d;
    return s;
}

/* The capacity to allocate for a string that must hold need bytes, grown geometrically
   from oldcap so a run of appends costs O(n) total rather than O(n^2). */
static int32_t
str_grow_cap(int32_t need, int32_t oldcap)
{
    int32_t c = oldcap > 8 ? oldcap : 8;

    while (c < need)
        c += c;                 /* double until it holds need */
    return c;
}

/* Append add bytes (src) to s, consuming one reference of s and returning an owned
   reference to the result. When s is a uniquely owned heap string with spare capacity
   the bytes are written in place and s is returned unchanged; otherwise a fresh copy
   is built and the handed-in reference is released. src must not alias s's storage past
   its length (it is read before any release). */
static kp_gptr
str_append_bytes(KP_VM_P kp_gptr s, const char *src, int32_t add)
{
    struct kp_str *d = str_ptr(KP_VM_A s);
    int32_t len = d ? d->len : 0;
    int32_t nlen = len + add;
    struct kp_str *nd;
    kp_gptr ns;

    if (add <= 0)
        return s;               /* nothing to add; keep the handed-in reference */
    if (d && d->refcount == 1 && d->cap >= nlen) {
        memcpy(d->bytes + len, src, (unsigned long)add);
        d->len = nlen;
        d->bytes[nlen] = '\0';
        return s;
    }
    ns = str_make(KP_VM_A nlen, str_grow_cap(nlen, d ? d->cap : 0), &nd);
    if (len)
        memcpy(nd->bytes, d->bytes, (unsigned long)len);
    memcpy(nd->bytes + len, src, (unsigned long)add);
    RT_RELEASE(s);              /* drop the handed-in reference (frees it when it was the last) */
    return ns;
}

kp_gptr
kp_str_new(KP_VM_P const char *bytes, int len)
{
    struct kp_str *d;
    kp_gptr s;

    if (len < 0)
        len = 0;
    s = str_make(KP_VM_A len, len, &d);
    if (len > 0) {
        if (bytes)
            memcpy(d->bytes, bytes, (unsigned long)len);
        else
            memset(d->bytes, 0, (unsigned long)len);
    }
    return s;
}

/* The guest-facing constructor: a literal or constant passes the guest address of its
   byte blob, translated to a real pointer for the copy. */
kp_gptr
kp_str_new_guest(KP_VM_P kp_gptr addr, int len)
{
    const char *bytes = (len > 0) ? (const char *)RT_PTR(addr) : (const char *)0;

    return kp_str_new(KP_VM_A bytes, len);
}

kp_gptr
kp_str_concat(KP_VM_P kp_gptr a, kp_gptr b)
{
    struct kp_str *sa = str_ptr(KP_VM_A a);
    struct kp_str *sb = str_ptr(KP_VM_A b);
    int32_t la = sa ? sa->len : 0;
    int32_t lb = sb ? sb->len : 0;
    struct kp_str *d;
    kp_gptr s;

    /* The guest heap never moves an existing block, so sa and sb stay valid across the
       allocation below. */
    s = str_make(KP_VM_A la + lb, la + lb, &d);
    if (la)
        memcpy(d->bytes, sa->bytes, (unsigned long)la);
    if (lb)
        memcpy(d->bytes + la, sb->bytes, (unsigned long)lb);
    return s;
}

int32_t
kp_str_len(KP_VM_P kp_gptr s)
{
    struct kp_str *d = str_ptr(KP_VM_A s);

    return d ? d->len : 0;
}

const char *
kp_str_bytes(KP_VM_P kp_gptr s)
{
    struct kp_str *d = str_ptr(KP_VM_A s);

    return (d && d->len) ? d->bytes : "";
}

kp_gptr
kp_str_base(KP_VM_P kp_gptr s)
{
    KP_VM_UNUSED();              /* the value is the object address; bytes follow the header */
    return s ? s + STRHDR : 0;
}

kp_gptr
kp_str_from_char(KP_VM_P int32_t code)
{
    char c = (char)(code & 0xFF);

    return kp_str_new(KP_VM_A &c, 1);
}

kp_gptr
kp_str_append_char(KP_VM_P kp_gptr s, int32_t code)
{
    char c = (char)(code & 0xFF);

    return str_append_bytes(KP_VM_A s, &c, 1);
}

kp_gptr
kp_str_append(KP_VM_P kp_gptr s, kp_gptr t)
{
    struct kp_str *dt = str_ptr(KP_VM_A t);

    if (!dt || dt->len == 0)
        return s;               /* appending the empty string keeps s unchanged */
    return str_append_bytes(KP_VM_A s, dt->bytes, dt->len);
}

int32_t
kp_str_cmp(KP_VM_P kp_gptr a, kp_gptr b)
{
    int32_t la = kp_str_len(KP_VM_A a);
    int32_t lb = kp_str_len(KP_VM_A b);
    int32_t n = la < lb ? la : lb;
    int r = RT_MEMCMP(kp_str_bytes(KP_VM_A a), kp_str_bytes(KP_VM_A b), (unsigned long)n);

    if (r != 0)
        return r < 0 ? -1 : 1;
    if (la != lb)
        return la < lb ? -1 : 1;
    return 0;
}

int32_t
kp_str_pos(KP_VM_P kp_gptr sub, kp_gptr s)
{
    struct kp_str *ds = str_ptr(KP_VM_A sub);
    struct kp_str *dd = str_ptr(KP_VM_A s);
    int32_t ls = ds ? ds->len : 0;
    int32_t ld = dd ? dd->len : 0;
    int32_t i;

    if (ls == 0 || ls > ld)             /* an empty needle never matches (as FPC) */
        return 0;
    for (i = 0; i + ls <= ld; i++)
        if (RT_MEMCMP(dd->bytes + i, ds->bytes, (unsigned long)ls) == 0)
            return i + 1;               /* 1-based position */
    return 0;
}

kp_gptr
kp_str_copy(KP_VM_P kp_gptr s, int32_t index, int32_t count)
{
    struct kp_str *d = str_ptr(KP_VM_A s);
    int32_t len = d ? d->len : 0;
    int32_t avail;
    struct kp_str *ns;
    kp_gptr id;

    if (index < 1)
        index = 1;
    if (count < 0 || index > len)
        count = 0;
    else {
        avail = len - (index - 1);
        if (count > avail)
            count = avail;
    }
    id = str_make(KP_VM_A count, count, &ns);
    if (count)
        memcpy(ns->bytes, d->bytes + (index - 1), (unsigned long)count);
    return id;
}
