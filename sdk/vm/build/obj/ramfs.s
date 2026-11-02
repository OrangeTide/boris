# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type node_alloc, @function
node_alloc:
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
.L1_0:
	lw s1, -20(s0)
	li s2, 256
	slt s3, s1, s2
	bnez s3, .L1_1
	j .L1_2
.L1_1:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L1_3
	j .L1_4
.L1_4:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	li s3, 64
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li s1, 1
	la s2, nodes
	lw s3, -20(s0)
	li s4, 64
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -4(s0)
	la s2, nodes
	lw s3, -20(s0)
	li s4, 64
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -8(s0)
	la s2, nodes
	lw s3, -20(s0)
	li s4, 64
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, -12(s0)
	li s2, 32
	li s4, 1
	sub s5, s2, s4
	mv a0, s3
	mv a1, s1
	mv a2, s5
	jal ra, strncpy
	mv s2, a0
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
.L1_3:
.L1_5:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L1_0
.L1_2:
	li s1, 10
	neg s2, s1
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
.Lfunc_end1:
	.size node_alloc, .Lfunc_end1-node_alloc

	.text
	.align 2
	.type node_free, @function
node_free:
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
	la s1, nodes
	lw s2, -4(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 44
	add s3, s2, s1
	lw s1, 0(s3)
	mv a0, s1
	jal ra, free
	mv s2, a0
	la s1, nodes
	lw s2, -4(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	li s3, 64
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memset
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
.Lfunc_end2:
	.size node_free, .Lfunc_end2-node_free

	.text
	.align 2
	.type find_child, @function
find_child:
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
	li s1, 0
	sw s1, -12(s0)
.L3_0:
	lw s1, -12(s0)
	li s2, 256
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	la s1, nodes
	lw s2, -12(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L3_3
	j .L3_4
.L3_3:
	la s1, nodes
	lw s2, -12(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -4(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_5
	j .L3_4
.L3_5:
	la s1, nodes
	lw s2, -12(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, -8(s0)
	mv a0, s3
	mv a1, s1
	jal ra, strcmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_6
	j .L3_4
.L3_6:
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
.L3_4:
.L3_7:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L3_0
.L3_2:
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
.Lfunc_end3:
	.size find_child, .Lfunc_end3-find_child

	.text
	.align 2
	.type walk, @function
walk:
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
	lw s1, -4(s0)
	sw s1, -12(s0)
	lw s1, -8(s0)
	sw s1, -16(s0)
.L4_0:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L4_1
	j .L4_2
.L4_1:
	li s1, 0
	sw s1, -52(s0)
.L4_3:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_4
	j .L4_5
.L4_4:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L4_3
.L4_5:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L4_6
	j .L4_7
.L4_7:
	j .L4_2
.L4_6:
.L4_8:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L4_9
	j .L4_10
.L4_9:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L4_11
	j .L4_10
.L4_11:
	lw s1, -52(s0)
	li s2, 32
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L4_12
	j .L4_13
.L4_12:
	lw s1, -16(s0)
	lb s2, 0(s1)
	addi s1, s0, -48
	addi s3, s0, -52
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -52(s0)
	add s3, s1, s4
	sb s2, 0(s3)
.L4_13:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L4_8
.L4_10:
	li s1, 0
	addi s2, s0, -48
	lw s3, -52(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -52(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_14
	j .L4_15
.L4_15:
	addi s1, s0, -48
	la s2, __str_1
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_14
	j .L4_16
.L4_14:
	j .L4_0
.L4_16:
	addi s1, s0, -48
	la s2, __str_2
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_17
	j .L4_18
.L4_17:
	la s1, nodes
	lw s2, -12(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L4_19
	j .L4_20
.L4_19:
	la s1, nodes
	lw s2, -12(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -12(s0)
.L4_20:
	j .L4_0
.L4_18:
	la s1, nodes
	lw s2, -12(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L4_21
	j .L4_22
.L4_22:
	li s1, 12
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
.L4_21:
	lw s1, -12(s0)
	addi s2, s0, -48
	mv a0, s1
	mv a1, s2
	jal ra, find_child
	mv s3, a0
	sw s3, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L4_23
	j .L4_24
.L4_23:
	li s1, 6
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
.L4_24:
	lw s1, -56(s0)
	sw s1, -12(s0)
	j .L4_0
.L4_2:
	lw s1, -12(s0)
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
.Lfunc_end4:
	.size walk, .Lfunc_end4-walk

	.text
	.align 2
	.type split_leaf, @function
split_leaf:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -20(s0)
.L5_0:
	lw s1, -20(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L5_1
	j .L5_2
.L5_1:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 1
	sub s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_3
	j .L5_2
.L5_3:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L5_0
.L5_2:
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_4
	j .L5_5
.L5_4:
	li s1, 4
	neg s2, s1
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
.L5_5:
	lw s1, -20(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -24(s0)
.L5_6:
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_7
	j .L5_8
.L5_7:
	lw s1, -4(s0)
	lw s2, -24(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_9
	j .L5_8
.L5_9:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L5_6
.L5_8:
	lw s1, -20(s0)
	li s2, 1
	sub s3, s1, s2
	lw s1, -24(s0)
	sub s2, s3, s1
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 32
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_10
	j .L5_11
.L5_10:
	li s1, 15
	neg s2, s1
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
.L5_11:
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -24(s0)
	add s4, s2, s3
	li s2, 1
	add s3, s4, s2
	lw s2, -28(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -16(s0)
	lw s3, -28(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L5_12
	j .L5_13
.L5_12:
	li s1, 0
	lw s2, -8(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	j .L5_14
.L5_13:
	lw s1, -24(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_15
	j .L5_16
.L5_15:
	li s1, 15
	neg s2, s1
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
.L5_16:
	lw s1, -8(s0)
	lw s2, -4(s0)
	lw s3, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -8(s0)
	lw s3, -24(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L5_14:
	lw s1, -16(s0)
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_17
	j .L5_18
.L5_18:
	lw s1, -16(s0)
	la s2, __str_4
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_17
	j .L5_19
.L5_17:
	li s1, 4
	neg s2, s1
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
.L5_19:
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
	.size split_leaf, .Lfunc_end5-split_leaf

	.text
	.align 2
	.type ensure_cap, @function
ensure_cap:
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
	lw s2, -4(s0)
	li s3, 52
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L6_0
	j .L6_1
.L6_0:
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
.L6_1:
	lw s1, -4(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L6_2
	j .L6_3
.L6_2:
	lw s1, -4(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L6_4
.L6_3:
	li s1, 64
	sw s1, -20(s0)
.L6_4:
	lw s1, -20(s0)
	sw s1, -12(s0)
.L6_5:
	lw s1, -12(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L6_6
	j .L6_7
.L6_6:
	lw s1, -12(s0)
	li s2, 2147483647
	li s3, 2
	div s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L6_8
	j .L6_9
.L6_8:
	lw s1, -8(s0)
	sw s1, -12(s0)
	j .L6_7
.L6_9:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -12(s0)
	j .L6_5
.L6_7:
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, realloc
	mv s3, a0
	sw s3, -16(s0)
	lw s1, -16(s0)
	bnez s1, .L6_10
	j .L6_11
.L6_11:
	li s1, 5
	neg s2, s1
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
.L6_10:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 52
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
.Lfunc_end6:
	.size ensure_cap, .Lfunc_end6-ensure_cap

	.text
	.align 2
	.type ram_open, @function
ram_open:
	addi sp, sp, -384
	sw ra, 380(sp)
	sw s0, 376(sp)
	addi s0, sp, 376
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -16(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_2
	j .L7_3
.L7_2:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_3:
	la s1, nodes
	lw s2, -28(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L7_4
	j .L7_5
.L7_5:
	li s1, 12
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_4:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_1:
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_6
	j .L7_7
.L7_6:
	la s1, nodes
	lw s2, -28(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L7_8
	j .L7_9
.L7_8:
	li s1, 13
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_9:
	lw s1, -16(s0)
	li s2, 512
	and s3, s1, s2
	bnez s3, .L7_10
	j .L7_11
.L7_10:
	lw s1, -16(s0)
	li s2, 3
	and s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L7_12
	j .L7_11
.L7_12:
	li s1, 0
	la s2, nodes
	lw s3, -28(s0)
	li s4, 64
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 48
	add s4, s3, s2
	sw s1, 0(s4)
.L7_11:
	la s1, nodes
	lw s2, -28(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 56
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_7:
	lw s1, -28(s0)
	li s2, 6
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L7_13
	j .L7_14
.L7_14:
	lw s1, -16(s0)
	li s2, 64
	and s3, s1, s2
	bnez s3, .L7_15
	j .L7_13
.L7_13:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_15:
	lw s1, -12(s0)
	addi s2, s0, -288
	li s3, 256
	addi s4, s0, -320
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, split_leaf
	mv s5, a0
	li s1, 0
	slt s2, s5, s1
	bnez s2, .L7_16
	j .L7_17
.L7_16:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_17:
	lw s1, -8(s0)
	addi s2, s0, -288
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L7_18
	j .L7_19
.L7_18:
	lw s1, -32(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_19:
	la s1, nodes
	lw s2, -32(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L7_20
	j .L7_21
.L7_21:
	li s1, 12
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L7_20:
	li s1, 0
	lw s2, -32(s0)
	addi s3, s0, -320
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, node_alloc
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_22
	j .L7_23
.L7_22:
	la s1, nodes
	lw s2, -28(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 56
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L7_23:
	lw s1, -28(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end7:
	.size ram_open, .Lfunc_end7-ram_open

	.text
	.align 2
	.type ram_read, @function
ram_read:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	la s1, nodes
	lw s2, -8(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -28(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L8_0
	sltu s1, s10, s8
.L8_0:
	bnez s1, .L8_1
	j .L8_2
.L8_2:
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -28(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L8_3
	sltu s1, s10, s8
.L8_3:
	xori s1, s1, 1
	bnez s1, .L8_1
	j .L8_4
.L8_1:
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
.L8_4:
	lw s1, -28(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	lw s10, 0(s2)
	lw s11, 4(s2)
	mv s2, s10
	sub s3, s1, s2
	sw s3, -32(s0)
	lw s1, -16(s0)
	lw s2, -32(s0)
	slt s3, s2, s1
	bnez s3, .L8_5
	j .L8_6
.L8_5:
	lw s1, -32(s0)
	sw s1, -16(s0)
.L8_6:
	lw s1, -12(s0)
	lw s2, -28(s0)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -20(s0)
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s3, s10
	add s4, s2, s3
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, memcpy
	mv s3, a0
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s2, -16(s0)
	mv s8, s2
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, 0(s1)
	sw s7, 4(s1)
	lw s1, -16(s0)
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
.Lfunc_end8:
	.size ram_read, .Lfunc_end8-ram_read

	.text
	.align 2
	.type ram_write, @function
ram_write:
	addi sp, sp, -112
	sw ra, 108(sp)
	sw s0, 104(sp)
	addi s0, sp, 104
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
	sw s7, 32(sp)
	sw s8, 36(sp)
	sw s9, 40(sp)
	sw s10, 44(sp)
	sw s11, 48(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	la s1, nodes
	lw s2, -8(s0)
	li s3, 64
	mul t0, s2, s3
	sw t0, -36(s0)
	lw t1, -36(s0)
	add s2, s1, t1
	sw s2, -28(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L9_0
	sltu s1, s10, s8
.L9_0:
	bnez s1, .L9_1
	j .L9_2
.L9_2:
	lw s1, -16(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L9_1
	j .L9_3
.L9_3:
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 2147483647
	mv s8, s1
	srai s9, s8, 31
	lw s1, -16(s0)
	mv s6, s1
	srai s7, s6, 31
	sltu t0, s8, s6
	sub s4, s8, s6
	sub s5, s9, t0
	sub s5, s5, s7
	slt s1, s5, s11
	bne s5, s11, .L9_4
	sltu s1, s4, s10
.L9_4:
	bnez s1, .L9_1
	j .L9_5
.L9_1:
	li s1, 10
	neg s2, s1
	mv a0, s2
	lw s1, -96(s0)
	lw s2, -92(s0)
	lw s3, -88(s0)
	lw s4, -84(s0)
	lw s5, -80(s0)
	lw s6, -76(s0)
	lw s7, -72(s0)
	lw s8, -68(s0)
	lw s9, -64(s0)
	lw s10, -60(s0)
	lw s11, -56(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L9_5:
	lw s1, -28(s0)
	lw s2, -20(s0)
	lw s10, 0(s2)
	lw s11, 4(s2)
	mv s2, s10
	lw s3, -16(s0)
	add t0, s2, s3
	sw t0, -40(s0)
	mv a0, s1
	lw t0, -40(s0)
	mv a1, t0
	jal ra, ensure_cap
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L9_6
	j .L9_7
.L9_6:
	lw s1, -32(s0)
	mv a0, s1
	lw s1, -96(s0)
	lw s2, -92(s0)
	lw s3, -88(s0)
	lw s4, -84(s0)
	lw s5, -80(s0)
	lw s6, -76(s0)
	lw s7, -72(s0)
	lw s8, -68(s0)
	lw s9, -64(s0)
	lw s10, -60(s0)
	lw s11, -56(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L9_7:
	lw s1, -28(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	lw s10, 0(s2)
	lw s11, 4(s2)
	mv s2, s10
	add s3, s1, s2
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv t0, a0
	sw t0, -44(s0)
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s2, -16(s0)
	mv s8, s2
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, 0(s1)
	sw s7, 4(s1)
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	mv t0, s10
	sw t0, -48(s0)
	lw s2, -28(s0)
	li s3, 48
	add s1, s2, s3
	lw s2, 0(s1)
	lw t0, -48(s0)
	slt s1, s2, t0
	bnez s1, .L9_8
	j .L9_9
.L9_8:
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	mv s1, s10
	lw s2, -28(s0)
	li s3, 48
	add t0, s2, s3
	sw t0, -52(s0)
	lw t0, -52(s0)
	sw s1, 0(t0)
.L9_9:
	lw s1, -16(s0)
	mv a0, s1
	lw s1, -96(s0)
	lw s2, -92(s0)
	lw s3, -88(s0)
	lw s4, -84(s0)
	lw s5, -80(s0)
	lw s6, -76(s0)
	lw s7, -72(s0)
	lw s8, -68(s0)
	lw s9, -64(s0)
	lw s10, -60(s0)
	lw s11, -56(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end9:
	.size ram_write, .Lfunc_end9-ram_write

	.text
	.align 2
	.type ram_lseek, @function
ram_lseek:
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
	sw a2, -16(s0)
	sw a3, -12(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	la s1, nodes
	lw s2, -8(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -28(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_0
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_1
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_2
	j .L10_3
.L10_0:
	lw s10, -16(s0)
	lw s11, -12(s0)
	sw s10, -40(s0)
	sw s11, -36(s0)
	j .L10_4
.L10_1:
	lw s1, -24(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s8, -16(s0)
	lw s9, -12(s0)
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -40(s0)
	sw s7, -36(s0)
	j .L10_4
.L10_2:
	lw s1, -28(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv s10, s1
	srai s11, s10, 31
	lw s8, -16(s0)
	lw s9, -12(s0)
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -40(s0)
	sw s7, -36(s0)
	j .L10_4
.L10_3:
	li s1, 4
	neg s2, s1
	mv s10, s2
	srai s11, s10, 31
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
.L10_4:
	lw s10, -40(s0)
	lw s11, -36(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L10_5
	sltu s1, s10, s8
.L10_5:
	bnez s1, .L10_6
	j .L10_7
.L10_6:
	li s1, 4
	neg s2, s1
	mv s10, s2
	srai s11, s10, 31
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
.L10_7:
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw s1, -24(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	lw s10, -40(s0)
	lw s11, -36(s0)
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
.Lfunc_end10:
	.size ram_lseek, .Lfunc_end10-ram_lseek

	.text
	.align 2
	.type ram_fill_stat, @function
ram_fill_stat:
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
	li s1, 29254
	lw s2, -8(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s2)
	sw s11, 4(s2)
	lw s1, -4(s0)
	mv s10, s1
	srai s11, s10, 31
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	sw s6, 0(s3)
	sw s7, 4(s3)
	la s1, nodes
	lw s2, -4(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L11_0
	j .L11_1
.L11_0:
	li s1, 0
	sw s1, -12(s0)
	j .L11_2
.L11_1:
	la s1, nodes
	lw s2, -4(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 48
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -12(s0)
.L11_2:
	lw s1, -12(s0)
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	la s1, nodes
	lw s2, -4(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L11_3
	j .L11_4
.L11_3:
	li s1, 16384
	li s2, 511
	or s3, s1, s2
	sw s3, -16(s0)
	j .L11_5
.L11_4:
	li s1, 32768
	li s2, 438
	or s3, s1, s2
	sw s3, -16(s0)
.L11_5:
	lw s1, -16(s0)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -8(s0)
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
.Lfunc_end11:
	.size ram_fill_stat, .Lfunc_end11-ram_fill_stat

	.text
	.align 2
	.type ram_stat, @function
ram_stat:
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
	sw a3, -16(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_0
	j .L12_1
.L12_0:
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
.L12_1:
	lw s1, -20(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ram_fill_stat
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
.Lfunc_end12:
	.size ram_stat, .Lfunc_end12-ram_stat

	.text
	.align 2
	.type ram_fstat, @function
ram_fstat:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ram_fill_stat
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
.Lfunc_end13:
	.size ram_fstat, .Lfunc_end13-ram_fstat

	.text
	.align 2
	.type ram_readdir, @function
ram_readdir:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	mv s1, s10
	sw s1, -20(s0)
.L14_0:
	lw s1, -20(s0)
	li s2, 256
	slt s3, s1, s2
	bnez s3, .L14_1
	j .L14_2
.L14_1:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L14_3
	j .L14_4
.L14_3:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -8(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_5
	j .L14_4
.L14_5:
	lw s1, -20(s0)
	lw s2, -16(s0)
	sw s1, 0(s2)
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L14_6
	j .L14_7
.L14_6:
	li s1, 2
	sw s1, -24(s0)
	j .L14_8
.L14_7:
	li s1, 1
	sw s1, -24(s0)
.L14_8:
	lw s1, -24(s0)
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 2
	add s3, s4, s2
	sb s1, 0(s3)
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 1
	add s3, s4, s2
	sb s1, 0(s3)
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 0
	add s3, s4, s2
	sb s1, 0(s3)
	lw s1, -16(s0)
	li s2, 8
	add s3, s1, s2
	la s1, nodes
	lw s2, -20(s0)
	li s4, 64
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 12
	add s4, s2, s1
	li s1, 56
	li s2, 1
	sub s5, s1, s2
	mv a0, s3
	mv a1, s4
	mv a2, s5
	jal ra, strncpy
	mv s1, a0
	li s1, 0
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	li s2, 56
	li s3, 1
	sub s5, s2, s3
	add s2, s4, s5
	sb s1, 0(s2)
	lw s1, -20(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	mv s10, s3
	srai s11, s10, 31
	sw s10, 0(s1)
	sw s11, 4(s1)
	li s1, 1
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
.L14_4:
.L14_9:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L14_0
.L14_2:
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
	.size ram_readdir, .Lfunc_end14-ram_readdir

	.text
	.align 2
	.type ram_close, @function
ram_close:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	bnez s1, .L15_0
	j .L15_1
.L15_1:
	la s1, nodes
	lw s2, -8(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L15_2
	j .L15_3
.L15_2:
	lw s1, -20(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, -1
	add s4, s1, s2
	sw s4, 0(s3)
.L15_3:
	lw s1, -20(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_4
	j .L15_5
.L15_4:
	lw s1, -20(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L15_6
	j .L15_5
.L15_6:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, node_free
	mv s2, a0
.L15_5:
.L15_0:
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
.Lfunc_end15:
	.size ram_close, .Lfunc_end15-ram_close

	.text
	.align 2
	.type ram_exists, @function
ram_exists:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	li s1, 0
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L16_0
	j .L16_1
.L16_0:
	li s1, 1
	sw s1, -20(s0)
	j .L16_2
.L16_1:
	li s1, 0
	sw s1, -20(s0)
.L16_2:
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
.Lfunc_end16:
	.size ram_exists, .Lfunc_end16-ram_exists

	.text
	.align 2
	.type ram_size, @function
ram_size:
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
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L17_0
	j .L17_1
.L17_0:
	lw s1, -20(s0)
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
.L17_1:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L17_2
	j .L17_3
.L17_2:
	li s1, 0
	sw s1, -24(s0)
	j .L17_4
.L17_3:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 48
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -24(s0)
.L17_4:
	lw s1, -24(s0)
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
.Lfunc_end17:
	.size ram_size, .Lfunc_end17-ram_size

	.text
	.align 2
	.type ram_isdir, @function
ram_isdir:
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
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L18_0
	j .L18_1
.L18_0:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L18_2
	j .L18_1
.L18_2:
	li s1, 1
	sw s1, -24(s0)
	j .L18_3
.L18_1:
	li s1, 0
	sw s1, -24(s0)
.L18_3:
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
.Lfunc_end18:
	.size ram_isdir, .Lfunc_end18-ram_isdir

	.text
	.align 2
	.type ram_unlink, @function
ram_unlink:
	addi sp, sp, -368
	sw ra, 364(sp)
	sw s0, 360(sp)
	addi s0, sp, 360
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	addi s2, s0, -280
	li s3, 256
	addi s4, s0, -312
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, split_leaf
	mv s5, a0
	li s1, 0
	slt s2, s5, s1
	bnez s2, .L19_0
	j .L19_1
.L19_0:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -356(s0)
	lw s2, -352(s0)
	lw s3, -348(s0)
	lw s4, -344(s0)
	lw s5, -340(s0)
	lw s6, -336(s0)
	lw s7, -332(s0)
	lw s8, -328(s0)
	lw s9, -324(s0)
	lw s10, -320(s0)
	lw s11, -316(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L19_1:
	lw s1, -8(s0)
	addi s2, s0, -280
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L19_2
	j .L19_3
.L19_2:
	lw s1, -20(s0)
	mv a0, s1
	lw s1, -356(s0)
	lw s2, -352(s0)
	lw s3, -348(s0)
	lw s4, -344(s0)
	lw s5, -340(s0)
	lw s6, -336(s0)
	lw s7, -332(s0)
	lw s8, -328(s0)
	lw s9, -324(s0)
	lw s10, -320(s0)
	lw s11, -316(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L19_3:
	lw s1, -20(s0)
	addi s2, s0, -312
	mv a0, s1
	mv a1, s2
	jal ra, find_child
	mv s3, a0
	sw s3, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L19_4
	j .L19_5
.L19_4:
	li s1, 6
	neg s2, s1
	mv a0, s2
	lw s1, -356(s0)
	lw s2, -352(s0)
	lw s3, -348(s0)
	lw s4, -344(s0)
	lw s5, -340(s0)
	lw s6, -336(s0)
	lw s7, -332(s0)
	lw s8, -328(s0)
	lw s9, -324(s0)
	lw s10, -320(s0)
	lw s11, -316(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L19_5:
	la s1, nodes
	lw s2, -24(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L19_6
	j .L19_7
.L19_6:
	li s1, 13
	neg s2, s1
	mv a0, s2
	lw s1, -356(s0)
	lw s2, -352(s0)
	lw s3, -348(s0)
	lw s4, -344(s0)
	lw s5, -340(s0)
	lw s6, -336(s0)
	lw s7, -332(s0)
	lw s8, -328(s0)
	lw s9, -324(s0)
	lw s10, -320(s0)
	lw s11, -316(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L19_7:
	la s1, nodes
	lw s2, -24(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 56
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L19_8
	j .L19_9
.L19_8:
	li s1, 1
	la s2, nodes
	lw s3, -24(s0)
	li s4, 64
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 60
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 2
	neg s2, s1
	la s1, nodes
	lw s3, -24(s0)
	li s4, 64
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 8
	add s4, s3, s1
	sw s2, 0(s4)
	j .L19_10
.L19_9:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, node_free
	mv s2, a0
.L19_10:
	li s1, 0
	mv a0, s1
	lw s1, -356(s0)
	lw s2, -352(s0)
	lw s3, -348(s0)
	lw s4, -344(s0)
	lw s5, -340(s0)
	lw s6, -336(s0)
	lw s7, -332(s0)
	lw s8, -328(s0)
	lw s9, -324(s0)
	lw s10, -320(s0)
	lw s11, -316(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end19:
	.size ram_unlink, .Lfunc_end19-ram_unlink

	.text
	.align 2
	.type ram_mkdir, @function
ram_mkdir:
	addi sp, sp, -384
	sw ra, 380(sp)
	sw s0, 376(sp)
	addi s0, sp, 376
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	addi s2, s0, -280
	li s3, 256
	addi s4, s0, -312
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, split_leaf
	mv s5, a0
	li s1, 0
	slt s2, s5, s1
	bnez s2, .L20_0
	j .L20_1
.L20_0:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_1:
	lw s1, -8(s0)
	addi s2, s0, -280
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_2
	j .L20_3
.L20_2:
	lw s1, -20(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_3:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L20_4
	j .L20_5
.L20_5:
	li s1, 12
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_4:
	lw s1, -20(s0)
	addi s2, s0, -312
	mv a0, s1
	mv a1, s2
	jal ra, find_child
	mv s3, a0
	li s1, 0
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L20_6
	j .L20_7
.L20_6:
	li s1, 11
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L20_7:
	li s1, 1
	lw s2, -20(s0)
	addi s3, s0, -312
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, node_alloc
	mv s4, a0
	li s1, 0
	slt s2, s4, s1
	bnez s2, .L20_8
	j .L20_9
.L20_8:
	li s1, 10
	neg s2, s1
	sw s2, -316(s0)
	j .L20_10
.L20_9:
	li s1, 0
	sw s1, -316(s0)
.L20_10:
	lw s1, -316(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end20:
	.size ram_mkdir, .Lfunc_end20-ram_mkdir

	.text
	.align 2
	.type ram_rmdir, @function
ram_rmdir:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L21_0
	j .L21_1
.L21_0:
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
.L21_1:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L21_2
	j .L21_3
.L21_3:
	li s1, 12
	neg s2, s1
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
.L21_2:
	li s1, 0
	sw s1, -24(s0)
.L21_4:
	lw s1, -24(s0)
	li s2, 256
	slt s3, s1, s2
	bnez s3, .L21_5
	j .L21_6
.L21_5:
	la s1, nodes
	lw s2, -24(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L21_7
	j .L21_8
.L21_7:
	la s1, nodes
	lw s2, -24(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -20(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L21_9
	j .L21_8
.L21_9:
	li s1, 14
	neg s2, s1
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
.L21_8:
.L21_10:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L21_4
.L21_6:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, node_free
	mv s2, a0
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
.Lfunc_end21:
	.size ram_rmdir, .Lfunc_end21-ram_rmdir

	.text
	.align 2
	.type ram_rename, @function
ram_rename:
	addi sp, sp, -384
	sw ra, 380(sp)
	sw s0, 376(sp)
	addi s0, sp, 376
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L22_0
	j .L22_1
.L22_0:
	lw s1, -20(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L22_1:
	lw s1, -16(s0)
	addi s2, s0, -280
	li s3, 256
	addi s4, s0, -312
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, split_leaf
	mv s5, a0
	li s1, 0
	slt s2, s5, s1
	bnez s2, .L22_2
	j .L22_3
.L22_2:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L22_3:
	lw s1, -8(s0)
	addi s2, s0, -280
	mv a0, s1
	mv a1, s2
	jal ra, walk
	mv s3, a0
	sw s3, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L22_4
	j .L22_5
.L22_4:
	lw s1, -24(s0)
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L22_5:
	la s1, nodes
	lw s2, -24(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L22_6
	j .L22_7
.L22_7:
	li s1, 12
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L22_6:
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L22_8
	j .L22_9
.L22_8:
	lw s1, -24(s0)
	sw s1, -316(s0)
.L22_10:
	lw s1, -316(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_11
	j .L22_12
.L22_11:
	lw s1, -316(s0)
	lw s2, -20(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_13
	j .L22_14
.L22_13:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L22_14:
	la s1, nodes
	lw s2, -316(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -316(s0)
	j .L22_10
.L22_12:
.L22_9:
	lw s1, -24(s0)
	addi s2, s0, -312
	mv a0, s1
	mv a1, s2
	jal ra, find_child
	mv s3, a0
	li s1, 0
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L22_15
	j .L22_16
.L22_15:
	li s1, 11
	neg s2, s1
	mv a0, s2
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L22_16:
	lw s1, -24(s0)
	la s2, nodes
	lw s3, -20(s0)
	li s4, 64
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, nodes
	lw s2, -20(s0)
	li s3, 64
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	addi s1, s0, -312
	addi s2, s0, -312
	mv a0, s2
	jal ra, strlen
	mv s4, a0
	li s2, 1
	add s5, s4, s2
	mv a0, s3
	mv a1, s1
	mv a2, s5
	jal ra, memcpy
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -364(s0)
	lw s2, -360(s0)
	lw s3, -356(s0)
	lw s4, -352(s0)
	lw s5, -348(s0)
	lw s6, -344(s0)
	lw s7, -340(s0)
	lw s8, -336(s0)
	lw s9, -332(s0)
	lw s10, -328(s0)
	lw s11, -324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end22:
	.size ram_rename, .Lfunc_end22-ram_rename

	.text
	.align 2
	.globl ramfs_mount
	.type ramfs_mount, @function
ramfs_mount:
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
	li s1, 1
	li s2, 1
	neg s3, s2
	la s2, __str_5
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, node_alloc
	mv s4, a0
	sw s4, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L23_0
	j .L23_1
.L23_0:
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
.L23_1:
	lw s1, -4(s0)
	li s2, 1
	lw s3, -12(s0)
	lw s4, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fs_install_mount
	mv s5, a0
	mv a0, s5
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
	.size ramfs_mount, .Lfunc_end23-ramfs_mount

	.data
	.align 2
__str_5:
	.ascii "\000"
	.align 2
__str_4:
	.ascii "..\000"
	.align 2
__str_3:
	.ascii ".\000"
	.align 2
__str_2:
	.ascii "..\000"
	.align 2
__str_1:
	.ascii ".\000"
	.align 2
__str_0:
	.ascii "ramfs\000"

	.section .rodata
	.align 2
	.globl ramfs_backend
ramfs_backend:
	.word 0x00000001
	.word __str_0
	.word ram_open
	.word ram_read
	.word ram_write
	.word ram_lseek
	.word ram_readdir
	.word ram_close
	.word ram_exists
	.word ram_size
	.word ram_isdir
	.word ram_stat
	.word ram_fstat
	.word ram_unlink
	.word ram_rename
	.word ram_mkdir
	.word ram_rmdir

	.bss
	.align 2
	.globl nodes
nodes:
	.space 16384
