# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type emit, @function
emit:
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
	lw s2, 0(s1)
	lw s1, -4(s0)
	addi s3, s0, -8
	lb s4, 0(s3)
	mv a0, s1
	mv a1, s4
	mv t0, s2
	jalr ra, t0, 0
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
.Lfunc_end1:
	.size emit, .Lfunc_end1-emit

	.text
	.align 2
	.type emit_pad, @function
emit_pad:
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
.L2_0:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L2_1
	j .L2_2
.L2_1:
	lw s1, -4(s0)
	addi s2, s0, -8
	lb s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit
	mv s2, a0
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
	.size emit_pad, .Lfunc_end2-emit_pad

	.text
	.align 2
	.type fmt_number, @function
fmt_number:
	addi sp, sp, -192
	sw ra, 188(sp)
	sw s0, 184(sp)
	addi s0, sp, 184
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	sw a3, -20(s0)
	sw a4, -24(s0)
	sw a5, -28(s0)
	sw a6, -32(s0)
	sw a7, -36(s0)
	lw s1, -24(s0)
	bnez s1, .L3_0
	j .L3_1
.L3_0:
	la s1, __str_0
	sw s1, -72(s0)
	j .L3_2
.L3_1:
	la s1, __str_1
	sw s1, -72(s0)
.L3_2:
	lw s1, -72(s0)
	sw s1, -68(s0)
	li s1, 0
	sw s1, -76(s0)
	li s1, 0
	sw s1, -80(s0)
	li s1, 0
	sw s1, -88(s0)
	lw s1, -28(s0)
	bnez s1, .L3_3
	j .L3_4
.L3_3:
	li s1, 45
	sw s1, -80(s0)
	j .L3_5
.L3_4:
	lw s1, -32(s0)
	li s2, 4
	and s3, s1, s2
	bnez s3, .L3_6
	j .L3_7
.L3_6:
	li s1, 43
	sw s1, -80(s0)
	j .L3_8
.L3_7:
	lw s1, -32(s0)
	li s2, 8
	and s3, s1, s2
	bnez s3, .L3_9
	j .L3_10
.L3_9:
	li s1, 32
	sw s1, -80(s0)
.L3_10:
.L3_8:
.L3_5:
.L3_11:
	lw s1, -68(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s2, -20(s0)
	mv s8, s2
	srai s9, s8, 31
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __umoddi3
	mv s6, a0
	mv s7, a1
	mv s2, s6
	add s3, s1, s2
	lb s1, 0(s3)
	addi s2, s0, -64
	addi s3, s0, -76
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -76(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -20(s0)
	mv s8, s1
	srai s9, s8, 31
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __udivdi3
	mv s6, a0
	mv s7, a1
	sw s6, -16(s0)
	sw s7, -12(s0)
.L3_12:
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L3_11
	j .L3_13
.L3_13:
	lw s1, -32(s0)
	li s2, 16
	and s3, s1, s2
	bnez s3, .L3_14
	j .L3_15
.L3_14:
	lw s1, -20(s0)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_16
	j .L3_17
.L3_16:
	addi s1, s0, -64
	lw s2, -76(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 48
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_18
	j .L3_17
.L3_18:
	li s1, 48
	addi s2, s0, -84
	addi s3, s0, -88
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -88(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L3_19
.L3_17:
	lw s1, -20(s0)
	li s2, 16
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_20
	j .L3_21
.L3_20:
	li s1, 48
	addi s2, s0, -84
	addi s3, s0, -88
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -88(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -24(s0)
	bnez s1, .L3_22
	j .L3_23
.L3_22:
	li s1, 88
	sw s1, -104(s0)
	j .L3_24
.L3_23:
	li s1, 120
	sw s1, -104(s0)
.L3_24:
	lw s1, -104(s0)
	addi s2, s0, -84
	addi s3, s0, -88
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -88(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L3_21:
.L3_19:
.L3_15:
	li s1, 0
	sw s1, -92(s0)
	lw s1, 8(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_25
	j .L3_26
.L3_25:
	lw s1, 8(s0)
	lw s2, -76(s0)
	slt s3, s2, s1
	bnez s3, .L3_27
	j .L3_28
.L3_27:
	lw s1, 8(s0)
	lw s2, -76(s0)
	sub s3, s1, s2
	sw s3, -92(s0)
.L3_28:
	j .L3_29
.L3_26:
	lw s1, -32(s0)
	li s2, 2
	and s3, s1, s2
	bnez s3, .L3_30
	j .L3_31
.L3_30:
	lw s1, -32(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L3_31
	j .L3_32
.L3_32:
	lw s1, -76(s0)
	addi s2, s0, -80
	lb s3, 0(s2)
	bnez s3, .L3_33
	j .L3_34
.L3_33:
	li s2, 1
	sw s2, -112(s0)
	j .L3_35
.L3_34:
	li s2, 0
	sw s2, -112(s0)
.L3_35:
	lw s2, -112(s0)
	add s3, s1, s2
	lw s1, -88(s0)
	add s2, s3, s1
	sw s2, -108(s0)
	lw s1, -36(s0)
	lw s2, -108(s0)
	slt s3, s2, s1
	bnez s3, .L3_36
	j .L3_37
.L3_36:
	lw s1, -36(s0)
	lw s2, -108(s0)
	sub s3, s1, s2
	sw s3, -92(s0)
.L3_37:
.L3_31:
.L3_29:
	lw s1, -76(s0)
	lw s2, -92(s0)
	add s3, s1, s2
	lw s1, -88(s0)
	add s2, s3, s1
	addi s1, s0, -80
	lb s3, 0(s1)
	bnez s3, .L3_38
	j .L3_39
.L3_38:
	li s1, 1
	sw s1, -116(s0)
	j .L3_40
.L3_39:
	li s1, 0
	sw s1, -116(s0)
.L3_40:
	lw s1, -116(s0)
	add s3, s2, s1
	sw s3, -96(s0)
	lw s1, -36(s0)
	lw s2, -96(s0)
	slt s3, s2, s1
	bnez s3, .L3_41
	j .L3_42
.L3_41:
	lw s1, -36(s0)
	lw s2, -96(s0)
	sub s3, s1, s2
	sw s3, -120(s0)
	j .L3_43
.L3_42:
	li s1, 0
	sw s1, -120(s0)
.L3_43:
	lw s1, -120(s0)
	sw s1, -100(s0)
	lw s1, -32(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L3_44
	j .L3_45
.L3_45:
	lw s1, -4(s0)
	li s2, 32
	lw s3, -100(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
.L3_44:
	addi s1, s0, -80
	lb s2, 0(s1)
	bnez s2, .L3_46
	j .L3_47
.L3_46:
	lw s1, -4(s0)
	addi s2, s0, -80
	lb s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit
	mv s2, a0
.L3_47:
	li s1, 0
	sw s1, -124(s0)
.L3_48:
	lw s1, -124(s0)
	lw s2, -88(s0)
	slt s3, s1, s2
	bnez s3, .L3_49
	j .L3_50
.L3_49:
	lw s1, -4(s0)
	addi s2, s0, -84
	lw s3, -124(s0)
	add s4, s2, s3
	lb s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, emit
	mv s3, a0
.L3_51:
	addi s1, s0, -124
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -124(s0)
	j .L3_48
.L3_50:
	lw s1, -4(s0)
	li s2, 48
	lw s3, -92(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
.L3_52:
	lw s1, -76(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_53
	j .L3_54
.L3_53:
	lw s1, -4(s0)
	addi s2, s0, -64
	addi s3, s0, -76
	lw s4, 0(s3)
	li s3, -1
	add s5, s4, s3
	sw s5, -76(s0)
	add s3, s2, s5
	lb s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, emit
	mv s3, a0
	j .L3_52
.L3_54:
	lw s1, -32(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L3_55
	j .L3_56
.L3_55:
	lw s1, -4(s0)
	li s2, 32
	lw s3, -100(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
.L3_56:
	li s1, 0
	mv a0, s1
	lw s1, -172(s0)
	lw s2, -168(s0)
	lw s3, -164(s0)
	lw s4, -160(s0)
	lw s5, -156(s0)
	lw s6, -152(s0)
	lw s7, -148(s0)
	lw s8, -144(s0)
	lw s9, -140(s0)
	lw s10, -136(s0)
	lw s11, -132(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size fmt_number, .Lfunc_end3-fmt_number

	.text
	.align 2
	.type fmt_str, @function
fmt_str:
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
	sw s1, -28(s0)
	lw s1, -8(s0)
	bnez s1, .L4_0
	j .L4_1
.L4_1:
	la s1, __str_2
	sw s1, -8(s0)
.L4_0:
.L4_2:
	lw s1, -8(s0)
	lw s2, -28(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L4_3
	j .L4_4
.L4_3:
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L4_5
	j .L4_6
.L4_6:
	lw s1, -28(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L4_5
	j .L4_4
.L4_5:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L4_2
.L4_4:
	lw s1, -16(s0)
	lw s2, -28(s0)
	slt s3, s2, s1
	bnez s3, .L4_7
	j .L4_8
.L4_7:
	lw s1, -16(s0)
	lw s2, -28(s0)
	sub s3, s1, s2
	sw s3, -36(s0)
	j .L4_9
.L4_8:
	li s1, 0
	sw s1, -36(s0)
.L4_9:
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s1, -12(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L4_10
	j .L4_11
.L4_11:
	lw s1, -4(s0)
	li s2, 32
	lw s3, -32(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
.L4_10:
	li s1, 0
	sw s1, -40(s0)
.L4_12:
	lw s1, -40(s0)
	lw s2, -28(s0)
	slt s3, s1, s2
	bnez s3, .L4_13
	j .L4_14
.L4_13:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -40(s0)
	add s4, s2, s3
	lb s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, emit
	mv s3, a0
.L4_15:
	addi s1, s0, -40
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -40(s0)
	j .L4_12
.L4_14:
	lw s1, -12(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L4_16
	j .L4_17
.L4_16:
	lw s1, -4(s0)
	li s2, 32
	lw s3, -32(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
.L4_17:
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
.Lfunc_end4:
	.size fmt_str, .Lfunc_end4-fmt_str

	.text
	.align 2
	.type put_uint, @function
put_uint:
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
	sw a2, -16(s0)
	sw a3, -12(s0)
	lw s1, -8(s0)
	lw s2, -4(s0)
	lw s3, -8(s0)
	add s4, s2, s3
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s4
	mv a1, s10
	mv a2, s11
	jal ra, __fmt_udec
	mv s2, a0
	add s3, s1, s2
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
.Lfunc_end5:
	.size put_uint, .Lfunc_end5-put_uint

	.text
	.align 2
	.type build_fixed, @function
build_fixed:
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
	fsd fs0, 56(sp)
	fsd fs1, 64(sp)
	fsd fs2, 72(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -16(s0)
	sw a3, -12(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	la s1, __flt_3
	fld fs0, 0(s1)
	fsd fs0, -32(s0)
	li s1, 0
	sw s1, -52(s0)
.L6_0:
	lw s1, -52(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L6_1
	j .L6_2
.L6_1:
	addi s1, s0, -32
	fld fs0, 0(s1)
	la s1, __flt_4
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -32(s0)
.L6_3:
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -52(s0)
	j .L6_0
.L6_2:
	addi s1, s0, -16
	fld fs0, 0(s1)
	fld fs1, -32(s0)
	fadd.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	fld fs0, -16(s0)
	fcvt.w.d s1, fs0, rtz
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	fld fs0, -16(s0)
	lw s10, -48(s0)
	lw s11, -44(s0)
	mv s1, s10
	fcvt.d.w fs1, s1
	fsub.d fs2, fs0, fs1
	fsd fs2, -40(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s10, -48(s0)
	lw s11, -44(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s10
	mv a3, s11
	jal ra, put_uint
	mv s3, a0
	sw s3, -8(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L6_4
	j .L6_5
.L6_5:
	lw s1, -24(s0)
	li s2, 16
	and s3, s1, s2
	bnez s3, .L6_4
	j .L6_6
.L6_4:
	li s1, 46
	lw s2, -4(s0)
	addi s3, s0, -8
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -8(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L6_6:
	li s1, 0
	sw s1, -52(s0)
.L6_7:
	lw s1, -52(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L6_8
	j .L6_9
.L6_8:
	addi s1, s0, -40
	fld fs0, 0(s1)
	la s1, __flt_5
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -40(s0)
	fld fs0, -40(s0)
	fcvt.w.d s1, fs0, rtz
	sw s1, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L6_10
	j .L6_11
.L6_10:
	li s1, 0
	sw s1, -56(s0)
	j .L6_12
.L6_11:
	lw s1, -56(s0)
	li s2, 9
	slt s3, s2, s1
	bnez s3, .L6_13
	j .L6_14
.L6_13:
	li s1, 9
	sw s1, -56(s0)
.L6_14:
.L6_12:
	li s1, 48
	lw s2, -56(s0)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -4(s0)
	addi s2, s0, -8
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -8(s0)
	add s2, s1, s4
	sb s3, 0(s2)
	addi s1, s0, -40
	fld fs0, 0(s1)
	lw s1, -56(s0)
	fcvt.d.w fs1, s1
	fsub.d fs2, fs0, fs1
	fsd fs2, -40(s0)
.L6_15:
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -52(s0)
	j .L6_7
.L6_9:
	lw s1, -8(s0)
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
	fld fs0, -80(s0)
	fld fs1, -72(s0)
	fld fs2, -64(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end6:
	.size build_fixed, .Lfunc_end6-build_fixed

	.text
	.align 2
	.type build_sci, @function
build_sci:
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
	fsd fs1, 64(sp)
	fsd fs2, 72(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -16(s0)
	sw a3, -12(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	sw a6, -28(s0)
	la s1, __flt_6
	fld fs0, 0(s1)
	fsd fs0, -40(s0)
	li s1, 0
	sw s1, -44(s0)
	fld fs0, -16(s0)
	la s1, __flt_7
	fld fs1, 0(s1)
	feq.d s1, fs0, fs1
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_1
.L7_0:
.L7_2:
	fld fs0, -16(s0)
	la s1, __flt_8
	fld fs1, 0(s1)
	fle.d s1, fs1, fs0
	bnez s1, .L7_3
	j .L7_4
.L7_3:
	addi s1, s0, -16
	fld fs0, 0(s1)
	la s1, __flt_9
	fld fs1, 0(s1)
	fdiv.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L7_2
.L7_4:
.L7_5:
	fld fs0, -16(s0)
	la s1, __flt_10
	fld fs1, 0(s1)
	flt.d s1, fs0, fs1
	bnez s1, .L7_6
	j .L7_7
.L7_6:
	addi s1, s0, -16
	fld fs0, 0(s1)
	la s1, __flt_11
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L7_5
.L7_7:
.L7_1:
	li s1, 0
	sw s1, -48(s0)
.L7_8:
	lw s1, -48(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L7_9
	j .L7_10
.L7_9:
	addi s1, s0, -40
	fld fs0, 0(s1)
	la s1, __flt_12
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -40(s0)
.L7_11:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L7_8
.L7_10:
	addi s1, s0, -16
	fld fs0, 0(s1)
	fld fs1, -40(s0)
	fadd.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	fld fs0, -16(s0)
	la s1, __flt_13
	fld fs1, 0(s1)
	fle.d s1, fs1, fs0
	bnez s1, .L7_12
	j .L7_13
.L7_12:
	addi s1, s0, -16
	fld fs0, 0(s1)
	la s1, __flt_14
	fld fs1, 0(s1)
	fdiv.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
.L7_13:
	fld fs0, -16(s0)
	fcvt.w.d s1, fs0, rtz
	sw s1, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_14
	j .L7_15
.L7_14:
	li s1, 0
	sw s1, -52(s0)
	j .L7_16
.L7_15:
	lw s1, -52(s0)
	li s2, 9
	slt s3, s2, s1
	bnez s3, .L7_17
	j .L7_18
.L7_17:
	li s1, 9
	sw s1, -52(s0)
.L7_18:
.L7_16:
	li s1, 48
	lw s2, -52(s0)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -4(s0)
	addi s2, s0, -8
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -8(s0)
	add s2, s1, s4
	sb s3, 0(s2)
	addi s1, s0, -16
	fld fs0, 0(s1)
	lw s1, -52(s0)
	fcvt.d.w fs1, s1
	fsub.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L7_19
	j .L7_20
.L7_20:
	lw s1, -24(s0)
	li s2, 16
	and s3, s1, s2
	bnez s3, .L7_19
	j .L7_21
.L7_19:
	li s1, 46
	lw s2, -4(s0)
	addi s3, s0, -8
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -8(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L7_21:
	li s1, 0
	sw s1, -48(s0)
.L7_22:
	lw s1, -48(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L7_23
	j .L7_24
.L7_23:
	addi s1, s0, -16
	fld fs0, 0(s1)
	la s1, __flt_15
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	fld fs0, -16(s0)
	fcvt.w.d s1, fs0, rtz
	sw s1, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_25
	j .L7_26
.L7_25:
	li s1, 0
	sw s1, -52(s0)
	j .L7_27
.L7_26:
	lw s1, -52(s0)
	li s2, 9
	slt s3, s2, s1
	bnez s3, .L7_28
	j .L7_29
.L7_28:
	li s1, 9
	sw s1, -52(s0)
.L7_29:
.L7_27:
	li s1, 48
	lw s2, -52(s0)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -4(s0)
	addi s2, s0, -8
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -8(s0)
	add s2, s1, s4
	sb s3, 0(s2)
	addi s1, s0, -16
	fld fs0, 0(s1)
	lw s1, -52(s0)
	fcvt.d.w fs1, s1
	fsub.d fs2, fs0, fs1
	fsd fs2, -16(s0)
.L7_30:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L7_22
.L7_24:
	lw s1, -28(s0)
	bnez s1, .L7_31
	j .L7_32
.L7_31:
	li s1, 69
	sw s1, -76(s0)
	j .L7_33
.L7_32:
	li s1, 101
	sw s1, -76(s0)
.L7_33:
	lw s1, -76(s0)
	lw s2, -4(s0)
	addi s3, s0, -8
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -8(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_34
	j .L7_35
.L7_34:
	li s1, 45
	sw s1, -80(s0)
	j .L7_36
.L7_35:
	li s1, 43
	sw s1, -80(s0)
.L7_36:
	lw s1, -80(s0)
	lw s2, -4(s0)
	addi s3, s0, -8
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -8(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_37
	j .L7_38
.L7_37:
	lw s1, -44(s0)
	neg s2, s1
	sw s2, -84(s0)
	j .L7_39
.L7_38:
	lw s1, -44(s0)
	sw s1, -84(s0)
.L7_39:
	lw s1, -84(s0)
	sw s1, -56(s0)
	li s1, 0
	sw s1, -60(s0)
.L7_40:
	li s1, 48
	lw s2, -56(s0)
	li s3, 10
	rem s4, s2, s3
	add s2, s1, s4
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -72
	addi s3, s0, -60
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -60(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 10
	div s3, s2, s1
	sw s3, -56(s0)
.L7_41:
	lw s1, -56(s0)
	bnez s1, .L7_40
	j .L7_42
.L7_42:
.L7_43:
	lw s1, -60(s0)
	li s2, 2
	slt s3, s1, s2
	bnez s3, .L7_44
	j .L7_45
.L7_44:
	li s1, 48
	addi s2, s0, -72
	addi s3, s0, -60
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -60(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L7_43
.L7_45:
.L7_46:
	lw s1, -60(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L7_47
	j .L7_48
.L7_47:
	addi s1, s0, -72
	addi s2, s0, -60
	lw s3, 0(s2)
	li s2, -1
	add s4, s3, s2
	sw s4, -60(s0)
	add s2, s1, s4
	lb s1, 0(s2)
	lw s2, -4(s0)
	addi s3, s0, -8
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -8(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L7_46
.L7_48:
	lw s1, -8(s0)
	mv a0, s1
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
	fld fs1, -104(s0)
	fld fs2, -96(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end7:
	.size build_sci, .Lfunc_end7-build_sci

	.text
	.align 2
	.type fmt_float, @function
fmt_float:
	addi sp, sp, -704
	sw ra, 700(sp)
	sw s0, 696(sp)
	addi s0, sp, 696
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
	fsd fs2, 72(sp)
	sw a0, -4(s0)
	sw a1, -16(s0)
	sw a2, -12(s0)
	sw a3, -20(s0)
	sw a4, -24(s0)
	sw a5, -28(s0)
	sw a6, -32(s0)
	sw a7, -36(s0)
	li s1, 0
	sw s1, -564(s0)
	li s1, 0
	sw s1, -568(s0)
	li s1, 0
	sw s1, -576(s0)
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L8_0
	j .L8_1
.L8_0:
	li s1, 6
	sw s1, -36(s0)
.L8_1:
	lw s1, -36(s0)
	li s2, 400
	slt s3, s2, s1
	bnez s3, .L8_2
	j .L8_3
.L8_2:
	li s1, 400
	sw s1, -36(s0)
.L8_3:
	fld fs0, -16(s0)
	addi s1, s0, -48
	fsd fs0, 0(s1)
	addi s1, s0, -48
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 63
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	mv s1, s8
	sw s1, -572(s0)
	lw s1, -572(s0)
	bnez s1, .L8_4
	j .L8_5
.L8_4:
	fld fs0, -16(s0)
	fneg.d fs1, fs0
	fsd fs1, -16(s0)
.L8_5:
	lw s1, -572(s0)
	bnez s1, .L8_6
	j .L8_7
.L8_6:
	li s1, 45
	sw s1, -568(s0)
	j .L8_8
.L8_7:
	lw s1, -28(s0)
	li s2, 4
	and s3, s1, s2
	bnez s3, .L8_9
	j .L8_10
.L8_9:
	li s1, 43
	sw s1, -568(s0)
	j .L8_11
.L8_10:
	lw s1, -28(s0)
	li s2, 8
	and s3, s1, s2
	bnez s3, .L8_12
	j .L8_13
.L8_12:
	li s1, 32
	sw s1, -568(s0)
.L8_13:
.L8_11:
.L8_8:
	fld fs0, -16(s0)
	fld fs1, -16(s0)
	feq.d s1, fs0, fs1
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_14
	j .L8_15
.L8_14:
	lw s1, -24(s0)
	bnez s1, .L8_16
	j .L8_17
.L8_16:
	la s1, __str_16
	sw s1, -596(s0)
	j .L8_18
.L8_17:
	la s1, __str_17
	sw s1, -596(s0)
.L8_18:
	lw s1, -596(s0)
	sw s1, -592(s0)
	li s1, 0
	sw s1, -580(s0)
.L8_19:
	lw s1, -592(s0)
	lw s2, -580(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L8_20
	j .L8_21
.L8_20:
	lw s1, -592(s0)
	lw s2, -580(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	addi s2, s0, -560
	addi s3, s0, -564
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -564(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L8_22:
	addi s1, s0, -580
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -580(s0)
	j .L8_19
.L8_21:
	li s1, 0
	sw s1, -568(s0)
	li s1, 1
	sw s1, -576(s0)
	j .L8_23
.L8_15:
	fld fs0, -16(s0)
	la s1, __flt_18
	fld fs1, 0(s1)
	flt.d s1, fs1, fs0
	bnez s1, .L8_24
	j .L8_25
.L8_24:
	fld fs0, -16(s0)
	fld fs1, -16(s0)
	fadd.d fs2, fs0, fs1
	fld fs0, -16(s0)
	feq.d s1, fs2, fs0
	bnez s1, .L8_26
	j .L8_25
.L8_26:
	lw s1, -24(s0)
	bnez s1, .L8_27
	j .L8_28
.L8_27:
	la s1, __str_19
	sw s1, -604(s0)
	j .L8_29
.L8_28:
	la s1, __str_20
	sw s1, -604(s0)
.L8_29:
	lw s1, -604(s0)
	sw s1, -600(s0)
	li s1, 0
	sw s1, -580(s0)
.L8_30:
	lw s1, -600(s0)
	lw s2, -580(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L8_31
	j .L8_32
.L8_31:
	lw s1, -600(s0)
	lw s2, -580(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	addi s2, s0, -560
	addi s3, s0, -564
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -564(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L8_33:
	addi s1, s0, -580
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -580(s0)
	j .L8_30
.L8_32:
	li s1, 1
	sw s1, -576(s0)
	j .L8_34
.L8_25:
	lw s1, -20(s0)
	li s2, 103
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_35
	j .L8_36
.L8_35:
	addi s1, s0, -560
	fld fs0, -16(s0)
	lw s2, -36(s0)
	li s3, 0
	xor s4, s2, s3
	seqz s4, s4
	bnez s4, .L8_37
	j .L8_38
.L8_37:
	li s2, 1
	sw s2, -608(s0)
	j .L8_39
.L8_38:
	lw s2, -36(s0)
	sw s2, -608(s0)
.L8_39:
	lw s2, -608(s0)
	lw s3, -28(s0)
	li s4, 16
	and s5, s3, s4
	lw s3, -24(s0)
	addi sp, sp, -16
	mv a0, s1
	fsd fs0, 0(sp)
	lw a1, 0(sp)
	lw a2, 4(sp)
	mv a3, s2
	mv a4, s5
	mv a5, s3
	jal ra, __fmt_greal
	mv s4, a0
	addi sp, sp, 16
	sw s4, -564(s0)
	j .L8_40
.L8_36:
	lw s1, -20(s0)
	li s2, 102
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_41
	j .L8_42
.L8_41:
	fld fs0, -16(s0)
	la s1, __flt_21
	fld fs1, 0(s1)
	fle.d s1, fs1, fs0
	bnez s1, .L8_43
	j .L8_44
.L8_43:
	addi s1, s0, -560
	lw s2, -564(s0)
	fld fs0, -16(s0)
	lw s3, -36(s0)
	lw s4, -28(s0)
	lw s5, -24(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	fsd fs0, 0(sp)
	lw a2, 0(sp)
	lw a3, 4(sp)
	mv a4, s3
	mv a5, s4
	mv a6, s5
	jal ra, build_sci
	mv s6, a0
	addi sp, sp, 16
	sw s6, -564(s0)
	j .L8_45
.L8_44:
	addi s1, s0, -560
	lw s2, -564(s0)
	fld fs0, -16(s0)
	lw s3, -36(s0)
	lw s4, -28(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	fsd fs0, 0(sp)
	lw a2, 0(sp)
	lw a3, 4(sp)
	mv a4, s3
	mv a5, s4
	jal ra, build_fixed
	mv s5, a0
	addi sp, sp, 16
	sw s5, -564(s0)
.L8_45:
	j .L8_46
.L8_42:
	addi s1, s0, -560
	lw s2, -564(s0)
	fld fs0, -16(s0)
	lw s3, -36(s0)
	lw s4, -28(s0)
	lw s5, -24(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	fsd fs0, 0(sp)
	lw a2, 0(sp)
	lw a3, 4(sp)
	mv a4, s3
	mv a5, s4
	mv a6, s5
	jal ra, build_sci
	mv s6, a0
	addi sp, sp, 16
	sw s6, -564(s0)
.L8_46:
.L8_40:
.L8_34:
.L8_23:
	lw s1, -564(s0)
	addi s2, s0, -568
	lb s3, 0(s2)
	bnez s3, .L8_47
	j .L8_48
.L8_47:
	li s2, 1
	sw s2, -612(s0)
	j .L8_49
.L8_48:
	li s2, 0
	sw s2, -612(s0)
.L8_49:
	lw s2, -612(s0)
	add s3, s1, s2
	sw s3, -584(s0)
	lw s1, -32(s0)
	lw s2, -584(s0)
	slt s3, s2, s1
	bnez s3, .L8_50
	j .L8_51
.L8_50:
	lw s1, -32(s0)
	lw s2, -584(s0)
	sub s3, s1, s2
	sw s3, -616(s0)
	j .L8_52
.L8_51:
	li s1, 0
	sw s1, -616(s0)
.L8_52:
	lw s1, -616(s0)
	sw s1, -588(s0)
	lw s1, -28(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L8_53
	j .L8_54
.L8_54:
	lw s1, -28(s0)
	li s2, 2
	and s3, s1, s2
	bnez s3, .L8_55
	j .L8_56
.L8_55:
	lw s1, -576(s0)
	bnez s1, .L8_56
	j .L8_57
.L8_57:
	addi s1, s0, -568
	lb s2, 0(s1)
	bnez s2, .L8_58
	j .L8_59
.L8_58:
	lw s1, -4(s0)
	addi s2, s0, -568
	lb s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit
	mv s2, a0
.L8_59:
	lw s1, -4(s0)
	li s2, 48
	lw s3, -588(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
	j .L8_60
.L8_56:
	lw s1, -4(s0)
	li s2, 32
	lw s3, -588(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
	addi s1, s0, -568
	lb s2, 0(s1)
	bnez s2, .L8_61
	j .L8_62
.L8_61:
	lw s1, -4(s0)
	addi s2, s0, -568
	lb s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit
	mv s2, a0
.L8_62:
.L8_60:
	li s1, 0
	sw s1, -580(s0)
.L8_63:
	lw s1, -580(s0)
	lw s2, -564(s0)
	slt s3, s1, s2
	bnez s3, .L8_64
	j .L8_65
.L8_64:
	lw s1, -4(s0)
	addi s2, s0, -560
	lw s3, -580(s0)
	add s4, s2, s3
	lb s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, emit
	mv s3, a0
.L8_66:
	addi s1, s0, -580
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -580(s0)
	j .L8_63
.L8_65:
	j .L8_67
.L8_53:
	addi s1, s0, -568
	lb s2, 0(s1)
	bnez s2, .L8_68
	j .L8_69
.L8_68:
	lw s1, -4(s0)
	addi s2, s0, -568
	lb s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit
	mv s2, a0
.L8_69:
	li s1, 0
	sw s1, -580(s0)
.L8_70:
	lw s1, -580(s0)
	lw s2, -564(s0)
	slt s3, s1, s2
	bnez s3, .L8_71
	j .L8_72
.L8_71:
	lw s1, -4(s0)
	addi s2, s0, -560
	lw s3, -580(s0)
	add s4, s2, s3
	lb s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, emit
	mv s3, a0
.L8_73:
	addi s1, s0, -580
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -580(s0)
	j .L8_70
.L8_72:
	lw s1, -4(s0)
	li s2, 32
	lw s3, -588(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
.L8_67:
	li s1, 0
	mv a0, s1
	lw s1, -684(s0)
	lw s2, -680(s0)
	lw s3, -676(s0)
	lw s4, -672(s0)
	lw s5, -668(s0)
	lw s6, -664(s0)
	lw s7, -660(s0)
	lw s8, -656(s0)
	lw s9, -652(s0)
	lw s10, -648(s0)
	lw s11, -644(s0)
	fld fs0, -640(s0)
	fld fs1, -632(s0)
	fld fs2, -624(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end8:
	.size fmt_float, .Lfunc_end8-fmt_float

	.text
	.align 2
	.globl __vformat
	.type __vformat, @function
__vformat:
	addi sp, sp, -256
	sw ra, 252(sp)
	sw s0, 248(sp)
	addi s0, sp, 248
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
	fsd fs0, 52(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
.L9_0:
	lw s1, -8(s0)
	lb s2, 0(s1)
	bnez s2, .L9_1
	j .L9_2
.L9_1:
	li s1, 0
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L9_3
	j .L9_4
.L9_3:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lb s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit
	mv s2, a0
	j .L9_5
.L9_4:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	sw s2, -36(s0)
.L9_6:
	j .L9_7
.L9_7:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_8
	j .L9_9
.L9_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	or s3, s2, s1
	sw s3, -20(s0)
	j .L9_10
.L9_9:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_11
	j .L9_12
.L9_11:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 2
	or s3, s2, s1
	sw s3, -20(s0)
	j .L9_13
.L9_12:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_14
	j .L9_15
.L9_14:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 4
	or s3, s2, s1
	sw s3, -20(s0)
	j .L9_16
.L9_15:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_17
	j .L9_18
.L9_17:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 8
	or s3, s2, s1
	sw s3, -20(s0)
	j .L9_19
.L9_18:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_20
	j .L9_21
.L9_20:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 16
	or s3, s2, s1
	sw s3, -20(s0)
	j .L9_22
.L9_21:
	j .L9_23
.L9_22:
.L9_19:
.L9_16:
.L9_13:
.L9_10:
.L9_24:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L9_6
.L9_23:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_25
	j .L9_26
.L9_25:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L9_27
	j .L9_28
.L9_27:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	or s3, s2, s1
	sw s3, -20(s0)
	lw s1, -24(s0)
	neg s2, s1
	sw s2, -24(s0)
.L9_28:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L9_29
.L9_26:
.L9_30:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_31
	j .L9_32
.L9_31:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_33
	j .L9_32
.L9_33:
	lw s1, -24(s0)
	li s2, 10
	mul s3, s1, s2
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -8(s0)
	lb s1, 0(s2)
	li s2, 48
	sub s4, s1, s2
	add s1, s3, s4
	sw s1, -24(s0)
	j .L9_30
.L9_32:
.L9_29:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_34
	j .L9_35
.L9_34:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_36
	j .L9_37
.L9_36:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	sw s1, -28(s0)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L9_38
.L9_37:
	li s1, 0
	sw s1, -28(s0)
.L9_39:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_40
	j .L9_41
.L9_40:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_42
	j .L9_41
.L9_42:
	lw s1, -28(s0)
	li s2, 10
	mul s3, s1, s2
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -8(s0)
	lb s1, 0(s2)
	li s2, 48
	sub s4, s1, s2
	add s1, s3, s4
	sw s1, -28(s0)
	j .L9_39
.L9_41:
.L9_38:
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L9_43
	j .L9_44
.L9_43:
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
.L9_44:
.L9_35:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 104
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_45
	j .L9_46
.L9_45:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 104
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_47
	j .L9_48
.L9_47:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
.L9_48:
	j .L9_49
.L9_46:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 108
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_50
	j .L9_51
.L9_50:
	li s1, 1
	sw s1, -32(s0)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 108
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_52
	j .L9_53
.L9_52:
	li s1, 2
	sw s1, -32(s0)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
.L9_53:
	j .L9_54
.L9_51:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 122
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_55
	j .L9_56
.L9_56:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 116
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_55
	j .L9_57
.L9_55:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_58
	j .L9_59
.L9_58:
	li s1, 2
	sw s1, -40(s0)
	j .L9_60
.L9_59:
	li s1, 1
	sw s1, -40(s0)
.L9_60:
	lw s1, -40(s0)
	sw s1, -32(s0)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L9_61
.L9_57:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 106
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_62
	j .L9_63
.L9_62:
	li s1, 2
	sw s1, -32(s0)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
.L9_63:
.L9_61:
.L9_54:
.L9_49:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 100
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_64
	li s1, 105
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_65
	li s1, 117
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_66
	li s1, 111
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_67
	li s1, 120
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_68
	li s1, 88
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_69
	li s1, 112
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_70
	li s1, 99
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_71
	li s1, 115
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_72
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_73
	li s1, 102
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_74
	li s1, 70
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_75
	li s1, 101
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_76
	li s1, 69
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_77
	li s1, 103
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_78
	li s1, 71
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_79
	li s1, 97
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_80
	li s1, 65
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_81
	j .L9_82
.L9_64:
.L9_65:
	lw s1, -32(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_83
	j .L9_84
.L9_83:
	lw s1, -12(s0)
	li s2, 2
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s10, 0(s3)
	lw s11, 4(s3)
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L9_85
.L9_84:
	lw s1, -32(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_86
	j .L9_87
.L9_86:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L9_88
.L9_87:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
.L9_88:
.L9_85:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L9_89
	sltu s1, s10, s8
.L9_89:
	sw s1, -52(s0)
	lw s1, -52(s0)
	bnez s1, .L9_90
	j .L9_91
.L9_90:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	neg s10, s6
	snez t0, s6
	neg s11, s7
	sub s11, s11, t0
	li s8, 1
	li s9, 0
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -64(s0)
	sw s7, -60(s0)
	j .L9_92
.L9_91:
	lw s10, -48(s0)
	lw s11, -44(s0)
	sw s10, -64(s0)
	sw s11, -60(s0)
.L9_92:
	lw s1, -4(s0)
	lw s10, -64(s0)
	lw s11, -60(s0)
	li s2, 10
	li s3, 0
	lw s4, -52(s0)
	lw s5, -20(s0)
	lw t0, -24(s0)
	sw t0, -140(s0)
	lw t0, -28(s0)
	sw t0, -144(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	mv a4, s3
	mv a5, s4
	mv a6, s5
	lw t0, -140(s0)
	mv a7, t0
	lw t0, -144(s0)
	sw t0, 0(sp)
	jal ra, fmt_number
	mv t0, a0
	sw t0, -148(s0)
	addi sp, sp, 16
	j .L9_93
.L9_66:
.L9_67:
.L9_68:
.L9_69:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 111
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_94
	j .L9_95
.L9_94:
	li s1, 8
	sw s1, -80(s0)
	j .L9_96
.L9_95:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 117
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_97
	j .L9_98
.L9_97:
	li s1, 10
	sw s1, -84(s0)
	j .L9_99
.L9_98:
	li s1, 16
	sw s1, -84(s0)
.L9_99:
	lw s1, -84(s0)
	sw s1, -80(s0)
.L9_96:
	lw s1, -80(s0)
	sw s1, -76(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 88
	xor s3, s2, s1
	seqz s3, s3
	sw s3, -88(s0)
	lw s1, -32(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_100
	j .L9_101
.L9_100:
	lw s1, -12(s0)
	li s2, 2
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s10, 0(s3)
	lw s11, 4(s3)
	sw s10, -72(s0)
	sw s11, -68(s0)
	j .L9_102
.L9_101:
	lw s1, -32(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_103
	j .L9_104
.L9_103:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	mv s10, s1
	li s11, 0
	sw s10, -72(s0)
	sw s11, -68(s0)
	j .L9_105
.L9_104:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	mv s10, s1
	li s11, 0
	sw s10, -72(s0)
	sw s11, -68(s0)
.L9_105:
.L9_102:
	lw s1, -4(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw s2, -76(s0)
	lw s3, -88(s0)
	li s4, 0
	lw s5, -20(s0)
	lw t0, -24(s0)
	sw t0, -152(s0)
	lw t0, -28(s0)
	sw t0, -156(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	mv a4, s3
	mv a5, s4
	mv a6, s5
	lw t0, -152(s0)
	mv a7, t0
	lw t0, -156(s0)
	sw t0, 0(sp)
	jal ra, fmt_number
	mv t0, a0
	sw t0, -160(s0)
	addi sp, sp, 16
	j .L9_93
.L9_70:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	sw s1, -92(s0)
	lw s1, -92(s0)
	bnez s1, .L9_106
	j .L9_107
.L9_107:
	lw s1, -4(s0)
	la s2, __str_22
	lw s3, -20(s0)
	lw s4, -24(s0)
	li s5, 1
	neg t0, s5
	sw t0, -164(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	lw t0, -164(s0)
	mv a4, t0
	jal ra, fmt_str
	mv s5, a0
	j .L9_108
.L9_106:
	lw s1, -4(s0)
	lw s2, -92(s0)
	mv s10, s2
	li s11, 0
	li s2, 16
	li s3, 0
	li t0, 0
	sw t0, -168(s0)
	lw s5, -20(s0)
	li s4, 16
	or t0, s5, s4
	sw t0, -172(s0)
	lw s4, -24(s0)
	lw s5, -28(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	mv a4, s3
	lw t0, -168(s0)
	mv a5, t0
	lw t0, -172(s0)
	mv a6, t0
	mv a7, s4
	sw s5, 0(sp)
	jal ra, fmt_number
	mv t0, a0
	sw t0, -176(s0)
	addi sp, sp, 16
.L9_108:
	j .L9_93
.L9_71:
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	lw s1, 0(s3)
	sw s1, -96(s0)
	lw s1, -96(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	sw s2, -100(s0)
	lw s1, -24(s0)
	li s2, 1
	slt s3, s2, s1
	bnez s3, .L9_109
	j .L9_110
.L9_109:
	lw s1, -24(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -108(s0)
	j .L9_111
.L9_110:
	li s1, 0
	sw s1, -108(s0)
.L9_111:
	lw s1, -108(s0)
	sw s1, -104(s0)
	lw s1, -20(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L9_112
	j .L9_113
.L9_113:
	lw s1, -4(s0)
	li s2, 32
	lw s3, -104(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
.L9_112:
	lw s1, -4(s0)
	addi s2, s0, -100
	lb s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit
	mv s2, a0
	lw s1, -20(s0)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L9_114
	j .L9_115
.L9_114:
	lw s1, -4(s0)
	li s2, 32
	lw s3, -104(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_pad
	mv s4, a0
.L9_115:
	j .L9_93
.L9_72:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 0
	mv a0, s2
	mv a1, s3
	jal ra, __va_arg
	mv s4, a0
	lw s2, 0(s4)
	lw s3, -20(s0)
	lw s4, -24(s0)
	lw s5, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fmt_str
	mv t0, a0
	sw t0, -180(s0)
	j .L9_93
.L9_73:
	lw s1, -4(s0)
	li s2, 37
	mv a0, s1
	mv a1, s2
	jal ra, emit
	mv s3, a0
	j .L9_93
.L9_74:
.L9_75:
.L9_76:
.L9_77:
.L9_78:
.L9_79:
.L9_80:
.L9_81:
	lw s1, -12(s0)
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, __va_arg
	mv s3, a0
	fld fs0, 0(s3)
	fsd fs0, -120(s0)
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 65
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_116
	j .L9_117
.L9_116:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 90
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_118
	j .L9_117
.L9_118:
	li s1, 1
	j .L9_119
.L9_117:
	li s1, 0
.L9_119:
	sw s1, -124(s0)
	lw s1, -124(s0)
	bnez s1, .L9_120
	j .L9_121
.L9_120:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 65
	sub s3, s2, s1
	li s1, 97
	add s2, s3, s1
	sw s2, -132(s0)
	j .L9_122
.L9_121:
	lw s1, -8(s0)
	lb s2, 0(s1)
	sw s2, -132(s0)
.L9_122:
	lw s1, -132(s0)
	sw s1, -128(s0)
	lw s1, -4(s0)
	fld fs0, -120(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -20(s0)
	lw s5, -24(s0)
	lw t0, -28(s0)
	sw t0, -184(s0)
	addi sp, sp, -16
	mv a0, s1
	fsd fs0, 0(sp)
	lw a1, 0(sp)
	lw a2, 4(sp)
	mv a3, s2
	mv a4, s3
	mv a5, s4
	mv a6, s5
	lw t0, -184(s0)
	mv a7, t0
	jal ra, fmt_float
	mv t0, a0
	sw t0, -188(s0)
	addi sp, sp, 16
	j .L9_93
.L9_82:
	lw s1, -36(s0)
	sw s1, -136(s0)
.L9_123:
	lw s1, -136(s0)
	lw s2, -8(s0)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_124
	j .L9_125
.L9_124:
	lw s1, -136(s0)
	lb s2, 0(s1)
	bnez s2, .L9_126
	j .L9_125
.L9_126:
	lw s1, -4(s0)
	lw s2, -136(s0)
	lb s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit
	mv s2, a0
.L9_127:
	addi s1, s0, -136
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -136(s0)
	j .L9_123
.L9_125:
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_128
	j .L9_129
.L9_128:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -8(s0)
.L9_129:
	j .L9_93
.L9_93:
.L9_5:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L9_0
.L9_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -240(s0)
	lw s2, -236(s0)
	lw s3, -232(s0)
	lw s4, -228(s0)
	lw s5, -224(s0)
	lw s6, -220(s0)
	lw s7, -216(s0)
	lw s8, -212(s0)
	lw s9, -208(s0)
	lw s10, -204(s0)
	lw s11, -200(s0)
	fld fs0, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end9:
	.size __vformat, .Lfunc_end9-__vformat

	.text
	.align 2
	.type mem_put, @function
mem_put:
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
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s3, s1
	bnez s2, .L10_0
	j .L10_1
.L10_0:
	addi s1, s0, -8
	lb s2, 0(s1)
	lw s1, -12(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	add s4, s1, s3
	sb s2, 0(s4)
.L10_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
	.size mem_put, .Lfunc_end10-mem_put

	.text
	.align 2
	.globl vsnprintf
	.type vsnprintf, @function
vsnprintf:
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
	la s1, mem_put
	addi s2, s0, -32
	sw s1, 0(s2)
	li s1, 0
	addi s2, s0, -32
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	addi s2, s0, -32
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	addi s2, s0, -32
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -32
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, __vformat
	mv s4, a0
	lw s1, -8(s0)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	addi s1, s0, -32
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 1
	sub s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L11_2
	j .L11_3
.L11_2:
	addi s1, s0, -32
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	j .L11_4
.L11_3:
	lw s1, -8(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -40(s0)
.L11_4:
	lw s1, -40(s0)
	sw s1, -36(s0)
	li s1, 0
	lw s2, -4(s0)
	lw s3, -36(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L11_1:
	addi s1, s0, -32
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end11:
	.size vsnprintf, .Lfunc_end11-vsnprintf

	.text
	.align 2
	.globl snprintf
	.type snprintf, @function
snprintf:
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
	addi s1, s0, -32
	addi t0, s0, 8
	sw t0, 8(s1)
	sw zero, 0(s1)
	sw zero, 4(s1)
	sw zero, 12(s1)
	li s1, 0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	addi s4, s0, -32
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, vsnprintf
	mv s5, a0
	sw s5, -36(s0)
	li s1, 0
	lw s1, -36(s0)
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
.Lfunc_end12:
	.size snprintf, .Lfunc_end12-snprintf

	.text
	.align 2
	.globl vsprintf
	.type vsprintf, @function
vsprintf:
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
	li s2, 1
	neg s3, s2
	lw s2, -8(s0)
	lw s4, -12(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	mv a3, s4
	jal ra, vsnprintf
	mv s5, a0
	mv a0, s5
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
	.size vsprintf, .Lfunc_end13-vsprintf

	.text
	.align 2
	.globl sprintf
	.type sprintf, @function
sprintf:
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
	li s2, 1
	neg s3, s2
	lw s2, -8(s0)
	addi s4, s0, -24
	mv a0, s1
	mv a1, s3
	mv a2, s2
	mv a3, s4
	jal ra, vsnprintf
	mv s5, a0
	sw s5, -28(s0)
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
.Lfunc_end14:
	.size sprintf, .Lfunc_end14-sprintf

	.data
	.align 2
__str_22:
	.ascii "(nil)\000"
	.align 3
__flt_21:
	.word 0x00000000
	.word 0x43f00000
	.align 2
__str_20:
	.ascii "inf\000"
	.align 2
__str_19:
	.ascii "INF\000"
	.align 3
__flt_18:
	.word 0x00000000
	.word 0x00000000
	.align 2
__str_17:
	.ascii "nan\000"
	.align 2
__str_16:
	.ascii "NAN\000"
	.align 3
__flt_15:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_14:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_13:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_12:
	.word 0x9999999a
	.word 0x3fb99999
	.align 3
__flt_11:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_10:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_9:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_8:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_7:
	.word 0x00000000
	.word 0x00000000
	.align 3
__flt_6:
	.word 0x00000000
	.word 0x3fe00000
	.align 3
__flt_5:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_4:
	.word 0x9999999a
	.word 0x3fb99999
	.align 3
__flt_3:
	.word 0x00000000
	.word 0x3fe00000
	.align 2
__str_2:
	.ascii "(null)\000"
	.align 2
__str_1:
	.ascii "0123456789abcdef\000"
	.align 2
__str_0:
	.ascii "0123456789ABCDEF\000"
