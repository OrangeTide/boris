# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl fflush
	.type fflush, @function
fflush:
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
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	li s1, 0
	sw s1, -16(s0)
	la s1, __libc_stdout
	mv a0, s1
	jal ra, fflush
	mv s2, a0
	li s1, 1
	neg s3, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L1_2
	j .L1_3
.L1_2:
	li s1, 1
	neg s2, s1
	sw s2, -16(s0)
.L1_3:
	la s1, __libc_stderr
	mv a0, s1
	jal ra, fflush
	mv s2, a0
	li s1, 1
	neg s3, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L1_4
	j .L1_5
.L1_4:
	li s1, 1
	neg s2, s1
	sw s2, -16(s0)
.L1_5:
	lw s1, -16(s0)
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
.L1_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	and s3, s1, s2
	bnez s3, .L1_6
	j .L1_7
.L1_6:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_7
	j .L1_8
.L1_7:
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
.L1_8:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L1_9
	j .L1_10
.L1_9:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	mv a0, s2
	mv t0, s1
	jalr ra, t0, 0
	mv s3, a0
	mv a0, s3
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
.L1_10:
	li s1, 0
	sw s1, -12(s0)
.L1_11:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L1_12
	j .L1_13
.L1_12:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, -12(s0)
	add s3, s4, s1
	lw s1, -4(s0)
	li s4, 12
	add s5, s1, s4
	lw s1, 0(s5)
	lw s4, -12(s0)
	sub s5, s1, s4
	mv a0, s2
	mv a1, s3
	mv a2, s5
	jal ra, write
	mv s1, a0
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_14
	j .L1_15
.L1_14:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	or s4, s1, s2
	sw s4, 0(s3)
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
.L1_15:
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -20(s0)
	add s3, s2, s1
	sw s3, -12(s0)
.L1_16:
	j .L1_11
.L1_13:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
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
	.size fflush, .Lfunc_end1-fflush

	.text
	.align 2
	.globl fputc
	.type fputc, @function
fputc:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	and s3, s1, s2
	bnez s3, .L2_0
	j .L2_1
.L2_1:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	or s4, s1, s2
	sw s4, 0(s3)
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
.L2_0:
	lw s1, -4(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -8(s0)
	li s2, 44
	add s4, s1, s2
	lw s1, -8(s0)
	li s2, 12
	add s5, s1, s2
	lw s1, 0(s5)
	li s2, 1
	add s6, s1, s2
	sw s6, 0(s5)
	add s2, s4, s1
	sb s3, 0(s2)
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1024
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_2
	j .L2_3
.L2_3:
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_2
	j .L2_4
.L2_4:
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_5
	j .L2_6
.L2_5:
	lw s1, -4(s0)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_2
	j .L2_6
.L2_2:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, fflush
	mv s2, a0
	li s1, 1
	neg s3, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L2_7
	j .L2_8
.L2_7:
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
.L2_8:
.L2_6:
	lw s1, -4(s0)
	li s2, 255
	and s3, s1, s2
	mv a0, s3
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
	.size fputc, .Lfunc_end2-fputc

	.text
	.align 2
	.globl putc
	.type putc, @function
putc:
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
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputc
	mv s3, a0
	mv a0, s3
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
	.size putc, .Lfunc_end3-putc

	.text
	.align 2
	.globl putchar
	.type putchar, @function
putchar:
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
	la s2, __libc_stdout
	mv a0, s1
	mv a1, s2
	jal ra, fputc
	mv s3, a0
	mv a0, s3
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
	.size putchar, .Lfunc_end4-putchar

	.text
	.align 2
	.globl fputs
	.type fputs, @function
fputs:
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
	lb s2, 0(s1)
	bnez s2, .L5_1
	j .L5_2
.L5_1:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	lw s1, -8(s0)
	mv a0, s3
	mv a1, s1
	jal ra, fputc
	mv s2, a0
	li s1, 1
	neg s3, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L5_3
	j .L5_4
.L5_3:
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
.L5_4:
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
	.size fputs, .Lfunc_end5-fputs

	.text
	.align 2
	.globl puts
	.type puts, @function
puts:
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
	la s2, __libc_stdout
	mv a0, s1
	mv a1, s2
	jal ra, fputs
	mv s3, a0
	li s1, 1
	neg s2, s1
	xor s1, s3, s2
	seqz s1, s1
	bnez s1, .L6_0
	j .L6_1
.L6_0:
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
.L6_1:
	li s1, 10
	la s2, __libc_stdout
	mv a0, s1
	mv a1, s2
	jal ra, fputc
	mv s3, a0
	li s1, 1
	neg s2, s1
	xor s1, s3, s2
	seqz s1, s1
	bnez s1, .L6_2
	j .L6_3
.L6_2:
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
.L6_3:
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
	.size puts, .Lfunc_end6-puts

	.text
	.align 2
	.type write_all, @function
write_all:
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
	li s1, 0
	sw s1, -20(s0)
.L7_0:
	lw s1, -20(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L7_1
	j .L7_2
.L7_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	lw s2, -12(s0)
	lw s3, -20(s0)
	sub s5, s2, s3
	mv a0, s1
	mv a1, s4
	mv a2, s5
	jal ra, write
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L7_3
	j .L7_4
.L7_3:
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
.L7_4:
	addi s1, s0, -20
	lw s2, 0(s1)
	lw s1, -24(s0)
	add s3, s2, s1
	sw s3, -20(s0)
	j .L7_0
.L7_2:
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
.Lfunc_end7:
	.size write_all, .Lfunc_end7-write_all

	.text
	.align 2
	.type flush_with_block, @function
flush_with_block:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -20(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	sw s3, -44(s0)
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	addi s1, s0, -40
	li s2, 0
	li s4, 8
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	lw s1, -20(s0)
	addi s2, s0, -40
	li s3, 0
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -8(s0)
	addi s2, s0, -40
	li s3, 1
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	addi s2, s0, -40
	li s3, 1
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -40
	li s3, 2
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, writev
	mv s4, a0
	sw s4, -48(s0)
	lw s1, -48(s0)
	lw s2, -44(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	mv a0, s1
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_1:
	lw s1, -48(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_2
	j .L8_3
.L8_2:
	lw s1, -48(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L8_4
	j .L8_5
.L8_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, -48(s0)
	add s3, s4, s1
	lw s1, -20(s0)
	lw s4, -48(s0)
	sub s5, s1, s4
	mv a0, s2
	mv a1, s3
	mv a2, s5
	jal ra, write_all
	mv s1, a0
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L8_6
	j .L8_7
.L8_6:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_7:
	li s1, 0
	sw s1, -48(s0)
	j .L8_8
.L8_5:
	addi s1, s0, -48
	lw s2, 0(s1)
	lw s1, -20(s0)
	sub s3, s2, s1
	sw s3, -48(s0)
.L8_8:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	lw s3, -48(s0)
	add s4, s1, s3
	lw s1, -12(s0)
	lw s3, -48(s0)
	sub s5, s1, s3
	mv a0, s2
	mv a1, s4
	mv a2, s5
	jal ra, write_all
	mv s1, a0
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L8_9
	j .L8_10
.L8_9:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_10:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	mv a0, s1
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_3:
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L8_11
	j .L8_12
.L8_11:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_12:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, -20(s0)
	mv a0, s2
	mv a1, s4
	mv a2, s1
	jal ra, write_all
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L8_13
	j .L8_14
.L8_13:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_14:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	lw s3, -12(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, write_all
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L8_15
	j .L8_16
.L8_15:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_16:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	mv a0, s1
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end8:
	.size flush_with_block, .Lfunc_end8-flush_with_block

	.text
	.align 2
	.globl fwrite
	.type fwrite, @function
fwrite:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	mul s3, s1, s2
	sw s3, -24(s0)
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_0
	j .L9_1
.L9_1:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_0
	j .L9_2
.L9_0:
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
.L9_2:
	lw s1, -16(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	and s3, s1, s2
	bnez s3, .L9_3
	j .L9_4
.L9_3:
	lw s1, -16(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_5
	j .L9_4
.L9_5:
	lw s1, -16(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_6
	j .L9_4
.L9_6:
	lw s1, -24(s0)
	li s2, 1024
	lw s3, -16(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	sub s4, s2, s3
	sltu s2, s4, s1
	bnez s2, .L9_7
	j .L9_4
.L9_7:
	lw s1, -16(s0)
	lw s2, -20(s0)
	lw s3, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, flush_with_block
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L9_8
	j .L9_9
.L9_8:
	lw s1, -16(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	or s4, s1, s2
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
.L9_9:
	lw s1, -12(s0)
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
.L9_4:
	li s1, 0
	sw s1, -28(s0)
.L9_10:
	lw s1, -28(s0)
	lw s2, -24(s0)
	sltu s3, s1, s2
	bnez s3, .L9_11
	j .L9_12
.L9_11:
	lw s1, -20(s0)
	lw s2, -28(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fputc
	mv s3, a0
	li s1, 1
	neg s2, s1
	xor s1, s3, s2
	seqz s1, s1
	bnez s1, .L9_13
	j .L9_14
.L9_13:
	j .L9_12
.L9_14:
.L9_15:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L9_10
.L9_12:
	lw s1, -28(s0)
	lw s2, -8(s0)
	divu s3, s1, s2
	mv a0, s3
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
.Lfunc_end9:
	.size fwrite, .Lfunc_end9-fwrite

	.text
	.align 2
	.type refill, @function
refill:
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
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 44
	add s4, s1, s3
	li s1, 1024
	mv a0, s2
	mv a1, s4
	mv a2, s1
	jal ra, read
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s4, 0
	xor s5, s2, s4
	seqz s5, s5
	bnez s5, .L10_2
	j .L10_3
.L10_2:
	li s2, 4
	sw s2, -16(s0)
	j .L10_4
.L10_3:
	li s2, 8
	sw s2, -16(s0)
.L10_4:
	lw s2, -16(s0)
	or s4, s1, s2
	sw s4, 0(s3)
	li s1, 0
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
.L10_1:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
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
.Lfunc_end10:
	.size refill, .Lfunc_end10-refill

	.text
	.align 2
	.globl fgetc
	.type fgetc, @function
fgetc:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	and s3, s1, s2
	bnez s3, .L11_0
	j .L11_1
.L11_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	or s4, s1, s2
	sw s4, 0(s3)
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
.L11_0:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_2
	j .L11_3
.L11_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, refill
	mv s2, a0
	li s1, 1
	neg s3, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L11_4
	j .L11_5
.L11_4:
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
.L11_5:
.L11_3:
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 1
	add s5, s1, s2
	sw s5, 0(s4)
	add s2, s3, s1
	lbu s1, 0(s2)
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
	.size fgetc, .Lfunc_end11-fgetc

	.text
	.align 2
	.globl getc
	.type getc, @function
getc:
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
	jal ra, fgetc
	mv s2, a0
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
.Lfunc_end12:
	.size getc, .Lfunc_end12-getc

	.text
	.align 2
	.globl getchar
	.type getchar, @function
getchar:
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
	la s1, __libc_stdin
	mv a0, s1
	jal ra, fgetc
	mv s2, a0
	mv a0, s2
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
.Lfunc_end13:
	.size getchar, .Lfunc_end13-getchar

	.text
	.align 2
	.globl fgets
	.type fgets, @function
fgets:
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
	li s1, 0
	sw s1, -20(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L14_0
	j .L14_1
.L14_0:
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
.L14_1:
.L14_2:
	lw s1, -20(s0)
	lw s2, -8(s0)
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L14_3
	j .L14_4
.L14_3:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fgetc
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L14_5
	j .L14_6
.L14_5:
	j .L14_4
.L14_6:
	lw s1, -24(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	addi s3, s0, -20
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -20(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	lw s1, -24(s0)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_7
	j .L14_8
.L14_7:
	j .L14_4
.L14_8:
	j .L14_2
.L14_4:
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_9
	j .L14_10
.L14_9:
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
.L14_10:
	li s1, 0
	lw s2, -4(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	sb s1, 0(s4)
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
.Lfunc_end14:
	.size fgets, .Lfunc_end14-fgets

	.text
	.align 2
	.globl fread
	.type fread, @function
fread:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	mul s3, s1, s2
	sw s3, -24(s0)
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_0
	j .L15_1
.L15_1:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_0
	j .L15_2
.L15_0:
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
.L15_2:
	li s1, 0
	sw s1, -28(s0)
.L15_3:
	lw s1, -28(s0)
	lw s2, -24(s0)
	sltu s3, s1, s2
	bnez s3, .L15_4
	j .L15_5
.L15_4:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, fgetc
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L15_6
	j .L15_7
.L15_6:
	j .L15_5
.L15_7:
	lw s1, -32(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -20(s0)
	lw s2, -28(s0)
	add s4, s1, s2
	sb s3, 0(s4)
.L15_8:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L15_3
.L15_5:
	lw s1, -28(s0)
	lw s2, -8(s0)
	divu s3, s1, s2
	mv a0, s3
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
.Lfunc_end15:
	.size fread, .Lfunc_end15-fread

	.text
	.align 2
	.globl feof
	.type feof, @function
feof:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	and s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
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
.Lfunc_end16:
	.size feof, .Lfunc_end16-feof

	.text
	.align 2
	.globl ferror
	.type ferror, @function
ferror:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	and s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
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
.Lfunc_end17:
	.size ferror, .Lfunc_end17-ferror

	.text
	.align 2
	.globl clearerr
	.type clearerr, @function
clearerr:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	li s4, 8
	or s5, s2, s4
	not s2, s5
	and s4, s1, s2
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
.Lfunc_end18:
	.size clearerr, .Lfunc_end18-clearerr

	.data
	.align 2
	.globl __libc_stderr
__libc_stderr:
	.word 0x00000002
	.word 0x00000002
	.word 0x00000002
	.word 0x00000000
	.word 0x00000000
	.space 1048
	.align 2
	.globl __libc_stdout
__libc_stdout:
	.word 0x00000001
	.word 0x00000002
	.word 0x00000001
	.word 0x00000000
	.word 0x00000000
	.space 1048
	.align 2
	.globl __libc_stdin
__libc_stdin:
	.word 0x00000000
	.word 0x00000001
	.word 0x00000001
	.word 0x00000000
	.word 0x00000000
	.space 1048
