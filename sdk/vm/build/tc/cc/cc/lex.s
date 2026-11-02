# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl cc_lex_init
	.type cc_lex_init, @function
cc_lex_init:
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
	la s2, lex_arena
	sw s1, 0(s2)
	lw s1, -8(s0)
	la s2, src_buf
	sw s1, 0(s2)
	lw s1, -12(s0)
	bnez s1, .L1_0
	j .L1_1
.L1_0:
	lw s1, -12(s0)
	sw s1, -20(s0)
	j .L1_2
.L1_1:
	la s1, __str_50
	sw s1, -20(s0)
.L1_2:
	lw s1, -20(s0)
	la s2, src_file
	sw s1, 0(s2)
	lw s1, -8(s0)
	la s2, p
	sw s1, 0(s2)
	li s1, 1
	la s2, line
	sw s1, 0(s2)
	lw s1, -8(s0)
	la s2, line_start
	sw s1, 0(s2)
	li s1, 1
	la s2, cur_tok_col
	sw s1, 0(s2)
	li s1, 0
	la s2, peeked
	sw s1, 0(s2)
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
.Lfunc_end1:
	.size cc_lex_init, .Lfunc_end1-cc_lex_init

	.text
	.align 2
	.globl cc_lex_col
	.type cc_lex_col, @function
cc_lex_col:
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
	la s1, cur_tok_col
	lw s2, 0(s1)
	mv a0, s2
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
.Lfunc_end2:
	.size cc_lex_col, .Lfunc_end2-cc_lex_col

	.text
	.align 2
	.globl cc_lex_line
	.type cc_lex_line, @function
cc_lex_line:
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
	la s1, line
	lw s2, 0(s1)
	mv a0, s2
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
.Lfunc_end3:
	.size cc_lex_line, .Lfunc_end3-cc_lex_line

	.text
	.align 2
	.globl cc_lex_file
	.type cc_lex_file, @function
cc_lex_file:
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
	la s1, src_file
	lw s2, 0(s1)
	mv a0, s2
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
	.size cc_lex_file, .Lfunc_end4-cc_lex_file

	.text
	.align 2
	.globl cc_tok_name
	.type cc_tok_name, @function
cc_tok_name:
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
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_0
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_1
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_2
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_3
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_4
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_5
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_6
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_7
	li s2, 49
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_8
	li s2, 50
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_9
	li s2, 51
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_10
	li s2, 52
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_11
	li s2, 53
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_12
	li s2, 54
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_13
	li s2, 55
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_14
	li s2, 56
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_15
	li s2, 57
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_16
	li s2, 58
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_17
	li s2, 91
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_18
	li s2, 92
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_19
	j .L5_20
.L5_0:
	la s1, __str_51
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
.L5_1:
	la s1, __str_52
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
.L5_2:
	la s1, __str_53
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
.L5_3:
	la s1, __str_54
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
	la s1, __str_55
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
.L5_5:
	la s1, __str_56
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
.L5_6:
	la s1, __str_57
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
.L5_7:
	la s1, __str_58
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
.L5_8:
	la s1, __str_59
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
.L5_9:
	la s1, __str_60
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
.L5_10:
	la s1, __str_61
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
.L5_11:
	la s1, __str_62
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
.L5_12:
	la s1, __str_63
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
.L5_13:
	la s1, __str_64
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
.L5_14:
	la s1, __str_65
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
.L5_15:
	la s1, __str_66
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
.L5_16:
	la s1, __str_67
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
.L5_17:
	la s1, __str_68
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
.L5_18:
	la s1, __str_69
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
.L5_19:
	la s1, __str_70
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
.L5_20:
	j .L5_21
.L5_21:
	la s1, keywords
	sw s1, -12(s0)
.L5_22:
	lw s1, -12(s0)
	lw s2, 0(s1)
	bnez s2, .L5_23
	j .L5_24
.L5_23:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_25
	j .L5_26
.L5_25:
	lw s1, -12(s0)
	lw s2, 0(s1)
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
.L5_26:
.L5_27:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 8
	add s3, s2, s1
	sw s3, -12(s0)
	j .L5_22
.L5_24:
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
	.size cc_tok_name, .Lfunc_end5-cc_tok_name

	.text
	.align 2
	.globl cc_lex_print_context
	.type cc_lex_print_context, @function
cc_lex_print_context:
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
	la s1, src_buf
	lw s2, 0(s1)
	sw s2, -12(s0)
	li s1, 1
	sw s1, -16(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	sub s3, s1, s2
	sw s3, -20(s0)
	lw s1, -12(s0)
	bnez s1, .L6_0
	j .L6_1
.L6_0:
	lw s1, -4(s0)
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L6_1
	j .L6_2
.L6_1:
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
.L6_2:
	lw s1, -20(s0)
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L6_3
	j .L6_4
.L6_3:
	li s1, 1
	sw s1, -20(s0)
.L6_4:
.L6_5:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L6_6
	j .L6_7
.L6_6:
	lw s1, -12(s0)
	sw s1, -24(s0)
.L6_8:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L6_9
	j .L6_10
.L6_9:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_11
	j .L6_10
.L6_11:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L6_8
.L6_10:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_12
	j .L6_13
.L6_12:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
.L6_14:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_15
	j .L6_16
.L6_16:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_15
	j .L6_17
.L6_15:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L6_14
.L6_17:
.L6_18:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L6_19
	j .L6_20
.L6_19:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_21
	j .L6_20
.L6_21:
	lw s1, -32(s0)
	li s2, 10
	mul s3, s1, s2
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -28(s0)
	lb s1, 0(s2)
	li s2, 48
	sub s4, s1, s2
	add s1, s3, s4
	sw s1, -32(s0)
	li s1, 1
	sw s1, -36(s0)
	j .L6_18
.L6_20:
	lw s1, -36(s0)
	bnez s1, .L6_22
	j .L6_23
.L6_22:
	lw s1, -32(s0)
	sw s1, -16(s0)
.L6_23:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_24
	j .L6_25
.L6_24:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -40(s0)
	j .L6_26
.L6_25:
	lw s1, -24(s0)
	sw s1, -40(s0)
.L6_26:
	lw s1, -40(s0)
	sw s1, -12(s0)
	j .L6_5
.L6_13:
	lw s1, -16(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_27
	j .L6_28
.L6_27:
	lw s1, -16(s0)
	lw s2, -4(s0)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L6_29
	j .L6_28
.L6_29:
	la s1, __libc_stderr
	la s2, __str_71
	lw s3, -16(s0)
	lw s4, -24(s0)
	lw s5, -12(s0)
	sub s6, s4, s5
	lw s4, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	sw s6, 4(sp)
	sw s4, 8(sp)
	jal ra, fprintf
	mv s5, a0
	addi sp, sp, 16
.L6_28:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_30
	j .L6_31
.L6_30:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -44(s0)
	j .L6_32
.L6_31:
	lw s1, -24(s0)
	sw s1, -44(s0)
.L6_32:
	lw s1, -44(s0)
	sw s1, -12(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	slt s3, s2, s1
	bnez s3, .L6_33
	j .L6_34
.L6_33:
	j .L6_7
.L6_34:
	j .L6_5
.L6_7:
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
.Lfunc_end6:
	.size cc_lex_print_context, .Lfunc_end6-cc_lex_print_context

	.text
	.align 2
	.type skip_ws, @function
skip_ws:
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
.L7_0:
	j .L7_1
.L7_1:
.L7_2:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_3
	j .L7_4
.L7_4:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_3
	j .L7_5
.L7_5:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 13
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_3
	j .L7_6
.L7_3:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L7_2
.L7_6:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_7
	j .L7_8
.L7_7:
	la s1, line
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	la s1, p
	lw s2, 0(s1)
	la s1, line_start
	sw s2, 0(s1)
	j .L7_9
.L7_8:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_10
	j .L7_11
.L7_10:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L7_12:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_13
	j .L7_14
.L7_14:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_13
	j .L7_15
.L7_13:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L7_12
.L7_15:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L7_16
	j .L7_17
.L7_16:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_18
	j .L7_17
.L7_18:
	li s1, 0
	sw s1, -8(s0)
.L7_19:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L7_20
	j .L7_21
.L7_20:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_22
	j .L7_21
.L7_22:
	lw s1, -8(s0)
	li s2, 10
	mul s3, s1, s2
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -4(s0)
	lb s1, 0(s2)
	li s2, 48
	sub s4, s1, s2
	add s1, s3, s4
	sw s1, -8(s0)
	j .L7_19
.L7_21:
.L7_23:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_24
	j .L7_25
.L7_25:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_24
	j .L7_26
.L7_24:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L7_23
.L7_26:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_27
	j .L7_28
.L7_27:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	sw s3, -12(s0)
.L7_29:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L7_30
	j .L7_31
.L7_30:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L7_32
	j .L7_31
.L7_32:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L7_29
.L7_31:
	lw s1, -4(s0)
	lw s2, -12(s0)
	sub s3, s1, s2
	sw s3, -16(s0)
	la s1, lex_arena
	lw s2, 0(s1)
	lw s1, -16(s0)
	li s3, 1
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -20(s0)
	lw s1, -20(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -20(s0)
	lw s3, -16(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -20(s0)
	la s2, src_file
	sw s1, 0(s2)
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_33
	j .L7_34
.L7_33:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L7_34:
.L7_28:
.L7_35:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L7_36
	j .L7_37
.L7_36:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L7_38
	j .L7_37
.L7_38:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L7_35
.L7_37:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_39
	j .L7_40
.L7_39:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L7_40:
	lw s1, -4(s0)
	la s2, p
	sw s1, 0(s2)
	lw s1, -8(s0)
	la s2, line
	sw s1, 0(s2)
	la s1, p
	lw s2, 0(s1)
	la s1, line_start
	sw s2, 0(s1)
	j .L7_9
.L7_17:
.L7_41:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	bnez s1, .L7_42
	j .L7_43
.L7_42:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_44
	j .L7_43
.L7_44:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L7_41
.L7_43:
	j .L7_9
.L7_11:
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_45
	j .L7_46
.L7_45:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_47
	j .L7_46
.L7_47:
.L7_48:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	bnez s1, .L7_49
	j .L7_50
.L7_49:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_51
	j .L7_50
.L7_51:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L7_48
.L7_50:
	j .L7_9
.L7_46:
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_52
	j .L7_53
.L7_52:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_54
	j .L7_53
.L7_54:
	la s1, p
	lw s2, 0(s1)
	li s3, 2
	add s4, s2, s3
	sw s4, 0(s1)
.L7_55:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	bnez s1, .L7_56
	j .L7_57
.L7_56:
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_58
	j .L7_59
.L7_58:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_57
	j .L7_59
.L7_59:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_60
	j .L7_61
.L7_60:
	la s1, line
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	la s1, line_start
	sw s3, 0(s1)
.L7_61:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L7_55
.L7_57:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	bnez s1, .L7_62
	j .L7_63
.L7_62:
	la s1, p
	lw s2, 0(s1)
	li s3, 2
	add s4, s2, s3
	sw s4, 0(s1)
.L7_63:
	j .L7_9
.L7_53:
	j .L7_64
.L7_9:
	j .L7_0
.L7_64:
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
.Lfunc_end7:
	.size skip_ws, .Lfunc_end7-skip_ws

	.text
	.align 2
	.type is_ident_start, @function
is_ident_start:
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
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isalpha
	mv s1, a0
	bnez s1, .L8_0
	j .L8_1
.L8_1:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
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
	.size is_ident_start, .Lfunc_end8-is_ident_start

	.text
	.align 2
	.type is_ident_char, @function
is_ident_char:
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
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isalnum
	mv s1, a0
	bnez s1, .L9_0
	j .L9_1
.L9_1:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_0
	j .L9_2
.L9_0:
	li s1, 1
	j .L9_3
.L9_2:
	li s1, 0
.L9_3:
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
	.size is_ident_char, .Lfunc_end9-is_ident_char

	.text
	.align 2
	.type parse_int_literal, @function
parse_int_literal:
	addi sp, sp, -256
	sw ra, 252(sp)
	sw s0, 248(sp)
	addi s0, sp, 248
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
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -24(s0)
	sw s11, -20(s0)
	li s1, 10
	sw s1, -28(s0)
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_2
	j .L10_3
.L10_3:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_2
	j .L10_1
.L10_2:
	li s1, 16
	sw s1, -28(s0)
	la s1, p
	lw s2, 0(s1)
	li s3, 2
	add s4, s2, s3
	sw s4, 0(s1)
.L10_4:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isxdigit
	mv s1, a0
	bnez s1, .L10_5
	j .L10_6
.L10_5:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 97
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_7
	j .L10_8
.L10_7:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 97
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -36(s0)
	j .L10_9
.L10_8:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 65
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_10
	j .L10_11
.L10_10:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 65
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -40(s0)
	j .L10_12
.L10_11:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 48
	sub s3, s1, s2
	sw s3, -40(s0)
.L10_12:
	lw s1, -40(s0)
	sw s1, -36(s0)
.L10_9:
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 16
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
	lw s1, -32(s0)
	mv s10, s1
	srai s11, s10, 31
	add s8, s6, s10
	sltu t0, s8, s10
	add s9, s7, t0
	add s9, s9, s11
	sw s8, -24(s0)
	sw s9, -20(s0)
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L10_4
.L10_6:
	j .L10_13
.L10_1:
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_14
	j .L10_15
.L10_14:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isdigit
	mv s1, a0
	bnez s1, .L10_16
	j .L10_15
.L10_16:
	li s1, 8
	sw s1, -28(s0)
.L10_17:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_18
	j .L10_19
.L10_18:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 55
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L10_20
	j .L10_19
.L10_20:
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 8
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
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 48
	sub s3, s1, s2
	mv s10, s3
	srai s11, s10, 31
	add s8, s6, s10
	sltu t0, s8, s10
	add s9, s7, t0
	add s9, s9, s11
	sw s8, -24(s0)
	sw s9, -20(s0)
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L10_17
.L10_19:
	j .L10_21
.L10_15:
.L10_22:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isdigit
	mv s1, a0
	bnez s1, .L10_23
	j .L10_24
.L10_23:
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 10
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
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 48
	sub s3, s1, s2
	mv s10, s3
	srai s11, s10, 31
	add s8, s6, s10
	sltu t0, s8, s10
	add s9, s7, t0
	add s9, s9, s11
	sw s8, -24(s0)
	sw s9, -20(s0)
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L10_22
.L10_24:
.L10_21:
.L10_13:
	li s1, 0
	sw s1, -44(s0)
	li s1, 0
	sw s1, -48(s0)
.L10_25:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 117
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_26
	j .L10_27
.L10_27:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 85
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_26
	j .L10_28
.L10_28:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 108
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_26
	j .L10_29
.L10_29:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 76
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_26
	j .L10_30
.L10_26:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 108
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_31
	j .L10_32
.L10_32:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 76
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_31
	j .L10_33
.L10_31:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L10_34
.L10_33:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
.L10_34:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L10_25
.L10_30:
	li s10, 2147483647
	li s11, 0
	sw s10, -56(s0)
	sw s11, -52(s0)
	li s10, -1
	li s11, 0
	sw s10, -64(s0)
	sw s11, -60(s0)
	li s1, 4
	li s2, 8
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_35
	j .L10_36
.L10_35:
	li s10, -1
	li s11, 2147483647
	sw s10, -80(s0)
	sw s11, -76(s0)
	j .L10_37
.L10_36:
	lw s10, -56(s0)
	lw s11, -52(s0)
	sw s10, -80(s0)
	sw s11, -76(s0)
.L10_37:
	lw s10, -80(s0)
	lw s11, -76(s0)
	sw s10, -72(s0)
	sw s11, -68(s0)
	li s1, 4
	li s2, 8
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_38
	j .L10_39
.L10_38:
	li s10, -1
	li s11, -1
	sw s10, -96(s0)
	sw s11, -92(s0)
	j .L10_40
.L10_39:
	lw s10, -64(s0)
	lw s11, -60(s0)
	sw s10, -96(s0)
	sw s11, -92(s0)
.L10_40:
	lw s10, -96(s0)
	lw s11, -92(s0)
	sw s10, -88(s0)
	sw s11, -84(s0)
	li s10, -1
	li s11, 2147483647
	sw s10, -104(s0)
	sw s11, -100(s0)
	lw s1, -48(s0)
	li s2, 0
	slt s3, s2, s1
	sw s3, -108(s0)
	lw s1, -108(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -112(s0)
	lw s1, -108(s0)
	bnez s1, .L10_41
	j .L10_42
.L10_42:
	lw s1, -28(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L10_41
	j .L10_43
.L10_41:
	li s1, 1
	j .L10_44
.L10_43:
	li s1, 0
.L10_44:
	sw s1, -116(s0)
	lw s1, -44(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_45
	j .L10_46
.L10_45:
	li s1, 2
	sw s1, -124(s0)
	j .L10_47
.L10_46:
	lw s1, -44(s0)
	li s2, 1
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_48
	j .L10_49
.L10_48:
	li s1, 1
	sw s1, -128(s0)
	j .L10_50
.L10_49:
	li s1, 0
	sw s1, -128(s0)
.L10_50:
	lw s1, -128(s0)
	sw s1, -124(s0)
.L10_47:
	lw s1, -124(s0)
	sw s1, -120(s0)
	li s1, 1
	neg s2, s1
	sw s2, -136(s0)
	li s1, 0
	sw s1, -140(s0)
	lw s1, -120(s0)
	sw s1, -132(s0)
.L10_51:
	lw s1, -132(s0)
	li s2, 2
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L10_52
	j .L10_53
.L10_52:
	lw s1, -136(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L10_54
	j .L10_53
.L10_54:
	lw s1, -132(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_55
	j .L10_56
.L10_55:
	lw s10, -56(s0)
	lw s11, -52(s0)
	sw s10, -160(s0)
	sw s11, -156(s0)
	j .L10_57
.L10_56:
	lw s1, -132(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_58
	j .L10_59
.L10_58:
	lw s10, -72(s0)
	lw s11, -68(s0)
	sw s10, -168(s0)
	sw s11, -164(s0)
	j .L10_60
.L10_59:
	lw s10, -104(s0)
	lw s11, -100(s0)
	sw s10, -168(s0)
	sw s11, -164(s0)
.L10_60:
	lw s10, -168(s0)
	lw s11, -164(s0)
	sw s10, -160(s0)
	sw s11, -156(s0)
.L10_57:
	lw s10, -160(s0)
	lw s11, -156(s0)
	sw s10, -152(s0)
	sw s11, -148(s0)
	lw s1, -132(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_61
	j .L10_62
.L10_61:
	lw s10, -64(s0)
	lw s11, -60(s0)
	sw s10, -184(s0)
	sw s11, -180(s0)
	j .L10_63
.L10_62:
	lw s1, -132(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_64
	j .L10_65
.L10_64:
	lw s10, -88(s0)
	lw s11, -84(s0)
	sw s10, -192(s0)
	sw s11, -188(s0)
	j .L10_66
.L10_65:
	li s10, -1
	li s11, -1
	sw s10, -192(s0)
	sw s11, -188(s0)
.L10_66:
	lw s10, -192(s0)
	lw s11, -188(s0)
	sw s10, -184(s0)
	sw s11, -180(s0)
.L10_63:
	lw s10, -184(s0)
	lw s11, -180(s0)
	sw s10, -176(s0)
	sw s11, -172(s0)
	lw s1, -112(s0)
	bnez s1, .L10_67
	j .L10_68
.L10_67:
	lw s10, -24(s0)
	lw s11, -20(s0)
	lw s8, -152(s0)
	lw s9, -148(s0)
	sltu s1, s9, s11
	bne s9, s11, .L10_69
	sltu s1, s8, s10
.L10_69:
	xori s1, s1, 1
	bnez s1, .L10_70
	j .L10_68
.L10_70:
	lw s1, -132(s0)
	sw s1, -136(s0)
	li s1, 0
	sw s1, -140(s0)
	j .L10_71
.L10_68:
	lw s1, -116(s0)
	bnez s1, .L10_72
	j .L10_73
.L10_72:
	lw s10, -24(s0)
	lw s11, -20(s0)
	lw s8, -176(s0)
	lw s9, -172(s0)
	sltu s1, s9, s11
	bne s9, s11, .L10_74
	sltu s1, s8, s10
.L10_74:
	xori s1, s1, 1
	bnez s1, .L10_75
	j .L10_73
.L10_75:
	lw s1, -132(s0)
	sw s1, -136(s0)
	li s1, 1
	sw s1, -140(s0)
.L10_73:
.L10_71:
.L10_76:
	addi s1, s0, -132
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -132(s0)
	j .L10_51
.L10_53:
	lw s1, -136(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L10_77
	j .L10_78
.L10_77:
	li s1, 2
	sw s1, -136(s0)
	li s1, 1
	sw s1, -140(s0)
.L10_78:
	lw s1, -4(s0)
	bnez s1, .L10_79
	j .L10_80
.L10_79:
	lw s1, -136(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	lw s1, -4(s0)
	sw s3, 0(s1)
.L10_80:
	lw s1, -8(s0)
	bnez s1, .L10_81
	j .L10_82
.L10_81:
	lw s1, -136(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	lw s1, -8(s0)
	sw s3, 0(s1)
.L10_82:
	lw s1, -12(s0)
	bnez s1, .L10_83
	j .L10_84
.L10_83:
	lw s1, -140(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
.L10_84:
	lw s10, -24(s0)
	lw s11, -20(s0)
	mv a0, s10
	mv a1, s11
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end10:
	.size parse_int_literal, .Lfunc_end10-parse_int_literal

	.text
	.align 2
	.type parse_escape, @function
parse_escape:
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
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
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
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lb s1, 0(s2)
	li s2, 97
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_2
	li s2, 98
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_3
	li s2, 102
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_4
	li s2, 110
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_5
	li s2, 114
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_6
	li s2, 116
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_7
	li s2, 118
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_8
	li s2, 92
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_9
	li s2, 39
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_10
	li s2, 34
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_11
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_12
	li s2, 49
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_13
	li s2, 50
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_14
	li s2, 51
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_15
	li s2, 52
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_16
	li s2, 53
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_17
	li s2, 54
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_18
	li s2, 55
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_19
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_20
	j .L11_21
.L11_2:
	li s1, 7
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
.L11_3:
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
.L11_4:
	li s1, 12
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
.L11_5:
	li s1, 10
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
.L11_6:
	li s1, 13
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
.L11_7:
	li s1, 9
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
.L11_8:
	li s1, 11
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
.L11_9:
	li s1, 92
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
.L11_10:
	li s1, 39
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
.L11_11:
	li s1, 34
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
.L11_12:
.L11_13:
.L11_14:
.L11_15:
.L11_16:
.L11_17:
.L11_18:
.L11_19:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	neg s3, s1
	add s1, s2, s3
	lb s2, 0(s1)
	li s1, 48
	sub s3, s2, s1
	sw s3, -4(s0)
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_22
	j .L11_23
.L11_22:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 55
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L11_24
	j .L11_23
.L11_24:
	lw s1, -4(s0)
	li s2, 8
	mul s3, s1, s2
	la s1, p
	lw s2, 0(s1)
	li s4, 1
	add s5, s2, s4
	sw s5, 0(s1)
	lb s1, 0(s2)
	add s2, s3, s1
	li s1, 48
	sub s3, s2, s1
	sw s3, -4(s0)
.L11_23:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_25
	j .L11_26
.L11_25:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 55
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L11_27
	j .L11_26
.L11_27:
	lw s1, -4(s0)
	li s2, 8
	mul s3, s1, s2
	la s1, p
	lw s2, 0(s1)
	li s4, 1
	add s5, s2, s4
	sw s5, 0(s1)
	lb s1, 0(s2)
	add s2, s3, s1
	li s1, 48
	sub s3, s2, s1
	sw s3, -4(s0)
.L11_26:
	lw s1, -4(s0)
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
.L11_20:
	li s1, 0
	sw s1, -8(s0)
.L11_28:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isxdigit
	mv s1, a0
	bnez s1, .L11_29
	j .L11_30
.L11_29:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 97
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_31
	j .L11_32
.L11_31:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 97
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -16(s0)
	j .L11_33
.L11_32:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 65
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_34
	j .L11_35
.L11_34:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 65
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -20(s0)
	j .L11_36
.L11_35:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 48
	sub s3, s1, s2
	sw s3, -20(s0)
.L11_36:
	lw s1, -20(s0)
	sw s1, -16(s0)
.L11_33:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -8(s0)
	li s2, 16
	mul s3, s1, s2
	lw s1, -12(s0)
	add s2, s3, s1
	sw s2, -8(s0)
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L11_28
.L11_30:
	lw s1, -8(s0)
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
.L11_21:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	neg s3, s1
	add s1, s2, s3
	lb s2, 0(s1)
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
.L11_37:
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
	.size parse_escape, .Lfunc_end11-parse_escape

	.text
	.align 2
	.type lex_token, @function
lex_token:
	li t6, -4352
	add sp, sp, t6
	li t6, 4348
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 4344
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 4344
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
	fsd fs0, 56(sp)
	sw a0, -4(s0)
	addi s1, s0, -72
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
	li s2, 0
	sw s2, 0(s1)
	jal ra, skip_ws
	mv s1, a0
	la s1, line
	lw s2, 0(s1)
	addi s1, s0, -72
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	la s1, p
	lw s2, 0(s1)
	la s1, line_start
	lw s3, 0(s1)
	sub s1, s2, s3
	li s2, 1
	add s3, s1, s2
	addi s1, s0, -72
	li s2, 36
	add s4, s1, s2
	sw s3, 0(s4)
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_0
	j .L12_1
.L12_0:
	li s1, 0
	addi s2, s0, -72
	sw s1, 0(s2)
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_1:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	mv a0, s1
	jal ra, is_ident_start
	mv s2, a0
	bnez s2, .L12_2
	j .L12_3
.L12_2:
	la s1, p
	lw s2, 0(s1)
	sw s2, -76(s0)
.L12_4:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	mv a0, s1
	jal ra, is_ident_char
	mv s2, a0
	bnez s2, .L12_5
	j .L12_6
.L12_5:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L12_4
.L12_6:
	la s1, p
	lw s2, 0(s1)
	lw s1, -76(s0)
	sub s3, s2, s1
	sw s3, -80(s0)
	la s1, keywords
	sw s1, -84(s0)
.L12_7:
	lw s1, -84(s0)
	lw s2, 0(s1)
	bnez s2, .L12_8
	j .L12_9
.L12_8:
	lw s1, -84(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	lw s2, -80(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_10
	j .L12_11
.L12_10:
	lw s1, -84(s0)
	lw s2, 0(s1)
	lw s1, -76(s0)
	lw s3, -80(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L12_12
	j .L12_11
.L12_12:
	lw s1, -84(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -72
	sw s1, 0(s2)
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_11:
.L12_13:
	addi s1, s0, -84
	lw s2, 0(s1)
	li s1, 8
	add s3, s2, s1
	sw s3, -84(s0)
	j .L12_7
.L12_9:
	lw s1, -80(s0)
	li s2, 13
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_14
	j .L12_15
.L12_14:
	lw s1, -76(s0)
	la s2, __str_72
	li s3, 13
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L12_16
	j .L12_15
.L12_16:
	jal ra, skip_ws
	mv s1, a0
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_17
	j .L12_18
.L12_17:
	li s1, 0
	sw s1, -88(s0)
.L12_19:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_20
	j .L12_21
.L12_20:
	addi s1, s0, -88
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -88(s0)
	j .L12_22
.L12_21:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 41
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_23
	j .L12_24
.L12_23:
	addi s1, s0, -88
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -88(s0)
	j .L12_25
.L12_24:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_26
	j .L12_27
.L12_26:
	la s1, line
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L12_27:
.L12_25:
.L12_22:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L12_28:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	bnez s1, .L12_29
	j .L12_30
.L12_29:
	lw s1, -88(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L12_19
	j .L12_30
.L12_30:
.L12_18:
	addi s1, s0, -152
	mv a0, s1
	jal ra, lex_token
	mv s2, a0
	addi s1, s0, -152
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_15:
	li s1, 5
	addi s2, s0, -72
	sw s1, 0(s2)
	la s1, lex_arena
	lw s2, 0(s1)
	lw s1, -76(s0)
	lw s3, -80(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	addi s1, s0, -72
	li s2, 24
	add s3, s1, s2
	sw s4, 0(s3)
	lw s1, -80(s0)
	addi s2, s0, -72
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_3:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isdigit
	mv s1, a0
	bnez s1, .L12_31
	j .L12_32
.L12_32:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_33
	j .L12_34
.L12_33:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isdigit
	mv s1, a0
	bnez s1, .L12_31
	j .L12_34
.L12_31:
	la s1, p
	lw s2, 0(s1)
	sw s2, -156(s0)
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -160(s0)
	lw s1, -160(s0)
	bnez s1, .L12_35
	j .L12_36
.L12_36:
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_37
	j .L12_38
.L12_37:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_39
	j .L12_40
.L12_40:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_39
	j .L12_38
.L12_39:
	la s1, p
	lw s2, 0(s1)
	li s3, 2
	add s4, s2, s3
	sw s4, 0(s1)
.L12_41:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isxdigit
	mv s1, a0
	bnez s1, .L12_42
	j .L12_43
.L12_42:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L12_41
.L12_43:
	j .L12_44
.L12_38:
.L12_45:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isdigit
	mv s1, a0
	bnez s1, .L12_46
	j .L12_47
.L12_46:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L12_45
.L12_47:
.L12_44:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_48
	j .L12_49
.L12_49:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 101
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_48
	j .L12_50
.L12_50:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_48
	j .L12_51
.L12_48:
	li s1, 1
	sw s1, -160(s0)
.L12_51:
.L12_35:
	lw s1, -156(s0)
	la s2, p
	sw s1, 0(s2)
	lw s1, -160(s0)
	bnez s1, .L12_52
	j .L12_53
.L12_52:
	li s1, 2
	addi s2, s0, -72
	sw s1, 0(s2)
	la s1, p
	lw s2, 0(s1)
	la s1, p
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	jal ra, strtod
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi s1, s0, -72
	li s2, 16
	add s3, s1, s2
	fsd fs0, 0(s3)
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 102
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_54
	j .L12_55
.L12_55:
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_54
	j .L12_56
.L12_54:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 49
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_57
	j .L12_56
.L12_57:
	la s1, p
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 54
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_58
	j .L12_56
.L12_58:
	li s1, 1
	addi s2, s0, -72
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, p
	lw s2, 0(s1)
	li s3, 3
	add s4, s2, s3
	sw s4, 0(s1)
	j .L12_59
.L12_56:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 102
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_60
	j .L12_61
.L12_61:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_60
	j .L12_62
.L12_60:
	li s1, 1
	addi s2, s0, -72
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	j .L12_63
.L12_62:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 108
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_64
	j .L12_65
.L12_65:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 76
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_64
	j .L12_66
.L12_64:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L12_66:
.L12_63:
.L12_59:
	j .L12_67
.L12_53:
	li s1, 1
	addi s2, s0, -72
	sw s1, 0(s2)
	addi s1, s0, -72
	li s2, 48
	add s3, s1, s2
	addi s1, s0, -72
	li s2, 52
	add s4, s1, s2
	addi s1, s0, -72
	li s2, 56
	add s5, s1, s2
	mv a0, s3
	mv a1, s4
	mv a2, s5
	jal ra, parse_int_literal
	mv s10, a0
	mv s11, a1
	addi s1, s0, -72
	li s2, 8
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
.L12_67:
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_34:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 39
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_68
	j .L12_69
.L12_68:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_70
	j .L12_71
.L12_70:
	li s1, 4
	addi s2, s0, -72
	sw s1, 0(s2)
	li s1, 0
	addi s2, s0, -72
	li s3, 8
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_71:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 92
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_72
	j .L12_73
.L12_72:
	jal ra, parse_escape
	mv s1, a0
	addi s2, s0, -72
	li s3, 8
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	j .L12_74
.L12_73:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	addi s1, s0, -72
	li s2, 8
	add s4, s1, s2
	mv s10, s3
	li s11, 0
	sw s10, 0(s4)
	sw s11, 4(s4)
.L12_74:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 39
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_75
	j .L12_76
.L12_75:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L12_76:
	li s1, 4
	addi s2, s0, -72
	sw s1, 0(s2)
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_69:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 34
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_77
	j .L12_78
.L12_77:
	li s1, 0
	li t6, -4260
	add t6, s0, t6
	sw s1, 0(t6)
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L12_79:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	bnez s1, .L12_80
	j .L12_81
.L12_80:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 34
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_82
	j .L12_81
.L12_82:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 92
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_83
	j .L12_84
.L12_83:
	jal ra, parse_escape
	mv s1, a0
	li t6, -4264
	add t6, s0, t6
	sw s1, 0(t6)
	j .L12_85
.L12_84:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	li t6, -4264
	add t6, s0, t6
	sw s3, 0(t6)
.L12_85:
	li t6, -4260
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4096
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L12_86
	j .L12_87
.L12_86:
	li t6, -4264
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li t6, -4256
	add s1, s0, t6
	li t6, -4260
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4260
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s1, s4
	sb s2, 0(s3)
.L12_87:
	j .L12_79
.L12_81:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 34
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_88
	j .L12_89
.L12_88:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L12_89:
.L12_90:
	j .L12_91
.L12_91:
	la s1, p
	lw s2, 0(s1)
	li t6, -4268
	add t6, s0, t6
	sw s2, 0(t6)
	la s1, line
	lw s2, 0(s1)
	li t6, -4272
	add t6, s0, t6
	sw s2, 0(t6)
	jal ra, skip_ws
	mv s1, a0
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 34
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_92
	j .L12_93
.L12_92:
	li t6, -4268
	add t6, s0, t6
	lw s1, 0(t6)
	la s2, p
	sw s1, 0(s2)
	li t6, -4272
	add t6, s0, t6
	lw s1, 0(t6)
	la s2, line
	sw s1, 0(s2)
	j .L12_94
.L12_93:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L12_95:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	bnez s1, .L12_96
	j .L12_97
.L12_96:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 34
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_98
	j .L12_97
.L12_98:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 92
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_99
	j .L12_100
.L12_99:
	jal ra, parse_escape
	mv s1, a0
	li t6, -4276
	add t6, s0, t6
	sw s1, 0(t6)
	j .L12_101
.L12_100:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	li t6, -4276
	add t6, s0, t6
	sw s3, 0(t6)
.L12_101:
	li t6, -4260
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4096
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L12_102
	j .L12_103
.L12_102:
	li t6, -4276
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li t6, -4256
	add s1, s0, t6
	li t6, -4260
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4260
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s1, s4
	sb s2, 0(s3)
.L12_103:
	j .L12_95
.L12_97:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 34
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_104
	j .L12_105
.L12_104:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L12_105:
.L12_106:
	j .L12_90
.L12_94:
	li s1, 0
	li t6, -4256
	add s2, s0, t6
	li t6, -4260
	add t6, s0, t6
	lw s3, 0(t6)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 3
	addi s2, s0, -72
	sw s1, 0(s2)
	la s1, lex_arena
	lw s2, 0(s1)
	li t6, -4256
	add s1, s0, t6
	li t6, -4260
	add t6, s0, t6
	lw s3, 0(t6)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	addi s1, s0, -72
	li s2, 24
	add s3, s1, s2
	sw s4, 0(s3)
	li t6, -4260
	add t6, s0, t6
	lw s1, 0(t6)
	addi s2, s0, -72
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_78:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lb s1, 0(s2)
	li t6, -4280
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -4280
	add s1, s0, t6
	lb s2, 0(s1)
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_107
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_108
	li s1, 123
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_109
	li s1, 125
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_110
	li s1, 91
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_111
	li s1, 93
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_112
	li s1, 59
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_113
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_114
	li s1, 126
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_115
	li s1, 63
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_116
	li s1, 58
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_117
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_118
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_119
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_120
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_121
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_122
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_123
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_124
	li s1, 124
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_125
	li s1, 94
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_126
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_127
	li s1, 33
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_128
	li s1, 60
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_129
	li s1, 62
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_130
	j .L12_131
.L12_107:
	li s1, 47
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_108:
	li s1, 48
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_109:
	li s1, 49
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_110:
	li s1, 50
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_111:
	li s1, 51
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_112:
	li s1, 52
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_113:
	li s1, 53
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_114:
	li s1, 54
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_115:
	li s1, 77
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_116:
	li s1, 91
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_117:
	li s1, 92
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_132
.L12_118:
	la s1, p
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_133
	j .L12_134
.L12_133:
	la s1, p
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_135
	j .L12_134
.L12_135:
	la s1, p
	lw s2, 0(s1)
	li s3, 2
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 57
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_136
.L12_134:
	li s1, 55
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_136:
	j .L12_132
.L12_119:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 43
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_137
	j .L12_138
.L12_137:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 89
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_139
.L12_138:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_140
	j .L12_141
.L12_140:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 59
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_142
.L12_141:
	li s1, 69
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_142:
.L12_139:
	j .L12_132
.L12_120:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_143
	j .L12_144
.L12_143:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 90
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_145
.L12_144:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 62
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_146
	j .L12_147
.L12_146:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 56
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_148
.L12_147:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_149
	j .L12_150
.L12_149:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 60
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_151
.L12_150:
	li s1, 70
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_151:
.L12_148:
.L12_145:
	j .L12_132
.L12_121:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_152
	j .L12_153
.L12_152:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 61
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_154
.L12_153:
	li s1, 71
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_154:
	j .L12_132
.L12_122:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_155
	j .L12_156
.L12_155:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 62
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_157
.L12_156:
	li s1, 72
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_157:
	j .L12_132
.L12_123:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_158
	j .L12_159
.L12_158:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 63
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_160
.L12_159:
	li s1, 73
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_160:
	j .L12_132
.L12_124:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 38
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_161
	j .L12_162
.L12_161:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 79
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_163
.L12_162:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_164
	j .L12_165
.L12_164:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 64
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_166
.L12_165:
	li s1, 74
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_166:
.L12_163:
	j .L12_132
.L12_125:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 124
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_167
	j .L12_168
.L12_167:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 80
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_169
.L12_168:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_170
	j .L12_171
.L12_170:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 65
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_172
.L12_171:
	li s1, 75
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_172:
.L12_169:
	j .L12_132
.L12_126:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_173
	j .L12_174
.L12_173:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 66
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_175
.L12_174:
	li s1, 76
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_175:
	j .L12_132
.L12_127:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_176
	j .L12_177
.L12_176:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 81
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_178
.L12_177:
	li s1, 58
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_178:
	j .L12_132
.L12_128:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_179
	j .L12_180
.L12_179:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 82
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_181
.L12_180:
	li s1, 78
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_181:
	j .L12_132
.L12_129:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 60
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_182
	j .L12_183
.L12_182:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_184
	j .L12_185
.L12_184:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 67
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_186
.L12_185:
	li s1, 87
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_186:
	j .L12_187
.L12_183:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_188
	j .L12_189
.L12_188:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 84
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_190
.L12_189:
	li s1, 83
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_190:
.L12_187:
	j .L12_132
.L12_130:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 62
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_191
	j .L12_192
.L12_191:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_193
	j .L12_194
.L12_193:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 68
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_195
.L12_194:
	li s1, 88
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_195:
	j .L12_196
.L12_192:
	la s1, p
	lw s2, 0(s1)
	lb s1, 0(s2)
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_197
	j .L12_198
.L12_197:
	la s1, p
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 86
	addi s2, s0, -72
	sw s1, 0(s2)
	j .L12_199
.L12_198:
	li s1, 85
	addi s2, s0, -72
	sw s1, 0(s2)
.L12_199:
.L12_196:
	j .L12_132
.L12_131:
	la s1, __str_73
	li t6, -4280
	add s2, s0, t6
	lb s3, 0(s2)
	li t6, -4280
	add s2, s0, t6
	lb s4, 0(s2)
	li s2, 255
	and s5, s4, s2
	la s2, line
	lw s4, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s4, 8(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L12_132:
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	li t6, -4332
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4328
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4324
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4320
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4316
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4312
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4308
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4304
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4300
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4296
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4292
	add t6, s0, t6
	lw s11, 0(t6)
	li t6, -4288
	add t6, s0, t6
	fld fs0, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end12:
	.size lex_token, .Lfunc_end12-lex_token

	.text
	.align 2
	.globl cc_lex_next
	.type cc_lex_next, @function
cc_lex_next:
	addi sp, sp, -192
	sw ra, 188(sp)
	sw s0, 184(sp)
	addi s0, sp, 184
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
	la s1, peeked
	lw s2, 0(s1)
	bnez s2, .L13_0
	j .L13_1
.L13_0:
	li s1, 0
	la s2, peeked
	sw s1, 0(s2)
	la s1, peek_tok
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, cur_tok_col
	sw s1, 0(s2)
	la s1, peek_tok
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	lw s1, -180(s0)
	lw s2, -176(s0)
	lw s3, -172(s0)
	lw s4, -168(s0)
	lw s5, -164(s0)
	lw s6, -160(s0)
	lw s7, -156(s0)
	lw s8, -152(s0)
	lw s9, -148(s0)
	lw s10, -144(s0)
	lw s11, -140(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_1:
	addi s1, s0, -136
	mv a0, s1
	jal ra, lex_token
	mv s2, a0
	addi s1, s0, -136
	addi s2, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, cur_tok_col
	sw s1, 0(s2)
	addi s1, s0, -72
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	lw s1, -180(s0)
	lw s2, -176(s0)
	lw s3, -172(s0)
	lw s4, -168(s0)
	lw s5, -164(s0)
	lw s6, -160(s0)
	lw s7, -156(s0)
	lw s8, -152(s0)
	lw s9, -148(s0)
	lw s10, -144(s0)
	lw s11, -140(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end13:
	.size cc_lex_next, .Lfunc_end13-cc_lex_next

	.text
	.align 2
	.globl cc_lex_peek
	.type cc_lex_peek, @function
cc_lex_peek:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	la s1, peeked
	lw s2, 0(s1)
	bnez s2, .L14_0
	j .L14_1
.L14_1:
	addi s1, s0, -72
	mv a0, s1
	jal ra, lex_token
	mv s2, a0
	addi s1, s0, -72
	la s2, peek_tok
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	la s2, peeked
	sw s1, 0(s2)
.L14_0:
	la s1, peek_tok
	lw s2, -4(s0)
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end14:
	.size cc_lex_peek, .Lfunc_end14-cc_lex_peek

	.data
	.align 2
__str_73:
	.ascii "unexpected character '%c' (0x%02x) at line %d\000"
	.align 2
__str_72:
	.ascii "__attribute__\000"
	.align 2
__str_71:
	.ascii "  %5d | %.*s\n\000"
	.align 2
__str_70:
	.ascii "':'\000"
	.align 2
__str_69:
	.ascii "'?'\000"
	.align 2
__str_68:
	.ascii "'='\000"
	.align 2
__str_67:
	.ascii "'...'\000"
	.align 2
__str_66:
	.ascii "'->'\000"
	.align 2
__str_65:
	.ascii "'.'\000"
	.align 2
__str_64:
	.ascii "','\000"
	.align 2
__str_63:
	.ascii "';'\000"
	.align 2
__str_62:
	.ascii "']'\000"
	.align 2
__str_61:
	.ascii "'['\000"
	.align 2
__str_60:
	.ascii "'}'\000"
	.align 2
__str_59:
	.ascii "'{'\000"
	.align 2
__str_58:
	.ascii "')'\000"
	.align 2
__str_57:
	.ascii "'('\000"
	.align 2
__str_56:
	.ascii "identifier\000"
	.align 2
__str_55:
	.ascii "character literal\000"
	.align 2
__str_54:
	.ascii "string literal\000"
	.align 2
__str_53:
	.ascii "floating literal\000"
	.align 2
__str_52:
	.ascii "integer literal\000"
	.align 2
__str_51:
	.ascii "end of file\000"
	.align 2
__str_50:
	.ascii "<input>\000"
	.align 2
__str_49:
	.ascii "while\000"
	.align 2
__str_48:
	.ascii "volatile\000"
	.align 2
__str_47:
	.ascii "void\000"
	.align 2
__str_46:
	.ascii "unsigned\000"
	.align 2
__str_45:
	.ascii "union\000"
	.align 2
__str_44:
	.ascii "typedef\000"
	.align 2
__str_43:
	.ascii "switch\000"
	.align 2
__str_42:
	.ascii "struct\000"
	.align 2
__str_41:
	.ascii "static\000"
	.align 2
__str_40:
	.ascii "_Generic\000"
	.align 2
__str_39:
	.ascii "static_assert\000"
	.align 2
__str_38:
	.ascii "_Static_assert\000"
	.align 2
__str_37:
	.ascii "alignas\000"
	.align 2
__str_36:
	.ascii "_Alignas\000"
	.align 2
__str_35:
	.ascii "alignof\000"
	.align 2
__str_34:
	.ascii "_Alignof\000"
	.align 2
__str_33:
	.ascii "sizeof\000"
	.align 2
__str_32:
	.ascii "signed\000"
	.align 2
__str_31:
	.ascii "short\000"
	.align 2
__str_30:
	.ascii "return\000"
	.align 2
__str_29:
	.ascii "register\000"
	.align 2
__str_28:
	.ascii "__restrict__\000"
	.align 2
__str_27:
	.ascii "__restrict\000"
	.align 2
__str_26:
	.ascii "restrict\000"
	.align 2
__str_25:
	.ascii "long\000"
	.align 2
__str_24:
	.ascii "int\000"
	.align 2
__str_23:
	.ascii "__inline__\000"
	.align 2
__str_22:
	.ascii "__inline\000"
	.align 2
__str_21:
	.ascii "inline\000"
	.align 2
__str_20:
	.ascii "if\000"
	.align 2
__str_19:
	.ascii "goto\000"
	.align 2
__str_18:
	.ascii "for\000"
	.align 2
__str_17:
	.ascii "float\000"
	.align 2
__str_16:
	.ascii "extern\000"
	.align 2
__str_15:
	.ascii "enum\000"
	.align 2
__str_14:
	.ascii "else\000"
	.align 2
__str_13:
	.ascii "double\000"
	.align 2
__str_12:
	.ascii "do\000"
	.align 2
__str_11:
	.ascii "default\000"
	.align 2
__str_10:
	.ascii "continue\000"
	.align 2
__str_9:
	.ascii "const\000"
	.align 2
__str_8:
	.ascii "char\000"
	.align 2
__str_7:
	.ascii "case\000"
	.align 2
__str_6:
	.ascii "break\000"
	.align 2
__str_5:
	.ascii "auto\000"
	.align 2
__str_4:
	.ascii "__asm__\000"
	.align 2
__str_3:
	.ascii "__asm\000"
	.align 2
__str_2:
	.ascii "asm\000"
	.align 2
__str_1:
	.ascii "_Float16\000"
	.align 2
__str_0:
	.ascii "_Bool\000"

	.section .rodata
	.align 2
	.globl keywords
keywords:
	.word __str_0
	.word 0x00000007
	.word __str_1
	.word 0x0000000c
	.word __str_2
	.word 0x0000002e
	.word __str_3
	.word 0x0000002e
	.word __str_4
	.word 0x0000002e
	.word __str_5
	.word 0x0000001b
	.word __str_6
	.word 0x00000025
	.word __str_7
	.word 0x00000023
	.word __str_8
	.word 0x00000008
	.word __str_9
	.word 0x00000015
	.word __str_10
	.word 0x00000026
	.word __str_11
	.word 0x00000024
	.word __str_12
	.word 0x00000020
	.word __str_13
	.word 0x0000000e
	.word __str_14
	.word 0x0000001e
	.word __str_15
	.word 0x00000013
	.word __str_16
	.word 0x00000019
	.word __str_17
	.word 0x0000000d
	.word __str_18
	.word 0x00000021
	.word __str_19
	.word 0x00000028
	.word __str_20
	.word 0x0000001d
	.word __str_21
	.word 0x00000018
	.word __str_22
	.word 0x00000018
	.word __str_23
	.word 0x00000018
	.word __str_24
	.word 0x0000000a
	.word __str_25
	.word 0x0000000b
	.word __str_26
	.word 0x00000017
	.word __str_27
	.word 0x00000017
	.word __str_28
	.word 0x00000017
	.word __str_29
	.word 0x0000001c
	.word __str_30
	.word 0x00000027
	.word __str_31
	.word 0x00000009
	.word __str_32
	.word 0x0000000f
	.word __str_33
	.word 0x00000029
	.word __str_34
	.word 0x0000002a
	.word __str_35
	.word 0x0000002a
	.word __str_36
	.word 0x0000002b
	.word __str_37
	.word 0x0000002b
	.word __str_38
	.word 0x0000002c
	.word __str_39
	.word 0x0000002c
	.word __str_40
	.word 0x0000002d
	.word __str_41
	.word 0x0000001a
	.word __str_42
	.word 0x00000011
	.word __str_43
	.word 0x00000022
	.word __str_44
	.word 0x00000014
	.word __str_45
	.word 0x00000012
	.word __str_46
	.word 0x00000010
	.word __str_47
	.word 0x00000006
	.word __str_48
	.word 0x00000016
	.word __str_49
	.word 0x0000001f
	.word 0x00000000
	.word 0x00000000

	.bss
	.align 3
	.globl peek_tok
peek_tok:
	.space 64
	.align 2
	.globl peeked
peeked:
	.space 4
	.align 2
	.globl cur_tok_col
cur_tok_col:
	.space 4
	.align 2
	.globl line_start
line_start:
	.space 4
	.align 2
	.globl line
line:
	.space 4
	.align 2
	.globl p
p:
	.space 4
	.align 2
	.globl src_file
src_file:
	.space 4
	.align 2
	.globl src_buf
src_buf:
	.space 4
	.align 2
	.globl lex_arena
lex_arena:
	.space 4
