# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type sort_by_start, @function
sort_by_start:
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
	lw s1, -8(s0)
	sw s1, -16(s0)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	sub s3, s1, s2
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
.L1_1:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	sub s3, s1, s2
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
.Lfunc_end1:
	.size sort_by_start, .Lfunc_end1-sort_by_start

	.text
	.align 2
	.type linscan, @function
linscan:
	addi sp, sp, -240
	sw ra, 236(sp)
	sw s0, 232(sp)
	addi s0, sp, 232
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
	sw a5, -24(s0)
	sw a6, -28(s0)
	sw a7, -32(s0)
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, arena_save
	sw a0, -96(s0)
	sw a1, -92(s0)
	addi s1, s0, -96
	addi s3, s0, -48
	lw s4, 0(s1)
	sw s4, 0(s3)
	li s4, 4
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 4
	add s5, s3, s4
	sw s1, 0(s5)
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -52(s0)
	li s4, 20
	mul s5, s1, s4
	mv a0, s3
	mv a1, s5
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -56(s0)
	li s1, 0
	sw s1, -68(s0)
.L2_0:
	lw s1, -68(s0)
	lw s2, -52(s0)
	slt s3, s1, s2
	bnez s3, .L2_1
	j .L2_2
.L2_1:
	lw s1, -16(s0)
	lw s2, -68(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L2_3
	j .L2_4
.L2_3:
	lw s1, -8(s0)
	lw s2, -68(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L2_4
	j .L2_5
.L2_4:
	j .L2_6
.L2_5:
	lw s1, -68(s0)
	lw s2, -36(s0)
	lw s3, -56(s0)
	li s4, 20
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -8(s0)
	lw s2, -68(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -36(s0)
	lw s3, -56(s0)
	li s4, 20
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -68(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -8(s0)
	lw s3, -68(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_7
	j .L2_8
.L2_7:
	lw s1, -12(s0)
	lw s2, -68(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -100(s0)
	j .L2_9
.L2_8:
	lw s1, -8(s0)
	lw s2, -68(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -100(s0)
.L2_9:
	lw s1, -100(s0)
	lw s2, -36(s0)
	lw s3, -56(s0)
	li s4, 20
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -36(s0)
	lw s3, -56(s0)
	li s4, 20
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 12
	add s4, s3, s1
	sw s2, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -36(s0)
	lw s3, -56(s0)
	li s4, 20
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 16
	add s4, s3, s1
	sw s2, 0(s4)
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -56(s0)
.L2_6:
	addi s1, s0, -68
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -68(s0)
	j .L2_0
.L2_2:
	lw s1, -56(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_10
	j .L2_11
.L2_10:
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -48
	lw s3, 0(s1)
	li s4, 4
	add s5, s1, s4
	lw s1, 0(s5)
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, arena_release
	mv s4, a0
	li s1, 0
	mv a0, s1
	lw s1, -220(s0)
	lw s2, -216(s0)
	lw s3, -212(s0)
	lw s4, -208(s0)
	lw s5, -204(s0)
	lw s6, -200(s0)
	lw s7, -196(s0)
	lw s8, -192(s0)
	lw s9, -188(s0)
	lw s10, -184(s0)
	lw s11, -180(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L2_11:
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_12
	j .L2_13
.L2_12:
	li s1, 0
	sw s1, -76(s0)
.L2_14:
	lw s1, -76(s0)
	lw s2, -56(s0)
	slt s3, s1, s2
	bnez s3, .L2_15
	j .L2_16
.L2_15:
	li s1, 1
	neg s2, s1
	lw s1, -4(s0)
	li s3, 84
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -36(s0)
	lw s4, -76(s0)
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -76(s0)
	lw s2, -28(s0)
	mul s3, s1, s2
	lw s1, -4(s0)
	li s2, 88
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -36(s0)
	lw s4, -76(s0)
	li s5, 20
	mul s6, s4, s5
	add s4, s2, s6
	lw s2, 0(s4)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L2_17:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
	j .L2_14
.L2_16:
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -48
	lw s3, 0(s1)
	li s4, 4
	add s5, s1, s4
	lw s1, 0(s5)
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, arena_release
	mv s4, a0
	lw s1, -56(s0)
	mv a0, s1
	lw s1, -220(s0)
	lw s2, -216(s0)
	lw s3, -212(s0)
	lw s4, -208(s0)
	lw s5, -204(s0)
	lw s6, -200(s0)
	lw s7, -196(s0)
	lw s8, -192(s0)
	lw s9, -188(s0)
	lw s10, -184(s0)
	lw s11, -180(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L2_13:
	lw s1, -36(s0)
	lw s2, -56(s0)
	li s3, 20
	la s4, sort_by_start
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, qsort
	mv s5, a0
	li s1, 0
	sw s1, -72(s0)
.L2_18:
	lw s1, -72(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L2_19
	j .L2_20
.L2_19:
	lw s1, -32(s0)
	bnez s1, .L2_21
	j .L2_22
.L2_21:
	lw s1, -32(s0)
	lw s2, -72(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L2_23
	j .L2_22
.L2_23:
	li s1, 0
	sw s1, -156(s0)
	j .L2_24
.L2_22:
	li s1, 1
	sw s1, -156(s0)
.L2_24:
	lw s1, -156(s0)
	addi s2, s0, -152
	lw s3, -72(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L2_25:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -72(s0)
	j .L2_18
.L2_20:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -20(s0)
	li s3, 1
	add s4, s1, s3
	li s1, 4
	mul s3, s4, s1
	mv a0, s2
	mv a1, s3
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -40(s0)
	li s1, 0
	sw s1, -60(s0)
	li s1, 0
	sw s1, -64(s0)
	li s1, 0
	sw s1, -76(s0)
.L2_26:
	lw s1, -76(s0)
	lw s2, -56(s0)
	slt s3, s1, s2
	bnez s3, .L2_27
	j .L2_28
.L2_27:
	lw s1, -36(s0)
	lw s2, -76(s0)
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -160(s0)
	li s1, 0
	sw s1, -84(s0)
	li s1, 0
	sw s1, -80(s0)
.L2_29:
	lw s1, -80(s0)
	lw s2, -60(s0)
	slt s3, s1, s2
	bnez s3, .L2_30
	j .L2_31
.L2_30:
	lw s1, -40(s0)
	lw s2, -80(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -160(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L2_32
	j .L2_33
.L2_32:
	li s1, 1
	addi s2, s0, -152
	lw s3, -40(s0)
	lw s4, -80(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -24(s0)
	sub s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	sw s1, 0(s3)
	j .L2_34
.L2_33:
	lw s1, -40(s0)
	lw s2, -80(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -40(s0)
	addi s3, s0, -84
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -84(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L2_34:
.L2_35:
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -80(s0)
	j .L2_29
.L2_31:
	lw s1, -84(s0)
	sw s1, -60(s0)
	li s1, 1
	neg s2, s1
	sw s2, -164(s0)
	li s1, 0
	sw s1, -72(s0)
.L2_36:
	lw s1, -72(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L2_37
	j .L2_38
.L2_37:
	addi s1, s0, -152
	lw s2, -72(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L2_39
	j .L2_40
.L2_39:
	lw s1, -72(s0)
	lw s2, -24(s0)
	add s3, s1, s2
	sw s3, -164(s0)
	li s1, 0
	addi s2, s0, -152
	lw s3, -72(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L2_38
.L2_40:
.L2_41:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -72(s0)
	j .L2_36
.L2_38:
	lw s1, -164(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_42
	j .L2_43
.L2_42:
	lw s1, -164(s0)
	lw s2, -160(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -60(s0)
	sw s1, -168(s0)
	li s1, 0
	sw s1, -80(s0)
.L2_44:
	lw s1, -80(s0)
	lw s2, -60(s0)
	slt s3, s1, s2
	bnez s3, .L2_45
	j .L2_46
.L2_45:
	lw s1, -40(s0)
	lw s2, -80(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -160(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L2_47
	j .L2_48
.L2_47:
	lw s1, -80(s0)
	sw s1, -168(s0)
	j .L2_46
.L2_48:
.L2_49:
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -80(s0)
	j .L2_44
.L2_46:
	lw s1, -60(s0)
	sw s1, -80(s0)
.L2_50:
	lw s1, -80(s0)
	lw s2, -168(s0)
	slt s3, s2, s1
	bnez s3, .L2_51
	j .L2_52
.L2_51:
	lw s1, -40(s0)
	lw s2, -80(s0)
	li s3, 1
	sub s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	lw s2, -40(s0)
	lw s3, -80(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L2_53:
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -80(s0)
	j .L2_50
.L2_52:
	lw s1, -160(s0)
	lw s2, -40(s0)
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L2_54
.L2_43:
	lw s1, -40(s0)
	lw s2, -60(s0)
	li s3, 1
	sub s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	sw s1, -172(s0)
	lw s1, -172(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -160(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L2_55
	j .L2_56
.L2_55:
	lw s1, -172(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -160(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -172(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -64(s0)
	lw s1, -28(s0)
	mul s3, s2, s1
	lw s1, -172(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -60(s0)
	lw s1, -60(s0)
	sw s1, -168(s0)
	li s1, 0
	sw s1, -80(s0)
.L2_57:
	lw s1, -80(s0)
	lw s2, -60(s0)
	slt s3, s1, s2
	bnez s3, .L2_58
	j .L2_59
.L2_58:
	lw s1, -40(s0)
	lw s2, -80(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -160(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L2_60
	j .L2_61
.L2_60:
	lw s1, -80(s0)
	sw s1, -168(s0)
	j .L2_59
.L2_61:
.L2_62:
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -80(s0)
	j .L2_57
.L2_59:
	lw s1, -60(s0)
	sw s1, -80(s0)
.L2_63:
	lw s1, -80(s0)
	lw s2, -168(s0)
	slt s3, s2, s1
	bnez s3, .L2_64
	j .L2_65
.L2_64:
	lw s1, -40(s0)
	lw s2, -80(s0)
	li s3, 1
	sub s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	lw s2, -40(s0)
	lw s3, -80(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L2_66:
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -80(s0)
	j .L2_63
.L2_65:
	lw s1, -160(s0)
	lw s2, -40(s0)
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L2_67
.L2_56:
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -64(s0)
	lw s1, -28(s0)
	mul s3, s2, s1
	lw s1, -160(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
.L2_67:
.L2_54:
.L2_68:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
	j .L2_26
.L2_28:
	li s1, 0
	sw s1, -76(s0)
.L2_69:
	lw s1, -76(s0)
	lw s2, -56(s0)
	slt s3, s1, s2
	bnez s3, .L2_70
	j .L2_71
.L2_70:
	lw s1, -36(s0)
	lw s2, -76(s0)
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 84
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -36(s0)
	lw s4, -76(s0)
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -36(s0)
	lw s2, -76(s0)
	li s3, 20
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 88
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -36(s0)
	lw s4, -76(s0)
	li s5, 20
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L2_72:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
	j .L2_69
.L2_71:
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -48
	lw s3, 0(s1)
	li s4, 4
	add s5, s1, s4
	lw s1, 0(s5)
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, arena_release
	mv s4, a0
	lw s1, -64(s0)
	mv a0, s1
	lw s1, -220(s0)
	lw s2, -216(s0)
	lw s3, -212(s0)
	lw s4, -208(s0)
	lw s5, -204(s0)
	lw s6, -200(s0)
	lw s7, -196(s0)
	lw s8, -192(s0)
	lw s9, -188(s0)
	lw s10, -184(s0)
	lw s11, -180(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end2:
	.size linscan, .Lfunc_end2-linscan

	.text
	.align 2
	.globl regalloc
	.type regalloc, @function
regalloc:
	addi sp, sp, -336
	sw ra, 332(sp)
	sw s0, 328(sp)
	addi s0, sp, 328
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
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -48(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -48(s0)
	li s3, 0
	slt s4, s3, s1
	bnez s4, .L3_0
	j .L3_1
.L3_0:
	lw s1, -48(s0)
	li s3, 4
	mul s4, s1, s3
	sw s4, -68(s0)
	j .L3_2
.L3_1:
	li s1, 1
	sw s1, -68(s0)
.L3_2:
	lw s1, -68(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -4(s0)
	li s2, 84
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -48(s0)
	li s3, 0
	slt s4, s3, s1
	bnez s4, .L3_3
	j .L3_4
.L3_3:
	lw s1, -48(s0)
	li s3, 4
	mul s4, s1, s3
	sw s4, -72(s0)
	j .L3_5
.L3_4:
	li s1, 1
	sw s1, -72(s0)
.L3_5:
	lw s1, -72(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -4(s0)
	li s2, 88
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 0
	sw s1, -56(s0)
.L3_6:
	lw s1, -56(s0)
	lw s2, -48(s0)
	slt s3, s1, s2
	bnez s3, .L3_7
	j .L3_8
.L3_7:
	li s1, 1
	neg s2, s1
	lw s1, -4(s0)
	li s3, 84
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	li s1, 1
	neg s2, s1
	lw s1, -4(s0)
	li s3, 88
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L3_9:
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -56(s0)
	j .L3_6
.L3_8:
	lw s1, -48(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_10
	j .L3_11
.L3_10:
	li s1, 0
	lw s2, -4(s0)
	li s3, 72
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 76
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -316(s0)
	lw s2, -312(s0)
	lw s3, -308(s0)
	lw s4, -304(s0)
	lw s5, -300(s0)
	lw s6, -296(s0)
	lw s7, -292(s0)
	lw s8, -288(s0)
	lw s9, -284(s0)
	lw s10, -280(s0)
	lw s11, -276(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_11:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, arena_save
	sw a0, -80(s0)
	sw a1, -76(s0)
	addi s1, s0, -80
	addi s3, s0, -24
	lw s4, 0(s1)
	sw s4, 0(s3)
	li s4, 4
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 4
	add s5, s3, s4
	sw s1, 0(s5)
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -48(s0)
	li s4, 4
	mul s5, s1, s4
	mv a0, s3
	mv a1, s5
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -28(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -48(s0)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -32(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -48(s0)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_zalloc
	mv s1, a0
	sw s1, -36(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -48(s0)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_zalloc
	mv s1, a0
	sw s1, -40(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -48(s0)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -44(s0)
	li s1, 0
	sw s1, -56(s0)
.L3_12:
	lw s1, -56(s0)
	lw s2, -48(s0)
	slt s3, s1, s2
	bnez s3, .L3_13
	j .L3_14
.L3_13:
	li s1, 1
	neg s2, s1
	lw s1, -28(s0)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	li s1, 1
	neg s2, s1
	lw s1, -32(s0)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L3_15:
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -56(s0)
	j .L3_12
.L3_14:
	li s1, 0
	sw s1, -148(s0)
	li s1, 0
	sw s1, -52(s0)
	lw s1, -4(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L3_16:
	lw s1, -12(s0)
	bnez s1, .L3_17
	j .L3_18
.L3_17:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_19
	j .L3_20
.L3_19:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -48(s0)
	slt s3, s1, s2
	bnez s3, .L3_21
	j .L3_20
.L3_21:
	lw s1, -28(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_22
	j .L3_23
.L3_22:
	lw s1, -52(s0)
	lw s2, -28(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_23:
	lw s1, -32(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -52(s0)
	slt s3, s1, s2
	bnez s3, .L3_24
	j .L3_25
.L3_24:
	lw s1, -52(s0)
	lw s2, -32(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_25:
	lw s1, -12(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, ir_op_is_float_def
	mv s1, a0
	bnez s1, .L3_26
	j .L3_27
.L3_26:
	li s1, 1
	lw s2, -36(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L3_28
.L3_27:
	lw s1, -12(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, ir_op_is_i64_def
	mv s1, a0
	bnez s1, .L3_29
	j .L3_30
.L3_29:
	li s1, 1
	lw s2, -40(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_30:
.L3_28:
.L3_20:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_31
	j .L3_32
.L3_31:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -48(s0)
	slt s3, s1, s2
	bnez s3, .L3_33
	j .L3_32
.L3_33:
	lw s1, -32(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -52(s0)
	slt s3, s1, s2
	bnez s3, .L3_34
	j .L3_32
.L3_34:
	lw s1, -52(s0)
	lw s2, -32(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_32:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_35
	j .L3_36
.L3_35:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -48(s0)
	slt s3, s1, s2
	bnez s3, .L3_37
	j .L3_36
.L3_37:
	lw s1, -32(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -52(s0)
	slt s3, s1, s2
	bnez s3, .L3_38
	j .L3_36
.L3_38:
	lw s1, -52(s0)
	lw s2, -32(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_36:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 129
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_39
	j .L3_40
.L3_39:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_41
	j .L3_40
.L3_41:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 28
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -156(s0)
	li s1, 0
	sw s1, -152(s0)
.L3_42:
	lw s1, -152(s0)
	lw s2, -156(s0)
	slt s3, s1, s2
	bnez s3, .L3_43
	j .L3_44
.L3_43:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -152(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -160(s0)
	lw s1, -160(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_45
	j .L3_46
.L3_46:
	lw s1, -160(s0)
	lw s2, -48(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_45
	j .L3_47
.L3_45:
	j .L3_48
.L3_47:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -152(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L3_49
	j .L3_50
.L3_50:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -152(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L3_49
	j .L3_51
.L3_49:
	lw s1, -28(s0)
	lw s2, -160(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_52
	j .L3_51
.L3_52:
	lw s1, -52(s0)
	lw s2, -28(s0)
	lw s3, -160(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_51:
	lw s1, -32(s0)
	lw s2, -160(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -52(s0)
	slt s3, s1, s2
	bnez s3, .L3_53
	j .L3_54
.L3_53:
	lw s1, -52(s0)
	lw s2, -32(s0)
	lw s3, -160(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_54:
.L3_48:
	addi s1, s0, -152
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -152(s0)
	j .L3_42
.L3_44:
.L3_40:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_55
	j .L3_56
.L3_56:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 120
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_55
	j .L3_57
.L3_57:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_55
	j .L3_58
.L3_55:
	lw s1, -148(s0)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L3_59
	j .L3_60
.L3_59:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -144
	addi s3, s0, -148
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -148(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L3_60:
	j .L3_61
.L3_58:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_63
.L3_63:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_64
.L3_64:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 135
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_65
.L3_65:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 136
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_66
.L3_66:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 122
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_67
.L3_67:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 123
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_68
.L3_68:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 83
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_69
.L3_69:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 84
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_70
.L3_70:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_71
.L3_71:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 49
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_72
.L3_62:
	li s1, 0
	sw s1, -164(s0)
.L3_73:
	lw s1, -164(s0)
	lw s2, -148(s0)
	slt s3, s1, s2
	bnez s3, .L3_74
	j .L3_75
.L3_74:
	addi s1, s0, -144
	lw s2, -164(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_76
	j .L3_77
.L3_76:
	addi s1, s0, -144
	lw s2, -164(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -48(s0)
	slt s3, s1, s2
	bnez s3, .L3_78
	j .L3_77
.L3_78:
	lw s1, -32(s0)
	addi s2, s0, -144
	lw s3, -164(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -52(s0)
	slt s3, s1, s2
	bnez s3, .L3_79
	j .L3_77
.L3_79:
	lw s1, -52(s0)
	lw s2, -32(s0)
	addi s3, s0, -144
	lw s4, -164(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_77:
.L3_80:
	addi s1, s0, -164
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -164(s0)
	j .L3_73
.L3_75:
	li s1, 0
	sw s1, -148(s0)
.L3_72:
.L3_61:
.L3_81:
	lw s1, -12(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -52(s0)
	j .L3_16
.L3_18:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -32(s0)
	lw s4, -40(s0)
	li s5, 4
	li s6, 0
	li s7, 8
	li s8, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	mv a7, s8
	jal ra, linscan
	mv s9, a0
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	sw s9, 0(s3)
	li s1, 1
	neg s2, s1
	sw s2, -60(s0)
	li s1, 0
	sw s1, -56(s0)
.L3_82:
	lw s1, -56(s0)
	lw s2, -48(s0)
	slt s3, s1, s2
	bnez s3, .L3_83
	j .L3_84
.L3_83:
	lw s1, -40(s0)
	lw s2, -56(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L3_85
	j .L3_86
.L3_85:
	lw s1, -4(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -56(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -60(s0)
	slt s3, s2, s1
	bnez s3, .L3_87
	j .L3_86
.L3_87:
	lw s1, -4(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -56(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -60(s0)
.L3_86:
.L3_88:
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -56(s0)
	j .L3_82
.L3_84:
	li s1, 11
	li s2, 2
	lw s3, -60(s0)
	li s4, 1
	add s5, s3, s4
	mul s3, s2, s5
	sub s2, s1, s3
	sw s2, -64(s0)
	lw s1, -64(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_89
	j .L3_90
.L3_89:
	li s1, 0
	sw s1, -64(s0)
.L3_90:
	li s1, 0
	sw s1, -56(s0)
.L3_91:
	lw s1, -56(s0)
	lw s2, -48(s0)
	slt s3, s1, s2
	bnez s3, .L3_92
	j .L3_93
.L3_92:
	lw s1, -36(s0)
	lw s2, -56(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L3_94
	j .L3_95
.L3_95:
	lw s1, -40(s0)
	lw s2, -56(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L3_94
	j .L3_96
.L3_96:
	li s1, 1
	j .L3_97
.L3_94:
	li s1, 0
.L3_97:
	lw s2, -44(s0)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_98:
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -56(s0)
	j .L3_91
.L3_93:
	li s1, 0
	sw s1, -264(s0)
.L3_99:
	lw s1, -264(s0)
	li s2, 11
	slt s3, s1, s2
	bnez s3, .L3_100
	j .L3_101
.L3_100:
	li s1, 0
	addi s2, s0, -208
	lw s3, -264(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_102:
	addi s1, s0, -264
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -264(s0)
	j .L3_99
.L3_101:
	lw s1, -4(s0)
	addi s2, s0, -252
	li s3, 11
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_asm_reserved_regs
	mv s4, a0
	sw s4, -256(s0)
	li s1, 0
	sw s1, -260(s0)
.L3_103:
	lw s1, -260(s0)
	lw s2, -256(s0)
	slt s3, s1, s2
	bnez s3, .L3_104
	j .L3_105
.L3_104:
	addi s1, s0, -252
	lw s2, -260(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 2
	sub s3, s1, s2
	sw s3, -268(s0)
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_106
	j .L3_107
.L3_106:
	la s1, __str_0
	mv a0, s1
	jal ra, die
	mv s2, a0
.L3_107:
	lw s1, -268(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_108
	j .L3_109
.L3_108:
	lw s1, -268(s0)
	lw s2, -64(s0)
	slt s3, s1, s2
	bnez s3, .L3_110
	j .L3_109
.L3_110:
	li s1, 1
	addi s2, s0, -208
	lw s3, -268(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L3_109:
.L3_111:
	addi s1, s0, -260
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -260(s0)
	j .L3_103
.L3_105:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -32(s0)
	lw s4, -44(s0)
	lw s5, -64(s0)
	li s6, 2
	li s7, 4
	addi s8, s0, -208
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	mv a7, s8
	jal ra, linscan
	mv s9, a0
	lw s1, -4(s0)
	li s2, 72
	add s3, s1, s2
	sw s9, 0(s3)
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -32(s0)
	lw s4, -36(s0)
	li s5, 12
	li s6, 2
	li s7, 8
	li s8, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	mv a7, s8
	jal ra, linscan
	mv s9, a0
	lw s1, -4(s0)
	li s2, 76
	add s3, s1, s2
	sw s9, 0(s3)
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -24
	lw s3, 0(s1)
	li s4, 4
	add s5, s1, s4
	lw s1, 0(s5)
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, arena_release
	mv s4, a0
	li s1, 0
	mv a0, s1
	lw s1, -316(s0)
	lw s2, -312(s0)
	lw s3, -308(s0)
	lw s4, -304(s0)
	lw s5, -300(s0)
	lw s6, -296(s0)
	lw s7, -292(s0)
	lw s8, -288(s0)
	lw s9, -284(s0)
	lw s10, -280(s0)
	lw s11, -276(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size regalloc, .Lfunc_end3-regalloc

	.data
	.align 2
__str_0:
	.ascii "rv: asm pin to an allocatable register in a function that uses 64-bit integers is not supported\000"
