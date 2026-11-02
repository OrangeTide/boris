# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type divmod10, @function
divmod10:
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
	lw s10, 0(s1)
	lw s11, 4(s1)
	sw s10, -16(s0)
	sw s11, -12(s0)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -24(s0)
	sw s11, -20(s0)
	li s1, 0
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 16
	sll s3, s1, s2
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 48
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	li s1, 65535
	mv s10, s1
	srai s11, s10, 31
	and s6, s8, s10
	and s7, s9, s11
	mv s1, s6
	or s2, s3, s1
	sw s2, -32(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 16
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	lw s1, -32(s0)
	li s2, 10
	divu s3, s1, s2
	mv s10, s3
	li s11, 0
	or s6, s8, s10
	or s7, s9, s11
	sw s6, -24(s0)
	sw s7, -20(s0)
	lw s1, -32(s0)
	li s2, 10
	remu s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 16
	sll s3, s1, s2
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 32
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	li s1, 65535
	mv s10, s1
	srai s11, s10, 31
	and s6, s8, s10
	and s7, s9, s11
	mv s1, s6
	or s2, s3, s1
	sw s2, -32(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 16
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	lw s1, -32(s0)
	li s2, 10
	divu s3, s1, s2
	mv s10, s3
	li s11, 0
	or s6, s8, s10
	or s7, s9, s11
	sw s6, -24(s0)
	sw s7, -20(s0)
	lw s1, -32(s0)
	li s2, 10
	remu s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 16
	sll s3, s1, s2
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 16
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	li s1, 65535
	mv s10, s1
	srai s11, s10, 31
	and s6, s8, s10
	and s7, s9, s11
	mv s1, s6
	or s2, s3, s1
	sw s2, -32(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 16
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	lw s1, -32(s0)
	li s2, 10
	divu s3, s1, s2
	mv s10, s3
	li s11, 0
	or s6, s8, s10
	or s7, s9, s11
	sw s6, -24(s0)
	sw s7, -20(s0)
	lw s1, -32(s0)
	li s2, 10
	remu s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 16
	sll s3, s1, s2
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 65535
	mv s8, s1
	srai s9, s8, 31
	and s6, s10, s8
	and s7, s11, s9
	mv s1, s6
	or s2, s3, s1
	sw s2, -32(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 16
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	lw s1, -32(s0)
	li s2, 10
	divu s3, s1, s2
	mv s10, s3
	li s11, 0
	or s6, s8, s10
	or s7, s9, s11
	sw s6, -24(s0)
	sw s7, -20(s0)
	lw s1, -32(s0)
	li s2, 10
	remu s3, s1, s2
	sw s3, -28(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	lw s1, -4(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
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
.Lfunc_end1:
	.size divmod10, .Lfunc_end1-divmod10

	.text
	.align 2
	.globl __fmt_udec
	.type __fmt_udec, @function
__fmt_udec:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	li s1, 0
	sw s1, -40(s0)
.L2_0:
	li s1, 48
	addi s2, s0, -16
	mv a0, s2
	jal ra, divmod10
	mv s3, a0
	add s2, s1, s3
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -36
	addi s3, s0, -40
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -40(s0)
	add s3, s1, s4
	sb s2, 0(s3)
.L2_1:
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L2_0
	j .L2_2
.L2_2:
	li s1, 0
	sw s1, -44(s0)
.L2_3:
	lw s1, -44(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L2_4
	j .L2_5
.L2_4:
	addi s1, s0, -36
	lw s2, -40(s0)
	li s3, 1
	sub s4, s2, s3
	lw s2, -44(s0)
	sub s3, s4, s2
	add s2, s1, s3
	lb s1, 0(s2)
	lw s2, -4(s0)
	lw s3, -44(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L2_6:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L2_3
.L2_5:
	lw s1, -40(s0)
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
.Lfunc_end2:
	.size __fmt_udec, .Lfunc_end2-__fmt_udec

	.text
	.align 2
	.globl __fmt_greal
	.type __fmt_greal, @function
__fmt_greal:
	addi sp, sp, -240
	sw ra, 236(sp)
	sw s0, 232(sp)
	addi s0, sp, 232
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
	fsd fs1, 56(sp)
	fsd fs2, 64(sp)
	sw a0, -4(s0)
	sw a1, -16(s0)
	sw a2, -12(s0)
	sw a3, -20(s0)
	sw a4, -24(s0)
	sw a5, -28(s0)
	li s1, 0
	sw s1, -108(s0)
	li s1, 0
	sw s1, -112(s0)
	lw s1, -20(s0)
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	li s1, 1
	sw s1, -20(s0)
.L3_1:
	lw s1, -20(s0)
	li s2, 17
	slt s3, s2, s1
	bnez s3, .L3_2
	j .L3_3
.L3_2:
	li s1, 17
	sw s1, -20(s0)
.L3_3:
	lw s1, -20(s0)
	sw s1, -124(s0)
	fld fs0, -16(s0)
	la s1, __flt_0
	fld fs1, 0(s1)
	feq.d s1, fs0, fs1
	bnez s1, .L3_4
	j .L3_5
.L3_4:
	li s1, 48
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -24(s0)
	bnez s1, .L3_6
	j .L3_7
.L3_6:
	lw s1, -124(s0)
	li s2, 1
	slt s3, s2, s1
	bnez s3, .L3_8
	j .L3_7
.L3_8:
	li s1, 46
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 1
	sw s1, -116(s0)
.L3_9:
	lw s1, -116(s0)
	lw s2, -124(s0)
	slt s3, s1, s2
	bnez s3, .L3_10
	j .L3_11
.L3_10:
	li s1, 48
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L3_12:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_9
.L3_11:
.L3_7:
	lw s1, -108(s0)
	mv a0, s1
	lw s1, -228(s0)
	lw s2, -224(s0)
	lw s3, -220(s0)
	lw s4, -216(s0)
	lw s5, -212(s0)
	lw s6, -208(s0)
	lw s7, -204(s0)
	lw s8, -200(s0)
	lw s9, -196(s0)
	lw s10, -192(s0)
	lw s11, -188(s0)
	fld fs0, -184(s0)
	fld fs1, -176(s0)
	fld fs2, -168(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_5:
	fld fs0, -16(s0)
	fsd fs0, -136(s0)
.L3_13:
	fld fs0, -136(s0)
	la s1, __flt_1
	fld fs1, 0(s1)
	fle.d s1, fs1, fs0
	bnez s1, .L3_14
	j .L3_15
.L3_14:
	addi s1, s0, -136
	fld fs0, 0(s1)
	la s1, __flt_2
	fld fs1, 0(s1)
	fdiv.d fs2, fs0, fs1
	fsd fs2, -136(s0)
	addi s1, s0, -112
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -112(s0)
	j .L3_13
.L3_15:
.L3_16:
	fld fs0, -136(s0)
	la s1, __flt_3
	fld fs1, 0(s1)
	flt.d s1, fs0, fs1
	bnez s1, .L3_17
	j .L3_18
.L3_17:
	addi s1, s0, -136
	fld fs0, 0(s1)
	la s1, __flt_4
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -136(s0)
	addi s1, s0, -112
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -112(s0)
	j .L3_16
.L3_18:
	li s1, 0
	sw s1, -116(s0)
.L3_19:
	lw s1, -116(s0)
	lw s2, -124(s0)
	slt s3, s1, s2
	bnez s3, .L3_20
	j .L3_21
.L3_20:
	fld fs0, -136(s0)
	fcvt.w.d s1, fs0, rtz
	sw s1, -140(s0)
	lw s1, -140(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_22
	j .L3_23
.L3_22:
	li s1, 0
	sw s1, -140(s0)
	j .L3_24
.L3_23:
	lw s1, -140(s0)
	li s2, 9
	slt s3, s2, s1
	bnez s3, .L3_25
	j .L3_26
.L3_25:
	li s1, 9
	sw s1, -140(s0)
.L3_26:
.L3_24:
	lw s1, -140(s0)
	addi s2, s0, -104
	lw s3, -116(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	fld fs0, -136(s0)
	lw s1, -140(s0)
	fcvt.d.w fs1, s1
	fsub.d fs2, fs0, fs1
	la s1, __flt_5
	fld fs0, 0(s1)
	fmul.d fs1, fs2, fs0
	fsd fs1, -136(s0)
.L3_27:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_19
.L3_21:
	fld fs0, -136(s0)
	fcvt.w.d s1, fs0, rtz
	li s2, 5
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_28
	j .L3_29
.L3_28:
	lw s1, -124(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -116(s0)
.L3_30:
	lw s1, -116(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_31
	j .L3_32
.L3_31:
	addi s1, s0, -104
	lw s2, -116(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s3, 1
	add s4, s1, s3
	sw s4, 0(s2)
	li s1, 10
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L3_33
	j .L3_32
.L3_33:
	li s1, 0
	addi s2, s0, -104
	lw s3, -116(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_30
.L3_32:
	lw s1, -116(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_34
	j .L3_35
.L3_34:
	lw s1, -124(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -116(s0)
.L3_36:
	lw s1, -116(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_37
	j .L3_38
.L3_37:
	addi s1, s0, -104
	lw s2, -116(s0)
	li s3, 1
	sub s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	addi s2, s0, -104
	lw s3, -116(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_39:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_36
.L3_38:
	li s1, 1
	addi s2, s0, -104
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -112
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -112(s0)
.L3_35:
.L3_29:
	lw s1, -112(s0)
	li s2, 4
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L3_40
	j .L3_41
.L3_41:
	lw s1, -112(s0)
	lw s2, -124(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_40
	j .L3_42
.L3_40:
	li s1, 48
	addi s2, s0, -104
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -4(s0)
	addi s2, s0, -108
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -108(s0)
	add s2, s1, s4
	sb s3, 0(s2)
	lw s1, -124(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -120(s0)
	lw s1, -24(s0)
	bnez s1, .L3_43
	j .L3_44
.L3_44:
.L3_45:
	lw s1, -120(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_46
	j .L3_47
.L3_46:
	addi s1, s0, -104
	lw s2, -120(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_48
	j .L3_47
.L3_48:
	addi s1, s0, -120
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -120(s0)
	j .L3_45
.L3_47:
.L3_43:
	lw s1, -24(s0)
	bnez s1, .L3_49
	j .L3_50
.L3_50:
	lw s1, -120(s0)
	li s2, 1
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_49
	j .L3_51
.L3_49:
	li s1, 46
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 1
	sw s1, -116(s0)
.L3_52:
	lw s1, -116(s0)
	lw s2, -120(s0)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_53
	j .L3_54
.L3_53:
	li s1, 48
	addi s2, s0, -104
	lw s3, -116(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -4(s0)
	addi s2, s0, -108
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -108(s0)
	add s2, s1, s4
	sb s3, 0(s2)
.L3_55:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_52
.L3_54:
.L3_51:
	lw s1, -28(s0)
	bnez s1, .L3_56
	j .L3_57
.L3_56:
	li s1, 69
	sw s1, -144(s0)
	j .L3_58
.L3_57:
	li s1, 101
	sw s1, -144(s0)
.L3_58:
	lw s1, -144(s0)
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -112(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_59
	j .L3_60
.L3_59:
	li s1, 45
	sw s1, -148(s0)
	j .L3_61
.L3_60:
	li s1, 43
	sw s1, -148(s0)
.L3_61:
	lw s1, -148(s0)
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -112(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_62
	j .L3_63
.L3_62:
	lw s1, -112(s0)
	neg s2, s1
	sw s2, -156(s0)
	j .L3_64
.L3_63:
	lw s1, -112(s0)
	sw s1, -156(s0)
.L3_64:
	lw s1, -156(s0)
	sw s1, -152(s0)
	lw s1, -152(s0)
	li s2, 100
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_65
	j .L3_66
.L3_65:
	li s1, 48
	lw s2, -152(s0)
	li s3, 100
	div s4, s2, s3
	add s2, s1, s4
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	addi s1, s0, -152
	lw s2, 0(s1)
	li s1, 100
	rem s3, s2, s1
	sw s3, -152(s0)
.L3_66:
	li s1, 48
	lw s2, -152(s0)
	li s3, 10
	div s4, s2, s3
	add s2, s1, s4
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	li s1, 48
	lw s2, -152(s0)
	li s3, 10
	rem s4, s2, s3
	add s2, s1, s4
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	j .L3_67
.L3_42:
	lw s1, -112(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_68
	j .L3_69
.L3_68:
	li s1, 0
	sw s1, -116(s0)
.L3_70:
	lw s1, -116(s0)
	lw s2, -112(s0)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_71
	j .L3_72
.L3_71:
	li s1, 48
	addi s2, s0, -104
	lw s3, -116(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -4(s0)
	addi s2, s0, -108
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -108(s0)
	add s2, s1, s4
	sb s3, 0(s2)
.L3_73:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_70
.L3_72:
	lw s1, -124(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -120(s0)
	lw s1, -24(s0)
	bnez s1, .L3_74
	j .L3_75
.L3_75:
.L3_76:
	lw s1, -120(s0)
	lw s2, -112(s0)
	slt s3, s2, s1
	bnez s3, .L3_77
	j .L3_78
.L3_77:
	addi s1, s0, -104
	lw s2, -120(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_79
	j .L3_78
.L3_79:
	addi s1, s0, -120
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -120(s0)
	j .L3_76
.L3_78:
.L3_74:
	lw s1, -24(s0)
	bnez s1, .L3_80
	j .L3_81
.L3_81:
	lw s1, -120(s0)
	lw s2, -112(s0)
	slt s3, s2, s1
	bnez s3, .L3_80
	j .L3_82
.L3_80:
	li s1, 46
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -112(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -116(s0)
.L3_83:
	lw s1, -116(s0)
	lw s2, -120(s0)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_84
	j .L3_85
.L3_84:
	li s1, 48
	addi s2, s0, -104
	lw s3, -116(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -4(s0)
	addi s2, s0, -108
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -108(s0)
	add s2, s1, s4
	sb s3, 0(s2)
.L3_86:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_83
.L3_85:
.L3_82:
	j .L3_87
.L3_69:
	lw s1, -124(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -120(s0)
	lw s1, -24(s0)
	bnez s1, .L3_88
	j .L3_89
.L3_89:
.L3_90:
	lw s1, -120(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_91
	j .L3_92
.L3_91:
	addi s1, s0, -104
	lw s2, -120(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_93
	j .L3_92
.L3_93:
	addi s1, s0, -120
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -120(s0)
	j .L3_90
.L3_92:
.L3_88:
	li s1, 48
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 46
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 0
	sw s1, -116(s0)
.L3_94:
	lw s1, -116(s0)
	lw s2, -112(s0)
	neg s3, s2
	li s2, 1
	sub s4, s3, s2
	slt s2, s1, s4
	bnez s2, .L3_95
	j .L3_96
.L3_95:
	li s1, 48
	lw s2, -4(s0)
	addi s3, s0, -108
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -108(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L3_97:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_94
.L3_96:
	li s1, 0
	sw s1, -116(s0)
.L3_98:
	lw s1, -116(s0)
	lw s2, -120(s0)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_99
	j .L3_100
.L3_99:
	li s1, 48
	addi s2, s0, -104
	lw s3, -116(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	lw s1, -4(s0)
	addi s2, s0, -108
	lw s4, 0(s2)
	li s2, 1
	add s5, s4, s2
	sw s5, -108(s0)
	add s2, s1, s4
	sb s3, 0(s2)
.L3_101:
	addi s1, s0, -116
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -116(s0)
	j .L3_98
.L3_100:
.L3_87:
.L3_67:
	lw s1, -108(s0)
	mv a0, s1
	lw s1, -228(s0)
	lw s2, -224(s0)
	lw s3, -220(s0)
	lw s4, -216(s0)
	lw s5, -212(s0)
	lw s6, -208(s0)
	lw s7, -204(s0)
	lw s8, -200(s0)
	lw s9, -196(s0)
	lw s10, -192(s0)
	lw s11, -188(s0)
	fld fs0, -184(s0)
	fld fs1, -176(s0)
	fld fs2, -168(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size __fmt_greal, .Lfunc_end3-__fmt_greal

	.data
	.align 3
__flt_5:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_4:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_3:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_2:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_1:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_0:
	.word 0x00000000
	.word 0x00000000
