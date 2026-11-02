# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type skj_exe_dir, @function
skj_exe_dir:
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
	li t6, -4116
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 0
	li t6, -4112
	add s2, s0, t6
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	li t6, -4112
	add s1, s0, t6
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L1_0
	j .L1_1
.L1_0:
	li t6, -4112
	add s1, s0, t6
	li t6, -4116
	add t6, s0, t6
	sw s1, 0(t6)
.L1_1:
	li s1, 0
	lw s2, -8(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	li t6, -4116
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L1_2
	j .L1_3
.L1_3:
	li t6, -4172
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4168
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4164
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4160
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4156
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4136
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4132
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L1_2:
	li t6, -4116
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, strrchr
	mv s3, a0
	li t6, -4120
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4120
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L1_4
	j .L1_5
.L1_5:
	li t6, -4172
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4168
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4164
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4160
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4156
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4136
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4132
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L1_4:
	li t6, -4120
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4116
	add t6, s0, t6
	lw s2, 0(t6)
	sub s3, s1, s2
	li t6, -4124
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4124
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -12(s0)
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_6
	j .L1_7
.L1_6:
	lw s1, -12(s0)
	li s2, 1
	sub s3, s1, s2
	li t6, -4124
	add t6, s0, t6
	sw s3, 0(t6)
.L1_7:
	lw s1, -8(s0)
	li t6, -4116
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4124
	add t6, s0, t6
	lw s3, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -8(s0)
	li t6, -4124
	add t6, s0, t6
	lw s3, 0(t6)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	mv a0, s1
	li t6, -4172
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4168
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4164
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4160
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4156
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -4152
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -4144
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4136
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4132
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end1:
	.size skj_exe_dir, .Lfunc_end1-skj_exe_dir

	.text
	.align 2
	.type cleanup_arena, @function
cleanup_arena:
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
	jal ra, arena_free
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
.Lfunc_end2:
	.size cleanup_arena, .Lfunc_end2-cleanup_arena

	.text
	.align 2
	.type cleanup_cpp, @function
cleanup_cpp:
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
	jal ra, cpp_free
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
.Lfunc_end3:
	.size cleanup_cpp, .Lfunc_end3-cleanup_cpp

	.text
	.align 2
	.type usage, @function
usage:
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
	la s2, __str_0
	la s3, __str_1
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
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
.Lfunc_end4:
	.size usage, .Lfunc_end4-usage

	.text
	.align 2
	.globl main
	.type main, @function
main:
	li t6, -8736
	add sp, sp, t6
	li t6, 8732
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 8728
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 8728
	add s0, sp, t6
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
	la s1, __str_2
	mv a0, s1
	jal ra, util_set_progname
	mv s2, a0
	li t6, -4160
	add s1, s0, t6
	mv a0, s1
	jal ra, arena_init
	mv s2, a0
	jal ra, cpp_new
	mv s1, a0
	sw s1, -24(s0)
	lw s1, -24(s0)
	la s2, __str_3
	la s3, __str_4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, cpp_define
	mv s4, a0
	lw s1, -24(s0)
	la s2, __str_5
	la s3, __str_6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, cpp_define
	mv s4, a0
	lw s1, -24(s0)
	la s2, __str_7
	la s3, __str_8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, cpp_define
	mv s4, a0
	li s1, 0
	sw s1, -12(s0)
	li s1, 0
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
	li s1, 1
	li t6, -4164
	add t6, s0, t6
	sw s1, 0(t6)
.L5_0:
	li t6, -4164
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -4(s0)
	slt s3, s1, s2
	bnez s3, .L5_1
	j .L5_2
.L5_1:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_9
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_3
	j .L5_4
.L5_3:
	li t6, -4164
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 1
	add s3, s1, s2
	lw s1, -4(s0)
	slt s2, s3, s1
	bnez s2, .L5_5
	j .L5_4
.L5_5:
	lw s1, -8(s0)
	li t6, -4164
	add s2, s0, t6
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	li t6, -4164
	add t6, s0, t6
	sw s4, 0(t6)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	sw s1, -16(s0)
	j .L5_6
.L5_4:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_10
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L5_7
	j .L5_8
.L5_7:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 2
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L5_9
	j .L5_10
.L5_9:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 2
	add s3, s1, s2
	li t6, -4172
	add t6, s0, t6
	sw s3, 0(t6)
	j .L5_11
.L5_10:
	lw s1, -8(s0)
	li t6, -4164
	add s2, s0, t6
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	li t6, -4164
	add t6, s0, t6
	sw s4, 0(t6)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li t6, -4172
	add t6, s0, t6
	sw s1, 0(t6)
.L5_11:
	li t6, -4172
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4168
	add t6, s0, t6
	sw s1, 0(t6)
	lw s1, -24(s0)
	li t6, -4168
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, cpp_add_include_path
	mv s3, a0
	j .L5_12
.L5_8:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_11
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L5_13
	j .L5_14
.L5_13:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 2
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L5_15
	j .L5_16
.L5_15:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 2
	add s3, s1, s2
	li t6, -4180
	add t6, s0, t6
	sw s3, 0(t6)
	j .L5_17
.L5_16:
	lw s1, -8(s0)
	li t6, -4164
	add s2, s0, t6
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	li t6, -4164
	add t6, s0, t6
	sw s4, 0(t6)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	li t6, -4180
	add t6, s0, t6
	sw s1, 0(t6)
.L5_17:
	li t6, -4180
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4176
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -4176
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 61
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	li t6, -4184
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4184
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L5_18
	j .L5_19
.L5_18:
	li t6, -4184
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4176
	add t6, s0, t6
	lw s2, 0(t6)
	sub s3, s1, s2
	li t6, -4444
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4444
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 256
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_20
	j .L5_21
.L5_20:
	li s1, 256
	li s2, 1
	sub s3, s1, s2
	li t6, -4444
	add t6, s0, t6
	sw s3, 0(t6)
.L5_21:
	li t6, -4440
	add s1, s0, t6
	li t6, -4176
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4444
	add t6, s0, t6
	lw s3, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	li t6, -4440
	add s2, s0, t6
	li t6, -4444
	add t6, s0, t6
	lw s3, 0(t6)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -24(s0)
	li t6, -4440
	add s2, s0, t6
	li t6, -4184
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 1
	add s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, cpp_define
	mv s3, a0
	j .L5_22
.L5_19:
	lw s1, -24(s0)
	li t6, -4176
	add t6, s0, t6
	lw s2, 0(t6)
	la s3, __str_12
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, cpp_define
	mv s4, a0
.L5_22:
	j .L5_23
.L5_14:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_13
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_24
	j .L5_25
.L5_24:
	la s1, __str_14
	la s2, __str_15
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, printf
	mv s3, a0
	addi sp, sp, 16
	lw s1, -24(s0)
	mv a0, s1
	jal ra, cpp_free
	mv s2, a0
	li s1, 0
	mv a0, s1
	li t6, -8716
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8712
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8708
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8704
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8700
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8696
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8692
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8688
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8684
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8680
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8676
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	j .L5_26
.L5_25:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_16
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_27
	j .L5_28
.L5_28:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_17
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_27
	j .L5_29
.L5_27:
	la s1, __libc_stdout
	mv a0, s1
	jal ra, usage
	mv s2, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, cpp_free
	mv s2, a0
	li s1, 0
	mv a0, s1
	li t6, -8716
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8712
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8708
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8704
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8700
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8696
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8692
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8688
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8684
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8680
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8676
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	j .L5_30
.L5_29:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_18
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_31
	j .L5_32
.L5_31:
	li s1, 1
	sw s1, -20(s0)
	j .L5_33
.L5_32:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_19
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_34
	j .L5_35
.L5_34:
	li s1, 1
	la s2, cc_debug
	sw s1, 0(s2)
	j .L5_36
.L5_35:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_37
	j .L5_38
.L5_37:
	j .L5_39
.L5_38:
	lw s1, -8(s0)
	li t6, -4164
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -12(s0)
.L5_39:
.L5_36:
.L5_33:
.L5_30:
.L5_26:
.L5_23:
.L5_12:
.L5_6:
.L5_40:
	li t6, -4164
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -4164
	add t6, s0, t6
	sw s3, 0(t6)
	j .L5_0
.L5_2:
	lw s1, -12(s0)
	bnez s1, .L5_41
	j .L5_42
.L5_42:
	la s1, __str_20
	la s2, __str_21
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_41:
	la s1, __str_22
	mv a0, s1
	jal ra, getenv
	mv s2, a0
	li t6, -4448
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -4448
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L5_43
	j .L5_44
.L5_43:
	li t6, -4448
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	bnez s2, .L5_45
	j .L5_44
.L5_45:
	lw s1, -24(s0)
	li t6, -4448
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, cpp_add_include_path
	mv s3, a0
.L5_44:
	la s1, util_die_env
	mv a0, s1
	jal ra, setjmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L5_46
	j .L5_47
.L5_46:
	li s1, 1
	mv a0, s1
	li t6, -8716
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8712
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8708
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8704
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8700
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8696
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8692
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8688
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8684
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8680
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8676
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L5_47:
	li s1, 1
	la s2, util_die_active
	sw s1, 0(s2)
	la s1, cleanup_arena
	li t6, -4160
	add s2, s0, t6
	mv a0, s1
	mv a1, s2
	jal ra, util_cleanup_push
	mv s3, a0
	la s1, cleanup_cpp
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, util_cleanup_push
	mv s3, a0
	li s1, 0
	sw s1, -28(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cpp_open
	mv s3, a0
	li s1, 0
	slt s2, s3, s1
	bnez s2, .L5_48
	j .L5_49
.L5_48:
	la s1, __str_23
	lw s2, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_49:
	li s1, 0
	li t6, -4452
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 0
	li t6, -4456
	add t6, s0, t6
	sw s1, 0(t6)
.L5_50:
	lw s1, -24(s0)
	li t6, -4128
	add s2, s0, t6
	li s3, 4096
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, cpp_next_line
	mv s4, a0
	li t6, -4132
	add t6, s0, t6
	sw s4, 0(t6)
	li s1, 0
	slt s2, s1, s4
	bnez s2, .L5_51
	j .L5_52
.L5_51:
	lw s1, -20(s0)
	bnez s1, .L5_53
	j .L5_54
.L5_54:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, cpp_get_emit_line
	mv s2, a0
	li t6, -4460
	add t6, s0, t6
	sw s2, 0(t6)
	lw s1, -24(s0)
	mv a0, s1
	jal ra, cpp_get_emit_file
	mv s2, a0
	li t6, -4464
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -4464
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L5_55
	j .L5_56
.L5_55:
	li t6, -4456
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L5_57
	j .L5_58
.L5_57:
	li t6, -4464
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4456
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L5_58
	j .L5_59
.L5_59:
	li t6, -4460
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4452
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 1
	add s4, s2, s3
	xor s2, s1, s4
	snez s2, s2
	bnez s2, .L5_58
	j .L5_56
.L5_58:
	li t6, -8664
	add s1, s0, t6
	li s2, 4200
	la s3, __str_24
	li t6, -4460
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -4464
	add t6, s0, t6
	lw s5, 0(t6)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, snprintf
	mv s6, a0
	addi sp, sp, 16
	li t6, -8668
	add t6, s0, t6
	sw s6, 0(t6)
	li t6, -8668
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L5_60
	j .L5_61
.L5_60:
	li t6, -8668
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4200
	slt s3, s1, s2
	bnez s3, .L5_62
	j .L5_61
.L5_62:
	lw s1, -28(s0)
	li t6, -8668
	add t6, s0, t6
	lw s2, 0(t6)
	add s3, s1, s2
	li s1, 2097152
	li s2, 1
	sub s4, s1, s2
	slt s1, s3, s4
	xori s1, s1, 1
	bnez s1, .L5_63
	j .L5_64
.L5_63:
	la s1, __str_25
	mv a0, s1
	jal ra, die
	mv s2, a0
.L5_64:
	la s1, main.ppbuf.0
	lw s2, -28(s0)
	add s3, s1, s2
	li t6, -8664
	add s1, s0, t6
	li t6, -8668
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -28
	lw s2, 0(s1)
	li t6, -8668
	add t6, s0, t6
	lw s1, 0(t6)
	add s3, s2, s1
	sw s3, -28(s0)
.L5_61:
	li t6, -4160
	add s1, s0, t6
	li t6, -4464
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, arena_strdup
	mv s3, a0
	li t6, -4456
	add t6, s0, t6
	sw s3, 0(t6)
.L5_56:
	li t6, -4460
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4452
	add t6, s0, t6
	sw s1, 0(t6)
.L5_53:
	lw s1, -28(s0)
	li t6, -4132
	add t6, s0, t6
	lw s2, 0(t6)
	add s3, s1, s2
	li s1, 2097152
	li s2, 1
	sub s4, s1, s2
	slt s1, s3, s4
	xori s1, s1, 1
	bnez s1, .L5_65
	j .L5_66
.L5_65:
	la s1, __str_26
	mv a0, s1
	jal ra, die
	mv s2, a0
.L5_66:
	la s1, main.ppbuf.0
	lw s2, -28(s0)
	add s3, s1, s2
	li t6, -4128
	add s1, s0, t6
	li t6, -4132
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -28
	lw s2, 0(s1)
	li t6, -4132
	add t6, s0, t6
	lw s1, 0(t6)
	add s3, s2, s1
	sw s3, -28(s0)
	j .L5_50
.L5_52:
	li s1, 0
	la s2, main.ppbuf.0
	lw s3, -28(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -24(s0)
	mv a0, s1
	jal ra, cpp_free
	mv s2, a0
	jal ra, util_cleanup_pop
	mv s1, a0
	lw s1, -20(s0)
	bnez s1, .L5_67
	j .L5_68
.L5_67:
	lw s1, -16(s0)
	bnez s1, .L5_69
	j .L5_70
.L5_69:
	lw s1, -16(s0)
	la s2, __str_27
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	li t6, -8672
	add t6, s0, t6
	sw s3, 0(t6)
	j .L5_71
.L5_70:
	la s1, __libc_stdout
	li t6, -8672
	add t6, s0, t6
	sw s1, 0(t6)
.L5_71:
	li t6, -8672
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4148
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L5_72
	j .L5_73
.L5_73:
	la s1, __str_28
	lw s2, -16(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_72:
	la s1, main.ppbuf.0
	li s2, 1
	lw s3, -28(s0)
	li t6, -4148
	add t6, s0, t6
	lw s4, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	li t6, -4148
	add t6, s0, t6
	lw s1, 0(t6)
	la s2, __libc_stdout
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_74
	j .L5_75
.L5_74:
	li t6, -4148
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
.L5_75:
	jal ra, util_cleanup_run
	mv s1, a0
	li s1, 0
	mv a0, s1
	li t6, -8716
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8712
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8708
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8704
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8700
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8696
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8692
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8688
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8684
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8680
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8676
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L5_68:
	li t6, -4160
	add s1, s0, t6
	la s2, main.ppbuf.0
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, cc_lex_init
	mv s4, a0
	li t6, -4160
	add s1, s0, t6
	mv a0, s1
	jal ra, cc_parse_program
	mv s2, a0
	li t6, -4136
	add t6, s0, t6
	sw s2, 0(t6)
	la s1, cc_debug
	lw s2, 0(s1)
	bnez s2, .L5_76
	j .L5_77
.L5_76:
	lw s1, -12(s0)
	la s2, cc_src_file
	sw s1, 0(s2)
.L5_77:
	li t6, -4160
	add s1, s0, t6
	li t6, -4136
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, cc_lower_program
	mv s3, a0
	li t6, -4140
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, 0(s1)
	li t6, -4144
	add t6, s0, t6
	sw s2, 0(t6)
.L5_78:
	li t6, -4144
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L5_79
	j .L5_80
.L5_79:
	li t6, -4144
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, regalloc
	mv s2, a0
.L5_81:
	li t6, -4144
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 100
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -4144
	add t6, s0, t6
	sw s1, 0(t6)
	j .L5_78
.L5_80:
	lw s1, -16(s0)
	bnez s1, .L5_82
	j .L5_83
.L5_82:
	lw s1, -16(s0)
	la s2, __str_29
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	li t6, -4148
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4148
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L5_84
	j .L5_85
.L5_85:
	la s1, __str_30
	lw s2, -16(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_84:
	j .L5_86
.L5_83:
	la s1, __libc_stdout
	li t6, -4148
	add t6, s0, t6
	sw s1, 0(t6)
.L5_86:
	li t6, -4148
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4140
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, target_emit
	mv s3, a0
	li t6, -4148
	add t6, s0, t6
	lw s1, 0(t6)
	la s2, __libc_stdout
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_87
	j .L5_88
.L5_87:
	li t6, -4148
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
.L5_88:
	jal ra, util_cleanup_run
	mv s1, a0
	li s1, 0
	mv a0, s1
	li t6, -8716
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -8712
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -8708
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -8704
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -8700
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -8696
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -8692
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -8688
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -8684
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -8680
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -8676
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end5:
	.size main, .Lfunc_end5-main

	.data
	.align 2
__str_30:
	.ascii "cannot write '%s'\000"
	.align 2
__str_29:
	.ascii "w\000"
	.align 2
__str_28:
	.ascii "cannot write '%s'\000"
	.align 2
__str_27:
	.ascii "w\000"
	.align 2
__str_26:
	.ascii "preprocessed source too large\000"
	.align 2
__str_25:
	.ascii "preprocessed source too large\000"
	.align 2
__str_24:
	.ascii "# %d \"%s\"\n\000"
	.align 2
__str_23:
	.ascii "cannot open '%s'\000"
	.align 2
__str_22:
	.ascii "SKJ_CC_INCLUDE\000"
	.align 2
__str_21:
	.ascii "usage: skj-cc [-V] [-o out.s] [-I path] [-D name[=val]] input.c\000"
	.align 2
__str_20:
	.ascii "%s\000"
	.align 2
__str_19:
	.ascii "-g\000"
	.align 2
__str_18:
	.ascii "-E\000"
	.align 2
__str_17:
	.ascii "--help\000"
	.align 2
__str_16:
	.ascii "-h\000"
	.align 2
__str_15:
	.ascii "0.43.0+g49a60c3\000"
	.align 2
__str_14:
	.ascii "skj-cc %s\n\000"
	.align 2
__str_13:
	.ascii "-V\000"
	.align 2
__str_12:
	.ascii "1\000"
	.align 2
__str_11:
	.ascii "-D\000"
	.align 2
__str_10:
	.ascii "-I\000"
	.align 2
__str_9:
	.ascii "-o\000"
	.align 2
__str_8:
	.ascii "1\000"
	.align 2
__str_7:
	.ascii "__skj_ilp32__\000"
	.align 2
__str_6:
	.ascii "1\000"
	.align 2
__str_5:
	.ascii "__skj_riscv__\000"
	.align 2
__str_4:
	.ascii "1\000"
	.align 2
__str_3:
	.ascii "__skj__\000"
	.align 2
__str_2:
	.ascii "skj-cc\000"
	.align 2
__str_1:
	.ascii "usage: skj-cc [-V] [-o out.s] [-I path] [-D name[=val]] input.c\000"
	.align 2
__str_0:
	.ascii "%s\n\000"

	.bss
	.align 2
main.ppbuf.0:
	.space 2097152
