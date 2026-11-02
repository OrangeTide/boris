# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type arr_ptr, @function
arr_ptr:
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
	.size arr_ptr, .Lfunc_end1-arr_ptr

	.text
	.align 2
	.type blob_i32, @function
blob_i32:
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
	addi s1, s0, -12
	lw s2, -4(s0)
	lw s3, -8(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
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
	.size blob_i32, .Lfunc_end2-blob_i32

	.text
	.align 2
	.type elem_ptr, @function
elem_ptr:
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
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -4(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
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
.Lfunc_end3:
	.size elem_ptr, .Lfunc_end3-elem_ptr

	.text
	.align 2
	.type release_elems, @function
release_elems:
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
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_0
	j .L4_1
.L4_0:
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
.L4_1:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, blob_i32
	mv s3, a0
	sw s3, -28(s0)
	lw s1, -8(s0)
	sw s1, -20(s0)
.L4_2:
	lw s1, -20(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L4_3
	j .L4_4
.L4_3:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, elem_ptr
	mv s3, a0
	sw s3, -32(s0)
	li s1, 0
	sw s1, -24(s0)
.L4_5:
	lw s1, -24(s0)
	lw s2, -28(s0)
	slt s3, s1, s2
	bnez s3, .L4_6
	j .L4_7
.L4_6:
	lw s1, -32(s0)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	lw s4, -24(s0)
	add s5, s3, s4
	mv a0, s2
	mv a1, s5
	jal ra, blob_i32
	mv s3, a0
	add s2, s1, s3
	lw s1, 0(s2)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
.L4_8:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L4_5
.L4_7:
.L4_9:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L4_2
.L4_4:
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
.Lfunc_end4:
	.size release_elems, .Lfunc_end4-release_elems

	.text
	.align 2
	.type retain_elems, @function
retain_elems:
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
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_0
	j .L5_1
.L5_0:
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
.L5_1:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, blob_i32
	mv s3, a0
	sw s3, -28(s0)
	lw s1, -8(s0)
	sw s1, -20(s0)
.L5_2:
	lw s1, -20(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L5_3
	j .L5_4
.L5_3:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, elem_ptr
	mv s3, a0
	sw s3, -32(s0)
	li s1, 0
	sw s1, -24(s0)
.L5_5:
	lw s1, -24(s0)
	lw s2, -28(s0)
	slt s3, s1, s2
	bnez s3, .L5_6
	j .L5_7
.L5_6:
	lw s1, -32(s0)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	lw s4, -24(s0)
	add s5, s3, s4
	mv a0, s2
	mv a1, s5
	jal ra, blob_i32
	mv s3, a0
	add s2, s1, s3
	lw s1, 0(s2)
	mv a0, s1
	jal ra, kp_retain
	mv s2, a0
.L5_8:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L5_5
.L5_7:
.L5_9:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L5_2
.L5_4:
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
	.size retain_elems, .Lfunc_end5-retain_elems

	.text
	.align 2
	.type arr_finalize, @function
arr_finalize:
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
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, release_elems
	mv s4, a0
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L6_0
	j .L6_1
.L6_0:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L6_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gheap_free
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
.Lfunc_end6:
	.size arr_finalize, .Lfunc_end6-arr_finalize

	.text
	.align 2
	.type arr_new, @function
arr_new:
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
	li s1, 2
	la s2, arr_finalize
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	li s1, 24
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -24(s0)
	li s1, 1
	lw s2, -24(s0)
	sw s1, 0(s2)
	li s1, 2
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -24(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -24(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	lw s2, -24(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	lw s3, -4(s0)
	lw s4, -8(s0)
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memset
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
.L7_1:
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
.Lfunc_end7:
	.size arr_new, .Lfunc_end7-arr_new

	.text
	.align 2
	.globl kp_arr_len
	.type kp_arr_len, @function
kp_arr_len:
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
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L8_0
	j .L8_1
.L8_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L8_2
.L8_1:
	li s1, 0
	sw s1, -16(s0)
.L8_2:
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
.Lfunc_end8:
	.size kp_arr_len, .Lfunc_end8-kp_arr_len

	.text
	.align 2
	.globl kp_arr_clone
	.type kp_arr_clone, @function
kp_arr_clone:
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
	bnez s3, .L9_0
	j .L9_1
.L9_0:
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
.L9_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -12(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arr_new
	mv s4, a0
	sw s4, -20(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L9_2
	j .L9_3
.L9_2:
	lw s1, -16(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -12(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
	lw s1, -16(s0)
	li s2, 0
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, retain_elems
	mv s4, a0
.L9_3:
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
.Lfunc_end9:
	.size kp_arr_clone, .Lfunc_end9-kp_arr_clone

	.text
	.align 2
	.globl kp_arr_base
	.type kp_arr_base, @function
kp_arr_base:
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
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L10_0
	j .L10_1
.L10_0:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L10_2
.L10_1:
	li s1, 0
	sw s1, -16(s0)
.L10_2:
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
	.size kp_arr_base, .Lfunc_end10-kp_arr_base

	.text
	.align 2
	.type arr_resize_inplace, @function
arr_resize_inplace:
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
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L11_0
	j .L11_1
.L11_0:
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
.L11_1:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L11_2
	j .L11_3
.L11_2:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -4(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, release_elems
	mv s4, a0
.L11_3:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, gheap_realloc
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L11_4
	j .L11_5
.L11_4:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -12(s0)
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	lw s3, -8(s0)
	lw s4, -4(s0)
	li s5, 8
	add s6, s4, s5
	lw s4, 0(s6)
	sub s5, s3, s4
	lw s3, -12(s0)
	mul s4, s5, s3
	mv a0, s2
	mv a1, s1
	mv a2, s4
	jal ra, memset
	mv s3, a0
.L11_5:
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -4(s0)
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
.Lfunc_end11:
	.size arr_resize_inplace, .Lfunc_end11-arr_resize_inplace

	.text
	.align 2
	.globl kp_arr_setlen
	.type kp_arr_setlen, @function
kp_arr_setlen:
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
	sw a3, -16(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L12_0
	j .L12_1
.L12_0:
	li s1, 0
	sw s1, -8(s0)
.L12_1:
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_2
	j .L12_3
.L12_2:
	lw s1, -8(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arr_new
	mv s4, a0
	mv a0, s4
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
.L12_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 1
	sltu s3, s1, s2
	bnez s3, .L12_4
	j .L12_5
.L12_4:
	lw s1, -8(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arr_new
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -8(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_6
	j .L12_7
.L12_6:
	lw s1, -8(s0)
	sw s1, -36(s0)
	j .L12_8
.L12_7:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
.L12_8:
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s1, -28(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L12_9
	j .L12_10
.L12_9:
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -32(s0)
	lw s4, -20(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
	lw s1, -24(s0)
	li s2, 0
	lw s3, -32(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, retain_elems
	mv s4, a0
.L12_10:
	lw s1, -28(s0)
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
.L12_5:
	lw s1, -20(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arr_resize_inplace
	mv s3, a0
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
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
	.size kp_arr_setlen, .Lfunc_end12-kp_arr_setlen

	.text
	.align 2
	.type arr_delete_inplace, @function
arr_delete_inplace:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	sub s3, s1, s2
	sw s3, -24(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -8(s0)
	lw s4, -12(s0)
	add s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, release_elems
	mv s3, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sub s3, s1, s2
	lw s1, -12(s0)
	sub s2, s3, s1
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L13_0
	j .L13_1
.L13_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, elem_ptr
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s4, -12(s0)
	add s5, s2, s4
	mv a0, s1
	mv a1, s5
	jal ra, elem_ptr
	mv s2, a0
	lw s1, -4(s0)
	li s4, 8
	add s5, s1, s4
	lw s1, 0(s5)
	lw s4, -8(s0)
	sub s5, s1, s4
	lw s1, -12(s0)
	sub s4, s5, s1
	lw s1, -20(s0)
	mul s5, s4, s1
	mv a0, s3
	mv a1, s2
	mv a2, s5
	jal ra, memmove
	mv s1, a0
.L13_1:
	lw s1, -24(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_2
	j .L13_3
.L13_2:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_4
	j .L13_5
.L13_4:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L13_5:
	li s1, 0
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	j .L13_6
.L13_3:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	lw s3, -20(s0)
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, gheap_realloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
.L13_6:
	lw s1, -24(s0)
	lw s2, -4(s0)
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
.Lfunc_end13:
	.size arr_delete_inplace, .Lfunc_end13-arr_delete_inplace

	.text
	.align 2
	.type arr_insert_inplace, @function
arr_insert_inplace:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	add s3, s1, s2
	sw s3, -24(s0)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	lw s3, -20(s0)
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, gheap_realloc
	mv s2, a0
	lw s1, -4(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sub s3, s1, s2
	li s1, 0
	slt s2, s1, s3
	bnez s2, .L14_0
	j .L14_1
.L14_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, elem_ptr
	mv s2, a0
	lw s1, -4(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s3
	jal ra, elem_ptr
	mv s4, a0
	lw s1, -4(s0)
	li s3, 8
	add s5, s1, s3
	lw s1, 0(s5)
	lw s3, -8(s0)
	sub s5, s1, s3
	lw s1, -20(s0)
	mul s3, s5, s1
	mv a0, s2
	mv a1, s4
	mv a2, s3
	jal ra, memmove
	mv s1, a0
.L14_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, elem_ptr
	mv s3, a0
	li s1, 0
	lw s2, -12(s0)
	lw s4, -20(s0)
	mul s5, s2, s4
	mv a0, s3
	mv a1, s1
	mv a2, s5
	jal ra, memset
	mv s2, a0
	lw s1, -24(s0)
	lw s2, -4(s0)
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
.Lfunc_end14:
	.size arr_insert_inplace, .Lfunc_end14-arr_insert_inplace

	.text
	.align 2
	.globl kp_arr_delete
	.type kp_arr_delete, @function
kp_arr_delete:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_0
	j .L15_1
.L15_0:
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
.L15_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_2
	j .L15_3
.L15_2:
	li s1, 0
	sw s1, -8(s0)
.L15_3:
	lw s1, -8(s0)
	lw s2, -24(s0)
	slt s3, s2, s1
	bnez s3, .L15_4
	j .L15_5
.L15_4:
	lw s1, -24(s0)
	sw s1, -8(s0)
.L15_5:
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_6
	j .L15_7
.L15_6:
	li s1, 0
	sw s1, -12(s0)
.L15_7:
	lw s1, -12(s0)
	lw s2, -24(s0)
	lw s3, -8(s0)
	sub s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L15_8
	j .L15_9
.L15_8:
	lw s1, -24(s0)
	lw s2, -8(s0)
	sub s3, s1, s2
	sw s3, -12(s0)
.L15_9:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_10
	j .L15_11
.L15_10:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
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
.L15_11:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 1
	sltu s3, s1, s2
	bnez s3, .L15_12
	j .L15_13
.L15_12:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_arr_clone
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	lw s1, -8(s0)
	lw s3, -12(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arr_delete_inplace
	mv s4, a0
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
.L15_13:
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arr_delete_inplace
	mv s4, a0
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
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
.Lfunc_end15:
	.size kp_arr_delete, .Lfunc_end15-kp_arr_delete

	.text
	.align 2
	.globl kp_arr_insert
	.type kp_arr_insert, @function
kp_arr_insert:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L16_0
	j .L16_1
.L16_0:
	li s1, 0
	sw s1, -12(s0)
.L16_1:
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_2
	j .L16_3
.L16_2:
	lw s1, -12(s0)
	lw s2, -16(s0)
	lw s3, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arr_new
	mv s4, a0
	mv a0, s4
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
.L16_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L16_4
	j .L16_5
.L16_4:
	li s1, 0
	sw s1, -8(s0)
.L16_5:
	lw s1, -8(s0)
	lw s2, -32(s0)
	slt s3, s2, s1
	bnez s3, .L16_6
	j .L16_7
.L16_6:
	lw s1, -32(s0)
	sw s1, -8(s0)
.L16_7:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L16_8
	j .L16_9
.L16_8:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
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
.L16_9:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s1, 1
	sltu s3, s1, s2
	bnez s3, .L16_10
	j .L16_11
.L16_10:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_arr_clone
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -36(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	lw s1, -8(s0)
	lw s3, -12(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arr_insert_inplace
	mv s4, a0
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
.L16_11:
	lw s1, -28(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arr_insert_inplace
	mv s4, a0
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
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
	.size kp_arr_insert, .Lfunc_end16-kp_arr_insert

	.text
	.align 2
	.type buf_finalize, @function
buf_finalize:
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
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L17_0
	j .L17_1
.L17_0:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L17_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gheap_free
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
.Lfunc_end17:
	.size buf_finalize, .Lfunc_end17-buf_finalize

	.text
	.align 2
	.globl kp_buf_new
	.type kp_buf_new, @function
kp_buf_new:
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
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L18_0
	j .L18_1
.L18_0:
	li s1, 0
	sw s1, -8(s0)
.L18_1:
	li s1, 4
	la s2, buf_finalize
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	li s1, 24
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -24(s0)
	li s1, 1
	lw s2, -24(s0)
	sw s1, 0(s2)
	li s1, 4
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -24(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -24(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -24(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end18:
	.size kp_buf_new, .Lfunc_end18-kp_buf_new

	.text
	.align 2
	.globl kp_buf_new_nd
	.type kp_buf_new_nd, @function
kp_buf_new_nd:
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
	lw s1, -8(s0)
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L19_0
	j .L19_1
.L19_0:
	lw s1, -4(s0)
	li s2, 0
	lw s3, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, kp_buf_new
	mv s4, a0
	mv a0, s4
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
.L19_1:
	li s1, 4
	la s2, buf_finalize
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	li s1, 24
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -28(s0)
	li s1, 1
	li s2, 2
	lw s3, -8(s0)
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	mul s3, s2, s1
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -32(s0)
	lw s1, -28(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -36(s0)
	li s1, 1
	lw s2, -36(s0)
	sw s1, 0(s2)
	li s1, 4
	lw s2, -36(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -36(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -36(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -36(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -36(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	sw s1, -44(s0)
	lw s1, -8(s0)
	lw s2, -44(s0)
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	sw s1, -40(s0)
.L19_2:
	lw s1, -40(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L19_3
	j .L19_4
.L19_3:
	lw s1, -12(s0)
	lw s2, -40(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -44(s0)
	li s3, 1
	lw s4, -40(s0)
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	sw s1, 0(s3)
	lw s1, -16(s0)
	lw s2, -40(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -44(s0)
	li s3, 1
	lw s4, -8(s0)
	add s5, s3, s4
	lw s3, -40(s0)
	add s4, s5, s3
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L19_5:
	addi s1, s0, -40
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -40(s0)
	j .L19_2
.L19_4:
	lw s1, -28(s0)
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
.Lfunc_end19:
	.size kp_buf_new_nd, .Lfunc_end19-kp_buf_new_nd

	.text
	.align 2
	.globl kp_buf_new_2d
	.type kp_buf_new_2d, @function
kp_buf_new_2d:
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
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -8(s0)
	addi s2, s0, -32
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -16(s0)
	addi s2, s0, -40
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	addi s2, s0, -32
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -20(s0)
	addi s2, s0, -40
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -4(s0)
	li s2, 2
	addi s3, s0, -32
	addi s4, s0, -40
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, kp_buf_new_nd
	mv s6, a0
	mv a0, s6
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
.Lfunc_end20:
	.size kp_buf_new_2d, .Lfunc_end20-kp_buf_new_2d

	.text
	.align 2
	.globl kp_buf_ndim
	.type kp_buf_ndim, @function
kp_buf_ndim:
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
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L21_0
	j .L21_1
.L21_0:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L21_1
	j .L21_2
.L21_1:
	li s1, 1
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
.L21_2:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, blob_i32
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
.Lfunc_end21:
	.size kp_buf_ndim, .Lfunc_end21-kp_buf_ndim

	.text
	.align 2
	.globl kp_buf_dim
	.type kp_buf_dim, @function
kp_buf_dim:
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
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L22_0
	j .L22_1
.L22_1:
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
.L22_0:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_2
	j .L22_3
.L22_2:
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_4
	j .L22_5
.L22_4:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L22_6
.L22_5:
	li s1, 1
	sw s1, -16(s0)
.L22_6:
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
.L22_3:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	lw s3, -8(s0)
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, blob_i32
	mv s2, a0
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
.Lfunc_end22:
	.size kp_buf_dim, .Lfunc_end22-kp_buf_dim

	.text
	.align 2
	.globl kp_buf_stride
	.type kp_buf_stride, @function
kp_buf_stride:
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
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L23_0
	j .L23_1
.L23_1:
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
.L23_0:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L23_2
	j .L23_3
.L23_2:
	lw s1, -8(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L23_4
	j .L23_5
.L23_4:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L23_6
.L23_5:
	li s1, 0
	sw s1, -20(s0)
.L23_6:
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
.L23_3:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, blob_i32
	mv s3, a0
	sw s3, -16(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	lw s3, -16(s0)
	add s4, s2, s3
	lw s2, -8(s0)
	add s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, blob_i32
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
.Lfunc_end23:
	.size kp_buf_stride, .Lfunc_end23-kp_buf_stride

	.text
	.align 2
	.type arr_or_buf, @function
arr_or_buf:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L24_0
	j .L24_1
.L24_0:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, arr_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L24_2
	j .L24_3
.L24_2:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L24_4
	j .L24_3
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
.L24_3:
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
.Lfunc_end24:
	.size arr_or_buf, .Lfunc_end24-arr_or_buf

	.text
	.align 2
	.type range_ok, @function
range_ok:
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
	lw s1, -8(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L25_0
	j .L25_1
.L25_1:
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L25_0
	j .L25_2
.L25_0:
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
.L25_2:
	lw s1, -8(s0)
	mv s10, s1
	srai s11, s10, 31
	lw s1, -12(s0)
	mv s8, s1
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv s10, s1
	srai s11, s10, 31
	slt s1, s11, s7
	bne s11, s7, .L25_3
	sltu s1, s10, s6
.L25_3:
	xori s1, s1, 1
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
.Lfunc_end25:
	.size range_ok, .Lfunc_end25-range_ok

	.text
	.align 2
	.type span_in_guest, @function
span_in_guest:
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
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	mv s10, s2
	srai s11, s10, 31
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	mv s8, s2
	srai s9, s8, 31
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
	mv s2, s6
	add s3, s1, s2
	sw s3, -20(s0)
	lw s1, -12(s0)
	mv s10, s1
	srai s11, s10, 31
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	mv s8, s1
	srai s9, s8, 31
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
	mv s1, s6
	sw s1, -24(s0)
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -24(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
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
.Lfunc_end26:
	.size span_in_guest, .Lfunc_end26-span_in_guest

	.text
	.align 2
	.globl kp_buf_len
	.type kp_buf_len, @function
kp_buf_len:
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
	jal ra, arr_or_buf
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L27_0
	j .L27_1
.L27_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L27_2
.L27_1:
	li s1, 1
	neg s2, s1
	sw s2, -16(s0)
.L27_2:
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
.Lfunc_end27:
	.size kp_buf_len, .Lfunc_end27-kp_buf_len

	.text
	.align 2
	.globl kp_buf_read
	.type kp_buf_read, @function
kp_buf_read:
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
	jal ra, arr_or_buf
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L28_0
	j .L28_1
.L28_0:
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, range_ok
	mv s4, a0
	bnez s4, .L28_2
	j .L28_1
.L28_2:
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, span_in_guest
	mv s4, a0
	bnez s4, .L28_3
	j .L28_1
.L28_1:
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
.L28_3:
	lw s1, -12(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L28_4
	j .L28_5
.L28_4:
	lw s1, -16(s0)
	lw s2, -20(s0)
	lw s3, -8(s0)
	mv a0, s2
	mv a1, s3
	jal ra, elem_ptr
	mv s4, a0
	lw s2, -12(s0)
	lw s3, -20(s0)
	li s5, 12
	add s6, s3, s5
	lw s3, 0(s6)
	mul s5, s2, s3
	mv a0, s1
	mv a1, s4
	mv a2, s5
	jal ra, memcpy
	mv s2, a0
.L28_5:
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
.Lfunc_end28:
	.size kp_buf_read, .Lfunc_end28-kp_buf_read

	.text
	.align 2
	.globl kp_buf_write
	.type kp_buf_write, @function
kp_buf_write:
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
	jal ra, arr_or_buf
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L29_0
	j .L29_1
.L29_0:
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, range_ok
	mv s4, a0
	bnez s4, .L29_2
	j .L29_1
.L29_2:
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, span_in_guest
	mv s4, a0
	bnez s4, .L29_3
	j .L29_1
.L29_1:
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
.L29_3:
	lw s1, -12(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L29_4
	j .L29_5
.L29_4:
	lw s1, -20(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, elem_ptr
	mv s3, a0
	lw s1, -16(s0)
	lw s2, -12(s0)
	lw s4, -20(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	mul s5, s2, s4
	mv a0, s3
	mv a1, s1
	mv a2, s5
	jal ra, memcpy
	mv s2, a0
.L29_5:
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
.Lfunc_end29:
	.size kp_buf_write, .Lfunc_end29-kp_buf_write

	.text
	.align 2
	.globl kp_buf_map
	.type kp_buf_map, @function
kp_buf_map:
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
	jal ra, arr_or_buf
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L30_0
	j .L30_1
.L30_0:
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, range_ok
	mv s4, a0
	bnez s4, .L30_2
	j .L30_1
.L30_2:
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, span_in_guest
	mv s4, a0
	bnez s4, .L30_3
	j .L30_1
.L30_1:
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
.L30_3:
	lw s1, -20(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, elem_ptr
	mv s3, a0
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
.Lfunc_end30:
	.size kp_buf_map, .Lfunc_end30-kp_buf_map

	.data
