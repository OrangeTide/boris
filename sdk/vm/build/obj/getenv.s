# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl getenv
	.type getenv, @function
getenv:
	addi sp, sp, -80
	sw ra, 76(sp)
	sw s0, 72(sp)
	addi s0, sp, 72
	sw s1, 12(sp)
	sw s2, 16(sp)
	sw s3, 20(sp)
	sw s4, 24(sp)
	sw s5, 28(sp)
	sw s6, 32(sp)
	sw s7, 36(sp)
	sw s8, 40(sp)
	sw s9, 44(sp)
	sw s10, 48(sp)
	sw s11, 52(sp)
	sw a0, -4(s0)
	la s1, environ
	lw s2, 0(s1)
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L1_0
	j .L1_1
.L1_1:
	li s1, 0
	mv a0, s1
	lw s1, -60(s0)
	lw s2, -56(s0)
	lw s3, -52(s0)
	lw s4, -48(s0)
	lw s5, -44(s0)
	lw s6, -40(s0)
	lw s7, -36(s0)
	lw s8, -32(s0)
	lw s9, -28(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L1_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -16(s0)
.L1_2:
	lw s1, -12(s0)
	lw s2, 0(s1)
	bnez s2, .L1_3
	j .L1_4
.L1_3:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	lw s3, -16(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L1_5
	j .L1_6
.L1_5:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_7
	j .L1_6
.L1_7:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	add s3, s2, s1
	li s1, 1
	add s2, s3, s1
	mv a0, s2
	lw s1, -60(s0)
	lw s2, -56(s0)
	lw s3, -52(s0)
	lw s4, -48(s0)
	lw s5, -44(s0)
	lw s6, -40(s0)
	lw s7, -36(s0)
	lw s8, -32(s0)
	lw s9, -28(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L1_6:
.L1_8:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	sw s3, -12(s0)
	j .L1_2
.L1_4:
	li s1, 0
	mv a0, s1
	lw s1, -60(s0)
	lw s2, -56(s0)
	lw s3, -52(s0)
	lw s4, -48(s0)
	lw s5, -44(s0)
	lw s6, -40(s0)
	lw s7, -36(s0)
	lw s8, -32(s0)
	lw s9, -28(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end1:
	.size getenv, .Lfunc_end1-getenv

	.data
	.align 2
	.globl environ
environ:
	.word 0
