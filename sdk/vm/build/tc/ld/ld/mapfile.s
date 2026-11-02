# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl mapfile_open
	.type mapfile_open, @function
mapfile_open:
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
	lw s2, -4(s0)
	sw s1, 0(s2)
	li s1, 0
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	li s2, 0
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, open
	mv s4, a0
	sw s4, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L1_1:
	lw s1, -12(s0)
	li s2, 0
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lseek
	mv s4, a0
	sw s4, -16(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L1_2
	j .L1_3
.L1_3:
	lw s1, -12(s0)
	li s2, 0
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lseek
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L1_2
	j .L1_4
.L1_2:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, close
	mv s2, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L1_4:
	lw s1, -16(s0)
	bnez s1, .L1_5
	j .L1_6
.L1_5:
	lw s1, -16(s0)
	sw s1, -24(s0)
	j .L1_7
.L1_6:
	li s1, 1
	sw s1, -24(s0)
.L1_7:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, malloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L1_8
	j .L1_9
.L1_9:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, close
	mv s2, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L1_8:
	li s1, 0
	sw s1, -28(s0)
.L1_10:
	lw s1, -28(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L1_11
	j .L1_12
.L1_11:
	lw s1, -12(s0)
	lw s2, -20(s0)
	lw s3, -28(s0)
	add s4, s2, s3
	lw s2, -16(s0)
	lw s3, -28(s0)
	sub s5, s2, s3
	mv a0, s1
	mv a1, s4
	mv a2, s5
	jal ra, read
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_13
	j .L1_14
.L1_13:
	j .L1_12
.L1_14:
	addi s1, s0, -28
	lw s2, 0(s1)
	lw s1, -32(s0)
	add s3, s2, s1
	sw s3, -28(s0)
	j .L1_10
.L1_12:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, close
	mv s2, a0
	lw s1, -28(s0)
	lw s2, -16(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L1_15
	j .L1_16
.L1_15:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L1_16:
	lw s1, -20(s0)
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end1:
	.size mapfile_open, .Lfunc_end1-mapfile_open

	.text
	.align 2
	.globl mapfile_close
	.type mapfile_close, @function
mapfile_close:
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
	bnez s2, .L2_0
	j .L2_1
.L2_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li s1, 0
	lw s2, -4(s0)
	sw s1, 0(s2)
.L2_1:
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
	.size mapfile_close, .Lfunc_end2-mapfile_close

	.data
