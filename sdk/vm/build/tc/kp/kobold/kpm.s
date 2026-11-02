# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type kpm_is_arch_tag, @function
kpm_is_arch_tag:
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
	la s2, __str_141
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_0
	j .L1_1
.L1_1:
	lw s1, -4(s0)
	la s2, __str_142
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_0
	j .L1_2
.L1_2:
	lw s1, -4(s0)
	la s2, __str_143
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_0
	j .L1_3
.L1_3:
	lw s1, -4(s0)
	la s2, __str_144
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_0
	j .L1_4
.L1_4:
	lw s1, -4(s0)
	la s2, __str_145
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_0
	j .L1_5
.L1_5:
	lw s1, -4(s0)
	la s2, __str_146
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_0
	j .L1_6
.L1_0:
	li s1, 1
	j .L1_7
.L1_6:
	li s1, 0
.L1_7:
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
	.size kpm_is_arch_tag, .Lfunc_end1-kpm_is_arch_tag

	.text
	.align 2
	.globl kpm_op_name
	.type kpm_op_name, @function
kpm_op_name:
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
.L2_0:
	lw s1, -12(s0)
	la s2, op_count
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L2_1
	j .L2_2
.L2_1:
	la s1, op_table
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -4(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_3
	j .L2_4
.L2_3:
	la s1, op_table
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.L2_4:
.L2_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L2_0
.L2_2:
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
.Lfunc_end2:
	.size kpm_op_name, .Lfunc_end2-kpm_op_name

	.text
	.align 2
	.type op_needs_slot, @function
op_needs_slot:
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
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_0
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_1
	li s2, 28
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_2
	li s2, 29
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_3
	li s2, 112
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_4
	li s2, 113
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_5
	li s2, 80
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_6
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_7
	li s2, 135
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_8
	li s2, 136
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_9
	li s2, 125
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_10
	li s2, 126
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_11
	li s2, 55
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_12
	li s2, 58
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_13
	j .L3_14
.L3_0:
.L3_1:
.L3_2:
.L3_3:
.L3_4:
.L3_5:
.L3_6:
.L3_7:
.L3_8:
.L3_9:
.L3_10:
.L3_11:
.L3_12:
.L3_13:
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
.L3_14:
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
.L3_15:
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
.Lfunc_end3:
	.size op_needs_slot, .Lfunc_end3-op_needs_slot

	.text
	.align 2
	.type op_needs_label, @function
op_needs_label:
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
	li s2, 41
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_0
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_1
	li s2, 43
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_2
	li s2, 54
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_3
	li s2, 137
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_4
	li s2, 139
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_5
	j .L4_6
.L4_0:
.L4_1:
.L4_2:
.L4_3:
.L4_4:
.L4_5:
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
.L4_6:
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
.L4_7:
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
.Lfunc_end4:
	.size op_needs_label, .Lfunc_end4-op_needs_label

	.text
	.align 2
	.type op_by_name, @function
op_by_name:
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
.L5_0:
	lw s1, -12(s0)
	la s2, op_count
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L5_1
	j .L5_2
.L5_1:
	la s1, op_table
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_3
	j .L5_4
.L5_3:
	la s1, op_table
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
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
.L5_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L5_0
.L5_2:
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
.Lfunc_end5:
	.size op_by_name, .Lfunc_end5-op_by_name

	.text
	.align 2
	.type base_type_by_name, @function
base_type_by_name:
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
	la s2, __str_147
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L6_0
	j .L6_1
.L6_0:
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
.L6_1:
	lw s1, -4(s0)
	la s2, __str_148
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L6_2
	j .L6_3
.L6_2:
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
.L6_3:
	lw s1, -4(s0)
	la s2, __str_149
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L6_4
	j .L6_5
.L6_4:
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
.L6_5:
	lw s1, -4(s0)
	la s2, __str_150
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L6_6
	j .L6_7
.L6_6:
	li s1, 5
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
.L6_7:
	lw s1, -4(s0)
	la s2, __str_151
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L6_8
	j .L6_9
.L6_8:
	li s1, 6
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
.L6_9:
	lw s1, -4(s0)
	la s2, __str_152
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L6_10
	j .L6_11
.L6_10:
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
.L6_11:
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
.Lfunc_end6:
	.size base_type_by_name, .Lfunc_end6-base_type_by_name

	.text
	.align 2
	.type tokenize, @function
tokenize:
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
	lw s1, -4(s0)
	sw s1, -16(s0)
.L7_0:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L7_1
	j .L7_2
.L7_1:
.L7_3:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_4
	j .L7_5
.L7_5:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_4
	j .L7_6
.L7_4:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L7_3
.L7_6:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L7_7
	j .L7_8
.L7_8:
	j .L7_2
.L7_7:
	lw s1, -12(s0)
	li s2, 64
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_9
	j .L7_10
.L7_9:
	j .L7_2
.L7_10:
	lw s1, -16(s0)
	lw s2, -8(s0)
	addi s3, s0, -12
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -12(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L7_11:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L7_12
	j .L7_13
.L7_12:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L7_14
	j .L7_13
.L7_14:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L7_15
	j .L7_13
.L7_15:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L7_11
.L7_13:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L7_16
	j .L7_17
.L7_16:
	li s1, 0
	addi s2, s0, -16
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -16(s0)
	sb s1, 0(s3)
.L7_17:
	j .L7_0
.L7_2:
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
.Lfunc_end7:
	.size tokenize, .Lfunc_end7-tokenize

	.text
	.align 2
	.type kw, @function
kw:
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
	jal ra, strlen
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L8_0
	j .L8_1
.L8_0:
	lw s1, -4(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_2
	j .L8_3
.L8_3:
	lw s1, -4(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_2
	j .L8_4
.L8_4:
	lw s1, -4(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_2
	j .L8_1
.L8_2:
	li s1, 1
	j .L8_5
.L8_1:
	li s1, 0
.L8_5:
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
.Lfunc_end8:
	.size kw, .Lfunc_end8-kw

	.text
	.align 2
	.type parse_signature, @function
parse_signature:
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
	sw a4, -20(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	lw s2, -20(s0)
	sw s1, 0(s2)
.L9_0:
	lw s1, -28(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L9_1
	j .L9_2
.L9_1:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_153
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L9_3
	j .L9_2
.L9_3:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L9_0
.L9_2:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
.L9_4:
	lw s1, -28(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L9_5
	j .L9_6
.L9_5:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_154
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L9_7
	j .L9_6
.L9_7:
	lw s1, -32(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L9_8
	j .L9_9
.L9_8:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -12(s0)
	addi s3, s0, -32
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -32(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L9_9:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L9_4
.L9_6:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	lw s1, -28(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L9_10
	j .L9_11
.L9_10:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_155
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L9_12
	j .L9_11
.L9_12:
	lw s1, -28(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -8(s0)
	slt s2, s3, s1
	bnez s2, .L9_13
	j .L9_11
.L9_13:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 1
	add s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	lw s2, -20(s0)
	sw s1, 0(s2)
.L9_11:
	lw s1, -32(s0)
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
.Lfunc_end9:
	.size parse_signature, .Lfunc_end9-parse_signature

	.text
	.align 2
	.type fail, @function
fail:
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
	sw a2, -12(s0)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L10_0
	j .L10_1
.L10_0:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L10_2
	j .L10_1
.L10_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	la s3, __str_156
	lw s4, -8(s0)
	lw s5, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, snprintf
	mv s6, a0
	addi sp, sp, 16
.L10_1:
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
.Lfunc_end10:
	.size fail, .Lfunc_end10-fail

	.text
	.align 2
	.type dup_classes, @function
dup_classes:
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
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_1
.L11_0:
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
.L11_1:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_alloc
	mv s2, a0
	sw s2, -20(s0)
	li s1, 0
	sw s1, -24(s0)
.L11_2:
	lw s1, -24(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L11_3
	j .L11_4
.L11_3:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -24(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -20(s0)
	lw s2, -24(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L11_5:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L11_2
.L11_4:
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
.Lfunc_end11:
	.size dup_classes, .Lfunc_end11-dup_classes

	.text
	.align 2
	.type read_import, @function
read_import:
	addi sp, sp, -624
	sw ra, 620(sp)
	sw s0, 616(sp)
	addi s0, sp, 616
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -264
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -528(s0)
	lw s1, -528(s0)
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L12_0
	j .L12_1
.L12_0:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_157
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -604(s0)
	lw s2, -600(s0)
	lw s3, -596(s0)
	lw s4, -592(s0)
	lw s5, -588(s0)
	lw s6, -584(s0)
	lw s7, -580(s0)
	lw s8, -576(s0)
	lw s9, -572(s0)
	lw s10, -568(s0)
	lw s11, -564(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -264
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -8(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	addi s1, s0, -264
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_158
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L12_2
	j .L12_3
.L12_2:
	li s1, 0
	lw s2, -8(s0)
	sw s1, 0(s2)
	j .L12_4
.L12_3:
	addi s1, s0, -264
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_159
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L12_5
	j .L12_6
.L12_5:
	li s1, 1
	lw s2, -8(s0)
	sw s1, 0(s2)
	j .L12_7
.L12_6:
	addi s1, s0, -264
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_160
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L12_8
	j .L12_9
.L12_8:
	li s1, 2
	lw s2, -8(s0)
	sw s1, 0(s2)
	j .L12_10
.L12_9:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_161
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -604(s0)
	lw s2, -600(s0)
	lw s3, -596(s0)
	lw s4, -592(s0)
	lw s5, -588(s0)
	lw s6, -584(s0)
	lw s7, -580(s0)
	lw s8, -576(s0)
	lw s9, -572(s0)
	lw s10, -568(s0)
	lw s11, -564(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_10:
.L12_7:
.L12_4:
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_11
	j .L12_12
.L12_11:
	li s1, 0
	sw s1, -536(s0)
	li s1, 3
	sw s1, -540(s0)
.L12_13:
	lw s1, -540(s0)
	lw s2, -528(s0)
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L12_14
	j .L12_15
.L12_14:
	addi s1, s0, -264
	lw s2, -540(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_162
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L12_16
	j .L12_17
.L12_16:
	addi s1, s0, -264
	lw s2, -540(s0)
	li s3, 1
	add s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -536(s0)
.L12_17:
.L12_18:
	addi s1, s0, -540
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -540(s0)
	j .L12_13
.L12_15:
	lw s1, -536(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_19
	j .L12_20
.L12_20:
	lw s1, -536(s0)
	li s2, 1
	li s3, 20
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L12_19
	j .L12_21
.L12_19:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_163
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -604(s0)
	lw s2, -600(s0)
	lw s3, -596(s0)
	lw s4, -592(s0)
	lw s5, -588(s0)
	lw s6, -584(s0)
	lw s7, -580(s0)
	lw s8, -576(s0)
	lw s9, -572(s0)
	lw s10, -568(s0)
	lw s11, -564(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_21:
	lw s1, -536(s0)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -536(s0)
	bnez s1, .L12_22
	j .L12_23
.L12_22:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -536(s0)
	li s3, 16
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -544(s0)
	j .L12_24
.L12_23:
	li s1, 0
	sw s1, -544(s0)
.L12_24:
	lw s1, -544(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -548(s0)
.L12_25:
	lw s1, -548(s0)
	lw s2, -536(s0)
	slt s3, s1, s2
	bnez s3, .L12_26
	j .L12_27
.L12_26:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_28
	j .L12_29
.L12_28:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	la s3, __str_164
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fail
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -604(s0)
	lw s2, -600(s0)
	lw s3, -596(s0)
	lw s4, -592(s0)
	lw s5, -588(s0)
	lw s6, -584(s0)
	lw s7, -580(s0)
	lw s8, -576(s0)
	lw s9, -572(s0)
	lw s10, -568(s0)
	lw s11, -564(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_29:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -264
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -528(s0)
	lw s1, -528(s0)
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L12_30
	j .L12_31
.L12_31:
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_165
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L12_30
	j .L12_32
.L12_30:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_166
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -604(s0)
	lw s2, -600(s0)
	lw s3, -596(s0)
	lw s4, -592(s0)
	lw s5, -588(s0)
	lw s6, -584(s0)
	lw s7, -580(s0)
	lw s8, -576(s0)
	lw s9, -572(s0)
	lw s10, -568(s0)
	lw s11, -564(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_32:
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -264
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -8(s0)
	li s2, 20
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -548(s0)
	li s4, 16
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -264
	lw s2, -528(s0)
	addi s3, s0, -520
	li s4, 64
	addi s5, s0, -524
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, parse_signature
	mv s6, a0
	sw s6, -532(s0)
	lw s1, -532(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -548(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -520
	lw s3, -532(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, dup_classes
	mv s4, a0
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -548(s0)
	li s3, 16
	mul s5, s2, s3
	add s2, s1, s5
	li s1, 4
	add s3, s2, s1
	sw s4, 0(s3)
	lw s1, -524(s0)
	bnez s1, .L12_33
	j .L12_34
.L12_33:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -524(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	sw s3, -552(s0)
	j .L12_35
.L12_34:
	li s1, 0
	sw s1, -552(s0)
.L12_35:
	lw s1, -552(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -548(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
.L12_36:
	addi s1, s0, -548
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -548(s0)
	j .L12_25
.L12_27:
	li s1, 0
	mv a0, s1
	lw s1, -604(s0)
	lw s2, -600(s0)
	lw s3, -596(s0)
	lw s4, -592(s0)
	lw s5, -588(s0)
	lw s6, -584(s0)
	lw s7, -580(s0)
	lw s8, -576(s0)
	lw s9, -572(s0)
	lw s10, -568(s0)
	lw s11, -564(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_12:
	addi s1, s0, -264
	lw s2, -528(s0)
	addi s3, s0, -520
	li s4, 64
	addi s5, s0, -524
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, parse_signature
	mv s6, a0
	sw s6, -532(s0)
	lw s1, -532(s0)
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -520
	lw s3, -532(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, dup_classes
	mv s4, a0
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	sw s4, 0(s3)
	lw s1, -524(s0)
	bnez s1, .L12_37
	j .L12_38
.L12_37:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -524(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	sw s3, -556(s0)
	j .L12_39
.L12_38:
	li s1, 0
	sw s1, -556(s0)
.L12_39:
	lw s1, -556(s0)
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	mv a0, s1
	lw s1, -604(s0)
	lw s2, -600(s0)
	lw s3, -596(s0)
	lw s4, -592(s0)
	lw s5, -588(s0)
	lw s6, -584(s0)
	lw s7, -580(s0)
	lw s8, -576(s0)
	lw s9, -572(s0)
	lw s10, -568(s0)
	lw s11, -564(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end12:
	.size read_import, .Lfunc_end12-read_import

	.text
	.align 2
	.type unescape, @function
unescape:
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
	lw s1, -8(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -24(s0)
	li s1, 0
	sw s1, -28(s0)
.L13_0:
	lw s1, -8(s0)
	lb s2, 0(s1)
	bnez s2, .L13_1
	j .L13_2
.L13_1:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_3
	j .L13_4
.L13_3:
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L13_5
	j .L13_4
.L13_5:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 110
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_6
	li s1, 116
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_7
	li s1, 114
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_8
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_9
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_10
	li s1, 120
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_11
	j .L13_12
.L13_6:
	li s1, 10
	lw s2, -24(s0)
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L13_13
.L13_7:
	li s1, 9
	lw s2, -24(s0)
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L13_13
.L13_8:
	li s1, 13
	lw s2, -24(s0)
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L13_13
.L13_9:
	li s1, 34
	lw s2, -24(s0)
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L13_13
.L13_10:
	li s1, 92
	lw s2, -24(s0)
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L13_13
.L13_11:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	bnez s2, .L13_14
	j .L13_15
.L13_14:
	addi s1, s0, -44
	li s2, 0
	sh s2, 0(s1)
	lw s2, -8(s0)
	lb s3, 0(s2)
	sb s3, 0(s1)
	li s2, 0
	li s3, 1
	add s4, s1, s3
	sb s2, 0(s4)
	addi s1, s0, -44
	li s2, 0
	li s3, 16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -40(s0)
	j .L13_16
.L13_15:
	li s1, 0
	sw s1, -40(s0)
.L13_16:
	lw s1, -40(s0)
	sw s1, -32(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	bnez s2, .L13_17
	j .L13_18
.L13_17:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
.L13_18:
	lw s1, -8(s0)
	lb s2, 0(s1)
	bnez s2, .L13_19
	j .L13_20
.L13_19:
	addi s1, s0, -52
	li s2, 0
	sh s2, 0(s1)
	lw s2, -8(s0)
	lb s3, 0(s2)
	sb s3, 0(s1)
	li s2, 0
	li s3, 1
	add s4, s1, s3
	sb s2, 0(s4)
	addi s1, s0, -52
	li s2, 0
	li s3, 16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -48(s0)
	j .L13_21
.L13_20:
	li s1, 0
	sw s1, -48(s0)
.L13_21:
	lw s1, -48(s0)
	sw s1, -36(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	bnez s2, .L13_22
	j .L13_23
.L13_22:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
.L13_23:
	lw s1, -32(s0)
	li s2, 16
	mul s3, s1, s2
	lw s1, -36(s0)
	add s2, s3, s1
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -24(s0)
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	j .L13_13
.L13_12:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lb s1, 0(s2)
	lw s2, -24(s0)
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L13_13
.L13_13:
	j .L13_24
.L13_4:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lb s1, 0(s2)
	lw s2, -24(s0)
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L13_24:
	j .L13_0
.L13_2:
	li s1, 0
	lw s2, -24(s0)
	lw s3, -28(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -28(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -24(s0)
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
.Lfunc_end13:
	.size unescape, .Lfunc_end13-unescape

	.text
	.align 2
	.type quoted_body, @function
quoted_body:
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
	li s2, 34
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L14_0
	j .L14_1
.L14_0:
	lw s1, -4(s0)
	li s2, 34
	mv a0, s1
	mv a1, s2
	jal ra, strrchr
	mv s3, a0
	sw s3, -20(s0)
	j .L14_2
.L14_1:
	li s1, 0
	sw s1, -20(s0)
.L14_2:
	lw s1, -20(s0)
	sw s1, -16(s0)
	lw s1, -12(s0)
	bnez s1, .L14_3
	j .L14_4
.L14_3:
	lw s1, -16(s0)
	lw s2, -12(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_4
	j .L14_5
.L14_4:
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
.L14_5:
	li s1, 0
	lw s2, -16(s0)
	sb s1, 0(s2)
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
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
.Lfunc_end14:
	.size quoted_body, .Lfunc_end14-quoted_body

	.text
	.align 2
	.type read_global, @function
read_global:
	addi sp, sp, -352
	sw ra, 348(sp)
	sw s0, 344(sp)
	addi s0, sp, 344
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
	li s1, 0
	sw s1, -276(s0)
	li s1, 0
	sw s1, -280(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	sw s2, -284(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -264
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -268(s0)
	lw s1, -268(s0)
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L15_0
	j .L15_1
.L15_0:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_167
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -340(s0)
	lw s2, -336(s0)
	lw s3, -332(s0)
	lw s4, -328(s0)
	lw s5, -324(s0)
	lw s6, -320(s0)
	lw s7, -316(s0)
	lw s8, -312(s0)
	lw s9, -308(s0)
	lw s10, -304(s0)
	lw s11, -300(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_1:
	lw s1, -284(s0)
	addi s2, s0, -264
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -8(s0)
	sw s3, 0(s1)
	addi s1, s0, -264
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, base_type_by_name
	mv s2, a0
	lw s1, -8(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_2
	j .L15_3
.L15_2:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_168
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -340(s0)
	lw s2, -336(s0)
	lw s3, -332(s0)
	lw s4, -328(s0)
	lw s5, -324(s0)
	lw s6, -320(s0)
	lw s7, -316(s0)
	lw s8, -312(s0)
	lw s9, -308(s0)
	lw s10, -304(s0)
	lw s11, -300(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_3:
	li s1, 3
	sw s1, -272(s0)
.L15_4:
	lw s1, -272(s0)
	lw s2, -268(s0)
	slt s3, s1, s2
	bnez s3, .L15_5
	j .L15_6
.L15_5:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_169
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_7
	j .L15_8
.L15_7:
	lw s1, -272(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -268(s0)
	slt s2, s3, s1
	bnez s2, .L15_9
	j .L15_8
.L15_9:
	addi s1, s0, -264
	addi s2, s0, -272
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -272(s0)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	sw s4, 0(s3)
	j .L15_10
.L15_8:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_170
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_11
	j .L15_12
.L15_11:
	lw s1, -272(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -268(s0)
	slt s2, s3, s1
	bnez s2, .L15_13
	j .L15_12
.L15_13:
	addi s1, s0, -264
	addi s2, s0, -272
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -272(s0)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	lw s1, -8(s0)
	li s2, 16
	add s3, s1, s2
	sw s4, 0(s3)
	j .L15_14
.L15_12:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_171
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_15
	j .L15_16
.L15_15:
	li s1, 1
	lw s2, -8(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	j .L15_17
.L15_16:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_172
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_18
	j .L15_19
.L15_18:
	li s1, 1
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	j .L15_20
.L15_19:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_173
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_21
	j .L15_22
.L15_21:
	li s1, 1
	lw s2, -8(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	j .L15_23
.L15_22:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_174
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_24
	j .L15_25
.L15_24:
	li s1, 1
	lw s2, -8(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	j .L15_26
.L15_25:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_175
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_27
	j .L15_28
.L15_27:
	li s1, 1
	lw s2, -8(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	j .L15_29
.L15_28:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_176
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_30
	j .L15_31
.L15_30:
	lw s1, -272(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -268(s0)
	slt s2, s3, s1
	bnez s2, .L15_32
	j .L15_31
.L15_32:
	lw s1, -284(s0)
	addi s2, s0, -264
	addi s3, s0, -272
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -272(s0)
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -8(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
.L15_31:
.L15_29:
.L15_26:
.L15_23:
.L15_20:
.L15_17:
.L15_14:
.L15_10:
.L15_33:
	addi s1, s0, -272
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -272(s0)
	j .L15_4
.L15_6:
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_34
	j .L15_35
.L15_35:
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	li s3, 20
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L15_34
	j .L15_36
.L15_36:
	lw s1, -8(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_34
	j .L15_37
.L15_34:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_177
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -340(s0)
	lw s2, -336(s0)
	lw s3, -332(s0)
	lw s4, -328(s0)
	lw s5, -324(s0)
	lw s6, -320(s0)
	lw s7, -316(s0)
	lw s8, -312(s0)
	lw s9, -308(s0)
	lw s10, -304(s0)
	lw s11, -300(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_37:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	sw s3, -272(s0)
.L15_38:
	lw s1, -272(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L15_39
	j .L15_40
.L15_39:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_178
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_41
	j .L15_42
.L15_41:
	addi s1, s0, -276
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -276(s0)
	j .L15_43
.L15_42:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_179
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_44
	j .L15_45
.L15_44:
	j .L15_40
.L15_45:
.L15_43:
.L15_46:
	addi s1, s0, -272
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -272(s0)
	j .L15_38
.L15_40:
	lw s1, -276(s0)
	bnez s1, .L15_47
	j .L15_48
.L15_47:
	lw s1, -284(s0)
	lw s2, -276(s0)
	li s3, 8
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -284(s0)
	lw s2, -276(s0)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
.L15_48:
.L15_49:
	j .L15_50
.L15_50:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L15_51
	j .L15_52
.L15_51:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	la s3, __str_180
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fail
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -340(s0)
	lw s2, -336(s0)
	lw s3, -332(s0)
	lw s4, -328(s0)
	lw s5, -324(s0)
	lw s6, -320(s0)
	lw s7, -316(s0)
	lw s8, -312(s0)
	lw s9, -308(s0)
	lw s10, -304(s0)
	lw s11, -300(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_52:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -288(s0)
	lw s1, -288(s0)
	la s2, __str_181
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_53
	j .L15_54
.L15_53:
	j .L15_55
.L15_54:
	lw s1, -288(s0)
	la s2, __str_182
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_56
	j .L15_57
.L15_56:
	lw s1, -288(s0)
	addi s2, s0, -264
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -268(s0)
	lw s1, -268(s0)
	li s2, 3
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L15_58
	j .L15_59
.L15_58:
	addi s1, s0, -264
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_183
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L15_60
	j .L15_59
.L15_60:
	lw s1, -284(s0)
	addi s2, s0, -264
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -8(s0)
	li s2, 48
	add s4, s1, s2
	lw s1, 0(s4)
	addi s2, s0, -280
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -280(s0)
	li s2, 4
	mul s5, s4, s2
	add s2, s1, s5
	sw s3, 0(s2)
	j .L15_61
.L15_59:
	lw s1, -268(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L15_62
	j .L15_63
.L15_62:
	addi s1, s0, -264
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoll
	mv s10, a0
	mv s11, a1
	lw s1, -8(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -280
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -280(s0)
	li s2, 8
	mul s4, s3, s2
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
.L15_63:
.L15_61:
	lw s1, -280(s0)
	lw s2, -8(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L15_64
.L15_57:
	lw s1, -288(s0)
	la s2, __str_184
	li s3, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_65
	j .L15_66
.L15_65:
	lw s1, -288(s0)
	mv a0, s1
	jal ra, quoted_body
	mv s2, a0
	sw s2, -292(s0)
	lw s1, -292(s0)
	bnez s1, .L15_67
	j .L15_68
.L15_68:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_185
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -340(s0)
	lw s2, -336(s0)
	lw s3, -332(s0)
	lw s4, -328(s0)
	lw s5, -324(s0)
	lw s6, -320(s0)
	lw s7, -316(s0)
	lw s8, -312(s0)
	lw s9, -308(s0)
	lw s10, -304(s0)
	lw s11, -300(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_67:
	lw s1, -284(s0)
	lw s2, -292(s0)
	lw s3, -8(s0)
	li s4, 60
	add s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, unescape
	mv s3, a0
	lw s1, -8(s0)
	li s2, 56
	add s4, s1, s2
	sw s3, 0(s4)
	j .L15_69
.L15_66:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_186
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -340(s0)
	lw s2, -336(s0)
	lw s3, -332(s0)
	lw s4, -328(s0)
	lw s5, -324(s0)
	lw s6, -320(s0)
	lw s7, -316(s0)
	lw s8, -312(s0)
	lw s9, -308(s0)
	lw s10, -304(s0)
	lw s11, -300(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_69:
.L15_64:
.L15_70:
	j .L15_49
.L15_55:
	li s1, 0
	mv a0, s1
	lw s1, -340(s0)
	lw s2, -336(s0)
	lw s3, -332(s0)
	lw s4, -328(s0)
	lw s5, -324(s0)
	lw s6, -320(s0)
	lw s7, -316(s0)
	lw s8, -312(s0)
	lw s9, -308(s0)
	lw s10, -304(s0)
	lw s11, -300(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end15:
	.size read_global, .Lfunc_end15-read_global

	.text
	.align 2
	.type set_operands, @function
set_operands:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	sw s2, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 1
	sw s1, -40(s0)
.L16_0:
	lw s1, -40(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L16_1
	j .L16_2
.L16_1:
	lw s1, -8(s0)
	lw s2, -40(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 61
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -44(s0)
	lw s1, -8(s0)
	lw s2, -40(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -48(s0)
	lw s1, -44(s0)
	bnez s1, .L16_3
	j .L16_4
.L16_4:
	j .L16_5
.L16_3:
	li s1, 0
	lw s2, -44(s0)
	sb s1, 0(s2)
	lw s1, -44(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -52(s0)
	lw s1, -48(s0)
	la s2, __str_187
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_6
	j .L16_7
.L16_6:
	lw s1, -52(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -56(s0)
	lw s1, -56(s0)
	li s2, 1
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L16_8
	j .L16_9
.L16_9:
	lw s1, -56(s0)
	lw s2, -16(s0)
	li s3, 64
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L16_8
	j .L16_10
.L16_8:
	j .L16_11
.L16_10:
	lw s1, -56(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	j .L16_12
.L16_7:
	lw s1, -48(s0)
	la s2, __str_188
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_13
	j .L16_14
.L16_13:
	lw s1, -52(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -56(s0)
	lw s1, -56(s0)
	li s2, 1
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L16_15
	j .L16_16
.L16_16:
	lw s1, -56(s0)
	lw s2, -16(s0)
	li s3, 64
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L16_15
	j .L16_17
.L16_15:
	j .L16_11
.L16_17:
	lw s1, -56(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	j .L16_18
.L16_14:
	lw s1, -48(s0)
	la s2, __str_189
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_19
	j .L16_20
.L16_19:
	lw s1, -52(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -56(s0)
	lw s1, -56(s0)
	li s2, 1
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L16_21
	j .L16_22
.L16_22:
	lw s1, -56(s0)
	lw s2, -16(s0)
	li s3, 64
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L16_21
	j .L16_23
.L16_21:
	j .L16_11
.L16_23:
	lw s1, -56(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	j .L16_24
.L16_20:
	lw s1, -48(s0)
	la s2, __str_190
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_25
	j .L16_26
.L16_25:
	lw s1, -52(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoll
	mv s10, a0
	mv s11, a1
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	j .L16_27
.L16_26:
	lw s1, -48(s0)
	la s2, __str_191
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_28
	j .L16_29
.L16_28:
	lw s1, -52(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L16_30
	j .L16_31
.L16_31:
	lw s1, -56(s0)
	lw s2, -16(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L16_30
	j .L16_32
.L16_30:
	lw s1, -20(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_192
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
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
.L16_32:
	lw s1, -56(s0)
	lw s2, -4(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	sw s1, -32(s0)
	j .L16_33
.L16_29:
	lw s1, -48(s0)
	la s2, __str_193
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_34
	j .L16_35
.L16_34:
	lw s1, -52(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L16_36
	j .L16_37
.L16_37:
	lw s1, -56(s0)
	lw s2, -16(s0)
	li s3, 68
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L16_36
	j .L16_38
.L16_36:
	lw s1, -20(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_194
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
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
.L16_38:
	lw s1, -56(s0)
	lw s2, -4(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	sw s1, -36(s0)
	j .L16_39
.L16_35:
	lw s1, -48(s0)
	la s2, __str_195
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_40
	j .L16_41
.L16_40:
	lw s1, -52(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	lw s1, -4(s0)
	li s2, 40
	add s3, s1, s2
	sw s4, 0(s3)
	j .L16_42
.L16_41:
	lw s1, -48(s0)
	la s2, __str_196
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_43
	j .L16_44
.L16_43:
	lw s1, -28(s0)
	lw s2, -52(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -4(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
.L16_44:
.L16_42:
.L16_39:
.L16_33:
.L16_27:
.L16_24:
.L16_18:
.L16_12:
.L16_5:
	addi s1, s0, -40
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -40(s0)
	j .L16_0
.L16_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, op_needs_slot
	mv s1, a0
	bnez s1, .L16_45
	j .L16_46
.L16_45:
	lw s1, -32(s0)
	bnez s1, .L16_46
	j .L16_47
.L16_47:
	lw s1, -20(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_197
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
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
.L16_46:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, op_needs_label
	mv s1, a0
	bnez s1, .L16_48
	j .L16_49
.L16_48:
	lw s1, -36(s0)
	bnez s1, .L16_49
	j .L16_50
.L16_50:
	lw s1, -20(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_198
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
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
.L16_49:
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
.L16_11:
	lw s1, -20(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_199
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
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
.Lfunc_end16:
	.size set_operands, .Lfunc_end16-set_operands

	.text
	.align 2
	.type read_int_list, @function
read_int_list:
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
	li s1, 1
	sw s1, -20(s0)
.L17_0:
	lw s1, -20(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L17_1
	j .L17_2
.L17_1:
	lw s1, -20(s0)
	li s2, 1
	sub s3, s1, s2
	lw s1, -16(s0)
	slt s2, s3, s1
	bnez s2, .L17_3
	j .L17_2
.L17_3:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 1
	sub s5, s2, s3
	li s2, 4
	mul s3, s5, s2
	add s2, s1, s3
	sw s4, 0(s2)
.L17_4:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L17_0
.L17_2:
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
	.size read_int_list, .Lfunc_end17-read_int_list

	.text
	.align 2
	.type kpm_isdigit, @function
kpm_isdigit:
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
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L18_0
	j .L18_1
.L18_0:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L18_2
	j .L18_1
.L18_2:
	li s1, 1
	j .L18_3
.L18_1:
	li s1, 0
.L18_3:
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
.Lfunc_end18:
	.size kpm_isdigit, .Lfunc_end18-kpm_isdigit

	.text
	.align 2
	.type parse_asm_op, @function
parse_asm_op:
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
	lw s1, -8(s0)
	sw s1, -20(s0)
	lw s1, -8(s0)
	li s2, 44
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -36(s0)
	bnez s1, .L19_0
	j .L19_1
.L19_1:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L19_0:
	li s1, 0
	lw s2, -36(s0)
	sb s1, 0(s2)
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -24(s0)
	lw s1, -24(s0)
	li s2, 44
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -36(s0)
	bnez s1, .L19_2
	j .L19_3
.L19_3:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L19_2:
	li s1, 0
	lw s2, -36(s0)
	sb s1, 0(s2)
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 44
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -36(s0)
	bnez s1, .L19_4
	j .L19_5
.L19_5:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L19_4:
	li s1, 0
	lw s2, -36(s0)
	sb s1, 0(s2)
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -32(s0)
	lw s1, -20(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 111
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L19_6
	j .L19_7
.L19_6:
	lw s1, -20(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 105
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L19_8
	j .L19_7
.L19_8:
	lw s1, -20(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 98
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L19_9
	j .L19_7
.L19_9:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L19_7:
	lw s1, -28(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -40(s0)
	lw s1, -32(s0)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -44(s0)
	lw s1, -40(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L19_10
	j .L19_11
.L19_11:
	lw s1, -40(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L19_10
	j .L19_12
.L19_12:
	lw s1, -44(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L19_10
	j .L19_13
.L19_13:
	lw s1, -44(s0)
	li s2, 8
	slt s3, s2, s1
	bnez s3, .L19_10
	j .L19_14
.L19_10:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L19_14:
	lw s1, -4(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	sw s3, 0(s1)
	li s1, 0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -40(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 111
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_15
	j .L19_16
.L19_16:
	lw s1, -20(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 98
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_15
	j .L19_17
.L19_15:
	li s1, 1
	j .L19_18
.L19_17:
	li s1, 0
.L19_18:
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 98
	xor s3, s1, s2
	seqz s3, s3
	lw s1, -12(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
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
.Lfunc_end19:
	.size parse_asm_op, .Lfunc_end19-parse_asm_op

	.text
	.align 2
	.type read_func, @function
read_func:
	addi sp, sp, -688
	sw ra, 684(sp)
	sw s0, 680(sp)
	addi s0, sp, 680
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
	lw s2, 0(s1)
	sw s2, -276(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -264
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -268(s0)
	lw s1, -268(s0)
	li s2, 2
	slt s3, s1, s2
	bnez s3, .L20_0
	j .L20_1
.L20_0:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_200
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_1:
	lw s1, -276(s0)
	addi s2, s0, -264
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -8(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 2
	sw s1, -272(s0)
.L20_2:
	lw s1, -272(s0)
	lw s2, -268(s0)
	slt s3, s1, s2
	bnez s3, .L20_3
	j .L20_4
.L20_3:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_201
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_5
	j .L20_6
.L20_5:
	li s1, 1
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	j .L20_7
.L20_6:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_202
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_8
	j .L20_9
.L20_8:
	li s1, 1
	lw s2, -8(s0)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	j .L20_10
.L20_9:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_203
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_11
	j .L20_12
.L20_11:
	lw s1, -272(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -268(s0)
	slt s2, s3, s1
	bnez s2, .L20_13
	j .L20_12
.L20_13:
	lw s1, -276(s0)
	addi s2, s0, -264
	addi s3, s0, -272
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -272(s0)
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -8(s0)
	li s2, 8
	add s4, s1, s2
	sw s3, 0(s4)
	j .L20_14
.L20_12:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_204
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_15
	j .L20_16
.L20_15:
	lw s1, -272(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -268(s0)
	slt s2, s3, s1
	bnez s2, .L20_17
	j .L20_16
.L20_17:
	addi s1, s0, -264
	addi s2, s0, -272
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -272(s0)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	sw s4, 0(s3)
	j .L20_18
.L20_16:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_205
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_19
	j .L20_20
.L20_19:
	lw s1, -272(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -268(s0)
	slt s2, s3, s1
	bnez s2, .L20_21
	j .L20_20
.L20_21:
	addi s1, s0, -264
	addi s2, s0, -272
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -272(s0)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	sw s4, 0(s3)
	j .L20_22
.L20_20:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_206
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_23
	j .L20_24
.L20_23:
	lw s1, -272(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -268(s0)
	slt s2, s3, s1
	bnez s2, .L20_25
	j .L20_24
.L20_25:
	addi s1, s0, -264
	addi s2, s0, -272
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -272(s0)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	sw s4, 0(s3)
	j .L20_26
.L20_24:
	addi s1, s0, -264
	lw s2, -272(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_207
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_27
	j .L20_28
.L20_27:
	lw s1, -272(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -268(s0)
	slt s2, s3, s1
	bnez s2, .L20_29
	j .L20_28
.L20_29:
	addi s1, s0, -264
	addi s2, s0, -272
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -272(s0)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	lw s1, -8(s0)
	li s2, 68
	add s3, s1, s2
	sw s4, 0(s3)
.L20_28:
.L20_26:
.L20_22:
.L20_18:
.L20_14:
.L20_10:
.L20_7:
.L20_30:
	addi s1, s0, -272
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -272(s0)
	j .L20_2
.L20_4:
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_31
	j .L20_32
.L20_32:
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	li s3, 20
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L20_31
	j .L20_33
.L20_33:
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_31
	j .L20_34
.L20_34:
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	li s3, 20
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L20_31
	j .L20_35
.L20_35:
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_31
	j .L20_36
.L20_36:
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	li s3, 20
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L20_31
	j .L20_37
.L20_37:
	lw s1, -8(s0)
	li s2, 68
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_31
	j .L20_38
.L20_38:
	lw s1, -8(s0)
	li s2, 68
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	li s3, 20
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L20_31
	j .L20_39
.L20_31:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_208
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_39:
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L20_40
	j .L20_41
.L20_40:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_209
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_41:
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L20_42
	j .L20_43
.L20_42:
	lw s1, -276(s0)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
.L20_43:
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L20_44
	j .L20_45
.L20_44:
	lw s1, -276(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -276(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
.L20_45:
.L20_46:
	j .L20_47
.L20_47:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L20_48
	j .L20_49
.L20_48:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	la s3, __str_210
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fail
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_49:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -280(s0)
	lw s1, -280(s0)
	la s2, __str_211
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_50
	j .L20_51
.L20_50:
	j .L20_52
.L20_51:
	lw s1, -280(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_53
	j .L20_54
.L20_53:
	lw s1, -280(s0)
	addi s2, s0, -264
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -268(s0)
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_212
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_55
	j .L20_56
.L20_55:
	addi s1, s0, -264
	lw s2, -268(s0)
	lw s3, -8(s0)
	li s4, 28
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -8(s0)
	li s5, 24
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, read_int_list
	mv s5, a0
	j .L20_57
.L20_56:
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_213
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_58
	j .L20_59
.L20_58:
	addi s1, s0, -264
	lw s2, -268(s0)
	lw s3, -8(s0)
	li s4, 36
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -8(s0)
	li s5, 20
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, read_int_list
	mv s5, a0
	j .L20_60
.L20_59:
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_214
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_61
	j .L20_62
.L20_61:
	li s1, 1
	sw s1, -284(s0)
.L20_63:
	lw s1, -284(s0)
	lw s2, -268(s0)
	slt s3, s1, s2
	bnez s3, .L20_64
	j .L20_65
.L20_64:
	lw s1, -284(s0)
	li s2, 1
	sub s3, s1, s2
	lw s1, -8(s0)
	li s2, 20
	add s4, s1, s2
	lw s1, 0(s4)
	slt s2, s3, s1
	bnez s2, .L20_66
	j .L20_65
.L20_66:
	addi s1, s0, -264
	lw s2, -284(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	li s1, 24
	sll s2, s4, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -8(s0)
	li s2, 48
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -284(s0)
	li s4, 1
	sub s5, s2, s4
	add s2, s1, s5
	sb s3, 0(s2)
.L20_67:
	addi s1, s0, -284
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -284(s0)
	j .L20_63
.L20_65:
	j .L20_68
.L20_62:
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_215
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L20_69
	j .L20_70
.L20_69:
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_216
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L20_71
	j .L20_70
.L20_71:
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_217
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L20_72
	j .L20_70
.L20_72:
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_218
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L20_73
	j .L20_70
.L20_73:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_219
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_70:
.L20_68:
.L20_60:
.L20_57:
	j .L20_74
.L20_54:
	lw s1, -280(s0)
	la s2, __str_220
	li s3, 3
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L20_75
	j .L20_76
.L20_75:
	lw s1, -280(s0)
	li s2, 3
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_77
	j .L20_78
.L20_78:
	lw s1, -280(s0)
	li s2, 3
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_77
	j .L20_76
.L20_77:
	lw s1, -280(s0)
	li s2, 3
	add s3, s1, s2
	sw s3, -296(s0)
.L20_79:
	lw s1, -296(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L20_80
	j .L20_81
.L20_81:
	lw s1, -296(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L20_80
	j .L20_82
.L20_80:
	addi s1, s0, -296
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -296(s0)
	j .L20_79
.L20_82:
	lw s1, -296(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L20_83
	j .L20_84
.L20_83:
	lw s1, -280(s0)
	mv a0, s1
	jal ra, quoted_body
	mv s2, a0
	sw s2, -304(s0)
	lw s1, -304(s0)
	bnez s1, .L20_85
	j .L20_86
.L20_86:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_221
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_85:
	lw s1, -8(s0)
	li s2, 129
	mv a0, s1
	mv a1, s2
	jal ra, ir_emit
	mv s3, a0
	sw s3, -288(s0)
	lw s1, -276(s0)
	lw s2, -304(s0)
	addi s3, s0, -300
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, unescape
	mv s4, a0
	lw s1, -288(s0)
	li s2, 24
	add s3, s1, s2
	sw s4, 0(s3)
	j .L20_87
.L20_84:
	lw s1, -296(s0)
	li s2, 34
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -308(s0)
	li s1, 1
	neg s2, s1
	sw s2, -584(s0)
	li s1, 1
	neg s2, s1
	sw s2, -588(s0)
	li s1, 1
	sw s1, -592(s0)
	li s1, 0
	sw s1, -596(s0)
	lw s1, -308(s0)
	bnez s1, .L20_88
	j .L20_89
.L20_88:
	lw s1, -308(s0)
	mv a0, s1
	jal ra, quoted_body
	mv s2, a0
	sw s2, -312(s0)
	bnez s2, .L20_90
	j .L20_89
.L20_89:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_222
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_90:
	li s1, 0
	lw s2, -308(s0)
	sb s1, 0(s2)
	lw s1, -296(s0)
	addi s2, s0, -568
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -576(s0)
	li s1, 0
	sw s1, -580(s0)
.L20_91:
	lw s1, -580(s0)
	lw s2, -576(s0)
	slt s3, s1, s2
	bnez s3, .L20_92
	j .L20_93
.L20_92:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_223
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L20_94
	j .L20_95
.L20_94:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 5
	add s3, s1, s2
	li s1, 0
	li s2, 10
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, strtol
	mv s4, a0
	sw s4, -584(s0)
	j .L20_96
.L20_95:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_224
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L20_97
	j .L20_98
.L20_97:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 4
	add s3, s1, s2
	li s1, 0
	li s2, 10
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, strtol
	mv s4, a0
	sw s4, -588(s0)
	j .L20_99
.L20_98:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_225
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L20_100
	j .L20_101
.L20_100:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 4
	add s3, s1, s2
	li s1, 0
	li s2, 10
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, strtol
	mv s4, a0
	sw s4, -592(s0)
	j .L20_102
.L20_101:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 99
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_103
	j .L20_104
.L20_103:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	mv a0, s1
	jal ra, kpm_isdigit
	mv s2, a0
	bnez s2, .L20_105
	j .L20_104
.L20_105:
	addi s1, s0, -596
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -596(s0)
.L20_104:
.L20_102:
.L20_99:
.L20_96:
.L20_106:
	addi s1, s0, -580
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -580(s0)
	j .L20_91
.L20_93:
	lw s1, -584(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_107
	j .L20_108
.L20_108:
	lw s1, -588(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_107
	j .L20_109
.L20_109:
	lw s1, -584(s0)
	li s2, 1
	li s3, 20
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L20_107
	j .L20_110
.L20_110:
	lw s1, -588(s0)
	li s2, 1
	li s3, 20
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L20_107
	j .L20_111
.L20_107:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_226
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_111:
	lw s1, -584(s0)
	lw s2, -588(s0)
	add s3, s1, s2
	sw s3, -600(s0)
	lw s1, -276(s0)
	li s2, 24
	mv a0, s1
	mv a1, s2
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -572(s0)
	lw s1, -584(s0)
	lw s2, -572(s0)
	sw s1, 0(s2)
	lw s1, -588(s0)
	lw s2, -572(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -592(s0)
	lw s2, -572(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -596(s0)
	lw s2, -572(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -600(s0)
	bnez s1, .L20_112
	j .L20_113
.L20_112:
	lw s1, -276(s0)
	lw s2, -600(s0)
	li s3, 24
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	sw s2, -612(s0)
	j .L20_114
.L20_113:
	li s1, 0
	sw s1, -612(s0)
.L20_114:
	lw s1, -612(s0)
	lw s2, -572(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -596(s0)
	bnez s1, .L20_115
	j .L20_116
.L20_115:
	lw s1, -276(s0)
	lw s2, -596(s0)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	sw s2, -616(s0)
	j .L20_117
.L20_116:
	li s1, 0
	sw s1, -616(s0)
.L20_117:
	lw s1, -616(s0)
	lw s2, -572(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -604(s0)
	li s1, 0
	sw s1, -580(s0)
.L20_118:
	lw s1, -580(s0)
	lw s2, -576(s0)
	slt s3, s1, s2
	bnez s3, .L20_119
	j .L20_120
.L20_119:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 61
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -620(s0)
	lw s1, -620(s0)
	bnez s1, .L20_121
	j .L20_122
.L20_122:
	j .L20_123
.L20_121:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 111
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_124
	j .L20_125
.L20_124:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	mv a0, s1
	jal ra, kpm_isdigit
	mv s2, a0
	bnez s2, .L20_126
	j .L20_125
.L20_126:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	add s3, s1, s2
	li s1, 0
	li s2, 10
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, strtol
	mv s4, a0
	sw s4, -624(s0)
	lw s1, -624(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_127
	j .L20_128
.L20_128:
	lw s1, -624(s0)
	lw s2, -600(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L20_127
	j .L20_129
.L20_129:
	lw s1, -276(s0)
	lw s2, -620(s0)
	li s3, 1
	add s4, s2, s3
	lw s2, -572(s0)
	li s3, 8
	add s5, s2, s3
	lw s2, 0(s5)
	lw s3, -624(s0)
	li s5, 24
	mul s6, s3, s5
	add s3, s2, s6
	lw s2, -8(s0)
	li s5, 64
	add s6, s2, s5
	lw s2, 0(s6)
	mv a0, s1
	mv a1, s4
	mv a2, s3
	mv a3, s2
	jal ra, parse_asm_op
	mv s5, a0
	li s1, 0
	xor s2, s5, s1
	snez s2, s2
	bnez s2, .L20_127
	j .L20_130
.L20_127:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_227
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_130:
	j .L20_131
.L20_125:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 99
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_132
	j .L20_133
.L20_132:
	addi s1, s0, -568
	lw s2, -580(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	mv a0, s1
	jal ra, kpm_isdigit
	mv s2, a0
	bnez s2, .L20_134
	j .L20_133
.L20_134:
	lw s1, -604(s0)
	lw s2, -596(s0)
	slt s3, s1, s2
	bnez s3, .L20_135
	j .L20_136
.L20_135:
	lw s1, -276(s0)
	lw s2, -620(s0)
	li s3, 1
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_strdup
	mv s2, a0
	lw s1, -572(s0)
	li s3, 12
	add s4, s1, s3
	lw s1, 0(s4)
	addi s3, s0, -604
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -604(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s1, s5
	sw s2, 0(s3)
.L20_136:
.L20_133:
.L20_131:
.L20_123:
	addi s1, s0, -580
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -580(s0)
	j .L20_118
.L20_120:
	li s1, 0
	sw s1, -608(s0)
.L20_137:
	lw s1, -608(s0)
	lw s2, -600(s0)
	slt s3, s1, s2
	bnez s3, .L20_138
	j .L20_139
.L20_138:
	lw s1, -572(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -608(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L20_140
	j .L20_141
.L20_141:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_228
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_140:
.L20_142:
	addi s1, s0, -608
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -608(s0)
	j .L20_137
.L20_139:
	lw s1, -8(s0)
	li s2, 129
	mv a0, s1
	mv a1, s2
	jal ra, ir_emit
	mv s3, a0
	sw s3, -288(s0)
	lw s1, -276(s0)
	lw s2, -312(s0)
	addi s3, s0, -300
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, unescape
	mv s4, a0
	lw s1, -288(s0)
	li s2, 24
	add s3, s1, s2
	sw s4, 0(s3)
	lw s1, -572(s0)
	lw s2, -288(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	j .L20_87
.L20_76:
	lw s1, -280(s0)
	addi s2, s0, -264
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -268(s0)
	lw s1, -268(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_143
	j .L20_144
.L20_143:
	j .L20_87
.L20_144:
	addi s1, s0, -264
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, op_by_name
	mv s2, a0
	sw s2, -292(s0)
	lw s1, -292(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_145
	j .L20_146
.L20_145:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_229
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_146:
	lw s1, -8(s0)
	lw s2, -292(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ir_emit
	mv s3, a0
	sw s3, -288(s0)
	lw s1, -288(s0)
	addi s2, s0, -264
	lw s3, -268(s0)
	lw s4, -8(s0)
	lw s5, -4(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, set_operands
	mv s6, a0
	li s1, 0
	xor s2, s6, s1
	snez s2, s2
	bnez s2, .L20_147
	j .L20_148
.L20_147:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_148:
.L20_74:
.L20_87:
	j .L20_46
.L20_52:
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L20_149
	j .L20_150
.L20_149:
	lw s1, -8(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L20_151
	j .L20_150
.L20_151:
	lw s1, -276(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -276(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	li s2, 1
	mul s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	sw s1, -628(s0)
.L20_152:
	lw s1, -628(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L20_153
	j .L20_154
.L20_153:
	li s1, 1
	lw s2, -8(s0)
	li s3, 40
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -628(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -8(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -628(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_155
	j .L20_156
.L20_155:
	li s1, 1
	sw s1, -632(s0)
	j .L20_157
.L20_156:
	li s1, 0
	sw s1, -632(s0)
.L20_157:
	lw s1, -632(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	lw s4, -628(s0)
	mul s5, s3, s4
	add s3, s1, s5
	sb s2, 0(s3)
.L20_158:
	addi s1, s0, -628
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -628(s0)
	j .L20_152
.L20_154:
.L20_150:
	li s1, 0
	mv a0, s1
	lw s1, -676(s0)
	lw s2, -672(s0)
	lw s3, -668(s0)
	lw s4, -664(s0)
	lw s5, -660(s0)
	lw s6, -656(s0)
	lw s7, -652(s0)
	lw s8, -648(s0)
	lw s9, -644(s0)
	lw s10, -640(s0)
	lw s11, -636(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end20:
	.size read_func, .Lfunc_end20-read_func

	.text
	.align 2
	.type split_lines, @function
split_lines:
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
	lw s2, 0(s1)
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, -12(s0)
	li s3, 1
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_alloc
	mv s2, a0
	sw s2, -24(s0)
	li s1, 1
	sw s1, -28(s0)
	lw s1, -24(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -24(s0)
	lw s3, -12(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	sw s1, -32(s0)
.L21_0:
	lw s1, -32(s0)
	lw s2, -12(s0)
	sltu s3, s1, s2
	bnez s3, .L21_1
	j .L21_2
.L21_1:
	lw s1, -24(s0)
	lw s2, -32(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L21_3
	j .L21_4
.L21_3:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
.L21_4:
.L21_5:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L21_0
.L21_2:
	lw s1, -20(s0)
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_alloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	sw s1, -36(s0)
.L21_6:
	lw s1, -36(s0)
	bnez s1, .L21_7
	j .L21_8
.L21_7:
	lw s1, -36(s0)
	li s2, 10
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -40(s0)
	lw s1, -40(s0)
	bnez s1, .L21_9
	j .L21_10
.L21_9:
	li s1, 0
	lw s2, -40(s0)
	sb s1, 0(s2)
.L21_10:
	lw s1, -36(s0)
	sw s1, -44(s0)
	lw s1, -44(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -48(s0)
	lw s1, -48(s0)
	bnez s1, .L21_11
	j .L21_12
.L21_11:
	lw s1, -44(s0)
	lw s2, -48(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 13
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L21_13
	j .L21_12
.L21_13:
	li s1, 0
	lw s2, -44(s0)
	addi s3, s0, -48
	lw s4, 0(s3)
	li s3, -1
	add s5, s4, s3
	sw s5, -48(s0)
	add s3, s2, s5
	sb s1, 0(s3)
.L21_12:
.L21_14:
	lw s1, -44(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L21_15
	j .L21_16
.L21_16:
	lw s1, -44(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L21_15
	j .L21_17
.L21_15:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L21_14
.L21_17:
	lw s1, -44(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -48(s0)
.L21_18:
	lw s1, -48(s0)
	bnez s1, .L21_19
	j .L21_20
.L21_19:
	lw s1, -44(s0)
	lw s2, -48(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L21_21
	j .L21_22
.L21_22:
	lw s1, -44(s0)
	lw s2, -48(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L21_21
	j .L21_20
.L21_21:
	li s1, 0
	lw s2, -44(s0)
	addi s3, s0, -48
	lw s4, 0(s3)
	li s3, -1
	add s5, s4, s3
	sw s5, -48(s0)
	add s3, s2, s5
	sb s1, 0(s3)
	j .L21_18
.L21_20:
	lw s1, -44(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 59
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L21_23
	j .L21_24
.L21_23:
	la s1, __str_230
	sw s1, -44(s0)
.L21_24:
	lw s1, -44(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s6, s3, s4
	sw s6, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -40(s0)
	bnez s1, .L21_25
	j .L21_26
.L21_25:
	lw s1, -40(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -52(s0)
	j .L21_27
.L21_26:
	li s1, 0
	sw s1, -52(s0)
.L21_27:
	lw s1, -52(s0)
	sw s1, -36(s0)
	j .L21_6
.L21_8:
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
.Lfunc_end21:
	.size split_lines, .Lfunc_end21-split_lines

	.text
	.align 2
	.globl kpm_read
	.type kpm_read, @function
kpm_read:
	addi sp, sp, -848
	sw ra, 844(sp)
	sw s0, 840(sp)
	addi s0, sp, 840
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
	li s1, 0
	sw s1, -52(s0)
	li s1, 0
	sw s1, -56(s0)
	li s1, 0
	sw s1, -60(s0)
	li s1, 0
	sw s1, -64(s0)
	li s1, 0
	sw s1, -68(s0)
	li s1, 0
	sw s1, -72(s0)
	li s1, 0
	sw s1, -76(s0)
	li s1, 0
	sw s1, -80(s0)
	lw s1, -4(s0)
	li s2, 0
	li s3, 64
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, arena_init
	mv s2, a0
	lw s1, -4(s0)
	addi s2, s0, -48
	sw s1, 0(s2)
	lw s1, -16(s0)
	addi s2, s0, -48
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	addi s2, s0, -48
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	bnez s1, .L22_0
	j .L22_1
.L22_0:
	lw s1, -20(s0)
	bnez s1, .L22_2
	j .L22_1
.L22_2:
	li s1, 0
	lw s2, -16(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
.L22_1:
	addi s1, s0, -48
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, split_lines
	mv s4, a0
.L22_3:
	addi s1, s0, -48
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -48
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L22_4
	j .L22_5
.L22_4:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_6
	j .L22_5
.L22_6:
	addi s1, s0, -48
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L22_3
.L22_5:
	addi s1, s0, -48
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -48
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_7
	j .L22_8
.L22_8:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_231
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L22_7
	j .L22_9
.L22_7:
	addi s1, s0, -48
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_232
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	j .L22_10
.L22_9:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -336
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -340(s0)
	lw s1, -340(s0)
	li s2, 2
	slt s3, s1, s2
	bnez s3, .L22_11
	j .L22_12
.L22_12:
	addi s1, s0, -336
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_233
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L22_11
	j .L22_13
.L22_11:
	addi s1, s0, -48
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_234
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	j .L22_10
.L22_13:
	addi s1, s0, -48
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 0
	sw s1, -344(s0)
.L22_14:
	lw s1, -344(s0)
	addi s2, s0, -48
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L22_15
	j .L22_16
.L22_15:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -344(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_235
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_17
	j .L22_18
.L22_17:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L22_19
.L22_18:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -344(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_236
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_20
	j .L22_21
.L22_20:
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -64(s0)
	j .L22_22
.L22_21:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -344(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_237
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_23
	j .L22_24
.L22_23:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
.L22_24:
.L22_22:
.L22_19:
.L22_25:
	addi s1, s0, -344
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -344(s0)
	j .L22_14
.L22_16:
	lw s1, -60(s0)
	bnez s1, .L22_26
	j .L22_27
.L22_26:
	lw s1, -4(s0)
	lw s2, -60(s0)
	li s3, 28
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
.L22_27:
	lw s1, -64(s0)
	bnez s1, .L22_28
	j .L22_29
.L22_28:
	lw s1, -4(s0)
	lw s2, -64(s0)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
.L22_29:
	lw s1, -76(s0)
	bnez s1, .L22_30
	j .L22_31
.L22_30:
	lw s1, -4(s0)
	lw s2, -76(s0)
	li s3, 8
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
.L22_31:
.L22_32:
	addi s1, s0, -48
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -48
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L22_33
	j .L22_34
.L22_33:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -348(s0)
	lw s1, -348(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_35
	j .L22_36
.L22_35:
	j .L22_37
.L22_36:
	lw s1, -348(s0)
	la s2, __str_238
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_38
	j .L22_39
.L22_38:
	lw s1, -348(s0)
	addi s2, s0, -608
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -612(s0)
	lw s1, -612(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_40
	j .L22_41
.L22_40:
	lw s1, -4(s0)
	addi s2, s0, -608
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -4(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, kpm_is_arch_tag
	mv s2, a0
	bnez s2, .L22_42
	j .L22_43
.L22_42:
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_239
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L22_44
	j .L22_45
.L22_44:
	addi s1, s0, -744
	li s2, 128
	la s3, __str_240
	addi s4, s0, -608
	li s5, 1
	li s6, 4
	mul s7, s5, s6
	add s5, s4, s7
	lw s4, 0(s5)
	la s5, __str_241
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, snprintf
	mv s6, a0
	addi sp, sp, 16
	addi s1, s0, -48
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	addi s2, s0, -744
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	j .L22_10
.L22_45:
	j .L22_46
.L22_43:
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_242
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_47
	j .L22_48
.L22_48:
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_243
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_47
	j .L22_49
.L22_47:
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	bnez s2, .L22_50
	j .L22_51
.L22_50:
	la s2, __str_244
	sw s2, -748(s0)
	j .L22_52
.L22_51:
	la s2, __str_245
	sw s2, -748(s0)
.L22_52:
	lw s2, -748(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L22_53
	j .L22_49
.L22_53:
	addi s1, s0, -48
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	li s2, 0
	bnez s2, .L22_54
	j .L22_55
.L22_54:
	la s2, __str_246
	sw s2, -756(s0)
	j .L22_56
.L22_55:
	la s2, __str_247
	sw s2, -756(s0)
.L22_56:
	lw s2, -756(s0)
	la s3, __str_248
	mv a0, s2
	mv a1, s3
	jal ra, strcmp
	mv s5, a0
	li s2, 0
	xor s3, s5, s2
	seqz s3, s3
	bnez s3, .L22_57
	j .L22_58
.L22_57:
	la s2, __str_249
	sw s2, -752(s0)
	j .L22_59
.L22_58:
	la s2, __str_250
	sw s2, -752(s0)
.L22_59:
	lw s2, -752(s0)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	j .L22_10
.L22_49:
.L22_46:
.L22_41:
	j .L22_60
.L22_39:
	lw s1, -348(s0)
	la s2, __str_251
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_61
	j .L22_62
.L22_61:
	lw s1, -348(s0)
	addi s2, s0, -608
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -612(s0)
	lw s1, -612(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_63
	j .L22_64
.L22_63:
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_252
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_65
	j .L22_66
.L22_65:
	li s1, 0
	lw s2, -4(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	j .L22_67
.L22_66:
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_253
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_68
	j .L22_69
.L22_68:
	li s1, 1
	lw s2, -4(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	j .L22_70
.L22_69:
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_254
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_71
	j .L22_72
.L22_71:
	li s1, 2
	lw s2, -4(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	j .L22_73
.L22_72:
	addi s1, s0, -48
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_255
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	j .L22_10
.L22_73:
.L22_70:
.L22_67:
	lw s1, -612(s0)
	li s2, 3
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_74
	j .L22_75
.L22_74:
	lw s1, -4(s0)
	addi s2, s0, -608
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -4(s0)
	li s2, 36
	add s4, s1, s2
	sw s3, 0(s4)
.L22_75:
.L22_64:
	j .L22_76
.L22_62:
	lw s1, -348(s0)
	la s2, __str_256
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_77
	j .L22_78
.L22_77:
	lw s1, -348(s0)
	addi s2, s0, -608
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -612(s0)
	lw s1, -612(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_79
	j .L22_80
.L22_79:
	lw s1, -4(s0)
	addi s2, s0, -608
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -4(s0)
	li s2, 40
	add s4, s1, s2
	sw s3, 0(s4)
.L22_80:
	j .L22_81
.L22_78:
	lw s1, -348(s0)
	la s2, __str_257
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_82
	j .L22_83
.L22_82:
	lw s1, -348(s0)
	addi s2, s0, -608
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -612(s0)
	lw s1, -612(s0)
	li s2, 4
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_84
	j .L22_85
.L22_84:
	addi s1, s0, -608
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_258
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_86
	j .L22_85
.L22_86:
	lw s1, -4(s0)
	addi s2, s0, -608
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -4(s0)
	li s2, 56
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -80(s0)
	li s4, 8
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -608
	li s2, 3
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoul
	mv s4, a0
	lw s1, -4(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -80(s0)
	li s3, 8
	mul s5, s2, s3
	add s2, s1, s5
	li s1, 4
	add s3, s2, s1
	sw s4, 0(s3)
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -80(s0)
	j .L22_87
.L22_85:
	lw s1, -612(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_88
	j .L22_89
.L22_88:
	lw s1, -4(s0)
	addi s2, s0, -608
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -4(s0)
	li s2, 56
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -80(s0)
	li s4, 8
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	li s1, 0
	lw s2, -4(s0)
	li s3, 56
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -80(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -80(s0)
.L22_89:
.L22_87:
	j .L22_90
.L22_83:
	lw s1, -348(s0)
	la s2, __str_259
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_91
	j .L22_92
.L22_91:
	addi s1, s0, -48
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	sw s3, -760(s0)
	lw s1, -348(s0)
	addi s2, s0, -608
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -612(s0)
	lw s1, -612(s0)
	li s2, 3
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_93
	j .L22_94
.L22_93:
	addi s1, s0, -608
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_260
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_95
	j .L22_94
.L22_95:
	addi s1, s0, -608
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoul
	mv s4, a0
	lw s1, -4(s0)
	li s2, 52
	add s3, s1, s2
	sw s4, 0(s3)
.L22_94:
.L22_96:
	lw s1, -760(s0)
	addi s2, s0, -48
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L22_97
	j .L22_98
.L22_97:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -760(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_261
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_98
	j .L22_99
.L22_99:
	addi s1, s0, -760
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -760(s0)
	j .L22_96
.L22_98:
	lw s1, -760(s0)
	addi s2, s0, -48
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_100
	j .L22_101
.L22_100:
	addi s1, s0, -48
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_262
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	j .L22_10
.L22_101:
	lw s1, -760(s0)
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	j .L22_102
.L22_92:
	lw s1, -348(s0)
	la s2, __str_263
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_103
	j .L22_104
.L22_103:
	lw s1, -348(s0)
	mv a0, s1
	jal ra, quoted_body
	mv s2, a0
	sw s2, -764(s0)
	lw s1, -764(s0)
	bnez s1, .L22_105
	j .L22_106
.L22_105:
	lw s1, -4(s0)
	lw s2, -764(s0)
	addi s3, s0, -768
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, unescape
	mv s4, a0
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	sw s4, 0(s3)
.L22_106:
	j .L22_107
.L22_104:
	lw s1, -348(s0)
	la s2, __str_264
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_108
	j .L22_109
.L22_108:
	addi s1, s0, -48
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -68
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -68(s0)
	li s3, 28
	mul s5, s4, s3
	add s3, s2, s5
	mv a0, s1
	mv a1, s3
	jal ra, read_import
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L22_110
	j .L22_111
.L22_110:
	j .L22_10
.L22_111:
	j .L22_112
.L22_109:
	lw s1, -348(s0)
	la s2, __str_265
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_113
	j .L22_114
.L22_113:
	lw s1, -348(s0)
	addi s2, s0, -608
	mv a0, s1
	mv a1, s2
	jal ra, tokenize
	mv s3, a0
	sw s3, -612(s0)
	lw s1, -612(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_115
	j .L22_116
.L22_115:
	lw s1, -4(s0)
	addi s2, s0, -608
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -4(s0)
	li s2, 24
	add s4, s1, s2
	lw s1, 0(s4)
	addi s2, s0, -72
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -72(s0)
	li s2, 4
	mul s5, s4, s2
	add s2, s1, s5
	sw s3, 0(s2)
.L22_116:
	j .L22_117
.L22_114:
	lw s1, -348(s0)
	la s2, __str_266
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_118
	j .L22_119
.L22_118:
	lw s1, -4(s0)
	li s2, 68
	mv a0, s1
	mv a1, s2
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -772(s0)
	addi s1, s0, -48
	lw s2, -772(s0)
	mv a0, s1
	mv a1, s2
	jal ra, read_global
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L22_120
	j .L22_121
.L22_120:
	j .L22_10
.L22_121:
	lw s1, -56(s0)
	bnez s1, .L22_122
	j .L22_123
.L22_122:
	lw s1, -772(s0)
	lw s2, -56(s0)
	li s3, 64
	add s4, s2, s3
	sw s1, 0(s4)
	j .L22_124
.L22_123:
	lw s1, -772(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	sw s1, 0(s3)
.L22_124:
	lw s1, -772(s0)
	sw s1, -56(s0)
	j .L22_125
.L22_119:
	lw s1, -348(s0)
	la s2, __str_267
	mv a0, s1
	mv a1, s2
	jal ra, kw
	mv s3, a0
	bnez s3, .L22_126
	j .L22_127
.L22_126:
	lw s1, -4(s0)
	la s2, __str_268
	mv a0, s1
	mv a1, s2
	jal ra, ir_new_func
	mv s3, a0
	sw s3, -776(s0)
	addi s1, s0, -48
	lw s2, -776(s0)
	mv a0, s1
	mv a1, s2
	jal ra, read_func
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L22_128
	j .L22_129
.L22_128:
	j .L22_10
.L22_129:
	lw s1, -52(s0)
	bnez s1, .L22_130
	j .L22_131
.L22_130:
	lw s1, -776(s0)
	lw s2, -52(s0)
	li s3, 100
	add s4, s2, s3
	sw s1, 0(s4)
	j .L22_132
.L22_131:
	lw s1, -776(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
.L22_132:
	lw s1, -776(s0)
	sw s1, -52(s0)
	j .L22_133
.L22_127:
	addi s1, s0, -48
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	la s2, __str_269
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fail
	mv s3, a0
	j .L22_10
.L22_133:
.L22_125:
.L22_117:
.L22_112:
.L22_107:
.L22_102:
.L22_90:
.L22_81:
.L22_76:
.L22_60:
.L22_37:
	addi s1, s0, -48
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L22_32
.L22_34:
	lw s1, -68(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -72(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -80(s0)
	lw s2, -4(s0)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -780(s0)
.L22_134:
	lw s1, -780(s0)
	bnez s1, .L22_135
	j .L22_136
.L22_135:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -780(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L22_137:
	lw s1, -780(s0)
	li s2, 100
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -780(s0)
	j .L22_134
.L22_136:
	li s1, 0
	mv a0, s1
	lw s1, -828(s0)
	lw s2, -824(s0)
	lw s3, -820(s0)
	lw s4, -816(s0)
	lw s5, -812(s0)
	lw s6, -808(s0)
	lw s7, -804(s0)
	lw s8, -800(s0)
	lw s9, -796(s0)
	lw s10, -792(s0)
	lw s11, -788(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L22_10:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, arena_free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 0
	li s3, 64
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -828(s0)
	lw s2, -824(s0)
	lw s3, -820(s0)
	lw s4, -816(s0)
	lw s5, -812(s0)
	lw s6, -808(s0)
	lw s7, -804(s0)
	lw s8, -800(s0)
	lw s9, -796(s0)
	lw s10, -792(s0)
	lw s11, -788(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end22:
	.size kpm_read, .Lfunc_end22-kpm_read

	.text
	.align 2
	.globl kpm_free
	.type kpm_free, @function
kpm_free:
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
	mv a0, s1
	jal ra, arena_free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 0
	li s3, 64
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
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
.Lfunc_end23:
	.size kpm_free, .Lfunc_end23-kpm_free

	.data
	.align 2
__str_269:
	.ascii "unexpected top-level line\000"
	.align 2
__str_268:
	.ascii "\000"
	.align 2
__str_267:
	.ascii ".func\000"
	.align 2
__str_266:
	.ascii ".global\000"
	.align 2
__str_265:
	.ascii ".export\000"
	.align 2
__str_264:
	.ascii ".import\000"
	.align 2
__str_263:
	.ascii ".file\000"
	.align 2
__str_262:
	.ascii "unterminated .interface\000"
	.align 2
__str_261:
	.ascii ".endinterface\000"
	.align 2
__str_260:
	.ascii "fingerprint\000"
	.align 2
__str_259:
	.ascii ".interface\000"
	.align 2
__str_258:
	.ascii "fingerprint\000"
	.align 2
__str_257:
	.ascii ".uses\000"
	.align 2
__str_256:
	.ascii ".entry\000"
	.align 2
__str_255:
	.ascii "unknown module kind\000"
	.align 2
__str_254:
	.ascii "executable\000"
	.align 2
__str_253:
	.ascii "library\000"
	.align 2
__str_252:
	.ascii "object\000"
	.align 2
__str_251:
	.ascii ".module\000"
	.align 2
__str_250:
	.ascii "KPM pointer-width mismatch: module is lp64, this backend is ilp32\000"
	.align 2
__str_249:
	.ascii "KPM pointer-width mismatch: module is ilp32, this backend is lp64\000"
	.align 2
__str_248:
	.ascii "lp64\000"
	.align 2
__str_247:
	.ascii "ilp32\000"
	.align 2
__str_246:
	.ascii "lp64\000"
	.align 2
__str_245:
	.ascii "ilp32\000"
	.align 2
__str_244:
	.ascii "lp64\000"
	.align 2
__str_243:
	.ascii "lp64\000"
	.align 2
__str_242:
	.ascii "ilp32\000"
	.align 2
__str_241:
	.ascii "rv32\000"
	.align 2
__str_240:
	.ascii "KPM target mismatch: module is %s, this backend is %s\000"
	.align 2
__str_239:
	.ascii "rv32\000"
	.align 2
__str_238:
	.ascii ".target\000"
	.align 2
__str_237:
	.ascii ".uses\000"
	.align 2
__str_236:
	.ascii ".export\000"
	.align 2
__str_235:
	.ascii ".import\000"
	.align 2
__str_234:
	.ascii "unsupported .kpm version\000"
	.align 2
__str_233:
	.ascii "1\000"
	.align 2
__str_232:
	.ascii "missing .kpm header\000"
	.align 2
__str_231:
	.ascii ".kpm\000"
	.align 2
__str_230:
	.ascii "\000"
	.align 2
__str_229:
	.ascii "unknown opcode\000"
	.align 2
__str_228:
	.ascii "missing ASM operand\000"
	.align 2
__str_227:
	.ascii "malformed ASM operand\000"
	.align 2
__str_226:
	.ascii "malformed ASM operand counts\000"
	.align 2
__str_225:
	.ascii "vol=\000"
	.align 2
__str_224:
	.ascii "nin=\000"
	.align 2
__str_223:
	.ascii "nout=\000"
	.align 2
__str_222:
	.ascii "malformed ASM\000"
	.align 2
__str_221:
	.ascii "malformed ASM\000"
	.align 2
__str_220:
	.ascii "ASM\000"
	.align 2
__str_219:
	.ascii "unexpected directive in .func\000"
	.align 2
__str_218:
	.ascii ".retcls\000"
	.align 2
__str_217:
	.ascii ".retneb\000"
	.align 2
__str_216:
	.ascii ".paramcls\000"
	.align 2
__str_215:
	.ascii ".paramneb\000"
	.align 2
__str_214:
	.ascii ".paramfw\000"
	.align 2
__str_213:
	.ascii ".paramclass\000"
	.align 2
__str_212:
	.ascii ".slotsize\000"
	.align 2
__str_211:
	.ascii ".endfunc\000"
	.align 2
__str_210:
	.ascii "unterminated .func\000"
	.align 2
__str_209:
	.ascii "more parameters than slots\000"
	.align 2
__str_208:
	.ascii "function count out of range\000"
	.align 2
__str_207:
	.ascii "labels\000"
	.align 2
__str_206:
	.ascii "temps\000"
	.align 2
__str_205:
	.ascii "slots\000"
	.align 2
__str_204:
	.ascii "params\000"
	.align 2
__str_203:
	.ascii "from\000"
	.align 2
__str_202:
	.ascii "variadic\000"
	.align 2
__str_201:
	.ascii "local\000"
	.align 2
__str_200:
	.ascii "malformed .func\000"
	.align 2
__str_199:
	.ascii "temp index out of range\000"
	.align 2
__str_198:
	.ascii "missing label operand\000"
	.align 2
__str_197:
	.ascii "missing slot operand\000"
	.align 2
__str_196:
	.ascii "sym\000"
	.align 2
__str_195:
	.ascii "nargs\000"
	.align 2
__str_194:
	.ascii "label index out of range\000"
	.align 2
__str_193:
	.ascii "label\000"
	.align 2
__str_192:
	.ascii "slot index out of range\000"
	.align 2
__str_191:
	.ascii "slot\000"
	.align 2
__str_190:
	.ascii "imm\000"
	.align 2
__str_189:
	.ascii "b\000"
	.align 2
__str_188:
	.ascii "a\000"
	.align 2
__str_187:
	.ascii "dst\000"
	.align 2
__str_186:
	.ascii "unexpected line in .global\000"
	.align 2
__str_185:
	.ascii "malformed .string\000"
	.align 2
__str_184:
	.ascii ".string\000"
	.align 2
__str_183:
	.ascii "sym\000"
	.align 2
__str_182:
	.ascii ".init\000"
	.align 2
__str_181:
	.ascii ".endglobal\000"
	.align 2
__str_180:
	.ascii "unterminated .global\000"
	.align 2
__str_179:
	.ascii ".endglobal\000"
	.align 2
__str_178:
	.ascii ".init\000"
	.align 2
__str_177:
	.ascii "global size or alignment out of range\000"
	.align 2
__str_176:
	.ascii "from\000"
	.align 2
__str_175:
	.ascii "strobj\000"
	.align 2
__str_174:
	.ascii "rodata\000"
	.align 2
__str_173:
	.ascii "export\000"
	.align 2
__str_172:
	.ascii "ptr\000"
	.align 2
__str_171:
	.ascii "local\000"
	.align 2
__str_170:
	.ascii "align\000"
	.align 2
__str_169:
	.ascii "array\000"
	.align 2
__str_168:
	.ascii "unknown base type\000"
	.align 2
__str_167:
	.ascii "malformed .global\000"
	.align 2
__str_166:
	.ascii "expected .method\000"
	.align 2
__str_165:
	.ascii ".method\000"
	.align 2
__str_164:
	.ascii "unexpected end inside .import type\000"
	.align 2
__str_163:
	.ascii "method count out of range\000"
	.align 2
__str_162:
	.ascii "methods\000"
	.align 2
__str_161:
	.ascii "unknown import kind\000"
	.align 2
__str_160:
	.ascii "type\000"
	.align 2
__str_159:
	.ascii "helper\000"
	.align 2
__str_158:
	.ascii "func\000"
	.align 2
__str_157:
	.ascii "malformed .import\000"
	.align 2
__str_156:
	.ascii "line %d: %s\000"
	.align 2
__str_155:
	.ascii "->\000"
	.align 2
__str_154:
	.ascii ")\000"
	.align 2
__str_153:
	.ascii "(\000"
	.align 2
__str_152:
	.ascii "f64\000"
	.align 2
__str_151:
	.ascii "f32\000"
	.align 2
__str_150:
	.ascii "i64\000"
	.align 2
__str_149:
	.ascii "i32\000"
	.align 2
__str_148:
	.ascii "i16\000"
	.align 2
__str_147:
	.ascii "i8\000"
	.align 2
__str_146:
	.ascii "x86-32\000"
	.align 2
__str_145:
	.ascii "mips\000"
	.align 2
__str_144:
	.ascii "arm64\000"
	.align 2
__str_143:
	.ascii "x86-64\000"
	.align 2
__str_142:
	.ascii "cf\000"
	.align 2
__str_141:
	.ascii "rv32\000"
	.align 2
__str_140:
	.ascii "IJMP64\000"
	.align 2
__str_139:
	.ascii "LABADDR64\000"
	.align 2
__str_138:
	.ascii "IJMP\000"
	.align 2
__str_137:
	.ascii "LABADDR\000"
	.align 2
__str_136:
	.ascii "ASM\000"
	.align 2
__str_135:
	.ascii "ARG_X8\000"
	.align 2
__str_134:
	.ascii "ARG_MEM\000"
	.align 2
__str_133:
	.ascii "CALLI2\000"
	.align 2
__str_132:
	.ascii "CALL2\000"
	.align 2
__str_131:
	.ascii "RETV2\000"
	.align 2
__str_130:
	.ascii "CALLI_AGG\000"
	.align 2
__str_129:
	.ascii "CALL_AGG\000"
	.align 2
__str_128:
	.ascii "RETV_AGG\000"
	.align 2
__str_127:
	.ascii "CALLI64\000"
	.align 2
__str_126:
	.ascii "CALL64\000"
	.align 2
__str_125:
	.ascii "RETV64\000"
	.align 2
__str_124:
	.ascii "ARG64\000"
	.align 2
__str_123:
	.ascii "TRUNC64\000"
	.align 2
__str_122:
	.ascii "ZEXT64\000"
	.align 2
__str_121:
	.ascii "SEXT64\000"
	.align 2
__str_120:
	.ascii "VA_START\000"
	.align 2
__str_119:
	.ascii "STL64\000"
	.align 2
__str_118:
	.ascii "LDL64\000"
	.align 2
__str_117:
	.ascii "ST64\000"
	.align 2
__str_116:
	.ascii "LD64\000"
	.align 2
__str_115:
	.ascii "CMP64GEU\000"
	.align 2
__str_114:
	.ascii "CMP64GTU\000"
	.align 2
__str_113:
	.ascii "CMP64LEU\000"
	.align 2
__str_112:
	.ascii "CMP64LTU\000"
	.align 2
__str_111:
	.ascii "CMP64GES\000"
	.align 2
__str_110:
	.ascii "CMP64GTS\000"
	.align 2
__str_109:
	.ascii "CMP64LES\000"
	.align 2
__str_108:
	.ascii "CMP64LTS\000"
	.align 2
__str_107:
	.ascii "CMP64NE\000"
	.align 2
__str_106:
	.ascii "CMP64EQ\000"
	.align 2
__str_105:
	.ascii "NEG64\000"
	.align 2
__str_104:
	.ascii "SHRU64\000"
	.align 2
__str_103:
	.ascii "SHRS64\000"
	.align 2
__str_102:
	.ascii "SHL64\000"
	.align 2
__str_101:
	.ascii "XOR64\000"
	.align 2
__str_100:
	.ascii "OR64\000"
	.align 2
__str_99:
	.ascii "AND64\000"
	.align 2
__str_98:
	.ascii "MODU64\000"
	.align 2
__str_97:
	.ascii "MODS64\000"
	.align 2
__str_96:
	.ascii "DIVU64\000"
	.align 2
__str_95:
	.ascii "DIVS64\000"
	.align 2
__str_94:
	.ascii "MUL64\000"
	.align 2
__str_93:
	.ascii "SUB64\000"
	.align 2
__str_92:
	.ascii "ADD64\000"
	.align 2
__str_91:
	.ascii "LIC64\000"
	.align 2
__str_90:
	.ascii "FCALLI\000"
	.align 2
__str_89:
	.ascii "FCALL\000"
	.align 2
__str_88:
	.ascii "FRETV\000"
	.align 2
__str_87:
	.ascii "FSTL\000"
	.align 2
__str_86:
	.ascii "FLDL\000"
	.align 2
__str_85:
	.ascii "FSH\000"
	.align 2
__str_84:
	.ascii "FLH\000"
	.align 2
__str_83:
	.ascii "FSD\000"
	.align 2
__str_82:
	.ascii "FSS\000"
	.align 2
__str_81:
	.ascii "FLD\000"
	.align 2
__str_80:
	.ascii "FLS\000"
	.align 2
__str_79:
	.ascii "F64TOF32\000"
	.align 2
__str_78:
	.ascii "F32TOF64\000"
	.align 2
__str_77:
	.ascii "FROUND\000"
	.align 2
__str_76:
	.ascii "FTOI\000"
	.align 2
__str_75:
	.ascii "ITOF\000"
	.align 2
__str_74:
	.ascii "FCMPLE\000"
	.align 2
__str_73:
	.ascii "FCMPLT\000"
	.align 2
__str_72:
	.ascii "FCMPEQ\000"
	.align 2
__str_71:
	.ascii "FSQRT\000"
	.align 2
__str_70:
	.ascii "FABS\000"
	.align 2
__str_69:
	.ascii "FNEG\000"
	.align 2
__str_68:
	.ascii "FDIV\000"
	.align 2
__str_67:
	.ascii "FMUL\000"
	.align 2
__str_66:
	.ascii "FSUB\000"
	.align 2
__str_65:
	.ascii "FADD\000"
	.align 2
__str_64:
	.ascii "CONT_UNWIND\000"
	.align 2
__str_63:
	.ascii "RESUME\000"
	.align 2
__str_62:
	.ascii "CAPTURE\000"
	.align 2
__str_61:
	.ascii "MARK\000"
	.align 2
__str_60:
	.ascii "LABEL\000"
	.align 2
__str_59:
	.ascii "ENDF\000"
	.align 2
__str_58:
	.ascii "FUNC\000"
	.align 2
__str_57:
	.ascii "RETV\000"
	.align 2
__str_56:
	.ascii "RET\000"
	.align 2
__str_55:
	.ascii "TAILCALLI\000"
	.align 2
__str_54:
	.ascii "TAILCALL\000"
	.align 2
__str_53:
	.ascii "CALLI\000"
	.align 2
__str_52:
	.ascii "CALL\000"
	.align 2
__str_51:
	.ascii "FARG\000"
	.align 2
__str_50:
	.ascii "ARG\000"
	.align 2
__str_49:
	.ascii "BNZ\000"
	.align 2
__str_48:
	.ascii "BZ\000"
	.align 2
__str_47:
	.ascii "JMP\000"
	.align 2
__str_46:
	.ascii "CMPGEU\000"
	.align 2
__str_45:
	.ascii "CMPGTU\000"
	.align 2
__str_44:
	.ascii "CMPLEU\000"
	.align 2
__str_43:
	.ascii "CMPLTU\000"
	.align 2
__str_42:
	.ascii "CMPGES\000"
	.align 2
__str_41:
	.ascii "CMPGTS\000"
	.align 2
__str_40:
	.ascii "CMPLES\000"
	.align 2
__str_39:
	.ascii "CMPLTS\000"
	.align 2
__str_38:
	.ascii "CMPNE\000"
	.align 2
__str_37:
	.ascii "CMPEQ\000"
	.align 2
__str_36:
	.ascii "ALLOCA\000"
	.align 2
__str_35:
	.ascii "STL\000"
	.align 2
__str_34:
	.ascii "LDL\000"
	.align 2
__str_33:
	.ascii "SW\000"
	.align 2
__str_32:
	.ascii "SH\000"
	.align 2
__str_31:
	.ascii "SB\000"
	.align 2
__str_30:
	.ascii "LW\000"
	.align 2
__str_29:
	.ascii "LHS\000"
	.align 2
__str_28:
	.ascii "LH\000"
	.align 2
__str_27:
	.ascii "LBS\000"
	.align 2
__str_26:
	.ascii "LB\000"
	.align 2
__str_25:
	.ascii "NOT\000"
	.align 2
__str_24:
	.ascii "NEG\000"
	.align 2
__str_23:
	.ascii "SHRU\000"
	.align 2
__str_22:
	.ascii "SHRS\000"
	.align 2
__str_21:
	.ascii "SHL\000"
	.align 2
__str_20:
	.ascii "XOR\000"
	.align 2
__str_19:
	.ascii "OR\000"
	.align 2
__str_18:
	.ascii "AND\000"
	.align 2
__str_17:
	.ascii "MODU\000"
	.align 2
__str_16:
	.ascii "MODS\000"
	.align 2
__str_15:
	.ascii "DIVU\000"
	.align 2
__str_14:
	.ascii "DIVS\000"
	.align 2
__str_13:
	.ascii "LOC\000"
	.align 2
__str_12:
	.ascii "MULO\000"
	.align 2
__str_11:
	.ascii "SUBO\000"
	.align 2
__str_10:
	.ascii "ADDO\000"
	.align 2
__str_9:
	.ascii "MUL\000"
	.align 2
__str_8:
	.ascii "SUB\000"
	.align 2
__str_7:
	.ascii "ADD\000"
	.align 2
__str_6:
	.ascii "ADL64\000"
	.align 2
__str_5:
	.ascii "LEA64\000"
	.align 2
__str_4:
	.ascii "MOV\000"
	.align 2
__str_3:
	.ascii "ADL\000"
	.align 2
__str_2:
	.ascii "LEA\000"
	.align 2
__str_1:
	.ascii "LIC\000"
	.align 2
__str_0:
	.ascii "NOP\000"

	.section .rodata
	.align 2
	.globl op_count
op_count:
	.word 141
	.align 2
	.globl op_table
op_table:
	.word __str_0
	.word 0x00000000
	.word __str_1
	.word 0x00000001
	.word __str_2
	.word 0x00000002
	.word __str_3
	.word 0x00000003
	.word __str_4
	.word 0x00000004
	.word __str_5
	.word 0x00000072
	.word __str_6
	.word 0x00000073
	.word __str_7
	.word 0x00000005
	.word __str_8
	.word 0x00000006
	.word __str_9
	.word 0x00000007
	.word __str_10
	.word 0x00000082
	.word __str_11
	.word 0x00000083
	.word __str_12
	.word 0x00000084
	.word __str_13
	.word 0x00000085
	.word __str_14
	.word 0x00000008
	.word __str_15
	.word 0x00000009
	.word __str_16
	.word 0x0000000a
	.word __str_17
	.word 0x0000000b
	.word __str_18
	.word 0x0000000c
	.word __str_19
	.word 0x0000000d
	.word __str_20
	.word 0x0000000e
	.word __str_21
	.word 0x0000000f
	.word __str_22
	.word 0x00000010
	.word __str_23
	.word 0x00000011
	.word __str_24
	.word 0x00000012
	.word __str_25
	.word 0x00000013
	.word __str_26
	.word 0x00000014
	.word __str_27
	.word 0x00000015
	.word __str_28
	.word 0x00000016
	.word __str_29
	.word 0x00000017
	.word __str_30
	.word 0x00000018
	.word __str_31
	.word 0x00000019
	.word __str_32
	.word 0x0000001a
	.word __str_33
	.word 0x0000001b
	.word __str_34
	.word 0x0000001c
	.word __str_35
	.word 0x0000001d
	.word __str_36
	.word 0x0000001e
	.word __str_37
	.word 0x0000001f
	.word __str_38
	.word 0x00000020
	.word __str_39
	.word 0x00000021
	.word __str_40
	.word 0x00000022
	.word __str_41
	.word 0x00000023
	.word __str_42
	.word 0x00000024
	.word __str_43
	.word 0x00000025
	.word __str_44
	.word 0x00000026
	.word __str_45
	.word 0x00000027
	.word __str_46
	.word 0x00000028
	.word __str_47
	.word 0x00000029
	.word __str_48
	.word 0x0000002a
	.word __str_49
	.word 0x0000002b
	.word __str_50
	.word 0x0000002c
	.word __str_51
	.word 0x0000002d
	.word __str_52
	.word 0x0000002e
	.word __str_53
	.word 0x0000002f
	.word __str_54
	.word 0x00000030
	.word __str_55
	.word 0x00000031
	.word __str_56
	.word 0x00000032
	.word __str_57
	.word 0x00000033
	.word __str_58
	.word 0x00000034
	.word __str_59
	.word 0x00000035
	.word __str_60
	.word 0x00000036
	.word __str_61
	.word 0x00000037
	.word __str_62
	.word 0x00000038
	.word __str_63
	.word 0x00000039
	.word __str_64
	.word 0x0000003a
	.word __str_65
	.word 0x0000003b
	.word __str_66
	.word 0x0000003c
	.word __str_67
	.word 0x0000003d
	.word __str_68
	.word 0x0000003e
	.word __str_69
	.word 0x0000003f
	.word __str_70
	.word 0x00000040
	.word __str_71
	.word 0x00000041
	.word __str_72
	.word 0x00000042
	.word __str_73
	.word 0x00000043
	.word __str_74
	.word 0x00000044
	.word __str_75
	.word 0x00000045
	.word __str_76
	.word 0x00000046
	.word __str_77
	.word 0x00000047
	.word __str_78
	.word 0x00000048
	.word __str_79
	.word 0x00000049
	.word __str_80
	.word 0x0000004a
	.word __str_81
	.word 0x0000004b
	.word __str_82
	.word 0x0000004c
	.word __str_83
	.word 0x0000004d
	.word __str_84
	.word 0x0000004e
	.word __str_85
	.word 0x0000004f
	.word __str_86
	.word 0x00000050
	.word __str_87
	.word 0x00000051
	.word __str_88
	.word 0x00000052
	.word __str_89
	.word 0x00000053
	.word __str_90
	.word 0x00000054
	.word __str_91
	.word 0x00000055
	.word __str_92
	.word 0x00000056
	.word __str_93
	.word 0x00000057
	.word __str_94
	.word 0x00000058
	.word __str_95
	.word 0x00000059
	.word __str_96
	.word 0x0000005a
	.word __str_97
	.word 0x0000005b
	.word __str_98
	.word 0x0000005c
	.word __str_99
	.word 0x0000005d
	.word __str_100
	.word 0x0000005e
	.word __str_101
	.word 0x0000005f
	.word __str_102
	.word 0x00000060
	.word __str_103
	.word 0x00000061
	.word __str_104
	.word 0x00000062
	.word __str_105
	.word 0x00000063
	.word __str_106
	.word 0x00000064
	.word __str_107
	.word 0x00000065
	.word __str_108
	.word 0x00000066
	.word __str_109
	.word 0x00000067
	.word __str_110
	.word 0x00000068
	.word __str_111
	.word 0x00000069
	.word __str_112
	.word 0x0000006a
	.word __str_113
	.word 0x0000006b
	.word __str_114
	.word 0x0000006c
	.word __str_115
	.word 0x0000006d
	.word __str_116
	.word 0x0000006e
	.word __str_117
	.word 0x0000006f
	.word __str_118
	.word 0x00000070
	.word __str_119
	.word 0x00000071
	.word __str_120
	.word 0x00000074
	.word __str_121
	.word 0x00000075
	.word __str_122
	.word 0x00000076
	.word __str_123
	.word 0x00000077
	.word __str_124
	.word 0x00000078
	.word __str_125
	.word 0x00000079
	.word __str_126
	.word 0x0000007a
	.word __str_127
	.word 0x0000007b
	.word __str_128
	.word 0x0000007c
	.word __str_129
	.word 0x0000007d
	.word __str_130
	.word 0x0000007e
	.word __str_131
	.word 0x00000086
	.word __str_132
	.word 0x00000087
	.word __str_133
	.word 0x00000088
	.word __str_134
	.word 0x0000007f
	.word __str_135
	.word 0x00000080
	.word __str_136
	.word 0x00000081
	.word __str_137
	.word 0x00000089
	.word __str_138
	.word 0x0000008a
	.word __str_139
	.word 0x0000008b
	.word __str_140
	.word 0x0000008c
