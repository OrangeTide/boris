# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type numeric_ref, @function
numeric_ref:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 2
	sltu s3, s1, s2
	bnez s3, .L1_0
	j .L1_1
.L1_0:
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
.L1_1:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 102
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L1_2
	j .L1_3
.L1_2:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 98
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L1_4
	j .L1_3
.L1_4:
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
.L1_3:
	li s1, 0
	sw s1, -24(s0)
.L1_5:
	lw s1, -24(s0)
	lw s2, -20(s0)
	li s3, 1
	sub s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L1_6
	j .L1_7
.L1_6:
	lw s1, -4(s0)
	lw s2, -24(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 48
	slt s3, s1, s2
	bnez s3, .L1_8
	j .L1_9
.L1_9:
	lw s1, -4(s0)
	lw s2, -24(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 57
	slt s3, s2, s1
	bnez s3, .L1_8
	j .L1_10
.L1_8:
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
.L1_10:
.L1_11:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L1_5
.L1_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, atoi
	mv s2, a0
	lw s1, -8(s0)
	sw s2, 0(s1)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	lw s2, -12(s0)
	sb s1, 0(s2)
	li s1, 1
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
.Lfunc_end1:
	.size numeric_ref, .Lfunc_end1-numeric_ref

	.text
	.align 2
	.type numlabel_count, @function
numlabel_count:
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
.L2_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 612
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L2_1
	j .L2_2
.L2_1:
	lw s1, -4(s0)
	li s2, 608
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -8(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_3
	j .L2_4
.L2_3:
	lw s1, -4(s0)
	li s2, 608
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
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
.L2_4:
.L2_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L2_0
.L2_2:
	lw s1, -4(s0)
	li s2, 612
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 616
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_6
	j .L2_7
.L2_6:
	lw s1, -4(s0)
	li s2, 616
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L2_8
	j .L2_9
.L2_8:
	lw s1, -4(s0)
	li s2, 616
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -16(s0)
	j .L2_10
.L2_9:
	li s1, 16
	sw s1, -16(s0)
.L2_10:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 616
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 608
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 616
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, realloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 608
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 608
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L2_11
	j .L2_12
.L2_12:
	la s1, __str_0
	mv a0, s1
	jal ra, die
	mv s2, a0
.L2_11:
.L2_7:
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 608
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 612
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	lw s2, -4(s0)
	li s3, 608
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 612
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 608
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 612
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s5, s2, s3
	sw s5, 0(s4)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
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
.Lfunc_end2:
	.size numlabel_count, .Lfunc_end2-numlabel_count

	.text
	.align 2
	.type numeric_ref_name, @function
numeric_ref_name:
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
	sw a2, -12(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, numlabel_count
	mv s3, a0
	lw s1, 0(s3)
	sw s1, -52(s0)
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 98
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, 1
	sub s3, s2, s1
	sw s3, -52(s0)
.L3_1:
	addi s1, s0, -48
	li s2, 32
	la s3, __str_1
	lw s4, -8(s0)
	lw s5, -52(s0)
	li s6, 0
	slt s7, s5, s6
	bnez s7, .L3_2
	j .L3_3
.L3_2:
	li s5, 0
	sw s5, -56(s0)
	j .L3_4
.L3_3:
	lw s5, -52(s0)
	sw s5, -56(s0)
.L3_4:
	lw s5, -56(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, snprintf
	mv s6, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	addi s1, s0, -48
	mv a0, s3
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	mv a0, s2
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
.Lfunc_end3:
	.size numeric_ref_name, .Lfunc_end3-numeric_ref_name

	.text
	.align 2
	.type reloc_op_of, @function
reloc_op_of:
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
	la s2, __str_2
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_0
	j .L4_1
.L4_0:
	li s1, 1
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
.L4_1:
	lw s1, -4(s0)
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_2
	j .L4_3
.L4_2:
	li s1, 2
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
.L4_3:
	lw s1, -4(s0)
	la s2, __str_4
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_4
	j .L4_5
.L4_4:
	li s1, 3
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
.L4_5:
	lw s1, -4(s0)
	la s2, __str_5
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_6
	j .L4_7
.L4_6:
	li s1, 4
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
.L4_7:
	li s1, 1
	neg s2, s1
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
.Lfunc_end4:
	.size reloc_op_of, .Lfunc_end4-reloc_op_of

	.text
	.align 2
	.type parse_addend, @function
parse_addend:
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
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_0
	j .L5_1
.L5_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_2
	j .L5_3
.L5_2:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L5_3:
	j .L5_4
.L5_1:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_5
	j .L5_6
.L5_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_7
	j .L5_8
.L5_7:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	neg s2, s1
	sw s2, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L5_8:
.L5_6:
.L5_4:
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
.Lfunc_end5:
	.size parse_addend, .Lfunc_end5-parse_addend

	.text
	.align 2
	.type parse_mem_base, @function
parse_mem_base:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 7
	xor s3, s1, s2
	snez s3, s3
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L6_2
	j .L6_3
.L6_2:
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
.L6_3:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	mv a0, s1
	jal ra, rv_ireg
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L6_4
	j .L6_5
.L6_4:
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
.L6_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L6_6
	j .L6_7
.L6_6:
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
.L6_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
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
.Lfunc_end6:
	.size parse_mem_base, .Lfunc_end6-parse_mem_base

	.text
	.align 2
	.type parse_operand, @function
parse_operand:
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
	lw s1, -4(s0)
	sw s1, -12(s0)
	lw s1, -8(s0)
	li s2, 0
	li s3, 20
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li s1, 0
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 11
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	mv a0, s1
	jal ra, reloc_op_of
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_2
	j .L7_3
.L7_2:
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
.L7_3:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 7
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_4
	j .L7_5
.L7_4:
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
.L7_5:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_6
	j .L7_7
.L7_6:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_8
	j .L7_7
.L7_8:
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
.L7_7:
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	lw s1, -8(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, parse_addend
	mv s2, a0
	lw s1, -8(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_9
	j .L7_10
.L7_9:
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
.L7_10:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -24(s0)
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	neg s2, s1
	sw s2, -20(s0)
	lw s1, -12(s0)
	addi s2, s0, -20
	mv a0, s1
	mv a1, s2
	jal ra, parse_mem_base
	mv s3, a0
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_11
	j .L7_12
.L7_11:
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
.L7_12:
	lw s1, -28(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_13
	j .L7_14
.L7_13:
	li s1, 5
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -20(s0)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
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
.L7_14:
	li s1, 3
	lw s2, -8(s0)
	sw s1, 0(s2)
	li s1, 1
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
.L7_1:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 7
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_15
	j .L7_16
.L7_15:
	li s1, 1
	neg s2, s1
	sw s2, -20(s0)
	lw s1, -12(s0)
	addi s2, s0, -20
	mv a0, s1
	mv a1, s2
	jal ra, parse_mem_base
	mv s3, a0
	li s1, 1
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L7_17
	j .L7_18
.L7_17:
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
.L7_18:
	li s1, 5
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -20(s0)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
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
.L7_16:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_19
	j .L7_20
.L7_20:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_19
	j .L7_21
.L7_19:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_22
	j .L7_23
.L7_22:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_24
	j .L7_25
.L7_24:
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
.L7_25:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	neg s2, s1
	sw s2, -32(s0)
	j .L7_26
.L7_23:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -32(s0)
.L7_26:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	li s1, 1
	neg s2, s1
	sw s2, -20(s0)
	lw s1, -12(s0)
	addi s2, s0, -20
	mv a0, s1
	mv a1, s2
	jal ra, parse_mem_base
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_27
	j .L7_28
.L7_27:
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
.L7_28:
	lw s1, -36(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_29
	j .L7_30
.L7_29:
	li s1, 5
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -20(s0)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -8(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
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
.L7_30:
	li s1, 3
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -32(s0)
	lw s2, -8(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
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
.L7_21:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_31
	j .L7_32
.L7_31:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	addi s2, s0, -40
	addi s3, s0, -44
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, numeric_ref
	mv s4, a0
	bnez s4, .L7_33
	j .L7_34
.L7_33:
	li s1, 4
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, -40(s0)
	addi s3, s0, -44
	lb s4, 0(s3)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, numeric_ref_name
	mv s3, a0
	lw s1, -8(s0)
	li s2, 12
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	li s1, 1
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
.L7_34:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	mv a0, s1
	jal ra, rv_ireg
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_35
	j .L7_36
.L7_35:
	li s1, 1
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -16(s0)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	lw s1, -8(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	li s1, 1
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
.L7_36:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	mv a0, s1
	jal ra, rv_freg
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_37
	j .L7_38
.L7_37:
	li s1, 2
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -16(s0)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	lw s1, -8(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	li s1, 1
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
.L7_38:
	li s1, 4
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	lw s1, -8(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	li s1, 1
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
.L7_32:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_39
	j .L7_40
.L7_39:
	li s1, 4
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	lw s1, -8(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	li s1, 1
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
.L7_40:
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
.Lfunc_end7:
	.size parse_operand, .Lfunc_end7-parse_operand

	.text
	.align 2
	.type skip_to_eol, @function
skip_to_eol:
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
.L8_0:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L8_1
	j .L8_2
.L8_1:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 13
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L8_3
	j .L8_2
.L8_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	j .L8_0
.L8_2:
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
	.size skip_to_eol, .Lfunc_end8-skip_to_eol

	.text
	.align 2
	.type emit_int_list, @function
emit_int_list:
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
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 552
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	lw s1, -4(s0)
	sw s1, -16(s0)
.L9_0:
	j .L9_1
.L9_1:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_2
	j .L9_3
.L9_2:
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_4
	j .L9_5
.L9_4:
	lw s1, -8(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_6
	j .L9_7
.L9_6:
	lw s1, -12(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 16
	add s3, s4, s2
	lw s2, 0(s3)
	li s3, 255
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, sec_emit8
	mv s2, a0
	j .L9_8
.L9_7:
	lw s1, -8(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_9
	j .L9_10
.L9_9:
	lw s1, -12(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 16
	add s3, s4, s2
	lw s2, 0(s3)
	li s3, 65535
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, sec_emit16
	mv s2, a0
	j .L9_11
.L9_10:
	lw s1, -12(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 16
	add s3, s4, s2
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, sec_emit32
	mv s3, a0
.L9_11:
.L9_8:
	j .L9_12
.L9_5:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s4, s1, s2
	sw s4, 0(s3)
.L9_12:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	j .L9_13
.L9_3:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_14
	j .L9_15
.L9_14:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_16
	j .L9_17
.L9_16:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	neg s2, s1
	sw s2, -20(s0)
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_18
	j .L9_19
.L9_18:
	lw s1, -8(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_20
	j .L9_21
.L9_20:
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 255
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, sec_emit8
	mv s2, a0
	j .L9_22
.L9_21:
	lw s1, -8(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_23
	j .L9_24
.L9_23:
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 65535
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, sec_emit16
	mv s2, a0
	j .L9_25
.L9_24:
	lw s1, -12(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, sec_emit32
	mv s3, a0
.L9_25:
.L9_22:
	j .L9_26
.L9_19:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s4, s1, s2
	sw s4, 0(s3)
.L9_26:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L9_17:
	j .L9_27
.L9_15:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_28
	j .L9_29
.L9_29:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_28
	j .L9_30
.L9_28:
	lw s1, -8(s0)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_31
	j .L9_30
.L9_31:
	li s1, 1
	neg s2, s1
	sw s2, -24(s0)
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_32
	j .L9_33
.L9_32:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -16(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L9_34
	j .L9_35
.L9_34:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -16(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -24(s0)
.L9_35:
.L9_33:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	li s1, 0
	sw s1, -28(s0)
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_36
	j .L9_37
.L9_37:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_36
	j .L9_38
.L9_36:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -32(s0)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_39
	j .L9_40
.L9_39:
	lw s1, -32(s0)
	bnez s1, .L9_41
	j .L9_42
.L9_41:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	neg s2, s1
	sw s2, -36(s0)
	j .L9_43
.L9_42:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -36(s0)
.L9_43:
	lw s1, -36(s0)
	sw s1, -28(s0)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L9_40:
.L9_38:
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_44
	j .L9_45
.L9_44:
	lw s1, -12(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -24(s0)
	lw s4, -28(s0)
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, sec_add_reloc_t
	mv s6, a0
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, sec_emit32
	mv s3, a0
	j .L9_46
.L9_45:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s4, s1, s2
	sw s4, 0(s3)
.L9_46:
	j .L9_47
.L9_30:
	j .L9_48
.L9_47:
.L9_27:
.L9_13:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 5
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L9_49
	j .L9_50
.L9_49:
	j .L9_48
.L9_50:
.L9_51:
	j .L9_0
.L9_48:
	li s1, 0
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
.Lfunc_end9:
	.size emit_int_list, .Lfunc_end9-emit_int_list

	.text
	.align 2
	.type emit_string, @function
emit_string:
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
	li s2, 328
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 552
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	lw s1, -4(s0)
	sw s1, -16(s0)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_2
	j .L10_3
.L10_2:
	li s1, 0
	sw s1, -20(s0)
.L10_4:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 12
	add s3, s4, s2
	lw s2, 0(s3)
	slt s3, s1, s2
	bnez s3, .L10_5
	j .L10_6
.L10_5:
	lw s1, -12(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 8
	add s3, s4, s2
	lw s2, 0(s3)
	lw s3, -20(s0)
	add s4, s2, s3
	lb s2, 0(s4)
	li s3, 255
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, sec_emit8
	mv s2, a0
.L10_7:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L10_4
.L10_6:
	lw s1, -8(s0)
	bnez s1, .L10_8
	j .L10_9
.L10_8:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, sec_emit8
	mv s3, a0
.L10_9:
	j .L10_10
.L10_3:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s4, 12
	add s5, s2, s4
	li s2, 12
	add s4, s5, s2
	lw s2, 0(s4)
	lw s4, -8(s0)
	bnez s4, .L10_11
	j .L10_12
.L10_11:
	li s4, 1
	sw s4, -24(s0)
	j .L10_13
.L10_12:
	li s4, 0
	sw s4, -24(s0)
.L10_13:
	lw s4, -24(s0)
	add s5, s2, s4
	add s2, s1, s5
	sw s2, 0(s3)
.L10_10:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L10_1:
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
	.size emit_string, .Lfunc_end10-emit_string

	.text
	.align 2
	.type do_align, @function
do_align:
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
	li s2, 328
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 552
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L11_1:
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_2
	j .L11_3
.L11_2:
	lw s1, -12(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, sec_align
	mv s3, a0
	j .L11_4
.L11_3:
.L11_5:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	rem s3, s1, s2
	bnez s3, .L11_6
	j .L11_7
.L11_6:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L11_5
.L11_7:
.L11_4:
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
	.size do_align, .Lfunc_end11-do_align

	.text
	.align 2
	.type rv_add_locrow, @function
rv_add_locrow:
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
	lw s1, -4(s0)
	li s2, 628
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 632
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_0
	j .L12_1
.L12_0:
	lw s1, -4(s0)
	li s2, 632
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_2
	j .L12_3
.L12_2:
	lw s1, -4(s0)
	li s2, 632
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -20(s0)
	j .L12_4
.L12_3:
	li s1, 64
	sw s1, -20(s0)
.L12_4:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 632
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 624
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 632
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, realloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 624
	add s4, s1, s3
	sw s2, 0(s4)
.L12_1:
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 624
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 628
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 624
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 628
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 628
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end12:
	.size rv_add_locrow, .Lfunc_end12-rv_add_locrow

	.text
	.align 2
	.type handle_directive, @function
handle_directive:
	addi sp, sp, -144
	sw ra, 140(sp)
	sw s0, 136(sp)
	addi s0, sp, 136
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
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 552
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -16(s0)
	lw s1, -8(s0)
	la s2, __str_6
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_0
	j .L13_1
.L13_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_1:
	lw s1, -8(s0)
	la s2, __str_7
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_2
	j .L13_3
.L13_2:
	li s1, 1
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_3:
	lw s1, -8(s0)
	la s2, __str_8
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_4
	j .L13_5
.L13_4:
	li s1, 2
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_5:
	lw s1, -8(s0)
	la s2, __str_9
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_6
	j .L13_7
.L13_7:
	lw s1, -8(s0)
	la s2, __str_10
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_6
	j .L13_8
.L13_6:
	li s1, 3
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_8:
	lw s1, -8(s0)
	la s2, __str_11
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_9
	j .L13_10
.L13_9:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_11
	j .L13_12
.L13_11:
	la s1, __str_12
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L13_12:
	lw s1, -12(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 8
	add s3, s4, s2
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, lex_include
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L13_13
	j .L13_14
.L13_13:
	la s1, __str_13
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	li s3, 8
	add s4, s5, s3
	lw s3, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L13_14:
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_10:
	lw s1, -8(s0)
	la s2, __str_14
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_15
	j .L13_16
.L13_15:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_17
	j .L13_18
.L13_18:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_17
	j .L13_19
.L13_17:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	la s2, __str_15
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L13_20
	j .L13_21
.L13_20:
	li s1, 0
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	j .L13_22
.L13_21:
	lw s1, -20(s0)
	la s2, __str_16
	li s3, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L13_23
	j .L13_24
.L13_23:
	li s1, 2
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	j .L13_25
.L13_24:
	lw s1, -20(s0)
	la s2, __str_17
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L13_26
	j .L13_27
.L13_26:
	li s1, 1
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	j .L13_28
.L13_27:
	lw s1, -20(s0)
	la s2, __str_18
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L13_29
	j .L13_30
.L13_29:
	li s1, 3
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	j .L13_31
.L13_30:
	li s1, 1
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
.L13_31:
.L13_28:
.L13_25:
.L13_22:
.L13_19:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_16:
	lw s1, -8(s0)
	la s2, __str_19
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_32
	j .L13_33
.L13_33:
	lw s1, -8(s0)
	la s2, __str_20
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_32
	j .L13_34
.L13_34:
	lw s1, -8(s0)
	la s2, __str_21
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_32
	j .L13_35
.L13_32:
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 119
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -24(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_36
	j .L13_37
.L13_37:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_36
	j .L13_38
.L13_36:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L13_39
	j .L13_40
.L13_39:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -28(s0)
.L13_40:
	lw s1, -24(s0)
	bnez s1, .L13_41
	j .L13_42
.L13_41:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -28(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_set_weak
	mv s2, a0
	j .L13_43
.L13_42:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -28(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_set_global
	mv s2, a0
.L13_43:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L13_38:
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_35:
	lw s1, -8(s0)
	la s2, __str_22
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_44
	j .L13_45
.L13_45:
	lw s1, -8(s0)
	la s2, __str_23
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_44
	j .L13_46
.L13_44:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_47
	j .L13_48
.L13_47:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -32(s0)
	li s1, 1
	lw s2, -32(s0)
	li s3, 0
	slt s4, s2, s3
	bnez s4, .L13_49
	j .L13_50
.L13_49:
	li s2, 0
	sw s2, -40(s0)
	j .L13_51
.L13_50:
	lw s2, -32(s0)
	li s3, 12
	slt s4, s3, s2
	bnez s4, .L13_52
	j .L13_53
.L13_52:
	li s2, 12
	sw s2, -44(s0)
	j .L13_54
.L13_53:
	lw s2, -32(s0)
	sw s2, -44(s0)
.L13_54:
	lw s2, -44(s0)
	sw s2, -40(s0)
.L13_51:
	lw s2, -40(s0)
	sll s3, s1, s2
	sw s3, -36(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -36(s0)
	mv a0, s1
	mv a1, s2
	jal ra, do_align
	mv s3, a0
.L13_48:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_46:
	lw s1, -8(s0)
	la s2, __str_24
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_55
	j .L13_56
.L13_55:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_57
	j .L13_58
.L13_57:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -48(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -48(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L13_59
	j .L13_60
.L13_59:
	lw s1, -4(s0)
	lw s2, -48(s0)
	mv a0, s1
	mv a1, s2
	jal ra, do_align
	mv s3, a0
.L13_60:
.L13_58:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_56:
	lw s1, -8(s0)
	la s2, __str_25
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_61
	j .L13_62
.L13_62:
	lw s1, -8(s0)
	la s2, __str_26
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_61
	j .L13_63
.L13_61:
	lw s1, -4(s0)
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, emit_int_list
	mv s3, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_63:
	lw s1, -8(s0)
	la s2, __str_27
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_64
	j .L13_65
.L13_65:
	lw s1, -8(s0)
	la s2, __str_28
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_64
	j .L13_66
.L13_66:
	lw s1, -8(s0)
	la s2, __str_29
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_64
	j .L13_67
.L13_64:
	lw s1, -4(s0)
	li s2, 2
	mv a0, s1
	mv a1, s2
	jal ra, emit_int_list
	mv s3, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_67:
	lw s1, -8(s0)
	la s2, __str_30
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_68
	j .L13_69
.L13_68:
	lw s1, -4(s0)
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, emit_int_list
	mv s3, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_69:
	lw s1, -8(s0)
	la s2, __str_31
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_70
	j .L13_71
.L13_70:
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, emit_string
	mv s3, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_71:
	lw s1, -8(s0)
	la s2, __str_32
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_72
	j .L13_73
.L13_73:
	lw s1, -8(s0)
	la s2, __str_33
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_72
	j .L13_74
.L13_72:
	lw s1, -4(s0)
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, emit_string
	mv s3, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_74:
	lw s1, -8(s0)
	la s2, __str_34
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_75
	j .L13_76
.L13_76:
	lw s1, -8(s0)
	la s2, __str_35
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_75
	j .L13_77
.L13_77:
	lw s1, -8(s0)
	la s2, __str_36
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_75
	j .L13_78
.L13_75:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_79
	j .L13_80
.L13_79:
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_81
	j .L13_82
.L13_81:
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 16
	add s3, s4, s2
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, sec_space
	mv s3, a0
	j .L13_83
.L13_82:
	lw s1, -16(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s4, 12
	add s5, s2, s4
	li s2, 16
	add s4, s5, s2
	lw s2, 0(s4)
	add s4, s1, s2
	sw s4, 0(s3)
.L13_83:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L13_80:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_78:
	lw s1, -8(s0)
	la s2, __str_37
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_84
	j .L13_85
.L13_84:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_86
	j .L13_87
.L13_87:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_86
	j .L13_88
.L13_86:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L13_89
	j .L13_90
.L13_89:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -52(s0)
.L13_90:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L13_91:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_92
	j .L13_93
.L13_92:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 13
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_94
	j .L13_93
.L13_94:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_95
	j .L13_96
.L13_96:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_95
	j .L13_97
.L13_95:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	la s2, __str_38
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_98
	j .L13_97
.L13_98:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -52(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_set_func
	mv s2, a0
.L13_97:
.L13_99:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	j .L13_91
.L13_93:
	j .L13_100
.L13_88:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
.L13_100:
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_85:
	lw s1, -8(s0)
	la s2, __str_39
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_101
	j .L13_102
.L13_101:
	li s1, 1
	neg s2, s1
	sw s2, -56(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_103
	j .L13_104
.L13_104:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_103
	j .L13_105
.L13_103:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L13_106
	j .L13_107
.L13_106:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -56(s0)
.L13_107:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L13_105:
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L13_108
	j .L13_109
.L13_108:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_110
	j .L13_109
.L13_110:
	li s1, 0
	sw s1, -60(s0)
	li s1, 0
	sw s1, -64(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L13_111:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_112
	j .L13_113
.L13_112:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 13
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_114
	j .L13_113
.L13_114:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_115
	j .L13_116
.L13_115:
	li s1, 1
	sw s1, -64(s0)
	j .L13_117
.L13_116:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_118
	j .L13_119
.L13_118:
	li s1, 0
	sw s1, -64(s0)
	j .L13_117
.L13_119:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_120
	j .L13_121
.L13_120:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -68(s0)
	j .L13_122
.L13_121:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_123
	j .L13_124
.L13_124:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_123
	j .L13_125
.L13_123:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	la s2, __str_40
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_126
	j .L13_127
.L13_126:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 552
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -68(s0)
	j .L13_128
.L13_127:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -72(s0)
	lw s1, -72(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L13_129
	j .L13_130
.L13_129:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -72(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -76(s0)
	j .L13_131
.L13_130:
	li s1, 0
	sw s1, -76(s0)
.L13_131:
	lw s1, -76(s0)
	sw s1, -68(s0)
.L13_128:
	j .L13_132
.L13_125:
	j .L13_113
.L13_132:
.L13_122:
	addi s1, s0, -60
	lw s2, 0(s1)
	lw s1, -64(s0)
	bnez s1, .L13_133
	j .L13_134
.L13_133:
	lw s1, -68(s0)
	neg s3, s1
	sw s3, -80(s0)
	j .L13_135
.L13_134:
	lw s1, -68(s0)
	sw s1, -80(s0)
.L13_135:
	lw s1, -80(s0)
	add s3, s2, s1
	sw s3, -60(s0)
	li s1, 0
	sw s1, -64(s0)
.L13_117:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	j .L13_111
.L13_113:
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L13_136
	j .L13_137
.L13_136:
	li s1, 0
	sw s1, -60(s0)
.L13_137:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -56(s0)
	lw s2, -60(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, sym_set_size
	mv s4, a0
.L13_109:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_102:
	lw s1, -8(s0)
	la s2, __str_41
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_138
	j .L13_139
.L13_138:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_140
	j .L13_141
.L13_140:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L13_141:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_142
	j .L13_143
.L13_142:
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 8
	add s2, s4, s1
	lw s1, 0(s2)
	lw s2, -12(s0)
	li s4, 12
	add s5, s2, s4
	li s2, 12
	add s4, s5, s2
	lw s2, 0(s4)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, arena_strndup
	mv s4, a0
	lw s1, -4(s0)
	li s2, 620
	add s3, s1, s2
	sw s4, 0(s3)
.L13_143:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_139:
	lw s1, -8(s0)
	la s2, __str_42
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_144
	j .L13_145
.L13_144:
	li s1, 0
	sw s1, -84(s0)
	li s1, 0
	sw s1, -88(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_146
	j .L13_147
.L13_146:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_148
	j .L13_149
.L13_148:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -84(s0)
	li s1, 1
	sw s1, -88(s0)
.L13_149:
.L13_147:
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_150
	j .L13_151
.L13_150:
	lw s1, -88(s0)
	bnez s1, .L13_152
	j .L13_151
.L13_152:
	lw s1, -4(s0)
	li s2, 552
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_153
	j .L13_151
.L13_153:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 328
	add s4, s2, s3
	li s2, 0
	li s3, 32
	mul s5, s2, s3
	add s2, s4, s5
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -84(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_add_locrow
	mv s4, a0
.L13_151:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_145:
	lw s1, -8(s0)
	la s2, __str_43
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_154
	j .L13_155
.L13_155:
	lw s1, -8(s0)
	la s2, __str_44
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_154
	j .L13_156
.L13_156:
	lw s1, -8(s0)
	la s2, __str_45
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_154
	j .L13_157
.L13_157:
	lw s1, -8(s0)
	la s2, __str_46
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L13_154
	j .L13_158
.L13_158:
	lw s1, -8(s0)
	la s2, __str_47
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L13_154
	j .L13_159
.L13_154:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_159:
	la s1, __str_48
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, warn
	mv s4, a0
	addi sp, sp, 16
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end13:
	.size handle_directive, .Lfunc_end13-handle_directive

	.text
	.align 2
	.type parse_instruction, @function
parse_instruction:
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
	lw s1, -4(s0)
	sw s1, -12(s0)
	li s1, 0
	sw s1, -100(s0)
	addi s1, s0, -96
	li s2, 0
	li s3, 80
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_0
	j .L14_1
.L14_0:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 13
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_2
	j .L14_1
.L14_2:
.L14_3:
	j .L14_4
.L14_4:
	lw s1, -100(s0)
	li s2, 4
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L14_5
	j .L14_6
.L14_5:
	la s1, __str_49
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L14_6:
	lw s1, -4(s0)
	addi s2, s0, -96
	lw s3, -100(s0)
	li s4, 20
	mul s5, s3, s4
	add s3, s2, s5
	mv a0, s1
	mv a1, s3
	jal ra, parse_operand
	mv s2, a0
	bnez s2, .L14_7
	j .L14_8
.L14_8:
	la s1, __str_50
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L14_7:
	addi s1, s0, -100
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -100(s0)
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 5
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_9
	j .L14_10
.L14_9:
	j .L14_11
.L14_10:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L14_12:
	j .L14_3
.L14_11:
.L14_1:
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_13
	j .L14_14
.L14_13:
	lw s1, -4(s0)
	lw s2, -8(s0)
	addi s3, s0, -96
	lw s4, -100(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, rv_encode
	mv s6, a0
	sw s6, -104(s0)
	lw s1, -104(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L14_15
	j .L14_16
.L14_15:
	la s1, __str_51
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L14_16:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 552
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -104(s0)
	add s4, s1, s2
	sw s4, 0(s3)
	j .L14_17
.L14_14:
	lw s1, -4(s0)
	lw s2, -8(s0)
	addi s3, s0, -96
	lw s4, -100(s0)
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, rv_encode
	mv s6, a0
	sw s6, -104(s0)
	lw s1, -104(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L14_18
	j .L14_19
.L14_18:
	la s1, __str_52
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L14_19:
.L14_17:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	li s1, 0
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
.Lfunc_end14:
	.size parse_instruction, .Lfunc_end14-parse_instruction

	.text
	.align 2
	.type define_label, @function
define_label:
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
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_0
	j .L15_1
.L15_0:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -8(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_2
	j .L15_3
.L15_2:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -8(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -12(s0)
.L15_3:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s4, 552
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -4(s0)
	li s5, 328
	add s6, s4, s5
	lw s4, -4(s0)
	li s5, 552
	add s7, s4, s5
	lw s4, 0(s7)
	li s5, 32
	mul s7, s4, s5
	add s4, s6, s7
	li s5, 4
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	mv a3, s4
	jal ra, sym_define
	mv s5, a0
.L15_1:
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
	.size define_label, .Lfunc_end15-define_label

	.text
	.align 2
	.type run_pass, @function
run_pass:
	addi sp, sp, -800
	sw ra, 796(sp)
	sw s0, 792(sp)
	addi s0, sp, 792
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
	sw s1, -12(s0)
	li s1, 0
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -16(s0)
.L16_0:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 612
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L16_1
	j .L16_2
.L16_1:
	li s1, 0
	lw s2, -4(s0)
	li s3, 608
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -16(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
.L16_3:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L16_0
.L16_2:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L16_4:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 13
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L16_5
	j .L16_6
.L16_5:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_7
	j .L16_8
.L16_7:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	j .L16_4
.L16_8:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_9
	j .L16_10
.L16_9:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -12(s0)
	addi s2, s0, -352
	lw s3, 0(s1)
	sw s3, 0(s2)
	li s3, 4
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 4
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 8
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 8
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 12
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 12
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 16
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 16
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 20
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 20
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 24
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 24
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 28
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 28
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 32
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 32
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 36
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 36
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 40
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 40
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 44
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 44
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 48
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 48
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 52
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 52
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 56
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 56
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 60
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 60
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 64
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 64
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 68
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 68
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 72
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 72
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 76
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 76
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 80
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 80
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 84
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 84
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 88
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 88
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 92
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 92
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 96
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 96
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 100
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 100
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 104
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 104
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 108
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 108
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 112
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 112
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 116
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 116
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 120
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 120
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 124
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 124
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 128
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 128
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 132
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 132
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 136
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 136
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 140
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 140
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 144
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 144
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 148
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 148
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 152
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 152
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 156
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 156
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 160
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 160
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 164
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 164
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 168
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 168
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 172
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 172
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 176
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 176
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 180
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 180
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 184
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 184
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 188
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 188
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 192
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 192
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 196
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 196
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 200
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 200
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 204
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 204
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 208
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 208
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 212
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 212
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 216
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 216
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 220
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 220
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 224
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 224
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 228
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 228
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 232
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 232
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 236
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 236
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 240
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 240
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 244
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 244
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 248
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 248
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 252
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 252
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 256
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 256
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 260
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 260
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 264
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 264
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 268
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 268
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 272
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 272
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 276
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 276
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 280
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 280
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 284
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 284
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 288
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 288
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 292
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 292
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 296
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 296
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 300
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 300
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 304
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 304
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 308
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 308
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 312
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 312
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 316
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 316
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 320
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 320
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 324
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 324
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_11
	j .L16_12
.L16_11:
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L16_13
	j .L16_12
.L16_13:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, numlabel_count
	mv s3, a0
	sw s3, -388(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 572
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_14
	j .L16_15
.L16_14:
	addi s1, s0, -384
	li s2, 32
	la s3, __str_53
	lw s4, -20(s0)
	lw s5, -388(s0)
	lw s6, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s6, 4(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	addi s1, s0, -384
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -392(s0)
	lw s1, -392(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L16_16
	j .L16_17
.L16_16:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	addi s1, s0, -384
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -392(s0)
.L16_17:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -392(s0)
	lw s2, -4(s0)
	li s4, 552
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -4(s0)
	li s5, 328
	add s6, s4, s5
	lw s4, -4(s0)
	li s5, 552
	add s7, s4, s5
	lw s4, 0(s7)
	li s5, 32
	mul s7, s4, s5
	add s4, s6, s7
	li s5, 4
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	mv a3, s4
	jal ra, sym_define
	mv s5, a0
.L16_15:
	lw s1, -388(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L16_4
.L16_12:
	lw s1, -12(s0)
	addi s2, s0, -352
	mv a0, s1
	mv a1, s2
	jal ra, lex_restore
	mv s3, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_18
	j .L16_19
.L16_18:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L16_19:
	j .L16_4
.L16_10:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_20
	j .L16_21
.L16_20:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -396(s0)
	lw s1, -12(s0)
	addi s2, s0, -728
	lw s3, 0(s1)
	sw s3, 0(s2)
	li s3, 4
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 4
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 8
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 8
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 12
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 12
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 16
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 16
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 20
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 20
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 24
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 24
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 28
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 28
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 32
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 32
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 36
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 36
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 40
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 40
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 44
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 44
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 48
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 48
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 52
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 52
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 56
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 56
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 60
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 60
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 64
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 64
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 68
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 68
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 72
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 72
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 76
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 76
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 80
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 80
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 84
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 84
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 88
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 88
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 92
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 92
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 96
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 96
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 100
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 100
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 104
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 104
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 108
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 108
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 112
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 112
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 116
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 116
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 120
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 120
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 124
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 124
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 128
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 128
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 132
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 132
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 136
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 136
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 140
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 140
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 144
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 144
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 148
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 148
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 152
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 152
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 156
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 156
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 160
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 160
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 164
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 164
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 168
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 168
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 172
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 172
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 176
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 176
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 180
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 180
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 184
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 184
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 188
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 188
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 192
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 192
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 196
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 196
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 200
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 200
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 204
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 204
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 208
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 208
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 212
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 212
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 216
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 216
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 220
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 220
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 224
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 224
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 228
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 228
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 232
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 232
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 236
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 236
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 240
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 240
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 244
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 244
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 248
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 248
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 252
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 252
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 256
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 256
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 260
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 260
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 264
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 264
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 268
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 268
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 272
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 272
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 276
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 276
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 280
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 280
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 284
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 284
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 288
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 288
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 292
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 292
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 296
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 296
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 300
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 300
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 304
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 304
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 308
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 308
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 312
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 312
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 316
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 316
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 320
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 320
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 324
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 324
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_22
	j .L16_23
.L16_22:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -396(s0)
	mv a0, s1
	mv a1, s2
	jal ra, define_label
	mv s3, a0
	j .L16_4
.L16_23:
	lw s1, -12(s0)
	addi s2, s0, -728
	mv a0, s1
	mv a1, s2
	jal ra, lex_restore
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -396(s0)
	mv a0, s1
	mv a1, s2
	jal ra, handle_directive
	mv s3, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_24
	j .L16_25
.L16_24:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L16_25:
	j .L16_4
.L16_21:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_26
	j .L16_27
.L16_26:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -732(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_28
	j .L16_29
.L16_28:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -732(s0)
	mv a0, s1
	mv a1, s2
	jal ra, define_label
	mv s3, a0
	j .L16_4
.L16_29:
	lw s1, -4(s0)
	lw s2, -732(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_instruction
	mv s3, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_30
	j .L16_31
.L16_30:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L16_31:
	j .L16_4
.L16_27:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_to_eol
	mv s2, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_32
	j .L16_33
.L16_32:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lex_next
	mv s2, a0
.L16_33:
	j .L16_4
.L16_6:
	li s1, 0
	mv a0, s1
	lw s1, -780(s0)
	lw s2, -776(s0)
	lw s3, -772(s0)
	lw s4, -768(s0)
	lw s5, -764(s0)
	lw s6, -760(s0)
	lw s7, -756(s0)
	lw s8, -752(s0)
	lw s9, -748(s0)
	lw s10, -744(s0)
	lw s11, -740(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end16:
	.size run_pass, .Lfunc_end16-run_pass

	.text
	.align 2
	.globl rv_note_branch
	.type rv_note_branch, @function
rv_note_branch:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	li s2, 584
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 588
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L17_0
	j .L17_1
.L17_0:
	lw s1, -4(s0)
	li s2, 588
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L17_2
	j .L17_3
.L17_2:
	lw s1, -4(s0)
	li s2, 588
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -20(s0)
	j .L17_4
.L17_3:
	li s1, 64
	sw s1, -20(s0)
.L17_4:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 588
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 580
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 588
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 12
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, realloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 580
	add s4, s1, s3
	sw s2, 0(s4)
.L17_1:
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 580
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 584
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 580
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 584
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 580
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 584
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 584
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end17:
	.size rv_note_branch, .Lfunc_end17-rv_note_branch

	.text
	.align 2
	.type sizing_pass, @function
sizing_pass:
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
.L18_0:
	lw s1, -12(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L18_1
	j .L18_2
.L18_1:
	li s1, 0
	lw s2, -4(s0)
	li s3, 328
	add s4, s2, s3
	lw s2, -12(s0)
	li s3, 32
	mul s5, s2, s3
	add s2, s4, s5
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
.L18_3:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L18_0
.L18_2:
	li s1, 1
	lw s2, -4(s0)
	li s3, 572
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 604
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 600
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 584
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_rewind
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, run_pass
	mv s2, a0
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
.Lfunc_end18:
	.size sizing_pass, .Lfunc_end18-sizing_pass

	.text
	.align 2
	.type relax_measure, @function
relax_measure:
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
	li s1, 0
	sw s1, -16(s0)
.L19_0:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 584
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L19_1
	j .L19_2
.L19_1:
	lw s1, -4(s0)
	li s2, 580
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 12
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -20(s0)
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -20(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -4(s0)
	li s2, 592
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	bnez s1, .L19_3
	j .L19_4
.L19_3:
	j .L19_5
.L19_4:
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L19_6
	j .L19_7
.L19_7:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L19_8
	j .L19_6
.L19_8:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -20(s0)
	lw s3, 0(s2)
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L19_6
	j .L19_9
.L19_6:
	j .L19_5
.L19_9:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	sub s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 4096
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L19_10
	j .L19_11
.L19_11:
	lw s1, -28(s0)
	li s2, 4094
	slt s3, s2, s1
	bnez s3, .L19_10
	j .L19_12
.L19_10:
	li s1, 1
	lw s2, -4(s0)
	li s3, 592
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -16(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 1
	sw s1, -12(s0)
.L19_12:
.L19_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L19_0
.L19_2:
	lw s1, -12(s0)
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
.Lfunc_end19:
	.size relax_measure, .Lfunc_end19-relax_measure

	.text
	.align 2
	.globl rv_init
	.type rv_init, @function
rv_init:
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
	li s2, 0
	li s3, 644
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	mv a0, s3
	jal ra, arena_init
	mv s1, a0
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 40
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 556
	add s4, s1, s2
	li s1, 12
	add s2, s4, s1
	sw s3, 0(s2)
	li s1, 0
	sw s1, -12(s0)
.L20_0:
	lw s1, -12(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L20_1
	j .L20_2
.L20_1:
	li s1, 1
	lw s2, -4(s0)
	li s3, 328
	add s4, s2, s3
	lw s2, -12(s0)
	li s3, 32
	mul s5, s2, s3
	add s2, s4, s5
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L20_3:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L20_0
.L20_2:
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	lw s1, -8(s0)
	mv a0, s3
	mv a1, s1
	jal ra, rv_expand_macros
	mv s2, a0
	sw s2, -8(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 35
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, lex_init
	mv s5, a0
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
	.size rv_init, .Lfunc_end20-rv_init

	.text
	.align 2
	.globl rv_free
	.type rv_free, @function
rv_free:
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
.L21_0:
	lw s1, -12(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L21_1
	j .L21_2
.L21_1:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L21_3:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L21_0
.L21_2:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 580
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 592
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 608
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 624
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 636
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
.Lfunc_end21:
	.size rv_free, .Lfunc_end21-rv_free

	.text
	.align 2
	.globl rv_emit_debug
	.type rv_emit_debug, @function
rv_emit_debug:
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
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	sw s3, -12(s0)
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 4
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 5
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 6
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -24(s0)
	lw s1, -4(s0)
	li s2, 620
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L22_0
	j .L22_1
.L22_0:
	lw s1, -4(s0)
	li s2, 620
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L22_2
.L22_1:
	la s1, __str_54
	sw s1, -32(s0)
.L22_2:
	lw s1, -32(s0)
	sw s1, -28(s0)
	lw s1, -4(s0)
	li s2, 628
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_3
	j .L22_4
.L22_3:
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
.L22_4:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	la s1, __str_55
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -68(s0)
	lw s1, -68(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L22_5
	j .L22_6
.L22_5:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	la s1, __str_56
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -68(s0)
.L22_6:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -68(s0)
	li s2, 0
	li s4, 0
	mv a0, s3
	mv a1, s1
	mv a2, s2
	mv a3, s4
	jal ra, sym_define
	mv s5, a0
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 628
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	sw s2, -36(s0)
	li s1, 0
	sw s1, -72(s0)
.L22_7:
	lw s1, -72(s0)
	lw s2, -4(s0)
	li s3, 628
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L22_8
	j .L22_9
.L22_8:
	lw s1, -4(s0)
	li s2, 624
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -72(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -36(s0)
	lw s3, -72(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -4(s0)
	li s2, 624
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -72(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -36(s0)
	lw s3, -72(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
.L22_10:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -72(s0)
	j .L22_7
.L22_9:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 0
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -64(s0)
	lw s1, -12(s0)
	addi s2, s0, -28
	li s3, 1
	lw s4, -36(s0)
	lw s5, -4(s0)
	li s6, 628
	add s7, s5, s6
	lw s5, 0(s7)
	lw s6, -64(s0)
	addi s7, s0, -40
	addi s8, s0, -48
	li s9, 0
	li s10, 4
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	mv a7, s8
	sw s9, 0(sp)
	sw s10, 4(sp)
	jal ra, dw_line_build
	mv s11, a0
	addi sp, sp, 16
	sw s11, -44(s0)
	li s1, 0
	sw s1, -60(s0)
.L22_11:
	lw s1, -60(s0)
	lw s2, -44(s0)
	sltu s3, s1, s2
	bnez s3, .L22_12
	j .L22_13
.L22_12:
	lw s1, -16(s0)
	lw s2, -40(s0)
	lw s3, -60(s0)
	add s4, s2, s3
	lbu s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, sec_emit8
	mv s3, a0
.L22_14:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L22_11
.L22_13:
	lw s1, -16(s0)
	lw s2, -48(s0)
	lw s3, -68(s0)
	lw s4, -36(s0)
	li s5, 0
	li s6, 16
	mul s7, s5, s6
	add s5, s4, s7
	lw s4, 0(s5)
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, sec_add_reloc_t
	mv s6, a0
	lw s1, -12(s0)
	addi s2, s0, -40
	mv a0, s1
	mv a1, s2
	jal ra, dw_abbrev_build
	mv s3, a0
	sw s3, -44(s0)
	li s1, 0
	sw s1, -60(s0)
.L22_15:
	lw s1, -60(s0)
	lw s2, -44(s0)
	sltu s3, s1, s2
	bnez s3, .L22_16
	j .L22_17
.L22_16:
	lw s1, -24(s0)
	lw s2, -40(s0)
	lw s3, -60(s0)
	add s4, s2, s3
	lbu s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, sec_emit8
	mv s3, a0
.L22_18:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L22_15
.L22_17:
	lw s1, -12(s0)
	la s2, __str_57
	lw s3, -28(s0)
	la s4, __str_58
	li s5, 0
	lw s6, -64(s0)
	li s7, 0
	addi s8, s0, -40
	addi s9, s0, -52
	addi s10, s0, -56
	li s11, 0
	li t0, 4
	sw t0, -76(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	mv a7, s8
	sw s9, 0(sp)
	sw s10, 4(sp)
	sw s11, 8(sp)
	lw t0, -76(s0)
	sw t0, 12(sp)
	jal ra, dw_info_build
	mv t0, a0
	sw t0, -80(s0)
	addi sp, sp, 16
	lw t0, -80(s0)
	sw t0, -44(s0)
	li s1, 0
	sw s1, -60(s0)
.L22_19:
	lw s1, -60(s0)
	lw s2, -44(s0)
	sltu s3, s1, s2
	bnez s3, .L22_20
	j .L22_21
.L22_20:
	lw s1, -20(s0)
	lw s2, -40(s0)
	lw s3, -60(s0)
	add s4, s2, s3
	lbu s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, sec_emit8
	mv s3, a0
.L22_22:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L22_19
.L22_21:
	lw s1, -20(s0)
	lw s2, -52(s0)
	lw s3, -68(s0)
	li s4, 0
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, sec_add_reloc_t
	mv s6, a0
	lw s1, -20(s0)
	lw s2, -56(s0)
	lw s3, -68(s0)
	lw s4, -64(s0)
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, sec_add_reloc_t
	mv s6, a0
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
.Lfunc_end22:
	.size rv_emit_debug, .Lfunc_end22-rv_emit_debug

	.text
	.align 2
	.globl rv_assemble
	.type rv_assemble, @function
rv_assemble:
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
	mv a0, s1
	jal ra, sizing_pass
	mv s2, a0
	lw s1, -4(s0)
	li s2, 584
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 596
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 596
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L23_0
	j .L23_1
.L23_0:
	lw s1, -4(s0)
	li s2, 596
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L23_2
.L23_1:
	li s1, 1
	sw s1, -20(s0)
.L23_2:
	lw s1, -20(s0)
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, calloc
	mv s3, a0
	lw s1, -4(s0)
	li s2, 592
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 0
	sw s1, -12(s0)
.L23_3:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 596
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L23_4
	j .L23_5
.L23_4:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, relax_measure
	mv s2, a0
	bnez s2, .L23_6
	j .L23_7
.L23_7:
	j .L23_5
.L23_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, sizing_pass
	mv s2, a0
.L23_8:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L23_3
.L23_5:
	li s1, 0
	sw s1, -16(s0)
.L23_9:
	lw s1, -16(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L23_10
	j .L23_11
.L23_10:
	li s1, 0
	lw s2, -4(s0)
	li s3, 328
	add s4, s2, s3
	lw s2, -16(s0)
	li s3, 32
	mul s5, s2, s3
	add s2, s4, s5
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
.L23_12:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L23_9
.L23_11:
	li s1, 2
	lw s2, -4(s0)
	li s3, 572
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 604
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 600
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 576
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_rewind
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, run_pass
	mv s2, a0
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
.Lfunc_end23:
	.size rv_assemble, .Lfunc_end23-rv_assemble

	.data
	.align 2
__str_58:
	.ascii ".\000"
	.align 2
__str_57:
	.ascii "skjegg\000"
	.align 2
__str_56:
	.ascii ".Ldebug_text0\000"
	.align 2
__str_55:
	.ascii ".Ldebug_text0\000"
	.align 2
__str_54:
	.ascii "?\000"
	.align 2
__str_53:
	.ascii ".Lnum_%d_%d\000"
	.align 2
__str_52:
	.ascii "line %d: cannot encode '%s'\000"
	.align 2
__str_51:
	.ascii "line %d: cannot encode '%s'\000"
	.align 2
__str_50:
	.ascii "line %d: bad operand for '%s'\000"
	.align 2
__str_49:
	.ascii "line %d: too many operands for '%s'\000"
	.align 2
__str_48:
	.ascii "line %d: unknown directive '%s'\000"
	.align 2
__str_47:
	.ascii ".cfi_\000"
	.align 2
__str_46:
	.ascii ".local\000"
	.align 2
__str_45:
	.ascii ".attribute\000"
	.align 2
__str_44:
	.ascii ".ident\000"
	.align 2
__str_43:
	.ascii ".option\000"
	.align 2
__str_42:
	.ascii ".loc\000"
	.align 2
__str_41:
	.ascii ".file\000"
	.align 2
__str_40:
	.ascii ".\000"
	.align 2
__str_39:
	.ascii ".size\000"
	.align 2
__str_38:
	.ascii "function\000"
	.align 2
__str_37:
	.ascii ".type\000"
	.align 2
__str_36:
	.ascii ".skip\000"
	.align 2
__str_35:
	.ascii ".zero\000"
	.align 2
__str_34:
	.ascii ".space\000"
	.align 2
__str_33:
	.ascii ".string\000"
	.align 2
__str_32:
	.ascii ".asciz\000"
	.align 2
__str_31:
	.ascii ".ascii\000"
	.align 2
__str_30:
	.ascii ".byte\000"
	.align 2
__str_29:
	.ascii ".2byte\000"
	.align 2
__str_28:
	.ascii ".short\000"
	.align 2
__str_27:
	.ascii ".half\000"
	.align 2
__str_26:
	.ascii ".long\000"
	.align 2
__str_25:
	.ascii ".word\000"
	.align 2
__str_24:
	.ascii ".balign\000"
	.align 2
__str_23:
	.ascii ".p2align\000"
	.align 2
__str_22:
	.ascii ".align\000"
	.align 2
__str_21:
	.ascii ".weak\000"
	.align 2
__str_20:
	.ascii ".global\000"
	.align 2
__str_19:
	.ascii ".globl\000"
	.align 2
__str_18:
	.ascii ".bss\000"
	.align 2
__str_17:
	.ascii ".data\000"
	.align 2
__str_16:
	.ascii ".rodata\000"
	.align 2
__str_15:
	.ascii ".text\000"
	.align 2
__str_14:
	.ascii ".section\000"
	.align 2
__str_13:
	.ascii "line %d: cannot .include \"%s\"\000"
	.align 2
__str_12:
	.ascii "line %d: .include needs a \"file\" operand\000"
	.align 2
__str_11:
	.ascii ".include\000"
	.align 2
__str_10:
	.ascii ".sbss\000"
	.align 2
__str_9:
	.ascii ".bss\000"
	.align 2
__str_8:
	.ascii ".rodata\000"
	.align 2
__str_7:
	.ascii ".data\000"
	.align 2
__str_6:
	.ascii ".text\000"
	.align 2
__str_5:
	.ascii "pcrel_lo\000"
	.align 2
__str_4:
	.ascii "pcrel_hi\000"
	.align 2
__str_3:
	.ascii "lo\000"
	.align 2
__str_2:
	.ascii "hi\000"
	.align 2
__str_1:
	.ascii ".Lnum_%d_%d\000"
	.align 2
__str_0:
	.ascii "out of memory\000"
