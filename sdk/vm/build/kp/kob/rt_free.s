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
.L2_0:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L2_1
	j .L2_2
.L2_1:
	lw s1, -8(s0)
	li s2, 255
	and s3, s1, s2
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -20(s0)
	sb s3, 0(s2)
	j .L2_0
.L2_2:
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
	.size memset, .Lfunc_end2-memset

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
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_0
	j .L3_1
.L3_0:
.L3_2:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L3_3
	j .L3_4
.L3_3:
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
	j .L3_2
.L3_4:
	j .L3_5
.L3_1:
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
.L3_6:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	bnez s2, .L3_7
	j .L3_8
.L3_7:
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
	j .L3_6
.L3_8:
.L3_5:
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
	.size memmove, .Lfunc_end3-memmove

	.text
	.align 2
	.globl rt_memcmp
	.type rt_memcmp, @function
rt_memcmp:
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
	slt s1, s2, s3
	bnez s1, .L4_5
	j .L4_6
.L4_5:
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
	j .L4_7
.L4_6:
	li s1, 1
	sw s1, -28(s0)
.L4_7:
	lw s1, -28(s0)
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
.Lfunc_end4:
	.size rt_memcmp, .Lfunc_end4-rt_memcmp

	.text
	.align 2
	.globl memcmp
	.type memcmp, @function
memcmp:
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
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rt_memcmp
	mv s4, a0
	mv a0, s4
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
.Lfunc_end5:
	.size memcmp, .Lfunc_end5-memcmp

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
.L7_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L7_1
	j .L7_2
.L7_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	lw s1, -8(s0)
	lb s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L7_3
	j .L7_2
.L7_3:
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
	j .L7_0
.L7_2:
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
.Lfunc_end7:
	.size strcmp, .Lfunc_end7-strcmp

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
.L8_0:
	lw s1, -20(s0)
	lw s2, -12(s0)
	sltu s3, s1, s2
	bnez s3, .L8_1
	j .L8_2
.L8_1:
	lw s1, -8(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L8_3
	j .L8_2
.L8_3:
	lw s1, -8(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	lw s2, -4(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L8_4:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L8_0
.L8_2:
.L8_5:
	lw s1, -20(s0)
	lw s2, -12(s0)
	sltu s3, s1, s2
	bnez s3, .L8_6
	j .L8_7
.L8_6:
	li s1, 0
	lw s2, -4(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L8_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L8_5
.L8_7:
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
.Lfunc_end8:
	.size strncpy, .Lfunc_end8-strncpy

	.text
	.align 2
	.type trap_die, @function
trap_die:
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
	li s1, 0
	sw s1, -16(s0)
.L9_0:
	lw s1, -12(s0)
	lw s2, -16(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L9_1
	j .L9_2
.L9_1:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L9_0
.L9_2:
	li s1, 2
	lw s2, -4(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, write
	mv s4, a0
	li s1, 2
	la s2, __str_0
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, write
	mv s4, a0
	li s1, 70
	mv a0, s1
	jal ra, __skj_trap_backtrace
	mv s2, a0
	li s1, 70
	mv a0, s1
	jal ra, _exit
	mv s2, a0
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
.Lfunc_end9:
	.size trap_die, .Lfunc_end9-trap_die

	.text
	.align 2
	.globl rt_trap
	.type rt_trap, @function
rt_trap:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	la s1, __str_1
	mv a0, s1
	jal ra, trap_die
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
.Lfunc_end10:
	.size rt_trap, .Lfunc_end10-rt_trap

	.text
	.align 2
	.globl kp_trap_div_zero
	.type kp_trap_div_zero, @function
kp_trap_div_zero:
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
	la s1, __str_2
	mv a0, s1
	jal ra, trap_die
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
.Lfunc_end11:
	.size kp_trap_div_zero, .Lfunc_end11-kp_trap_div_zero

	.text
	.align 2
	.globl kp_trap_overflow
	.type kp_trap_overflow, @function
kp_trap_overflow:
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
	la s1, __str_3
	mv a0, s1
	jal ra, trap_die
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
.Lfunc_end12:
	.size kp_trap_overflow, .Lfunc_end12-kp_trap_overflow

	.text
	.align 2
	.globl kp_trap_index
	.type kp_trap_index, @function
kp_trap_index:
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
	la s1, __str_4
	mv a0, s1
	jal ra, trap_die
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
.Lfunc_end13:
	.size kp_trap_index, .Lfunc_end13-kp_trap_index

	.text
	.align 2
	.globl kp_abort
	.type kp_abort, @function
kp_abort:
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
	la s1, __str_5
	mv a0, s1
	jal ra, trap_die
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
.Lfunc_end14:
	.size kp_abort, .Lfunc_end14-kp_abort

	.text
	.align 2
	.globl kp_assert
	.type kp_assert, @function
kp_assert:
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
	bnez s1, .L15_0
	j .L15_1
.L15_1:
	la s1, __str_6
	mv a0, s1
	jal ra, trap_die
	mv s2, a0
.L15_0:
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
	.size kp_assert, .Lfunc_end15-kp_assert

	.text
	.align 2
	.globl kp_rt_init
	.type kp_rt_init, @function
kp_rt_init:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
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
	.size kp_rt_init, .Lfunc_end16-kp_rt_init

	.text
	.align 2
	.type gh_round_up, @function
gh_round_up:
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
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	lw s1, -8(s0)
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
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
.Lfunc_end17:
	.size gh_round_up, .Lfunc_end17-gh_round_up

	.text
	.align 2
	.type gh_push_free, @function
gh_push_free:
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
	li s1, 16
	divu s3, s2, s1
	sw s3, -12(s0)
	li s1, 1
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 512
	sltu s3, s1, s2
	bnez s3, .L18_0
	j .L18_1
.L18_0:
	la s1, gh_bins
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	la s2, gh_bins
	lw s3, -12(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L18_2
.L18_1:
	la s1, gh_large
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	la s2, gh_large
	sw s1, 0(s2)
.L18_2:
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
.Lfunc_end18:
	.size gh_push_free, .Lfunc_end18-gh_push_free

	.text
	.align 2
	.type gh_payload, @function
gh_payload:
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
	li s3, 16
	add s4, s2, s3
	li s2, 1
	sub s3, s4, s2
	li s2, 16
	li s4, 1
	sub s5, s2, s4
	not s2, s5
	and s4, s3, s2
	add s2, s1, s4
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
.Lfunc_end19:
	.size gh_payload, .Lfunc_end19-gh_payload

	.text
	.align 2
	.type gh_block_of, @function
gh_block_of:
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
	li s3, 16
	add s4, s2, s3
	li s2, 1
	sub s3, s4, s2
	li s2, 16
	li s4, 1
	sub s5, s2, s4
	not s2, s5
	and s4, s3, s2
	sub s2, s1, s4
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
.Lfunc_end20:
	.size gh_block_of, .Lfunc_end20-gh_block_of

	.text
	.align 2
	.type gh_alloc, @function
gh_alloc:
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
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L21_0
	j .L21_1
.L21_0:
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
.L21_1:
	lw s1, -4(s0)
	li s2, 12
	li s3, 16
	add s4, s2, s3
	li s2, 1
	sub s3, s4, s2
	li s2, 16
	li s4, 1
	sub s5, s2, s4
	not s2, s5
	and s4, s3, s2
	add s2, s1, s4
	li s1, 16
	mv a0, s2
	mv a1, s1
	jal ra, gh_round_up
	mv s3, a0
	sw s3, -24(s0)
	lw s1, -24(s0)
	li s2, 16
	divu s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 512
	sltu s3, s1, s2
	bnez s3, .L21_2
	j .L21_3
.L21_2:
	la s1, gh_bins
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L21_4
	j .L21_5
.L21_4:
	li s1, 0
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, gh_bins
	lw s3, -28(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, gh_live_bytes
	lw s2, 0(s1)
	lw s3, -12(s0)
	lw s4, 0(s3)
	add s3, s2, s4
	sw s3, 0(s1)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, gh_payload
	mv s2, a0
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
.L21_5:
	j .L21_6
.L21_3:
	li s1, 0
	sw s1, -16(s0)
	la s1, gh_large
	lw s2, 0(s1)
	sw s2, -12(s0)
.L21_7:
	lw s1, -12(s0)
	bnez s1, .L21_8
	j .L21_9
.L21_8:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -24(s0)
	sltu s3, s2, s1
	bnez s3, .L21_10
	j .L21_11
.L21_10:
	j .L21_12
.L21_11:
	li s1, 0
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -16(s0)
	bnez s1, .L21_13
	j .L21_14
.L21_13:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	j .L21_15
.L21_14:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, gh_large
	sw s1, 0(s2)
.L21_15:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -24(s0)
	sub s3, s2, s1
	li s1, 12
	li s2, 16
	add s4, s1, s2
	li s1, 1
	sub s2, s4, s1
	li s1, 16
	li s4, 1
	sub s5, s1, s4
	not s1, s5
	and s4, s2, s1
	li s1, 16
	add s2, s4, s1
	sltu s1, s3, s2
	xori s1, s1, 1
	bnez s1, .L21_16
	j .L21_17
.L21_16:
	lw s1, -12(s0)
	lw s2, -24(s0)
	add s3, s1, s2
	sw s3, -20(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -24(s0)
	sub s3, s2, s1
	lw s1, -20(s0)
	sw s3, 0(s1)
	lw s1, -24(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, gh_push_free
	mv s2, a0
	li s1, 0
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
.L21_17:
	li s1, 0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, gh_live_bytes
	lw s2, 0(s1)
	lw s3, -12(s0)
	lw s4, 0(s3)
	add s3, s2, s4
	sw s3, 0(s1)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, gh_payload
	mv s2, a0
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
.L21_12:
	lw s1, -12(s0)
	sw s1, -16(s0)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L21_7
.L21_9:
.L21_6:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, __libc_sbrk
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L21_18
	j .L21_19
.L21_18:
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
.L21_19:
	lw s1, -32(s0)
	sw s1, -12(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	li s1, 0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, gh_live_bytes
	lw s2, 0(s1)
	lw s3, -24(s0)
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, gh_payload
	mv s2, a0
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
.Lfunc_end21:
	.size gh_alloc, .Lfunc_end21-gh_alloc

	.text
	.align 2
	.type gh_free, @function
gh_free:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_0
	j .L22_1
.L22_0:
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
.L22_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gh_block_of
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L22_2
	j .L22_3
.L22_2:
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
.L22_3:
	la s1, gh_live_bytes
	lw s2, 0(s1)
	lw s3, -12(s0)
	lw s4, 0(s3)
	sub s3, s2, s4
	sw s3, 0(s1)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, gh_push_free
	mv s2, a0
	li s1, 0
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
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
	.size gh_free, .Lfunc_end22-gh_free

	.text
	.align 2
	.type gh_realloc, @function
gh_realloc:
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
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L23_0
	j .L23_1
.L23_0:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, gh_alloc
	mv s2, a0
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
.L23_1:
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L23_2
	j .L23_3
.L23_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gh_free
	mv s2, a0
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
.L23_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gh_block_of
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -8(s0)
	li s2, 12
	li s3, 16
	add s4, s2, s3
	li s2, 1
	sub s3, s4, s2
	li s2, 16
	li s4, 1
	sub s5, s2, s4
	not s2, s5
	and s4, s3, s2
	add s2, s1, s4
	li s1, 16
	mv a0, s2
	mv a1, s1
	jal ra, gh_round_up
	mv s3, a0
	sw s3, -16(s0)
	lw s1, -16(s0)
	lw s2, -12(s0)
	lw s3, 0(s2)
	sltu s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L23_4
	j .L23_5
.L23_4:
	lw s1, -4(s0)
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
.L23_5:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 12
	li s3, 16
	add s4, s1, s3
	li s1, 1
	sub s3, s4, s1
	li s1, 16
	li s4, 1
	sub s5, s1, s4
	not s1, s5
	and s4, s3, s1
	sub s1, s2, s4
	sw s1, -20(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, gh_alloc
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L23_6
	j .L23_7
.L23_6:
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
.L23_7:
	lw s1, -20(s0)
	lw s2, -8(s0)
	sltu s3, s1, s2
	bnez s3, .L23_8
	j .L23_9
.L23_8:
	lw s1, -20(s0)
	sw s1, -32(s0)
	j .L23_10
.L23_9:
	lw s1, -8(s0)
	sw s1, -32(s0)
.L23_10:
	lw s1, -32(s0)
	sw s1, -24(s0)
	lw s1, -28(s0)
	lw s2, -4(s0)
	lw s3, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gh_free
	mv s2, a0
	lw s1, -28(s0)
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
.Lfunc_end23:
	.size gh_realloc, .Lfunc_end23-gh_realloc

	.text
	.align 2
	.type gh_live, @function
gh_live:
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
	la s1, gh_live_bytes
	lw s2, 0(s1)
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
.Lfunc_end24:
	.size gh_live, .Lfunc_end24-gh_live

	.text
	.align 2
	.globl gheap_alloc
	.type gheap_alloc, @function
gheap_alloc:
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
	mv a0, s1
	jal ra, gh_alloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_0
	j .L25_1
.L25_0:
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L25_2
	j .L25_1
.L25_2:
	li s1, 0
	mv a0, s1
	jal ra, rt_trap
	mv s2, a0
.L25_1:
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
.Lfunc_end25:
	.size gheap_alloc, .Lfunc_end25-gheap_alloc

	.text
	.align 2
	.globl gheap_free
	.type gheap_free, @function
gheap_free:
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
	jal ra, gh_free
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
.Lfunc_end26:
	.size gheap_free, .Lfunc_end26-gheap_free

	.text
	.align 2
	.globl gheap_realloc
	.type gheap_realloc, @function
gheap_realloc:
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
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, gh_realloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L27_0
	j .L27_1
.L27_0:
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L27_2
	j .L27_1
.L27_2:
	li s1, 0
	mv a0, s1
	jal ra, rt_trap
	mv s2, a0
.L27_1:
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
.Lfunc_end27:
	.size gheap_realloc, .Lfunc_end27-gheap_realloc

	.text
	.align 2
	.globl kp_gheap_live
	.type kp_gheap_live, @function
kp_gheap_live:
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
	jal ra, gh_live
	mv s1, a0
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
.Lfunc_end28:
	.size kp_gheap_live, .Lfunc_end28-kp_gheap_live

	.text
	.align 2
	.globl malloc
	.type malloc, @function
malloc:
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
	jal ra, gh_alloc
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
.Lfunc_end29:
	.size malloc, .Lfunc_end29-malloc

	.text
	.align 2
	.globl free
	.type free, @function
free:
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
	bnez s1, .L30_0
	j .L30_1
.L30_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gh_free
	mv s2, a0
.L30_1:
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
.Lfunc_end30:
	.size free, .Lfunc_end30-free

	.text
	.align 2
	.globl realloc
	.type realloc, @function
realloc:
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
	bnez s1, .L31_0
	j .L31_1
.L31_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, gh_realloc
	mv s3, a0
	sw s3, -12(s0)
	j .L31_2
.L31_1:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, gh_alloc
	mv s2, a0
	sw s2, -12(s0)
.L31_2:
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
.Lfunc_end31:
	.size realloc, .Lfunc_end31-realloc

	.text
	.align 2
	.globl rt_register_final
	.type rt_register_final, @function
rt_register_final:
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
	li s2, 9
	sltu s3, s1, s2
	bnez s3, .L32_0
	j .L32_1
.L32_0:
	lw s1, -8(s0)
	la s2, g_final
	lw s3, -4(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L32_1:
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
.Lfunc_end32:
	.size rt_register_final, .Lfunc_end32-rt_register_final

	.text
	.align 2
	.globl kp_retain
	.type kp_retain, @function
kp_retain:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L33_0
	j .L33_1
.L33_0:
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
.L33_1:
	lw s1, -4(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 0
	sltu s3, s1, s2
	bnez s3, .L33_2
	j .L33_3
.L33_2:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 4294967295
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L33_4
	j .L33_3
.L33_4:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L33_3:
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
	.size kp_retain, .Lfunc_end33-kp_retain

	.text
	.align 2
	.globl kp_release
	.type kp_release, @function
kp_release:
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
	bnez s3, .L34_0
	j .L34_1
.L34_0:
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
.L34_1:
	lw s1, -4(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L34_2
	j .L34_3
.L34_3:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 4294967295
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L34_2
	j .L34_4
.L34_2:
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
.L34_4:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s3, -1
	add s4, s2, s3
	sw s4, 0(s1)
	li s1, 0
	sltu s2, s1, s4
	bnez s2, .L34_5
	j .L34_6
.L34_5:
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
.L34_6:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	sltu s3, s1, s2
	bnez s3, .L34_7
	j .L34_8
.L34_7:
	la s1, g_final
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	j .L34_9
.L34_8:
	li s1, 0
	sw s1, -20(s0)
.L34_9:
	lw s1, -20(s0)
	sw s1, -16(s0)
	lw s1, -16(s0)
	bnez s1, .L34_10
	j .L34_11
.L34_10:
	lw s1, -16(s0)
	lw s2, -4(s0)
	mv a0, s2
	mv t0, s1
	jalr ra, t0, 0
	mv s3, a0
.L34_11:
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
.Lfunc_end34:
	.size kp_release, .Lfunc_end34-kp_release

	.data
	.align 2
__str_6:
	.ascii "skj-kp: assertion failed\000"
	.align 2
__str_5:
	.ascii "skj-kp: aborted\000"
	.align 2
__str_4:
	.ascii "skj-kp: runtime fault: array index out of bounds\000"
	.align 2
__str_3:
	.ascii "skj-kp: runtime fault: integer overflow\000"
	.align 2
__str_2:
	.ascii "skj-kp: runtime fault: divide by zero\000"
	.align 2
__str_1:
	.ascii "skj-kp: runtime fault: index out of bounds\000"
	.align 2
__str_0:
	.ascii "\n\000"

	.section .rodata
	.align 2
	.globl kp_guest_abi_version
kp_guest_abi_version:
	.word 3
	.align 2
	.globl kp_guest_abi_v3
kp_guest_abi_v3:
	.word 3

	.bss
	.align 2
	.globl g_final
g_final:
	.space 36
	.align 2
	.globl gh_live_bytes
gh_live_bytes:
	.space 4
	.align 2
	.globl gh_large
gh_large:
	.space 4
	.align 2
	.globl gh_bins
gh_bins:
	.space 2048
