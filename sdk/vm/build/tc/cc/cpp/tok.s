# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type new_token, @function
new_token:
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
	li s1, 20
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	sw s1, 0(s2)
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, xstrndup
	mv s3, a0
	lw s1, -20(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 8
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
.Lfunc_end1:
	.size new_token, .Lfunc_end1-new_token

	.text
	.align 2
	.globl pp_free_tokens
	.type pp_free_tokens, @function
pp_free_tokens:
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
.L2_0:
	lw s1, -4(s0)
	bnez s1, .L2_1
	j .L2_2
.L2_1:
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
	.size pp_free_tokens, .Lfunc_end2-pp_free_tokens

	.text
	.align 2
	.globl pp_token_dup
	.type pp_token_dup, @function
pp_token_dup:
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
	bnez s1, .L3_0
	j .L3_1
.L3_1:
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
.L3_0:
	li s1, 20
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	sw s2, 0(s1)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, xstrndup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end3:
	.size pp_token_dup, .Lfunc_end3-pp_token_dup

	.text
	.align 2
	.globl pp_list_dup
	.type pp_list_dup, @function
pp_list_dup:
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
.L4_0:
	lw s1, -4(s0)
	bnez s1, .L4_1
	j .L4_2
.L4_1:
	lw s1, -4(s0)
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
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -4(s0)
	j .L4_0
.L4_2:
	addi s1, s0, -28
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end4:
	.size pp_list_dup, .Lfunc_end4-pp_list_dup

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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, isalpha
	mv s2, a0
	bnez s2, .L5_0
	j .L5_1
.L5_1:
	lw s1, -4(s0)
	li s2, 95
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_0
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
	.size is_ident_start, .Lfunc_end5-is_ident_start

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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, isalnum
	mv s2, a0
	bnez s2, .L6_0
	j .L6_1
.L6_1:
	lw s1, -4(s0)
	li s2, 95
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_0
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
	.size is_ident_char, .Lfunc_end6-is_ident_char

	.text
	.align 2
	.type is_punct2, @function
is_punct2:
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
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L7_0
	j .L7_1
.L7_0:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L7_2
	j .L7_1
.L7_1:
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
.L7_2:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	sw s1, -16(s0)
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_3
	j .L7_4
.L7_3:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_4
.L7_4:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 60
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_6
	j .L7_7
.L7_6:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 60
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_7
.L7_7:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 62
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_8
	j .L7_9
.L7_8:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 62
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_9
.L7_9:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 60
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_10
	j .L7_11
.L7_10:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_11
.L7_11:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 62
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_12
	j .L7_13
.L7_12:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_13
.L7_13:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_14
	j .L7_15
.L7_14:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_15
.L7_15:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 33
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_16
	j .L7_17
.L7_16:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_17
.L7_17:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_18
	j .L7_19
.L7_18:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_19
.L7_19:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 124
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_20
	j .L7_21
.L7_20:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 124
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_21
.L7_21:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_22
	j .L7_23
.L7_22:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_23
.L7_23:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_24
	j .L7_25
.L7_24:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_25
.L7_25:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_26
	j .L7_27
.L7_26:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_27
.L7_27:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_28
	j .L7_29
.L7_28:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_29
.L7_29:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_30
	j .L7_31
.L7_30:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_31
.L7_31:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_32
	j .L7_33
.L7_32:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_33
.L7_33:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 124
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_34
	j .L7_35
.L7_34:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_35
.L7_35:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 94
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_36
	j .L7_37
.L7_36:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_37
.L7_37:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_38
	j .L7_39
.L7_38:
	addi s1, s0, -16
	lb s2, 0(s1)
	li s1, 62
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_39
.L7_5:
	li s1, 1
	j .L7_40
.L7_39:
	li s1, 0
.L7_40:
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
	.size is_punct2, .Lfunc_end7-is_punct2

	.text
	.align 2
	.type skip_string, @function
skip_string:
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
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L8_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L8_1
	j .L8_2
.L8_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	addi s1, s0, -8
	lb s3, 0(s1)
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L8_3
	j .L8_2
.L8_3:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L8_4
	j .L8_5
.L8_4:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L8_6
	j .L8_5
.L8_6:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L8_5:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L8_0
.L8_2:
	lw s1, -4(s0)
	lb s2, 0(s1)
	addi s1, s0, -8
	lb s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L8_7
	j .L8_8
.L8_7:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L8_8:
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
.Lfunc_end8:
	.size skip_string, .Lfunc_end8-skip_string

	.text
	.align 2
	.globl pp_tokenize
	.type pp_tokenize, @function
pp_tokenize:
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
	lw s1, -4(s0)
	sw s1, -36(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	add s3, s1, s2
	sw s3, -40(s0)
.L9_0:
	lw s1, -36(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L9_1
	j .L9_2
.L9_1:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_3
	j .L9_4
.L9_4:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_3
	j .L9_5
.L9_3:
	j .L9_2
.L9_5:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_6
	j .L9_7
.L9_7:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_6
	j .L9_8
.L9_6:
	lw s1, -36(s0)
	sw s1, -44(s0)
.L9_9:
	lw s1, -36(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L9_10
	j .L9_11
.L9_10:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_12
	j .L9_13
.L9_13:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_12
	j .L9_11
.L9_12:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L9_9
.L9_11:
	li s1, 6
	lw s2, -44(s0)
	lw s3, -36(s0)
	lw s4, -44(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, new_token
	mv s3, a0
	lw s1, -32(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L9_0
.L9_8:
	lw s1, -36(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, is_ident_start
	mv s1, a0
	bnez s1, .L9_14
	j .L9_15
.L9_14:
	lw s1, -36(s0)
	sw s1, -48(s0)
.L9_16:
	lw s1, -36(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L9_17
	j .L9_18
.L9_17:
	lw s1, -36(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, is_ident_char
	mv s1, a0
	bnez s1, .L9_19
	j .L9_18
.L9_19:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L9_16
.L9_18:
	li s1, 1
	lw s2, -48(s0)
	lw s3, -36(s0)
	lw s4, -48(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, new_token
	mv s3, a0
	lw s1, -32(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L9_0
.L9_15:
	lw s1, -36(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, isdigit
	mv s1, a0
	bnez s1, .L9_20
	j .L9_21
.L9_21:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_22
	j .L9_23
.L9_22:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -40(s0)
	slt s2, s3, s1
	bnez s2, .L9_24
	j .L9_23
.L9_24:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	mv a0, s1
	jal ra, isdigit
	mv s2, a0
	bnez s2, .L9_20
	j .L9_23
.L9_20:
	lw s1, -36(s0)
	sw s1, -52(s0)
.L9_25:
	lw s1, -36(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L9_26
	j .L9_27
.L9_26:
	lw s1, -36(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, isalnum
	mv s1, a0
	bnez s1, .L9_28
	j .L9_29
.L9_29:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_28
	j .L9_30
.L9_30:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_28
	j .L9_31
.L9_31:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_28
	j .L9_32
.L9_32:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_28
	j .L9_27
.L9_28:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_33
	j .L9_34
.L9_34:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_33
	j .L9_35
.L9_33:
	lw s1, -36(s0)
	lw s2, -52(s0)
	slt s3, s2, s1
	bnez s3, .L9_36
	j .L9_35
.L9_36:
	lw s1, -36(s0)
	li s2, 1
	neg s3, s2
	add s2, s1, s3
	lb s1, 0(s2)
	mv a0, s1
	jal ra, tolower
	mv s2, a0
	li s1, 101
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L9_37
	j .L9_35
.L9_37:
	lw s1, -36(s0)
	li s2, 1
	neg s3, s2
	add s2, s1, s3
	lb s1, 0(s2)
	mv a0, s1
	jal ra, tolower
	mv s2, a0
	li s1, 112
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L9_38
	j .L9_35
.L9_38:
	j .L9_27
.L9_35:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L9_25
.L9_27:
	li s1, 2
	lw s2, -52(s0)
	lw s3, -36(s0)
	lw s4, -52(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, new_token
	mv s3, a0
	lw s1, -32(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L9_0
.L9_23:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_39
	j .L9_40
.L9_39:
	lw s1, -36(s0)
	sw s1, -56(s0)
	lw s1, -36(s0)
	li s2, 34
	mv a0, s1
	mv a1, s2
	jal ra, skip_string
	mv s3, a0
	sw s3, -36(s0)
	li s1, 3
	lw s2, -56(s0)
	lw s3, -36(s0)
	lw s4, -56(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, new_token
	mv s3, a0
	lw s1, -32(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L9_0
.L9_40:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_41
	j .L9_42
.L9_41:
	lw s1, -36(s0)
	sw s1, -60(s0)
	lw s1, -36(s0)
	li s2, 39
	mv a0, s1
	mv a1, s2
	jal ra, skip_string
	mv s3, a0
	sw s3, -36(s0)
	li s1, 4
	lw s2, -60(s0)
	lw s3, -36(s0)
	lw s4, -60(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, new_token
	mv s3, a0
	lw s1, -32(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L9_0
.L9_42:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_43
	j .L9_44
.L9_43:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -40(s0)
	slt s2, s3, s1
	bnez s2, .L9_45
	j .L9_44
.L9_45:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_46
	j .L9_44
.L9_46:
	j .L9_2
.L9_44:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_47
	j .L9_48
.L9_47:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -40(s0)
	slt s2, s3, s1
	bnez s2, .L9_49
	j .L9_48
.L9_49:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_50
	j .L9_48
.L9_50:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	sw s3, -36(s0)
.L9_51:
	lw s1, -36(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L9_52
	j .L9_53
.L9_52:
	lw s1, -36(s0)
	li s2, 1
	neg s3, s2
	add s2, s1, s3
	lb s1, 0(s2)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_54
	j .L9_55
.L9_54:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_53
	j .L9_55
.L9_55:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L9_51
.L9_53:
	lw s1, -36(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L9_56
	j .L9_57
.L9_56:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
.L9_57:
	li s1, 6
	la s2, __str_0
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, new_token
	mv s4, a0
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	sw s4, 0(s3)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L9_0
.L9_48:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, is_punct2
	mv s2, a0
	bnez s2, .L9_58
	j .L9_59
.L9_58:
	li s1, 5
	lw s2, -36(s0)
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, new_token
	mv s4, a0
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	sw s4, 0(s3)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	sw s3, -36(s0)
	j .L9_0
.L9_59:
	li s1, 5
	lw s2, -36(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, new_token
	mv s4, a0
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	sw s4, 0(s3)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L9_0
.L9_2:
	addi s1, s0, -28
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end9:
	.size pp_tokenize, .Lfunc_end9-pp_tokenize

	.text
	.align 2
	.globl pp_detokenize
	.type pp_detokenize, @function
pp_detokenize:
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
	lw s1, -4(s0)
	sw s1, -24(s0)
.L10_0:
	lw s1, -24(s0)
	bnez s1, .L10_1
	j .L10_2
.L10_1:
	lw s1, -20(s0)
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 1
	sub s4, s1, s2
	slt s1, s3, s4
	xori s1, s1, 1
	bnez s1, .L10_3
	j .L10_4
.L10_3:
	j .L10_2
.L10_4:
	lw s1, -8(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lw s1, -24(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -24(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -20
	lw s2, 0(s1)
	lw s1, -24(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -20(s0)
.L10_5:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	j .L10_0
.L10_2:
	li s1, 0
	lw s2, -8(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	sb s1, 0(s4)
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
.Lfunc_end10:
	.size pp_detokenize, .Lfunc_end10-pp_detokenize

	.data
	.align 2
__str_0:
	.ascii " \000"
