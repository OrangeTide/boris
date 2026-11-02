# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type rd_u32, @function
rd_u32:
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
	li s2, 0
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -4(s0)
	li s3, 1
	add s4, s2, s3
	lbu s2, 0(s4)
	li s3, 8
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -4(s0)
	li s3, 2
	add s4, s1, s3
	lbu s1, 0(s4)
	li s3, 16
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -4(s0)
	li s3, 3
	add s4, s2, s3
	lbu s2, 0(s4)
	li s3, 24
	sll s4, s2, s3
	or s2, s1, s4
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
.Lfunc_end1:
	.size rd_u32, .Lfunc_end1-rd_u32

	.text
	.align 2
	.type img_of, @function
img_of:
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
	la s1, images
	lw s2, -4(s0)
	la s3, fs_mounts
	sub s4, s2, s3
	li s2, 16
	div s3, s4, s2
	li s2, 24
	mul s4, s3, s2
	add s2, s1, s4
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
.Lfunc_end2:
	.size img_of, .Lfunc_end2-img_of

	.text
	.align 2
	.type node_ptr, @function
node_ptr:
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
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	lw s1, -8(s0)
	li s2, 20
	mul s4, s1, s2
	add s1, s3, s4
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
	.size node_ptr, .Lfunc_end3-node_ptr

	.text
	.align 2
	.type node_name, @function
node_name:
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
	jal ra, node_ptr
	mv s3, a0
	li s1, 0
	add s2, s3, s1
	mv a0, s2
	jal ra, rd_u32
	mv s1, a0
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
	.size node_name, .Lfunc_end4-node_name

	.text
	.align 2
	.type node_type, @function
node_type:
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
	jal ra, node_ptr
	mv s3, a0
	li s1, 4
	add s2, s3, s1
	mv a0, s2
	jal ra, rd_u32
	mv s1, a0
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
	.size node_type, .Lfunc_end5-node_type

	.text
	.align 2
	.type node_parent, @function
node_parent:
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
	jal ra, node_ptr
	mv s3, a0
	li s1, 8
	add s2, s3, s1
	mv a0, s2
	jal ra, rd_u32
	mv s1, a0
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
	.size node_parent, .Lfunc_end6-node_parent

	.text
	.align 2
	.type node_data, @function
node_data:
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
	jal ra, node_ptr
	mv s3, a0
	li s1, 12
	add s2, s3, s1
	mv a0, s2
	jal ra, rd_u32
	mv s1, a0
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
	.size node_data, .Lfunc_end7-node_data

	.text
	.align 2
	.type node_size, @function
node_size:
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
	jal ra, node_ptr
	mv s3, a0
	li s1, 16
	add s2, s3, s1
	mv a0, s2
	jal ra, rd_u32
	mv s1, a0
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
	.size node_size, .Lfunc_end8-node_size

	.text
	.align 2
	.type node_name_str, @function
node_name_str:
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
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_name
	mv s4, a0
	add s1, s3, s4
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
	.size node_name_str, .Lfunc_end9-node_name_str

	.text
	.align 2
	.type find_child, @function
find_child:
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
	li s1, 0
	sw s1, -20(s0)
.L10_0:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	sltu s3, s1, s2
	bnez s3, .L10_1
	j .L10_2
.L10_1:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_parent
	mv s3, a0
	lw s1, -8(s0)
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L10_3
	j .L10_4
.L10_3:
	j .L10_5
.L10_4:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_name_str
	mv s3, a0
	sw s3, -24(s0)
	lw s1, -24(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	lw s1, -16(s0)
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L10_6
	j .L10_7
.L10_6:
	lw s1, -24(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L10_8
	j .L10_7
.L10_8:
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
.L10_7:
.L10_5:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L10_0
.L10_2:
	li s1, 1
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
.Lfunc_end10:
	.size find_child, .Lfunc_end10-find_child

	.text
	.align 2
	.type walk, @function
walk:
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
	lw s1, -8(s0)
	sw s1, -20(s0)
	lw s1, -12(s0)
	sw s1, -24(s0)
.L11_0:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L11_1
	j .L11_2
.L11_1:
.L11_3:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_4
	j .L11_5
.L11_4:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L11_3
.L11_5:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L11_6
	j .L11_7
.L11_7:
	j .L11_2
.L11_6:
	lw s1, -24(s0)
	sw s1, -28(s0)
.L11_8:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L11_9
	j .L11_10
.L11_9:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L11_11
	j .L11_10
.L11_11:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L11_8
.L11_10:
	lw s1, -24(s0)
	lw s2, -28(s0)
	sub s3, s1, s2
	sw s3, -32(s0)
	lw s1, -32(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_12
	j .L11_13
.L11_12:
	lw s1, -28(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_14
	j .L11_13
.L11_14:
	j .L11_0
.L11_13:
	lw s1, -32(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_15
	j .L11_16
.L11_15:
	lw s1, -28(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_17
	j .L11_16
.L11_17:
	lw s1, -28(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_18
	j .L11_16
.L11_18:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_parent
	mv s3, a0
	li s1, 0
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L11_19
	j .L11_20
.L11_19:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_parent
	mv s3, a0
	sw s3, -20(s0)
.L11_20:
	j .L11_0
.L11_16:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_type
	mv s3, a0
	li s1, 1
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L11_21
	j .L11_22
.L11_21:
	li s1, 12
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
.L11_22:
	lw s1, -4(s0)
	lw s2, -20(s0)
	lw s3, -28(s0)
	lw s4, -32(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, find_child
	mv s5, a0
	sw s5, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L11_23
	j .L11_24
.L11_23:
	li s1, 6
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
.L11_24:
	j .L11_0
.L11_2:
	lw s1, -20(s0)
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
	.size walk, .Lfunc_end11-walk

	.text
	.align 2
	.type rom_open, @function
rom_open:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, img_of
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -16(s0)
	li s2, 3
	and s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L12_0
	j .L12_1
.L12_1:
	lw s1, -16(s0)
	li s2, 64
	and s3, s1, s2
	bnez s3, .L12_0
	j .L12_2
.L12_0:
	li s1, 18
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
.L12_2:
	lw s1, -28(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk
	mv s4, a0
	sw s4, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_3
	j .L12_4
.L12_3:
	lw s1, -32(s0)
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
.L12_4:
	lw s1, -16(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L12_5
	j .L12_6
.L12_5:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_type
	mv s3, a0
	li s1, 1
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L12_7
	j .L12_8
.L12_7:
	li s1, 12
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
.L12_8:
	lw s1, -32(s0)
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
.L12_6:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_type
	mv s3, a0
	li s1, 1
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L12_9
	j .L12_10
.L12_9:
	li s1, 13
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
.L12_10:
	lw s1, -32(s0)
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
.Lfunc_end12:
	.size rom_open, .Lfunc_end12-rom_open

	.text
	.align 2
	.type rom_read, @function
rom_read:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, img_of
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_size
	mv s3, a0
	sw s3, -32(s0)
	lw s1, -28(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	lw s3, -8(s0)
	mv a0, s2
	mv a1, s3
	jal ra, node_data
	mv s4, a0
	add s2, s1, s4
	sw s2, -36(s0)
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L13_0
	sltu s1, s10, s8
.L13_0:
	bnez s1, .L13_1
	j .L13_2
.L13_2:
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -32(s0)
	mv s8, s1
	li s9, 0
	slt s1, s11, s9
	bne s11, s9, .L13_3
	sltu s1, s10, s8
.L13_3:
	xori s1, s1, 1
	bnez s1, .L13_1
	j .L13_4
.L13_1:
	li s1, 0
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
.L13_4:
	lw s1, -32(s0)
	mv s10, s1
	li s11, 0
	lw s1, -20(s0)
	lw s8, 0(s1)
	lw s9, 4(s1)
	sltu t0, s10, s8
	sub s6, s10, s8
	sub s7, s11, t0
	sub s7, s7, s9
	sw s6, -48(s0)
	sw s7, -44(s0)
	lw s1, -16(s0)
	mv s10, s1
	srai s11, s10, 31
	lw s8, -48(s0)
	lw s9, -44(s0)
	slt s1, s9, s11
	bne s9, s11, .L13_5
	sltu s1, s8, s10
.L13_5:
	bnez s1, .L13_6
	j .L13_7
.L13_6:
	lw s10, -48(s0)
	lw s11, -44(s0)
	mv s1, s10
	sw s1, -16(s0)
.L13_7:
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, 0(s2)
	lw s2, -36(s0)
	add s4, s3, s2
	lw s2, -20(s0)
	lw s10, 0(s2)
	lw s11, 4(s2)
	mv s2, s10
	add s3, s4, s2
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
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
.Lfunc_end13:
	.size rom_read, .Lfunc_end13-rom_read

	.text
	.align 2
	.type rom_write, @function
rom_write:
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
	sw a4, -20(s0)
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
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -16(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 18
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
.Lfunc_end14:
	.size rom_write, .Lfunc_end14-rom_write

	.text
	.align 2
	.type rom_lseek, @function
rom_lseek:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, img_of
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_0
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_1
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_2
	j .L15_3
.L15_0:
	lw s10, -16(s0)
	lw s11, -12(s0)
	sw s10, -40(s0)
	sw s11, -36(s0)
	j .L15_4
.L15_1:
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
	j .L15_4
.L15_2:
	lw s1, -28(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_size
	mv s3, a0
	mv s10, s3
	li s11, 0
	lw s8, -16(s0)
	lw s9, -12(s0)
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -40(s0)
	sw s7, -36(s0)
	j .L15_4
.L15_3:
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
.L15_4:
	lw s10, -40(s0)
	lw s11, -36(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L15_5
	sltu s1, s10, s8
.L15_5:
	bnez s1, .L15_6
	j .L15_7
.L15_6:
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
.L15_7:
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
.Lfunc_end15:
	.size rom_lseek, .Lfunc_end15-rom_lseek

	.text
	.align 2
	.type rom_fill_stat, @function
rom_fill_stat:
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
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_type
	mv s3, a0
	li s1, 1
	xor s2, s3, s1
	seqz s2, s2
	sw s2, -20(s0)
	li s1, 29261
	lw s2, -12(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s2)
	sw s11, 4(s2)
	lw s1, -8(s0)
	mv s10, s1
	li s11, 0
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	sw s6, 0(s3)
	sw s7, 4(s3)
	lw s1, -20(s0)
	bnez s1, .L16_0
	j .L16_1
.L16_0:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -32(s0)
	sw s11, -28(s0)
	j .L16_2
.L16_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_size
	mv s3, a0
	mv s10, s3
	li s11, 0
	sw s10, -32(s0)
	sw s11, -28(s0)
.L16_2:
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -20(s0)
	bnez s1, .L16_3
	j .L16_4
.L16_3:
	li s1, 16384
	li s2, 365
	or s3, s1, s2
	sw s3, -36(s0)
	j .L16_5
.L16_4:
	li s1, 32768
	li s2, 292
	or s3, s1, s2
	sw s3, -36(s0)
.L16_5:
	lw s1, -36(s0)
	lw s2, -12(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 28
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
.Lfunc_end16:
	.size rom_fill_stat, .Lfunc_end16-rom_fill_stat

	.text
	.align 2
	.type rom_readdir, @function
rom_readdir:
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
	jal ra, img_of
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -12(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	mv s1, s10
	sw s1, -24(s0)
.L17_0:
	lw s1, -24(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	sltu s3, s1, s2
	bnez s3, .L17_1
	j .L17_2
.L17_1:
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_parent
	mv s3, a0
	lw s1, -8(s0)
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L17_3
	j .L17_4
.L17_3:
	j .L17_5
.L17_4:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	sw s3, 0(s1)
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_type
	mv s3, a0
	li s1, 1
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L17_6
	j .L17_7
.L17_6:
	li s1, 2
	sw s1, -28(s0)
	j .L17_8
.L17_7:
	li s1, 1
	sw s1, -28(s0)
.L17_8:
	lw s1, -28(s0)
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
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_name_str
	mv s4, a0
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
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	mv s10, s3
	li s11, 0
	sw s10, 0(s1)
	sw s11, 4(s1)
	li s1, 1
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
.L17_5:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L17_0
.L17_2:
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
.Lfunc_end17:
	.size rom_readdir, .Lfunc_end17-rom_readdir

	.text
	.align 2
	.type rom_close, @function
rom_close:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
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
.Lfunc_end18:
	.size rom_close, .Lfunc_end18-rom_close

	.text
	.align 2
	.type rom_exists, @function
rom_exists:
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
	mv a0, s1
	jal ra, img_of
	mv s2, a0
	lw s1, -8(s0)
	lw s3, -12(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, walk
	mv s4, a0
	li s1, 0
	slt s2, s4, s1
	xori s2, s2, 1
	bnez s2, .L19_0
	j .L19_1
.L19_0:
	li s1, 1
	sw s1, -20(s0)
	j .L19_2
.L19_1:
	li s1, 0
	sw s1, -20(s0)
.L19_2:
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
.Lfunc_end19:
	.size rom_exists, .Lfunc_end19-rom_exists

	.text
	.align 2
	.type rom_size, @function
rom_size:
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
	mv a0, s1
	jal ra, img_of
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk
	mv s4, a0
	sw s4, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_0
	j .L20_1
.L20_0:
	lw s1, -24(s0)
	mv s10, s1
	srai s11, s10, 31
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
.L20_1:
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_type
	mv s3, a0
	li s1, 1
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L20_2
	j .L20_3
.L20_2:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -32(s0)
	sw s11, -28(s0)
	j .L20_4
.L20_3:
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_size
	mv s3, a0
	mv s10, s3
	li s11, 0
	sw s10, -32(s0)
	sw s11, -28(s0)
.L20_4:
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
.Lfunc_end20:
	.size rom_size, .Lfunc_end20-rom_size

	.text
	.align 2
	.type rom_isdir, @function
rom_isdir:
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
	mv a0, s1
	jal ra, img_of
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk
	mv s4, a0
	sw s4, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L21_0
	j .L21_1
.L21_0:
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node_type
	mv s3, a0
	li s1, 1
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L21_2
	j .L21_1
.L21_2:
	li s1, 1
	sw s1, -28(s0)
	j .L21_3
.L21_1:
	li s1, 0
	sw s1, -28(s0)
.L21_3:
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
.Lfunc_end21:
	.size rom_isdir, .Lfunc_end21-rom_isdir

	.text
	.align 2
	.type rom_stat, @function
rom_stat:
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
	mv a0, s1
	jal ra, img_of
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk
	mv s4, a0
	sw s4, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L22_0
	j .L22_1
.L22_0:
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
.L22_1:
	lw s1, -20(s0)
	lw s2, -24(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rom_fill_stat
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
.Lfunc_end22:
	.size rom_stat, .Lfunc_end22-rom_stat

	.text
	.align 2
	.type rom_fstat, @function
rom_fstat:
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
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	mv a0, s1
	jal ra, img_of
	mv s2, a0
	lw s1, -8(s0)
	lw s3, -16(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, rom_fill_stat
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
.Lfunc_end23:
	.size rom_fstat, .Lfunc_end23-rom_fstat

	.text
	.align 2
	.type rom_ro, @function
rom_ro:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 18
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
.Lfunc_end24:
	.size rom_ro, .Lfunc_end24-rom_ro

	.text
	.align 2
	.type rom_ro2, @function
rom_ro2:
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
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -16(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 18
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
.Lfunc_end25:
	.size rom_ro2, .Lfunc_end25-rom_ro2

	.text
	.align 2
	.type romfs_parse, @function
romfs_parse:
	addi sp, sp, -160
	sw ra, 156(sp)
	sw s0, 152(sp)
	addi s0, sp, 152
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
	sw s1, -20(s0)
	lw s1, -8(s0)
	li s2, 32
	sltu s3, s1, s2
	bnez s3, .L26_0
	j .L26_1
.L26_1:
	lw s1, -20(s0)
	la s2, __str_1
	li s3, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv t0, a0
	sw t0, -68(s0)
	li s1, 0
	lw t0, -68(s0)
	xor s2, t0, s1
	snez s2, s2
	bnez s2, .L26_0
	j .L26_2
.L26_0:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_2:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L26_3
	j .L26_4
.L26_3:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_4:
	lw s1, -20(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add t0, s2, s3
	sw t0, -72(s0)
	lw t0, -72(s0)
	sw s1, 0(t0)
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	lw s2, -12(s0)
	li s3, 8
	add t0, s2, s3
	sw t0, -76(s0)
	lw t0, -76(s0)
	sw s1, 0(t0)
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	lw s2, -12(s0)
	li s3, 12
	add t0, s2, s3
	sw t0, -80(s0)
	lw t0, -80(s0)
	sw s1, 0(t0)
	lw s1, -20(s0)
	li s2, 20
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	lw s2, -12(s0)
	li s3, 16
	add t0, s2, s3
	sw t0, -84(s0)
	lw t0, -84(s0)
	sw s1, 0(t0)
	lw s1, -20(s0)
	li s2, 24
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	lw s2, -12(s0)
	li s3, 20
	add t0, s2, s3
	sw t0, -88(s0)
	lw t0, -88(s0)
	sw s1, 0(t0)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_5
	j .L26_6
.L26_6:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	mv s10, s1
	li s11, 0
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv s8, s1
	li s9, 0
	li s1, 20
	mv s6, s1
	srai s7, s6, 31
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -8
	sw s6, 0(sp)
	sw s7, 4(sp)
	jal ra, __muldi3
	addi sp, sp, 16
	mv s4, a0
	mv s5, a1
	add s8, s10, s4
	sltu t0, s8, s4
	add s9, s11, t0
	add s9, s9, s5
	lw s1, -8(s0)
	mv s10, s1
	li s11, 0
	sltu s1, s11, s9
	bne s11, s9, .L26_7
	sltu s1, s10, s8
.L26_7:
	bnez s1, .L26_5
	j .L26_8
.L26_8:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sltu s3, s2, s1
	bnez s3, .L26_5
	j .L26_9
.L26_9:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sltu s3, s2, s1
	bnez s3, .L26_5
	j .L26_10
.L26_5:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_10:
	li s1, 0
	sw s1, -24(s0)
.L26_11:
	lw t0, -24(s0)
	sw t0, -92(s0)
	lw s2, -12(s0)
	li s3, 8
	add s1, s2, s3
	lw s2, 0(s1)
	lw t0, -92(s0)
	sltu s1, t0, s2
	bnez s1, .L26_12
	j .L26_13
.L26_12:
	lw t0, -20(s0)
	sw t0, -96(s0)
	lw s2, -12(s0)
	li s3, 12
	add s1, s2, s3
	lw s2, 0(s1)
	lw t0, -96(s0)
	add s1, t0, s2
	lw s2, -24(s0)
	li s3, 20
	mul t0, s2, s3
	sw t0, -100(s0)
	lw t1, -100(s0)
	add s2, s1, t1
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	sw s1, -32(s0)
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	sw s1, -36(s0)
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	sw s1, -40(s0)
	lw s1, -28(s0)
	li s2, 12
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	sw s1, -44(s0)
	lw s1, -28(s0)
	li s2, 16
	add s3, s1, s2
	mv a0, s3
	jal ra, rd_u32
	mv s1, a0
	sw s1, -48(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv s10, s1
	li s11, 0
	lw s1, -32(s0)
	mv s8, s1
	li s9, 0
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -56(s0)
	sw s7, -52(s0)
	li s1, 0
	sw s1, -64(s0)
	lw s1, -36(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L26_14
	j .L26_15
.L26_14:
	lw s1, -36(s0)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L26_16
	j .L26_15
.L26_16:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_15:
	lw s1, -40(s0)
	li s2, 1
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L26_17
	j .L26_18
.L26_18:
	lw t0, -40(s0)
	sw t0, -104(s0)
	lw s2, -12(s0)
	li s3, 8
	add s1, s2, s3
	lw s2, 0(s1)
	lw t0, -104(s0)
	slt s1, t0, s2
	xori s1, s1, 1
	bnez s1, .L26_17
	j .L26_19
.L26_17:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_19:
	lw s10, -56(s0)
	lw s11, -52(s0)
	lw s1, -8(s0)
	mv s8, s1
	li s9, 0
	sltu s1, s11, s9
	bne s11, s9, .L26_20
	sltu s1, s10, s8
.L26_20:
	xori s1, s1, 1
	bnez s1, .L26_21
	j .L26_22
.L26_21:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_22:
	lw s10, -56(s0)
	lw s11, -52(s0)
	mv s1, s10
	sw s1, -60(s0)
.L26_23:
	lw s1, -60(s0)
	lw s2, -8(s0)
	sltu s3, s1, s2
	bnez s3, .L26_24
	j .L26_25
.L26_24:
	lw s1, -20(s0)
	lw s2, -60(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_26
	j .L26_27
.L26_26:
	li s1, 1
	sw s1, -64(s0)
	j .L26_25
.L26_27:
.L26_28:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
	j .L26_23
.L26_25:
	lw s1, -64(s0)
	bnez s1, .L26_29
	j .L26_30
.L26_30:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_29:
	lw s1, -36(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_31
	j .L26_32
.L26_31:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv s10, s1
	li s11, 0
	lw s1, -44(s0)
	mv s8, s1
	li s9, 0
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	lw s1, -48(s0)
	mv s10, s1
	li s11, 0
	add s8, s6, s10
	sltu t0, s8, s10
	add s9, s7, t0
	add s9, s9, s11
	lw s1, -8(s0)
	mv s10, s1
	li s11, 0
	sltu s1, s11, s9
	bne s11, s9, .L26_33
	sltu s1, s10, s8
.L26_33:
	bnez s1, .L26_34
	j .L26_32
.L26_34:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L26_32:
.L26_35:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L26_11
.L26_13:
	li s1, 0
	mv a0, s1
	lw s1, -148(s0)
	lw s2, -144(s0)
	lw s3, -140(s0)
	lw s4, -136(s0)
	lw s5, -132(s0)
	lw s6, -128(s0)
	lw s7, -124(s0)
	lw s8, -120(s0)
	lw s9, -116(s0)
	lw s10, -112(s0)
	lw s11, -108(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end26:
	.size romfs_parse, .Lfunc_end26-romfs_parse

	.text
	.align 2
	.globl romfs_mount
	.type romfs_mount, @function
romfs_mount:
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
	sw a3, -16(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, romfs_parse
	mv s4, a0
	sw s4, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L27_0
	j .L27_1
.L27_0:
	lw s1, -48(s0)
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
.L27_1:
	lw s1, -4(s0)
	li s2, 3
	li s3, 0
	lw s4, -16(s0)
	li s5, 256
	or s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, fs_install_mount
	mv s4, a0
	sw s4, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L27_2
	j .L27_3
.L27_2:
	lw s1, -44(s0)
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
.L27_3:
	addi s1, s0, -40
	la s2, images
	lw s3, -44(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s1)
	sw s2, 0(s3)
	li s2, 4
	add s4, s1, s2
	lw s2, 0(s4)
	li s4, 4
	add s5, s3, s4
	sw s2, 0(s5)
	li s2, 8
	add s4, s1, s2
	lw s2, 0(s4)
	li s4, 8
	add s5, s3, s4
	sw s2, 0(s5)
	li s2, 12
	add s4, s1, s2
	lw s2, 0(s4)
	li s4, 12
	add s5, s3, s4
	sw s2, 0(s5)
	li s2, 16
	add s4, s1, s2
	lw s2, 0(s4)
	li s4, 16
	add s5, s3, s4
	sw s2, 0(s5)
	li s2, 20
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 20
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -44(s0)
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
.Lfunc_end27:
	.size romfs_mount, .Lfunc_end27-romfs_mount

	.text
	.align 2
	.globl romfs_adopt
	.type romfs_adopt, @function
romfs_adopt:
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
	lw s1, -8(s0)
	lw s2, -12(s0)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, romfs_parse
	mv s4, a0
	sw s4, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L28_0
	j .L28_1
.L28_0:
	lw s1, -44(s0)
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
.L28_1:
	la s1, fs_mounts
	lw s2, -4(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 256
	or s4, s1, s2
	sw s4, 0(s3)
	addi s1, s0, -40
	la s2, images
	lw s3, -4(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s1)
	sw s2, 0(s3)
	li s2, 4
	add s4, s1, s2
	lw s2, 0(s4)
	li s4, 4
	add s5, s3, s4
	sw s2, 0(s5)
	li s2, 8
	add s4, s1, s2
	lw s2, 0(s4)
	li s4, 8
	add s5, s3, s4
	sw s2, 0(s5)
	li s2, 12
	add s4, s1, s2
	lw s2, 0(s4)
	li s4, 12
	add s5, s3, s4
	sw s2, 0(s5)
	li s2, 16
	add s4, s1, s2
	lw s2, 0(s4)
	li s4, 16
	add s5, s3, s4
	sw s2, 0(s5)
	li s2, 20
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 20
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
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
.Lfunc_end28:
	.size romfs_adopt, .Lfunc_end28-romfs_adopt

	.data
	.align 2
__str_1:
	.ascii "SKJROMFS\000"
	.align 2
__str_0:
	.ascii "romfs\000"

	.section .rodata
	.align 2
	.globl romfs_backend
romfs_backend:
	.word 0x00000003
	.word __str_0
	.word rom_open
	.word rom_read
	.word rom_write
	.word rom_lseek
	.word rom_readdir
	.word rom_close
	.word rom_exists
	.word rom_size
	.word rom_isdir
	.word rom_stat
	.word rom_fstat
	.word rom_ro
	.word rom_ro2
	.word rom_ro
	.word rom_ro

	.bss
	.align 2
	.globl images
images:
	.space 384
