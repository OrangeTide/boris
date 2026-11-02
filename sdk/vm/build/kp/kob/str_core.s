# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type str_ptr, @function
str_ptr:
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
	bnez s1, .L1_0
	j .L1_1
.L1_0:
	lw s1, -4(s0)
	sw s1, -12(s0)
	j .L1_2
.L1_1:
	li s1, 0
	sw s1, -12(s0)
.L1_2:
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
.Lfunc_end1:
	.size str_ptr, .Lfunc_end1-str_ptr

	.text
	.align 2
	.type str_finalize, @function
str_finalize:
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
	jal ra, gheap_free
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
	.size str_finalize, .Lfunc_end2-str_finalize

	.text
	.align 2
	.type str_make, @function
str_make:
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
	li s1, 1
	la s2, str_finalize
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	lw s1, -4(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	li s1, 0
	lw s2, -12(s0)
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
.L3_1:
	lw s1, -8(s0)
	lw s2, -4(s0)
	slt s3, s1, s2
	bnez s3, .L3_2
	j .L3_3
.L3_2:
	lw s1, -4(s0)
	sw s1, -8(s0)
.L3_3:
	li s1, 4
	li s2, 4
	mul s3, s1, s2
	lw s1, -8(s0)
	add s2, s3, s1
	li s1, 1
	add s3, s2, s1
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -20(s0)
	lw s1, -20(s0)
	sw s1, -24(s0)
	li s1, 1
	lw s2, -24(s0)
	sw s1, 0(s2)
	li s1, 1
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -24(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, -4(s0)
	add s3, s4, s2
	sb s1, 0(s3)
	lw s1, -24(s0)
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
.Lfunc_end3:
	.size str_make, .Lfunc_end3-str_make

	.text
	.align 2
	.type str_grow_cap, @function
str_grow_cap:
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
	li s2, 8
	slt s3, s2, s1
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	lw s1, -8(s0)
	sw s1, -16(s0)
	j .L4_2
.L4_1:
	li s1, 8
	sw s1, -16(s0)
.L4_2:
	lw s1, -16(s0)
	sw s1, -12(s0)
.L4_3:
	lw s1, -12(s0)
	lw s2, -4(s0)
	slt s3, s1, s2
	bnez s3, .L4_4
	j .L4_5
.L4_4:
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -12(s0)
	add s3, s2, s1
	sw s3, -12(s0)
	j .L4_3
.L4_5:
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
.Lfunc_end4:
	.size str_grow_cap, .Lfunc_end4-str_grow_cap

	.text
	.align 2
	.type str_append_bytes, @function
str_append_bytes:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, str_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L5_0
	j .L5_1
.L5_0:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	j .L5_2
.L5_1:
	li s1, 0
	sw s1, -28(s0)
.L5_2:
	lw s1, -28(s0)
	sw s1, -24(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	sw s3, -32(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L5_3
	j .L5_4
.L5_3:
	lw s1, -4(s0)
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
.L5_4:
	lw s1, -20(s0)
	bnez s1, .L5_5
	j .L5_6
.L5_5:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_7
	j .L5_6
.L5_7:
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -32(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_8
	j .L5_6
.L5_8:
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -24(s0)
	add s2, s3, s1
	lw s1, -8(s0)
	lw s3, -12(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -32(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, -32(s0)
	add s3, s4, s2
	sb s1, 0(s3)
	lw s1, -4(s0)
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
.L5_6:
	lw s1, -32(s0)
	lw s2, -32(s0)
	lw s3, -20(s0)
	bnez s3, .L5_9
	j .L5_10
.L5_9:
	lw s3, -20(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	sw s3, -44(s0)
	j .L5_11
.L5_10:
	li s3, 0
	sw s3, -44(s0)
.L5_11:
	lw s3, -44(s0)
	mv a0, s2
	mv a1, s3
	jal ra, str_grow_cap
	mv s4, a0
	addi s2, s0, -36
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, str_make
	mv s3, a0
	sw s3, -40(s0)
	lw s1, -24(s0)
	bnez s1, .L5_12
	j .L5_13
.L5_12:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -20(s0)
	li s2, 16
	add s4, s1, s2
	lw s1, -24(s0)
	mv a0, s3
	mv a1, s4
	mv a2, s1
	jal ra, memcpy
	mv s2, a0
.L5_13:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -24(s0)
	add s2, s3, s1
	lw s1, -8(s0)
	lw s3, -12(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
	lw s1, -40(s0)
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
.Lfunc_end5:
	.size str_append_bytes, .Lfunc_end5-str_append_bytes

	.text
	.align 2
	.globl kp_str_new
	.type kp_str_new, @function
kp_str_new:
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
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L6_0
	j .L6_1
.L6_0:
	li s1, 0
	sw s1, -8(s0)
.L6_1:
	lw s1, -8(s0)
	lw s2, -8(s0)
	addi s3, s0, -12
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_make
	mv s4, a0
	sw s4, -16(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L6_2
	j .L6_3
.L6_2:
	lw s1, -4(s0)
	bnez s1, .L6_4
	j .L6_5
.L6_4:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	j .L6_6
.L6_5:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	li s1, 0
	lw s2, -8(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memset
	mv s4, a0
.L6_6:
.L6_3:
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
.Lfunc_end6:
	.size kp_str_new, .Lfunc_end6-kp_str_new

	.text
	.align 2
	.globl kp_str_new_guest
	.type kp_str_new_guest, @function
kp_str_new_guest:
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
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	lw s1, -4(s0)
	sw s1, -16(s0)
	j .L7_2
.L7_1:
	li s1, 0
	sw s1, -16(s0)
.L7_2:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
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
.Lfunc_end7:
	.size kp_str_new_guest, .Lfunc_end7-kp_str_new_guest

	.text
	.align 2
	.globl kp_str_concat
	.type kp_str_concat, @function
kp_str_concat:
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
	mv a0, s1
	jal ra, str_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, str_ptr
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -12(s0)
	bnez s1, .L8_0
	j .L8_1
.L8_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	j .L8_2
.L8_1:
	li s1, 0
	sw s1, -24(s0)
.L8_2:
	lw s1, -24(s0)
	sw s1, -20(s0)
	lw s1, -16(s0)
	bnez s1, .L8_3
	j .L8_4
.L8_3:
	lw s1, -16(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L8_5
.L8_4:
	li s1, 0
	sw s1, -32(s0)
.L8_5:
	lw s1, -32(s0)
	sw s1, -28(s0)
	lw s1, -20(s0)
	lw s2, -28(s0)
	add s3, s1, s2
	lw s1, -20(s0)
	lw s2, -28(s0)
	add s4, s1, s2
	addi s1, s0, -36
	mv a0, s3
	mv a1, s4
	mv a2, s1
	jal ra, str_make
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -20(s0)
	bnez s1, .L8_6
	j .L8_7
.L8_6:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 16
	add s4, s1, s2
	lw s1, -20(s0)
	mv a0, s3
	mv a1, s4
	mv a2, s1
	jal ra, memcpy
	mv s2, a0
.L8_7:
	lw s1, -28(s0)
	bnez s1, .L8_8
	j .L8_9
.L8_8:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -20(s0)
	add s2, s3, s1
	lw s1, -16(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, -28(s0)
	mv a0, s2
	mv a1, s4
	mv a2, s1
	jal ra, memcpy
	mv s3, a0
.L8_9:
	lw s1, -40(s0)
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
.Lfunc_end8:
	.size kp_str_concat, .Lfunc_end8-kp_str_concat

	.text
	.align 2
	.globl kp_str_len
	.type kp_str_len, @function
kp_str_len:
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
	jal ra, str_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L9_0
	j .L9_1
.L9_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L9_2
.L9_1:
	li s1, 0
	sw s1, -16(s0)
.L9_2:
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
.Lfunc_end9:
	.size kp_str_len, .Lfunc_end9-kp_str_len

	.text
	.align 2
	.globl kp_str_bytes
	.type kp_str_bytes, @function
kp_str_bytes:
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
	jal ra, str_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L10_0
	j .L10_1
.L10_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L10_2
	j .L10_1
.L10_2:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	sw s3, -16(s0)
	j .L10_3
.L10_1:
	la s1, __str_0
	sw s1, -16(s0)
.L10_3:
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
	.size kp_str_bytes, .Lfunc_end10-kp_str_bytes

	.text
	.align 2
	.globl kp_str_base
	.type kp_str_base, @function
kp_str_base:
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
	bnez s1, .L11_0
	j .L11_1
.L11_0:
	lw s1, -4(s0)
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -12(s0)
	j .L11_2
.L11_1:
	li s1, 0
	sw s1, -12(s0)
.L11_2:
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
.Lfunc_end11:
	.size kp_str_base, .Lfunc_end11-kp_str_base

	.text
	.align 2
	.globl kp_str_from_char
	.type kp_str_from_char, @function
kp_str_from_char:
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
	li s2, 255
	and s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	sw s3, -12(s0)
	addi s1, s0, -12
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
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
.Lfunc_end12:
	.size kp_str_from_char, .Lfunc_end12-kp_str_from_char

	.text
	.align 2
	.globl kp_str_append_char
	.type kp_str_append_char, @function
kp_str_append_char:
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
	li s2, 255
	and s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	sw s3, -12(s0)
	lw s1, -4(s0)
	addi s2, s0, -12
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_append_bytes
	mv s4, a0
	mv a0, s4
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
	.size kp_str_append_char, .Lfunc_end13-kp_str_append_char

	.text
	.align 2
	.globl kp_str_append
	.type kp_str_append, @function
kp_str_append:
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
	mv a0, s1
	jal ra, str_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L14_0
	j .L14_1
.L14_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_1
	j .L14_2
.L14_1:
	lw s1, -4(s0)
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
.L14_2:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, -12(s0)
	li s3, 8
	add s5, s2, s3
	lw s2, 0(s5)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, str_append_bytes
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
.Lfunc_end14:
	.size kp_str_append, .Lfunc_end14-kp_str_append

	.text
	.align 2
	.globl kp_str_cmp
	.type kp_str_cmp, @function
kp_str_cmp:
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
	mv a0, s1
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -12(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L15_0
	j .L15_1
.L15_0:
	lw s1, -12(s0)
	sw s1, -24(s0)
	j .L15_2
.L15_1:
	lw s1, -16(s0)
	sw s1, -24(s0)
.L15_2:
	lw s1, -24(s0)
	sw s1, -20(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_bytes
	mv s2, a0
	lw s1, -8(s0)
	mv a0, s1
	jal ra, kp_str_bytes
	mv s3, a0
	lw s1, -20(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, rt_memcmp
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_3
	j .L15_4
.L15_3:
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_5
	j .L15_6
.L15_5:
	li s1, 1
	neg s2, s1
	sw s2, -32(s0)
	j .L15_7
.L15_6:
	li s1, 1
	sw s1, -32(s0)
.L15_7:
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
.L15_4:
	lw s1, -12(s0)
	lw s2, -16(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_8
	j .L15_9
.L15_8:
	lw s1, -12(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L15_10
	j .L15_11
.L15_10:
	li s1, 1
	neg s2, s1
	sw s2, -36(s0)
	j .L15_12
.L15_11:
	li s1, 1
	sw s1, -36(s0)
.L15_12:
	lw s1, -36(s0)
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
.L15_9:
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
.Lfunc_end15:
	.size kp_str_cmp, .Lfunc_end15-kp_str_cmp

	.text
	.align 2
	.globl kp_str_pos
	.type kp_str_pos, @function
kp_str_pos:
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
	mv a0, s1
	jal ra, str_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, str_ptr
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -12(s0)
	bnez s1, .L16_0
	j .L16_1
.L16_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	j .L16_2
.L16_1:
	li s1, 0
	sw s1, -24(s0)
.L16_2:
	lw s1, -24(s0)
	sw s1, -20(s0)
	lw s1, -16(s0)
	bnez s1, .L16_3
	j .L16_4
.L16_3:
	lw s1, -16(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L16_5
.L16_4:
	li s1, 0
	sw s1, -32(s0)
.L16_5:
	lw s1, -32(s0)
	sw s1, -28(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_6
	j .L16_7
.L16_7:
	lw s1, -20(s0)
	lw s2, -28(s0)
	slt s3, s2, s1
	bnez s3, .L16_6
	j .L16_8
.L16_6:
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
.L16_8:
	li s1, 0
	sw s1, -36(s0)
.L16_9:
	lw s1, -36(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lw s1, -28(s0)
	slt s2, s1, s3
	xori s2, s2, 1
	bnez s2, .L16_10
	j .L16_11
.L16_10:
	lw s1, -16(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -36(s0)
	add s2, s3, s1
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, -20(s0)
	mv a0, s2
	mv a1, s4
	mv a2, s1
	jal ra, rt_memcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_12
	j .L16_13
.L16_12:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	mv a0, s3
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
.L16_13:
.L16_14:
	addi s1, s0, -36
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -36(s0)
	j .L16_9
.L16_11:
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
	.size kp_str_pos, .Lfunc_end16-kp_str_pos

	.text
	.align 2
	.globl kp_str_copy
	.type kp_str_copy, @function
kp_str_copy:
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
	mv a0, s1
	jal ra, str_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L17_0
	j .L17_1
.L17_0:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	j .L17_2
.L17_1:
	li s1, 0
	sw s1, -28(s0)
.L17_2:
	lw s1, -28(s0)
	sw s1, -24(s0)
	lw s1, -8(s0)
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L17_3
	j .L17_4
.L17_3:
	li s1, 1
	sw s1, -8(s0)
.L17_4:
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L17_5
	j .L17_6
.L17_6:
	lw s1, -8(s0)
	lw s2, -24(s0)
	slt s3, s2, s1
	bnez s3, .L17_5
	j .L17_7
.L17_5:
	li s1, 0
	sw s1, -12(s0)
	j .L17_8
.L17_7:
	lw s1, -24(s0)
	lw s2, -8(s0)
	li s3, 1
	sub s4, s2, s3
	sub s2, s1, s4
	sw s2, -32(s0)
	lw s1, -12(s0)
	lw s2, -32(s0)
	slt s3, s2, s1
	bnez s3, .L17_9
	j .L17_10
.L17_9:
	lw s1, -32(s0)
	sw s1, -12(s0)
.L17_10:
.L17_8:
	lw s1, -12(s0)
	lw s2, -12(s0)
	addi s3, s0, -36
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_make
	mv s4, a0
	sw s4, -40(s0)
	lw s1, -12(s0)
	bnez s1, .L17_11
	j .L17_12
.L17_11:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -20(s0)
	li s2, 16
	add s4, s1, s2
	lw s1, -8(s0)
	li s2, 1
	sub s5, s1, s2
	add s1, s4, s5
	lw s2, -12(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
.L17_12:
	lw s1, -40(s0)
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
.Lfunc_end17:
	.size kp_str_copy, .Lfunc_end17-kp_str_copy

	.data
	.align 2
__str_0:
	.ascii "\000"
