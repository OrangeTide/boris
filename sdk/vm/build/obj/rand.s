# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl rand
	.type rand, @function
rand:
	addi sp, sp, -64
	sw ra, 60(sp)
	sw s0, 56(sp)
	addi s0, sp, 56
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
	la s1, seeded
	lw s2, 0(s1)
	bnez s2, .L1_0
	j .L1_1
.L1_1:
	la s1, state
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, kp_rng_seed
	mv s3, a0
	li s1, 1
	la s2, seeded
	sw s1, 0(s2)
.L1_0:
	la s1, state
	mv a0, s1
	jal ra, kp_rng_u32
	mv s2, a0
	li s1, 17
	srl s3, s2, s1
	mv a0, s3
	lw s1, -44(s0)
	lw s2, -40(s0)
	lw s3, -36(s0)
	lw s4, -32(s0)
	lw s5, -28(s0)
	lw s6, -24(s0)
	lw s7, -20(s0)
	lw s8, -16(s0)
	lw s9, -12(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end1:
	.size rand, .Lfunc_end1-rand

	.text
	.align 2
	.globl srand
	.type srand, @function
srand:
	addi sp, sp, -64
	sw ra, 60(sp)
	sw s0, 56(sp)
	addi s0, sp, 56
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
	la s1, state
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_rng_seed
	mv s3, a0
	li s1, 1
	la s2, seeded
	sw s1, 0(s2)
	li s1, 0
	mv a0, s1
	lw s1, -52(s0)
	lw s2, -48(s0)
	lw s3, -44(s0)
	lw s4, -40(s0)
	lw s5, -36(s0)
	lw s6, -32(s0)
	lw s7, -28(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end2:
	.size srand, .Lfunc_end2-srand

	.data

	.bss
	.align 2
	.globl seeded
seeded:
	.space 4
	.align 2
	.globl state
state:
	.space 16
