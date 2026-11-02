# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl abs
	.type abs, @function
abs:
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
	slt s3, s1, s2
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	lw s1, -4(s0)
	neg s2, s1
	sw s2, -12(s0)
	j .L1_2
.L1_1:
	lw s1, -4(s0)
	sw s1, -12(s0)
.L1_2:
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
.Lfunc_end1:
	.size abs, .Lfunc_end1-abs

	.text
	.align 2
	.globl labs
	.type labs, @function
labs:
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
	slt s3, s1, s2
	bnez s3, .L2_0
	j .L2_1
.L2_0:
	lw s1, -4(s0)
	neg s2, s1
	sw s2, -12(s0)
	j .L2_2
.L2_1:
	lw s1, -4(s0)
	sw s1, -12(s0)
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
	.size labs, .Lfunc_end2-labs

	.text
	.align 2
	.globl llabs
	.type llabs, @function
llabs:
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L3_0
	sltu s1, s10, s8
.L3_0:
	bnez s1, .L3_1
	j .L3_2
.L3_1:
	lw s10, -8(s0)
	lw s11, -4(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -16(s0)
	sw s9, -12(s0)
	j .L3_3
.L3_2:
	lw s10, -8(s0)
	lw s11, -4(s0)
	sw s10, -16(s0)
	sw s11, -12(s0)
.L3_3:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
	.size llabs, .Lfunc_end3-llabs

	.text
	.align 2
	.globl div
	.type div, @function
div:
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
	lw s2, -8(s0)
	div s3, s1, s2
	addi s1, s0, -16
	sw s3, 0(s1)
	lw s1, -4(s0)
	lw s2, -8(s0)
	rem s3, s1, s2
	addi s1, s0, -16
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	addi s1, s0, -16
	lw a0, 0(s1)
	lw a1, 4(s1)
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
	.size div, .Lfunc_end4-div

	.text
	.align 2
	.globl ldiv
	.type ldiv, @function
ldiv:
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
	lw s2, -8(s0)
	div s3, s1, s2
	addi s1, s0, -16
	sw s3, 0(s1)
	lw s1, -4(s0)
	lw s2, -8(s0)
	rem s3, s1, s2
	addi s1, s0, -16
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	addi s1, s0, -16
	lw a0, 0(s1)
	lw a1, 4(s1)
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
	.size ldiv, .Lfunc_end5-ldiv

	.text
	.align 2
	.type parse_ul, @function
parse_ul:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -40(s0)
.L6_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isspace
	mv s1, a0
	bnez s1, .L6_1
	j .L6_2
.L6_1:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L6_0
.L6_2:
	li s1, 0
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_3
	j .L6_4
.L6_4:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_3
	j .L6_5
.L6_3:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	lw s1, -16(s0)
	sw s3, 0(s1)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L6_5:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_6
	j .L6_7
.L6_7:
	lw s1, -12(s0)
	li s2, 16
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_6
	j .L6_8
.L6_6:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_9
	j .L6_8
.L6_9:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_10
	j .L6_11
.L6_11:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_10
	j .L6_8
.L6_10:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	sw s3, -4(s0)
	li s1, 16
	sw s1, -12(s0)
	j .L6_12
.L6_8:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_13
	j .L6_14
.L6_13:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_15
	j .L6_14
.L6_15:
	li s1, 8
	sw s1, -12(s0)
	j .L6_16
.L6_14:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_17
	j .L6_18
.L6_17:
	li s1, 10
	sw s1, -12(s0)
.L6_18:
.L6_16:
.L6_12:
	li s1, 4294967295
	lw s2, -12(s0)
	divu s3, s1, s2
	sw s3, -28(s0)
	li s1, 4294967295
	lw s2, -12(s0)
	remu s3, s1, s2
	sw s3, -32(s0)
.L6_19:
	j .L6_20
.L6_20:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	sw s3, -44(s0)
	lw s1, -44(s0)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_21
	j .L6_22
.L6_21:
	lw s1, -44(s0)
	li s2, 57
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L6_23
	j .L6_22
.L6_23:
	lw s1, -44(s0)
	li s2, 48
	sub s3, s1, s2
	sw s3, -48(s0)
	j .L6_24
.L6_22:
	lw s1, -44(s0)
	li s2, 97
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_25
	j .L6_26
.L6_25:
	lw s1, -44(s0)
	li s2, 122
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L6_27
	j .L6_26
.L6_27:
	lw s1, -44(s0)
	li s2, 97
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -48(s0)
	j .L6_28
.L6_26:
	lw s1, -44(s0)
	li s2, 65
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_29
	j .L6_30
.L6_29:
	lw s1, -44(s0)
	li s2, 90
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L6_31
	j .L6_30
.L6_31:
	lw s1, -44(s0)
	li s2, 65
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -48(s0)
	j .L6_32
.L6_30:
	j .L6_33
.L6_32:
.L6_28:
.L6_24:
	lw s1, -48(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_34
	j .L6_35
.L6_34:
	j .L6_33
.L6_35:
	li s1, 1
	sw s1, -36(s0)
	lw s1, -40(s0)
	bnez s1, .L6_36
	j .L6_37
.L6_37:
	lw s1, -24(s0)
	lw s2, -28(s0)
	sltu s3, s2, s1
	bnez s3, .L6_36
	j .L6_38
.L6_38:
	lw s1, -24(s0)
	lw s2, -28(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_39
	j .L6_40
.L6_39:
	lw s1, -48(s0)
	lw s2, -32(s0)
	slt s3, s2, s1
	bnez s3, .L6_36
	j .L6_40
.L6_36:
	li s1, 1
	sw s1, -40(s0)
	j .L6_41
.L6_40:
	lw s1, -24(s0)
	lw s2, -12(s0)
	mul s3, s1, s2
	lw s1, -48(s0)
	add s2, s3, s1
	sw s2, -24(s0)
.L6_41:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L6_19
.L6_33:
	lw s1, -8(s0)
	bnez s1, .L6_42
	j .L6_43
.L6_42:
	lw s1, -36(s0)
	bnez s1, .L6_44
	j .L6_45
.L6_44:
	lw s1, -4(s0)
	sw s1, -52(s0)
	j .L6_46
.L6_45:
	lw s1, -20(s0)
	sw s1, -52(s0)
.L6_46:
	lw s1, -52(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
.L6_43:
	lw s1, -40(s0)
	bnez s1, .L6_47
	j .L6_48
.L6_47:
	lw s1, -16(s0)
	lw s2, 0(s1)
	bnez s2, .L6_49
	j .L6_50
.L6_49:
	li s1, 2
	sw s1, -56(s0)
	j .L6_51
.L6_50:
	li s1, 3
	sw s1, -56(s0)
.L6_51:
	lw s1, -56(s0)
	lw s2, -16(s0)
	sw s1, 0(s2)
.L6_48:
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
.Lfunc_end6:
	.size parse_ul, .Lfunc_end6-parse_ul

	.text
	.align 2
	.globl strtol
	.type strtol, @function
strtol:
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
	lw s2, -8(s0)
	lw s3, -12(s0)
	addi s4, s0, -20
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, parse_ul
	mv s5, a0
	sw s5, -24(s0)
	lw s1, -20(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s1, 2147483647
	neg s2, s1
	li s1, 1
	sub s3, s2, s1
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
.L7_1:
	lw s1, -20(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_2
	j .L7_3
.L7_2:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s1, 2147483647
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
.L7_3:
	lw s1, -20(s0)
	bnez s1, .L7_4
	j .L7_5
.L7_4:
	lw s1, -24(s0)
	li s2, 2147483647
	li s3, 1
	add s4, s2, s3
	sltu s2, s4, s1
	bnez s2, .L7_6
	j .L7_7
.L7_6:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s1, 2147483647
	neg s2, s1
	li s1, 1
	sub s3, s2, s1
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
.L7_7:
	lw s1, -24(s0)
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
.L7_5:
	lw s1, -24(s0)
	li s2, 2147483647
	sltu s3, s2, s1
	bnez s3, .L7_8
	j .L7_9
.L7_8:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s1, 2147483647
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
.L7_9:
	lw s1, -24(s0)
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
	.size strtol, .Lfunc_end7-strtol

	.text
	.align 2
	.globl strtoul
	.type strtoul, @function
strtoul:
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
	lw s2, -8(s0)
	lw s3, -12(s0)
	addi s4, s0, -20
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, parse_ul
	mv s5, a0
	sw s5, -24(s0)
	lw s1, -20(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_1:
	lw s1, -20(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_2
.L8_0:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s1, 4294967295
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
.L8_2:
	lw s1, -20(s0)
	bnez s1, .L8_3
	j .L8_4
.L8_3:
	lw s1, -24(s0)
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
.L8_4:
	lw s1, -24(s0)
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
.Lfunc_end8:
	.size strtoul, .Lfunc_end8-strtoul

	.text
	.align 2
	.type parse_ull, @function
parse_ull:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	lw s1, -4(s0)
	sw s1, -20(s0)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -32(s0)
	sw s11, -28(s0)
	li s1, 0
	sw s1, -48(s0)
	li s1, 0
	sw s1, -52(s0)
.L9_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isspace
	mv s1, a0
	bnez s1, .L9_1
	j .L9_2
.L9_1:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L9_0
.L9_2:
	li s1, 0
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_3
	j .L9_4
.L9_4:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_3
	j .L9_5
.L9_3:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	lw s1, -16(s0)
	sw s3, 0(s1)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L9_5:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_6
	j .L9_7
.L9_7:
	lw s1, -12(s0)
	li s2, 16
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_6
	j .L9_8
.L9_6:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_9
	j .L9_8
.L9_9:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_10
	j .L9_11
.L9_11:
	lw s1, -4(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_10
	j .L9_8
.L9_10:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	sw s3, -4(s0)
	li s1, 16
	sw s1, -12(s0)
	j .L9_12
.L9_8:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_13
	j .L9_14
.L9_13:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_15
	j .L9_14
.L9_15:
	li s1, 8
	sw s1, -12(s0)
	j .L9_16
.L9_14:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_17
	j .L9_18
.L9_17:
	li s1, 10
	sw s1, -12(s0)
.L9_18:
.L9_16:
.L9_12:
	li s10, -1
	li s11, -1
	lw s1, -12(s0)
	mv s8, s1
	srai s9, s8, 31
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __udivdi3
	mv s6, a0
	mv s7, a1
	sw s6, -40(s0)
	sw s7, -36(s0)
	li s10, -1
	li s11, -1
	lw s1, -12(s0)
	mv s8, s1
	srai s9, s8, 31
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __umoddi3
	mv s6, a0
	mv s7, a1
	mv s1, s6
	sw s1, -44(s0)
.L9_19:
	j .L9_20
.L9_20:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	sw s3, -56(s0)
	lw s1, -56(s0)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_21
	j .L9_22
.L9_21:
	lw s1, -56(s0)
	li s2, 57
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_23
	j .L9_22
.L9_23:
	lw s1, -56(s0)
	li s2, 48
	sub s3, s1, s2
	sw s3, -60(s0)
	j .L9_24
.L9_22:
	lw s1, -56(s0)
	li s2, 97
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_25
	j .L9_26
.L9_25:
	lw s1, -56(s0)
	li s2, 122
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_27
	j .L9_26
.L9_27:
	lw s1, -56(s0)
	li s2, 97
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -60(s0)
	j .L9_28
.L9_26:
	lw s1, -56(s0)
	li s2, 65
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_29
	j .L9_30
.L9_29:
	lw s1, -56(s0)
	li s2, 90
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_31
	j .L9_30
.L9_31:
	lw s1, -56(s0)
	li s2, 65
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -60(s0)
	j .L9_32
.L9_30:
	j .L9_33
.L9_32:
.L9_28:
.L9_24:
	lw s1, -60(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_34
	j .L9_35
.L9_34:
	j .L9_33
.L9_35:
	li s1, 1
	sw s1, -48(s0)
	lw s1, -52(s0)
	bnez s1, .L9_36
	j .L9_37
.L9_37:
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s8, -40(s0)
	lw s9, -36(s0)
	sltu s1, s9, s11
	bne s9, s11, .L9_38
	sltu s1, s8, s10
.L9_38:
	bnez s1, .L9_36
	j .L9_39
.L9_39:
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s8, -40(s0)
	lw s9, -36(s0)
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L9_40
	j .L9_41
.L9_40:
	lw s1, -60(s0)
	lw s2, -44(s0)
	slt s3, s2, s1
	bnez s3, .L9_36
	j .L9_41
.L9_36:
	li s1, 1
	sw s1, -52(s0)
	j .L9_42
.L9_41:
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s1, -12(s0)
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
	lw s1, -60(s0)
	mv s10, s1
	srai s11, s10, 31
	add s8, s6, s10
	sltu t0, s8, s10
	add s9, s7, t0
	add s9, s9, s11
	sw s8, -32(s0)
	sw s9, -28(s0)
.L9_42:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L9_19
.L9_33:
	lw s1, -8(s0)
	bnez s1, .L9_43
	j .L9_44
.L9_43:
	lw s1, -48(s0)
	bnez s1, .L9_45
	j .L9_46
.L9_45:
	lw s1, -4(s0)
	sw s1, -64(s0)
	j .L9_47
.L9_46:
	lw s1, -20(s0)
	sw s1, -64(s0)
.L9_47:
	lw s1, -64(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
.L9_44:
	lw s1, -52(s0)
	bnez s1, .L9_48
	j .L9_49
.L9_48:
	lw s1, -16(s0)
	lw s2, 0(s1)
	bnez s2, .L9_50
	j .L9_51
.L9_50:
	li s1, 2
	sw s1, -68(s0)
	j .L9_52
.L9_51:
	li s1, 3
	sw s1, -68(s0)
.L9_52:
	lw s1, -68(s0)
	lw s2, -16(s0)
	sw s1, 0(s2)
.L9_49:
	lw s10, -32(s0)
	lw s11, -28(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end9:
	.size parse_ull, .Lfunc_end9-parse_ull

	.text
	.align 2
	.globl strtoll
	.type strtoll, @function
strtoll:
	addi sp, sp, -96
	sw ra, 92(sp)
	sw s0, 88(sp)
	addi s0, sp, 88
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
	sw s7, 32(sp)
	sw s8, 36(sp)
	sw s9, 40(sp)
	sw s10, 44(sp)
	sw s11, 48(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	addi t0, s0, -20
	sw t0, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	lw t0, -36(s0)
	mv a3, t0
	jal ra, parse_ull
	mv s10, a0
	mv s11, a1
	sw s10, -32(s0)
	sw s11, -28(s0)
	lw s1, -20(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s10, -1
	li s11, 2147483647
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	li s1, 1
	mv s10, s1
	srai s11, s10, 31
	sltu t0, s8, s10
	sub s6, s8, s10
	sub s7, s9, t0
	sub s7, s7, s11
	mv a0, s6
	mv a1, s7
	lw s1, -80(s0)
	lw s2, -76(s0)
	lw s3, -72(s0)
	lw s4, -68(s0)
	lw s5, -64(s0)
	lw s6, -60(s0)
	lw s7, -56(s0)
	lw s8, -52(s0)
	lw s9, -48(s0)
	lw s10, -44(s0)
	lw s11, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L10_1:
	lw s1, -20(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_2
	j .L10_3
.L10_2:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s10, -1
	li s11, 2147483647
	mv a0, s10
	mv a1, s11
	lw s1, -80(s0)
	lw s2, -76(s0)
	lw s3, -72(s0)
	lw s4, -68(s0)
	lw s5, -64(s0)
	lw s6, -60(s0)
	lw s7, -56(s0)
	lw s8, -52(s0)
	lw s9, -48(s0)
	lw s10, -44(s0)
	lw s11, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L10_3:
	lw s1, -20(s0)
	bnez s1, .L10_4
	j .L10_5
.L10_4:
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s8, -1
	li s9, 2147483647
	li s6, 1
	li s7, 0
	add s4, s8, s6
	sltu t0, s4, s6
	add s5, s9, t0
	add s5, s5, s7
	sltu s1, s5, s11
	bne s5, s11, .L10_6
	sltu s1, s4, s10
.L10_6:
	bnez s1, .L10_7
	j .L10_8
.L10_7:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s10, -1
	li s11, 2147483647
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	li s1, 1
	mv s10, s1
	srai s11, s10, 31
	sltu t0, s8, s10
	sub s6, s8, s10
	sub s7, s9, t0
	sub s7, s7, s11
	mv a0, s6
	mv a1, s7
	lw s1, -80(s0)
	lw s2, -76(s0)
	lw s3, -72(s0)
	lw s4, -68(s0)
	lw s5, -64(s0)
	lw s6, -60(s0)
	lw s7, -56(s0)
	lw s8, -52(s0)
	lw s9, -48(s0)
	lw s10, -44(s0)
	lw s11, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L10_8:
	lw s10, -32(s0)
	lw s11, -28(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	mv a0, s8
	mv a1, s9
	lw s1, -80(s0)
	lw s2, -76(s0)
	lw s3, -72(s0)
	lw s4, -68(s0)
	lw s5, -64(s0)
	lw s6, -60(s0)
	lw s7, -56(s0)
	lw s8, -52(s0)
	lw s9, -48(s0)
	lw s10, -44(s0)
	lw s11, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L10_5:
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s8, -1
	li s9, 2147483647
	sltu s1, s9, s11
	bne s9, s11, .L10_9
	sltu s1, s8, s10
.L10_9:
	bnez s1, .L10_10
	j .L10_11
.L10_10:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s10, -1
	li s11, 2147483647
	mv a0, s10
	mv a1, s11
	lw s1, -80(s0)
	lw s2, -76(s0)
	lw s3, -72(s0)
	lw s4, -68(s0)
	lw s5, -64(s0)
	lw s6, -60(s0)
	lw s7, -56(s0)
	lw s8, -52(s0)
	lw s9, -48(s0)
	lw s10, -44(s0)
	lw s11, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L10_11:
	lw s10, -32(s0)
	lw s11, -28(s0)
	mv a0, s10
	mv a1, s11
	lw s1, -80(s0)
	lw s2, -76(s0)
	lw s3, -72(s0)
	lw s4, -68(s0)
	lw s5, -64(s0)
	lw s6, -60(s0)
	lw s7, -56(s0)
	lw s8, -52(s0)
	lw s9, -48(s0)
	lw s10, -44(s0)
	lw s11, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end10:
	.size strtoll, .Lfunc_end10-strtoll

	.text
	.align 2
	.globl strtoull
	.type strtoull, @function
strtoull:
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
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	addi s4, s0, -20
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, parse_ull
	mv s10, a0
	mv s11, a1
	sw s10, -32(s0)
	sw s11, -28(s0)
	lw s1, -20(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_1
.L11_1:
	lw s1, -20(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_2
.L11_0:
	li s1, 2
	la s2, errno
	sw s1, 0(s2)
	li s10, -1
	li s11, -1
	mv a0, s10
	mv a1, s11
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
.L11_2:
	lw s1, -20(s0)
	bnez s1, .L11_3
	j .L11_4
.L11_3:
	lw s10, -32(s0)
	lw s11, -28(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	mv a0, s8
	mv a1, s9
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
.L11_4:
	lw s10, -32(s0)
	lw s11, -28(s0)
	mv a0, s10
	mv a1, s11
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
	.size strtoull, .Lfunc_end11-strtoull

	.text
	.align 2
	.globl atoi
	.type atoi, @function
atoi:
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
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	mv a0, s4
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
	.size atoi, .Lfunc_end12-atoi

	.text
	.align 2
	.globl atol
	.type atol, @function
atol:
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
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	mv a0, s4
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
.Lfunc_end13:
	.size atol, .Lfunc_end13-atol

	.text
	.align 2
	.globl bsearch
	.type bsearch, @function
bsearch:
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
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	lw s1, -12(s0)
	sw s1, -36(s0)
.L14_0:
	lw s1, -32(s0)
	lw s2, -36(s0)
	sltu s3, s1, s2
	bnez s3, .L14_1
	j .L14_2
.L14_1:
	lw s1, -32(s0)
	lw s2, -36(s0)
	lw s3, -32(s0)
	sub s4, s2, s3
	li s2, 2
	divu s3, s4, s2
	add s2, s1, s3
	sw s2, -40(s0)
	lw s1, -28(s0)
	lw s2, -40(s0)
	lw s3, -16(s0)
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -44(s0)
	lw s1, -20(s0)
	lw s2, -4(s0)
	lw s3, -44(s0)
	mv a0, s2
	mv a1, s3
	mv t0, s1
	jalr ra, t0, 0
	mv s4, a0
	sw s4, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L14_3
	j .L14_4
.L14_3:
	lw s1, -40(s0)
	sw s1, -36(s0)
	j .L14_5
.L14_4:
	lw s1, -48(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L14_6
	j .L14_7
.L14_6:
	lw s1, -40(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -32(s0)
	j .L14_8
.L14_7:
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
.L14_8:
.L14_5:
	j .L14_0
.L14_2:
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
.Lfunc_end14:
	.size bsearch, .Lfunc_end14-bsearch

	.text
	.align 2
	.type swap_bytes, @function
swap_bytes:
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
.L15_0:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L15_1
	j .L15_2
.L15_1:
	lw s1, -4(s0)
	lbu s2, 0(s1)
	sw s2, -20(s0)
	lw s1, -8(s0)
	lbu s2, 0(s1)
	addi s1, s0, -4
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -4(s0)
	sb s2, 0(s3)
	addi s1, s0, -20
	lbu s2, 0(s1)
	addi s1, s0, -8
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -8(s0)
	sb s2, 0(s3)
	j .L15_0
.L15_2:
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
.Lfunc_end15:
	.size swap_bytes, .Lfunc_end15-swap_bytes

	.text
	.align 2
	.globl qsort
	.type qsort, @function
qsort:
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
	sw s1, -20(s0)
	li s1, 1
	sw s1, -24(s0)
	lw s1, -8(s0)
	li s2, 2
	sltu s3, s1, s2
	bnez s3, .L16_0
	j .L16_1
.L16_1:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_0
	j .L16_2
.L16_0:
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
.L16_2:
.L16_3:
	lw s1, -24(s0)
	lw s2, -8(s0)
	li s3, 3
	divu s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L16_4
	j .L16_5
.L16_4:
	lw s1, -24(s0)
	li s2, 3
	mul s3, s1, s2
	li s1, 1
	add s2, s3, s1
	sw s2, -24(s0)
	j .L16_3
.L16_5:
.L16_6:
	lw s1, -24(s0)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L16_7
	j .L16_8
.L16_7:
	lw s1, -24(s0)
	sw s1, -28(s0)
.L16_9:
	lw s1, -28(s0)
	lw s2, -8(s0)
	sltu s3, s1, s2
	bnez s3, .L16_10
	j .L16_11
.L16_10:
	lw s1, -28(s0)
	sw s1, -32(s0)
.L16_12:
	lw s1, -32(s0)
	lw s2, -24(s0)
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L16_13
	j .L16_14
.L16_13:
	lw s1, -16(s0)
	lw s2, -20(s0)
	lw s3, -32(s0)
	lw s4, -24(s0)
	sub s5, s3, s4
	lw s3, -12(s0)
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, -20(s0)
	lw s4, -32(s0)
	lw s5, -12(s0)
	mul s6, s4, s5
	add s4, s2, s6
	mv a0, s3
	mv a1, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s2, a0
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L16_15
	j .L16_14
.L16_15:
	lw s1, -20(s0)
	lw s2, -32(s0)
	lw s3, -24(s0)
	sub s4, s2, s3
	lw s2, -12(s0)
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, -20(s0)
	lw s3, -32(s0)
	lw s4, -12(s0)
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, -12(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, swap_bytes
	mv s4, a0
	addi s1, s0, -32
	lw s2, 0(s1)
	lw s1, -24(s0)
	sub s3, s2, s1
	sw s3, -32(s0)
	j .L16_12
.L16_14:
.L16_16:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L16_9
.L16_11:
.L16_17:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 3
	divu s3, s2, s1
	sw s3, -24(s0)
	j .L16_6
.L16_8:
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
.Lfunc_end16:
	.size qsort, .Lfunc_end16-qsort

	.text
	.align 2
	.globl abort
	.type abort, @function
abort:
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
	li s1, 134
	mv a0, s1
	jal ra, __skj_trap_backtrace
	mv s2, a0
	li s1, 134
	mv a0, s1
	jal ra, exit
	mv s2, a0
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
.Lfunc_end17:
	.size abort, .Lfunc_end17-abort

	.data
