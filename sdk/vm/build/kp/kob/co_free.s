# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type coro_ptr, @function
coro_ptr:
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
	.size coro_ptr, .Lfunc_end1-coro_ptr

	.text
	.align 2
	.type co_trampoline, @function
co_trampoline:
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
	la s1, current
	lw s2, 0(s1)
	mv a0, s2
	jal ra, coro_ptr
	mv s1, a0
	sw s1, -4(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	lw s3, -4(s0)
	li s4, 28
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -4(s0)
	li s5, 32
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	sw s5, 0(s3)
	li s1, 2
	lw s2, -4(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, co_switch
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
	.size co_trampoline, .Lfunc_end2-co_trampoline

	.text
	.align 2
	.type co_run, @function
co_run:
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
	la s1, current
	lw s2, 0(s1)
	sw s2, -12(s0)
	lw s1, -4(s0)
	la s2, current
	sw s1, 0(s2)
	lw s1, -8(s0)
	lw s2, -4(s0)
	mv a0, s2
	jal ra, coro_ptr
	mv s3, a0
	li s2, 8
	add s4, s3, s2
	mv a0, s1
	mv a1, s4
	jal ra, co_switch
	mv s2, a0
	lw s1, -12(s0)
	la s2, current
	sw s1, 0(s2)
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
	.size co_run, .Lfunc_end3-co_run

	.text
	.align 2
	.globl kp_co_new_g
	.type kp_co_new_g, @function
kp_co_new_g:
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
	li s1, 56
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, coro_ptr
	mv s2, a0
	sw s2, -24(s0)
	li s1, 3
	la s2, co_final
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	lw s1, -24(s0)
	li s2, 0
	li s3, 56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li s1, 1
	lw s2, -24(s0)
	sw s1, 0(s2)
	li s1, 3
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -24(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -24(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 64
	li s2, 1024
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	lw s2, -24(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 64
	li s2, 1024
	mul s3, s1, s2
	lw s1, -24(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	li s1, 0
	mv a0, s1
	jal ra, rt_trap
	mv s2, a0
.L4_1:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 64
	li s3, 1024
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 15
	not s3, s2
	and s2, s1, s3
	sw s2, -28(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L4_2
	j .L4_3
.L4_2:
	lw s1, -12(s0)
	li s2, 8
	mul s3, s1, s2
	li s1, 15
	add s2, s3, s1
	li s1, 15
	not s3, s1
	and s1, s2, s3
	sw s1, -44(s0)
	addi s1, s0, -28
	lw s2, 0(s1)
	lw s1, -44(s0)
	sub s3, s2, s1
	sw s3, -28(s0)
	lw s1, -28(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
	lw s1, -28(s0)
	lw s2, -24(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
.L4_3:
	li s1, 160
	sw s1, -36(s0)
	li s1, 0
	sw s1, -40(s0)
	addi s1, s0, -28
	lw s2, 0(s1)
	lw s1, -36(s0)
	sub s3, s2, s1
	sw s3, -28(s0)
	lw s1, -28(s0)
	sw s1, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	lw s3, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	la s1, co_trampoline
	lw s2, -32(s0)
	lw s3, -40(s0)
	li s4, 4
	divu s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	sw s1, 0(s3)
	lw s1, -32(s0)
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
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
.Lfunc_end4:
	.size kp_co_new_g, .Lfunc_end4-kp_co_new_g

	.text
	.align 2
	.globl kp_co_resume_g
	.type kp_co_resume_g, @function
kp_co_resume_g:
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
	bnez s1, .L5_0
	j .L5_1
.L5_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, coro_ptr
	mv s2, a0
	sw s2, -16(s0)
	j .L5_2
.L5_1:
	li s1, 0
	sw s1, -16(s0)
.L5_2:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L5_3
	j .L5_4
.L5_3:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_4
	j .L5_5
.L5_5:
	lw s1, -12(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_4
	j .L5_6
.L5_4:
	li s1, 0
	mv a0, s1
	jal ra, rt_trap
	mv s2, a0
.L5_6:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -20
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	addi s2, s0, -20
	mv a0, s1
	mv a1, s2
	jal ra, co_run
	mv s3, a0
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -12(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_7
	j .L5_8
.L5_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, co_reclaim
	mv s2, a0
.L5_8:
	lw s1, -24(s0)
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
	.size kp_co_resume_g, .Lfunc_end5-kp_co_resume_g

	.text
	.align 2
	.globl kp_co_yield_g
	.type kp_co_yield_g, @function
kp_co_yield_g:
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
	la s1, current
	lw s2, 0(s1)
	bnez s2, .L6_0
	j .L6_1
.L6_0:
	la s1, current
	lw s2, 0(s1)
	mv a0, s2
	jal ra, coro_ptr
	mv s1, a0
	sw s1, -16(s0)
	j .L6_2
.L6_1:
	li s1, 0
	sw s1, -16(s0)
.L6_2:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L6_3
	j .L6_4
.L6_4:
	li s1, 0
	mv a0, s1
	jal ra, rt_trap
	mv s2, a0
.L6_3:
	lw s1, -12(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L6_5
	j .L6_6
.L6_5:
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
.L6_6:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, co_switch
	mv s2, a0
	li s1, 1
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
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
	.size kp_co_yield_g, .Lfunc_end6-kp_co_yield_g

	.text
	.align 2
	.globl kp_co_self_g
	.type kp_co_self_g, @function
kp_co_self_g:
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
	la s1, current
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
.Lfunc_end7:
	.size kp_co_self_g, .Lfunc_end7-kp_co_self_g

	.text
	.align 2
	.globl kp_co_cancelling_g
	.type kp_co_cancelling_g, @function
kp_co_cancelling_g:
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
	la s1, current
	lw s2, 0(s1)
	bnez s2, .L8_0
	j .L8_1
.L8_0:
	la s1, current
	lw s2, 0(s1)
	mv a0, s2
	jal ra, coro_ptr
	mv s1, a0
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -4(s0)
	j .L8_2
.L8_1:
	li s1, 0
	sw s1, -4(s0)
.L8_2:
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
.Lfunc_end8:
	.size kp_co_cancelling_g, .Lfunc_end8-kp_co_cancelling_g

	.text
	.align 2
	.type co_cancel, @function
co_cancel:
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
	jal ra, coro_ptr
	mv s2, a0
	sw s2, -12(s0)
	li s1, 1
	lw s2, -12(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -16
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	addi s2, s0, -16
	mv a0, s1
	mv a1, s2
	jal ra, co_run
	mv s3, a0
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
	.size co_cancel, .Lfunc_end9-co_cancel

	.text
	.align 2
	.type co_reclaim, @function
co_reclaim:
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
	jal ra, coro_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -12(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L10_2
	j .L10_1
.L10_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, co_cancel
	mv s2, a0
.L10_1:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L10_3
	j .L10_4
.L10_3:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L10_4:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gheap_free
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
.Lfunc_end10:
	.size co_reclaim, .Lfunc_end10-co_reclaim

	.text
	.align 2
	.type co_final, @function
co_final:
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
	jal ra, coro_ptr
	mv s2, a0
	li s1, 40
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	li s1, 1
	lw s2, -4(s0)
	mv a0, s2
	jal ra, coro_ptr
	mv s3, a0
	li s2, 52
	add s4, s3, s2
	sw s1, 0(s4)
	j .L11_2
.L11_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, co_reclaim
	mv s2, a0
.L11_2:
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
.Lfunc_end11:
	.size co_final, .Lfunc_end11-co_final

	.data

	.bss
	.align 2
	.globl current
current:
	.space 4
