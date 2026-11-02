# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl __libc_sbrk
	.type __libc_sbrk, @function
__libc_sbrk:
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
	la s1, cur_brk
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	li s1, 0
	mv a0, s1
	jal ra, __sys_brk
	mv s2, a0
	la s1, cur_brk
	sw s2, 0(s1)
	la s1, cur_brk
	lw s2, 0(s1)
	li s1, 1
	neg s3, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L1_2
	j .L1_3
.L1_3:
	la s1, cur_brk
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_2
	j .L1_4
.L1_2:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L1_4:
.L1_1:
	la s1, cur_brk
	lw s2, 0(s1)
	sw s2, -12(s0)
	lw s1, -12(s0)
	lw s2, -4(s0)
	add s3, s1, s2
	sw s3, -16(s0)
	lw s1, -4(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L1_5
	j .L1_6
.L1_5:
	lw s1, -16(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L1_7
	j .L1_6
.L1_7:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L1_8
	j .L1_9
.L1_8:
	lw s1, -16(s0)
	lw s2, -12(s0)
	slt s3, s2, s1
	bnez s3, .L1_10
	j .L1_9
.L1_10:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L1_9:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, __sys_brk
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -4(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L1_11
	j .L1_12
.L1_11:
	lw s1, -20(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L1_13
	j .L1_12
.L1_13:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L1_12:
	lw s1, -20(s0)
	la s2, cur_brk
	sw s1, 0(s2)
	lw s1, -12(s0)
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
	.size __libc_sbrk, .Lfunc_end1-__libc_sbrk

	.data

	.bss
	.align 2
	.globl cur_brk
cur_brk:
	.space 4
