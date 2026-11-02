# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type sec_reserve, @function
sec_reserve:
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
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L1_0
	j .L1_1
.L1_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L1_0
	j .L1_2
.L1_0:
	la s1, __str_0
	mv a0, s1
	jal ra, die
	mv s2, a0
.L1_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s3, s1, s2
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 2147483647
	sltu s3, s2, s1
	bnez s3, .L1_3
	j .L1_4
.L1_3:
	la s1, __str_1
	mv a0, s1
	jal ra, die
	mv s2, a0
.L1_4:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	sltu s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_5
	j .L1_6
.L1_5:
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
.L1_6:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L1_7
	j .L1_8
.L1_7:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L1_9
.L1_8:
	li s1, 256
	sw s1, -20(s0)
.L1_9:
	lw s1, -20(s0)
	sw s1, -16(s0)
.L1_10:
	lw s1, -16(s0)
	lw s2, -12(s0)
	sltu s3, s1, s2
	bnez s3, .L1_11
	j .L1_12
.L1_11:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -16(s0)
	j .L1_10
.L1_12:
	lw s1, -16(s0)
	li s2, 2147483647
	sltu s3, s2, s1
	bnez s3, .L1_13
	j .L1_14
.L1_13:
	lw s1, -12(s0)
	sw s1, -16(s0)
.L1_14:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	mv a0, s2
	mv a1, s1
	jal ra, realloc
	mv s3, a0
	lw s1, -4(s0)
	sw s3, 0(s1)
	lw s1, -4(s0)
	lw s2, 0(s1)
	bnez s2, .L1_15
	j .L1_16
.L1_16:
	la s1, __str_2
	mv a0, s1
	jal ra, die
	mv s2, a0
.L1_15:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end1:
	.size sec_reserve, .Lfunc_end1-sec_reserve

	.text
	.align 2
	.globl sec_emit8
	.type sec_emit8, @function
sec_emit8:
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
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, sec_reserve
	mv s3, a0
	addi s1, s0, -8
	lbu s2, 0(s1)
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -4(s0)
	li s4, 4
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 1
	add s6, s1, s4
	sw s6, 0(s5)
	add s4, s3, s1
	sb s2, 0(s4)
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
.Lfunc_end2:
	.size sec_emit8, .Lfunc_end2-sec_emit8

	.text
	.align 2
	.globl sec_emit16
	.type sec_emit16, @function
sec_emit16:
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
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	addi s2, s0, -8
	lhu s3, 0(s2)
	li s2, 255
	and s4, s3, s2
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	lw s1, -4(s0)
	addi s2, s0, -8
	lhu s3, 0(s2)
	li s2, 8
	sra s4, s3, s2
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	j .L3_2
.L3_1:
	lw s1, -4(s0)
	addi s2, s0, -8
	lhu s3, 0(s2)
	li s2, 8
	sra s4, s3, s2
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	lw s1, -4(s0)
	addi s2, s0, -8
	lhu s3, 0(s2)
	li s2, 255
	and s4, s3, s2
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
.L3_2:
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
.Lfunc_end3:
	.size sec_emit16, .Lfunc_end3-sec_emit16

	.text
	.align 2
	.globl sec_emit32
	.type sec_emit32, @function
sec_emit32:
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
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 255
	and s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 8
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 16
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 24
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	j .L4_2
.L4_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 24
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 16
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 8
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 255
	and s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, sec_emit8
	mv s2, a0
.L4_2:
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
	.size sec_emit32, .Lfunc_end4-sec_emit32

	.text
	.align 2
	.globl sec_align
	.type sec_align, @function
sec_align:
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
.L5_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	rem s3, s1, s2
	bnez s3, .L5_1
	j .L5_2
.L5_1:
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, sec_emit8
	mv s3, a0
	j .L5_0
.L5_2:
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
	.size sec_align, .Lfunc_end5-sec_align

	.text
	.align 2
	.globl sec_space
	.type sec_space, @function
sec_space:
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
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L6_0
	j .L6_1
.L6_0:
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
.L6_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, sec_reserve
	mv s3, a0
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	li s1, 0
	lw s2, -8(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memset
	mv s4, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end6:
	.size sec_space, .Lfunc_end6-sec_space

	.text
	.align 2
	.globl sec_add_reloc_t
	.type sec_add_reloc_t, @function
sec_add_reloc_t:
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
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L7_2
	j .L7_3
.L7_2:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -28(s0)
	j .L7_4
.L7_3:
	li s1, 16
	sw s1, -28(s0)
.L7_4:
	lw s1, -28(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, realloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
.L7_1:
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end7:
	.size sec_add_reloc_t, .Lfunc_end7-sec_add_reloc_t

	.text
	.align 2
	.globl sec_add_reloc
	.type sec_add_reloc, @function
sec_add_reloc:
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
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, sec_add_reloc_t
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
.Lfunc_end8:
	.size sec_add_reloc, .Lfunc_end8-sec_add_reloc

	.text
	.align 2
	.globl sym_lookup
	.type sym_lookup, @function
sym_lookup:
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
	li s1, 0
	sw s1, -12(s0)
.L9_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L9_1
	j .L9_2
.L9_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 32
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L9_3
	j .L9_4
.L9_3:
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
.L9_4:
.L9_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L9_0
.L9_2:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.Lfunc_end9:
	.size sym_lookup, .Lfunc_end9-sym_lookup

	.text
	.align 2
	.globl sym_add
	.type sym_add, @function
sym_add:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L10_2
	j .L10_3
.L10_2:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -16(s0)
	j .L10_4
.L10_3:
	li s1, 32
	sw s1, -16(s0)
.L10_4:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 32
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, realloc
	mv s1, a0
	lw s2, -4(s0)
	sw s1, 0(s2)
.L10_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s4, 32
	mul s5, s1, s4
	add s1, s2, s5
	sw s3, 0(s1)
	li s1, 1
	neg s2, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -12(s0)
	li s4, 32
	mul s5, s1, s4
	add s1, s3, s5
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -12(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -12(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -12(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -12(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -12(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -12(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 28
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
.Lfunc_end10:
	.size sym_add, .Lfunc_end10-sym_add

	.text
	.align 2
	.globl sym_define
	.type sym_define, @function
sym_define:
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
	lw s1, -12(s0)
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -8(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -8(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -8(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end11:
	.size sym_define, .Lfunc_end11-sym_define

	.text
	.align 2
	.globl sym_set_global
	.type sym_set_global, @function
sym_set_global:
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
	li s1, 1
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -8(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 12
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
.Lfunc_end12:
	.size sym_set_global, .Lfunc_end12-sym_set_global

	.text
	.align 2
	.globl sym_set_weak
	.type sym_set_weak, @function
sym_set_weak:
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
	li s1, 1
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -8(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -8(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 16
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
.Lfunc_end13:
	.size sym_set_weak, .Lfunc_end13-sym_set_weak

	.text
	.align 2
	.globl sym_set_func
	.type sym_set_func, @function
sym_set_func:
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
	li s1, 1
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -8(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 24
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
.Lfunc_end14:
	.size sym_set_func, .Lfunc_end14-sym_set_func

	.text
	.align 2
	.globl sym_set_size
	.type sym_set_size, @function
sym_set_size:
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
	lw s1, -12(s0)
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -8(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s3, s5
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end15:
	.size sym_set_size, .Lfunc_end15-sym_set_size

	.data
	.align 2
__str_2:
	.ascii "out of memory growing section\000"
	.align 2
__str_1:
	.ascii "section too large\000"
	.align 2
__str_0:
	.ascii "section fill count out of range\000"
