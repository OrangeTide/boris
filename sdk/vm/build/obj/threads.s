# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type ensure_init, @function
ensure_init:
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
	la s1, inited
	lw s2, 0(s1)
	bnez s2, .L1_0
	j .L1_1
.L1_1:
	li s1, 1
	la s2, inited
	sw s1, 0(s2)
	li s1, 1
	la s2, main_thread
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, main_thread
	la s2, cur
	sw s1, 0(s2)
.L1_0:
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
.Lfunc_end1:
	.size ensure_init, .Lfunc_end1-ensure_init

	.text
	.align 2
	.type rq_push, @function
rq_push:
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
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, rq_tail
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L2_0
	j .L2_1
.L2_0:
	lw s1, -4(s0)
	la s2, rq_tail
	lw s3, 0(s2)
	li s2, 28
	add s4, s3, s2
	sw s1, 0(s4)
	j .L2_2
.L2_1:
	lw s1, -4(s0)
	la s2, rq_head
	sw s1, 0(s2)
.L2_2:
	lw s1, -4(s0)
	la s2, rq_tail
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
.Lfunc_end2:
	.size rq_push, .Lfunc_end2-rq_push

	.text
	.align 2
	.type rq_pop, @function
rq_pop:
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
	la s1, rq_head
	lw s2, 0(s1)
	sw s2, -4(s0)
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, rq_head
	sw s1, 0(s2)
	la s1, rq_head
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_2
	j .L3_3
.L3_2:
	li s1, 0
	la s2, rq_tail
	sw s1, 0(s2)
.L3_3:
	li s1, 0
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
.L3_1:
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
.Lfunc_end3:
	.size rq_pop, .Lfunc_end3-rq_pop

	.text
	.align 2
	.type ready, @function
ready:
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
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	la s2, main_thread
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rq_push
	mv s2, a0
.L4_1:
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
	.size ready, .Lfunc_end4-ready

	.text
	.align 2
	.type wq_push, @function
wq_push:
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
	lw s2, 0(s1)
	sw s2, -12(s0)
	li s1, 0
	lw s2, -8(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_0
	j .L5_1
.L5_0:
	lw s1, -8(s0)
	lw s2, -4(s0)
	sw s1, 0(s2)
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
.L5_1:
.L5_2:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_3
	j .L5_4
.L5_3:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L5_2
.L5_4:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 28
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
.Lfunc_end5:
	.size wq_push, .Lfunc_end5-wq_push

	.text
	.align 2
	.type wq_pop, @function
wq_pop:
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
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L6_0
	j .L6_1
.L6_0:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	sw s1, 0(s2)
	li s1, 0
	lw s2, -12(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
.L6_1:
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
.Lfunc_end6:
	.size wq_pop, .Lfunc_end6-wq_pop

	.text
	.align 2
	.type reap, @function
reap:
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
	la s2, main_thread
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_1
.L7_0:
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
.L7_1:
	lw s1, -4(s0)
	li s2, 4
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
	.size reap, .Lfunc_end7-reap

	.text
	.align 2
	.type run, @function
run:
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
	la s1, cur
	lw s2, 0(s1)
	sw s2, -12(s0)
	lw s1, -4(s0)
	la s2, cur
	sw s1, 0(s2)
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 0
	mv a0, s2
	mv a1, s1
	jal ra, co_resume
	mv s3, a0
	lw s1, -12(s0)
	la s2, cur
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, co_done
	mv s1, a0
	bnez s1, .L8_0
	j .L8_1
.L8_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_2
.L8_0:
	li s1, 3
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
.L8_3:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	mv a0, s3
	jal ra, wq_pop
	mv s1, a0
	sw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L8_4
	j .L8_5
.L8_4:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, ready
	mv s2, a0
	j .L8_3
.L8_5:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L8_6
	j .L8_7
.L8_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, reap
	mv s2, a0
.L8_7:
.L8_2:
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
.Lfunc_end8:
	.size run, .Lfunc_end8-run

	.text
	.align 2
	.type block_current, @function
block_current:
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
	la s1, cur
	lw s2, 0(s1)
	la s1, main_thread
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_0
	j .L9_1
.L9_0:
.L9_2:
	la s1, cur
	lw s2, 0(s1)
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_3
	j .L9_4
.L9_3:
	jal ra, rq_pop
	mv s1, a0
	sw s1, -4(s0)
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_5
	j .L9_6
.L9_5:
	jal ra, abort
	mv s1, a0
.L9_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, run
	mv s2, a0
	j .L9_2
.L9_4:
	li s1, 1
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	j .L9_7
.L9_1:
	li s1, 0
	mv a0, s1
	jal ra, co_yield
	mv s2, a0
	li s1, 1
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
.L9_7:
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
.Lfunc_end9:
	.size block_current, .Lfunc_end9-block_current

	.text
	.align 2
	.type thread_trampoline, @function
thread_trampoline:
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
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	mv t0, s1
	jalr ra, t0, 0
	mv s3, a0
	lw s1, -12(s0)
	li s2, 12
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, run_tss_dtors
	mv s2, a0
	li s1, 3
	lw s2, -12(s0)
	li s3, 8
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
	.size thread_trampoline, .Lfunc_end10-thread_trampoline

	.text
	.align 2
	.globl thrd_create
	.type thrd_create, @function
thrd_create:
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
	li s1, 256
	li s2, 64
	li s3, 1024
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -24(s0)
	jal ra, ensure_init
	mv s1, a0
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	li s1, 2
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
.L11_1:
	li s1, 164
	mv a0, s1
	jal ra, malloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_2
	j .L11_3
.L11_2:
	li s1, 3
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
.L11_3:
	lw s1, -20(s0)
	li s2, 0
	li s3, 164
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, malloc
	mv s2, a0
	lw s1, -20(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_4
	j .L11_5
.L11_4:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 3
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
.L11_5:
	lw s1, -8(s0)
	lw s2, -20(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	la s3, thread_trampoline
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, co_create
	mv s5, a0
	lw s1, -20(s0)
	sw s5, 0(s1)
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_6
	j .L11_7
.L11_6:
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 2
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
.L11_7:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, ready
	mv s2, a0
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L11_8
	j .L11_9
.L11_8:
	lw s1, -20(s0)
	lw s2, -4(s0)
	sw s1, 0(s2)
.L11_9:
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
.Lfunc_end11:
	.size thrd_create, .Lfunc_end11-thrd_create

	.text
	.align 2
	.globl thrd_join
	.type thrd_join, @function
thrd_join:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_0
	j .L12_1
.L12_1:
	lw s1, -4(s0)
	la s2, main_thread
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_0
	j .L12_2
.L12_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_0
	j .L12_3
.L12_0:
	li s1, 2
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
.L12_3:
.L12_4:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_5
	j .L12_6
.L12_5:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	la s1, cur
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s2
	jal ra, wq_push
	mv s1, a0
	li s1, 2
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	jal ra, block_current
	mv s1, a0
	j .L12_4
.L12_6:
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_7
	j .L12_8
.L12_7:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
.L12_8:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, reap
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
.Lfunc_end12:
	.size thrd_join, .Lfunc_end12-thrd_join

	.text
	.align 2
	.globl thrd_detach
	.type thrd_detach, @function
thrd_detach:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_0
	j .L13_1
.L13_1:
	lw s1, -4(s0)
	la s2, main_thread
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_0
	j .L13_2
.L13_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_0
	j .L13_3
.L13_0:
	li s1, 2
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
.L13_3:
	li s1, 1
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_4
	j .L13_5
.L13_4:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, reap
	mv s2, a0
.L13_5:
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
	.size thrd_detach, .Lfunc_end13-thrd_detach

	.text
	.align 2
	.globl thrd_yield
	.type thrd_yield, @function
thrd_yield:
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
	jal ra, ensure_init
	mv s1, a0
	la s1, cur
	lw s2, 0(s1)
	la s1, main_thread
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_0
	j .L14_1
.L14_0:
	jal ra, rq_pop
	mv s1, a0
	sw s1, -4(s0)
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_2
	j .L14_3
.L14_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, run
	mv s2, a0
.L14_3:
	j .L14_4
.L14_1:
	la s1, cur
	lw s2, 0(s1)
	mv a0, s2
	jal ra, ready
	mv s1, a0
	li s1, 0
	mv a0, s1
	jal ra, co_yield
	mv s2, a0
	li s1, 1
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
.L14_4:
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
.Lfunc_end14:
	.size thrd_yield, .Lfunc_end14-thrd_yield

	.text
	.align 2
	.globl thrd_exit
	.type thrd_exit, @function
thrd_exit:
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
	jal ra, ensure_init
	mv s1, a0
	la s1, cur
	lw s2, 0(s1)
	la s1, main_thread
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L15_0
	j .L15_1
.L15_0:
	la s1, cur
	lw s2, 0(s1)
	mv a0, s2
	jal ra, run_tss_dtors
	mv s1, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, exit
	mv s2, a0
.L15_1:
	lw s1, -4(s0)
	la s2, cur
	lw s3, 0(s2)
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, cur
	lw s2, 0(s1)
	mv a0, s2
	jal ra, run_tss_dtors
	mv s1, a0
	li s1, 3
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	mv a0, s1
	jal ra, co_yield
	mv s2, a0
.L15_2:
	j .L15_3
.L15_3:
	li s1, 0
	mv a0, s1
	jal ra, co_yield
	mv s2, a0
.L15_4:
	j .L15_2
.L15_5:
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
	.size thrd_exit, .Lfunc_end15-thrd_exit

	.text
	.align 2
	.globl thrd_current
	.type thrd_current, @function
thrd_current:
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
	jal ra, ensure_init
	mv s1, a0
	la s1, cur
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
.Lfunc_end16:
	.size thrd_current, .Lfunc_end16-thrd_current

	.text
	.align 2
	.globl thrd_equal
	.type thrd_equal, @function
thrd_equal:
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
	xor s3, s1, s2
	seqz s3, s3
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
	.size thrd_equal, .Lfunc_end17-thrd_equal

	.text
	.align 2
	.globl thrd_sleep
	.type thrd_sleep, @function
thrd_sleep:
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
	jal ra, thrd_yield
	mv s1, a0
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
	.size thrd_sleep, .Lfunc_end18-thrd_sleep

	.text
	.align 2
	.globl mtx_init
	.type mtx_init, @function
mtx_init:
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
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 16
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
.Lfunc_end19:
	.size mtx_init, .Lfunc_end19-mtx_init

	.text
	.align 2
	.globl mtx_destroy
	.type mtx_destroy, @function
mtx_destroy:
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
.Lfunc_end20:
	.size mtx_destroy, .Lfunc_end20-mtx_destroy

	.text
	.align 2
	.globl mtx_lock
	.type mtx_lock, @function
mtx_lock:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L21_0
	j .L21_1
.L21_0:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, cur
	lw s3, 0(s2)
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L21_2
	j .L21_1
.L21_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	and s3, s2, s1
	bnez s3, .L21_3
	j .L21_1
.L21_3:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
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
.L21_1:
.L21_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L21_5
	j .L21_6
.L21_5:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	la s1, cur
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s2
	jal ra, wq_push
	mv s1, a0
	li s1, 2
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	jal ra, block_current
	mv s1, a0
	j .L21_4
.L21_6:
	li s1, 1
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, cur
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 1
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
.Lfunc_end21:
	.size mtx_lock, .Lfunc_end21-mtx_lock

	.text
	.align 2
	.globl mtx_trylock
	.type mtx_trylock, @function
mtx_trylock:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L22_0
	j .L22_1
.L22_0:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, cur
	lw s3, 0(s2)
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L22_2
	j .L22_3
.L22_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	and s3, s2, s1
	bnez s3, .L22_4
	j .L22_3
.L22_4:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
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
.L22_3:
	li s1, 1
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
.L22_1:
	li s1, 1
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, cur
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 1
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
.Lfunc_end22:
	.size mtx_trylock, .Lfunc_end22-mtx_trylock

	.text
	.align 2
	.globl mtx_timedlock
	.type mtx_timedlock, @function
mtx_timedlock:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, mtx_trylock
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L23_0
	j .L23_1
.L23_0:
	li s1, 4
	sw s1, -16(s0)
	j .L23_2
.L23_1:
	lw s1, -12(s0)
	sw s1, -16(s0)
.L23_2:
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
.Lfunc_end23:
	.size mtx_timedlock, .Lfunc_end23-mtx_timedlock

	.text
	.align 2
	.globl mtx_unlock
	.type mtx_unlock, @function
mtx_unlock:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	and s3, s2, s1
	bnez s3, .L24_0
	j .L24_1
.L24_0:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, -1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 0
	slt s2, s1, s4
	bnez s2, .L24_2
	j .L24_1
.L24_2:
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
.L24_1:
	li s1, 0
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	mv a0, s3
	jal ra, wq_pop
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L24_3
	j .L24_4
.L24_3:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ready
	mv s2, a0
.L24_4:
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
	.size mtx_unlock, .Lfunc_end24-mtx_unlock

	.text
	.align 2
	.globl cnd_init
	.type cnd_init, @function
cnd_init:
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
.Lfunc_end25:
	.size cnd_init, .Lfunc_end25-cnd_init

	.text
	.align 2
	.globl cnd_destroy
	.type cnd_destroy, @function
cnd_destroy:
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
	.size cnd_destroy, .Lfunc_end26-cnd_destroy

	.text
	.align 2
	.globl cnd_wait
	.type cnd_wait, @function
cnd_wait:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	li s1, 0
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	li s2, 16
	add s3, s1, s2
	mv a0, s3
	jal ra, wq_pop
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L27_0
	j .L27_1
.L27_0:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ready
	mv s2, a0
.L27_1:
	lw s1, -4(s0)
	la s2, cur
	lw s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, wq_push
	mv s2, a0
	li s1, 2
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	jal ra, block_current
	mv s1, a0
.L27_2:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L27_3
	j .L27_4
.L27_3:
	lw s1, -8(s0)
	li s2, 16
	add s3, s1, s2
	la s1, cur
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s2
	jal ra, wq_push
	mv s1, a0
	li s1, 2
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	jal ra, block_current
	mv s1, a0
	j .L27_2
.L27_4:
	li s1, 1
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, cur
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L27_5
	j .L27_6
.L27_5:
	lw s1, -16(s0)
	sw s1, -20(s0)
	j .L27_7
.L27_6:
	li s1, 1
	sw s1, -20(s0)
.L27_7:
	lw s1, -20(s0)
	lw s2, -8(s0)
	li s3, 8
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
.Lfunc_end27:
	.size cnd_wait, .Lfunc_end27-cnd_wait

	.text
	.align 2
	.globl cnd_timedwait
	.type cnd_timedwait, @function
cnd_timedwait:
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
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cnd_wait
	mv s3, a0
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
.Lfunc_end28:
	.size cnd_timedwait, .Lfunc_end28-cnd_timedwait

	.text
	.align 2
	.globl cnd_signal
	.type cnd_signal, @function
cnd_signal:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wq_pop
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L29_0
	j .L29_1
.L29_0:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ready
	mv s2, a0
.L29_1:
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
.Lfunc_end29:
	.size cnd_signal, .Lfunc_end29-cnd_signal

	.text
	.align 2
	.globl cnd_broadcast
	.type cnd_broadcast, @function
cnd_broadcast:
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
	jal ra, ensure_init
	mv s1, a0
.L30_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wq_pop
	mv s2, a0
	sw s2, -12(s0)
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L30_1
	j .L30_2
.L30_1:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ready
	mv s2, a0
	j .L30_0
.L30_2:
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
.Lfunc_end30:
	.size cnd_broadcast, .Lfunc_end30-cnd_broadcast

	.text
	.align 2
	.globl call_once
	.type call_once, @function
call_once:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L31_0
	j .L31_1
.L31_0:
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
.L31_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L31_2
	j .L31_3
.L31_2:
.L31_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 2
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L31_5
	j .L31_6
.L31_5:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	la s1, cur
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s2
	jal ra, wq_push
	mv s1, a0
	li s1, 2
	la s2, cur
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	jal ra, block_current
	mv s1, a0
	j .L31_4
.L31_6:
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
.L31_3:
	li s1, 1
	lw s2, -4(s0)
	sw s1, 0(s2)
	la s1, cur
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -8(s0)
	mv t0, s1
	jalr ra, t0, 0
	mv s2, a0
	li s1, 2
	lw s2, -4(s0)
	sw s1, 0(s2)
.L31_7:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	mv a0, s3
	jal ra, wq_pop
	mv s1, a0
	sw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L31_8
	j .L31_9
.L31_8:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ready
	mv s2, a0
	j .L31_7
.L31_9:
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
.Lfunc_end31:
	.size call_once, .Lfunc_end31-call_once

	.text
	.align 2
	.globl tss_create
	.type tss_create, @function
tss_create:
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
	jal ra, ensure_init
	mv s1, a0
	li s1, 0
	sw s1, -12(s0)
.L32_0:
	lw s1, -12(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L32_1
	j .L32_2
.L32_1:
	la s1, tss_used
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L32_3
	j .L32_4
.L32_4:
	li s1, 1
	la s2, tss_used
	lw s3, -12(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -8(s0)
	la s2, tss_dtors
	lw s3, -12(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -4(s0)
	sw s3, 0(s1)
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
.L32_3:
.L32_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L32_0
.L32_2:
	li s1, 2
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
.Lfunc_end32:
	.size tss_create, .Lfunc_end32-tss_create

	.text
	.align 2
	.globl tss_get
	.type tss_get, @function
tss_get:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L33_0
	j .L33_1
.L33_1:
	lw s1, -4(s0)
	li s2, 32
	slt s3, s2, s1
	bnez s3, .L33_0
	j .L33_2
.L33_0:
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
.L33_2:
	la s1, cur
	lw s2, 0(s1)
	li s1, 36
	add s3, s2, s1
	lw s1, -4(s0)
	li s2, 1
	sub s4, s1, s2
	li s1, 4
	mul s2, s4, s1
	add s1, s3, s2
	lw s2, 0(s1)
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
.Lfunc_end33:
	.size tss_get, .Lfunc_end33-tss_get

	.text
	.align 2
	.globl tss_set
	.type tss_set, @function
tss_set:
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
	jal ra, ensure_init
	mv s1, a0
	lw s1, -4(s0)
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L34_0
	j .L34_1
.L34_1:
	lw s1, -4(s0)
	li s2, 32
	slt s3, s2, s1
	bnez s3, .L34_0
	j .L34_2
.L34_0:
	li s1, 2
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
.L34_2:
	lw s1, -8(s0)
	la s2, cur
	lw s3, 0(s2)
	li s2, 36
	add s4, s3, s2
	lw s2, -4(s0)
	li s3, 1
	sub s5, s2, s3
	li s2, 4
	mul s3, s5, s2
	add s2, s4, s3
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
.Lfunc_end34:
	.size tss_set, .Lfunc_end34-tss_set

	.text
	.align 2
	.globl tss_delete
	.type tss_delete, @function
tss_delete:
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
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L35_0
	j .L35_1
.L35_1:
	lw s1, -4(s0)
	li s2, 32
	slt s3, s2, s1
	bnez s3, .L35_0
	j .L35_2
.L35_0:
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
.L35_2:
	li s1, 0
	la s2, tss_used
	lw s3, -4(s0)
	li s4, 1
	sub s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	sw s1, 0(s3)
	li s1, 0
	la s2, tss_dtors
	lw s3, -4(s0)
	li s4, 1
	sub s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
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
.Lfunc_end35:
	.size tss_delete, .Lfunc_end35-tss_delete

	.text
	.align 2
	.type run_tss_dtors, @function
run_tss_dtors:
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
	li s1, 0
	sw s1, -12(s0)
.L36_0:
	lw s1, -12(s0)
	li s2, 4
	slt s3, s1, s2
	bnez s3, .L36_1
	j .L36_2
.L36_1:
	li s1, 0
	sw s1, -20(s0)
	li s1, 0
	sw s1, -16(s0)
.L36_3:
	lw s1, -16(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L36_4
	j .L36_5
.L36_4:
	la s1, tss_used
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L36_6
	j .L36_7
.L36_6:
	la s1, tss_dtors
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L36_8
	j .L36_7
.L36_8:
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, -16(s0)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L36_9
	j .L36_7
.L36_9:
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, -16(s0)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	sw s2, -24(s0)
	li s1, 0
	lw s2, -4(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, -16(s0)
	li s3, 4
	mul s5, s2, s3
	add s2, s4, s5
	sw s1, 0(s2)
	la s1, tss_dtors
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -24(s0)
	mv a0, s2
	mv t0, s1
	jalr ra, t0, 0
	mv s3, a0
	li s1, 1
	sw s1, -20(s0)
.L36_7:
.L36_10:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L36_3
.L36_5:
	lw s1, -20(s0)
	bnez s1, .L36_11
	j .L36_12
.L36_12:
	j .L36_2
.L36_11:
.L36_13:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L36_0
.L36_2:
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
.Lfunc_end36:
	.size run_tss_dtors, .Lfunc_end36-run_tss_dtors

	.data

	.bss
	.align 2
	.globl tss_used
tss_used:
	.space 128
	.align 2
	.globl tss_dtors
tss_dtors:
	.space 128
	.align 2
	.globl inited
inited:
	.space 4
	.align 2
	.globl rq_tail
rq_tail:
	.space 4
	.align 2
	.globl rq_head
rq_head:
	.space 4
	.align 2
	.globl cur
cur:
	.space 4
	.align 2
	.globl main_thread
main_thread:
	.space 164
