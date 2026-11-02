# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl util_cleanup_push
	.type util_cleanup_push, @function
util_cleanup_push:
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
	la s1, ncleanups
	lw s2, 0(s1)
	li s1, 8
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	la s1, __str_1
	mv a0, s1
	jal ra, die
	mv s2, a0
.L1_1:
	lw s1, -4(s0)
	la s2, cleanup_stack
	la s3, ncleanups
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -8(s0)
	la s2, cleanup_stack
	la s3, ncleanups
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, ncleanups
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
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
	.size util_cleanup_push, .Lfunc_end1-util_cleanup_push

	.text
	.align 2
	.globl util_cleanup_pop
	.type util_cleanup_pop, @function
util_cleanup_pop:
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
	la s1, ncleanups
	lw s2, 0(s1)
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L2_0
	j .L2_1
.L2_0:
	la s1, ncleanups
	lw s2, 0(s1)
	li s3, -1
	add s4, s2, s3
	sw s4, 0(s1)
.L2_1:
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
	.size util_cleanup_pop, .Lfunc_end2-util_cleanup_pop

	.text
	.align 2
	.globl util_cleanup_run
	.type util_cleanup_run, @function
util_cleanup_run:
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
.L3_0:
	la s1, ncleanups
	lw s2, 0(s1)
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	la s1, ncleanups
	lw s2, 0(s1)
	li s3, -1
	add s4, s2, s3
	sw s4, 0(s1)
	sw s4, -4(s0)
	la s1, cleanup_stack
	lw s2, -4(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, cleanup_stack
	lw s3, -4(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	mv a0, s2
	mv t0, s1
	jalr ra, t0, 0
	mv s3, a0
	j .L3_0
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
	.size util_cleanup_run, .Lfunc_end3-util_cleanup_run

	.text
	.align 2
	.globl util_set_progname
	.type util_set_progname, @function
util_set_progname:
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
	la s2, progname
	sw s1, 0(s2)
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
	.size util_set_progname, .Lfunc_end4-util_set_progname

	.text
	.align 2
	.globl die
	.type die, @function
die:
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
	addi s1, s0, -24
	addi t0, s0, 8
	sw t0, 8(s1)
	sw zero, 0(s1)
	sw zero, 4(s1)
	sw zero, 12(s1)
	li s1, 0
	la s1, __libc_stderr
	la s2, __str_2
	la s3, progname
	lw s4, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s4, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
	la s1, __libc_stderr
	lw s2, -4(s0)
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
	la s1, util_die_active
	lw s2, 0(s1)
	sw s2, -28(s0)
	li s1, 0
	la s2, util_die_active
	sw s1, 0(s2)
	jal ra, util_cleanup_run
	mv s1, a0
	lw s1, -28(s0)
	bnez s1, .L5_0
	j .L5_1
.L5_0:
	la s1, util_die_env
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, longjmp
	mv s3, a0
.L5_1:
	li s1, 1
	mv a0, s1
	jal ra, exit
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
.Lfunc_end5:
	.size die, .Lfunc_end5-die

	.text
	.align 2
	.globl warn
	.type warn, @function
warn:
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
	addi s1, s0, -24
	addi t0, s0, 8
	sw t0, 8(s1)
	sw zero, 0(s1)
	sw zero, 4(s1)
	sw zero, 12(s1)
	li s1, 0
	la s1, __libc_stderr
	la s2, __str_3
	la s3, progname
	lw s4, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s4, 0(sp)
	jal ra, fprintf
	mv s3, a0
	addi sp, sp, 16
	la s1, __libc_stderr
	lw s2, -4(s0)
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
.Lfunc_end6:
	.size warn, .Lfunc_end6-warn

	.text
	.align 2
	.globl xmalloc
	.type xmalloc, @function
xmalloc:
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
	jal ra, malloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	la s1, __str_4
	mv a0, s1
	jal ra, die
	mv s2, a0
.L7_1:
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
	.size xmalloc, .Lfunc_end7-xmalloc

	.text
	.align 2
	.globl xcalloc
	.type xcalloc, @function
xcalloc:
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
	jal ra, calloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_0:
	la s1, __str_5
	mv a0, s1
	jal ra, die
	mv s2, a0
.L8_1:
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
.Lfunc_end8:
	.size xcalloc, .Lfunc_end8-xcalloc

	.text
	.align 2
	.globl xstrdup
	.type xstrdup, @function
xstrdup:
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
	jal ra, strlen
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	mv a0, s3
	jal ra, xmalloc
	mv s1, a0
	sw s1, -16(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -12(s0)
	li s4, 1
	add s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
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
.Lfunc_end9:
	.size xstrdup, .Lfunc_end9-xstrdup

	.text
	.align 2
	.globl xstrndup
	.type xstrndup, @function
xstrndup:
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
	li s2, 1
	add s3, s1, s2
	mv a0, s3
	jal ra, xmalloc
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -12(s0)
	lw s2, -4(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -12(s0)
	lw s3, -8(s0)
	add s4, s2, s3
	sb s1, 0(s4)
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
	.size xstrndup, .Lfunc_end10-xstrndup

	.text
	.align 2
	.globl slurp
	.type slurp, @function
slurp:
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
	la s2, __str_6
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L11_0
	j .L11_1
.L11_1:
	la s1, __str_7
	lw s2, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_0:
	lw s1, -12(s0)
	li s2, 0
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fseek
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L11_2
	j .L11_3
.L11_3:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ftell
	mv s2, a0
	sw s2, -16(s0)
	li s1, 0
	slt s3, s2, s1
	bnez s3, .L11_2
	j .L11_4
.L11_2:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	la s1, __str_8
	lw s2, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_4:
	lw s1, -16(s0)
	li s2, 1
	li s3, 30
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L11_5
	j .L11_6
.L11_5:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	la s1, __str_9
	lw s2, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_6:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, rewind
	mv s2, a0
	lw s1, -16(s0)
	li s2, 1
	add s3, s1, s2
	mv a0, s3
	jal ra, malloc
	mv s1, a0
	sw s1, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L11_7
	j .L11_8
.L11_8:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	la s1, __str_10
	mv a0, s1
	jal ra, die
	mv s2, a0
.L11_7:
	lw s1, -20(s0)
	li s2, 1
	lw s3, -16(s0)
	lw s4, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fread
	mv s5, a0
	lw s1, -16(s0)
	xor s2, s5, s1
	snez s2, s2
	bnez s2, .L11_9
	j .L11_10
.L11_9:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	la s1, __str_11
	lw s2, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_10:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	li s1, 0
	lw s2, -20(s0)
	lw s3, -16(s0)
	add s4, s2, s3
	sb s1, 0(s4)
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
.Lfunc_end11:
	.size slurp, .Lfunc_end11-slurp

	.text
	.align 2
	.type strset_hash, @function
strset_hash:
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
	li s10, 1939669891
	li s11, 342167472
	sw s10, -16(s0)
	sw s11, -12(s0)
.L12_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L12_1
	j .L12_2
.L12_1:
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	lb s1, 0(s2)
	li s2, 255
	and s3, s1, s2
	mv s8, s3
	li s9, 0
	xor s6, s10, s8
	xor s7, s11, s9
	sw s6, -16(s0)
	sw s7, -12(s0)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s8, 435
	li s9, 256
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	jal ra, __muldi3
	addi sp, sp, 16
	mv s6, a0
	mv s7, a1
	sw s6, -16(s0)
	sw s7, -12(s0)
	j .L12_0
.L12_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv s1, s10
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
	.size strset_hash, .Lfunc_end12-strset_hash

	.text
	.align 2
	.globl strset_init
	.type strset_init, @function
strset_init:
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
	li s1, 0
	lw s2, -4(s0)
	sw s1, 0(s2)
	li s1, 0
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
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
	.size strset_init, .Lfunc_end13-strset_init

	.text
	.align 2
	.type strset_grow, @function
strset_grow:
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
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_0
	j .L14_1
.L14_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -16(s0)
	j .L14_2
.L14_1:
	li s1, 64
	sw s1, -16(s0)
.L14_2:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, xcalloc
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -12(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -24(s0)
	li s1, 0
	sw s1, -28(s0)
.L14_3:
	lw s1, -28(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	sltu s3, s1, s2
	bnez s3, .L14_4
	j .L14_5
.L14_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -28(s0)
	li s3, 4
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	sw s2, -32(s0)
	lw s1, -32(s0)
	bnez s1, .L14_6
	j .L14_7
.L14_7:
	j .L14_8
.L14_6:
	lw s1, -32(s0)
	mv a0, s1
	jal ra, strset_hash
	mv s2, a0
	lw s1, -24(s0)
	and s3, s2, s1
	sw s3, -36(s0)
.L14_9:
	lw s1, -20(s0)
	lw s2, -36(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L14_10
	j .L14_11
.L14_10:
.L14_12:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -24(s0)
	and s2, s3, s1
	sw s2, -36(s0)
	j .L14_9
.L14_11:
	lw s1, -32(s0)
	lw s2, -20(s0)
	lw s3, -36(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L14_8:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L14_3
.L14_5:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	lw s1, -20(s0)
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end14:
	.size strset_grow, .Lfunc_end14-strset_grow

	.text
	.align 2
	.globl strset_contains
	.type strset_contains, @function
strset_contains:
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
	bnez s1, .L15_0
	j .L15_1
.L15_1:
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
.L15_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	sub s3, s1, s2
	sw s3, -12(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, strset_hash
	mv s2, a0
	lw s1, -12(s0)
	and s3, s2, s1
	sw s3, -16(s0)
.L15_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	li s3, 4
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	bnez s2, .L15_3
	j .L15_4
.L15_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	li s3, 4
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
	bnez s2, .L15_5
	j .L15_6
.L15_5:
	li s1, 1
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
.L15_6:
.L15_7:
	lw s1, -16(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	and s2, s3, s1
	sw s2, -16(s0)
	j .L15_2
.L15_4:
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
	.size strset_contains, .Lfunc_end15-strset_contains

	.text
	.align 2
	.globl strset_add
	.type strset_add, @function
strset_add:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L16_0
	j .L16_1
.L16_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, strset_grow
	mv s2, a0
.L16_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	sub s3, s1, s2
	sw s3, -12(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, strset_hash
	mv s2, a0
	lw s1, -12(s0)
	and s3, s2, s1
	sw s3, -16(s0)
.L16_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	li s3, 4
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	bnez s2, .L16_3
	j .L16_4
.L16_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	li s3, 4
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
	bnez s2, .L16_5
	j .L16_6
.L16_5:
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
.L16_6:
.L16_7:
	lw s1, -16(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	and s2, s3, s1
	sw s2, -16(s0)
	j .L16_2
.L16_4:
	lw s1, -8(s0)
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -16(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s3, s5
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 1
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
	.size strset_add, .Lfunc_end16-strset_add

	.text
	.align 2
	.globl strset_free
	.type strset_free, @function
strset_free:
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
	mv a0, s2
	jal ra, free
	mv s1, a0
	li s1, 0
	lw s2, -4(s0)
	sw s1, 0(s2)
	li s1, 0
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
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
.Lfunc_end17:
	.size strset_free, .Lfunc_end17-strset_free

	.data
	.align 2
__str_11:
	.ascii "read failed on %s\000"
	.align 2
__str_10:
	.ascii "out of memory\000"
	.align 2
__str_9:
	.ascii "file too large: %s\000"
	.align 2
__str_8:
	.ascii "cannot read %s\000"
	.align 2
__str_7:
	.ascii "cannot open %s\000"
	.align 2
__str_6:
	.ascii "rb\000"
	.align 2
__str_5:
	.ascii "out of memory\000"
	.align 2
__str_4:
	.ascii "out of memory\000"
	.align 2
__str_3:
	.ascii "%s: warning: \000"
	.align 2
__str_2:
	.ascii "%s: error: \000"
	.align 2
__str_1:
	.ascii "cleanup stack overflow\000"
	.align 2
	.globl progname
progname:
	.word __str_0
	.align 2
__str_0:
	.ascii "compiler\000"

	.bss
	.align 2
	.globl ncleanups
ncleanups:
	.space 4
	.align 2
	.globl cleanup_stack
cleanup_stack:
	.space 64
	.align 2
	.globl util_die_active
util_die_active:
	.space 4
	.align 2
	.globl util_die_env
util_die_env:
	.space 128
