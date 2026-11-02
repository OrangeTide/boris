# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type fs_strchr, @function
fs_strchr:
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
.L1_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L1_1
	j .L1_2
.L1_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	lw s1, -8(s0)
	li s3, 24
	sll s4, s1, s3
	li s1, 24
	sra s3, s4, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L1_3
	j .L1_4
.L1_3:
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
.L1_4:
.L1_5:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L1_0
.L1_2:
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
	.size fs_strchr, .Lfunc_end1-fs_strchr

	.text
	.align 2
	.type fs_strrchr, @function
fs_strrchr:
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
.L2_0:
	lw s1, -4(s0)
	lb s2, 0(s1)
	bnez s2, .L2_1
	j .L2_2
.L2_1:
	lw s1, -4(s0)
	lb s2, 0(s1)
	lw s1, -8(s0)
	li s3, 24
	sll s4, s1, s3
	li s1, 24
	sra s3, s4, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L2_3
	j .L2_4
.L2_3:
	lw s1, -4(s0)
	sw s1, -12(s0)
.L2_4:
.L2_5:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L2_0
.L2_2:
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
.Lfunc_end2:
	.size fs_strrchr, .Lfunc_end2-fs_strrchr

	.text
	.align 2
	.type backend_for, @function
backend_for:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_0
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_1
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_2
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_3
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_4
	j .L3_5
.L3_0:
	la s1, ramfs_backend
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
.L3_1:
	la s1, dev_backend
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
.L3_2:
	la s1, romfs_backend
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
.L3_3:
	la s1, ninefs_backend
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
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 512
	and s3, s1, s2
	bnez s3, .L3_6
	j .L3_7
.L3_7:
	la s1, hostcap_backend
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
.L3_6:
	la s1, ambient_backend
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
.L3_5:
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
.L3_8:
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
	.size backend_for, .Lfunc_end3-backend_for

	.text
	.align 2
	.type fd_alloc, @function
fd_alloc:
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
	li s1, 3
	sw s1, -20(s0)
.L4_0:
	lw s1, -20(s0)
	li s2, 64
	slt s3, s1, s2
	bnez s3, .L4_1
	j .L4_2
.L4_1:
	la s1, fd_tab
	lw s2, -20(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_3
	j .L4_4
.L4_3:
	lw s1, -4(s0)
	la s2, fd_tab
	lw s3, -20(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -8(s0)
	la s2, fd_tab
	lw s3, -20(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -12(s0)
	la s2, fd_tab
	lw s3, -20(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	la s2, fd_tab
	lw s3, -20(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 16
	add s4, s3, s2
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
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
.L4_4:
.L4_5:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L4_0
.L4_2:
	li s1, 16
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
.Lfunc_end4:
	.size fd_alloc, .Lfunc_end4-fd_alloc

	.text
	.align 2
	.type fd_get, @function
fd_get:
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
	slt s3, s1, s2
	bnez s3, .L5_0
	j .L5_1
.L5_1:
	lw s1, -4(s0)
	li s2, 64
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_0
	j .L5_2
.L5_2:
	la s1, fd_tab
	lw s2, -4(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_0
	j .L5_3
.L5_0:
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
.L5_3:
	la s1, fd_tab
	lw s2, -4(s0)
	li s3, 24
	mul s4, s2, s3
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
.Lfunc_end5:
	.size fd_get, .Lfunc_end5-fd_get

	.text
	.align 2
	.type pad_name, @function
pad_name:
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
.L6_0:
	lw s1, -12(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L6_1
	j .L6_2
.L6_1:
	lw s1, -8(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L6_3
	j .L6_2
.L6_3:
	lw s1, -8(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	lw s2, -4(s0)
	lw s3, -12(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L6_4:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L6_0
.L6_2:
.L6_5:
	lw s1, -12(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L6_6
	j .L6_7
.L6_6:
	li s1, 0
	lw s2, -4(s0)
	lw s3, -12(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L6_8:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L6_5
.L6_7:
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
.Lfunc_end6:
	.size pad_name, .Lfunc_end6-pad_name

	.text
	.align 2
	.type is_root_alias, @function
is_root_alias:
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
	li s1, 0
	sw s1, -28(s0)
.L7_0:
	lw s1, -28(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L7_1
	j .L7_2
.L7_1:
	lw s1, -4(s0)
	lw s2, -28(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	sw s1, -32(s0)
	addi s1, s0, -32
	lb s2, 0(s1)
	li s1, 97
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L7_3
	j .L7_4
.L7_3:
	addi s1, s0, -32
	lb s2, 0(s1)
	li s1, 122
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L7_5
	j .L7_4
.L7_5:
	addi s1, s0, -32
	lb s2, 0(s1)
	li s1, 32
	sub s3, s2, s1
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	sw s3, -36(s0)
	j .L7_6
.L7_4:
	addi s1, s0, -32
	lb s2, 0(s1)
	sw s2, -36(s0)
.L7_6:
	lw s1, -36(s0)
	addi s2, s0, -16
	lw s3, -28(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L7_7:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L7_0
.L7_2:
	addi s1, s0, -24
	la s2, __str_0
	mv a0, s1
	mv a1, s2
	jal ra, pad_name
	mv s3, a0
	addi s1, s0, -16
	addi s2, s0, -24
	li s3, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	mv a0, s2
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
.Lfunc_end7:
	.size is_root_alias, .Lfunc_end7-is_root_alias

	.text
	.align 2
	.type root_mount, @function
root_mount:
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
	la s1, fs_mount_count
	lw s2, 0(s1)
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L8_0
	j .L8_1
.L8_0:
	la s1, fs_mounts
	li s2, 0
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lh s1, 0(s3)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L8_2
	j .L8_1
.L8_2:
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
.L8_1:
	li s1, 1
	neg s2, s1
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
.Lfunc_end8:
	.size root_mount, .Lfunc_end8-root_mount

	.text
	.align 2
	.globl fs_install_mount
	.type fs_install_mount, @function
fs_install_mount:
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
	la s1, fs_mount_count
	lw s2, 0(s1)
	li s1, 16
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_0
	j .L9_1
.L9_0:
	li s1, 5
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
.L9_1:
	la s1, fs_mount_count
	lw s2, 0(s1)
	sw s2, -24(s0)
	li s1, 3
	lw s2, -24(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fd_alloc
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L9_2
	j .L9_3
.L9_2:
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
.L9_3:
	la s1, fs_mounts
	lw s2, -24(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	li s3, 16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -20(s0)
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, pad_name
	mv s3, a0
	lw s1, -28(s0)
	li s2, 16
	sll s3, s1, s2
	li s1, 16
	sra s2, s3, s1
	lw s1, -20(s0)
	li s3, 8
	add s4, s1, s3
	sh s2, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -20(s0)
	li s3, 10
	add s4, s1, s3
	sh s2, 0(s4)
	lw s1, -16(s0)
	li s2, 255
	not s3, s2
	and s2, s1, s3
	lw s1, -8(s0)
	li s3, 255
	and s4, s1, s3
	or s1, s2, s4
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	la s2, cwd_path
	lw s3, -24(s0)
	li s4, 256
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 0
	add s4, s3, s2
	sb s1, 0(s4)
	la s1, fs_mount_count
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -24(s0)
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
.Lfunc_end9:
	.size fs_install_mount, .Lfunc_end9-fs_install_mount

	.text
	.align 2
	.type split_path, @function
split_path:
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
	lw s1, -4(s0)
	li s2, 58
	mv a0, s1
	mv a1, s2
	jal ra, fs_strchr
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, fs_strchr
	mv s3, a0
	sw s3, -16(s0)
	lw s1, -12(s0)
	bnez s1, .L10_0
	j .L10_1
.L10_0:
	lw s1, -16(s0)
	bnez s1, .L10_2
	j .L10_3
.L10_2:
	lw s1, -12(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L10_3
	j .L10_1
.L10_3:
	lw s1, -12(s0)
	lw s2, -4(s0)
	sub s3, s1, s2
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 8
	slt s3, s2, s1
	bnez s3, .L10_4
	j .L10_5
.L10_4:
	li s1, 4
	neg s2, s1
	mv a0, s2
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
.L10_5:
	addi s1, s0, -24
	la s2, __str_1
	mv a0, s1
	mv a1, s2
	jal ra, pad_name
	mv s3, a0
	addi s1, s0, -24
	lw s2, -4(s0)
	lw s3, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 1
	neg s2, s1
	sw s2, -32(s0)
	li s1, 0
	sw s1, -36(s0)
.L10_6:
	lw s1, -36(s0)
	la s2, fs_mount_count
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L10_7
	j .L10_8
.L10_7:
	la s1, fs_mounts
	lw s2, -36(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lh s1, 0(s3)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L10_9
	j .L10_10
.L10_9:
	la s1, fs_mounts
	lw s2, -36(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	addi s1, s0, -24
	li s3, 8
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L10_11
	j .L10_10
.L10_11:
	lw s1, -36(s0)
	sw s1, -32(s0)
	j .L10_8
.L10_10:
.L10_12:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L10_6
.L10_8:
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L10_13
	j .L10_14
.L10_13:
	addi s1, s0, -24
	mv a0, s1
	jal ra, is_root_alias
	mv s2, a0
	bnez s2, .L10_15
	j .L10_14
.L10_15:
	jal ra, root_mount
	mv s1, a0
	sw s1, -32(s0)
.L10_14:
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L10_16
	j .L10_17
.L10_16:
	li s1, 6
	neg s2, s1
	mv a0, s2
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
.L10_17:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -8(s0)
	sw s3, 0(s1)
	lw s1, -32(s0)
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
.L10_1:
	la s1, fs_cur_mount
	lw s2, 0(s1)
	li s1, 0
	slt s3, s2, s1
	bnez s3, .L10_18
	j .L10_19
.L10_19:
	la s1, fs_cur_mount
	lw s2, 0(s1)
	la s1, fs_mount_count
	lw s3, 0(s1)
	slt s1, s2, s3
	xori s1, s1, 1
	bnez s1, .L10_18
	j .L10_20
.L10_20:
	la s1, fs_mounts
	la s2, fs_cur_mount
	lw s3, 0(s2)
	li s2, 16
	mul s4, s3, s2
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lh s1, 0(s3)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L10_18
	j .L10_21
.L10_18:
	li s1, 6
	neg s2, s1
	mv a0, s2
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
.L10_21:
	lw s1, -4(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
	la s1, fs_cur_mount
	lw s2, 0(s1)
	mv a0, s2
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
	.size split_path, .Lfunc_end10-split_path

	.text
	.align 2
	.type resolve_op, @function
resolve_op:
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
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	jal ra, fs_init
	mv s1, a0
	lw s1, -4(s0)
	addi s2, s0, -28
	mv a0, s1
	mv a1, s2
	jal ra, split_path
	mv s3, a0
	sw s3, -40(s0)
	lw s1, -40(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	lw s1, -40(s0)
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
.L11_1:
	la s1, fs_mounts
	lw s2, -40(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -32(s0)
	lw s1, -32(s0)
	mv a0, s1
	jal ra, backend_for
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -36(s0)
	bnez s1, .L11_2
	j .L11_3
.L11_3:
	li s1, 20
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
.L11_2:
	lw s1, -32(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 512
	and s3, s1, s2
	bnez s3, .L11_4
	j .L11_5
.L11_4:
	lw s1, -32(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -36(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	la s1, fd_tab
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	lh s2, 0(s4)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -28(s0)
	lw s2, -20(s0)
	sw s1, 0(s2)
	lw s1, -24(s0)
	bnez s1, .L11_6
	j .L11_7
.L11_6:
	li s1, 0
	lw s2, -24(s0)
	sw s1, 0(s2)
.L11_7:
	li s1, 0
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
.L11_5:
	lw s1, -28(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -44(s0)
	lw s1, -44(s0)
	bnez s1, .L11_8
	j .L11_9
.L11_8:
	lw s1, -32(s0)
	li s2, 8
	add s3, s1, s2
	lh s1, 0(s3)
	sw s1, -52(s0)
	j .L11_10
.L11_9:
	lw s1, -32(s0)
	li s2, 10
	add s3, s1, s2
	lh s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_11
	j .L11_12
.L11_11:
	lw s1, -32(s0)
	li s2, 10
	add s3, s1, s2
	lh s1, 0(s3)
	sw s1, -56(s0)
	j .L11_13
.L11_12:
	lw s1, -32(s0)
	li s2, 8
	add s3, s1, s2
	lh s1, 0(s3)
	sw s1, -56(s0)
.L11_13:
	lw s1, -56(s0)
	sw s1, -52(s0)
.L11_10:
	lw s1, -52(s0)
	sw s1, -48(s0)
	lw s1, -48(s0)
	mv a0, s1
	jal ra, fd_get
	mv s2, a0
	bnez s2, .L11_14
	j .L11_15
.L11_15:
	li s1, 7
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
.L11_14:
.L11_16:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_17
	j .L11_18
.L11_17:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L11_16
.L11_18:
	lw s1, -32(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -36(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	la s1, fd_tab
	lw s2, -48(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -28(s0)
	lw s2, -20(s0)
	sw s1, 0(s2)
	lw s1, -24(s0)
	bnez s1, .L11_19
	j .L11_20
.L11_19:
	lw s1, -44(s0)
	lw s2, -24(s0)
	sw s1, 0(s2)
.L11_20:
	li s1, 0
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
.Lfunc_end11:
	.size resolve_op, .Lfunc_end11-resolve_op

	.text
	.align 2
	.globl fs_open
	.type fs_open, @function
fs_open:
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
	sw a2, -12(s0)
	lw s1, -4(s0)
	addi s2, s0, -20
	addi s3, s0, -24
	addi s4, s0, -28
	addi s5, s0, -36
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -40(s0)
	lw s1, -40(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_0
	j .L12_1
.L12_0:
	lw s1, -40(s0)
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
.L12_1:
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 256
	and s3, s1, s2
	bnez s3, .L12_2
	j .L12_3
.L12_2:
	lw s1, -8(s0)
	li s2, 3
	and s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L12_4
	j .L12_5
.L12_5:
	lw s1, -8(s0)
	li s2, 64
	and s3, s1, s2
	bnez s3, .L12_4
	j .L12_3
.L12_4:
	li s1, 18
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
.L12_3:
	lw s1, -24(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	lw s3, -28(s0)
	lw s4, -36(s0)
	lw s5, -8(s0)
	lw s6, -12(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv t0, s1
	jalr ra, t0, 0
	mv s7, a0
	sw s7, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_6
	j .L12_7
.L12_6:
	lw s1, -32(s0)
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
.L12_7:
	lw s1, -8(s0)
	li s2, 65536
	and s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	sw s2, -48(s0)
	lw s1, -48(s0)
	bnez s1, .L12_8
	j .L12_9
.L12_8:
	li s1, 2
	sw s1, -52(s0)
	j .L12_10
.L12_9:
	li s1, 1
	sw s1, -52(s0)
.L12_10:
	lw s1, -52(s0)
	lw s2, -20(s0)
	la s3, fs_mounts
	sub s4, s2, s3
	li s2, 16
	div s3, s4, s2
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, fd_alloc
	mv s4, a0
	sw s4, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_11
	j .L12_12
.L12_11:
	lw s1, -24(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	lw s3, -32(s0)
	lw s4, -48(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
.L12_12:
	lw s1, -44(s0)
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
.Lfunc_end12:
	.size fs_open, .Lfunc_end12-fs_open

	.text
	.align 2
	.globl fs_read
	.type fs_read, @function
fs_read:
	addi sp, sp, -160
	sw ra, 156(sp)
	sw s0, 152(sp)
	addi s0, sp, 152
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
	jal ra, fd_get
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L13_0
	j .L13_1
.L13_1:
	li s1, 7
	neg s2, s1
	mv a0, s2
	lw s1, -140(s0)
	lw s2, -136(s0)
	lw s3, -132(s0)
	lw s4, -128(s0)
	lw s5, -124(s0)
	lw s6, -120(s0)
	lw s7, -116(s0)
	lw s8, -112(s0)
	lw s9, -108(s0)
	lw s10, -104(s0)
	lw s11, -100(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_0:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_2
	j .L13_3
.L13_2:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, __sys_read
	mv s4, a0
	mv a0, s4
	lw s1, -140(s0)
	lw s2, -136(s0)
	lw s3, -132(s0)
	lw s4, -128(s0)
	lw s5, -124(s0)
	lw s6, -120(s0)
	lw s7, -116(s0)
	lw s8, -112(s0)
	lw s9, -108(s0)
	lw s10, -104(s0)
	lw s11, -100(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_3:
	la s1, fs_mounts
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, backend_for
	mv s1, a0
	sw s1, -24(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_4
	j .L13_5
.L13_4:
	lw s1, -24(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, fs_mounts
	lw s3, -20(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, -20(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -8(s0)
	lw s5, -12(s0)
	lw s6, -20(s0)
	li s7, 16
	add s8, s6, s7
	mv a0, s3
	mv a1, s2
	mv a2, s4
	mv a3, s5
	mv a4, s8
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	mv a0, s6
	lw s1, -140(s0)
	lw s2, -136(s0)
	lw s3, -132(s0)
	lw s4, -128(s0)
	lw s5, -124(s0)
	lw s6, -120(s0)
	lw s7, -116(s0)
	lw s8, -112(s0)
	lw s9, -108(s0)
	lw s10, -104(s0)
	lw s11, -100(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_5:
	lw s1, -12(s0)
	li s2, 64
	slt s3, s1, s2
	bnez s3, .L13_6
	j .L13_7
.L13_6:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -140(s0)
	lw s2, -136(s0)
	lw s3, -132(s0)
	lw s4, -128(s0)
	lw s5, -124(s0)
	lw s6, -120(s0)
	lw s7, -116(s0)
	lw s8, -112(s0)
	lw s9, -108(s0)
	lw s10, -104(s0)
	lw s11, -100(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_7:
	lw s1, -24(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, fs_mounts
	lw s3, -20(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, -20(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -20(s0)
	li s5, 16
	add s6, s4, s5
	addi s4, s0, -88
	mv a0, s3
	mv a1, s2
	mv a2, s6
	mv a3, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	sw s5, -92(s0)
	lw s1, -92(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L13_8
	j .L13_9
.L13_8:
	lw s1, -92(s0)
	mv a0, s1
	lw s1, -140(s0)
	lw s2, -136(s0)
	lw s3, -132(s0)
	lw s4, -128(s0)
	lw s5, -124(s0)
	lw s6, -120(s0)
	lw s7, -116(s0)
	lw s8, -112(s0)
	lw s9, -108(s0)
	lw s10, -104(s0)
	lw s11, -100(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_9:
	lw s1, -8(s0)
	addi s2, s0, -88
	li s3, 64
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 64
	mv a0, s1
	lw s1, -140(s0)
	lw s2, -136(s0)
	lw s3, -132(s0)
	lw s4, -128(s0)
	lw s5, -124(s0)
	lw s6, -120(s0)
	lw s7, -116(s0)
	lw s8, -112(s0)
	lw s9, -108(s0)
	lw s10, -104(s0)
	lw s11, -100(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end13:
	.size fs_read, .Lfunc_end13-fs_read

	.text
	.align 2
	.globl fs_write
	.type fs_write, @function
fs_write:
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
	jal ra, fd_get
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L14_0
	j .L14_1
.L14_1:
	li s1, 7
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
.L14_0:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_2
	j .L14_3
.L14_2:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, __sys_write
	mv s4, a0
	mv a0, s4
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
.L14_3:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L14_4
	j .L14_5
.L14_4:
	li s1, 7
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
.L14_5:
	la s1, fs_mounts
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 256
	and s3, s1, s2
	bnez s3, .L14_6
	j .L14_7
.L14_6:
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
.L14_7:
	la s1, fs_mounts
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, backend_for
	mv s1, a0
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, fs_mounts
	lw s3, -20(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, -20(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -8(s0)
	lw s5, -12(s0)
	lw s6, -20(s0)
	li s7, 16
	add s8, s6, s7
	mv a0, s3
	mv a1, s2
	mv a2, s4
	mv a3, s5
	mv a4, s8
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	mv a0, s6
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
	.size fs_write, .Lfunc_end14-fs_write

	.text
	.align 2
	.globl fs_lseek
	.type fs_lseek, @function
fs_lseek:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	sw a3, -20(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, fd_get
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	bnez s1, .L15_0
	j .L15_1
.L15_1:
	li s1, 7
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
.L15_0:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L15_2
	j .L15_3
.L15_2:
	li s1, 19
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
.L15_3:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L15_4
	j .L15_5
.L15_4:
	li s1, 7
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
.L15_5:
	la s1, fs_mounts
	lw s2, -28(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, backend_for
	mv s1, a0
	sw s1, -32(s0)
	lw s1, -32(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L15_6
	j .L15_7
.L15_7:
	li s1, 19
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
.L15_6:
	lw s1, -32(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, fs_mounts
	lw s3, -28(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, -28(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s4, -20(s0)
	lw s5, -28(s0)
	li s6, 16
	add s7, s5, s6
	mv a0, s3
	mv a1, s2
	mv a2, s10
	mv a3, s11
	mv a4, s4
	mv a5, s7
	mv t0, s1
	jalr ra, t0, 0
	mv s8, a0
	mv s9, a1
	sw s8, -40(s0)
	sw s9, -36(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L15_8
	sltu s1, s10, s8
.L15_8:
	xori s1, s1, 1
	bnez s1, .L15_9
	j .L15_10
.L15_9:
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw s1, -28(s0)
	li s2, 16
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
.L15_10:
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
	.size fs_lseek, .Lfunc_end15-fs_lseek

	.text
	.align 2
	.globl fs_close
	.type fs_close, @function
fs_close:
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
	jal ra, fd_get
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L16_0
	j .L16_1
.L16_1:
	li s1, 7
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
.L16_0:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L16_2
	j .L16_3
.L16_2:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, __sys_close
	mv s2, a0
	sw s2, -24(s0)
	li s1, 0
	lw s2, -12(s0)
	sw s1, 0(s2)
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
.L16_3:
	la s1, fs_mounts
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, backend_for
	mv s1, a0
	sw s1, -16(s0)
	lw s1, -16(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, fs_mounts
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, -12(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -12(s0)
	lw s5, 0(s4)
	li s4, 1
	xor s6, s5, s4
	snez s6, s6
	mv a0, s3
	mv a1, s2
	mv a2, s6
	mv t0, s1
	jalr ra, t0, 0
	mv s4, a0
	sw s4, -20(s0)
	li s1, 0
	lw s2, -12(s0)
	sw s1, 0(s2)
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
	.size fs_close, .Lfunc_end16-fs_close

	.text
	.align 2
	.globl fs_adopt_pipe
	.type fs_adopt_pipe, @function
fs_adopt_pipe:
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
	li s1, 4
	li s2, 1
	neg s3, s2
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, fd_alloc
	mv s4, a0
	mv a0, s4
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
	.size fs_adopt_pipe, .Lfunc_end17-fs_adopt_pipe

	.text
	.align 2
	.globl fs_fd_backing
	.type fs_fd_backing, @function
fs_fd_backing:
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
	jal ra, fd_get
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L18_0
	j .L18_1
.L18_1:
	li s1, 7
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
.L18_0:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_2
	j .L18_3
.L18_2:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
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
.L18_3:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_4
	j .L18_5
.L18_4:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L18_6
	j .L18_5
.L18_6:
	la s1, fs_mounts
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	sw s3, -16(s0)
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_7
	j .L18_8
.L18_8:
	lw s1, -16(s0)
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_7
	j .L18_9
.L18_7:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
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
.L18_9:
.L18_5:
	li s1, 4
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
.Lfunc_end18:
	.size fs_fd_backing, .Lfunc_end18-fs_fd_backing

	.text
	.align 2
	.globl fs_exists
	.type fs_exists, @function
fs_exists:
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
	addi s2, s0, -12
	addi s3, s0, -16
	addi s4, s0, -20
	addi s5, s0, -24
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L19_0
	j .L19_1
.L19_0:
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
.L19_1:
	lw s1, -16(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	mv a0, s5
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
	.size fs_exists, .Lfunc_end19-fs_exists

	.text
	.align 2
	.globl fs_size
	.type fs_size, @function
fs_size:
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
	addi s2, s0, -12
	addi s3, s0, -16
	addi s4, s0, -20
	addi s5, s0, -24
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L20_0
	j .L20_1
.L20_0:
	lw s1, -28(s0)
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
	lw s1, -16(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s10, a0
	mv s11, a1
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
	.size fs_size, .Lfunc_end20-fs_size

	.text
	.align 2
	.globl fs_isdir
	.type fs_isdir, @function
fs_isdir:
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
	addi s2, s0, -12
	addi s3, s0, -16
	addi s4, s0, -20
	addi s5, s0, -24
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L21_0
	j .L21_1
.L21_0:
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
.L21_1:
	lw s1, -16(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	mv a0, s5
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
	.size fs_isdir, .Lfunc_end21-fs_isdir

	.text
	.align 2
	.globl fs_stat
	.type fs_stat, @function
fs_stat:
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
	lw s1, -4(s0)
	addi s2, s0, -12
	addi s3, s0, -16
	addi s4, s0, -20
	addi s5, s0, -24
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L22_0
	j .L22_1
.L22_0:
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
.L22_1:
	lw s1, -16(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	lw s5, -8(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	mv a0, s6
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
.Lfunc_end22:
	.size fs_stat, .Lfunc_end22-fs_stat

	.text
	.align 2
	.globl fs_fstat
	.type fs_fstat, @function
fs_fstat:
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
	jal ra, fd_get
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L23_0
	j .L23_1
.L23_1:
	li s1, 7
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
.L23_0:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L23_2
	j .L23_3
.L23_2:
	lw s1, -8(s0)
	li s2, 0
	li s3, 32
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li s1, 8192
	li s2, 438
	or s3, s1, s2
	lw s1, -8(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
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
.L23_3:
	la s1, fs_mounts
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, backend_for
	mv s1, a0
	sw s1, -16(s0)
	lw s1, -16(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, fs_mounts
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, -12(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -12(s0)
	lw s5, 0(s4)
	li s4, 1
	xor s6, s5, s4
	snez s6, s6
	lw s4, -8(s0)
	mv a0, s3
	mv a1, s2
	mv a2, s6
	mv a3, s4
	mv t0, s1
	jalr ra, t0, 0
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
	.size fs_fstat, .Lfunc_end23-fs_fstat

	.text
	.align 2
	.globl fs_unlink
	.type fs_unlink, @function
fs_unlink:
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
	addi s2, s0, -12
	addi s3, s0, -16
	addi s4, s0, -20
	addi s5, s0, -24
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L24_0
	j .L24_1
.L24_0:
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
.L24_1:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 256
	and s3, s1, s2
	bnez s3, .L24_2
	j .L24_3
.L24_2:
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
.L24_3:
	lw s1, -16(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	mv a0, s5
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
.Lfunc_end24:
	.size fs_unlink, .Lfunc_end24-fs_unlink

	.text
	.align 2
	.globl fs_mkdir
	.type fs_mkdir, @function
fs_mkdir:
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
	addi s2, s0, -12
	addi s3, s0, -16
	addi s4, s0, -20
	addi s5, s0, -24
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L25_0
	j .L25_1
.L25_0:
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
.L25_1:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 256
	and s3, s1, s2
	bnez s3, .L25_2
	j .L25_3
.L25_2:
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
.L25_3:
	lw s1, -16(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	mv a0, s5
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
.Lfunc_end25:
	.size fs_mkdir, .Lfunc_end25-fs_mkdir

	.text
	.align 2
	.globl fs_rmdir
	.type fs_rmdir, @function
fs_rmdir:
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
	addi s2, s0, -12
	addi s3, s0, -16
	addi s4, s0, -20
	addi s5, s0, -24
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L26_0
	j .L26_1
.L26_0:
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
.L26_1:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 256
	and s3, s1, s2
	bnez s3, .L26_2
	j .L26_3
.L26_2:
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
.L26_3:
	lw s1, -16(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	mv a0, s5
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
.Lfunc_end26:
	.size fs_rmdir, .Lfunc_end26-fs_rmdir

	.text
	.align 2
	.globl fs_rename
	.type fs_rename, @function
fs_rename:
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
	lw s1, -4(s0)
	addi s2, s0, -12
	addi s3, s0, -20
	addi s4, s0, -28
	addi s5, s0, -36
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L27_0
	j .L27_1
.L27_0:
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
.L27_1:
	lw s1, -8(s0)
	addi s2, s0, -16
	addi s3, s0, -24
	addi s4, s0, -32
	addi s5, s0, -40
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -44(s0)
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
	lw s1, -12(s0)
	lw s2, -16(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L27_4
	j .L27_5
.L27_4:
	li s1, 17
	neg s2, s1
	mv a0, s2
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
.L27_5:
	lw s1, -28(s0)
	lw s2, -32(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L27_6
	j .L27_7
.L27_6:
	li s1, 4
	neg s2, s1
	mv a0, s2
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
.L27_7:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 256
	and s3, s1, s2
	bnez s3, .L27_8
	j .L27_9
.L27_8:
	li s1, 18
	neg s2, s1
	mv a0, s2
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
.L27_9:
	lw s1, -20(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -28(s0)
	lw s4, -36(s0)
	lw s5, -40(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	mv a0, s6
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
	.size fs_rename, .Lfunc_end27-fs_rename

	.text
	.align 2
	.globl fs_mount_set
	.type fs_mount_set, @function
fs_mount_set:
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
	slt s3, s1, s2
	bnez s3, .L28_0
	j .L28_1
.L28_1:
	lw s1, -4(s0)
	la s2, fs_mount_count
	lw s3, 0(s2)
	slt s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L28_0
	j .L28_2
.L28_2:
	la s1, fs_mounts
	lw s2, -4(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lh s1, 0(s3)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L28_0
	j .L28_3
.L28_0:
	li s1, 4
	neg s2, s1
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
.L28_3:
	lw s1, -4(s0)
	la s2, fs_cur_mount
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
.Lfunc_end28:
	.size fs_mount_set, .Lfunc_end28-fs_mount_set

	.text
	.align 2
	.globl fs_mount_current
	.type fs_mount_current, @function
fs_mount_current:
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
	la s1, fs_cur_mount
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
.Lfunc_end29:
	.size fs_mount_current, .Lfunc_end29-fs_mount_current

	.text
	.align 2
	.globl fs_mount_find
	.type fs_mount_find, @function
fs_mount_find:
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
	addi s1, s0, -16
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, pad_name
	mv s3, a0
	li s1, 0
	sw s1, -20(s0)
.L30_0:
	lw s1, -20(s0)
	la s2, fs_mount_count
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L30_1
	j .L30_2
.L30_1:
	la s1, fs_mounts
	lw s2, -20(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lh s1, 0(s3)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L30_3
	j .L30_4
.L30_3:
	la s1, fs_mounts
	lw s2, -20(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	addi s1, s0, -16
	li s3, 8
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L30_5
	j .L30_4
.L30_5:
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
.L30_4:
.L30_6:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L30_0
.L30_2:
	addi s1, s0, -16
	mv a0, s1
	jal ra, is_root_alias
	mv s2, a0
	bnez s2, .L30_7
	j .L30_8
.L30_7:
	jal ra, root_mount
	mv s1, a0
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
.L30_8:
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
.Lfunc_end30:
	.size fs_mount_find, .Lfunc_end30-fs_mount_find

	.text
	.align 2
	.type normalize_cwd, @function
normalize_cwd:
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
	lw s1, -8(s0)
	sw s1, -268(s0)
.L31_0:
	lw s1, -268(s0)
	lb s2, 0(s1)
	bnez s2, .L31_1
	j .L31_2
.L31_1:
	li s1, 0
	sw s1, -272(s0)
.L31_3:
	lw s1, -268(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L31_4
	j .L31_5
.L31_4:
	addi s1, s0, -268
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -268(s0)
	j .L31_3
.L31_5:
.L31_6:
	lw s1, -268(s0)
	lb s2, 0(s1)
	bnez s2, .L31_7
	j .L31_8
.L31_7:
	lw s1, -268(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L31_9
	j .L31_8
.L31_9:
	lw s1, -272(s0)
	li s2, 256
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L31_10
	j .L31_8
.L31_10:
	addi s1, s0, -268
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -268(s0)
	lb s1, 0(s2)
	addi s2, s0, -264
	addi s3, s0, -272
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -272(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L31_6
.L31_8:
	li s1, 0
	addi s2, s0, -264
	lw s3, -272(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -272(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_11
	j .L31_12
.L31_12:
	addi s1, s0, -264
	la s2, __str_2
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L31_11
	j .L31_13
.L31_11:
	j .L31_0
.L31_13:
	addi s1, s0, -264
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L31_14
	j .L31_15
.L31_14:
	lw s1, -4(s0)
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, fs_strrchr
	mv s3, a0
	sw s3, -276(s0)
	lw s1, -276(s0)
	bnez s1, .L31_16
	j .L31_17
.L31_16:
	li s1, 0
	lw s2, -276(s0)
	sb s1, 0(s2)
	j .L31_18
.L31_17:
	li s1, 0
	lw s2, -4(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
.L31_18:
	j .L31_0
.L31_15:
	lw s1, -4(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L31_19
	j .L31_20
.L31_19:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -280(s0)
	lw s1, -280(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -272(s0)
	add s2, s3, s1
	li s1, 256
	sltu s3, s2, s1
	bnez s3, .L31_21
	j .L31_22
.L31_21:
	li s1, 47
	lw s2, -4(s0)
	lw s3, -280(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -280(s0)
	add s3, s1, s2
	li s1, 1
	add s2, s3, s1
	addi s1, s0, -264
	lw s3, -272(s0)
	li s4, 1
	add s5, s3, s4
	mv a0, s2
	mv a1, s1
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
.L31_22:
	j .L31_23
.L31_20:
	lw s1, -272(s0)
	li s2, 256
	slt s3, s1, s2
	bnez s3, .L31_24
	j .L31_25
.L31_24:
	lw s1, -4(s0)
	addi s2, s0, -264
	lw s3, -272(s0)
	li s4, 1
	add s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
.L31_25:
.L31_23:
	j .L31_0
.L31_2:
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
.Lfunc_end31:
	.size normalize_cwd, .Lfunc_end31-normalize_cwd

	.text
	.align 2
	.globl fs_chdir
	.type fs_chdir, @function
fs_chdir:
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
	lw s1, -4(s0)
	addi s2, s0, -12
	addi s3, s0, -16
	addi s4, s0, -20
	addi s5, s0, -28
	addi s6, s0, -36
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, resolve_op
	mv s7, a0
	sw s7, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L32_0
	j .L32_1
.L32_0:
	lw s1, -32(s0)
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
.L32_1:
	lw s1, -12(s0)
	la s2, fs_mounts
	sub s3, s1, s2
	li s1, 16
	div s2, s3, s1
	sw s2, -40(s0)
	lw s1, -16(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -20(s0)
	lw s4, -28(s0)
	li s5, 65536
	li s6, 0
	or s7, s5, s6
	li s5, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s7
	mv a4, s5
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	sw s6, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L32_2
	j .L32_3
.L32_2:
	lw s1, -24(s0)
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
.L32_3:
	lw s1, -36(s0)
	bnez s1, .L32_4
	j .L32_5
.L32_4:
	li s1, 0
	addi s2, s0, -304
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	j .L32_6
.L32_5:
	la s1, cwd_path
	lw s2, -40(s0)
	li s3, 256
	mul s4, s2, s3
	add s2, s1, s4
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	sw s1, -308(s0)
	addi s1, s0, -304
	la s2, cwd_path
	lw s3, -40(s0)
	li s4, 256
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, -308(s0)
	li s4, 1
	add s5, s2, s4
	mv a0, s1
	mv a1, s3
	mv a2, s5
	jal ra, memcpy
	mv s2, a0
.L32_6:
	addi s1, s0, -304
	lw s2, -28(s0)
	mv a0, s1
	mv a1, s2
	jal ra, normalize_cwd
	mv s3, a0
	lw s1, -12(s0)
	li s2, 10
	add s3, s1, s2
	lh s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L32_7
	j .L32_8
.L32_7:
	lw s1, -12(s0)
	li s2, 10
	add s3, s1, s2
	lh s1, 0(s3)
	mv a0, s1
	jal ra, fd_get
	mv s2, a0
	sw s2, -312(s0)
	lw s1, -312(s0)
	bnez s1, .L32_9
	j .L32_10
.L32_9:
	lw s1, -16(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -312(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	li s1, 0
	lw s2, -312(s0)
	sw s1, 0(s2)
.L32_10:
.L32_8:
	li s1, 2
	lw s2, -40(s0)
	lw s3, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fd_alloc
	mv s4, a0
	sw s4, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L32_11
	j .L32_12
.L32_11:
	lw s1, -16(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -24(s0)
	li s4, 1
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 10
	add s4, s1, s3
	sh s2, 0(s4)
	lw s1, -44(s0)
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
.L32_12:
	lw s1, -44(s0)
	li s2, 16
	sll s3, s1, s2
	li s1, 16
	sra s2, s3, s1
	lw s1, -12(s0)
	li s3, 10
	add s4, s1, s3
	sh s2, 0(s4)
	la s1, cwd_path
	lw s2, -40(s0)
	li s3, 256
	mul s4, s2, s3
	add s2, s1, s4
	addi s1, s0, -304
	addi s3, s0, -304
	mv a0, s3
	jal ra, strlen
	mv s4, a0
	li s3, 1
	add s5, s4, s3
	mv a0, s2
	mv a1, s1
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
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
.Lfunc_end32:
	.size fs_chdir, .Lfunc_end32-fs_chdir

	.text
	.align 2
	.globl fs_getcwd
	.type fs_getcwd, @function
fs_getcwd:
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
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L33_0
	j .L33_1
.L33_1:
	lw s1, -4(s0)
	la s2, fs_mount_count
	lw s3, 0(s2)
	slt s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L33_0
	j .L33_2
.L33_2:
	la s1, fs_mounts
	lw s2, -4(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lh s1, 0(s3)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L33_0
	j .L33_3
.L33_0:
	li s1, 4
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
.L33_3:
	la s1, cwd_path
	lw s2, -4(s0)
	li s3, 256
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -20(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 2
	add s3, s1, s2
	lw s1, -12(s0)
	slt s2, s1, s3
	bnez s2, .L33_4
	j .L33_5
.L33_4:
	li s1, 2
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
.L33_5:
	li s1, 47
	lw s2, -8(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -20(s0)
	lw s2, -24(s0)
	li s4, 1
	add s5, s2, s4
	mv a0, s3
	mv a1, s1
	mv a2, s5
	jal ra, memcpy
	mv s2, a0
	lw s1, -24(s0)
	li s2, 1
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
.Lfunc_end33:
	.size fs_getcwd, .Lfunc_end33-fs_getcwd

	.text
	.align 2
	.globl fs_init
	.type fs_init, @function
fs_init:
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
	la s1, fs_init.started.0
	lw s2, 0(s1)
	bnez s2, .L34_0
	j .L34_1
.L34_0:
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
.L34_1:
	li s1, 1
	la s2, fs_init.started.0
	sw s1, 0(s2)
	li s1, 0
	sw s1, -4(s0)
.L34_2:
	lw s1, -4(s0)
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L34_3
	j .L34_4
.L34_3:
	li s1, 4
	la s2, fd_tab
	lw s3, -4(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1
	neg s2, s1
	la s1, fd_tab
	lw s3, -4(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	sw s2, 0(s4)
	lw s1, -4(s0)
	la s2, fd_tab
	lw s3, -4(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	la s2, fd_tab
	lw s3, -4(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 16
	add s4, s3, s2
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L34_5:
	addi s1, s0, -4
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -4(s0)
	j .L34_2
.L34_4:
	li s1, 0
	sw s1, -8(s0)
.L34_6:
	lw s1, -8(s0)
	la s2, fs_inherit_n
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L34_7
	j .L34_8
.L34_7:
	lw s1, -8(s0)
	li s2, 64
	slt s3, s1, s2
	bnez s3, .L34_9
	j .L34_8
.L34_9:
	la s1, fs_inherit_fds
	lw s2, -8(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L34_10
	j .L34_11
.L34_11:
	lw s1, -12(s0)
	li s2, 64
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L34_10
	j .L34_12
.L34_10:
	j .L34_13
.L34_12:
	li s1, 4
	la s2, fd_tab
	lw s3, -12(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1
	neg s2, s1
	la s1, fd_tab
	lw s3, -12(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	sw s2, 0(s4)
	la s1, fs_inherit_fds
	lw s2, -8(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	la s2, fd_tab
	lw s3, -12(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	la s2, fd_tab
	lw s3, -12(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 16
	add s4, s3, s2
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L34_13:
	addi s1, s0, -8
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -8(s0)
	j .L34_6
.L34_8:
	la s1, fs_mount_count
	lw s2, 0(s1)
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L34_14
	j .L34_15
.L34_14:
	la s1, fs_mount_count
	lw s2, 0(s1)
	sw s2, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L34_16:
	lw s1, -20(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L34_17
	j .L34_18
.L34_17:
	la s1, fs_mounts
	lw s2, -20(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	sw s3, -32(s0)
	lw s1, -32(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_19
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_20
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_21
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_22
	j .L34_23
.L34_19:
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lh s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L34_24
	j .L34_25
.L34_24:
	j .L34_26
.L34_25:
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lh s1, 0(s3)
	sw s1, -36(s0)
	j .L34_27
.L34_20:
	li s1, 100
	sw s1, -36(s0)
	j .L34_27
.L34_21:
	lw s1, -20(s0)
	la s2, fs_mount_aux
	lw s3, -20(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	la s3, fs_mount_aux
	lw s4, -20(s0)
	li s5, 8
	mul s6, s4, s5
	add s4, s3, s6
	li s3, 4
	add s5, s4, s3
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, romfs_adopt
	mv s4, a0
	sw s4, -36(s0)
	j .L34_27
.L34_22:
	la s1, fs_mount_aux
	lw s2, -20(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -48
	mv a0, s1
	mv a1, s2
	jal ra, p9_guest_transport
	mv s3, a0
	lw s1, -20(s0)
	addi s2, s0, -48
	mv a0, s1
	mv a1, s2
	jal ra, ninefs_adopt
	mv s3, a0
	sw s3, -36(s0)
	j .L34_27
.L34_23:
	j .L34_26
.L34_27:
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L34_28
	j .L34_29
.L34_28:
	j .L34_26
.L34_29:
	li s1, 3
	lw s2, -20(s0)
	lw s3, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fd_alloc
	mv s4, a0
	sw s4, -40(s0)
	lw s1, -40(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L34_30
	j .L34_31
.L34_30:
	j .L34_18
.L34_31:
	lw s1, -40(s0)
	li s2, 16
	sll s3, s1, s2
	li s1, 16
	sra s2, s3, s1
	lw s1, -28(s0)
	li s3, 8
	add s4, s1, s3
	sh s2, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -28(s0)
	li s3, 10
	add s4, s1, s3
	sh s2, 0(s4)
	li s1, 0
	la s2, cwd_path
	lw s3, -20(s0)
	li s4, 256
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 0
	add s4, s3, s2
	sb s1, 0(s4)
.L34_26:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L34_16
.L34_18:
	la s1, __str_4
	mv a0, s1
	jal ra, fs_mount_find
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L34_32
	j .L34_33
.L34_32:
	la s1, __str_5
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, ramfs_mount
	mv s3, a0
	sw s3, -24(s0)
	la s1, __str_6
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, ambient_mount
	mv s3, a0
	sw s3, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L34_34
	j .L34_35
.L34_34:
	lw s1, -52(s0)
	sw s1, -24(s0)
.L34_35:
.L34_33:
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L34_36
	j .L34_37
.L34_36:
	lw s1, -24(s0)
	la s2, fs_cur_mount
	sw s1, 0(s2)
.L34_37:
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
.L34_15:
	la s1, __str_7
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, ramfs_mount
	mv s3, a0
	li s1, 0
	la s2, fs_cur_mount
	sw s1, 0(s2)
	la s1, __str_8
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, ambient_mount
	mv s3, a0
	sw s3, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L34_38
	j .L34_39
.L34_38:
	lw s1, -56(s0)
	la s2, fs_cur_mount
	sw s1, 0(s2)
.L34_39:
	li s1, 0
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
.Lfunc_end34:
	.size fs_init, .Lfunc_end34-fs_init

	.data
	.align 2
__str_8:
	.ascii "host\000"
	.align 2
__str_7:
	.ascii "scratch\000"
	.align 2
__str_6:
	.ascii "host\000"
	.align 2
__str_5:
	.ascii "scratch\000"
	.align 2
__str_4:
	.ascii "scratch\000"
	.align 2
__str_3:
	.ascii "..\000"
	.align 2
__str_2:
	.ascii ".\000"
	.align 2
__str_1:
	.ascii "\000"
	.align 2
__str_0:
	.ascii "ROOT\000"
	.align 2
	.globl fs_inherit_n
fs_inherit_n:
	.word 0
	.align 2
	.globl fs_cur_mount
fs_cur_mount:
	.word 0
	.align 2
	.globl fs_mount_count
fs_mount_count:
	.word 0

	.bss
	.align 2
fs_init.started.0:
	.space 4
	.align 2
	.globl cwd_path
cwd_path:
	.space 64
	.align 2
	.globl fs_inherit_fds
fs_inherit_fds:
	.space 512
	.align 3
	.globl fd_tab
fd_tab:
	.space 1536
	.align 2
	.globl fs_mount_aux
fs_mount_aux:
	.space 128
	.align 2
	.globl fs_mounts
fs_mounts:
	.space 256
