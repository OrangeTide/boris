/* map.c : the guest-owned string-keyed associative array (map of T), shared by the hosted VM
   and the freestanding sandbox through rt_glue.h. See map.h for the object model.

   The table is open-addressed with linear probing. A key slot holds a retained string handle,
   or 0 for empty or 1 for a tombstone (a deleted slot that probing must skip but insertion may
   reuse); both sentinels are impossible for a real string handle, an even heap address. The
   load factor counts live entries and tombstones together, so the table grows (and sheds its
   tombstones) before probing can run long. */

#include "map.h"
#include "str.h"

struct kp_map {
    uint32_t refcount;  /* width-neutral header, matching kp_obj_hdr */
    uint32_t kind;      /* KP_OBJ_MAP */
    int32_t  count;     /* live entries */
    int32_t  tombs;     /* tombstone slots */
    int32_t  cap;       /* slot capacity, a power of two, 0 when empty */
    int32_t  elemsize;  /* value width in bytes */
    kp_gptr  layout;    /* guest address of the value's handle-field map, 0 when none */
    kp_gptr  keys;      /* guest block of cap key handles (0 empty, 1 tombstone) */
    kp_gptr  vals;      /* guest block of cap * elemsize value bytes */
    uint32_t modcount;  /* bumped on every insert or delete, for iterator invalidation */
};

struct kp_mapiter {
    uint32_t refcount;  /* width-neutral header, matching kp_obj_hdr */
    uint32_t kind;      /* KP_OBJ_MAPITER */
    kp_gptr  map;       /* the map being iterated, retained */
    int32_t  pos;       /* next slot index to scan */
    uint32_t modcount;  /* the map's modcount when the iterator was made */
};

#define KEY_EMPTY 0u
#define KEY_TOMB  1u
#define MAP_INIT_CAP 8
/* Bytes per key slot: a key is a string handle, so pointer-width. Equals 4 under
   ILP32 (byte-identical to the old literal) and 8 under LP64. */
#define KEYW ((int32_t)sizeof(kp_gptr))

static struct kp_map *
map_ptr(KP_VM_P kp_gptr a)
{
    return a ? (struct kp_map *)RT_PTR(a) : (struct kp_map *)0;
}

static struct kp_mapiter *
iter_ptr(KP_VM_P kp_gptr a)
{
    return (struct kp_mapiter *)RT_PTR(a);
}

/* Read/write the key handle at slot i (the key block may be unaligned after translation). */
static kp_gptr
key_at(KP_VM_P struct kp_map *m, int32_t i)
{
    kp_gptr v;
    memcpy(&v, (char *)RT_PTR(m->keys) + (unsigned long)i * (unsigned long)KEYW, sizeof v);
    return v;
}

static void
set_key_at(KP_VM_P struct kp_map *m, int32_t i, kp_gptr k)
{
    memcpy((char *)RT_PTR(m->keys) + (unsigned long)i * (unsigned long)KEYW, &k, sizeof k);
}

/* The real address of slot i's value storage. */
static void *
val_at(KP_VM_P struct kp_map *m, int32_t i)
{
    return (char *)RT_PTR(m->vals) + (unsigned long)i * (unsigned long)m->elemsize;
}

/* Read the int32 at word index idx of a layout blob (an i8 global, so possibly unaligned).
   The blob is an array of int32 byte offsets, so its stride stays 4 regardless of width. */
static int32_t
layout_i32(KP_VM_P kp_gptr layout, int32_t idx)
{
    int32_t v;
    memcpy(&v, (char *)RT_PTR(layout) + (unsigned long)idx * 4, 4);
    return v;
}

/* The FNV-1a hash of a key's bytes, read host-side. Computed before any allocation so the
   byte pointer stays valid. */
static uint32_t
hash_key(KP_VM_P kp_gptr key)
{
    const char *b = kp_str_bytes(KP_VM_A key);
    int32_t n = kp_str_len(KP_VM_A key), i;
    uint32_t h = 2166136261u;

    for (i = 0; i < n; i++) {
        h ^= (uint32_t)(unsigned char)b[i];
        h *= 16777619u;
    }
    return h;
}

static int
key_eq(KP_VM_P kp_gptr a, kp_gptr b)
{
    return a == b || kp_str_cmp(KP_VM_A a, b) == 0;
}

/* Retain the value's managed handles in slot i, per the layout map. Used when a value is
   copied out (tryget, iterator) or a map is cloned: the copy takes its own references. */
static void
retain_val(KP_VM_P struct kp_map *m, int32_t i)
{
    int32_t nf, j;
    char *e;
    kp_gptr h;

    if (m->layout == 0)
        return;
    nf = layout_i32(KP_VM_A m->layout, 0);
    e = (char *)val_at(KP_VM_A m, i);
    for (j = 0; j < nf; j++) {
        memcpy(&h, e + layout_i32(KP_VM_A m->layout, 1 + j), sizeof h);
        RT_RETAIN(h);
    }
}

/* Release the value's managed handles in slot i, per the layout map. */
static void
release_val(KP_VM_P struct kp_map *m, int32_t i)
{
    int32_t nf, j;
    char *e;
    kp_gptr h;

    if (m->layout == 0)
        return;
    nf = layout_i32(KP_VM_A m->layout, 0);
    e = (char *)val_at(KP_VM_A m, i);
    for (j = 0; j < nf; j++) {
        memcpy(&h, e + layout_i32(KP_VM_A m->layout, 1 + j), sizeof h);
        RT_RELEASE(h);
    }
}

/* Release the managed handles of a value held at an arbitrary guest address, per a layout
   map. Used to drop the previous contents of a destination slot before a value is copied in. */
static void
release_slot_at(KP_VM_P kp_gptr addr, kp_gptr layout)
{
    int32_t nf, j;
    kp_gptr h;

    if (layout == 0)
        return;
    nf = layout_i32(KP_VM_A layout, 0);
    for (j = 0; j < nf; j++) {
        memcpy(&h, (char *)RT_PTR(addr) + layout_i32(KP_VM_A layout, 1 + j), sizeof h);
        RT_RELEASE(h);
    }
}

static void map_finalize(KP_VM_P kp_gptr a);
static void mapiter_finalize(KP_VM_P kp_gptr a);

kp_gptr
kp_map_new(KP_VM_P int32_t elemsize, kp_gptr layout)
{
    kp_gptr a;
    struct kp_map *m;

    RT_REGISTER(KP_OBJ_MAP, map_finalize);   /* idempotent */
    a = RT_ALLOC((uint32_t)sizeof(struct kp_map));
    m = map_ptr(KP_VM_A a);
    m->refcount = 1;
    m->kind = KP_OBJ_MAP;
    m->count = 0;
    m->tombs = 0;
    m->cap = 0;
    m->elemsize = elemsize;
    m->layout = layout;
    m->keys = 0;
    m->vals = 0;
    m->modcount = 0;
    return a;
}

/* Grow (or first-allocate) the table to newcap slots and rehash the live entries into it,
   dropping tombstones. The descriptor address is stable; only the key and value blocks move. */
static void
map_grow(KP_VM_P kp_gptr a, int32_t newcap)
{
    struct kp_map *m = map_ptr(KP_VM_A a);
    kp_gptr oldkeys = m->keys, oldvals = m->vals, nk, nv;
    int32_t oldcap = m->cap, es = m->elemsize, i, j, mask = newcap - 1;
    kp_gptr k;

    nk = RT_ALLOC((uint32_t)newcap * (uint32_t)KEYW);
    memset(RT_PTR(nk), 0, (unsigned long)newcap * (unsigned long)KEYW);  /* every slot empty */
    nv = RT_ALLOC((uint32_t)newcap * (uint32_t)es);
    m = map_ptr(KP_VM_A a);                               /* re-translate after allocations */
    m->keys = nk;
    m->vals = nv;
    m->cap = newcap;
    m->tombs = 0;
    for (i = 0; i < oldcap; i++) {
        memcpy(&k, (char *)RT_PTR(oldkeys) + (unsigned long)i * (unsigned long)KEYW, sizeof k);
        if (k == KEY_EMPTY || k == KEY_TOMB)
            continue;
        j = (int32_t)(hash_key(KP_VM_A k) & (uint32_t)mask);
        while (key_at(KP_VM_A m, j) != KEY_EMPTY)
            j = (j + 1) & mask;
        set_key_at(KP_VM_A m, j, k);
        memcpy(val_at(KP_VM_A m, j),
               (char *)RT_PTR(oldvals) + (unsigned long)i * (unsigned long)es,
               (unsigned long)es);
    }
    if (oldkeys)
        RT_FREE(oldkeys);
    if (oldvals)
        RT_FREE(oldvals);
}

/* Find the slot holding key, or -1 when absent. */
static int32_t
map_find(KP_VM_P struct kp_map *m, kp_gptr key)
{
    int32_t mask, i;
    kp_gptr k;
    uint32_t h;

    if (m->cap == 0)
        return -1;
    mask = m->cap - 1;
    h = hash_key(KP_VM_A key);
    i = (int32_t)(h & (uint32_t)mask);
    for (;;) {
        k = key_at(KP_VM_A m, i);
        if (k == KEY_EMPTY)
            return -1;
        if (k != KEY_TOMB && key_eq(KP_VM_A k, key))
            return i;
        i = (i + 1) & mask;
    }
}

kp_gptr
kp_map_reserve(KP_VM_P kp_gptr a, kp_gptr key, int32_t elemsize, kp_gptr layout)
{
    struct kp_map *m;
    int32_t mask, i, slot, tomb;
    kp_gptr k;

    if (a == 0)
        a = kp_map_new(KP_VM_A elemsize, layout);
    else {
        /* Value semantics keeps each map unique (assignment clones), so a reserve mutates in
           place and returns an owned reference the caller stores back. The one time a map is
           shared is while an iterator holds it; a structural change then is caught by the
           iterator's modcount guard rather than silently forked. */
        m = map_ptr(KP_VM_A a);
        m->refcount++;
    }
    m = map_ptr(KP_VM_A a);
    if (m->cap == 0)
        map_grow(KP_VM_A a, MAP_INIT_CAP);
    else if ((m->count + m->tombs + 1) * 4 >= m->cap * 3)
        map_grow(KP_VM_A a, m->cap * 2);
    m = map_ptr(KP_VM_A a);
    mask = m->cap - 1;
    i = (int32_t)(hash_key(KP_VM_A key) & (uint32_t)mask);
    tomb = -1;
    for (;;) {
        k = key_at(KP_VM_A m, i);
        if (k == KEY_EMPTY) {
            slot = tomb >= 0 ? tomb : i;
            RT_RETAIN(key);
            set_key_at(KP_VM_A m, slot, key);
            memset(val_at(KP_VM_A m, slot), 0, (unsigned long)m->elemsize);
            m->count++;
            if (slot == tomb)
                m->tombs--;
            m->modcount++;
            return a;
        }
        if (k == KEY_TOMB) {
            if (tomb < 0)
                tomb = i;
        }
        else if (key_eq(KP_VM_A k, key))
            return a;   /* already present: its value slot is reused in place */
        i = (i + 1) & mask;
    }
}

kp_gptr
kp_map_get(KP_VM_P kp_gptr a, kp_gptr key)
{
    struct kp_map *m = map_ptr(KP_VM_A a);
    int32_t i = a ? map_find(KP_VM_A m, key) : -1;

    if (i < 0) {
        RT_TRAP_KEY();
        return 0;
    }
    return m->vals + (uint32_t)i * (uint32_t)m->elemsize;
}

int32_t
kp_map_tryget(KP_VM_P kp_gptr a, kp_gptr key, kp_gptr vaddr)
{
    struct kp_map *m = map_ptr(KP_VM_A a);
    int32_t i = a ? map_find(KP_VM_A m, key) : -1;

    if (i < 0)
        return 0;
    retain_val(KP_VM_A m, i);               /* the copy takes its own references */
    release_slot_at(KP_VM_A vaddr, m->layout);  /* drop the destination's previous value */
    memcpy(RT_PTR(vaddr), val_at(KP_VM_A m, i), (unsigned long)m->elemsize);
    return 1;
}

int32_t
kp_map_has(KP_VM_P kp_gptr a, kp_gptr key)
{
    struct kp_map *m = map_ptr(KP_VM_A a);

    return (a && map_find(KP_VM_A m, key) >= 0) ? 1 : 0;
}

static void
map_del_inplace(KP_VM_P kp_gptr a, kp_gptr key)
{
    struct kp_map *m = map_ptr(KP_VM_A a);
    int32_t i = map_find(KP_VM_A m, key);

    if (i < 0)
        return;
    release_val(KP_VM_A m, i);
    RT_RELEASE(key_at(KP_VM_A m, i));
    set_key_at(KP_VM_A m, i, KEY_TOMB);
    m->count--;
    m->tombs++;
    m->modcount++;
}

kp_gptr
kp_map_del(KP_VM_P kp_gptr a, kp_gptr key)
{
    struct kp_map *m;

    if (a == 0)
        return 0;
    map_del_inplace(KP_VM_A a, key);   /* in place, like kp_map_reserve: the map is unique */
    m = map_ptr(KP_VM_A a);
    m->refcount++;
    return a;
}

int32_t
kp_map_len(KP_VM_P kp_gptr a)
{
    struct kp_map *m = map_ptr(KP_VM_A a);

    return m ? m->count : 0;
}

kp_gptr
kp_map_clone(KP_VM_P kp_gptr a)
{
    struct kp_map *m, *cm;
    kp_gptr c, nk, nv;
    int32_t cap, es, i;
    kp_gptr k;

    if (a == 0)
        return 0;
    /* A map value copy reaches here from the generic aggregate-clone path, which knows only
       that a field is a map, not its key kind. Dispatch on the object header so an ordinal-keyed
       map clones through its own path; the release path already dispatches by the finalizer the
       kind selects. */
    if (map_ptr(KP_VM_A a)->kind == KP_OBJ_IMAP)
        return kp_imap_clone(KP_VM_A a);
    m = map_ptr(KP_VM_A a);
    c = kp_map_new(KP_VM_A m->elemsize, m->layout);
    cap = m->cap;
    es = m->elemsize;
    if (cap > 0) {
        nk = RT_ALLOC((uint32_t)cap * (uint32_t)KEYW);
        nv = RT_ALLOC((uint32_t)cap * (uint32_t)es);
        m = map_ptr(KP_VM_A a);
        cm = map_ptr(KP_VM_A c);
        memcpy(RT_PTR(nk), RT_PTR(m->keys), (unsigned long)cap * (unsigned long)KEYW);
        memcpy(RT_PTR(nv), RT_PTR(m->vals), (unsigned long)cap * (unsigned long)es);
        cm->keys = nk;
        cm->vals = nv;
        cm->cap = cap;
        cm->count = m->count;
        cm->tombs = m->tombs;
        for (i = 0; i < cap; i++) {
            k = key_at(KP_VM_A cm, i);
            if (k != KEY_EMPTY && k != KEY_TOMB) {
                RT_RETAIN(k);
                retain_val(KP_VM_A cm, i);
            }
        }
    }
    return c;
}

static void
map_finalize(KP_VM_P kp_gptr a)
{
    struct kp_map *m = map_ptr(KP_VM_A a);
    int32_t i;
    kp_gptr k;

    for (i = 0; i < m->cap; i++) {
        k = key_at(KP_VM_A m, i);
        if (k != KEY_EMPTY && k != KEY_TOMB) {
            release_val(KP_VM_A m, i);
            RT_RELEASE(k);
        }
    }
    if (m->keys)
        RT_FREE(m->keys);
    if (m->vals)
        RT_FREE(m->vals);
    RT_FREE(a);
}

kp_gptr
kp_mapiter_new(KP_VM_P kp_gptr map)
{
    kp_gptr a;
    struct kp_mapiter *it;

    RT_REGISTER(KP_OBJ_MAPITER, mapiter_finalize);   /* idempotent */
    a = RT_ALLOC((uint32_t)sizeof(struct kp_mapiter));
    it = iter_ptr(KP_VM_A a);
    it->refcount = 1;
    it->kind = KP_OBJ_MAPITER;
    it->map = map;
    it->pos = 0;
    if (map) {
        RT_RETAIN(map);
        it->modcount = map_ptr(KP_VM_A map)->modcount;
    }
    else
        it->modcount = 0;
    return a;
}

int32_t
kp_mapiter_next(KP_VM_P kp_gptr a, kp_gptr kaddr, kp_gptr vaddr)
{
    struct kp_mapiter *it = iter_ptr(KP_VM_A a);
    kp_gptr mid = it->map;
    struct kp_map *m;
    int32_t i;
    kp_gptr k, old;

    if (mid == 0)
        return 0;
    m = map_ptr(KP_VM_A mid);
    if (m->modcount != it->modcount) {
        RT_TRAP_CONCMOD();
        return 0;
    }
    while (it->pos < m->cap) {
        i = it->pos++;
        k = key_at(KP_VM_A m, i);
        if (k == KEY_EMPTY || k == KEY_TOMB)
            continue;
        /* write an owned key handle to *kaddr (retain the new one before releasing the old,
           so the same handle cannot drop to zero in between) */
        memcpy(&old, RT_PTR(kaddr), sizeof old);
        RT_RETAIN(k);
        memcpy(RT_PTR(kaddr), &k, sizeof k);
        RT_RELEASE(old);
        /* write an owned copy of the value to *vaddr */
        retain_val(KP_VM_A m, i);
        release_slot_at(KP_VM_A vaddr, m->layout);
        memcpy(RT_PTR(vaddr), val_at(KP_VM_A m, i), (unsigned long)m->elemsize);
        return 1;
    }
    return 0;
}

static void
mapiter_finalize(KP_VM_P kp_gptr a)
{
    struct kp_mapiter *it = iter_ptr(KP_VM_A a);

    if (it->map)
        RT_RELEASE(it->map);
    RT_FREE(a);
}

/* ----------------------------------------------------------------------------------------- */
/* kp_imap_* : the ordinal-keyed associative array (map[K] of T). Same open-addressed, linear-
   probing table and the same value machinery (elemsize/layout/clone/iterator) as the string map,
   but the key is a plain 64-bit integer stored by value, never retained. Because 0 and 1 are valid
   keys they cannot double as empty/tombstone sentinels the way a string handle's address can, so a
   parallel states block holds each slot's occupancy. See map.h. */

#define IST_EMPTY 0u
#define IST_TOMB  1u
#define IST_LIVE  2u
#define IKEYW     8   /* an int64 key slot, the same width on every target */

struct kp_imap {
    uint32_t refcount;  /* width-neutral header, matching kp_obj_hdr */
    uint32_t kind;      /* KP_OBJ_IMAP */
    int32_t  count;     /* live entries */
    int32_t  tombs;     /* tombstone slots */
    int32_t  cap;       /* slot capacity, a power of two, 0 when empty */
    int32_t  elemsize;  /* value width in bytes */
    kp_gptr  layout;    /* guest address of the value's handle-field map, 0 when none */
    kp_gptr  keys;      /* guest block of cap int64 keys */
    kp_gptr  vals;      /* guest block of cap * elemsize value bytes */
    kp_gptr  states;    /* guest block of cap state bytes (empty/tomb/live) */
    uint32_t modcount;  /* bumped on every insert or delete, for iterator invalidation */
};

struct kp_imapiter {
    uint32_t refcount;
    uint32_t kind;      /* KP_OBJ_IMAPITER */
    kp_gptr  map;       /* the map being iterated, retained */
    int32_t  pos;       /* next slot index to scan */
    uint32_t modcount;  /* the map's modcount when the iterator was made */
};

static struct kp_imap *
imap_ptr(KP_VM_P kp_gptr a)
{
    return a ? (struct kp_imap *)RT_PTR(a) : (struct kp_imap *)0;
}

static struct kp_imapiter *
iiter_ptr(KP_VM_P kp_gptr a)
{
    return (struct kp_imapiter *)RT_PTR(a);
}

static int64_t
ikey_at(KP_VM_P struct kp_imap *m, int32_t i)
{
    int64_t v;
    memcpy(&v, (char *)RT_PTR(m->keys) + (unsigned long)i * IKEYW, sizeof v);
    return v;
}

static void
set_ikey_at(KP_VM_P struct kp_imap *m, int32_t i, int64_t k)
{
    memcpy((char *)RT_PTR(m->keys) + (unsigned long)i * IKEYW, &k, sizeof k);
}

static unsigned
istate_at(KP_VM_P struct kp_imap *m, int32_t i)
{
    return ((unsigned char *)RT_PTR(m->states))[i];
}

static void
set_istate_at(KP_VM_P struct kp_imap *m, int32_t i, unsigned s)
{
    ((unsigned char *)RT_PTR(m->states))[i] = (unsigned char)s;
}

static void *
ival_at(KP_VM_P struct kp_imap *m, int32_t i)
{
    return (char *)RT_PTR(m->vals) + (unsigned long)i * (unsigned long)m->elemsize;
}

/* A 64-bit integer hash (the MurmurHash3 finalizer), folded to 32 bits. */
static uint32_t
ihash_key(int64_t key)
{
    uint64_t h = (uint64_t)key;

    h ^= h >> 33;
    h *= 0xff51afd7ed558ccdULL;
    h ^= h >> 33;
    h *= 0xc4ceb9fe1a85ec53ULL;
    h ^= h >> 33;
    return (uint32_t)h;
}

/* Retain / release the value's managed handles in slot i, per the layout map. */
static void
iretain_val(KP_VM_P struct kp_imap *m, int32_t i)
{
    int32_t nf, j;
    char *e;
    kp_gptr h;

    if (m->layout == 0)
        return;
    nf = layout_i32(KP_VM_A m->layout, 0);
    e = (char *)ival_at(KP_VM_A m, i);
    for (j = 0; j < nf; j++) {
        memcpy(&h, e + layout_i32(KP_VM_A m->layout, 1 + j), sizeof h);
        RT_RETAIN(h);
    }
}

static void
irelease_val(KP_VM_P struct kp_imap *m, int32_t i)
{
    int32_t nf, j;
    char *e;
    kp_gptr h;

    if (m->layout == 0)
        return;
    nf = layout_i32(KP_VM_A m->layout, 0);
    e = (char *)ival_at(KP_VM_A m, i);
    for (j = 0; j < nf; j++) {
        memcpy(&h, e + layout_i32(KP_VM_A m->layout, 1 + j), sizeof h);
        RT_RELEASE(h);
    }
}

static void imap_finalize(KP_VM_P kp_gptr a);
static void imapiter_finalize(KP_VM_P kp_gptr a);

kp_gptr
kp_imap_new(KP_VM_P int32_t elemsize, kp_gptr layout)
{
    kp_gptr a;
    struct kp_imap *m;

    RT_REGISTER(KP_OBJ_IMAP, imap_finalize);   /* idempotent */
    a = RT_ALLOC((uint32_t)sizeof(struct kp_imap));
    m = imap_ptr(KP_VM_A a);
    m->refcount = 1;
    m->kind = KP_OBJ_IMAP;
    m->count = 0;
    m->tombs = 0;
    m->cap = 0;
    m->elemsize = elemsize;
    m->layout = layout;
    m->keys = 0;
    m->vals = 0;
    m->states = 0;
    m->modcount = 0;
    return a;
}

static void
imap_grow(KP_VM_P kp_gptr a, int32_t newcap)
{
    struct kp_imap *m = imap_ptr(KP_VM_A a);
    kp_gptr oldkeys = m->keys, oldvals = m->vals, oldstates = m->states, nk, nv, ns;
    int32_t oldcap = m->cap, es = m->elemsize, i, j, mask = newcap - 1;
    unsigned char *os;
    int64_t k;

    nk = RT_ALLOC((uint32_t)newcap * IKEYW);
    nv = RT_ALLOC((uint32_t)newcap * (uint32_t)es);
    ns = RT_ALLOC((uint32_t)newcap);
    memset(RT_PTR(ns), 0, (unsigned long)newcap);   /* every slot empty (IST_EMPTY == 0) */
    m = imap_ptr(KP_VM_A a);                         /* re-translate after allocations */
    m->keys = nk;
    m->vals = nv;
    m->states = ns;
    m->cap = newcap;
    m->tombs = 0;
    os = oldstates ? (unsigned char *)RT_PTR(oldstates) : (unsigned char *)0;
    for (i = 0; i < oldcap; i++) {
        if (!os || os[i] != IST_LIVE)
            continue;
        memcpy(&k, (char *)RT_PTR(oldkeys) + (unsigned long)i * IKEYW, sizeof k);
        j = (int32_t)(ihash_key(k) & (uint32_t)mask);
        while (istate_at(KP_VM_A m, j) == IST_LIVE)
            j = (j + 1) & mask;
        set_ikey_at(KP_VM_A m, j, k);
        set_istate_at(KP_VM_A m, j, IST_LIVE);
        memcpy(ival_at(KP_VM_A m, j),
               (char *)RT_PTR(oldvals) + (unsigned long)i * (unsigned long)es,
               (unsigned long)es);
    }
    if (oldkeys)
        RT_FREE(oldkeys);
    if (oldvals)
        RT_FREE(oldvals);
    if (oldstates)
        RT_FREE(oldstates);
}

static int32_t
imap_find(KP_VM_P struct kp_imap *m, int64_t key)
{
    int32_t mask, i;
    unsigned s;

    if (m->cap == 0)
        return -1;
    mask = m->cap - 1;
    i = (int32_t)(ihash_key(key) & (uint32_t)mask);
    for (;;) {
        s = istate_at(KP_VM_A m, i);
        if (s == IST_EMPTY)
            return -1;
        if (s == IST_LIVE && ikey_at(KP_VM_A m, i) == key)
            return i;
        i = (i + 1) & mask;
    }
}

kp_gptr
kp_imap_reserve(KP_VM_P kp_gptr a, int64_t key, int32_t elemsize, kp_gptr layout)
{
    struct kp_imap *m;
    int32_t mask, i, slot, tomb;
    unsigned s;

    if (a == 0)
        a = kp_imap_new(KP_VM_A elemsize, layout);
    else {
        m = imap_ptr(KP_VM_A a);
        m->refcount++;
    }
    m = imap_ptr(KP_VM_A a);
    if (m->cap == 0)
        imap_grow(KP_VM_A a, MAP_INIT_CAP);
    else if ((m->count + m->tombs + 1) * 4 >= m->cap * 3)
        imap_grow(KP_VM_A a, m->cap * 2);
    m = imap_ptr(KP_VM_A a);
    mask = m->cap - 1;
    i = (int32_t)(ihash_key(key) & (uint32_t)mask);
    tomb = -1;
    for (;;) {
        s = istate_at(KP_VM_A m, i);
        if (s == IST_EMPTY) {
            slot = tomb >= 0 ? tomb : i;
            set_ikey_at(KP_VM_A m, slot, key);
            set_istate_at(KP_VM_A m, slot, IST_LIVE);
            memset(ival_at(KP_VM_A m, slot), 0, (unsigned long)m->elemsize);
            m->count++;
            if (slot == tomb)
                m->tombs--;
            m->modcount++;
            return a;
        }
        if (s == IST_TOMB) {
            if (tomb < 0)
                tomb = i;
        }
        else if (ikey_at(KP_VM_A m, i) == key)
            return a;   /* already present: its value slot is reused in place */
        i = (i + 1) & mask;
    }
}

kp_gptr
kp_imap_get(KP_VM_P kp_gptr a, int64_t key)
{
    struct kp_imap *m = imap_ptr(KP_VM_A a);
    int32_t i = a ? imap_find(KP_VM_A m, key) : -1;

    if (i < 0) {
        RT_TRAP_KEY();
        return 0;
    }
    return m->vals + (uint32_t)i * (uint32_t)m->elemsize;
}

int32_t
kp_imap_tryget(KP_VM_P kp_gptr a, int64_t key, kp_gptr vaddr)
{
    struct kp_imap *m = imap_ptr(KP_VM_A a);
    int32_t i = a ? imap_find(KP_VM_A m, key) : -1;

    if (i < 0)
        return 0;
    iretain_val(KP_VM_A m, i);
    release_slot_at(KP_VM_A vaddr, m->layout);
    memcpy(RT_PTR(vaddr), ival_at(KP_VM_A m, i), (unsigned long)m->elemsize);
    return 1;
}

int32_t
kp_imap_has(KP_VM_P kp_gptr a, int64_t key)
{
    struct kp_imap *m = imap_ptr(KP_VM_A a);

    return (a && imap_find(KP_VM_A m, key) >= 0) ? 1 : 0;
}

static void
imap_del_inplace(KP_VM_P kp_gptr a, int64_t key)
{
    struct kp_imap *m = imap_ptr(KP_VM_A a);
    int32_t i = imap_find(KP_VM_A m, key);

    if (i < 0)
        return;
    irelease_val(KP_VM_A m, i);
    set_istate_at(KP_VM_A m, i, IST_TOMB);
    m->count--;
    m->tombs++;
    m->modcount++;
}

kp_gptr
kp_imap_del(KP_VM_P kp_gptr a, int64_t key)
{
    struct kp_imap *m;

    if (a == 0)
        return 0;
    imap_del_inplace(KP_VM_A a, key);
    m = imap_ptr(KP_VM_A a);
    m->refcount++;
    return a;
}

int32_t
kp_imap_len(KP_VM_P kp_gptr a)
{
    struct kp_imap *m = imap_ptr(KP_VM_A a);

    return m ? m->count : 0;
}

kp_gptr
kp_imap_clone(KP_VM_P kp_gptr a)
{
    struct kp_imap *m, *cm;
    kp_gptr c, nk, nv, ns;
    int32_t cap, es, i;

    if (a == 0)
        return 0;
    m = imap_ptr(KP_VM_A a);
    c = kp_imap_new(KP_VM_A m->elemsize, m->layout);
    cap = m->cap;
    es = m->elemsize;
    if (cap > 0) {
        nk = RT_ALLOC((uint32_t)cap * IKEYW);
        nv = RT_ALLOC((uint32_t)cap * (uint32_t)es);
        ns = RT_ALLOC((uint32_t)cap);
        m = imap_ptr(KP_VM_A a);
        cm = imap_ptr(KP_VM_A c);
        memcpy(RT_PTR(nk), RT_PTR(m->keys), (unsigned long)cap * IKEYW);
        memcpy(RT_PTR(nv), RT_PTR(m->vals), (unsigned long)cap * (unsigned long)es);
        memcpy(RT_PTR(ns), RT_PTR(m->states), (unsigned long)cap);
        cm->keys = nk;
        cm->vals = nv;
        cm->states = ns;
        cm->cap = cap;
        cm->count = m->count;
        cm->tombs = m->tombs;
        for (i = 0; i < cap; i++)
            if (istate_at(KP_VM_A cm, i) == IST_LIVE)
                iretain_val(KP_VM_A cm, i);   /* keys are plain values; only values are handles */
    }
    return c;
}

static void
imap_finalize(KP_VM_P kp_gptr a)
{
    struct kp_imap *m = imap_ptr(KP_VM_A a);
    int32_t i;

    for (i = 0; i < m->cap; i++)
        if (istate_at(KP_VM_A m, i) == IST_LIVE)
            irelease_val(KP_VM_A m, i);
    if (m->keys)
        RT_FREE(m->keys);
    if (m->vals)
        RT_FREE(m->vals);
    if (m->states)
        RT_FREE(m->states);
    RT_FREE(a);
}

kp_gptr
kp_imapiter_new(KP_VM_P kp_gptr map)
{
    kp_gptr a;
    struct kp_imapiter *it;

    RT_REGISTER(KP_OBJ_IMAPITER, imapiter_finalize);   /* idempotent */
    a = RT_ALLOC((uint32_t)sizeof(struct kp_imapiter));
    it = iiter_ptr(KP_VM_A a);
    it->refcount = 1;
    it->kind = KP_OBJ_IMAPITER;
    it->map = map;
    it->pos = 0;
    if (map) {
        RT_RETAIN(map);
        it->modcount = imap_ptr(KP_VM_A map)->modcount;
    }
    else
        it->modcount = 0;
    return a;
}

int32_t
kp_imapiter_next(KP_VM_P kp_gptr a, kp_gptr kaddr, kp_gptr vaddr)
{
    struct kp_imapiter *it = iiter_ptr(KP_VM_A a);
    kp_gptr mid = it->map;
    struct kp_imap *m;
    int32_t i;
    int64_t k;

    if (mid == 0)
        return 0;
    m = imap_ptr(KP_VM_A mid);
    if (m->modcount != it->modcount) {
        RT_TRAP_CONCMOD();
        return 0;
    }
    while (it->pos < m->cap) {
        i = it->pos++;
        if (istate_at(KP_VM_A m, i) != IST_LIVE)
            continue;
        /* the key is a plain int64 value, not a handle: write it straight out (the front end
           narrows it to the binder's ordinal width) */
        k = ikey_at(KP_VM_A m, i);
        memcpy(RT_PTR(kaddr), &k, sizeof k);
        /* write an owned copy of the value to *vaddr */
        iretain_val(KP_VM_A m, i);
        release_slot_at(KP_VM_A vaddr, m->layout);
        memcpy(RT_PTR(vaddr), ival_at(KP_VM_A m, i), (unsigned long)m->elemsize);
        return 1;
    }
    return 0;
}

static void
imapiter_finalize(KP_VM_P kp_gptr a)
{
    struct kp_imapiter *it = iiter_ptr(KP_VM_A a);

    if (it->map)
        RT_RELEASE(it->map);
    RT_FREE(a);
}
