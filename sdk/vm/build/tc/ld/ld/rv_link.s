# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type rd32, @function
rd32:
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
	.size rd32, .Lfunc_end1-rd32

	.text
	.align 2
	.type wr32, @function
wr32:
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
	li s2, 255
	and s3, s1, s2
	lw s1, -4(s0)
	li s2, 0
	add s4, s1, s2
	sb s3, 0(s4)
	lw s1, -8(s0)
	li s2, 8
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 1
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 16
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 2
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 24
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 3
	add s4, s1, s3
	sb s2, 0(s4)
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
	.size wr32, .Lfunc_end2-wr32

	.text
	.align 2
	.type patch_hi20, @function
patch_hi20:
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
	jal ra, rd32
	mv s2, a0
	li s1, 4095
	and s3, s2, s1
	sw s3, -12(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s3, 1048575
	and s4, s1, s3
	li s1, 12
	sll s3, s4, s1
	or s1, s2, s3
	sw s1, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wr32
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
.Lfunc_end3:
	.size patch_hi20, .Lfunc_end3-patch_hi20

	.text
	.align 2
	.type patch_lo12_i, @function
patch_lo12_i:
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
	jal ra, rd32
	mv s2, a0
	li s1, 1048575
	and s3, s2, s1
	sw s3, -12(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s3, 4095
	and s4, s1, s3
	li s1, 20
	sll s3, s4, s1
	or s1, s2, s3
	sw s1, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wr32
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
.Lfunc_end4:
	.size patch_lo12_i, .Lfunc_end4-patch_lo12_i

	.text
	.align 2
	.type patch_lo12_s, @function
patch_lo12_s:
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
	jal ra, rd32
	mv s2, a0
	li s1, 33550463
	and s3, s2, s1
	sw s3, -12(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s3, 31
	and s4, s1, s3
	li s1, 7
	sll s3, s4, s1
	or s1, s2, s3
	sw s1, -12(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s3, 5
	srl s4, s1, s3
	li s1, 127
	and s3, s4, s1
	li s1, 25
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wr32
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
.Lfunc_end5:
	.size patch_lo12_s, .Lfunc_end5-patch_lo12_s

	.text
	.align 2
	.type patch_branch, @function
patch_branch:
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
	sw s1, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rd32
	mv s2, a0
	li s1, 33550463
	and s3, s2, s1
	sw s3, -16(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 11
	srl s4, s1, s3
	li s1, 1
	and s3, s4, s1
	li s1, 7
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -16(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 1
	srl s4, s1, s3
	li s1, 15
	and s3, s4, s1
	li s1, 8
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -16(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 5
	srl s4, s1, s3
	li s1, 63
	and s3, s4, s1
	li s1, 25
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -16(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 12
	srl s4, s1, s3
	li s1, 1
	and s3, s4, s1
	li s1, 31
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -16(s0)
	lw s1, -4(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wr32
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
.Lfunc_end6:
	.size patch_branch, .Lfunc_end6-patch_branch

	.text
	.align 2
	.type patch_jal, @function
patch_jal:
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
	sw s1, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rd32
	mv s2, a0
	li s1, 4095
	and s3, s2, s1
	sw s3, -16(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 12
	srl s4, s1, s3
	li s1, 255
	and s3, s4, s1
	li s1, 12
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -16(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 11
	srl s4, s1, s3
	li s1, 1
	and s3, s4, s1
	li s1, 20
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -16(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 1
	srl s4, s1, s3
	li s1, 1023
	and s3, s4, s1
	li s1, 21
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -16(s0)
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 20
	srl s4, s1, s3
	li s1, 1
	and s3, s4, s1
	li s1, 31
	sll s4, s3, s1
	or s1, s2, s4
	sw s1, -16(s0)
	lw s1, -4(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wr32
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
.Lfunc_end7:
	.size patch_jal, .Lfunc_end7-patch_jal

	.text
	.align 2
	.type hi_lo, @function
hi_lo:
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
	li s2, 2048
	add s3, s1, s2
	li s1, 12
	srl s2, s3, s1
	lw s1, -8(s0)
	sw s2, 0(s1)
	lw s1, -4(s0)
	li s2, 4095
	and s3, s1, s2
	lw s1, -12(s0)
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
.Lfunc_end8:
	.size hi_lo, .Lfunc_end8-hi_lo

	.text
	.align 2
	.type got_lookup, @function
got_lookup:
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
.L9_0:
	lw s1, -12(s0)
	la s2, g_ngot
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L9_1
	j .L9_2
.L9_1:
	la s1, g_got
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 8
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L9_3
	j .L9_4
.L9_3:
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
.L9_4:
.L9_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L9_0
.L9_2:
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
.Lfunc_end9:
	.size got_lookup, .Lfunc_end9-got_lookup

	.text
	.align 2
	.type got_prescan, @function
got_prescan:
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
	li s1, 0
	la s2, g_got
	sw s1, 0(s2)
	li s1, 0
	la s2, g_ngot
	sw s1, 0(s2)
	li s1, 0
	sw s1, -12(s0)
.L10_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L10_1
	j .L10_2
.L10_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L10_3:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L10_4
	j .L10_5
.L10_4:
	lw s1, -16(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 20
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L10_6
	j .L10_7
.L10_6:
	j .L10_8
.L10_7:
	lw s1, -16(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -28(s0)
	lw s1, -28(s0)
	mv a0, s1
	jal ra, got_lookup
	mv s2, a0
	li s1, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L10_9
	j .L10_10
.L10_9:
	j .L10_8
.L10_10:
	la s1, g_got
	lw s2, 0(s1)
	la s1, g_ngot
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	li s1, 8
	mul s3, s4, s1
	mv a0, s2
	mv a1, s3
	jal ra, realloc
	mv s1, a0
	la s2, g_got
	sw s1, 0(s2)
	la s1, g_got
	lw s2, 0(s1)
	bnez s2, .L10_11
	j .L10_12
.L10_12:
	la s1, __str_0
	mv a0, s1
	jal ra, die
	mv s2, a0
.L10_11:
	lw s1, -28(s0)
	la s2, g_got
	lw s3, 0(s2)
	la s2, g_ngot
	lw s4, 0(s2)
	li s2, 8
	mul s5, s4, s2
	add s2, s3, s5
	sw s1, 0(s2)
	li s1, 0
	la s2, g_got
	lw s3, 0(s2)
	la s2, g_ngot
	lw s4, 0(s2)
	li s2, 8
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, g_ngot
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L10_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L10_3
.L10_5:
.L10_13:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L10_0
.L10_2:
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
.Lfunc_end10:
	.size got_prescan, .Lfunc_end10-got_prescan

	.text
	.align 2
	.type got_inject, @function
got_inject:
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
	la s1, g_ngot
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_1
.L11_0:
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
	la s1, g_ngot
	lw s2, 0(s1)
	li s1, 4
	mul s3, s2, s1
	sw s3, -12(s0)
	lw s1, -4(s0)
	li s2, 6204
	add s3, s1, s2
	li s1, 32
	mv a0, s3
	mv a1, s1
	jal ra, arena_zalloc
	mv s2, a0
	sw s2, -16(s0)
	la s1, __str_1
	lw s2, -16(s0)
	sw s1, 0(s2)
	li s1, 1
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 2
	li s2, 1
	or s3, s1, s2
	lw s1, -16(s0)
	li s2, 8
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 6204
	add s3, s1, s2
	lw s1, -12(s0)
	mv a0, s3
	mv a1, s1
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -16(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 4
	lw s2, -16(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, ld_add_object
	mv s2, a0
	sw s2, -20(s0)
	la s1, __str_2
	lw s2, -20(s0)
	sw s1, 0(s2)
	lw s1, -16(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -20(s0)
	li s3, 16
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
.Lfunc_end11:
	.size got_inject, .Lfunc_end11-got_inject

	.text
	.align 2
	.type got_fill, @function
got_fill:
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
	la s1, g_ngot
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_0
	j .L12_1
.L12_0:
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
.L12_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 1
	sub s4, s1, s3
	li s1, 44
	mul s3, s4, s1
	add s1, s2, s3
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -16(s0)
	lw s1, -4(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ld_find_output_sec
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L12_2
	j .L12_3
.L12_3:
	la s1, __str_3
	mv a0, s1
	jal ra, die
	mv s2, a0
.L12_2:
	li s1, 0
	sw s1, -24(s0)
.L12_4:
	lw s1, -24(s0)
	la s2, g_ngot
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L12_5
	j .L12_6
.L12_5:
	li s1, 0
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
.L12_7:
	lw s1, -36(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_8
	j .L12_9
.L12_8:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -36(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L12_10
	j .L12_11
.L12_10:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -36(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, g_got
	lw s3, 0(s2)
	lw s2, -24(s0)
	li s4, 8
	mul s5, s2, s4
	add s2, s3, s5
	lw s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, strcmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_12
	j .L12_11
.L12_12:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -36(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	j .L12_9
.L12_11:
.L12_13:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L12_7
.L12_9:
	lw s1, -32(s0)
	bnez s1, .L12_14
	j .L12_15
.L12_15:
	la s1, __str_4
	la s2, g_got
	lw s3, 0(s2)
	lw s2, -24(s0)
	li s4, 8
	mul s5, s2, s4
	add s2, s3, s5
	lw s3, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L12_14:
	lw s1, -16(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	la s1, g_got
	lw s3, 0(s1)
	lw s1, -24(s0)
	li s4, 8
	mul s5, s1, s4
	add s1, s3, s5
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -16(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	sub s3, s1, s2
	lw s1, -24(s0)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -40(s0)
	lw s1, -20(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -40(s0)
	add s3, s1, s2
	lw s1, -28(s0)
	mv a0, s3
	mv a1, s1
	jal ra, wr32
	mv s2, a0
.L12_16:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L12_4
.L12_6:
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
.Lfunc_end12:
	.size got_fill, .Lfunc_end12-got_fill

	.text
	.align 2
	.type pcrel_hi_value, @function
pcrel_hi_value:
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
	li s1, 0
	sw s1, -20(s0)
.L13_0:
	lw s1, -20(s0)
	lw s2, -8(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L13_1
	j .L13_2
.L13_1:
	lw s1, -8(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 23
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_3
	j .L13_4
.L13_3:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 18
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_5
	j .L13_4
.L13_5:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 19
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_6
	j .L13_4
.L13_6:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 20
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_7
	j .L13_4
.L13_7:
	j .L13_8
.L13_4:
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_9
	j .L13_10
.L13_10:
	j .L13_8
.L13_9:
	lw s1, -28(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	lw s3, 0(s2)
	add s2, s1, s3
	sw s2, -32(s0)
	lw s1, -32(s0)
	lw s2, -12(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L13_11
	j .L13_12
.L13_11:
	j .L13_8
.L13_12:
	lw s1, -8(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -36(s0)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -36(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -40(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 20
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_13
	j .L13_14
.L13_13:
	lw s1, -40(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, got_lookup
	mv s1, a0
	sw s1, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L13_15
	j .L13_16
.L13_15:
	la s1, __str_5
	lw s2, -8(s0)
	lw s3, 0(s2)
	lw s2, -40(s0)
	lw s4, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L13_16:
	la s1, g_got
	lw s2, 0(s1)
	lw s1, -44(s0)
	li s3, 8
	mul s4, s1, s3
	add s1, s2, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -32(s0)
	sub s3, s1, s2
	lw s1, -16(s0)
	sw s3, 0(s1)
	j .L13_17
.L13_14:
	lw s1, -40(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	lw s10, 0(s4)
	lw s11, 4(s4)
	mv s2, s10
	add s3, s1, s2
	lw s1, -32(s0)
	sub s2, s3, s1
	lw s1, -16(s0)
	sw s2, 0(s1)
.L13_17:
	li s1, 1
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
.L13_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L13_0
.L13_2:
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
.Lfunc_end13:
	.size pcrel_hi_value, .Lfunc_end13-pcrel_hi_value

	.text
	.align 2
	.globl rv_ld_link
	.type rv_ld_link, @function
rv_ld_link:
	addi sp, sp, -192
	sw ra, 188(sp)
	sw s0, 184(sp)
	addi s0, sp, 184
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
	jal ra, got_prescan
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, got_inject
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, ld_layout
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, got_fill
	mv s2, a0
	li s1, 0
	sw s1, -12(s0)
.L14_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L14_1
	j .L14_2
.L14_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L14_3:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L14_4
	j .L14_5
.L14_4:
	lw s1, -16(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 51
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_6
	j .L14_7
.L14_7:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_6
	j .L14_8
.L14_6:
	j .L14_9
.L14_8:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_10
	j .L14_11
.L14_11:
	j .L14_9
.L14_10:
	lw s1, -4(s0)
	lw s2, -28(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ld_find_output_sec
	mv s3, a0
	sw s3, -32(s0)
	lw s1, -32(s0)
	bnez s1, .L14_12
	j .L14_13
.L14_13:
	j .L14_9
.L14_12:
	lw s1, -16(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -36(s0)
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L14_14
	j .L14_15
.L14_14:
	la s1, __str_6
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -24(s0)
	li s4, 4
	add s5, s2, s4
	lw s2, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s2, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L14_15:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -36(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -40(s0)
	lw s1, -40(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_16
	j .L14_17
.L14_17:
	lw s1, -40(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_16
	j .L14_18
.L14_18:
	la s1, __str_7
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -40(s0)
	lw s4, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L14_16:
	lw s1, -28(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -32(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	sub s3, s1, s2
	lw s1, -24(s0)
	lw s2, 0(s1)
	add s1, s3, s2
	sw s1, -44(s0)
	lw s1, -32(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	add s3, s1, s2
	sw s3, -48(s0)
	lw s1, -40(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	lw s1, -24(s0)
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	sw s10, -56(s0)
	lw s1, -28(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	lw s3, 0(s2)
	add s2, s1, s3
	sw s2, -60(s0)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_19
	li s2, 57
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_20
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_21
	li s2, 39
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_22
	li s2, 16
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_23
	li s2, 17
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_24
	li s2, 26
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_25
	li s2, 27
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_26
	li s2, 28
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_27
	li s2, 23
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_28
	li s2, 20
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_29
	li s2, 24
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_30
	li s2, 25
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_31
	li s2, 18
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_32
	li s2, 19
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_33
	j .L14_34
.L14_19:
	lw s1, -48(s0)
	lw s2, -52(s0)
	lw s3, -56(s0)
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, wr32
	mv s2, a0
	j .L14_35
.L14_20:
	lw s1, -48(s0)
	lw s2, -52(s0)
	lw s3, -56(s0)
	add s4, s2, s3
	lw s2, -60(s0)
	sub s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, wr32
	mv s2, a0
	j .L14_35
.L14_21:
	lw s1, -48(s0)
	lw s2, -48(s0)
	mv a0, s2
	jal ra, rd32
	mv s3, a0
	lw s2, -52(s0)
	add s4, s3, s2
	lw s2, -56(s0)
	add s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, wr32
	mv s2, a0
	j .L14_35
.L14_22:
	lw s1, -48(s0)
	lw s2, -48(s0)
	mv a0, s2
	jal ra, rd32
	mv s3, a0
	lw s2, -52(s0)
	lw s4, -56(s0)
	add s5, s2, s4
	sub s2, s3, s5
	mv a0, s1
	mv a1, s2
	jal ra, wr32
	mv s3, a0
	j .L14_35
.L14_23:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	lw s1, -60(s0)
	sub s2, s3, s1
	sw s2, -72(s0)
	lw s1, -72(s0)
	li s2, 4096
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L14_36
	j .L14_37
.L14_37:
	lw s1, -72(s0)
	li s2, 4095
	slt s3, s2, s1
	bnez s3, .L14_36
	j .L14_38
.L14_36:
	la s1, __str_8
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -40(s0)
	lw s4, 0(s2)
	lw s2, -72(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s2, 8(sp)
	jal ra, die
	mv s5, a0
	addi sp, sp, 16
.L14_38:
	lw s1, -48(s0)
	lw s2, -72(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_branch
	mv s3, a0
	j .L14_35
.L14_24:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	lw s1, -60(s0)
	sub s2, s3, s1
	sw s2, -76(s0)
	lw s1, -76(s0)
	li s2, 1048576
	neg s3, s2
	slt s2, s1, s3
	bnez s2, .L14_39
	j .L14_40
.L14_40:
	lw s1, -76(s0)
	li s2, 1048575
	slt s3, s2, s1
	bnez s3, .L14_39
	j .L14_41
.L14_39:
	la s1, __str_9
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -40(s0)
	lw s4, 0(s2)
	lw s2, -76(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	sw s2, 8(sp)
	jal ra, die
	mv s5, a0
	addi sp, sp, 16
.L14_41:
	lw s1, -48(s0)
	lw s2, -76(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_jal
	mv s3, a0
	j .L14_35
.L14_25:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	addi s1, s0, -64
	addi s2, s0, -68
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, hi_lo
	mv s4, a0
	lw s1, -48(s0)
	lw s2, -64(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_hi20
	mv s3, a0
	j .L14_35
.L14_26:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	addi s1, s0, -64
	addi s2, s0, -68
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, hi_lo
	mv s4, a0
	lw s1, -48(s0)
	lw s2, -68(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_lo12_i
	mv s3, a0
	j .L14_35
.L14_27:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	addi s1, s0, -64
	addi s2, s0, -68
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, hi_lo
	mv s4, a0
	lw s1, -48(s0)
	lw s2, -68(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_lo12_s
	mv s3, a0
	j .L14_35
.L14_28:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	lw s1, -60(s0)
	sub s2, s3, s1
	addi s1, s0, -64
	addi s3, s0, -68
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, hi_lo
	mv s4, a0
	lw s1, -48(s0)
	lw s2, -64(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_hi20
	mv s3, a0
	j .L14_35
.L14_29:
	lw s1, -40(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, got_lookup
	mv s1, a0
	sw s1, -80(s0)
	lw s1, -80(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L14_42
	j .L14_43
.L14_42:
	la s1, __str_10
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -40(s0)
	lw s4, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s4, 4(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L14_43:
	la s1, g_got
	lw s2, 0(s1)
	lw s1, -80(s0)
	li s3, 8
	mul s4, s1, s3
	add s1, s2, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -60(s0)
	sub s3, s1, s2
	addi s1, s0, -64
	addi s2, s0, -68
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, hi_lo
	mv s4, a0
	lw s1, -48(s0)
	lw s2, -64(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_hi20
	mv s3, a0
	j .L14_35
.L14_30:
.L14_31:
	lw s1, -4(s0)
	lw s2, -16(s0)
	lw s3, -52(s0)
	lw s4, -56(s0)
	add s5, s3, s4
	addi s3, s0, -84
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	jal ra, pcrel_hi_value
	mv s4, a0
	bnez s4, .L14_44
	j .L14_45
.L14_45:
	la s1, __str_11
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -52(s0)
	lw s4, -56(s0)
	add s5, s2, s4
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s5, 4(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L14_44:
	lw s1, -84(s0)
	addi s2, s0, -64
	addi s3, s0, -68
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, hi_lo
	mv s4, a0
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_46
	j .L14_47
.L14_46:
	lw s1, -48(s0)
	lw s2, -68(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_lo12_i
	mv s3, a0
	j .L14_48
.L14_47:
	lw s1, -48(s0)
	lw s2, -68(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_lo12_s
	mv s3, a0
.L14_48:
	j .L14_35
.L14_32:
.L14_33:
	lw s1, -52(s0)
	lw s2, -56(s0)
	add s3, s1, s2
	lw s1, -60(s0)
	sub s2, s3, s1
	sw s2, -88(s0)
	lw s1, -88(s0)
	addi s2, s0, -64
	addi s3, s0, -68
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, hi_lo
	mv s4, a0
	lw s1, -48(s0)
	lw s2, -64(s0)
	mv a0, s1
	mv a1, s2
	jal ra, patch_hi20
	mv s3, a0
	lw s1, -48(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, -68(s0)
	mv a0, s3
	mv a1, s1
	jal ra, patch_lo12_i
	mv s2, a0
	j .L14_35
.L14_34:
	la s1, __str_12
	lw s2, -16(s0)
	lw s3, 0(s2)
	lw s2, -24(s0)
	li s4, 16
	add s5, s2, s4
	lw s2, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s2, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L14_35:
.L14_9:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L14_3
.L14_5:
.L14_49:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L14_0
.L14_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, ld_build_debug
	mv s2, a0
	li s1, 0
	sw s1, -92(s0)
.L14_50:
	lw s1, -92(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L14_51
	j .L14_52
.L14_51:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -92(s0)
	li s3, 44
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -96(s0)
	li s1, 0
	sw s1, -100(s0)
.L14_53:
	lw s1, -100(s0)
	lw s2, -96(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L14_54
	j .L14_55
.L14_54:
	lw s1, -96(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -100(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -104(s0)
	lw s1, -96(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -104(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -108(s0)
	li s1, 0
	sw s1, -112(s0)
	lw s1, -104(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 51
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_56
	j .L14_57
.L14_57:
	lw s1, -104(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_56
	j .L14_58
.L14_56:
	j .L14_59
.L14_58:
	lw s1, -108(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_60
	j .L14_61
.L14_61:
	lw s1, -108(s0)
	lw s2, 0(s1)
	la s1, __str_13
	li s3, 7
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L14_60
	j .L14_62
.L14_60:
	j .L14_59
.L14_62:
	li s1, 0
	sw s1, -136(s0)
.L14_63:
	lw s1, -136(s0)
	lw s2, -4(s0)
	li s3, 6192
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L14_64
	j .L14_65
.L14_64:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -136(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	lw s1, -108(s0)
	lw s3, 0(s1)
	mv a0, s2
	mv a1, s3
	jal ra, strcmp
	mv s1, a0
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_66
	j .L14_67
.L14_66:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -136(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -112(s0)
	j .L14_65
.L14_67:
.L14_68:
	addi s1, s0, -136
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -136(s0)
	j .L14_63
.L14_65:
	lw s1, -112(s0)
	bnez s1, .L14_69
	j .L14_70
.L14_70:
	j .L14_59
.L14_69:
	lw s1, -96(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -104(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -132(s0)
	lw s1, -132(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L14_71
	j .L14_72
.L14_71:
	la s1, __str_14
	lw s2, -96(s0)
	lw s3, 0(s2)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	jal ra, die
	mv s2, a0
	addi sp, sp, 16
.L14_72:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -132(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -116(s0)
	lw s1, -116(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -124(s0)
	lw s1, -104(s0)
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	sw s10, -128(s0)
	lw s1, -112(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -108(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -104(s0)
	lw s2, 0(s1)
	add s1, s3, s2
	sw s1, -120(s0)
	lw s1, -104(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_73
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_74
	li s2, 39
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_75
	j .L14_76
.L14_73:
	lw s1, -120(s0)
	lw s2, -124(s0)
	lw s3, -128(s0)
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, wr32
	mv s2, a0
	j .L14_77
.L14_74:
	lw s1, -120(s0)
	lw s2, -120(s0)
	mv a0, s2
	jal ra, rd32
	mv s3, a0
	lw s2, -124(s0)
	add s4, s3, s2
	lw s2, -128(s0)
	add s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, wr32
	mv s2, a0
	j .L14_77
.L14_75:
	lw s1, -120(s0)
	lw s2, -120(s0)
	mv a0, s2
	jal ra, rd32
	mv s3, a0
	lw s2, -124(s0)
	lw s4, -128(s0)
	add s5, s2, s4
	sub s2, s3, s5
	mv a0, s1
	mv a1, s2
	jal ra, wr32
	mv s3, a0
	j .L14_77
.L14_76:
	la s1, __str_15
	lw s2, -96(s0)
	lw s3, 0(s2)
	lw s2, -104(s0)
	li s4, 16
	add s5, s2, s4
	lw s2, 0(s5)
	lw s4, -108(s0)
	lw s5, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s2, 4(sp)
	sw s5, 8(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L14_77:
.L14_59:
	addi s1, s0, -100
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -100(s0)
	j .L14_53
.L14_55:
.L14_78:
	addi s1, s0, -92
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -92(s0)
	j .L14_50
.L14_52:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, ld_check_undefined
	mv s2, a0
	la s1, g_got
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li s1, 0
	la s2, g_got
	sw s1, 0(s2)
	li s1, 0
	la s2, g_ngot
	sw s1, 0(s2)
	li s1, 0
	mv a0, s1
	lw s1, -180(s0)
	lw s2, -176(s0)
	lw s3, -172(s0)
	lw s4, -168(s0)
	lw s5, -164(s0)
	lw s6, -160(s0)
	lw s7, -156(s0)
	lw s8, -152(s0)
	lw s9, -148(s0)
	lw s10, -144(s0)
	lw s11, -140(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end14:
	.size rv_ld_link, .Lfunc_end14-rv_ld_link

	.text
	.align 2
	.globl rv_default_script
	.type rv_default_script, @function
rv_default_script:
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
	la s3, rv_default_script.default_script.0
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
.Lfunc_end15:
	.size rv_default_script, .Lfunc_end15-rv_default_script

	.data
	.align 2
__str_15:
	.ascii "%s: unsupported debug relocation type %d in %s\000"
	.align 2
__str_14:
	.ascii "%s: debug reloc references unmapped symbol\000"
	.align 2
__str_13:
	.ascii ".debug_\000"
	.align 2
__str_12:
	.ascii "%s: unsupported relocation type %d\000"
	.align 2
__str_11:
	.ascii "%s: PCREL_LO12 with no matching PCREL_HI20 at %08x\000"
	.align 2
__str_10:
	.ascii "%s: GOT_HI20 for '%s' with no GOT entry\000"
	.align 2
__str_9:
	.ascii "%s: R_RISCV_JAL out of range for '%s' (%d)\000"
	.align 2
__str_8:
	.ascii "%s: R_RISCV_BRANCH out of range for '%s' (%d)\000"
	.align 2
__str_7:
	.ascii "%s: undefined symbol '%s'\000"
	.align 2
__str_6:
	.ascii "%s: reloc references unmapped symbol %d\000"
	.align 2
__str_5:
	.ascii "%s: GOT_HI20 for '%s' with no GOT entry\000"
	.align 2
__str_4:
	.ascii "GOT symbol '%s' is undefined\000"
	.align 2
__str_3:
	.ascii "the .got section was not placed (the linker script needs a '.got : { *(.got) }' output section)\000"
	.align 2
__str_2:
	.ascii "<got>\000"
	.align 2
__str_1:
	.ascii ".got\000"
	.align 2
__str_0:
	.ascii "out of memory\000"

	.section .rodata
	.align 2
rv_default_script.default_script.0:
	.ascii "OUTPUT_FORMAT(\"elf32-littleriscv\")\nOUTPUT_ARCH(riscv)\nENTRY(_start)\nMEMORY { RAM (rwx) : ORIGIN = 0x00010000, LENGTH = 0x4000000 }\nSECTIONS {\n    .text : { *(.text .text.*) } > RAM\n    .rodata : { *(.rodata .rodata.*) *(.srodata .srodata.*) } > RAM\n    .data : { *(.data .data.*) *(.sdata .sdata.*) } > RAM\n    .got : { *(.got) *(.got.plt) } > RAM\n    .bss : { __bss_start = .; *(.sbss .sbss.*) *(.bss .bss.*) *(COMMON) __bss_end = .; } > RAM\n    /DISCARD/ : { *(.note .note.*) *(.comment) *(.eh_frame) *(.gnu.hash) *(.riscv.attributes) }\n}\n\000"

	.bss
	.align 2
	.globl g_ngot
g_ngot:
	.space 4
	.align 2
	.globl g_got
g_got:
	.space 4
