# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl ir_new_func
	.type ir_new_func, @function
ir_new_func:
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
	li s2, 104
	mv a0, s1
	mv a1, s2
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
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
	.size ir_new_func, .Lfunc_end1-ir_new_func

	.text
	.align 2
	.globl ir_new_temp
	.type ir_new_temp, @function
ir_new_temp:
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
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end2:
	.size ir_new_temp, .Lfunc_end2-ir_new_temp

	.text
	.align 2
	.globl ir_loc
	.type ir_loc, @function
ir_loc:
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
	li s2, 133
	mv a0, s1
	mv a1, s2
	jal ra, ir_emit
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
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
	.size ir_loc, .Lfunc_end3-ir_loc

	.text
	.align 2
	.globl ir_new_label
	.type ir_new_label, @function
ir_new_label:
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
	li s2, 68
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end4:
	.size ir_new_label, .Lfunc_end4-ir_new_label

	.text
	.align 2
	.globl ir_op_is_float_def
	.type ir_op_is_float_def, @function
ir_op_is_float_def:
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
	li s2, 59
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_0
	li s2, 60
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_1
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_2
	li s2, 62
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_3
	li s2, 63
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_4
	li s2, 64
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_5
	li s2, 65
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_6
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_7
	li s2, 72
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_8
	li s2, 73
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_9
	li s2, 74
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_10
	li s2, 75
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_11
	li s2, 78
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_12
	li s2, 80
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_13
	li s2, 83
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_14
	li s2, 84
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_15
	j .L5_16
.L5_0:
.L5_1:
.L5_2:
.L5_3:
.L5_4:
.L5_5:
.L5_6:
.L5_7:
.L5_8:
.L5_9:
.L5_10:
.L5_11:
.L5_12:
.L5_13:
.L5_14:
.L5_15:
	li s1, 1
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
.L5_16:
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
.L5_17:
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
.Lfunc_end5:
	.size ir_op_is_float_def, .Lfunc_end5-ir_op_is_float_def

	.text
	.align 2
	.globl ir_classify_f32
	.type ir_classify_f32, @function
ir_classify_f32:
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
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L6_0:
	lw s1, -20(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_1
	j .L6_2
.L6_1:
	li s1, 0
	lw s2, -8(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L6_3:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L6_0
.L6_2:
	lw s1, -4(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L6_4:
	lw s1, -12(s0)
	bnez s1, .L6_5
	j .L6_6
.L6_5:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -24(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 59
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_7
	li s1, 60
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_8
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_9
	li s1, 62
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_10
	li s1, 66
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_11
	li s1, 67
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_12
	li s1, 68
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_13
	li s1, 63
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_14
	li s1, 64
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_15
	li s1, 65
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_16
	li s1, 80
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_17
	li s1, 81
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_18
	li s1, 69
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_19
	li s1, 70
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_20
	li s1, 71
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_21
	li s1, 73
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_22
	li s1, 72
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_23
	li s1, 75
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_24
	li s1, 77
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_25
	li s1, 74
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_26
	li s1, 78
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_27
	li s1, 76
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_28
	li s1, 79
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_29
	j .L6_30
.L6_7:
.L6_8:
.L6_9:
.L6_10:
.L6_31:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_32
	j .L6_33
.L6_32:
	lw s1, -28(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_34
	j .L6_33
.L6_34:
	lw s1, -8(s0)
	lw s2, -28(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_35
	j .L6_36
.L6_35:
	li s2, 1
	sw s2, -32(s0)
	j .L6_37
.L6_36:
	li s2, 2
	sw s2, -32(s0)
.L6_37:
	lw s2, -32(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_33:
.L6_38:
	li s1, 0
	bnez s1, .L6_31
	j .L6_39
.L6_39:
.L6_40:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_41
	j .L6_42
.L6_41:
	lw s1, -36(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_43
	j .L6_42
.L6_43:
	lw s1, -8(s0)
	lw s2, -36(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_44
	j .L6_45
.L6_44:
	li s2, 1
	sw s2, -40(s0)
	j .L6_46
.L6_45:
	li s2, 2
	sw s2, -40(s0)
.L6_46:
	lw s2, -40(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_42:
.L6_47:
	li s1, 0
	bnez s1, .L6_40
	j .L6_48
.L6_48:
.L6_49:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_50
	j .L6_51
.L6_50:
	lw s1, -44(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_52
	j .L6_51
.L6_52:
	lw s1, -8(s0)
	lw s2, -44(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_53
	j .L6_54
.L6_53:
	li s2, 1
	sw s2, -48(s0)
	j .L6_55
.L6_54:
	li s2, 2
	sw s2, -48(s0)
.L6_55:
	lw s2, -48(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_51:
.L6_56:
	li s1, 0
	bnez s1, .L6_49
	j .L6_57
.L6_57:
	j .L6_58
.L6_11:
.L6_12:
.L6_13:
.L6_59:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_60
	j .L6_61
.L6_60:
	lw s1, -52(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_62
	j .L6_61
.L6_62:
	lw s1, -8(s0)
	lw s2, -52(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_63
	j .L6_64
.L6_63:
	li s2, 1
	sw s2, -56(s0)
	j .L6_65
.L6_64:
	li s2, 2
	sw s2, -56(s0)
.L6_65:
	lw s2, -56(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_61:
.L6_66:
	li s1, 0
	bnez s1, .L6_59
	j .L6_67
.L6_67:
.L6_68:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -60(s0)
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_69
	j .L6_70
.L6_69:
	lw s1, -60(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_71
	j .L6_70
.L6_71:
	lw s1, -8(s0)
	lw s2, -60(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_72
	j .L6_73
.L6_72:
	li s2, 1
	sw s2, -64(s0)
	j .L6_74
.L6_73:
	li s2, 2
	sw s2, -64(s0)
.L6_74:
	lw s2, -64(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_70:
.L6_75:
	li s1, 0
	bnez s1, .L6_68
	j .L6_76
.L6_76:
	j .L6_58
.L6_14:
.L6_15:
.L6_16:
.L6_77:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -68(s0)
	lw s1, -68(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_78
	j .L6_79
.L6_78:
	lw s1, -68(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_80
	j .L6_79
.L6_80:
	lw s1, -8(s0)
	lw s2, -68(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_81
	j .L6_82
.L6_81:
	li s2, 1
	sw s2, -72(s0)
	j .L6_83
.L6_82:
	li s2, 2
	sw s2, -72(s0)
.L6_83:
	lw s2, -72(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_79:
.L6_84:
	li s1, 0
	bnez s1, .L6_77
	j .L6_85
.L6_85:
.L6_86:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -76(s0)
	lw s1, -76(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_87
	j .L6_88
.L6_87:
	lw s1, -76(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_89
	j .L6_88
.L6_89:
	lw s1, -8(s0)
	lw s2, -76(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_90
	j .L6_91
.L6_90:
	li s2, 1
	sw s2, -80(s0)
	j .L6_92
.L6_91:
	li s2, 2
	sw s2, -80(s0)
.L6_92:
	lw s2, -80(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_88:
.L6_93:
	li s1, 0
	bnez s1, .L6_86
	j .L6_94
.L6_94:
	j .L6_58
.L6_17:
.L6_95:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -84(s0)
	lw s1, -84(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_96
	j .L6_97
.L6_96:
	lw s1, -84(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_98
	j .L6_97
.L6_98:
	lw s1, -8(s0)
	lw s2, -84(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_99
	j .L6_100
.L6_99:
	li s2, 1
	sw s2, -88(s0)
	j .L6_101
.L6_100:
	li s2, 2
	sw s2, -88(s0)
.L6_101:
	lw s2, -88(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_97:
.L6_102:
	li s1, 0
	bnez s1, .L6_95
	j .L6_103
.L6_103:
	j .L6_58
.L6_18:
.L6_104:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -92(s0)
	lw s1, -92(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_105
	j .L6_106
.L6_105:
	lw s1, -92(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_107
	j .L6_106
.L6_107:
	lw s1, -8(s0)
	lw s2, -92(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_108
	j .L6_109
.L6_108:
	li s2, 1
	sw s2, -96(s0)
	j .L6_110
.L6_109:
	li s2, 2
	sw s2, -96(s0)
.L6_110:
	lw s2, -96(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_106:
.L6_111:
	li s1, 0
	bnez s1, .L6_104
	j .L6_112
.L6_112:
	j .L6_58
.L6_19:
.L6_113:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -100(s0)
	lw s1, -100(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_114
	j .L6_115
.L6_114:
	lw s1, -100(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_116
	j .L6_115
.L6_116:
	lw s1, -8(s0)
	lw s2, -100(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_117
	j .L6_118
.L6_117:
	li s2, 1
	sw s2, -104(s0)
	j .L6_119
.L6_118:
	li s2, 2
	sw s2, -104(s0)
.L6_119:
	lw s2, -104(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_115:
.L6_120:
	li s1, 0
	bnez s1, .L6_113
	j .L6_121
.L6_121:
	j .L6_58
.L6_20:
.L6_21:
.L6_122:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -108(s0)
	lw s1, -108(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_123
	j .L6_124
.L6_123:
	lw s1, -108(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_125
	j .L6_124
.L6_125:
	lw s1, -8(s0)
	lw s2, -108(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_126
	j .L6_127
.L6_126:
	li s2, 1
	sw s2, -112(s0)
	j .L6_128
.L6_127:
	li s2, 2
	sw s2, -112(s0)
.L6_128:
	lw s2, -112(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_124:
.L6_129:
	li s1, 0
	bnez s1, .L6_122
	j .L6_130
.L6_130:
	j .L6_58
.L6_22:
.L6_131:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -116(s0)
	lw s1, -116(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_132
	j .L6_133
.L6_132:
	lw s1, -116(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_134
	j .L6_133
.L6_134:
	lw s1, -8(s0)
	lw s2, -116(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 1
	bnez s2, .L6_135
	j .L6_136
.L6_135:
	li s2, 1
	sw s2, -120(s0)
	j .L6_137
.L6_136:
	li s2, 2
	sw s2, -120(s0)
.L6_137:
	lw s2, -120(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_133:
.L6_138:
	li s1, 0
	bnez s1, .L6_131
	j .L6_139
.L6_139:
.L6_140:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -124(s0)
	lw s1, -124(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_141
	j .L6_142
.L6_141:
	lw s1, -124(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_143
	j .L6_142
.L6_143:
	lw s1, -8(s0)
	lw s2, -124(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 0
	bnez s2, .L6_144
	j .L6_145
.L6_144:
	li s2, 1
	sw s2, -128(s0)
	j .L6_146
.L6_145:
	li s2, 2
	sw s2, -128(s0)
.L6_146:
	lw s2, -128(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_142:
.L6_147:
	li s1, 0
	bnez s1, .L6_140
	j .L6_148
.L6_148:
	j .L6_58
.L6_23:
.L6_149:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -132(s0)
	lw s1, -132(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_150
	j .L6_151
.L6_150:
	lw s1, -132(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_152
	j .L6_151
.L6_152:
	lw s1, -8(s0)
	lw s2, -132(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 0
	bnez s2, .L6_153
	j .L6_154
.L6_153:
	li s2, 1
	sw s2, -136(s0)
	j .L6_155
.L6_154:
	li s2, 2
	sw s2, -136(s0)
.L6_155:
	lw s2, -136(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_151:
.L6_156:
	li s1, 0
	bnez s1, .L6_149
	j .L6_157
.L6_157:
.L6_158:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -140(s0)
	lw s1, -140(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_159
	j .L6_160
.L6_159:
	lw s1, -140(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_161
	j .L6_160
.L6_161:
	lw s1, -8(s0)
	lw s2, -140(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 1
	bnez s2, .L6_162
	j .L6_163
.L6_162:
	li s2, 1
	sw s2, -144(s0)
	j .L6_164
.L6_163:
	li s2, 2
	sw s2, -144(s0)
.L6_164:
	lw s2, -144(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_160:
.L6_165:
	li s1, 0
	bnez s1, .L6_158
	j .L6_166
.L6_166:
	j .L6_58
.L6_24:
.L6_167:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -148(s0)
	lw s1, -148(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_168
	j .L6_169
.L6_168:
	lw s1, -148(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_170
	j .L6_169
.L6_170:
	lw s1, -8(s0)
	lw s2, -148(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_171
	j .L6_172
.L6_171:
	li s2, 1
	sw s2, -152(s0)
	j .L6_173
.L6_172:
	li s2, 2
	sw s2, -152(s0)
.L6_173:
	lw s2, -152(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_169:
.L6_174:
	li s1, 0
	bnez s1, .L6_167
	j .L6_175
.L6_175:
	j .L6_58
.L6_25:
.L6_176:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -156(s0)
	lw s1, -156(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_177
	j .L6_178
.L6_177:
	lw s1, -156(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_179
	j .L6_178
.L6_179:
	lw s1, -8(s0)
	lw s2, -156(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -24(s0)
	bnez s2, .L6_180
	j .L6_181
.L6_180:
	li s2, 1
	sw s2, -160(s0)
	j .L6_182
.L6_181:
	li s2, 2
	sw s2, -160(s0)
.L6_182:
	lw s2, -160(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_178:
.L6_183:
	li s1, 0
	bnez s1, .L6_176
	j .L6_184
.L6_184:
	j .L6_58
.L6_26:
.L6_27:
.L6_185:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -164(s0)
	lw s1, -164(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_186
	j .L6_187
.L6_186:
	lw s1, -164(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_188
	j .L6_187
.L6_188:
	lw s1, -8(s0)
	lw s2, -164(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 0
	bnez s2, .L6_189
	j .L6_190
.L6_189:
	li s2, 1
	sw s2, -168(s0)
	j .L6_191
.L6_190:
	li s2, 2
	sw s2, -168(s0)
.L6_191:
	lw s2, -168(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_187:
.L6_192:
	li s1, 0
	bnez s1, .L6_185
	j .L6_193
.L6_193:
	j .L6_58
.L6_28:
.L6_29:
.L6_194:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -172(s0)
	lw s1, -172(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_195
	j .L6_196
.L6_195:
	lw s1, -172(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_197
	j .L6_196
.L6_197:
	lw s1, -8(s0)
	lw s2, -172(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 0
	bnez s2, .L6_198
	j .L6_199
.L6_198:
	li s2, 1
	sw s2, -176(s0)
	j .L6_200
.L6_199:
	li s2, 2
	sw s2, -176(s0)
.L6_200:
	lw s2, -176(s0)
	li s4, 255
	and s5, s2, s4
	or s2, s1, s5
	sb s2, 0(s3)
.L6_196:
.L6_201:
	li s1, 0
	bnez s1, .L6_194
	j .L6_202
.L6_202:
	j .L6_58
.L6_30:
	j .L6_58
.L6_58:
.L6_203:
	lw s1, -12(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L6_4
.L6_6:
	li s1, 0
	sw s1, -20(s0)
.L6_204:
	lw s1, -20(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L6_205
	j .L6_206
.L6_205:
	lw s1, -8(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	li s1, 255
	and s2, s3, s1
	lw s1, -8(s0)
	lw s3, -20(s0)
	add s4, s1, s3
	sb s2, 0(s4)
.L6_207:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L6_204
.L6_206:
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
.Lfunc_end6:
	.size ir_classify_f32, .Lfunc_end6-ir_classify_f32

	.text
	.align 2
	.globl ir_op_is_i64_def
	.type ir_op_is_i64_def, @function
ir_op_is_i64_def:
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
	li s2, 85
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	li s2, 86
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_1
	li s2, 87
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_2
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_3
	li s2, 89
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_4
	li s2, 90
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_5
	li s2, 91
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_6
	li s2, 92
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_7
	li s2, 93
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_8
	li s2, 94
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_9
	li s2, 95
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_10
	li s2, 96
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_11
	li s2, 97
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_12
	li s2, 98
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_13
	li s2, 99
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_14
	li s2, 110
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_15
	li s2, 112
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_16
	li s2, 114
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_17
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_18
	li s2, 117
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_19
	li s2, 118
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_20
	li s2, 122
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_21
	li s2, 123
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_22
	j .L7_23
.L7_0:
.L7_1:
.L7_2:
.L7_3:
.L7_4:
.L7_5:
.L7_6:
.L7_7:
.L7_8:
.L7_9:
.L7_10:
.L7_11:
.L7_12:
.L7_13:
.L7_14:
.L7_15:
.L7_16:
.L7_17:
.L7_18:
.L7_19:
.L7_20:
.L7_21:
.L7_22:
	li s1, 1
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
.L7_23:
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
.L7_24:
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
.Lfunc_end7:
	.size ir_op_is_i64_def, .Lfunc_end7-ir_op_is_i64_def

	.text
	.align 2
	.globl ir_emit
	.type ir_emit, @function
ir_emit:
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
	lw s2, 0(s1)
	li s1, 56
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L8_0
	j .L8_1
.L8_1:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 92
	add s4, s2, s3
	sw s1, 0(s4)
	j .L8_2
.L8_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 96
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
.L8_2:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 96
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
.Lfunc_end8:
	.size ir_emit, .Lfunc_end8-ir_emit

	.data
	.align 2
	.globl target_aot_trap_guarded
target_aot_trap_guarded:
	.word 0
