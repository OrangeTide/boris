# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl rv_ireg
	.type rv_ireg, @function
rv_ireg:
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
	la s2, __str_32
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_0
	j .L1_1
.L1_0:
	li s1, 8
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
	li s1, 0
	sw s1, -12(s0)
.L1_2:
	lw s1, -12(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L1_3
	j .L1_4
.L1_3:
	lw s1, -4(s0)
	la s2, rv_ireg.abi.0
	lw s3, -12(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_5
	j .L1_6
.L1_5:
	lw s1, -12(s0)
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
.L1_6:
.L1_7:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L1_2
.L1_4:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_8
	j .L1_9
.L1_8:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L1_10
	j .L1_9
.L1_10:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	addi s1, s0, -16
	li s2, 10
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, strtol
	mv s4, a0
	sw s4, -20(s0)
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_11
	j .L1_12
.L1_11:
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_13
	j .L1_12
.L1_13:
	lw s1, -20(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L1_14
	j .L1_12
.L1_14:
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
.L1_12:
.L1_9:
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
.Lfunc_end1:
	.size rv_ireg, .Lfunc_end1-rv_ireg

	.text
	.align 2
	.globl rv_freg
	.type rv_freg, @function
rv_freg:
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
	li s1, 0
	sw s1, -12(s0)
.L2_0:
	lw s1, -12(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L2_1
	j .L2_2
.L2_1:
	lw s1, -4(s0)
	la s2, rv_freg.abi.1
	lw s3, -12(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L2_3
	j .L2_4
.L2_3:
	lw s1, -12(s0)
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
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 102
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_6
	j .L2_7
.L2_6:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_8
	j .L2_7
.L2_8:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 57
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L2_9
	j .L2_7
.L2_9:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	addi s1, s0, -16
	li s2, 10
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, strtol
	mv s4, a0
	sw s4, -20(s0)
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L2_10
	j .L2_11
.L2_10:
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_12
	j .L2_11
.L2_12:
	lw s1, -20(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L2_13
	j .L2_11
.L2_13:
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
.L2_11:
.L2_7:
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
.Lfunc_end2:
	.size rv_freg, .Lfunc_end2-rv_freg

	.text
	.align 2
	.globl rv_csr
	.type rv_csr, @function
rv_csr:
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
.L3_0:
	lw s1, -12(s0)
	li s2, 176
	li s3, 8
	div s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L3_1
	j .L3_2
.L3_1:
	lw s1, -4(s0)
	la s2, rv_csr.csrs.2
	lw s3, -12(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
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
	la s1, rv_csr.csrs.2
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
	.size rv_csr, .Lfunc_end3-rv_csr

	.text
	.align 2
	.type rv_roundmode, @function
rv_roundmode:
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
	la s2, __str_87
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
.L4_1:
	lw s1, -4(s0)
	la s2, __str_88
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
.L4_3:
	lw s1, -4(s0)
	la s2, __str_89
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
.L4_5:
	lw s1, -4(s0)
	la s2, __str_90
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
.L4_7:
	lw s1, -4(s0)
	la s2, __str_91
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_8
	j .L4_9
.L4_8:
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
.L4_9:
	lw s1, -4(s0)
	la s2, __str_92
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_10
	j .L4_11
.L4_10:
	li s1, 7
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
.L4_11:
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
	.size rv_roundmode, .Lfunc_end4-rv_roundmode

	.text
	.align 2
	.type enc_r, @function
enc_r:
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
	sw a4, -20(s0)
	sw a5, -24(s0)
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 7
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -8(s0)
	li s3, 12
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -20(s0)
	li s3, 15
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -24(s0)
	li s3, 20
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -12(s0)
	li s3, 25
	sll s4, s2, s3
	or s2, s1, s4
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
.Lfunc_end5:
	.size enc_r, .Lfunc_end5-enc_r

	.text
	.align 2
	.type enc_i, @function
enc_i:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 7
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -8(s0)
	li s3, 12
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -16(s0)
	li s3, 15
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -20(s0)
	li s3, 4095
	and s4, s1, s3
	li s1, 20
	sll s3, s4, s1
	or s1, s2, s3
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
.Lfunc_end6:
	.size enc_i, .Lfunc_end6-enc_i

	.text
	.align 2
	.type enc_s, @function
enc_s:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 31
	and s4, s2, s3
	li s2, 7
	sll s3, s4, s2
	or s2, s1, s3
	lw s1, -8(s0)
	li s3, 12
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -12(s0)
	li s3, 15
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -16(s0)
	li s3, 20
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -20(s0)
	li s3, 5
	srl s4, s2, s3
	li s2, 127
	and s3, s4, s2
	li s2, 25
	sll s4, s3, s2
	or s2, s1, s4
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
.Lfunc_end7:
	.size enc_s, .Lfunc_end7-enc_s

	.text
	.align 2
	.type enc_b, @function
enc_b:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 11
	srl s4, s2, s3
	li s2, 1
	and s3, s4, s2
	li s2, 7
	sll s4, s3, s2
	or s2, s1, s4
	lw s1, -20(s0)
	li s3, 1
	srl s4, s1, s3
	li s1, 15
	and s3, s4, s1
	li s1, 8
	sll s4, s3, s1
	or s1, s2, s4
	lw s2, -8(s0)
	li s3, 12
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -12(s0)
	li s3, 15
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -16(s0)
	li s3, 20
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -20(s0)
	li s3, 5
	srl s4, s1, s3
	li s1, 63
	and s3, s4, s1
	li s1, 25
	sll s4, s3, s1
	or s1, s2, s4
	lw s2, -20(s0)
	li s3, 12
	srl s4, s2, s3
	li s2, 1
	and s3, s4, s2
	li s2, 31
	sll s4, s3, s2
	or s2, s1, s4
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
	.size enc_b, .Lfunc_end8-enc_b

	.text
	.align 2
	.type enc_u, @function
enc_u:
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
	lw s2, -8(s0)
	li s3, 7
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -12(s0)
	li s3, 1048575
	and s4, s1, s3
	li s1, 12
	sll s3, s4, s1
	or s1, s2, s3
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
	.size enc_u, .Lfunc_end9-enc_u

	.text
	.align 2
	.type enc_j, @function
enc_j:
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
	lw s2, -8(s0)
	li s3, 7
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -12(s0)
	li s3, 12
	srl s4, s1, s3
	li s1, 255
	and s3, s4, s1
	li s1, 12
	sll s4, s3, s1
	or s1, s2, s4
	lw s2, -12(s0)
	li s3, 11
	srl s4, s2, s3
	li s2, 1
	and s3, s4, s2
	li s2, 20
	sll s4, s3, s2
	or s2, s1, s4
	lw s1, -12(s0)
	li s3, 1
	srl s4, s1, s3
	li s1, 1023
	and s3, s4, s1
	li s1, 21
	sll s4, s3, s1
	or s1, s2, s4
	lw s2, -12(s0)
	li s3, 20
	srl s4, s2, s3
	li s2, 1
	and s3, s4, s2
	li s2, 31
	sll s4, s3, s2
	or s2, s1, s4
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
.Lfunc_end10:
	.size enc_j, .Lfunc_end10-enc_j

	.text
	.align 2
	.type cur, @function
cur:
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
	li s2, 328
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 552
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
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
.Lfunc_end11:
	.size cur, .Lfunc_end11-cur

	.text
	.align 2
	.type emit_word, @function
emit_word:
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
	mv a0, s1
	jal ra, cur
	mv s2, a0
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, sec_emit32
	mv s3, a0
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
.Lfunc_end12:
	.size emit_word, .Lfunc_end12-emit_word

	.text
	.align 2
	.type reloc_sym, @function
reloc_sym:
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
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L13_0
	j .L13_1
.L13_0:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -12(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -28(s0)
.L13_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	lw s1, -8(s0)
	lw s3, -28(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, sec_add_reloc_t
	mv s6, a0
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
	.size reloc_sym, .Lfunc_end13-reloc_sym

	.text
	.align 2
	.type new_pcrel_label, @function
new_pcrel_label:
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
	addi s1, s0, -40
	li s2, 32
	la s3, __str_93
	lw s4, -4(s0)
	li s5, 576
	add s6, s4, s5
	lw s4, 0(s6)
	li s5, 1
	add s7, s4, s5
	sw s7, 0(s6)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	li s2, 636
	add s3, s1, s2
	addi s1, s0, -40
	mv a0, s3
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	sw s2, -44(s0)
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -44(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L14_0
	j .L14_1
.L14_0:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -44(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_add
	mv s2, a0
	sw s2, -48(s0)
.L14_1:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -48(s0)
	lw s2, -4(s0)
	li s4, 552
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -8(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	mv a3, s4
	jal ra, sym_define
	mv s5, a0
	lw s1, -44(s0)
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
.Lfunc_end14:
	.size new_pcrel_label, .Lfunc_end14-new_pcrel_label

	.text
	.align 2
	.type branch_disp, @function
branch_disp:
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
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, -8(s0)
	mv a0, s3
	mv a1, s1
	jal ra, sym_lookup
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L15_0
	j .L15_1
.L15_0:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L15_2
	j .L15_1
.L15_2:
	li s1, 1
	j .L15_3
.L15_1:
	li s1, 0
.L15_3:
	sw s1, -24(s0)
	lw s1, -24(s0)
	bnez s1, .L15_4
	j .L15_5
.L15_4:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	lw s2, 0(s4)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_6
	j .L15_5
.L15_6:
	li s1, 1
	j .L15_7
.L15_5:
	li s1, 0
.L15_7:
	sw s1, -28(s0)
	lw s1, -24(s0)
	bnez s1, .L15_8
	j .L15_9
.L15_8:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -36(s0)
	j .L15_10
.L15_9:
	li s1, 0
	sw s1, -36(s0)
.L15_10:
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s1, -32(s0)
	lw s2, -12(s0)
	sub s3, s1, s2
	sw s3, -40(s0)
	lw s1, -28(s0)
	bnez s1, .L15_11
	j .L15_12
.L15_12:
	lw s1, -4(s0)
	lw s2, -12(s0)
	lw s3, -8(s0)
	li s4, 0
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
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
.L15_11:
	lw s1, -16(s0)
	li s2, 17
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_13
	j .L15_14
.L15_13:
	lw s1, -40(s0)
	li s2, 1048576
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L15_15
	j .L15_16
.L15_16:
	lw s1, -40(s0)
	li s2, 1048574
	slt s3, s2, s1
	bnez s3, .L15_15
	j .L15_17
.L15_15:
	la s1, __str_94
	lw s2, -8(s0)
	lw s3, -40(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L15_17:
	j .L15_18
.L15_14:
	lw s1, -40(s0)
	li s2, 4096
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L15_19
	j .L15_20
.L15_20:
	lw s1, -40(s0)
	li s2, 4094
	slt s3, s2, s1
	bnez s3, .L15_19
	j .L15_21
.L15_19:
	la s1, __str_95
	lw s2, -8(s0)
	lw s3, -40(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L15_21:
.L15_18:
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
.Lfunc_end15:
	.size branch_disp, .Lfunc_end15-branch_disp

	.text
	.align 2
	.type is_reg, @function
is_reg:
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
	bnez s1, .L16_0
	j .L16_1
.L16_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L16_2
	j .L16_1
.L16_2:
	li s1, 1
	j .L16_3
.L16_1:
	li s1, 0
.L16_3:
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
.Lfunc_end16:
	.size is_reg, .Lfunc_end16-is_reg

	.text
	.align 2
	.type is_freg, @function
is_freg:
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
	bnez s1, .L17_0
	j .L17_1
.L17_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_2
	j .L17_1
.L17_2:
	li s1, 1
	j .L17_3
.L17_1:
	li s1, 0
.L17_3:
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
.Lfunc_end17:
	.size is_freg, .Lfunc_end17-is_freg

	.text
	.align 2
	.type is_imm, @function
is_imm:
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
	bnez s1, .L18_0
	j .L18_1
.L18_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 3
	xor s3, s2, s1
	seqz s3, s3
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
	.size is_imm, .Lfunc_end18-is_imm

	.text
	.align 2
	.type is_mem, @function
is_mem:
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
	bnez s1, .L19_0
	j .L19_1
.L19_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_2
	j .L19_1
.L19_2:
	li s1, 1
	j .L19_3
.L19_1:
	li s1, 0
.L19_3:
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
.Lfunc_end19:
	.size is_mem, .Lfunc_end19-is_mem

	.text
	.align 2
	.type is_sym, @function
is_sym:
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
	bnez s1, .L20_0
	j .L20_1
.L20_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L20_2
	j .L20_1
.L20_2:
	li s1, 1
	j .L20_3
.L20_1:
	li s1, 0
.L20_3:
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
.Lfunc_end20:
	.size is_sym, .Lfunc_end20-is_sym

	.text
	.align 2
	.type sym_target, @function
sym_target:
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
	bnez s1, .L21_0
	j .L21_1
.L21_1:
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
.L21_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L21_2
	j .L21_3
.L21_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L21_2
	j .L21_4
.L21_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L21_2
	j .L21_5
.L21_2:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
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
.L21_5:
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
.Lfunc_end21:
	.size sym_target, .Lfunc_end21-sym_target

	.text
	.align 2
	.type in3, @function
in3:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_0
	j .L22_1
.L22_1:
	lw s1, -12(s0)
	bnez s1, .L22_2
	j .L22_3
.L22_2:
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_0
	j .L22_3
.L22_3:
	lw s1, -16(s0)
	bnez s1, .L22_4
	j .L22_5
.L22_4:
	lw s1, -4(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L22_0
	j .L22_5
.L22_0:
	li s1, 1
	j .L22_6
.L22_5:
	li s1, 0
.L22_6:
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
.Lfunc_end22:
	.size in3, .Lfunc_end22-in3

	.text
	.align 2
	.type enc_op_rrr, @function
enc_op_rrr:
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
	li s1, 51
	sw s1, -28(s0)
	li s1, 1
	neg s2, s1
	sw s2, -32(s0)
	li s1, 0
	sw s1, -36(s0)
.L23_0:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L23_1
	j .L23_2
.L23_1:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L23_3
	j .L23_2
.L23_3:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L23_4
	j .L23_2
.L23_4:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L23_5
	j .L23_2
.L23_2:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L23_5:
.L23_6:
	li s1, 0
	bnez s1, .L23_0
	j .L23_7
.L23_7:
	lw s1, -8(s0)
	la s2, __str_96
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_8
	j .L23_9
.L23_8:
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L23_10
.L23_9:
	lw s1, -8(s0)
	la s2, __str_97
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_11
	j .L23_12
.L23_11:
	li s1, 0
	sw s1, -32(s0)
	li s1, 32
	sw s1, -36(s0)
	j .L23_13
.L23_12:
	lw s1, -8(s0)
	la s2, __str_98
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_14
	j .L23_15
.L23_14:
	li s1, 1
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L23_16
.L23_15:
	lw s1, -8(s0)
	la s2, __str_99
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_17
	j .L23_18
.L23_17:
	li s1, 2
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L23_19
.L23_18:
	lw s1, -8(s0)
	la s2, __str_100
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_20
	j .L23_21
.L23_20:
	li s1, 3
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L23_22
.L23_21:
	lw s1, -8(s0)
	la s2, __str_101
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_23
	j .L23_24
.L23_23:
	li s1, 4
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L23_25
.L23_24:
	lw s1, -8(s0)
	la s2, __str_102
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_26
	j .L23_27
.L23_26:
	li s1, 5
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L23_28
.L23_27:
	lw s1, -8(s0)
	la s2, __str_103
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_29
	j .L23_30
.L23_29:
	li s1, 5
	sw s1, -32(s0)
	li s1, 32
	sw s1, -36(s0)
	j .L23_31
.L23_30:
	lw s1, -8(s0)
	la s2, __str_104
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_32
	j .L23_33
.L23_32:
	li s1, 6
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L23_34
.L23_33:
	lw s1, -8(s0)
	la s2, __str_105
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_35
	j .L23_36
.L23_35:
	li s1, 7
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L23_37
.L23_36:
	lw s1, -8(s0)
	la s2, __str_106
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_38
	j .L23_39
.L23_38:
	li s1, 0
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L23_40
.L23_39:
	lw s1, -8(s0)
	la s2, __str_107
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_41
	j .L23_42
.L23_41:
	li s1, 1
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L23_43
.L23_42:
	lw s1, -8(s0)
	la s2, __str_108
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_44
	j .L23_45
.L23_44:
	li s1, 2
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L23_46
.L23_45:
	lw s1, -8(s0)
	la s2, __str_109
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_47
	j .L23_48
.L23_47:
	li s1, 3
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L23_49
.L23_48:
	lw s1, -8(s0)
	la s2, __str_110
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_50
	j .L23_51
.L23_50:
	li s1, 4
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L23_52
.L23_51:
	lw s1, -8(s0)
	la s2, __str_111
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_53
	j .L23_54
.L23_53:
	li s1, 5
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L23_55
.L23_54:
	lw s1, -8(s0)
	la s2, __str_112
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_56
	j .L23_57
.L23_56:
	li s1, 6
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L23_58
.L23_57:
	lw s1, -8(s0)
	la s2, __str_113
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_59
	j .L23_60
.L23_59:
	li s1, 7
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L23_61
.L23_60:
	lw s1, -8(s0)
	la s2, __str_114
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_62
	j .L23_63
.L23_62:
	li s1, 2
	sw s1, -32(s0)
	li s1, 16
	sw s1, -36(s0)
	j .L23_64
.L23_63:
	lw s1, -8(s0)
	la s2, __str_115
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_65
	j .L23_66
.L23_65:
	li s1, 4
	sw s1, -32(s0)
	li s1, 16
	sw s1, -36(s0)
	j .L23_67
.L23_66:
	lw s1, -8(s0)
	la s2, __str_116
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_68
	j .L23_69
.L23_68:
	li s1, 6
	sw s1, -32(s0)
	li s1, 16
	sw s1, -36(s0)
	j .L23_70
.L23_69:
	lw s1, -8(s0)
	la s2, __str_117
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_71
	j .L23_72
.L23_71:
	li s1, 7
	sw s1, -32(s0)
	li s1, 32
	sw s1, -36(s0)
	j .L23_73
.L23_72:
	lw s1, -8(s0)
	la s2, __str_118
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_74
	j .L23_75
.L23_74:
	li s1, 6
	sw s1, -32(s0)
	li s1, 32
	sw s1, -36(s0)
	j .L23_76
.L23_75:
	lw s1, -8(s0)
	la s2, __str_119
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_77
	j .L23_78
.L23_77:
	li s1, 4
	sw s1, -32(s0)
	li s1, 32
	sw s1, -36(s0)
	j .L23_79
.L23_78:
	lw s1, -8(s0)
	la s2, __str_120
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_80
	j .L23_81
.L23_80:
	li s1, 4
	sw s1, -32(s0)
	li s1, 5
	sw s1, -36(s0)
	j .L23_82
.L23_81:
	lw s1, -8(s0)
	la s2, __str_121
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_83
	j .L23_84
.L23_83:
	li s1, 5
	sw s1, -32(s0)
	li s1, 5
	sw s1, -36(s0)
	j .L23_85
.L23_84:
	lw s1, -8(s0)
	la s2, __str_122
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_86
	j .L23_87
.L23_86:
	li s1, 6
	sw s1, -32(s0)
	li s1, 5
	sw s1, -36(s0)
	j .L23_88
.L23_87:
	lw s1, -8(s0)
	la s2, __str_123
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_89
	j .L23_90
.L23_89:
	li s1, 7
	sw s1, -32(s0)
	li s1, 5
	sw s1, -36(s0)
	j .L23_91
.L23_90:
	lw s1, -8(s0)
	la s2, __str_124
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_92
	j .L23_93
.L23_92:
	li s1, 1
	sw s1, -32(s0)
	li s1, 48
	sw s1, -36(s0)
	j .L23_94
.L23_93:
	lw s1, -8(s0)
	la s2, __str_125
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_95
	j .L23_96
.L23_95:
	li s1, 5
	sw s1, -32(s0)
	li s1, 48
	sw s1, -36(s0)
	j .L23_97
.L23_96:
	lw s1, -8(s0)
	la s2, __str_126
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_98
	j .L23_99
.L23_98:
	li s1, 1
	sw s1, -32(s0)
	li s1, 36
	sw s1, -36(s0)
	j .L23_100
.L23_99:
	lw s1, -8(s0)
	la s2, __str_127
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_101
	j .L23_102
.L23_101:
	li s1, 5
	sw s1, -32(s0)
	li s1, 36
	sw s1, -36(s0)
	j .L23_103
.L23_102:
	lw s1, -8(s0)
	la s2, __str_128
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_104
	j .L23_105
.L23_104:
	li s1, 1
	sw s1, -32(s0)
	li s1, 52
	sw s1, -36(s0)
	j .L23_106
.L23_105:
	lw s1, -8(s0)
	la s2, __str_129
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L23_107
	j .L23_108
.L23_107:
	li s1, 1
	sw s1, -32(s0)
	li s1, 20
	sw s1, -36(s0)
	j .L23_109
.L23_108:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L23_109:
.L23_106:
.L23_103:
.L23_100:
.L23_97:
.L23_94:
.L23_91:
.L23_88:
.L23_85:
.L23_82:
.L23_79:
.L23_76:
.L23_73:
.L23_70:
.L23_67:
.L23_64:
.L23_61:
.L23_58:
.L23_55:
.L23_52:
.L23_49:
.L23_46:
.L23_43:
.L23_40:
.L23_37:
.L23_34:
.L23_31:
.L23_28:
.L23_25:
.L23_22:
.L23_19:
.L23_16:
.L23_13:
.L23_10:
	lw s1, -20(s0)
	bnez s1, .L23_110
	j .L23_111
.L23_110:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -32(s0)
	lw s4, -36(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	lw s7, -12(s0)
	li s8, 2
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L23_111:
	li s1, 4
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
.Lfunc_end23:
	.size enc_op_rrr, .Lfunc_end23-enc_op_rrr

	.text
	.align 2
	.type enc_op_rr, @function
enc_op_rr:
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
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	li s1, 19
	sw s1, -40(s0)
.L24_0:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L24_1
	j .L24_2
.L24_1:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L24_3
	j .L24_2
.L24_3:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L24_4
	j .L24_2
.L24_2:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L24_4:
.L24_5:
	li s1, 0
	bnez s1, .L24_0
	j .L24_6
.L24_6:
	lw s1, -8(s0)
	la s2, __str_130
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L24_7
	j .L24_8
.L24_7:
	li s1, 48
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	j .L24_9
.L24_8:
	lw s1, -8(s0)
	la s2, __str_131
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L24_10
	j .L24_11
.L24_10:
	li s1, 48
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L24_12
.L24_11:
	lw s1, -8(s0)
	la s2, __str_132
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L24_13
	j .L24_14
.L24_13:
	li s1, 48
	sw s1, -28(s0)
	li s1, 2
	sw s1, -32(s0)
	j .L24_15
.L24_14:
	lw s1, -8(s0)
	la s2, __str_133
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L24_16
	j .L24_17
.L24_16:
	li s1, 48
	sw s1, -28(s0)
	li s1, 4
	sw s1, -32(s0)
	j .L24_18
.L24_17:
	lw s1, -8(s0)
	la s2, __str_134
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L24_19
	j .L24_20
.L24_19:
	li s1, 48
	sw s1, -28(s0)
	li s1, 5
	sw s1, -32(s0)
	j .L24_21
.L24_20:
	lw s1, -8(s0)
	la s2, __str_135
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L24_22
	j .L24_23
.L24_22:
	li s1, 20
	sw s1, -28(s0)
	li s1, 7
	sw s1, -32(s0)
	li s1, 5
	sw s1, -36(s0)
	j .L24_24
.L24_23:
	lw s1, -8(s0)
	la s2, __str_136
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L24_25
	j .L24_26
.L24_25:
	li s1, 52
	sw s1, -28(s0)
	li s1, 24
	sw s1, -32(s0)
	li s1, 5
	sw s1, -36(s0)
	j .L24_27
.L24_26:
	lw s1, -8(s0)
	la s2, __str_137
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L24_28
	j .L24_29
.L24_28:
	li s1, 4
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 4
	sw s1, -36(s0)
	li s1, 51
	sw s1, -40(s0)
	j .L24_30
.L24_29:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L24_30:
.L24_27:
.L24_24:
.L24_21:
.L24_18:
.L24_15:
.L24_12:
.L24_9:
	lw s1, -20(s0)
	bnez s1, .L24_31
	j .L24_32
.L24_31:
	lw s1, -40(s0)
	li s2, 51
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L24_33
	j .L24_34
.L24_33:
	lw s1, -4(s0)
	lw s2, -40(s0)
	lw s3, -36(s0)
	lw s4, -28(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	lw s7, -32(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
	j .L24_35
.L24_34:
	lw s1, -4(s0)
	lw s2, -40(s0)
	lw s3, -36(s0)
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -28(s0)
	li s7, 5
	sll s8, s6, s7
	lw s6, -32(s0)
	or s7, s8, s6
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s7
	jal ra, enc_i
	mv s6, a0
	mv a0, s1
	mv a1, s6
	jal ra, emit_word
	mv s2, a0
.L24_35:
.L24_32:
	li s1, 4
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
.Lfunc_end24:
	.size enc_op_rr, .Lfunc_end24-enc_op_rr

	.text
	.align 2
	.type enc_op_imm, @function
enc_op_imm:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 19
	sw s1, -40(s0)
.L25_0:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_1
	j .L25_2
.L25_1:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L25_3
	j .L25_2
.L25_3:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L25_4
	j .L25_2
.L25_4:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_imm
	mv s1, a0
	bnez s1, .L25_5
	j .L25_2
.L25_2:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L25_5:
.L25_6:
	li s1, 0
	bnez s1, .L25_0
	j .L25_7
.L25_7:
	lw s1, -8(s0)
	la s2, __str_138
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_8
	j .L25_9
.L25_8:
	li s1, 0
	sw s1, -28(s0)
	j .L25_10
.L25_9:
	lw s1, -8(s0)
	la s2, __str_139
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_11
	j .L25_12
.L25_11:
	li s1, 2
	sw s1, -28(s0)
	j .L25_13
.L25_12:
	lw s1, -8(s0)
	la s2, __str_140
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_14
	j .L25_15
.L25_14:
	li s1, 3
	sw s1, -28(s0)
	j .L25_16
.L25_15:
	lw s1, -8(s0)
	la s2, __str_141
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_17
	j .L25_18
.L25_17:
	li s1, 4
	sw s1, -28(s0)
	j .L25_19
.L25_18:
	lw s1, -8(s0)
	la s2, __str_142
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_20
	j .L25_21
.L25_20:
	li s1, 6
	sw s1, -28(s0)
	j .L25_22
.L25_21:
	lw s1, -8(s0)
	la s2, __str_143
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_23
	j .L25_24
.L25_23:
	li s1, 7
	sw s1, -28(s0)
	j .L25_25
.L25_24:
	lw s1, -8(s0)
	la s2, __str_144
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_26
	j .L25_27
.L25_26:
	li s1, 1
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L25_28
.L25_27:
	lw s1, -8(s0)
	la s2, __str_145
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_29
	j .L25_30
.L25_29:
	li s1, 5
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	j .L25_31
.L25_30:
	lw s1, -8(s0)
	la s2, __str_146
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_32
	j .L25_33
.L25_32:
	li s1, 5
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 32
	sw s1, -36(s0)
	j .L25_34
.L25_33:
	lw s1, -8(s0)
	la s2, __str_147
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_35
	j .L25_36
.L25_35:
	li s1, 5
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 48
	sw s1, -36(s0)
	j .L25_37
.L25_36:
	lw s1, -8(s0)
	la s2, __str_148
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_38
	j .L25_39
.L25_38:
	li s1, 1
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 36
	sw s1, -36(s0)
	j .L25_40
.L25_39:
	lw s1, -8(s0)
	la s2, __str_149
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_41
	j .L25_42
.L25_41:
	li s1, 5
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 36
	sw s1, -36(s0)
	j .L25_43
.L25_42:
	lw s1, -8(s0)
	la s2, __str_150
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_44
	j .L25_45
.L25_44:
	li s1, 1
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 52
	sw s1, -36(s0)
	j .L25_46
.L25_45:
	lw s1, -8(s0)
	la s2, __str_151
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_47
	j .L25_48
.L25_47:
	li s1, 1
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 20
	sw s1, -36(s0)
	j .L25_49
.L25_48:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L25_49:
.L25_46:
.L25_43:
.L25_40:
.L25_37:
.L25_34:
.L25_31:
.L25_28:
.L25_25:
.L25_22:
.L25_19:
.L25_16:
.L25_13:
.L25_10:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L25_50
	j .L25_51
.L25_50:
.L25_52:
	lw s1, -32(s0)
	bnez s1, .L25_53
	j .L25_54
.L25_53:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L25_54:
.L25_55:
	li s1, 0
	bnez s1, .L25_52
	j .L25_56
.L25_56:
	lw s1, -20(s0)
	bnez s1, .L25_57
	j .L25_58
.L25_57:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -44(s0)
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_59
	j .L25_60
.L25_59:
	li s1, 27
	sw s1, -52(s0)
	j .L25_61
.L25_60:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_62
	j .L25_63
.L25_62:
	li s1, 24
	sw s1, -56(s0)
	j .L25_64
.L25_63:
	li s1, 1
	neg s2, s1
	sw s2, -56(s0)
.L25_64:
	lw s1, -56(s0)
	sw s1, -52(s0)
.L25_61:
	lw s1, -52(s0)
	sw s1, -48(s0)
.L25_65:
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L25_66
	j .L25_67
.L25_67:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L25_66:
.L25_68:
	li s1, 0
	bnez s1, .L25_65
	j .L25_69
.L25_69:
	lw s1, -4(s0)
	lw s2, -44(s0)
	lw s3, -12(s0)
	li s4, 2
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 12
	add s5, s4, s3
	lw s3, 0(s5)
	lw s4, -12(s0)
	li s5, 2
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 8
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -48(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -40(s0)
	lw s3, -28(s0)
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L25_58:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L25_51:
	lw s1, -32(s0)
	bnez s1, .L25_70
	j .L25_71
.L25_70:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -60(s0)
.L25_72:
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L25_73
	j .L25_74
.L25_73:
	lw s1, -60(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L25_75
	j .L25_74
.L25_74:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L25_75:
.L25_76:
	li s1, 0
	bnez s1, .L25_72
	j .L25_77
.L25_77:
	lw s1, -20(s0)
	bnez s1, .L25_78
	j .L25_79
.L25_78:
	lw s1, -4(s0)
	lw s2, -40(s0)
	lw s3, -28(s0)
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -36(s0)
	li s7, 5
	sll s8, s6, s7
	lw s6, -60(s0)
	or s7, s8, s6
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s7
	jal ra, enc_i
	mv s6, a0
	mv a0, s1
	mv a1, s6
	jal ra, emit_word
	mv s2, a0
.L25_79:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L25_71:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -64(s0)
	lw s1, -64(s0)
	li s2, 2048
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L25_80
	j .L25_81
.L25_81:
	lw s1, -64(s0)
	li s2, 2047
	slt s3, s2, s1
	bnez s3, .L25_80
	j .L25_82
.L25_80:
	la s1, __str_152
	lw s2, -8(s0)
	lw s3, -64(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L25_82:
	lw s1, -20(s0)
	bnez s1, .L25_83
	j .L25_84
.L25_83:
	lw s1, -4(s0)
	lw s2, -40(s0)
	lw s3, -28(s0)
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -64(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L25_84:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end25:
	.size enc_op_imm, .Lfunc_end25-enc_op_imm

	.text
	.align 2
	.type enc_load, @function
enc_load:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	li s1, 3
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	lw s1, -8(s0)
	la s2, __str_153
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L26_0
	j .L26_1
.L26_0:
	li s1, 0
	sw s1, -28(s0)
	j .L26_2
.L26_1:
	lw s1, -8(s0)
	la s2, __str_154
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L26_3
	j .L26_4
.L26_3:
	li s1, 1
	sw s1, -28(s0)
	j .L26_5
.L26_4:
	lw s1, -8(s0)
	la s2, __str_155
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L26_6
	j .L26_7
.L26_6:
	li s1, 2
	sw s1, -28(s0)
	j .L26_8
.L26_7:
	lw s1, -8(s0)
	la s2, __str_156
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L26_9
	j .L26_10
.L26_9:
	li s1, 4
	sw s1, -28(s0)
	j .L26_11
.L26_10:
	lw s1, -8(s0)
	la s2, __str_157
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L26_12
	j .L26_13
.L26_12:
	li s1, 5
	sw s1, -28(s0)
	j .L26_14
.L26_13:
	lw s1, -8(s0)
	la s2, __str_158
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L26_15
	j .L26_16
.L26_15:
	li s1, 1
	sw s1, -28(s0)
	li s1, 7
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L26_17
.L26_16:
	lw s1, -8(s0)
	la s2, __str_159
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L26_18
	j .L26_19
.L26_18:
	li s1, 2
	sw s1, -28(s0)
	li s1, 7
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L26_20
.L26_19:
	lw s1, -8(s0)
	la s2, __str_160
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L26_21
	j .L26_22
.L26_21:
	li s1, 3
	sw s1, -28(s0)
	li s1, 7
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L26_23
.L26_22:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_23:
.L26_20:
.L26_17:
.L26_14:
.L26_11:
.L26_8:
.L26_5:
.L26_2:
.L26_24:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_25
	j .L26_26
.L26_25:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_mem
	mv s1, a0
	bnez s1, .L26_27
	j .L26_26
.L26_26:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_27:
.L26_28:
	li s1, 0
	bnez s1, .L26_24
	j .L26_29
.L26_29:
.L26_30:
	lw s1, -36(s0)
	bnez s1, .L26_31
	j .L26_32
.L26_31:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	sw s1, -40(s0)
	j .L26_33
.L26_32:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	sw s1, -40(s0)
.L26_33:
	lw s1, -40(s0)
	bnez s1, .L26_34
	j .L26_35
.L26_35:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_34:
.L26_36:
	li s1, 0
	bnez s1, .L26_30
	j .L26_37
.L26_37:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L26_38
	j .L26_39
.L26_38:
	lw s1, -20(s0)
	bnez s1, .L26_40
	j .L26_41
.L26_40:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -44(s0)
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_42
	j .L26_43
.L26_42:
	li s1, 27
	sw s1, -52(s0)
	j .L26_44
.L26_43:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_45
	j .L26_46
.L26_45:
	li s1, 24
	sw s1, -56(s0)
	j .L26_47
.L26_46:
	li s1, 1
	neg s2, s1
	sw s2, -56(s0)
.L26_47:
	lw s1, -56(s0)
	sw s1, -52(s0)
.L26_44:
	lw s1, -52(s0)
	sw s1, -48(s0)
.L26_48:
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L26_49
	j .L26_50
.L26_50:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_49:
.L26_51:
	li s1, 0
	bnez s1, .L26_48
	j .L26_52
.L26_52:
	lw s1, -4(s0)
	lw s2, -44(s0)
	lw s3, -12(s0)
	li s4, 1
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 12
	add s5, s4, s3
	lw s3, 0(s5)
	lw s4, -12(s0)
	li s5, 1
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 8
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -48(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -28(s0)
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L26_41:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_39:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -60(s0)
	lw s1, -60(s0)
	li s2, 2048
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L26_53
	j .L26_54
.L26_54:
	lw s1, -60(s0)
	li s2, 2047
	slt s3, s2, s1
	bnez s3, .L26_53
	j .L26_55
.L26_53:
	la s1, __str_161
	lw s2, -8(s0)
	lw s3, -60(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L26_55:
	lw s1, -20(s0)
	bnez s1, .L26_56
	j .L26_57
.L26_56:
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -28(s0)
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -60(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L26_57:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end26:
	.size enc_load, .Lfunc_end26-enc_load

	.text
	.align 2
	.type enc_store, @function
enc_store:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	li s1, 35
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	lw s1, -8(s0)
	la s2, __str_162
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L27_0
	j .L27_1
.L27_0:
	li s1, 0
	sw s1, -28(s0)
	j .L27_2
.L27_1:
	lw s1, -8(s0)
	la s2, __str_163
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L27_3
	j .L27_4
.L27_3:
	li s1, 1
	sw s1, -28(s0)
	j .L27_5
.L27_4:
	lw s1, -8(s0)
	la s2, __str_164
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L27_6
	j .L27_7
.L27_6:
	li s1, 2
	sw s1, -28(s0)
	j .L27_8
.L27_7:
	lw s1, -8(s0)
	la s2, __str_165
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L27_9
	j .L27_10
.L27_9:
	li s1, 1
	sw s1, -28(s0)
	li s1, 39
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L27_11
.L27_10:
	lw s1, -8(s0)
	la s2, __str_166
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L27_12
	j .L27_13
.L27_12:
	li s1, 2
	sw s1, -28(s0)
	li s1, 39
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L27_14
.L27_13:
	lw s1, -8(s0)
	la s2, __str_167
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L27_15
	j .L27_16
.L27_15:
	li s1, 3
	sw s1, -28(s0)
	li s1, 39
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L27_17
.L27_16:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_17:
.L27_14:
.L27_11:
.L27_8:
.L27_5:
.L27_2:
.L27_18:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L27_19
	j .L27_20
.L27_19:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_mem
	mv s1, a0
	bnez s1, .L27_21
	j .L27_20
.L27_20:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_21:
.L27_22:
	li s1, 0
	bnez s1, .L27_18
	j .L27_23
.L27_23:
.L27_24:
	lw s1, -36(s0)
	bnez s1, .L27_25
	j .L27_26
.L27_25:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	sw s1, -40(s0)
	j .L27_27
.L27_26:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	sw s1, -40(s0)
.L27_27:
	lw s1, -40(s0)
	bnez s1, .L27_28
	j .L27_29
.L27_29:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_28:
.L27_30:
	li s1, 0
	bnez s1, .L27_24
	j .L27_31
.L27_31:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L27_32
	j .L27_33
.L27_32:
	lw s1, -20(s0)
	bnez s1, .L27_34
	j .L27_35
.L27_34:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -44(s0)
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L27_36
	j .L27_37
.L27_36:
	li s1, 28
	sw s1, -52(s0)
	j .L27_38
.L27_37:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L27_39
	j .L27_40
.L27_39:
	li s1, 25
	sw s1, -56(s0)
	j .L27_41
.L27_40:
	li s1, 1
	neg s2, s1
	sw s2, -56(s0)
.L27_41:
	lw s1, -56(s0)
	sw s1, -52(s0)
.L27_38:
	lw s1, -52(s0)
	sw s1, -48(s0)
.L27_42:
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L27_43
	j .L27_44
.L27_44:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_43:
.L27_45:
	li s1, 0
	bnez s1, .L27_42
	j .L27_46
.L27_46:
	lw s1, -4(s0)
	lw s2, -44(s0)
	lw s3, -12(s0)
	li s4, 1
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 12
	add s5, s4, s3
	lw s3, 0(s5)
	lw s4, -12(s0)
	li s5, 1
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 8
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -48(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -28(s0)
	lw s4, -12(s0)
	li s5, 1
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_s
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L27_35:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_33:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -60(s0)
	lw s1, -60(s0)
	li s2, 2048
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L27_47
	j .L27_48
.L27_48:
	lw s1, -60(s0)
	li s2, 2047
	slt s3, s2, s1
	bnez s3, .L27_47
	j .L27_49
.L27_47:
	la s1, __str_168
	lw s2, -8(s0)
	lw s3, -60(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L27_49:
	lw s1, -20(s0)
	bnez s1, .L27_50
	j .L27_51
.L27_50:
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -28(s0)
	lw s4, -12(s0)
	li s5, 1
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -60(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_s
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L27_51:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end27:
	.size enc_store, .Lfunc_end27-enc_store

	.text
	.align 2
	.type enc_branch, @function
enc_branch:
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
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	li s1, 0
	sw s1, -44(s0)
	li s1, 0
	sw s1, -48(s0)
	lw s1, -8(s0)
	la s2, __str_169
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_0
	j .L28_1
.L28_0:
	li s1, 0
	sw s1, -28(s0)
	j .L28_2
.L28_1:
	lw s1, -8(s0)
	la s2, __str_170
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_3
	j .L28_4
.L28_3:
	li s1, 1
	sw s1, -28(s0)
	j .L28_5
.L28_4:
	lw s1, -8(s0)
	la s2, __str_171
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_6
	j .L28_7
.L28_6:
	li s1, 4
	sw s1, -28(s0)
	j .L28_8
.L28_7:
	lw s1, -8(s0)
	la s2, __str_172
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_9
	j .L28_10
.L28_9:
	li s1, 5
	sw s1, -28(s0)
	j .L28_11
.L28_10:
	lw s1, -8(s0)
	la s2, __str_173
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_12
	j .L28_13
.L28_12:
	li s1, 6
	sw s1, -28(s0)
	j .L28_14
.L28_13:
	lw s1, -8(s0)
	la s2, __str_174
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_15
	j .L28_16
.L28_15:
	li s1, 7
	sw s1, -28(s0)
	j .L28_17
.L28_16:
	lw s1, -8(s0)
	la s2, __str_175
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_18
	j .L28_19
.L28_18:
	li s1, 4
	sw s1, -28(s0)
	li s1, 1
	sw s1, -48(s0)
	j .L28_20
.L28_19:
	lw s1, -8(s0)
	la s2, __str_176
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_21
	j .L28_22
.L28_21:
	li s1, 5
	sw s1, -28(s0)
	li s1, 1
	sw s1, -48(s0)
	j .L28_23
.L28_22:
	lw s1, -8(s0)
	la s2, __str_177
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_24
	j .L28_25
.L28_24:
	li s1, 6
	sw s1, -28(s0)
	li s1, 1
	sw s1, -48(s0)
	j .L28_26
.L28_25:
	lw s1, -8(s0)
	la s2, __str_178
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_27
	j .L28_28
.L28_27:
	li s1, 7
	sw s1, -28(s0)
	li s1, 1
	sw s1, -48(s0)
	j .L28_29
.L28_28:
	lw s1, -8(s0)
	la s2, __str_179
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_30
	j .L28_31
.L28_30:
	li s1, 0
	sw s1, -28(s0)
	li s1, 2
	sw s1, -44(s0)
	j .L28_32
.L28_31:
	lw s1, -8(s0)
	la s2, __str_180
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_33
	j .L28_34
.L28_33:
	li s1, 1
	sw s1, -28(s0)
	li s1, 2
	sw s1, -44(s0)
	j .L28_35
.L28_34:
	lw s1, -8(s0)
	la s2, __str_181
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_36
	j .L28_37
.L28_36:
	li s1, 5
	sw s1, -28(s0)
	li s1, 3
	sw s1, -44(s0)
	j .L28_38
.L28_37:
	lw s1, -8(s0)
	la s2, __str_182
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_39
	j .L28_40
.L28_39:
	li s1, 5
	sw s1, -28(s0)
	li s1, 2
	sw s1, -44(s0)
	j .L28_41
.L28_40:
	lw s1, -8(s0)
	la s2, __str_183
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_42
	j .L28_43
.L28_42:
	li s1, 4
	sw s1, -28(s0)
	li s1, 2
	sw s1, -44(s0)
	j .L28_44
.L28_43:
	lw s1, -8(s0)
	la s2, __str_184
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L28_45
	j .L28_46
.L28_45:
	li s1, 4
	sw s1, -28(s0)
	li s1, 3
	sw s1, -44(s0)
	j .L28_47
.L28_46:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L28_47:
.L28_44:
.L28_41:
.L28_38:
.L28_35:
.L28_32:
.L28_29:
.L28_26:
.L28_23:
.L28_20:
.L28_17:
.L28_14:
.L28_11:
.L28_8:
.L28_5:
.L28_2:
	lw s1, -44(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_48
	j .L28_49
.L28_48:
.L28_50:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_51
	j .L28_52
.L28_51:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L28_53
	j .L28_52
.L28_53:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L28_54
	j .L28_52
.L28_52:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L28_54:
.L28_55:
	li s1, 0
	bnez s1, .L28_50
	j .L28_56
.L28_56:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	sw s1, -40(s0)
	j .L28_57
.L28_49:
	lw s1, -44(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_58
	j .L28_59
.L28_58:
.L28_60:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_61
	j .L28_62
.L28_61:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L28_63
	j .L28_62
.L28_63:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L28_64
	j .L28_62
.L28_62:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L28_64:
.L28_65:
	li s1, 0
	bnez s1, .L28_60
	j .L28_66
.L28_66:
	li s1, 0
	sw s1, -32(s0)
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	sw s1, -40(s0)
	j .L28_67
.L28_59:
.L28_68:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_69
	j .L28_70
.L28_69:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L28_71
	j .L28_70
.L28_71:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L28_72
	j .L28_70
.L28_72:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L28_73
	j .L28_70
.L28_70:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L28_73:
.L28_74:
	li s1, 0
	bnez s1, .L28_68
	j .L28_75
.L28_75:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	sw s1, -40(s0)
	lw s1, -48(s0)
	bnez s1, .L28_76
	j .L28_77
.L28_76:
	lw s1, -32(s0)
	sw s1, -52(s0)
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s1, -52(s0)
	sw s1, -36(s0)
.L28_77:
.L28_67:
.L28_57:
	lw s1, -4(s0)
	li s2, 600
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	sw s1, -56(s0)
	lw s1, -56(s0)
	lw s2, -4(s0)
	li s3, 596
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L28_78
	j .L28_79
.L28_78:
	lw s1, -4(s0)
	li s2, 592
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -56(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	sw s1, -64(s0)
	j .L28_80
.L28_79:
	li s1, 0
	sw s1, -64(s0)
.L28_80:
	lw s1, -64(s0)
	sw s1, -60(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -68(s0)
	lw s1, -4(s0)
	li s2, 604
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L28_81
	j .L28_82
.L28_81:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 552
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -68(s0)
	lw s4, -40(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_note_branch
	mv s5, a0
.L28_82:
	lw s1, -20(s0)
	bnez s1, .L28_83
	j .L28_84
.L28_84:
	lw s1, -60(s0)
	bnez s1, .L28_85
	j .L28_86
.L28_85:
	li s1, 8
	sw s1, -72(s0)
	j .L28_87
.L28_86:
	li s1, 4
	sw s1, -72(s0)
.L28_87:
	lw s1, -72(s0)
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
.L28_83:
	lw s1, -60(s0)
	bnez s1, .L28_88
	j .L28_89
.L28_88:
	lw s1, -4(s0)
	li s2, 99
	lw s3, -28(s0)
	li s4, 1
	xor s5, s3, s4
	lw s3, -32(s0)
	lw s4, -36(s0)
	li s6, 8
	mv a0, s2
	mv a1, s5
	mv a2, s3
	mv a3, s4
	mv a4, s6
	jal ra, enc_b
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -40(s0)
	lw s3, -68(s0)
	li s4, 4
	add s5, s3, s4
	li s3, 17
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	jal ra, branch_disp
	mv s4, a0
	sw s4, -76(s0)
	lw s1, -4(s0)
	li s2, 111
	li s3, 0
	lw s4, -76(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_j
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
	li s1, 8
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
.L28_89:
	lw s1, -4(s0)
	li s2, 99
	lw s3, -28(s0)
	lw s4, -32(s0)
	lw s5, -36(s0)
	lw s6, -4(s0)
	lw s7, -40(s0)
	lw s8, -68(s0)
	li s9, 16
	mv a0, s6
	mv a1, s7
	mv a2, s8
	mv a3, s9
	jal ra, branch_disp
	mv s10, a0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s10
	jal ra, enc_b
	mv s6, a0
	mv a0, s1
	mv a1, s6
	jal ra, emit_word
	mv s2, a0
	li s1, 4
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
.Lfunc_end28:
	.size enc_branch, .Lfunc_end28-enc_branch

	.text
	.align 2
	.type enc_jal, @function
enc_jal:
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
	lw s1, -8(s0)
	la s2, __str_185
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L29_0
	j .L29_1
.L29_0:
	lw s1, -8(s0)
	la s2, __str_186
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L29_2
	j .L29_1
.L29_2:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L29_1:
	lw s1, -8(s0)
	la s2, __str_187
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L29_3
	j .L29_4
.L29_3:
.L29_5:
	lw s1, -16(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L29_6
	j .L29_7
.L29_6:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L29_8
	j .L29_7
.L29_7:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L29_8:
.L29_9:
	li s1, 0
	bnez s1, .L29_5
	j .L29_10
.L29_10:
	li s1, 0
	sw s1, -28(s0)
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	sw s1, -32(s0)
	j .L29_11
.L29_4:
	lw s1, -16(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L29_12
	j .L29_13
.L29_12:
.L29_14:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L29_15
	j .L29_16
.L29_16:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L29_15:
.L29_17:
	li s1, 0
	bnez s1, .L29_14
	j .L29_18
.L29_18:
	li s1, 1
	sw s1, -28(s0)
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	sw s1, -32(s0)
	j .L29_19
.L29_13:
.L29_20:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L29_21
	j .L29_22
.L29_21:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L29_23
	j .L29_22
.L29_23:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L29_24
	j .L29_22
.L29_22:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L29_24:
.L29_25:
	li s1, 0
	bnez s1, .L29_20
	j .L29_26
.L29_26:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -28(s0)
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	sw s1, -32(s0)
.L29_19:
.L29_11:
	lw s1, -20(s0)
	bnez s1, .L29_27
	j .L29_28
.L29_27:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -36(s0)
	li s4, 17
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, branch_disp
	mv s5, a0
	sw s5, -40(s0)
	lw s1, -4(s0)
	li s2, 111
	lw s3, -28(s0)
	lw s4, -40(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_j
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
.L29_28:
	li s1, 4
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
.Lfunc_end29:
	.size enc_jal, .Lfunc_end29-enc_jal

	.text
	.align 2
	.type enc_jalr, @function
enc_jalr:
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
	li s1, 0
	sw s1, -36(s0)
	lw s1, -8(s0)
	la s2, __str_188
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L30_0
	j .L30_1
.L30_0:
.L30_2:
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L30_3
	j .L30_4
.L30_4:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L30_3:
.L30_5:
	li s1, 0
	bnez s1, .L30_2
	j .L30_6
.L30_6:
	li s1, 0
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L30_7
.L30_1:
	lw s1, -8(s0)
	la s2, __str_189
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L30_8
	j .L30_9
.L30_8:
.L30_10:
	lw s1, -16(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L30_11
	j .L30_12
.L30_11:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L30_13
	j .L30_12
.L30_12:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L30_13:
.L30_14:
	li s1, 0
	bnez s1, .L30_10
	j .L30_15
.L30_15:
	li s1, 0
	sw s1, -28(s0)
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L30_16
.L30_9:
	lw s1, -16(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L30_17
	j .L30_18
.L30_17:
.L30_19:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L30_20
	j .L30_21
.L30_21:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L30_20:
.L30_22:
	li s1, 0
	bnez s1, .L30_19
	j .L30_23
.L30_23:
	li s1, 1
	sw s1, -28(s0)
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L30_24
.L30_18:
.L30_25:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L30_26
	j .L30_27
.L30_26:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L30_28
	j .L30_27
.L30_28:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L30_29
	j .L30_27
.L30_29:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_imm
	mv s1, a0
	bnez s1, .L30_30
	j .L30_27
.L30_30:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L30_31
	j .L30_27
.L30_27:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L30_31:
.L30_32:
	li s1, 0
	bnez s1, .L30_25
	j .L30_33
.L30_33:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -28(s0)
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -36(s0)
.L30_24:
.L30_16:
.L30_7:
	lw s1, -36(s0)
	li s2, 2048
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L30_34
	j .L30_35
.L30_35:
	lw s1, -36(s0)
	li s2, 2047
	slt s3, s2, s1
	bnez s3, .L30_34
	j .L30_36
.L30_34:
	la s1, __str_190
	lw s2, -8(s0)
	lw s3, -36(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L30_36:
	lw s1, -20(s0)
	bnez s1, .L30_37
	j .L30_38
.L30_37:
	lw s1, -4(s0)
	li s2, 103
	li s3, 0
	lw s4, -28(s0)
	lw s5, -32(s0)
	lw s6, -36(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L30_38:
	li s1, 4
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
.Lfunc_end30:
	.size enc_jalr, .Lfunc_end30-enc_jalr

	.text
	.align 2
	.type enc_float, @function
enc_float:
	addi sp, sp, -976
	sw ra, 972(sp)
	sw s0, 968(sp)
	addi s0, sp, 968
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
	li s1, 83
	sw s1, -28(s0)
	addi s1, s0, -128
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
	la s2, __str_191
	sw s2, 0(s1)
	li s2, 0
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_192
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 4
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_193
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 8
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_194
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 12
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_195
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_196
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 5
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_197
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 9
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_198
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 13
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_199
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_200
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 6
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_201
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 10
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_202
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 14
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	addi s1, s0, -308
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
	la s2, __str_203
	sw s2, 0(s1)
	li s2, 16
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_204
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 16
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_205
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 16
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_206
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 17
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_207
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 17
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_208
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 17
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_209
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 18
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_210
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 18
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_211
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 18
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_212
	li s3, 108
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 20
	li s3, 112
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 116
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_213
	li s3, 120
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 20
	li s3, 124
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 128
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_214
	li s3, 132
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 21
	li s3, 136
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 140
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_215
	li s3, 144
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 21
	li s3, 148
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 152
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_216
	li s3, 156
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 22
	li s3, 160
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 164
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_217
	li s3, 168
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 22
	li s3, 172
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 176
	add s4, s1, s3
	sw s2, 0(s4)
	addi s1, s0, -416
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
	la s2, __str_218
	sw s2, 0(s1)
	li s2, 80
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_219
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 80
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_220
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 80
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_221
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 81
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_222
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 81
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_223
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 81
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_224
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 82
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_225
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 82
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_226
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 82
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	sw s1, -420(s0)
.L31_0:
	lw s1, -420(s0)
	li s2, 96
	li s3, 8
	div s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L31_1
	j .L31_2
.L31_1:
	lw s1, -8(s0)
	addi s2, s0, -128
	lw s3, -420(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L31_3
	j .L31_4
.L31_3:
.L31_5:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_6
	j .L31_7
.L31_6:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_8
	j .L31_7
.L31_8:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_9
	j .L31_7
.L31_9:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_10
	j .L31_7
.L31_7:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_10:
.L31_11:
	li s1, 0
	bnez s1, .L31_5
	j .L31_12
.L31_12:
	lw s1, -20(s0)
	bnez s1, .L31_13
	j .L31_14
.L31_13:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 7
	addi s4, s0, -128
	lw s5, -420(s0)
	li s6, 8
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	lw s7, -12(s0)
	li s8, 2
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L31_14:
	li s1, 4
	mv a0, s1
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_4:
.L31_15:
	addi s1, s0, -420
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -420(s0)
	j .L31_0
.L31_2:
	li s1, 0
	sw s1, -420(s0)
.L31_16:
	lw s1, -420(s0)
	li s2, 180
	li s3, 12
	div s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L31_17
	j .L31_18
.L31_17:
	lw s1, -8(s0)
	addi s2, s0, -308
	lw s3, -420(s0)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L31_19
	j .L31_20
.L31_19:
.L31_21:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_22
	j .L31_23
.L31_22:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_24
	j .L31_23
.L31_24:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_25
	j .L31_23
.L31_25:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_26
	j .L31_23
.L31_23:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_26:
.L31_27:
	li s1, 0
	bnez s1, .L31_21
	j .L31_28
.L31_28:
	lw s1, -20(s0)
	bnez s1, .L31_29
	j .L31_30
.L31_29:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -308
	lw s4, -420(s0)
	li s5, 12
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 8
	add s5, s4, s3
	lw s3, 0(s5)
	addi s4, s0, -308
	lw s5, -420(s0)
	li s6, 12
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	lw s7, -12(s0)
	li s8, 2
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L31_30:
	li s1, 4
	mv a0, s1
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_20:
.L31_31:
	addi s1, s0, -420
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -420(s0)
	j .L31_16
.L31_18:
	li s1, 0
	sw s1, -420(s0)
.L31_32:
	lw s1, -420(s0)
	li s2, 108
	li s3, 12
	div s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L31_33
	j .L31_34
.L31_33:
	lw s1, -8(s0)
	addi s2, s0, -416
	lw s3, -420(s0)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L31_35
	j .L31_36
.L31_35:
.L31_37:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_38
	j .L31_39
.L31_38:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L31_40
	j .L31_39
.L31_40:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_41
	j .L31_39
.L31_41:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_42
	j .L31_39
.L31_39:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_42:
.L31_43:
	li s1, 0
	bnez s1, .L31_37
	j .L31_44
.L31_44:
	lw s1, -20(s0)
	bnez s1, .L31_45
	j .L31_46
.L31_45:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -416
	lw s4, -420(s0)
	li s5, 12
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 8
	add s5, s4, s3
	lw s3, 0(s5)
	addi s4, s0, -416
	lw s5, -420(s0)
	li s6, 12
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	lw s7, -12(s0)
	li s8, 2
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L31_46:
	li s1, 4
	mv a0, s1
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_36:
.L31_47:
	addi s1, s0, -420
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -420(s0)
	j .L31_32
.L31_34:
	lw s1, -8(s0)
	la s2, __str_227
	la s3, __str_228
	la s4, __str_229
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, in3
	mv s5, a0
	bnez s5, .L31_48
	j .L31_49
.L31_48:
	lw s1, -8(s0)
	li s2, 6
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_50
	j .L31_51
.L31_50:
	li s1, 44
	sw s1, -428(s0)
	j .L31_52
.L31_51:
	lw s1, -8(s0)
	li s2, 6
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 100
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_53
	j .L31_54
.L31_53:
	li s1, 45
	sw s1, -432(s0)
	j .L31_55
.L31_54:
	li s1, 46
	sw s1, -432(s0)
.L31_55:
	lw s1, -432(s0)
	sw s1, -428(s0)
.L31_52:
	lw s1, -428(s0)
	sw s1, -424(s0)
.L31_56:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_57
	j .L31_58
.L31_57:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_59
	j .L31_58
.L31_59:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_60
	j .L31_58
.L31_58:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_60:
.L31_61:
	li s1, 0
	bnez s1, .L31_56
	j .L31_62
.L31_62:
	lw s1, -20(s0)
	bnez s1, .L31_63
	j .L31_64
.L31_63:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 7
	lw s4, -424(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	li s7, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L31_64:
	li s1, 4
	mv a0, s1
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_49:
	lw s1, -8(s0)
	la s2, __str_230
	la s3, __str_231
	la s4, __str_232
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, in3
	mv s5, a0
	bnez s5, .L31_65
	j .L31_66
.L31_65:
	lw s1, -8(s0)
	li s2, 7
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_67
	j .L31_68
.L31_67:
	li s1, 112
	sw s1, -440(s0)
	j .L31_69
.L31_68:
	lw s1, -8(s0)
	li s2, 7
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 100
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_70
	j .L31_71
.L31_70:
	li s1, 113
	sw s1, -444(s0)
	j .L31_72
.L31_71:
	li s1, 114
	sw s1, -444(s0)
.L31_72:
	lw s1, -444(s0)
	sw s1, -440(s0)
.L31_69:
	lw s1, -440(s0)
	sw s1, -436(s0)
.L31_73:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_74
	j .L31_75
.L31_74:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L31_76
	j .L31_75
.L31_76:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_77
	j .L31_75
.L31_75:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_77:
.L31_78:
	li s1, 0
	bnez s1, .L31_73
	j .L31_79
.L31_79:
	lw s1, -20(s0)
	bnez s1, .L31_80
	j .L31_81
.L31_80:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 1
	lw s4, -436(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	li s7, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L31_81:
	li s1, 4
	mv a0, s1
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_66:
	lw s1, -8(s0)
	la s2, __str_233
	la s3, __str_234
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, in3
	mv s5, a0
	bnez s5, .L31_82
	j .L31_83
.L31_82:
	lw s1, -8(s0)
	la s2, __str_235
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L31_84
	j .L31_85
.L31_84:
	li s1, 112
	sw s1, -452(s0)
	j .L31_86
.L31_85:
	li s1, 114
	sw s1, -452(s0)
.L31_86:
	lw s1, -452(s0)
	sw s1, -448(s0)
.L31_87:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_88
	j .L31_89
.L31_88:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L31_90
	j .L31_89
.L31_90:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_91
	j .L31_89
.L31_89:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_91:
.L31_92:
	li s1, 0
	bnez s1, .L31_87
	j .L31_93
.L31_93:
	lw s1, -20(s0)
	bnez s1, .L31_94
	j .L31_95
.L31_94:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 0
	lw s4, -448(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	li s7, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L31_95:
	li s1, 4
	mv a0, s1
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_83:
	lw s1, -8(s0)
	la s2, __str_236
	la s3, __str_237
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, in3
	mv s5, a0
	bnez s5, .L31_96
	j .L31_97
.L31_96:
	lw s1, -8(s0)
	la s2, __str_238
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L31_98
	j .L31_99
.L31_98:
	li s1, 120
	sw s1, -460(s0)
	j .L31_100
.L31_99:
	li s1, 122
	sw s1, -460(s0)
.L31_100:
	lw s1, -460(s0)
	sw s1, -456(s0)
.L31_101:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_102
	j .L31_103
.L31_102:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L31_104
	j .L31_103
.L31_104:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L31_105
	j .L31_103
.L31_103:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_105:
.L31_106:
	li s1, 0
	bnez s1, .L31_101
	j .L31_107
.L31_107:
	lw s1, -20(s0)
	bnez s1, .L31_108
	j .L31_109
.L31_108:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 0
	lw s4, -456(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	li s7, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L31_109:
	li s1, 4
	mv a0, s1
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_97:
	addi s1, s0, -896
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
	li s3, 256
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 260
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 264
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 268
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 272
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 276
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 280
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 284
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 288
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 292
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 296
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 300
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 304
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 308
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 312
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 316
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 320
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 324
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 328
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 332
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 336
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 340
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 344
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 348
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 352
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 356
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 360
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 364
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 368
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 372
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 376
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 380
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 384
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 388
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 392
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 396
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 400
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 404
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 408
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 412
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 416
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 420
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 424
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 428
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_239
	sw s2, 0(s1)
	li s2, 104
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_240
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 104
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_241
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 105
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_242
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 105
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_243
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 106
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 108
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 112
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 116
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_244
	li s3, 120
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 106
	li s3, 124
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 128
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 132
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 136
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 140
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_245
	li s3, 144
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 96
	li s3, 148
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 152
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 156
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 160
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 164
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_246
	li s3, 168
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 96
	li s3, 172
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 176
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 180
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 184
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 188
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_247
	li s3, 192
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 97
	li s3, 196
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 200
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 204
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 208
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 212
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_248
	li s3, 216
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 97
	li s3, 220
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 224
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 228
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 232
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 236
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_249
	li s3, 240
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 98
	li s3, 244
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 248
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 252
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 256
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 260
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_250
	li s3, 264
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 98
	li s3, 268
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 272
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 276
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 280
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 284
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_251
	li s3, 288
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 32
	li s3, 292
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 296
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 300
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 304
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 308
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_252
	li s3, 312
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 33
	li s3, 316
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 320
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 324
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 328
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 332
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_253
	li s3, 336
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 32
	li s3, 340
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 344
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 348
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 352
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 356
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_254
	li s3, 360
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 34
	li s3, 364
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 368
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 372
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 376
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 380
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_255
	li s3, 384
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 33
	li s3, 388
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 392
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 396
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 400
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 404
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_256
	li s3, 408
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 34
	li s3, 412
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 416
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 420
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 424
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 7
	li s3, 428
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	sw s1, -420(s0)
.L31_110:
	lw s1, -420(s0)
	li s2, 432
	li s3, 24
	div s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L31_111
	j .L31_112
.L31_111:
	lw s1, -8(s0)
	addi s2, s0, -896
	lw s3, -420(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L31_113
	j .L31_114
.L31_113:
	addi s1, s0, -896
	lw s2, -420(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -900(s0)
.L31_115:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_116
	j .L31_117
.L31_117:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_116
	j .L31_118
.L31_118:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_116:
.L31_119:
	li s1, 0
	bnez s1, .L31_115
	j .L31_120
.L31_120:
.L31_121:
	addi s1, s0, -896
	lw s2, -420(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L31_122
	j .L31_123
.L31_122:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	sw s1, -904(s0)
	j .L31_124
.L31_123:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	sw s1, -904(s0)
.L31_124:
	lw s1, -904(s0)
	bnez s1, .L31_125
	j .L31_126
.L31_126:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_125:
.L31_127:
	li s1, 0
	bnez s1, .L31_121
	j .L31_128
.L31_128:
.L31_129:
	addi s1, s0, -896
	lw s2, -420(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L31_130
	j .L31_131
.L31_130:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	sw s1, -908(s0)
	j .L31_132
.L31_131:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	sw s1, -908(s0)
.L31_132:
	lw s1, -908(s0)
	bnez s1, .L31_133
	j .L31_134
.L31_134:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_133:
.L31_135:
	li s1, 0
	bnez s1, .L31_129
	j .L31_136
.L31_136:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_137
	j .L31_138
.L31_137:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_imm
	mv s1, a0
	bnez s1, .L31_139
	j .L31_140
.L31_139:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -900(s0)
	j .L31_141
.L31_140:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_sym
	mv s1, a0
	bnez s1, .L31_142
	j .L31_143
.L31_142:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	mv a0, s1
	jal ra, rv_roundmode
	mv s2, a0
	sw s2, -900(s0)
.L31_143:
.L31_141:
.L31_144:
	lw s1, -900(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L31_145
	j .L31_146
.L31_146:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_145:
.L31_147:
	li s1, 0
	bnez s1, .L31_144
	j .L31_148
.L31_148:
.L31_138:
	lw s1, -20(s0)
	bnez s1, .L31_149
	j .L31_150
.L31_149:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -900(s0)
	addi s4, s0, -896
	lw s5, -420(s0)
	li s6, 24
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	addi s7, s0, -896
	lw s8, -420(s0)
	li s9, 24
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 8
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L31_150:
	li s1, 4
	mv a0, s1
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L31_114:
.L31_151:
	addi s1, s0, -420
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -420(s0)
	j .L31_110
.L31_112:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -956(s0)
	lw s2, -952(s0)
	lw s3, -948(s0)
	lw s4, -944(s0)
	lw s5, -940(s0)
	lw s6, -936(s0)
	lw s7, -932(s0)
	lw s8, -928(s0)
	lw s9, -924(s0)
	lw s10, -920(s0)
	lw s11, -916(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end31:
	.size enc_float, .Lfunc_end31-enc_float

	.text
	.align 2
	.type enc_fma, @function
enc_fma:
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
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	lw s1, -8(s0)
	la s2, __str_257
	li s3, 6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L32_0
	j .L32_1
.L32_0:
	li s1, 67
	sw s1, -28(s0)
	j .L32_2
.L32_1:
	lw s1, -8(s0)
	la s2, __str_258
	li s3, 6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L32_3
	j .L32_4
.L32_3:
	li s1, 71
	sw s1, -28(s0)
	j .L32_5
.L32_4:
	lw s1, -8(s0)
	la s2, __str_259
	li s3, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L32_6
	j .L32_7
.L32_6:
	li s1, 75
	sw s1, -28(s0)
	j .L32_8
.L32_7:
	lw s1, -8(s0)
	la s2, __str_260
	li s3, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L32_9
	j .L32_10
.L32_9:
	li s1, 79
	sw s1, -28(s0)
	j .L32_11
.L32_10:
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
.L32_11:
.L32_8:
.L32_5:
.L32_2:
	lw s1, -8(s0)
	li s2, 46
	mv a0, s1
	mv a1, s2
	jal ra, strrchr
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L32_12
	j .L32_13
.L32_12:
	li s1, 0
	sw s1, -40(s0)
	j .L32_14
.L32_13:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 100
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L32_15
	j .L32_16
.L32_15:
	li s1, 1
	sw s1, -44(s0)
	j .L32_17
.L32_16:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 104
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L32_18
	j .L32_19
.L32_18:
	li s1, 2
	sw s1, -48(s0)
	j .L32_20
.L32_19:
	li s1, 1
	neg s2, s1
	sw s2, -48(s0)
.L32_20:
	lw s1, -48(s0)
	sw s1, -44(s0)
.L32_17:
	lw s1, -44(s0)
	sw s1, -40(s0)
.L32_14:
	lw s1, -40(s0)
	sw s1, -32(s0)
.L32_21:
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L32_22
	j .L32_23
.L32_23:
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
.L32_22:
.L32_24:
	li s1, 0
	bnez s1, .L32_21
	j .L32_25
.L32_25:
.L32_26:
	lw s1, -16(s0)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L32_27
	j .L32_28
.L32_27:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L32_29
	j .L32_28
.L32_29:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L32_30
	j .L32_28
.L32_30:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L32_31
	j .L32_28
.L32_31:
	lw s1, -12(s0)
	li s2, 3
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L32_32
	j .L32_28
.L32_28:
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
.L32_32:
.L32_33:
	li s1, 0
	bnez s1, .L32_26
	j .L32_34
.L32_34:
	lw s1, -20(s0)
	bnez s1, .L32_35
	j .L32_36
.L32_35:
	lw s1, -28(s0)
	lw s2, -12(s0)
	li s3, 0
	li s4, 20
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	li s3, 7
	sll s4, s2, s3
	or s2, s1, s4
	li s1, 7
	li s3, 12
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -12(s0)
	li s3, 1
	li s4, 20
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	li s3, 15
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -12(s0)
	li s3, 2
	li s4, 20
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	lw s1, 0(s4)
	li s3, 20
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -32(s0)
	li s3, 25
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -12(s0)
	li s3, 3
	li s4, 20
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	lw s1, 0(s4)
	li s3, 27
	sll s4, s1, s3
	or s1, s2, s4
	sw s1, -52(s0)
	lw s1, -4(s0)
	lw s2, -52(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_word
	mv s3, a0
.L32_36:
	li s1, 4
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
.Lfunc_end32:
	.size enc_fma, .Lfunc_end32-enc_fma

	.text
	.align 2
	.type enc_csr, @function
enc_csr:
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
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	lw s1, -8(s0)
	la s2, __str_261
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L33_0
	j .L33_1
.L33_0:
	li s1, 1
	sw s1, -28(s0)
	j .L33_2
.L33_1:
	lw s1, -8(s0)
	la s2, __str_262
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L33_3
	j .L33_4
.L33_3:
	li s1, 2
	sw s1, -28(s0)
	j .L33_5
.L33_4:
	lw s1, -8(s0)
	la s2, __str_263
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L33_6
	j .L33_7
.L33_6:
	li s1, 3
	sw s1, -28(s0)
	j .L33_8
.L33_7:
	lw s1, -8(s0)
	la s2, __str_264
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L33_9
	j .L33_10
.L33_9:
	li s1, 5
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L33_11
.L33_10:
	lw s1, -8(s0)
	la s2, __str_265
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L33_12
	j .L33_13
.L33_12:
	li s1, 6
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L33_14
.L33_13:
	lw s1, -8(s0)
	la s2, __str_266
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L33_15
	j .L33_16
.L33_15:
	li s1, 7
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L33_17
.L33_16:
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
.L33_17:
.L33_14:
.L33_11:
.L33_8:
.L33_5:
.L33_2:
.L33_18:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L33_19
	j .L33_20
.L33_19:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L33_21
	j .L33_20
.L33_20:
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
.L33_21:
.L33_22:
	li s1, 0
	bnez s1, .L33_18
	j .L33_23
.L33_23:
.L33_24:
	lw s1, -32(s0)
	bnez s1, .L33_25
	j .L33_26
.L33_25:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_imm
	mv s1, a0
	sw s1, -36(s0)
	j .L33_27
.L33_26:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	sw s1, -36(s0)
.L33_27:
	lw s1, -36(s0)
	bnez s1, .L33_28
	j .L33_29
.L33_29:
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
.L33_28:
.L33_30:
	li s1, 0
	bnez s1, .L33_24
	j .L33_31
.L33_31:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L33_32
	j .L33_33
.L33_33:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_imm
	mv s1, a0
	bnez s1, .L33_32
	j .L33_34
.L33_32:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -40(s0)
	j .L33_35
.L33_34:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_sym
	mv s1, a0
	bnez s1, .L33_36
	j .L33_37
.L33_36:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	mv a0, s1
	jal ra, rv_csr
	mv s2, a0
	sw s2, -40(s0)
	j .L33_38
.L33_37:
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
.L33_38:
.L33_35:
.L33_39:
	lw s1, -40(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L33_40
	j .L33_41
.L33_41:
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
.L33_40:
.L33_42:
	li s1, 0
	bnez s1, .L33_39
	j .L33_43
.L33_43:
	lw s1, -20(s0)
	bnez s1, .L33_44
	j .L33_45
.L33_44:
	lw s1, -32(s0)
	bnez s1, .L33_46
	j .L33_47
.L33_46:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 31
	and s3, s1, s2
	sw s3, -48(s0)
	j .L33_48
.L33_47:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -48(s0)
.L33_48:
	lw s1, -48(s0)
	sw s1, -44(s0)
	lw s1, -4(s0)
	li s2, 115
	lw s3, -28(s0)
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -44(s0)
	lw s6, -40(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L33_45:
	li s1, 4
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
.Lfunc_end33:
	.size enc_csr, .Lfunc_end33-enc_csr

	.text
	.align 2
	.type enc_u_type, @function
enc_u_type:
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
	lw s1, -8(s0)
	la s2, __str_267
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L34_0
	j .L34_1
.L34_0:
	li s1, 55
	sw s1, -28(s0)
	j .L34_2
.L34_1:
	lw s1, -8(s0)
	la s2, __str_268
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L34_3
	j .L34_4
.L34_3:
	li s1, 23
	sw s1, -28(s0)
	j .L34_5
.L34_4:
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
.L34_5:
.L34_2:
.L34_6:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_7
	j .L34_8
.L34_7:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L34_9
	j .L34_8
.L34_9:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_imm
	mv s1, a0
	bnez s1, .L34_10
	j .L34_8
.L34_8:
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
.L34_10:
.L34_11:
	li s1, 0
	bnez s1, .L34_6
	j .L34_12
.L34_12:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L34_13
	j .L34_14
.L34_13:
	lw s1, -20(s0)
	bnez s1, .L34_15
	j .L34_16
.L34_15:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_17
	j .L34_18
.L34_17:
	li s1, 26
	sw s1, -40(s0)
	j .L34_19
.L34_18:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_20
	j .L34_21
.L34_20:
	li s1, 23
	sw s1, -44(s0)
	j .L34_22
.L34_21:
	li s1, 1
	neg s2, s1
	sw s2, -44(s0)
.L34_22:
	lw s1, -44(s0)
	sw s1, -40(s0)
.L34_19:
	lw s1, -40(s0)
	sw s1, -36(s0)
.L34_23:
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L34_24
	j .L34_25
.L34_25:
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
.L34_24:
.L34_26:
	li s1, 0
	bnez s1, .L34_23
	j .L34_27
.L34_27:
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -12(s0)
	li s4, 1
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 12
	add s5, s4, s3
	lw s3, 0(s5)
	lw s4, -12(s0)
	li s5, 1
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 8
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -12(s0)
	li s4, 0
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 4
	add s5, s4, s3
	lw s3, 0(s5)
	li s4, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_u
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
.L34_16:
	li s1, 4
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
.L34_14:
	lw s1, -20(s0)
	bnez s1, .L34_28
	j .L34_29
.L34_28:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -12(s0)
	li s4, 0
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 4
	add s5, s4, s3
	lw s3, 0(s5)
	lw s4, -12(s0)
	li s5, 1
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 8
	add s6, s5, s4
	lw s4, 0(s6)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_u
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
.L34_29:
	li s1, 4
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
.Lfunc_end34:
	.size enc_u_type, .Lfunc_end34-enc_u_type

	.text
	.align 2
	.type enc_amo, @function
enc_amo:
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
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	lw s1, -8(s0)
	la s2, __str_269
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_0
	j .L35_1
.L35_0:
	li s1, 2
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L35_2
.L35_1:
	lw s1, -8(s0)
	la s2, __str_270
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_3
	j .L35_4
.L35_3:
	li s1, 3
	sw s1, -28(s0)
	j .L35_5
.L35_4:
	lw s1, -8(s0)
	la s2, __str_271
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_6
	j .L35_7
.L35_6:
	li s1, 1
	sw s1, -28(s0)
	j .L35_8
.L35_7:
	lw s1, -8(s0)
	la s2, __str_272
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_9
	j .L35_10
.L35_9:
	li s1, 0
	sw s1, -28(s0)
	j .L35_11
.L35_10:
	lw s1, -8(s0)
	la s2, __str_273
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_12
	j .L35_13
.L35_12:
	li s1, 4
	sw s1, -28(s0)
	j .L35_14
.L35_13:
	lw s1, -8(s0)
	la s2, __str_274
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_15
	j .L35_16
.L35_15:
	li s1, 12
	sw s1, -28(s0)
	j .L35_17
.L35_16:
	lw s1, -8(s0)
	la s2, __str_275
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_18
	j .L35_19
.L35_18:
	li s1, 8
	sw s1, -28(s0)
	j .L35_20
.L35_19:
	lw s1, -8(s0)
	la s2, __str_276
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_21
	j .L35_22
.L35_21:
	li s1, 16
	sw s1, -28(s0)
	j .L35_23
.L35_22:
	lw s1, -8(s0)
	la s2, __str_277
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_24
	j .L35_25
.L35_24:
	li s1, 20
	sw s1, -28(s0)
	j .L35_26
.L35_25:
	lw s1, -8(s0)
	la s2, __str_278
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_27
	j .L35_28
.L35_27:
	li s1, 24
	sw s1, -28(s0)
	j .L35_29
.L35_28:
	lw s1, -8(s0)
	la s2, __str_279
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L35_30
	j .L35_31
.L35_30:
	li s1, 28
	sw s1, -28(s0)
	j .L35_32
.L35_31:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L35_32:
.L35_29:
.L35_26:
.L35_23:
.L35_20:
.L35_17:
.L35_14:
.L35_11:
.L35_8:
.L35_5:
.L35_2:
	lw s1, -32(s0)
	bnez s1, .L35_33
	j .L35_34
.L35_33:
.L35_35:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L35_36
	j .L35_37
.L35_36:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L35_38
	j .L35_37
.L35_38:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_mem
	mv s1, a0
	bnez s1, .L35_39
	j .L35_37
.L35_39:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L35_40
	j .L35_37
.L35_37:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L35_40:
.L35_41:
	li s1, 0
	bnez s1, .L35_35
	j .L35_42
.L35_42:
	lw s1, -20(s0)
	bnez s1, .L35_43
	j .L35_44
.L35_43:
	lw s1, -4(s0)
	li s2, 47
	li s3, 2
	lw s4, -28(s0)
	li s5, 2
	sll s6, s4, s5
	lw s4, -12(s0)
	li s5, 0
	li s7, 20
	mul s8, s5, s7
	add s5, s4, s8
	li s4, 4
	add s7, s5, s4
	lw s4, 0(s7)
	lw s5, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s5, s9
	li s5, 4
	add s8, s7, s5
	lw s5, 0(s8)
	li s7, 0
	mv a0, s2
	mv a1, s3
	mv a2, s6
	mv a3, s4
	mv a4, s5
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L35_44:
	j .L35_45
.L35_34:
.L35_46:
	lw s1, -16(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L35_47
	j .L35_48
.L35_47:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L35_49
	j .L35_48
.L35_49:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L35_50
	j .L35_48
.L35_50:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_mem
	mv s1, a0
	bnez s1, .L35_51
	j .L35_48
.L35_51:
	lw s1, -12(s0)
	li s2, 2
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L35_52
	j .L35_48
.L35_48:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L35_52:
.L35_53:
	li s1, 0
	bnez s1, .L35_46
	j .L35_54
.L35_54:
	lw s1, -20(s0)
	bnez s1, .L35_55
	j .L35_56
.L35_55:
	lw s1, -4(s0)
	li s2, 47
	li s3, 2
	lw s4, -28(s0)
	li s5, 2
	sll s6, s4, s5
	lw s4, -12(s0)
	li s5, 0
	li s7, 20
	mul s8, s5, s7
	add s5, s4, s8
	li s4, 4
	add s7, s5, s4
	lw s4, 0(s7)
	lw s5, -12(s0)
	li s7, 2
	li s8, 20
	mul s9, s7, s8
	add s7, s5, s9
	li s5, 4
	add s8, s7, s5
	lw s5, 0(s8)
	lw s7, -12(s0)
	li s8, 1
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s6
	mv a3, s4
	mv a4, s5
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L35_56:
.L35_45:
	li s1, 4
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
.Lfunc_end35:
	.size enc_amo, .Lfunc_end35-enc_amo

	.text
	.align 2
	.type enc_li, @function
enc_li:
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
.L36_0:
	lw s1, -12(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L36_1
	j .L36_2
.L36_1:
	lw s1, -8(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L36_3
	j .L36_2
.L36_3:
	lw s1, -8(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_imm
	mv s1, a0
	bnez s1, .L36_4
	j .L36_2
.L36_4:
	lw s1, -8(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L36_5
	j .L36_2
.L36_2:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L36_5:
.L36_6:
	li s1, 0
	bnez s1, .L36_0
	j .L36_7
.L36_7:
	lw s1, -8(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 2048
	neg s3, s2
	slt s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L36_8
	j .L36_9
.L36_8:
	lw s1, -20(s0)
	li s2, 2047
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L36_10
	j .L36_9
.L36_10:
	lw s1, -16(s0)
	bnez s1, .L36_11
	j .L36_12
.L36_11:
	lw s1, -4(s0)
	li s2, 19
	li s3, 0
	lw s4, -8(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	li s5, 0
	lw s6, -20(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L36_12:
	li s1, 4
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
.L36_9:
	lw s1, -20(s0)
	li s2, 2048
	add s3, s1, s2
	li s1, 12
	sra s2, s3, s1
	sw s2, -24(s0)
	lw s1, -20(s0)
	lw s2, -24(s0)
	li s3, 12
	sll s4, s2, s3
	sub s2, s1, s4
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L36_13
	j .L36_14
.L36_13:
	lw s1, -16(s0)
	bnez s1, .L36_15
	j .L36_16
.L36_15:
	lw s1, -4(s0)
	li s2, 55
	lw s3, -8(s0)
	li s4, 0
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 4
	add s5, s4, s3
	lw s3, 0(s5)
	lw s4, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_u
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
.L36_16:
	li s1, 4
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
.L36_14:
	lw s1, -16(s0)
	bnez s1, .L36_17
	j .L36_18
.L36_17:
	lw s1, -4(s0)
	li s2, 55
	lw s3, -8(s0)
	li s4, 0
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 4
	add s5, s4, s3
	lw s3, 0(s5)
	lw s4, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_u
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
	lw s1, -4(s0)
	li s2, 19
	li s3, 0
	lw s4, -8(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -8(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -28(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L36_18:
	li s1, 8
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
.Lfunc_end36:
	.size enc_li, .Lfunc_end36-enc_li

	.text
	.align 2
	.type enc_la, @function
enc_la:
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
.L37_0:
	lw s1, -12(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L37_1
	j .L37_2
.L37_1:
	lw s1, -8(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L37_3
	j .L37_2
.L37_3:
	lw s1, -8(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L37_4
	j .L37_2
.L37_2:
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
.L37_4:
.L37_5:
	li s1, 0
	bnez s1, .L37_0
	j .L37_6
.L37_6:
	lw s1, -16(s0)
	bnez s1, .L37_7
	j .L37_8
.L37_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, new_pcrel_label
	mv s3, a0
	sw s3, -24(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	lw s3, -8(s0)
	li s4, 1
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	mv a0, s4
	jal ra, sym_target
	mv s3, a0
	li s4, 0
	li s5, 23
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
	lw s1, -4(s0)
	li s2, 23
	lw s3, -8(s0)
	li s4, 0
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 4
	add s5, s4, s3
	lw s3, 0(s5)
	li s4, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_u
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -4(s0)
	mv a0, s2
	jal ra, cur
	mv s3, a0
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	lw s3, -24(s0)
	li s4, 0
	li s5, 24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
	lw s1, -4(s0)
	li s2, 19
	li s3, 0
	lw s4, -8(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -8(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L37_8:
	li s1, 8
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
.Lfunc_end37:
	.size enc_la, .Lfunc_end37-enc_la

	.text
	.align 2
	.type enc_call, @function
enc_call:
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
.L38_0:
	lw s1, -12(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L38_1
	j .L38_2
.L38_1:
	lw s1, -8(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L38_3
	j .L38_2
.L38_2:
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
.L38_3:
.L38_4:
	li s1, 0
	bnez s1, .L38_0
	j .L38_5
.L38_5:
	lw s1, -16(s0)
	bnez s1, .L38_6
	j .L38_7
.L38_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	lw s3, -8(s0)
	li s4, 0
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	mv a0, s4
	jal ra, sym_target
	mv s3, a0
	li s4, 0
	li s5, 19
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
	lw s1, -4(s0)
	li s2, 23
	li s3, 1
	li s4, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_u
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
	lw s1, -4(s0)
	li s2, 103
	li s3, 0
	li s4, 1
	li s5, 1
	li s6, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L38_7:
	li s1, 8
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
.Lfunc_end38:
	.size enc_call, .Lfunc_end38-enc_call

	.text
	.align 2
	.type enc_tail, @function
enc_tail:
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
.L39_0:
	lw s1, -12(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L39_1
	j .L39_2
.L39_1:
	lw s1, -8(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, sym_target
	mv s1, a0
	bnez s1, .L39_3
	j .L39_2
.L39_2:
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
.L39_3:
.L39_4:
	li s1, 0
	bnez s1, .L39_0
	j .L39_5
.L39_5:
	lw s1, -16(s0)
	bnez s1, .L39_6
	j .L39_7
.L39_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cur
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	lw s3, -8(s0)
	li s4, 0
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	mv a0, s4
	jal ra, sym_target
	mv s3, a0
	li s4, 0
	li s5, 19
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, reloc_sym
	mv s6, a0
	lw s1, -4(s0)
	li s2, 23
	li s3, 6
	li s4, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, enc_u
	mv s5, a0
	mv a0, s1
	mv a1, s5
	jal ra, emit_word
	mv s2, a0
	lw s1, -4(s0)
	li s2, 103
	li s3, 0
	li s4, 0
	li s5, 6
	li s6, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L39_7:
	li s1, 8
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
.Lfunc_end39:
	.size enc_tail, .Lfunc_end39-enc_tail

	.text
	.align 2
	.globl rv_encode
	.type rv_encode, @function
rv_encode:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	lw s1, -8(s0)
	la s2, __str_280
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_0
	j .L40_1
.L40_0:
.L40_2:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_3
	j .L40_4
.L40_3:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_5
	j .L40_4
.L40_5:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_6
	j .L40_4
.L40_4:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_6:
.L40_7:
	li s1, 0
	bnez s1, .L40_2
	j .L40_8
.L40_8:
	lw s1, -20(s0)
	bnez s1, .L40_9
	j .L40_10
.L40_9:
	lw s1, -4(s0)
	li s2, 19
	li s3, 0
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L40_10:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_1:
	lw s1, -8(s0)
	la s2, __str_281
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_11
	j .L40_12
.L40_11:
.L40_13:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_14
	j .L40_15
.L40_14:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_16
	j .L40_15
.L40_16:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_17
	j .L40_15
.L40_15:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_17:
.L40_18:
	li s1, 0
	bnez s1, .L40_13
	j .L40_19
.L40_19:
	lw s1, -20(s0)
	bnez s1, .L40_20
	j .L40_21
.L40_20:
	lw s1, -4(s0)
	li s2, 51
	li s3, 0
	li s4, 32
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 0
	lw s7, -12(s0)
	li s8, 1
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L40_21:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_12:
	lw s1, -8(s0)
	la s2, __str_282
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_22
	j .L40_23
.L40_22:
.L40_24:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_25
	j .L40_26
.L40_25:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_27
	j .L40_26
.L40_27:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_28
	j .L40_26
.L40_26:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_28:
.L40_29:
	li s1, 0
	bnez s1, .L40_24
	j .L40_30
.L40_30:
	lw s1, -20(s0)
	bnez s1, .L40_31
	j .L40_32
.L40_31:
	lw s1, -4(s0)
	li s2, 19
	li s3, 4
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 1
	neg s7, s6
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s7
	jal ra, enc_i
	mv s6, a0
	mv a0, s1
	mv a1, s6
	jal ra, emit_word
	mv s2, a0
.L40_32:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_23:
	lw s1, -8(s0)
	la s2, __str_283
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_33
	j .L40_34
.L40_33:
.L40_35:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_36
	j .L40_37
.L40_36:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_38
	j .L40_37
.L40_38:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_39
	j .L40_37
.L40_37:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_39:
.L40_40:
	li s1, 0
	bnez s1, .L40_35
	j .L40_41
.L40_41:
	lw s1, -20(s0)
	bnez s1, .L40_42
	j .L40_43
.L40_42:
	lw s1, -4(s0)
	li s2, 19
	li s3, 3
	lw s4, -12(s0)
	li s5, 0
	li s6, 20
	mul s7, s5, s6
	add s5, s4, s7
	li s4, 4
	add s6, s5, s4
	lw s4, 0(s6)
	lw s5, -12(s0)
	li s6, 1
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 1
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L40_43:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_34:
	lw s1, -8(s0)
	la s2, __str_284
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_44
	j .L40_45
.L40_44:
.L40_46:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_47
	j .L40_48
.L40_47:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_49
	j .L40_48
.L40_49:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_reg
	mv s1, a0
	bnez s1, .L40_50
	j .L40_48
.L40_48:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_50:
.L40_51:
	li s1, 0
	bnez s1, .L40_46
	j .L40_52
.L40_52:
	lw s1, -20(s0)
	bnez s1, .L40_53
	j .L40_54
.L40_53:
	lw s1, -4(s0)
	li s2, 51
	li s3, 3
	li s4, 0
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	li s6, 0
	lw s7, -12(s0)
	li s8, 1
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L40_54:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_45:
	lw s1, -8(s0)
	la s2, __str_285
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_55
	j .L40_56
.L40_55:
.L40_57:
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_58
	j .L40_59
.L40_59:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_58:
.L40_60:
	li s1, 0
	bnez s1, .L40_57
	j .L40_61
.L40_61:
	lw s1, -20(s0)
	bnez s1, .L40_62
	j .L40_63
.L40_62:
	lw s1, -4(s0)
	li s2, 19
	li s3, 0
	li s4, 0
	li s5, 0
	li s6, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	jal ra, enc_i
	mv s7, a0
	mv a0, s1
	mv a1, s7
	jal ra, emit_word
	mv s2, a0
.L40_63:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_56:
	lw s1, -8(s0)
	la s2, __str_286
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_64
	j .L40_65
.L40_65:
	lw s1, -8(s0)
	la s2, __str_287
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_64
	j .L40_66
.L40_66:
	lw s1, -8(s0)
	la s2, __str_288
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_64
	j .L40_67
.L40_64:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_68
	j .L40_69
.L40_68:
	li s1, 16
	sw s1, -36(s0)
	j .L40_70
.L40_69:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 100
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_71
	j .L40_72
.L40_71:
	li s1, 17
	sw s1, -40(s0)
	j .L40_73
.L40_72:
	li s1, 18
	sw s1, -40(s0)
.L40_73:
	lw s1, -40(s0)
	sw s1, -36(s0)
.L40_70:
	lw s1, -36(s0)
	sw s1, -32(s0)
.L40_74:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_75
	j .L40_76
.L40_75:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L40_77
	j .L40_76
.L40_77:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L40_78
	j .L40_76
.L40_76:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_78:
.L40_79:
	li s1, 0
	bnez s1, .L40_74
	j .L40_80
.L40_80:
	lw s1, -20(s0)
	bnez s1, .L40_81
	j .L40_82
.L40_81:
	lw s1, -4(s0)
	li s2, 83
	li s3, 0
	lw s4, -32(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	lw s7, -12(s0)
	li s8, 1
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L40_82:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_67:
	lw s1, -8(s0)
	la s2, __str_289
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_83
	j .L40_84
.L40_84:
	lw s1, -8(s0)
	la s2, __str_290
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_83
	j .L40_85
.L40_85:
	lw s1, -8(s0)
	la s2, __str_291
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_83
	j .L40_86
.L40_83:
	lw s1, -8(s0)
	li s2, 5
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_87
	j .L40_88
.L40_87:
	li s1, 16
	sw s1, -48(s0)
	j .L40_89
.L40_88:
	lw s1, -8(s0)
	li s2, 5
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 100
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_90
	j .L40_91
.L40_90:
	li s1, 17
	sw s1, -52(s0)
	j .L40_92
.L40_91:
	li s1, 18
	sw s1, -52(s0)
.L40_92:
	lw s1, -52(s0)
	sw s1, -48(s0)
.L40_89:
	lw s1, -48(s0)
	sw s1, -44(s0)
.L40_93:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_94
	j .L40_95
.L40_94:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L40_96
	j .L40_95
.L40_96:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L40_97
	j .L40_95
.L40_95:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_97:
.L40_98:
	li s1, 0
	bnez s1, .L40_93
	j .L40_99
.L40_99:
	lw s1, -20(s0)
	bnez s1, .L40_100
	j .L40_101
.L40_100:
	lw s1, -4(s0)
	li s2, 83
	li s3, 1
	lw s4, -44(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	lw s7, -12(s0)
	li s8, 1
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L40_101:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_86:
	lw s1, -8(s0)
	la s2, __str_292
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_102
	j .L40_103
.L40_103:
	lw s1, -8(s0)
	la s2, __str_293
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_102
	j .L40_104
.L40_104:
	lw s1, -8(s0)
	la s2, __str_294
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_102
	j .L40_105
.L40_102:
	lw s1, -8(s0)
	li s2, 5
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_106
	j .L40_107
.L40_106:
	li s1, 16
	sw s1, -60(s0)
	j .L40_108
.L40_107:
	lw s1, -8(s0)
	li s2, 5
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 100
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_109
	j .L40_110
.L40_109:
	li s1, 17
	sw s1, -64(s0)
	j .L40_111
.L40_110:
	li s1, 18
	sw s1, -64(s0)
.L40_111:
	lw s1, -64(s0)
	sw s1, -60(s0)
.L40_108:
	lw s1, -60(s0)
	sw s1, -56(s0)
.L40_112:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_113
	j .L40_114
.L40_113:
	lw s1, -12(s0)
	li s2, 0
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L40_115
	j .L40_114
.L40_115:
	lw s1, -12(s0)
	li s2, 1
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, is_freg
	mv s1, a0
	bnez s1, .L40_116
	j .L40_114
.L40_114:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_116:
.L40_117:
	li s1, 0
	bnez s1, .L40_112
	j .L40_118
.L40_118:
	lw s1, -20(s0)
	bnez s1, .L40_119
	j .L40_120
.L40_119:
	lw s1, -4(s0)
	li s2, 83
	li s3, 2
	lw s4, -56(s0)
	lw s5, -12(s0)
	li s6, 0
	li s7, 20
	mul s8, s6, s7
	add s6, s5, s8
	li s5, 4
	add s7, s6, s5
	lw s5, 0(s7)
	lw s6, -12(s0)
	li s7, 1
	li s8, 20
	mul s9, s7, s8
	add s7, s6, s9
	li s6, 4
	add s8, s7, s6
	lw s6, 0(s8)
	lw s7, -12(s0)
	li s8, 1
	li s9, 20
	mul s10, s8, s9
	add s8, s7, s10
	li s7, 4
	add s9, s8, s7
	lw s7, 0(s9)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv a5, s7
	jal ra, enc_r
	mv s8, a0
	mv a0, s1
	mv a1, s8
	jal ra, emit_word
	mv s2, a0
.L40_120:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_105:
	lw s1, -8(s0)
	la s2, __str_295
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_121
	j .L40_122
.L40_121:
	lw s1, -4(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, enc_li
	mv s5, a0
	mv a0, s5
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_122:
	lw s1, -8(s0)
	la s2, __str_296
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_123
	j .L40_124
.L40_123:
	lw s1, -4(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, enc_la
	mv s5, a0
	mv a0, s5
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_124:
	lw s1, -8(s0)
	la s2, __str_297
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_125
	j .L40_126
.L40_125:
	lw s1, -4(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, enc_call
	mv s5, a0
	mv a0, s5
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_126:
	lw s1, -8(s0)
	la s2, __str_298
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_127
	j .L40_128
.L40_127:
	lw s1, -4(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, enc_tail
	mv s5, a0
	mv a0, s5
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_128:
	lw s1, -8(s0)
	la s2, __str_299
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_129
	j .L40_130
.L40_129:
.L40_131:
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_132
	j .L40_133
.L40_133:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_132:
.L40_134:
	li s1, 0
	bnez s1, .L40_131
	j .L40_135
.L40_135:
	lw s1, -20(s0)
	bnez s1, .L40_136
	j .L40_137
.L40_136:
	lw s1, -4(s0)
	li s2, 115
	mv a0, s1
	mv a1, s2
	jal ra, emit_word
	mv s3, a0
.L40_137:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_130:
	lw s1, -8(s0)
	la s2, __str_300
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_138
	j .L40_139
.L40_138:
.L40_140:
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_141
	j .L40_142
.L40_142:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_141:
.L40_143:
	li s1, 0
	bnez s1, .L40_140
	j .L40_144
.L40_144:
	lw s1, -20(s0)
	bnez s1, .L40_145
	j .L40_146
.L40_145:
	lw s1, -4(s0)
	li s2, 1048691
	mv a0, s1
	mv a1, s2
	jal ra, emit_word
	mv s3, a0
.L40_146:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_139:
	lw s1, -8(s0)
	la s2, __str_301
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_147
	j .L40_148
.L40_147:
.L40_149:
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_150
	j .L40_151
.L40_151:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_150:
.L40_152:
	li s1, 0
	bnez s1, .L40_149
	j .L40_153
.L40_153:
	lw s1, -20(s0)
	bnez s1, .L40_154
	j .L40_155
.L40_154:
	lw s1, -4(s0)
	li s2, 267386895
	mv a0, s1
	mv a1, s2
	jal ra, emit_word
	mv s3, a0
.L40_155:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_148:
	lw s1, -8(s0)
	la s2, __str_302
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L40_156
	j .L40_157
.L40_156:
.L40_158:
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_159
	j .L40_160
.L40_160:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_159:
.L40_161:
	li s1, 0
	bnez s1, .L40_158
	j .L40_162
.L40_162:
	lw s1, -20(s0)
	bnez s1, .L40_163
	j .L40_164
.L40_163:
	lw s1, -4(s0)
	li s2, 4111
	mv a0, s1
	mv a1, s2
	jal ra, emit_word
	mv s3, a0
.L40_164:
	li s1, 4
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_157:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_op_rrr
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_165
	j .L40_166
.L40_165:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_166:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_op_rr
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_167
	j .L40_168
.L40_167:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_168:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_op_imm
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_169
	j .L40_170
.L40_169:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_170:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_load
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_171
	j .L40_172
.L40_171:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_172:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_store
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_173
	j .L40_174
.L40_173:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_174:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_branch
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_175
	j .L40_176
.L40_175:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_176:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_jal
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_177
	j .L40_178
.L40_177:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_178:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_jalr
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_179
	j .L40_180
.L40_179:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_180:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_u_type
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_181
	j .L40_182
.L40_181:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_182:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_amo
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_183
	j .L40_184
.L40_183:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_184:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_csr
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_185
	j .L40_186
.L40_185:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_186:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_float
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_187
	j .L40_188
.L40_187:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_188:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, enc_fma
	mv s6, a0
	sw s6, -28(s0)
	li s1, 1
	neg s2, s1
	xor s1, s6, s2
	snez s1, s1
	bnez s1, .L40_189
	j .L40_190
.L40_189:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_190:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end40:
	.size rv_encode, .Lfunc_end40-rv_encode

	.data
	.align 2
__str_302:
	.ascii "fence.i\000"
	.align 2
__str_301:
	.ascii "fence\000"
	.align 2
__str_300:
	.ascii "ebreak\000"
	.align 2
__str_299:
	.ascii "ecall\000"
	.align 2
__str_298:
	.ascii "tail\000"
	.align 2
__str_297:
	.ascii "call\000"
	.align 2
__str_296:
	.ascii "la\000"
	.align 2
__str_295:
	.ascii "li\000"
	.align 2
__str_294:
	.ascii "fabs.h\000"
	.align 2
__str_293:
	.ascii "fabs.d\000"
	.align 2
__str_292:
	.ascii "fabs.s\000"
	.align 2
__str_291:
	.ascii "fneg.h\000"
	.align 2
__str_290:
	.ascii "fneg.d\000"
	.align 2
__str_289:
	.ascii "fneg.s\000"
	.align 2
__str_288:
	.ascii "fmv.h\000"
	.align 2
__str_287:
	.ascii "fmv.d\000"
	.align 2
__str_286:
	.ascii "fmv.s\000"
	.align 2
__str_285:
	.ascii "nop\000"
	.align 2
__str_284:
	.ascii "snez\000"
	.align 2
__str_283:
	.ascii "seqz\000"
	.align 2
__str_282:
	.ascii "not\000"
	.align 2
__str_281:
	.ascii "neg\000"
	.align 2
__str_280:
	.ascii "mv\000"
	.align 2
__str_279:
	.ascii "amomaxu.w\000"
	.align 2
__str_278:
	.ascii "amominu.w\000"
	.align 2
__str_277:
	.ascii "amomax.w\000"
	.align 2
__str_276:
	.ascii "amomin.w\000"
	.align 2
__str_275:
	.ascii "amoor.w\000"
	.align 2
__str_274:
	.ascii "amoand.w\000"
	.align 2
__str_273:
	.ascii "amoxor.w\000"
	.align 2
__str_272:
	.ascii "amoadd.w\000"
	.align 2
__str_271:
	.ascii "amoswap.w\000"
	.align 2
__str_270:
	.ascii "sc.w\000"
	.align 2
__str_269:
	.ascii "lr.w\000"
	.align 2
__str_268:
	.ascii "auipc\000"
	.align 2
__str_267:
	.ascii "lui\000"
	.align 2
__str_266:
	.ascii "csrrci\000"
	.align 2
__str_265:
	.ascii "csrrsi\000"
	.align 2
__str_264:
	.ascii "csrrwi\000"
	.align 2
__str_263:
	.ascii "csrrc\000"
	.align 2
__str_262:
	.ascii "csrrs\000"
	.align 2
__str_261:
	.ascii "csrrw\000"
	.align 2
__str_260:
	.ascii "fnmadd.\000"
	.align 2
__str_259:
	.ascii "fnmsub.\000"
	.align 2
__str_258:
	.ascii "fmsub.\000"
	.align 2
__str_257:
	.ascii "fmadd.\000"
	.align 2
__str_256:
	.ascii "fcvt.h.d\000"
	.align 2
__str_255:
	.ascii "fcvt.d.h\000"
	.align 2
__str_254:
	.ascii "fcvt.h.s\000"
	.align 2
__str_253:
	.ascii "fcvt.s.h\000"
	.align 2
__str_252:
	.ascii "fcvt.d.s\000"
	.align 2
__str_251:
	.ascii "fcvt.s.d\000"
	.align 2
__str_250:
	.ascii "fcvt.wu.h\000"
	.align 2
__str_249:
	.ascii "fcvt.w.h\000"
	.align 2
__str_248:
	.ascii "fcvt.wu.d\000"
	.align 2
__str_247:
	.ascii "fcvt.w.d\000"
	.align 2
__str_246:
	.ascii "fcvt.wu.s\000"
	.align 2
__str_245:
	.ascii "fcvt.w.s\000"
	.align 2
__str_244:
	.ascii "fcvt.h.wu\000"
	.align 2
__str_243:
	.ascii "fcvt.h.w\000"
	.align 2
__str_242:
	.ascii "fcvt.d.wu\000"
	.align 2
__str_241:
	.ascii "fcvt.d.w\000"
	.align 2
__str_240:
	.ascii "fcvt.s.wu\000"
	.align 2
__str_239:
	.ascii "fcvt.s.w\000"
	.align 2
__str_238:
	.ascii "fmv.w.x\000"
	.align 2
__str_237:
	.ascii "fmv.h.x\000"
	.align 2
__str_236:
	.ascii "fmv.w.x\000"
	.align 2
__str_235:
	.ascii "fmv.x.w\000"
	.align 2
__str_234:
	.ascii "fmv.x.h\000"
	.align 2
__str_233:
	.ascii "fmv.x.w\000"
	.align 2
__str_232:
	.ascii "fclass.h\000"
	.align 2
__str_231:
	.ascii "fclass.d\000"
	.align 2
__str_230:
	.ascii "fclass.s\000"
	.align 2
__str_229:
	.ascii "fsqrt.h\000"
	.align 2
__str_228:
	.ascii "fsqrt.d\000"
	.align 2
__str_227:
	.ascii "fsqrt.s\000"
	.align 2
__str_226:
	.ascii "feq.h\000"
	.align 2
__str_225:
	.ascii "flt.h\000"
	.align 2
__str_224:
	.ascii "fle.h\000"
	.align 2
__str_223:
	.ascii "feq.d\000"
	.align 2
__str_222:
	.ascii "flt.d\000"
	.align 2
__str_221:
	.ascii "fle.d\000"
	.align 2
__str_220:
	.ascii "feq.s\000"
	.align 2
__str_219:
	.ascii "flt.s\000"
	.align 2
__str_218:
	.ascii "fle.s\000"
	.align 2
__str_217:
	.ascii "fmax.h\000"
	.align 2
__str_216:
	.ascii "fmin.h\000"
	.align 2
__str_215:
	.ascii "fmax.d\000"
	.align 2
__str_214:
	.ascii "fmin.d\000"
	.align 2
__str_213:
	.ascii "fmax.s\000"
	.align 2
__str_212:
	.ascii "fmin.s\000"
	.align 2
__str_211:
	.ascii "fsgnjx.h\000"
	.align 2
__str_210:
	.ascii "fsgnjn.h\000"
	.align 2
__str_209:
	.ascii "fsgnj.h\000"
	.align 2
__str_208:
	.ascii "fsgnjx.d\000"
	.align 2
__str_207:
	.ascii "fsgnjn.d\000"
	.align 2
__str_206:
	.ascii "fsgnj.d\000"
	.align 2
__str_205:
	.ascii "fsgnjx.s\000"
	.align 2
__str_204:
	.ascii "fsgnjn.s\000"
	.align 2
__str_203:
	.ascii "fsgnj.s\000"
	.align 2
__str_202:
	.ascii "fdiv.h\000"
	.align 2
__str_201:
	.ascii "fmul.h\000"
	.align 2
__str_200:
	.ascii "fsub.h\000"
	.align 2
__str_199:
	.ascii "fadd.h\000"
	.align 2
__str_198:
	.ascii "fdiv.d\000"
	.align 2
__str_197:
	.ascii "fmul.d\000"
	.align 2
__str_196:
	.ascii "fsub.d\000"
	.align 2
__str_195:
	.ascii "fadd.d\000"
	.align 2
__str_194:
	.ascii "fdiv.s\000"
	.align 2
__str_193:
	.ascii "fmul.s\000"
	.align 2
__str_192:
	.ascii "fsub.s\000"
	.align 2
__str_191:
	.ascii "fadd.s\000"
	.align 2
__str_190:
	.ascii "'%s' immediate %d out of range [-2048, 2047]\000"
	.align 2
__str_189:
	.ascii "jr\000"
	.align 2
__str_188:
	.ascii "ret\000"
	.align 2
__str_187:
	.ascii "j\000"
	.align 2
__str_186:
	.ascii "jal\000"
	.align 2
__str_185:
	.ascii "j\000"
	.align 2
__str_184:
	.ascii "bgtz\000"
	.align 2
__str_183:
	.ascii "bltz\000"
	.align 2
__str_182:
	.ascii "bgez\000"
	.align 2
__str_181:
	.ascii "blez\000"
	.align 2
__str_180:
	.ascii "bnez\000"
	.align 2
__str_179:
	.ascii "beqz\000"
	.align 2
__str_178:
	.ascii "bleu\000"
	.align 2
__str_177:
	.ascii "bgtu\000"
	.align 2
__str_176:
	.ascii "ble\000"
	.align 2
__str_175:
	.ascii "bgt\000"
	.align 2
__str_174:
	.ascii "bgeu\000"
	.align 2
__str_173:
	.ascii "bltu\000"
	.align 2
__str_172:
	.ascii "bge\000"
	.align 2
__str_171:
	.ascii "blt\000"
	.align 2
__str_170:
	.ascii "bne\000"
	.align 2
__str_169:
	.ascii "beq\000"
	.align 2
__str_168:
	.ascii "'%s' offset %d out of range [-2048, 2047]\000"
	.align 2
__str_167:
	.ascii "fsd\000"
	.align 2
__str_166:
	.ascii "fsw\000"
	.align 2
__str_165:
	.ascii "fsh\000"
	.align 2
__str_164:
	.ascii "sw\000"
	.align 2
__str_163:
	.ascii "sh\000"
	.align 2
__str_162:
	.ascii "sb\000"
	.align 2
__str_161:
	.ascii "'%s' offset %d out of range [-2048, 2047]\000"
	.align 2
__str_160:
	.ascii "fld\000"
	.align 2
__str_159:
	.ascii "flw\000"
	.align 2
__str_158:
	.ascii "flh\000"
	.align 2
__str_157:
	.ascii "lhu\000"
	.align 2
__str_156:
	.ascii "lbu\000"
	.align 2
__str_155:
	.ascii "lw\000"
	.align 2
__str_154:
	.ascii "lh\000"
	.align 2
__str_153:
	.ascii "lb\000"
	.align 2
__str_152:
	.ascii "'%s' immediate %d out of range [-2048, 2047]\000"
	.align 2
__str_151:
	.ascii "bseti\000"
	.align 2
__str_150:
	.ascii "binvi\000"
	.align 2
__str_149:
	.ascii "bexti\000"
	.align 2
__str_148:
	.ascii "bclri\000"
	.align 2
__str_147:
	.ascii "rori\000"
	.align 2
__str_146:
	.ascii "srai\000"
	.align 2
__str_145:
	.ascii "srli\000"
	.align 2
__str_144:
	.ascii "slli\000"
	.align 2
__str_143:
	.ascii "andi\000"
	.align 2
__str_142:
	.ascii "ori\000"
	.align 2
__str_141:
	.ascii "xori\000"
	.align 2
__str_140:
	.ascii "sltiu\000"
	.align 2
__str_139:
	.ascii "slti\000"
	.align 2
__str_138:
	.ascii "addi\000"
	.align 2
__str_137:
	.ascii "zext.h\000"
	.align 2
__str_136:
	.ascii "rev8\000"
	.align 2
__str_135:
	.ascii "orc.b\000"
	.align 2
__str_134:
	.ascii "sext.h\000"
	.align 2
__str_133:
	.ascii "sext.b\000"
	.align 2
__str_132:
	.ascii "cpop\000"
	.align 2
__str_131:
	.ascii "ctz\000"
	.align 2
__str_130:
	.ascii "clz\000"
	.align 2
__str_129:
	.ascii "bset\000"
	.align 2
__str_128:
	.ascii "binv\000"
	.align 2
__str_127:
	.ascii "bext\000"
	.align 2
__str_126:
	.ascii "bclr\000"
	.align 2
__str_125:
	.ascii "ror\000"
	.align 2
__str_124:
	.ascii "rol\000"
	.align 2
__str_123:
	.ascii "maxu\000"
	.align 2
__str_122:
	.ascii "max\000"
	.align 2
__str_121:
	.ascii "minu\000"
	.align 2
__str_120:
	.ascii "min\000"
	.align 2
__str_119:
	.ascii "xnor\000"
	.align 2
__str_118:
	.ascii "orn\000"
	.align 2
__str_117:
	.ascii "andn\000"
	.align 2
__str_116:
	.ascii "sh3add\000"
	.align 2
__str_115:
	.ascii "sh2add\000"
	.align 2
__str_114:
	.ascii "sh1add\000"
	.align 2
__str_113:
	.ascii "remu\000"
	.align 2
__str_112:
	.ascii "rem\000"
	.align 2
__str_111:
	.ascii "divu\000"
	.align 2
__str_110:
	.ascii "div\000"
	.align 2
__str_109:
	.ascii "mulhu\000"
	.align 2
__str_108:
	.ascii "mulhsu\000"
	.align 2
__str_107:
	.ascii "mulh\000"
	.align 2
__str_106:
	.ascii "mul\000"
	.align 2
__str_105:
	.ascii "and\000"
	.align 2
__str_104:
	.ascii "or\000"
	.align 2
__str_103:
	.ascii "sra\000"
	.align 2
__str_102:
	.ascii "srl\000"
	.align 2
__str_101:
	.ascii "xor\000"
	.align 2
__str_100:
	.ascii "sltu\000"
	.align 2
__str_99:
	.ascii "slt\000"
	.align 2
__str_98:
	.ascii "sll\000"
	.align 2
__str_97:
	.ascii "sub\000"
	.align 2
__str_96:
	.ascii "add\000"
	.align 2
__str_95:
	.ascii "branch to '%s' out of range (displacement %d)\000"
	.align 2
__str_94:
	.ascii "jump to '%s' out of range (displacement %d)\000"
	.align 2
__str_93:
	.ascii ".Lpcrel_hi%d\000"
	.align 2
__str_92:
	.ascii "dyn\000"
	.align 2
__str_91:
	.ascii "rmm\000"
	.align 2
__str_90:
	.ascii "rup\000"
	.align 2
__str_89:
	.ascii "rdn\000"
	.align 2
__str_88:
	.ascii "rtz\000"
	.align 2
__str_87:
	.ascii "rne\000"
	.align 2
__str_86:
	.ascii "mhartid\000"
	.align 2
__str_85:
	.ascii "mimpid\000"
	.align 2
__str_84:
	.ascii "marchid\000"
	.align 2
__str_83:
	.ascii "mvendorid\000"
	.align 2
__str_82:
	.ascii "mip\000"
	.align 2
__str_81:
	.ascii "mtval\000"
	.align 2
__str_80:
	.ascii "mcause\000"
	.align 2
__str_79:
	.ascii "mepc\000"
	.align 2
__str_78:
	.ascii "mscratch\000"
	.align 2
__str_77:
	.ascii "mtvec\000"
	.align 2
__str_76:
	.ascii "mie\000"
	.align 2
__str_75:
	.ascii "misa\000"
	.align 2
__str_74:
	.ascii "mstatus\000"
	.align 2
__str_73:
	.ascii "instreth\000"
	.align 2
__str_72:
	.ascii "timeh\000"
	.align 2
__str_71:
	.ascii "cycleh\000"
	.align 2
__str_70:
	.ascii "instret\000"
	.align 2
__str_69:
	.ascii "time\000"
	.align 2
__str_68:
	.ascii "cycle\000"
	.align 2
__str_67:
	.ascii "fcsr\000"
	.align 2
__str_66:
	.ascii "frm\000"
	.align 2
__str_65:
	.ascii "fflags\000"
	.align 2
rv_freg.abi.1:
	.word __str_33
	.word __str_34
	.word __str_35
	.word __str_36
	.word __str_37
	.word __str_38
	.word __str_39
	.word __str_40
	.word __str_41
	.word __str_42
	.word __str_43
	.word __str_44
	.word __str_45
	.word __str_46
	.word __str_47
	.word __str_48
	.word __str_49
	.word __str_50
	.word __str_51
	.word __str_52
	.word __str_53
	.word __str_54
	.word __str_55
	.word __str_56
	.word __str_57
	.word __str_58
	.word __str_59
	.word __str_60
	.word __str_61
	.word __str_62
	.word __str_63
	.word __str_64
	.align 2
__str_64:
	.ascii "ft11\000"
	.align 2
__str_63:
	.ascii "ft10\000"
	.align 2
__str_62:
	.ascii "ft9\000"
	.align 2
__str_61:
	.ascii "ft8\000"
	.align 2
__str_60:
	.ascii "fs11\000"
	.align 2
__str_59:
	.ascii "fs10\000"
	.align 2
__str_58:
	.ascii "fs9\000"
	.align 2
__str_57:
	.ascii "fs8\000"
	.align 2
__str_56:
	.ascii "fs7\000"
	.align 2
__str_55:
	.ascii "fs6\000"
	.align 2
__str_54:
	.ascii "fs5\000"
	.align 2
__str_53:
	.ascii "fs4\000"
	.align 2
__str_52:
	.ascii "fs3\000"
	.align 2
__str_51:
	.ascii "fs2\000"
	.align 2
__str_50:
	.ascii "fa7\000"
	.align 2
__str_49:
	.ascii "fa6\000"
	.align 2
__str_48:
	.ascii "fa5\000"
	.align 2
__str_47:
	.ascii "fa4\000"
	.align 2
__str_46:
	.ascii "fa3\000"
	.align 2
__str_45:
	.ascii "fa2\000"
	.align 2
__str_44:
	.ascii "fa1\000"
	.align 2
__str_43:
	.ascii "fa0\000"
	.align 2
__str_42:
	.ascii "fs1\000"
	.align 2
__str_41:
	.ascii "fs0\000"
	.align 2
__str_40:
	.ascii "ft7\000"
	.align 2
__str_39:
	.ascii "ft6\000"
	.align 2
__str_38:
	.ascii "ft5\000"
	.align 2
__str_37:
	.ascii "ft4\000"
	.align 2
__str_36:
	.ascii "ft3\000"
	.align 2
__str_35:
	.ascii "ft2\000"
	.align 2
__str_34:
	.ascii "ft1\000"
	.align 2
__str_33:
	.ascii "ft0\000"
	.align 2
__str_32:
	.ascii "fp\000"
	.align 2
rv_ireg.abi.0:
	.word __str_0
	.word __str_1
	.word __str_2
	.word __str_3
	.word __str_4
	.word __str_5
	.word __str_6
	.word __str_7
	.word __str_8
	.word __str_9
	.word __str_10
	.word __str_11
	.word __str_12
	.word __str_13
	.word __str_14
	.word __str_15
	.word __str_16
	.word __str_17
	.word __str_18
	.word __str_19
	.word __str_20
	.word __str_21
	.word __str_22
	.word __str_23
	.word __str_24
	.word __str_25
	.word __str_26
	.word __str_27
	.word __str_28
	.word __str_29
	.word __str_30
	.word __str_31
	.align 2
__str_31:
	.ascii "t6\000"
	.align 2
__str_30:
	.ascii "t5\000"
	.align 2
__str_29:
	.ascii "t4\000"
	.align 2
__str_28:
	.ascii "t3\000"
	.align 2
__str_27:
	.ascii "s11\000"
	.align 2
__str_26:
	.ascii "s10\000"
	.align 2
__str_25:
	.ascii "s9\000"
	.align 2
__str_24:
	.ascii "s8\000"
	.align 2
__str_23:
	.ascii "s7\000"
	.align 2
__str_22:
	.ascii "s6\000"
	.align 2
__str_21:
	.ascii "s5\000"
	.align 2
__str_20:
	.ascii "s4\000"
	.align 2
__str_19:
	.ascii "s3\000"
	.align 2
__str_18:
	.ascii "s2\000"
	.align 2
__str_17:
	.ascii "a7\000"
	.align 2
__str_16:
	.ascii "a6\000"
	.align 2
__str_15:
	.ascii "a5\000"
	.align 2
__str_14:
	.ascii "a4\000"
	.align 2
__str_13:
	.ascii "a3\000"
	.align 2
__str_12:
	.ascii "a2\000"
	.align 2
__str_11:
	.ascii "a1\000"
	.align 2
__str_10:
	.ascii "a0\000"
	.align 2
__str_9:
	.ascii "s1\000"
	.align 2
__str_8:
	.ascii "s0\000"
	.align 2
__str_7:
	.ascii "t2\000"
	.align 2
__str_6:
	.ascii "t1\000"
	.align 2
__str_5:
	.ascii "t0\000"
	.align 2
__str_4:
	.ascii "tp\000"
	.align 2
__str_3:
	.ascii "gp\000"
	.align 2
__str_2:
	.ascii "sp\000"
	.align 2
__str_1:
	.ascii "ra\000"
	.align 2
__str_0:
	.ascii "zero\000"

	.section .rodata
	.align 2
rv_csr.csrs.2:
	.word __str_65
	.word 0x00000001
	.word __str_66
	.word 0x00000002
	.word __str_67
	.word 0x00000003
	.word __str_68
	.word 0x00000c00
	.word __str_69
	.word 0x00000c01
	.word __str_70
	.word 0x00000c02
	.word __str_71
	.word 0x00000c80
	.word __str_72
	.word 0x00000c81
	.word __str_73
	.word 0x00000c82
	.word __str_74
	.word 0x00000300
	.word __str_75
	.word 0x00000301
	.word __str_76
	.word 0x00000304
	.word __str_77
	.word 0x00000305
	.word __str_78
	.word 0x00000340
	.word __str_79
	.word 0x00000341
	.word __str_80
	.word 0x00000342
	.word __str_81
	.word 0x00000343
	.word __str_82
	.word 0x00000344
	.word __str_83
	.word 0x00000f11
	.word __str_84
	.word 0x00000f12
	.word __str_85
	.word 0x00000f13
	.word __str_86
	.word 0x00000f14
