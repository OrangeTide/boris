# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl kp_sleep_ms
	.type kp_sleep_ms, @function
kp_sleep_ms:
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
	lw s1, -4(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	li s1, 0
	sw s1, -4(s0)
.L1_1:
	lw s1, -4(s0)
	li s2, 1000
	div s3, s1, s2
	addi s1, s0, -16
	sw s3, 0(s1)
	lw s1, -4(s0)
	li s2, 1000
	rem s3, s1, s2
	li s1, 1000000
	mul s2, s3, s1
	addi s1, s0, -16
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	addi s1, s0, -16
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, nanosleep
	mv s3, a0
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
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
	.size kp_sleep_ms, .Lfunc_end1-kp_sleep_ms

	.data
