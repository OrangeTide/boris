# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type glue_fill_entropy, @function
glue_fill_entropy:
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
	sw a1, -8(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, getrandom
	mv s4, a0
	lw s1, -8(s0)
	xor s2, s4, s1
	seqz s2, s2
	mv a0, s2
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
.Lfunc_end1:
	.size glue_fill_entropy, .Lfunc_end1-glue_fill_entropy

	.text
	.align 2
	.type glue_now_ms, @function
glue_now_ms:
	addi sp, sp, -80
	sw ra, 76(sp)
	sw s0, 72(sp)
	addi s0, sp, 72
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
	sw s7, 32(sp)
	sw s8, 36(sp)
	sw s9, 40(sp)
	sw s10, 44(sp)
	sw s11, 48(sp)
	addi t0, s0, -8
	sw t0, -12(s0)
	li s2, 0
	lw t0, -12(s0)
	sw s2, 0(t0)
	li s3, 4
	lw t0, -12(s0)
	add s1, t0, s3
	sw s2, 0(s1)
	li s1, 0
	lw t0, -12(s0)
	sw s1, 0(t0)
	li s1, 0
	li s2, 4
	lw t0, -12(s0)
	add s3, t0, s2
	sw s1, 0(s3)
	li s1, 1
	addi s2, s0, -8
	mv a0, s1
	mv a1, s2
	jal ra, clock_gettime
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L2_0
	j .L2_1
.L2_0:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
	lw s1, -64(s0)
	lw s2, -60(s0)
	lw s3, -56(s0)
	lw s4, -52(s0)
	lw s5, -48(s0)
	lw s6, -44(s0)
	lw s7, -40(s0)
	lw s8, -36(s0)
	lw s9, -32(s0)
	lw s10, -28(s0)
	lw s11, -24(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L2_1:
	addi s1, s0, -8
	li s2, 0
	li s3, 4
	mul t0, s2, s3
	sw t0, -16(s0)
	lw t1, -16(s0)
	add s2, s1, t1
	lw s1, 0(s2)
	mv s10, s1
	srai s11, s10, 31
	li s1, 1000
	mv s8, s1
	srai s9, s8, 31
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	jal ra, __muldi3
	addi sp, sp, 16
	mv s6, a0
	mv s7, a1
	addi s1, s0, -8
	li s2, 1
	li s3, 4
	mul t0, s2, s3
	sw t0, -20(s0)
	lw t1, -20(s0)
	add s2, s1, t1
	lw s1, 0(s2)
	mv s10, s1
	srai s11, s10, 31
	li s1, 1000000
	mv s8, s1
	srai s9, s8, 31
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __divdi3
	mv s4, a0
	mv s5, a1
	add s10, s6, s4
	sltu t0, s10, s4
	add s11, s7, t0
	add s11, s11, s5
	mv a0, s10
	mv a1, s11
	lw s1, -64(s0)
	lw s2, -60(s0)
	lw s3, -56(s0)
	lw s4, -52(s0)
	lw s5, -48(s0)
	lw s6, -44(s0)
	lw s7, -40(s0)
	lw s8, -36(s0)
	lw s9, -32(s0)
	lw s10, -28(s0)
	lw s11, -24(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end2:
	.size glue_now_ms, .Lfunc_end2-glue_now_ms

	.text
	.align 2
	.type entropy_seed, @function
entropy_seed:
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
	li s1, 2654435769
	sw s1, -4(s0)
	addi s1, s0, -8
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, glue_fill_entropy
	mv s3, a0
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	addi s1, s0, -8
	li s2, 0
	add s3, s1, s2
	lbu s1, 0(s3)
	addi s2, s0, -8
	li s3, 1
	add s4, s2, s3
	lbu s2, 0(s4)
	li s3, 8
	sll s4, s2, s3
	or s2, s1, s4
	addi s1, s0, -8
	li s3, 2
	add s4, s1, s3
	lbu s1, 0(s4)
	li s3, 16
	sll s4, s1, s3
	or s1, s2, s4
	addi s2, s0, -8
	li s3, 3
	add s4, s2, s3
	lbu s2, 0(s4)
	li s3, 24
	sll s4, s2, s3
	or s2, s1, s4
	sw s2, -4(s0)
.L3_1:
	lw s1, -4(s0)
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
.Lfunc_end3:
	.size entropy_seed, .Lfunc_end3-entropy_seed

	.text
	.align 2
	.type ensure_rng, @function
ensure_rng:
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
	la s1, g_rng_seeded
	lw s2, 0(s1)
	bnez s2, .L4_0
	j .L4_1
.L4_1:
	la s1, g_rng
	jal ra, entropy_seed
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, kp_rng_seed
	mv s3, a0
	li s1, 1
	la s2, g_rng_seeded
	sw s1, 0(s2)
.L4_0:
	li s1, 0
	mv a0, s1
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
.Lfunc_end4:
	.size ensure_rng, .Lfunc_end4-ensure_rng

	.text
	.align 2
	.globl kp_random_seed
	.type kp_random_seed, @function
kp_random_seed:
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
	la s1, g_rng
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_rng_seed
	mv s3, a0
	li s1, 1
	la s2, g_rng_seeded
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
.Lfunc_end5:
	.size kp_random_seed, .Lfunc_end5-kp_random_seed

	.text
	.align 2
	.globl kp_randomize
	.type kp_randomize, @function
kp_randomize:
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
	la s1, g_rng
	jal ra, entropy_seed
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, kp_rng_seed
	mv s3, a0
	li s1, 1
	la s2, g_rng_seeded
	sw s1, 0(s2)
	li s1, 0
	mv a0, s1
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
.Lfunc_end6:
	.size kp_randomize, .Lfunc_end6-kp_randomize

	.text
	.align 2
	.globl kp_random_real
	.type kp_random_real, @function
kp_random_real:
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
	fsd fs0, 48(sp)
	jal ra, ensure_rng
	mv s1, a0
	la s1, g_rng
	addi sp, sp, -16
	mv a0, s1
	jal ra, kp_rng_real
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -8(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -8(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end7:
	.size kp_random_real, .Lfunc_end7-kp_random_real

	.text
	.align 2
	.globl kp_random_below
	.type kp_random_below, @function
kp_random_below:
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
	jal ra, ensure_rng
	mv s1, a0
	lw s1, -4(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L8_0
	j .L8_1
.L8_0:
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
.L8_1:
	la s1, g_rng
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_rng_below
	mv s3, a0
	mv a0, s3
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
.Lfunc_end8:
	.size kp_random_below, .Lfunc_end8-kp_random_below

	.text
	.align 2
	.globl kp_secure_bytes
	.type kp_secure_bytes, @function
kp_secure_bytes:
	addi sp, sp, -112
	sw ra, 108(sp)
	sw s0, 104(sp)
	addi s0, sp, 104
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
	lw s1, -8(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_0
	j .L9_1
.L9_1:
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_0
	j .L9_2
.L9_0:
	lw s1, -100(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	lw s4, -88(s0)
	lw s5, -84(s0)
	lw s6, -80(s0)
	lw s7, -76(s0)
	lw s8, -72(s0)
	lw s9, -68(s0)
	lw s10, -64(s0)
	lw s11, -60(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L9_2:
	la s1, g_csprng_seeded
	lw s2, 0(s1)
	bnez s2, .L9_3
	j .L9_4
.L9_4:
	addi s1, s0, -40
	li s2, 32
	mv a0, s1
	mv a1, s2
	jal ra, glue_fill_entropy
	mv s3, a0
	bnez s3, .L9_5
	j .L9_6
.L9_6:
	la s1, g_rng
	la s2, g_rng
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, kp_rng_seed
	mv s3, a0
.L9_5:
	addi s1, s0, -52
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, glue_fill_entropy
	mv s3, a0
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	la s1, g_csprng
	addi s2, s0, -40
	addi s3, s0, -52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, kp_csprng_seed
	mv s4, a0
	li s1, 1
	la s2, g_csprng_seeded
	sw s1, 0(s2)
.L9_3:
	la s1, g_csprng
	lw s2, -4(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, kp_csprng_bytes
	mv s4, a0
	li s1, 0
	mv a0, s1
	lw s1, -100(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	lw s4, -88(s0)
	lw s5, -84(s0)
	lw s6, -80(s0)
	lw s7, -76(s0)
	lw s8, -72(s0)
	lw s9, -68(s0)
	lw s10, -64(s0)
	lw s11, -60(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end9:
	.size kp_secure_bytes, .Lfunc_end9-kp_secure_bytes

	.text
	.align 2
	.globl kp_secure_below
	.type kp_secure_below, @function
kp_secure_below:
	addi sp, sp, -80
	sw ra, 76(sp)
	sw s0, 72(sp)
	addi s0, sp, 72
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
	lw s1, -4(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	li s1, 0
	mv a0, s1
	lw s1, -68(s0)
	lw s2, -64(s0)
	lw s3, -60(s0)
	lw s4, -56(s0)
	lw s5, -52(s0)
	lw s6, -48(s0)
	lw s7, -44(s0)
	lw s8, -40(s0)
	lw s9, -36(s0)
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L10_1:
	lw s1, -4(s0)
	sw s1, -12(s0)
	li s10, 0
	li s11, 1
	li s8, 0
	li s9, 1
	lw s1, -12(s0)
	mv s6, s1
	li s7, 0
	mv a0, s8
	mv a1, s9
	mv a2, s6
	mv a3, s7
	jal ra, __umoddi3
	mv s4, a0
	mv s5, a1
	sltu t0, s10, s4
	sub s8, s10, s4
	sub s9, s11, t0
	sub s9, s9, s5
	mv s1, s8
	sw s1, -16(s0)
.L10_2:
	addi s1, s0, -20
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, kp_secure_bytes
	mv s3, a0
.L10_3:
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L10_4
	j .L10_5
.L10_4:
	lw s1, -20(s0)
	lw s2, -16(s0)
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_2
	j .L10_5
.L10_5:
	lw s1, -20(s0)
	lw s2, -12(s0)
	remu s3, s1, s2
	mv a0, s3
	lw s1, -68(s0)
	lw s2, -64(s0)
	lw s3, -60(s0)
	lw s4, -56(s0)
	lw s5, -52(s0)
	lw s6, -48(s0)
	lw s7, -44(s0)
	lw s8, -40(s0)
	lw s9, -36(s0)
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end10:
	.size kp_secure_below, .Lfunc_end10-kp_secure_below

	.text
	.align 2
	.globl kp_now_ms
	.type kp_now_ms, @function
kp_now_ms:
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
	jal ra, glue_now_ms
	mv s10, a0
	mv s11, a1
	mv a0, s10
	mv a1, s11
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
.Lfunc_end11:
	.size kp_now_ms, .Lfunc_end11-kp_now_ms

	.data

	.bss
	.align 2
	.globl g_csprng_seeded
g_csprng_seeded:
	.space 4
	.align 2
	.globl g_rng_seeded
g_rng_seeded:
	.space 4
	.align 2
	.globl g_csprng
g_csprng:
	.space 132
	.align 2
	.globl g_rng
g_rng:
	.space 16
