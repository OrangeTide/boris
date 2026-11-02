# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type hash_name, @function
hash_name:
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
	li s1, 0
	sw s1, -12(s0)
.L1_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L1_1
	j .L1_2
.L1_1:
	lw s1, -12(s0)
	li s2, 31
	mul s3, s1, s2
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -4(s0)
	lb s1, 0(s2)
	li s2, 255
	and s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	j .L1_0
.L1_2:
	lw s1, -12(s0)
	li s2, 256
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
.Lfunc_end1:
	.size hash_name, .Lfunc_end1-hash_name

	.text
	.align 2
	.globl macro_define
	.type macro_define, @function
macro_define:
	addi sp, sp, -112
	sw ra, 108(sp)
	sw s0, 104(sp)
	addi s0, sp, 104
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
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	sw a6, -28(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, hash_name
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -4(s0)
	lw s2, -36(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -40(s0)
.L2_0:
	lw s1, -40(s0)
	bnez s1, .L2_1
	j .L2_2
.L2_1:
	lw s1, -40(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L2_3
	j .L2_4
.L2_3:
	lw s1, -40(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	li s1, 0
	sw s1, -44(s0)
.L2_5:
	lw s1, -44(s0)
	lw s2, -40(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L2_6
	j .L2_7
.L2_6:
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L2_8:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L2_5
.L2_7:
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -12(s0)
	lw s2, -40(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -40(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -40(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	lw s2, -40(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -28(s0)
	lw s2, -40(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -40(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -92(s0)
	lw s2, -88(s0)
	lw s3, -84(s0)
	lw s4, -80(s0)
	lw s5, -76(s0)
	lw s6, -72(s0)
	lw s7, -68(s0)
	lw s8, -64(s0)
	lw s9, -60(s0)
	lw s10, -56(s0)
	lw s11, -52(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L2_4:
	lw s1, -40(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	j .L2_0
.L2_2:
	li s1, 36
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -40(s0)
	sw s2, 0(s1)
	lw s1, -16(s0)
	lw s2, -40(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -40(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -28(s0)
	lw s2, -40(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	lw s2, -40(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -40(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -40(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -40(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -36(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -40(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -40(s0)
	lw s2, -4(s0)
	lw s3, -36(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	mv a0, s1
	lw s1, -92(s0)
	lw s2, -88(s0)
	lw s3, -84(s0)
	lw s4, -80(s0)
	lw s5, -76(s0)
	lw s6, -72(s0)
	lw s7, -68(s0)
	lw s8, -64(s0)
	lw s9, -60(s0)
	lw s10, -56(s0)
	lw s11, -52(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end2:
	.size macro_define, .Lfunc_end2-macro_define

	.text
	.align 2
	.globl macro_undef
	.type macro_undef, @function
macro_undef:
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
	mv a0, s1
	jal ra, hash_name
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -16(s0)
.L3_0:
	lw s1, -16(s0)
	lw s2, 0(s1)
	bnez s2, .L3_1
	j .L3_2
.L3_1:
	lw s1, -16(s0)
	lw s2, 0(s1)
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_3
	j .L3_4
.L3_3:
	lw s1, -20(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -20(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	lw s1, -20(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	li s1, 0
	sw s1, -24(s0)
.L3_5:
	lw s1, -24(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L3_6
	j .L3_7
.L3_6:
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L3_8:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L3_5
.L3_7:
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
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
.L3_4:
	lw s1, -20(s0)
	li s2, 32
	add s3, s1, s2
	sw s3, -16(s0)
	j .L3_0
.L3_2:
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
	.size macro_undef, .Lfunc_end3-macro_undef

	.text
	.align 2
	.globl macro_lookup
	.type macro_lookup, @function
macro_lookup:
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
	mv a0, s1
	jal ra, hash_name
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -16(s0)
.L4_0:
	lw s1, -16(s0)
	bnez s1, .L4_1
	j .L4_2
.L4_1:
	lw s1, -16(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_3
	j .L4_4
.L4_3:
	lw s1, -16(s0)
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
.L4_4:
	lw s1, -16(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L4_0
.L4_2:
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
.Lfunc_end4:
	.size macro_lookup, .Lfunc_end4-macro_lookup

	.text
	.align 2
	.type skip_space, @function
skip_space:
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
.L5_0:
	lw s1, -4(s0)
	bnez s1, .L5_1
	j .L5_2
.L5_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_3
	j .L5_2
.L5_3:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -4(s0)
	j .L5_0
.L5_2:
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
.Lfunc_end5:
	.size skip_space, .Lfunc_end5-skip_space

	.text
	.align 2
	.type stringify_tokens, @function
stringify_tokens:
	li t6, -4192
	add sp, sp, t6
	li t6, 4188
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 4184
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 4184
	add s0, sp, t6
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
	li t6, -4108
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 34
	li t6, -4104
	add s2, s0, t6
	li t6, -4108
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4108
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -4(s0)
	li t6, -4112
	add t6, s0, t6
	sw s1, 0(t6)
.L6_0:
	li t6, -4112
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L6_1
	j .L6_2
.L6_1:
	li t6, -4112
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_3
	j .L6_4
.L6_3:
	li t6, -4108
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4096
	li s3, 2
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L6_5
	j .L6_6
.L6_5:
	li s1, 32
	li t6, -4104
	add s2, s0, t6
	li t6, -4108
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4108
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s2, s4
	sb s1, 0(s3)
.L6_6:
	j .L6_7
.L6_4:
	li s1, 0
	li t6, -4116
	add t6, s0, t6
	sw s1, 0(t6)
.L6_8:
	li t6, -4116
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4112
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L6_9
	j .L6_10
.L6_9:
	li t6, -4108
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4096
	li s3, 3
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L6_11
	j .L6_10
.L6_11:
	li t6, -4112
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -4116
	add t6, s0, t6
	lw s2, 0(t6)
	add s3, s1, s2
	lb s1, 0(s3)
	li t6, -4120
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -4120
	add s1, s0, t6
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_12
	j .L6_13
.L6_13:
	li t6, -4120
	add s1, s0, t6
	lb s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_12
	j .L6_14
.L6_12:
	li s1, 92
	li t6, -4104
	add s2, s0, t6
	li t6, -4108
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4108
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s2, s4
	sb s1, 0(s3)
.L6_14:
	li t6, -4120
	add s1, s0, t6
	lb s2, 0(s1)
	li t6, -4104
	add s1, s0, t6
	li t6, -4108
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4108
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s1, s4
	sb s2, 0(s3)
.L6_15:
	li t6, -4116
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -4116
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_8
.L6_10:
.L6_7:
	li t6, -4112
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -4112
	add t6, s0, t6
	sw s1, 0(t6)
	j .L6_0
.L6_2:
	li s1, 34
	li t6, -4104
	add s2, s0, t6
	li t6, -4108
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4108
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 0
	li t6, -4104
	add s2, s0, t6
	li t6, -4108
	add t6, s0, t6
	lw s3, 0(t6)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 20
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	li t6, -4124
	add t6, s0, t6
	sw s2, 0(t6)
	li s1, 3
	li t6, -4124
	add t6, s0, t6
	lw s2, 0(t6)
	sw s1, 0(s2)
	li t6, -4104
	add s1, s0, t6
	li t6, -4108
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, xstrndup
	mv s3, a0
	li t6, -4124
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	li t6, -4108
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4124
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	li t6, -4124
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	li t6, -4124
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -4124
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -4172
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4168
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4164
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4160
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4156
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4136
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4132
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end6:
	.size stringify_tokens, .Lfunc_end6-stringify_tokens

	.text
	.align 2
	.type paste_tokens, @function
paste_tokens:
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
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	mv a0, s3
	jal ra, xmalloc
	mv s1, a0
	sw s1, -16(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -8(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -16(s0)
	lw s3, -12(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 20
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	li s1, 8
	lw s2, -20(s0)
	sw s1, 0(s2)
	j .L7_2
.L7_1:
	lw s1, -16(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	mv a0, s1
	jal ra, isalpha
	mv s2, a0
	bnez s2, .L7_3
	j .L7_4
.L7_4:
	lw s1, -16(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 95
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_3
	j .L7_5
.L7_3:
	li s1, 1
	lw s2, -20(s0)
	sw s1, 0(s2)
	j .L7_6
.L7_5:
	lw s1, -16(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	mv a0, s1
	jal ra, isdigit
	mv s2, a0
	bnez s2, .L7_7
	j .L7_8
.L7_7:
	li s1, 2
	lw s2, -20(s0)
	sw s1, 0(s2)
	j .L7_9
.L7_8:
	li s1, 5
	lw s2, -20(s0)
	sw s1, 0(s2)
.L7_9:
.L7_6:
.L7_2:
	lw s1, -20(s0)
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
.Lfunc_end7:
	.size paste_tokens, .Lfunc_end7-paste_tokens

	.text
	.align 2
	.type find_param, @function
find_param:
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
.L8_0:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L8_1
	j .L8_2
.L8_1:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	lw s1, -12(s0)
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L8_3
	j .L8_4
.L8_3:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L8_5
	j .L8_4
.L8_5:
	lw s1, -20(s0)
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
.L8_4:
.L8_6:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L8_0
.L8_2:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L8_7
	j .L8_8
.L8_7:
	lw s1, -12(s0)
	li s2, 11
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_9
	j .L8_8
.L8_9:
	lw s1, -8(s0)
	la s2, __str_0
	li s3, 11
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L8_10
	j .L8_8
.L8_10:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
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
.L8_8:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.Lfunc_end8:
	.size find_param, .Lfunc_end8-find_param

	.text
	.align 2
	.type strip_leading_space, @function
strip_leading_space:
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
.L9_0:
	lw s1, -4(s0)
	bnez s1, .L9_1
	j .L9_2
.L9_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_3
	j .L9_2
.L9_3:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -12(s0)
	sw s1, -4(s0)
	j .L9_0
.L9_2:
	lw s1, -4(s0)
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
.Lfunc_end9:
	.size strip_leading_space, .Lfunc_end9-strip_leading_space

	.text
	.align 2
	.type collect_args, @function
collect_args:
	addi sp, sp, -624
	sw ra, 620(sp)
	sw s0, 616(sp)
	addi s0, sp, 616
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
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_space
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -8(s0)
	sw s1, -28(s0)
	j .L10_2
.L10_1:
	li s1, 1
	sw s1, -28(s0)
.L10_2:
	lw s1, -28(s0)
	sw s1, -24(s0)
	lw s1, -12(s0)
	bnez s1, .L10_3
	j .L10_4
.L10_3:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
.L10_4:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	li s1, 4
	mv a0, s3
	mv a1, s1
	jal ra, xcalloc
	mv s2, a0
	sw s2, -32(s0)
	addi s1, s0, -288
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 108
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 112
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 116
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 120
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 124
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 128
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 132
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 136
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 140
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 144
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 148
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 152
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 156
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 160
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 164
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 168
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 172
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 176
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 180
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 184
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 188
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 192
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 196
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 200
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 204
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 208
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 212
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 216
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 220
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 224
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 228
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 232
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 236
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 240
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 244
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 248
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 252
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	addi s1, s0, -544
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 108
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 112
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 116
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 120
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 124
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 128
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 132
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 136
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 140
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 144
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 148
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 152
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 156
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 160
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 164
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 168
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 172
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 176
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 180
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 184
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 188
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 192
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 196
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 200
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 204
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 208
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 212
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 216
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 220
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 224
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 228
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 232
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 236
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 240
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 244
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 248
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 252
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	li s1, 0
	sw s1, -548(s0)
	li s1, 0
	sw s1, -552(s0)
.L10_5:
	lw s1, -20(s0)
	bnez s1, .L10_6
	j .L10_7
.L10_6:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L10_8
	j .L10_9
.L10_8:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_10
	j .L10_9
.L10_10:
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_11
	j .L10_9
.L10_11:
	addi s1, s0, -552
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -552(s0)
	j .L10_12
.L10_9:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L10_13
	j .L10_14
.L10_13:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_15
	j .L10_14
.L10_15:
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 41
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_16
	j .L10_14
.L10_16:
	lw s1, -552(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_17
	j .L10_18
.L10_17:
	j .L10_7
.L10_18:
	addi s1, s0, -552
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -552(s0)
	j .L10_19
.L10_14:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L10_20
	j .L10_21
.L10_20:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_22
	j .L10_21
.L10_22:
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 44
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_23
	j .L10_21
.L10_23:
	lw s1, -552(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_24
	j .L10_21
.L10_24:
	lw s1, -12(s0)
	bnez s1, .L10_25
	j .L10_26
.L10_25:
	lw s1, -548(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L10_26
	j .L10_27
.L10_26:
	addi s1, s0, -548
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -548(s0)
	lw s1, -548(s0)
	li s2, 64
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_28
	j .L10_29
.L10_28:
	j .L10_7
.L10_29:
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L10_5
.L10_27:
.L10_21:
.L10_19:
.L10_12:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	sw s2, -556(s0)
	addi s1, s0, -288
	lw s2, -548(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L10_30
	j .L10_31
.L10_31:
	lw s1, -556(s0)
	addi s2, s0, -288
	lw s3, -548(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -556(s0)
	addi s2, s0, -544
	lw s3, -548(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L10_32
.L10_30:
	lw s1, -556(s0)
	addi s2, s0, -544
	lw s3, -548(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -556(s0)
	addi s2, s0, -544
	lw s3, -548(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L10_32:
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L10_5
.L10_7:
	addi s1, s0, -548
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -548(s0)
	li s1, 0
	sw s1, -560(s0)
.L10_33:
	lw s1, -560(s0)
	lw s2, -548(s0)
	slt s3, s1, s2
	bnez s3, .L10_34
	j .L10_35
.L10_34:
	lw s1, -560(s0)
	lw s2, -24(s0)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L10_36
	j .L10_35
.L10_36:
	addi s1, s0, -288
	lw s2, -560(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, strip_leading_space
	mv s2, a0
	lw s1, -32(s0)
	lw s3, -560(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L10_37:
	addi s1, s0, -560
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -560(s0)
	j .L10_33
.L10_35:
	lw s1, -548(s0)
	lw s2, -24(s0)
	li s3, 1
	add s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L10_38
	j .L10_39
.L10_38:
	lw s1, -548(s0)
	sw s1, -564(s0)
	j .L10_40
.L10_39:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -564(s0)
.L10_40:
	lw s1, -564(s0)
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -32(s0)
	mv a0, s1
	lw s1, -612(s0)
	lw s2, -608(s0)
	lw s3, -604(s0)
	lw s4, -600(s0)
	lw s5, -596(s0)
	lw s6, -592(s0)
	lw s7, -588(s0)
	lw s8, -584(s0)
	lw s9, -580(s0)
	lw s10, -576(s0)
	lw s11, -572(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end10:
	.size collect_args, .Lfunc_end10-collect_args

	.text
	.align 2
	.type find_closing_paren, @function
find_closing_paren:
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
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	li s1, 0
	sw s1, -16(s0)
.L11_0:
	lw s1, -12(s0)
	bnez s1, .L11_1
	j .L11_2
.L11_1:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_3
	j .L11_4
.L11_3:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_5
	j .L11_4
.L11_5:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_6
	j .L11_4
.L11_6:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L11_7
.L11_4:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_8
	j .L11_9
.L11_8:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_10
	j .L11_9
.L11_10:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 41
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_11
	j .L11_9
.L11_11:
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_12
	j .L11_13
.L11_12:
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
.L11_13:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -16(s0)
.L11_9:
.L11_7:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L11_0
.L11_2:
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
.Lfunc_end11:
	.size find_closing_paren, .Lfunc_end11-find_closing_paren

	.text
	.align 2
	.type substitute, @function
substitute:
	addi sp, sp, -160
	sw ra, 156(sp)
	sw s0, 152(sp)
	addi s0, sp, 152
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
	addi s1, s0, -36
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	addi s1, s0, -36
	sw s1, -40(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
.L12_0:
	lw s1, -44(s0)
	bnez s1, .L12_1
	j .L12_2
.L12_1:
	lw s1, -44(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_3
	j .L12_4
.L12_3:
	lw s1, -44(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_5
	j .L12_4
.L12_5:
	lw s1, -44(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_6
	j .L12_4
.L12_6:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_7
	j .L12_4
.L12_7:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_8
	j .L12_4
.L12_8:
	lw s1, -8(s0)
	lw s2, -44(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -44(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, find_param
	mv s4, a0
	sw s4, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_9
	j .L12_10
.L12_9:
	lw s1, -48(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L12_11
	j .L12_10
.L12_11:
	lw s1, -12(s0)
	lw s2, -48(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, stringify_tokens
	mv s2, a0
	lw s1, -40(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
	j .L12_0
.L12_10:
.L12_4:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_12
	j .L12_13
.L12_12:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_14
	j .L12_13
.L12_14:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_15
	j .L12_13
.L12_15:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_16
	j .L12_13
.L12_16:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_17
	j .L12_13
.L12_17:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_18
	j .L12_13
.L12_18:
	lw s1, -44(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_19
	j .L12_20
.L12_19:
	lw s1, -8(s0)
	lw s2, -44(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -44(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, find_param
	mv s4, a0
	sw s4, -60(s0)
	j .L12_21
.L12_20:
	li s1, 1
	neg s2, s1
	sw s2, -60(s0)
.L12_21:
	lw s1, -60(s0)
	sw s1, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_22
	j .L12_23
.L12_22:
	lw s1, -56(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L12_24
	j .L12_23
.L12_24:
	lw s1, -12(s0)
	lw s2, -56(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L12_25
	j .L12_23
.L12_25:
	lw s1, -12(s0)
	lw s2, -56(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, pp_list_dup
	mv s2, a0
	sw s2, -64(s0)
	lw s1, -64(s0)
	sw s1, -68(s0)
.L12_26:
	lw s1, -68(s0)
	bnez s1, .L12_27
	j .L12_28
.L12_27:
	lw s1, -68(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_29
	j .L12_28
.L12_29:
	lw s1, -68(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -68(s0)
	j .L12_26
.L12_28:
	lw s1, -68(s0)
	sw s1, -52(s0)
	lw s1, -64(s0)
	lw s2, -68(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_30
	j .L12_31
.L12_30:
	lw s1, -64(s0)
	lw s2, -40(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L12_32:
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -68(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_33
	j .L12_34
.L12_33:
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	j .L12_32
.L12_34:
.L12_31:
	j .L12_35
.L12_23:
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_36
	j .L12_37
.L12_36:
	li s1, 0
	sw s1, -52(s0)
	j .L12_38
.L12_37:
	lw s1, -44(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	sw s2, -52(s0)
.L12_38:
.L12_35:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -72(s0)
	lw s1, -72(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_39
	j .L12_40
.L12_39:
	lw s1, -8(s0)
	lw s2, -72(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -72(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, find_param
	mv s4, a0
	sw s4, -80(s0)
	j .L12_41
.L12_40:
	li s1, 1
	neg s2, s1
	sw s2, -80(s0)
.L12_41:
	lw s1, -80(s0)
	sw s1, -76(s0)
	li s1, 0
	sw s1, -88(s0)
	lw s1, -76(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_42
	j .L12_43
.L12_42:
	lw s1, -76(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L12_44
	j .L12_43
.L12_44:
	lw s1, -12(s0)
	lw s2, -76(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L12_45
	j .L12_43
.L12_45:
	lw s1, -12(s0)
	lw s2, -76(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, pp_list_dup
	mv s2, a0
	sw s2, -92(s0)
	lw s1, -92(s0)
	sw s1, -84(s0)
	lw s1, -92(s0)
	bnez s1, .L12_46
	j .L12_47
.L12_46:
	lw s1, -92(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -88(s0)
	li s1, 0
	lw s2, -92(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L12_47:
	j .L12_48
.L12_43:
	lw s1, -76(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_49
	j .L12_50
.L12_49:
	li s1, 0
	sw s1, -84(s0)
	j .L12_51
.L12_50:
	lw s1, -72(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	sw s2, -84(s0)
.L12_51:
.L12_48:
	lw s1, -52(s0)
	bnez s1, .L12_52
	j .L12_53
.L12_52:
	lw s1, -84(s0)
	bnez s1, .L12_54
	j .L12_53
.L12_54:
	lw s1, -52(s0)
	lw s2, -84(s0)
	mv a0, s1
	mv a1, s2
	jal ra, paste_tokens
	mv s3, a0
	lw s1, -40(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	lw s1, -52(s0)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	lw s1, -84(s0)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	j .L12_55
.L12_53:
	lw s1, -52(s0)
	bnez s1, .L12_56
	j .L12_57
.L12_56:
	lw s1, -52(s0)
	lw s2, -40(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	j .L12_58
.L12_57:
	lw s1, -84(s0)
	bnez s1, .L12_59
	j .L12_60
.L12_59:
	lw s1, -84(s0)
	lw s2, -40(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
.L12_60:
.L12_58:
.L12_55:
	lw s1, -88(s0)
	bnez s1, .L12_61
	j .L12_62
.L12_61:
	lw s1, -88(s0)
	lw s2, -40(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L12_63:
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_64
	j .L12_65
.L12_64:
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	j .L12_63
.L12_65:
.L12_62:
	lw s1, -72(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
	j .L12_0
.L12_13:
	lw s1, -44(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_66
	j .L12_67
.L12_66:
	lw s1, -8(s0)
	lw s2, -44(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -44(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, find_param
	mv s4, a0
	sw s4, -96(s0)
	lw s1, -96(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_68
	j .L12_69
.L12_68:
	lw s1, -96(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L12_70
	j .L12_69
.L12_70:
	lw s1, -4(s0)
	lw s2, -12(s0)
	lw s3, -96(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s2
	jal ra, pp_list_dup
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, macro_expand
	mv s2, a0
	sw s2, -100(s0)
	lw s1, -100(s0)
	bnez s1, .L12_71
	j .L12_72
.L12_71:
	lw s1, -100(s0)
	lw s2, -40(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L12_73:
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_74
	j .L12_75
.L12_74:
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	j .L12_73
.L12_75:
.L12_72:
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
	j .L12_0
.L12_69:
.L12_67:
	lw s1, -44(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -40(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -40(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	lw s1, -44(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
	j .L12_0
.L12_2:
	addi s1, s0, -36
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end12:
	.size substitute, .Lfunc_end12-substitute

	.text
	.align 2
	.globl macro_expand
	.type macro_expand, @function
macro_expand:
	addi sp, sp, -272
	sw ra, 268(sp)
	sw s0, 264(sp)
	addi s0, sp, 264
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
	addi s1, s0, -28
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	addi s1, s0, -28
	sw s1, -32(s0)
	lw s1, -8(s0)
	sw s1, -36(s0)
.L13_0:
	lw s1, -36(s0)
	bnez s1, .L13_1
	j .L13_2
.L13_1:
	lw s1, -36(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L13_3
	j .L13_4
.L13_4:
	lw s1, -36(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_3
	j .L13_5
.L13_3:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -40(s0)
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	j .L13_0
.L13_5:
	lw s1, -4(s0)
	lw s2, -36(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, macro_lookup
	mv s3, a0
	sw s3, -44(s0)
	lw s1, -44(s0)
	bnez s1, .L13_6
	j .L13_7
.L13_6:
	lw s1, -44(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_7
	j .L13_8
.L13_7:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	j .L13_0
.L13_8:
	lw s1, -44(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_9
	j .L13_10
.L13_9:
	lw s1, -44(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_11
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_12
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_13
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_14
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_15
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_16
	j .L13_17
.L13_11:
	addi s1, s0, -112
	li s2, 64
	la s3, __str_1
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	bnez s4, .L13_18
	j .L13_19
.L13_18:
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	sw s4, -116(s0)
	j .L13_20
.L13_19:
	li s4, 0
	sw s4, -116(s0)
.L13_20:
	lw s4, -116(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	addi s1, s0, -112
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	addi s1, s0, -112
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 2
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L13_17
.L13_12:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_21
	j .L13_22
.L13_21:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	sw s2, -124(s0)
	j .L13_23
.L13_22:
	la s1, __str_2
	sw s1, -124(s0)
.L13_23:
	lw s1, -124(s0)
	sw s1, -120(s0)
	lw s1, -120(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	li s1, 3
	add s3, s2, s1
	sw s3, -128(s0)
	lw s1, -128(s0)
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -132(s0)
	lw s1, -132(s0)
	lw s2, -128(s0)
	la s3, __str_3
	lw s4, -120(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -132(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 3
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L13_17
.L13_13:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 1044
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 1044
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 3
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L13_17
.L13_14:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 1048
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 1048
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 3
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L13_17
.L13_15:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	la s1, __str_4
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 1
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 2
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L13_17
.L13_16:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	la s1, __str_5
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 7
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 2
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L13_17
.L13_17:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	j .L13_0
.L13_10:
	lw s1, -44(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_24
	j .L13_25
.L13_25:
	lw s1, -44(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, pp_list_dup
	mv s2, a0
	sw s2, -136(s0)
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -140(s0)
	li s1, 1
	lw s2, -44(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -136(s0)
	mv a0, s1
	mv a1, s2
	jal ra, macro_expand
	mv s3, a0
	sw s3, -144(s0)
	li s1, 0
	lw s2, -44(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	sw s1, -148(s0)
	lw s1, -144(s0)
	sw s1, -152(s0)
.L13_26:
	lw s1, -152(s0)
	bnez s1, .L13_27
	j .L13_28
.L13_27:
	lw s1, -152(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_29
	j .L13_30
.L13_29:
	lw s1, -152(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -148(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_31
	j .L13_30
.L13_31:
	lw s1, -152(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	lw s3, 0(s2)
	lw s2, -148(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L13_32
	j .L13_30
.L13_32:
	li s1, 1
	lw s2, -152(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L13_30:
.L13_33:
	lw s1, -152(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -152(s0)
	j .L13_26
.L13_28:
	lw s1, -144(s0)
	bnez s1, .L13_34
	j .L13_35
.L13_34:
	lw s1, -144(s0)
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L13_36:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_37
	j .L13_38
.L13_37:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L13_36
.L13_38:
.L13_35:
	lw s1, -140(s0)
	sw s1, -36(s0)
	j .L13_0
.L13_24:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -156(s0)
	lw s1, -156(s0)
	mv a0, s1
	jal ra, skip_space
	mv s2, a0
	sw s2, -160(s0)
	lw s1, -160(s0)
	bnez s1, .L13_39
	j .L13_40
.L13_39:
	lw s1, -160(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L13_40
	j .L13_41
.L13_41:
	lw s1, -160(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_40
	j .L13_42
.L13_42:
	lw s1, -160(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 40
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_40
	j .L13_43
.L13_40:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	j .L13_0
.L13_43:
	lw s1, -160(s0)
	mv a0, s1
	jal ra, find_closing_paren
	mv s2, a0
	sw s2, -164(s0)
	lw s1, -164(s0)
	bnez s1, .L13_44
	j .L13_45
.L13_45:
	li s1, 1
	lw s2, -4(s0)
	li s3, 17444
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_token_dup
	mv s2, a0
	lw s1, -32(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	j .L13_0
.L13_44:
	li s1, 0
	sw s1, -168(s0)
	lw s1, -160(s0)
	lw s2, -44(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -44(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	addi s4, s0, -168
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, collect_args
	mv s5, a0
	sw s5, -172(s0)
	lw s1, -4(s0)
	lw s2, -44(s0)
	lw s3, -172(s0)
	lw s4, -168(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, substitute
	mv s5, a0
	sw s5, -176(s0)
	li s1, 1
	lw s2, -44(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -176(s0)
	mv a0, s1
	mv a1, s2
	jal ra, macro_expand
	mv s3, a0
	sw s3, -180(s0)
	li s1, 0
	lw s2, -44(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	sw s1, -184(s0)
	lw s1, -180(s0)
	sw s1, -188(s0)
.L13_46:
	lw s1, -188(s0)
	bnez s1, .L13_47
	j .L13_48
.L13_47:
	lw s1, -188(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_49
	j .L13_50
.L13_49:
	lw s1, -188(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -184(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_51
	j .L13_50
.L13_51:
	lw s1, -188(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	lw s3, 0(s2)
	lw s2, -184(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L13_52
	j .L13_50
.L13_52:
	li s1, 1
	lw s2, -188(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L13_50:
.L13_53:
	lw s1, -188(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -188(s0)
	j .L13_46
.L13_48:
	li s1, 0
	sw s1, -192(s0)
.L13_54:
	lw s1, -192(s0)
	lw s2, -168(s0)
	slt s3, s1, s2
	bnez s3, .L13_55
	j .L13_56
.L13_55:
	lw s1, -172(s0)
	lw s2, -192(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
.L13_57:
	addi s1, s0, -192
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -192(s0)
	j .L13_54
.L13_56:
	lw s1, -172(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -180(s0)
	bnez s1, .L13_58
	j .L13_59
.L13_58:
	lw s1, -180(s0)
	sw s1, -196(s0)
.L13_60:
	lw s1, -196(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_61
	j .L13_62
.L13_61:
	lw s1, -196(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -196(s0)
	j .L13_60
.L13_62:
	li s1, 0
	sw s1, -200(s0)
	lw s1, -196(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_63
	j .L13_64
.L13_63:
	lw s1, -196(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_64
	j .L13_65
.L13_65:
	lw s1, -4(s0)
	lw s2, -196(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, macro_lookup
	mv s3, a0
	sw s3, -200(s0)
.L13_64:
	lw s1, -200(s0)
	bnez s1, .L13_66
	j .L13_67
.L13_66:
	lw s1, -200(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_68
	j .L13_67
.L13_68:
	lw s1, -200(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_67
	j .L13_69
.L13_69:
	lw s1, -164(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, skip_space
	mv s2, a0
	sw s2, -204(s0)
	lw s1, -204(s0)
	bnez s1, .L13_70
	j .L13_71
.L13_70:
	lw s1, -204(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_72
	j .L13_71
.L13_72:
	lw s1, -204(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_73
	j .L13_71
.L13_73:
	lw s1, -204(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_74
	j .L13_71
.L13_74:
	lw s1, -164(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -196(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -164(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -180(s0)
	mv a0, s1
	mv a1, s2
	jal ra, macro_expand
	mv s3, a0
	sw s3, -208(s0)
	lw s1, -208(s0)
	bnez s1, .L13_75
	j .L13_76
.L13_75:
	lw s1, -208(s0)
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L13_77:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_78
	j .L13_79
.L13_78:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L13_77
.L13_79:
.L13_76:
	li s1, 0
	sw s1, -36(s0)
	j .L13_0
.L13_71:
.L13_67:
	lw s1, -180(s0)
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L13_80:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_81
	j .L13_82
.L13_81:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L13_80
.L13_82:
.L13_59:
	lw s1, -164(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	j .L13_0
.L13_2:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	addi s1, s0, -28
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -252(s0)
	lw s2, -248(s0)
	lw s3, -244(s0)
	lw s4, -240(s0)
	lw s5, -236(s0)
	lw s6, -232(s0)
	lw s7, -228(s0)
	lw s8, -224(s0)
	lw s9, -220(s0)
	lw s10, -216(s0)
	lw s11, -212(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end13:
	.size macro_expand, .Lfunc_end13-macro_expand

	.data
	.align 2
__str_5:
	.ascii "199901L\000"
	.align 2
__str_4:
	.ascii "1\000"
	.align 2
__str_3:
	.ascii "\"%s\"\000"
	.align 2
__str_2:
	.ascii "\000"
	.align 2
__str_1:
	.ascii "%d\000"
	.align 2
__str_0:
	.ascii "__VA_ARGS__\000"
