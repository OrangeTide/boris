# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl __assert_fail
	.type __assert_fail, @function
__assert_fail:
	addi sp, sp, -336
	sw ra, 332(sp)
	sw s0, 328(sp)
	addi s0, sp, 328
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw s6, 24(sp)
	sw s7, 28(sp)
	sw s8, 32(sp)
	sw s9, 36(sp)
	sw s10, 40(sp)
	sw s11, 44(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	addi s1, s0, -272
	li s2, 256
	la s3, __str_0
	lw s4, -8(s0)
	lw s5, -12(s0)
	lw s6, -16(s0)
	lw s7, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	sw s7, 12(sp)
	jal ra, snprintf
	mv s8, a0
	addi sp, sp, 16
	sw s8, -276(s0)
	lw s1, -276(s0)
	li s2, 256
	slt s3, s2, s1
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	li s1, 256
	li s2, 1
	sub s3, s1, s2
	sw s3, -276(s0)
.L1_1:
	li s1, 2
	addi s2, s0, -272
	lw s3, -276(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, write
	mv s4, a0
	jal ra, abort
	mv s1, a0
	li s1, 0
	mv a0, s1
	lw s1, -324(s0)
	lw s2, -320(s0)
	lw s3, -316(s0)
	lw s4, -312(s0)
	lw s5, -308(s0)
	lw s6, -304(s0)
	lw s7, -300(s0)
	lw s8, -296(s0)
	lw s9, -292(s0)
	lw s10, -288(s0)
	lw s11, -284(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end1:
	.size __assert_fail, .Lfunc_end1-__assert_fail

	.data
	.align 2
__str_0:
	.ascii "%s:%d: %s: assertion failed: %s\n\000"
