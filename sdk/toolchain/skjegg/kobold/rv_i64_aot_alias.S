/* rv_i64_aot_alias.S : the rv32 backend lowers a 64-bit multiply and the shift
   family to stack-ABI helpers emitted under the libgcc names (__muldi3, __ashldi3,
   __ashrdi3, __lshrdi3).  The JIT binds those names to the stack-ABI routines in
   jit/rv_jit_i64.S through its table; the AOT link has no table, so define those
   names here as tail-jumps into the skj_jit_* routines.  A real definition (not a
   .set alias, which to an external symbol stays undefined) is what makes the linker
   resolve the guest's calls here and never pull the toolchain library's own,
   register-ABI, __muldi3.  tail is a bare jump: it leaves sp and ra untouched, so
   the stack-passed arguments and the return address reach the routine unchanged.

   This is safe because the AOT runtime's own 64-bit arithmetic never calls these
   names: its divide and modulo use the register-ABI __divdi3 family (resolved from
   the toolchain library, which the backend emits with the matching ABI) and the
   compiler inlines the rest, so there is no collision. */

    .text
    .globl __muldi3
__muldi3:
    tail skj_jit_muldi3

    .globl __ashldi3
__ashldi3:
    tail skj_jit_ashldi3

    .globl __ashrdi3
__ashrdi3:
    tail skj_jit_ashrdi3

    .globl __lshrdi3
__lshrdi3:
    tail skj_jit_lshrdi3
