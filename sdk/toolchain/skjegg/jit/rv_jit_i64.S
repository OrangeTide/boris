/* rv_jit_i64.S : the RV32 stack-ABI 64-bit helpers for the in-process RV JIT.

   The helper bodies (skj_jit_muldi3 / _ashldi3 / _ashrdi3 / _lshrdi3) are shared
   with the C AOT runtime, so they live once in runtime/i64_rv.S and both files
   .include it.  The JIT driver is an ordinary C program whose own libgcc
   __muldi3 (if any) uses the C register ABI, so the guest's stack-ABI helpers
   keep the distinct skj_jit_* names and the driver binds the guest's __muldi3 /
   __ashldi3 / __ashrdi3 / __lshrdi3 to them through its table.  No __ names are
   defined here, so this object is safe to link beside the driver's libgcc. */

	.include "runtime/i64_rv.S"

	.section .note.GNU-stack,"",%progbits
