# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type skip_ws, @function
skip_ws:
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
.L1_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isspace
	mv s1, a0
	bnez s1, .L1_1
	j .L1_2
.L1_1:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L1_0
.L1_2:
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
.Lfunc_end1:
	.size skip_ws, .Lfunc_end1-skip_ws

	.text
	.align 2
	.type scan_uint, @function
scan_uint:
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
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, skip_ws
	mv s1, a0
	sw s1, -28(s0)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -40(s0)
	sw s11, -36(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L2_0
	j .L2_1
.L2_0:
	lw s1, -8(s0)
	sw s1, -48(s0)
	j .L2_2
.L2_1:
	li s1, 2147483647
	sw s1, -48(s0)
.L2_2:
	lw s1, -48(s0)
	sw s1, -44(s0)
	li s1, 0
	sw s1, -52(s0)
	li s1, 0
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L2_3
	j .L2_4
.L2_3:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L2_5
	j .L2_6
.L2_6:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L2_5
	j .L2_4
.L2_5:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	lw s1, -16(s0)
	sw s3, 0(s1)
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -44(s0)
.L2_4:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_7
	j .L2_8
.L2_8:
	lw s1, -12(s0)
	li s2, 16
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_7
	j .L2_9
.L2_7:
	lw s1, -44(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_10
	j .L2_9
.L2_10:
	lw s1, -28(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_11
	j .L2_9
.L2_11:
	lw s1, -28(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_12
	j .L2_13
.L2_13:
	lw s1, -28(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_12
	j .L2_9
.L2_12:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	sw s3, -28(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 2
	sub s3, s2, s1
	sw s3, -44(s0)
	li s1, 16
	sw s1, -12(s0)
	j .L2_14
.L2_9:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_15
	j .L2_16
.L2_15:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L2_17
	j .L2_16
.L2_17:
	li s1, 8
	sw s1, -12(s0)
	j .L2_18
.L2_16:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_19
	j .L2_20
.L2_19:
	li s1, 10
	sw s1, -12(s0)
.L2_20:
.L2_18:
.L2_14:
.L2_21:
	lw s1, -44(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L2_22
	j .L2_23
.L2_22:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	sw s3, -56(s0)
	lw s1, -56(s0)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_24
	j .L2_25
.L2_24:
	lw s1, -56(s0)
	li s2, 57
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L2_26
	j .L2_25
.L2_26:
	lw s1, -56(s0)
	li s2, 48
	sub s3, s1, s2
	sw s3, -60(s0)
	j .L2_27
.L2_25:
	lw s1, -56(s0)
	li s2, 97
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_28
	j .L2_29
.L2_28:
	lw s1, -56(s0)
	li s2, 122
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L2_30
	j .L2_29
.L2_30:
	lw s1, -56(s0)
	li s2, 97
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -60(s0)
	j .L2_31
.L2_29:
	lw s1, -56(s0)
	li s2, 65
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_32
	j .L2_33
.L2_32:
	lw s1, -56(s0)
	li s2, 90
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L2_34
	j .L2_33
.L2_34:
	lw s1, -56(s0)
	li s2, 65
	sub s3, s1, s2
	li s1, 10
	add s2, s3, s1
	sw s2, -60(s0)
	j .L2_35
.L2_33:
	j .L2_23
.L2_35:
.L2_31:
.L2_27:
	lw s1, -60(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_36
	j .L2_37
.L2_36:
	j .L2_23
.L2_37:
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw s1, -12(s0)
	mv s8, s1
	li s9, 0
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
	li s11, 0
	add s8, s6, s10
	sltu t0, s8, s10
	add s9, s7, t0
	add s9, s9, s11
	sw s8, -40(s0)
	sw s9, -36(s0)
	li s1, 1
	sw s1, -52(s0)
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L2_21
.L2_23:
	lw s1, -52(s0)
	bnez s1, .L2_38
	j .L2_39
.L2_39:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, skip_ws
	mv s1, a0
	lw s2, -4(s0)
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
.L2_38:
	lw s1, -28(s0)
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw s1, -20(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	li s1, 1
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
	.size scan_uint, .Lfunc_end2-scan_uint

	.text
	.align 2
	.globl vsscanf
	.type vsscanf, @function
vsscanf:
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
	fsd fs0, 56(sp)
	fsd fs1, 64(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	sw s1, -20(s0)
	lw s1, -8(s0)
	sw s1, -24(s0)
	li s1, 0
	sw s1, -28(s0)
.L3_0:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L3_1
	j .L3_2
.L3_1:
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -40(s0)
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isspace
	mv s1, a0
	bnez s1, .L3_3
	j .L3_4
.L3_3:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -20(s0)
	j .L3_0
.L3_4:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L3_5
	j .L3_6
.L3_5:
	lw s1, -20(s0)
	lb s2, 0(s1)
	lw s1, -24(s0)
	lb s3, 0(s1)
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L3_7
	j .L3_8
.L3_7:
	lw s1, -28(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L3_0
.L3_6:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_9
	j .L3_10
.L3_9:
	li s1, 1
	sw s1, -32(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
.L3_10:
.L3_11:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_12
	j .L3_13
.L3_12:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_14
	j .L3_13
.L3_14:
	lw s1, -36(s0)
	li s2, 10
	mul s3, s1, s2
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -24(s0)
	lb s1, 0(s2)
	li s2, 48
	sub s4, s1, s2
	add s1, s3, s4
	sw s1, -36(s0)
	j .L3_11
.L3_13:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 104
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_15
	j .L3_16
.L3_15:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 104
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_17
	j .L3_18
.L3_17:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
.L3_18:
	j .L3_19
.L3_16:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 108
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_20
	j .L3_21
.L3_20:
	li s1, 1
	sw s1, -40(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 108
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_22
	j .L3_23
.L3_22:
	li s1, 2
	sw s1, -40(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
.L3_23:
	j .L3_24
.L3_21:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 76
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_25
	j .L3_26
.L3_25:
	li s1, 1
	sw s1, -40(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L3_27
.L3_26:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 122
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_28
	j .L3_29
.L3_29:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 106
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_28
	j .L3_30
.L3_30:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 116
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_28
	j .L3_31
.L3_28:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_32
	j .L3_33
.L3_32:
	li s1, 2
	sw s1, -48(s0)
	j .L3_34
.L3_33:
	li s1, 1
	sw s1, -48(s0)
.L3_34:
	lw s1, -48(s0)
	sw s1, -40(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
.L3_31:
.L3_27:
.L3_24:
.L3_19:
	lw s1, -24(s0)
	lb s2, 0(s1)
	sw s2, -44(s0)
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_35
	j .L3_36
.L3_35:
	j .L3_2
.L3_36:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_37
	j .L3_38
.L3_37:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L3_39
	j .L3_40
.L3_39:
	lw s1, -28(s0)
	bnez s1, .L3_41
	j .L3_42
.L3_41:
	lw s1, -28(s0)
	sw s1, -52(s0)
	j .L3_43
.L3_42:
	li s1, 1
	neg s2, s1
	sw s2, -52(s0)
.L3_43:
	lw s1, -52(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_40:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L3_0
.L3_38:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 99
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_44
	j .L3_45
.L3_44:
	lw s1, -36(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_46
	j .L3_47
.L3_46:
	lw s1, -36(s0)
	sw s1, -60(s0)
	j .L3_48
.L3_47:
	li s1, 1
	sw s1, -60(s0)
.L3_48:
	lw s1, -60(s0)
	sw s1, -56(s0)
	li s1, 0
	sw s1, -64(s0)
.L3_49:
	lw s1, -64(s0)
	lw s2, -56(s0)
	slt s3, s1, s2
	bnez s3, .L3_50
	j .L3_51
.L3_50:
	lw s1, -20(s0)
	lw s2, -64(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L3_52
	j .L3_53
.L3_53:
	j .L3_51
.L3_52:
.L3_54:
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -64(s0)
	j .L3_49
.L3_51:
	lw s1, -64(s0)
	lw s2, -56(s0)
	slt s3, s1, s2
	bnez s3, .L3_55
	j .L3_56
.L3_55:
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_57
	j .L3_58
.L3_57:
	li s1, 1
	neg s2, s1
	sw s2, -68(s0)
	j .L3_59
.L3_58:
	lw s1, -28(s0)
	sw s1, -68(s0)
.L3_59:
	lw s1, -68(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_56:
	lw s1, -32(s0)
	bnez s1, .L3_60
	j .L3_61
.L3_61:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	sw s1, -72(s0)
	li s1, 0
	sw s1, -64(s0)
.L3_62:
	lw s1, -64(s0)
	lw s2, -56(s0)
	slt s3, s1, s2
	bnez s3, .L3_63
	j .L3_64
.L3_63:
	lw s1, -20(s0)
	lw s2, -64(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	lw s2, -72(s0)
	lw s3, -64(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L3_65:
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -64(s0)
	j .L3_62
.L3_64:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
.L3_60:
	addi s1, s0, -20
	lw s2, 0(s1)
	lw s1, -56(s0)
	add s3, s2, s1
	sw s3, -20(s0)
	j .L3_0
.L3_45:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 115
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_66
	j .L3_67
.L3_66:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -76(s0)
	lw s1, -36(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_68
	j .L3_69
.L3_68:
	lw s1, -36(s0)
	sw s1, -84(s0)
	j .L3_70
.L3_69:
	li s1, 2147483647
	sw s1, -84(s0)
.L3_70:
	lw s1, -84(s0)
	sw s1, -80(s0)
	li s1, 0
	sw s1, -88(s0)
	lw s1, -76(s0)
	lb s2, 0(s1)
	bnez s2, .L3_71
	j .L3_72
.L3_72:
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_73
	j .L3_74
.L3_73:
	li s1, 1
	neg s2, s1
	sw s2, -92(s0)
	j .L3_75
.L3_74:
	lw s1, -28(s0)
	sw s1, -92(s0)
.L3_75:
	lw s1, -92(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_71:
	lw s1, -32(s0)
	bnez s1, .L3_76
	j .L3_77
.L3_77:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	sw s1, -96(s0)
.L3_78:
	lw s1, -76(s0)
	lw s2, -88(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L3_79
	j .L3_80
.L3_79:
	lw s1, -76(s0)
	lw s2, -88(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isspace
	mv s1, a0
	bnez s1, .L3_80
	j .L3_81
.L3_81:
	lw s1, -88(s0)
	lw s2, -80(s0)
	slt s3, s1, s2
	bnez s3, .L3_82
	j .L3_80
.L3_82:
	lw s1, -76(s0)
	lw s2, -88(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	lw s2, -96(s0)
	lw s3, -88(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -88
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -88(s0)
	j .L3_78
.L3_80:
	li s1, 0
	lw s2, -96(s0)
	lw s3, -88(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L3_83
.L3_76:
.L3_84:
	lw s1, -76(s0)
	lw s2, -88(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L3_85
	j .L3_86
.L3_85:
	lw s1, -76(s0)
	lw s2, -88(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
	jal ra, isspace
	mv s1, a0
	bnez s1, .L3_86
	j .L3_87
.L3_87:
	lw s1, -88(s0)
	lw s2, -80(s0)
	slt s3, s1, s2
	bnez s3, .L3_88
	j .L3_86
.L3_88:
	addi s1, s0, -88
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -88(s0)
	j .L3_84
.L3_86:
.L3_83:
	lw s1, -76(s0)
	lw s2, -88(s0)
	add s3, s1, s2
	sw s3, -20(s0)
	j .L3_0
.L3_67:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 100
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_89
	j .L3_90
.L3_90:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 105
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_89
	j .L3_91
.L3_91:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 117
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_89
	j .L3_92
.L3_92:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 111
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_89
	j .L3_93
.L3_93:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 120
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_89
	j .L3_94
.L3_94:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 88
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_89
	j .L3_95
.L3_95:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 112
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_89
	j .L3_96
.L3_89:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 100
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_97
	j .L3_98
.L3_98:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 117
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_97
	j .L3_99
.L3_97:
	li s1, 10
	sw s1, -104(s0)
	j .L3_100
.L3_99:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 105
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_101
	j .L3_102
.L3_101:
	li s1, 0
	sw s1, -108(s0)
	j .L3_103
.L3_102:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 111
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_104
	j .L3_105
.L3_104:
	li s1, 8
	sw s1, -112(s0)
	j .L3_106
.L3_105:
	li s1, 16
	sw s1, -112(s0)
.L3_106:
	lw s1, -112(s0)
	sw s1, -108(s0)
.L3_103:
	lw s1, -108(s0)
	sw s1, -104(s0)
.L3_100:
	lw s1, -104(s0)
	sw s1, -100(s0)
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 100
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_107
	j .L3_108
.L3_108:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 105
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_107
	j .L3_109
.L3_107:
	li s1, 1
	j .L3_110
.L3_109:
	li s1, 0
.L3_110:
	sw s1, -116(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -140(s0)
	addi s1, s0, -20
	lw s2, -36(s0)
	lw s3, -100(s0)
	addi s4, s0, -120
	addi s5, s0, -128
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, scan_uint
	mv s6, a0
	bnez s6, .L3_111
	j .L3_112
.L3_112:
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_113
	j .L3_114
.L3_113:
	lw s1, -140(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_115
	j .L3_114
.L3_115:
	li s1, 1
	neg s2, s1
	sw s2, -144(s0)
	j .L3_116
.L3_114:
	lw s1, -28(s0)
	sw s1, -144(s0)
.L3_116:
	lw s1, -144(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_111:
	lw s1, -120(s0)
	bnez s1, .L3_117
	j .L3_118
.L3_117:
	lw s10, -128(s0)
	lw s11, -124(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -152(s0)
	sw s9, -148(s0)
	j .L3_119
.L3_118:
	lw s10, -128(s0)
	lw s11, -124(s0)
	sw s10, -152(s0)
	sw s11, -148(s0)
.L3_119:
	lw s10, -152(s0)
	lw s11, -148(s0)
	sw s10, -136(s0)
	sw s11, -132(s0)
	lw s1, -32(s0)
	bnez s1, .L3_120
	j .L3_121
.L3_121:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 112
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_122
	j .L3_123
.L3_122:
	lw s10, -136(s0)
	lw s11, -132(s0)
	mv s1, s10
	lw s2, -12(s0)
	li s3, 0
	mv a0, s2
	mv a1, s3
	jal ra, __va_arg
	mv s4, a0
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L3_124
.L3_123:
	lw s1, -116(s0)
	bnez s1, .L3_125
	j .L3_126
.L3_125:
	lw s1, -40(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_127
	j .L3_128
.L3_127:
	lw s10, -136(s0)
	lw s11, -132(s0)
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L3_129
.L3_128:
	lw s1, -40(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_130
	j .L3_131
.L3_130:
	lw s10, -136(s0)
	lw s11, -132(s0)
	mv s1, s10
	lw s2, -12(s0)
	li s3, 0
	mv a0, s2
	mv a1, s3
	jal ra, __va_arg
	mv s4, a0
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L3_132
.L3_131:
	lw s10, -136(s0)
	lw s11, -132(s0)
	mv s1, s10
	lw s2, -12(s0)
	li s3, 0
	mv a0, s2
	mv a1, s3
	jal ra, __va_arg
	mv s4, a0
	lw s2, 0(s4)
	sw s1, 0(s2)
.L3_132:
.L3_129:
	j .L3_133
.L3_126:
	lw s1, -40(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_134
	j .L3_135
.L3_134:
	lw s10, -136(s0)
	lw s11, -132(s0)
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L3_136
.L3_135:
	lw s1, -40(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_137
	j .L3_138
.L3_137:
	lw s10, -136(s0)
	lw s11, -132(s0)
	mv s1, s10
	lw s2, -12(s0)
	li s3, 0
	mv a0, s2
	mv a1, s3
	jal ra, __va_arg
	mv s4, a0
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L3_139
.L3_138:
	lw s10, -136(s0)
	lw s11, -132(s0)
	mv s1, s10
	lw s2, -12(s0)
	li s3, 0
	mv a0, s2
	mv a1, s3
	jal ra, __va_arg
	mv s4, a0
	lw s2, 0(s4)
	sw s1, 0(s2)
.L3_139:
.L3_136:
.L3_133:
.L3_124:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
.L3_120:
	j .L3_0
.L3_96:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 102
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_140
	j .L3_141
.L3_141:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 101
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_140
	j .L3_142
.L3_142:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 103
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_140
	j .L3_143
.L3_143:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 69
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_140
	j .L3_144
.L3_144:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 71
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_140
	j .L3_145
.L3_145:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 97
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_140
	j .L3_146
.L3_146:
	addi s1, s0, -44
	lb s2, 0(s1)
	li s1, 65
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_140
	j .L3_147
.L3_140:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -156(s0)
	lw s1, -156(s0)
	lb s2, 0(s1)
	bnez s2, .L3_148
	j .L3_149
.L3_149:
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_150
	j .L3_151
.L3_150:
	li s1, 1
	neg s2, s1
	sw s2, -172(s0)
	j .L3_152
.L3_151:
	lw s1, -28(s0)
	sw s1, -172(s0)
.L3_152:
	lw s1, -172(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_148:
	lw s1, -156(s0)
	addi s2, s0, -160
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	jal ra, strtod
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -168(s0)
	lw s1, -160(s0)
	lw s2, -156(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_153
	j .L3_154
.L3_153:
	lw s1, -28(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_154:
	lw s1, -160(s0)
	sw s1, -20(s0)
	lw s1, -32(s0)
	bnez s1, .L3_155
	j .L3_156
.L3_156:
	lw s1, -40(s0)
	li s2, 1
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_157
	j .L3_158
.L3_157:
	fld fs0, -168(s0)
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	fsd fs0, 0(s1)
	j .L3_159
.L3_158:
	fld fs0, -168(s0)
	fcvt.s.d fs1, fs0
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	fsw fs1, 0(s1)
.L3_159:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
.L3_155:
	j .L3_0
.L3_147:
	lw s1, -28(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	j .L3_0
.L3_2:
	lw s1, -28(s0)
	mv a0, s1
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
	fld fs0, -192(s0)
	fld fs1, -184(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size vsscanf, .Lfunc_end3-vsscanf

	.text
	.align 2
	.globl sscanf
	.type sscanf, @function
sscanf:
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
	addi s1, s0, -24
	addi t0, s0, 8
	sw t0, 8(s1)
	sw zero, 0(s1)
	sw zero, 4(s1)
	sw zero, 12(s1)
	li s1, 0
	lw s1, -4(s0)
	lw s2, -8(s0)
	addi s3, s0, -24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, vsscanf
	mv s4, a0
	sw s4, -28(s0)
	li s1, 0
	lw s1, -28(s0)
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
	.size sscanf, .Lfunc_end4-sscanf

	.data
