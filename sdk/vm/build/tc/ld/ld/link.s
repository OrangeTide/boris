# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type put16, @function
put16:
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
	addi s1, s0, -8
	lhu s2, 0(s1)
	li s1, 8
	sra s3, s2, s1
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 0
	add s4, s1, s3
	sb s2, 0(s4)
	addi s1, s0, -8
	lhu s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	li s2, 1
	add s4, s1, s2
	sb s3, 0(s4)
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
.Lfunc_end1:
	.size put16, .Lfunc_end1-put16

	.text
	.align 2
	.type put32, @function
put32:
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
	li s2, 24
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 0
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 16
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 1
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 8
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 2
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -4(s0)
	li s2, 3
	add s4, s1, s2
	sb s3, 0(s4)
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
	.size put32, .Lfunc_end2-put32

	.text
	.align 2
	.type sym_find, @function
sym_find:
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
	li s1, 0
	sw s1, -12(s0)
.L3_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_3
	j .L3_4
.L3_3:
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
.L3_4:
.L3_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L3_0
.L3_2:
	li s1, 1
	neg s2, s1
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
.Lfunc_end3:
	.size sym_find, .Lfunc_end3-sym_find

	.text
	.align 2
	.type sym_add, @function
sym_add:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	sw a6, -28(s0)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_2
	j .L4_3
.L4_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -36(s0)
	j .L4_4
.L4_3:
	li s1, 64
	sw s1, -36(s0)
.L4_4:
	lw s1, -36(s0)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 36
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, realloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_5
	j .L4_6
.L4_6:
	la s1, __str_0
	mv a0, s1
	jal ra, die
	mv s2, a0
.L4_5:
.L4_1:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	sw s1, -40(s0)
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -24(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 16
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -28(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 20
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 24
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 28
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -40(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 32
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -40(s0)
	mv a0, s1
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end4:
	.size sym_add, .Lfunc_end4-sym_add

	.text
	.align 2
	.type collect_symbols, @function
collect_symbols:
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
	li s1, 0
	sw s1, -12(s0)
.L5_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L5_1
	j .L5_2
.L5_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 6204
	add s3, s1, s2
	lw s1, -16(s0)
	li s2, 24
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 4
	mul s4, s1, s2
	mv a0, s3
	mv a1, s4
	jal ra, arena_zalloc
	mv s1, a0
	lw s2, -16(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -20(s0)
.L5_3:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L5_4
	j .L5_5
.L5_4:
	lw s1, -16(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -24(s0)
	li s1, 1
	neg s2, s1
	lw s1, -16(s0)
	li s3, 40
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -20(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -24(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	sw s3, -28(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -32(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_6
	j .L5_7
.L5_6:
	lw s1, -4(s0)
	lw s2, -24(s0)
	lw s3, 0(s2)
	lw s2, -24(s0)
	li s4, 4
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -28(s0)
	li s5, 0
	lw s6, -12(s0)
	lw s7, -24(s0)
	li s8, 12
	add s9, s7, s8
	lw s7, 0(s9)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	jal ra, sym_add
	mv s8, a0
	sw s8, -36(s0)
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -36(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 24
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -36(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 28
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -36(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 32
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -36(s0)
	lw s2, -16(s0)
	li s3, 40
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -20(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L5_8
.L5_7:
	lw s1, -4(s0)
	lw s2, -24(s0)
	lw s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, sym_find
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -40(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_9
	j .L5_10
.L5_9:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -40(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -44(s0)
	lw s1, -28(s0)
	bnez s1, .L5_11
	j .L5_12
.L5_11:
	lw s1, -44(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_13
	j .L5_14
.L5_13:
	lw s1, -44(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_15
	j .L5_16
.L5_15:
	lw s1, -32(s0)
	bnez s1, .L5_16
	j .L5_17
.L5_17:
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -44(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -44(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	j .L5_18
.L5_16:
	lw s1, -44(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_19
	j .L5_20
.L5_20:
	lw s1, -32(s0)
	bnez s1, .L5_19
	j .L5_21
.L5_21:
	la s1, __str_1
	lw s2, -24(s0)
	lw s3, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L5_19:
.L5_18:
	j .L5_22
.L5_14:
	li s1, 1
	lw s2, -44(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -44(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -44(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
.L5_22:
	j .L5_23
.L5_12:
	lw s1, -44(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_24
	j .L5_25
.L5_25:
	lw s1, -32(s0)
	bnez s1, .L5_24
	j .L5_26
.L5_26:
	li s1, 0
	lw s2, -44(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L5_24:
.L5_23:
	lw s1, -40(s0)
	lw s2, -16(s0)
	li s3, 40
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -20(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L5_27
.L5_10:
	lw s1, -4(s0)
	lw s2, -24(s0)
	lw s3, 0(s2)
	lw s2, -24(s0)
	li s4, 4
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -28(s0)
	lw s5, -32(s0)
	lw s6, -12(s0)
	lw s7, -24(s0)
	li s8, 12
	add s9, s7, s8
	lw s7, 0(s9)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	jal ra, sym_add
	mv s8, a0
	sw s8, -48(s0)
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 24
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 28
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -48(s0)
	lw s2, -16(s0)
	li s3, 40
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -20(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L5_27:
.L5_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L5_3
.L5_5:
.L5_28:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L5_0
.L5_2:
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
.Lfunc_end5:
	.size collect_symbols, .Lfunc_end5-collect_symbols

	.text
	.align 2
	.type pattern_matches, @function
pattern_matches:
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
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_2
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L6_0
	j .L6_1
.L6_0:
	lw s1, -8(s0)
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
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
.L6_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L6_2
	j .L6_3
.L6_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -8(s0)
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L6_4
	j .L6_5
.L6_4:
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
.L6_5:
	lw s1, -8(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_6
	j .L6_7
.L6_7:
	lw s1, -8(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_6
	j .L6_8
.L6_6:
	li s1, 1
	j .L6_9
.L6_8:
	li s1, 0
.L6_9:
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
.L6_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
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
.Lfunc_end6:
	.size pattern_matches, .Lfunc_end6-pattern_matches

	.text
	.align 2
	.type find_region, @function
find_region:
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
	li s1, 0
	sw s1, -12(s0)
.L7_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 172
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L7_1
	j .L7_2
.L7_1:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 20
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L7_3
	j .L7_4
.L7_3:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 20
	mul s4, s1, s2
	add s1, s3, s4
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
.L7_4:
.L7_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L7_0
.L7_2:
	la s1, __str_4
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end7:
	.size find_region, .Lfunc_end7-find_region

	.text
	.align 2
	.type align_up, @function
align_up:
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
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	lw s1, -8(s0)
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
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
	.size align_up, .Lfunc_end8-align_up

	.text
	.align 2
	.type outsec_ensure, @function
outsec_ensure:
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
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_0
	j .L9_1
.L9_0:
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
.L9_1:
	lw s1, -8(s0)
	li s2, 2
	mul s3, s1, s2
	lw s1, -4(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, realloc
	mv s3, a0
	lw s1, -4(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L9_2
	j .L9_3
.L9_3:
	la s1, __str_5
	mv a0, s1
	jal ra, die
	mv s2, a0
.L9_2:
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
.Lfunc_end9:
	.size outsec_ensure, .Lfunc_end9-outsec_ensure

	.text
	.align 2
	.type outsec_append, @function
outsec_append:
	addi sp, sp, -96
	sw ra, 92(sp)
	sw s0, 88(sp)
	addi s0, sp, 88
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
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	sw s3, -20(s0)
	lw s1, -20(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, align_up
	mv s3, a0
	lw s1, -20(s0)
	sub s2, s3, s1
	sw s2, -24(s0)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	add s3, s1, s2
	lw s1, -12(s0)
	add s2, s3, s1
	sw s2, -28(s0)
	lw s1, -4(s0)
	lw s2, -28(s0)
	mv a0, s1
	mv a1, s2
	jal ra, outsec_ensure
	mv s3, a0
	lw s1, -24(s0)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	li s1, 0
	lw s2, -24(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memset
	mv s4, a0
.L10_1:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -12(s0)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L10_2
	j .L10_3
.L10_2:
	lw s1, -8(s0)
	bnez s1, .L10_4
	j .L10_5
.L10_4:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	j .L10_6
.L10_5:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	li s1, 0
	lw s2, -12(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memset
	mv s4, a0
.L10_6:
.L10_3:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 0
	mv a0, s1
	lw s1, -76(s0)
	lw s2, -72(s0)
	lw s3, -68(s0)
	lw s4, -64(s0)
	lw s5, -60(s0)
	lw s6, -56(s0)
	lw s7, -52(s0)
	lw s8, -48(s0)
	lw s9, -44(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end10:
	.size outsec_append, .Lfunc_end10-outsec_append

	.text
	.align 2
	.type process_assigns, @function
process_assigns:
	addi sp, sp, -96
	sw ra, 92(sp)
	sw s0, 88(sp)
	addi s0, sp, 88
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
	li s1, 0
	sw s1, -20(s0)
.L11_0:
	lw s1, -20(s0)
	lw s2, -8(s0)
	li s3, 360
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L11_1
	j .L11_2
.L11_1:
	lw s1, -8(s0)
	li s2, 168
	add s3, s1, s2
	lw s1, -20(s0)
	li s2, 12
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -24(s0)
	li s1, 0
	sw s1, -28(s0)
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L11_3
	j .L11_4
.L11_3:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_5
	j .L11_4
.L11_5:
	li s1, 1
	sw s1, -28(s0)
	j .L11_6
.L11_4:
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L11_7
	j .L11_8
.L11_8:
	lw s1, -24(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_9
	j .L11_7
.L11_9:
	li s1, 1
	sw s1, -28(s0)
.L11_7:
.L11_6:
	lw s1, -28(s0)
	bnez s1, .L11_10
	j .L11_11
.L11_11:
	j .L11_12
.L11_10:
	lw s1, -4(s0)
	lw s2, -24(s0)
	lw s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, sym_find
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_13
	j .L11_14
.L11_13:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -32(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -32(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -32(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	j .L11_15
.L11_14:
	lw s1, -4(s0)
	lw s2, -24(s0)
	lw s3, 0(s2)
	lw s2, -16(s0)
	li s4, 1
	li s5, 0
	li s6, 1
	neg s7, s6
	li s6, 1
	neg s8, s6
	mv a0, s1
	mv a1, s3
	mv a2, s2
	mv a3, s4
	mv a4, s5
	mv a5, s7
	mv a6, s8
	jal ra, sym_add
	mv s6, a0
.L11_15:
.L11_12:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L11_0
.L11_2:
	li s1, 0
	mv a0, s1
	lw s1, -76(s0)
	lw s2, -72(s0)
	lw s3, -68(s0)
	lw s4, -64(s0)
	lw s5, -60(s0)
	lw s6, -56(s0)
	lw s7, -52(s0)
	lw s8, -48(s0)
	lw s9, -44(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end11:
	.size process_assigns, .Lfunc_end11-process_assigns

	.text
	.align 2
	.globl ld_layout
	.type ld_layout, @function
ld_layout:
	addi sp, sp, -208
	sw ra, 204(sp)
	sw s0, 200(sp)
	addi s0, sp, 200
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
	li s2, 20
	add s3, s1, s2
	sw s3, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, collect_symbols
	mv s2, a0
	lw s1, -12(s0)
	li s2, 272
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L12_0
	j .L12_1
.L12_0:
	lw s1, -12(s0)
	li s2, 272
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L12_2
.L12_1:
	li s1, 1
	sw s1, -20(s0)
.L12_2:
	lw s1, -20(s0)
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 6196
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_3
	j .L12_4
.L12_3:
	lw s1, -4(s0)
	li s2, 6196
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	j .L12_5
.L12_4:
	li s1, 52
	sw s1, -28(s0)
.L12_5:
	lw s1, -28(s0)
	sw s1, -24(s0)
	lw s1, -4(s0)
	li s2, 6200
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_6
	j .L12_7
.L12_6:
	lw s1, -4(s0)
	li s2, 6200
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	j .L12_8
.L12_7:
	li s1, 32
	sw s1, -36(s0)
.L12_8:
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s1, -24(s0)
	lw s2, -16(s0)
	lw s3, -32(s0)
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -40(s0)
	li s1, 0
	sw s1, -44(s0)
.L12_9:
	lw s1, -44(s0)
	lw s2, -12(s0)
	li s3, 172
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_10
	j .L12_11
.L12_10:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -44(s0)
	li s2, 20
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -40(s0)
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, -44(s0)
	li s2, 20
	mul s5, s1, s2
	add s1, s4, s5
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
.L12_12:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L12_9
.L12_11:
	li s1, 0
	sw s1, -48(s0)
.L12_13:
	lw s1, -48(s0)
	lw s2, -12(s0)
	li s3, 6100
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_14
	j .L12_15
.L12_14:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	lw s1, -48(s0)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -52(s0)
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_16
	j .L12_17
.L12_16:
	li s1, 0
	sw s1, -56(s0)
.L12_18:
	lw s1, -56(s0)
	lw s2, -52(s0)
	li s3, 164
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_19
	j .L12_20
.L12_19:
	li s1, 0
	sw s1, -60(s0)
.L12_21:
	lw s1, -60(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_22
	j .L12_23
.L12_22:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -60(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -64(s0)
	li s1, 0
	sw s1, -68(s0)
.L12_24:
	lw s1, -68(s0)
	lw s2, -64(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_25
	j .L12_26
.L12_25:
	lw s1, -64(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -68(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 28
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L12_27
	j .L12_28
.L12_27:
	j .L12_29
.L12_28:
	lw s1, -64(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -68(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 2
	and s3, s1, s2
	bnez s3, .L12_30
	j .L12_31
.L12_31:
	lw s1, -64(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -68(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_32
	j .L12_30
.L12_32:
	lw s1, -64(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -68(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 8
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_33
	j .L12_30
.L12_33:
	j .L12_29
.L12_30:
	lw s1, -52(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, -56(s0)
	li s2, 8
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, -64(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -68(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, pattern_matches
	mv s3, a0
	bnez s3, .L12_34
	j .L12_35
.L12_34:
	li s1, 1
	lw s2, -64(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -68(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 28
	add s4, s3, s2
	sw s1, 0(s4)
.L12_35:
.L12_29:
	addi s1, s0, -68
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -68(s0)
	j .L12_24
.L12_26:
.L12_36:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L12_21
.L12_23:
.L12_37:
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -56(s0)
	j .L12_18
.L12_20:
	j .L12_38
.L12_17:
	li s1, 0
	sw s1, -72(s0)
	lw s1, -52(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_39
	j .L12_40
.L12_39:
	lw s1, -12(s0)
	lw s2, -52(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, find_region
	mv s3, a0
	sw s3, -72(s0)
.L12_40:
	lw s1, -72(s0)
	bnez s1, .L12_41
	j .L12_42
.L12_41:
	lw s1, -72(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -52(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L12_42:
	lw s1, -4(s0)
	lw s2, -52(s0)
	li s3, 0
	lw s4, -72(s0)
	bnez s4, .L12_43
	j .L12_44
.L12_43:
	lw s4, -72(s0)
	li s5, 16
	add s6, s4, s5
	lw s4, 0(s6)
	sw s4, -76(s0)
	j .L12_45
.L12_44:
	lw s4, -52(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	sw s4, -76(s0)
.L12_45:
	lw s4, -76(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, process_assigns
	mv s5, a0
	li s1, 0
	sw s1, -80(s0)
	li s1, 0
	sw s1, -84(s0)
.L12_46:
	lw s1, -84(s0)
	lw s2, -52(s0)
	li s3, 164
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_47
	j .L12_48
.L12_47:
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -80(s0)
	li s1, 0
	sw s1, -88(s0)
.L12_49:
	lw s1, -88(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_50
	j .L12_51
.L12_50:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -88(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -92(s0)
	li s1, 0
	sw s1, -96(s0)
.L12_52:
	lw s1, -96(s0)
	lw s2, -92(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_53
	j .L12_54
.L12_53:
	lw s1, -92(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -96(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -100(s0)
	lw s1, -100(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_55
	j .L12_56
.L12_55:
	j .L12_57
.L12_56:
	lw s1, -100(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_58
	j .L12_59
.L12_58:
	lw s1, -100(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_60
	j .L12_59
.L12_60:
	j .L12_57
.L12_59:
	lw s1, -52(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, -84(s0)
	li s2, 8
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, -100(s0)
	lw s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, pattern_matches
	mv s2, a0
	bnez s2, .L12_61
	j .L12_62
.L12_62:
	j .L12_57
.L12_61:
	li s1, 1
	lw s2, -100(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -52(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -52(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	sw s3, -104(s0)
	lw s1, -104(s0)
	lw s2, -100(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, align_up
	mv s3, a0
	lw s1, -104(s0)
	sub s2, s3, s1
	sw s2, -108(s0)
	lw s1, -52(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -52(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -108(s0)
	add s2, s3, s1
	lw s1, -100(s0)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -100(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_63
	j .L12_64
.L12_63:
	li s1, 1
	lw s2, -52(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -52(s0)
	li s2, 0
	lw s3, -100(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -100(s0)
	li s5, 20
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, outsec_append
	mv s5, a0
	j .L12_65
.L12_64:
	lw s1, -52(s0)
	lw s2, -100(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -100(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -100(s0)
	li s5, 20
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, outsec_append
	mv s5, a0
.L12_65:
.L12_57:
	addi s1, s0, -96
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -96(s0)
	j .L12_52
.L12_54:
.L12_66:
	addi s1, s0, -88
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -88(s0)
	j .L12_49
.L12_51:
	lw s1, -52(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -52(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	sw s3, -112(s0)
	lw s1, -4(s0)
	lw s2, -52(s0)
	lw s3, -80(s0)
	lw s4, -112(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, process_assigns
	mv s5, a0
.L12_67:
	addi s1, s0, -84
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -84(s0)
	j .L12_46
.L12_48:
	lw s1, -72(s0)
	bnez s1, .L12_68
	j .L12_69
.L12_68:
	lw s1, -52(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -52(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -72(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -72(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -72(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -72(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	add s4, s2, s3
	sltu s2, s4, s1
	bnez s2, .L12_70
	j .L12_71
.L12_70:
	la s1, __str_6
	lw s2, -52(s0)
	lw s3, 0(s2)
	lw s2, -72(s0)
	lw s4, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L12_71:
.L12_69:
.L12_38:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L12_13
.L12_15:
	li s1, 0
	sw s1, -116(s0)
.L12_72:
	lw s1, -116(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_73
	j .L12_74
.L12_73:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -116(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -120(s0)
	li s1, 0
	sw s1, -124(s0)
.L12_75:
	lw s1, -124(s0)
	lw s2, -120(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_76
	j .L12_77
.L12_76:
	lw s1, -120(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -124(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -128(s0)
	lw s1, -128(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_78
	j .L12_79
.L12_78:
	j .L12_80
.L12_79:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -128(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -132(s0)
	lw s1, -132(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_81
	j .L12_82
.L12_81:
	j .L12_80
.L12_82:
	lw s1, -120(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -124(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -136(s0)
	lw s1, -136(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_83
	j .L12_84
.L12_83:
	lw s1, -136(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_85
	j .L12_84
.L12_85:
	lw s1, -120(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -136(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 24
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -132(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	j .L12_86
.L12_84:
	lw s1, -136(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_87
	j .L12_88
.L12_87:
	lw s1, -136(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 65521
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_89
	j .L12_88
.L12_89:
	lw s1, -120(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -136(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 24
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -136(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -132(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
.L12_88:
.L12_86:
.L12_80:
	addi s1, s0, -124
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -124(s0)
	j .L12_75
.L12_77:
.L12_90:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L12_72
.L12_74:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_91
	j .L12_92
.L12_91:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, sym_find
	mv s3, a0
	sw s3, -140(s0)
	lw s1, -140(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_93
	j .L12_94
.L12_93:
	la s1, __str_7
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L12_94:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -140(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L12_95
	j .L12_96
.L12_96:
	la s1, __str_8
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L12_95:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -140(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 6124
	add s4, s2, s3
	sw s1, 0(s4)
.L12_92:
	li s1, 0
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end12:
	.size ld_layout, .Lfunc_end12-ld_layout

	.text
	.align 2
	.globl ld_find_output_sec
	.type ld_find_output_sec, @function
ld_find_output_sec:
	addi sp, sp, -96
	sw ra, 92(sp)
	sw s0, 88(sp)
	addi s0, sp, 88
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
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	sw s3, -12(s0)
	li s1, 0
	sw s1, -16(s0)
.L13_0:
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 6100
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L13_1
	j .L13_2
.L13_1:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	lw s1, -16(s0)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_3
	j .L13_4
.L13_3:
	j .L13_5
.L13_4:
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	sw s3, -28(s0)
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L13_6
	j .L13_7
.L13_6:
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	sltu s3, s1, s2
	bnez s3, .L13_8
	j .L13_7
.L13_8:
	lw s1, -20(s0)
	mv a0, s1
	lw s1, -76(s0)
	lw s2, -72(s0)
	lw s3, -68(s0)
	lw s4, -64(s0)
	lw s5, -60(s0)
	lw s6, -56(s0)
	lw s7, -52(s0)
	lw s8, -48(s0)
	lw s9, -44(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_7:
.L13_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L13_0
.L13_2:
	li s1, 0
	mv a0, s1
	lw s1, -76(s0)
	lw s2, -72(s0)
	lw s3, -68(s0)
	lw s4, -64(s0)
	lw s5, -60(s0)
	lw s6, -56(s0)
	lw s7, -52(s0)
	lw s8, -48(s0)
	lw s9, -44(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end13:
	.size ld_find_output_sec, .Lfunc_end13-ld_find_output_sec

	.text
	.align 2
	.globl ld_build_debug
	.type ld_build_debug, @function
ld_build_debug:
	addi sp, sp, -96
	sw ra, 92(sp)
	sw s0, 88(sp)
	addi s0, sp, 88
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
.L14_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L14_1
	j .L14_2
.L14_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L14_3:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L14_4
	j .L14_5
.L14_4:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -24(s0)
	li s1, 0
	sw s1, -28(s0)
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_6
	j .L14_7
.L14_6:
	j .L14_8
.L14_7:
	lw s1, -24(s0)
	lw s2, 0(s1)
	la s1, __str_9
	li s3, 7
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L14_9
	j .L14_10
.L14_9:
	j .L14_8
.L14_10:
	li s1, 0
	sw s1, -32(s0)
.L14_11:
	lw s1, -32(s0)
	lw s2, -4(s0)
	li s3, 6192
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L14_12
	j .L14_13
.L14_12:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -32(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	lw s1, -24(s0)
	lw s3, 0(s1)
	mv a0, s2
	mv a1, s3
	jal ra, strcmp
	mv s1, a0
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_14
	j .L14_15
.L14_14:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -32(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -28(s0)
	j .L14_13
.L14_15:
.L14_16:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L14_11
.L14_13:
	lw s1, -28(s0)
	bnez s1, .L14_17
	j .L14_18
.L14_18:
	lw s1, -4(s0)
	li s2, 6192
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L14_19
	j .L14_20
.L14_19:
	la s1, __str_10
	lw s2, -24(s0)
	lw s3, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L14_20:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 6192
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 1
	add s5, s1, s2
	sw s5, 0(s4)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -28(s0)
	lw s1, -24(s0)
	lw s2, 0(s1)
	lw s1, -28(s0)
	sw s2, 0(s1)
.L14_17:
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -28(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L14_21
	j .L14_22
.L14_21:
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	li s1, 2
	mul s2, s3, s1
	lw s1, -28(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, realloc
	mv s3, a0
	lw s1, -28(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_23
	j .L14_24
.L14_24:
	la s1, __str_11
	mv a0, s1
	jal ra, die
	mv s2, a0
.L14_23:
.L14_22:
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L14_25
	j .L14_26
.L14_25:
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -24(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -24(s0)
	li s4, 16
	add s5, s2, s4
	lw s2, 0(s5)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
.L14_26:
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s4, 16
	add s5, s2, s4
	lw s2, 0(s5)
	add s4, s1, s2
	sw s4, 0(s3)
.L14_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L14_3
.L14_5:
.L14_27:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L14_0
.L14_2:
	li s1, 0
	mv a0, s1
	lw s1, -76(s0)
	lw s2, -72(s0)
	lw s3, -68(s0)
	lw s4, -64(s0)
	lw s5, -60(s0)
	lw s6, -56(s0)
	lw s7, -52(s0)
	lw s8, -48(s0)
	lw s9, -44(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end14:
	.size ld_build_debug, .Lfunc_end14-ld_build_debug

	.text
	.align 2
	.globl ld_check_undefined
	.type ld_check_undefined, @function
ld_check_undefined:
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
.L15_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L15_1
	j .L15_2
.L15_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L15_3
	j .L15_4
.L15_4:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L15_3
	j .L15_5
.L15_5:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_6
	j .L15_3
.L15_6:
	la s1, __str_12
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -12(s0)
	li s4, 36
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L15_3:
.L15_7:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L15_0
.L15_2:
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
.Lfunc_end15:
	.size ld_check_undefined, .Lfunc_end15-ld_check_undefined

	.text
	.align 2
	.type map_sym_cmp, @function
map_sym_cmp:
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
	lw s1, -4(s0)
	lw s2, 0(s1)
	sw s2, -12(s0)
	lw s1, -8(s0)
	lw s2, 0(s1)
	sw s2, -16(s0)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	sltu s3, s1, s2
	bnez s3, .L16_0
	j .L16_1
.L16_0:
	li s1, 1
	neg s2, s1
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
.L16_1:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	sltu s3, s2, s1
	bnez s3, .L16_2
	j .L16_3
.L16_2:
	li s1, 1
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
.L16_3:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	lw s3, 0(s1)
	mv a0, s2
	mv a1, s3
	jal ra, strcmp
	mv s1, a0
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
.Lfunc_end16:
	.size map_sym_cmp, .Lfunc_end16-map_sym_cmp

	.text
	.align 2
	.globl ld_write_map
	.type ld_write_map, @function
ld_write_map:
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
	sw a1, -8(s0)
	lw s1, -8(s0)
	la s2, __str_13
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L17_0
	j .L17_1
.L17_1:
	la s1, __str_14
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L17_0:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	sw s3, -16(s0)
	lw s1, -12(s0)
	la s2, __str_15
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	lw s1, -12(s0)
	la s2, __str_16
	lw s3, -4(s0)
	li s4, 6124
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -16(s0)
	li s2, 172
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L17_2
	j .L17_3
.L17_2:
	lw s1, -12(s0)
	la s2, __str_17
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	li s1, 0
	sw s1, -20(s0)
.L17_4:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 172
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L17_5
	j .L17_6
.L17_5:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -20(s0)
	li s2, 20
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -24(s0)
	lw s1, -12(s0)
	la s2, __str_18
	lw s3, -24(s0)
	lw s4, 0(s3)
	lw s3, -24(s0)
	li s5, 4
	add s6, s3, s5
	lw s3, 0(s6)
	lw s5, -24(s0)
	li s6, 8
	add s7, s5, s6
	lw s5, 0(s7)
	lw s6, -24(s0)
	li s7, 8
	add s8, s6, s7
	lw s6, 0(s8)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s4, 0(sp)
	sw s3, 4(sp)
	sw s5, 8(sp)
	sw s6, 12(sp)
	jal ra, fprintf
	mv s7, a0
	addi sp, sp, 16
.L17_7:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L17_4
.L17_6:
	lw s1, -12(s0)
	la s2, __str_19
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
.L17_3:
	lw s1, -12(s0)
	la s2, __str_20
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	li s1, 0
	sw s1, -28(s0)
.L17_8:
	lw s1, -28(s0)
	lw s2, -16(s0)
	li s3, 6100
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L17_9
	j .L17_10
.L17_9:
	lw s1, -16(s0)
	li s2, 276
	add s3, s1, s2
	lw s1, -28(s0)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -32(s0)
	lw s1, -32(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L17_11
	j .L17_12
.L17_12:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L17_11
	j .L17_13
.L17_11:
	j .L17_14
.L17_13:
	lw s1, -12(s0)
	la s2, __str_21
	lw s3, -32(s0)
	lw s4, 0(s3)
	lw s3, -32(s0)
	li s5, 12
	add s6, s3, s5
	lw s3, 0(s6)
	lw s5, -32(s0)
	li s6, 16
	add s7, s5, s6
	lw s5, 0(s7)
	lw s6, -32(s0)
	li s7, 8
	add s8, s6, s7
	lw s6, 0(s8)
	bnez s6, .L17_15
	j .L17_16
.L17_15:
	la s6, __str_22
	sw s6, -36(s0)
	j .L17_17
.L17_16:
	la s6, __str_23
	sw s6, -36(s0)
.L17_17:
	lw s6, -36(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s4, 0(sp)
	sw s3, 4(sp)
	sw s5, 8(sp)
	sw s6, 12(sp)
	jal ra, fprintf
	mv s7, a0
	addi sp, sp, 16
	li s1, 0
	sw s1, -40(s0)
.L17_18:
	lw s1, -40(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L17_19
	j .L17_20
.L17_19:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -40(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -44(s0)
	li s1, 0
	sw s1, -48(s0)
.L17_21:
	lw s1, -48(s0)
	lw s2, -44(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L17_22
	j .L17_23
.L17_22:
	lw s1, -44(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -48(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -52(s0)
	lw s1, -52(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L17_24
	j .L17_25
.L17_25:
	j .L17_26
.L17_24:
	lw s1, -4(s0)
	lw s2, -52(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ld_find_output_sec
	mv s3, a0
	lw s1, -32(s0)
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L17_27
	j .L17_28
.L17_27:
	j .L17_26
.L17_28:
	lw s1, -12(s0)
	la s2, __str_24
	lw s3, -52(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -52(s0)
	li s5, 16
	add s6, s4, s5
	lw s4, 0(s6)
	lw s5, -44(s0)
	lw s6, 0(s5)
	lw s5, -52(s0)
	lw s7, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s6, 8(sp)
	sw s7, 12(sp)
	jal ra, fprintf
	mv s5, a0
	addi sp, sp, 16
.L17_26:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L17_21
.L17_23:
.L17_29:
	addi s1, s0, -40
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -40(s0)
	j .L17_18
.L17_20:
.L17_14:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L17_8
.L17_10:
	lw s1, -12(s0)
	la s2, __str_25
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	lw s1, -4(s0)
	li s2, 6204
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 4
	mul s4, s1, s2
	mv a0, s3
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -56(s0)
	li s1, 0
	sw s1, -60(s0)
	li s1, 0
	sw s1, -64(s0)
.L17_30:
	lw s1, -64(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L17_31
	j .L17_32
.L17_31:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -64(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L17_33
	j .L17_34
.L17_33:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -64(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L17_35
	j .L17_34
.L17_35:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -64(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, -56(s0)
	addi s3, s0, -60
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -60(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s1, s5
	sw s2, 0(s3)
.L17_34:
.L17_36:
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -64(s0)
	j .L17_30
.L17_32:
	lw s1, -56(s0)
	lw s2, -60(s0)
	li s3, 4
	la s4, map_sym_cmp
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, qsort
	mv s5, a0
	lw s1, -12(s0)
	la s2, __str_26
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	li s1, 0
	sw s1, -68(s0)
.L17_37:
	lw s1, -68(s0)
	lw s2, -60(s0)
	slt s3, s1, s2
	bnez s3, .L17_38
	j .L17_39
.L17_38:
	lw s1, -56(s0)
	lw s2, -68(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -72(s0)
	la s1, __str_27
	sw s1, -76(s0)
	lw s1, -72(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L17_40
	j .L17_41
.L17_40:
	lw s1, -72(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L17_42
	j .L17_41
.L17_42:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -72(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	sw s2, -76(s0)
.L17_41:
	lw s1, -12(s0)
	la s2, __str_28
	lw s3, -72(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -72(s0)
	lw s5, 0(s4)
	lw s4, -76(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s4, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
.L17_43:
	addi s1, s0, -68
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -68(s0)
	j .L17_37
.L17_39:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
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
.Lfunc_end17:
	.size ld_write_map, .Lfunc_end17-ld_write_map

	.text
	.align 2
	.globl ld_link
	.type ld_link, @function
ld_link:
	addi sp, sp, -176
	sw ra, 172(sp)
	sw s0, 168(sp)
	addi s0, sp, 168
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
	mv a0, s1
	jal ra, ld_layout
	mv s2, a0
	li s1, 0
	sw s1, -12(s0)
.L18_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L18_1
	j .L18_2
.L18_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L18_3:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L18_4
	j .L18_5
.L18_4:
	lw s1, -16(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -24(s0)
	lw s1, -16(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L18_6
	j .L18_7
.L18_6:
	la s1, __str_29
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -24(s0)
	li s4, 4
	add s5, s2, s4
	lw s2, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s2, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L18_7:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L18_8
	j .L18_9
.L18_9:
	lw s1, -32(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L18_8
	j .L18_10
.L18_10:
	la s1, __str_30
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -32(s0)
	lw s4, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L18_8:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -36(s0)
	lw s1, -36(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L18_11
	j .L18_12
.L18_12:
	j .L18_13
.L18_11:
	lw s1, -4(s0)
	lw s2, -36(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ld_find_output_sec
	mv s3, a0
	sw s3, -40(s0)
	lw s1, -40(s0)
	bnez s1, .L18_14
	j .L18_15
.L18_15:
	la s1, __str_31
	lw s2, -16(s0)
	lw s3, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L18_14:
	lw s1, -36(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -40(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	sub s3, s1, s2
	lw s1, -24(s0)
	lw s2, 0(s1)
	add s1, s3, s2
	sw s1, -44(s0)
	lw s1, -40(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	add s3, s1, s2
	sw s3, -48(s0)
	lw s1, -32(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	lw s1, -24(s0)
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	sw s10, -56(s0)
	lw s1, -36(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	lw s3, 0(s2)
	add s2, s1, s3
	sw s2, -60(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_16
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_17
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_18
	j .L18_19
.L18_16:
	lw s1, -48(s0)
	lw s2, -52(s0)
	lw s3, -56(s0)
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, put32
	mv s2, a0
	j .L18_20
.L18_17:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	lw s1, -60(s0)
	sub s2, s3, s1
	sw s2, -64(s0)
	lw s1, -48(s0)
	lw s2, -64(s0)
	mv a0, s1
	mv a1, s2
	jal ra, put32
	mv s3, a0
	j .L18_20
.L18_18:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	lw s1, -60(s0)
	sub s2, s3, s1
	sw s2, -68(s0)
	lw s1, -68(s0)
	li s2, 32768
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L18_21
	j .L18_22
.L18_22:
	lw s1, -68(s0)
	li s2, 32767
	slt s3, s2, s1
	bnez s3, .L18_21
	j .L18_23
.L18_21:
	la s1, __str_32
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -32(s0)
	lw s4, 0(s2)
	lw s2, -68(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s2, 8(sp)
	jal ra, die
	mv s5, a0
	addi sp, sp, 16
.L18_23:
	lw s1, -48(s0)
	lw s2, -68(s0)
	li s3, 16
	sll s4, s2, s3
	li s2, 16
	sra s3, s4, s2
	li s2, 65535
	and s4, s3, s2
	mv a0, s1
	mv a1, s4
	jal ra, put16
	mv s2, a0
	j .L18_20
.L18_19:
	la s1, __str_33
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -24(s0)
	li s4, 16
	add s5, s2, s4
	lw s2, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s2, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L18_20:
.L18_13:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L18_3
.L18_5:
.L18_24:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L18_0
.L18_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, ld_build_debug
	mv s2, a0
	li s1, 0
	sw s1, -72(s0)
.L18_25:
	lw s1, -72(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L18_26
	j .L18_27
.L18_26:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -72(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -76(s0)
	li s1, 0
	sw s1, -80(s0)
.L18_28:
	lw s1, -80(s0)
	lw s2, -76(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L18_29
	j .L18_30
.L18_29:
	lw s1, -76(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -80(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -84(s0)
	lw s1, -76(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -84(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -88(s0)
	li s1, 0
	sw s1, -92(s0)
	lw s1, -88(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L18_31
	j .L18_32
.L18_32:
	lw s1, -88(s0)
	lw s2, 0(s1)
	la s1, __str_34
	li s3, 7
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L18_31
	j .L18_33
.L18_31:
	j .L18_34
.L18_33:
	li s1, 0
	sw s1, -108(s0)
.L18_35:
	lw s1, -108(s0)
	lw s2, -4(s0)
	li s3, 6192
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L18_36
	j .L18_37
.L18_36:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -108(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	lw s1, -88(s0)
	lw s3, 0(s1)
	mv a0, s2
	mv a1, s3
	jal ra, strcmp
	mv s1, a0
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_38
	j .L18_39
.L18_38:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -108(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -92(s0)
	j .L18_37
.L18_39:
.L18_40:
	addi s1, s0, -108
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -108(s0)
	j .L18_35
.L18_37:
	lw s1, -92(s0)
	bnez s1, .L18_41
	j .L18_42
.L18_42:
	j .L18_34
.L18_41:
	lw s1, -76(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -84(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -104(s0)
	lw s1, -104(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L18_43
	j .L18_44
.L18_43:
	la s1, __str_35
	lw s2, -76(s0)
	lw s3, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L18_44:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -104(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -96(s0)
	lw s1, -92(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -88(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -84(s0)
	lw s2, 0(s1)
	add s1, s3, s2
	sw s1, -100(s0)
	lw s1, -84(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_45
	j .L18_46
.L18_45:
	lw s1, -100(s0)
	lw s2, -96(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -84(s0)
	li s4, 8
	add s5, s3, s4
	lw s10, 0(s5)
	lw s11, 4(s5)
	mv s3, s10
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, put32
	mv s2, a0
	j .L18_47
.L18_46:
	la s1, __str_36
	lw s2, -76(s0)
	lw s3, 0(s2)
	lw s2, -84(s0)
	li s4, 16
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -88(s0)
	lw s5, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s2, 4(sp)
	sw s5, 8(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L18_47:
.L18_34:
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -80(s0)
	j .L18_28
.L18_30:
.L18_48:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -72(s0)
	j .L18_25
.L18_27:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, ld_check_undefined
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end18:
	.size ld_link, .Lfunc_end18-ld_link

	.text
	.align 2
	.globl ld_add_object
	.type ld_add_object, @function
ld_add_object:
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
	li s2, 6204
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 1
	add s4, s1, s2
	li s1, 44
	mul s2, s4, s1
	mv a0, s3
	mv a1, s2
	jal ra, arena_zalloc
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L19_0
	j .L19_1
.L19_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -4(s0)
	li s4, 4
	add s5, s2, s4
	lw s2, 0(s5)
	li s4, 44
	mul s5, s2, s4
	mv a0, s1
	mv a1, s3
	mv a2, s5
	jal ra, memcpy
	mv s2, a0
.L19_1:
	lw s1, -12(s0)
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 1
	add s5, s1, s3
	sw s5, 0(s4)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
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
.Lfunc_end19:
	.size ld_add_object, .Lfunc_end19-ld_add_object

	.text
	.align 2
	.globl ld_free
	.type ld_free, @function
ld_free:
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
.L20_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L20_1
	j .L20_2
.L20_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	li s2, 4
	add s3, s1, s2
	mv a0, s3
	jal ra, mapfile_close
	mv s1, a0
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L20_3:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L20_0
.L20_2:
	li s1, 0
	sw s1, -16(s0)
.L20_4:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	li s2, 6100
	add s3, s4, s2
	lw s2, 0(s3)
	slt s3, s1, s2
	bnez s3, .L20_5
	j .L20_6
.L20_5:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	li s1, 276
	add s2, s3, s1
	lw s1, -16(s0)
	li s3, 364
	mul s4, s1, s3
	add s1, s2, s4
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L20_7:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L20_4
.L20_6:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 6204
	add s3, s1, s2
	mv a0, s3
	jal ra, arena_free
	mv s1, a0
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
.Lfunc_end20:
	.size ld_free, .Lfunc_end20-ld_free

	.data
	.align 2
__str_36:
	.ascii "%s: unsupported debug relocation type %d in %s\000"
	.align 2
__str_35:
	.ascii "%s: debug reloc references unmapped symbol\000"
	.align 2
__str_34:
	.ascii ".debug_\000"
	.align 2
__str_33:
	.ascii "%s: unsupported relocation type %d\000"
	.align 2
__str_32:
	.ascii "%s: R_68K_PC16 relocation overflow for '%s' (displacement %d)\000"
	.align 2
__str_31:
	.ascii "%s: cannot find output section for reloc\000"
	.align 2
__str_30:
	.ascii "%s: undefined symbol '%s'\000"
	.align 2
__str_29:
	.ascii "%s: reloc references unmapped symbol %d\000"
	.align 2
__str_28:
	.ascii "  0x%08x  %-24s %s\n\000"
	.align 2
__str_27:
	.ascii "\000"
	.align 2
__str_26:
	.ascii "Symbols:\n\000"
	.align 2
__str_25:
	.ascii "\n\000"
	.align 2
__str_24:
	.ascii "    0x%08x  0x%08x  %s(%s)\n\000"
	.align 2
__str_23:
	.ascii "\000"
	.align 2
__str_22:
	.ascii "  (nobits)\000"
	.align 2
__str_21:
	.ascii "  %-12s 0x%08x  0x%08x%s\n\000"
	.align 2
__str_20:
	.ascii "Output sections:\n\000"
	.align 2
__str_19:
	.ascii "\n\000"
	.align 2
__str_18:
	.ascii "  %-12s origin 0x%08x  length 0x%08x (%u bytes)\n\000"
	.align 2
__str_17:
	.ascii "Memory configuration:\n\000"
	.align 2
__str_16:
	.ascii "Entry point: 0x%08x\n\n\000"
	.align 2
__str_15:
	.ascii "Skjegg link map\n\n\000"
	.align 2
__str_14:
	.ascii "cannot create %s\000"
	.align 2
__str_13:
	.ascii "w\000"
	.align 2
__str_12:
	.ascii "undefined symbol: %s\000"
	.align 2
__str_11:
	.ascii "out of memory\000"
	.align 2
__str_10:
	.ascii "too many debug sections (%s)\000"
	.align 2
__str_9:
	.ascii ".debug_\000"
	.align 2
__str_8:
	.ascii "entry symbol '%s' is undefined\000"
	.align 2
__str_7:
	.ascii "entry symbol '%s' not found\000"
	.align 2
__str_6:
	.ascii "section %s overflows region %s\000"
	.align 2
__str_5:
	.ascii "out of memory\000"
	.align 2
__str_4:
	.ascii "unknown memory region: %s\000"
	.align 2
__str_3:
	.ascii "COMMON\000"
	.align 2
__str_2:
	.ascii "COMMON\000"
	.align 2
__str_1:
	.ascii "duplicate symbol: %s\000"
	.align 2
__str_0:
	.ascii "out of memory\000"
