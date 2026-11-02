# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type be32, @function
be32:
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
	li s2, 24
	sll s3, s1, s2
	lw s1, -4(s0)
	li s2, 1
	add s4, s1, s2
	lbu s1, 0(s4)
	li s2, 16
	sll s4, s1, s2
	or s1, s3, s4
	lw s2, -4(s0)
	li s3, 2
	add s4, s2, s3
	lbu s2, 0(s4)
	li s3, 8
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -4(s0)
	li s3, 3
	add s4, s1, s3
	lbu s1, 0(s4)
	or s3, s2, s1
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
.Lfunc_end1:
	.size be32, .Lfunc_end1-be32

	.text
	.align 2
	.type ar_num, @function
ar_num:
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
	li s1, 0
	sw s1, -16(s0)
.L2_0:
	lw s1, -16(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L2_1
	j .L2_2
.L2_1:
	lw s1, -4(s0)
	lw s2, -16(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 48
	slt s3, s1, s2
	bnez s3, .L2_3
	j .L2_4
.L2_4:
	lw s1, -4(s0)
	lw s2, -16(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 57
	slt s3, s2, s1
	bnez s3, .L2_3
	j .L2_5
.L2_3:
	j .L2_2
.L2_5:
	lw s1, -12(s0)
	li s2, 10
	mul s3, s1, s2
	lw s1, -4(s0)
	lw s2, -16(s0)
	add s4, s1, s2
	lbu s1, 0(s4)
	li s2, 48
	sub s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
.L2_6:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L2_0
.L2_2:
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
.Lfunc_end2:
	.size ar_num, .Lfunc_end2-ar_num

	.text
	.align 2
	.type member_name, @function
member_name:
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
	sw a4, -20(s0)
	li s1, 0
	sw s1, -92(s0)
	lw s1, -8(s0)
	li s2, 0
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_2
	j .L3_1
.L3_2:
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 57
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_3
	j .L3_1
.L3_3:
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	li s1, 15
	mv a0, s3
	mv a1, s1
	jal ra, ar_num
	mv s2, a0
	sw s2, -96(s0)
.L3_4:
	lw s1, -96(s0)
	lw s2, -92(s0)
	add s3, s1, s2
	lw s1, -16(s0)
	slt s2, s3, s1
	bnez s2, .L3_5
	j .L3_6
.L3_5:
	lw s1, -12(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	add s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 47
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_7
	j .L3_6
.L3_7:
	lw s1, -12(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	add s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_8
	j .L3_6
.L3_8:
	lw s1, -92(s0)
	li s2, 64
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L3_9
	j .L3_6
.L3_9:
	lw s1, -12(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	add s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	addi s2, s0, -88
	lw s3, -92(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -92
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -92(s0)
	j .L3_4
.L3_6:
	j .L3_10
.L3_1:
.L3_11:
	lw s1, -92(s0)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L3_12
	j .L3_13
.L3_12:
	lw s1, -8(s0)
	lw s2, -92(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_14
	j .L3_13
.L3_14:
	lw s1, -8(s0)
	lw s2, -92(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 32
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_15
	j .L3_13
.L3_15:
	lw s1, -92(s0)
	li s2, 64
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L3_16
	j .L3_13
.L3_16:
	lw s1, -8(s0)
	lw s2, -92(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -88
	lw s3, -92(s0)
	add s4, s1, s3
	sb s2, 0(s4)
	addi s1, s0, -92
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -92(s0)
	j .L3_11
.L3_13:
.L3_10:
	li s1, 0
	addi s2, s0, -88
	lw s3, -92(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	addi s1, s0, -88
	mv a0, s1
	jal ra, strlen
	mv s3, a0
	add s1, s2, s3
	li s2, 3
	add s3, s1, s2
	sw s3, -100(s0)
	lw s1, -4(s0)
	lw s2, -100(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -104(s0)
	lw s1, -104(s0)
	lw s2, -100(s0)
	la s3, __str_0
	lw s4, -20(s0)
	addi s5, s0, -88
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, snprintf
	mv s6, a0
	addi sp, sp, 16
	lw s1, -104(s0)
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
.Lfunc_end3:
	.size member_name, .Lfunc_end3-member_name

	.text
	.align 2
	.globl rv_ld_archive_reset
	.type rv_ld_archive_reset, @function
rv_ld_archive_reset:
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
	la s1, g_loaded
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li s1, 0
	la s2, g_loaded
	sw s1, 0(s2)
	li s1, 0
	la s2, g_nloaded
	sw s1, 0(s2)
	li s1, 0
	la s2, g_loaded_cap
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
.Lfunc_end4:
	.size rv_ld_archive_reset, .Lfunc_end4-rv_ld_archive_reset

	.text
	.align 2
	.type member_seen, @function
member_seen:
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
.L5_0:
	lw s1, -12(s0)
	la s2, g_nloaded
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L5_1
	j .L5_2
.L5_1:
	la s1, g_loaded
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 8
	mul s4, s1, s3
	add s1, s2, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_3
	j .L5_4
.L5_3:
	la s1, g_loaded
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 8
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_5
	j .L5_4
.L5_5:
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
.L5_4:
.L5_6:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L5_0
.L5_2:
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
.Lfunc_end5:
	.size member_seen, .Lfunc_end5-member_seen

	.text
	.align 2
	.type member_mark, @function
member_mark:
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
	la s1, g_nloaded
	lw s2, 0(s1)
	la s1, g_loaded_cap
	lw s3, 0(s1)
	slt s1, s2, s3
	xori s1, s1, 1
	bnez s1, .L6_0
	j .L6_1
.L6_0:
	la s1, g_loaded_cap
	lw s2, 0(s1)
	bnez s2, .L6_2
	j .L6_3
.L6_2:
	la s1, g_loaded_cap
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -12(s0)
	j .L6_4
.L6_3:
	li s1, 16
	sw s1, -12(s0)
.L6_4:
	lw s1, -12(s0)
	la s2, g_loaded_cap
	sw s1, 0(s2)
	la s1, g_loaded
	lw s2, 0(s1)
	la s1, g_loaded_cap
	lw s3, 0(s1)
	li s1, 8
	mul s4, s3, s1
	mv a0, s2
	mv a1, s4
	jal ra, realloc
	mv s1, a0
	la s2, g_loaded
	sw s1, 0(s2)
	la s1, g_loaded
	lw s2, 0(s1)
	bnez s2, .L6_5
	j .L6_6
.L6_6:
	la s1, __str_1
	mv a0, s1
	jal ra, die
	mv s2, a0
.L6_5:
.L6_1:
	lw s1, -4(s0)
	la s2, g_loaded
	lw s3, 0(s2)
	la s2, g_nloaded
	lw s4, 0(s2)
	li s2, 8
	mul s5, s4, s2
	add s2, s3, s5
	sw s1, 0(s2)
	lw s1, -8(s0)
	la s2, g_loaded
	lw s3, 0(s2)
	la s2, g_nloaded
	lw s4, 0(s2)
	li s2, 8
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, g_nloaded
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
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
.Lfunc_end6:
	.size member_mark, .Lfunc_end6-member_mark

	.text
	.align 2
	.type sym_needed, @function
sym_needed:
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
	li s1, 0
	sw s1, -12(s0)
	li s1, 0
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L7_0:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L7_1
	j .L7_2
.L7_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -20(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -24(s0)
	li s1, 0
	sw s1, -28(s0)
.L7_3:
	lw s1, -28(s0)
	lw s2, -24(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L7_4
	j .L7_5
.L7_4:
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_6
	j .L7_7
.L7_7:
	lw s1, -32(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L7_6
	j .L7_8
.L7_6:
	j .L7_9
.L7_8:
	lw s1, -32(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_10
	j .L7_11
.L7_10:
	li s1, 1
	sw s1, -12(s0)
	j .L7_12
.L7_11:
	li s1, 1
	sw s1, -16(s0)
.L7_12:
.L7_9:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L7_3
.L7_5:
.L7_13:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L7_0
.L7_2:
	lw s1, -12(s0)
	bnez s1, .L7_14
	j .L7_15
.L7_14:
	lw s1, -16(s0)
	bnez s1, .L7_15
	j .L7_16
.L7_16:
	li s1, 1
	j .L7_17
.L7_15:
	li s1, 0
.L7_17:
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
.Lfunc_end7:
	.size sym_needed, .Lfunc_end7-sym_needed

	.text
	.align 2
	.globl rv_ld_is_archive
	.type rv_ld_is_archive, @function
rv_ld_is_archive:
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
	lw s1, -4(s0)
	la s2, __str_2
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L8_0
	j .L8_1
.L8_1:
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
.L8_0:
	addi s1, s0, -24
	li s2, 1
	li s3, 8
	lw s4, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fread
	mv s5, a0
	sw s5, -28(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	lw s1, -28(s0)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_2
	j .L8_3
.L8_2:
	addi s1, s0, -24
	la s2, __str_3
	li s3, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L8_4
	j .L8_3
.L8_4:
	li s1, 1
	j .L8_5
.L8_3:
	li s1, 0
.L8_5:
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
.Lfunc_end8:
	.size rv_ld_is_archive, .Lfunc_end8-rv_ld_is_archive

	.text
	.align 2
	.globl rv_ld_read_archive
	.type rv_ld_read_archive, @function
rv_ld_read_archive:
	addi sp, sp, -224
	sw ra, 220(sp)
	sw s0, 216(sp)
	addi s0, sp, 216
	sw s1, 0(sp)
	sw s2, 4(sp)
	sw s3, 8(sp)
	sw s4, 12(sp)
	sw s5, 16(sp)
	sw s6, 20(sp)
	sw s7, 24(sp)
	sw s8, 28(sp)
	sw s9, 32(sp)
	sw s10, 36(sp)
	sw s11, 40(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -40(s0)
	li s1, 0
	sw s1, -44(s0)
	addi s1, s0, -16
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, mapfile_open
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L9_0
	j .L9_1
.L9_0:
	la s1, __str_4
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_1:
	addi s1, s0, -16
	lw s2, 0(s1)
	sw s2, -20(s0)
	addi s1, s0, -16
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 8
	sltu s3, s1, s2
	bnez s3, .L9_2
	j .L9_3
.L9_3:
	lw s1, -20(s0)
	la s2, __str_5
	li s3, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv t0, a0
	sw t0, -124(s0)
	li s1, 0
	lw t0, -124(s0)
	xor s2, t0, s1
	snez s2, s2
	bnez s2, .L9_2
	j .L9_4
.L9_2:
	la s1, __str_6
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_4:
	li s1, 8
	sw s1, -48(s0)
.L9_5:
	lw s1, -48(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, -24(s0)
	sltu s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L9_6
	j .L9_7
.L9_6:
	lw s1, -20(s0)
	lw s2, -48(s0)
	add s3, s1, s2
	sw s3, -52(s0)
	lw s1, -52(s0)
	li s2, 48
	add s3, s1, s2
	li s1, 10
	mv a0, s3
	mv a1, s1
	jal ra, ar_num
	mv s2, a0
	sw s2, -56(s0)
	lw s1, -52(s0)
	li s2, 0
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_8
	j .L9_9
.L9_8:
	lw s1, -52(s0)
	li s2, 1
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_10
	j .L9_9
.L9_10:
	lw s1, -20(s0)
	lw s2, -48(s0)
	add s3, s1, s2
	li s1, 60
	add s2, s3, s1
	sw s2, -28(s0)
	lw s1, -56(s0)
	sw s1, -32(s0)
	j .L9_11
.L9_9:
	lw s1, -52(s0)
	li s2, 0
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_12
	j .L9_13
.L9_12:
	lw s1, -52(s0)
	li s2, 1
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_14
	j .L9_13
.L9_14:
	lw s1, -20(s0)
	lw s2, -48(s0)
	add s3, s1, s2
	li s1, 60
	add s2, s3, s1
	sw s2, -36(s0)
	lw s1, -56(s0)
	sw s1, -40(s0)
.L9_13:
.L9_11:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 60
	lw s3, -56(s0)
	add t0, s1, s3
	sw t0, -128(s0)
	lw t1, -128(s0)
	add s1, s2, t1
	sw s1, -48(s0)
	lw s1, -56(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L9_15
	j .L9_16
.L9_15:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
.L9_16:
.L9_17:
	j .L9_5
.L9_7:
	lw s1, -28(s0)
	bnez s1, .L9_18
	j .L9_19
.L9_18:
	lw s1, -32(s0)
	li s2, 4
	sltu s3, s1, s2
	bnez s3, .L9_19
	j .L9_20
.L9_19:
	la s1, __str_7
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_20:
	lw s1, -28(s0)
	lw s2, -20(s0)
	sub s3, s1, s2
	lw s1, -32(s0)
	add s2, s3, s1
	lw s1, -24(s0)
	sltu s3, s1, s2
	bnez s3, .L9_21
	j .L9_22
.L9_21:
	la s1, __str_8
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_22:
	lw s1, -36(s0)
	bnez s1, .L9_23
	j .L9_24
.L9_23:
	lw s1, -36(s0)
	lw s2, -20(s0)
	sub s3, s1, s2
	lw s1, -40(s0)
	add s2, s3, s1
	lw s1, -24(s0)
	sltu s3, s1, s2
	bnez s3, .L9_25
	j .L9_24
.L9_25:
	la s1, __str_9
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_24:
	lw s1, -28(s0)
	mv a0, s1
	jal ra, be32
	mv s2, a0
	sw s2, -60(s0)
	li s1, 4
	mv s10, s1
	srai s11, s10, 31
	lw s1, -60(s0)
	mv s8, s1
	li s9, 0
	li s1, 4
	mv s6, s1
	srai s7, s6, 31
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -8
	sw s6, 0(sp)
	sw s7, 4(sp)
	jal ra, __muldi3
	addi sp, sp, 16
	mv s4, a0
	mv s5, a1
	add s8, s10, s4
	sltu t0, s8, s4
	add s9, s11, t0
	add s9, s9, s5
	lw s1, -32(s0)
	mv s10, s1
	li s11, 0
	sltu s1, s11, s9
	bne s11, s9, .L9_26
	sltu s1, s10, s8
.L9_26:
	bnez s1, .L9_27
	j .L9_28
.L9_27:
	la s1, __str_10
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_28:
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	sw s3, -64(s0)
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, -60(s0)
	li s2, 4
	mul t0, s1, s2
	sw t0, -132(s0)
	lw t1, -132(s0)
	add s1, s3, t1
	sw s1, -68(s0)
	lw s1, -28(s0)
	lw s2, -32(s0)
	add s3, s1, s2
	sw s3, -72(s0)
	li s1, 1
	sw s1, -76(s0)
.L9_29:
	lw s1, -76(s0)
	bnez s1, .L9_30
	j .L9_31
.L9_30:
	li s1, 0
	sw s1, -76(s0)
	lw s1, -68(s0)
	sw s1, -80(s0)
	li s1, 0
	sw s1, -84(s0)
.L9_32:
	lw s1, -84(s0)
	lw s2, -60(s0)
	sltu s3, s1, s2
	bnez s3, .L9_33
	j .L9_34
.L9_33:
	lw s1, -80(s0)
	sw s1, -88(s0)
	lw s1, -80(s0)
	li t0, 0
	sw t0, -136(s0)
	lw s3, -72(s0)
	lw s2, -80(s0)
	sub t0, s3, s2
	sw t0, -140(s0)
	mv a0, s1
	lw t0, -136(s0)
	mv a1, t0
	lw t0, -140(s0)
	mv a2, t0
	jal ra, memchr
	mv s2, a0
	sw s2, -92(s0)
	lw s1, -92(s0)
	bnez s1, .L9_35
	j .L9_36
.L9_36:
	la s1, __str_11
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_35:
	lw s1, -92(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -80(s0)
	lw s1, -4(s0)
	lw s2, -88(s0)
	mv a0, s1
	mv a1, s2
	jal ra, sym_needed
	mv s3, a0
	bnez s3, .L9_37
	j .L9_38
.L9_38:
	j .L9_39
.L9_37:
	lw s1, -64(s0)
	lw s2, -84(s0)
	li s3, 4
	mul t0, s2, s3
	sw t0, -144(s0)
	lw t1, -144(s0)
	add s2, s1, t1
	mv a0, s2
	jal ra, be32
	mv s1, a0
	sw s1, -96(s0)
	lw s1, -8(s0)
	lw s2, -96(s0)
	mv a0, s1
	mv a1, s2
	jal ra, member_seen
	mv s3, a0
	bnez s3, .L9_40
	j .L9_41
.L9_40:
	j .L9_39
.L9_41:
	lw s1, -96(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, -24(s0)
	sltu s2, s1, s3
	bnez s2, .L9_42
	j .L9_43
.L9_42:
	la s1, __str_12
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_43:
	lw s1, -20(s0)
	lw s2, -96(s0)
	add s3, s1, s2
	sw s3, -100(s0)
	lw s1, -100(s0)
	li s2, 48
	add s3, s1, s2
	li s1, 10
	mv a0, s3
	mv a1, s1
	jal ra, ar_num
	mv s2, a0
	sw s2, -104(s0)
	lw s1, -96(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, -104(s0)
	add s2, s3, s1
	lw s1, -24(s0)
	sltu s3, s1, s2
	bnez s3, .L9_44
	j .L9_45
.L9_44:
	la s1, __str_13
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_45:
	lw s1, -4(s0)
	li s2, 6204
	add s3, s1, s2
	lw s1, -104(s0)
	mv a0, s3
	mv a1, s1
	jal ra, arena_alloc
	mv s2, a0
	sw s2, -108(s0)
	lw t0, -108(s0)
	sw t0, -148(s0)
	lw s2, -20(s0)
	lw s3, -96(s0)
	add s1, s2, s3
	li s2, 60
	add s3, s1, s2
	lw s1, -104(s0)
	lw t0, -148(s0)
	mv a0, t0
	mv a1, s3
	mv a2, s1
	jal ra, memcpy
	mv s2, a0
	lw s1, -4(s0)
	li s2, 6204
	add s3, s1, s2
	lw s1, -100(s0)
	lw s2, -36(s0)
	lw t0, -40(s0)
	sw t0, -152(s0)
	lw t0, -8(s0)
	sw t0, -156(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	lw t0, -152(s0)
	mv a3, t0
	lw t0, -156(s0)
	mv a4, t0
	jal ra, member_name
	mv t0, a0
	sw t0, -160(s0)
	lw t0, -160(s0)
	sw t0, -112(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, ld_add_object
	mv s2, a0
	sw s2, -116(s0)
	lw s1, -4(s0)
	li s2, 6204
	add s3, s1, s2
	lw s1, -116(s0)
	lw s2, -108(s0)
	lw t0, -104(s0)
	sw t0, -164(s0)
	lw t0, -112(s0)
	sw t0, -168(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	lw t0, -164(s0)
	mv a3, t0
	lw t0, -168(s0)
	mv a4, t0
	jal ra, rv_parse_elf
	mv t0, a0
	sw t0, -172(s0)
	lw s1, -8(s0)
	lw s2, -96(s0)
	mv a0, s1
	mv a1, s2
	jal ra, member_mark
	mv s3, a0
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	li s1, 1
	sw s1, -76(s0)
.L9_39:
	addi s1, s0, -84
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -84(s0)
	j .L9_32
.L9_34:
	j .L9_29
.L9_31:
	addi s1, s0, -16
	mv a0, s1
	jal ra, mapfile_close
	mv s2, a0
	lw s1, -44(s0)
	mv a0, s1
	lw s1, -216(s0)
	lw s2, -212(s0)
	lw s3, -208(s0)
	lw s4, -204(s0)
	lw s5, -200(s0)
	lw s6, -196(s0)
	lw s7, -192(s0)
	lw s8, -188(s0)
	lw s9, -184(s0)
	lw s10, -180(s0)
	lw s11, -176(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end9:
	.size rv_ld_read_archive, .Lfunc_end9-rv_ld_read_archive

	.data
	.align 2
__str_13:
	.ascii "%s: member overruns the archive\000"
	.align 2
__str_12:
	.ascii "%s: bad member offset in symbol index\000"
	.align 2
__str_11:
	.ascii "%s: unterminated name in symbol index\000"
	.align 2
__str_10:
	.ascii "%s: symbol index count exceeds its member\000"
	.align 2
__str_9:
	.ascii "%s: long-name table runs past the end of the archive\000"
	.align 2
__str_8:
	.ascii "%s: symbol index runs past the end of the archive\000"
	.align 2
__str_7:
	.ascii "%s: no symbol index (build the archive with 'ar rcs' or ranlib)\000"
	.align 2
__str_6:
	.ascii "%s: not an ar archive\000"
	.align 2
__str_5:
	.ascii "!<arch>\n\000"
	.align 2
__str_4:
	.ascii "cannot open %s\000"
	.align 2
__str_3:
	.ascii "!<arch>\n\000"
	.align 2
__str_2:
	.ascii "rb\000"
	.align 2
__str_1:
	.ascii "out of memory\000"
	.align 2
__str_0:
	.ascii "%s(%s)\000"

	.bss
	.align 2
	.globl g_loaded_cap
g_loaded_cap:
	.space 4
	.align 2
	.globl g_nloaded
g_nloaded:
	.space 4
	.align 2
	.globl g_loaded
g_loaded:
	.space 4
