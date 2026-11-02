# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type round_up, @function
round_up:
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
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	lw s1, -8(s0)
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
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
.Lfunc_end1:
	.size round_up, .Lfunc_end1-round_up

	.text
	.align 2
	.type set_hdr, @function
set_hdr:
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
	bnez s2, .L2_0
	j .L2_1
.L2_0:
	li s2, 1
	sw s2, -20(s0)
	j .L2_2
.L2_1:
	li s2, 0
	sw s2, -20(s0)
.L2_2:
	lw s2, -20(s0)
	or s3, s1, s2
	lw s1, -4(s0)
	sw s3, 0(s1)
	lw s1, -8(s0)
	lw s2, -4(s0)
	lw s3, -8(s0)
	add s4, s2, s3
	li s2, 4
	sub s3, s4, s2
	sw s1, 0(s3)
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
.Lfunc_end2:
	.size set_hdr, .Lfunc_end2-set_hdr

	.text
	.align 2
	.type bin_head, @function
bin_head:
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
	li s2, 16
	divu s3, s1, s2
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 512
	sltu s3, s1, s2
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	la s1, bins
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -16(s0)
	j .L3_2
.L3_1:
	la s1, large
	sw s1, -16(s0)
.L3_2:
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
.Lfunc_end3:
	.size bin_head, .Lfunc_end3-bin_head

	.text
	.align 2
	.type push_free, @function
push_free:
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
	li s1, 16
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	mv a0, s3
	jal ra, bin_head
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	sw s1, 0(s3)
	lw s1, -12(s0)
	lw s2, 0(s1)
	bnez s2, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	lw s2, -12(s0)
	lw s3, 0(s2)
	li s2, 16
	add s4, s3, s2
	li s2, 4
	add s3, s4, s2
	sw s1, 0(s3)
.L4_1:
	lw s1, -4(s0)
	lw s2, -12(s0)
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
.Lfunc_end4:
	.size push_free, .Lfunc_end4-push_free

	.text
	.align 2
	.type unlink_free, @function
unlink_free:
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
	lw s2, 0(s1)
	li s1, 16
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	mv a0, s3
	jal ra, bin_head
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	li s1, 4
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L5_0
	j .L5_1
.L5_0:
	lw s1, -16(s0)
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	j .L5_2
.L5_1:
	lw s1, -16(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
.L5_2:
	lw s1, -16(s0)
	bnez s1, .L5_3
	j .L5_4
.L5_3:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	sw s1, 0(s3)
.L5_4:
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
.Lfunc_end5:
	.size unlink_free, .Lfunc_end5-unlink_free

	.text
	.align 2
	.type take_fit, @function
take_fit:
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
	li s2, 16
	divu s3, s1, s2
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 512
	sltu s3, s1, s2
	bnez s3, .L6_0
	j .L6_1
.L6_0:
	la s1, bins
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L6_2
	j .L6_1
.L6_2:
	la s1, bins
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -16(s0)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, unlink_free
	mv s2, a0
	lw s1, -16(s0)
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
	la s1, large
	lw s2, 0(s1)
	sw s2, -16(s0)
.L6_3:
	lw s1, -16(s0)
	bnez s1, .L6_4
	j .L6_5
.L6_4:
	lw s1, -16(s0)
	lw s2, 0(s1)
	li s1, 16
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	lw s1, -4(s0)
	sltu s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L6_6
	j .L6_7
.L6_6:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, unlink_free
	mv s2, a0
	lw s1, -16(s0)
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
.L6_7:
.L6_8:
	lw s1, -16(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L6_3
.L6_5:
	lw s1, -12(s0)
	li s2, 512
	sltu s3, s1, s2
	bnez s3, .L6_9
	j .L6_10
.L6_9:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -20(s0)
.L6_11:
	lw s1, -20(s0)
	li s2, 512
	sltu s3, s1, s2
	bnez s3, .L6_12
	j .L6_13
.L6_12:
	la s1, bins
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L6_14
	j .L6_15
.L6_14:
	la s1, bins
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -16(s0)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, unlink_free
	mv s2, a0
	lw s1, -16(s0)
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
.L6_15:
.L6_16:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L6_11
.L6_13:
.L6_10:
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
	.size take_fit, .Lfunc_end6-take_fit

	.text
	.align 2
	.type grow, @function
grow:
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
	la s1, arena_lo
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	li s1, 0
	mv a0, s1
	jal ra, __libc_sbrk
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L7_2
	j .L7_3
.L7_2:
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
.L7_3:
	lw s1, -12(s0)
	li s2, 16
	li s3, 1
	sub s4, s2, s3
	and s2, s1, s4
	sw s2, -28(s0)
	lw s1, -28(s0)
	bnez s1, .L7_4
	j .L7_5
.L7_4:
	li s1, 16
	lw s2, -28(s0)
	sub s3, s1, s2
	mv a0, s3
	jal ra, __libc_sbrk
	mv s1, a0
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L7_6
	j .L7_5
.L7_6:
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
.L7_5:
	li s1, 0
	mv a0, s1
	jal ra, __libc_sbrk
	mv s2, a0
	la s1, brk_end
	sw s2, 0(s1)
	la s1, arena_lo
	sw s2, 0(s1)
.L7_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, __libc_sbrk
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L7_7
	j .L7_8
.L7_7:
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
.L7_8:
	lw s1, -12(s0)
	lw s2, -4(s0)
	add s3, s1, s2
	la s1, brk_end
	sw s3, 0(s1)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_hdr
	mv s4, a0
	lw s1, -12(s0)
	sw s1, -16(s0)
	lw s1, -12(s0)
	la s2, arena_lo
	lw s3, 0(s2)
	slt s2, s3, s1
	bnez s2, .L7_9
	j .L7_10
.L7_9:
	lw s1, -12(s0)
	li s2, 4
	sub s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -12(s0)
	lw s2, -24(s0)
	sub s3, s1, s2
	sw s3, -20(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 1
	and s3, s2, s1
	bnez s3, .L7_11
	j .L7_12
.L7_12:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, unlink_free
	mv s2, a0
	lw s1, -20(s0)
	sw s1, -16(s0)
	lw s1, -16(s0)
	lw s2, -24(s0)
	lw s3, -4(s0)
	add s4, s2, s3
	li s2, 0
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, set_hdr
	mv s3, a0
.L7_11:
.L7_10:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, push_free
	mv s2, a0
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
.Lfunc_end7:
	.size grow, .Lfunc_end7-grow

	.text
	.align 2
	.globl malloc
	.type malloc, @function
malloc:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_0:
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
.L8_1:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	li s1, 4
	add s2, s3, s1
	li s1, 16
	mv a0, s2
	mv a1, s1
	jal ra, round_up
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 16
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	li s2, 16
	li s3, 1
	sub s5, s2, s3
	add s2, s4, s5
	li s3, 16
	li s4, 1
	sub s5, s3, s4
	not s3, s5
	and s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L8_2
	j .L8_3
.L8_2:
	li s1, 16
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 16
	li s2, 1
	sub s4, s1, s2
	add s1, s3, s4
	li s2, 16
	li s3, 1
	sub s4, s2, s3
	not s2, s4
	and s3, s1, s2
	sw s3, -12(s0)
.L8_3:
.L8_4:
	j .L8_5
.L8_5:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, take_fit
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L8_6
	j .L8_7
.L8_6:
	j .L8_8
.L8_7:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, grow
	mv s2, a0
	bnez s2, .L8_9
	j .L8_10
.L8_10:
	li s1, 5
	la s2, errno
	sw s1, 0(s2)
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
.L8_9:
.L8_11:
	j .L8_4
.L8_8:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 16
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	sw s3, -16(s0)
	lw s1, -16(s0)
	lw s2, -12(s0)
	sub s3, s1, s2
	li s1, 16
	li s2, 2
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 4
	add s4, s2, s1
	li s1, 16
	li s2, 1
	sub s5, s1, s2
	add s1, s4, s5
	li s2, 16
	li s4, 1
	sub s5, s2, s4
	not s2, s5
	and s4, s1, s2
	sltu s1, s3, s4
	xori s1, s1, 1
	bnez s1, .L8_12
	j .L8_13
.L8_12:
	lw s1, -20(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	sw s3, -24(s0)
	lw s1, -24(s0)
	lw s2, -16(s0)
	lw s3, -12(s0)
	sub s4, s2, s3
	li s2, 0
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, set_hdr
	mv s3, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, push_free
	mv s2, a0
	lw s1, -20(s0)
	lw s2, -12(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_hdr
	mv s4, a0
	j .L8_14
.L8_13:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_hdr
	mv s4, a0
.L8_14:
	la s1, live
	lw s2, 0(s1)
	lw s3, -20(s0)
	lw s4, 0(s3)
	li s3, 16
	li s5, 1
	sub s6, s3, s5
	not s3, s6
	and s5, s4, s3
	add s3, s2, s5
	sw s3, 0(s1)
	la s1, live
	lw s2, 0(s1)
	la s1, peak
	lw s3, 0(s1)
	sltu s1, s3, s2
	bnez s1, .L8_15
	j .L8_16
.L8_15:
	la s1, live
	lw s2, 0(s1)
	la s1, peak
	sw s2, 0(s1)
.L8_16:
	lw s1, -20(s0)
	li s2, 16
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
.Lfunc_end8:
	.size malloc, .Lfunc_end8-malloc

	.text
	.align 2
	.globl free
	.type free, @function
free:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_0
	j .L9_1
.L9_0:
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
	lw s1, -4(s0)
	li s2, 16
	sub s3, s1, s2
	sw s3, -12(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 1
	and s3, s2, s1
	bnez s3, .L9_2
	j .L9_3
.L9_3:
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
.L9_2:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s3, 1
	not s4, s3
	and s3, s2, s4
	sw s3, 0(s1)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 16
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	sw s3, -24(s0)
	la s1, live
	lw s2, 0(s1)
	lw s3, -24(s0)
	sub s4, s2, s3
	sw s4, 0(s1)
	lw s1, -12(s0)
	lw s2, -24(s0)
	add s3, s1, s2
	sw s3, -16(s0)
	lw s1, -16(s0)
	la s2, brk_end
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L9_4
	j .L9_5
.L9_4:
	lw s1, -16(s0)
	lw s2, 0(s1)
	li s1, 1
	and s3, s2, s1
	bnez s3, .L9_5
	j .L9_6
.L9_6:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, unlink_free
	mv s2, a0
	addi s1, s0, -24
	lw s2, 0(s1)
	lw s1, -16(s0)
	lw s3, 0(s1)
	li s1, 16
	li s4, 1
	sub s5, s1, s4
	not s1, s5
	and s4, s3, s1
	add s1, s2, s4
	sw s1, -24(s0)
.L9_5:
	lw s1, -12(s0)
	la s2, arena_lo
	lw s3, 0(s2)
	slt s2, s3, s1
	bnez s2, .L9_7
	j .L9_8
.L9_7:
	lw s1, -12(s0)
	li s2, 4
	sub s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	lw s1, -12(s0)
	lw s2, -28(s0)
	sub s3, s1, s2
	sw s3, -20(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 1
	and s3, s2, s1
	bnez s3, .L9_9
	j .L9_10
.L9_10:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, unlink_free
	mv s2, a0
	lw s1, -20(s0)
	sw s1, -12(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	lw s1, -28(s0)
	add s3, s2, s1
	sw s3, -24(s0)
.L9_9:
.L9_8:
	lw s1, -12(s0)
	lw s2, -24(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_hdr
	mv s4, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, push_free
	mv s2, a0
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
.Lfunc_end9:
	.size free, .Lfunc_end9-free

	.text
	.align 2
	.globl calloc
	.type calloc, @function
calloc:
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
	mul s3, s1, s2
	sw s3, -12(s0)
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	divu s3, s1, s2
	lw s1, -8(s0)
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L10_2
	j .L10_1
.L10_2:
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
.L10_1:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, malloc
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -16(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L10_3
	j .L10_4
.L10_3:
	lw s1, -16(s0)
	li s2, 0
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
.L10_4:
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
.Lfunc_end10:
	.size calloc, .Lfunc_end10-calloc

	.text
	.align 2
	.globl realloc
	.type realloc, @function
realloc:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_1
.L11_0:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, malloc
	mv s2, a0
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
.L11_1:
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_2
	j .L11_3
.L11_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, free
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
.L11_3:
	lw s1, -4(s0)
	li s2, 16
	sub s3, s1, s2
	sw s3, -12(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 16
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	li s1, 16
	sub s2, s3, s1
	li s1, 4
	sub s3, s2, s1
	sw s3, -16(s0)
	lw s1, -16(s0)
	lw s2, -8(s0)
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_4
	j .L11_5
.L11_4:
	lw s1, -4(s0)
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
	mv a0, s1
	jal ra, malloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_6
	j .L11_7
.L11_6:
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
.L11_7:
	lw s1, -20(s0)
	lw s2, -4(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, free
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
.Lfunc_end11:
	.size realloc, .Lfunc_end11-realloc

	.text
	.align 2
	.globl __libc_malloc_live
	.type __libc_malloc_live, @function
__libc_malloc_live:
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
	la s1, live
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
.Lfunc_end12:
	.size __libc_malloc_live, .Lfunc_end12-__libc_malloc_live

	.text
	.align 2
	.globl __libc_malloc_peak
	.type __libc_malloc_peak, @function
__libc_malloc_peak:
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
	la s1, peak
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
.Lfunc_end13:
	.size __libc_malloc_peak, .Lfunc_end13-__libc_malloc_peak

	.data

	.bss
	.align 2
	.globl peak
peak:
	.space 4
	.align 2
	.globl live
live:
	.space 4
	.align 2
	.globl brk_end
brk_end:
	.space 4
	.align 2
	.globl arena_lo
arena_lo:
	.space 4
	.align 2
	.globl large
large:
	.space 4
	.align 2
	.globl bins
bins:
	.space 2048
