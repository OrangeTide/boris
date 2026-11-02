# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type page_new, @function
page_new:
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
	li s1, 8
	lw s2, -4(s0)
	add s3, s1, s2
	mv a0, s3
	jal ra, malloc
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L1_0
	j .L1_1
.L1_1:
	la s1, __libc_stderr
	la s2, __str_0
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	jal ra, abort
	mv s1, a0
.L1_0:
	li s1, 0
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end1:
	.size page_new, .Lfunc_end1-page_new

	.text
	.align 2
	.globl arena_init
	.type arena_init, @function
arena_init:
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
	li s1, 65536
	mv a0, s1
	jal ra, page_new
	mv s2, a0
	lw s1, -4(s0)
	sw s2, 0(s1)
	li s1, 0
	lw s2, -4(s0)
	li s3, 4
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
.Lfunc_end2:
	.size arena_init, .Lfunc_end2-arena_init

	.text
	.align 2
	.globl arena_free
	.type arena_free, @function
arena_free:
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
	sw s2, -12(s0)
.L3_0:
	lw s1, -12(s0)
	bnez s1, .L3_1
	j .L3_2
.L3_1:
	lw s1, -12(s0)
	lw s2, 0(s1)
	sw s2, -16(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L3_3:
	lw s1, -16(s0)
	sw s1, -12(s0)
	j .L3_0
.L3_2:
	li s1, 0
	lw s2, -4(s0)
	sw s1, 0(s2)
	li s1, 0
	lw s2, -4(s0)
	li s3, 4
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
.Lfunc_end3:
	.size arena_free, .Lfunc_end3-arena_free

	.text
	.align 2
	.globl arena_alloc
	.type arena_alloc, @function
arena_alloc:
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
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	li s1, 8
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	lw s2, -8(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 4
	add s4, s2, s1
	lw s1, 0(s4)
	sltu s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L4_0
	j .L4_1
.L4_0:
	lw s1, -12(s0)
	lw s2, -8(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 8
	add s3, s2, s1
	lw s1, -12(s0)
	add s2, s3, s1
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
.L4_1:
	li s1, 65536
	sw s1, -20(s0)
	lw s1, -8(s0)
	lw s2, -20(s0)
	sltu s3, s2, s1
	bnez s3, .L4_2
	j .L4_3
.L4_2:
	lw s1, -8(s0)
	sw s1, -20(s0)
.L4_3:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, page_new
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -16(s0)
	sw s2, 0(s1)
	lw s1, -16(s0)
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	li s2, 8
	add s3, s1, s2
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
.Lfunc_end4:
	.size arena_alloc, .Lfunc_end4-arena_alloc

	.text
	.align 2
	.globl arena_zalloc
	.type arena_zalloc, @function
arena_zalloc:
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
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
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
.Lfunc_end5:
	.size arena_zalloc, .Lfunc_end5-arena_zalloc

	.text
	.align 2
	.globl arena_strdup
	.type arena_strdup, @function
arena_strdup:
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
	jal ra, strlen
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 1
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_alloc
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -16(s0)
	lw s2, -8(s0)
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
.Lfunc_end6:
	.size arena_strdup, .Lfunc_end6-arena_strdup

	.text
	.align 2
	.globl arena_strndup
	.type arena_strndup, @function
arena_strndup:
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
	lw s2, -12(s0)
	li s3, 1
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_alloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -20(s0)
	lw s3, -12(s0)
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
.Lfunc_end7:
	.size arena_strndup, .Lfunc_end7-arena_strndup

	.text
	.align 2
	.globl arena_save
	.type arena_save, @function
arena_save:
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
	addi s1, s0, -16
	sw s2, 0(s1)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -16
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -16
	lw a0, 0(s1)
	lw a1, 4(s1)
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
	.size arena_save, .Lfunc_end8-arena_save

	.text
	.align 2
	.globl arena_release
	.type arena_release, @function
arena_release:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	sw s2, -20(s0)
.L9_0:
	lw s1, -20(s0)
	addi s2, s0, -16
	lw s3, 0(s2)
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L9_1
	j .L9_2
.L9_1:
	lw s1, -20(s0)
	lw s2, 0(s1)
	sw s2, -24(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L9_3:
	lw s1, -24(s0)
	sw s1, -20(s0)
	j .L9_0
.L9_2:
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -4(s0)
	sw s2, 0(s1)
	addi s1, s0, -16
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 4
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
.Lfunc_end9:
	.size arena_release, .Lfunc_end9-arena_release

	.data
	.align 2
__str_0:
	.ascii "arena: out of memory\n\000"
