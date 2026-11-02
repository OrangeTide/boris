/* i64_rv.S : the RV32 stack-ABI 64-bit helpers (a 64-bit multiply and the
 * shift family), written once and shared by every assembler path.
 *
 * RV32 has no native 64-bit register, so the backend lowers a 64-bit multiply
 * and the shift family to calls into these helpers, passing the operands on the
 * stack (not in registers) and taking the result in a0:a1.  That is an internal
 * ABI between the backend and its runtime, distinct from the C register ABI.
 *
 * The routines carry the internal name skj_jit_*, never the libgcc __muldi3 /
 * __ashldi3 / __ashrdi3 / __lshrdi3 names, so this fragment is safe to link into
 * the JIT driver (an ordinary C program whose own libgcc may define the __
 * names with the C register ABI).  Each AOT path that needs the public __ names
 * adds its own tail-jump aliases into these bodies (runtime/start_rv.S for the C
 * runtime, kobold/rv_i64_aot_alias.S for the Kobold freestanding runtime), so
 * the bodies are not duplicated.
 *
 * This file is read raw by three assemblers (GNU as via runtime/start_rv.S,
 * skj-as-rv via jit/rv_jit_i64.S, and the LLVM integrated assembler when the
 * Kobold target toolchain builds libkpaot-rv.a).  LLVM's assembler rejects a
 * block comment trailing an instruction, so comments stay on their own lines and
 * never follow an instruction.  Leaf code: it touches only a0-a3 and t0-t2 and
 * reads its operands relative to the caller's sp.
 */

	.text

/* skj_jit_muldi3: Stack 8(sp)=a_lo 12(sp)=a_hi 0(sp)=b_lo 4(sp)=b_hi -> a0:a1.
   result_lo = lo32(a_lo * b_lo);
   result_hi = hi32(a_lo * b_lo) + lo32(a_hi * b_lo) + lo32(a_lo * b_hi). */
	.globl skj_jit_muldi3
	.type	skj_jit_muldi3,@function
skj_jit_muldi3:
	lw	a0, 8(sp)
	lw	a1, 12(sp)
	lw	a2, 0(sp)
	lw	a3, 4(sp)
	mulhu	t0, a0, a2
	mul	t1, a1, a2
	add	t0, t0, t1
	mul	t1, a0, a3
	add	a1, t0, t1
	mul	a0, a0, a2
	ret
	.size	skj_jit_muldi3,.-skj_jit_muldi3

/* skj_jit_ashldi3: Stack 0(sp)=shift 4(sp)=a_lo 8(sp)=a_hi -> a0:a1.
   64-bit left shift. */
	.globl skj_jit_ashldi3
	.type	skj_jit_ashldi3,@function
skj_jit_ashldi3:
	lw	a2, 0(sp)
	lw	a0, 4(sp)
	lw	a1, 8(sp)
	li	t0, 32
	bge	a2, t0, .Lashl_ge32
	beqz	a2, .Lashl_done
	/* shift < 32: a1 = (a_hi << n) | (a_lo >> (32-n)); a0 = a_lo << n */
	sll	a1, a1, a2
	sub	t1, t0, a2
	srl	t2, a0, t1
	or	a1, a1, t2
	sll	a0, a0, a2
	ret
.Lashl_ge32:
	/* 32 <= shift: a1 = a_lo << (n-32); a0 = 0 (and 0:0 for shift >= 64) */
	li	t0, 64
	bge	a2, t0, .Lashl_zero
	addi	a2, a2, -32
	sll	a1, a0, a2
	li	a0, 0
	ret
.Lashl_zero:
	li	a0, 0
	li	a1, 0
.Lashl_done:
	ret
	.size	skj_jit_ashldi3,.-skj_jit_ashldi3

/* skj_jit_ashrdi3: Stack 0(sp)=shift 4(sp)=a_lo 8(sp)=a_hi -> a0:a1.
   64-bit arithmetic right shift. */
	.globl skj_jit_ashrdi3
	.type	skj_jit_ashrdi3,@function
skj_jit_ashrdi3:
	lw	a2, 0(sp)
	lw	a0, 4(sp)
	lw	a1, 8(sp)
	li	t0, 32
	bge	a2, t0, .Lashr_ge32
	beqz	a2, .Lashr_done
	/* shift < 32: a0 = (a_lo >> n) | (a_hi << (32-n)); a1 = a_hi >> n (arith) */
	srl	a0, a0, a2
	sub	t1, t0, a2
	sll	t2, a1, t1
	or	a0, a0, t2
	sra	a1, a1, a2
	ret
.Lashr_ge32:
	/* 32 <= shift: a0 = a_hi >> (n-32) (arith); a1 = sign bits */
	li	t0, 64
	bge	a2, t0, .Lashr_sign
	addi	a2, a2, -32
	sra	a0, a1, a2
	srai	a1, a1, 31
	ret
.Lashr_sign:
	srai	a1, a1, 31
	mv	a0, a1
.Lashr_done:
	ret
	.size	skj_jit_ashrdi3,.-skj_jit_ashrdi3

/* skj_jit_lshrdi3: Stack 0(sp)=shift 4(sp)=a_lo 8(sp)=a_hi -> a0:a1.
   64-bit logical right shift. */
	.globl skj_jit_lshrdi3
	.type	skj_jit_lshrdi3,@function
skj_jit_lshrdi3:
	lw	a2, 0(sp)
	lw	a0, 4(sp)
	lw	a1, 8(sp)
	li	t0, 32
	bge	a2, t0, .Llshr_ge32
	beqz	a2, .Llshr_done
	/* shift < 32: a0 = (a_lo >> n) | (a_hi << (32-n)); a1 = a_hi >> n */
	srl	a0, a0, a2
	sub	t1, t0, a2
	sll	t2, a1, t1
	or	a0, a0, t2
	srl	a1, a1, a2
	ret
.Llshr_ge32:
	/* 32 <= shift: a0 = a_hi >> (n-32); a1 = 0 */
	li	t0, 64
	bge	a2, t0, .Llshr_zero
	addi	a2, a2, -32
	srl	a0, a1, a2
	li	a1, 0
	ret
.Llshr_zero:
	li	a0, 0
	li	a1, 0
.Llshr_done:
	ret
	.size	skj_jit_lshrdi3,.-skj_jit_lshrdi3
