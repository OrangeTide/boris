# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

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
.L1_0:
	j .L1_1
.L1_1:
.L1_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L1_3
	j .L1_4
.L1_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isspace
	mv s1, a0
	bnez s1, .L1_5
	j .L1_4
.L1_5:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_6
	j .L1_7
.L1_6:
	lw s1, -4(s0)
	li s2, 272
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L1_7:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L1_2
.L1_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_8
	j .L1_9
.L1_8:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_10
	j .L1_9
.L1_10:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	add s4, s1, s2
	sw s4, 0(s3)
.L1_11:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L1_12
	j .L1_13
.L1_12:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_14
	j .L1_15
.L1_14:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_13
	j .L1_15
.L1_15:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_16
	j .L1_17
.L1_16:
	lw s1, -4(s0)
	li s2, 272
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L1_17:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L1_11
.L1_13:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L1_18
	j .L1_19
.L1_18:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	add s4, s1, s2
	sw s4, 0(s3)
.L1_19:
	j .L1_20
.L1_9:
	j .L1_21
.L1_20:
	j .L1_0
.L1_21:
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
	.size skip_ws, .Lfunc_end1-skip_ws

	.text
	.align 2
	.type is_ident_start, @function
is_ident_start:
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
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isalpha
	mv s1, a0
	bnez s1, .L2_0
	j .L2_1
.L2_1:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L2_0
	j .L2_2
.L2_0:
	li s1, 1
	j .L2_3
.L2_2:
	li s1, 0
.L2_3:
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
	.size is_ident_start, .Lfunc_end2-is_ident_start

	.text
	.align 2
	.type is_ident_char, @function
is_ident_char:
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
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isalnum
	mv s1, a0
	bnez s1, .L3_0
	j .L3_1
.L3_1:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_0
	j .L3_2
.L3_0:
	li s1, 1
	j .L3_3
.L3_2:
	li s1, 0
.L3_3:
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
	.size is_ident_char, .Lfunc_end3-is_ident_char

	.text
	.align 2
	.type next, @function
next:
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
	jal ra, skip_ws
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L4_0
	j .L4_1
.L4_1:
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
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
.L4_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	sw s2, -12(s0)
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_2
	j .L4_3
.L4_2:
	li s1, 4
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_3:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_4
	j .L4_5
.L4_4:
	li s1, 5
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_5:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 123
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_6
	j .L4_7
.L4_6:
	li s1, 6
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_7:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 125
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_8
	j .L4_9
.L4_8:
	li s1, 7
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_9:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 58
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_10
	j .L4_11
.L4_10:
	li s1, 8
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_11:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_12
	j .L4_13
.L4_12:
	li s1, 9
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_13:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 59
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_14
	j .L4_15
.L4_14:
	li s1, 10
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_15:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 62
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_16
	j .L4_17
.L4_16:
	li s1, 11
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_17:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_18
	j .L4_19
.L4_18:
	li s1, 12
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_19:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_20
	j .L4_21
.L4_20:
	li s1, 14
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_21:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_22
	j .L4_23
.L4_22:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	mv a0, s1
	jal ra, is_ident_char
	mv s2, a0
	bnez s2, .L4_24
	j .L4_25
.L4_24:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L4_26:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, is_ident_char
	mv s1, a0
	bnez s1, .L4_27
	j .L4_28
.L4_28:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_27
	j .L4_29
.L4_27:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L4_26
.L4_29:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 1
	add s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L4_30
	j .L4_31
.L4_30:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	neg s3, s2
	add s2, s1, s3
	lb s1, 0(s2)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_32
	j .L4_31
.L4_32:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_33
	j .L4_31
.L4_33:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L4_31:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	sub s3, s1, s2
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 256
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L4_34
	j .L4_35
.L4_34:
	la s1, __str_0
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L4_35:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -16(s0)
	lw s2, -20(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, -20(s0)
	add s3, s4, s2
	sb s1, 0(s3)
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
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
.L4_25:
	li s1, 13
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_23:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_36
	j .L4_37
.L4_36:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_1
	li s3, 9
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L4_38
	j .L4_39
.L4_38:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	la s1, __str_2
	li s2, 10
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_39:
	li s1, 15
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L4_37:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_40
	j .L4_41
.L4_40:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
.L4_42:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L4_43
	j .L4_44
.L4_43:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L4_45
	j .L4_44
.L4_45:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L4_42
.L4_44:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	sub s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 256
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L4_46
	j .L4_47
.L4_46:
	la s1, __str_3
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L4_47:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -24(s0)
	lw s2, -28(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, -28(s0)
	add s3, s4, s2
	sb s1, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_48
	j .L4_49
.L4_48:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L4_49:
	li s1, 3
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
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
.L4_41:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_50
	j .L4_51
.L4_50:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_52
	j .L4_51
.L4_52:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	li s2, 16
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, strtoul
	mv s3, a0
	lw s1, -4(s0)
	li s2, 268
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 75
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_53
	j .L4_54
.L4_53:
	lw s1, -4(s0)
	li s2, 268
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1024
	mul s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L4_55
.L4_54:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 77
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_56
	j .L4_57
.L4_56:
	lw s1, -4(s0)
	li s2, 268
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1024
	li s4, 1024
	mul s5, s2, s4
	mul s2, s1, s5
	sw s2, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L4_57:
.L4_55:
	li s1, 2
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
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
.L4_51:
	addi s1, s0, -12
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isdigit
	mv s1, a0
	bnez s1, .L4_58
	j .L4_59
.L4_58:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	li s2, 10
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, strtoul
	mv s3, a0
	lw s1, -4(s0)
	li s2, 268
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 75
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_60
	j .L4_61
.L4_60:
	lw s1, -4(s0)
	li s2, 268
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1024
	mul s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L4_62
.L4_61:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 77
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_63
	j .L4_64
.L4_63:
	lw s1, -4(s0)
	li s2, 268
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1024
	li s4, 1024
	mul s5, s2, s4
	mul s2, s1, s5
	sw s2, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L4_64:
.L4_62:
	li s1, 2
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
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
.L4_59:
	addi s1, s0, -12
	lb s2, 0(s1)
	mv a0, s2
	jal ra, is_ident_start
	mv s1, a0
	bnez s1, .L4_65
	j .L4_66
.L4_65:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
.L4_67:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, is_ident_char
	mv s1, a0
	bnez s1, .L4_68
	j .L4_69
.L4_68:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L4_67
.L4_69:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -32(s0)
	sub s3, s1, s2
	sw s3, -36(s0)
	lw s1, -36(s0)
	li s2, 256
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L4_70
	j .L4_71
.L4_70:
	la s1, __str_4
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L4_71:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -32(s0)
	lw s2, -36(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, -36(s0)
	add s3, s4, s2
	sb s1, 0(s3)
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
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
.L4_66:
	la s1, __str_5
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -12
	lb s4, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s4, 4(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end4:
	.size next, .Lfunc_end4-next

	.text
	.align 2
	.type expect, @function
expect:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_0
	j .L5_1
.L5_0:
	la s1, __str_6
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L5_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
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
.Lfunc_end5:
	.size expect, .Lfunc_end5-expect

	.text
	.align 2
	.type match_ident, @function
match_ident:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_0
	j .L6_1
.L6_0:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -8(s0)
	mv a0, s3
	mv a1, s1
	jal ra, strcmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_2
	j .L6_1
.L6_2:
	li s1, 1
	j .L6_3
.L6_1:
	li s1, 0
.L6_3:
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
.Lfunc_end6:
	.size match_ident, .Lfunc_end6-match_ident

	.text
	.align 2
	.type parse_flags_string, @function
parse_flags_string:
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
.L7_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L7_1
	j .L7_2
.L7_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 114
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_3
	j .L7_4
.L7_3:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 4
	or s3, s2, s1
	sw s3, -12(s0)
	j .L7_5
.L7_4:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 119
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_6
	j .L7_7
.L7_6:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 2
	or s3, s2, s1
	sw s3, -12(s0)
	j .L7_8
.L7_7:
	lw s1, -4(s0)
	lb s2, 0(s1)
	li s1, 120
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_9
	j .L7_10
.L7_9:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	or s3, s2, s1
	sw s3, -12(s0)
.L7_10:
.L7_8:
.L7_5:
.L7_11:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
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
	.size parse_flags_string, .Lfunc_end7-parse_flags_string

	.text
	.align 2
	.type parse_output_format, @function
parse_output_format:
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
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
	la s3, __str_7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 3
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_0:
	la s1, __str_8
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L8_1:
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 5
	la s3, __str_9
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
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
.Lfunc_end8:
	.size parse_output_format, .Lfunc_end8-parse_output_format

	.text
	.align 2
	.type parse_output_arch, @function
parse_output_arch:
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
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
	la s3, __str_10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L9_0
	j .L9_1
.L9_0:
	la s1, __str_11
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L9_1:
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 5
	la s3, __str_12
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
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
	.size parse_output_arch, .Lfunc_end9-parse_output_arch

	.text
	.align 2
	.type parse_entry, @function
parse_entry:
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
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
	la s3, __str_13
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	la s1, __str_14
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L10_1:
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -8(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 5
	la s3, __str_15
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
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
	.size parse_entry, .Lfunc_end10-parse_entry

	.text
	.align 2
	.type parse_memory, @function
parse_memory:
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
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 6
	la s3, __str_16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
.L11_0:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_1
	j .L11_2
.L11_1:
	lw s1, -4(s0)
	la s2, __str_17
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L11_2
	j .L11_3
.L11_3:
	lw s1, -4(s0)
	la s2, __str_18
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L11_2
	j .L11_4
.L11_4:
	lw s1, -8(s0)
	li s2, 172
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_5
	j .L11_6
.L11_5:
	la s1, __str_19
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_6:
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 172
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 1
	add s5, s1, s2
	sw s5, 0(s4)
	li s2, 20
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
	la s3, __str_20
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L11_7
	j .L11_8
.L11_7:
	la s1, __str_21
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_8:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	mv a0, s3
	jal ra, parse_flags_string
	mv s1, a0
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 5
	la s3, __str_22
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	la s3, __str_23
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_24
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L11_9
	j .L11_10
.L11_10:
	la s1, __str_25
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_9:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 12
	la s3, __str_26
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L11_11
	j .L11_12
.L11_11:
	la s1, __str_27
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_12:
	lw s1, -4(s0)
	li s2, 268
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 9
	la s3, __str_28
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_29
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L11_13
	j .L11_14
.L11_14:
	la s1, __str_30
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_13:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 12
	la s3, __str_31
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L11_15
	j .L11_16
.L11_15:
	la s1, __str_32
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L11_16:
	lw s1, -4(s0)
	li s2, 268
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	j .L11_0
.L11_2:
	lw s1, -4(s0)
	li s2, 7
	la s3, __str_33
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
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
.Lfunc_end11:
	.size parse_memory, .Lfunc_end11-parse_memory

	.text
	.align 2
	.type parse_phdrs, @function
parse_phdrs:
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
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 6
	la s3, __str_34
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
.L12_0:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_1
	j .L12_2
.L12_1:
	lw s1, -8(s0)
	li s2, 272
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L12_3
	j .L12_4
.L12_3:
	la s1, __str_35
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L12_4:
	lw s1, -8(s0)
	li s2, 176
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 272
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 1
	add s5, s1, s2
	sw s5, 0(s4)
	li s2, 12
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	la s2, __str_36
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L12_5
	j .L12_6
.L12_6:
	la s1, __str_37
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L12_5:
	li s1, 1
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	la s2, __str_38
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L12_7
	j .L12_8
.L12_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
	la s3, __str_39
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_9
	j .L12_10
.L12_9:
	la s1, __str_40
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L12_10:
	lw s1, -4(s0)
	li s2, 268
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 5
	la s3, __str_41
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
.L12_8:
	lw s1, -4(s0)
	li s2, 10
	la s3, __str_42
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	j .L12_0
.L12_2:
	lw s1, -4(s0)
	li s2, 7
	la s3, __str_43
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
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
.Lfunc_end12:
	.size parse_phdrs, .Lfunc_end12-parse_phdrs

	.text
	.align 2
	.type parse_input_spec, @function
parse_input_spec:
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
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
	la s3, __str_44
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
.L13_0:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 5
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_1
	j .L13_2
.L13_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_3
	j .L13_2
.L13_3:
	lw s1, -8(s0)
	li s2, 164
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L13_4
	j .L13_5
.L13_4:
	la s1, __str_45
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L13_5:
	lw s1, -8(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 164
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 1
	add s5, s1, s2
	sw s5, 0(s4)
	li s2, 8
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_6
	j .L13_7
.L13_6:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	la s1, __str_46
	mv a0, s3
	mv a1, s1
	jal ra, strcmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_8
	j .L13_7
.L13_8:
	la s1, script_arena
	lw s2, 0(s1)
	la s1, __str_47
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	sw s3, 0(s1)
	li s1, 0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	j .L13_9
.L13_7:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_10
	j .L13_11
.L13_10:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	sw s3, -16(s0)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 2
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L13_12
	j .L13_13
.L13_12:
	lw s1, -16(s0)
	lw s2, -20(s0)
	li s3, 2
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_14
	j .L13_13
.L13_14:
	lw s1, -16(s0)
	lw s2, -20(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_15
	j .L13_13
.L13_15:
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -16(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	sw s3, -24(s0)
	li s1, 0
	lw s2, -24(s0)
	lw s3, -20(s0)
	li s4, 2
	sub s5, s3, s4
	add s3, s2, s5
	sb s1, 0(s3)
	lw s1, -24(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	li s1, 1
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	j .L13_16
.L13_13:
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -16(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	sw s3, 0(s1)
	li s1, 0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
.L13_16:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 13
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_17
	j .L13_18
.L13_17:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_18
	j .L13_19
.L13_19:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 14
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_20
	j .L13_21
.L13_20:
	li s1, 1
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
.L13_21:
.L13_18:
	j .L13_22
.L13_11:
	la s1, __str_48
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L13_22:
.L13_9:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_23
	j .L13_24
.L13_23:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
.L13_24:
	j .L13_0
.L13_2:
	lw s1, -4(s0)
	li s2, 5
	la s3, __str_49
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
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
	.size parse_input_spec, .Lfunc_end13-parse_input_spec

	.text
	.align 2
	.type parse_sec_body, @function
parse_sec_body:
	addi sp, sp, -336
	sw ra, 332(sp)
	sw s0, 328(sp)
	addi s0, sp, 328
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
	li s1, 0
	sw s1, -12(s0)
.L14_0:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 7
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_1
	j .L14_2
.L14_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_3
	j .L14_2
.L14_3:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 14
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_4
	j .L14_5
.L14_4:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_input_spec
	mv s3, a0
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L14_6
.L14_5:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_7
	j .L14_8
.L14_7:
	addi s1, s0, -272
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 256
	li s3, 1
	sub s5, s2, s3
	mv a0, s1
	mv a1, s4
	mv a2, s5
	jal ra, strncpy
	mv s2, a0
	li s1, 0
	addi s2, s0, -272
	li s3, 256
	li s4, 1
	sub s5, s3, s4
	add s3, s2, s5
	sb s1, 0(s3)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 12
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_9
	j .L14_10
.L14_9:
	la s1, __str_50
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -272
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L14_10:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 13
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_11
	j .L14_12
.L14_11:
	la s1, __str_51
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L14_12:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 10
	la s3, __str_52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -8(s0)
	li s2, 360
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L14_13
	j .L14_14
.L14_13:
	la s1, __str_53
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L14_14:
	lw s1, -8(s0)
	li s2, 168
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 360
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 1
	add s5, s1, s2
	sw s5, 0(s4)
	li s2, 12
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -276(s0)
	la s1, script_arena
	lw s2, 0(s1)
	addi s1, s0, -272
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -276(s0)
	sw s3, 0(s1)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	lw s1, -276(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -12(s0)
	lw s2, -276(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	j .L14_15
.L14_8:
	la s1, __str_54
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L14_15:
.L14_6:
	j .L14_0
.L14_2:
	li s1, 0
	mv a0, s1
	lw s1, -324(s0)
	lw s2, -320(s0)
	lw s3, -316(s0)
	lw s4, -312(s0)
	lw s5, -308(s0)
	lw s6, -304(s0)
	lw s7, -300(s0)
	lw s8, -296(s0)
	lw s9, -292(s0)
	lw s10, -288(s0)
	lw s11, -284(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end14:
	.size parse_sec_body, .Lfunc_end14-parse_sec_body

	.text
	.align 2
	.type parse_sections, @function
parse_sections:
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
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 6
	la s3, __str_55
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
.L15_0:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 7
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_1
	j .L15_2
.L15_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_3
	j .L15_2
.L15_3:
	lw s1, -8(s0)
	li s2, 6100
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L15_4
	j .L15_5
.L15_4:
	la s1, __str_56
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L15_5:
	lw s1, -8(s0)
	li s2, 276
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 6100
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	li s3, 364
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_6
	j .L15_7
.L15_6:
	la s1, __str_57
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L15_7:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	la s1, __str_58
	mv a0, s3
	mv a1, s1
	jal ra, strcmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	sw s3, -16(s0)
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	la s3, __str_59
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	li s2, 6
	la s3, __str_60
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_sec_body
	mv s3, a0
	lw s1, -4(s0)
	li s2, 7
	la s3, __str_61
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
	mv s4, a0
	lw s1, -16(s0)
	bnez s1, .L15_8
	j .L15_9
.L15_9:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 11
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_10
	j .L15_8
.L15_10:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_11
	j .L15_12
.L15_11:
	la s1, __str_62
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L15_12:
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -12(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_13
	j .L15_14
.L15_13:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_15
	j .L15_16
.L15_15:
	la s1, __str_63
	lw s2, -4(s0)
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L15_16:
	la s1, script_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, next
	mv s2, a0
.L15_14:
.L15_8:
	lw s1, -8(s0)
	li s2, 6100
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L15_0
.L15_2:
	lw s1, -4(s0)
	li s2, 7
	la s3, __str_64
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, expect
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
.Lfunc_end15:
	.size parse_sections, .Lfunc_end15-parse_sections

	.text
	.align 2
	.globl ld_parse_script
	.type ld_parse_script, @function
ld_parse_script:
	addi sp, sp, -352
	sw ra, 348(sp)
	sw s0, 344(sp)
	addi s0, sp, 344
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
	la s2, script_arena
	sw s1, 0(s2)
	lw s1, -8(s0)
	li s2, 0
	li s3, 6104
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -292
	li s2, 0
	li s3, 276
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -12(s0)
	addi s2, s0, -292
	sw s1, 0(s2)
	lw s1, -12(s0)
	addi s2, s0, -292
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	addi s2, s0, -292
	li s3, 272
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -292
	mv a0, s1
	jal ra, next
	mv s2, a0
.L16_0:
	addi s1, s0, -292
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L16_1
	j .L16_2
.L16_1:
	addi s1, s0, -292
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L16_3
	j .L16_4
.L16_3:
	la s1, __str_65
	addi s2, s0, -292
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L16_4:
	addi s1, s0, -292
	la s2, __str_66
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L16_5
	j .L16_6
.L16_5:
	addi s1, s0, -292
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_output_format
	mv s3, a0
	j .L16_7
.L16_6:
	addi s1, s0, -292
	la s2, __str_67
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L16_8
	j .L16_9
.L16_8:
	addi s1, s0, -292
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_output_arch
	mv s3, a0
	j .L16_10
.L16_9:
	addi s1, s0, -292
	la s2, __str_68
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L16_11
	j .L16_12
.L16_11:
	addi s1, s0, -292
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_entry
	mv s3, a0
	j .L16_13
.L16_12:
	addi s1, s0, -292
	la s2, __str_69
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L16_14
	j .L16_15
.L16_14:
	addi s1, s0, -292
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_memory
	mv s3, a0
	j .L16_16
.L16_15:
	addi s1, s0, -292
	la s2, __str_70
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L16_17
	j .L16_18
.L16_17:
	addi s1, s0, -292
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_phdrs
	mv s3, a0
	j .L16_19
.L16_18:
	addi s1, s0, -292
	la s2, __str_71
	mv a0, s1
	mv a1, s2
	jal ra, match_ident
	mv s3, a0
	bnez s3, .L16_20
	j .L16_21
.L16_20:
	addi s1, s0, -292
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, parse_sections
	mv s3, a0
	j .L16_22
.L16_21:
	la s1, __str_72
	addi s2, s0, -292
	li s3, 272
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -292
	li s4, 12
	add s5, s3, s4
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s5, 4(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L16_22:
.L16_19:
.L16_16:
.L16_13:
.L16_10:
.L16_7:
	j .L16_0
.L16_2:
	li s1, 0
	mv a0, s1
	lw s1, -340(s0)
	lw s2, -336(s0)
	lw s3, -332(s0)
	lw s4, -328(s0)
	lw s5, -324(s0)
	lw s6, -320(s0)
	lw s7, -316(s0)
	lw s8, -312(s0)
	lw s9, -308(s0)
	lw s10, -304(s0)
	lw s11, -300(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end16:
	.size ld_parse_script, .Lfunc_end16-ld_parse_script

	.text
	.align 2
	.globl ld_default_script
	.type ld_default_script, @function
ld_default_script:
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
	la s3, ld_default_script.default_script.0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, ld_parse_script
	mv s4, a0
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
	.size ld_default_script, .Lfunc_end17-ld_default_script

	.data
	.align 2
__str_72:
	.ascii "script:%d: unknown directive '%s'\000"
	.align 2
__str_71:
	.ascii "SECTIONS\000"
	.align 2
__str_70:
	.ascii "PHDRS\000"
	.align 2
__str_69:
	.ascii "MEMORY\000"
	.align 2
__str_68:
	.ascii "ENTRY\000"
	.align 2
__str_67:
	.ascii "OUTPUT_ARCH\000"
	.align 2
__str_66:
	.ascii "OUTPUT_FORMAT\000"
	.align 2
__str_65:
	.ascii "script:%d: expected top-level directive\000"
	.align 2
__str_64:
	.ascii "'}'\000"
	.align 2
__str_63:
	.ascii "script:%d: expected phdr name after ':'\000"
	.align 2
__str_62:
	.ascii "script:%d: expected region name after '>'\000"
	.align 2
__str_61:
	.ascii "'}'\000"
	.align 2
__str_60:
	.ascii "'{'\000"
	.align 2
__str_59:
	.ascii "':'\000"
	.align 2
__str_58:
	.ascii "/DISCARD/\000"
	.align 2
__str_57:
	.ascii "script:%d: expected section name\000"
	.align 2
__str_56:
	.ascii "script:%d: too many output sections\000"
	.align 2
__str_55:
	.ascii "'{'\000"
	.align 2
__str_54:
	.ascii "script:%d: unexpected token in section body\000"
	.align 2
__str_53:
	.ascii "script:%d: too many symbol assignments\000"
	.align 2
__str_52:
	.ascii "';'\000"
	.align 2
__str_51:
	.ascii "script:%d: only '. (dot)' supported on RHS of symbol assignment\000"
	.align 2
__str_50:
	.ascii "script:%d: expected '=' after '%s'\000"
	.align 2
__str_49:
	.ascii "')'\000"
	.align 2
__str_48:
	.ascii "script:%d: expected section pattern\000"
	.align 2
__str_47:
	.ascii "COMMON\000"
	.align 2
__str_46:
	.ascii "COMMON\000"
	.align 2
__str_45:
	.ascii "script:%d: too many input patterns\000"
	.align 2
__str_44:
	.ascii "'('\000"
	.align 2
__str_43:
	.ascii "'}'\000"
	.align 2
__str_42:
	.ascii "';'\000"
	.align 2
__str_41:
	.ascii "')'\000"
	.align 2
__str_40:
	.ascii "script:%d: expected number for FLAGS\000"
	.align 2
__str_39:
	.ascii "'('\000"
	.align 2
__str_38:
	.ascii "FLAGS\000"
	.align 2
__str_37:
	.ascii "script:%d: only PT_LOAD supported\000"
	.align 2
__str_36:
	.ascii "PT_LOAD\000"
	.align 2
__str_35:
	.ascii "script:%d: too many PHDRS\000"
	.align 2
__str_34:
	.ascii "'{'\000"
	.align 2
__str_33:
	.ascii "'}'\000"
	.align 2
__str_32:
	.ascii "script:%d: expected number for LENGTH\000"
	.align 2
__str_31:
	.ascii "'='\000"
	.align 2
__str_30:
	.ascii "script:%d: expected LENGTH\000"
	.align 2
__str_29:
	.ascii "LENGTH\000"
	.align 2
__str_28:
	.ascii "','\000"
	.align 2
__str_27:
	.ascii "script:%d: expected number for ORIGIN\000"
	.align 2
__str_26:
	.ascii "'='\000"
	.align 2
__str_25:
	.ascii "script:%d: expected ORIGIN\000"
	.align 2
__str_24:
	.ascii "ORIGIN\000"
	.align 2
__str_23:
	.ascii "':'\000"
	.align 2
__str_22:
	.ascii "')'\000"
	.align 2
__str_21:
	.ascii "script:%d: expected flags for MEMORY region\000"
	.align 2
__str_20:
	.ascii "'('\000"
	.align 2
__str_19:
	.ascii "script:%d: too many MEMORY regions\000"
	.align 2
__str_18:
	.ascii "SECTIONS\000"
	.align 2
__str_17:
	.ascii "PHDRS\000"
	.align 2
__str_16:
	.ascii "'{'\000"
	.align 2
__str_15:
	.ascii "')'\000"
	.align 2
__str_14:
	.ascii "script:%d: expected identifier for ENTRY\000"
	.align 2
__str_13:
	.ascii "'('\000"
	.align 2
__str_12:
	.ascii "')'\000"
	.align 2
__str_11:
	.ascii "script:%d: expected identifier for OUTPUT_ARCH\000"
	.align 2
__str_10:
	.ascii "'('\000"
	.align 2
__str_9:
	.ascii "')'\000"
	.align 2
__str_8:
	.ascii "script:%d: expected string for OUTPUT_FORMAT\000"
	.align 2
__str_7:
	.ascii "'('\000"
	.align 2
__str_6:
	.ascii "script:%d: expected %s\000"
	.align 2
__str_5:
	.ascii "script:%d: unexpected character '%c'\000"
	.align 2
__str_4:
	.ascii "script:%d: identifier too long\000"
	.align 2
__str_3:
	.ascii "script:%d: string too long\000"
	.align 2
__str_2:
	.ascii "/DISCARD/\000"
	.align 2
__str_1:
	.ascii "/DISCARD/\000"
	.align 2
__str_0:
	.ascii "script:%d: identifier too long\000"

	.section .rodata
	.align 2
ld_default_script.default_script.0:
	.ascii "OUTPUT_FORMAT(\"elf32-m68k\")\nENTRY(_start)\nMEMORY { RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 0x4000000 }\nSECTIONS {\n    .text : { *(.text .text.*) } > RAM\n    .rodata : { *(.rodata .rodata.*) } > RAM\n    .data : { *(.data .data.*) } > RAM\n    .bss : { __bss_start = .; *(.bss .bss.*) *(COMMON) __bss_end = .; } > RAM\n    /DISCARD/ : { *(.note .note.*) *(.comment) *(.eh_frame) *(.gnu.hash) }\n}\n\000"

	.bss
	.align 2
	.globl script_arena
script_arena:
	.space 4
