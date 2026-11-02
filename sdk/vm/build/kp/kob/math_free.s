# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

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
	lw s10, -8(s0)
	lw s11, -4(s0)
	addi s1, s0, -16
	sw s10, 0(s1)
	sw s11, 4(s1)
	addi s1, s0, -16
	fld fs0, 0(s1)
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
.Lfunc_end1:
	.size b2d, .Lfunc_end1-b2d

	.text
	.align 2
	.type d2b, @function
d2b:
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
	fld fs0, -8(s0)
	addi s1, s0, -16
	fsd fs0, 0(s1)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
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
	fld fs0, -24(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end2:
	.size d2b, .Lfunc_end2-d2b

	.text
	.align 2
	.type my_floor, @function
my_floor:
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
	fsd fs0, 48(sp)
	fsd fs1, 56(sp)
	fsd fs2, 64(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	fcvt.w.d s1, fs0, rtz
	fcvt.d.w fs0, s1
	fsd fs0, -16(s0)
	fld fs0, -16(s0)
	fld fs1, -8(s0)
	flt.d s1, fs1, fs0
	bnez s1, .L3_0
	j .L3_1
.L3_0:
	addi s1, s0, -16
	fld fs0, 0(s1)
	la s1, __flt_0
	fld fs1, 0(s1)
	fsub.d fs2, fs0, fs1
	fsd fs2, -16(s0)
.L3_1:
	fld fs0, -16(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -40(s0)
	fld fs1, -32(s0)
	fld fs2, -24(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -40(s0)
	fld fs1, -32(s0)
	fld fs2, -24(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size my_floor, .Lfunc_end3-my_floor

	.text
	.align 2
	.type my_round, @function
my_round:
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
	fsd fs1, 64(sp)
	fsd fs2, 72(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	la s1, __flt_1
	fld fs1, 0(s1)
	fadd.d fs2, fs0, fs1
	addi sp, sp, -16
	fsd fs2, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, my_floor
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs1, -24(s0)
	fld fs2, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs1, -24(s0)
	fld fs2, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end4:
	.size my_round, .Lfunc_end4-my_round

	.text
	.align 2
	.type ldexp2, @function
ldexp2:
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
	fsd fs0, 56(sp)
	fsd fs1, 64(sp)
	fsd fs2, 72(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	sw a2, -12(s0)
	lw s1, -12(s0)
	li s2, 1023
	add s3, s1, s2
	mv s10, s3
	srai s11, s10, 31
	li s1, 52
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	addi s1, s0, -24
	sw s8, 0(s1)
	sw s9, 4(s1)
	fld fs0, -8(s0)
	addi s1, s0, -24
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	addi sp, sp, -8
	fsd fs2, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -48(s0)
	fld fs1, -40(s0)
	fld fs2, -32(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -48(s0)
	fld fs1, -40(s0)
	fld fs2, -32(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end5:
	.size ldexp2, .Lfunc_end5-ldexp2

	.text
	.align 2
	.type sin_kernel, @function
sin_kernel:
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
	fsd fs0, 56(sp)
	fsd fs1, 64(sp)
	fsd fs2, 72(sp)
	fsd fs3, 80(sp)
	fsd fs4, 88(sp)
	fsd fs5, 96(sp)
	fsd fs6, 104(sp)
	fsd fs7, 112(sp)
	fsd fs8, 120(sp)
	fsd fs9, 128(sp)
	fsd fs10, 136(sp)
	fsd fs11, 144(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	fld fs1, -8(s0)
	fmul.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	fld ft0, -8(s0)
	fsd ft0, -24(s0)
	la s1, __flt_2
	fld ft0, 0(s1)
	fsd ft0, -32(s0)
	fld fs2, -16(s0)
	la s1, __flt_3
	fld fs3, 0(s1)
	fneg.d fs4, fs3
	li s1, 6
	fcvt.d.w fs3, s1
	fdiv.d fs5, fs4, fs3
	fld fs3, -16(s0)
	la s1, __flt_4
	fld fs4, 0(s1)
	li s1, 120
	fcvt.d.w fs6, s1
	fdiv.d fs7, fs4, fs6
	fld fs4, -16(s0)
	la s1, __flt_5
	fld fs6, 0(s1)
	fneg.d fs8, fs6
	li s1, 5040
	fcvt.d.w fs6, s1
	fdiv.d fs9, fs8, fs6
	fld fs6, -16(s0)
	la s1, __flt_6
	fld fs8, 0(s1)
	li s1, 362880
	fcvt.d.w fs10, s1
	fdiv.d fs11, fs8, fs10
	fld fs8, -16(s0)
	la s1, __flt_7
	fld fs10, 0(s1)
	fneg.d fs0, fs10
	li s1, 39916800
	fcvt.d.w fs10, s1
	fdiv.d fs1, fs0, fs10
	fmul.d fs0, fs8, fs1
	fadd.d fs1, fs11, fs0
	fmul.d fs0, fs6, fs1
	fadd.d fs1, fs9, fs0
	fmul.d fs0, fs4, fs1
	fadd.d fs1, fs7, fs0
	fmul.d fs0, fs3, fs1
	fadd.d fs1, fs5, fs0
	fmul.d fs0, fs2, fs1
	fld ft0, -32(s0)
	fadd.d fs1, ft0, fs0
	fld ft0, -24(s0)
	fmul.d fs0, ft0, fs1
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -128(s0)
	fld fs1, -120(s0)
	fld fs2, -112(s0)
	fld fs3, -104(s0)
	fld fs4, -96(s0)
	fld fs5, -88(s0)
	fld fs6, -80(s0)
	fld fs7, -72(s0)
	fld fs8, -64(s0)
	fld fs9, -56(s0)
	fld fs10, -48(s0)
	fld fs11, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -128(s0)
	fld fs1, -120(s0)
	fld fs2, -112(s0)
	fld fs3, -104(s0)
	fld fs4, -96(s0)
	fld fs5, -88(s0)
	fld fs6, -80(s0)
	fld fs7, -72(s0)
	fld fs8, -64(s0)
	fld fs9, -56(s0)
	fld fs10, -48(s0)
	fld fs11, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end6:
	.size sin_kernel, .Lfunc_end6-sin_kernel

	.text
	.align 2
	.type cos_kernel, @function
cos_kernel:
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
	fsd fs0, 48(sp)
	fsd fs1, 56(sp)
	fsd fs2, 64(sp)
	fsd fs3, 72(sp)
	fsd fs4, 80(sp)
	fsd fs5, 88(sp)
	fsd fs6, 96(sp)
	fsd fs7, 104(sp)
	fsd fs8, 112(sp)
	fsd fs9, 120(sp)
	fsd fs10, 128(sp)
	fsd fs11, 136(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	fld fs1, -8(s0)
	fmul.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	la s1, __flt_8
	fld ft0, 0(s1)
	fsd ft0, -24(s0)
	fld ft0, -16(s0)
	fsd ft0, -32(s0)
	la s1, __flt_9
	fld fs2, 0(s1)
	fneg.d ft0, fs2
	fsd ft0, -40(s0)
	fld fs2, -16(s0)
	la s1, __flt_10
	fld fs4, 0(s1)
	li s1, 24
	fcvt.d.w fs5, s1
	fdiv.d fs6, fs4, fs5
	fld fs4, -16(s0)
	la s1, __flt_11
	fld fs5, 0(s1)
	fneg.d fs7, fs5
	li s1, 720
	fcvt.d.w fs5, s1
	fdiv.d fs8, fs7, fs5
	fld fs5, -16(s0)
	la s1, __flt_12
	fld fs7, 0(s1)
	li s1, 40320
	fcvt.d.w fs9, s1
	fdiv.d fs10, fs7, fs9
	fld fs7, -16(s0)
	la s1, __flt_13
	fld fs9, 0(s1)
	fneg.d fs11, fs9
	li s1, 3628800
	fcvt.d.w fs9, s1
	fdiv.d fs0, fs11, fs9
	fld fs9, -16(s0)
	la s1, __flt_14
	fld fs11, 0(s1)
	li s1, 479001600
	fcvt.d.w fs1, s1
	fdiv.d fs3, fs11, fs1
	fmul.d fs1, fs9, fs3
	fadd.d fs3, fs0, fs1
	fmul.d fs0, fs7, fs3
	fadd.d fs1, fs10, fs0
	fmul.d fs0, fs5, fs1
	fadd.d fs1, fs8, fs0
	fmul.d fs0, fs4, fs1
	fadd.d fs1, fs6, fs0
	fmul.d fs0, fs2, fs1
	fld ft0, -40(s0)
	fadd.d fs1, ft0, fs0
	fld ft0, -32(s0)
	fmul.d fs0, ft0, fs1
	fld ft0, -24(s0)
	fadd.d fs1, ft0, fs0
	addi sp, sp, -8
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -136(s0)
	fld fs1, -128(s0)
	fld fs2, -120(s0)
	fld fs3, -112(s0)
	fld fs4, -104(s0)
	fld fs5, -96(s0)
	fld fs6, -88(s0)
	fld fs7, -80(s0)
	fld fs8, -72(s0)
	fld fs9, -64(s0)
	fld fs10, -56(s0)
	fld fs11, -48(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -136(s0)
	fld fs1, -128(s0)
	fld fs2, -120(s0)
	fld fs3, -112(s0)
	fld fs4, -104(s0)
	fld fs5, -96(s0)
	fld fs6, -88(s0)
	fld fs7, -80(s0)
	fld fs8, -72(s0)
	fld fs9, -64(s0)
	fld fs10, -56(s0)
	fld fs11, -48(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end7:
	.size cos_kernel, .Lfunc_end7-cos_kernel

	.text
	.align 2
	.type trig, @function
trig:
	addi sp, sp, -144
	sw ra, 140(sp)
	sw s0, 136(sp)
	addi s0, sp, 136
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	sw a2, -12(s0)
	fld fs0, -8(s0)
	la s1, __flt_15
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	addi sp, sp, -16
	fsd fs2, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, my_round
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -24(s0)
	fld fs0, -8(s0)
	fld fs1, -24(s0)
	la s1, __flt_16
	fld fs2, 0(s1)
	fmul.d fs3, fs1, fs2
	fsub.d fs1, fs0, fs3
	fld fs0, -24(s0)
	la s1, __flt_17
	fld fs2, 0(s1)
	fmul.d fs3, fs0, fs2
	fsub.d fs0, fs1, fs3
	fsd fs0, -32(s0)
	fld fs0, -24(s0)
	fcvt.w.d s1, fs0, rtz
	li s2, 3
	and s3, s1, s2
	sw s3, -36(s0)
	fld fs0, -32(s0)
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, sin_kernel
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	fsd fs1, -48(s0)
	fld fs0, -32(s0)
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, cos_kernel
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	fsd fs1, -56(s0)
	lw s1, -12(s0)
	bnez s1, .L8_0
	j .L8_1
.L8_1:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	li s1, 3
	and s2, s3, s1
	sw s2, -36(s0)
.L8_0:
	lw s1, -36(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_2
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_3
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_4
	j .L8_5
.L8_2:
	fld fs0, -48(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	fld fs0, -88(s0)
	fld fs1, -80(s0)
	fld fs2, -72(s0)
	fld fs3, -64(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_3:
	fld fs0, -56(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	fld fs0, -88(s0)
	fld fs1, -80(s0)
	fld fs2, -72(s0)
	fld fs3, -64(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_4:
	fld fs0, -48(s0)
	fneg.d fs1, fs0
	addi sp, sp, -8
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	fld fs0, -88(s0)
	fld fs1, -80(s0)
	fld fs2, -72(s0)
	fld fs3, -64(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_5:
	fld fs0, -56(s0)
	fneg.d fs1, fs0
	addi sp, sp, -8
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	fld fs0, -88(s0)
	fld fs1, -80(s0)
	fld fs2, -72(s0)
	fld fs3, -64(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_6:
	li s1, 0
	mv a0, s1
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	fld fs0, -88(s0)
	fld fs1, -80(s0)
	fld fs2, -72(s0)
	fld fs3, -64(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end8:
	.size trig, .Lfunc_end8-trig

	.text
	.align 2
	.globl my_sin
	.type my_sin, @function
my_sin:
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
	fsd fs1, 56(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	li s1, 1
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	mv a2, s1
	jal ra, trig
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs1, 0(sp)
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
	fld fs1, -16(s0)
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
	fld fs1, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end9:
	.size my_sin, .Lfunc_end9-my_sin

	.text
	.align 2
	.globl my_cos
	.type my_cos, @function
my_cos:
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
	fsd fs1, 56(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	li s1, 0
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	mv a2, s1
	jal ra, trig
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs1, 0(sp)
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
	fld fs1, -16(s0)
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
	fld fs1, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end10:
	.size my_cos, .Lfunc_end10-my_cos

	.text
	.align 2
	.globl my_exp
	.type my_exp, @function
my_exp:
	addi sp, sp, -224
	sw ra, 220(sp)
	sw s0, 216(sp)
	addi s0, sp, 216
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
	fsd fs4, 80(sp)
	fsd fs5, 88(sp)
	fsd fs6, 96(sp)
	fsd fs7, 104(sp)
	fsd fs8, 112(sp)
	fsd fs9, 120(sp)
	fsd fs10, 128(sp)
	fsd fs11, 136(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	fld fs1, -8(s0)
	feq.d s1, fs0, fs1
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	fld fs0, -8(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -212(s0)
	lw s2, -208(s0)
	lw s3, -204(s0)
	lw s4, -200(s0)
	lw s5, -196(s0)
	lw s6, -192(s0)
	lw s7, -188(s0)
	lw s8, -184(s0)
	lw s9, -180(s0)
	lw s10, -176(s0)
	lw s11, -172(s0)
	fld fs0, -168(s0)
	fld fs1, -160(s0)
	fld fs2, -152(s0)
	fld fs3, -144(s0)
	fld fs4, -136(s0)
	fld fs5, -128(s0)
	fld fs6, -120(s0)
	fld fs7, -112(s0)
	fld fs8, -104(s0)
	fld fs9, -96(s0)
	fld fs10, -88(s0)
	fld fs11, -80(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L11_1:
	fld fs0, -8(s0)
	la s1, __flt_18
	fld fs1, 0(s1)
	flt.d s1, fs1, fs0
	bnez s1, .L11_2
	j .L11_3
.L11_2:
	li s10, 0
	li s11, 2146435072
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -212(s0)
	lw s2, -208(s0)
	lw s3, -204(s0)
	lw s4, -200(s0)
	lw s5, -196(s0)
	lw s6, -192(s0)
	lw s7, -188(s0)
	lw s8, -184(s0)
	lw s9, -180(s0)
	lw s10, -176(s0)
	lw s11, -172(s0)
	fld fs0, -168(s0)
	fld fs1, -160(s0)
	fld fs2, -152(s0)
	fld fs3, -144(s0)
	fld fs4, -136(s0)
	fld fs5, -128(s0)
	fld fs6, -120(s0)
	fld fs7, -112(s0)
	fld fs8, -104(s0)
	fld fs9, -96(s0)
	fld fs10, -88(s0)
	fld fs11, -80(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L11_3:
	fld fs0, -8(s0)
	la s1, __flt_19
	fld fs1, 0(s1)
	fneg.d fs2, fs1
	flt.d s1, fs0, fs2
	bnez s1, .L11_4
	j .L11_5
.L11_4:
	la s1, __flt_20
	fld fs0, 0(s1)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -212(s0)
	lw s2, -208(s0)
	lw s3, -204(s0)
	lw s4, -200(s0)
	lw s5, -196(s0)
	lw s6, -192(s0)
	lw s7, -188(s0)
	lw s8, -184(s0)
	lw s9, -180(s0)
	lw s10, -176(s0)
	lw s11, -172(s0)
	fld fs0, -168(s0)
	fld fs1, -160(s0)
	fld fs2, -152(s0)
	fld fs3, -144(s0)
	fld fs4, -136(s0)
	fld fs5, -128(s0)
	fld fs6, -120(s0)
	fld fs7, -112(s0)
	fld fs8, -104(s0)
	fld fs9, -96(s0)
	fld fs10, -88(s0)
	fld fs11, -80(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L11_5:
	fld fs0, -8(s0)
	la s1, __flt_21
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	addi sp, sp, -16
	fsd fs2, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, my_round
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -16(s0)
	fld fs0, -8(s0)
	fld fs1, -16(s0)
	la s1, __flt_22
	fld fs2, 0(s1)
	fmul.d fs3, fs1, fs2
	fsub.d fs1, fs0, fs3
	fld fs0, -16(s0)
	la s1, __flt_23
	fld fs2, 0(s1)
	fmul.d fs3, fs0, fs2
	fsub.d fs0, fs1, fs3
	fsd fs0, -24(s0)
	la s1, __flt_24
	fld ft0, 0(s1)
	fsd ft0, -40(s0)
	fld ft0, -24(s0)
	fsd ft0, -48(s0)
	la s1, __flt_25
	fld ft0, 0(s1)
	fsd ft0, -56(s0)
	fld ft0, -24(s0)
	fsd ft0, -64(s0)
	la s1, __flt_26
	fld fs4, 0(s1)
	li s1, 2
	fcvt.d.w fs5, s1
	fdiv.d ft0, fs4, fs5
	fsd ft0, -72(s0)
	fld fs4, -24(s0)
	la s1, __flt_27
	fld fs5, 0(s1)
	li s1, 6
	fcvt.d.w fs7, s1
	fdiv.d fs8, fs5, fs7
	fld fs5, -24(s0)
	la s1, __flt_28
	fld fs7, 0(s1)
	li s1, 24
	fcvt.d.w fs9, s1
	fdiv.d fs10, fs7, fs9
	fld fs7, -24(s0)
	la s1, __flt_29
	fld fs9, 0(s1)
	li s1, 120
	fcvt.d.w fs11, s1
	fdiv.d fs0, fs9, fs11
	fld fs9, -24(s0)
	la s1, __flt_30
	fld fs11, 0(s1)
	li s1, 720
	fcvt.d.w fs1, s1
	fdiv.d fs2, fs11, fs1
	fld fs1, -24(s0)
	la s1, __flt_31
	fld fs11, 0(s1)
	li s1, 5040
	fcvt.d.w fs3, s1
	fdiv.d fs6, fs11, fs3
	fmul.d fs3, fs1, fs6
	fadd.d fs1, fs2, fs3
	fmul.d fs2, fs9, fs1
	fadd.d fs1, fs0, fs2
	fmul.d fs0, fs7, fs1
	fadd.d fs1, fs10, fs0
	fmul.d fs0, fs5, fs1
	fadd.d fs1, fs8, fs0
	fmul.d fs0, fs4, fs1
	fld ft0, -72(s0)
	fadd.d fs1, ft0, fs0
	fld ft0, -64(s0)
	fmul.d fs0, ft0, fs1
	fld ft0, -56(s0)
	fadd.d fs1, ft0, fs0
	fld ft0, -48(s0)
	fmul.d fs0, ft0, fs1
	fld ft0, -40(s0)
	fadd.d fs1, ft0, fs0
	fsd fs1, -32(s0)
	fld fs0, -32(s0)
	fld fs1, -16(s0)
	fcvt.w.d s1, fs1, rtz
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	mv a2, s1
	jal ra, ldexp2
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -212(s0)
	lw s2, -208(s0)
	lw s3, -204(s0)
	lw s4, -200(s0)
	lw s5, -196(s0)
	lw s6, -192(s0)
	lw s7, -188(s0)
	lw s8, -184(s0)
	lw s9, -180(s0)
	lw s10, -176(s0)
	lw s11, -172(s0)
	fld fs0, -168(s0)
	fld fs1, -160(s0)
	fld fs2, -152(s0)
	fld fs3, -144(s0)
	fld fs4, -136(s0)
	fld fs5, -128(s0)
	fld fs6, -120(s0)
	fld fs7, -112(s0)
	fld fs8, -104(s0)
	fld fs9, -96(s0)
	fld fs10, -88(s0)
	fld fs11, -80(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	lw s1, -212(s0)
	lw s2, -208(s0)
	lw s3, -204(s0)
	lw s4, -200(s0)
	lw s5, -196(s0)
	lw s6, -192(s0)
	lw s7, -188(s0)
	lw s8, -184(s0)
	lw s9, -180(s0)
	lw s10, -176(s0)
	lw s11, -172(s0)
	fld fs0, -168(s0)
	fld fs1, -160(s0)
	fld fs2, -152(s0)
	fld fs3, -144(s0)
	fld fs4, -136(s0)
	fld fs5, -128(s0)
	fld fs6, -120(s0)
	fld fs7, -112(s0)
	fld fs8, -104(s0)
	fld fs9, -96(s0)
	fld fs10, -88(s0)
	fld fs11, -80(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end11:
	.size my_exp, .Lfunc_end11-my_exp

	.text
	.align 2
	.globl my_ln
	.type my_ln, @function
my_ln:
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
	fsd fs3, 72(sp)
	fsd fs4, 80(sp)
	fsd fs5, 88(sp)
	fsd fs6, 96(sp)
	fsd fs7, 104(sp)
	fsd fs8, 112(sp)
	fsd fs9, 120(sp)
	fsd fs10, 128(sp)
	fsd fs11, 136(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	fld fs1, -8(s0)
	feq.d s1, fs0, fs1
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_0
	j .L12_1
.L12_0:
	fld fs0, -8(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs3, -160(s0)
	fld fs4, -152(s0)
	fld fs5, -144(s0)
	fld fs6, -136(s0)
	fld fs7, -128(s0)
	fld fs8, -120(s0)
	fld fs9, -112(s0)
	fld fs10, -104(s0)
	fld fs11, -96(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_1:
	fld fs0, -8(s0)
	la s1, __flt_32
	fld fs1, 0(s1)
	flt.d s1, fs0, fs1
	bnez s1, .L12_2
	j .L12_3
.L12_2:
	li s10, 0
	li s11, 2146959360
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs3, -160(s0)
	fld fs4, -152(s0)
	fld fs5, -144(s0)
	fld fs6, -136(s0)
	fld fs7, -128(s0)
	fld fs8, -120(s0)
	fld fs9, -112(s0)
	fld fs10, -104(s0)
	fld fs11, -96(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_3:
	fld fs0, -8(s0)
	la s1, __flt_33
	fld fs1, 0(s1)
	feq.d s1, fs0, fs1
	bnez s1, .L12_4
	j .L12_5
.L12_4:
	li s10, 0
	li s11, -1048576
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs3, -160(s0)
	fld fs4, -152(s0)
	fld fs5, -144(s0)
	fld fs6, -136(s0)
	fld fs7, -128(s0)
	fld fs8, -120(s0)
	fld fs9, -112(s0)
	fld fs10, -104(s0)
	fld fs11, -96(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L12_5:
	fld fs0, -8(s0)
	addi s1, s0, -16
	fsd fs0, 0(s1)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 52
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	li s1, 2047
	mv s10, s1
	srai s11, s10, 31
	and s6, s8, s10
	and s7, s9, s11
	mv s1, s6
	li s2, 1023
	sub s3, s1, s2
	sw s3, -20(s0)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s8, -1
	li s9, 1048575
	and s6, s10, s8
	and s7, s11, s9
	li s10, 1023
	li s11, 0
	li s1, 52
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	or s10, s6, s8
	or s11, s7, s9
	addi s1, s0, -16
	sw s10, 0(s1)
	sw s11, 4(s1)
	addi s1, s0, -16
	fld fs0, 0(s1)
	fsd fs0, -32(s0)
	fld fs0, -32(s0)
	la s1, __flt_34
	fld fs1, 0(s1)
	flt.d s1, fs1, fs0
	bnez s1, .L12_6
	j .L12_7
.L12_6:
	addi s1, s0, -32
	fld fs0, 0(s1)
	la s1, __flt_35
	fld fs1, 0(s1)
	fmul.d fs2, fs0, fs1
	fsd fs2, -32(s0)
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
.L12_7:
	fld fs0, -32(s0)
	la s1, __flt_36
	fld fs1, 0(s1)
	fsub.d fs2, fs0, fs1
	fld fs0, -32(s0)
	la s1, __flt_37
	fld fs1, 0(s1)
	fadd.d fs3, fs0, fs1
	fdiv.d fs0, fs2, fs3
	fsd fs0, -40(s0)
	fld fs0, -40(s0)
	fld fs1, -40(s0)
	fmul.d fs2, fs0, fs1
	fsd fs2, -48(s0)
	fld ft0, -40(s0)
	fsd ft0, -64(s0)
	la s1, __flt_38
	fld ft0, 0(s1)
	fsd ft0, -72(s0)
	fld ft0, -48(s0)
	fsd ft0, -80(s0)
	la s1, __flt_39
	fld fs3, 0(s1)
	li s1, 3
	fcvt.d.w fs4, s1
	fdiv.d ft0, fs3, fs4
	fsd ft0, -88(s0)
	fld fs3, -48(s0)
	la s1, __flt_40
	fld fs4, 0(s1)
	li s1, 5
	fcvt.d.w fs6, s1
	fdiv.d fs7, fs4, fs6
	fld fs4, -48(s0)
	la s1, __flt_41
	fld fs6, 0(s1)
	li s1, 7
	fcvt.d.w fs8, s1
	fdiv.d fs9, fs6, fs8
	fld fs6, -48(s0)
	la s1, __flt_42
	fld fs8, 0(s1)
	li s1, 9
	fcvt.d.w fs10, s1
	fdiv.d fs11, fs8, fs10
	fld fs8, -48(s0)
	la s1, __flt_43
	fld fs10, 0(s1)
	li s1, 11
	fcvt.d.w fs0, s1
	fdiv.d fs1, fs10, fs0
	fld fs0, -48(s0)
	la s1, __flt_44
	fld fs10, 0(s1)
	li s1, 13
	fcvt.d.w fs2, s1
	fdiv.d fs5, fs10, fs2
	fmul.d fs2, fs0, fs5
	fadd.d fs0, fs1, fs2
	fmul.d fs1, fs8, fs0
	fadd.d fs0, fs11, fs1
	fmul.d fs1, fs6, fs0
	fadd.d fs0, fs9, fs1
	fmul.d fs1, fs4, fs0
	fadd.d fs0, fs7, fs1
	fmul.d fs1, fs3, fs0
	fld ft0, -88(s0)
	fadd.d fs0, ft0, fs1
	fld ft0, -80(s0)
	fmul.d fs1, ft0, fs0
	fld ft0, -72(s0)
	fadd.d fs0, ft0, fs1
	fld ft0, -64(s0)
	fmul.d fs1, ft0, fs0
	fsd fs1, -56(s0)
	lw s1, -20(s0)
	la s2, __flt_45
	fld fs0, 0(s2)
	fcvt.d.w fs1, s1
	fmul.d fs2, fs1, fs0
	la s1, __flt_46
	fld fs0, 0(s1)
	fld fs1, -56(s0)
	fmul.d fs3, fs0, fs1
	fadd.d fs0, fs2, fs3
	lw s1, -20(s0)
	la s2, __flt_47
	fld fs1, 0(s2)
	fcvt.d.w fs2, s1
	fmul.d fs3, fs2, fs1
	fadd.d fs1, fs0, fs3
	addi sp, sp, -8
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs3, -160(s0)
	fld fs4, -152(s0)
	fld fs5, -144(s0)
	fld fs6, -136(s0)
	fld fs7, -128(s0)
	fld fs8, -120(s0)
	fld fs9, -112(s0)
	fld fs10, -104(s0)
	fld fs11, -96(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs3, -160(s0)
	fld fs4, -152(s0)
	fld fs5, -144(s0)
	fld fs6, -136(s0)
	fld fs7, -128(s0)
	fld fs8, -120(s0)
	fld fs9, -112(s0)
	fld fs10, -104(s0)
	fld fs11, -96(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end12:
	.size my_ln, .Lfunc_end12-my_ln

	.text
	.align 2
	.type atan_kernel, @function
atan_kernel:
	addi sp, sp, -224
	sw ra, 220(sp)
	sw s0, 216(sp)
	addi s0, sp, 216
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
	fsd fs3, 80(sp)
	fsd fs4, 88(sp)
	fsd fs5, 96(sp)
	fsd fs6, 104(sp)
	fsd fs7, 112(sp)
	fsd fs8, 120(sp)
	fsd fs9, 128(sp)
	fsd fs10, 136(sp)
	fsd fs11, 144(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	fld fs1, -8(s0)
	fmul.d fs2, fs0, fs1
	fsd fs2, -16(s0)
	fld ft0, -8(s0)
	fsd ft0, -24(s0)
	la s1, __flt_48
	fld ft0, 0(s1)
	fsd ft0, -32(s0)
	fld ft0, -16(s0)
	fsd ft0, -40(s0)
	la s1, __flt_49
	fld fs3, 0(s1)
	fneg.d fs4, fs3
	li s1, 3
	fcvt.d.w fs3, s1
	fdiv.d ft0, fs4, fs3
	fsd ft0, -48(s0)
	fld ft0, -16(s0)
	fsd ft0, -56(s0)
	la s1, __flt_50
	fld fs4, 0(s1)
	li s1, 5
	fcvt.d.w fs6, s1
	fdiv.d ft0, fs4, fs6
	fsd ft0, -64(s0)
	fld fs4, -16(s0)
	la s1, __flt_51
	fld fs6, 0(s1)
	fneg.d fs8, fs6
	li s1, 7
	fcvt.d.w fs6, s1
	fdiv.d fs9, fs8, fs6
	fld fs6, -16(s0)
	la s1, __flt_52
	fld fs8, 0(s1)
	li s1, 9
	fcvt.d.w fs10, s1
	fdiv.d fs11, fs8, fs10
	fld fs8, -16(s0)
	la s1, __flt_53
	fld fs10, 0(s1)
	fneg.d fs0, fs10
	li s1, 11
	fcvt.d.w fs10, s1
	fdiv.d fs1, fs0, fs10
	fld fs0, -16(s0)
	la s1, __flt_54
	fld fs10, 0(s1)
	li s1, 13
	fcvt.d.w fs2, s1
	fdiv.d fs5, fs10, fs2
	fld fs2, -16(s0)
	la s1, __flt_55
	fld fs10, 0(s1)
	fneg.d fs3, fs10
	li s1, 15
	fcvt.d.w fs10, s1
	fdiv.d fs7, fs3, fs10
	fmul.d fs3, fs2, fs7
	fadd.d fs2, fs5, fs3
	fmul.d fs3, fs0, fs2
	fadd.d fs0, fs1, fs3
	fmul.d fs1, fs8, fs0
	fadd.d fs0, fs11, fs1
	fmul.d fs1, fs6, fs0
	fadd.d fs0, fs9, fs1
	fmul.d fs1, fs4, fs0
	fld ft0, -64(s0)
	fadd.d fs0, ft0, fs1
	fld ft0, -56(s0)
	fmul.d fs1, ft0, fs0
	fld ft0, -48(s0)
	fadd.d fs0, ft0, fs1
	fld ft0, -40(s0)
	fmul.d fs1, ft0, fs0
	fld ft0, -32(s0)
	fadd.d fs0, ft0, fs1
	fld ft0, -24(s0)
	fmul.d fs1, ft0, fs0
	addi sp, sp, -8
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	lw s1, -204(s0)
	lw s2, -200(s0)
	lw s3, -196(s0)
	lw s4, -192(s0)
	lw s5, -188(s0)
	lw s6, -184(s0)
	lw s7, -180(s0)
	lw s8, -176(s0)
	lw s9, -172(s0)
	lw s10, -168(s0)
	lw s11, -164(s0)
	fld fs0, -160(s0)
	fld fs1, -152(s0)
	fld fs2, -144(s0)
	fld fs3, -136(s0)
	fld fs4, -128(s0)
	fld fs5, -120(s0)
	fld fs6, -112(s0)
	fld fs7, -104(s0)
	fld fs8, -96(s0)
	fld fs9, -88(s0)
	fld fs10, -80(s0)
	fld fs11, -72(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	lw s1, -204(s0)
	lw s2, -200(s0)
	lw s3, -196(s0)
	lw s4, -192(s0)
	lw s5, -188(s0)
	lw s6, -184(s0)
	lw s7, -180(s0)
	lw s8, -176(s0)
	lw s9, -172(s0)
	lw s10, -168(s0)
	lw s11, -164(s0)
	fld fs0, -160(s0)
	fld fs1, -152(s0)
	fld fs2, -144(s0)
	fld fs3, -136(s0)
	fld fs4, -128(s0)
	fld fs5, -120(s0)
	fld fs6, -112(s0)
	fld fs7, -104(s0)
	fld fs8, -96(s0)
	fld fs9, -88(s0)
	fld fs10, -80(s0)
	fld fs11, -72(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end13:
	.size atan_kernel, .Lfunc_end13-atan_kernel

	.text
	.align 2
	.globl my_atan
	.type my_atan, @function
my_atan:
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
	fsd fs0, 48(sp)
	fsd fs1, 56(sp)
	fsd fs2, 64(sp)
	fsd fs3, 72(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	li s1, 0
	sw s1, -12(s0)
	li s1, 0
	sw s1, -16(s0)
	fld fs0, -8(s0)
	fld fs1, -8(s0)
	feq.d s1, fs0, fs1
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_0
	j .L14_1
.L14_0:
	fld fs0, -8(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -72(s0)
	fld fs1, -64(s0)
	fld fs2, -56(s0)
	fld fs3, -48(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L14_1:
	fld fs0, -8(s0)
	la s1, __flt_56
	fld fs1, 0(s1)
	flt.d s1, fs0, fs1
	bnez s1, .L14_2
	j .L14_3
.L14_2:
	fld fs0, -8(s0)
	fneg.d fs1, fs0
	fsd fs1, -8(s0)
	li s1, 1
	sw s1, -12(s0)
.L14_3:
	fld fs0, -8(s0)
	la s1, __flt_57
	fld fs1, 0(s1)
	flt.d s1, fs1, fs0
	bnez s1, .L14_4
	j .L14_5
.L14_4:
	la s1, __flt_58
	fld fs0, 0(s1)
	fld fs1, -8(s0)
	fdiv.d fs2, fs0, fs1
	fsd fs2, -8(s0)
	li s1, 1
	sw s1, -16(s0)
.L14_5:
	fld fs0, -8(s0)
	la s1, __flt_59
	fld fs1, 0(s1)
	flt.d s1, fs1, fs0
	bnez s1, .L14_6
	j .L14_7
.L14_6:
	fld fs0, -8(s0)
	la s1, __flt_60
	fld fs1, 0(s1)
	fsub.d fs2, fs0, fs1
	fld fs0, -8(s0)
	la s1, __flt_61
	fld fs1, 0(s1)
	fadd.d fs3, fs0, fs1
	fdiv.d fs0, fs2, fs3
	fsd fs0, -24(s0)
	la s1, __flt_62
	fld fs0, 0(s1)
	fld fs1, -24(s0)
	addi sp, sp, -16
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, atan_kernel
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs2, 0(sp)
	addi sp, sp, 16
	fadd.d fs1, fs0, fs2
	fsd fs1, -32(s0)
	j .L14_8
.L14_7:
	fld fs0, -8(s0)
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, atan_kernel
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	fsd fs1, -32(s0)
.L14_8:
	lw s1, -16(s0)
	bnez s1, .L14_9
	j .L14_10
.L14_9:
	la s1, __flt_63
	fld fs0, 0(s1)
	fld fs1, -32(s0)
	fsub.d fs2, fs0, fs1
	fsd fs2, -32(s0)
.L14_10:
	lw s1, -12(s0)
	bnez s1, .L14_11
	j .L14_12
.L14_11:
	fld fs0, -32(s0)
	fneg.d fs1, fs0
	fsd fs1, -40(s0)
	j .L14_13
.L14_12:
	fld fs0, -32(s0)
	fsd fs0, -40(s0)
.L14_13:
	fld fs0, -40(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -72(s0)
	fld fs1, -64(s0)
	fld fs2, -56(s0)
	fld fs3, -48(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -72(s0)
	fld fs1, -64(s0)
	fld fs2, -56(s0)
	fld fs3, -48(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end14:
	.size my_atan, .Lfunc_end14-my_atan

	.text
	.align 2
	.globl brv_sin
	.type brv_sin, @function
brv_sin:
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
	fsd fs1, 56(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, my_sin
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, d2b
	mv s10, a0
	mv s11, a1
	addi sp, sp, 16
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
	fld fs0, -24(s0)
	fld fs1, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end15:
	.size brv_sin, .Lfunc_end15-brv_sin

	.text
	.align 2
	.globl brv_cos
	.type brv_cos, @function
brv_cos:
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
	fsd fs1, 56(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, my_cos
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, d2b
	mv s10, a0
	mv s11, a1
	addi sp, sp, 16
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
	fld fs0, -24(s0)
	fld fs1, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end16:
	.size brv_cos, .Lfunc_end16-brv_cos

	.text
	.align 2
	.globl brv_exp
	.type brv_exp, @function
brv_exp:
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
	fsd fs1, 56(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, my_exp
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, d2b
	mv s10, a0
	mv s11, a1
	addi sp, sp, 16
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
	fld fs0, -24(s0)
	fld fs1, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end17:
	.size brv_exp, .Lfunc_end17-brv_exp

	.text
	.align 2
	.globl brv_ln
	.type brv_ln, @function
brv_ln:
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
	fsd fs1, 56(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, my_ln
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, d2b
	mv s10, a0
	mv s11, a1
	addi sp, sp, 16
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
	fld fs0, -24(s0)
	fld fs1, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end18:
	.size brv_ln, .Lfunc_end18-brv_ln

	.text
	.align 2
	.globl brv_arctan
	.type brv_arctan, @function
brv_arctan:
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
	fsd fs1, 56(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	addi sp, sp, -16
	mv a0, s10
	mv a1, s11
	jal ra, b2d
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, my_atan
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs1, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -16
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, d2b
	mv s10, a0
	mv s11, a1
	addi sp, sp, 16
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
	fld fs0, -24(s0)
	fld fs1, -16(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end19:
	.size brv_arctan, .Lfunc_end19-brv_arctan

	.data
	.align 3
__flt_63:
	.word 0x54442d18
	.word 0x3ff921fb
	.align 3
__flt_62:
	.word 0x54442d18
	.word 0x3fe921fb
	.align 3
__flt_61:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_60:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_59:
	.word 0x99fcef32
	.word 0x3fda8279
	.align 3
__flt_58:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_57:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_56:
	.word 0x00000000
	.word 0x00000000
	.align 3
__flt_55:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_54:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_53:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_52:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_51:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_50:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_49:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_48:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_47:
	.word 0x35793c76
	.word 0x3dea39ef
	.align 3
__flt_46:
	.word 0x00000000
	.word 0x40000000
	.align 3
__flt_45:
	.word 0xfee00000
	.word 0x3fe62e42
	.align 3
__flt_44:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_43:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_42:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_41:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_40:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_39:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_38:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_37:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_36:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_35:
	.word 0x00000000
	.word 0x3fe00000
	.align 3
__flt_34:
	.word 0x667f3bcd
	.word 0x3ff6a09e
	.align 3
__flt_33:
	.word 0x00000000
	.word 0x00000000
	.align 3
__flt_32:
	.word 0x00000000
	.word 0x00000000
	.align 3
__flt_31:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_30:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_29:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_28:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_27:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_26:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_25:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_24:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_23:
	.word 0x35793c76
	.word 0x3dea39ef
	.align 3
__flt_22:
	.word 0xfee00000
	.word 0x3fe62e42
	.align 3
__flt_21:
	.word 0x652b82fe
	.word 0x3ff71547
	.align 3
__flt_20:
	.word 0x00000000
	.word 0x00000000
	.align 3
__flt_19:
	.word 0x00000000
	.word 0x40874800
	.align 3
__flt_18:
	.word 0x70a3d70a
	.word 0x40862e3d
	.align 3
__flt_17:
	.word 0x33145c07
	.word 0x3c91a626
	.align 3
__flt_16:
	.word 0x54442d18
	.word 0x3ff921fb
	.align 3
__flt_15:
	.word 0x6dc9c883
	.word 0x3fe45f30
	.align 3
__flt_14:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_13:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_12:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_11:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_10:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_9:
	.word 0x00000000
	.word 0x3fe00000
	.align 3
__flt_8:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_7:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_6:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_5:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_4:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_3:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_2:
	.word 0x00000000
	.word 0x3ff00000
	.align 3
__flt_1:
	.word 0x00000000
	.word 0x3fe00000
	.align 3
__flt_0:
	.word 0x00000000
	.word 0x3ff00000
