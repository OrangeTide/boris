# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl strerror
	.type strerror, @function
strerror:
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
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	lw s1, -4(s0)
	li s2, 44
	li s3, 4
	div s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L1_2
	j .L1_1
.L1_2:
	la s1, messages
	lw s2, -4(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
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
.L1_1:
	la s1, __str_11
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
	.size strerror, .Lfunc_end1-strerror

	.text
	.align 2
	.globl perror
	.type perror, @function
perror:
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
	bnez s1, .L2_0
	j .L2_1
.L2_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L2_2
	j .L2_1
.L2_2:
	lw s1, -4(s0)
	la s2, __libc_stderr
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	la s1, __str_12
	la s2, __libc_stderr
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
.L2_1:
	la s1, errno
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strerror
	mv s1, a0
	la s2, __libc_stderr
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	li s1, 10
	la s2, __libc_stderr
	mv a0, s1
	mv a1, s2
	jal ra, fputc
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
.Lfunc_end2:
	.size perror, .Lfunc_end2-perror

	.data
	.align 2
__str_12:
	.ascii ": \000"
	.align 2
__str_11:
	.ascii "Unknown error\000"
	.align 2
__str_10:
	.ascii "No space left on device\000"
	.align 2
__str_9:
	.ascii "Permission denied\000"
	.align 2
__str_8:
	.ascii "Input/output error\000"
	.align 2
__str_7:
	.ascii "Bad file descriptor\000"
	.align 2
__str_6:
	.ascii "No such file or directory\000"
	.align 2
__str_5:
	.ascii "Cannot allocate memory\000"
	.align 2
__str_4:
	.ascii "Invalid argument\000"
	.align 2
__str_3:
	.ascii "Invalid or incomplete multibyte character\000"
	.align 2
__str_2:
	.ascii "Numerical result out of range\000"
	.align 2
__str_1:
	.ascii "Numerical argument out of domain\000"
	.align 2
__str_0:
	.ascii "Success\000"

	.section .rodata
	.align 2
	.globl messages
messages:
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
