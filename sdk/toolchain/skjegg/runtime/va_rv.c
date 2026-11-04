/* va_rv.c - RISC-V RV32 va_arg helper for skj-cc.

   skjegg routes every unnamed argument of a variadic call onto the caller's
   outgoing stack block (see rv_abi_assign's first_vararg in the backend), so
   the unnamed arguments are contiguous just past the named stack arguments.
   The backend's IR_VA_START points overflow_arg_area at the first unnamed
   argument; cc lowers va_arg to a call to __va_arg, which 8-aligns the cursor
   for a 64-bit slot, returns a pointer to it, and advances by the slot size.

   This is self-consistent for skj -> skj.  It is not the standard RISC-V
   variadic ABI (which passes unnamed arguments in a0-a7 with a GPR save area
   and 8-aligns 64-bit arguments to a register pair), so a skj-compiled
   variadic function does not interoperate with a gcc caller and vice versa.
   The overflow block's base (fp+8) is 16-aligned, so an absolute 8-alignment
   here matches the caller's relative slot alignment. */

struct __va_list_tag {
    unsigned gp_offset;
    unsigned fp_offset;
    void *overflow_arg_area;
    void *reg_save_area;
};

/* kind: 0 = 32-bit int/pointer (4 bytes), 1 = double, 2 = 64-bit integer */
void *
__va_arg(struct __va_list_tag *ap, int kind)
{
    char *p = ap->overflow_arg_area;
    void *r;

    if (kind != 0)              /* a two-word argument is 8-aligned */
        p = (char *)(((unsigned long)p + 7u) & ~(unsigned long)7u);
    r = p;
    p += (kind == 0) ? 4 : 8;
    ap->overflow_arg_area = p;
    return r;
}
