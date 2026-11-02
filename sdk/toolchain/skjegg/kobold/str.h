/* str.h : the minimal VM string runtime */

#ifndef KP_STR_H
#define KP_STR_H

#include <stdint.h>
#include "rt_glue.h"

#ifndef KP_VM_FWD
#define KP_VM_FWD
typedef struct kp_vm kp_vm;
#endif

/* A `string` is a guest-heap object: a reference count and kind tag, then the byte length,
   an allocated byte capacity, and the bytes inline. The value the front end holds is the
   object's guest address (0 is nil, counted as the empty string), so the byte storage is
   guest-visible: the code generator reads a character inline with kp_str_base, the byte
   length with kp_str_len, and a `LB` at base + (i - 1) (Pascal indexes from 1).

   A string presents as immutable to a reader: its len bytes never change under it, there is
   no s[i] := c and no SetLength(s). The one exception is append (kp_str_append*), which the
   front end emits only for the self-append idiom (x := x + e). Append grows the string in
   place when it is uniquely owned (refcount 1) with spare capacity, and otherwise builds an
   independent copy, so no value another owner holds is ever disturbed and the immutable view
   is preserved. A new value is otherwise built by concatenation (kp_str_concat) or Copy
   (kp_str_copy).

   kp_str_bytes is the read side a host output routine uses; it stays NUL-terminated. */
kp_gptr    kp_str_new(KP_VM_P const char *bytes, int len);
kp_gptr    kp_str_new_guest(KP_VM_P kp_gptr addr, int len);  /* bytes at a guest address */
kp_gptr    kp_str_concat(KP_VM_P kp_gptr a, kp_gptr b);
kp_gptr    kp_str_append(KP_VM_P kp_gptr s, kp_gptr t);      /* append t to s (consumes s) */
kp_gptr    kp_str_append_char(KP_VM_P kp_gptr s, int32_t code); /* append one byte to s */
int32_t     kp_str_len(KP_VM_P kp_gptr s);
const char *kp_str_bytes(KP_VM_P kp_gptr s);   /* NUL-terminated; "" for nil */
kp_gptr    kp_str_base(KP_VM_P kp_gptr s);    /* guest address of the bytes, 0 if empty */

/* The query and conversion helpers behind the Pascal builtins. kp_str_from_int formats an
   integer as a decimal string (Str). kp_str_pos returns the 1-based position of sub within s,
   or 0 when it does not occur (Pos). kp_str_copy returns the count characters from a 1-based
   index, clamped to the string (Copy). The Val helpers parse s: kp_str_val_int and
   kp_str_val_real give the parsed value, and kp_str_valcode gives 0 for a fully valid parse
   or the 1-based position of the first offending character, as FPC's Val code parameter. */
kp_gptr    kp_str_from_int(KP_VM_P int32_t x);
kp_gptr    kp_str_from_int64(KP_VM_P int64_t x);     /* Str of an Int64 value */
kp_gptr    kp_str_from_char(KP_VM_P int32_t code);   /* a 1-char string from a byte code */
int32_t     kp_str_cmp(KP_VM_P kp_gptr a, kp_gptr b);  /* <0, 0, >0 by byte order then length */
int32_t     kp_str_pos(KP_VM_P kp_gptr sub, kp_gptr s);
kp_gptr    kp_str_copy(KP_VM_P kp_gptr s, int32_t index, int32_t count);
int32_t     kp_str_val_int(KP_VM_P kp_gptr s);
int64_t     kp_str_val_int64(KP_VM_P kp_gptr s);   /* Val into an Int64 destination */
KP_REAL     kp_str_val_real(KP_VM_P kp_gptr s);   /* double hosted, float in the sandbox */
int32_t     kp_str_valcode(KP_VM_P kp_gptr s, int32_t kind);  /* 0 int32, 1 real, 2 int64 */

#endif /* KP_STR_H */
