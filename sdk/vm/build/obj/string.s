# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl memcpy
	.type memcpy, @function
memcpy:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
	lw s1, -8(s0)
	sw s1, -24(s0)
.L1_0:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L1_1
	j .L1_2
.L1_1:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	lbu s1, 0(s2)
	addi s2, s0, -20
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -20(s0)
	sb s1, 0(s3)
	j .L1_0
.L1_2:
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
.Lfunc_end1:
	.size memcpy, .Lfunc_end1-memcpy

	.text
	.align 2
	.globl memmove
	.type memmove, @function
memmove:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
	lw s1, -8(s0)
	sw s1, -24(s0)
	lw s1, -20(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	bnez s3, .L2_0
	j .L2_1
.L2_0:
.L2_2:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L2_3
	j .L2_4
.L2_3:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	lbu s1, 0(s2)
	addi s2, s0, -20
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -20(s0)
	sb s1, 0(s3)
	j .L2_2
.L2_4:
	j .L2_5
.L2_1:
	lw s1, -20(s0)
	lw s2, -24(s0)
	slt s3, s2, s1
	bnez s3, .L2_6
	j .L2_7
.L2_6:
	addi s1, s0, -20
	lw s2, 0(s1)
	lw s1, -12(s0)
	add s3, s2, s1
	sw s3, -20(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	lw s1, -12(s0)
	add s3, s2, s1
	sw s3, -24(s0)
.L2_8:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L2_9
	j .L2_10
.L2_9:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -24(s0)
	lbu s1, 0(s3)
	addi s2, s0, -20
	lw s3, 0(s2)
	li s2, -1
	add s4, s3, s2
	sw s4, -20(s0)
	sb s1, 0(s4)
	j .L2_8
.L2_10:
.L2_7:
.L2_5:
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
.Lfunc_end2:
	.size memmove, .Lfunc_end2-memmove

	.text
	.align 2
	.globl memset
	.type memset, @function
memset:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
.L3_0:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L3_1
	j .L3_2
.L3_1:
	lw s1, -8(s0)
	li s2, 255
	and s3, s1, s2
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -20(s0)
	sb s3, 0(s2)
	j .L3_0
.L3_2:
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
.Lfunc_end3:
	.size memset, .Lfunc_end3-memset

	.text
	.align 2
	.globl memcmp
	.type memcmp, @function
memcmp:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
	lw s1, -8(s0)
	sw s1, -24(s0)
.L4_0:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L4_1
	j .L4_2
.L4_1:
	lw s1, -20(s0)
	lbu s2, 0(s1)
	lw s1, -24(s0)
	lbu s3, 0(s1)
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L4_3
	j .L4_4
.L4_3:
	lw s1, -20(s0)
	lbu s2, 0(s1)
	lw s1, -24(s0)
	lbu s3, 0(s1)
	sub s1, s2, s3
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
.L4_4:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L4_0
.L4_2:
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
.Lfunc_end4:
	.size memcmp, .Lfunc_end4-memcmp

	.text
	.align 2
	.globl memchr
	.type memchr, @function
memchr:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
	lw s1, -8(s0)
	li s2, 255
	and s3, s1, s2
	sw s3, -24(s0)
.L5_0:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L5_1
	j .L5_2
.L5_1:
	lw s1, -20(s0)
	lbu s2, 0(s1)
	addi s1, s0, -24
	lbu s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L5_3
	j .L5_4
.L5_3:
	lw s1, -20(s0)
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
.L5_4:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L5_0
.L5_2:
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
.Lfunc_end5:
	.size memchr, .Lfunc_end5-memchr

	.text
	.align 2
	.globl strlen
	.type strlen, @function
strlen:
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
	sw s1, -12(s0)
.L6_0:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L6_1
	j .L6_2
.L6_1:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L6_0
.L6_2:
	lw s1, -12(s0)
	lw s2, -4(s0)
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
.Lfunc_end6:
	.size strlen, .Lfunc_end6-strlen

	.text
	.align 2
	.globl strnlen
	.type strnlen, @function
strnlen:
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
.L7_0:
	lw s1, -12(s0)
	lw s2, -8(s0)
	sltu s3, s1, s2
	bnez s3, .L7_1
	j .L7_2
.L7_1:
	lw s1, -4(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L7_3
	j .L7_2
.L7_3:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L7_0
.L7_2:
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
.Lfunc_end7:
	.size strnlen, .Lfunc_end7-strnlen

	.text
	.align 2
	.globl strcmp
	.type strcmp, @function
strcmp:
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
.L8_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L8_1
	j .L8_2
.L8_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	lw s1, -8(s0)
	lb s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L8_3
	j .L8_2
.L8_3:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L8_0
.L8_2:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 255
	and s4, s2, s1
	sub s1, s3, s4
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
.Lfunc_end8:
	.size strcmp, .Lfunc_end8-strcmp

	.text
	.align 2
	.globl strncmp
	.type strncmp, @function
strncmp:
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
.L9_0:
	lw s1, -12(s0)
	bnez s1, .L9_1
	j .L9_2
.L9_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L9_3
	j .L9_2
.L9_3:
	lw s1, -4(s0)
	lb s2, 0(s1)
	lw s1, -8(s0)
	lb s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L9_4
	j .L9_2
.L9_4:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L9_0
.L9_2:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_5
	j .L9_6
.L9_5:
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
.L9_6:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 255
	and s4, s2, s1
	sub s1, s3, s4
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
.Lfunc_end9:
	.size strncmp, .Lfunc_end9-strncmp

	.text
	.align 2
	.globl strcpy
	.type strcpy, @function
strcpy:
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
.L10_0:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lb s1, 0(s2)
	addi s2, s0, -12
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -12(s0)
	sb s1, 0(s3)
	bnez s1, .L10_1
	j .L10_2
.L10_1:
	j .L10_0
.L10_2:
	lw s1, -4(s0)
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
	.size strcpy, .Lfunc_end10-strcpy

	.text
	.align 2
	.globl strncpy
	.type strncpy, @function
strncpy:
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
.L11_0:
	lw s1, -20(s0)
	lw s2, -12(s0)
	sltu s3, s1, s2
	bnez s3, .L11_1
	j .L11_2
.L11_1:
	lw s1, -8(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L11_3
	j .L11_2
.L11_3:
	lw s1, -8(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	lw s2, -4(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L11_0
.L11_2:
.L11_4:
	lw s1, -20(s0)
	lw s2, -12(s0)
	sltu s3, s1, s2
	bnez s3, .L11_5
	j .L11_6
.L11_5:
	li s1, 0
	lw s2, -4(s0)
	addi s3, s0, -20
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -20(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L11_4
.L11_6:
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
.Lfunc_end11:
	.size strncpy, .Lfunc_end11-strncpy

	.text
	.align 2
	.globl strcat
	.type strcat, @function
strcat:
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
.L12_0:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L12_1
	j .L12_2
.L12_1:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L12_0
.L12_2:
.L12_3:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lb s1, 0(s2)
	addi s2, s0, -12
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -12(s0)
	sb s1, 0(s3)
	bnez s1, .L12_4
	j .L12_5
.L12_4:
	j .L12_3
.L12_5:
	lw s1, -4(s0)
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
	.size strcat, .Lfunc_end12-strcat

	.text
	.align 2
	.globl strncat
	.type strncat, @function
strncat:
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
	lw s1, -4(s0)
	sw s1, -20(s0)
.L13_0:
	lw s1, -20(s0)
	lb s2, 0(s1)
	bnez s2, .L13_1
	j .L13_2
.L13_1:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L13_0
.L13_2:
.L13_3:
	lw s1, -12(s0)
	bnez s1, .L13_4
	j .L13_5
.L13_4:
	lw s1, -8(s0)
	lb s2, 0(s1)
	bnez s2, .L13_6
	j .L13_5
.L13_6:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	lb s1, 0(s2)
	addi s2, s0, -20
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -20(s0)
	sb s1, 0(s3)
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L13_3
.L13_5:
	li s1, 0
	lw s2, -20(s0)
	sb s1, 0(s2)
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
.Lfunc_end13:
	.size strncat, .Lfunc_end13-strncat

	.text
	.align 2
	.globl strchr
	.type strchr, @function
strchr:
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
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	sw s2, -12(s0)
.L14_0:
	j .L14_1
.L14_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	addi s1, s0, -12
	lb s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L14_2
	j .L14_3
.L14_2:
	lw s1, -4(s0)
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
.L14_3:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_4
	j .L14_5
.L14_4:
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
.L14_5:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L14_6:
	j .L14_0
.L14_7:
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
	.size strchr, .Lfunc_end14-strchr

	.text
	.align 2
	.globl strrchr
	.type strrchr, @function
strrchr:
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
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	sw s2, -12(s0)
	li s1, 0
	sw s1, -16(s0)
.L15_0:
	j .L15_1
.L15_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	addi s1, s0, -12
	lb s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L15_2
	j .L15_3
.L15_2:
	lw s1, -4(s0)
	sw s1, -16(s0)
.L15_3:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L15_4
	j .L15_5
.L15_4:
	lw s1, -16(s0)
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
.L15_5:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
.L15_6:
	j .L15_0
.L15_7:
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
	.size strrchr, .Lfunc_end15-strrchr

	.text
	.align 2
	.globl strstr
	.type strstr, @function
strstr:
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
	lw s1, -8(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L16_0
	j .L16_1
.L16_0:
	lw s1, -4(s0)
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
.L16_1:
.L16_2:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L16_3
	j .L16_4
.L16_3:
	lw s1, -4(s0)
	sw s1, -12(s0)
	lw s1, -8(s0)
	sw s1, -16(s0)
.L16_5:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L16_6
	j .L16_7
.L16_6:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L16_8
	j .L16_7
.L16_8:
	lw s1, -12(s0)
	lb s2, 0(s1)
	lw s1, -16(s0)
	lb s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L16_9
	j .L16_7
.L16_9:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L16_5
.L16_7:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L16_10
	j .L16_11
.L16_10:
	lw s1, -4(s0)
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
.L16_11:
.L16_12:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L16_2
.L16_4:
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
.Lfunc_end16:
	.size strstr, .Lfunc_end16-strstr

	.text
	.align 2
	.globl strspn
	.type strspn, @function
strspn:
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
.L17_0:
	lw s1, -4(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L17_1
	j .L17_2
.L17_1:
	lw s1, -8(s0)
	sw s1, -16(s0)
.L17_3:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L17_4
	j .L17_5
.L17_4:
	lw s1, -16(s0)
	lb s2, 0(s1)
	lw s1, -4(s0)
	lw s3, -12(s0)
	add s4, s1, s3
	lb s1, 0(s4)
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L17_6
	j .L17_5
.L17_6:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L17_3
.L17_5:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_7
	j .L17_8
.L17_7:
	j .L17_2
.L17_8:
.L17_9:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L17_0
.L17_2:
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
.Lfunc_end17:
	.size strspn, .Lfunc_end17-strspn

	.text
	.align 2
	.globl strcspn
	.type strcspn, @function
strcspn:
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
.L18_0:
	lw s1, -4(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L18_1
	j .L18_2
.L18_1:
	lw s1, -8(s0)
	sw s1, -16(s0)
.L18_3:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L18_4
	j .L18_5
.L18_4:
	lw s1, -16(s0)
	lb s2, 0(s1)
	lw s1, -4(s0)
	lw s3, -12(s0)
	add s4, s1, s3
	lb s1, 0(s4)
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L18_6
	j .L18_5
.L18_6:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L18_3
.L18_5:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L18_7
	j .L18_8
.L18_7:
	j .L18_2
.L18_8:
.L18_9:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L18_0
.L18_2:
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
.Lfunc_end18:
	.size strcspn, .Lfunc_end18-strcspn

	.text
	.align 2
	.globl strpbrk
	.type strpbrk, @function
strpbrk:
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
.L19_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L19_1
	j .L19_2
.L19_1:
	lw s1, -8(s0)
	sw s1, -12(s0)
.L19_3:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L19_4
	j .L19_5
.L19_4:
	lw s1, -12(s0)
	lb s2, 0(s1)
	lw s1, -4(s0)
	lb s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L19_6
	j .L19_7
.L19_6:
	lw s1, -4(s0)
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
.L19_7:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L19_3
.L19_5:
.L19_8:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L19_0
.L19_2:
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
.Lfunc_end19:
	.size strpbrk, .Lfunc_end19-strpbrk

	.data
