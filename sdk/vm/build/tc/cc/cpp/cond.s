# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl cond_push
	.type cond_push, @function
cond_push:
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
	li s1, 16
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -8(s0)
	bnez s1, .L1_0
	j .L1_1
.L1_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cond_active
	mv s2, a0
	bnez s2, .L1_2
	j .L1_1
.L1_2:
	li s1, 1
	j .L1_3
.L1_1:
	li s1, 0
.L1_3:
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 1024
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
.Lfunc_end1:
	.size cond_push, .Lfunc_end1-cond_push

	.text
	.align 2
	.globl cond_pop
	.type cond_pop, @function
cond_pop:
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
	bnez s1, .L2_0
	j .L2_1
.L2_1:
	lw s1, -4(s0)
	la s2, __str_0
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
.L2_0:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 1024
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end2:
	.size cond_pop, .Lfunc_end2-cond_pop

	.text
	.align 2
	.globl cond_active
	.type cond_active, @function
cond_active:
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
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_0
	j .L3_1
.L3_1:
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
.L3_0:
	lw s1, -4(s0)
	li s2, 1024
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end3:
	.size cond_active, .Lfunc_end3-cond_active

	.text
	.align 2
	.type eval_advance, @function
eval_advance:
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
	bnez s1, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
.L4_1:
.L4_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_3
	j .L4_4
.L4_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_5
	j .L4_4
.L4_5:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	j .L4_2
.L4_4:
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
	.size eval_advance, .Lfunc_end4-eval_advance

	.text
	.align 2
	.type eval_primary, @function
eval_primary:
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
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_0
	j .L5_1
.L5_1:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L5_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_2
	j .L5_3
.L5_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 7
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_4
	j .L5_3
.L5_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_1
	li s3, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L5_5
	j .L5_3
.L5_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	li s1, 0
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_6
	j .L5_7
.L5_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_8
	j .L5_7
.L5_8:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_9
	j .L5_7
.L5_9:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_10
	j .L5_7
.L5_10:
	li s1, 1
	sw s1, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
.L5_7:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_11
	j .L5_12
.L5_11:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_13
	j .L5_12
.L5_13:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, macro_lookup
	mv s3, a0
	bnez s3, .L5_14
	j .L5_15
.L5_14:
	li s1, 1
	sw s1, -28(s0)
	j .L5_16
.L5_15:
	li s1, 0
	sw s1, -28(s0)
.L5_16:
	lw s1, -28(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
.L5_12:
	lw s1, -12(s0)
	bnez s1, .L5_17
	j .L5_18
.L5_17:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_19
	j .L5_18
.L5_19:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_20
	j .L5_18
.L5_20:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_21
	j .L5_18
.L5_21:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 41
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_22
	j .L5_18
.L5_22:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
.L5_18:
	lw s10, -24(s0)
	lw s11, -20(s0)
	mv a0, s10
	mv a1, s11
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
.L5_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_23
	j .L5_24
.L5_23:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -32
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoll
	mv s10, a0
	mv s11, a1
	sw s10, -40(s0)
	sw s11, -36(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s10, -40(s0)
	lw s11, -36(s0)
	mv a0, s10
	mv a1, s11
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
.L5_24:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_25
	j .L5_26
.L5_25:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	lw s1, -52(s0)
	lb s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_27
	j .L5_28
.L5_27:
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -52(s0)
	lw s1, -52(s0)
	lb s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_29
	j .L5_30
.L5_29:
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -52(s0)
	lw s1, -52(s0)
	lb s2, 0(s1)
	li s1, 110
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_31
	li s1, 116
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_32
	li s1, 114
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_33
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_34
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_35
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_36
	li s1, 97
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_37
	li s1, 98
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_38
	li s1, 102
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_39
	li s1, 118
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_40
	li s1, 120
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_41
	j .L5_42
.L5_31:
	li s1, 10
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_32:
	li s1, 9
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_33:
	li s1, 13
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_34:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_35:
	li s1, 92
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_36:
	li s1, 39
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_37:
	li s1, 7
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_38:
	li s1, 8
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_39:
	li s1, 12
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_40:
	li s1, 11
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_41:
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	li s3, 16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoll
	mv s10, a0
	mv s11, a1
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L5_43
.L5_42:
	lw s1, -52(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L5_44
	j .L5_45
.L5_44:
	lw s1, -52(s0)
	lb s2, 0(s1)
	li s1, 55
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_46
	j .L5_45
.L5_46:
	lw s1, -52(s0)
	li s2, 0
	li s3, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoll
	mv s10, a0
	mv s11, a1
	sw s10, -48(s0)
	sw s11, -44(s0)
.L5_45:
	j .L5_43
.L5_43:
	j .L5_47
.L5_30:
	lw s1, -52(s0)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv s10, s3
	li s11, 0
	sw s10, -48(s0)
	sw s11, -44(s0)
.L5_47:
.L5_28:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s10, -48(s0)
	lw s11, -44(s0)
	mv a0, s10
	mv a1, s11
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
.L5_26:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_48
	j .L5_49
.L5_48:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_50
	j .L5_49
.L5_50:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_51
	j .L5_49
.L5_51:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_ternary
	mv s10, a0
	mv s11, a1
	sw s10, -64(s0)
	sw s11, -60(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_52
	j .L5_53
.L5_52:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_54
	j .L5_53
.L5_54:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_55
	j .L5_53
.L5_55:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 41
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_56
	j .L5_53
.L5_56:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
.L5_53:
	lw s10, -64(s0)
	lw s11, -60(s0)
	mv a0, s10
	mv a1, s11
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
.L5_49:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_57
	j .L5_58
.L5_57:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L5_58:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.Lfunc_end5:
	.size eval_primary, .Lfunc_end5-eval_primary

	.text
	.align 2
	.type eval_unary, @function
eval_unary:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L6_0
	j .L6_1
.L6_1:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L6_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_2
	j .L6_3
.L6_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_4
	j .L6_3
.L6_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	sw s1, -12(s0)
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 33
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_5
	j .L6_6
.L6_6:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 126
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_5
	j .L6_7
.L6_7:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_5
	j .L6_8
.L6_8:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_5
	j .L6_9
.L6_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_unary
	mv s10, a0
	mv s11, a1
	sw s10, -24(s0)
	sw s11, -20(s0)
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 33
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_10
	li s1, 126
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_11
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_12
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_13
	j .L6_14
.L6_10:
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s8, 0
	li s9, 0
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	srai t1, s1, 31
	mv a0, s1
	mv a1, t1
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
.L6_11:
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s8, -1
	li s9, -1
	xor s6, s10, s8
	xor s7, s11, s9
	mv a0, s6
	mv a1, s7
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
.L6_12:
	li s10, 0
	li s11, 0
	lw s8, -24(s0)
	lw s9, -20(s0)
	sltu t0, s10, s8
	sub s6, s10, s8
	sub s7, s11, t0
	sub s7, s7, s9
	mv a0, s6
	mv a1, s7
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
.L6_13:
	lw s10, -24(s0)
	lw s11, -20(s0)
	mv a0, s10
	mv a1, s11
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
.L6_14:
.L6_9:
.L6_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_primary
	mv s10, a0
	mv s11, a1
	mv a0, s10
	mv a1, s11
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
	.size eval_unary, .Lfunc_end6-eval_unary

	.text
	.align 2
	.type eval_mul, @function
eval_mul:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_unary
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L7_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L7_1
	j .L7_2
.L7_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_3
	j .L7_2
.L7_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_4
	j .L7_2
.L7_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	sw s1, -20(s0)
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L7_5
	j .L7_6
.L7_5:
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L7_7
	j .L7_6
.L7_7:
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L7_8
	j .L7_6
.L7_8:
	j .L7_2
.L7_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_unary
	mv s10, a0
	mv s11, a1
	sw s10, -32(s0)
	sw s11, -28(s0)
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_9
	j .L7_10
.L7_9:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -32(s0)
	lw s9, -28(s0)
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
	j .L7_11
.L7_10:
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_12
	j .L7_13
.L7_12:
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s1, t0
	bnez s1, .L7_14
	j .L7_13
.L7_14:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s8, -1
	li s9, 2147483647
	neg s6, s8
	snez t0, s8
	neg s7, s9
	sub s7, s7, t0
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	sltu t0, s6, s8
	sub s4, s6, s8
	sub s5, s7, t0
	sub s5, s5, s9
	xor t0, s10, s4
	xor t1, s11, s5
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L7_15
	j .L7_16
.L7_15:
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s1, 1
	neg s2, s1
	mv s8, s2
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L7_17
	j .L7_16
.L7_17:
	li s10, -1
	li s11, 2147483647
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	li s1, 1
	mv s10, s1
	srai s11, s10, 31
	sltu t0, s8, s10
	sub s6, s8, s10
	sub s7, s9, t0
	sub s7, s7, s11
	sw s6, -40(s0)
	sw s7, -36(s0)
	j .L7_18
.L7_16:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -32(s0)
	lw s9, -28(s0)
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __divdi3
	mv s6, a0
	mv s7, a1
	sw s6, -40(s0)
	sw s7, -36(s0)
.L7_18:
	lw s10, -40(s0)
	lw s11, -36(s0)
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L7_19
.L7_13:
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_20
	j .L7_21
.L7_20:
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s1, t0
	bnez s1, .L7_22
	j .L7_21
.L7_22:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s8, -1
	li s9, 2147483647
	neg s6, s8
	snez t0, s8
	neg s7, s9
	sub s7, s7, t0
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	sltu t0, s6, s8
	sub s4, s6, s8
	sub s5, s7, t0
	sub s5, s5, s9
	xor t0, s10, s4
	xor t1, s11, s5
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L7_23
	j .L7_24
.L7_23:
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s1, 1
	neg s2, s1
	mv s8, s2
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L7_25
	j .L7_24
.L7_25:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L7_26
.L7_24:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -32(s0)
	lw s9, -28(s0)
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __moddi3
	mv s6, a0
	mv s7, a1
	sw s6, -48(s0)
	sw s7, -44(s0)
.L7_26:
	lw s10, -48(s0)
	lw s11, -44(s0)
	sw s10, -16(s0)
	sw s11, -12(s0)
.L7_21:
.L7_19:
.L7_11:
	j .L7_0
.L7_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end7:
	.size eval_mul, .Lfunc_end7-eval_mul

	.text
	.align 2
	.type eval_add, @function
eval_add:
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
	mv a0, s1
	jal ra, eval_mul
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L8_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L8_1
	j .L8_2
.L8_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L8_3
	j .L8_2
.L8_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_4
	j .L8_2
.L8_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	sw s1, -20(s0)
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L8_5
	j .L8_6
.L8_5:
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L8_7
	j .L8_6
.L8_7:
	j .L8_2
.L8_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_mul
	mv s10, a0
	mv s11, a1
	sw s10, -32(s0)
	sw s11, -28(s0)
	addi s1, s0, -20
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L8_8
	j .L8_9
.L8_8:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -32(s0)
	lw s9, -28(s0)
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -16(s0)
	sw s7, -12(s0)
	j .L8_10
.L8_9:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -32(s0)
	lw s9, -28(s0)
	sltu t0, s10, s8
	sub s6, s10, s8
	sub s7, s11, t0
	sub s7, s7, s9
	sw s6, -16(s0)
	sw s7, -12(s0)
.L8_10:
	j .L8_0
.L8_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end8:
	.size eval_add, .Lfunc_end8-eval_add

	.text
	.align 2
	.type eval_shift, @function
eval_shift:
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
	mv a0, s1
	jal ra, eval_add
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L9_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L9_1
	j .L9_2
.L9_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_3
	j .L9_2
.L9_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_4
	j .L9_2
.L9_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_2
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L9_5
	j .L9_6
.L9_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_add
	mv s10, a0
	mv s11, a1
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L9_7
	sltu s1, s10, s8
.L9_7:
	bnez s1, .L9_8
	j .L9_9
.L9_9:
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 64
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L9_10
	sltu s1, s10, s8
.L9_10:
	xori s1, s1, 1
	bnez s1, .L9_8
	j .L9_11
.L9_8:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L9_12
.L9_11:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s8, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	sw s6, -16(s0)
	sw s7, -12(s0)
.L9_12:
	j .L9_13
.L9_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_3
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L9_14
	j .L9_15
.L9_14:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_add
	mv s10, a0
	mv s11, a1
	sw s10, -32(s0)
	sw s11, -28(s0)
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L9_16
	sltu s1, s10, s8
.L9_16:
	bnez s1, .L9_17
	j .L9_18
.L9_18:
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s1, 64
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L9_19
	sltu s1, s10, s8
.L9_19:
	xori s1, s1, 1
	bnez s1, .L9_17
	j .L9_20
.L9_17:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L9_21
	sltu s1, s10, s8
.L9_21:
	bnez s1, .L9_22
	j .L9_23
.L9_22:
	li s1, 1
	neg s2, s1
	sw s2, -36(s0)
	j .L9_24
.L9_23:
	li s1, 0
	sw s1, -36(s0)
.L9_24:
	lw s1, -36(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L9_25
.L9_20:
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s8, -32(s0)
	lw s9, -28(s0)
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s8, 0(sp)
	jal ra, __ashrdi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	sw s6, -16(s0)
	sw s7, -12(s0)
.L9_25:
	j .L9_26
.L9_15:
	j .L9_2
.L9_26:
.L9_13:
	j .L9_0
.L9_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
	.size eval_shift, .Lfunc_end9-eval_shift

	.text
	.align 2
	.type eval_relational, @function
eval_relational:
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
	jal ra, eval_shift
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L10_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L10_1
	j .L10_2
.L10_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L10_3
	j .L10_2
.L10_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_4
	j .L10_5
.L10_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_4
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L10_6
	j .L10_5
.L10_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_shift
	mv s8, a0
	mv s9, a1
	slt s1, s9, s11
	bne s9, s11, .L10_7
	sltu s1, s8, s10
.L10_7:
	xori s1, s1, 1
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L10_8
.L10_5:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_9
	j .L10_10
.L10_9:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_5
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L10_11
	j .L10_10
.L10_11:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_shift
	mv s8, a0
	mv s9, a1
	slt s1, s11, s9
	bne s11, s9, .L10_12
	sltu s1, s10, s8
.L10_12:
	xori s1, s1, 1
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L10_13
.L10_10:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_14
	j .L10_15
.L10_14:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 60
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_16
	j .L10_15
.L10_16:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_shift
	mv s8, a0
	mv s9, a1
	slt s1, s11, s9
	bne s11, s9, .L10_17
	sltu s1, s10, s8
.L10_17:
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L10_18
.L10_15:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_19
	j .L10_20
.L10_19:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 62
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_21
	j .L10_20
.L10_21:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_shift
	mv s8, a0
	mv s9, a1
	slt s1, s9, s11
	bne s9, s11, .L10_22
	sltu s1, s8, s10
.L10_22:
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L10_23
.L10_20:
	j .L10_2
.L10_23:
.L10_18:
.L10_13:
.L10_8:
	j .L10_0
.L10_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
	.size eval_relational, .Lfunc_end10-eval_relational

	.text
	.align 2
	.type eval_equality, @function
eval_equality:
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
	jal ra, eval_relational
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L11_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L11_1
	j .L11_2
.L11_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_3
	j .L11_2
.L11_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_4
	j .L11_2
.L11_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_6
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L11_5
	j .L11_6
.L11_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_relational
	mv s8, a0
	mv s9, a1
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L11_7
.L11_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_7
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L11_8
	j .L11_9
.L11_8:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_relational
	mv s8, a0
	mv s9, a1
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s1, t0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	j .L11_10
.L11_9:
	j .L11_2
.L11_10:
.L11_7:
	j .L11_0
.L11_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end11:
	.size eval_equality, .Lfunc_end11-eval_equality

	.text
	.align 2
	.type eval_bitand, @function
eval_bitand:
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
	jal ra, eval_equality
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L12_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_1
	j .L12_2
.L12_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_3
	j .L12_2
.L12_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_4
	j .L12_2
.L12_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 38
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_5
	j .L12_2
.L12_5:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_6
	j .L12_7
.L12_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_8
	j .L12_7
.L12_8:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_9
	j .L12_7
.L12_9:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 38
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_10
	j .L12_7
.L12_10:
	j .L12_2
.L12_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_equality
	mv s8, a0
	mv s9, a1
	and s6, s10, s8
	and s7, s11, s9
	sw s6, -16(s0)
	sw s7, -12(s0)
	j .L12_0
.L12_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
	.size eval_bitand, .Lfunc_end12-eval_bitand

	.text
	.align 2
	.type eval_bitxor, @function
eval_bitxor:
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
	jal ra, eval_bitand
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L13_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_1
	j .L13_2
.L13_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_3
	j .L13_2
.L13_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_4
	j .L13_2
.L13_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 94
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_5
	j .L13_2
.L13_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_bitand
	mv s8, a0
	mv s9, a1
	xor s6, s10, s8
	xor s7, s11, s9
	sw s6, -16(s0)
	sw s7, -12(s0)
	j .L13_0
.L13_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end13:
	.size eval_bitxor, .Lfunc_end13-eval_bitxor

	.text
	.align 2
	.type eval_bitor, @function
eval_bitor:
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
	jal ra, eval_bitxor
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L14_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_1
	j .L14_2
.L14_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_3
	j .L14_2
.L14_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_4
	j .L14_2
.L14_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 124
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_5
	j .L14_2
.L14_5:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_6
	j .L14_7
.L14_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_8
	j .L14_7
.L14_8:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_9
	j .L14_7
.L14_9:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 124
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_10
	j .L14_7
.L14_10:
	j .L14_2
.L14_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_bitxor
	mv s8, a0
	mv s9, a1
	or s6, s10, s8
	or s7, s11, s9
	sw s6, -16(s0)
	sw s7, -12(s0)
	j .L14_0
.L14_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
	.size eval_bitor, .Lfunc_end14-eval_bitor

	.text
	.align 2
	.type eval_logand, @function
eval_logand:
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
	mv a0, s1
	jal ra, eval_bitor
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L15_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L15_1
	j .L15_2
.L15_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L15_3
	j .L15_2
.L15_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_4
	j .L15_2
.L15_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_8
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L15_5
	j .L15_2
.L15_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_bitor
	mv s10, a0
	mv s11, a1
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L15_6
	j .L15_7
.L15_6:
	lw s10, -24(s0)
	lw s11, -20(s0)
	bnez s10, .L15_8
	j .L15_7
.L15_8:
	li s1, 1
	j .L15_9
.L15_7:
	li s1, 0
.L15_9:
	sw s1, -16(s0)
	srai t1, s1, 31
	sw t1, -12(s0)
	j .L15_0
.L15_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end15:
	.size eval_logand, .Lfunc_end15-eval_logand

	.text
	.align 2
	.type eval_logor, @function
eval_logor:
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
	mv a0, s1
	jal ra, eval_logand
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
.L16_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L16_1
	j .L16_2
.L16_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L16_3
	j .L16_2
.L16_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_4
	j .L16_2
.L16_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_9
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L16_5
	j .L16_2
.L16_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_logand
	mv s10, a0
	mv s11, a1
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L16_6
	j .L16_7
.L16_7:
	lw s10, -24(s0)
	lw s11, -20(s0)
	bnez s10, .L16_6
	j .L16_8
.L16_6:
	li s1, 1
	j .L16_9
.L16_8:
	li s1, 0
.L16_9:
	sw s1, -16(s0)
	srai t1, s1, 31
	sw t1, -12(s0)
	j .L16_0
.L16_2:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end16:
	.size eval_logor, .Lfunc_end16-eval_logor

	.text
	.align 2
	.type eval_ternary, @function
eval_ternary:
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
	mv a0, s1
	jal ra, eval_logor
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L17_0
	j .L17_1
.L17_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_2
	j .L17_1
.L17_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L17_3
	j .L17_1
.L17_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 63
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L17_4
	j .L17_1
.L17_4:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_ternary
	mv s10, a0
	mv s11, a1
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L17_5
	j .L17_6
.L17_5:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_7
	j .L17_6
.L17_7:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L17_8
	j .L17_6
.L17_8:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 58
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L17_9
	j .L17_6
.L17_9:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_advance
	mv s2, a0
.L17_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, eval_ternary
	mv s10, a0
	mv s11, a1
	sw s10, -32(s0)
	sw s11, -28(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L17_10
	j .L17_11
.L17_10:
	lw s10, -24(s0)
	lw s11, -20(s0)
	sw s10, -40(s0)
	sw s11, -36(s0)
	j .L17_12
.L17_11:
	lw s10, -32(s0)
	lw s11, -28(s0)
	sw s10, -40(s0)
	sw s11, -36(s0)
.L17_12:
	lw s10, -40(s0)
	lw s11, -36(s0)
	sw s10, -16(s0)
	sw s11, -12(s0)
.L17_1:
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end17:
	.size eval_ternary, .Lfunc_end17-eval_ternary

	.text
	.align 2
	.type protect_defined, @function
protect_defined:
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
	sw s1, -12(s0)
.L18_0:
	lw s1, -12(s0)
	bnez s1, .L18_1
	j .L18_2
.L18_1:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L18_3
	j .L18_4
.L18_4:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 7
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L18_3
	j .L18_5
.L18_5:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_10
	li s3, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L18_3
	j .L18_6
.L18_3:
	j .L18_7
.L18_6:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
.L18_8:
	lw s1, -16(s0)
	bnez s1, .L18_9
	j .L18_10
.L18_9:
	lw s1, -16(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_11
	j .L18_10
.L18_11:
	lw s1, -16(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L18_8
.L18_10:
	lw s1, -16(s0)
	bnez s1, .L18_12
	j .L18_13
.L18_13:
	j .L18_2
.L18_12:
	lw s1, -16(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_14
	j .L18_15
.L18_14:
	lw s1, -16(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_16
	j .L18_15
.L18_16:
	lw s1, -16(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_17
	j .L18_15
.L18_17:
	lw s1, -16(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
.L18_18:
	lw s1, -20(s0)
	bnez s1, .L18_19
	j .L18_20
.L18_19:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_21
	j .L18_20
.L18_21:
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L18_18
.L18_20:
	lw s1, -20(s0)
	bnez s1, .L18_22
	j .L18_23
.L18_22:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_24
	j .L18_23
.L18_24:
	li s1, 1
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L18_23:
	j .L18_25
.L18_15:
	lw s1, -16(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_26
	j .L18_27
.L18_26:
	li s1, 1
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L18_27:
.L18_25:
.L18_7:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L18_0
.L18_2:
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
	.size protect_defined, .Lfunc_end18-protect_defined

	.text
	.align 2
	.globl cond_eval
	.type cond_eval, @function
cond_eval:
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
	mv a0, s1
	jal ra, protect_defined
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, macro_expand
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	addi s2, s0, -24
	sw s1, 0(s2)
	lw s1, -12(s0)
	addi s2, s0, -24
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
.L19_0:
	addi s1, s0, -24
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L19_1
	j .L19_2
.L19_1:
	addi s1, s0, -24
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_3
	j .L19_2
.L19_3:
	addi s1, s0, -24
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -24
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	j .L19_0
.L19_2:
	addi s1, s0, -24
	mv a0, s1
	jal ra, eval_ternary
	mv s10, a0
	mv s11, a1
	sw s10, -32(s0)
	sw s11, -28(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, pp_free_tokens
	mv s2, a0
	lw s10, -32(s0)
	lw s11, -28(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end19:
	.size cond_eval, .Lfunc_end19-cond_eval

	.data
	.align 2
__str_10:
	.ascii "defined\000"
	.align 2
__str_9:
	.ascii "||\000"
	.align 2
__str_8:
	.ascii "&&\000"
	.align 2
__str_7:
	.ascii "!=\000"
	.align 2
__str_6:
	.ascii "==\000"
	.align 2
__str_5:
	.ascii ">=\000"
	.align 2
__str_4:
	.ascii "<=\000"
	.align 2
__str_3:
	.ascii ">>\000"
	.align 2
__str_2:
	.ascii "<<\000"
	.align 2
__str_1:
	.ascii "defined\000"
	.align 2
__str_0:
	.ascii "unmatched #endif\000"
