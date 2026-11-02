# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type digit_of, @function
digit_of:
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
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_2
	j .L1_1
.L1_2:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 48
	sub s3, s2, s1
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
.L1_1:
	lw s1, -8(s0)
	li s2, 16
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_3
	j .L1_4
.L1_3:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 97
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_5
	j .L1_4
.L1_5:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 102
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_6
	j .L1_4
.L1_6:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 97
	sub s3, s2, s1
	li s1, 10
	add s2, s3, s1
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
.L1_4:
	lw s1, -8(s0)
	li s2, 16
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_7
	j .L1_8
.L1_7:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 65
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_9
	j .L1_8
.L1_9:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 70
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_10
	j .L1_8
.L1_10:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 65
	sub s3, s2, s1
	li s1, 10
	add s2, s3, s1
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
.L1_8:
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
.Lfunc_end1:
	.size digit_of, .Lfunc_end1-digit_of

	.text
	.align 2
	.type scan_int, @function
scan_int:
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
	li s1, 0
	sw s1, -20(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 10
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -40(s0)
	li s1, 0
	sw s1, -44(s0)
	li s1, 0
	lw s2, -12(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s2)
	sw s11, 4(s2)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L2_0
	j .L2_1
.L2_0:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 43
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_2
	j .L2_3
.L2_3:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_2
	j .L2_1
.L2_2:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -28(s0)
	li s1, 1
	sw s1, -20(s0)
.L2_1:
	lw s1, -20(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L2_4
	j .L2_5
.L2_4:
	lw s1, -4(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 36
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_6
	j .L2_5
.L2_6:
	li s1, 16
	sw s1, -32(s0)
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
.L2_5:
	lw s1, -20(s0)
	sw s1, -24(s0)
.L2_7:
	lw s1, -20(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L2_8
	j .L2_9
.L2_8:
	lw s1, -4(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, digit_of
	mv s3, a0
	sw s3, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L2_10
	j .L2_11
.L2_10:
	j .L2_9
.L2_11:
	lw s1, -44(s0)
	li s2, 4294967295
	lw s3, -52(s0)
	sub s4, s2, s3
	lw s2, -32(s0)
	divu s3, s4, s2
	sltu s2, s3, s1
	bnez s2, .L2_12
	j .L2_13
.L2_12:
	li s1, 1
	sw s1, -40(s0)
	j .L2_14
.L2_13:
	lw s1, -44(s0)
	lw s2, -32(s0)
	mul s3, s1, s2
	lw s1, -52(s0)
	add s2, s3, s1
	sw s2, -44(s0)
.L2_14:
	li s1, 1
	sw s1, -36(s0)
.L2_15:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L2_7
.L2_9:
	lw s1, -36(s0)
	bnez s1, .L2_16
	j .L2_17
.L2_17:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	sw s3, 0(s1)
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
.L2_16:
	lw s1, -20(s0)
	lw s2, -8(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L2_18
	j .L2_19
.L2_18:
	lw s1, -20(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	sw s3, 0(s1)
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
.L2_19:
	lw s1, -28(s0)
	bnez s1, .L2_20
	j .L2_21
.L2_20:
	li s1, 2147483648
	sw s1, -56(s0)
	j .L2_22
.L2_21:
	li s1, 2147483647
	sw s1, -56(s0)
.L2_22:
	lw s1, -56(s0)
	sw s1, -48(s0)
	lw s1, -40(s0)
	bnez s1, .L2_23
	j .L2_24
.L2_24:
	lw s1, -44(s0)
	lw s2, -48(s0)
	sltu s3, s2, s1
	bnez s3, .L2_23
	j .L2_25
.L2_23:
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	sw s3, 0(s1)
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
.L2_25:
	lw s1, -28(s0)
	bnez s1, .L2_26
	j .L2_27
.L2_26:
	lw s1, -44(s0)
	mv s10, s1
	li s11, 0
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -64(s0)
	sw s9, -60(s0)
	j .L2_28
.L2_27:
	lw s1, -44(s0)
	mv s10, s1
	li s11, 0
	sw s10, -64(s0)
	sw s11, -60(s0)
.L2_28:
	lw s10, -64(s0)
	lw s11, -60(s0)
	lw s1, -12(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	li s1, 0
	lw s2, -16(s0)
	sw s1, 0(s2)
	li s1, 0
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
.Lfunc_end2:
	.size scan_int, .Lfunc_end2-scan_int

	.text
	.align 2
	.type scan_int64, @function
scan_int64:
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
	li s1, 0
	sw s1, -20(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 10
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -40(s0)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	li s1, 0
	lw s2, -12(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s2)
	sw s11, 4(s2)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 43
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_2
	j .L3_3
.L3_3:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_2
	j .L3_1
.L3_2:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -28(s0)
	li s1, 1
	sw s1, -20(s0)
.L3_1:
	lw s1, -20(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L3_4
	j .L3_5
.L3_4:
	lw s1, -4(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 36
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_6
	j .L3_5
.L3_6:
	li s1, 16
	sw s1, -32(s0)
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
.L3_5:
	lw s1, -20(s0)
	sw s1, -24(s0)
.L3_7:
	lw s1, -20(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L3_8
	j .L3_9
.L3_8:
	lw s1, -4(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, digit_of
	mv s3, a0
	sw s3, -60(s0)
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_10
	j .L3_11
.L3_10:
	j .L3_9
.L3_11:
	li s1, 1
	sw s1, -36(s0)
	lw s1, -32(s0)
	li s2, 16
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_12
	j .L3_13
.L3_12:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s8, -1
	li s9, -1
	li s1, 4
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	sltu s1, s7, s11
	bne s7, s11, .L3_14
	sltu s1, s6, s10
.L3_14:
	bnez s1, .L3_15
	j .L3_16
.L3_15:
	li s1, 1
	sw s1, -40(s0)
	j .L3_17
.L3_16:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s1, 4
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	lw s1, -60(s0)
	mv s10, s1
	srai s11, s10, 31
	add s6, s8, s10
	sltu t0, s6, s10
	add s7, s9, t0
	add s7, s7, s11
	sw s6, -48(s0)
	sw s7, -44(s0)
	j .L3_18
.L3_13:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s8, -1717986919
	li s9, 429496729
	sltu s1, s9, s11
	bne s9, s11, .L3_19
	sltu s1, s8, s10
.L3_19:
	bnez s1, .L3_20
	j .L3_21
.L3_21:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s8, -1717986919
	li s9, 429496729
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L3_22
	j .L3_23
.L3_22:
	lw s1, -60(s0)
	li s2, 5
	slt s3, s2, s1
	bnez s3, .L3_20
	j .L3_23
.L3_20:
	li s1, 1
	sw s1, -40(s0)
	j .L3_17
.L3_23:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s1, 3
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s1, 1
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	add s10, s8, s6
	sltu t0, s10, s6
	add s11, s9, t0
	add s11, s11, s7
	lw s1, -60(s0)
	mv s8, s1
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -48(s0)
	sw s7, -44(s0)
.L3_18:
.L3_17:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L3_7
.L3_9:
	lw s1, -36(s0)
	bnez s1, .L3_24
	j .L3_25
.L3_25:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	sw s3, 0(s1)
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
.L3_24:
	lw s1, -20(s0)
	lw s2, -8(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_26
	j .L3_27
.L3_26:
	lw s1, -20(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	sw s3, 0(s1)
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
.L3_27:
	lw s1, -28(s0)
	bnez s1, .L3_28
	j .L3_29
.L3_28:
	li s10, 0
	li s11, -2147483648
	sw s10, -72(s0)
	sw s11, -68(s0)
	j .L3_30
.L3_29:
	li s10, -1
	li s11, 2147483647
	sw s10, -72(s0)
	sw s11, -68(s0)
.L3_30:
	lw s10, -72(s0)
	lw s11, -68(s0)
	sw s10, -56(s0)
	sw s11, -52(s0)
	lw s1, -40(s0)
	bnez s1, .L3_31
	j .L3_32
.L3_32:
	lw s10, -48(s0)
	lw s11, -44(s0)
	lw s8, -56(s0)
	lw s9, -52(s0)
	sltu s1, s9, s11
	bne s9, s11, .L3_33
	sltu s1, s8, s10
.L3_33:
	bnez s1, .L3_31
	j .L3_34
.L3_31:
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	sw s3, 0(s1)
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
.L3_34:
	lw s1, -28(s0)
	bnez s1, .L3_35
	j .L3_36
.L3_35:
	lw s10, -48(s0)
	lw s11, -44(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -80(s0)
	sw s9, -76(s0)
	j .L3_37
.L3_36:
	lw s10, -48(s0)
	lw s11, -44(s0)
	sw s10, -80(s0)
	sw s11, -76(s0)
.L3_37:
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw s1, -12(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	li s1, 0
	lw s2, -16(s0)
	sw s1, 0(s2)
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
.Lfunc_end3:
	.size scan_int64, .Lfunc_end3-scan_int64

	.text
	.align 2
	.globl kp_str_from_int
	.type kp_str_from_int, @function
kp_str_from_int:
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
	li s1, 0
	sw s1, -28(s0)
	lw s1, -4(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	li s1, 0
	lw s2, -4(s0)
	sub s3, s1, s2
	sw s3, -36(s0)
	j .L4_2
.L4_1:
	lw s1, -4(s0)
	sw s1, -36(s0)
.L4_2:
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s1, -4(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L4_3
	j .L4_4
.L4_3:
	li s1, 45
	addi s2, s0, -24
	addi s3, s0, -28
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -28(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L4_4:
	addi s1, s0, -28
	lw s2, 0(s1)
	addi s1, s0, -24
	lw s3, -28(s0)
	add s4, s1, s3
	lw s1, -32(s0)
	mv s10, s1
	li s11, 0
	mv a0, s4
	mv a1, s10
	mv a2, s11
	jal ra, __fmt_udec
	mv s1, a0
	add s3, s2, s1
	sw s3, -28(s0)
	addi s1, s0, -24
	lw s2, -28(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
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
	.size kp_str_from_int, .Lfunc_end4-kp_str_from_int

	.text
	.align 2
	.globl kp_str_from_int64
	.type kp_str_from_int64, @function
kp_str_from_int64:
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	li s1, 0
	sw s1, -36(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L5_0
	sltu s1, s10, s8
.L5_0:
	bnez s1, .L5_1
	j .L5_2
.L5_1:
	li s10, 0
	li s11, 0
	lw s8, -8(s0)
	lw s9, -4(s0)
	sltu t0, s10, s8
	sub s6, s10, s8
	sub s7, s11, t0
	sub s7, s7, s9
	sw s6, -56(s0)
	sw s7, -52(s0)
	j .L5_3
.L5_2:
	lw s10, -8(s0)
	lw s11, -4(s0)
	sw s10, -56(s0)
	sw s11, -52(s0)
.L5_3:
	lw s10, -56(s0)
	lw s11, -52(s0)
	sw s10, -48(s0)
	sw s11, -44(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L5_4
	sltu s1, s10, s8
.L5_4:
	bnez s1, .L5_5
	j .L5_6
.L5_5:
	li s1, 45
	addi s2, s0, -32
	addi s3, s0, -36
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -36(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L5_6:
	addi s1, s0, -36
	lw s2, 0(s1)
	addi s1, s0, -32
	lw s3, -36(s0)
	add s4, s1, s3
	lw s10, -48(s0)
	lw s11, -44(s0)
	mv a0, s4
	mv a1, s10
	mv a2, s11
	jal ra, __fmt_udec
	mv s1, a0
	add s3, s2, s1
	sw s3, -36(s0)
	addi s1, s0, -32
	lw s2, -36(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
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
.Lfunc_end5:
	.size kp_str_from_int64, .Lfunc_end5-kp_str_from_int64

	.text
	.align 2
	.globl kp_str_val_int
	.type kp_str_val_int, @function
kp_str_val_int:
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
	jal ra, kp_str_bytes
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s3, a0
	addi s1, s0, -16
	addi s4, s0, -20
	mv a0, s2
	mv a1, s3
	mv a2, s1
	mv a3, s4
	jal ra, scan_int
	mv s5, a0
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv s1, s10
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
	.size kp_str_val_int, .Lfunc_end6-kp_str_val_int

	.text
	.align 2
	.globl kp_str_val_int64
	.type kp_str_val_int64, @function
kp_str_val_int64:
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
	jal ra, kp_str_bytes
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s3, a0
	addi s1, s0, -16
	addi s4, s0, -20
	mv a0, s2
	mv a1, s3
	mv a2, s1
	mv a3, s4
	jal ra, scan_int64
	mv s5, a0
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
	.size kp_str_val_int64, .Lfunc_end7-kp_str_val_int64

	.text
	.align 2
	.globl kp_str_valcode
	.type kp_str_valcode, @function
kp_str_valcode:
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
	fsd fs0, 56(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	lw s1, -8(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_bytes
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s3, a0
	addi s1, s0, -20
	addi sp, sp, -16
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, scan_real
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fcvt.w.d s1, fs0, rtz
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
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
	fld fs0, -32(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_1:
	lw s1, -8(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_2
	j .L8_3
.L8_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_bytes
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s3, a0
	addi s1, s0, -16
	addi s4, s0, -20
	mv a0, s2
	mv a1, s3
	mv a2, s1
	mv a3, s4
	jal ra, scan_int64
	mv s5, a0
	j .L8_4
.L8_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_bytes
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s3, a0
	addi s1, s0, -16
	addi s4, s0, -20
	mv a0, s2
	mv a1, s3
	mv a2, s1
	mv a3, s4
	jal ra, scan_int
	mv s5, a0
.L8_4:
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
	fld fs0, -32(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end8:
	.size kp_str_valcode, .Lfunc_end8-kp_str_valcode

	.text
	.align 2
	.type b2d, @function
b2d:
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
	fsd fs0, 48(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	addi s1, s0, -16
	addi s2, s0, -8
	li s3, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	fld fs0, -16(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -24(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -24(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end9:
	.size b2d, .Lfunc_end9-b2d

	.text
	.align 2
	.type d2b, @function
d2b:
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
	addi s1, s0, -16
	addi s2, s0, -8
	li s3, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
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
.Lfunc_end10:
	.size d2b, .Lfunc_end10-d2b

	.text
	.align 2
	.type scan_real, @function
scan_real:
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
	fsd fs0, 56(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	li s1, 0
	sw s1, -92(s0)
	j .L11_2
.L11_1:
	lw s1, -8(s0)
	li s2, 63
	slt s3, s2, s1
	bnez s3, .L11_3
	j .L11_4
.L11_3:
	li s1, 63
	sw s1, -96(s0)
	j .L11_5
.L11_4:
	lw s1, -8(s0)
	sw s1, -96(s0)
.L11_5:
	lw s1, -96(s0)
	sw s1, -92(s0)
.L11_2:
	lw s1, -92(s0)
	sw s1, -88(s0)
	lw s1, -88(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_6
	j .L11_7
.L11_6:
	lw s1, -12(s0)
	bnez s1, .L11_8
	j .L11_9
.L11_8:
	li s1, 1
	lw s2, -12(s0)
	sw s1, 0(s2)
.L11_9:
	li s1, 0
	fcvt.d.w fs0, s1
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -112(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L11_7:
	addi s1, s0, -80
	lw s2, -4(s0)
	lw s3, -88(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	addi s2, s0, -80
	lw s3, -88(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -80
	addi s2, s0, -84
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	jal ra, strtod
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -104(s0)
	lw s1, -84(s0)
	addi s2, s0, -80
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_10
	j .L11_11
.L11_10:
	lw s1, -12(s0)
	bnez s1, .L11_12
	j .L11_13
.L11_12:
	li s1, 1
	lw s2, -12(s0)
	sw s1, 0(s2)
.L11_13:
	li s1, 0
	fcvt.d.w fs0, s1
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -112(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L11_11:
	lw s1, -84(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L11_14
	j .L11_15
.L11_14:
	lw s1, -12(s0)
	bnez s1, .L11_16
	j .L11_17
.L11_16:
	lw s1, -84(s0)
	addi s2, s0, -80
	sub s3, s1, s2
	li s1, 1
	add s2, s3, s1
	lw s1, -12(s0)
	sw s2, 0(s1)
.L11_17:
	li s1, 0
	fcvt.d.w fs0, s1
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -112(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L11_15:
	lw s1, -12(s0)
	bnez s1, .L11_18
	j .L11_19
.L11_18:
	li s1, 0
	lw s2, -12(s0)
	sw s1, 0(s2)
.L11_19:
	fld fs0, -104(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -112(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -112(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end11:
	.size scan_real, .Lfunc_end11-scan_real

	.text
	.align 2
	.globl kp_str_val_real
	.type kp_str_val_real, @function
kp_str_val_real:
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
	fsd fs0, 56(sp)
	sw a0, -4(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_bytes
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s3, a0
	li s1, 0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, scan_real
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -16(s0)
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
	fld fs0, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end12:
	.size kp_str_val_real, .Lfunc_end12-kp_str_val_real

	.text
	.align 2
	.globl brv_write_real
	.type brv_write_real, @function
brv_write_real:
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
	fsd fs0, 48(sp)
	sw a0, -4(s0)
	sw a1, -16(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	mv a0, s1
	fsd fs0, 0(sp)
	lw a1, 0(sp)
	lw a2, 4(sp)
	jal ra, io_write_real
	mv s2, a0
	addi sp, sp, 16
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
	fld fs0, -24(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end13:
	.size brv_write_real, .Lfunc_end13-brv_write_real

	.text
	.align 2
	.globl brv_read_real
	.type brv_read_real, @function
brv_read_real:
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
	fsd fs0, 48(sp)
	addi sp, sp, -16
	jal ra, io_read_real
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, d2b
	mv s10, a0
	mv s11, a1
	addi sp, sp, 16
	mv a0, s10
	mv a1, s11
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
	fld fs0, -8(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end14:
	.size brv_read_real, .Lfunc_end14-brv_read_real

	.text
	.align 2
	.globl brv_val_real
	.type brv_val_real, @function
brv_val_real:
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
	fsd fs0, 56(sp)
	sw a0, -4(s0)
	lw s1, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	jal ra, kp_str_val_real
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, d2b
	mv s10, a0
	mv s11, a1
	addi sp, sp, 16
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
	fld fs0, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end15:
	.size brv_val_real, .Lfunc_end15-brv_val_real

	.text
	.align 2
	.globl kp_set_raw_args
	.type kp_set_raw_args, @function
kp_set_raw_args:
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
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_0
	j .L16_1
.L16_0:
	li s1, 0
	la s2, g_argc
	sw s1, 0(s2)
	li s1, 0
	la s2, g_argv
	sw s1, 0(s2)
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
.L16_1:
	lw s1, -4(s0)
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, g_argc
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	la s1, g_argv
	sw s2, 0(s1)
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
.Lfunc_end16:
	.size kp_set_raw_args, .Lfunc_end16-kp_set_raw_args

	.text
	.align 2
	.globl rt_param_count
	.type rt_param_count, @function
rt_param_count:
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
	la s1, g_argc
	lw s2, 0(s1)
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L17_0
	j .L17_1
.L17_0:
	la s1, g_argc
	lw s2, 0(s1)
	li s1, 1
	sub s3, s2, s1
	sw s3, -4(s0)
	j .L17_2
.L17_1:
	li s1, 0
	sw s1, -4(s0)
.L17_2:
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
.Lfunc_end17:
	.size rt_param_count, .Lfunc_end17-rt_param_count

	.text
	.align 2
	.globl rt_param_str
	.type rt_param_str, @function
rt_param_str:
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
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L18_0
	j .L18_1
.L18_1:
	lw s1, -4(s0)
	la s2, g_argc
	lw s3, 0(s2)
	slt s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L18_0
	j .L18_2
.L18_2:
	la s1, g_argv
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_0
	j .L18_3
.L18_0:
	la s1, __str_0
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
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
.L18_3:
	la s1, g_argv
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_4
	j .L18_5
.L18_4:
	la s1, __str_1
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
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
.L18_5:
.L18_6:
	lw s1, -12(s0)
	lw s2, -16(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L18_7
	j .L18_8
.L18_7:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L18_6
.L18_8:
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
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
.Lfunc_end18:
	.size rt_param_str, .Lfunc_end18-rt_param_str

	.text
	.align 2
	.globl main
	.type main, @function
main:
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
	la s2, g_argc
	sw s1, 0(s2)
	lw s1, -8(s0)
	la s2, g_argv
	sw s1, 0(s2)
	jal ra, kp_guest_entry
	mv s1, a0
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
.Lfunc_end19:
	.size main, .Lfunc_end19-main

	.text
	.align 2
	.globl __libc_fini
	.type __libc_fini, @function
__libc_fini:
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
.Lfunc_end20:
	.size __libc_fini, .Lfunc_end20-__libc_fini

	.text
	.align 2
	.type kpio_open, @function
kpio_open:
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
	li s3, 420
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fs_open
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
.Lfunc_end21:
	.size kpio_open, .Lfunc_end21-kpio_open

	.text
	.align 2
	.type kpio_read, @function
kpio_read:
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
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L22_0
	j .L22_1
.L22_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, read
	mv s4, a0
	sw s4, -20(s0)
	j .L22_2
.L22_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fs_read
	mv s4, a0
	sw s4, -20(s0)
.L22_2:
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
.Lfunc_end22:
	.size kpio_read, .Lfunc_end22-kpio_read

	.text
	.align 2
	.type kpio_write, @function
kpio_write:
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
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L23_0
	j .L23_1
.L23_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, write
	mv s4, a0
	sw s4, -20(s0)
	j .L23_2
.L23_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fs_write
	mv s4, a0
	sw s4, -20(s0)
.L23_2:
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
.Lfunc_end23:
	.size kpio_write, .Lfunc_end23-kpio_write

	.text
	.align 2
	.type kpio_lseek, @function
kpio_lseek:
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
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L24_0
	j .L24_1
.L24_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lseek
	mv s4, a0
	sw s4, -20(s0)
	j .L24_2
.L24_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv s10, s2
	srai s11, s10, 31
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	jal ra, fs_lseek
	mv s8, a0
	mv s9, a1
	mv s1, s8
	sw s1, -20(s0)
.L24_2:
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
.Lfunc_end24:
	.size kpio_lseek, .Lfunc_end24-kpio_lseek

	.text
	.align 2
	.type kpio_close, @function
kpio_close:
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
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L25_0
	j .L25_1
.L25_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, fs_close
	mv s2, a0
	j .L25_2
.L25_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, close
	mv s2, a0
.L25_2:
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
.Lfunc_end25:
	.size kpio_close, .Lfunc_end25-kpio_close

	.text
	.align 2
	.globl ReadFileStr
	.type ReadFileStr, @function
ReadFileStr:
	addi sp, sp, -1136
	sw ra, 1132(sp)
	sw s0, 1128(sp)
	addi s0, sp, 1128
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
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -1036(s0)
	li s1, 0
	sw s1, -1044(s0)
	lw s1, -1036(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L26_0
	j .L26_1
.L26_1:
	lw s1, -1036(s0)
	li s2, 1024
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L26_0
	j .L26_2
.L26_0:
	la s1, __str_2
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
	lw s1, -1116(s0)
	lw s2, -1112(s0)
	lw s3, -1108(s0)
	lw s4, -1104(s0)
	lw s5, -1100(s0)
	lw s6, -1096(s0)
	lw s7, -1092(s0)
	lw s8, -1088(s0)
	lw s9, -1084(s0)
	lw s10, -1080(s0)
	lw s11, -1076(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_2:
	addi s1, s0, -1032
	lw s2, -4(s0)
	mv a0, s2
	jal ra, kp_str_bytes
	mv s3, a0
	lw s2, -1036(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	addi s2, s0, -1032
	lw s3, -1036(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -1032
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kpio_open
	mv s3, a0
	sw s3, -1056(s0)
	lw s1, -1056(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L26_3
	j .L26_4
.L26_3:
	la s1, __str_3
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
	lw s1, -1116(s0)
	lw s2, -1112(s0)
	lw s3, -1108(s0)
	lw s4, -1104(s0)
	lw s5, -1100(s0)
	lw s6, -1096(s0)
	lw s7, -1092(s0)
	lw s8, -1088(s0)
	lw s9, -1084(s0)
	lw s10, -1080(s0)
	lw s11, -1076(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_4:
	lw s1, -1056(s0)
	li s2, 0
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, kpio_lseek
	mv s4, a0
	sw s4, -1064(s0)
	lw s1, -1064(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L26_5
	j .L26_6
.L26_5:
	lw s1, -1056(s0)
	li s2, 0
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, kpio_lseek
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L26_7
	j .L26_6
.L26_7:
	lw s1, -1064(s0)
	sw s1, -1040(s0)
	lw s1, -1040(s0)
	bnez s1, .L26_8
	j .L26_9
.L26_8:
	lw s1, -1040(s0)
	sw s1, -1068(s0)
	j .L26_10
.L26_9:
	li s1, 1
	sw s1, -1068(s0)
.L26_10:
	lw s1, -1068(s0)
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -1048(s0)
.L26_11:
	lw s1, -1044(s0)
	lw s2, -1040(s0)
	sltu s3, s1, s2
	bnez s3, .L26_12
	j .L26_13
.L26_12:
	lw s1, -1056(s0)
	lw s2, -1048(s0)
	lw s3, -1044(s0)
	add s4, s2, s3
	lw s2, -1040(s0)
	lw s3, -1044(s0)
	sub s5, s2, s3
	mv a0, s1
	mv a1, s4
	mv a2, s5
	jal ra, kpio_read
	mv s2, a0
	sw s2, -1060(s0)
	lw s1, -1060(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L26_14
	j .L26_15
.L26_14:
	j .L26_13
.L26_15:
	addi s1, s0, -1044
	lw s2, 0(s1)
	lw s1, -1060(s0)
	add s3, s2, s1
	sw s3, -1044(s0)
	j .L26_11
.L26_13:
	j .L26_16
.L26_6:
	li s1, 65536
	sw s1, -1040(s0)
	lw s1, -1040(s0)
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -1048(s0)
.L26_17:
	j .L26_18
.L26_18:
	lw s1, -1044(s0)
	lw s2, -1040(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_19
	j .L26_20
.L26_19:
	addi s1, s0, -1040
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -1040(s0)
	lw s1, -1048(s0)
	lw s2, -1040(s0)
	mv a0, s1
	mv a1, s2
	jal ra, gheap_realloc
	mv s3, a0
	sw s3, -1048(s0)
.L26_20:
	lw s1, -1056(s0)
	lw s2, -1048(s0)
	lw s3, -1044(s0)
	add s4, s2, s3
	lw s2, -1040(s0)
	lw s3, -1044(s0)
	sub s5, s2, s3
	mv a0, s1
	mv a1, s4
	mv a2, s5
	jal ra, kpio_read
	mv s2, a0
	sw s2, -1060(s0)
	lw s1, -1060(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L26_21
	j .L26_22
.L26_21:
	j .L26_23
.L26_22:
	addi s1, s0, -1044
	lw s2, 0(s1)
	lw s1, -1060(s0)
	add s3, s2, s1
	sw s3, -1044(s0)
.L26_24:
	j .L26_17
.L26_23:
.L26_16:
	lw s1, -1056(s0)
	mv a0, s1
	jal ra, kpio_close
	mv s2, a0
	lw s1, -1048(s0)
	lw s2, -1044(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new_guest
	mv s3, a0
	sw s3, -1052(s0)
	lw s1, -1048(s0)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
	lw s1, -1052(s0)
	mv a0, s1
	lw s1, -1116(s0)
	lw s2, -1112(s0)
	lw s3, -1108(s0)
	lw s4, -1104(s0)
	lw s5, -1100(s0)
	lw s6, -1096(s0)
	lw s7, -1092(s0)
	lw s8, -1088(s0)
	lw s9, -1084(s0)
	lw s10, -1080(s0)
	lw s11, -1076(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end26:
	.size ReadFileStr, .Lfunc_end26-ReadFileStr

	.text
	.align 2
	.globl WriteFileStr
	.type WriteFileStr, @function
WriteFileStr:
	addi sp, sp, -1104
	sw ra, 1100(sp)
	sw s0, 1096(sp)
	addi s0, sp, 1096
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
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -1036(s0)
	lw s1, -1036(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L27_0
	j .L27_1
.L27_1:
	lw s1, -1036(s0)
	li s2, 1024
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L27_0
	j .L27_2
.L27_0:
	li s1, 0
	mv a0, s1
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_2:
	addi s1, s0, -1032
	lw s2, -4(s0)
	mv a0, s2
	jal ra, kp_str_bytes
	mv s3, a0
	lw s2, -1036(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	addi s2, s0, -1032
	lw s3, -1036(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -1032
	li s2, 1
	li s3, 64
	or s4, s2, s3
	li s2, 512
	or s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, kpio_open
	mv s2, a0
	sw s2, -1044(s0)
	lw s1, -1044(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L27_3
	j .L27_4
.L27_3:
	li s1, 0
	mv a0, s1
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_4:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -1040(s0)
	lw s1, -1044(s0)
	lw s2, -8(s0)
	mv a0, s2
	jal ra, kp_str_bytes
	mv s3, a0
	lw s2, -1040(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, kpio_write
	mv s4, a0
	sw s4, -1048(s0)
	lw s1, -1044(s0)
	mv a0, s1
	jal ra, kpio_close
	mv s2, a0
	lw s1, -1048(s0)
	lw s2, -1040(s0)
	xor s3, s1, s2
	seqz s3, s3
	mv a0, s3
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end27:
	.size WriteFileStr, .Lfunc_end27-WriteFileStr

	.text
	.align 2
	.globl kpf_open_read
	.type kpf_open_read, @function
kpf_open_read:
	addi sp, sp, -1104
	sw ra, 1100(sp)
	sw s0, 1096(sp)
	addi s0, sp, 1096
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
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -1036(s0)
	lw s1, -1036(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L28_0
	j .L28_1
.L28_1:
	lw s1, -1036(s0)
	li s2, 1024
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L28_0
	j .L28_2
.L28_0:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1084(s0)
	lw s2, -1080(s0)
	lw s3, -1076(s0)
	lw s4, -1072(s0)
	lw s5, -1068(s0)
	lw s6, -1064(s0)
	lw s7, -1060(s0)
	lw s8, -1056(s0)
	lw s9, -1052(s0)
	lw s10, -1048(s0)
	lw s11, -1044(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L28_2:
	addi s1, s0, -1032
	lw s2, -4(s0)
	mv a0, s2
	jal ra, kp_str_bytes
	mv s3, a0
	lw s2, -1036(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	addi s2, s0, -1032
	lw s3, -1036(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -1032
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kpio_open
	mv s3, a0
	mv a0, s3
	lw s1, -1084(s0)
	lw s2, -1080(s0)
	lw s3, -1076(s0)
	lw s4, -1072(s0)
	lw s5, -1068(s0)
	lw s6, -1064(s0)
	lw s7, -1060(s0)
	lw s8, -1056(s0)
	lw s9, -1052(s0)
	lw s10, -1048(s0)
	lw s11, -1044(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end28:
	.size kpf_open_read, .Lfunc_end28-kpf_open_read

	.text
	.align 2
	.globl kpf_open_write
	.type kpf_open_write, @function
kpf_open_write:
	addi sp, sp, -1104
	sw ra, 1100(sp)
	sw s0, 1096(sp)
	addi s0, sp, 1096
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
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -1036(s0)
	lw s1, -1036(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L29_0
	j .L29_1
.L29_1:
	lw s1, -1036(s0)
	li s2, 1024
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L29_0
	j .L29_2
.L29_0:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1084(s0)
	lw s2, -1080(s0)
	lw s3, -1076(s0)
	lw s4, -1072(s0)
	lw s5, -1068(s0)
	lw s6, -1064(s0)
	lw s7, -1060(s0)
	lw s8, -1056(s0)
	lw s9, -1052(s0)
	lw s10, -1048(s0)
	lw s11, -1044(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L29_2:
	addi s1, s0, -1032
	lw s2, -4(s0)
	mv a0, s2
	jal ra, kp_str_bytes
	mv s3, a0
	lw s2, -1036(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	addi s2, s0, -1032
	lw s3, -1036(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -1032
	li s2, 1
	li s3, 64
	or s4, s2, s3
	li s2, 512
	or s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, kpio_open
	mv s2, a0
	mv a0, s2
	lw s1, -1084(s0)
	lw s2, -1080(s0)
	lw s3, -1076(s0)
	lw s4, -1072(s0)
	lw s5, -1068(s0)
	lw s6, -1064(s0)
	lw s7, -1060(s0)
	lw s8, -1056(s0)
	lw s9, -1052(s0)
	lw s10, -1048(s0)
	lw s11, -1044(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end29:
	.size kpf_open_write, .Lfunc_end29-kpf_open_write

	.text
	.align 2
	.globl kpf_read
	.type kpf_read, @function
kpf_read:
	li t6, -4176
	add sp, sp, t6
	li t6, 4172
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 4168
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 4168
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
	lw s1, -4(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L30_0
	j .L30_1
.L30_0:
	li s1, 1
	neg s2, s1
	li t6, -4112
	add t6, s0, t6
	sw s2, 0(t6)
	j .L30_2
.L30_1:
	lw s1, -4(s0)
	li t6, -4104
	add s2, s0, t6
	li s3, 4096
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, kpio_read
	mv s4, a0
	li t6, -4112
	add t6, s0, t6
	sw s4, 0(t6)
.L30_2:
	li t6, -4112
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4108
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -4108
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L30_3
	j .L30_4
.L30_3:
	la s1, __str_4
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
	li t6, -4156
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4136
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4132
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4128
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4124
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4120
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4116
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L30_4:
	li t6, -4104
	add s1, s0, t6
	li t6, -4108
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
	li t6, -4156
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4136
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4132
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4128
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4124
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4120
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4116
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end30:
	.size kpf_read, .Lfunc_end30-kpf_read

	.text
	.align 2
	.globl kpf_write
	.type kpf_write, @function
kpf_write:
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
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L31_0
	j .L31_1
.L31_0:
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
.L31_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s2
	jal ra, kp_str_bytes
	mv s3, a0
	lw s2, -8(s0)
	mv a0, s2
	jal ra, kp_str_len
	mv s4, a0
	mv a0, s1
	mv a1, s3
	mv a2, s4
	jal ra, kpio_write
	mv s2, a0
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
.Lfunc_end31:
	.size kpf_write, .Lfunc_end31-kpf_write

	.text
	.align 2
	.globl kpf_close
	.type kpf_close, @function
kpf_close:
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
	bnez s3, .L32_0
	j .L32_1
.L32_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kpio_close
	mv s2, a0
.L32_1:
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
.Lfunc_end32:
	.size kpf_close, .Lfunc_end32-kpf_close

	.text
	.align 2
	.globl kpd_open
	.type kpd_open, @function
kpd_open:
	addi sp, sp, -1104
	sw ra, 1100(sp)
	sw s0, 1096(sp)
	addi s0, sp, 1096
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
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -1036(s0)
	lw s1, -1036(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L33_0
	j .L33_1
.L33_1:
	lw s1, -1036(s0)
	li s2, 1024
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L33_0
	j .L33_2
.L33_0:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L33_2:
	addi s1, s0, -1032
	lw s2, -4(s0)
	mv a0, s2
	jal ra, kp_str_bytes
	mv s3, a0
	lw s2, -1036(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	addi s2, s0, -1032
	lw s3, -1036(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	sw s1, -1040(s0)
.L33_3:
	lw s1, -1040(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L33_4
	j .L33_5
.L33_4:
	la s1, kpd_tab
	lw s2, -1040(s0)
	li s3, 2064
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L33_6
	j .L33_7
.L33_7:
	j .L33_5
.L33_6:
.L33_8:
	addi s1, s0, -1040
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1040(s0)
	j .L33_3
.L33_5:
	lw s1, -1040(s0)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L33_9
	j .L33_10
.L33_9:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L33_10:
	addi s1, s0, -1032
	li s2, 65536
	li s3, 0
	or s4, s2, s3
	li s2, 0
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fs_open
	mv s3, a0
	sw s3, -1044(s0)
	lw s1, -1044(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L33_11
	j .L33_12
.L33_11:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L33_12:
	lw s1, -1044(s0)
	la s2, kpd_tab
	lw s3, -1040(s0)
	li s4, 2064
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1
	la s2, kpd_tab
	lw s3, -1040(s0)
	li s4, 2064
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	la s2, kpd_tab
	lw s3, -1040(s0)
	li s4, 2064
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	la s2, kpd_tab
	lw s3, -1040(s0)
	li s4, 2064
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -1040(s0)
	mv a0, s1
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end33:
	.size kpd_open, .Lfunc_end33-kpd_open

	.text
	.align 2
	.globl kpd_next
	.type kpd_next, @function
kpd_next:
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
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L34_0
	j .L34_1
.L34_1:
	lw s1, -4(s0)
	li s2, 8
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L34_0
	j .L34_2
.L34_2:
	la s1, kpd_tab
	lw s2, -4(s0)
	li s3, 2064
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L34_3
	j .L34_0
.L34_0:
	la s1, __str_5
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
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
.L34_3:
	li s1, 0
	sw s1, -76(s0)
	la s1, kpd_tab
	lw s2, -4(s0)
	li s3, 2064
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -72
	li s3, 64
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fs_read
	mv s4, a0
	li s1, 64
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L34_4
	j .L34_5
.L34_4:
	la s1, __str_6
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
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
.L34_5:
.L34_6:
	lw s1, -76(s0)
	li s2, 56
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L34_7
	j .L34_8
.L34_7:
	addi s1, s0, -72
	li s2, 8
	add s3, s1, s2
	lw s1, -76(s0)
	add s2, s3, s1
	lb s1, 0(s2)
	bnez s1, .L34_9
	j .L34_8
.L34_9:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
	j .L34_6
.L34_8:
	addi s1, s0, -72
	li s2, 8
	add s3, s1, s2
	lw s1, -76(s0)
	mv a0, s3
	mv a1, s1
	jal ra, kp_str_new
	mv s2, a0
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
.Lfunc_end34:
	.size kpd_next, .Lfunc_end34-kpd_next

	.text
	.align 2
	.globl kpd_close
	.type kpd_close, @function
kpd_close:
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
	bnez s3, .L35_0
	j .L35_1
.L35_0:
	lw s1, -4(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L35_2
	j .L35_1
.L35_2:
	la s1, kpd_tab
	lw s2, -4(s0)
	li s3, 2064
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L35_3
	j .L35_1
.L35_3:
	la s1, kpd_tab
	lw s2, -4(s0)
	li s3, 2064
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, kpio_close
	mv s2, a0
	li s1, 0
	la s2, kpd_tab
	lw s3, -4(s0)
	li s4, 2064
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
.L35_1:
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
.Lfunc_end35:
	.size kpd_close, .Lfunc_end35-kpd_close

	.data
	.align 2
__str_6:
	.ascii "\000"
	.align 2
__str_5:
	.ascii "\000"
	.align 2
__str_4:
	.ascii "\000"
	.align 2
__str_3:
	.ascii "\000"
	.align 2
__str_2:
	.ascii "\000"
	.align 2
__str_1:
	.ascii "\000"
	.align 2
__str_0:
	.ascii "\000"

	.bss
	.align 2
	.globl kpd_tab
kpd_tab:
	.space 16512
	.align 2
	.globl environ
environ:
	.space 4
	.align 2
	.globl g_argv
g_argv:
	.space 4
	.align 2
	.globl g_argc
g_argc:
	.space 4
