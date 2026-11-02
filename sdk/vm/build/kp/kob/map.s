# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type map_ptr, @function
map_ptr:
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
	.size map_ptr, .Lfunc_end1-map_ptr

	.text
	.align 2
	.type iter_ptr, @function
iter_ptr:
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
	.size iter_ptr, .Lfunc_end2-iter_ptr

	.text
	.align 2
	.type key_at, @function
key_at:
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
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
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
.Lfunc_end3:
	.size key_at, .Lfunc_end3-key_at

	.text
	.align 2
	.type set_key_at, @function
set_key_at:
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
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	addi s1, s0, -12
	li s3, 4
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memcpy
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
.Lfunc_end4:
	.size set_key_at, .Lfunc_end4-set_key_at

	.text
	.align 2
	.type val_at, @function
val_at:
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
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -4(s0)
	li s4, 20
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
.Lfunc_end5:
	.size val_at, .Lfunc_end5-val_at

	.text
	.align 2
	.type layout_i32, @function
layout_i32:
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
.Lfunc_end6:
	.size layout_i32, .Lfunc_end6-layout_i32

	.text
	.align 2
	.type hash_key, @function
hash_key:
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
	jal ra, kp_str_bytes
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_str_len
	mv s2, a0
	sw s2, -16(s0)
	li s1, 2166136261
	sw s1, -24(s0)
	li s1, 0
	sw s1, -20(s0)
.L7_0:
	lw s1, -20(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L7_1
	j .L7_2
.L7_1:
	addi s1, s0, -24
	lw s2, 0(s1)
	lw s1, -12(s0)
	lw s3, -20(s0)
	add s4, s1, s3
	lb s1, 0(s4)
	li s3, 255
	and s4, s1, s3
	xor s1, s2, s4
	sw s1, -24(s0)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 16777619
	mul s3, s2, s1
	sw s3, -24(s0)
.L7_3:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L7_0
.L7_2:
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
.Lfunc_end7:
	.size hash_key, .Lfunc_end7-hash_key

	.text
	.align 2
	.type key_eq, @function
key_eq:
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
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L8_0
	j .L8_1
.L8_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_cmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L8_0
	j .L8_2
.L8_0:
	li s1, 1
	j .L8_3
.L8_2:
	li s1, 0
.L8_3:
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
	.size key_eq, .Lfunc_end8-key_eq

	.text
	.align 2
	.type retain_val, @function
retain_val:
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
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L9_0
	j .L9_1
.L9_0:
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
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, layout_i32
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, val_at
	mv s3, a0
	sw s3, -20(s0)
	li s1, 0
	sw s1, -16(s0)
.L9_2:
	lw s1, -16(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L9_3
	j .L9_4
.L9_3:
	addi s1, s0, -24
	lw s2, -20(s0)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	lw s5, -16(s0)
	add s6, s4, s5
	mv a0, s3
	mv a1, s6
	jal ra, layout_i32
	mv s4, a0
	add s3, s2, s4
	li s2, 4
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, kp_retain
	mv s2, a0
.L9_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L9_2
.L9_4:
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
.Lfunc_end9:
	.size retain_val, .Lfunc_end9-retain_val

	.text
	.align 2
	.type release_val, @function
release_val:
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
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_0
	j .L10_1
.L10_0:
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
.L10_1:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, layout_i32
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, val_at
	mv s3, a0
	sw s3, -20(s0)
	li s1, 0
	sw s1, -16(s0)
.L10_2:
	lw s1, -16(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L10_3
	j .L10_4
.L10_3:
	addi s1, s0, -24
	lw s2, -20(s0)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	lw s5, -16(s0)
	add s6, s4, s5
	mv a0, s3
	mv a1, s6
	jal ra, layout_i32
	mv s4, a0
	add s3, s2, s4
	li s2, 4
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
.L10_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L10_2
.L10_4:
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
.Lfunc_end10:
	.size release_val, .Lfunc_end10-release_val

	.text
	.align 2
	.type release_slot_at, @function
release_slot_at:
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
	li s2, 0
	xor s3, s1, s2
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
	lw s1, -8(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, layout_i32
	mv s3, a0
	sw s3, -12(s0)
	li s1, 0
	sw s1, -16(s0)
.L11_2:
	lw s1, -16(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L11_3
	j .L11_4
.L11_3:
	addi s1, s0, -20
	lw s2, -4(s0)
	lw s3, -8(s0)
	li s4, 1
	lw s5, -16(s0)
	add s6, s4, s5
	mv a0, s3
	mv a1, s6
	jal ra, layout_i32
	mv s4, a0
	add s3, s2, s4
	li s2, 4
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s1, -20(s0)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
.L11_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L11_2
.L11_4:
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
	.size release_slot_at, .Lfunc_end11-release_slot_at

	.text
	.align 2
	.globl kp_map_new
	.type kp_map_new, @function
kp_map_new:
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
	li s1, 5
	la s2, map_finalize
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	li s1, 40
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -16(s0)
	li s1, 1
	lw s2, -16(s0)
	sw s1, 0(s2)
	li s1, 5
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -16(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end12:
	.size kp_map_new, .Lfunc_end12-kp_map_new

	.text
	.align 2
	.type map_grow, @function
map_grow:
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
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -8(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -48(s0)
	lw s1, -8(s0)
	li s2, 4
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	lw s3, -8(s0)
	li s4, 4
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memset
	mv s3, a0
	lw s1, -8(s0)
	lw s2, -36(s0)
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -28(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -28(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -40(s0)
.L13_0:
	lw s1, -40(s0)
	lw s2, -32(s0)
	slt s3, s1, s2
	bnez s3, .L13_1
	j .L13_2
.L13_1:
	addi s1, s0, -52
	lw s2, -16(s0)
	lw s3, -40(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s1, -52(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_3
	j .L13_4
.L13_4:
	lw s1, -52(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_3
	j .L13_5
.L13_3:
	j .L13_6
.L13_5:
	lw s1, -52(s0)
	mv a0, s1
	jal ra, hash_key
	mv s2, a0
	lw s1, -48(s0)
	and s3, s2, s1
	sw s3, -44(s0)
.L13_7:
	lw s1, -12(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_at
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L13_8
	j .L13_9
.L13_8:
	lw s1, -44(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -48(s0)
	and s2, s3, s1
	sw s2, -44(s0)
	j .L13_7
.L13_9:
	lw s1, -12(s0)
	lw s2, -44(s0)
	lw s3, -52(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_key_at
	mv s4, a0
	lw s1, -12(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, val_at
	mv s3, a0
	lw s1, -20(s0)
	lw s2, -40(s0)
	lw s4, -36(s0)
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, -36(s0)
	mv a0, s3
	mv a1, s2
	mv a2, s1
	jal ra, memcpy
	mv s4, a0
.L13_6:
	addi s1, s0, -40
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -40(s0)
	j .L13_0
.L13_2:
	lw s1, -16(s0)
	bnez s1, .L13_10
	j .L13_11
.L13_10:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L13_11:
	lw s1, -20(s0)
	bnez s1, .L13_12
	j .L13_13
.L13_12:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L13_13:
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
.Lfunc_end13:
	.size map_grow, .Lfunc_end13-map_grow

	.text
	.align 2
	.type map_find, @function
map_find:
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
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_0
	j .L14_1
.L14_0:
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
.L14_1:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	sub s3, s1, s2
	sw s3, -12(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, hash_key
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	and s3, s1, s2
	sw s3, -16(s0)
.L14_2:
	j .L14_3
.L14_3:
	lw s1, -4(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_at
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_4
	j .L14_5
.L14_4:
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
.L14_5:
	lw s1, -20(s0)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L14_6
	j .L14_7
.L14_6:
	lw s1, -20(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_eq
	mv s3, a0
	bnez s3, .L14_8
	j .L14_7
.L14_8:
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
.L14_7:
	lw s1, -16(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	and s2, s3, s1
	sw s2, -16(s0)
.L14_9:
	j .L14_2
.L14_10:
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
	.size map_find, .Lfunc_end14-map_find

	.text
	.align 2
	.globl kp_map_reserve
	.type kp_map_reserve, @function
kp_map_reserve:
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
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_0
	j .L15_1
.L15_0:
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_map_new
	mv s3, a0
	sw s3, -4(s0)
	j .L15_2
.L15_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L15_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_3
	j .L15_4
.L15_3:
	lw s1, -4(s0)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, map_grow
	mv s3, a0
	j .L15_5
.L15_4:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	li s1, 1
	add s2, s3, s1
	li s1, 4
	mul s3, s2, s1
	lw s1, -20(s0)
	li s2, 16
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 3
	mul s4, s1, s2
	slt s1, s3, s4
	xori s1, s1, 1
	bnez s1, .L15_6
	j .L15_7
.L15_6:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 2
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, map_grow
	mv s2, a0
.L15_7:
.L15_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	sub s3, s1, s2
	sw s3, -24(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, hash_key
	mv s2, a0
	lw s1, -24(s0)
	and s3, s2, s1
	sw s3, -28(s0)
	li s1, 1
	neg s2, s1
	sw s2, -36(s0)
.L15_8:
	j .L15_9
.L15_9:
	lw s1, -20(s0)
	lw s2, -28(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_at
	mv s3, a0
	sw s3, -40(s0)
	lw s1, -40(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_10
	j .L15_11
.L15_10:
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L15_12
	j .L15_13
.L15_12:
	lw s1, -36(s0)
	sw s1, -44(s0)
	j .L15_14
.L15_13:
	lw s1, -28(s0)
	sw s1, -44(s0)
.L15_14:
	lw s1, -44(s0)
	sw s1, -32(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, kp_retain
	mv s2, a0
	lw s1, -20(s0)
	lw s2, -32(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_key_at
	mv s4, a0
	lw s1, -20(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, val_at
	mv s3, a0
	li s1, 0
	lw s2, -20(s0)
	li s4, 20
	add s5, s2, s4
	lw s2, 0(s5)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memset
	mv s4, a0
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -32(s0)
	lw s2, -36(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_15
	j .L15_16
.L15_15:
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, -1
	add s4, s1, s2
	sw s4, 0(s3)
.L15_16:
	lw s1, -20(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.L15_11:
	lw s1, -40(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L15_17
	j .L15_18
.L15_17:
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_19
	j .L15_20
.L15_19:
	lw s1, -28(s0)
	sw s1, -36(s0)
.L15_20:
	j .L15_21
.L15_18:
	lw s1, -40(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_eq
	mv s3, a0
	bnez s3, .L15_22
	j .L15_23
.L15_22:
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
.L15_23:
.L15_21:
	lw s1, -28(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -24(s0)
	and s2, s3, s1
	sw s2, -28(s0)
.L15_24:
	j .L15_8
.L15_25:
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
.Lfunc_end15:
	.size kp_map_reserve, .Lfunc_end15-kp_map_reserve

	.text
	.align 2
	.globl kp_map_get
	.type kp_map_get, @function
kp_map_get:
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
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	bnez s1, .L16_0
	j .L16_1
.L16_0:
	lw s1, -12(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, map_find
	mv s3, a0
	sw s3, -20(s0)
	j .L16_2
.L16_1:
	li s1, 1
	neg s2, s1
	sw s2, -20(s0)
.L16_2:
	lw s1, -20(s0)
	sw s1, -16(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L16_3
	j .L16_4
.L16_3:
	li s1, 4
	mv a0, s1
	jal ra, rt_trap
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
.L16_4:
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	lw s3, -12(s0)
	li s4, 20
	add s5, s3, s4
	lw s3, 0(s5)
	mul s4, s2, s3
	add s2, s1, s4
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
.Lfunc_end16:
	.size kp_map_get, .Lfunc_end16-kp_map_get

	.text
	.align 2
	.globl kp_map_tryget
	.type kp_map_tryget, @function
kp_map_tryget:
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
	jal ra, map_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -4(s0)
	bnez s1, .L17_0
	j .L17_1
.L17_0:
	lw s1, -20(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, map_find
	mv s3, a0
	sw s3, -28(s0)
	j .L17_2
.L17_1:
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
.L17_2:
	lw s1, -28(s0)
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L17_3
	j .L17_4
.L17_3:
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
.L17_4:
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, retain_val
	mv s3, a0
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, release_slot_at
	mv s3, a0
	lw s1, -12(s0)
	lw s2, -20(s0)
	lw s3, -24(s0)
	mv a0, s2
	mv a1, s3
	jal ra, val_at
	mv s4, a0
	lw s2, -20(s0)
	li s3, 20
	add s5, s2, s3
	lw s2, 0(s5)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, memcpy
	mv s3, a0
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
.Lfunc_end17:
	.size kp_map_tryget, .Lfunc_end17-kp_map_tryget

	.text
	.align 2
	.globl kp_map_has
	.type kp_map_has, @function
kp_map_has:
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
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	bnez s1, .L18_0
	j .L18_1
.L18_0:
	lw s1, -12(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, map_find
	mv s3, a0
	li s1, 0
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L18_2
	j .L18_1
.L18_2:
	li s1, 1
	sw s1, -16(s0)
	j .L18_3
.L18_1:
	li s1, 0
	sw s1, -16(s0)
.L18_3:
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
.Lfunc_end18:
	.size kp_map_has, .Lfunc_end18-kp_map_has

	.text
	.align 2
	.type map_del_inplace, @function
map_del_inplace:
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
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, map_find
	mv s3, a0
	sw s3, -16(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L19_0
	j .L19_1
.L19_0:
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
.L19_1:
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, release_val
	mv s3, a0
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_at
	mv s3, a0
	mv a0, s3
	jal ra, kp_release
	mv s1, a0
	lw s1, -12(s0)
	lw s2, -16(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_key_at
	mv s4, a0
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, -1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end19:
	.size map_del_inplace, .Lfunc_end19-map_del_inplace

	.text
	.align 2
	.globl kp_map_del
	.type kp_map_del, @function
kp_map_del:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L20_0
	j .L20_1
.L20_0:
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
.L20_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, map_del_inplace
	mv s3, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
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
.Lfunc_end20:
	.size kp_map_del, .Lfunc_end20-kp_map_del

	.text
	.align 2
	.globl kp_map_len
	.type kp_map_len, @function
kp_map_len:
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
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L21_0
	j .L21_1
.L21_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L21_2
.L21_1:
	li s1, 0
	sw s1, -16(s0)
.L21_2:
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
.Lfunc_end21:
	.size kp_map_len, .Lfunc_end21-kp_map_len

	.text
	.align 2
	.globl kp_map_clone
	.type kp_map_clone, @function
kp_map_clone:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_0
	j .L22_1
.L22_0:
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
.L22_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 7
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_2
	j .L22_3
.L22_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_imap_clone
	mv s2, a0
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
.L22_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, kp_map_new
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L22_4
	j .L22_5
.L22_4:
	lw s1, -32(s0)
	li s2, 4
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -24(s0)
	lw s1, -32(s0)
	lw s2, -36(s0)
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -28(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -32(s0)
	li s4, 4
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
	lw s1, -28(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -32(s0)
	lw s4, -36(s0)
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
	lw s1, -24(s0)
	lw s2, -16(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -28(s0)
	lw s2, -16(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -40(s0)
.L22_6:
	lw s1, -40(s0)
	lw s2, -32(s0)
	slt s3, s1, s2
	bnez s3, .L22_7
	j .L22_8
.L22_7:
	lw s1, -16(s0)
	lw s2, -40(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_at
	mv s3, a0
	sw s3, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L22_9
	j .L22_10
.L22_9:
	lw s1, -44(s0)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L22_11
	j .L22_10
.L22_11:
	lw s1, -44(s0)
	mv a0, s1
	jal ra, kp_retain
	mv s2, a0
	lw s1, -16(s0)
	lw s2, -40(s0)
	mv a0, s1
	mv a1, s2
	jal ra, retain_val
	mv s3, a0
.L22_10:
.L22_12:
	addi s1, s0, -40
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -40(s0)
	j .L22_6
.L22_8:
.L22_5:
	lw s1, -20(s0)
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
.Lfunc_end22:
	.size kp_map_clone, .Lfunc_end22-kp_map_clone

	.text
	.align 2
	.type map_finalize, @function
map_finalize:
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
	jal ra, map_ptr
	mv s2, a0
	sw s2, -12(s0)
	li s1, 0
	sw s1, -16(s0)
.L23_0:
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L23_1
	j .L23_2
.L23_1:
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_at
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L23_3
	j .L23_4
.L23_3:
	lw s1, -20(s0)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L23_5
	j .L23_4
.L23_5:
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, release_val
	mv s3, a0
	lw s1, -20(s0)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
.L23_4:
.L23_6:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L23_0
.L23_2:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L23_7
	j .L23_8
.L23_7:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L23_8:
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L23_9
	j .L23_10
.L23_9:
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L23_10:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, gheap_free
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
.Lfunc_end23:
	.size map_finalize, .Lfunc_end23-map_finalize

	.text
	.align 2
	.globl kp_mapiter_new
	.type kp_mapiter_new, @function
kp_mapiter_new:
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
	li s1, 6
	la s2, mapiter_finalize
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	li s1, 20
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, iter_ptr
	mv s2, a0
	sw s2, -16(s0)
	li s1, 1
	lw s2, -16(s0)
	sw s1, 0(s2)
	li s1, 6
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	bnez s1, .L24_0
	j .L24_1
.L24_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_retain
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	li s1, 36
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	j .L24_2
.L24_1:
	li s1, 0
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L24_2:
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
	.size kp_mapiter_new, .Lfunc_end24-kp_mapiter_new

	.text
	.align 2
	.globl kp_mapiter_next
	.type kp_mapiter_next, @function
kp_mapiter_next:
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
	jal ra, iter_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_0
	j .L25_1
.L25_0:
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
.L25_1:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, map_ptr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L25_2
	j .L25_3
.L25_2:
	li s1, 4
	mv a0, s1
	jal ra, rt_trap
	mv s2, a0
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
.L25_3:
.L25_4:
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L25_5
	j .L25_6
.L25_5:
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	sw s1, -32(s0)
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, key_at
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -36(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_7
	j .L25_8
.L25_8:
	lw s1, -36(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_7
	j .L25_9
.L25_7:
	j .L25_4
.L25_9:
	addi s1, s0, -40
	lw s2, -8(s0)
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -36(s0)
	mv a0, s1
	jal ra, kp_retain
	mv s2, a0
	lw s1, -8(s0)
	addi s2, s0, -36
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -40(s0)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, retain_val
	mv s3, a0
	lw s1, -12(s0)
	lw s2, -28(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, release_slot_at
	mv s3, a0
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, -32(s0)
	mv a0, s2
	mv a1, s3
	jal ra, val_at
	mv s4, a0
	lw s2, -28(s0)
	li s3, 20
	add s5, s2, s3
	lw s2, 0(s5)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, memcpy
	mv s3, a0
	li s1, 1
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
	j .L25_4
.L25_6:
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
.Lfunc_end25:
	.size kp_mapiter_next, .Lfunc_end25-kp_mapiter_next

	.text
	.align 2
	.type mapiter_finalize, @function
mapiter_finalize:
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
	jal ra, iter_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L26_0
	j .L26_1
.L26_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
.L26_1:
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
.Lfunc_end26:
	.size mapiter_finalize, .Lfunc_end26-mapiter_finalize

	.text
	.align 2
	.type imap_ptr, @function
imap_ptr:
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
	bnez s1, .L27_0
	j .L27_1
.L27_0:
	lw s1, -4(s0)
	sw s1, -12(s0)
	j .L27_2
.L27_1:
	li s1, 0
	sw s1, -12(s0)
.L27_2:
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
.Lfunc_end27:
	.size imap_ptr, .Lfunc_end27-imap_ptr

	.text
	.align 2
	.type iiter_ptr, @function
iiter_ptr:
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
	.size iiter_ptr, .Lfunc_end28-iiter_ptr

	.text
	.align 2
	.type ikey_at, @function
ikey_at:
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
	addi s1, s0, -16
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -8(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
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
.Lfunc_end29:
	.size ikey_at, .Lfunc_end29-ikey_at

	.text
	.align 2
	.type set_ikey_at, @function
set_ikey_at:
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
	sw a2, -16(s0)
	sw a3, -12(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	addi s1, s0, -16
	li s3, 8
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memcpy
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
.Lfunc_end30:
	.size set_ikey_at, .Lfunc_end30-set_ikey_at

	.text
	.align 2
	.type istate_at, @function
istate_at:
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
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
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
.Lfunc_end31:
	.size istate_at, .Lfunc_end31-istate_at

	.text
	.align 2
	.type set_istate_at, @function
set_istate_at:
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
	lw s1, -12(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -4(s0)
	li s2, 36
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -8(s0)
	add s4, s1, s2
	sb s3, 0(s4)
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
.Lfunc_end32:
	.size set_istate_at, .Lfunc_end32-set_istate_at

	.text
	.align 2
	.type ival_at, @function
ival_at:
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
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -4(s0)
	li s4, 20
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
.Lfunc_end33:
	.size ival_at, .Lfunc_end33-ival_at

	.text
	.align 2
	.type ihash_key, @function
ihash_key:
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
	sw a0, -8(s0)
	sw a1, -4(s0)
	lw s10, -8(s0)
	lw s11, -4(s0)
	sw s10, -16(s0)
	sw s11, -12(s0)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s8, -16(s0)
	lw s9, -12(s0)
	li s1, 33
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	xor s8, s10, s6
	xor s9, s11, s7
	sw s8, -16(s0)
	sw s9, -12(s0)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s8, -313160499
	li s9, -11423785
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
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s8, -16(s0)
	lw s9, -12(s0)
	li s1, 33
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	xor s8, s10, s6
	xor s9, s11, s7
	sw s8, -16(s0)
	sw s9, -12(s0)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s8, 444984403
	li s9, -993084930
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
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s8, -16(s0)
	lw s9, -12(s0)
	li s1, 33
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	xor s8, s10, s6
	xor s9, s11, s7
	sw s8, -16(s0)
	sw s9, -12(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv s1, s10
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
.Lfunc_end34:
	.size ihash_key, .Lfunc_end34-ihash_key

	.text
	.align 2
	.type iretain_val, @function
iretain_val:
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
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L35_0
	j .L35_1
.L35_0:
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
.L35_1:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, layout_i32
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ival_at
	mv s3, a0
	sw s3, -20(s0)
	li s1, 0
	sw s1, -16(s0)
.L35_2:
	lw s1, -16(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L35_3
	j .L35_4
.L35_3:
	addi s1, s0, -24
	lw s2, -20(s0)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	lw s5, -16(s0)
	add s6, s4, s5
	mv a0, s3
	mv a1, s6
	jal ra, layout_i32
	mv s4, a0
	add s3, s2, s4
	li s2, 4
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, kp_retain
	mv s2, a0
.L35_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L35_2
.L35_4:
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
.Lfunc_end35:
	.size iretain_val, .Lfunc_end35-iretain_val

	.text
	.align 2
	.type irelease_val, @function
irelease_val:
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
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L36_0
	j .L36_1
.L36_0:
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
.L36_1:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, layout_i32
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ival_at
	mv s3, a0
	sw s3, -20(s0)
	li s1, 0
	sw s1, -16(s0)
.L36_2:
	lw s1, -16(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L36_3
	j .L36_4
.L36_3:
	addi s1, s0, -24
	lw s2, -20(s0)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	lw s5, -16(s0)
	add s6, s4, s5
	mv a0, s3
	mv a1, s6
	jal ra, layout_i32
	mv s4, a0
	add s3, s2, s4
	li s2, 4
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
.L36_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L36_2
.L36_4:
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
.Lfunc_end36:
	.size irelease_val, .Lfunc_end36-irelease_val

	.text
	.align 2
	.globl kp_imap_new
	.type kp_imap_new, @function
kp_imap_new:
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
	li s1, 7
	la s2, imap_finalize
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	li s1, 44
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -16(s0)
	li s1, 1
	lw s2, -16(s0)
	sw s1, 0(s2)
	li s1, 7
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -16(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end37:
	.size kp_imap_new, .Lfunc_end37-kp_imap_new

	.text
	.align 2
	.type imap_grow, @function
imap_grow:
	addi sp, sp, -144
	sw ra, 140(sp)
	sw s0, 136(sp)
	addi s0, sp, 136
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
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
	lw s1, -8(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -56(s0)
	lw s1, -8(s0)
	li s2, 8
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -28(s0)
	lw s1, -8(s0)
	lw s2, -44(s0)
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -32(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -36(s0)
	li s2, 0
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -28(s0)
	lw s2, -12(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -36(s0)
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	bnez s1, .L38_0
	j .L38_1
.L38_0:
	lw s1, -24(s0)
	sw s1, -76(s0)
	j .L38_2
.L38_1:
	li s1, 0
	sw s1, -76(s0)
.L38_2:
	lw s1, -76(s0)
	sw s1, -60(s0)
	li s1, 0
	sw s1, -48(s0)
.L38_3:
	lw s1, -48(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L38_4
	j .L38_5
.L38_4:
	lw s1, -60(s0)
	bnez s1, .L38_6
	j .L38_7
.L38_6:
	lw s1, -60(s0)
	lw s2, -48(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L38_7
	j .L38_8
.L38_7:
	j .L38_9
.L38_8:
	addi s1, s0, -72
	lw s2, -16(s0)
	lw s3, -48(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s10, -72(s0)
	lw s11, -68(s0)
	mv a0, s10
	mv a1, s11
	jal ra, ihash_key
	mv s1, a0
	lw s2, -56(s0)
	and s3, s1, s2
	sw s3, -52(s0)
.L38_10:
	lw s1, -12(s0)
	lw s2, -52(s0)
	mv a0, s1
	mv a1, s2
	jal ra, istate_at
	mv s3, a0
	li s1, 2
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L38_11
	j .L38_12
.L38_11:
	lw s1, -52(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -56(s0)
	and s2, s3, s1
	sw s2, -52(s0)
	j .L38_10
.L38_12:
	lw s1, -12(s0)
	lw s2, -52(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s10
	mv a3, s11
	jal ra, set_ikey_at
	mv s3, a0
	lw s1, -12(s0)
	lw s2, -52(s0)
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_istate_at
	mv s4, a0
	lw s1, -12(s0)
	lw s2, -52(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ival_at
	mv s3, a0
	lw s1, -20(s0)
	lw s2, -48(s0)
	lw s4, -44(s0)
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, -44(s0)
	mv a0, s3
	mv a1, s2
	mv a2, s1
	jal ra, memcpy
	mv s4, a0
.L38_9:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L38_3
.L38_5:
	lw s1, -16(s0)
	bnez s1, .L38_13
	j .L38_14
.L38_13:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L38_14:
	lw s1, -20(s0)
	bnez s1, .L38_15
	j .L38_16
.L38_15:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L38_16:
	lw s1, -24(s0)
	bnez s1, .L38_17
	j .L38_18
.L38_17:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L38_18:
	li s1, 0
	mv a0, s1
	lw s1, -124(s0)
	lw s2, -120(s0)
	lw s3, -116(s0)
	lw s4, -112(s0)
	lw s5, -108(s0)
	lw s6, -104(s0)
	lw s7, -100(s0)
	lw s8, -96(s0)
	lw s9, -92(s0)
	lw s10, -88(s0)
	lw s11, -84(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end38:
	.size imap_grow, .Lfunc_end38-imap_grow

	.text
	.align 2
	.type imap_find, @function
imap_find:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L39_0
	j .L39_1
.L39_0:
	li s1, 1
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
.L39_1:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	sub s3, s1, s2
	sw s3, -20(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
	jal ra, ihash_key
	mv s1, a0
	lw s2, -20(s0)
	and s3, s1, s2
	sw s3, -24(s0)
.L39_2:
	j .L39_3
.L39_3:
	lw s1, -4(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, istate_at
	mv s3, a0
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L39_4
	j .L39_5
.L39_4:
	li s1, 1
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
.L39_5:
	lw s1, -28(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L39_6
	j .L39_7
.L39_6:
	lw s1, -4(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ikey_at
	mv s10, a0
	mv s11, a1
	lw s8, -16(s0)
	lw s9, -12(s0)
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L39_8
	j .L39_7
.L39_8:
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
.L39_7:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -20(s0)
	and s2, s3, s1
	sw s2, -24(s0)
.L39_9:
	j .L39_2
.L39_10:
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
.Lfunc_end39:
	.size imap_find, .Lfunc_end39-imap_find

	.text
	.align 2
	.globl kp_imap_reserve
	.type kp_imap_reserve, @function
kp_imap_reserve:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	sw a3, -20(s0)
	sw a4, -24(s0)
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_0
	j .L40_1
.L40_0:
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_imap_new
	mv s3, a0
	sw s3, -4(s0)
	j .L40_2
.L40_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L40_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_3
	j .L40_4
.L40_3:
	lw s1, -4(s0)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, imap_grow
	mv s3, a0
	j .L40_5
.L40_4:
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	li s1, 1
	add s2, s3, s1
	li s1, 4
	mul s3, s2, s1
	lw s1, -28(s0)
	li s2, 16
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 3
	mul s4, s1, s2
	slt s1, s3, s4
	xori s1, s1, 1
	bnez s1, .L40_6
	j .L40_7
.L40_6:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 2
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, imap_grow
	mv s2, a0
.L40_7:
.L40_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	sub s3, s1, s2
	sw s3, -32(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s10
	mv a1, s11
	jal ra, ihash_key
	mv s1, a0
	lw s2, -32(s0)
	and s3, s1, s2
	sw s3, -36(s0)
	li s1, 1
	neg s2, s1
	sw s2, -44(s0)
.L40_8:
	j .L40_9
.L40_9:
	lw s1, -28(s0)
	lw s2, -36(s0)
	mv a0, s1
	mv a1, s2
	jal ra, istate_at
	mv s3, a0
	sw s3, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_10
	j .L40_11
.L40_10:
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L40_12
	j .L40_13
.L40_12:
	lw s1, -44(s0)
	sw s1, -52(s0)
	j .L40_14
.L40_13:
	lw s1, -36(s0)
	sw s1, -52(s0)
.L40_14:
	lw s1, -52(s0)
	sw s1, -40(s0)
	lw s1, -28(s0)
	lw s2, -40(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s10
	mv a3, s11
	jal ra, set_ikey_at
	mv s3, a0
	lw s1, -28(s0)
	lw s2, -40(s0)
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_istate_at
	mv s4, a0
	lw s1, -28(s0)
	lw s2, -40(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ival_at
	mv s3, a0
	li s1, 0
	lw s2, -28(s0)
	li s4, 20
	add s5, s2, s4
	lw s2, 0(s5)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memset
	mv s4, a0
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -40(s0)
	lw s2, -44(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_15
	j .L40_16
.L40_15:
	lw s1, -28(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, -1
	add s4, s1, s2
	sw s4, 0(s3)
.L40_16:
	lw s1, -28(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
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
.L40_11:
	lw s1, -48(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_17
	j .L40_18
.L40_17:
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L40_19
	j .L40_20
.L40_19:
	lw s1, -36(s0)
	sw s1, -44(s0)
.L40_20:
	j .L40_21
.L40_18:
	lw s1, -28(s0)
	lw s2, -36(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ikey_at
	mv s10, a0
	mv s11, a1
	lw s8, -16(s0)
	lw s9, -12(s0)
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L40_22
	j .L40_23
.L40_22:
	lw s1, -4(s0)
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
.L40_23:
.L40_21:
	lw s1, -36(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -32(s0)
	and s2, s3, s1
	sw s2, -36(s0)
.L40_24:
	j .L40_8
.L40_25:
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
.Lfunc_end40:
	.size kp_imap_reserve, .Lfunc_end40-kp_imap_reserve

	.text
	.align 2
	.globl kp_imap_get
	.type kp_imap_get, @function
kp_imap_get:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -4(s0)
	bnez s1, .L41_0
	j .L41_1
.L41_0:
	lw s1, -20(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, imap_find
	mv s2, a0
	sw s2, -28(s0)
	j .L41_2
.L41_1:
	li s1, 1
	neg s2, s1
	sw s2, -28(s0)
.L41_2:
	lw s1, -28(s0)
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L41_3
	j .L41_4
.L41_3:
	li s1, 4
	mv a0, s1
	jal ra, rt_trap
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
.L41_4:
	lw s1, -20(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	lw s3, -20(s0)
	li s4, 20
	add s5, s3, s4
	lw s3, 0(s5)
	mul s4, s2, s3
	add s2, s1, s4
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
.Lfunc_end41:
	.size kp_imap_get, .Lfunc_end41-kp_imap_get

	.text
	.align 2
	.globl kp_imap_tryget
	.type kp_imap_tryget, @function
kp_imap_tryget:
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
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -4(s0)
	bnez s1, .L42_0
	j .L42_1
.L42_0:
	lw s1, -28(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, imap_find
	mv s2, a0
	sw s2, -36(s0)
	j .L42_2
.L42_1:
	li s1, 1
	neg s2, s1
	sw s2, -36(s0)
.L42_2:
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L42_3
	j .L42_4
.L42_3:
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
.L42_4:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, iretain_val
	mv s3, a0
	lw s1, -20(s0)
	lw s2, -28(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, release_slot_at
	mv s3, a0
	lw s1, -20(s0)
	lw s2, -28(s0)
	lw s3, -32(s0)
	mv a0, s2
	mv a1, s3
	jal ra, ival_at
	mv s4, a0
	lw s2, -28(s0)
	li s3, 20
	add s5, s2, s3
	lw s2, 0(s5)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, memcpy
	mv s3, a0
	li s1, 1
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
.Lfunc_end42:
	.size kp_imap_tryget, .Lfunc_end42-kp_imap_tryget

	.text
	.align 2
	.globl kp_imap_has
	.type kp_imap_has, @function
kp_imap_has:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -4(s0)
	bnez s1, .L43_0
	j .L43_1
.L43_0:
	lw s1, -20(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, imap_find
	mv s2, a0
	li s1, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L43_2
	j .L43_1
.L43_2:
	li s1, 1
	sw s1, -24(s0)
	j .L43_3
.L43_1:
	li s1, 0
	sw s1, -24(s0)
.L43_3:
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
.Lfunc_end43:
	.size kp_imap_has, .Lfunc_end43-kp_imap_has

	.text
	.align 2
	.type imap_del_inplace, @function
imap_del_inplace:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, imap_find
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L44_0
	j .L44_1
.L44_0:
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
.L44_1:
	lw s1, -20(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, irelease_val
	mv s3, a0
	lw s1, -20(s0)
	lw s2, -24(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, set_istate_at
	mv s4, a0
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, -1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -20(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end44:
	.size imap_del_inplace, .Lfunc_end44-imap_del_inplace

	.text
	.align 2
	.globl kp_imap_del
	.type kp_imap_del, @function
kp_imap_del:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L45_0
	j .L45_1
.L45_0:
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
.L45_1:
	lw s1, -4(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, imap_del_inplace
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
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
.Lfunc_end45:
	.size kp_imap_del, .Lfunc_end45-kp_imap_del

	.text
	.align 2
	.globl kp_imap_len
	.type kp_imap_len, @function
kp_imap_len:
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
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L46_0
	j .L46_1
.L46_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L46_2
.L46_1:
	li s1, 0
	sw s1, -16(s0)
.L46_2:
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
.Lfunc_end46:
	.size kp_imap_len, .Lfunc_end46-kp_imap_len

	.text
	.align 2
	.globl kp_imap_clone
	.type kp_imap_clone, @function
kp_imap_clone:
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
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L47_0
	j .L47_1
.L47_0:
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
.L47_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, kp_imap_new
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -40(s0)
	lw s1, -36(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L47_2
	j .L47_3
.L47_2:
	lw s1, -36(s0)
	li s2, 8
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -24(s0)
	lw s1, -36(s0)
	lw s2, -40(s0)
	mul s3, s1, s2
	mv a0, s3
	jal ra, gheap_alloc
	mv s1, a0
	sw s1, -28(s0)
	lw s1, -36(s0)
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -36(s0)
	li s4, 8
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
	lw s1, -28(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -36(s0)
	lw s4, -40(s0)
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memcpy
	mv s3, a0
	lw s1, -32(s0)
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -24(s0)
	lw s2, -16(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -28(s0)
	lw s2, -16(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -16(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -36(s0)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -44(s0)
.L47_4:
	lw s1, -44(s0)
	lw s2, -36(s0)
	slt s3, s1, s2
	bnez s3, .L47_5
	j .L47_6
.L47_5:
	lw s1, -16(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, istate_at
	mv s3, a0
	li s1, 2
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L47_7
	j .L47_8
.L47_7:
	lw s1, -16(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, iretain_val
	mv s3, a0
.L47_8:
.L47_9:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L47_4
.L47_6:
.L47_3:
	lw s1, -20(s0)
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
.Lfunc_end47:
	.size kp_imap_clone, .Lfunc_end47-kp_imap_clone

	.text
	.align 2
	.type imap_finalize, @function
imap_finalize:
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
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -12(s0)
	li s1, 0
	sw s1, -16(s0)
.L48_0:
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L48_1
	j .L48_2
.L48_1:
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, istate_at
	mv s3, a0
	li s1, 2
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L48_3
	j .L48_4
.L48_3:
	lw s1, -12(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, irelease_val
	mv s3, a0
.L48_4:
.L48_5:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L48_0
.L48_2:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L48_6
	j .L48_7
.L48_6:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L48_7:
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L48_8
	j .L48_9
.L48_8:
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L48_9:
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L48_10
	j .L48_11
.L48_10:
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, gheap_free
	mv s2, a0
.L48_11:
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
.Lfunc_end48:
	.size imap_finalize, .Lfunc_end48-imap_finalize

	.text
	.align 2
	.globl kp_imapiter_new
	.type kp_imapiter_new, @function
kp_imapiter_new:
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
	li s1, 8
	la s2, imapiter_finalize
	mv a0, s1
	mv a1, s2
	jal ra, rt_register_final
	mv s3, a0
	li s1, 20
	mv a0, s1
	jal ra, gheap_alloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, iiter_ptr
	mv s2, a0
	sw s2, -16(s0)
	li s1, 1
	lw s2, -16(s0)
	sw s1, 0(s2)
	li s1, 8
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	bnez s1, .L49_0
	j .L49_1
.L49_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, kp_retain
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	li s1, 40
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	j .L49_2
.L49_1:
	li s1, 0
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L49_2:
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
.Lfunc_end49:
	.size kp_imapiter_new, .Lfunc_end49-kp_imapiter_new

	.text
	.align 2
	.globl kp_imapiter_next
	.type kp_imapiter_next, @function
kp_imapiter_next:
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
	jal ra, iiter_ptr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L50_0
	j .L50_1
.L50_0:
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
.L50_1:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, imap_ptr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L50_2
	j .L50_3
.L50_2:
	li s1, 4
	mv a0, s1
	jal ra, rt_trap
	mv s2, a0
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
.L50_3:
.L50_4:
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L50_5
	j .L50_6
.L50_5:
	lw s1, -20(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	sw s1, -32(s0)
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, istate_at
	mv s3, a0
	li s1, 2
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L50_7
	j .L50_8
.L50_7:
	j .L50_4
.L50_8:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ikey_at
	mv s10, a0
	mv s11, a1
	sw s10, -40(s0)
	sw s11, -36(s0)
	lw s1, -8(s0)
	addi s2, s0, -40
	li s3, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, iretain_val
	mv s3, a0
	lw s1, -12(s0)
	lw s2, -28(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, release_slot_at
	mv s3, a0
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, -32(s0)
	mv a0, s2
	mv a1, s3
	jal ra, ival_at
	mv s4, a0
	lw s2, -28(s0)
	li s3, 20
	add s5, s2, s3
	lw s2, 0(s5)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, memcpy
	mv s3, a0
	li s1, 1
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
	j .L50_4
.L50_6:
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
.Lfunc_end50:
	.size kp_imapiter_next, .Lfunc_end50-kp_imapiter_next

	.text
	.align 2
	.type imapiter_finalize, @function
imapiter_finalize:
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
	jal ra, iiter_ptr
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L51_0
	j .L51_1
.L51_0:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, kp_release
	mv s2, a0
.L51_1:
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
.Lfunc_end51:
	.size imapiter_finalize, .Lfunc_end51-imapiter_finalize

	.data
