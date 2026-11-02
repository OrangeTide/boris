# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl cpp_error
	.type cpp_error, @function
cpp_error:
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
	addi s1, s0, -24
	addi t0, s0, 8
	sw t0, 8(s1)
	sw zero, 0(s1)
	sw zero, 4(s1)
	sw zero, 12(s1)
	li s1, 0
	la s1, __libc_stderr
	la s2, __str_0
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	la s1, __libc_stderr
	lw s2, -8(s0)
	addi s3, s0, -24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, vfprintf
	mv s4, a0
	li s1, 10
	la s2, __libc_stderr
	mv a0, s1
	mv a1, s2
	jal ra, fputc
	mv s3, a0
	li s1, 0
	lw s1, -4(s0)
	li s2, 17436
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
	.size cpp_error, .Lfunc_end1-cpp_error

	.text
	.align 2
	.type file_push, @function
file_push:
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
	li s1, 20
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -20(s0)
	sw s2, 0(s1)
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 1028
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
.Lfunc_end2:
	.size file_push, .Lfunc_end2-file_push

	.text
	.align 2
	.type file_pop, @function
file_pop:
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
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L3_0
	j .L3_1
.L3_1:
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
.L3_0:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 1028
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -12(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, free
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
.Lfunc_end3:
	.size file_pop, .Lfunc_end3-file_pop

	.text
	.align 2
	.type read_logical_line, @function
read_logical_line:
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
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_2
	j .L4_1
.L4_2:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_1
	j .L4_3
.L4_1:
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
.L4_3:
	li s1, 0
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
.L4_4:
	j .L4_5
.L4_5:
.L4_6:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L4_7
	j .L4_8
.L4_7:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L4_9
	j .L4_8
.L4_9:
	lw s1, -20(s0)
	lw s2, -12(s0)
	li s3, 2
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L4_10
	j .L4_8
.L4_10:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	lb s1, 0(s2)
	lw s2, -8(s0)
	addi s3, s0, -20
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -20(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L4_6
.L4_8:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_11
	j .L4_12
.L4_11:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L4_13
	j .L4_14
.L4_13:
	lw s1, -8(s0)
	lw s2, -20(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 92
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_15
	j .L4_14
.L4_15:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L4_16
.L4_14:
.L4_12:
	j .L4_17
.L4_16:
	j .L4_4
.L4_17:
	li s1, 0
	lw s2, -8(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -24(s0)
	lw s2, -4(s0)
	li s3, 1028
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L4_18
	j .L4_19
.L4_19:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	neg s3, s2
	add s2, s1, s3
	lb s1, 0(s2)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_18
	j .L4_20
.L4_18:
	li s1, 1
	sw s1, -28(s0)
	j .L4_21
.L4_20:
	li s1, 0
	sw s1, -28(s0)
.L4_21:
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
.Lfunc_end4:
	.size read_logical_line, .Lfunc_end4-read_logical_line

	.text
	.align 2
	.type skip_ws, @function
skip_ws:
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
.L5_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_1
	j .L5_2
.L5_2:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_1
	j .L5_3
.L5_1:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L5_0
.L5_3:
	lw s1, -4(s0)
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
	.size skip_ws, .Lfunc_end5-skip_ws

	.text
	.align 2
	.type resolve_include, @function
resolve_include:
	li t6, -4192
	add sp, sp, t6
	li t6, 4188
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 4184
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 4184
	add s0, sp, t6
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
	lw s1, -12(s0)
	bnez s1, .L6_0
	j .L6_1
.L6_1:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L6_2
	j .L6_0
.L6_2:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	bnez s2, .L6_3
	j .L6_0
.L6_3:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 47
	mv a0, s2
	mv a1, s1
	jal ra, strrchr
	mv s3, a0
	li t6, -4120
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4120
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L6_4
	j .L6_5
.L6_4:
	li t6, -4120
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -4(s0)
	li s3, 1028
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, 0(s2)
	sub s2, s1, s3
	li t6, -4124
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -4112
	add s1, s0, t6
	li s2, 4096
	la s3, __str_1
	li t6, -4124
	add t6, s0, t6
	lw s4, 0(t6)
	lw s5, -4(s0)
	li s6, 1028
	add s7, s5, s6
	lw s5, 0(s7)
	lw s6, 0(s5)
	lw s5, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s6, 4(sp)
	sw s5, 8(sp)
	jal ra, snprintf
	mv s7, a0
	addi sp, sp, 16
	li t6, -4116
	add t6, s0, t6
	sw s7, 0(t6)
	li t6, -4116
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L6_6
	j .L6_7
.L6_6:
	li t6, -4116
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4096
	slt s3, s1, s2
	bnez s3, .L6_8
	j .L6_7
.L6_8:
	li t6, -4112
	add s1, s0, t6
	la s2, __str_2
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	li t6, -4128
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4128
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L6_9
	j .L6_10
.L6_9:
	li t6, -4128
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	li t6, -4112
	add s1, s0, t6
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	mv a0, s2
	li t6, -4180
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4176
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4172
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4168
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4164
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4160
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4156
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L6_10:
.L6_7:
.L6_5:
.L6_0:
	li s1, 0
	li t6, -4132
	add t6, s0, t6
	sw s1, 0(t6)
.L6_11:
	li t6, -4132
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -4(s0)
	li s3, 1036
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L6_12
	j .L6_13
.L6_12:
	li t6, -4112
	add s1, s0, t6
	li s2, 4096
	la s3, __str_3
	lw s4, -4(s0)
	li s5, 1032
	add s6, s4, s5
	lw s4, 0(s6)
	li t6, -4132
	add t6, s0, t6
	lw s5, 0(t6)
	li s6, 4
	mul s7, s5, s6
	add s5, s4, s7
	lw s4, 0(s5)
	lw s5, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, snprintf
	mv s6, a0
	addi sp, sp, 16
	li t6, -4116
	add t6, s0, t6
	sw s6, 0(t6)
	li t6, -4116
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L6_14
	j .L6_15
.L6_15:
	li t6, -4116
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4096
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_14
	j .L6_16
.L6_14:
	j .L6_17
.L6_16:
	li t6, -4112
	add s1, s0, t6
	la s2, __str_4
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	li t6, -4136
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4136
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L6_18
	j .L6_19
.L6_18:
	li t6, -4136
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	li t6, -4112
	add s1, s0, t6
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	mv a0, s2
	li t6, -4180
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4176
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4172
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4168
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4164
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4160
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4156
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L6_19:
.L6_17:
	li t6, -4132
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -4132
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_11
.L6_13:
	li s1, 0
	mv a0, s1
	li t6, -4180
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4176
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4172
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4168
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4164
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4160
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4156
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end6:
	.size resolve_include, .Lfunc_end6-resolve_include

	.text
	.align 2
	.type handle_define, @function
handle_define:
	addi sp, sp, -144
	sw ra, 140(sp)
	sw s0, 136(sp)
	addi s0, sp, 136
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
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	sw s1, -16(s0)
.L7_0:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L7_1
	j .L7_2
.L7_1:
	lw s1, -12(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, isalnum
	mv s1, a0
	bnez s1, .L7_3
	j .L7_4
.L7_4:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_3
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
	lw s2, -16(s0)
	sub s3, s1, s2
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_5
	j .L7_6
.L7_5:
	la s1, __str_5
	mv a0, s1
	jal ra, warn
	mv s2, a0
	lw s1, -124(s0)
	lw s2, -120(s0)
	lw s3, -116(s0)
	lw s4, -112(s0)
	lw s5, -108(s0)
	lw s6, -104(s0)
	lw s7, -100(s0)
	lw s8, -96(s0)
	lw s9, -92(s0)
	lw s10, -88(s0)
	lw s11, -84(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_6:
	lw s1, -16(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, xstrndup
	mv s3, a0
	sw s3, -24(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -40(s0)
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_7
	j .L7_8
.L7_7:
	li s1, 1
	sw s1, -28(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	li s1, 8
	sw s1, -44(s0)
	lw s1, -44(s0)
	li s2, 4
	mul s3, s1, s2
	mv a0, s3
	jal ra, xmalloc
	mv s1, a0
	sw s1, -40(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
.L7_9:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L7_10
	j .L7_11
.L7_10:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L7_12
	j .L7_11
.L7_12:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_13
	j .L7_14
.L7_13:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_15
	j .L7_14
.L7_15:
	lw s1, -12(s0)
	li s2, 2
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_16
	j .L7_14
.L7_16:
	li s1, 1
	sw s1, -36(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 3
	add s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	j .L7_11
.L7_14:
	lw s1, -12(s0)
	sw s1, -48(s0)
.L7_17:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L7_18
	j .L7_19
.L7_18:
	lw s1, -12(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, isalnum
	mv s1, a0
	bnez s1, .L7_20
	j .L7_21
.L7_21:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_20
	j .L7_19
.L7_20:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L7_17
.L7_19:
	lw s1, -12(s0)
	lw s2, -48(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_22
	j .L7_23
.L7_22:
	j .L7_11
.L7_23:
	lw s1, -32(s0)
	lw s2, -44(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_24
	j .L7_25
.L7_24:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -44(s0)
	lw s1, -40(s0)
	lw s2, -44(s0)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, realloc
	mv s2, a0
	sw s2, -40(s0)
.L7_25:
	lw s1, -48(s0)
	lw s2, -12(s0)
	lw s3, -48(s0)
	sub s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, xstrndup
	mv s2, a0
	lw s1, -40(s0)
	addi s3, s0, -32
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -32(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_26
	j .L7_27
.L7_26:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	j .L7_28
.L7_27:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_29
	j .L7_30
.L7_29:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_31
	j .L7_30
.L7_31:
	lw s1, -12(s0)
	li s2, 2
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_32
	j .L7_30
.L7_32:
	li s1, 1
	sw s1, -36(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 3
	add s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	j .L7_11
.L7_30:
.L7_28:
	j .L7_9
.L7_11:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_33
	j .L7_34
.L7_33:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
.L7_34:
.L7_8:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -52(s0)
.L7_35:
	lw s1, -52(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L7_36
	j .L7_37
.L7_36:
	lw s1, -12(s0)
	lw s2, -52(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_38
	j .L7_39
.L7_39:
	lw s1, -12(s0)
	lw s2, -52(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_38
	j .L7_37
.L7_38:
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -52(s0)
	j .L7_35
.L7_37:
	li s1, 0
	sw s1, -56(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L7_40
	j .L7_41
.L7_40:
	lw s1, -12(s0)
	lw s2, -52(s0)
	mv a0, s1
	mv a1, s2
	jal ra, pp_tokenize
	mv s3, a0
	sw s3, -56(s0)
.L7_41:
	li s1, 0
	sw s1, -60(s0)
	lw s1, -56(s0)
	sw s1, -64(s0)
.L7_42:
	lw s1, -64(s0)
	bnez s1, .L7_43
	j .L7_44
.L7_43:
	lw s1, -64(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_45
	j .L7_46
.L7_45:
	lw s1, -64(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_47
	j .L7_46
.L7_47:
	lw s1, -64(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_48
	j .L7_46
.L7_48:
	lw s1, -64(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_49
	j .L7_46
.L7_49:
	lw s1, -60(s0)
	bnez s1, .L7_50
	j .L7_51
.L7_50:
	lw s1, -60(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_52
	j .L7_51
.L7_52:
	lw s1, -60(s0)
	sw s1, -68(s0)
	lw s1, -68(s0)
	lw s2, -56(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_53
	j .L7_54
.L7_53:
	lw s1, -64(s0)
	sw s1, -56(s0)
	j .L7_55
.L7_54:
	lw s1, -56(s0)
	sw s1, -72(s0)
.L7_56:
	lw s1, -72(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -68(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L7_57
	j .L7_58
.L7_57:
	lw s1, -72(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -72(s0)
	j .L7_56
.L7_58:
	lw s1, -64(s0)
	lw s2, -72(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -72(s0)
	sw s1, -60(s0)
.L7_55:
	lw s1, -68(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -68(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L7_51:
	lw s1, -64(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L7_59
	j .L7_60
.L7_59:
	lw s1, -64(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_61
	j .L7_60
.L7_61:
	lw s1, -64(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -76(s0)
	lw s1, -76(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -64(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -76(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -76(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L7_60:
.L7_46:
	lw s1, -64(s0)
	sw s1, -60(s0)
	lw s1, -64(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -64(s0)
	j .L7_42
.L7_44:
	lw s1, -4(s0)
	lw s2, -24(s0)
	lw s3, -56(s0)
	lw s4, -28(s0)
	lw s5, -32(s0)
	lw s6, -40(s0)
	lw s7, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	jal ra, macro_define
	mv s8, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -124(s0)
	lw s2, -120(s0)
	lw s3, -116(s0)
	lw s4, -112(s0)
	lw s5, -108(s0)
	lw s6, -104(s0)
	lw s7, -100(s0)
	lw s8, -96(s0)
	lw s9, -92(s0)
	lw s10, -88(s0)
	lw s11, -84(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end7:
	.size handle_define, .Lfunc_end7-handle_define

	.text
	.align 2
	.type handle_include, @function
handle_include:
	li t6, -8320
	add sp, sp, t6
	li t6, 8316
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 8312
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 8312
	add s0, sp, t6
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
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	li s1, 0
	sw s1, -16(s0)
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 60
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_0:
	li s1, 1
	sw s1, -16(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	li s1, 0
	li t6, -4116
	add t6, s0, t6
	sw s1, 0(t6)
.L8_2:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L8_3
	j .L8_4
.L8_3:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 62
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L8_5
	j .L8_4
.L8_5:
	li t6, -4116
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4096
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L8_6
	j .L8_4
.L8_6:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lb s1, 0(s2)
	li t6, -4112
	add s2, s0, t6
	li t6, -4116
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4116
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L8_2
.L8_4:
	li s1, 0
	li t6, -4112
	add s2, s0, t6
	li t6, -4116
	add t6, s0, t6
	lw s3, 0(t6)
	add s4, s2, s3
	sb s1, 0(s4)
	j .L8_7
.L8_1:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L8_8
	j .L8_9
.L8_8:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	li s1, 0
	li t6, -4120
	add t6, s0, t6
	sw s1, 0(t6)
.L8_10:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L8_11
	j .L8_12
.L8_11:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L8_13
	j .L8_12
.L8_13:
	li t6, -4120
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4096
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L8_14
	j .L8_12
.L8_14:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lb s1, 0(s2)
	li t6, -4112
	add s2, s0, t6
	li t6, -4120
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -4120
	add t6, s0, t6
	sw s5, 0(t6)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L8_10
.L8_12:
	li s1, 0
	li t6, -4112
	add s2, s0, t6
	li t6, -4120
	add t6, s0, t6
	lw s3, 0(t6)
	add s4, s2, s3
	sb s1, 0(s4)
	j .L8_15
.L8_9:
	lw s1, -12(s0)
	lw s2, -12(s0)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, pp_tokenize
	mv s2, a0
	li t6, -4124
	add t6, s0, t6
	sw s2, 0(t6)
	lw s1, -4(s0)
	li t6, -4124
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, macro_expand
	mv s3, a0
	li t6, -4128
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4128
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8224
	add s2, s0, t6
	li s3, 4096
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, pp_detokenize
	mv s4, a0
	li t6, -4128
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	li t6, -8224
	add s1, s0, t6
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	li t6, -8228
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -8228
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 60
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L8_16
	j .L8_17
.L8_17:
	li t6, -8228
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L8_16
	j .L8_18
.L8_16:
	lw s1, -4(s0)
	li t6, -8224
	add s2, s0, t6
	mv a0, s1
	mv a1, s2
	jal ra, handle_include
	mv s3, a0
	j .L8_19
.L8_18:
	lw s1, -4(s0)
	la s2, __str_6
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	bnez s3, .L8_20
	j .L8_21
.L8_20:
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, 0(s3)
	li t6, -8232
	add t6, s0, t6
	sw s4, 0(t6)
	j .L8_22
.L8_21:
	la s3, __str_7
	li t6, -8232
	add t6, s0, t6
	sw s3, 0(t6)
.L8_22:
	li t6, -8232
	add t6, s0, t6
	lw s3, 0(t6)
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	bnez s4, .L8_23
	j .L8_24
.L8_23:
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	li t6, -8236
	add t6, s0, t6
	sw s4, 0(t6)
	j .L8_25
.L8_24:
	li s4, 0
	li t6, -8236
	add t6, s0, t6
	sw s4, 0(t6)
.L8_25:
	li t6, -8236
	add t6, s0, t6
	lw s4, 0(t6)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, cpp_error
	mv s5, a0
	addi sp, sp, 16
.L8_19:
	li t6, -8308
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8304
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8300
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8296
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8292
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8288
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8284
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8280
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8276
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8272
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8268
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_15:
.L8_7:
	lw s1, -4(s0)
	li t6, -4112
	add s2, s0, t6
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, resolve_include
	mv s4, a0
	li t6, -8240
	add t6, s0, t6
	sw s4, 0(t6)
	li t6, -8240
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L8_26
	j .L8_27
.L8_27:
	lw s1, -4(s0)
	la s2, __str_8
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	bnez s3, .L8_28
	j .L8_29
.L8_28:
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, 0(s3)
	li t6, -8244
	add t6, s0, t6
	sw s4, 0(t6)
	j .L8_30
.L8_29:
	la s3, __str_9
	li t6, -8244
	add t6, s0, t6
	sw s3, 0(t6)
.L8_30:
	li t6, -8244
	add t6, s0, t6
	lw s3, 0(t6)
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	bnez s4, .L8_31
	j .L8_32
.L8_31:
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	li t6, -8248
	add t6, s0, t6
	sw s4, 0(t6)
	j .L8_33
.L8_32:
	li s4, 0
	li t6, -8248
	add t6, s0, t6
	sw s4, 0(t6)
.L8_33:
	li t6, -8248
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4112
	add s5, s0, t6
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s5, 8(sp)
	jal ra, cpp_error
	mv s6, a0
	addi sp, sp, 16
	li t6, -8308
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8304
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8300
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8296
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8292
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8288
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8284
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8280
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8276
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8272
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8268
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_26:
	li t6, -8240
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, slurp
	mv s2, a0
	li t6, -8252
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -8252
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L8_34
	j .L8_35
.L8_35:
	lw s1, -4(s0)
	la s2, __str_10
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	bnez s3, .L8_36
	j .L8_37
.L8_36:
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, 0(s3)
	li t6, -8256
	add t6, s0, t6
	sw s4, 0(t6)
	j .L8_38
.L8_37:
	la s3, __str_11
	li t6, -8256
	add t6, s0, t6
	sw s3, 0(t6)
.L8_38:
	li t6, -8256
	add t6, s0, t6
	lw s3, 0(t6)
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	bnez s4, .L8_39
	j .L8_40
.L8_39:
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	li t6, -8260
	add t6, s0, t6
	sw s4, 0(t6)
	j .L8_41
.L8_40:
	li s4, 0
	li t6, -8260
	add t6, s0, t6
	sw s4, 0(t6)
.L8_41:
	li t6, -8260
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8240
	add t6, s0, t6
	lw s5, 0(t6)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s5, 8(sp)
	jal ra, cpp_error
	mv s6, a0
	addi sp, sp, 16
	li t6, -8240
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li t6, -8308
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8304
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8300
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8296
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8292
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8288
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8284
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8280
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8276
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8272
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8268
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L8_34:
	lw s1, -4(s0)
	li t6, -8240
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8252
	add t6, s0, t6
	lw s3, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, file_push
	mv s4, a0
	li t6, -8240
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 0
	mv a0, s1
	li t6, -8308
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8304
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8300
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8296
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8292
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8288
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8284
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8280
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8276
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8272
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8268
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end8:
	.size handle_include, .Lfunc_end8-handle_include

	.text
	.align 2
	.type handle_ifdef, @function
handle_ifdef:
	addi sp, sp, -96
	sw ra, 92(sp)
	sw s0, 88(sp)
	addi s0, sp, 88
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
	lw s1, -8(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	sw s1, -24(s0)
.L9_0:
	lw s1, -20(s0)
	lb s2, 0(s1)
	bnez s2, .L9_1
	j .L9_2
.L9_1:
	lw s1, -20(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, isalnum
	mv s1, a0
	bnez s1, .L9_3
	j .L9_4
.L9_4:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_3
	j .L9_2
.L9_3:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L9_0
.L9_2:
	lw s1, -20(s0)
	lw s2, -24(s0)
	sub s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_5
	j .L9_6
.L9_5:
	la s1, __str_12
	mv a0, s1
	jal ra, warn
	mv s2, a0
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, cond_push
	mv s3, a0
	lw s1, -84(s0)
	lw s2, -80(s0)
	lw s3, -76(s0)
	lw s4, -72(s0)
	lw s5, -68(s0)
	lw s6, -64(s0)
	lw s7, -60(s0)
	lw s8, -56(s0)
	lw s9, -52(s0)
	lw s10, -48(s0)
	lw s11, -44(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L9_6:
	lw s1, -24(s0)
	lw s2, -28(s0)
	mv a0, s1
	mv a1, s2
	jal ra, xstrndup
	mv s3, a0
	sw s3, -32(s0)
	lw s1, -4(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, macro_lookup
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	sw s2, -36(s0)
	lw s1, -32(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -12(s0)
	bnez s2, .L9_7
	j .L9_8
.L9_7:
	lw s2, -36(s0)
	sw s2, -40(s0)
	j .L9_9
.L9_8:
	lw s2, -36(s0)
	li s3, 0
	xor s4, s2, s3
	seqz s4, s4
	sw s4, -40(s0)
.L9_9:
	lw s2, -40(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cond_push
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -84(s0)
	lw s2, -80(s0)
	lw s3, -76(s0)
	lw s4, -72(s0)
	lw s5, -68(s0)
	lw s6, -64(s0)
	lw s7, -60(s0)
	lw s8, -56(s0)
	lw s9, -52(s0)
	lw s10, -48(s0)
	lw s11, -44(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end9:
	.size handle_ifdef, .Lfunc_end9-handle_ifdef

	.text
	.align 2
	.type handle_if, @function
handle_if:
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
	lw s2, -8(s0)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, pp_tokenize
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cond_eval
	mv s10, a0
	mv s11, a1
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s1, -4(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s2, 0
	mv s8, s2
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s2, t0
	mv a0, s1
	mv a1, s2
	jal ra, cond_push
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
.Lfunc_end10:
	.size handle_if, .Lfunc_end10-handle_if

	.text
	.align 2
	.type handle_elif, @function
handle_elif:
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
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L11_0
	j .L11_1
.L11_1:
	lw s1, -4(s0)
	la s2, __str_13
	mv a0, s1
	mv a1, s2
	jal ra, cpp_error
	mv s3, a0
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
.L11_0:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L11_2
	j .L11_3
.L11_2:
	lw s1, -4(s0)
	la s2, __str_14
	mv a0, s1
	mv a1, s2
	jal ra, cpp_error
	mv s3, a0
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
.L11_3:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L11_4
	j .L11_5
.L11_4:
	li s1, 0
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L11_6
.L11_5:
	lw s1, -8(s0)
	lw s2, -8(s0)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, pp_tokenize
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L11_7
	j .L11_8
.L11_7:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	sw s2, -20(s0)
	j .L11_9
.L11_8:
	li s1, 1
	sw s1, -20(s0)
.L11_9:
	lw s1, -20(s0)
	sw s1, -16(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cond_eval
	mv s10, a0
	mv s11, a1
	sw s10, -32(s0)
	sw s11, -28(s0)
	lw s10, -32(s0)
	lw s11, -28(s0)
	bnez s10, .L11_10
	j .L11_11
.L11_10:
	lw s1, -16(s0)
	bnez s1, .L11_12
	j .L11_11
.L11_12:
	li s1, 1
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	li s1, 1
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	j .L11_13
.L11_11:
	li s1, 0
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
.L11_13:
.L11_6:
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
.Lfunc_end11:
	.size handle_elif, .Lfunc_end11-handle_elif

	.text
	.align 2
	.type handle_else, @function
handle_else:
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
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_0
	j .L12_1
.L12_1:
	lw s1, -4(s0)
	la s2, __str_15
	mv a0, s1
	mv a1, s2
	jal ra, cpp_error
	mv s3, a0
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
.L12_0:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_2
	j .L12_3
.L12_2:
	lw s1, -4(s0)
	la s2, __str_16
	mv a0, s1
	mv a1, s2
	jal ra, cpp_error
	mv s3, a0
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
.L12_3:
	li s1, 1
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_4
	j .L12_5
.L12_4:
	li s1, 0
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	j .L12_6
.L12_5:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_7
	j .L12_8
.L12_7:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	sw s2, -16(s0)
	j .L12_9
.L12_8:
	li s1, 1
	sw s1, -16(s0)
.L12_9:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	lw s2, 0(s4)
	sw s1, 0(s2)
	li s1, 1
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
.L12_6:
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
	.size handle_else, .Lfunc_end12-handle_else

	.text
	.align 2
	.type handle_error, @function
handle_error:
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
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	la s2, __str_17
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	bnez s3, .L13_0
	j .L13_1
.L13_0:
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, 0(s3)
	sw s4, -16(s0)
	j .L13_2
.L13_1:
	la s3, __str_18
	sw s3, -16(s0)
.L13_2:
	lw s3, -16(s0)
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	bnez s4, .L13_3
	j .L13_4
.L13_3:
	lw s4, -4(s0)
	li s5, 1028
	add s6, s4, s5
	lw s4, 0(s6)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	sw s4, -20(s0)
	j .L13_5
.L13_4:
	li s4, 0
	sw s4, -20(s0)
.L13_5:
	lw s4, -20(s0)
	lw s5, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s5, 8(sp)
	jal ra, cpp_error
	mv s6, a0
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
.Lfunc_end13:
	.size handle_error, .Lfunc_end13-handle_error

	.text
	.align 2
	.type handle_line_directive, @function
handle_line_directive:
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
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	addi s2, s0, -16
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtol
	mv s4, a0
	sw s4, -20(s0)
	lw s1, -16(s0)
	lw s2, -12(s0)
	slt s3, s2, s1
	bnez s3, .L14_0
	j .L14_1
.L14_0:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_2
	j .L14_1
.L14_2:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 1028
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_3
	j .L14_4
.L14_3:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	sw s1, -24(s0)
.L14_5:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L14_6
	j .L14_7
.L14_6:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L14_8
	j .L14_7
.L14_8:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L14_5
.L14_7:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	lw s1, -24(s0)
	lw s2, -12(s0)
	lw s3, -24(s0)
	sub s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, xstrndup
	mv s2, a0
	lw s1, -4(s0)
	li s3, 1028
	add s4, s1, s3
	lw s1, 0(s4)
	sw s2, 0(s1)
.L14_4:
.L14_1:
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
.Lfunc_end14:
	.size handle_line_directive, .Lfunc_end14-handle_line_directive

	.text
	.align 2
	.type process_directive, @function
process_directive:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	lw s1, -8(s0)
	sw s1, -20(s0)
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L15_0
	j .L15_1
.L15_1:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L15_0
	j .L15_2
.L15_0:
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_2:
	lw s1, -20(s0)
	sw s1, -24(s0)
.L15_3:
	lw s1, -20(s0)
	lb s2, 0(s1)
	bnez s2, .L15_4
	j .L15_5
.L15_4:
	lw s1, -20(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, isalpha
	mv s1, a0
	bnez s1, .L15_6
	j .L15_5
.L15_6:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L15_3
.L15_5:
	lw s1, -20(s0)
	lw s2, -24(s0)
	sub s3, s1, s2
	sw s3, -28(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -28(s0)
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_7
	j .L15_8
.L15_7:
	lw s1, -24(s0)
	la s2, __str_19
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_9
	j .L15_8
.L15_9:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_pop
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_8:
	lw s1, -28(s0)
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_10
	j .L15_11
.L15_10:
	lw s1, -24(s0)
	la s2, __str_20
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_12
	j .L15_11
.L15_12:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_active
	mv s2, a0
	bnez s2, .L15_13
	j .L15_14
.L15_14:
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, cond_push
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_13:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, handle_ifdef
	mv s4, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_11:
	lw s1, -28(s0)
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_15
	j .L15_16
.L15_15:
	lw s1, -24(s0)
	la s2, __str_21
	li s3, 6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_17
	j .L15_16
.L15_17:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_active
	mv s2, a0
	bnez s2, .L15_18
	j .L15_19
.L15_19:
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, cond_push
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_18:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, handle_ifdef
	mv s4, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_16:
	lw s1, -28(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_20
	j .L15_21
.L15_20:
	lw s1, -24(s0)
	la s2, __str_22
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_22
	j .L15_21
.L15_22:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_active
	mv s2, a0
	bnez s2, .L15_23
	j .L15_24
.L15_24:
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, cond_push
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_23:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, handle_if
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_21:
	lw s1, -28(s0)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_25
	j .L15_26
.L15_25:
	lw s1, -24(s0)
	la s2, __str_23
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_27
	j .L15_26
.L15_27:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, handle_elif
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_26:
	lw s1, -28(s0)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_28
	j .L15_29
.L15_28:
	lw s1, -24(s0)
	la s2, __str_24
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_30
	j .L15_29
.L15_30:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, handle_else
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_29:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_active
	mv s2, a0
	bnez s2, .L15_31
	j .L15_32
.L15_32:
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_31:
	lw s1, -28(s0)
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_33
	j .L15_34
.L15_33:
	lw s1, -24(s0)
	la s2, __str_25
	li s3, 6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_35
	j .L15_34
.L15_35:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, handle_define
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_34:
	lw s1, -28(s0)
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_36
	j .L15_37
.L15_36:
	lw s1, -24(s0)
	la s2, __str_26
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_38
	j .L15_37
.L15_38:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	sw s1, -36(s0)
.L15_39:
	lw s1, -36(s0)
	lb s2, 0(s1)
	bnez s2, .L15_40
	j .L15_41
.L15_40:
	lw s1, -36(s0)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, isalnum
	mv s1, a0
	bnez s1, .L15_42
	j .L15_43
.L15_43:
	lw s1, -36(s0)
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L15_42
	j .L15_41
.L15_42:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L15_39
.L15_41:
	lw s1, -36(s0)
	lw s2, -32(s0)
	slt s3, s2, s1
	bnez s3, .L15_44
	j .L15_45
.L15_44:
	lw s1, -32(s0)
	lw s2, -36(s0)
	lw s3, -32(s0)
	sub s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, xstrndup
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -4(s0)
	lw s2, -40(s0)
	mv a0, s1
	mv a1, s2
	jal ra, macro_undef
	mv s3, a0
	lw s1, -40(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L15_45:
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_37:
	lw s1, -28(s0)
	li s2, 7
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_46
	j .L15_47
.L15_46:
	lw s1, -24(s0)
	la s2, __str_27
	li s3, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_48
	j .L15_47
.L15_48:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, handle_include
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_47:
	lw s1, -28(s0)
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_49
	j .L15_50
.L15_49:
	lw s1, -24(s0)
	la s2, __str_28
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_51
	j .L15_50
.L15_51:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, handle_error
	mv s3, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_50:
	lw s1, -28(s0)
	li s2, 7
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_52
	j .L15_53
.L15_52:
	lw s1, -24(s0)
	la s2, __str_29
	li s3, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_54
	j .L15_53
.L15_54:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, skip_ws
	mv s2, a0
	sw s2, -44(s0)
	la s1, __str_30
	lw s2, -4(s0)
	li s3, 1028
	add s4, s2, s3
	lw s2, 0(s4)
	bnez s2, .L15_55
	j .L15_56
.L15_55:
	lw s2, -4(s0)
	li s3, 1028
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, 0(s2)
	sw s3, -48(s0)
	j .L15_57
.L15_56:
	la s2, __str_31
	sw s2, -48(s0)
.L15_57:
	lw s2, -48(s0)
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	bnez s3, .L15_58
	j .L15_59
.L15_58:
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	sw s3, -52(s0)
	j .L15_60
.L15_59:
	li s3, 0
	sw s3, -52(s0)
.L15_60:
	lw s3, -52(s0)
	lw s4, -44(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	sw s4, 8(sp)
	jal ra, warn
	mv s5, a0
	addi sp, sp, 16
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_53:
	lw s1, -28(s0)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_61
	j .L15_62
.L15_61:
	lw s1, -24(s0)
	la s2, __str_32
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_63
	j .L15_62
.L15_63:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, handle_line_directive
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_62:
	lw s1, -28(s0)
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_64
	j .L15_65
.L15_64:
	lw s1, -24(s0)
	la s2, __str_33
	li s3, 6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_66
	j .L15_65
.L15_66:
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_65:
	la s1, __str_34
	lw s2, -4(s0)
	li s3, 1028
	add s4, s2, s3
	lw s2, 0(s4)
	bnez s2, .L15_67
	j .L15_68
.L15_67:
	lw s2, -4(s0)
	li s3, 1028
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, 0(s2)
	sw s3, -56(s0)
	j .L15_69
.L15_68:
	la s2, __str_35
	sw s2, -56(s0)
.L15_69:
	lw s2, -56(s0)
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	bnez s3, .L15_70
	j .L15_71
.L15_70:
	lw s3, -4(s0)
	li s4, 1028
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	sw s3, -60(s0)
	j .L15_72
.L15_71:
	li s3, 0
	sw s3, -60(s0)
.L15_72:
	lw s3, -60(s0)
	lw s4, -28(s0)
	lw s5, -24(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	sw s4, 8(sp)
	sw s5, 12(sp)
	jal ra, warn
	mv s6, a0
	addi sp, sp, 16
	li s1, 0
	mv a0, s1
	lw s1, -108(s0)
	lw s2, -104(s0)
	lw s3, -100(s0)
	lw s4, -96(s0)
	lw s5, -92(s0)
	lw s6, -88(s0)
	lw s7, -84(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end15:
	.size process_directive, .Lfunc_end15-process_directive

	.text
	.align 2
	.type strip_block_comments, @function
strip_block_comments:
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
	lw s1, -8(s0)
	sw s1, -12(s0)
	lw s1, -8(s0)
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 17440
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L16_0
	j .L16_1
.L16_0:
	lw s1, -12(s0)
	la s2, __str_36
	mv a0, s1
	mv a1, s2
	jal ra, strstr
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L16_2
	j .L16_3
.L16_3:
	li s1, 0
	lw s2, -8(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
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
.L16_2:
	lw s1, -20(s0)
	li s2, 2
	add s3, s1, s2
	sw s3, -12(s0)
	li s1, 0
	lw s2, -4(s0)
	li s3, 17440
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 32
	addi s2, s0, -16
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -16(s0)
	sb s1, 0(s3)
.L16_1:
.L16_4:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L16_5
	j .L16_6
.L16_5:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L16_7
	j .L16_8
.L16_8:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L16_7
	j .L16_9
.L16_7:
	lw s1, -12(s0)
	lb s2, 0(s1)
	sw s2, -24(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lb s1, 0(s2)
	addi s2, s0, -16
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -16(s0)
	sb s1, 0(s3)
.L16_10:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L16_11
	j .L16_12
.L16_11:
	lw s1, -12(s0)
	lb s2, 0(s1)
	addi s1, s0, -24
	lb s3, 0(s1)
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L16_13
	j .L16_12
.L16_13:
	lw s1, -12(s0)
	lb s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L16_14
	j .L16_15
.L16_14:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L16_16
	j .L16_15
.L16_16:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lb s1, 0(s2)
	addi s2, s0, -16
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -16(s0)
	sb s1, 0(s3)
.L16_15:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lb s1, 0(s2)
	addi s2, s0, -16
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -16(s0)
	sb s1, 0(s3)
	j .L16_10
.L16_12:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L16_17
	j .L16_18
.L16_17:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lb s1, 0(s2)
	addi s2, s0, -16
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -16(s0)
	sb s1, 0(s3)
.L16_18:
	j .L16_4
.L16_9:
	lw s1, -12(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_19
	j .L16_20
.L16_19:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_21
	j .L16_20
.L16_21:
	j .L16_6
.L16_20:
	lw s1, -12(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_22
	j .L16_23
.L16_22:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_24
	j .L16_23
.L16_24:
	lw s1, -12(s0)
	li s2, 2
	add s3, s1, s2
	la s1, __str_37
	mv a0, s3
	mv a1, s1
	jal ra, strstr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	bnez s1, .L16_25
	j .L16_26
.L16_25:
	li s1, 32
	addi s2, s0, -16
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -16(s0)
	sb s1, 0(s3)
	lw s1, -28(s0)
	li s2, 2
	add s3, s1, s2
	sw s3, -12(s0)
	j .L16_4
.L16_26:
	li s1, 1
	lw s2, -4(s0)
	li s3, 17440
	add s4, s2, s3
	sw s1, 0(s4)
	j .L16_6
.L16_23:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lb s1, 0(s2)
	addi s2, s0, -16
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -16(s0)
	sb s1, 0(s3)
	j .L16_4
.L16_6:
	li s1, 0
	lw s2, -16(s0)
	sb s1, 0(s2)
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
.Lfunc_end16:
	.size strip_block_comments, .Lfunc_end16-strip_block_comments

	.text
	.align 2
	.type hash_name, @function
hash_name:
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
	li s1, 0
	sw s1, -12(s0)
.L17_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L17_1
	j .L17_2
.L17_1:
	lw s1, -12(s0)
	li s2, 31
	mul s3, s1, s2
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -4(s0)
	lb s1, 0(s2)
	li s2, 255
	and s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	j .L17_0
.L17_2:
	lw s1, -12(s0)
	li s2, 256
	remu s3, s1, s2
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
.Lfunc_end17:
	.size hash_name, .Lfunc_end17-hash_name

	.text
	.align 2
	.type define_builtin, @function
define_builtin:
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
	lw s1, -8(s0)
	mv a0, s1
	jal ra, hash_name
	mv s2, a0
	sw s2, -20(s0)
	li s1, 36
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -24(s0)
	sw s2, 0(s1)
	li s1, 0
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -24(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -24(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	lw s2, -4(s0)
	lw s3, -20(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
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
.Lfunc_end18:
	.size define_builtin, .Lfunc_end18-define_builtin

	.text
	.align 2
	.globl cpp_new
	.type cpp_new, @function
cpp_new:
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
	li s1, 1
	li s2, 17456
	mv a0, s1
	mv a1, s2
	jal ra, xcalloc
	mv s3, a0
	sw s3, -4(s0)
	li s1, 0
	mv a0, s1
	jal ra, time
	mv s2, a0
	sw s2, -8(s0)
	addi s1, s0, -8
	mv a0, s1
	jal ra, localtime
	mv s2, a0
	sw s2, -12(s0)
	addi s1, s0, -48
	li s2, 32
	la s3, __str_38
	lw s4, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, strftime
	mv s5, a0
	addi s1, s0, -48
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -4(s0)
	li s3, 1044
	add s4, s1, s3
	sw s2, 0(s4)
	addi s1, s0, -48
	li s2, 32
	la s3, __str_39
	lw s4, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, strftime
	mv s5, a0
	addi s1, s0, -48
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -4(s0)
	li s3, 1048
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	la s2, __str_40
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, define_builtin
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_41
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, define_builtin
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_42
	li s3, 3
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, define_builtin
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_43
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, define_builtin
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_44
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, define_builtin
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_45
	li s3, 6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, define_builtin
	mv s4, a0
	lw s1, -4(s0)
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
.Lfunc_end19:
	.size cpp_new, .Lfunc_end19-cpp_new

	.text
	.align 2
	.globl cpp_free
	.type cpp_free, @function
cpp_free:
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
	bnez s1, .L20_0
	j .L20_1
.L20_1:
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
.L20_0:
.L20_2:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L20_3
	j .L20_4
.L20_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, file_pop
	mv s2, a0
	j .L20_2
.L20_4:
.L20_5:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L20_6
	j .L20_7
.L20_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_pop
	mv s2, a0
	j .L20_5
.L20_7:
	li s1, 0
	sw s1, -12(s0)
.L20_8:
	lw s1, -12(s0)
	li s2, 256
	slt s3, s1, s2
	bnez s3, .L20_9
	j .L20_10
.L20_9:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -16(s0)
.L20_11:
	lw s1, -16(s0)
	bnez s1, .L20_12
	j .L20_13
.L20_12:
	lw s1, -16(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -16(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	lw s1, -16(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	li s1, 0
	sw s1, -24(s0)
.L20_14:
	lw s1, -24(s0)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L20_15
	j .L20_16
.L20_15:
	lw s1, -16(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L20_17:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L20_14
.L20_16:
	lw s1, -16(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -16(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -20(s0)
	sw s1, -16(s0)
	j .L20_11
.L20_13:
.L20_18:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L20_8
.L20_10:
	li s1, 0
	sw s1, -28(s0)
.L20_19:
	lw s1, -28(s0)
	lw s2, -4(s0)
	li s3, 1036
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L20_20
	j .L20_21
.L20_20:
	lw s1, -4(s0)
	li s2, 1032
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L20_22:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L20_19
.L20_21:
	lw s1, -4(s0)
	li s2, 1032
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 1044
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	li s2, 1048
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, free
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
.Lfunc_end20:
	.size cpp_free, .Lfunc_end20-cpp_free

	.text
	.align 2
	.globl cpp_add_include_path
	.type cpp_add_include_path, @function
cpp_add_include_path:
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
	li s2, 1036
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 1040
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L21_0
	j .L21_1
.L21_0:
	lw s1, -4(s0)
	li s2, 1040
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L21_2
	j .L21_3
.L21_2:
	lw s1, -4(s0)
	li s2, 1040
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -12(s0)
	j .L21_4
.L21_3:
	li s1, 8
	sw s1, -12(s0)
.L21_4:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 1040
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 1032
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 1040
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, realloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 1032
	add s4, s1, s3
	sw s2, 0(s4)
.L21_1:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, xstrdup
	mv s2, a0
	lw s1, -4(s0)
	li s3, 1032
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -4(s0)
	li s4, 1036
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s6, s3, s4
	sw s6, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
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
	.size cpp_add_include_path, .Lfunc_end21-cpp_add_include_path

	.text
	.align 2
	.globl cpp_define
	.type cpp_define, @function
cpp_define:
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
	lw s1, -12(s0)
	bnez s1, .L22_0
	j .L22_1
.L22_0:
	lw s1, -12(s0)
	lb s2, 0(s1)
	bnez s2, .L22_2
	j .L22_1
.L22_2:
	lw s1, -12(s0)
	lw s2, -12(s0)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, pp_tokenize
	mv s2, a0
	sw s2, -20(s0)
.L22_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -20(s0)
	li s4, 0
	li s5, 0
	li s6, 0
	li s7, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	mv a6, s7
	jal ra, macro_define
	mv s8, a0
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
.Lfunc_end22:
	.size cpp_define, .Lfunc_end22-cpp_define

	.text
	.align 2
	.globl cpp_undef
	.type cpp_undef, @function
cpp_undef:
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
	jal ra, macro_undef
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
.Lfunc_end23:
	.size cpp_undef, .Lfunc_end23-cpp_undef

	.text
	.align 2
	.globl cpp_open
	.type cpp_open, @function
cpp_open:
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
	mv a0, s1
	jal ra, slurp
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L24_0
	j .L24_1
.L24_1:
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
.L24_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, file_push
	mv s4, a0
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
	.size cpp_open, .Lfunc_end24-cpp_open

	.text
	.align 2
	.globl cpp_get_line_number
	.type cpp_get_line_number, @function
cpp_get_line_number:
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
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L25_0
	j .L25_1
.L25_0:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L25_2
.L25_1:
	li s1, 0
	sw s1, -12(s0)
.L25_2:
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
	.size cpp_get_line_number, .Lfunc_end25-cpp_get_line_number

	.text
	.align 2
	.globl cpp_get_filename
	.type cpp_get_filename, @function
cpp_get_filename:
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
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L26_0
	j .L26_1
.L26_0:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	sw s2, -12(s0)
	j .L26_2
.L26_1:
	li s1, 0
	sw s1, -12(s0)
.L26_2:
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
.Lfunc_end26:
	.size cpp_get_filename, .Lfunc_end26-cpp_get_filename

	.text
	.align 2
	.globl cpp_get_emit_line
	.type cpp_get_emit_line, @function
cpp_get_emit_line:
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
	li s2, 17448
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
.Lfunc_end27:
	.size cpp_get_emit_line, .Lfunc_end27-cpp_get_emit_line

	.text
	.align 2
	.globl cpp_get_emit_file
	.type cpp_get_emit_file, @function
cpp_get_emit_file:
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
	li s2, 17452
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
.Lfunc_end28:
	.size cpp_get_emit_file, .Lfunc_end28-cpp_get_emit_file

	.text
	.align 2
	.globl cpp_next_line
	.type cpp_next_line, @function
cpp_next_line:
	addi sp, sp, -112
	sw ra, 108(sp)
	sw s0, 104(sp)
	addi s0, sp, 104
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
.L29_0:
	j .L29_1
.L29_1:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L29_2
	j .L29_3
.L29_3:
	li s1, 0
	mv a0, s1
	lw s1, -100(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	lw s4, -88(s0)
	lw s5, -84(s0)
	lw s6, -80(s0)
	lw s7, -76(s0)
	lw s8, -72(s0)
	lw s9, -68(s0)
	lw s10, -64(s0)
	lw s11, -60(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L29_2:
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 1028
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	sw s2, -24(s0)
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 1052
	add s4, s2, s3
	li s2, 8192
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, read_logical_line
	mv s3, a0
	bnez s3, .L29_4
	j .L29_5
.L29_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, file_pop
	mv s2, a0
	j .L29_6
.L29_4:
	lw s1, -4(s0)
	lw s2, -4(s0)
	li s3, 1052
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, strip_block_comments
	mv s2, a0
	lw s1, -4(s0)
	li s2, 1052
	add s3, s1, s2
	mv a0, s3
	jal ra, skip_ws
	mv s1, a0
	sw s1, -28(s0)
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L29_7
	j .L29_8
.L29_7:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -28(s0)
	mv a0, s3
	jal ra, strlen
	mv s4, a0
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, process_directive
	mv s3, a0
	sw s3, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L29_9
	j .L29_10
.L29_9:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -100(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	lw s4, -88(s0)
	lw s5, -84(s0)
	lw s6, -80(s0)
	lw s7, -76(s0)
	lw s8, -72(s0)
	lw s9, -68(s0)
	lw s10, -64(s0)
	lw s11, -60(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L29_10:
	j .L29_6
.L29_8:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_active
	mv s2, a0
	bnez s2, .L29_11
	j .L29_12
.L29_12:
	j .L29_6
.L29_11:
.L29_13:
	j .L29_14
.L29_14:
	li s1, 0
	lw s2, -4(s0)
	li s3, 17444
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 1052
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 1052
	add s4, s1, s2
	mv a0, s4
	jal ra, strlen
	mv s1, a0
	mv a0, s3
	mv a1, s1
	jal ra, pp_tokenize
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -4(s0)
	lw s2, -40(s0)
	mv a0, s1
	mv a1, s2
	jal ra, macro_expand
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -4(s0)
	li s2, 17444
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L29_15
	j .L29_16
.L29_16:
	j .L29_17
.L29_15:
	lw s1, -4(s0)
	addi s2, s0, -44
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, read_logical_line
	mv s4, a0
	bnez s4, .L29_18
	j .L29_19
.L29_19:
	la s1, __str_46
	mv a0, s1
	jal ra, warn
	mv s2, a0
	j .L29_17
.L29_18:
	lw s1, -4(s0)
	addi s2, s0, -44
	mv a0, s1
	mv a1, s2
	jal ra, strip_block_comments
	mv s3, a0
	lw s1, -4(s0)
	li s2, 1052
	add s3, s1, s2
	mv a0, s3
	jal ra, strlen
	mv s1, a0
	sw s1, -48(s0)
	lw s1, -48(s0)
	li s2, 8192
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	xori s2, s2, 1
	bnez s2, .L29_20
	j .L29_21
.L29_20:
	j .L29_17
.L29_21:
	lw s1, -4(s0)
	li s2, 1052
	add s3, s1, s2
	lw s1, -48(s0)
	add s2, s3, s1
	li s1, 8192
	lw s3, -48(s0)
	sub s4, s1, s3
	la s1, __str_47
	addi s3, s0, -44
	addi sp, sp, -16
	mv a0, s2
	mv a1, s4
	mv a2, s1
	sw s3, 0(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
.L29_22:
	j .L29_13
.L29_17:
	lw s1, -36(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 1
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, pp_detokenize
	mv s3, a0
	sw s3, -52(s0)
	lw s1, -36(s0)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	lw s1, -52(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L29_23
	j .L29_24
.L29_23:
	j .L29_6
.L29_24:
	li s1, 10
	lw s2, -8(s0)
	addi s3, s0, -52
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -52(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 0
	lw s2, -8(s0)
	lw s3, -52(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 17448
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	lw s2, -4(s0)
	li s3, 17452
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -52(s0)
	mv a0, s1
	lw s1, -100(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	lw s4, -88(s0)
	lw s5, -84(s0)
	lw s6, -80(s0)
	lw s7, -76(s0)
	lw s8, -72(s0)
	lw s9, -68(s0)
	lw s10, -64(s0)
	lw s11, -60(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L29_6:
	j .L29_0
.L29_25:
	li s1, 0
	mv a0, s1
	lw s1, -100(s0)
	lw s2, -96(s0)
	lw s3, -92(s0)
	lw s4, -88(s0)
	lw s5, -84(s0)
	lw s6, -80(s0)
	lw s7, -76(s0)
	lw s8, -72(s0)
	lw s9, -68(s0)
	lw s10, -64(s0)
	lw s11, -60(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end29:
	.size cpp_next_line, .Lfunc_end29-cpp_next_line

	.text
	.align 2
	.globl cpp_process_file
	.type cpp_process_file, @function
cpp_process_file:
	li t6, -8272
	add sp, sp, t6
	li t6, 8268
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 8264
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 8264
	add s0, sp, t6
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
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cpp_open
	mv s3, a0
	li s1, 0
	slt s2, s3, s1
	bnez s2, .L30_0
	j .L30_1
.L30_0:
	li s1, 1
	neg s2, s1
	mv a0, s2
	li t6, -8260
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8256
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8252
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8248
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8244
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8240
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8236
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8232
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8228
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8224
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8220
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L30_1:
.L30_2:
	lw s1, -4(s0)
	li t6, -8208
	add s2, s0, t6
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, cpp_next_line
	mv s4, a0
	li t6, -8212
	add t6, s0, t6
	sw s4, 0(t6)
	li s1, 0
	slt s2, s1, s4
	bnez s2, .L30_3
	j .L30_4
.L30_3:
	li t6, -8208
	add s1, s0, t6
	li s2, 1
	li t6, -8212
	add t6, s0, t6
	lw s3, 0(t6)
	lw s4, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	j .L30_2
.L30_4:
.L30_5:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L30_6
	j .L30_7
.L30_6:
	lw s1, -4(s0)
	la s2, __str_48
	mv a0, s1
	mv a1, s2
	jal ra, cpp_error
	mv s3, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_pop
	mv s2, a0
	j .L30_5
.L30_7:
	li t6, -8212
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L30_8
	j .L30_9
.L30_9:
	lw s1, -4(s0)
	li s2, 17436
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L30_8
	j .L30_10
.L30_8:
	li s1, 1
	neg s2, s1
	li t6, -8216
	add t6, s0, t6
	sw s2, 0(t6)
	j .L30_11
.L30_10:
	li s1, 0
	li t6, -8216
	add t6, s0, t6
	sw s1, 0(t6)
.L30_11:
	li t6, -8216
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -8260
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8256
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8252
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8248
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8244
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8240
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8236
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8232
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8228
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8224
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8220
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end30:
	.size cpp_process_file, .Lfunc_end30-cpp_process_file

	.data
	.align 2
__str_48:
	.ascii "unterminated #if (missing #endif)\000"
	.align 2
__str_47:
	.ascii " %s\000"
	.align 2
__str_46:
	.ascii "unterminated macro arguments\000"
	.align 2
__str_45:
	.ascii "__STDC_VERSION__\000"
	.align 2
__str_44:
	.ascii "__STDC__\000"
	.align 2
__str_43:
	.ascii "__TIME__\000"
	.align 2
__str_42:
	.ascii "__DATE__\000"
	.align 2
__str_41:
	.ascii "__LINE__\000"
	.align 2
__str_40:
	.ascii "__FILE__\000"
	.align 2
__str_39:
	.ascii "\"%H:%M:%S\"\000"
	.align 2
__str_38:
	.ascii "\"%b %e %Y\"\000"
	.align 2
__str_37:
	.ascii "*/\000"
	.align 2
__str_36:
	.ascii "*/\000"
	.align 2
__str_35:
	.ascii "<unknown>\000"
	.align 2
__str_34:
	.ascii "%s:%d: unknown directive '#%.*s'\000"
	.align 2
__str_33:
	.ascii "pragma\000"
	.align 2
__str_32:
	.ascii "line\000"
	.align 2
__str_31:
	.ascii "<unknown>\000"
	.align 2
__str_30:
	.ascii "%s:%d: #warning %s\000"
	.align 2
__str_29:
	.ascii "warning\000"
	.align 2
__str_28:
	.ascii "error\000"
	.align 2
__str_27:
	.ascii "include\000"
	.align 2
__str_26:
	.ascii "undef\000"
	.align 2
__str_25:
	.ascii "define\000"
	.align 2
__str_24:
	.ascii "else\000"
	.align 2
__str_23:
	.ascii "elif\000"
	.align 2
__str_22:
	.ascii "if\000"
	.align 2
__str_21:
	.ascii "ifndef\000"
	.align 2
__str_20:
	.ascii "ifdef\000"
	.align 2
__str_19:
	.ascii "endif\000"
	.align 2
__str_18:
	.ascii "<unknown>\000"
	.align 2
__str_17:
	.ascii "%s:%d: #error %s\000"
	.align 2
__str_16:
	.ascii "duplicate #else\000"
	.align 2
__str_15:
	.ascii "#else without #if\000"
	.align 2
__str_14:
	.ascii "#elif after #else\000"
	.align 2
__str_13:
	.ascii "#elif without #if\000"
	.align 2
__str_12:
	.ascii "#ifdef/#ifndef: missing identifier\000"
	.align 2
__str_11:
	.ascii "<unknown>\000"
	.align 2
__str_10:
	.ascii "%s:%d: cannot read include file '%s'\000"
	.align 2
__str_9:
	.ascii "<unknown>\000"
	.align 2
__str_8:
	.ascii "%s:%d: cannot find include file '%s'\000"
	.align 2
__str_7:
	.ascii "<unknown>\000"
	.align 2
__str_6:
	.ascii "%s:%d: invalid #include\000"
	.align 2
__str_5:
	.ascii "#define: missing macro name\000"
	.align 2
__str_4:
	.ascii "r\000"
	.align 2
__str_3:
	.ascii "%s/%s\000"
	.align 2
__str_2:
	.ascii "r\000"
	.align 2
__str_1:
	.ascii "%.*s/%s\000"
	.align 2
__str_0:
	.ascii "skj-cpp: error: \000"
