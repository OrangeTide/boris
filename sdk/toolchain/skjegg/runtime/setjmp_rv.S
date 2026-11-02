/* setjmp_rv.S : RV32 setjmp/longjmp.  jmp_buf (a long[32]) holds the
   callee-saved registers longjmp must restore: ra, sp, and s0..s11.  Float is
   not saved (the compiler the self-host build runs does not keep live fs
   registers across a setjmp).  setjmp returns 0 on the direct call; longjmp
   resumes it returning val (or 1 if val is 0). */

	.text
	.globl setjmp
	.globl longjmp

	.type	setjmp,@function
setjmp:
	sw	ra, 0(a0)
	sw	sp, 4(a0)
	sw	s0, 8(a0)
	sw	s1, 12(a0)
	sw	s2, 16(a0)
	sw	s3, 20(a0)
	sw	s4, 24(a0)
	sw	s5, 28(a0)
	sw	s6, 32(a0)
	sw	s7, 36(a0)
	sw	s8, 40(a0)
	sw	s9, 44(a0)
	sw	s10, 48(a0)
	sw	s11, 52(a0)
	li	a0, 0
	ret
	.size	setjmp,.-setjmp

	.type	longjmp,@function
longjmp:
	lw	ra, 0(a0)
	lw	sp, 4(a0)
	lw	s0, 8(a0)
	lw	s1, 12(a0)
	lw	s2, 16(a0)
	lw	s3, 20(a0)
	lw	s4, 24(a0)
	lw	s5, 28(a0)
	lw	s6, 32(a0)
	lw	s7, 36(a0)
	lw	s8, 40(a0)
	lw	s9, 44(a0)
	lw	s10, 48(a0)
	lw	s11, 52(a0)
	mv	a0, a1			/* return val ... */
	bnez	a0, 1f
	li	a0, 1			/* ... but never 0 */
1:	ret
	.size	longjmp,.-longjmp
