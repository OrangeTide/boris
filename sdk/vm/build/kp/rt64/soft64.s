# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type udivmod64, @function
udivmod64:
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	sw a2, -16(s0)
	sw a3, -12(s0)
	sw a4, -20(s0)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -32(s0)
	sw s11, -28(s0)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -40(s0)
	sw s11, -36(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L1_0
	j .L1_1
.L1_0:
	li s1, 0
	lw s2, -20(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
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
.L1_1:
	li s1, 0
	sw s1, -44(s0)
.L1_2:
	lw s1, -44(s0)
	li s2, 64
	slt s3, s1, s2
	bnez s3, .L1_3
	j .L1_4
.L1_3:
	lw s10, -40(s0)
	lw s11, -36(s0)
	li s1, 1
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	lw s10, -8(s0)
	lw s11, -4(s0)
	li s1, 63
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	or s10, s8, s6
	or s11, s9, s7
	sw s10, -40(s0)
	sw s11, -36(s0)
	addi s1, s0, -8
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 1
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	sw s8, -8(s0)
	sw s9, -4(s0)
	addi s1, s0, -32
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 1
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	sw s8, -32(s0)
	sw s9, -28(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw s8, -16(s0)
	lw s9, -12(s0)
	sltu s1, s11, s9
	bne s11, s9, .L1_5
	sltu s1, s10, s8
.L1_5:
	xori s1, s1, 1
	bnez s1, .L1_6
	j .L1_7
.L1_6:
	addi s1, s0, -40
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s8, -16(s0)
	lw s9, -12(s0)
	sltu t0, s10, s8
	sub s6, s10, s8
	sub s7, s11, t0
	sub s7, s7, s9
	sw s6, -40(s0)
	sw s7, -36(s0)
	addi s1, s0, -32
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 1
	mv s8, s1
	li s9, 0
	or s6, s10, s8
	or s7, s11, s9
	sw s6, -32(s0)
	sw s7, -28(s0)
.L1_7:
.L1_8:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L1_2
.L1_4:
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw s1, -20(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	lw s10, -32(s0)
	lw s11, -28(s0)
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
.Lfunc_end1:
	.size udivmod64, .Lfunc_end1-udivmod64

	.text
	.align 2
	.globl __udivdi3
	.type __udivdi3, @function
__udivdi3:
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	sw a2, -16(s0)
	sw a3, -12(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	lw s8, -16(s0)
	lw s9, -12(s0)
	addi s1, s0, -24
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	mv a4, s1
	jal ra, udivmod64
	mv s6, a0
	mv s7, a1
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
.Lfunc_end2:
	.size __udivdi3, .Lfunc_end2-__udivdi3

	.text
	.align 2
	.globl __umoddi3
	.type __umoddi3, @function
__umoddi3:
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	sw a2, -16(s0)
	sw a3, -12(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	lw s8, -16(s0)
	lw s9, -12(s0)
	addi s1, s0, -24
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	mv a4, s1
	jal ra, udivmod64
	mv s6, a0
	mv s7, a1
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
.Lfunc_end3:
	.size __umoddi3, .Lfunc_end3-__umoddi3

	.text
	.align 2
	.globl __divdi3
	.type __divdi3, @function
__divdi3:
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	sw a2, -16(s0)
	sw a3, -12(s0)
	li s1, 0
	sw s1, -20(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L4_0
	sltu s1, s10, s8
.L4_0:
	bnez s1, .L4_1
	j .L4_2
.L4_1:
	lw s10, -8(s0)
	lw s11, -4(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -32(s0)
	sw s9, -28(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -20(s0)
	j .L4_3
.L4_2:
	lw s10, -8(s0)
	lw s11, -4(s0)
	sw s10, -32(s0)
	sw s11, -28(s0)
.L4_3:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L4_4
	sltu s1, s10, s8
.L4_4:
	bnez s1, .L4_5
	j .L4_6
.L4_5:
	lw s10, -16(s0)
	lw s11, -12(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -40(s0)
	sw s9, -36(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -20(s0)
	j .L4_7
.L4_6:
	lw s10, -16(s0)
	lw s11, -12(s0)
	sw s10, -40(s0)
	sw s11, -36(s0)
.L4_7:
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s8, -40(s0)
	lw s9, -36(s0)
	addi s1, s0, -56
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	mv a4, s1
	jal ra, udivmod64
	mv s6, a0
	mv s7, a1
	sw s6, -48(s0)
	sw s7, -44(s0)
	lw s1, -20(s0)
	bnez s1, .L4_8
	j .L4_9
.L4_8:
	lw s10, -48(s0)
	lw s11, -44(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -64(s0)
	sw s9, -60(s0)
	j .L4_10
.L4_9:
	lw s10, -48(s0)
	lw s11, -44(s0)
	sw s10, -64(s0)
	sw s11, -60(s0)
.L4_10:
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
.Lfunc_end4:
	.size __divdi3, .Lfunc_end4-__divdi3

	.text
	.align 2
	.globl __moddi3
	.type __moddi3, @function
__moddi3:
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	sw a2, -16(s0)
	sw a3, -12(s0)
	li s1, 0
	sw s1, -20(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L5_0
	sltu s1, s10, s8
.L5_0:
	bnez s1, .L5_1
	j .L5_2
.L5_1:
	lw s10, -8(s0)
	lw s11, -4(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -32(s0)
	sw s9, -28(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L5_3
.L5_2:
	lw s10, -8(s0)
	lw s11, -4(s0)
	sw s10, -32(s0)
	sw s11, -28(s0)
.L5_3:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L5_4
	sltu s1, s10, s8
.L5_4:
	bnez s1, .L5_5
	j .L5_6
.L5_5:
	lw s10, -16(s0)
	lw s11, -12(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -40(s0)
	sw s9, -36(s0)
	j .L5_7
.L5_6:
	lw s10, -16(s0)
	lw s11, -12(s0)
	sw s10, -40(s0)
	sw s11, -36(s0)
.L5_7:
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s8, -40(s0)
	lw s9, -36(s0)
	addi s1, s0, -48
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	mv a4, s1
	jal ra, udivmod64
	mv s6, a0
	mv s7, a1
	lw s1, -20(s0)
	bnez s1, .L5_8
	j .L5_9
.L5_8:
	lw s10, -48(s0)
	lw s11, -44(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -56(s0)
	sw s9, -52(s0)
	j .L5_10
.L5_9:
	lw s10, -48(s0)
	lw s11, -44(s0)
	sw s10, -56(s0)
	sw s11, -52(s0)
.L5_10:
	lw s10, -56(s0)
	lw s11, -52(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end5:
	.size __moddi3, .Lfunc_end5-__moddi3

	.data
