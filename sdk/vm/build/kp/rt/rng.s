# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type rotl32, @function
rotl32:
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
	sll s3, s1, s2
	lw s1, -4(s0)
	li s2, 32
	lw s4, -8(s0)
	sub s5, s2, s4
	srl s2, s1, s5
	or s1, s3, s2
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
.Lfunc_end1:
	.size rotl32, .Lfunc_end1-rotl32

	.text
	.align 2
	.globl kp_splitmix32
	.type kp_splitmix32, @function
kp_splitmix32:
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
	lw s2, 0(s1)
	li s3, 2654435769
	add s4, s2, s3
	sw s4, 0(s1)
	sw s4, -12(s0)
	lw s1, -12(s0)
	lw s2, -12(s0)
	li s3, 16
	srl s4, s2, s3
	xor s2, s1, s4
	li s1, 569420461
	mul s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	lw s2, -12(s0)
	li s3, 15
	srl s4, s2, s3
	xor s2, s1, s4
	li s1, 1935289751
	mul s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	lw s2, -12(s0)
	li s3, 15
	srl s4, s2, s3
	xor s2, s1, s4
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
.Lfunc_end2:
	.size kp_splitmix32, .Lfunc_end2-kp_splitmix32

	.text
	.align 2
	.globl kp_rng_seed
	.type kp_rng_seed, @function
kp_rng_seed:
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
	sw a1, -8(s0)
	lw s1, -8(s0)
	sw s1, -12(s0)
	li s1, 1
	sw s1, -20(s0)
	li s1, 0
	sw s1, -16(s0)
.L3_0:
	lw s1, -16(s0)
	li s2, 4
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	addi s1, s0, -12
	mv a0, s1
	jal ra, kp_splitmix32
	mv s2, a0
	lw s1, -4(s0)
	lw s3, -16(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_3
	j .L3_4
.L3_3:
	li s1, 0
	sw s1, -20(s0)
.L3_4:
.L3_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L3_0
.L3_2:
	lw s1, -20(s0)
	bnez s1, .L3_6
	j .L3_7
.L3_6:
	li s1, 2654435769
	lw s2, -4(s0)
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_7:
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
.Lfunc_end3:
	.size kp_rng_seed, .Lfunc_end3-kp_rng_seed

	.text
	.align 2
	.globl kp_rng_u32
	.type kp_rng_u32, @function
kp_rng_u32:
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
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 5
	mul s3, s1, s2
	li s1, 7
	mv a0, s3
	mv a1, s1
	jal ra, rotl32
	mv s2, a0
	li s1, 9
	mul s3, s2, s1
	sw s3, -12(s0)
	lw s1, -4(s0)
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 9
	sll s3, s1, s2
	sw s3, -16(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s3, -4(s0)
	li s4, 0
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	lw s1, -4(s0)
	li s2, 3
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s3, -4(s0)
	li s4, 1
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	lw s1, -4(s0)
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s3, -4(s0)
	li s4, 2
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	lw s1, -4(s0)
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s3, -4(s0)
	li s4, 3
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	lw s1, -4(s0)
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s3, -16(s0)
	xor s4, s1, s3
	sw s4, 0(s2)
	lw s1, -4(s0)
	li s2, 3
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 11
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	lw s1, -4(s0)
	li s2, 3
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	lw s1, -12(s0)
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
.Lfunc_end4:
	.size kp_rng_u32, .Lfunc_end4-kp_rng_u32

	.text
	.align 2
	.globl kp_rng_real
	.type kp_rng_real, @function
kp_rng_real:
	addi sp, sp, -96
	sw ra, 92(sp)
	sw s0, 88(sp)
	addi s0, sp, 88
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
	fsd fs1, 56(sp)
	fsd fs2, 64(sp)
	fsd fs3, 72(sp)
	sw a0, -4(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_rng_u32
	mv s2, a0
	fcvt.d.w fs0, s2
	la s1, __flt_0
	fld fs1, 0(s1)
	la s1, __flt_1
	fld fs2, 0(s1)
	fdiv.d fs3, fs1, fs2
	fmul.d fs1, fs0, fs3
	addi sp, sp, -8
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -84(s0)
	lw s2, -80(s0)
	lw s3, -76(s0)
	lw s4, -72(s0)
	lw s5, -68(s0)
	lw s6, -64(s0)
	lw s7, -60(s0)
	lw s8, -56(s0)
	lw s9, -52(s0)
	lw s10, -48(s0)
	lw s11, -44(s0)
	fld fs0, -40(s0)
	fld fs1, -32(s0)
	fld fs2, -24(s0)
	fld fs3, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	lw s1, -84(s0)
	lw s2, -80(s0)
	lw s3, -76(s0)
	lw s4, -72(s0)
	lw s5, -68(s0)
	lw s6, -64(s0)
	lw s7, -60(s0)
	lw s8, -56(s0)
	lw s9, -52(s0)
	lw s10, -48(s0)
	lw s11, -44(s0)
	fld fs0, -40(s0)
	fld fs1, -32(s0)
	fld fs2, -24(s0)
	fld fs3, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end5:
	.size kp_rng_real, .Lfunc_end5-kp_rng_real

	.text
	.align 2
	.globl kp_rng_below
	.type kp_rng_below, @function
kp_rng_below:
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
	sw a1, -8(s0)
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_0
	j .L6_1
.L6_0:
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
.L6_1:
	li s1, 0
	lw s2, -8(s0)
	sub s3, s1, s2
	lw s1, -8(s0)
	remu s2, s3, s1
	sw s2, -12(s0)
.L6_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_rng_u32
	mv s2, a0
	sw s2, -16(s0)
.L6_3:
	lw s1, -16(s0)
	lw s2, -12(s0)
	sltu s3, s1, s2
	bnez s3, .L6_2
	j .L6_4
.L6_4:
	lw s1, -16(s0)
	lw s2, -8(s0)
	remu s3, s1, s2
	mv a0, s3
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
.Lfunc_end6:
	.size kp_rng_below, .Lfunc_end6-kp_rng_below

	.text
	.align 2
	.type rd32le, @function
rd32le:
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
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -4(s0)
	li s3, 1
	add s4, s2, s3
	lbu s2, 0(s4)
	li s3, 8
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -4(s0)
	li s3, 2
	add s4, s1, s3
	lbu s1, 0(s4)
	li s3, 16
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -4(s0)
	li s3, 3
	add s4, s2, s3
	lbu s2, 0(s4)
	li s3, 24
	sll s4, s2, s3
	or s2, s1, s4
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
.Lfunc_end7:
	.size rd32le, .Lfunc_end7-rd32le

	.text
	.align 2
	.type wr32le, @function
wr32le:
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
	lw s1, -8(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -4(s0)
	li s2, 0
	add s4, s1, s2
	sb s3, 0(s4)
	lw s1, -8(s0)
	li s2, 8
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 1
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 16
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 2
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 24
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 3
	add s4, s1, s3
	sb s2, 0(s4)
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
.Lfunc_end8:
	.size wr32le, .Lfunc_end8-wr32le

	.text
	.align 2
	.type chacha20_block, @function
chacha20_block:
	addi sp, sp, -144
	sw ra, 140(sp)
	sw s0, 136(sp)
	addi s0, sp, 136
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
	li s1, 0
	sw s1, -76(s0)
.L9_0:
	lw s1, -76(s0)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L9_1
	j .L9_2
.L9_1:
	lw s1, -4(s0)
	lw s2, -76(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -72
	lw s3, -76(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L9_3:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
	j .L9_0
.L9_2:
	li s1, 0
	sw s1, -76(s0)
.L9_4:
	lw s1, -76(s0)
	li s2, 10
	slt s3, s1, s2
	bnez s3, .L9_5
	j .L9_6
.L9_5:
.L9_7:
	addi s1, s0, -72
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 4
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 0
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 12
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 8
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 12
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 8
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 4
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 4
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 0
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 12
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 8
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 12
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 8
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 4
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L9_8:
	li s1, 0
	bnez s1, .L9_7
	j .L9_9
.L9_9:
.L9_10:
	addi s1, s0, -72
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 5
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 1
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 13
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 9
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 13
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 9
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 5
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 5
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 1
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 13
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 9
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 13
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 9
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 5
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L9_11:
	li s1, 0
	bnez s1, .L9_10
	j .L9_12
.L9_12:
.L9_13:
	addi s1, s0, -72
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 6
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 14
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 2
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 14
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 14
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 10
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 14
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 10
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 6
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 6
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 14
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 2
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 14
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 14
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 10
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 14
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 10
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 6
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L9_14:
	li s1, 0
	bnez s1, .L9_13
	j .L9_15
.L9_15:
.L9_16:
	addi s1, s0, -72
	li s2, 3
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 7
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 15
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 3
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 15
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 15
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 11
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 15
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 7
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 11
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 7
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 7
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 3
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 7
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 15
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 3
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 15
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 15
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 11
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 15
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 7
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 11
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 7
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 7
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L9_17:
	li s1, 0
	bnez s1, .L9_16
	j .L9_18
.L9_18:
.L9_19:
	addi s1, s0, -72
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 5
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 15
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 0
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 15
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 15
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 10
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 15
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 10
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 5
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 5
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 15
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 0
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 15
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 15
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 10
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 15
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 10
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 5
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L9_20:
	li s1, 0
	bnez s1, .L9_19
	j .L9_21
.L9_21:
.L9_22:
	addi s1, s0, -72
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 6
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 1
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 12
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 11
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 12
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 11
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 6
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 6
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 1
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 12
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 11
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 12
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 11
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 6
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L9_23:
	li s1, 0
	bnez s1, .L9_22
	j .L9_24
.L9_24:
.L9_25:
	addi s1, s0, -72
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 7
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 2
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 13
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 8
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 13
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 7
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 8
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 7
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 7
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 7
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 2
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 13
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 8
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 13
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 7
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 8
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 7
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 7
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L9_26:
	li s1, 0
	bnez s1, .L9_25
	j .L9_27
.L9_27:
.L9_28:
	addi s1, s0, -72
	li s2, 3
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 4
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 14
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 3
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 14
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 14
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 9
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 14
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 9
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 4
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 3
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 4
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 14
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 3
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 14
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 14
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -72
	li s2, 9
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 14
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s3, s0, -72
	li s4, 9
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	xor s4, s1, s3
	sw s4, 0(s2)
	addi s1, s0, -72
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rotl32
	mv s3, a0
	addi s1, s0, -72
	li s2, 4
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L9_29:
	li s1, 0
	bnez s1, .L9_28
	j .L9_30
.L9_30:
.L9_31:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
	j .L9_4
.L9_6:
	li s1, 0
	sw s1, -76(s0)
.L9_32:
	lw s1, -76(s0)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L9_33
	j .L9_34
.L9_33:
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, -76(s0)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	addi s2, s0, -72
	lw s3, -76(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -4(s0)
	lw s4, -76(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, wr32le
	mv s2, a0
.L9_35:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
	j .L9_32
.L9_34:
	lw s1, -4(s0)
	li s2, 12
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s3, 1
	add s4, s1, s3
	sw s4, 0(s2)
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L9_36
	j .L9_37
.L9_36:
	lw s1, -4(s0)
	li s2, 13
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s3, 1
	add s4, s1, s3
	sw s4, 0(s2)
.L9_37:
	li s1, 64
	lw s2, -4(s0)
	li s3, 128
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	mv a0, s1
	lw s1, -124(s0)
	lw s2, -120(s0)
	lw s3, -116(s0)
	lw s4, -112(s0)
	lw s5, -108(s0)
	lw s6, -104(s0)
	lw s7, -100(s0)
	lw s8, -96(s0)
	lw s9, -92(s0)
	lw s10, -88(s0)
	lw s11, -84(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end9:
	.size chacha20_block, .Lfunc_end9-chacha20_block

	.text
	.align 2
	.globl kp_csprng_seed
	.type kp_csprng_seed, @function
kp_csprng_seed:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	li s1, 1634760805
	lw s2, -4(s0)
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 857760878
	lw s2, -4(s0)
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 2036477234
	lw s2, -4(s0)
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1797285236
	lw s2, -4(s0)
	li s3, 3
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	sw s1, -20(s0)
.L10_0:
	lw s1, -20(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L10_1
	j .L10_2
.L10_1:
	lw s1, -8(s0)
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, rd32le
	mv s1, a0
	lw s2, -4(s0)
	li s3, 4
	lw s4, -20(s0)
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	sw s1, 0(s3)
.L10_3:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L10_0
.L10_2:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	sw s1, -20(s0)
.L10_4:
	lw s1, -20(s0)
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L10_5
	j .L10_6
.L10_5:
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, rd32le
	mv s1, a0
	lw s2, -4(s0)
	li s3, 13
	lw s4, -20(s0)
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	sw s1, 0(s3)
.L10_7:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L10_4
.L10_6:
	li s1, 0
	lw s2, -4(s0)
	li s3, 128
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end10:
	.size kp_csprng_seed, .Lfunc_end10-kp_csprng_seed

	.text
	.align 2
	.globl kp_csprng_bytes
	.type kp_csprng_bytes, @function
kp_csprng_bytes:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	li s1, 0
	sw s1, -20(s0)
.L11_0:
	lw s1, -20(s0)
	lw s2, -12(s0)
	sltu s3, s1, s2
	bnez s3, .L11_1
	j .L11_2
.L11_1:
	lw s1, -4(s0)
	li s2, 128
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_3
	j .L11_4
.L11_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, chacha20_block
	mv s2, a0
.L11_4:
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	li s1, 64
	lw s2, -4(s0)
	li s4, 128
	add s5, s2, s4
	lw s2, 0(s5)
	sub s4, s1, s2
	add s1, s3, s4
	lbu s2, 0(s1)
	lw s1, -8(s0)
	lw s3, -20(s0)
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -4(s0)
	li s2, 128
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, -1
	add s4, s1, s2
	sw s4, 0(s3)
.L11_5:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L11_0
.L11_2:
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
.Lfunc_end11:
	.size kp_csprng_bytes, .Lfunc_end11-kp_csprng_bytes

	.data
	.align 3
__flt_1:
	.word 0x00000000
	.word 0x41f00000
	.align 3
__flt_0:
	.word 0x00000000
	.word 0x3ff00000
