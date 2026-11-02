# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl isdigit
	.type isdigit, @function
isdigit:
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
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	lw s1, -4(s0)
	li s2, 57
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_2
	j .L1_1
.L1_2:
	li s1, 1
	j .L1_3
.L1_1:
	li s1, 0
.L1_3:
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
	.size isdigit, .Lfunc_end1-isdigit

	.text
	.align 2
	.globl isxdigit
	.type isxdigit, @function
isxdigit:
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
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_0
	j .L2_1
.L2_0:
	lw s1, -4(s0)
	li s2, 57
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L2_2
	j .L2_1
.L2_1:
	lw s1, -4(s0)
	li s2, 97
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_3
	j .L2_4
.L2_3:
	lw s1, -4(s0)
	li s2, 102
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L2_2
	j .L2_4
.L2_4:
	lw s1, -4(s0)
	li s2, 65
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_5
	j .L2_6
.L2_5:
	lw s1, -4(s0)
	li s2, 70
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L2_2
	j .L2_6
.L2_2:
	li s1, 1
	j .L2_7
.L2_6:
	li s1, 0
.L2_7:
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
	.size isxdigit, .Lfunc_end2-isxdigit

	.text
	.align 2
	.globl isupper
	.type isupper, @function
isupper:
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
	li s2, 65
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	li s2, 90
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_2
	j .L3_1
.L3_2:
	li s1, 1
	j .L3_3
.L3_1:
	li s1, 0
.L3_3:
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
	.size isupper, .Lfunc_end3-isupper

	.text
	.align 2
	.globl islower
	.type islower, @function
islower:
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
	li s2, 97
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	li s2, 122
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L4_2
	j .L4_1
.L4_2:
	li s1, 1
	j .L4_3
.L4_1:
	li s1, 0
.L4_3:
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
	.size islower, .Lfunc_end4-islower

	.text
	.align 2
	.globl isalpha
	.type isalpha, @function
isalpha:
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
	jal ra, isupper
	mv s2, a0
	bnez s2, .L5_0
	j .L5_1
.L5_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, islower
	mv s2, a0
	bnez s2, .L5_0
	j .L5_2
.L5_0:
	li s1, 1
	j .L5_3
.L5_2:
	li s1, 0
.L5_3:
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
	.size isalpha, .Lfunc_end5-isalpha

	.text
	.align 2
	.globl isalnum
	.type isalnum, @function
isalnum:
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
	jal ra, isalpha
	mv s2, a0
	bnez s2, .L6_0
	j .L6_1
.L6_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, isdigit
	mv s2, a0
	bnez s2, .L6_0
	j .L6_2
.L6_0:
	li s1, 1
	j .L6_3
.L6_2:
	li s1, 0
.L6_3:
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
.Lfunc_end6:
	.size isalnum, .Lfunc_end6-isalnum

	.text
	.align 2
	.globl isspace
	.type isspace, @function
isspace:
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
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_1
.L7_1:
	lw s1, -4(s0)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_2
.L7_2:
	lw s1, -4(s0)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_3
.L7_3:
	lw s1, -4(s0)
	li s2, 11
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_4
.L7_4:
	lw s1, -4(s0)
	li s2, 12
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_5
.L7_5:
	lw s1, -4(s0)
	li s2, 13
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_6
.L7_0:
	li s1, 1
	j .L7_7
.L7_6:
	li s1, 0
.L7_7:
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
.Lfunc_end7:
	.size isspace, .Lfunc_end7-isspace

	.text
	.align 2
	.globl isblank
	.type isblank, @function
isblank:
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
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_1:
	lw s1, -4(s0)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_2
.L8_0:
	li s1, 1
	j .L8_3
.L8_2:
	li s1, 0
.L8_3:
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
	.size isblank, .Lfunc_end8-isblank

	.text
	.align 2
	.globl iscntrl
	.type iscntrl, @function
iscntrl:
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
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_0
	j .L9_1
.L9_0:
	lw s1, -4(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L9_2
	j .L9_1
.L9_1:
	lw s1, -4(s0)
	li s2, 127
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_2
	j .L9_3
.L9_2:
	li s1, 1
	j .L9_4
.L9_3:
	li s1, 0
.L9_4:
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
	.size iscntrl, .Lfunc_end9-iscntrl

	.text
	.align 2
	.globl isprint
	.type isprint, @function
isprint:
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
	li s2, 32
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -4(s0)
	li s2, 127
	slt s3, s1, s2
	bnez s3, .L10_2
	j .L10_1
.L10_2:
	li s1, 1
	j .L10_3
.L10_1:
	li s1, 0
.L10_3:
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
.Lfunc_end10:
	.size isprint, .Lfunc_end10-isprint

	.text
	.align 2
	.globl isgraph
	.type isgraph, @function
isgraph:
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
	li s2, 32
	slt s3, s2, s1
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	lw s1, -4(s0)
	li s2, 127
	slt s3, s1, s2
	bnez s3, .L11_2
	j .L11_1
.L11_2:
	li s1, 1
	j .L11_3
.L11_1:
	li s1, 0
.L11_3:
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
	.size isgraph, .Lfunc_end11-isgraph

	.text
	.align 2
	.globl ispunct
	.type ispunct, @function
ispunct:
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
	jal ra, isgraph
	mv s2, a0
	bnez s2, .L12_0
	j .L12_1
.L12_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, isalnum
	mv s2, a0
	bnez s2, .L12_1
	j .L12_2
.L12_2:
	li s1, 1
	j .L12_3
.L12_1:
	li s1, 0
.L12_3:
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
	.size ispunct, .Lfunc_end12-ispunct

	.text
	.align 2
	.globl tolower
	.type tolower, @function
tolower:
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
	mv a0, s1
	jal ra, isupper
	mv s2, a0
	bnez s2, .L13_0
	j .L13_1
.L13_0:
	lw s1, -4(s0)
	li s2, 65
	sub s3, s1, s2
	li s1, 97
	add s2, s3, s1
	sw s2, -12(s0)
	j .L13_2
.L13_1:
	lw s1, -4(s0)
	sw s1, -12(s0)
.L13_2:
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
.Lfunc_end13:
	.size tolower, .Lfunc_end13-tolower

	.text
	.align 2
	.globl toupper
	.type toupper, @function
toupper:
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
	mv a0, s1
	jal ra, islower
	mv s2, a0
	bnez s2, .L14_0
	j .L14_1
.L14_0:
	lw s1, -4(s0)
	li s2, 97
	sub s3, s1, s2
	li s1, 65
	add s2, s3, s1
	sw s2, -12(s0)
	j .L14_2
.L14_1:
	lw s1, -4(s0)
	sw s1, -12(s0)
.L14_2:
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
.Lfunc_end14:
	.size toupper, .Lfunc_end14-toupper

	.data
