# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type xn, @function
xn:
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
	la s1, xn.t.0
	lw s2, -4(s0)
	li s3, 31
	and s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
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
	.size xn, .Lfunc_end1-xn

	.text
	.align 2
	.type fnn, @function
fnn:
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
	la s1, fnn.t.1
	lw s2, -4(s0)
	li s3, 31
	and s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
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
	.size fnn, .Lfunc_end2-fnn

	.text
	.align 2
	.globl rvt_new
	.type rvt_new, @function
rvt_new:
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
	li s1, 1
	li s2, 16
	mv a0, s1
	mv a1, s2
	jal ra, calloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
.L3_1:
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
	.size rvt_new, .Lfunc_end3-rvt_new

	.text
	.align 2
	.globl rvt_free
	.type rvt_free, @function
rvt_free:
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
	jal ra, free
	mv s2, a0
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
.Lfunc_end4:
	.size rvt_free, .Lfunc_end4-rvt_free

	.text
	.align 2
	.globl rvt_begin_func
	.type rvt_begin_func, @function
rvt_begin_func:
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
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
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
	.size rvt_begin_func, .Lfunc_end5-rvt_begin_func

	.text
	.align 2
	.globl rvt_errsym
	.type rvt_errsym, @function
rvt_errsym:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
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
	.size rvt_errsym, .Lfunc_end6-rvt_errsym

	.text
	.align 2
	.globl rv_mc_loc
	.type rv_mc_loc, @function
rv_mc_loc:
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
	la s1, __str_64
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
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
	.size rv_mc_loc, .Lfunc_end7-rv_mc_loc

	.text
	.align 2
	.type memop, @function
memop:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -20(s0)
	li s2, 2048
	neg s3, s2
	slt s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L8_0
	j .L8_1
.L8_0:
	lw s1, -20(s0)
	li s2, 2047
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L8_2
	j .L8_1
.L8_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_65
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -20(s0)
	lw s6, -16(s0)
	mv a0, s6
	jal ra, xn
	mv s7, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s5, 8(sp)
	sw s7, 12(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.L8_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_66
	lw s3, -20(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_67
	lw s3, -16(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_68
	lw s3, -8(s0)
	lw s4, -12(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, fprintf
	mv s5, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end8:
	.size memop, .Lfunc_end8-memop

	.text
	.align 2
	.globl rv_mc_new_label
	.type rv_mc_new_label, @function
rv_mc_new_label:
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
	li s2, 8
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
.Lfunc_end9:
	.size rv_mc_new_label, .Lfunc_end9-rv_mc_new_label

	.text
	.align 2
	.globl rv_mc_label
	.type rv_mc_label, @function
rv_mc_label:
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
	la s1, __str_69
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -8(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, fprintf
	mv s5, a0
	addi sp, sp, 16
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
.Lfunc_end10:
	.size rv_mc_label, .Lfunc_end10-rv_mc_label

	.text
	.align 2
	.globl rv_mc_j
	.type rv_mc_j, @function
rv_mc_j:
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
	la s1, __str_70
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -8(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, fprintf
	mv s5, a0
	addi sp, sp, 16
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
.Lfunc_end11:
	.size rv_mc_j, .Lfunc_end11-rv_mc_j

	.text
	.align 2
	.globl rv_mc_beqz
	.type rv_mc_beqz, @function
rv_mc_beqz:
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
	lw s2, 0(s1)
	la s1, __str_71
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -4(s0)
	li s5, 4
	add s6, s3, s5
	lw s3, 0(s6)
	lw s5, -12(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s3, 4(sp)
	sw s5, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.Lfunc_end12:
	.size rv_mc_beqz, .Lfunc_end12-rv_mc_beqz

	.text
	.align 2
	.globl rv_mc_bnez
	.type rv_mc_bnez, @function
rv_mc_bnez:
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
	lw s2, 0(s1)
	la s1, __str_72
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -4(s0)
	li s5, 4
	add s6, s3, s5
	lw s3, 0(s6)
	lw s5, -12(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s3, 4(sp)
	sw s5, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.Lfunc_end13:
	.size rv_mc_bnez, .Lfunc_end13-rv_mc_bnez

	.text
	.align 2
	.globl rv_mc_bne
	.type rv_mc_bne, @function
rv_mc_bne:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_73
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	lw s3, -4(s0)
	li s6, 4
	add s7, s3, s6
	lw s3, 0(s7)
	lw s6, -16(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	sw s3, 8(sp)
	sw s6, 12(sp)
	jal ra, fprintf
	mv s7, a0
	addi sp, sp, 16
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
.Lfunc_end14:
	.size rv_mc_bne, .Lfunc_end14-rv_mc_bne

	.text
	.align 2
	.globl rv_mc_ret
	.type rv_mc_ret, @function
rv_mc_ret:
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
	lw s2, 0(s1)
	la s1, __str_74
	mv a0, s2
	mv a1, s1
	jal ra, fprintf
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
.Lfunc_end15:
	.size rv_mc_ret, .Lfunc_end15-rv_mc_ret

	.text
	.align 2
	.globl rv_mc_jr
	.type rv_mc_jr, @function
rv_mc_jr:
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
	la s1, __str_75
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
	.size rv_mc_jr, .Lfunc_end16-rv_mc_jr

	.text
	.align 2
	.globl rv_mc_j_sym
	.type rv_mc_j_sym, @function
rv_mc_j_sym:
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
	la s1, __str_76
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
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
.Lfunc_end17:
	.size rv_mc_j_sym, .Lfunc_end17-rv_mc_j_sym

	.text
	.align 2
	.globl rv_mc_call
	.type rv_mc_call, @function
rv_mc_call:
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
	la s1, __str_77
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
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
.Lfunc_end18:
	.size rv_mc_call, .Lfunc_end18-rv_mc_call

	.text
	.align 2
	.globl rv_mc_jalr
	.type rv_mc_jalr, @function
rv_mc_jalr:
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
	la s1, __str_78
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
	.size rv_mc_jalr, .Lfunc_end19-rv_mc_jalr

	.text
	.align 2
	.globl rv_mc_lea_label
	.type rv_mc_lea_label, @function
rv_mc_lea_label:
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
	lw s2, 0(s1)
	la s1, __str_79
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -4(s0)
	li s5, 4
	add s6, s3, s5
	lw s3, 0(s6)
	lw s5, -12(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s3, 4(sp)
	sw s5, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.Lfunc_end20:
	.size rv_mc_lea_label, .Lfunc_end20-rv_mc_lea_label

	.text
	.align 2
	.globl rv_mc_li
	.type rv_mc_li, @function
rv_mc_li:
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
	lw s2, 0(s1)
	la s1, __str_80
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s3, 4(sp)
	jal ra, fprintf
	mv s5, a0
	addi sp, sp, 16
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
.Lfunc_end21:
	.size rv_mc_li, .Lfunc_end21-rv_mc_li

	.text
	.align 2
	.globl rv_mc_la
	.type rv_mc_la, @function
rv_mc_la:
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
	lw s2, 0(s1)
	la s1, __str_81
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s3, 4(sp)
	jal ra, fprintf
	mv s5, a0
	addi sp, sp, 16
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
.Lfunc_end22:
	.size rv_mc_la, .Lfunc_end22-rv_mc_la

	.text
	.align 2
	.globl rv_mc_mv
	.type rv_mc_mv, @function
rv_mc_mv:
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
	lw s2, 0(s1)
	la s1, __str_82
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end23:
	.size rv_mc_mv, .Lfunc_end23-rv_mc_mv

	.text
	.align 2
	.globl rv_mc_addbig
	.type rv_mc_addbig, @function
rv_mc_addbig:
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
	sw a3, -16(s0)
	lw s1, -16(s0)
	li s2, 2048
	neg s3, s2
	slt s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L24_0
	j .L24_1
.L24_0:
	lw s1, -16(s0)
	li s2, 2047
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L24_2
	j .L24_1
.L24_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_83
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	lw s3, -16(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	sw s3, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.L24_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_84
	lw s3, -16(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_85
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end24:
	.size rv_mc_addbig, .Lfunc_end24-rv_mc_addbig

	.text
	.align 2
	.globl rv_mc_addi
	.type rv_mc_addi, @function
rv_mc_addi:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_86
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	lw s3, -16(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	sw s3, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.Lfunc_end25:
	.size rv_mc_addi, .Lfunc_end25-rv_mc_addi

	.text
	.align 2
	.globl rv_mc_andi
	.type rv_mc_andi, @function
rv_mc_andi:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_87
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	lw s3, -16(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	sw s3, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.Lfunc_end26:
	.size rv_mc_andi, .Lfunc_end26-rv_mc_andi

	.text
	.align 2
	.globl rv_mc_xori
	.type rv_mc_xori, @function
rv_mc_xori:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_88
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	lw s3, -16(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	sw s3, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.Lfunc_end27:
	.size rv_mc_xori, .Lfunc_end27-rv_mc_xori

	.text
	.align 2
	.globl rv_mc_srai
	.type rv_mc_srai, @function
rv_mc_srai:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_89
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	lw s3, -16(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	sw s3, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
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
.Lfunc_end28:
	.size rv_mc_srai, .Lfunc_end28-rv_mc_srai

	.text
	.align 2
	.type r3, @function
r3:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_90
	lw s3, -8(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, xn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, xn
	mv s6, a0
	lw s4, -20(s0)
	mv a0, s4
	jal ra, xn
	mv s7, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	sw s7, 12(sp)
	jal ra, fprintf
	mv s4, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end29:
	.size r3, .Lfunc_end29-r3

	.text
	.align 2
	.globl rv_mc_add
	.type rv_mc_add, @function
rv_mc_add:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_91
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end30:
	.size rv_mc_add, .Lfunc_end30-rv_mc_add

	.text
	.align 2
	.globl rv_mc_sub
	.type rv_mc_sub, @function
rv_mc_sub:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_92
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end31:
	.size rv_mc_sub, .Lfunc_end31-rv_mc_sub

	.text
	.align 2
	.globl rv_mc_mul
	.type rv_mc_mul, @function
rv_mc_mul:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_93
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end32:
	.size rv_mc_mul, .Lfunc_end32-rv_mc_mul

	.text
	.align 2
	.globl rv_mc_mulh
	.type rv_mc_mulh, @function
rv_mc_mulh:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_94
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end33:
	.size rv_mc_mulh, .Lfunc_end33-rv_mc_mulh

	.text
	.align 2
	.globl rv_mc_and
	.type rv_mc_and, @function
rv_mc_and:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_95
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end34:
	.size rv_mc_and, .Lfunc_end34-rv_mc_and

	.text
	.align 2
	.globl rv_mc_or
	.type rv_mc_or, @function
rv_mc_or:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_96
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end35:
	.size rv_mc_or, .Lfunc_end35-rv_mc_or

	.text
	.align 2
	.globl rv_mc_xor
	.type rv_mc_xor, @function
rv_mc_xor:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_97
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end36:
	.size rv_mc_xor, .Lfunc_end36-rv_mc_xor

	.text
	.align 2
	.globl rv_mc_sll
	.type rv_mc_sll, @function
rv_mc_sll:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_98
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end37:
	.size rv_mc_sll, .Lfunc_end37-rv_mc_sll

	.text
	.align 2
	.globl rv_mc_sra
	.type rv_mc_sra, @function
rv_mc_sra:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_99
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end38:
	.size rv_mc_sra, .Lfunc_end38-rv_mc_sra

	.text
	.align 2
	.globl rv_mc_srl
	.type rv_mc_srl, @function
rv_mc_srl:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_100
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end39:
	.size rv_mc_srl, .Lfunc_end39-rv_mc_srl

	.text
	.align 2
	.globl rv_mc_div
	.type rv_mc_div, @function
rv_mc_div:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_101
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end40:
	.size rv_mc_div, .Lfunc_end40-rv_mc_div

	.text
	.align 2
	.globl rv_mc_divu
	.type rv_mc_divu, @function
rv_mc_divu:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_102
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end41:
	.size rv_mc_divu, .Lfunc_end41-rv_mc_divu

	.text
	.align 2
	.globl rv_mc_rem
	.type rv_mc_rem, @function
rv_mc_rem:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_103
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end42:
	.size rv_mc_rem, .Lfunc_end42-rv_mc_rem

	.text
	.align 2
	.globl rv_mc_remu
	.type rv_mc_remu, @function
rv_mc_remu:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_104
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end43:
	.size rv_mc_remu, .Lfunc_end43-rv_mc_remu

	.text
	.align 2
	.globl rv_mc_slt
	.type rv_mc_slt, @function
rv_mc_slt:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_105
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end44:
	.size rv_mc_slt, .Lfunc_end44-rv_mc_slt

	.text
	.align 2
	.globl rv_mc_sltu
	.type rv_mc_sltu, @function
rv_mc_sltu:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_106
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, r3
	mv s6, a0
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
.Lfunc_end45:
	.size rv_mc_sltu, .Lfunc_end45-rv_mc_sltu

	.text
	.align 2
	.globl rv_mc_neg
	.type rv_mc_neg, @function
rv_mc_neg:
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
	lw s2, 0(s1)
	la s1, __str_107
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end46:
	.size rv_mc_neg, .Lfunc_end46-rv_mc_neg

	.text
	.align 2
	.globl rv_mc_not
	.type rv_mc_not, @function
rv_mc_not:
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
	lw s2, 0(s1)
	la s1, __str_108
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end47:
	.size rv_mc_not, .Lfunc_end47-rv_mc_not

	.text
	.align 2
	.globl rv_mc_seqz
	.type rv_mc_seqz, @function
rv_mc_seqz:
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
	lw s2, 0(s1)
	la s1, __str_109
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end48:
	.size rv_mc_seqz, .Lfunc_end48-rv_mc_seqz

	.text
	.align 2
	.globl rv_mc_snez
	.type rv_mc_snez, @function
rv_mc_snez:
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
	lw s2, 0(s1)
	la s1, __str_110
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end49:
	.size rv_mc_snez, .Lfunc_end49-rv_mc_snez

	.text
	.align 2
	.globl rv_mc_lb
	.type rv_mc_lb, @function
rv_mc_lb:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_111
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end50:
	.size rv_mc_lb, .Lfunc_end50-rv_mc_lb

	.text
	.align 2
	.globl rv_mc_lh
	.type rv_mc_lh, @function
rv_mc_lh:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_112
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end51:
	.size rv_mc_lh, .Lfunc_end51-rv_mc_lh

	.text
	.align 2
	.globl rv_mc_lw
	.type rv_mc_lw, @function
rv_mc_lw:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_113
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end52:
	.size rv_mc_lw, .Lfunc_end52-rv_mc_lw

	.text
	.align 2
	.globl rv_mc_lbu
	.type rv_mc_lbu, @function
rv_mc_lbu:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_114
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end53:
	.size rv_mc_lbu, .Lfunc_end53-rv_mc_lbu

	.text
	.align 2
	.globl rv_mc_lhu
	.type rv_mc_lhu, @function
rv_mc_lhu:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_115
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end54:
	.size rv_mc_lhu, .Lfunc_end54-rv_mc_lhu

	.text
	.align 2
	.globl rv_mc_sb
	.type rv_mc_sb, @function
rv_mc_sb:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_116
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end55:
	.size rv_mc_sb, .Lfunc_end55-rv_mc_sb

	.text
	.align 2
	.globl rv_mc_sh
	.type rv_mc_sh, @function
rv_mc_sh:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_117
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end56:
	.size rv_mc_sh, .Lfunc_end56-rv_mc_sh

	.text
	.align 2
	.globl rv_mc_sw
	.type rv_mc_sw, @function
rv_mc_sw:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_118
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end57:
	.size rv_mc_sw, .Lfunc_end57-rv_mc_sw

	.text
	.align 2
	.globl rv_mc_flw
	.type rv_mc_flw, @function
rv_mc_flw:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_119
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end58:
	.size rv_mc_flw, .Lfunc_end58-rv_mc_flw

	.text
	.align 2
	.globl rv_mc_fld
	.type rv_mc_fld, @function
rv_mc_fld:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_120
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end59:
	.size rv_mc_fld, .Lfunc_end59-rv_mc_fld

	.text
	.align 2
	.globl rv_mc_flh
	.type rv_mc_flh, @function
rv_mc_flh:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_121
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end60:
	.size rv_mc_flh, .Lfunc_end60-rv_mc_flh

	.text
	.align 2
	.globl rv_mc_fsw
	.type rv_mc_fsw, @function
rv_mc_fsw:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_122
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end61:
	.size rv_mc_fsw, .Lfunc_end61-rv_mc_fsw

	.text
	.align 2
	.globl rv_mc_fsd
	.type rv_mc_fsd, @function
rv_mc_fsd:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_123
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end62:
	.size rv_mc_fsd, .Lfunc_end62-rv_mc_fsd

	.text
	.align 2
	.globl rv_mc_fsh
	.type rv_mc_fsh, @function
rv_mc_fsh:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	la s2, __str_124
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s3
	mv a4, s5
	jal ra, memop
	mv s6, a0
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
.Lfunc_end63:
	.size rv_mc_fsh, .Lfunc_end63-rv_mc_fsh

	.text
	.align 2
	.type f3, @function
f3:
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
	sw a4, -20(s0)
	sw a5, -24(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_125
	lw s3, -8(s0)
	lw s4, -12(s0)
	bnez s4, .L64_0
	j .L64_1
.L64_0:
	la s4, __str_126
	sw s4, -28(s0)
	j .L64_2
.L64_1:
	la s4, __str_127
	sw s4, -28(s0)
.L64_2:
	lw s4, -28(s0)
	lw s5, -16(s0)
	mv a0, s5
	jal ra, fnn
	mv s6, a0
	lw s5, -20(s0)
	mv a0, s5
	jal ra, fnn
	mv s7, a0
	lw s5, -24(s0)
	mv a0, s5
	jal ra, fnn
	mv s8, a0
	addi sp, sp, -32
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s6, 8(sp)
	sw s7, 12(sp)
	sw s8, 16(sp)
	jal ra, fprintf
	mv s5, a0
	addi sp, sp, 32
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
.Lfunc_end64:
	.size f3, .Lfunc_end64-f3

	.text
	.align 2
	.globl rv_mc_fadd
	.type rv_mc_fadd, @function
rv_mc_fadd:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	la s2, __str_128
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	lw s6, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, f3
	mv s7, a0
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
.Lfunc_end65:
	.size rv_mc_fadd, .Lfunc_end65-rv_mc_fadd

	.text
	.align 2
	.globl rv_mc_fsub
	.type rv_mc_fsub, @function
rv_mc_fsub:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	la s2, __str_129
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	lw s6, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, f3
	mv s7, a0
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
.Lfunc_end66:
	.size rv_mc_fsub, .Lfunc_end66-rv_mc_fsub

	.text
	.align 2
	.globl rv_mc_fmul
	.type rv_mc_fmul, @function
rv_mc_fmul:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	la s2, __str_130
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	lw s6, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, f3
	mv s7, a0
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
.Lfunc_end67:
	.size rv_mc_fmul, .Lfunc_end67-rv_mc_fmul

	.text
	.align 2
	.globl rv_mc_fdiv
	.type rv_mc_fdiv, @function
rv_mc_fdiv:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	la s2, __str_131
	lw s3, -8(s0)
	lw s4, -12(s0)
	lw s5, -16(s0)
	lw s6, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, f3
	mv s7, a0
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
.Lfunc_end68:
	.size rv_mc_fdiv, .Lfunc_end68-rv_mc_fdiv

	.text
	.align 2
	.globl rv_mc_fneg
	.type rv_mc_fneg, @function
rv_mc_fneg:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_132
	lw s3, -8(s0)
	bnez s3, .L69_0
	j .L69_1
.L69_0:
	la s3, __str_133
	sw s3, -20(s0)
	j .L69_2
.L69_1:
	la s3, __str_134
	sw s3, -20(s0)
.L69_2:
	lw s3, -20(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, fnn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, fnn
	mv s6, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	jal ra, fprintf
	mv s4, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end69:
	.size rv_mc_fneg, .Lfunc_end69-rv_mc_fneg

	.text
	.align 2
	.globl rv_mc_fabs
	.type rv_mc_fabs, @function
rv_mc_fabs:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_135
	lw s3, -8(s0)
	bnez s3, .L70_0
	j .L70_1
.L70_0:
	la s3, __str_136
	sw s3, -20(s0)
	j .L70_2
.L70_1:
	la s3, __str_137
	sw s3, -20(s0)
.L70_2:
	lw s3, -20(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, fnn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, fnn
	mv s6, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	jal ra, fprintf
	mv s4, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end70:
	.size rv_mc_fabs, .Lfunc_end70-rv_mc_fabs

	.text
	.align 2
	.globl rv_mc_fsqrt
	.type rv_mc_fsqrt, @function
rv_mc_fsqrt:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_138
	lw s3, -8(s0)
	bnez s3, .L71_0
	j .L71_1
.L71_0:
	la s3, __str_139
	sw s3, -20(s0)
	j .L71_2
.L71_1:
	la s3, __str_140
	sw s3, -20(s0)
.L71_2:
	lw s3, -20(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, fnn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, fnn
	mv s6, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	jal ra, fprintf
	mv s4, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end71:
	.size rv_mc_fsqrt, .Lfunc_end71-rv_mc_fsqrt

	.text
	.align 2
	.globl rv_mc_feq
	.type rv_mc_feq, @function
rv_mc_feq:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_141
	lw s3, -8(s0)
	bnez s3, .L72_0
	j .L72_1
.L72_0:
	la s3, __str_142
	sw s3, -28(s0)
	j .L72_2
.L72_1:
	la s3, __str_143
	sw s3, -28(s0)
.L72_2:
	lw s3, -28(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, xn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, fnn
	mv s6, a0
	lw s4, -20(s0)
	mv a0, s4
	jal ra, fnn
	mv s7, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	sw s7, 12(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
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
.Lfunc_end72:
	.size rv_mc_feq, .Lfunc_end72-rv_mc_feq

	.text
	.align 2
	.globl rv_mc_flt
	.type rv_mc_flt, @function
rv_mc_flt:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_144
	lw s3, -8(s0)
	bnez s3, .L73_0
	j .L73_1
.L73_0:
	la s3, __str_145
	sw s3, -28(s0)
	j .L73_2
.L73_1:
	la s3, __str_146
	sw s3, -28(s0)
.L73_2:
	lw s3, -28(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, xn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, fnn
	mv s6, a0
	lw s4, -20(s0)
	mv a0, s4
	jal ra, fnn
	mv s7, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	sw s7, 12(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
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
.Lfunc_end73:
	.size rv_mc_flt, .Lfunc_end73-rv_mc_flt

	.text
	.align 2
	.globl rv_mc_fle
	.type rv_mc_fle, @function
rv_mc_fle:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_147
	lw s3, -8(s0)
	bnez s3, .L74_0
	j .L74_1
.L74_0:
	la s3, __str_148
	sw s3, -28(s0)
	j .L74_2
.L74_1:
	la s3, __str_149
	sw s3, -28(s0)
.L74_2:
	lw s3, -28(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, xn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, fnn
	mv s6, a0
	lw s4, -20(s0)
	mv a0, s4
	jal ra, fnn
	mv s7, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	sw s7, 12(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
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
.Lfunc_end74:
	.size rv_mc_fle, .Lfunc_end74-rv_mc_fle

	.text
	.align 2
	.globl rv_mc_fcvt_f_w
	.type rv_mc_fcvt_f_w, @function
rv_mc_fcvt_f_w:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_150
	lw s3, -8(s0)
	bnez s3, .L75_0
	j .L75_1
.L75_0:
	la s3, __str_151
	sw s3, -20(s0)
	j .L75_2
.L75_1:
	la s3, __str_152
	sw s3, -20(s0)
.L75_2:
	lw s3, -20(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, fnn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, xn
	mv s6, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	jal ra, fprintf
	mv s4, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end75:
	.size rv_mc_fcvt_f_w, .Lfunc_end75-rv_mc_fcvt_f_w

	.text
	.align 2
	.globl rv_mc_fcvt_w_f
	.type rv_mc_fcvt_w_f, @function
rv_mc_fcvt_w_f:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_153
	lw s3, -8(s0)
	bnez s3, .L76_0
	j .L76_1
.L76_0:
	la s3, __str_154
	sw s3, -20(s0)
	j .L76_2
.L76_1:
	la s3, __str_155
	sw s3, -20(s0)
.L76_2:
	lw s3, -20(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, xn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, fnn
	mv s6, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	jal ra, fprintf
	mv s4, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end76:
	.size rv_mc_fcvt_w_f, .Lfunc_end76-rv_mc_fcvt_w_f

	.text
	.align 2
	.globl rv_mc_fround
	.type rv_mc_fround, @function
rv_mc_fround:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	la s1, __str_156
	lw s3, -8(s0)
	bnez s3, .L77_0
	j .L77_1
.L77_0:
	la s3, __str_157
	sw s3, -20(s0)
	j .L77_2
.L77_1:
	la s3, __str_158
	sw s3, -20(s0)
.L77_2:
	lw s3, -20(s0)
	lw s4, -12(s0)
	mv a0, s4
	jal ra, xn
	mv s5, a0
	lw s4, -16(s0)
	mv a0, s4
	jal ra, fnn
	mv s6, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	sw s6, 8(sp)
	jal ra, fprintf
	mv s4, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end77:
	.size rv_mc_fround, .Lfunc_end77-rv_mc_fround

	.text
	.align 2
	.globl rv_mc_fcvt_d_s
	.type rv_mc_fcvt_d_s, @function
rv_mc_fcvt_d_s:
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
	lw s2, 0(s1)
	la s1, __str_159
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, fnn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end78:
	.size rv_mc_fcvt_d_s, .Lfunc_end78-rv_mc_fcvt_d_s

	.text
	.align 2
	.globl rv_mc_fcvt_s_d
	.type rv_mc_fcvt_s_d, @function
rv_mc_fcvt_s_d:
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
	lw s2, 0(s1)
	la s1, __str_160
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, fnn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end79:
	.size rv_mc_fcvt_s_d, .Lfunc_end79-rv_mc_fcvt_s_d

	.text
	.align 2
	.globl rv_mc_fcvt_d_h
	.type rv_mc_fcvt_d_h, @function
rv_mc_fcvt_d_h:
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
	lw s2, 0(s1)
	la s1, __str_161
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, fnn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end80:
	.size rv_mc_fcvt_d_h, .Lfunc_end80-rv_mc_fcvt_d_h

	.text
	.align 2
	.globl rv_mc_fcvt_h_d
	.type rv_mc_fcvt_h_d, @function
rv_mc_fcvt_h_d:
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
	lw s2, 0(s1)
	la s1, __str_162
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, fnn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end81:
	.size rv_mc_fcvt_h_d, .Lfunc_end81-rv_mc_fcvt_h_d

	.text
	.align 2
	.globl rv_mc_fmv_x_w
	.type rv_mc_fmv_x_w, @function
rv_mc_fmv_x_w:
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
	lw s2, 0(s1)
	la s1, __str_163
	lw s3, -8(s0)
	mv a0, s3
	jal ra, xn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, fnn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end82:
	.size rv_mc_fmv_x_w, .Lfunc_end82-rv_mc_fmv_x_w

	.text
	.align 2
	.globl rv_mc_fmv_w_x
	.type rv_mc_fmv_w_x, @function
rv_mc_fmv_w_x:
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
	lw s2, 0(s1)
	la s1, __str_164
	lw s3, -8(s0)
	mv a0, s3
	jal ra, fnn
	mv s4, a0
	lw s3, -12(s0)
	mv a0, s3
	jal ra, xn
	mv s5, a0
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end83:
	.size rv_mc_fmv_w_x, .Lfunc_end83-rv_mc_fmv_w_x

	.text
	.align 2
	.globl rv_mc_asm
	.type rv_mc_asm, @function
rv_mc_asm:
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
	la s1, __str_165
	lw s3, -8(s0)
	addi sp, sp, -16
	mv a0, s2
	mv a1, s1
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
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
.Lfunc_end84:
	.size rv_mc_asm, .Lfunc_end84-rv_mc_asm

	.text
	.align 2
	.type emit_string_bytes, @function
emit_string_bytes:
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
	la s1, __str_166
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	li s1, 0
	sw s1, -20(s0)
.L85_0:
	lw s1, -20(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L85_1
	j .L85_2
.L85_1:
	lw s1, -8(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	sw s3, -24(s0)
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L85_3
	j .L85_4
.L85_3:
	la s1, __str_167
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	j .L85_5
.L85_4:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L85_6
	j .L85_7
.L85_6:
	la s1, __str_168
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	j .L85_8
.L85_7:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L85_9
	j .L85_10
.L85_9:
	la s1, __str_169
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	j .L85_11
.L85_10:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L85_12
	j .L85_13
.L85_12:
	la s1, __str_170
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	j .L85_14
.L85_13:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L85_15
	j .L85_16
.L85_15:
	la s1, __str_171
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	j .L85_17
.L85_16:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 32
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L85_18
	j .L85_19
.L85_18:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 127
	slt s3, s2, s1
	bnez s3, .L85_20
	j .L85_19
.L85_20:
	addi s1, s0, -24
	lbu s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, fputc
	mv s3, a0
	j .L85_21
.L85_19:
	lw s1, -4(s0)
	la s2, __str_172
	addi s3, s0, -24
	lbu s4, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s4, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
.L85_21:
.L85_17:
.L85_14:
.L85_11:
.L85_8:
.L85_5:
.L85_22:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L85_0
.L85_2:
	la s1, __str_173
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
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
.Lfunc_end85:
	.size emit_string_bytes, .Lfunc_end85-emit_string_bytes

	.text
	.align 2
	.type sym_ref, @function
sym_ref:
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
	sw a3, -24(s0)
	sw a4, -20(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s9, s11
	bne s9, s11, .L86_0
	sltu s1, s8, s10
.L86_0:
	bnez s1, .L86_1
	j .L86_2
.L86_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, __str_174
	lw s4, -12(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s10, 8(sp)
	sw s11, 12(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	j .L86_3
.L86_2:
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L86_4
	sltu s1, s10, s8
.L86_4:
	bnez s1, .L86_5
	j .L86_6
.L86_5:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, __str_175
	lw s4, -12(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s8, 8(sp)
	sw s9, 12(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	j .L86_7
.L86_6:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, __str_176
	lw s4, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
.L86_7:
.L86_3:
	lw s1, -4(s0)
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
.Lfunc_end86:
	.size sym_ref, .Lfunc_end86-sym_ref

	.text
	.align 2
	.type emit_init_image, @function
emit_init_image:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	li s1, 0
	sw s1, -16(s0)
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L87_0:
	lw s1, -12(s0)
	bnez s1, .L87_1
	j .L87_2
.L87_1:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	slt s3, s1, s2
	bnez s3, .L87_3
	j .L87_4
.L87_3:
	lw s1, -4(s0)
	la s2, __str_177
	lw s3, -12(s0)
	lw s4, 0(s3)
	lw s3, -16(s0)
	sub s5, s4, s3
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s5, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
	lw s1, -12(s0)
	lw s2, 0(s1)
	sw s2, -16(s0)
.L87_4:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L87_5
	j .L87_6
.L87_5:
	lw t0, -4(s0)
	sw t0, -192(s0)
	la t0, __str_178
	sw t0, -188(s0)
	addi s3, s0, -176
	li s4, 160
	lw s5, -12(s0)
	li s2, 16
	add s1, s5, s2
	lw t0, 0(s1)
	sw t0, -196(s0)
	lw s1, -12(s0)
	li s5, 8
	add s2, s1, s5
	lw s10, 0(s2)
	lw s11, 4(s2)
	mv a0, s3
	mv a1, s4
	lw t0, -196(s0)
	mv a2, t0
	mv a3, s10
	mv a4, s11
	jal ra, sym_ref
	mv s1, a0
	addi sp, sp, -16
	lw t0, -192(s0)
	mv a0, t0
	lw t0, -188(s0)
	mv a1, t0
	sw s1, 0(sp)
	jal ra, fprintf
	mv s2, a0
	addi sp, sp, 16
	j .L87_7
.L87_6:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L87_8
	j .L87_9
.L87_8:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	sw s10, -184(s0)
	sw s11, -180(s0)
	lw s1, -4(s0)
	la s2, __str_179
	lw s10, -184(s0)
	lw s11, -180(s0)
	li s3, 4294967295
	mv s8, s3
	li s9, 0
	and s6, s10, s8
	and s7, s11, s9
	mv s3, s6
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	la s2, __str_180
	lw s10, -184(s0)
	lw s11, -180(s0)
	li s3, 32
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s3, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	mv s3, s8
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	j .L87_10
.L87_9:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L87_11
	j .L87_12
.L87_11:
	lw s1, -4(s0)
	la s2, __str_181
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s10, 0(s5)
	lw s11, 4(s5)
	li s3, 65535
	mv s8, s3
	srai s9, s8, 31
	and s6, s10, s8
	and s7, s11, s9
	mv s3, s6
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	j .L87_13
.L87_12:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L87_14
	j .L87_15
.L87_14:
	lw s1, -4(s0)
	la s2, __str_182
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s10, 0(s5)
	lw s11, 4(s5)
	li s3, 255
	mv s8, s3
	srai s9, s8, 31
	and s6, s10, s8
	and s7, s11, s9
	mv s3, s6
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	j .L87_16
.L87_15:
	lw s1, -4(s0)
	la s2, __str_183
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s10, 0(s5)
	lw s11, 4(s5)
	mv s3, s10
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
.L87_16:
.L87_13:
.L87_10:
.L87_7:
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -16(s0)
.L87_17:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L87_0
.L87_2:
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	slt s3, s2, s1
	bnez s3, .L87_18
	j .L87_19
.L87_18:
	lw s1, -4(s0)
	la s2, __str_184
	lw s3, -8(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -16(s0)
	sub s5, s3, s4
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s5, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
.L87_19:
	li s1, 0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end87:
	.size emit_init_image, .Lfunc_end87-emit_init_image

	.text
	.align 2
	.type global_is_bss, @function
global_is_bss:
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
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L88_0
	j .L88_1
.L88_1:
	lw s1, -4(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L88_0
	j .L88_2
.L88_2:
	lw s1, -4(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L88_3
	j .L88_0
.L88_3:
	li s1, 1
	j .L88_4
.L88_0:
	li s1, 0
.L88_4:
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
.Lfunc_end88:
	.size global_is_bss, .Lfunc_end88-global_is_bss

	.text
	.align 2
	.type global_elsz, @function
global_elsz:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L89_0
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L89_1
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L89_2
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L89_3
	j .L89_4
.L89_0:
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
.L89_1:
	li s1, 2
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
.L89_2:
	li s1, 8
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
.L89_3:
	li s1, 8
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
.L89_4:
	li s1, 4
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
.L89_5:
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
.Lfunc_end89:
	.size global_elsz, .Lfunc_end89-global_elsz

	.text
	.align 2
	.type emit_global_head, @function
emit_global_head:
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
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L90_0
	j .L90_1
.L90_0:
	li s1, 8
	sw s1, -16(s0)
	j .L90_2
.L90_1:
	li s1, 4
	sw s1, -16(s0)
.L90_2:
	lw s1, -16(s0)
	sw s1, -12(s0)
	li s1, 0
	sw s1, -20(s0)
	lw s1, -8(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	slt s3, s2, s1
	bnez s3, .L90_3
	j .L90_4
.L90_3:
	lw s1, -8(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L90_4:
.L90_5:
	li s1, 1
	lw s2, -20(s0)
	sll s3, s1, s2
	lw s1, -12(s0)
	slt s2, s3, s1
	bnez s2, .L90_6
	j .L90_7
.L90_6:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L90_5
.L90_7:
	lw s1, -4(s0)
	la s2, __str_185
	lw s3, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -8(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L90_8
	j .L90_9
.L90_9:
	lw s1, -4(s0)
	la s2, __str_186
	lw s3, -8(s0)
	lw s4, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s4, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
.L90_8:
	lw s1, -4(s0)
	la s2, __str_187
	lw s3, -8(s0)
	lw s4, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s4, 0(sp)
	jal ra, fprintf
	mv s3, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end90:
	.size emit_global_head, .Lfunc_end90-emit_global_head

	.text
	.align 2
	.type emit_global_def, @function
emit_global_def:
	addi sp, sp, -272
	sw ra, 268(sp)
	sw s0, 264(sp)
	addi s0, sp, 264
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
	lw s1, -8(s0)
	mv a0, s1
	jal ra, global_elsz
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -8(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_0
	j .L91_1
.L91_0:
	lw s1, -4(s0)
	la s2, __str_188
	li s3, 4294967295
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	la s2, __str_189
	li s3, 1
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	la s2, __str_190
	lw s3, -8(s0)
	li s4, 60
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	la s2, __str_191
	lw s3, -8(s0)
	li s4, 60
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -8(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L91_2
	j .L91_3
.L91_2:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 56
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -8(s0)
	li s4, 60
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_string_bytes
	mv s4, a0
.L91_3:
	lw s1, -4(s0)
	la s2, __str_192
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	j .L91_4
.L91_1:
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_5
	j .L91_6
.L91_5:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_init_image
	mv s3, a0
	j .L91_7
.L91_6:
	lw s1, -8(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_8
	j .L91_9
.L91_8:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 56
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -8(s0)
	li s4, 60
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_string_bytes
	mv s4, a0
	j .L91_10
.L91_9:
	li s1, 0
	sw s1, -16(s0)
.L91_11:
	lw s1, -16(s0)
	lw s2, -8(s0)
	li s3, 52
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L91_12
	j .L91_13
.L91_12:
	lw s1, -8(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_14
	j .L91_15
.L91_14:
	lw s1, -8(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L91_16
	j .L91_15
.L91_16:
	lw t0, -4(s0)
	sw t0, -192(s0)
	la t0, __str_193
	sw t0, -188(s0)
	addi s3, s0, -176
	li t0, 160
	sw t0, -196(s0)
	lw s5, -8(s0)
	li s2, 48
	add s1, s5, s2
	lw s2, 0(s1)
	lw s1, -16(s0)
	li s5, 4
	mul s4, s1, s5
	add s1, s2, s4
	lw t0, 0(s1)
	sw t0, -200(s0)
	lw s1, -8(s0)
	li s4, 44
	add s5, s1, s4
	lw s1, 0(s5)
	lw s4, -16(s0)
	li s5, 8
	mul s2, s4, s5
	add s4, s1, s2
	lw s10, 0(s4)
	lw s11, 4(s4)
	mv a0, s3
	lw t0, -196(s0)
	mv a1, t0
	lw t0, -200(s0)
	mv a2, t0
	mv a3, s10
	mv a4, s11
	jal ra, sym_ref
	mv s1, a0
	addi sp, sp, -16
	lw t0, -192(s0)
	mv a0, t0
	lw t0, -188(s0)
	mv a1, t0
	sw s1, 0(sp)
	jal ra, fprintf
	mv s2, a0
	addi sp, sp, 16
	j .L91_17
.L91_15:
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L91_18
	j .L91_19
.L91_19:
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L91_18
	j .L91_20
.L91_18:
	lw s1, -8(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s10, 0(s2)
	lw s11, 4(s2)
	sw s10, -184(s0)
	sw s11, -180(s0)
	lw s1, -4(s0)
	la s2, __str_194
	lw s10, -184(s0)
	lw s11, -180(s0)
	li s3, 4294967295
	mv s8, s3
	li s9, 0
	and s6, s10, s8
	and s7, s11, s9
	mv s3, s6
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	la s2, __str_195
	lw s10, -184(s0)
	lw s11, -180(s0)
	li s3, 32
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s3, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	mv s3, s8
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	j .L91_21
.L91_20:
	lw s1, -12(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L91_22
	j .L91_23
.L91_22:
	lw s1, -4(s0)
	la t0, __str_196
	sw t0, -204(s0)
	lw s3, -8(s0)
	li s4, 44
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -16(s0)
	li s5, 8
	mul s2, s4, s5
	add s4, s3, s2
	lw s10, 0(s4)
	lw s11, 4(s4)
	addi sp, sp, -16
	mv a0, s1
	lw t0, -204(s0)
	mv a1, t0
	sw s10, 0(sp)
	sw s11, 4(sp)
	jal ra, fprintf
	mv s2, a0
	addi sp, sp, 16
	j .L91_24
.L91_23:
	lw s1, -12(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L91_25
	j .L91_26
.L91_25:
	lw s1, -4(s0)
	la t0, __str_197
	sw t0, -208(s0)
	lw s3, -8(s0)
	li s4, 44
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -16(s0)
	li s5, 8
	mul s2, s4, s5
	add s4, s3, s2
	lw s10, 0(s4)
	lw s11, 4(s4)
	addi sp, sp, -16
	mv a0, s1
	lw t0, -208(s0)
	mv a1, t0
	sw s10, 0(sp)
	sw s11, 4(sp)
	jal ra, fprintf
	mv s2, a0
	addi sp, sp, 16
	j .L91_27
.L91_26:
	lw s1, -4(s0)
	la t0, __str_198
	sw t0, -212(s0)
	lw s3, -8(s0)
	li s4, 44
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -16(s0)
	li s5, 8
	mul s2, s4, s5
	add s4, s3, s2
	lw s10, 0(s4)
	lw s11, 4(s4)
	addi sp, sp, -16
	mv a0, s1
	lw t0, -212(s0)
	mv a1, t0
	sw s10, 0(sp)
	sw s11, 4(sp)
	jal ra, fprintf
	mv s2, a0
	addi sp, sp, 16
.L91_27:
.L91_24:
.L91_21:
.L91_17:
.L91_28:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L91_11
.L91_13:
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 52
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L91_29
	j .L91_30
.L91_29:
	lw s1, -4(s0)
	la t0, __str_199
	sw t0, -216(s0)
	lw s3, -8(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -8(s0)
	li s5, 52
	add s2, s4, s5
	lw s4, 0(s2)
	sub s2, s3, s4
	lw s3, -12(s0)
	mul s4, s2, s3
	addi sp, sp, -16
	mv a0, s1
	lw t0, -216(s0)
	mv a1, t0
	sw s4, 0(sp)
	jal ra, fprintf
	mv s2, a0
	addi sp, sp, 16
.L91_30:
.L91_10:
.L91_7:
.L91_4:
	li s1, 0
	mv a0, s1
	lw s1, -260(s0)
	lw s2, -256(s0)
	lw s3, -252(s0)
	lw s4, -248(s0)
	lw s5, -244(s0)
	lw s6, -240(s0)
	lw s7, -236(s0)
	lw s8, -232(s0)
	lw s9, -228(s0)
	lw s10, -224(s0)
	lw s11, -220(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end91:
	.size emit_global_def, .Lfunc_end91-emit_global_def

	.text
	.align 2
	.type emit_globals, @function
emit_globals:
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
	li s1, 0
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
	la s1, __str_200
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L92_0:
	lw s1, -12(s0)
	bnez s1, .L92_1
	j .L92_2
.L92_1:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, global_is_bss
	mv s2, a0
	bnez s2, .L92_3
	j .L92_4
.L92_3:
	li s1, 1
	sw s1, -16(s0)
	j .L92_5
.L92_4:
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L92_6
	j .L92_7
.L92_6:
	li s1, 1
	sw s1, -20(s0)
	j .L92_5
.L92_7:
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_global_head
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_global_def
	mv s3, a0
.L92_5:
	lw s1, -12(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L92_0
.L92_2:
	lw s1, -20(s0)
	bnez s1, .L92_8
	j .L92_9
.L92_8:
	la s1, __str_201
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L92_10:
	lw s1, -12(s0)
	bnez s1, .L92_11
	j .L92_12
.L92_11:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, global_is_bss
	mv s2, a0
	bnez s2, .L92_13
	j .L92_14
.L92_14:
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L92_15
	j .L92_13
.L92_13:
	j .L92_16
.L92_15:
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_global_head
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_global_def
	mv s3, a0
.L92_16:
	lw s1, -12(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L92_10
.L92_12:
.L92_9:
	lw s1, -16(s0)
	bnez s1, .L92_17
	j .L92_18
.L92_18:
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
.L92_17:
	la s1, __str_202
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L92_19:
	lw s1, -12(s0)
	bnez s1, .L92_20
	j .L92_21
.L92_20:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, global_elsz
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, global_is_bss
	mv s2, a0
	bnez s2, .L92_22
	j .L92_23
.L92_23:
	j .L92_24
.L92_22:
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_global_head
	mv s3, a0
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L92_25
	j .L92_26
.L92_25:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	mul s3, s1, s2
	sw s3, -32(s0)
	j .L92_27
.L92_26:
	lw s1, -24(s0)
	sw s1, -32(s0)
.L92_27:
	lw s1, -32(s0)
	sw s1, -28(s0)
	lw s1, -4(s0)
	la s2, __str_203
	lw s3, -28(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
.L92_24:
	lw s1, -12(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L92_19
.L92_21:
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
.Lfunc_end92:
	.size emit_globals, .Lfunc_end92-emit_globals

	.text
	.align 2
	.globl target_emit
	.type target_emit, @function
target_emit:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	li s1, 0
	sw s1, -20(s0)
	la s1, __str_204
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	lw s1, -8(s0)
	lw s2, 0(s1)
	sw s2, -12(s0)
.L93_0:
	lw s1, -12(s0)
	bnez s1, .L93_1
	j .L93_2
.L93_1:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_3
	j .L93_4
.L93_3:
	lw s1, -4(s0)
	la s2, __str_205
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	j .L93_2
.L93_4:
.L93_5:
	lw s1, -12(s0)
	li s2, 100
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L93_0
.L93_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rvt_new
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -16(s0)
	bnez s1, .L93_6
	j .L93_7
.L93_7:
	la s1, __str_206
	la s2, __libc_stderr
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	li s1, 1
	mv a0, s1
	jal ra, exit
	mv s2, a0
.L93_6:
	lw s1, -8(s0)
	lw s2, 0(s1)
	sw s2, -12(s0)
.L93_8:
	lw s1, -12(s0)
	bnez s1, .L93_9
	j .L93_10
.L93_9:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	sw s3, -156(s0)
	lw s1, -4(s0)
	la s2, __str_207
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_11
	j .L93_12
.L93_12:
	lw s1, -4(s0)
	la s2, __str_208
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
.L93_11:
	lw s1, -4(s0)
	la s2, __str_209
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	la s2, __str_210
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -16(s0)
	lw s2, -156(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rvt_begin_func
	mv s3, a0
	lw s1, -16(s0)
	lw s2, -12(s0)
	la s3, target_aot_trap_guarded
	lw s4, 0(s3)
	bnez s4, .L93_13
	j .L93_14
.L93_13:
	li s3, 1
	sw s3, -160(s0)
	j .L93_15
.L93_14:
	li s3, 0
	sw s3, -160(s0)
.L93_15:
	lw s3, -160(s0)
	addi s4, s0, -152
	li s5, 128
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, rv_select_func
	mv s6, a0
	li s1, 0
	xor s2, s6, s1
	snez s2, s2
	bnez s2, .L93_16
	j .L93_17
.L93_16:
	la s1, __libc_stderr
	la s2, __str_211
	addi s3, s0, -152
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	li s1, 1
	mv a0, s1
	jal ra, exit
	mv s2, a0
.L93_17:
	lw s1, -4(s0)
	la s2, __str_212
	lw s3, -156(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -4(s0)
	la s2, __str_213
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -156(s0)
	lw s5, -12(s0)
	li s6, 4
	add s7, s5, s6
	lw s5, 0(s7)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s5, 8(sp)
	jal ra, fprintf
	mv s6, a0
	addi sp, sp, 16
.L93_18:
	lw s1, -12(s0)
	li s2, 100
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L93_8
.L93_10:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, rvt_free
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_globals
	mv s3, a0
	li s1, 0
	mv a0, s1
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end93:
	.size target_emit, .Lfunc_end93-target_emit

	.data
	.align 2
__str_213:
	.ascii "\t.size %s, .Lfunc_end%d-%s\n\000"
	.align 2
__str_212:
	.ascii ".Lfunc_end%d:\n\000"
	.align 2
__str_211:
	.ascii "rv_mc_text: %s\n\000"
	.align 2
__str_210:
	.ascii "%s:\n\000"
	.align 2
__str_209:
	.ascii "\t.type %s, @function\n\000"
	.align 2
__str_208:
	.ascii "\t.globl %s\n\000"
	.align 2
__str_207:
	.ascii "\n\t.text\n\t.align 2\n\000"
	.align 2
__str_206:
	.ascii "rv_mc_text: out of memory\n\000"
	.align 2
__str_205:
	.ascii "\t.file 1 \"%s\"\n\000"
	.align 2
__str_204:
	.ascii "# tinc: generated RISC-V (RV32IMFD + Zfh) assembly\n\000"
	.align 2
__str_203:
	.ascii "\t.space %d\n\000"
	.align 2
__str_202:
	.ascii "\n\t.bss\n\000"
	.align 2
__str_201:
	.ascii "\n\t.section .rodata\n\000"
	.align 2
__str_200:
	.ascii "\n\t.data\n\000"
	.align 2
__str_199:
	.ascii "\t.space %d\n\000"
	.align 2
__str_198:
	.ascii "\t.word %lld\n\000"
	.align 2
__str_197:
	.ascii "\t.short %lld\n\000"
	.align 2
__str_196:
	.ascii "\t.byte %lld\n\000"
	.align 2
__str_195:
	.ascii "\t.word 0x%08x\n\000"
	.align 2
__str_194:
	.ascii "\t.word 0x%08x\n\000"
	.align 2
__str_193:
	.ascii "\t.word %s\n\000"
	.align 2
__str_192:
	.ascii "\t.byte 0\n\000"
	.align 2
__str_191:
	.ascii "\t.word %d\n\000"
	.align 2
__str_190:
	.ascii "\t.word %d\n\000"
	.align 2
__str_189:
	.ascii "\t.word 0x%08x\n\000"
	.align 2
__str_188:
	.ascii "\t.word 0x%08x\n\000"
	.align 2
__str_187:
	.ascii "%s:\n\000"
	.align 2
__str_186:
	.ascii "\t.globl %s\n\000"
	.align 2
__str_185:
	.ascii "\t.align %d\n\000"
	.align 2
__str_184:
	.ascii "\t.space %d\n\000"
	.align 2
__str_183:
	.ascii "\t.word 0x%08x\n\000"
	.align 2
__str_182:
	.ascii "\t.byte 0x%02x\n\000"
	.align 2
__str_181:
	.ascii "\t.short 0x%04x\n\000"
	.align 2
__str_180:
	.ascii "\t.word 0x%08x\n\000"
	.align 2
__str_179:
	.ascii "\t.word 0x%08x\n\000"
	.align 2
__str_178:
	.ascii "\t.word %s\n\000"
	.align 2
__str_177:
	.ascii "\t.space %d\n\000"
	.align 2
__str_176:
	.ascii "%s\000"
	.align 2
__str_175:
	.ascii "%s - %lld\000"
	.align 2
__str_174:
	.ascii "%s + %lld\000"
	.align 2
__str_173:
	.ascii "\"\n\000"
	.align 2
__str_172:
	.ascii "\\%03o\000"
	.align 2
__str_171:
	.ascii "\\r\000"
	.align 2
__str_170:
	.ascii "\\t\000"
	.align 2
__str_169:
	.ascii "\\n\000"
	.align 2
__str_168:
	.ascii "\\\"\000"
	.align 2
__str_167:
	.ascii "\\\\\000"
	.align 2
__str_166:
	.ascii "\t.ascii \"\000"
	.align 2
__str_165:
	.ascii "%s\n\000"
	.align 2
__str_164:
	.ascii "\tfmv.w.x %s, %s\n\000"
	.align 2
__str_163:
	.ascii "\tfmv.x.w %s, %s\n\000"
	.align 2
__str_162:
	.ascii "\tfcvt.h.d %s, %s\n\000"
	.align 2
__str_161:
	.ascii "\tfcvt.d.h %s, %s\n\000"
	.align 2
__str_160:
	.ascii "\tfcvt.s.d %s, %s\n\000"
	.align 2
__str_159:
	.ascii "\tfcvt.d.s %s, %s\n\000"
	.align 2
__str_158:
	.ascii "d\000"
	.align 2
__str_157:
	.ascii "s\000"
	.align 2
__str_156:
	.ascii "\tfcvt.w.%s %s, %s, rne\n\000"
	.align 2
__str_155:
	.ascii "d\000"
	.align 2
__str_154:
	.ascii "s\000"
	.align 2
__str_153:
	.ascii "\tfcvt.w.%s %s, %s, rtz\n\000"
	.align 2
__str_152:
	.ascii "d\000"
	.align 2
__str_151:
	.ascii "s\000"
	.align 2
__str_150:
	.ascii "\tfcvt.%s.w %s, %s\n\000"
	.align 2
__str_149:
	.ascii "d\000"
	.align 2
__str_148:
	.ascii "s\000"
	.align 2
__str_147:
	.ascii "\tfle.%s %s, %s, %s\n\000"
	.align 2
__str_146:
	.ascii "d\000"
	.align 2
__str_145:
	.ascii "s\000"
	.align 2
__str_144:
	.ascii "\tflt.%s %s, %s, %s\n\000"
	.align 2
__str_143:
	.ascii "d\000"
	.align 2
__str_142:
	.ascii "s\000"
	.align 2
__str_141:
	.ascii "\tfeq.%s %s, %s, %s\n\000"
	.align 2
__str_140:
	.ascii "d\000"
	.align 2
__str_139:
	.ascii "s\000"
	.align 2
__str_138:
	.ascii "\tfsqrt.%s %s, %s\n\000"
	.align 2
__str_137:
	.ascii "d\000"
	.align 2
__str_136:
	.ascii "s\000"
	.align 2
__str_135:
	.ascii "\tfabs.%s %s, %s\n\000"
	.align 2
__str_134:
	.ascii "d\000"
	.align 2
__str_133:
	.ascii "s\000"
	.align 2
__str_132:
	.ascii "\tfneg.%s %s, %s\n\000"
	.align 2
__str_131:
	.ascii "fdiv\000"
	.align 2
__str_130:
	.ascii "fmul\000"
	.align 2
__str_129:
	.ascii "fsub\000"
	.align 2
__str_128:
	.ascii "fadd\000"
	.align 2
__str_127:
	.ascii "d\000"
	.align 2
__str_126:
	.ascii "s\000"
	.align 2
__str_125:
	.ascii "\t%s.%s %s, %s, %s\n\000"
	.align 2
__str_124:
	.ascii "fsh\000"
	.align 2
__str_123:
	.ascii "fsd\000"
	.align 2
__str_122:
	.ascii "fsw\000"
	.align 2
__str_121:
	.ascii "flh\000"
	.align 2
__str_120:
	.ascii "fld\000"
	.align 2
__str_119:
	.ascii "flw\000"
	.align 2
__str_118:
	.ascii "sw\000"
	.align 2
__str_117:
	.ascii "sh\000"
	.align 2
__str_116:
	.ascii "sb\000"
	.align 2
__str_115:
	.ascii "lhu\000"
	.align 2
__str_114:
	.ascii "lbu\000"
	.align 2
__str_113:
	.ascii "lw\000"
	.align 2
__str_112:
	.ascii "lh\000"
	.align 2
__str_111:
	.ascii "lb\000"
	.align 2
__str_110:
	.ascii "\tsnez %s, %s\n\000"
	.align 2
__str_109:
	.ascii "\tseqz %s, %s\n\000"
	.align 2
__str_108:
	.ascii "\tnot %s, %s\n\000"
	.align 2
__str_107:
	.ascii "\tneg %s, %s\n\000"
	.align 2
__str_106:
	.ascii "sltu\000"
	.align 2
__str_105:
	.ascii "slt\000"
	.align 2
__str_104:
	.ascii "remu\000"
	.align 2
__str_103:
	.ascii "rem\000"
	.align 2
__str_102:
	.ascii "divu\000"
	.align 2
__str_101:
	.ascii "div\000"
	.align 2
__str_100:
	.ascii "srl\000"
	.align 2
__str_99:
	.ascii "sra\000"
	.align 2
__str_98:
	.ascii "sll\000"
	.align 2
__str_97:
	.ascii "xor\000"
	.align 2
__str_96:
	.ascii "or\000"
	.align 2
__str_95:
	.ascii "and\000"
	.align 2
__str_94:
	.ascii "mulh\000"
	.align 2
__str_93:
	.ascii "mul\000"
	.align 2
__str_92:
	.ascii "sub\000"
	.align 2
__str_91:
	.ascii "add\000"
	.align 2
__str_90:
	.ascii "\t%s %s, %s, %s\n\000"
	.align 2
__str_89:
	.ascii "\tsrai %s, %s, %d\n\000"
	.align 2
__str_88:
	.ascii "\txori %s, %s, %d\n\000"
	.align 2
__str_87:
	.ascii "\tandi %s, %s, %d\n\000"
	.align 2
__str_86:
	.ascii "\taddi %s, %s, %d\n\000"
	.align 2
__str_85:
	.ascii "\tadd %s, %s, t6\n\000"
	.align 2
__str_84:
	.ascii "\tli t6, %d\n\000"
	.align 2
__str_83:
	.ascii "\taddi %s, %s, %d\n\000"
	.align 2
__str_82:
	.ascii "\tmv %s, %s\n\000"
	.align 2
__str_81:
	.ascii "\tla %s, %s\n\000"
	.align 2
__str_80:
	.ascii "\tli %s, %ld\n\000"
	.align 2
__str_79:
	.ascii "\tla %s, .L%d_%d\n\000"
	.align 2
__str_78:
	.ascii "\tjalr ra, %s, 0\n\000"
	.align 2
__str_77:
	.ascii "\tjal ra, %s\n\000"
	.align 2
__str_76:
	.ascii "\tj %s\n\000"
	.align 2
__str_75:
	.ascii "\tjr %s\n\000"
	.align 2
__str_74:
	.ascii "\tret\n\000"
	.align 2
__str_73:
	.ascii "\tbne %s, %s, .L%d_%d\n\000"
	.align 2
__str_72:
	.ascii "\tbnez %s, .L%d_%d\n\000"
	.align 2
__str_71:
	.ascii "\tbeqz %s, .L%d_%d\n\000"
	.align 2
__str_70:
	.ascii "\tj .L%d_%d\n\000"
	.align 2
__str_69:
	.ascii ".L%d_%d:\n\000"
	.align 2
__str_68:
	.ascii "\t%s %s, 0(t6)\n\000"
	.align 2
__str_67:
	.ascii "\tadd t6, %s, t6\n\000"
	.align 2
__str_66:
	.ascii "\tli t6, %d\n\000"
	.align 2
__str_65:
	.ascii "\t%s %s, %d(%s)\n\000"
	.align 2
__str_64:
	.ascii "\t.loc 1 %d\n\000"
	.align 2
fnn.t.1:
	.word __str_32
	.word __str_33
	.word __str_34
	.word __str_35
	.word __str_36
	.word __str_37
	.word __str_38
	.word __str_39
	.word __str_40
	.word __str_41
	.word __str_42
	.word __str_43
	.word __str_44
	.word __str_45
	.word __str_46
	.word __str_47
	.word __str_48
	.word __str_49
	.word __str_50
	.word __str_51
	.word __str_52
	.word __str_53
	.word __str_54
	.word __str_55
	.word __str_56
	.word __str_57
	.word __str_58
	.word __str_59
	.word __str_60
	.word __str_61
	.word __str_62
	.word __str_63
	.align 2
__str_63:
	.ascii "ft11\000"
	.align 2
__str_62:
	.ascii "ft10\000"
	.align 2
__str_61:
	.ascii "ft9\000"
	.align 2
__str_60:
	.ascii "ft8\000"
	.align 2
__str_59:
	.ascii "fs11\000"
	.align 2
__str_58:
	.ascii "fs10\000"
	.align 2
__str_57:
	.ascii "fs9\000"
	.align 2
__str_56:
	.ascii "fs8\000"
	.align 2
__str_55:
	.ascii "fs7\000"
	.align 2
__str_54:
	.ascii "fs6\000"
	.align 2
__str_53:
	.ascii "fs5\000"
	.align 2
__str_52:
	.ascii "fs4\000"
	.align 2
__str_51:
	.ascii "fs3\000"
	.align 2
__str_50:
	.ascii "fs2\000"
	.align 2
__str_49:
	.ascii "fa7\000"
	.align 2
__str_48:
	.ascii "fa6\000"
	.align 2
__str_47:
	.ascii "fa5\000"
	.align 2
__str_46:
	.ascii "fa4\000"
	.align 2
__str_45:
	.ascii "fa3\000"
	.align 2
__str_44:
	.ascii "fa2\000"
	.align 2
__str_43:
	.ascii "fa1\000"
	.align 2
__str_42:
	.ascii "fa0\000"
	.align 2
__str_41:
	.ascii "fs1\000"
	.align 2
__str_40:
	.ascii "fs0\000"
	.align 2
__str_39:
	.ascii "ft7\000"
	.align 2
__str_38:
	.ascii "ft6\000"
	.align 2
__str_37:
	.ascii "ft5\000"
	.align 2
__str_36:
	.ascii "ft4\000"
	.align 2
__str_35:
	.ascii "ft3\000"
	.align 2
__str_34:
	.ascii "ft2\000"
	.align 2
__str_33:
	.ascii "ft1\000"
	.align 2
__str_32:
	.ascii "ft0\000"
	.align 2
xn.t.0:
	.word __str_0
	.word __str_1
	.word __str_2
	.word __str_3
	.word __str_4
	.word __str_5
	.word __str_6
	.word __str_7
	.word __str_8
	.word __str_9
	.word __str_10
	.word __str_11
	.word __str_12
	.word __str_13
	.word __str_14
	.word __str_15
	.word __str_16
	.word __str_17
	.word __str_18
	.word __str_19
	.word __str_20
	.word __str_21
	.word __str_22
	.word __str_23
	.word __str_24
	.word __str_25
	.word __str_26
	.word __str_27
	.word __str_28
	.word __str_29
	.word __str_30
	.word __str_31
	.align 2
__str_31:
	.ascii "t6\000"
	.align 2
__str_30:
	.ascii "t5\000"
	.align 2
__str_29:
	.ascii "t4\000"
	.align 2
__str_28:
	.ascii "t3\000"
	.align 2
__str_27:
	.ascii "s11\000"
	.align 2
__str_26:
	.ascii "s10\000"
	.align 2
__str_25:
	.ascii "s9\000"
	.align 2
__str_24:
	.ascii "s8\000"
	.align 2
__str_23:
	.ascii "s7\000"
	.align 2
__str_22:
	.ascii "s6\000"
	.align 2
__str_21:
	.ascii "s5\000"
	.align 2
__str_20:
	.ascii "s4\000"
	.align 2
__str_19:
	.ascii "s3\000"
	.align 2
__str_18:
	.ascii "s2\000"
	.align 2
__str_17:
	.ascii "a7\000"
	.align 2
__str_16:
	.ascii "a6\000"
	.align 2
__str_15:
	.ascii "a5\000"
	.align 2
__str_14:
	.ascii "a4\000"
	.align 2
__str_13:
	.ascii "a3\000"
	.align 2
__str_12:
	.ascii "a2\000"
	.align 2
__str_11:
	.ascii "a1\000"
	.align 2
__str_10:
	.ascii "a0\000"
	.align 2
__str_9:
	.ascii "s1\000"
	.align 2
__str_8:
	.ascii "s0\000"
	.align 2
__str_7:
	.ascii "t2\000"
	.align 2
__str_6:
	.ascii "t1\000"
	.align 2
__str_5:
	.ascii "t0\000"
	.align 2
__str_4:
	.ascii "tp\000"
	.align 2
__str_3:
	.ascii "gp\000"
	.align 2
__str_2:
	.ascii "sp\000"
	.align 2
__str_1:
	.ascii "ra\000"
	.align 2
__str_0:
	.ascii "zero\000"
