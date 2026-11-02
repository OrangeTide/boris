# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl atexit
	.type atexit, @function
atexit:
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
	la s1, nhandlers
	lw s2, 0(s1)
	li s1, 32
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L1_1:
	lw s1, -4(s0)
	la s2, handlers
	la s3, nhandlers
	lw s4, 0(s3)
	li s5, 1
	add s6, s4, s5
	sw s6, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
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
	.size atexit, .Lfunc_end1-atexit

	.text
	.align 2
	.globl __libc_fini
	.type __libc_fini, @function
__libc_fini:
	addi sp, sp, -64
	sw ra, 60(sp)
	sw s0, 56(sp)
	addi s0, sp, 56
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
	la s1, finished
	lw s2, 0(s1)
	bnez s2, .L2_0
	j .L2_1
.L2_0:
	lw s1, -44(s0)
	lw s2, -40(s0)
	lw s3, -36(s0)
	lw s4, -32(s0)
	lw s5, -28(s0)
	lw s6, -24(s0)
	lw s7, -20(s0)
	lw s8, -16(s0)
	lw s9, -12(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L2_1:
	li s1, 1
	la s2, finished
	sw s1, 0(s2)
.L2_2:
	la s1, nhandlers
	lw s2, 0(s1)
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L2_3
	j .L2_4
.L2_3:
	la s1, handlers
	la s2, nhandlers
	lw s3, 0(s2)
	li s4, -1
	add s5, s3, s4
	sw s5, 0(s2)
	li s2, 4
	mul s3, s5, s2
	add s2, s1, s3
	lw s1, 0(s2)
	mv t0, s1
	jalr ra, t0, 0
	mv s2, a0
	j .L2_2
.L2_4:
	li s1, 0
	mv a0, s1
	jal ra, fflush
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -44(s0)
	lw s2, -40(s0)
	lw s3, -36(s0)
	lw s4, -32(s0)
	lw s5, -28(s0)
	lw s6, -24(s0)
	lw s7, -20(s0)
	lw s8, -16(s0)
	lw s9, -12(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end2:
	.size __libc_fini, .Lfunc_end2-__libc_fini

	.text
	.align 2
	.globl exit
	.type exit, @function
exit:
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
	jal ra, __libc_fini
	mv s1, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, _exit
	mv s2, a0
.L3_0:
	j .L3_1
.L3_1:
.L3_2:
	j .L3_0
.L3_3:
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
	.size exit, .Lfunc_end3-exit

	.data

	.bss
	.align 2
	.globl finished
finished:
	.space 4
	.align 2
	.globl nhandlers
nhandlers:
	.space 4
	.align 2
	.globl handlers
handlers:
	.space 128
