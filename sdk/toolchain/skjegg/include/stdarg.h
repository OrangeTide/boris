#ifndef _STDARG_H
#define _STDARG_H

/* C99 variable arguments for skj-cc.  The compiler provides the primitives:
   __builtin_va_list is the va_list representation, and __builtin_va_start /
   __builtin_va_arg / __builtin_va_end are intercepted in lowering.  The
   backend's IR_VA_START and the per-ABI runtime __va_arg agree on the layout,
   so this header only names the standard spellings. */

typedef __builtin_va_list va_list;

#define va_start(ap, last) __builtin_va_start((ap), (last))
#define va_arg(ap, type)   __builtin_va_arg((ap), type)
#define va_end(ap)         __builtin_va_end((ap))

/* va_list is an array of one tag struct, so a va_list name decays to the
   address of its struct; copying dereferences both and assigns the struct. */
#define va_copy(dst, src)  (*(dst) = *(src))

#endif /* _STDARG_H */
