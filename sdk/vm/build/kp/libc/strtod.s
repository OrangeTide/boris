# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl strtod
	.type strtod, @function
strtod:
	addi sp, sp, -176
	sw ra, 172(sp)
	sw s0, 168(sp)
	addi s0, sp, 168
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
	fsd fs3, 72(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	lw s1, -4(s0)
	sw s1, -12(s0)
	la s1, __flt_0
	fld fs0, 0(s1)
	fsd fs0, -24(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
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
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_3
	j .L1_4
.L1_4:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_3
	j .L1_5
.L1_3:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	sw s3, -28(s0)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L1_5:
.L1_6:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_7
	j .L1_8
.L1_7:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_9
	j .L1_8
.L1_9:
	fld fs0, -24(s0)
	la s1, __flt_1
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 48
	sub s3, s2, s1
	fcvt.d.w fs0, s3
	fadd.d fs1, fs2, fs0
	fsd fs1, -24(s0)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L1_6
.L1_8:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_10
	j .L1_11
.L1_10:
	la s1, __flt_2
	fld fs0, 0(s1)
	fsd fs0, -40(s0)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L1_12:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_13
	j .L1_14
.L1_13:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_15
	j .L1_14
.L1_15:
	addi s1, s0, -40
	fld fs0, 0(s1)
	la s1, __flt_3
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -40(s0)
	addi s1, s0, -24
	fld fs0, 0(s1)
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 48
	sub s3, s2, s1
	fcvt.d.w fs1, s3
	fld fs2, -40(s0)
	fmul.d fs3, fs1, fs2
	fadd.d fs1, fs0, fs3
	fsd fs1, -24(s0)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L1_12
.L1_14:
.L1_11:
	lw s1, -32(s0)
	bnez s1, .L1_16
	j .L1_17
.L1_16:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 101
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_18
	j .L1_19
.L1_19:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 69
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_18
	j .L1_17
.L1_18:
	lw s1, -4(s0)
	sw s1, -44(s0)
	li s1, 0
	sw s1, -48(s0)
	li s1, 0
	sw s1, -52(s0)
	li s1, 0
	sw s1, -56(s0)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_20
	j .L1_21
.L1_21:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_20
	j .L1_22
.L1_20:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	sw s3, -48(s0)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L1_22:
.L1_23:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_24
	j .L1_25
.L1_24:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_26
	j .L1_25
.L1_26:
	lw s1, -52(s0)
	li s2, 10
	mul s3, s1, s2
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 48
	sub s4, s2, s1
	add s1, s3, s4
	sw s1, -52(s0)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	li s1, 1
	sw s1, -56(s0)
	j .L1_23
.L1_25:
	lw s1, -56(s0)
	bnez s1, .L1_27
	j .L1_28
.L1_27:
	la s1, __flt_4
	fld fs0, 0(s1)
	fsd fs0, -72(s0)
	li s1, 0
	sw s1, -60(s0)
.L1_29:
	lw s1, -60(s0)
	lw s2, -52(s0)
	slt s3, s1, s2
	bnez s3, .L1_30
	j .L1_31
.L1_30:
	addi s1, s0, -72
	fld fs0, 0(s1)
	la s1, __flt_5
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -72(s0)
.L1_32:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L1_29
.L1_31:
	lw s1, -48(s0)
	bnez s1, .L1_33
	j .L1_34
.L1_33:
	addi s1, s0, -24
	fld fs0, 0(s1)
	fld fs1, -72(s0)
	fdiv.d fs2, fs0, fs1
	fsd fs2, -24(s0)
	j .L1_35
.L1_34:
	addi s1, s0, -24
	fld fs0, 0(s1)
	fld fs1, -72(s0)
	fmul.d fs2, fs0, fs1
	fsd fs2, -24(s0)
.L1_35:
	j .L1_36
.L1_28:
	lw s1, -44(s0)
	sw s1, -4(s0)
.L1_36:
.L1_17:
	lw s1, -8(s0)
	bnez s1, .L1_37
	j .L1_38
.L1_37:
	lw s1, -32(s0)
	bnez s1, .L1_39
	j .L1_40
.L1_39:
	lw s1, -4(s0)
	sw s1, -76(s0)
	j .L1_41
.L1_40:
	lw s1, -12(s0)
	sw s1, -76(s0)
.L1_41:
	lw s1, -76(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
.L1_38:
	lw s1, -28(s0)
	bnez s1, .L1_42
	j .L1_43
.L1_42:
	fld fs0, -24(s0)
	fneg.d fs1, fs0
	fsd fs1, -88(s0)
	j .L1_44
.L1_43:
	fld fs0, -24(s0)
	fsd fs0, -88(s0)
.L1_44:
	fld fs0, -88(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -164(s0)
	lw s2, -160(s0)
	lw s3, -156(s0)
	lw s4, -152(s0)
	lw s5, -148(s0)
	lw s6, -144(s0)
	lw s7, -140(s0)
	lw s8, -136(s0)
	lw s9, -132(s0)
	lw s10, -128(s0)
	lw s11, -124(s0)
	fld fs0, -120(s0)
	fld fs1, -112(s0)
	fld fs2, -104(s0)
	fld fs3, -96(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	lw s1, -164(s0)
	lw s2, -160(s0)
	lw s3, -156(s0)
	lw s4, -152(s0)
	lw s5, -148(s0)
	lw s6, -144(s0)
	lw s7, -140(s0)
	lw s8, -136(s0)
	lw s9, -132(s0)
	lw s10, -128(s0)
	lw s11, -124(s0)
	fld fs0, -120(s0)
	fld fs1, -112(s0)
	fld fs2, -104(s0)
	fld fs3, -96(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end1:
	.size strtod, .Lfunc_end1-strtod

	.text
	.align 2
	.globl atof
	.type atof, @function
atof:
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
	li s2, 0
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	jal ra, strtod
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
.Lfunc_end2:
	.size atof, .Lfunc_end2-atof

	.data
	.align 3
__flt_5:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_4:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_3:
	.word 0x9999999a
	.word 0x3fb99999
	.align 3
__flt_2:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_1:
	.word 0x00000000
	.word 0x40240000
	.align 3
__flt_0:
	.word 0x00000000
	.word 0x00000000
