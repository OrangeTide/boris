#ifndef _STDDEF_H
#define _STDDEF_H

/* On every skj target the pointer, long, and size types are one machine word:
   four bytes under __skj_ilp32__, eight under __skj_lp64__.  So size_t is
   unsigned long and ptrdiff_t is long, with no per-target branch needed. */
typedef unsigned long size_t;
typedef long ptrdiff_t;

#ifndef NULL
#define NULL ((void *)0)
#endif

#define offsetof(type, member) ((size_t)&(((type *)0)->member))

#endif
