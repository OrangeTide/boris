# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type emit, @function
emit:
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
	la s1, cur_fn
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, ir_emit
	mv s3, a0
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
	.size emit, .Lfunc_end1-emit

	.text
	.align 2
	.type new_temp, @function
new_temp:
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
	la s1, cur_fn
	lw s2, 0(s1)
	mv a0, s2
	jal ra, ir_new_temp
	mv s1, a0
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
.Lfunc_end2:
	.size new_temp, .Lfunc_end2-new_temp

	.text
	.align 2
	.type new_label, @function
new_label:
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
	la s1, cur_fn
	lw s2, 0(s1)
	mv a0, s2
	jal ra, ir_new_label
	mv s1, a0
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
.Lfunc_end3:
	.size new_label, .Lfunc_end3-new_label

	.text
	.align 2
	.type lower_const, @function
lower_const:
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
	li s1, 1
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
	.size lower_const, .Lfunc_end4-lower_const

	.text
	.align 2
	.type lower_const64, @function
lower_const64:
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
	li s1, 85
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s10, -8(s0)
	lw s11, -4(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
	.size lower_const64, .Lfunc_end5-lower_const64

	.text
	.align 2
	.type emit_label, @function
emit_label:
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
	li s1, 54
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 36
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
.Lfunc_end6:
	.size emit_label, .Lfunc_end6-emit_label

	.text
	.align 2
	.type emit_jmp, @function
emit_jmp:
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
	li s1, 41
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 36
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
.Lfunc_end7:
	.size emit_jmp, .Lfunc_end7-emit_jmp

	.text
	.align 2
	.type emit_bnz, @function
emit_bnz:
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
	li s1, 43
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 36
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
.Lfunc_end8:
	.size emit_bnz, .Lfunc_end8-emit_bnz

	.text
	.align 2
	.type alloc_slot, @function
alloc_slot:
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
	la s1, nslots
	lw s2, 0(s1)
	la s1, slot_cap
	lw s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L9_0
	j .L9_1
.L9_0:
	la s1, slot_cap
	lw s2, 0(s1)
	bnez s2, .L9_2
	j .L9_3
.L9_2:
	la s1, slot_cap
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -12(s0)
	j .L9_4
.L9_3:
	li s1, 32
	sw s1, -12(s0)
.L9_4:
	lw s1, -12(s0)
	la s2, slot_cap
	sw s1, 0(s2)
	la s1, slot_sizes
	lw s2, 0(s1)
	la s1, slot_cap
	lw s3, 0(s1)
	li s1, 4
	mul s4, s3, s1
	mv a0, s2
	mv a1, s4
	jal ra, realloc
	mv s1, a0
	la s2, slot_sizes
	sw s1, 0(s2)
	la s1, slot_aligns
	lw s2, 0(s1)
	la s1, slot_cap
	lw s3, 0(s1)
	li s1, 4
	mul s4, s3, s1
	mv a0, s2
	mv a1, s4
	jal ra, realloc
	mv s1, a0
	la s2, slot_aligns
	sw s1, 0(s2)
.L9_1:
	lw s1, -4(s0)
	la s2, slot_sizes
	lw s3, 0(s2)
	la s2, nslots
	lw s4, 0(s2)
	li s2, 4
	mul s5, s4, s2
	add s2, s3, s5
	sw s1, 0(s2)
	lw s1, -8(s0)
	la s2, slot_aligns
	lw s3, 0(s2)
	la s2, nslots
	lw s4, 0(s2)
	li s2, 4
	mul s5, s4, s2
	add s2, s3, s5
	sw s1, 0(s2)
	la s1, nslots
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
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
	.size alloc_slot, .Lfunc_end9-alloc_slot

	.text
	.align 2
	.type add_local, @function
add_local:
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
	la s1, nlocals
	lw s2, 0(s1)
	la s1, local_cap
	lw s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L10_0
	j .L10_1
.L10_0:
	la s1, local_cap
	lw s2, 0(s1)
	bnez s2, .L10_2
	j .L10_3
.L10_2:
	la s1, local_cap
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -20(s0)
	j .L10_4
.L10_3:
	li s1, 32
	sw s1, -20(s0)
.L10_4:
	lw s1, -20(s0)
	la s2, local_cap
	sw s1, 0(s2)
	la s1, locals
	lw s2, 0(s1)
	la s1, local_cap
	lw s3, 0(s1)
	li s1, 20
	mul s4, s3, s1
	mv a0, s2
	mv a1, s4
	jal ra, realloc
	mv s1, a0
	la s2, locals
	sw s1, 0(s2)
.L10_1:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	la s1, locals
	lw s2, 0(s1)
	la s1, nlocals
	lw s4, 0(s1)
	li s1, 20
	mul s5, s4, s1
	add s1, s2, s5
	sw s3, 0(s1)
	lw s1, -8(s0)
	la s2, locals
	lw s3, 0(s2)
	la s2, nlocals
	lw s4, 0(s2)
	li s2, 20
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	la s2, locals
	lw s3, 0(s2)
	la s2, nlocals
	lw s4, 0(s2)
	li s2, 20
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	la s2, locals
	lw s3, 0(s2)
	la s2, nlocals
	lw s4, 0(s2)
	li s2, 20
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	la s2, locals
	lw s3, 0(s2)
	la s2, nlocals
	lw s4, 0(s2)
	li s2, 20
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, nlocals
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
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
	.size add_local, .Lfunc_end10-add_local

	.text
	.align 2
	.type find_local, @function
find_local:
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
	la s1, nlocals
	lw s2, 0(s1)
	li s1, 1
	sub s3, s2, s1
	sw s3, -12(s0)
.L11_0:
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L11_1
	j .L11_2
.L11_1:
	la s1, locals
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 20
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
	bnez s2, .L11_3
	j .L11_4
.L11_3:
	la s1, locals
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 20
	mul s4, s1, s3
	add s1, s2, s4
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
.L11_4:
.L11_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L11_0
.L11_2:
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
	.size find_local, .Lfunc_end11-find_local

	.text
	.align 2
	.type asm_operand_pin, @function
asm_operand_pin:
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
	li s1, 0
	sw s1, -12(s0)
.L12_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 76
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L12_1
	j .L12_2
.L12_1:
	lw s1, -4(s0)
	li s2, 72
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 123
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_3
	j .L12_4
.L12_3:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L12_5:
	lw s1, -16(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 76
	add s4, s1, s2
	lw s1, 0(s4)
	slt s2, s3, s1
	bnez s2, .L12_6
	j .L12_7
.L12_6:
	lw s1, -4(s0)
	li s2, 72
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	add s2, s1, s4
	lb s1, 0(s2)
	li s2, 125
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L12_8
	j .L12_7
.L12_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L12_5
.L12_7:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 72
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -16(s0)
	add s4, s1, s3
	lw s1, -20(s0)
	mv a0, s2
	mv a1, s4
	mv a2, s1
	jal ra, arena_strndup
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
.L12_4:
.L12_9:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L12_0
.L12_2:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_10
	j .L12_11
.L12_10:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L12_12
	j .L12_11
.L12_12:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	bnez s1, .L12_13
	j .L12_14
.L12_13:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L12_15
	j .L12_14
.L12_15:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
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
.L12_14:
.L12_11:
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
	.size asm_operand_pin, .Lfunc_end12-asm_operand_pin

	.text
	.align 2
	.type type_is_readonly, @function
type_is_readonly:
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
.L13_0:
	lw s1, -4(s0)
	bnez s1, .L13_1
	j .L13_2
.L13_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_3
	j .L13_2
.L13_3:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -4(s0)
	j .L13_0
.L13_2:
	lw s1, -4(s0)
	bnez s1, .L13_4
	j .L13_5
.L13_4:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L13_6
	j .L13_5
.L13_6:
	li s1, 1
	j .L13_7
.L13_5:
	li s1, 0
.L13_7:
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
.Lfunc_end13:
	.size type_is_readonly, .Lfunc_end13-type_is_readonly

	.text
	.align 2
	.type add_global, @function
add_global:
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
	la s1, nglobals
	lw s2, 0(s1)
	la s1, global_cap
	lw s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L14_0
	j .L14_1
.L14_0:
	la s1, global_cap
	lw s2, 0(s1)
	bnez s2, .L14_2
	j .L14_3
.L14_2:
	la s1, global_cap
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -20(s0)
	j .L14_4
.L14_3:
	li s1, 32
	sw s1, -20(s0)
.L14_4:
	lw s1, -20(s0)
	la s2, global_cap
	sw s1, 0(s2)
	la s1, globals
	lw s2, 0(s1)
	la s1, global_cap
	lw s3, 0(s1)
	li s1, 12
	mul s4, s3, s1
	mv a0, s2
	mv a1, s4
	jal ra, realloc
	mv s1, a0
	la s2, globals
	sw s1, 0(s2)
.L14_1:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	la s1, globals
	lw s2, 0(s1)
	la s1, nglobals
	lw s4, 0(s1)
	li s1, 12
	mul s5, s4, s1
	add s1, s2, s5
	sw s3, 0(s1)
	lw s1, -8(s0)
	la s2, globals
	lw s3, 0(s2)
	la s2, nglobals
	lw s4, 0(s2)
	li s2, 12
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	la s2, globals
	lw s3, 0(s2)
	la s2, nglobals
	lw s4, 0(s2)
	li s2, 12
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, nglobals
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
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
	.size add_global, .Lfunc_end14-add_global

	.text
	.align 2
	.type find_global, @function
find_global:
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
.L15_0:
	lw s1, -12(s0)
	la s2, nglobals
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L15_1
	j .L15_2
.L15_1:
	la s1, globals
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 12
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
	bnez s2, .L15_3
	j .L15_4
.L15_3:
	la s1, globals
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 12
	mul s4, s1, s3
	add s1, s2, s4
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
.L15_4:
.L15_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L15_0
.L15_2:
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
	.size find_global, .Lfunc_end15-find_global

	.text
	.align 2
	.type get_named_label, @function
get_named_label:
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
.L16_0:
	lw s1, -12(s0)
	la s2, nnamed_labels
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L16_1
	j .L16_2
.L16_1:
	la s1, named_labels
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L16_3
	j .L16_4
.L16_3:
	la s1, named_labels
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
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
.L16_4:
.L16_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L16_0
.L16_2:
	jal ra, new_label
	mv s1, a0
	sw s1, -16(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	la s1, named_labels
	la s2, nnamed_labels
	lw s4, 0(s2)
	li s2, 8
	mul s5, s4, s2
	add s2, s1, s5
	sw s3, 0(s2)
	lw s1, -16(s0)
	la s2, named_labels
	la s3, nnamed_labels
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, nnamed_labels
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
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
.Lfunc_end16:
	.size get_named_label, .Lfunc_end16-get_named_label

	.text
	.align 2
	.type type_to_ir, @function
type_to_ir:
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
	bnez s1, .L17_0
	j .L17_1
.L17_1:
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
.L17_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_2
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_3
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_4
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_5
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_6
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_7
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_8
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_9
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_10
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L17_11
	j .L17_12
.L17_2:
	li s1, 2
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
.L17_3:
	li s1, 3
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
.L17_4:
	li s1, 5
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
.L17_5:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L17_13
	j .L17_14
.L17_13:
	li s1, 5
	sw s1, -12(s0)
	j .L17_15
.L17_14:
	li s1, 1
	sw s1, -12(s0)
.L17_15:
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
.L17_6:
.L17_7:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L17_16
	j .L17_17
.L17_16:
	li s1, 5
	sw s1, -16(s0)
	j .L17_18
.L17_17:
	li s1, 1
	sw s1, -16(s0)
.L17_18:
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
.L17_8:
	li s1, 4
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
.L17_9:
	li s1, 6
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
.L17_10:
	li s1, 4
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
.L17_11:
	li s1, 0
	mv a0, s1
	jal ra, hit_ldouble
	mv s2, a0
	li s1, 5
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
.L17_12:
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
.L17_19:
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
	.size type_to_ir, .Lfunc_end17-type_to_ir

	.text
	.align 2
	.type hit_ldouble, @function
hit_ldouble:
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
	la s1, ldouble_recover_active
	lw s2, 0(s1)
	bnez s2, .L18_0
	j .L18_1
.L18_0:
	la s1, ldouble_recover
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, longjmp
	mv s3, a0
.L18_1:
	lw s1, -4(s0)
	bnez s1, .L18_2
	j .L18_3
.L18_2:
	la s1, __str_0
	lw s2, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L18_3:
	la s1, __str_1
	mv a0, s1
	jal ra, die
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
.Lfunc_end18:
	.size hit_ldouble, .Lfunc_end18-hit_ldouble

	.text
	.align 2
	.type reject_ldouble, @function
reject_ldouble:
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
	bnez s1, .L19_0
	j .L19_1
.L19_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_2
	j .L19_1
.L19_2:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, hit_ldouble
	mv s2, a0
.L19_1:
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
.Lfunc_end19:
	.size reject_ldouble, .Lfunc_end19-reject_ldouble

	.text
	.align 2
	.type pointee_size, @function
pointee_size:
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
	bnez s1, .L20_0
	j .L20_1
.L20_1:
	li s1, 4
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
.L20_0:
	li s1, 0
	sw s1, -12(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L20_2
	j .L20_3
.L20_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L20_4
.L20_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L20_5
	j .L20_6
.L20_5:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L20_6:
.L20_4:
	lw s1, -12(s0)
	bnez s1, .L20_7
	j .L20_8
.L20_8:
	li s1, 4
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
.L20_7:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_size
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
.Lfunc_end20:
	.size pointee_size, .Lfunc_end20-pointee_size

	.text
	.align 2
	.type is_float_type, @function
is_float_type:
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
	bnez s1, .L21_0
	j .L21_1
.L21_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L21_2
	j .L21_3
.L21_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L21_2
	j .L21_4
.L21_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L21_2
	j .L21_1
.L21_2:
	li s1, 1
	j .L21_5
.L21_1:
	li s1, 0
.L21_5:
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
.Lfunc_end21:
	.size is_float_type, .Lfunc_end21-is_float_type

	.text
	.align 2
	.type fwidth, @function
fwidth:
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
	bnez s1, .L22_0
	j .L22_1
.L22_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_2
	j .L22_1
.L22_2:
	li s1, 4
	sw s1, -12(s0)
	j .L22_3
.L22_1:
	li s1, 0
	sw s1, -12(s0)
.L22_3:
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
.Lfunc_end22:
	.size fwidth, .Lfunc_end22-fwidth

	.text
	.align 2
	.type is_double_type, @function
is_double_type:
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
	bnez s1, .L23_0
	j .L23_1
.L23_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L23_2
	j .L23_3
.L23_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L23_2
	j .L23_1
.L23_2:
	li s1, 1
	j .L23_4
.L23_1:
	li s1, 0
.L23_4:
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
.Lfunc_end23:
	.size is_double_type, .Lfunc_end23-is_double_type

	.text
	.align 2
	.type double_to_half, @function
double_to_half:
	addi sp, sp, -192
	sw ra, 188(sp)
	sw s0, 184(sp)
	addi s0, sp, 184
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
	fsd fs0, 52(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	fld fs0, -8(s0)
	addi s1, s0, -16
	fsd fs0, 0(s1)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 48
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	li s1, 32768
	mv s10, s1
	li s11, 0
	and s6, s8, s10
	and s7, s9, s11
	mv s1, s6
	li s2, 65535
	and s3, s1, s2
	sw s3, -28(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s1, 52
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	li s1, 2047
	mv s10, s1
	srai s11, s10, 31
	and s6, s8, s10
	and s7, s9, s11
	mv s1, s6
	sw s1, -32(s0)
	lw s10, -24(s0)
	lw s11, -20(s0)
	li s8, -1
	li s9, 1048575
	and s6, s10, s8
	and s7, s11, s9
	sw s6, -40(s0)
	sw s7, -36(s0)
	lw s1, -32(s0)
	li s2, 2047
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L24_0
	j .L24_1
.L24_0:
	addi s1, s0, -28
	lhu s2, 0(s1)
	lw s10, -40(s0)
	lw s11, -36(s0)
	bnez s10, .L24_2
	j .L24_3
.L24_2:
	li s1, 32256
	sw s1, -44(s0)
	j .L24_4
.L24_3:
	li s1, 31744
	sw s1, -44(s0)
.L24_4:
	lw s1, -44(s0)
	or s3, s2, s1
	mv a0, s3
	lw s1, -176(s0)
	lw s2, -172(s0)
	lw s3, -168(s0)
	lw s4, -164(s0)
	lw s5, -160(s0)
	lw s6, -156(s0)
	lw s7, -152(s0)
	lw s8, -148(s0)
	lw s9, -144(s0)
	lw s10, -140(s0)
	lw s11, -136(s0)
	fld fs0, -132(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_1:
	lw s1, -32(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L24_5
	j .L24_6
.L24_5:
	addi s1, s0, -28
	lhu s2, 0(s1)
	mv a0, s2
	lw s1, -176(s0)
	lw s2, -172(s0)
	lw s3, -168(s0)
	lw s4, -164(s0)
	lw s5, -160(s0)
	lw s6, -156(s0)
	lw s7, -152(s0)
	lw s8, -148(s0)
	lw s9, -144(s0)
	lw s10, -140(s0)
	lw s11, -136(s0)
	fld fs0, -132(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_6:
	lw s1, -32(s0)
	li s2, 1023
	sub s3, s1, s2
	li s1, 15
	add s2, s3, s1
	sw s2, -48(s0)
	lw s1, -48(s0)
	li s2, 31
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L24_7
	j .L24_8
.L24_7:
	addi s1, s0, -28
	lhu s2, 0(s1)
	li s1, 31744
	or s3, s2, s1
	mv a0, s3
	lw s1, -176(s0)
	lw s2, -172(s0)
	lw s3, -168(s0)
	lw s4, -164(s0)
	lw s5, -160(s0)
	lw s6, -156(s0)
	lw s7, -152(s0)
	lw s8, -148(s0)
	lw s9, -144(s0)
	lw s10, -140(s0)
	lw s11, -136(s0)
	fld fs0, -132(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_8:
	lw s1, -48(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L24_9
	j .L24_10
.L24_9:
	addi s1, s0, -40
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s8, 0
	li s9, 1048576
	or s6, s10, s8
	or s7, s11, s9
	sw s6, -40(s0)
	sw s7, -36(s0)
	li s1, 43
	lw s2, -48(s0)
	sub s3, s1, s2
	sw s3, -52(s0)
	lw s1, -52(s0)
	li s2, 64
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L24_11
	j .L24_12
.L24_11:
	addi s1, s0, -28
	lhu s2, 0(s1)
	mv a0, s2
	lw s1, -176(s0)
	lw s2, -172(s0)
	lw s3, -168(s0)
	lw s4, -164(s0)
	lw s5, -160(s0)
	lw s6, -156(s0)
	lw s7, -152(s0)
	lw s8, -148(s0)
	lw s9, -144(s0)
	lw s10, -140(s0)
	lw s11, -136(s0)
	fld fs0, -132(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_12:
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw s1, -52(s0)
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	sw s8, -64(s0)
	sw s9, -60(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	lw s1, -52(s0)
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	sltu t0, s6, s8
	sub s4, s6, s8
	sub s5, s7, t0
	sub s5, s5, s9
	and s8, s10, s4
	and s9, s11, s5
	sw s8, -72(s0)
	sw s9, -68(s0)
	li s1, 1
	mv s10, s1
	srai s11, s10, 31
	lw s1, -52(s0)
	li s2, 1
	sub s3, s1, s2
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s3, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	sw s8, -80(s0)
	sw s9, -76(s0)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	sltu s1, s9, s11
	bne s9, s11, .L24_13
	sltu s1, s8, s10
.L24_13:
	bnez s1, .L24_14
	j .L24_15
.L24_15:
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw s8, -80(s0)
	lw s9, -76(s0)
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L24_16
	j .L24_17
.L24_16:
	lw s10, -64(s0)
	lw s11, -60(s0)
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	and s6, s10, s8
	and s7, s11, s9
	bnez s6, .L24_14
	j .L24_17
.L24_14:
	addi s1, s0, -64
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s8, 1
	li s9, 0
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -64(s0)
	sw s7, -60(s0)
.L24_17:
	addi s1, s0, -28
	lhu s2, 0(s1)
	lw s10, -64(s0)
	lw s11, -60(s0)
	mv s1, s10
	li s3, 65535
	and t0, s1, s3
	sw t0, -116(s0)
	lw t1, -116(s0)
	or s1, s2, t1
	mv a0, s1
	lw s1, -176(s0)
	lw s2, -172(s0)
	lw s3, -168(s0)
	lw s4, -164(s0)
	lw s5, -160(s0)
	lw s6, -156(s0)
	lw s7, -152(s0)
	lw s8, -148(s0)
	lw s9, -144(s0)
	lw s10, -140(s0)
	lw s11, -136(s0)
	fld fs0, -132(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_10:
	lw s10, -40(s0)
	lw s11, -36(s0)
	li s1, 42
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	sw s8, -88(s0)
	sw s9, -84(s0)
	lw s10, -40(s0)
	lw s11, -36(s0)
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	li s1, 42
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	sltu t0, s6, s8
	sub s4, s6, s8
	sub s5, s7, t0
	sub s5, s5, s9
	and s8, s10, s4
	and s9, s11, s5
	sw s8, -96(s0)
	sw s9, -92(s0)
	li s1, 1
	mv s10, s1
	srai s11, s10, 31
	li s1, 41
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	sw s8, -104(s0)
	sw s9, -100(s0)
	addi s1, s0, -28
	lhu t0, 0(s1)
	sw t0, -120(s0)
	lw s1, -48(s0)
	li s3, 10
	sll s2, s1, s3
	li s1, 65535
	and s3, s2, s1
	lw t0, -120(s0)
	or s1, t0, s3
	lw s10, -88(s0)
	lw s11, -84(s0)
	mv s2, s10
	li s3, 65535
	and t0, s2, s3
	sw t0, -124(s0)
	lw t1, -124(s0)
	or s2, s1, t1
	sw s2, -108(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	sltu s1, s9, s11
	bne s9, s11, .L24_18
	sltu s1, s8, s10
.L24_18:
	bnez s1, .L24_19
	j .L24_20
.L24_20:
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L24_21
	j .L24_22
.L24_21:
	lw s10, -88(s0)
	lw s11, -84(s0)
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	and s6, s10, s8
	and s7, s11, s9
	bnez s6, .L24_19
	j .L24_22
.L24_19:
	addi s1, s0, -108
	lhu s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -108(s0)
.L24_22:
	addi s1, s0, -108
	lhu s2, 0(s1)
	mv a0, s2
	lw s1, -176(s0)
	lw s2, -172(s0)
	lw s3, -168(s0)
	lw s4, -164(s0)
	lw s5, -160(s0)
	lw s6, -156(s0)
	lw s7, -152(s0)
	lw s8, -148(s0)
	lw s9, -144(s0)
	lw s10, -140(s0)
	lw s11, -136(s0)
	fld fs0, -132(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end24:
	.size double_to_half, .Lfunc_end24-double_to_half

	.text
	.align 2
	.type is_i64_type, @function
is_i64_type:
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
	bnez s1, .L25_0
	j .L25_1
.L25_1:
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
.L25_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L25_2
	j .L25_3
.L25_2:
	li s1, 1
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
.L25_3:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_4
	j .L25_5
.L25_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L25_6
	j .L25_5
.L25_6:
	li s1, 1
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
.L25_5:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_7
	j .L25_8
.L25_7:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L25_9
	j .L25_10
.L25_10:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L25_9
	j .L25_8
.L25_9:
	li s1, 1
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
.L25_8:
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
.Lfunc_end25:
	.size is_i64_type, .Lfunc_end25-is_i64_type

	.text
	.align 2
	.type is_bool_type, @function
is_bool_type:
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
	bnez s1, .L26_0
	j .L26_1
.L26_0:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L26_2
	j .L26_1
.L26_2:
	li s1, 1
	j .L26_3
.L26_1:
	li s1, 0
.L26_3:
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
.Lfunc_end26:
	.size is_bool_type, .Lfunc_end26-is_bool_type

	.text
	.align 2
	.type widen_to_i64, @function
widen_to_i64:
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
	bnez s1, .L27_0
	j .L27_1
.L27_0:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L27_2
	j .L27_1
.L27_2:
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
.L27_1:
	lw s1, -8(s0)
	bnez s1, .L27_3
	j .L27_4
.L27_3:
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L27_5
	j .L27_6
.L27_6:
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L27_5
	j .L27_4
.L27_5:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L27_7
	j .L27_4
.L27_7:
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
.L27_4:
	lw s1, -8(s0)
	bnez s1, .L27_8
	j .L27_9
.L27_8:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L27_10
	j .L27_9
.L27_10:
	li s1, 118
	sw s1, -16(s0)
	j .L27_11
.L27_9:
	li s1, 117
	sw s1, -16(s0)
.L27_11:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end27:
	.size widen_to_i64, .Lfunc_end27-widen_to_i64

	.text
	.align 2
	.type widen_branch_to_i64, @function
widen_branch_to_i64:
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
	jal ra, widen_to_i64
	mv s3, a0
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
.Lfunc_end28:
	.size widen_branch_to_i64, .Lfunc_end28-widen_branch_to_i64

	.text
	.align 2
	.type emit_load, @function
emit_load:
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
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
	lw s1, -8(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L29_0
	j .L29_1
.L29_0:
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L29_2
	j .L29_3
.L29_2:
	li s1, 78
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	j .L29_4
.L29_3:
	li s1, 75
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L29_4:
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.L29_1:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, val_is_wide
	mv s2, a0
	bnez s2, .L29_5
	j .L29_6
.L29_5:
	li s1, 110
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.L29_6:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -16(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L29_7
	j .L29_8
.L29_7:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L29_9
	j .L29_10
.L29_9:
	li s1, 20
	sw s1, -20(s0)
	j .L29_11
.L29_10:
	li s1, 21
	sw s1, -20(s0)
.L29_11:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	j .L29_12
.L29_8:
	lw s1, -16(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L29_13
	j .L29_14
.L29_13:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L29_15
	j .L29_16
.L29_15:
	li s1, 22
	sw s1, -24(s0)
	j .L29_17
.L29_16:
	li s1, 23
	sw s1, -24(s0)
.L29_17:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	j .L29_18
.L29_14:
	li s1, 24
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
.L29_18:
.L29_12:
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
	.size emit_load, .Lfunc_end29-emit_load

	.text
	.align 2
	.type emit_store, @function
emit_store:
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
	lw s1, -12(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L30_0
	j .L30_1
.L30_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s3
	jal ra, cc_type_size
	mv s4, a0
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, emit_aggregate_copy
	mv s3, a0
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
.L30_1:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L30_2
	j .L30_3
.L30_2:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L30_4
	j .L30_5
.L30_4:
	li s1, 79
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	j .L30_6
.L30_5:
	li s1, 77
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -20(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L30_6:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
	lw s1, -12(s0)
	mv a0, s1
	jal ra, val_is_wide
	mv s2, a0
	bnez s2, .L30_7
	j .L30_8
.L30_7:
	li s1, 111
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L30_9
	j .L30_10
.L30_9:
	li s1, 25
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	j .L30_11
.L30_10:
	lw s1, -24(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L30_12
	j .L30_13
.L30_12:
	li s1, 26
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	j .L30_14
.L30_13:
	li s1, 27
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
.L30_14:
.L30_11:
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -20(s0)
	li s3, 12
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
.Lfunc_end30:
	.size emit_store, .Lfunc_end30-emit_store

	.text
	.align 2
	.type to_float, @function
to_float:
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
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L31_0
	j .L31_1
.L31_1:
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
.L31_0:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L31_2
	j .L31_3
.L31_3:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L31_4
	j .L31_5
.L31_4:
	li s1, 119
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -4(s0)
.L31_5:
	li s1, 69
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -20(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.L31_2:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fwidth
	mv s3, a0
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L31_6
	j .L31_7
.L31_6:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L31_8
	j .L31_9
.L31_8:
	li s1, 73
	sw s1, -24(s0)
	j .L31_10
.L31_9:
	li s1, 72
	sw s1, -24(s0)
.L31_10:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.L31_7:
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
.Lfunc_end31:
	.size to_float, .Lfunc_end31-to_float

	.text
	.align 2
	.type emit_string_literal, @function
emit_string_literal:
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
	addi s1, s0, -40
	li s2, 32
	la s3, __str_2
	la s4, str_counter
	lw s5, 0(s4)
	li s6, 1
	add s7, s5, s6
	sw s7, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s5, 0(sp)
	jal ra, snprintf
	mv s4, a0
	addi sp, sp, 16
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 68
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -44(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	addi s1, s0, -40
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -44(s0)
	sw s3, 0(s1)
	li s1, 2
	lw s2, -44(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -44(s0)
	li s2, 12
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 1
	lw s2, -44(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s3, 1
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -44(s0)
	li s3, 56
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -44(s0)
	li s3, 56
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -8(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -44(s0)
	li s2, 60
	add s4, s1, s2
	sw s3, 0(s4)
	la s1, cur_prog
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 64
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	la s2, cur_prog
	lw s3, 0(s2)
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -40
	mv a0, s1
	jal ra, emit_addr_sym
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
.Lfunc_end32:
	.size emit_string_literal, .Lfunc_end32-emit_string_literal

	.text
	.align 2
	.type count_init_flat, @function
count_init_flat:
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
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
.L33_0:
	lw s1, -16(s0)
	bnez s1, .L33_1
	j .L33_2
.L33_1:
	lw s1, -16(s0)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L33_3
	j .L33_4
.L33_3:
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, count_init_flat
	mv s3, a0
	add s1, s2, s3
	sw s1, -12(s0)
	j .L33_5
.L33_4:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
.L33_5:
.L33_6:
	lw s1, -16(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L33_0
.L33_2:
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
.Lfunc_end33:
	.size count_init_flat, .Lfunc_end33-count_init_flat

	.text
	.align 2
	.type emit_string_global, @function
emit_string_global:
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
	addi s1, s0, -40
	li s2, 32
	la s3, __str_3
	la s4, str_counter
	lw s5, 0(s4)
	li s6, 1
	add s7, s5, s6
	sw s7, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s5, 0(sp)
	jal ra, snprintf
	mv s4, a0
	addi sp, sp, 16
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 68
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -44(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	addi s1, s0, -40
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -44(s0)
	sw s3, 0(s1)
	li s1, 2
	lw s2, -44(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -44(s0)
	li s2, 12
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 1
	lw s2, -44(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s3, 1
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -44(s0)
	li s3, 56
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -44(s0)
	li s3, 56
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -8(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -8(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -44(s0)
	li s2, 60
	add s4, s1, s2
	sw s3, 0(s4)
	la s1, cur_prog
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 64
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	la s2, cur_prog
	lw s3, 0(s2)
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	addi s1, s0, -40
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	mv a0, s3
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
.Lfunc_end34:
	.size emit_string_global, .Lfunc_end34-emit_string_global

	.text
	.align 2
	.type flat_elem_type, @function
flat_elem_type:
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
.L35_0:
	lw s1, -4(s0)
	bnez s1, .L35_1
	j .L35_2
.L35_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_3
	j .L35_2
.L35_3:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -4(s0)
	j .L35_0
.L35_2:
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
.Lfunc_end35:
	.size flat_elem_type, .Lfunc_end35-flat_elem_type

	.text
	.align 2
	.type flatten_init, @function
flatten_init:
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
	lw s1, -8(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
.L36_0:
	lw s1, -28(s0)
	bnez s1, .L36_1
	j .L36_2
.L36_1:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L36_3
	j .L36_4
.L36_3:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, flatten_init
	mv s6, a0
	j .L36_5
.L36_4:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -12(s0)
	lw s4, -20(s0)
	lw s5, 0(s4)
	li s4, 8
	mul s6, s5, s4
	add s4, s3, s6
	lw s3, -16(s0)
	lw s5, -20(s0)
	lw s6, 0(s5)
	li s5, 4
	mul s7, s6, s5
	add s5, s3, s7
	mv a0, s1
	mv a1, s2
	mv a2, s4
	mv a3, s5
	jal ra, encode_scalar
	mv s3, a0
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L36_5:
.L36_6:
	lw s1, -28(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	j .L36_0
.L36_2:
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
.Lfunc_end36:
	.size flatten_init, .Lfunc_end36-flatten_init

	.text
	.align 2
	.type needs_image, @function
needs_image:
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
	bnez s1, .L37_0
	j .L37_1
.L37_1:
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
.L37_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L37_2
	j .L37_3
.L37_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L37_2
	j .L37_4
.L37_2:
	li s1, 1
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
.L37_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L37_5
	j .L37_6
.L37_5:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, needs_image
	mv s2, a0
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
.L37_6:
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
.Lfunc_end37:
	.size needs_image, .Lfunc_end37-needs_image

	.text
	.align 2
	.type wants_image, @function
wants_image:
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
	jal ra, needs_image
	mv s2, a0
	bnez s2, .L38_0
	j .L38_1
.L38_0:
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
.L38_1:
	lw s1, -4(s0)
	bnez s1, .L38_2
	j .L38_3
.L38_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L38_4
	j .L38_3
.L38_4:
	lw s1, -8(s0)
	bnez s1, .L38_5
	j .L38_3
.L38_5:
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L38_6
	j .L38_3
.L38_6:
	lw s1, -8(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L38_7:
	lw s1, -12(s0)
	bnez s1, .L38_8
	j .L38_9
.L38_8:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L38_10
	j .L38_11
.L38_10:
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
.L38_11:
.L38_12:
	lw s1, -12(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L38_7
.L38_9:
.L38_3:
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
.Lfunc_end38:
	.size wants_image, .Lfunc_end38-wants_image

	.text
	.align 2
	.type const_expr_is_integer, @function
const_expr_is_integer:
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
	bnez s1, .L39_0
	j .L39_1
.L39_1:
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
.L39_0:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L39_2
	j .L39_3
.L39_2:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_is_integer
	mv s2, a0
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
.L39_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L39_4
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L39_5
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L39_6
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L39_7
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L39_8
	li s1, 24
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L39_9
	j .L39_10
.L39_4:
	li s1, 1
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
.L39_5:
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
.L39_6:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_expr_is_integer
	mv s2, a0
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
.L39_7:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_expr_is_integer
	mv s2, a0
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
.L39_8:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_expr_is_integer
	mv s2, a0
	bnez s2, .L39_11
	j .L39_12
.L39_11:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_expr_is_integer
	mv s2, a0
	bnez s2, .L39_13
	j .L39_12
.L39_13:
	li s1, 1
	j .L39_14
.L39_12:
	li s1, 0
.L39_14:
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
.L39_9:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_expr_is_integer
	mv s2, a0
	bnez s2, .L39_15
	j .L39_16
.L39_15:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_expr_is_integer
	mv s2, a0
	bnez s2, .L39_17
	j .L39_16
.L39_17:
	li s1, 1
	j .L39_18
.L39_16:
	li s1, 0
.L39_18:
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
.L39_10:
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
.L39_19:
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
.Lfunc_end39:
	.size const_expr_is_integer, .Lfunc_end39-const_expr_is_integer

	.text
	.align 2
	.type fold_float_const, @function
fold_float_const:
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
	fsd fs0, 48(sp)
	fsd fs1, 56(sp)
	fsd fs2, 64(sp)
	sw a0, -4(s0)
	lw s1, -4(s0)
	bnez s1, .L40_0
	j .L40_1
.L40_1:
	la s1, __str_4
	mv a0, s1
	jal ra, die
	mv s2, a0
.L40_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, const_expr_is_integer
	mv s2, a0
	bnez s2, .L40_2
	j .L40_3
.L40_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cc_const_eval
	mv s10, a0
	mv s11, a1
	mv s1, s10
	fcvt.d.w fs0, s1
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L40_4
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L40_5
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L40_6
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L40_7
	li s1, 24
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L40_8
	j .L40_9
.L40_4:
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_5:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	jal ra, fold_float_const
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_10
	j .L40_11
.L40_10:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	jal ra, fold_float_const
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fneg.d fs1, fs0
	addi sp, sp, -8
	fsd fs1, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_11:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_12
	j .L40_13
.L40_12:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	jal ra, fold_float_const
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_13:
	j .L40_14
.L40_7:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	jal ra, fold_float_const
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -16(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	jal ra, fold_float_const
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -24(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_15
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_16
	li s2, 71
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_17
	li s2, 72
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_18
	j .L40_19
.L40_15:
	fld fs0, -16(s0)
	fld fs1, -24(s0)
	fadd.d fs2, fs0, fs1
	addi sp, sp, -8
	fsd fs2, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_16:
	fld fs0, -16(s0)
	fld fs1, -24(s0)
	fsub.d fs2, fs0, fs1
	addi sp, sp, -8
	fsd fs2, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_17:
	fld fs0, -16(s0)
	fld fs1, -24(s0)
	fmul.d fs2, fs0, fs1
	addi sp, sp, -8
	fsd fs2, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_18:
	fld fs0, -16(s0)
	fld fs1, -24(s0)
	fdiv.d fs2, fs0, fs1
	addi sp, sp, -8
	fsd fs2, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_19:
	j .L40_20
.L40_20:
	j .L40_14
.L40_8:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_const_eval
	mv s10, a0
	mv s11, a1
	bnez s10, .L40_21
	j .L40_22
.L40_21:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	jal ra, fold_float_const
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -32(s0)
	j .L40_23
.L40_22:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	jal ra, fold_float_const
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -32(s0)
.L40_23:
	fld fs0, -32(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L40_9:
	j .L40_14
.L40_14:
	la s1, __str_5
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 0
	fcvt.d.w fs0, s1
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -56(s0)
	fld fs1, -48(s0)
	fld fs2, -40(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end40:
	.size fold_float_const, .Lfunc_end40-fold_float_const

	.text
	.align 2
	.type encode_scalar, @function
encode_scalar:
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
	fsd fs0, 56(sp)
	fsd fs1, 64(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	li s1, 0
	lw s2, -12(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 0
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_0
	j .L41_1
.L41_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_2
	j .L41_3
.L41_2:
	lw s1, -8(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	fcvt.d.w fs0, s1
	addi s1, s0, -24
	fsd fs0, 0(s1)
	addi s1, s0, -24
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -12(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L41_4
.L41_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_5
	j .L41_6
.L41_5:
	lw s1, -8(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	fcvt.s.w fs0, s1
	addi s1, s0, -28
	fsw fs0, 0(s1)
	addi s1, s0, -28
	lw s2, 0(s1)
	lw s1, -12(s0)
	mv s10, s2
	li s11, 0
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L41_7
.L41_6:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_8
	j .L41_9
.L41_8:
	lw s1, -8(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	fcvt.d.w fs0, s1
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, double_to_half
	mv s1, a0
	addi sp, sp, 16
	li s2, 65535
	and s3, s1, s2
	lw s1, -12(s0)
	mv s10, s3
	li s11, 0
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L41_10
.L41_9:
	lw s1, -8(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -12(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
.L41_10:
.L41_7:
.L41_4:
	j .L41_11
.L41_1:
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_12
	j .L41_13
.L41_12:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L41_14
	j .L41_13
.L41_14:
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L41_15
	j .L41_13
.L41_15:
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_16
	j .L41_17
.L41_17:
	lw s1, -8(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_16
	j .L41_13
.L41_16:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -12(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, encode_scalar
	mv s5, a0
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_18
	j .L41_19
.L41_18:
	lw s1, -12(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s2, 1
	mv s8, s2
	srai s9, s8, 31
	li s2, 63
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s2, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	xor s8, s10, s6
	xor s9, s11, s7
	sw s8, 0(s1)
	sw s9, 4(s1)
	j .L41_20
.L41_19:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_21
	j .L41_22
.L41_21:
	lw s1, -12(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s2, 1
	mv s8, s2
	srai s9, s8, 31
	li s2, 31
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s2, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	xor s8, s10, s6
	xor s9, s11, s7
	sw s8, 0(s1)
	sw s9, 4(s1)
	j .L41_23
.L41_22:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_24
	j .L41_25
.L41_24:
	lw s1, -12(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s2, 1
	mv s8, s2
	srai s9, s8, 31
	li s2, 15
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s2, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	xor s8, s10, s6
	xor s9, s11, s7
	sw s8, 0(s1)
	sw s9, 4(s1)
	j .L41_26
.L41_25:
	lw s1, -12(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	lw s1, -12(s0)
	sw s8, 0(s1)
	sw s9, 4(s1)
.L41_26:
.L41_23:
.L41_20:
	j .L41_27
.L41_13:
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_28
	j .L41_29
.L41_28:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_30
	j .L41_31
.L41_30:
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	fcvt.s.d fs1, fs0
	addi s1, s0, -32
	fsw fs1, 0(s1)
	addi s1, s0, -32
	lw s2, 0(s1)
	lw s1, -12(s0)
	mv s10, s2
	li s11, 0
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L41_32
.L41_31:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_33
	j .L41_34
.L41_33:
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, double_to_half
	mv s1, a0
	addi sp, sp, 16
	li s2, 65535
	and s3, s1, s2
	lw s1, -12(s0)
	mv s10, s3
	li s11, 0
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L41_35
.L41_34:
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	addi s1, s0, -40
	fsd fs0, 0(s1)
	addi s1, s0, -40
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -12(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
.L41_35:
.L41_32:
	j .L41_36
.L41_29:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_37
	j .L41_38
.L41_37:
	lw s1, -8(s0)
	lw s2, -16(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fold_addr
	mv s4, a0
	bnez s4, .L41_39
	j .L41_40
.L41_40:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, cc_const_eval
	mv s10, a0
	mv s11, a1
	lw s1, -12(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
.L41_39:
	j .L41_41
.L41_38:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cc_type_is_integer
	mv s2, a0
	bnez s2, .L41_42
	j .L41_43
.L41_42:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, fold_int_const
	mv s10, a0
	mv s11, a1
	lw s1, -12(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L41_44
.L41_43:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_45
	j .L41_46
.L41_46:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_45
	j .L41_47
.L41_47:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_45
	j .L41_48
.L41_45:
	lw s1, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	jal ra, fold_float_const
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -48(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_49
	j .L41_50
.L41_49:
	fld fs0, -48(s0)
	fcvt.s.d fs1, fs0
	addi s1, s0, -52
	fsw fs1, 0(s1)
	addi s1, s0, -52
	lw s2, 0(s1)
	lw s1, -12(s0)
	mv s10, s2
	li s11, 0
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L41_51
.L41_50:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L41_52
	j .L41_53
.L41_52:
	fld fs0, -48(s0)
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, double_to_half
	mv s1, a0
	addi sp, sp, 16
	li s2, 65535
	and s3, s1, s2
	lw s1, -12(s0)
	mv s10, s3
	li s11, 0
	sw s10, 0(s1)
	sw s11, 4(s1)
	j .L41_54
.L41_53:
	fld fs0, -48(s0)
	addi s1, s0, -64
	fsd fs0, 0(s1)
	addi s1, s0, -64
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -12(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
.L41_54:
.L41_51:
	j .L41_55
.L41_48:
	la s1, __str_6
	lw s2, -8(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L41_55:
.L41_44:
.L41_41:
.L41_36:
.L41_27:
.L41_11:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L41_56
	j .L41_57
.L41_56:
	lw s1, -16(s0)
	lw s2, 0(s1)
	bnez s2, .L41_57
	j .L41_58
.L41_58:
	lw s1, -12(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s1, t0
	lw s2, -12(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s2)
	sw s11, 4(s2)
.L41_57:
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
	fld fs0, -80(s0)
	fld fs1, -72(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end41:
	.size encode_scalar, .Lfunc_end41-encode_scalar

	.text
	.align 2
	.type agg_nslots, @function
agg_nslots:
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
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L42_0
	j .L42_1
.L42_0:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L42_2
	j .L42_3
.L42_2:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L42_4
.L42_3:
	li s1, 0
	sw s1, -12(s0)
.L42_4:
	lw s1, -12(s0)
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
.L42_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L42_5
	j .L42_6
.L42_5:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L42_7
	j .L42_8
.L42_7:
	li s1, 1
	sw s1, -16(s0)
	j .L42_9
.L42_8:
	li s1, 0
	sw s1, -16(s0)
.L42_9:
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
.L42_6:
	li s1, 0
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
.L42_10:
	lw s1, -24(s0)
	bnez s1, .L42_11
	j .L42_12
.L42_11:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
.L42_13:
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	j .L42_10
.L42_12:
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
.Lfunc_end42:
	.size agg_nslots, .Lfunc_end42-agg_nslots

	.text
	.align 2
	.type agg_slot, @function
agg_slot:
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
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L43_0
	j .L43_1
.L43_0:
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, cc_type_size
	mv s3, a0
	mul s2, s1, s3
	lw s1, -12(s0)
	sw s2, 0(s1)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
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
.L43_1:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
.L43_2:
	lw s1, -24(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L43_3
	j .L43_4
.L43_3:
	lw s1, -20(s0)
	bnez s1, .L43_5
	j .L43_4
.L43_5:
	lw s1, -20(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
.L43_6:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L43_2
.L43_4:
	lw s1, -20(s0)
	bnez s1, .L43_7
	j .L43_8
.L43_8:
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
.L43_7:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
	.size agg_slot, .Lfunc_end43-agg_slot

	.text
	.align 2
	.type field_index, @function
field_index:
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
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
.L44_0:
	lw s1, -16(s0)
	bnez s1, .L44_1
	j .L44_2
.L44_1:
	lw s1, -16(s0)
	lw s2, 0(s1)
	bnez s2, .L44_3
	j .L44_4
.L44_3:
	lw s1, -16(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L44_5
	j .L44_4
.L44_5:
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
.L44_4:
.L44_6:
	lw s1, -16(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L44_0
.L44_2:
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
.Lfunc_end44:
	.size field_index, .Lfunc_end44-field_index

	.text
	.align 2
	.type resolve_member, @function
resolve_member:
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
	bnez s1, .L45_0
	j .L45_1
.L45_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L45_2
	j .L45_3
.L45_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L45_1
	j .L45_3
.L45_1:
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
.L45_3:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
.L45_4:
	lw s1, -20(s0)
	bnez s1, .L45_5
	j .L45_6
.L45_5:
	lw s1, -20(s0)
	lw s2, 0(s1)
	bnez s2, .L45_7
	j .L45_8
.L45_7:
	lw s1, -20(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L45_9
	j .L45_8
.L45_9:
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
.L45_8:
.L45_10:
	lw s1, -20(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L45_4
.L45_6:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
.L45_11:
	lw s1, -24(s0)
	bnez s1, .L45_12
	j .L45_13
.L45_12:
	lw s1, -24(s0)
	lw s2, 0(s1)
	bnez s2, .L45_14
	j .L45_15
.L45_15:
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L45_16
	j .L45_14
.L45_14:
	j .L45_17
.L45_16:
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L45_18
	j .L45_19
.L45_18:
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L45_20
	j .L45_19
.L45_20:
	j .L45_17
.L45_19:
	li s1, 0
	sw s1, -28(s0)
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	addi s3, s0, -28
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, resolve_member
	mv s4, a0
	sw s4, -32(s0)
	lw s1, -32(s0)
	bnez s1, .L45_21
	j .L45_22
.L45_21:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s3, -24(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -28(s0)
	add s5, s3, s4
	add s3, s2, s5
	sw s3, 0(s1)
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
.L45_22:
.L45_17:
	lw s1, -24(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	j .L45_11
.L45_13:
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
.Lfunc_end45:
	.size resolve_member, .Lfunc_end45-resolve_member

	.text
	.align 2
	.type is_aggregate, @function
is_aggregate:
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
	bnez s1, .L46_0
	j .L46_1
.L46_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L46_2
	j .L46_3
.L46_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L46_2
	j .L46_4
.L46_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L46_2
	j .L46_1
.L46_2:
	li s1, 1
	j .L46_5
.L46_1:
	li s1, 0
.L46_5:
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
.Lfunc_end46:
	.size is_aggregate, .Lfunc_end46-is_aggregate

	.text
	.align 2
	.type rv_agg, @function
rv_agg:
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
	neg s2, s1
	lw s1, -8(s0)
	li s3, 3
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -8(s0)
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -8(s0)
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -8(s0)
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -4(s0)
	bnez s1, .L47_0
	j .L47_1
.L47_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L47_2
	j .L47_3
.L47_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L47_1
	j .L47_3
.L47_1:
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
.L47_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 1
	slt s3, s1, s2
	bnez s3, .L47_4
	j .L47_5
.L47_4:
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
.L47_5:
	lw s1, -12(s0)
	li s2, 8
	slt s3, s2, s1
	bnez s3, .L47_6
	j .L47_7
.L47_6:
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
.L47_7:
	li s1, 0
	sw s1, -16(s0)
.L47_8:
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 3
	add s4, s2, s3
	li s2, 4
	div s3, s4, s2
	slt s2, s1, s3
	bnez s2, .L47_9
	j .L47_10
.L47_9:
	li s1, 0
	lw s2, -8(s0)
	lw s3, -16(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L47_11:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L47_8
.L47_10:
	lw s1, -12(s0)
	li s2, 3
	add s3, s1, s2
	li s1, 4
	div s2, s3, s1
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
.Lfunc_end47:
	.size rv_agg, .Lfunc_end47-rv_agg

	.text
	.align 2
	.type abi_agg, @function
abi_agg:
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
	jal ra, rv_agg
	mv s3, a0
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
.Lfunc_end48:
	.size abi_agg, .Lfunc_end48-abi_agg

	.text
	.align 2
	.type abi_struct_mem, @function
abi_struct_mem:
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
	addi s2, s0, -24
	mv a0, s1
	mv a1, s2
	jal ra, abi_agg
	mv s3, a0
	li s1, 0
	slt s2, s3, s1
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
.Lfunc_end49:
	.size abi_struct_mem, .Lfunc_end49-abi_struct_mem

	.text
	.align 2
	.type ret_uses_hidden_ptr, @function
ret_uses_hidden_ptr:
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
	jal ra, abi_struct_mem
	mv s2, a0
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
.Lfunc_end50:
	.size ret_uses_hidden_ptr, .Lfunc_end50-ret_uses_hidden_ptr

	.text
	.align 2
	.type emit_leaf, @function
emit_leaf:
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
	bnez s1, .L51_0
	j .L51_1
.L51_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L51_2
	j .L51_1
.L51_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L51_3
	j .L51_1
.L51_3:
	lw s1, -8(s0)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L51_4
	j .L51_1
.L51_4:
	li s1, 0
	sw s1, -20(s0)
.L51_5:
	lw s1, -20(s0)
	lw s2, -8(s0)
	li s3, 76
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L51_6
	j .L51_7
.L51_6:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 24
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -24(s0)
	lw s1, -12(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lw s1, -24(s0)
	sw s3, 0(s1)
	li s1, 1
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	li s2, 72
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	lw s1, -24(s0)
	li s2, 8
	add s4, s1, s2
	mv s10, s3
	li s11, 0
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -24(s0)
	lw s2, -16(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	sw s1, -16(s0)
.L51_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L51_5
.L51_7:
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
.L51_1:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 24
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -28(s0)
	lw s1, -12(s0)
	lw s2, -28(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	lw s1, -28(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -28(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, -28(s0)
	li s4, 16
	add s6, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s6
	jal ra, encode_scalar
	mv s3, a0
	lw s1, -28(s0)
	lw s2, -16(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end51:
	.size emit_leaf, .Lfunc_end51-emit_leaf

	.text
	.align 2
	.type first_leaf, @function
first_leaf:
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
.L52_0:
	lw s1, -4(s0)
	bnez s1, .L52_1
	j .L52_2
.L52_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_3
	j .L52_2
.L52_3:
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -4(s0)
	j .L52_0
.L52_2:
	lw s1, -4(s0)
	bnez s1, .L52_4
	j .L52_5
.L52_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_6
	j .L52_5
.L52_6:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -4(s0)
.L52_5:
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
.Lfunc_end52:
	.size first_leaf, .Lfunc_end52-first_leaf

	.text
	.align 2
	.type build_image, @function
build_image:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	bnez s1, .L53_0
	j .L53_1
.L53_1:
	lw s1, -16(s0)
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L53_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_2
	j .L53_3
.L53_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_4
	j .L53_3
.L53_4:
	lw s1, -8(s0)
	lw s2, 0(s1)
	bnez s2, .L53_5
	j .L53_3
.L53_5:
	lw s1, -8(s0)
	lw s2, 0(s1)
	lw s1, 0(s2)
	li s2, 41
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L53_6
	j .L53_3
.L53_6:
	lw s1, -8(s0)
	lw s2, 0(s1)
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, -20(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_leaf
	mv s5, a0
	mv a0, s5
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L53_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, agg_nslots
	mv s2, a0
	sw s2, -24(s0)
	li s1, 0
	sw s1, -28(s0)
.L53_7:
	lw s1, -8(s0)
	lw s2, 0(s1)
	bnez s2, .L53_8
	j .L53_9
.L53_8:
	lw s1, -8(s0)
	lw s2, 0(s1)
	sw s2, -32(s0)
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_10
	j .L53_11
.L53_10:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_12
	j .L53_13
.L53_12:
	lw s1, -32(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L53_14
	j .L53_15
.L53_15:
	lw s1, -28(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L53_14
	j .L53_16
.L53_14:
	la s1, __str_7
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L53_16:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, agg_slot
	mv s4, a0
	sw s4, -36(s0)
	j .L53_17
.L53_13:
	lw s1, -4(s0)
	lw s2, -32(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, field_index
	mv s3, a0
	sw s3, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L53_18
	j .L53_19
.L53_18:
	lw s1, -44(s0)
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L53_20
	j .L53_21
.L53_21:
	lw s1, -28(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L53_20
	j .L53_22
.L53_20:
	la s1, __str_8
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L53_22:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, agg_slot
	mv s4, a0
	sw s4, -36(s0)
	j .L53_23
.L53_19:
	li s1, 0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -48(s0)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
.L53_24:
	lw s1, -52(s0)
	bnez s1, .L53_25
	j .L53_26
.L53_25:
	lw s1, -52(s0)
	lw s2, 0(s1)
	bnez s2, .L53_27
	j .L53_28
.L53_28:
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L53_29
	j .L53_27
.L53_27:
	j .L53_30
.L53_29:
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_31
	j .L53_32
.L53_31:
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_33
	j .L53_32
.L53_33:
	j .L53_30
.L53_32:
	li s1, 0
	sw s1, -56(s0)
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -32(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, resolve_member
	mv s4, a0
	sw s4, -60(s0)
	lw s1, -60(s0)
	bnez s1, .L53_34
	j .L53_35
.L53_34:
	lw s1, -60(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -52(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -56(s0)
	add s3, s1, s2
	lw s1, -60(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	add s2, s3, s1
	sw s2, -40(s0)
	lw s1, -48(s0)
	sw s1, -28(s0)
	j .L53_26
.L53_35:
.L53_30:
	lw s1, -52(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L53_24
.L53_26:
	lw s1, -36(s0)
	bnez s1, .L53_36
	j .L53_37
.L53_37:
	la s1, __str_9
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -32(s0)
	li s4, 48
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L53_36:
.L53_23:
.L53_17:
	lw s1, -32(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -32(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_38
	j .L53_39
.L53_38:
	addi s1, s0, -64
	li s2, 0
	sw s2, 0(s1)
	lw s2, -32(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	sw s2, 0(s1)
	lw s1, -36(s0)
	addi s2, s0, -64
	lw s3, -12(s0)
	lw s4, -40(s0)
	add s5, s3, s4
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	jal ra, build_image
	mv s4, a0
	sw s4, -16(s0)
	j .L53_40
.L53_39:
	lw s1, -36(s0)
	lw s2, -32(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -12(s0)
	lw s4, -40(s0)
	add s5, s3, s4
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	jal ra, emit_leaf
	mv s4, a0
	sw s4, -16(s0)
.L53_40:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L53_7
.L53_11:
	lw s1, -28(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L53_41
	j .L53_42
.L53_41:
	j .L53_9
.L53_42:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, agg_slot
	mv s4, a0
	sw s4, -36(s0)
	lw s1, -36(s0)
	bnez s1, .L53_43
	j .L53_44
.L53_44:
	j .L53_9
.L53_43:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_45
	j .L53_46
.L53_45:
	lw s1, -32(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -36(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L53_47
	j .L53_48
.L53_47:
	addi s1, s0, -68
	li s2, 0
	sw s2, 0(s1)
	lw s2, -32(s0)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	sw s2, 0(s1)
	lw s1, -36(s0)
	addi s2, s0, -68
	lw s3, -12(s0)
	lw s4, -40(s0)
	add s5, s3, s4
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	jal ra, build_image
	mv s4, a0
	sw s4, -16(s0)
	j .L53_49
.L53_48:
	lw s1, -32(s0)
	mv a0, s1
	jal ra, first_leaf
	mv s2, a0
	sw s2, -72(s0)
	lw s1, -72(s0)
	bnez s1, .L53_50
	j .L53_51
.L53_50:
	lw s1, -36(s0)
	lw s2, -72(s0)
	lw s3, -12(s0)
	lw s4, -40(s0)
	add s5, s3, s4
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	jal ra, emit_leaf
	mv s4, a0
	sw s4, -16(s0)
.L53_51:
.L53_49:
	j .L53_52
.L53_46:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L53_53
	j .L53_54
.L53_53:
	lw s1, -36(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_55
	j .L53_56
.L53_55:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_57
	j .L53_56
.L53_57:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L53_54
	j .L53_56
.L53_56:
	lw s1, -36(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -40(s0)
	add s5, s3, s4
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	jal ra, build_image
	mv s4, a0
	sw s4, -16(s0)
	j .L53_58
.L53_54:
	lw s1, -32(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -36(s0)
	lw s2, -32(s0)
	lw s3, -12(s0)
	lw s4, -40(s0)
	add s5, s3, s4
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	jal ra, emit_leaf
	mv s4, a0
	sw s4, -16(s0)
.L53_58:
.L53_52:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L53_7
.L53_9:
	lw s1, -16(s0)
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end53:
	.size build_image, .Lfunc_end53-build_image

	.text
	.align 2
	.type lower_aggregate_init, @function
lower_aggregate_init:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	addi s1, s0, -32
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	addi s1, s0, -36
	li s2, 0
	sw s2, 0(s1)
	lw s2, -8(s0)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	sw s2, 0(s1)
	li s1, 0
	sw s1, -40(s0)
	lw s1, -4(s0)
	addi s2, s0, -36
	li s3, 0
	addi s4, s0, -32
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, build_image
	mv s5, a0
	addi s1, s0, -32
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -48(s0)
.L54_0:
	lw s1, -48(s0)
	bnez s1, .L54_1
	j .L54_2
.L54_1:
	addi s1, s0, -40
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -40(s0)
.L54_3:
	lw s1, -48(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -48(s0)
	j .L54_0
.L54_2:
	lw s1, -40(s0)
	li s2, 1
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L54_4
	j .L54_5
.L54_4:
	addi s1, s0, -32
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L54_5:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -40(s0)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	sw s1, -52(s0)
	li s1, 0
	sw s1, -44(s0)
	addi s1, s0, -32
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -56(s0)
.L54_6:
	lw s1, -56(s0)
	bnez s1, .L54_7
	j .L54_8
.L54_7:
	lw s1, -56(s0)
	lw s2, -52(s0)
	addi s3, s0, -44
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -44(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L54_9:
	lw s1, -56(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -56(s0)
	j .L54_6
.L54_8:
	li s1, 1
	sw s1, -44(s0)
.L54_10:
	lw s1, -44(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L54_11
	j .L54_12
.L54_11:
	lw s1, -52(s0)
	lw s2, -44(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -60(s0)
	lw s1, -44(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -64(s0)
.L54_13:
	lw s1, -64(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L54_14
	j .L54_15
.L54_14:
	lw s1, -52(s0)
	lw s2, -64(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, 0(s1)
	lw s1, -60(s0)
	lw s3, 0(s1)
	slt s1, s3, s2
	bnez s1, .L54_16
	j .L54_15
.L54_16:
	lw s1, -52(s0)
	lw s2, -64(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -52(s0)
	lw s3, -64(s0)
	li s4, 1
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	sw s1, 0(s3)
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -64(s0)
	j .L54_13
.L54_15:
	lw s1, -60(s0)
	lw s2, -52(s0)
	lw s3, -64(s0)
	li s4, 1
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	sw s1, 0(s3)
.L54_17:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L54_10
.L54_12:
	li s1, 0
	sw s1, -68(s0)
	li s1, 0
	sw s1, -72(s0)
	li s1, 0
	sw s1, -44(s0)
.L54_18:
	lw s1, -44(s0)
	lw s2, -40(s0)
	slt s3, s1, s2
	bnez s3, .L54_19
	j .L54_20
.L54_19:
	lw s1, -44(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -40(s0)
	slt s2, s3, s1
	bnez s2, .L54_21
	j .L54_22
.L54_21:
	lw s1, -52(s0)
	lw s2, -44(s0)
	li s3, 1
	add s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	lw s2, 0(s1)
	lw s1, -52(s0)
	lw s3, -44(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	lw s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L54_23
	j .L54_22
.L54_23:
	j .L54_24
.L54_22:
	li s1, 0
	lw s2, -52(s0)
	lw s3, -44(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -72(s0)
	bnez s1, .L54_25
	j .L54_26
.L54_26:
	lw s1, -52(s0)
	lw s2, -44(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -68(s0)
	j .L54_27
.L54_25:
	lw s1, -52(s0)
	lw s2, -44(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -72(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
.L54_27:
	lw s1, -52(s0)
	lw s2, -44(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -72(s0)
.L54_24:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L54_18
.L54_20:
	lw s1, -68(s0)
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end54:
	.size lower_aggregate_init, .Lfunc_end54-lower_aggregate_init

	.text
	.align 2
	.type infer_array_len, @function
infer_array_len:
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
	li s1, 0
	sw s1, -12(s0)
	li s1, 0
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
.L55_0:
	lw s1, -20(s0)
	bnez s1, .L55_1
	j .L55_2
.L55_1:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L55_3
	j .L55_4
.L55_3:
	lw s1, -20(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L55_5
	j .L55_4
.L55_5:
	lw s1, -20(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	sw s1, -12(s0)
.L55_4:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	slt s2, s1, s3
	bnez s2, .L55_6
	j .L55_7
.L55_6:
	lw s1, -12(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -16(s0)
.L55_7:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
.L55_8:
	lw s1, -20(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L55_0
.L55_2:
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
.Lfunc_end55:
	.size infer_array_len, .Lfunc_end55-infer_array_len

	.text
	.align 2
	.type val_is_wide, @function
val_is_wide:
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
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L56_0
	j .L56_1
.L56_0:
	li s1, 1
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
.L56_1:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L56_2
	j .L56_3
.L56_2:
	lw s1, -4(s0)
	bnez s1, .L56_4
	j .L56_3
.L56_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L56_5
	j .L56_6
.L56_6:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L56_5
	j .L56_3
.L56_5:
	li s1, 1
	j .L56_7
.L56_3:
	li s1, 0
.L56_7:
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
.Lfunc_end56:
	.size val_is_wide, .Lfunc_end56-val_is_wide

	.text
	.align 2
	.type emit_addr_sym, @function
emit_addr_sym:
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
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L57_0
	j .L57_1
.L57_0:
	li s1, 114
	sw s1, -16(s0)
	j .L57_2
.L57_1:
	li s1, 2
	sw s1, -16(s0)
.L57_2:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end57:
	.size emit_addr_sym, .Lfunc_end57-emit_addr_sym

	.text
	.align 2
	.type emit_addr_slot, @function
emit_addr_slot:
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
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L58_0
	j .L58_1
.L58_0:
	li s1, 115
	sw s1, -16(s0)
	j .L58_2
.L58_1:
	li s1, 3
	sw s1, -16(s0)
.L58_2:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end58:
	.size emit_addr_slot, .Lfunc_end58-emit_addr_slot

	.text
	.align 2
	.type emit_addr_const, @function
emit_addr_const:
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
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L59_0
	j .L59_1
.L59_0:
	li s1, 85
	sw s1, -16(s0)
	j .L59_2
.L59_1:
	li s1, 1
	sw s1, -16(s0)
.L59_2:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end59:
	.size emit_addr_const, .Lfunc_end59-emit_addr_const

	.text
	.align 2
	.type emit_addr_add, @function
emit_addr_add:
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
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L60_0
	j .L60_1
.L60_0:
	li s1, 86
	sw s1, -16(s0)
	j .L60_2
.L60_1:
	li s1, 5
	sw s1, -16(s0)
.L60_2:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end60:
	.size emit_addr_add, .Lfunc_end60-emit_addr_add

	.text
	.align 2
	.type emit_aggregate_copy, @function
emit_aggregate_copy:
	addi sp, sp, -144
	sw ra, 140(sp)
	sw s0, 136(sp)
	addi s0, sp, 136
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
	sw s1, -24(s0)
.L61_0:
	lw s1, -12(s0)
	lw s2, -24(s0)
	sub s3, s1, s2
	li s1, 4
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L61_1
	j .L61_2
.L61_1:
	lw s1, -24(s0)
	bnez s1, .L61_3
	j .L61_4
.L61_3:
	lw s1, -8(s0)
	lw s2, -24(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -32(s0)
	j .L61_5
.L61_4:
	lw s1, -8(s0)
	sw s1, -32(s0)
.L61_5:
	lw s1, -32(s0)
	sw s1, -28(s0)
	li s1, 24
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -28(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -24(s0)
	bnez s1, .L61_6
	j .L61_7
.L61_6:
	lw s1, -4(s0)
	lw s2, -24(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -44(s0)
	j .L61_8
.L61_7:
	lw s1, -4(s0)
	sw s1, -44(s0)
.L61_8:
	lw s1, -44(s0)
	sw s1, -40(s0)
	li s1, 27
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -40(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -36(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	sw s3, -24(s0)
	j .L61_0
.L61_2:
	lw s1, -12(s0)
	lw s2, -24(s0)
	sub s3, s1, s2
	li s1, 2
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L61_9
	j .L61_10
.L61_9:
	lw s1, -24(s0)
	bnez s1, .L61_11
	j .L61_12
.L61_11:
	lw s1, -8(s0)
	lw s2, -24(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -52(s0)
	j .L61_13
.L61_12:
	lw s1, -8(s0)
	sw s1, -52(s0)
.L61_13:
	lw s1, -52(s0)
	sw s1, -48(s0)
	li s1, 22
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -48(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -56(s0)
	lw s1, -24(s0)
	bnez s1, .L61_14
	j .L61_15
.L61_14:
	lw s1, -4(s0)
	lw s2, -24(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -64(s0)
	j .L61_16
.L61_15:
	lw s1, -4(s0)
	sw s1, -64(s0)
.L61_16:
	lw s1, -64(s0)
	sw s1, -60(s0)
	li s1, 26
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -60(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -56(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	sw s3, -24(s0)
.L61_10:
	lw s1, -12(s0)
	lw s2, -24(s0)
	sub s3, s1, s2
	li s1, 1
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L61_17
	j .L61_18
.L61_17:
	lw s1, -24(s0)
	bnez s1, .L61_19
	j .L61_20
.L61_19:
	lw s1, -8(s0)
	lw s2, -24(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -72(s0)
	j .L61_21
.L61_20:
	lw s1, -8(s0)
	sw s1, -72(s0)
.L61_21:
	lw s1, -72(s0)
	sw s1, -68(s0)
	li s1, 20
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -68(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -76(s0)
	lw s1, -24(s0)
	bnez s1, .L61_22
	j .L61_23
.L61_22:
	lw s1, -4(s0)
	lw s2, -24(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -84(s0)
	j .L61_24
.L61_23:
	lw s1, -4(s0)
	sw s1, -84(s0)
.L61_24:
	lw s1, -84(s0)
	sw s1, -80(s0)
	li s1, 25
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -80(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -76(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L61_18:
	li s1, 0
	mv a0, s1
	lw s1, -132(s0)
	lw s2, -128(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	lw s5, -116(s0)
	lw s6, -112(s0)
	lw s7, -108(s0)
	lw s8, -104(s0)
	lw s9, -100(s0)
	lw s10, -96(s0)
	lw s11, -92(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end61:
	.size emit_aggregate_copy, .Lfunc_end61-emit_aggregate_copy

	.text
	.align 2
	.type emit_addr_sub, @function
emit_addr_sub:
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
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L62_0
	j .L62_1
.L62_0:
	li s1, 87
	sw s1, -16(s0)
	j .L62_2
.L62_1:
	li s1, 6
	sw s1, -16(s0)
.L62_2:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end62:
	.size emit_addr_sub, .Lfunc_end62-emit_addr_sub

	.text
	.align 2
	.type widen_to_addr, @function
widen_to_addr:
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
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L63_0
	j .L63_1
.L63_1:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, val_is_wide
	mv s2, a0
	bnez s2, .L63_2
	j .L63_3
.L63_3:
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
.L63_2:
	li s1, 119
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.L63_0:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, val_is_wide
	mv s2, a0
	bnez s2, .L63_4
	j .L63_5
.L63_4:
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
.L63_5:
	lw s1, -8(s0)
	bnez s1, .L63_6
	j .L63_7
.L63_6:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L63_8
	j .L63_7
.L63_8:
	li s1, 118
	sw s1, -16(s0)
	j .L63_9
.L63_7:
	li s1, 117
	sw s1, -16(s0)
.L63_9:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end63:
	.size widen_to_addr, .Lfunc_end63-widen_to_addr

	.text
	.align 2
	.type emit_addr_scale, @function
emit_addr_scale:
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
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, widen_to_addr
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -12(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L64_0
	j .L64_1
.L64_0:
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
.L64_1:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, emit_addr_const
	mv s2, a0
	sw s2, -24(s0)
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L64_2
	j .L64_3
.L64_2:
	li s1, 88
	sw s1, -32(s0)
	j .L64_4
.L64_3:
	li s1, 7
	sw s1, -32(s0)
.L64_4:
	lw s1, -32(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -28(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -28(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -28(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	lw s2, -28(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end64:
	.size emit_addr_scale, .Lfunc_end64-emit_addr_scale

	.text
	.align 2
	.type lower_addr, @function
lower_addr:
	addi sp, sp, -256
	sw ra, 252(sp)
	sw s0, 248(sp)
	addi s0, sp, 248
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
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_0
	li s1, 31
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_1
	li s1, 29
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_2
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_3
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_4
	li s1, 26
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_5
	j .L65_6
.L65_0:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -16(s0)
	bnez s1, .L65_7
	j .L65_8
.L65_7:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L65_9
	j .L65_10
.L65_9:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_addr_sym
	mv s2, a0
	mv a0, s2
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_10:
	lw s1, -16(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	mv a0, s1
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_8:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_global
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	bnez s1, .L65_11
	j .L65_12
.L65_12:
	la s1, __str_10
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 48
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L65_11:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_addr_sym
	mv s2, a0
	mv a0, s2
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_1:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	mv a0, s2
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_2:
	lw s1, -4(s0)
	addi s2, s0, -28
	addi s3, s0, -32
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, index_operands
	mv s4, a0
	lw s1, -28(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -32(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -28(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -44(s0)
	lw s1, -44(s0)
	mv a0, s1
	jal ra, pointee_size
	mv s2, a0
	sw s2, -48(s0)
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L65_13
	j .L65_14
.L65_13:
	lw s1, -32(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -56(s0)
	j .L65_15
.L65_14:
	lw s1, -32(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -56(s0)
.L65_15:
	lw s1, -56(s0)
	sw s1, -52(s0)
	lw s1, -40(s0)
	lw s2, -52(s0)
	lw s3, -48(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_addr_scale
	mv s4, a0
	sw s4, -60(s0)
	lw s1, -36(s0)
	lw s2, -60(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_addr_add
	mv s3, a0
	mv a0, s3
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_3:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -64(s0)
	lw s1, -64(s0)
	bnez s1, .L65_16
	j .L65_17
.L65_16:
	lw s1, -64(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_18
	j .L65_19
.L65_19:
	lw s1, -64(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_18
	j .L65_17
.L65_18:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -68(s0)
	j .L65_20
.L65_17:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -68(s0)
	lw s1, -64(s0)
	bnez s1, .L65_21
	j .L65_22
.L65_21:
	lw s1, -64(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_23
	j .L65_22
.L65_23:
	lw s1, -64(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -64(s0)
.L65_22:
.L65_20:
	lw s1, -64(s0)
	bnez s1, .L65_24
	j .L65_25
.L65_24:
	lw s1, -64(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L65_26
	j .L65_27
.L65_26:
	lw s1, -64(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L65_25
	j .L65_27
.L65_25:
	la s1, __str_11
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L65_27:
	li s1, 0
	sw s1, -72(s0)
	lw s1, -64(s0)
	lw s2, -4(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -72
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, resolve_member
	mv s4, a0
	sw s4, -76(s0)
	lw s1, -76(s0)
	bnez s1, .L65_28
	j .L65_29
.L65_29:
	la s1, __str_12
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 48
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L65_28:
	lw s1, -72(s0)
	lw s2, -76(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	sw s3, -80(s0)
	lw s1, -80(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L65_30
	j .L65_31
.L65_30:
	lw s1, -68(s0)
	mv a0, s1
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_31:
	lw s1, -68(s0)
	lw s2, -80(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	mv a0, s2
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_4:
	addi s1, s0, -184
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	li s1, 38
	addi s2, s0, -184
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -184
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, compound_lit_local
	mv s2, a0
	addi s1, s0, -184
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	addi s1, s0, -184
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	mv a0, s2
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_5:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -188(s0)
	lw s1, -188(s0)
	bnez s1, .L65_32
	j .L65_33
.L65_32:
	lw s1, -188(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_34
	j .L65_35
.L65_35:
	lw s1, -188(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L65_34
	j .L65_33
.L65_34:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	mv a0, s2
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_33:
	la s1, __str_13
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_6:
	la s1, __str_14
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L65_36:
	li s1, 0
	mv a0, s1
	lw s1, -236(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	lw s4, -224(s0)
	lw s5, -220(s0)
	lw s6, -216(s0)
	lw s7, -212(s0)
	lw s8, -208(s0)
	lw s9, -204(s0)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end65:
	.size lower_addr, .Lfunc_end65-lower_addr

	.text
	.align 2
	.type generic_type_match, @function
generic_type_match:
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
	bnez s1, .L66_0
	j .L66_1
.L66_0:
	lw s1, -8(s0)
	bnez s1, .L66_2
	j .L66_1
.L66_1:
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
.L66_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	lw s3, 0(s1)
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L66_3
	j .L66_4
.L66_3:
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
.L66_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_5
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_6
	li s1, 3
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_7
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_8
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_9
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_10
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_11
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_12
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_13
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_14
	li s1, 15
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_15
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_16
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_17
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_18
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L66_19
	j .L66_20
.L66_5:
.L66_6:
.L66_7:
.L66_8:
.L66_9:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L66_21
	j .L66_22
.L66_21:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L66_23
	j .L66_22
.L66_23:
	li s1, 1
	j .L66_24
.L66_22:
	li s1, 0
.L66_24:
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
.L66_10:
.L66_11:
.L66_12:
.L66_13:
.L66_14:
.L66_15:
	li s1, 1
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
.L66_16:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, generic_type_match
	mv s3, a0
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
.L66_17:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L66_25
	j .L66_26
.L66_26:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L66_25
	j .L66_27
.L66_27:
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L66_25
	j .L66_28
.L66_25:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, generic_type_match
	mv s3, a0
	bnez s3, .L66_29
	j .L66_28
.L66_29:
	li s1, 1
	j .L66_30
.L66_28:
	li s1, 0
.L66_30:
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
.L66_18:
.L66_19:
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L66_31
	j .L66_32
.L66_31:
	lw s1, -8(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L66_33
	j .L66_32
.L66_33:
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
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
.L66_32:
	lw s1, -4(s0)
	lw s2, -8(s0)
	xor s3, s1, s2
	seqz s3, s3
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
.L66_20:
	lw s1, -4(s0)
	lw s2, -8(s0)
	xor s3, s1, s2
	seqz s3, s3
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
.L66_34:
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
.Lfunc_end66:
	.size generic_type_match, .Lfunc_end66-generic_type_match

	.text
	.align 2
	.type generic_select, @function
generic_select:
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
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L67_0
	j .L67_1
.L67_0:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L67_2
	j .L67_1
.L67_2:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	sw s3, -12(s0)
	j .L67_3
.L67_1:
	lw s1, -12(s0)
	bnez s1, .L67_4
	j .L67_5
.L67_4:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L67_6
	j .L67_5
.L67_6:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -12(s0)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	sw s3, -12(s0)
.L67_5:
.L67_3:
	li s1, 0
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
.L67_7:
	lw s1, -24(s0)
	bnez s1, .L67_8
	j .L67_9
.L67_8:
	lw s1, -24(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L67_10
	j .L67_11
.L67_11:
	lw s1, -24(s0)
	sw s1, -16(s0)
	j .L67_12
.L67_10:
	lw s1, -12(s0)
	lw s2, -24(s0)
	li s3, 80
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, generic_type_match
	mv s3, a0
	bnez s3, .L67_13
	j .L67_14
.L67_13:
	lw s1, -20(s0)
	bnez s1, .L67_15
	j .L67_16
.L67_15:
	la s1, __str_15
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L67_16:
	lw s1, -24(s0)
	sw s1, -20(s0)
.L67_14:
.L67_12:
	lw s1, -24(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	j .L67_7
.L67_9:
	lw s1, -20(s0)
	bnez s1, .L67_17
	j .L67_18
.L67_17:
	lw s1, -20(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
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
.L67_18:
	lw s1, -16(s0)
	bnez s1, .L67_19
	j .L67_20
.L67_19:
	lw s1, -16(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
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
.L67_20:
	la s1, __str_16
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
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
.Lfunc_end67:
	.size generic_select, .Lfunc_end67-generic_select

	.text
	.align 2
	.type index_operands, @function
index_operands:
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
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L68_0
	j .L68_1
.L68_0:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L68_2
	j .L68_3
.L68_3:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L68_2
	j .L68_1
.L68_2:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	sw s1, 0(s2)
	j .L68_4
.L68_1:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	sw s1, 0(s2)
.L68_4:
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
.Lfunc_end68:
	.size index_operands, .Lfunc_end68-index_operands

	.text
	.align 2
	.type lvalue_type, @function
lvalue_type:
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
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_0
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_1
	li s1, 31
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_2
	li s1, 29
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_3
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_4
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_5
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_6
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_7
	li s1, 33
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_8
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_9
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_10
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_11
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_12
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_13
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_14
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_15
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_16
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_17
	li s1, 24
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_18
	li s1, 26
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_19
	j .L69_20
.L69_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, generic_select
	mv s2, a0
	mv a0, s2
	jal ra, lvalue_type
	mv s1, a0
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
.L69_1:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L69_21
	j .L69_22
.L69_21:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_22:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_global
	mv s2, a0
	sw s2, -16(s0)
	lw s1, -16(s0)
	bnez s1, .L69_23
	j .L69_24
.L69_23:
	lw s1, -16(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_24:
	jal ra, cc_type_int
	mv s1, a0
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
.L69_2:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L69_25
	j .L69_26
.L69_25:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_27
	j .L69_26
.L69_27:
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_26:
	jal ra, cc_type_int
	mv s1, a0
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
.L69_3:
	lw s1, -4(s0)
	addi s2, s0, -24
	addi s3, s0, -28
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, index_operands
	mv s4, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	bnez s1, .L69_28
	j .L69_29
.L69_28:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_30
	j .L69_31
.L69_31:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_30
	j .L69_29
.L69_30:
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_29:
	jal ra, cc_type_int
	mv s1, a0
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
.L69_4:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -36(s0)
	bnez s1, .L69_32
	j .L69_33
.L69_32:
	lw s1, -36(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_34
	j .L69_33
.L69_34:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
.L69_33:
	lw s1, -36(s0)
	bnez s1, .L69_35
	j .L69_36
.L69_35:
	lw s1, -36(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_37
	j .L69_38
.L69_38:
	lw s1, -36(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_37
	j .L69_36
.L69_37:
	li s1, 0
	sw s1, -40(s0)
	lw s1, -36(s0)
	lw s2, -4(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, resolve_member
	mv s4, a0
	sw s4, -44(s0)
	lw s1, -44(s0)
	bnez s1, .L69_39
	j .L69_40
.L69_39:
	lw s1, -44(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_40:
.L69_36:
	jal ra, cc_type_int
	mv s1, a0
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
.L69_5:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_41
	j .L69_42
.L69_41:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_42:
	jal ra, cc_type_int
	mv s1, a0
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
.L69_6:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_43
	j .L69_44
.L69_43:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -48(s0)
	j .L69_45
.L69_44:
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -48(s0)
.L69_45:
	lw s1, -48(s0)
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
.L69_7:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -52(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -52(s0)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	mv a0, s3
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
.L69_8:
	la s1, lower_arena
	lw s2, 0(s1)
	jal ra, cc_type_void
	mv s1, a0
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	mv a0, s3
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
.L69_9:
.L69_10:
.L69_11:
.L69_12:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
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
.L69_13:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_46
	j .L69_47
.L69_46:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -56(s0)
	j .L69_48
.L69_47:
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -56(s0)
.L69_48:
	lw s1, -56(s0)
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
.L69_14:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_49
	j .L69_50
.L69_49:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -60(s0)
	j .L69_51
.L69_50:
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -60(s0)
.L69_51:
	lw s1, -60(s0)
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
.L69_15:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_52
	j .L69_53
.L69_52:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -64(s0)
	j .L69_54
.L69_53:
	la s1, lower_arena
	lw s2, 0(s1)
	jal ra, cc_type_char
	mv s1, a0
	lw s3, -4(s0)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s5, s3, s4
	mv a0, s2
	mv a1, s1
	mv a2, s5
	jal ra, cc_type_array
	mv s3, a0
	sw s3, -64(s0)
.L69_54:
	lw s1, -64(s0)
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
.L69_16:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
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
.L69_17:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -68(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -72(s0)
	lw s1, -68(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L69_55
	j .L69_56
.L69_56:
	lw s1, -72(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L69_55
	j .L69_57
.L69_55:
	lw s1, -68(s0)
	mv a0, s1
	jal ra, is_double_type
	mv s2, a0
	bnez s2, .L69_58
	j .L69_59
.L69_59:
	lw s1, -72(s0)
	mv a0, s1
	jal ra, is_double_type
	mv s2, a0
	bnez s2, .L69_58
	j .L69_60
.L69_58:
	la s1, lvalue_type.ty_double.0
	sw s1, -76(s0)
	j .L69_61
.L69_60:
	la s1, lvalue_type.ty_float.1
	sw s1, -76(s0)
.L69_61:
	lw s1, -76(s0)
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
.L69_57:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L69_62
	li s2, 82
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L69_63
	li s2, 83
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L69_64
	li s2, 84
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L69_65
	li s2, 85
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L69_66
	li s2, 86
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L69_67
	j .L69_68
.L69_62:
.L69_63:
.L69_64:
.L69_65:
.L69_66:
.L69_67:
	jal ra, cc_type_int
	mv s1, a0
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
.L69_68:
	j .L69_69
.L69_69:
	lw s1, -68(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L69_70
	j .L69_71
.L69_70:
	lw s1, -68(s0)
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
.L69_71:
	lw s1, -72(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L69_72
	j .L69_73
.L69_72:
	lw s1, -72(s0)
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
.L69_73:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 87
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L69_74
	j .L69_75
.L69_75:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L69_74
	j .L69_76
.L69_74:
	lw s1, -68(s0)
	mv a0, s1
	jal ra, cc_type_promote
	mv s2, a0
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
.L69_76:
	lw s1, -68(s0)
	lw s2, -72(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cc_type_usual_arith
	mv s3, a0
	mv a0, s3
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
.L69_18:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -80(s0)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -84(s0)
	lw s1, -80(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L69_77
	j .L69_78
.L69_78:
	lw s1, -84(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L69_77
	j .L69_79
.L69_77:
	lw s1, -80(s0)
	mv a0, s1
	jal ra, is_double_type
	mv s2, a0
	bnez s2, .L69_80
	j .L69_81
.L69_81:
	lw s1, -84(s0)
	mv a0, s1
	jal ra, is_double_type
	mv s2, a0
	bnez s2, .L69_80
	j .L69_82
.L69_80:
	la s1, lvalue_type.ty_double.2
	sw s1, -88(s0)
	j .L69_83
.L69_82:
	la s1, lvalue_type.ty_float.3
	sw s1, -88(s0)
.L69_83:
	lw s1, -88(s0)
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
.L69_79:
	lw s1, -80(s0)
	bnez s1, .L69_84
	j .L69_85
.L69_84:
	lw s1, -80(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_86
	j .L69_85
.L69_86:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -80(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	mv a0, s3
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
.L69_85:
	lw s1, -80(s0)
	bnez s1, .L69_87
	j .L69_88
.L69_87:
	lw s1, -80(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_89
	j .L69_88
.L69_89:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -80(s0)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	mv a0, s3
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
.L69_88:
	lw s1, -84(s0)
	bnez s1, .L69_90
	j .L69_91
.L69_90:
	lw s1, -84(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_92
	j .L69_91
.L69_92:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -84(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	mv a0, s3
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
.L69_91:
	lw s1, -84(s0)
	bnez s1, .L69_93
	j .L69_94
.L69_93:
	lw s1, -84(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_95
	j .L69_94
.L69_95:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -84(s0)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	mv a0, s3
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
.L69_94:
	lw s1, -80(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L69_96
	j .L69_97
.L69_96:
	lw s1, -80(s0)
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
.L69_97:
	lw s1, -84(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L69_98
	j .L69_99
.L69_98:
	lw s1, -84(s0)
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
.L69_99:
	lw s1, -80(s0)
	bnez s1, .L69_100
	j .L69_101
.L69_100:
	lw s1, -84(s0)
	bnez s1, .L69_102
	j .L69_101
.L69_102:
	lw s1, -80(s0)
	mv a0, s1
	jal ra, cc_type_is_arith
	mv s2, a0
	bnez s2, .L69_103
	j .L69_101
.L69_103:
	lw s1, -84(s0)
	mv a0, s1
	jal ra, cc_type_is_arith
	mv s2, a0
	bnez s2, .L69_104
	j .L69_101
.L69_104:
	lw s1, -80(s0)
	lw s2, -84(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cc_type_usual_arith
	mv s3, a0
	mv a0, s3
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
.L69_101:
	lw s1, -80(s0)
	bnez s1, .L69_105
	j .L69_106
.L69_105:
	lw s1, -80(s0)
	sw s1, -92(s0)
	j .L69_107
.L69_106:
	lw s1, -84(s0)
	bnez s1, .L69_108
	j .L69_109
.L69_108:
	lw s1, -84(s0)
	sw s1, -96(s0)
	j .L69_110
.L69_109:
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -96(s0)
.L69_110:
	lw s1, -96(s0)
	sw s1, -92(s0)
.L69_107:
	lw s1, -92(s0)
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
.L69_19:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_111
	j .L69_112
.L69_111:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_17
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L69_113
	j .L69_114
.L69_113:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_115
	j .L69_114
.L69_115:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_114:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_global
	mv s2, a0
	sw s2, -100(s0)
	lw s1, -100(s0)
	bnez s1, .L69_116
	j .L69_117
.L69_116:
	lw s1, -100(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_118
	j .L69_117
.L69_118:
	lw s1, -100(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_119
	j .L69_117
.L69_119:
	lw s1, -100(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_120
	j .L69_117
.L69_120:
	lw s1, -100(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_117:
.L69_112:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -104(s0)
	lw s1, -104(s0)
	bnez s1, .L69_121
	j .L69_122
.L69_121:
	lw s1, -104(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_123
	j .L69_122
.L69_123:
	lw s1, -104(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -104(s0)
.L69_122:
	lw s1, -104(s0)
	bnez s1, .L69_124
	j .L69_125
.L69_124:
	lw s1, -104(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L69_126
	j .L69_125
.L69_126:
	lw s1, -104(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L69_127
	j .L69_125
.L69_127:
	lw s1, -104(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
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
.L69_125:
	jal ra, cc_type_int
	mv s1, a0
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
.L69_20:
	jal ra, cc_type_int
	mv s1, a0
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
.L69_128:
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
.Lfunc_end69:
	.size lvalue_type, .Lfunc_end69-lvalue_type

	.text
	.align 2
	.type fold_lval_addr, @function
fold_lval_addr:
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
	sw a2, -12(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L70_0
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L70_1
	li s1, 29
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L70_2
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L70_3
	li s1, 31
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L70_4
	j .L70_5
.L70_0:
	la s1, lower_arena
	lw t0, 0(s1)
	sw t0, -44(s0)
	lw s1, -4(s0)
	li s3, 48
	add s2, s1, s3
	lw s1, 0(s2)
	lw t0, -44(s0)
	mv a0, t0
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	lw s1, -8(s0)
	sw s2, 0(s1)
	li s1, 1
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
.L70_1:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, compound_lit_global
	mv s3, a0
	mv a0, s2
	mv a1, s3
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -8(s0)
	sw s1, 0(s2)
	li s1, 1
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
.L70_2:
	lw s1, -4(s0)
	addi s2, s0, -20
	addi s3, s0, -24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, index_operands
	mv t0, a0
	sw t0, -48(s0)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	bnez s1, .L70_6
	j .L70_7
.L70_6:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L70_7
	j .L70_8
.L70_7:
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
.L70_8:
	lw s1, -20(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fold_lval_addr
	mv t0, a0
	sw t0, -52(s0)
	lw t0, -52(s0)
	bnez t0, .L70_9
	j .L70_10
.L70_10:
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
.L70_9:
	lw t0, -12(s0)
	sw t0, -56(s0)
	lw t0, -56(s0)
	lw s10, 0(t0)
	lw s11, 4(t0)
	lw s2, -24(s0)
	mv a0, s2
	jal ra, cc_const_eval
	mv s8, a0
	mv s9, a1
	lw s2, -28(s0)
	li s3, 16
	add s1, s2, s3
	lw s2, 0(s1)
	mv a0, s2
	jal ra, cc_type_size
	mv s1, a0
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
	lw t0, -56(s0)
	sw s8, 0(t0)
	sw s9, 4(t0)
	li s1, 1
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
.L70_3:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	bnez s1, .L70_11
	j .L70_12
.L70_11:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L70_13
	j .L70_14
.L70_13:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L70_12
	j .L70_14
.L70_12:
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
.L70_14:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fold_lval_addr
	mv t0, a0
	sw t0, -60(s0)
	lw t0, -60(s0)
	bnez t0, .L70_15
	j .L70_16
.L70_16:
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
.L70_15:
	li s1, 0
	sw s1, -36(s0)
	lw t0, -32(s0)
	sw t0, -64(s0)
	lw s2, -4(s0)
	li s3, 48
	add s1, s2, s3
	lw s2, 0(s1)
	addi s1, s0, -36
	lw t0, -64(s0)
	mv a0, t0
	mv a1, s2
	mv a2, s1
	jal ra, resolve_member
	mv s3, a0
	sw s3, -40(s0)
	lw s1, -40(s0)
	bnez s1, .L70_17
	j .L70_18
.L70_17:
	lw t0, -12(s0)
	sw t0, -68(s0)
	lw t0, -68(s0)
	lw s10, 0(t0)
	lw s11, 4(t0)
	lw t0, -36(s0)
	sw t0, -72(s0)
	lw s3, -40(s0)
	li s1, 8
	add s2, s3, s1
	lw s1, 0(s2)
	lw t0, -72(s0)
	add s2, t0, s1
	mv s8, s2
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	lw t0, -68(s0)
	sw s6, 0(t0)
	sw s7, 4(t0)
	li s1, 1
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
.L70_18:
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
.L70_4:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fold_addr
	mv t0, a0
	sw t0, -76(s0)
	lw t0, -76(s0)
	bnez t0, .L70_19
	j .L70_20
.L70_19:
	li s1, 1
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
.L70_20:
	lw t0, -12(s0)
	sw t0, -80(s0)
	lw t0, -80(s0)
	lw s10, 0(t0)
	lw s11, 4(t0)
	lw s2, -4(s0)
	li s3, 24
	add s1, s2, s3
	lw s2, 0(s1)
	mv a0, s2
	jal ra, cc_const_eval
	mv s8, a0
	mv s9, a1
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	lw t0, -80(s0)
	sw s6, 0(t0)
	sw s7, 4(t0)
	li s1, 1
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
.L70_5:
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
.L70_21:
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
.Lfunc_end70:
	.size fold_lval_addr, .Lfunc_end70-fold_lval_addr

	.text
	.align 2
	.type fold_int_const, @function
fold_int_const:
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
	li s1, 0
	sw s1, -12(s0)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s1, -4(s0)
	addi s2, s0, -12
	addi s3, s0, -24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fold_addr
	mv s4, a0
	bnez s4, .L71_0
	j .L71_1
.L71_0:
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L71_2
	j .L71_1
.L71_2:
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
.L71_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cc_const_eval
	mv s10, a0
	mv s11, a1
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
.Lfunc_end71:
	.size fold_int_const, .Lfunc_end71-fold_int_const

	.text
	.align 2
	.type compound_matches, @function
compound_matches:
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
	bnez s1, .L72_0
	j .L72_1
.L72_0:
	lw s1, -8(s0)
	bnez s1, .L72_2
	j .L72_1
.L72_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	lw s3, 0(s1)
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L72_1
	j .L72_3
.L72_1:
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
.L72_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L72_4
	j .L72_5
.L72_5:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L72_4
	j .L72_6
.L72_4:
	lw s1, -4(s0)
	lw s2, -8(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L72_7
	j .L72_8
.L72_8:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	lw s1, -8(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s3, a0
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L72_7
	j .L72_9
.L72_7:
	li s1, 1
	j .L72_10
.L72_9:
	li s1, 0
.L72_10:
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
.L72_6:
	li s1, 1
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
.Lfunc_end72:
	.size compound_matches, .Lfunc_end72-compound_matches

	.text
	.align 2
	.type compound_lit_local, @function
compound_lit_local:
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
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L73_0
	j .L73_1
.L73_1:
	addi s1, s0, -40
	li s2, 32
	la s3, __str_18
	la s4, compound_counter
	lw s5, 0(s4)
	li s6, 1
	add s7, s5, s6
	sw s7, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s5, 0(sp)
	jal ra, snprintf
	mv s4, a0
	addi sp, sp, 16
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 104
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -44(s0)
	li s1, 17
	lw s2, -44(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	addi s1, s0, -40
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -44(s0)
	li s2, 48
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	mv a0, s1
	jal ra, lower_local_decl
	mv s2, a0
	lw s1, -44(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
.L73_0:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end73:
	.size compound_lit_local, .Lfunc_end73-compound_lit_local

	.text
	.align 2
	.type compound_lit_global, @function
compound_lit_global:
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
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L74_0
	j .L74_1
.L74_1:
	addi s1, s0, -40
	li s2, 32
	la s3, __str_19
	la s4, compound_counter
	lw s5, 0(s4)
	li s6, 1
	add s7, s5, s6
	sw s7, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s5, 0(sp)
	jal ra, snprintf
	mv s4, a0
	addi sp, sp, 16
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 104
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -44(s0)
	li s1, 2
	lw s2, -44(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	addi s1, s0, -40
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -44(s0)
	li s2, 48
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -44(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	mv a0, s1
	jal ra, lower_global_decl
	mv s2, a0
	li s1, 1
	la s2, cur_prog
	lw s3, 0(s2)
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -44(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
.L74_0:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end74:
	.size compound_lit_global, .Lfunc_end74-compound_lit_global

	.text
	.align 2
	.type fold_addr, @function
fold_addr:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_0
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_1
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_2
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_3
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_4
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_5
	j .L75_6
.L75_0:
	lw s1, -4(s0)
	li s2, 72
	add s3, s1, s2
	lw t0, 0(s3)
	sw t0, -52(s0)
	lw s2, -4(s0)
	li s3, 76
	add s1, s2, s3
	lw s2, 0(s1)
	lw t0, -52(s0)
	mv a0, t0
	mv a1, s2
	jal ra, emit_string_global
	mv s1, a0
	lw s2, -8(s0)
	sw s1, 0(s2)
	li s1, 1
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L75_7
	j .L75_8
.L75_7:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_9
	j .L75_10
.L75_10:
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_9
	j .L75_8
.L75_9:
	la s1, lower_arena
	lw t0, 0(s1)
	sw t0, -56(s0)
	lw s1, -4(s0)
	li s3, 48
	add s2, s1, s3
	lw s1, 0(s2)
	lw t0, -56(s0)
	mv a0, t0
	mv a1, s1
	jal ra, arena_strdup
	mv s2, a0
	lw s1, -8(s0)
	sw s2, 0(s1)
	li s1, 1
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_8:
	li s1, 0
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_2:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fold_lval_addr
	mv t0, a0
	sw t0, -60(s0)
	lw t0, -60(s0)
	mv a0, t0
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_3:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, compound_lit_global
	mv s3, a0
	mv a0, s2
	mv a1, s3
	jal ra, arena_strdup
	mv s1, a0
	lw s2, -8(s0)
	sw s1, 0(s2)
	li s1, 1
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_4:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fold_addr
	mv t0, a0
	sw t0, -64(s0)
	lw t0, -64(s0)
	mv a0, t0
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_5:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L75_11
	j .L75_12
.L75_12:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L75_11
	j .L75_13
.L75_11:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	lw s1, -24(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	bnez s1, .L75_14
	j .L75_15
.L75_14:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L75_16
	j .L75_17
.L75_16:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L75_15
	j .L75_17
.L75_15:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L75_18
	j .L75_19
.L75_18:
	li s1, 0
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_19:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	lw s1, -24(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	bnez s1, .L75_20
	j .L75_21
.L75_20:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L75_22
	j .L75_23
.L75_22:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L75_21
	j .L75_23
.L75_21:
	li s1, 0
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_23:
.L75_17:
	lw s1, -24(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fold_addr
	mv t0, a0
	sw t0, -68(s0)
	lw t0, -68(s0)
	bnez t0, .L75_24
	j .L75_25
.L75_25:
	li s1, 0
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_24:
	lw s1, -28(s0)
	mv a0, s1
	jal ra, cc_const_eval
	mv s10, a0
	mv s11, a1
	sw s10, -40(s0)
	sw s11, -36(s0)
	lw t0, -12(s0)
	sw t0, -72(s0)
	lw t0, -72(s0)
	lw s10, 0(t0)
	lw s11, 4(t0)
	lw s2, -4(s0)
	li s3, 4
	add s1, s2, s3
	lw s2, 0(s1)
	li s1, 69
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L75_26
	j .L75_27
.L75_26:
	lw s8, -40(s0)
	lw s9, -36(s0)
	sw s8, -48(s0)
	sw s9, -44(s0)
	j .L75_28
.L75_27:
	lw s8, -40(s0)
	lw s9, -36(s0)
	neg s6, s8
	snez t0, s8
	neg s7, s9
	sub s7, s7, t0
	sw s6, -48(s0)
	sw s7, -44(s0)
.L75_28:
	lw s8, -48(s0)
	lw s9, -44(s0)
	lw s1, -32(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	mv s6, s2
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
	lw t0, -72(s0)
	sw s8, 0(t0)
	sw s9, 4(t0)
	li s1, 1
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_13:
	li s1, 0
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_6:
	li s1, 0
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L75_29:
	li s1, 0
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end75:
	.size fold_addr, .Lfunc_end75-fold_addr

	.text
	.align 2
	.type member_field, @function
member_field:
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
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L76_0
	j .L76_1
.L76_0:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L76_2
	j .L76_1
.L76_2:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L76_1:
	lw s1, -12(s0)
	bnez s1, .L76_3
	j .L76_4
.L76_3:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L76_5
	j .L76_6
.L76_5:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L76_4
	j .L76_6
.L76_4:
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
.L76_6:
	li s1, 0
	sw s1, -16(s0)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, resolve_member
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
.Lfunc_end76:
	.size member_field, .Lfunc_end76-member_field

	.text
	.align 2
	.type emit_shift, @function
emit_shift:
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
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L77_0
	j .L77_1
.L77_0:
	lw s1, -8(s0)
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
.L77_1:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -24(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -24(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	lw s2, -24(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end77:
	.size emit_shift, .Lfunc_end77-emit_shift

	.text
	.align 2
	.type emit_and_const, @function
emit_and_const:
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
	jal ra, lower_const
	mv s2, a0
	sw s2, -12(s0)
	li s1, 12
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -16(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end78:
	.size emit_and_const, .Lfunc_end78-emit_and_const

	.text
	.align 2
	.type narrow_to, @function
narrow_to:
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
	bnez s1, .L79_0
	j .L79_1
.L79_0:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L79_1
	j .L79_2
.L79_2:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L79_1
	j .L79_3
.L79_1:
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
.L79_3:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 8
	mul s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L79_4
	j .L79_5
.L79_5:
	lw s1, -12(s0)
	li s2, 32
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L79_4
	j .L79_6
.L79_4:
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
.L79_6:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L79_7
	j .L79_8
.L79_7:
	lw s1, -4(s0)
	li s2, 1
	lw s3, -12(s0)
	sll s4, s2, s3
	li s2, 1
	sub s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, emit_and_const
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
.L79_8:
	li s1, 15
	lw s2, -4(s0)
	li s3, 32
	lw s4, -12(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, emit_shift
	mv s3, a0
	sw s3, -4(s0)
	li s1, 16
	lw s2, -4(s0)
	li s3, 32
	lw s4, -12(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, emit_shift
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
.Lfunc_end79:
	.size narrow_to, .Lfunc_end79-narrow_to

	.text
	.align 2
	.type to_bool, @function
to_bool:
	addi sp, sp, -208
	sw ra, 204(sp)
	sw s0, 200(sp)
	addi s0, sp, 200
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
	fsd fs0, 48(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L80_0
	j .L80_1
.L80_0:
	addi s1, s0, -120
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	li s1, 40
	addi s2, s0, -120
	sw s1, 0(s2)
	la s1, __flt_20
	fld fs0, 0(s1)
	addi s1, s0, -120
	li s2, 64
	add s3, s1, s2
	fsd fs0, 0(s3)
	lw s1, -8(s0)
	addi s2, s0, -120
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -120
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -124(s0)
	li s1, 66
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -124(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -128(s0)
	li s1, 0
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -132(s0)
	li s1, 31
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -128(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -132(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -196(s0)
	lw s2, -192(s0)
	lw s3, -188(s0)
	lw s4, -184(s0)
	lw s5, -180(s0)
	lw s6, -176(s0)
	lw s7, -172(s0)
	lw s8, -168(s0)
	lw s9, -164(s0)
	lw s10, -160(s0)
	lw s11, -156(s0)
	fld fs0, -152(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L80_1:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L80_2
	j .L80_3
.L80_2:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
	jal ra, lower_const64
	mv s1, a0
	sw s1, -136(s0)
	li s1, 101
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -136(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -196(s0)
	lw s2, -192(s0)
	lw s3, -188(s0)
	lw s4, -184(s0)
	lw s5, -180(s0)
	lw s6, -176(s0)
	lw s7, -172(s0)
	lw s8, -168(s0)
	lw s9, -164(s0)
	lw s10, -160(s0)
	lw s11, -156(s0)
	fld fs0, -152(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L80_3:
	li s1, 0
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -140(s0)
	li s1, 32
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -140(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -196(s0)
	lw s2, -192(s0)
	lw s3, -188(s0)
	lw s4, -184(s0)
	lw s5, -180(s0)
	lw s6, -176(s0)
	lw s7, -172(s0)
	lw s8, -168(s0)
	lw s9, -164(s0)
	lw s10, -160(s0)
	lw s11, -156(s0)
	fld fs0, -152(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end80:
	.size to_bool, .Lfunc_end80-to_bool

	.text
	.align 2
	.type lower_bitfield_read, @function
lower_bitfield_read:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 8
	mul s3, s2, s1
	sw s3, -12(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	sw s3, -16(s0)
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L81_0
	j .L81_1
.L81_0:
	li s1, 17
	lw s2, -16(s0)
	lw s3, -8(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_shift
	mv s4, a0
	sw s4, -20(s0)
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L81_2
	j .L81_3
.L81_2:
	lw s1, -20(s0)
	li s2, 1
	lw s3, -8(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	sll s4, s2, s3
	li s2, 1
	sub s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, emit_and_const
	mv s2, a0
	sw s2, -20(s0)
.L81_3:
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
.L81_1:
	li s1, 15
	lw s2, -16(s0)
	lw s3, -12(s0)
	lw s4, -8(s0)
	li s5, 16
	add s6, s4, s5
	lw s4, 0(s6)
	sub s5, s3, s4
	lw s3, -8(s0)
	li s4, 12
	add s6, s3, s4
	lw s3, 0(s6)
	sub s4, s5, s3
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, emit_shift
	mv s3, a0
	sw s3, -24(s0)
	li s1, 16
	lw s2, -24(s0)
	lw s3, -12(s0)
	lw s4, -8(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, emit_shift
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
.Lfunc_end81:
	.size lower_bitfield_read, .Lfunc_end81-lower_bitfield_read

	.text
	.align 2
	.type lower_bitfield_write, @function
lower_bitfield_write:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 8
	mul s3, s2, s1
	sw s3, -20(s0)
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L82_0
	j .L82_1
.L82_0:
	li s1, 0
	not s2, s1
	sw s2, -28(s0)
	j .L82_2
.L82_1:
	li s1, 1
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	sll s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	sw s2, -28(s0)
.L82_2:
	lw s1, -28(s0)
	sw s1, -24(s0)
	lw s1, -12(s0)
	sw s1, -32(s0)
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L82_3
	j .L82_4
.L82_3:
	lw s1, -32(s0)
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_and_const
	mv s3, a0
	sw s3, -32(s0)
.L82_4:
	li s1, 15
	lw s2, -32(s0)
	lw s3, -8(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_shift
	mv s4, a0
	sw s4, -32(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -36(s0)
	lw s2, -24(s0)
	lw s3, -8(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	sll s4, s2, s3
	not s2, s4
	mv a0, s1
	mv a1, s2
	jal ra, emit_and_const
	mv s3, a0
	sw s3, -40(s0)
	li s1, 13
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -44(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -44(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -40(s0)
	lw s2, -44(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -44(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -44(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -8(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
	lw s1, -12(s0)
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
.Lfunc_end82:
	.size lower_bitfield_write, .Lfunc_end82-lower_bitfield_write

	.text
	.align 2
	.type emit_compound_int, @function
emit_compound_int:
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
	lw s1, -16(s0)
	bnez s1, .L83_0
	j .L83_1
.L83_0:
	lw s1, -16(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L83_2
	j .L83_1
.L83_2:
	li s1, 1
	j .L83_3
.L83_1:
	li s1, 0
.L83_3:
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 59
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_4
	li s2, 60
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_5
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_6
	li s2, 62
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_7
	li s2, 63
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_8
	li s2, 64
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_9
	li s2, 65
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_10
	li s2, 66
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_11
	li s2, 67
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_12
	li s2, 68
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L83_13
	j .L83_14
.L83_4:
	li s1, 5
	sw s1, -24(s0)
	j .L83_15
.L83_5:
	li s1, 6
	sw s1, -24(s0)
	j .L83_15
.L83_6:
	li s1, 7
	sw s1, -24(s0)
	j .L83_15
.L83_7:
	lw s1, -20(s0)
	bnez s1, .L83_16
	j .L83_17
.L83_16:
	li s1, 9
	sw s1, -28(s0)
	j .L83_18
.L83_17:
	li s1, 8
	sw s1, -28(s0)
.L83_18:
	lw s1, -28(s0)
	sw s1, -24(s0)
	j .L83_15
.L83_8:
	lw s1, -20(s0)
	bnez s1, .L83_19
	j .L83_20
.L83_19:
	li s1, 11
	sw s1, -32(s0)
	j .L83_21
.L83_20:
	li s1, 10
	sw s1, -32(s0)
.L83_21:
	lw s1, -32(s0)
	sw s1, -24(s0)
	j .L83_15
.L83_9:
	li s1, 12
	sw s1, -24(s0)
	j .L83_15
.L83_10:
	li s1, 13
	sw s1, -24(s0)
	j .L83_15
.L83_11:
	li s1, 14
	sw s1, -24(s0)
	j .L83_15
.L83_12:
	li s1, 15
	sw s1, -24(s0)
	j .L83_15
.L83_13:
	lw s1, -20(s0)
	bnez s1, .L83_22
	j .L83_23
.L83_22:
	li s1, 17
	sw s1, -36(s0)
	j .L83_24
.L83_23:
	li s1, 16
	sw s1, -36(s0)
.L83_24:
	lw s1, -36(s0)
	sw s1, -24(s0)
	j .L83_15
.L83_14:
	la s1, __str_21
	lw s2, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 1
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
.L83_15:
	lw s1, -24(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -40(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -40(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -40(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -40(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -40(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end83:
	.size emit_compound_int, .Lfunc_end83-emit_compound_int

	.text
	.align 2
	.type lower_expr, @function
lower_expr:
	addi sp, sp, -1920
	sw ra, 1916(sp)
	sw s0, 1912(sp)
	addi s0, sp, 1912
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
	fsd fs0, 48(sp)
	fsd fs1, 56(sp)
	sw a0, -4(s0)
	lw s1, -4(s0)
	bnez s1, .L84_0
	j .L84_1
.L84_1:
	la s1, __str_22
	mv a0, s1
	jal ra, die
	mv s2, a0
.L84_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_2
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_3
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_4
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_5
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_6
	li s1, 31
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_7
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_8
	li s1, 33
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_9
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_10
	li s1, 29
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_11
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_12
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_13
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_14
	li s1, 22
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_15
	li s1, 23
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_16
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_17
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_18
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_19
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_20
	li s1, 24
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_21
	li s1, 25
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_22
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_23
	li s1, 28
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_24
	li s1, 26
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_25
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_26
	j .L84_27
.L84_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, generic_select
	mv s2, a0
	mv a0, s2
	jal ra, lower_expr
	mv s1, a0
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_3:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_28
	j .L84_29
.L84_28:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_30
	j .L84_29
.L84_30:
	lw s1, -4(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv a0, s10
	mv a1, s11
	jal ra, lower_const64
	mv s1, a0
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_29:
	lw s1, -4(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_4:
	addi s1, s0, -48
	li s2, 32
	la s3, __str_23
	la s4, str_counter
	lw s5, 0(s4)
	li s6, 1
	add s7, s5, s6
	sw s7, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s5, 0(sp)
	jal ra, snprintf
	mv s4, a0
	addi sp, sp, 16
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 68
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -52(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	addi s1, s0, -48
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -52(s0)
	sw s3, 0(s1)
	li s1, 1
	lw s2, -52(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -52(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_31
	j .L84_32
.L84_31:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_33
	j .L84_32
.L84_33:
	li s1, 1
	j .L84_34
.L84_32:
	li s1, 0
.L84_34:
	sw s1, -56(s0)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_35
	j .L84_36
.L84_35:
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_37
	j .L84_36
.L84_37:
	li s1, 1
	j .L84_38
.L84_36:
	li s1, 0
.L84_38:
	sw s1, -60(s0)
	lw s1, -56(s0)
	bnez s1, .L84_39
	j .L84_40
.L84_39:
	li s1, 3
	lw s2, -52(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	jal ra, double_to_half
	mv s1, a0
	addi sp, sp, 16
	li s2, 16
	sll s3, s1, s2
	li s1, 16
	sra s2, s3, s1
	lw s1, -52(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 0
	li s4, 8
	mul s5, s3, s4
	add s3, s1, s5
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s3)
	sw s11, 4(s3)
	j .L84_41
.L84_40:
	lw s1, -60(s0)
	bnez s1, .L84_42
	j .L84_43
.L84_42:
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	fcvt.s.d fs1, fs0
	addi s1, s0, -64
	fsw fs1, 0(s1)
	li s1, 6
	lw s2, -52(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -64
	lw s2, 0(s1)
	lw s1, -52(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 0
	li s4, 8
	mul s5, s3, s4
	add s3, s1, s5
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s3)
	sw s11, 4(s3)
	j .L84_44
.L84_43:
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	addi s1, s0, -72
	fsd fs0, 0(s1)
	li s1, 4
	lw s2, -52(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -52(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
.L84_44:
.L84_41:
	li s1, 1
	lw s2, -52(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, cur_prog
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -52(s0)
	li s3, 64
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -52(s0)
	la s2, cur_prog
	lw s3, 0(s2)
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -48
	mv a0, s1
	jal ra, emit_addr_sym
	mv s2, a0
	sw s2, -76(s0)
	lw s1, -56(s0)
	bnez s1, .L84_45
	j .L84_46
.L84_45:
	li s1, 78
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	j .L84_47
.L84_46:
	li s1, 75
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -60(s0)
	bnez s1, .L84_48
	j .L84_49
.L84_48:
	li s1, 4
	sw s1, -80(s0)
	j .L84_50
.L84_49:
	li s1, 0
	sw s1, -80(s0)
.L84_50:
	lw s1, -80(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_47:
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -76(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_5:
	lw s1, -4(s0)
	li s2, 72
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 76
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, emit_string_literal
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_6:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_24
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L84_51
	j .L84_52
.L84_51:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	bnez s2, .L84_52
	j .L84_53
.L84_53:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_global
	mv s2, a0
	bnez s2, .L84_52
	j .L84_54
.L84_54:
	la s1, cur_fn_name
	lw s2, 0(s1)
	bnez s2, .L84_55
	j .L84_56
.L84_55:
	la s1, cur_fn_name
	lw s2, 0(s1)
	sw s2, -88(s0)
	j .L84_57
.L84_56:
	la s1, __str_25
	sw s1, -88(s0)
.L84_57:
	lw s1, -88(s0)
	sw s1, -84(s0)
	lw s1, -84(s0)
	lw s2, -84(s0)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_string_literal
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_52:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -92(s0)
	lw s1, -92(s0)
	bnez s1, .L84_58
	j .L84_59
.L84_58:
	lw s1, -92(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_60
	j .L84_61
.L84_60:
	lw s1, -92(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -96(s0)
	lw s1, -92(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_addr_sym
	mv s2, a0
	sw s2, -100(s0)
	lw s1, -96(s0)
	bnez s1, .L84_62
	j .L84_63
.L84_62:
	lw s1, -96(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_64
	j .L84_65
.L84_65:
	lw s1, -96(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_64
	j .L84_66
.L84_66:
	lw s1, -96(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_64
	j .L84_63
.L84_64:
	lw s1, -100(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_63:
	lw s1, -100(s0)
	lw s2, -96(s0)
	bnez s2, .L84_67
	j .L84_68
.L84_67:
	lw s2, -96(s0)
	sw s2, -104(s0)
	j .L84_69
.L84_68:
	jal ra, cc_type_int
	mv s2, a0
	sw s2, -104(s0)
.L84_69:
	lw s2, -104(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_61:
	lw s1, -92(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -108(s0)
	lw s1, -108(s0)
	bnez s1, .L84_70
	j .L84_71
.L84_70:
	lw s1, -108(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_72
	j .L84_73
.L84_73:
	lw s1, -108(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_72
	j .L84_74
.L84_74:
	lw s1, -108(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_72
	j .L84_71
.L84_72:
	lw s1, -92(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_71:
	lw s1, -108(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_75
	j .L84_76
.L84_75:
	li s1, 80
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -92(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -108(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_76:
	lw s1, -108(s0)
	mv a0, s1
	jal ra, val_is_wide
	mv s2, a0
	bnez s2, .L84_77
	j .L84_78
.L84_77:
	li s1, 112
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -92(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_78:
	lw s1, -108(s0)
	bnez s1, .L84_79
	j .L84_80
.L84_79:
	lw s1, -108(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -112(s0)
	lw s1, -112(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_81
	j .L84_82
.L84_82:
	lw s1, -112(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_81
	j .L84_83
.L84_81:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	lw s1, -108(s0)
	mv a0, s2
	mv a1, s1
	jal ra, emit_load
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_83:
.L84_80:
	li s1, 28
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -92(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_59:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_global
	mv s2, a0
	sw s2, -116(s0)
	lw s1, -116(s0)
	bnez s1, .L84_84
	j .L84_85
.L84_85:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	jal ra, cc_type_int
	mv s2, a0
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, add_global
	mv s4, a0
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_global
	mv s2, a0
	sw s2, -116(s0)
.L84_84:
	lw s1, -116(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_86
	j .L84_87
.L84_87:
	lw s1, -116(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_88
	j .L84_89
.L84_88:
	lw s1, -116(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_86
	j .L84_90
.L84_90:
	lw s1, -116(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_86
	j .L84_91
.L84_91:
	lw s1, -116(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_86
	j .L84_92
.L84_92:
	lw s1, -116(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_86
	j .L84_89
.L84_86:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_addr_sym
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_89:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_addr_sym
	mv s2, a0
	sw s2, -120(s0)
	lw s1, -120(s0)
	lw s2, -116(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	bnez s2, .L84_93
	j .L84_94
.L84_93:
	lw s2, -116(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	sw s2, -124(s0)
	j .L84_95
.L84_94:
	jal ra, cc_type_int
	mv s2, a0
	sw s2, -124(s0)
.L84_95:
	lw s2, -124(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_7:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -128(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -132(s0)
	lw s1, -132(s0)
	bnez s1, .L84_96
	j .L84_97
.L84_96:
	lw s1, -132(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_98
	j .L84_97
.L84_98:
	lw s1, -132(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -140(s0)
	j .L84_99
.L84_97:
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -140(s0)
.L84_99:
	lw s1, -140(s0)
	sw s1, -136(s0)
	lw s1, -136(s0)
	bnez s1, .L84_100
	j .L84_101
.L84_100:
	lw s1, -136(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_102
	j .L84_103
.L84_103:
	lw s1, -136(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_102
	j .L84_104
.L84_104:
	lw s1, -136(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_102
	j .L84_101
.L84_102:
	lw s1, -128(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_101:
	lw s1, -128(s0)
	lw s2, -136(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_8:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_9:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_105
	j .L84_106
.L84_105:
	li s1, 139
	sw s1, -148(s0)
	j .L84_107
.L84_106:
	li s1, 137
	sw s1, -148(s0)
.L84_107:
	lw s1, -148(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -144(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -144(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, get_named_label
	mv s2, a0
	lw s1, -144(s0)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -144(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_10:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -152(s0)
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -156(s0)
	lw s1, -156(s0)
	bnez s1, .L84_108
	j .L84_109
.L84_108:
	lw s1, -156(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_110
	j .L84_111
.L84_111:
	lw s1, -156(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_110
	j .L84_112
.L84_112:
	lw s1, -156(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_110
	j .L84_109
.L84_110:
	lw s1, -152(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_109:
	lw s1, -152(s0)
	lw s2, -156(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_11:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -160(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -164(s0)
	lw s1, -164(s0)
	bnez s1, .L84_113
	j .L84_114
.L84_113:
	lw s1, -164(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_115
	j .L84_116
.L84_116:
	lw s1, -164(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_115
	j .L84_117
.L84_117:
	lw s1, -164(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_115
	j .L84_114
.L84_115:
	lw s1, -160(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_114:
	lw s1, -160(s0)
	lw s2, -164(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_12:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, member_field
	mv s2, a0
	sw s2, -168(s0)
	lw s1, -168(s0)
	bnez s1, .L84_118
	j .L84_119
.L84_118:
	lw s1, -168(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L84_120
	j .L84_119
.L84_120:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	lw s1, -168(s0)
	mv a0, s2
	mv a1, s1
	jal ra, lower_bitfield_read
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_119:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -172(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -176(s0)
	lw s1, -176(s0)
	bnez s1, .L84_121
	j .L84_122
.L84_121:
	lw s1, -176(s0)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_123
	j .L84_124
.L84_124:
	lw s1, -176(s0)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_123
	j .L84_125
.L84_125:
	lw s1, -176(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_123
	j .L84_122
.L84_123:
	lw s1, -172(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_122:
	lw s1, -172(s0)
	lw s2, -176(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_13:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -180(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -184(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_126
	li s2, 77
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_127
	li s2, 78
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_128
	j .L84_129
.L84_126:
	lw s1, -184(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_130
	j .L84_131
.L84_130:
	li s1, 63
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -180(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -184(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_131:
	lw s1, -184(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_132
	j .L84_133
.L84_132:
	li s1, 99
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -180(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_133:
	li s1, 18
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -180(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_127:
	lw s1, -184(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_134
	j .L84_135
.L84_134:
	li s1, 1
	neg s2, s1
	mv s10, s2
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
	jal ra, lower_const64
	mv s1, a0
	sw s1, -188(s0)
	li s1, 95
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -180(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -188(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_135:
	li s1, 19
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -180(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_128:
	lw s1, -184(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_136
	j .L84_137
.L84_136:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
	jal ra, lower_const64
	mv s1, a0
	sw s1, -192(s0)
	li s1, 100
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -180(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -192(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	j .L84_138
.L84_137:
	li s1, 0
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -196(s0)
	li s1, 31
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -180(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -196(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_138:
.L84_129:
	la s1, __str_26
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_139:
.L84_14:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 79
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_140
	j .L84_141
.L84_141:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 80
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_140
	j .L84_142
.L84_140:
	jal ra, new_label
	mv s1, a0
	sw s1, -200(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -204(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -208(s0)
	jal ra, new_temp
	mv s1, a0
	sw s1, -212(s0)
	lw s1, -4(s0)
	lw s2, -200(s0)
	lw s3, -204(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	lw s1, -200(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	li s1, 1
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -212(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -208(s0)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	lw s1, -204(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	li s1, 1
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -212(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -208(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -212(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_142:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -216(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -220(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_143
	j .L84_144
.L84_144:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_143
	j .L84_145
.L84_143:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -224(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -228(s0)
	lw s1, -224(s0)
	bnez s1, .L84_146
	j .L84_147
.L84_146:
	lw s1, -224(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L84_148
	j .L84_147
.L84_148:
	li s1, 1
	j .L84_149
.L84_147:
	li s1, 0
.L84_149:
	sw s1, -232(s0)
	lw s1, -228(s0)
	bnez s1, .L84_150
	j .L84_151
.L84_150:
	lw s1, -228(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L84_152
	j .L84_151
.L84_152:
	li s1, 1
	j .L84_153
.L84_151:
	li s1, 0
.L84_153:
	sw s1, -236(s0)
	lw s1, -232(s0)
	bnez s1, .L84_154
	j .L84_155
.L84_154:
	lw s1, -236(s0)
	bnez s1, .L84_156
	j .L84_155
.L84_156:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_157
	j .L84_155
.L84_157:
	lw s1, -216(s0)
	lw s2, -220(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_addr_sub
	mv s3, a0
	sw s3, -240(s0)
	lw s1, -224(s0)
	mv a0, s1
	jal ra, pointee_size
	mv s2, a0
	sw s2, -244(s0)
	lw s1, -244(s0)
	li s2, 1
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L84_158
	j .L84_159
.L84_158:
	lw s1, -240(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_159:
	lw s1, -240(s0)
	sw s1, -248(s0)
	lw s1, -244(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -252(s0)
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_160
	j .L84_161
.L84_160:
	li s1, 119
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -240(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -248(s0)
.L84_161:
	li s1, 8
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -248(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -252(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -256(s0)
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_162
	j .L84_163
.L84_162:
	li s1, 117
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -256(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -256(s0)
.L84_163:
	lw s1, -256(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_155:
	lw s1, -232(s0)
	bnez s1, .L84_164
	j .L84_165
.L84_164:
	lw s1, -236(s0)
	bnez s1, .L84_165
	j .L84_166
.L84_166:
	lw s1, -220(s0)
	lw s2, -228(s0)
	lw s3, -224(s0)
	mv a0, s3
	jal ra, pointee_size
	mv s4, a0
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, emit_addr_scale
	mv s3, a0
	sw s3, -260(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_167
	j .L84_168
.L84_167:
	lw s1, -216(s0)
	lw s2, -260(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_addr_add
	mv s3, a0
	sw s3, -264(s0)
	j .L84_169
.L84_168:
	lw s1, -216(s0)
	lw s2, -260(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_addr_sub
	mv s3, a0
	sw s3, -264(s0)
.L84_169:
	lw s1, -264(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_165:
	lw s1, -236(s0)
	bnez s1, .L84_170
	j .L84_171
.L84_170:
	lw s1, -232(s0)
	bnez s1, .L84_171
	j .L84_172
.L84_172:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_173
	j .L84_171
.L84_173:
	lw s1, -216(s0)
	lw s2, -224(s0)
	lw s3, -228(s0)
	mv a0, s3
	jal ra, pointee_size
	mv s4, a0
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, emit_addr_scale
	mv s3, a0
	sw s3, -268(s0)
	lw s1, -220(s0)
	lw s2, -268(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_addr_add
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_171:
.L84_145:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -272(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -276(s0)
	lw s1, -272(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_174
	j .L84_175
.L84_175:
	lw s1, -276(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_174
	j .L84_176
.L84_174:
	li s1, 1
	j .L84_177
.L84_176:
	li s1, 0
.L84_177:
	sw s1, -280(s0)
	lw s1, -280(s0)
	bnez s1, .L84_178
	j .L84_179
.L84_178:
	lw s1, -272(s0)
	mv a0, s1
	jal ra, is_double_type
	mv s2, a0
	bnez s2, .L84_180
	j .L84_181
.L84_181:
	lw s1, -276(s0)
	mv a0, s1
	jal ra, is_double_type
	mv s2, a0
	bnez s2, .L84_180
	j .L84_182
.L84_180:
	li s1, 1
	j .L84_183
.L84_182:
	li s1, 0
.L84_183:
	sw s1, -284(s0)
	lw s1, -284(s0)
	bnez s1, .L84_184
	j .L84_185
.L84_184:
	li s1, 0
	sw s1, -292(s0)
	j .L84_186
.L84_185:
	li s1, 4
	sw s1, -292(s0)
.L84_186:
	lw s1, -292(s0)
	sw s1, -288(s0)
	lw s1, -272(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_187
	j .L84_188
.L84_188:
	li s1, 69
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -288(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -216(s0)
	j .L84_189
.L84_187:
	lw s1, -272(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_190
	j .L84_191
.L84_190:
	lw s1, -284(s0)
	bnez s1, .L84_192
	j .L84_191
.L84_192:
	li s1, 72
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -216(s0)
.L84_191:
.L84_189:
	lw s1, -276(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_193
	j .L84_194
.L84_194:
	li s1, 69
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -288(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -220(s0)
	j .L84_195
.L84_193:
	lw s1, -276(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_196
	j .L84_197
.L84_196:
	lw s1, -284(s0)
	bnez s1, .L84_198
	j .L84_197
.L84_198:
	li s1, 72
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -220(s0)
.L84_197:
.L84_195:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_199
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_200
	li s2, 71
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_201
	li s2, 72
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_202
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_203
	li s2, 83
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_204
	li s2, 84
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_205
	li s2, 85
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_206
	li s2, 86
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_207
	li s2, 82
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_208
	j .L84_209
.L84_199:
	li s1, 59
	sw s1, -296(s0)
	j .L84_210
.L84_200:
	li s1, 60
	sw s1, -296(s0)
	j .L84_210
.L84_201:
	li s1, 61
	sw s1, -296(s0)
	j .L84_210
.L84_202:
	li s1, 62
	sw s1, -296(s0)
	j .L84_210
.L84_203:
	li s1, 66
	sw s1, -296(s0)
	j .L84_210
.L84_204:
	li s1, 67
	sw s1, -296(s0)
	j .L84_210
.L84_205:
	li s1, 68
	sw s1, -296(s0)
	j .L84_210
.L84_206:
	lw s1, -216(s0)
	sw s1, -300(s0)
	lw s1, -220(s0)
	sw s1, -216(s0)
	lw s1, -300(s0)
	sw s1, -220(s0)
	li s1, 67
	sw s1, -296(s0)
	j .L84_210
.L84_207:
	lw s1, -216(s0)
	sw s1, -304(s0)
	lw s1, -220(s0)
	sw s1, -216(s0)
	lw s1, -304(s0)
	sw s1, -220(s0)
	li s1, 68
	sw s1, -296(s0)
	j .L84_210
.L84_208:
	li s1, 66
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -288(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -308(s0)
	li s1, 0
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -312(s0)
	li s1, 31
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -308(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -312(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_209:
	la s1, __str_27
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_210:
	lw s1, -296(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -288(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_179:
	lw s1, -272(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_211
	j .L84_212
.L84_212:
	lw s1, -276(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_211
	j .L84_213
.L84_211:
	li s1, 1
	j .L84_214
.L84_213:
	li s1, 0
.L84_214:
	sw s1, -316(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 87
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_215
	j .L84_216
.L84_216:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_215
	j .L84_217
.L84_215:
	li s1, 1
	j .L84_218
.L84_217:
	li s1, 0
.L84_218:
	sw s1, -320(s0)
	lw s1, -316(s0)
	bnez s1, .L84_219
	j .L84_220
.L84_219:
	lw s1, -272(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_221
	j .L84_222
.L84_222:
	lw s1, -272(s0)
	bnez s1, .L84_223
	j .L84_224
.L84_223:
	lw s1, -272(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_225
	j .L84_224
.L84_225:
	li s1, 118
	sw s1, -324(s0)
	j .L84_226
.L84_224:
	li s1, 117
	sw s1, -324(s0)
.L84_226:
	lw s1, -324(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -216(s0)
.L84_221:
	lw s1, -320(s0)
	bnez s1, .L84_227
	j .L84_228
.L84_228:
	lw s1, -276(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_227
	j .L84_229
.L84_229:
	lw s1, -276(s0)
	bnez s1, .L84_230
	j .L84_231
.L84_230:
	lw s1, -276(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_232
	j .L84_231
.L84_232:
	li s1, 118
	sw s1, -328(s0)
	j .L84_233
.L84_231:
	li s1, 117
	sw s1, -328(s0)
.L84_233:
	lw s1, -328(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -220(s0)
.L84_227:
	lw s1, -320(s0)
	bnez s1, .L84_234
	j .L84_235
.L84_234:
	lw s1, -272(s0)
	mv a0, s1
	jal ra, cc_type_promote
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -336(s0)
	j .L84_236
.L84_235:
	lw s1, -272(s0)
	lw s2, -276(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cc_type_usual_arith
	mv s3, a0
	li s1, 4
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -336(s0)
.L84_236:
	lw s1, -336(s0)
	sw s1, -332(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_237
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_238
	li s2, 71
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_239
	li s2, 72
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_240
	li s2, 73
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_241
	li s2, 74
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_242
	li s2, 75
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_243
	li s2, 76
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_244
	li s2, 87
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_245
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_246
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_247
	li s2, 82
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_248
	li s2, 83
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_249
	li s2, 84
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_250
	li s2, 85
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_251
	li s2, 86
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_252
	j .L84_253
.L84_237:
	li s1, 86
	sw s1, -340(s0)
	j .L84_254
.L84_238:
	li s1, 87
	sw s1, -340(s0)
	j .L84_254
.L84_239:
	li s1, 88
	sw s1, -340(s0)
	j .L84_254
.L84_240:
	lw s1, -332(s0)
	bnez s1, .L84_255
	j .L84_256
.L84_255:
	la s1, __str_28
	sw s1, -348(s0)
	j .L84_257
.L84_256:
	la s1, __str_29
	sw s1, -348(s0)
.L84_257:
	lw s1, -348(s0)
	sw s1, -344(s0)
	li s1, 120
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 120
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 122
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -344(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 2
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_241:
	lw s1, -332(s0)
	bnez s1, .L84_258
	j .L84_259
.L84_258:
	la s1, __str_30
	sw s1, -356(s0)
	j .L84_260
.L84_259:
	la s1, __str_31
	sw s1, -356(s0)
.L84_260:
	lw s1, -356(s0)
	sw s1, -352(s0)
	li s1, 120
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 120
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 122
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -352(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 2
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_242:
	li s1, 93
	sw s1, -340(s0)
	j .L84_254
.L84_243:
	li s1, 94
	sw s1, -340(s0)
	j .L84_254
.L84_244:
	li s1, 95
	sw s1, -340(s0)
	j .L84_254
.L84_245:
	li s1, 96
	sw s1, -340(s0)
	j .L84_254
.L84_246:
	lw s1, -332(s0)
	bnez s1, .L84_261
	j .L84_262
.L84_261:
	li s1, 98
	sw s1, -360(s0)
	j .L84_263
.L84_262:
	li s1, 97
	sw s1, -360(s0)
.L84_263:
	lw s1, -360(s0)
	sw s1, -340(s0)
	j .L84_254
.L84_247:
	li s1, 100
	sw s1, -340(s0)
	j .L84_254
.L84_248:
	li s1, 101
	sw s1, -340(s0)
	j .L84_254
.L84_249:
	lw s1, -332(s0)
	bnez s1, .L84_264
	j .L84_265
.L84_264:
	li s1, 106
	sw s1, -364(s0)
	j .L84_266
.L84_265:
	li s1, 102
	sw s1, -364(s0)
.L84_266:
	lw s1, -364(s0)
	sw s1, -340(s0)
	j .L84_254
.L84_250:
	lw s1, -332(s0)
	bnez s1, .L84_267
	j .L84_268
.L84_267:
	li s1, 107
	sw s1, -368(s0)
	j .L84_269
.L84_268:
	li s1, 103
	sw s1, -368(s0)
.L84_269:
	lw s1, -368(s0)
	sw s1, -340(s0)
	j .L84_254
.L84_251:
	lw s1, -332(s0)
	bnez s1, .L84_270
	j .L84_271
.L84_270:
	li s1, 108
	sw s1, -372(s0)
	j .L84_272
.L84_271:
	li s1, 104
	sw s1, -372(s0)
.L84_272:
	lw s1, -372(s0)
	sw s1, -340(s0)
	j .L84_254
.L84_252:
	lw s1, -332(s0)
	bnez s1, .L84_273
	j .L84_274
.L84_273:
	li s1, 109
	sw s1, -376(s0)
	j .L84_275
.L84_274:
	li s1, 105
	sw s1, -376(s0)
.L84_275:
	lw s1, -376(s0)
	sw s1, -340(s0)
	j .L84_254
.L84_253:
	la s1, __str_32
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_254:
	lw s1, -340(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_220:
	lw s1, -320(s0)
	bnez s1, .L84_276
	j .L84_277
.L84_276:
	lw s1, -272(s0)
	mv a0, s1
	jal ra, cc_type_promote
	mv s2, a0
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -384(s0)
	j .L84_278
.L84_277:
	lw s1, -272(s0)
	lw s2, -276(s0)
	mv a0, s1
	mv a1, s2
	jal ra, cc_type_usual_arith
	mv s3, a0
	li s1, 4
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -384(s0)
.L84_278:
	lw s1, -384(s0)
	sw s1, -380(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_279
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_280
	li s2, 71
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_281
	li s2, 72
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_282
	li s2, 73
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_283
	li s2, 74
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_284
	li s2, 75
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_285
	li s2, 76
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_286
	li s2, 87
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_287
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_288
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_289
	li s2, 82
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_290
	li s2, 83
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_291
	li s2, 84
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_292
	li s2, 85
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_293
	li s2, 86
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_294
	j .L84_295
.L84_279:
	li s1, 5
	sw s1, -388(s0)
	j .L84_296
.L84_280:
	li s1, 6
	sw s1, -388(s0)
	j .L84_296
.L84_281:
	li s1, 7
	sw s1, -388(s0)
	j .L84_296
.L84_282:
	lw s1, -380(s0)
	bnez s1, .L84_297
	j .L84_298
.L84_297:
	li s1, 9
	sw s1, -392(s0)
	j .L84_299
.L84_298:
	li s1, 8
	sw s1, -392(s0)
.L84_299:
	lw s1, -392(s0)
	sw s1, -388(s0)
	j .L84_296
.L84_283:
	lw s1, -380(s0)
	bnez s1, .L84_300
	j .L84_301
.L84_300:
	li s1, 11
	sw s1, -396(s0)
	j .L84_302
.L84_301:
	li s1, 10
	sw s1, -396(s0)
.L84_302:
	lw s1, -396(s0)
	sw s1, -388(s0)
	j .L84_296
.L84_284:
	li s1, 12
	sw s1, -388(s0)
	j .L84_296
.L84_285:
	li s1, 13
	sw s1, -388(s0)
	j .L84_296
.L84_286:
	li s1, 14
	sw s1, -388(s0)
	j .L84_296
.L84_287:
	li s1, 15
	sw s1, -388(s0)
	j .L84_296
.L84_288:
	lw s1, -380(s0)
	bnez s1, .L84_303
	j .L84_304
.L84_303:
	li s1, 17
	sw s1, -400(s0)
	j .L84_305
.L84_304:
	li s1, 16
	sw s1, -400(s0)
.L84_305:
	lw s1, -400(s0)
	sw s1, -388(s0)
	j .L84_296
.L84_289:
	li s1, 31
	sw s1, -388(s0)
	j .L84_296
.L84_290:
	li s1, 32
	sw s1, -388(s0)
	j .L84_296
.L84_291:
	lw s1, -380(s0)
	bnez s1, .L84_306
	j .L84_307
.L84_306:
	li s1, 37
	sw s1, -404(s0)
	j .L84_308
.L84_307:
	li s1, 33
	sw s1, -404(s0)
.L84_308:
	lw s1, -404(s0)
	sw s1, -388(s0)
	j .L84_296
.L84_292:
	lw s1, -380(s0)
	bnez s1, .L84_309
	j .L84_310
.L84_309:
	li s1, 38
	sw s1, -408(s0)
	j .L84_311
.L84_310:
	li s1, 34
	sw s1, -408(s0)
.L84_311:
	lw s1, -408(s0)
	sw s1, -388(s0)
	j .L84_296
.L84_293:
	lw s1, -380(s0)
	bnez s1, .L84_312
	j .L84_313
.L84_312:
	li s1, 39
	sw s1, -412(s0)
	j .L84_314
.L84_313:
	li s1, 35
	sw s1, -412(s0)
.L84_314:
	lw s1, -412(s0)
	sw s1, -388(s0)
	j .L84_296
.L84_294:
	lw s1, -380(s0)
	bnez s1, .L84_315
	j .L84_316
.L84_315:
	li s1, 40
	sw s1, -416(s0)
	j .L84_317
.L84_316:
	li s1, 36
	sw s1, -416(s0)
.L84_317:
	lw s1, -416(s0)
	sw s1, -388(s0)
	j .L84_296
.L84_295:
	la s1, __str_33
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_296:
	lw s1, -388(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -216(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_15:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -420(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_318
	j .L84_319
.L84_318:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, member_field
	mv s2, a0
	sw s2, -424(s0)
	lw s1, -424(s0)
	bnez s1, .L84_320
	j .L84_321
.L84_320:
	lw s1, -424(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L84_322
	j .L84_321
.L84_322:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	lw s1, -424(s0)
	lw s3, -420(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, lower_bitfield_write
	mv s4, a0
	mv a0, s4
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_321:
.L84_319:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_323
	j .L84_324
.L84_323:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -428(s0)
	lw s1, -428(s0)
	bnez s1, .L84_325
	j .L84_326
.L84_325:
	lw s1, -428(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_326
	j .L84_327
.L84_327:
	lw s1, -428(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_328
	j .L84_326
.L84_328:
	lw s1, -428(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L84_329
	j .L84_326
.L84_329:
	lw s1, -428(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L84_330
	j .L84_326
.L84_330:
	lw s1, -428(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L84_331
	j .L84_326
.L84_331:
	lw s1, -428(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_332
	j .L84_333
.L84_332:
	li s1, 81
	sw s1, -432(s0)
	lw s1, -420(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	lw s2, -428(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, to_float
	mv s4, a0
	sw s4, -420(s0)
	j .L84_334
.L84_333:
	lw s1, -428(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_335
	j .L84_336
.L84_335:
	li s1, 113
	sw s1, -432(s0)
	lw s1, -420(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, widen_to_i64
	mv s2, a0
	sw s2, -420(s0)
	j .L84_337
.L84_336:
	li s1, 29
	sw s1, -432(s0)
	lw s1, -428(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L84_338
	j .L84_339
.L84_338:
	lw s1, -420(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, to_bool
	mv s2, a0
	sw s2, -420(s0)
.L84_339:
.L84_337:
.L84_334:
	lw s1, -432(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -420(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -428(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -432(s0)
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_340
	j .L84_341
.L84_340:
	lw s1, -428(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_341:
	lw s1, -420(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_326:
.L84_324:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -436(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -440(s0)
	lw s1, -440(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_342
	j .L84_343
.L84_342:
	lw s1, -420(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, widen_to_i64
	mv s2, a0
	sw s2, -420(s0)
	j .L84_344
.L84_343:
	lw s1, -440(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L84_345
	j .L84_346
.L84_345:
	lw s1, -420(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, to_bool
	mv s2, a0
	sw s2, -420(s0)
.L84_346:
.L84_344:
	lw s1, -436(s0)
	lw s2, -420(s0)
	lw s3, -440(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
	lw s1, -420(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_16:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_347
	j .L84_348
.L84_347:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, member_field
	mv s2, a0
	sw s2, -444(s0)
	lw s1, -444(s0)
	bnez s1, .L84_349
	j .L84_350
.L84_349:
	lw s1, -444(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L84_351
	j .L84_350
.L84_351:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -448(s0)
	lw s1, -448(s0)
	lw s2, -444(s0)
	mv a0, s1
	mv a1, s2
	jal ra, lower_bitfield_read
	mv s3, a0
	sw s3, -452(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -456(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -452(s0)
	lw s3, -456(s0)
	lw s4, -444(s0)
	li s5, 4
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_compound_int
	mv s5, a0
	sw s5, -460(s0)
	lw s1, -448(s0)
	lw s2, -444(s0)
	lw s3, -460(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_bitfield_write
	mv s4, a0
	mv a0, s4
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_350:
.L84_348:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -464(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -468(s0)
	lw s1, -464(s0)
	lw s2, -468(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	sw s3, -472(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -476(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 59
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_352
	j .L84_353
.L84_353:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 60
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_352
	j .L84_354
.L84_352:
	lw s1, -468(s0)
	bnez s1, .L84_355
	j .L84_354
.L84_355:
	lw s1, -468(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L84_356
	j .L84_354
.L84_356:
	lw s1, -468(s0)
	mv a0, s1
	jal ra, pointee_size
	mv s2, a0
	sw s2, -480(s0)
	lw s1, -480(s0)
	li s2, 1
	slt s3, s2, s1
	bnez s3, .L84_357
	j .L84_358
.L84_357:
	lw s1, -480(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -484(s0)
	li s1, 7
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -476(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -484(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -476(s0)
.L84_358:
.L84_354:
	lw s1, -468(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_359
	j .L84_360
.L84_359:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	mv a0, s2
	jal ra, is_float_type
	mv s1, a0
	bnez s1, .L84_361
	j .L84_362
.L84_362:
	li s1, 69
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -476(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -476(s0)
.L84_361:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 59
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_363
	li s2, 60
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_364
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_365
	li s2, 62
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_366
	j .L84_367
.L84_363:
	li s1, 59
	sw s1, -488(s0)
	j .L84_368
.L84_364:
	li s1, 60
	sw s1, -488(s0)
	j .L84_368
.L84_365:
	li s1, 61
	sw s1, -488(s0)
	j .L84_368
.L84_366:
	li s1, 62
	sw s1, -488(s0)
	j .L84_368
.L84_367:
	la s1, __str_34
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_368:
	j .L84_369
.L84_360:
	lw s1, -468(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_370
	j .L84_371
.L84_370:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 67
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_372
	j .L84_373
.L84_373:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 68
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_372
	j .L84_374
.L84_372:
	li s1, 1
	j .L84_375
.L84_374:
	li s1, 0
.L84_375:
	sw s1, -492(s0)
	lw s1, -492(s0)
	bnez s1, .L84_376
	j .L84_377
.L84_377:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	mv a0, s2
	jal ra, is_i64_type
	mv s1, a0
	bnez s1, .L84_376
	j .L84_378
.L84_378:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -496(s0)
	lw s1, -496(s0)
	bnez s1, .L84_379
	j .L84_380
.L84_379:
	lw s1, -496(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_381
	j .L84_380
.L84_381:
	li s1, 118
	sw s1, -500(s0)
	j .L84_382
.L84_380:
	li s1, 117
	sw s1, -500(s0)
.L84_382:
	lw s1, -500(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -476(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -476(s0)
.L84_376:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 59
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_383
	li s2, 60
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_384
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_385
	li s2, 62
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_386
	li s2, 63
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_387
	li s2, 64
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_388
	li s2, 65
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_389
	li s2, 66
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_390
	li s2, 67
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_391
	li s2, 68
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_392
	j .L84_393
.L84_383:
	li s1, 86
	sw s1, -488(s0)
	j .L84_394
.L84_384:
	li s1, 87
	sw s1, -488(s0)
	j .L84_394
.L84_385:
	li s1, 88
	sw s1, -488(s0)
	j .L84_394
.L84_386:
	lw s1, -468(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_395
	j .L84_396
.L84_395:
	la s1, __str_35
	sw s1, -508(s0)
	j .L84_397
.L84_396:
	la s1, __str_36
	sw s1, -508(s0)
.L84_397:
	lw s1, -508(s0)
	sw s1, -504(s0)
	li s1, 120
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -472(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 120
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -476(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 122
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -504(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 2
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -512(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_398
	j .L84_399
.L84_398:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -516(s0)
	lw s1, -516(s0)
	bnez s1, .L84_400
	j .L84_401
.L84_400:
	lw s1, -516(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_401
	j .L84_402
.L84_402:
	lw s1, -516(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_403
	j .L84_401
.L84_403:
	lw s1, -516(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L84_404
	j .L84_401
.L84_404:
	li s1, 113
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -512(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -516(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -512(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_401:
.L84_399:
	lw s1, -464(s0)
	lw s2, -512(s0)
	lw s3, -468(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
	lw s1, -512(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_387:
	lw s1, -468(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_405
	j .L84_406
.L84_405:
	la s1, __str_37
	sw s1, -524(s0)
	j .L84_407
.L84_406:
	la s1, __str_38
	sw s1, -524(s0)
.L84_407:
	lw s1, -524(s0)
	sw s1, -520(s0)
	li s1, 120
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -472(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 120
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -476(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 122
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -520(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 2
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -528(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_408
	j .L84_409
.L84_408:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -532(s0)
	lw s1, -532(s0)
	bnez s1, .L84_410
	j .L84_411
.L84_410:
	lw s1, -532(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_411
	j .L84_412
.L84_412:
	lw s1, -532(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_413
	j .L84_411
.L84_413:
	lw s1, -532(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L84_414
	j .L84_411
.L84_414:
	li s1, 113
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -528(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -532(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -528(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_411:
.L84_409:
	lw s1, -464(s0)
	lw s2, -528(s0)
	lw s3, -468(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
	lw s1, -528(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_388:
	li s1, 93
	sw s1, -488(s0)
	j .L84_394
.L84_389:
	li s1, 94
	sw s1, -488(s0)
	j .L84_394
.L84_390:
	li s1, 95
	sw s1, -488(s0)
	j .L84_394
.L84_391:
	li s1, 96
	sw s1, -488(s0)
	j .L84_394
.L84_392:
	lw s1, -468(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_415
	j .L84_416
.L84_415:
	li s1, 98
	sw s1, -536(s0)
	j .L84_417
.L84_416:
	li s1, 97
	sw s1, -536(s0)
.L84_417:
	lw s1, -536(s0)
	sw s1, -488(s0)
	j .L84_394
.L84_393:
	la s1, __str_39
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_394:
	j .L84_418
.L84_371:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 59
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_419
	li s2, 60
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_420
	li s2, 61
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_421
	li s2, 62
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_422
	li s2, 63
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_423
	li s2, 64
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_424
	li s2, 65
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_425
	li s2, 66
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_426
	li s2, 67
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_427
	li s2, 68
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_428
	j .L84_429
.L84_419:
	li s1, 5
	sw s1, -488(s0)
	j .L84_430
.L84_420:
	li s1, 6
	sw s1, -488(s0)
	j .L84_430
.L84_421:
	li s1, 7
	sw s1, -488(s0)
	j .L84_430
.L84_422:
	lw s1, -468(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_431
	j .L84_432
.L84_431:
	li s1, 9
	sw s1, -540(s0)
	j .L84_433
.L84_432:
	li s1, 8
	sw s1, -540(s0)
.L84_433:
	lw s1, -540(s0)
	sw s1, -488(s0)
	j .L84_430
.L84_423:
	lw s1, -468(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_434
	j .L84_435
.L84_434:
	li s1, 11
	sw s1, -544(s0)
	j .L84_436
.L84_435:
	li s1, 10
	sw s1, -544(s0)
.L84_436:
	lw s1, -544(s0)
	sw s1, -488(s0)
	j .L84_430
.L84_424:
	li s1, 12
	sw s1, -488(s0)
	j .L84_430
.L84_425:
	li s1, 13
	sw s1, -488(s0)
	j .L84_430
.L84_426:
	li s1, 14
	sw s1, -488(s0)
	j .L84_430
.L84_427:
	li s1, 15
	sw s1, -488(s0)
	j .L84_430
.L84_428:
	lw s1, -468(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_437
	j .L84_438
.L84_437:
	li s1, 17
	sw s1, -548(s0)
	j .L84_439
.L84_438:
	li s1, 16
	sw s1, -548(s0)
.L84_439:
	lw s1, -548(s0)
	sw s1, -488(s0)
	j .L84_430
.L84_429:
	la s1, __str_40
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_430:
.L84_418:
.L84_369:
	lw s1, -488(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -472(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -476(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -552(s0)
	lw s1, -468(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L84_440
	j .L84_441
.L84_440:
	lw s1, -552(s0)
	lw s2, -468(s0)
	mv a0, s1
	mv a1, s2
	jal ra, to_bool
	mv s3, a0
	sw s3, -552(s0)
.L84_441:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_442
	j .L84_443
.L84_442:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -556(s0)
	lw s1, -556(s0)
	bnez s1, .L84_444
	j .L84_445
.L84_444:
	lw s1, -556(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_445
	j .L84_446
.L84_446:
	lw s1, -556(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_447
	j .L84_445
.L84_447:
	lw s1, -556(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L84_448
	j .L84_445
.L84_448:
	lw s1, -556(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_449
	j .L84_450
.L84_449:
	li s1, 81
	sw s1, -560(s0)
	j .L84_451
.L84_450:
	lw s1, -556(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_452
	j .L84_453
.L84_452:
	li s1, 113
	sw s1, -560(s0)
	j .L84_454
.L84_453:
	li s1, 29
	sw s1, -560(s0)
.L84_454:
.L84_451:
	lw s1, -560(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -552(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -556(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -560(s0)
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_455
	j .L84_456
.L84_455:
	lw s1, -556(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_456:
	lw s1, -552(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_445:
.L84_443:
	lw s1, -464(s0)
	lw s2, -552(s0)
	lw s3, -468(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
	lw s1, -552(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_17:
.L84_18:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_457
	j .L84_458
.L84_457:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, member_field
	mv s2, a0
	sw s2, -564(s0)
	lw s1, -564(s0)
	bnez s1, .L84_459
	j .L84_460
.L84_459:
	lw s1, -564(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L84_461
	j .L84_460
.L84_461:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -568(s0)
	lw s1, -568(s0)
	lw s2, -564(s0)
	mv a0, s1
	mv a1, s2
	jal ra, lower_bitfield_read
	mv s3, a0
	sw s3, -572(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_462
	j .L84_463
.L84_462:
	li s1, 1
	sw s1, -580(s0)
	j .L84_464
.L84_463:
	li s1, 1
	neg s2, s1
	sw s2, -580(s0)
.L84_464:
	lw s1, -580(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -576(s0)
	li s1, 5
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -584(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -584(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -572(s0)
	lw s2, -584(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -576(s0)
	lw s2, -584(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -568(s0)
	lw s2, -564(s0)
	lw s3, -584(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_bitfield_write
	mv s4, a0
	mv a0, s4
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_460:
.L84_458:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -588(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -592(s0)
	lw s1, -588(s0)
	lw s2, -592(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	sw s3, -596(s0)
	li s1, 1
	sw s1, -600(s0)
	lw s1, -592(s0)
	bnez s1, .L84_465
	j .L84_466
.L84_465:
	lw s1, -592(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L84_467
	j .L84_466
.L84_467:
	lw s1, -592(s0)
	mv a0, s1
	jal ra, pointee_size
	mv s2, a0
	sw s2, -600(s0)
.L84_466:
	lw s1, -592(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_468
	j .L84_469
.L84_468:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_470
	j .L84_471
.L84_470:
	lw s1, -600(s0)
	sw s1, -616(s0)
	j .L84_472
.L84_471:
	lw s1, -600(s0)
	neg s2, s1
	sw s2, -616(s0)
.L84_472:
	lw s1, -616(s0)
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
	jal ra, lower_const64
	mv s1, a0
	sw s1, -604(s0)
	li s1, 86
	sw s1, -608(s0)
	li s1, 113
	sw s1, -612(s0)
	j .L84_473
.L84_469:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_474
	j .L84_475
.L84_474:
	lw s1, -600(s0)
	sw s1, -620(s0)
	j .L84_476
.L84_475:
	lw s1, -600(s0)
	neg s2, s1
	sw s2, -620(s0)
.L84_476:
	lw s1, -620(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -604(s0)
	li s1, 5
	sw s1, -608(s0)
	li s1, 29
	sw s1, -612(s0)
.L84_473:
	lw s1, -608(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -596(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -604(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -624(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_477
	j .L84_478
.L84_477:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -628(s0)
	lw s1, -628(s0)
	bnez s1, .L84_479
	j .L84_480
.L84_479:
	lw s1, -628(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_480
	j .L84_481
.L84_481:
	lw s1, -628(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_482
	j .L84_480
.L84_482:
	lw s1, -628(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L84_483
	j .L84_480
.L84_483:
	lw s1, -612(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -624(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -628(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -624(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_480:
.L84_478:
	lw s1, -588(s0)
	lw s2, -624(s0)
	lw s3, -592(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
	lw s1, -624(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_19:
.L84_20:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_484
	j .L84_485
.L84_484:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, member_field
	mv s2, a0
	sw s2, -632(s0)
	lw s1, -632(s0)
	bnez s1, .L84_486
	j .L84_487
.L84_486:
	lw s1, -632(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L84_488
	j .L84_487
.L84_488:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -636(s0)
	lw s1, -636(s0)
	lw s2, -632(s0)
	mv a0, s1
	mv a1, s2
	jal ra, lower_bitfield_read
	mv s3, a0
	sw s3, -640(s0)
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_489
	j .L84_490
.L84_489:
	li s1, 1
	sw s1, -648(s0)
	j .L84_491
.L84_490:
	li s1, 1
	neg s2, s1
	sw s2, -648(s0)
.L84_491:
	lw s1, -648(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -644(s0)
	li s1, 5
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -652(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -652(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -640(s0)
	lw s2, -652(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -644(s0)
	lw s2, -652(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -636(s0)
	lw s2, -632(s0)
	lw s3, -652(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_bitfield_write
	mv s4, a0
	lw s1, -640(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_487:
.L84_485:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	sw s2, -656(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -660(s0)
	lw s1, -656(s0)
	lw s2, -660(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_load
	mv s3, a0
	sw s3, -664(s0)
	li s1, 1
	sw s1, -668(s0)
	lw s1, -660(s0)
	bnez s1, .L84_492
	j .L84_493
.L84_492:
	lw s1, -660(s0)
	mv a0, s1
	jal ra, cc_type_is_ptr
	mv s2, a0
	bnez s2, .L84_494
	j .L84_493
.L84_494:
	lw s1, -660(s0)
	mv a0, s1
	jal ra, pointee_size
	mv s2, a0
	sw s2, -668(s0)
.L84_493:
	lw s1, -660(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_495
	j .L84_496
.L84_495:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_497
	j .L84_498
.L84_497:
	lw s1, -668(s0)
	sw s1, -684(s0)
	j .L84_499
.L84_498:
	lw s1, -668(s0)
	neg s2, s1
	sw s2, -684(s0)
.L84_499:
	lw s1, -684(s0)
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
	jal ra, lower_const64
	mv s1, a0
	sw s1, -672(s0)
	li s1, 86
	sw s1, -676(s0)
	li s1, 113
	sw s1, -680(s0)
	j .L84_500
.L84_496:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_501
	j .L84_502
.L84_501:
	lw s1, -668(s0)
	sw s1, -688(s0)
	j .L84_503
.L84_502:
	lw s1, -668(s0)
	neg s2, s1
	sw s2, -688(s0)
.L84_503:
	lw s1, -688(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -672(s0)
	li s1, 5
	sw s1, -676(s0)
	li s1, 29
	sw s1, -680(s0)
.L84_500:
	lw s1, -676(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -664(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -672(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -692(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_504
	j .L84_505
.L84_504:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -696(s0)
	lw s1, -696(s0)
	bnez s1, .L84_506
	j .L84_507
.L84_506:
	lw s1, -696(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_507
	j .L84_508
.L84_508:
	lw s1, -696(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_509
	j .L84_507
.L84_509:
	lw s1, -696(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L84_510
	j .L84_507
.L84_510:
	lw s1, -680(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -692(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -696(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -664(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_507:
.L84_505:
	lw s1, -656(s0)
	lw s2, -692(s0)
	lw s3, -660(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
	lw s1, -664(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_21:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -700(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -704(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -708(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -712(s0)
	lw s1, -700(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L84_511
	j .L84_512
.L84_511:
	jal ra, new_temp
	mv s1, a0
	sw s1, -716(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -704(s0)
	lw s3, -708(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	lw s1, -704(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	li s1, 4
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -716(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	lw s1, -12(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -712(s0)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	lw s1, -708(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	li s1, 4
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -716(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	lw s1, -12(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -712(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -716(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_512:
	lw s1, -700(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	lw s1, -700(s0)
	mv a0, s1
	jal ra, cc_type_align
	mv s3, a0
	mv a0, s2
	mv a1, s3
	jal ra, alloc_slot
	mv s1, a0
	sw s1, -720(s0)
	lw s1, -700(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	sw s2, -724(s0)
	lw s1, -700(s0)
	mv a0, s1
	jal ra, val_is_wide
	mv s2, a0
	sw s2, -728(s0)
	lw s1, -724(s0)
	bnez s1, .L84_513
	j .L84_514
.L84_513:
	li s1, 81
	sw s1, -736(s0)
	j .L84_515
.L84_514:
	lw s1, -728(s0)
	bnez s1, .L84_516
	j .L84_517
.L84_516:
	li s1, 113
	sw s1, -740(s0)
	j .L84_518
.L84_517:
	li s1, 29
	sw s1, -740(s0)
.L84_518:
	lw s1, -740(s0)
	sw s1, -736(s0)
.L84_515:
	lw s1, -736(s0)
	sw s1, -732(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -704(s0)
	lw s3, -708(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	lw s1, -704(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -744(s0)
	lw s1, -724(s0)
	bnez s1, .L84_519
	j .L84_520
.L84_519:
	lw s1, -744(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	lw s2, -700(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, to_float
	mv s4, a0
	sw s4, -744(s0)
	j .L84_521
.L84_520:
	lw s1, -700(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_522
	j .L84_523
.L84_522:
	lw s1, -744(s0)
	lw s2, -4(s0)
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, widen_branch_to_i64
	mv s2, a0
	sw s2, -744(s0)
.L84_523:
.L84_521:
	lw s1, -732(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -744(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -720(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -724(s0)
	bnez s1, .L84_524
	j .L84_525
.L84_524:
	lw s1, -700(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_525:
	lw s1, -712(s0)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	lw s1, -708(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -748(s0)
	lw s1, -724(s0)
	bnez s1, .L84_526
	j .L84_527
.L84_526:
	lw s1, -748(s0)
	lw s2, -4(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	lw s2, -700(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, to_float
	mv s4, a0
	sw s4, -748(s0)
	j .L84_528
.L84_527:
	lw s1, -700(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_529
	j .L84_530
.L84_529:
	lw s1, -748(s0)
	lw s2, -4(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, widen_branch_to_i64
	mv s2, a0
	sw s2, -748(s0)
.L84_530:
.L84_528:
	lw s1, -732(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -748(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -720(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -724(s0)
	bnez s1, .L84_531
	j .L84_532
.L84_531:
	lw s1, -700(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_532:
	lw s1, -712(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -724(s0)
	bnez s1, .L84_533
	j .L84_534
.L84_533:
	li s1, 80
	sw s1, -752(s0)
	j .L84_535
.L84_534:
	lw s1, -728(s0)
	bnez s1, .L84_536
	j .L84_537
.L84_536:
	li s1, 112
	sw s1, -756(s0)
	j .L84_538
.L84_537:
	li s1, 28
	sw s1, -756(s0)
.L84_538:
	lw s1, -756(s0)
	sw s1, -752(s0)
.L84_535:
	lw s1, -752(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -720(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -724(s0)
	bnez s1, .L84_539
	j .L84_540
.L84_539:
	lw s1, -700(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_540:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_22:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_23:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -760(s0)
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -764(s0)
	lw s1, -764(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
	lw s1, -760(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -768(s0)
	lw s1, -764(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L84_541
	j .L84_542
.L84_541:
	lw s1, -768(s0)
	lw s2, -760(s0)
	mv a0, s1
	mv a1, s2
	jal ra, to_bool
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_542:
	lw s1, -764(s0)
	bnez s1, .L84_543
	j .L84_544
.L84_543:
	lw s1, -764(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_545
	j .L84_544
.L84_545:
	lw s1, -760(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_544
	j .L84_546
.L84_546:
	lw s1, -760(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_547
	j .L84_548
.L84_547:
	li s1, 119
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -768(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -768(s0)
.L84_548:
	li s1, 69
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -768(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -764(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_544:
	lw s1, -764(s0)
	bnez s1, .L84_549
	j .L84_550
.L84_549:
	lw s1, -764(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_550
	j .L84_551
.L84_551:
	lw s1, -760(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_552
	j .L84_550
.L84_552:
	li s1, 70
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -768(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -760(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -768(s0)
	lw s1, -764(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_553
	j .L84_554
.L84_553:
	li s1, 117
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -768(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_554:
	lw s1, -768(s0)
	lw s2, -764(s0)
	mv a0, s1
	mv a1, s2
	jal ra, narrow_to
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_550:
	lw s1, -764(s0)
	bnez s1, .L84_555
	j .L84_556
.L84_555:
	lw s1, -760(s0)
	bnez s1, .L84_557
	j .L84_556
.L84_557:
	lw s1, -764(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_558
	j .L84_556
.L84_558:
	lw s1, -760(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_559
	j .L84_556
.L84_559:
	lw s1, -760(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -764(s0)
	mv a0, s1
	jal ra, fwidth
	mv s3, a0
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L84_560
	j .L84_561
.L84_560:
	lw s1, -764(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_562
	j .L84_563
.L84_562:
	li s1, 73
	sw s1, -772(s0)
	j .L84_564
.L84_563:
	li s1, 72
	sw s1, -772(s0)
.L84_564:
	lw s1, -772(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -768(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_561:
	lw s1, -768(s0)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_556:
	lw s1, -764(s0)
	bnez s1, .L84_565
	j .L84_566
.L84_565:
	lw s1, -764(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_567
	j .L84_566
.L84_567:
	lw s1, -760(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_566
	j .L84_568
.L84_568:
	lw s1, -760(s0)
	bnez s1, .L84_569
	j .L84_570
.L84_569:
	lw s1, -760(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_571
	j .L84_570
.L84_571:
	li s1, 118
	sw s1, -776(s0)
	j .L84_572
.L84_570:
	li s1, 117
	sw s1, -776(s0)
.L84_572:
	lw s1, -776(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -768(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_566:
	lw s1, -764(s0)
	bnez s1, .L84_573
	j .L84_574
.L84_573:
	lw s1, -764(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_574
	j .L84_575
.L84_575:
	lw s1, -760(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_576
	j .L84_574
.L84_576:
	li s1, 119
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -768(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -764(s0)
	mv a0, s1
	mv a1, s2
	jal ra, narrow_to
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_574:
	lw s1, -768(s0)
	lw s2, -764(s0)
	mv a0, s1
	mv a1, s2
	jal ra, narrow_to
	mv s3, a0
	mv a0, s3
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_24:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_577
	j .L84_578
.L84_577:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -784(s0)
	j .L84_579
.L84_578:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_580
	j .L84_581
.L84_580:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -788(s0)
	j .L84_582
.L84_581:
	li s1, 0
	sw s1, -788(s0)
.L84_582:
	lw s1, -788(s0)
	sw s1, -784(s0)
.L84_579:
	lw s1, -784(s0)
	sw s1, -780(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_583
	j .L84_584
.L84_583:
	lw s1, -780(s0)
	bnez s1, .L84_585
	j .L84_586
.L84_585:
	lw s1, -780(s0)
	sw s1, -800(s0)
	j .L84_587
.L84_586:
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -800(s0)
.L84_587:
	lw s1, -800(s0)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	sw s2, -796(s0)
	j .L84_588
.L84_584:
	lw s1, -780(s0)
	bnez s1, .L84_589
	j .L84_590
.L84_589:
	lw s1, -780(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -804(s0)
	j .L84_591
.L84_590:
	li s1, 4
	sw s1, -804(s0)
.L84_591:
	lw s1, -804(s0)
	sw s1, -796(s0)
.L84_588:
	lw s1, -796(s0)
	sw s1, -792(s0)
	lw s1, -792(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_25:
	li s1, 0
	sw s1, -808(s0)
	li s1, 1
	neg s2, s1
	sw s2, -812(s0)
	li s1, 0
	sw s1, -816(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_592
	j .L84_593
.L84_592:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_594
	j .L84_593
.L84_594:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -820(s0)
	lw s1, -820(s0)
	la s2, __str_41
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L84_595
	j .L84_596
.L84_595:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -824(s0)
	li s1, 116
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -824(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_596:
	lw s1, -820(s0)
	la s2, __str_42
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L84_597
	j .L84_598
.L84_597:
	li s1, 0
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_598:
	lw s1, -820(s0)
	la s2, __str_43
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L84_599
	j .L84_600
.L84_599:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_601
	j .L84_600
.L84_601:
	li s1, 1
	j .L84_602
.L84_600:
	li s1, 0
.L84_602:
	sw s1, -828(s0)
	li s1, 1
	neg s2, s1
	sw s2, -832(s0)
	lw s1, -820(s0)
	la s2, __str_44
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L84_603
	j .L84_604
.L84_603:
	li s1, 0
	sw s1, -832(s0)
	j .L84_605
.L84_604:
	lw s1, -820(s0)
	la s2, __str_45
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L84_606
	j .L84_607
.L84_606:
	li s1, 1
	sw s1, -832(s0)
	j .L84_608
.L84_607:
	lw s1, -820(s0)
	la s2, __str_46
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L84_609
	j .L84_610
.L84_609:
	li s1, 2
	sw s1, -832(s0)
	j .L84_611
.L84_610:
	lw s1, -828(s0)
	bnez s1, .L84_612
	j .L84_613
.L84_612:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -836(s0)
	lw s1, -836(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_614
	j .L84_615
.L84_614:
	li s1, 1
	sw s1, -840(s0)
	j .L84_616
.L84_615:
	lw s1, -836(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_617
	j .L84_618
.L84_617:
	li s1, 2
	sw s1, -844(s0)
	j .L84_619
.L84_618:
	li s1, 0
	sw s1, -844(s0)
.L84_619:
	lw s1, -844(s0)
	sw s1, -840(s0)
.L84_616:
	lw s1, -840(s0)
	sw s1, -832(s0)
.L84_613:
.L84_611:
.L84_608:
.L84_605:
	lw s1, -832(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L84_620
	j .L84_621
.L84_620:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -848(s0)
	lw s1, -832(s0)
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -852(s0)
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_622
	j .L84_623
.L84_622:
	li s1, 120
	sw s1, -856(s0)
	j .L84_624
.L84_623:
	li s1, 44
	sw s1, -856(s0)
.L84_624:
	lw s1, -856(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -848(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 44
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -852(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_625
	j .L84_626
.L84_625:
	li s1, 122
	sw s1, -860(s0)
	j .L84_627
.L84_626:
	li s1, 46
	sw s1, -860(s0)
.L84_627:
	lw s1, -860(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	la s1, __str_47
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 2
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -864(s0)
	lw s1, -832(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_628
	j .L84_629
.L84_628:
	li s1, 75
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -864(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_629:
	lw s1, -832(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_630
	j .L84_631
.L84_630:
	li s1, 110
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -864(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_631:
	li s1, 24
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -864(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_621:
.L84_593:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_632
	j .L84_633
.L84_632:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_local
	mv s2, a0
	sw s2, -868(s0)
	lw s1, -868(s0)
	bnez s1, .L84_634
	j .L84_635
.L84_634:
	lw s1, -868(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_636
	j .L84_635
.L84_636:
	lw s1, -868(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_637
	j .L84_638
.L84_638:
	lw s1, -868(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_637
	j .L84_635
.L84_637:
	li s1, 1
	sw s1, -808(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -812(s0)
	lw s1, -868(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -816(s0)
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_639
	j .L84_640
.L84_639:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -816(s0)
.L84_640:
	j .L84_641
.L84_635:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_global
	mv s2, a0
	sw s2, -872(s0)
	lw s1, -872(s0)
	bnez s1, .L84_642
	j .L84_643
.L84_642:
	lw s1, -872(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -816(s0)
.L84_643:
.L84_641:
	j .L84_644
.L84_633:
	li s1, 1
	sw s1, -808(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -812(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -816(s0)
	lw s1, -816(s0)
	bnez s1, .L84_645
	j .L84_646
.L84_645:
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_647
	j .L84_646
.L84_647:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -816(s0)
.L84_646:
.L84_644:
	addi s1, s0, -1384
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 108
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 112
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 116
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 120
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 124
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	addi s1, s0, -1512
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 108
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 112
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 116
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 120
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 124
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	addi s1, s0, -1640
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 108
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 112
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 116
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 120
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 124
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	li s1, 0
	sw s1, -1644(s0)
	li s1, 8
	sw s1, -1648(s0)
	li s1, 0
	sw s1, -1652(s0)
	li s1, 0
	sw s1, -1656(s0)
	li s1, 1
	neg s2, s1
	sw s2, -1660(s0)
	lw s1, -816(s0)
	bnez s1, .L84_648
	j .L84_649
.L84_648:
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_650
	j .L84_649
.L84_650:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, ret_uses_hidden_ptr
	mv s2, a0
	bnez s2, .L84_651
	j .L84_649
.L84_651:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	lw s1, -816(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s1
	jal ra, cc_type_align
	mv s3, a0
	mv a0, s2
	mv a1, s3
	jal ra, alloc_slot
	mv s1, a0
	sw s1, -1660(s0)
	lw s1, -1660(s0)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	addi s1, s0, -1000
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	li s1, 0
	addi s2, s0, -1128
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1
	sw s1, -1652(s0)
	li s1, 0
	addi s2, s0, -1256
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1
	sw s1, -1644(s0)
.L84_649:
	lw s1, -816(s0)
	bnez s1, .L84_652
	j .L84_653
.L84_652:
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_654
	j .L84_653
.L84_654:
	lw s1, -816(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1668(s0)
	j .L84_655
.L84_653:
	li s1, 0
	sw s1, -1668(s0)
.L84_655:
	lw s1, -1668(s0)
	sw s1, -1664(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1672(s0)
.L84_656:
	lw s1, -1672(s0)
	bnez s1, .L84_657
	j .L84_658
.L84_657:
	lw s1, -1644(s0)
	li s2, 32
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L84_659
	j .L84_660
.L84_659:
	la s1, __str_48
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L84_660:
	lw s1, -816(s0)
	bnez s1, .L84_661
	j .L84_662
.L84_661:
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_663
	j .L84_662
.L84_663:
	lw s1, -816(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L84_664
	j .L84_662
.L84_664:
	lw s1, -1664(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_665
	j .L84_662
.L84_665:
	li s1, 1
	j .L84_666
.L84_662:
	li s1, 0
.L84_666:
	sw s1, -1676(s0)
	lw s1, -1664(s0)
	bnez s1, .L84_667
	j .L84_668
.L84_667:
	lw s1, -1664(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1708(s0)
	j .L84_669
.L84_668:
	lw s1, -1672(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -1708(s0)
.L84_669:
	lw s1, -1708(s0)
	sw s1, -1704(s0)
	lw s1, -1704(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
	lw s1, -1704(s0)
	addi s2, s0, -1696
	mv a0, s1
	mv a1, s2
	jal ra, abi_agg
	mv s3, a0
	sw s3, -1700(s0)
	li s1, 0
	slt s2, s1, s3
	bnez s2, .L84_670
	j .L84_671
.L84_670:
	lw s1, -1672(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -1712(s0)
	li s1, 0
	sw s1, -1716(s0)
.L84_672:
	lw s1, -1716(s0)
	lw s2, -1700(s0)
	slt s3, s1, s2
	bnez s3, .L84_673
	j .L84_674
.L84_673:
	lw s1, -1716(s0)
	bnez s1, .L84_675
	j .L84_676
.L84_675:
	lw s1, -1712(s0)
	li s2, 4
	lw s3, -1716(s0)
	mul s4, s2, s3
	mv a0, s4
	jal ra, emit_addr_const
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, emit_addr_add
	mv s3, a0
	sw s3, -1724(s0)
	j .L84_677
.L84_676:
	lw s1, -1712(s0)
	sw s1, -1724(s0)
.L84_677:
	lw s1, -1724(s0)
	sw s1, -1720(s0)
	li s1, 24
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -1728(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -1728(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1720(s0)
	lw s2, -1728(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1728(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -1000
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	addi s2, s0, -1128
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	addi s2, s0, -1256
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1676(s0)
	addi s2, s0, -1512
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -1644
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1644(s0)
.L84_678:
	addi s1, s0, -1716
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1716(s0)
	j .L84_672
.L84_674:
	lw s1, -1664(s0)
	bnez s1, .L84_679
	j .L84_680
.L84_679:
	lw s1, -1664(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1664(s0)
.L84_680:
	j .L84_681
.L84_671:
	lw s1, -1704(s0)
	mv a0, s1
	jal ra, abi_struct_mem
	mv s2, a0
	bnez s2, .L84_682
	j .L84_683
.L84_682:
	lw s1, -1672(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -1732(s0)
	lw s1, -1704(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	lw s1, -1704(s0)
	mv a0, s1
	jal ra, cc_type_align
	mv s3, a0
	mv a0, s2
	mv a1, s3
	jal ra, alloc_slot
	mv s1, a0
	sw s1, -1736(s0)
	lw s1, -1736(s0)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	lw s1, -1732(s0)
	lw s3, -1704(s0)
	mv a0, s3
	jal ra, cc_type_size
	mv s4, a0
	mv a0, s2
	mv a1, s1
	mv a2, s4
	jal ra, emit_aggregate_copy
	mv s3, a0
	lw s1, -1736(s0)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	addi s1, s0, -1000
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	li s1, 0
	addi s2, s0, -1128
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	addi s2, s0, -1256
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1676(s0)
	addi s2, s0, -1512
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1652(s0)
	lw s2, -1648(s0)
	slt s3, s1, s2
	bnez s3, .L84_684
	j .L84_685
.L84_684:
	addi s1, s0, -1652
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1652(s0)
.L84_685:
	lw s1, -1664(s0)
	bnez s1, .L84_686
	j .L84_687
.L84_686:
	lw s1, -1664(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1664(s0)
.L84_687:
	addi s1, s0, -1644
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1644(s0)
	j .L84_681
.L84_683:
	lw s1, -1672(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	addi s1, s0, -1000
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	li s1, 0
	addi s2, s0, -1256
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1704(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_688
	j .L84_689
.L84_688:
	li s1, 1
	addi s2, s0, -1128
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1704(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	addi s1, s0, -1256
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	lw s1, -1656(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L84_690
	j .L84_691
.L84_690:
	addi s1, s0, -1656
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1656(s0)
.L84_691:
	lw s1, -1664(s0)
	bnez s1, .L84_692
	j .L84_693
.L84_692:
	addi s1, s0, -1000
	lw s2, -1644(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -1672(s0)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	lw s2, -1704(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, to_float
	mv s4, a0
	addi s1, s0, -1000
	lw s2, -1644(s0)
	li s3, 4
	mul s5, s2, s3
	add s2, s1, s5
	sw s4, 0(s2)
.L84_693:
	j .L84_694
.L84_689:
	lw s1, -1704(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_695
	j .L84_696
.L84_695:
	li s1, 2
	addi s2, s0, -1128
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1652(s0)
	lw s2, -1648(s0)
	slt s3, s1, s2
	bnez s3, .L84_697
	j .L84_698
.L84_697:
	addi s1, s0, -1652
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1652(s0)
.L84_698:
	addi s1, s0, -1000
	lw s2, -1644(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -1672(s0)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, widen_to_i64
	mv s2, a0
	addi s1, s0, -1000
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	j .L84_699
.L84_696:
	lw s1, -1664(s0)
	bnez s1, .L84_700
	j .L84_701
.L84_700:
	lw s1, -1704(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L84_702
	j .L84_701
.L84_702:
	li s1, 0
	addi s2, s0, -1128
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1652(s0)
	lw s2, -1648(s0)
	slt s3, s1, s2
	bnez s3, .L84_703
	j .L84_704
.L84_703:
	addi s1, s0, -1652
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1652(s0)
.L84_704:
	addi s1, s0, -1000
	lw s2, -1644(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -1672(s0)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, to_bool
	mv s2, a0
	addi s1, s0, -1000
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	j .L84_705
.L84_701:
	li s1, 0
	addi s2, s0, -1128
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1652(s0)
	lw s2, -1648(s0)
	slt s3, s1, s2
	bnez s3, .L84_706
	j .L84_707
.L84_706:
	addi s1, s0, -1652
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1652(s0)
.L84_707:
	lw s1, -1664(s0)
	bnez s1, .L84_708
	j .L84_709
.L84_708:
	lw s1, -1672(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	mv a0, s2
	jal ra, is_i64_type
	mv s1, a0
	bnez s1, .L84_710
	j .L84_709
.L84_710:
	lw s1, -1704(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_709
	j .L84_711
.L84_711:
	li s1, 119
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1000
	lw s2, -1644(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -1000
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L84_709:
.L84_705:
.L84_699:
.L84_694:
	lw s1, -1676(s0)
	addi s2, s0, -1512
	lw s3, -1644(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -1664(s0)
	bnez s1, .L84_712
	j .L84_713
.L84_712:
	lw s1, -1664(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1664(s0)
.L84_713:
	addi s1, s0, -1644
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1644(s0)
.L84_681:
	lw s1, -1672(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1672(s0)
	j .L84_656
.L84_658:
	li s1, 0
	sw s1, -1740(s0)
.L84_714:
	lw s1, -1740(s0)
	lw s2, -1644(s0)
	slt s3, s1, s2
	bnez s3, .L84_715
	j .L84_716
.L84_715:
	addi s1, s0, -1128
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_717
	j .L84_718
.L84_717:
	li s1, 45
	sw s1, -1748(s0)
	j .L84_719
.L84_718:
	addi s1, s0, -1128
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_720
	j .L84_721
.L84_720:
	li s1, 120
	sw s1, -1752(s0)
	j .L84_722
.L84_721:
	addi s1, s0, -1128
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_723
	j .L84_724
.L84_723:
	li s1, 127
	sw s1, -1756(s0)
	j .L84_725
.L84_724:
	addi s1, s0, -1128
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_726
	j .L84_727
.L84_726:
	li s1, 128
	sw s1, -1760(s0)
	j .L84_728
.L84_727:
	li s1, 44
	sw s1, -1760(s0)
.L84_728:
	lw s1, -1760(s0)
	sw s1, -1756(s0)
.L84_725:
	lw s1, -1756(s0)
	sw s1, -1752(s0)
.L84_722:
	lw s1, -1752(s0)
	sw s1, -1748(s0)
.L84_719:
	lw s1, -1748(s0)
	sw s1, -1744(s0)
	lw s1, -1744(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	addi s1, s0, -1000
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1512
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -12(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1744(s0)
	li s2, 44
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_729
	j .L84_730
.L84_729:
	addi s1, s0, -1640
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L84_731
	j .L84_730
.L84_731:
	li s1, 8
	lw s2, -12(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
.L84_730:
	lw s1, -1744(s0)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_732
	j .L84_733
.L84_732:
	addi s1, s0, -1256
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1764(s0)
	j .L84_734
.L84_733:
	lw s1, -1744(s0)
	li s2, 127
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L84_735
	j .L84_736
.L84_735:
	addi s1, s0, -1384
	lw s2, -1740(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1768(s0)
	j .L84_737
.L84_736:
	lw s1, -1740(s0)
	sw s1, -1768(s0)
.L84_737:
	lw s1, -1768(s0)
	sw s1, -1764(s0)
.L84_734:
	lw s1, -1764(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_738:
	addi s1, s0, -1740
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1740(s0)
	j .L84_714
.L84_716:
	lw s1, -816(s0)
	bnez s1, .L84_739
	j .L84_740
.L84_739:
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_741
	j .L84_740
.L84_741:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
.L84_740:
	lw s1, -816(s0)
	bnez s1, .L84_742
	j .L84_743
.L84_742:
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_744
	j .L84_743
.L84_744:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L84_745
	j .L84_743
.L84_745:
	li s1, 1
	j .L84_746
.L84_743:
	li s1, 0
.L84_746:
	sw s1, -1772(s0)
	li s1, 0
	sw s1, -1796(s0)
	lw s1, -816(s0)
	bnez s1, .L84_747
	j .L84_748
.L84_747:
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_749
	j .L84_748
.L84_749:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -1792
	mv a0, s1
	mv a1, s2
	jal ra, abi_agg
	mv s3, a0
	sw s3, -1796(s0)
.L84_748:
	lw s1, -1796(s0)
	li s2, 0
	slt s3, s2, s1
	sw s3, -1800(s0)
	lw s1, -816(s0)
	bnez s1, .L84_750
	j .L84_751
.L84_750:
	lw s1, -816(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L84_752
	j .L84_751
.L84_752:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L84_753
	j .L84_751
.L84_753:
	li s1, 1
	j .L84_754
.L84_751:
	li s1, 0
.L84_754:
	sw s1, -1804(s0)
	lw s1, -1800(s0)
	bnez s1, .L84_755
	j .L84_756
.L84_755:
	lw s1, -1796(s0)
	li s2, 4
	mul s3, s1, s2
	li s1, 8
	slt s2, s3, s1
	bnez s2, .L84_757
	j .L84_758
.L84_757:
	li s1, 8
	sw s1, -1812(s0)
	j .L84_759
.L84_758:
	lw s1, -1796(s0)
	li s2, 4
	mul s3, s1, s2
	sw s3, -1812(s0)
.L84_759:
	lw s1, -1812(s0)
	li s2, 8
	mv a0, s1
	mv a1, s2
	jal ra, alloc_slot
	mv s3, a0
	sw s3, -1808(s0)
	lw s1, -1796(s0)
	sw s1, -1816(s0)
	li s1, 0
	sw s1, -1820(s0)
.L84_760:
	lw s1, -1820(s0)
	lw s2, -1796(s0)
	slt s3, s1, s2
	bnez s3, .L84_761
	j .L84_762
.L84_761:
	addi s1, s0, -1816
	lw s2, 0(s1)
	addi s1, s0, -1792
	lw s3, -1820(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	li s3, 3
	li s4, 2
	lw s5, -1820(s0)
	mul s6, s4, s5
	add s4, s3, s6
	sll s3, s1, s4
	or s1, s2, s3
	sw s1, -1816(s0)
.L84_763:
	addi s1, s0, -1820
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1820(s0)
	j .L84_760
.L84_762:
	lw s1, -808(s0)
	bnez s1, .L84_764
	j .L84_765
.L84_764:
	li s1, 126
	sw s1, -1824(s0)
	j .L84_766
.L84_765:
	li s1, 125
	sw s1, -1824(s0)
.L84_766:
	lw s1, -1824(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -1808(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1816(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -1644(s0)
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -808(s0)
	bnez s1, .L84_767
	j .L84_768
.L84_767:
	lw s1, -812(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	j .L84_769
.L84_768:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 24
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 48
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
.L84_769:
	lw s1, -1808(s0)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_756:
	lw s1, -1660(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L84_770
	j .L84_771
.L84_770:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -1804(s0)
.L84_771:
	lw s1, -808(s0)
	bnez s1, .L84_772
	j .L84_773
.L84_772:
	lw s1, -1772(s0)
	bnez s1, .L84_774
	j .L84_775
.L84_774:
	li s1, 84
	sw s1, -1832(s0)
	j .L84_776
.L84_775:
	lw s1, -1804(s0)
	bnez s1, .L84_777
	j .L84_778
.L84_777:
	li s1, 123
	sw s1, -1836(s0)
	j .L84_779
.L84_778:
	li s1, 47
	sw s1, -1836(s0)
.L84_779:
	lw s1, -1836(s0)
	sw s1, -1832(s0)
.L84_776:
	lw s1, -1832(s0)
	sw s1, -1828(s0)
	lw s1, -1828(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -812(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1644(s0)
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1772(s0)
	bnez s1, .L84_780
	j .L84_781
.L84_780:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_781:
	j .L84_782
.L84_773:
	lw s1, -1772(s0)
	bnez s1, .L84_783
	j .L84_784
.L84_783:
	li s1, 83
	sw s1, -1844(s0)
	j .L84_785
.L84_784:
	lw s1, -1804(s0)
	bnez s1, .L84_786
	j .L84_787
.L84_786:
	li s1, 122
	sw s1, -1848(s0)
	j .L84_788
.L84_787:
	li s1, 46
	sw s1, -1848(s0)
.L84_788:
	lw s1, -1848(s0)
	sw s1, -1844(s0)
.L84_785:
	lw s1, -1844(s0)
	sw s1, -1840(s0)
	lw s1, -1840(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 24
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 48
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -1644(s0)
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1772(s0)
	bnez s1, .L84_789
	j .L84_790
.L84_789:
	lw s1, -816(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -12(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L84_790:
.L84_782:
	lw s1, -1660(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L84_791
	j .L84_792
.L84_791:
	lw s1, -1660(s0)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_792:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_26:
	la s1, __str_49
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_27:
	la s1, __str_50
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	lw s4, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s4, 4(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L84_793:
	li s1, 0
	mv a0, s1
	lw s1, -1908(s0)
	lw s2, -1904(s0)
	lw s3, -1900(s0)
	lw s4, -1896(s0)
	lw s5, -1892(s0)
	lw s6, -1888(s0)
	lw s7, -1884(s0)
	lw s8, -1880(s0)
	lw s9, -1876(s0)
	lw s10, -1872(s0)
	lw s11, -1868(s0)
	fld fs0, -1864(s0)
	fld fs1, -1856(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end84:
	.size lower_expr, .Lfunc_end84-lower_expr

	.text
	.align 2
	.type lower_cond, @function
lower_cond:
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
	lw s2, 0(s1)
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L85_0
	j .L85_1
.L85_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 79
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L85_2
	j .L85_1
.L85_2:
	jal ra, new_label
	mv s1, a0
	sw s1, -20(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	lw s1, -20(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
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
.L85_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L85_3
	j .L85_4
.L85_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 80
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L85_5
	j .L85_4
.L85_5:
	jal ra, new_label
	mv s1, a0
	sw s1, -24(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
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
.L85_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L85_6
	j .L85_7
.L85_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 78
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L85_8
	j .L85_7
.L85_8:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
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
.L85_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -28(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_bnz
	mv s3, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, emit_jmp
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
.Lfunc_end85:
	.size lower_cond, .Lfunc_end85-lower_cond

	.text
	.align 2
	.type emit_zero_fill, @function
emit_zero_fill:
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
	li s1, 0
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L86_0:
	lw s1, -8(s0)
	lw s2, -20(s0)
	sub s3, s1, s2
	li s1, 4
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L86_1
	j .L86_2
.L86_1:
	lw s1, -20(s0)
	bnez s1, .L86_3
	j .L86_4
.L86_3:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -28(s0)
	j .L86_5
.L86_4:
	lw s1, -4(s0)
	sw s1, -28(s0)
.L86_5:
	lw s1, -28(s0)
	sw s1, -24(s0)
	li s1, 27
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	sw s3, -20(s0)
	j .L86_0
.L86_2:
	lw s1, -8(s0)
	lw s2, -20(s0)
	sub s3, s1, s2
	li s1, 2
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L86_6
	j .L86_7
.L86_6:
	lw s1, -20(s0)
	bnez s1, .L86_8
	j .L86_9
.L86_8:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -36(s0)
	j .L86_10
.L86_9:
	lw s1, -4(s0)
	sw s1, -36(s0)
.L86_10:
	lw s1, -36(s0)
	sw s1, -32(s0)
	li s1, 26
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -32(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	sw s3, -20(s0)
.L86_7:
	lw s1, -8(s0)
	lw s2, -20(s0)
	sub s3, s1, s2
	li s1, 1
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L86_11
	j .L86_12
.L86_11:
	lw s1, -20(s0)
	bnez s1, .L86_13
	j .L86_14
.L86_13:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -44(s0)
	j .L86_15
.L86_14:
	lw s1, -4(s0)
	sw s1, -44(s0)
.L86_15:
	lw s1, -44(s0)
	sw s1, -40(s0)
	li s1, 25
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -40(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L86_12:
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
.Lfunc_end86:
	.size emit_zero_fill, .Lfunc_end86-emit_zero_fill

	.text
	.align 2
	.type store_leaf, @function
store_leaf:
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
	lw s1, -12(s0)
	bnez s1, .L87_0
	j .L87_1
.L87_0:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L87_2
	j .L87_1
.L87_2:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L87_3
	j .L87_1
.L87_3:
	lw s1, -16(s0)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L87_4
	j .L87_1
.L87_4:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -16(s0)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	sw s3, -24(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -8(s0)
	bnez s1, .L87_5
	j .L87_6
.L87_5:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -36(s0)
	j .L87_7
.L87_6:
	lw s1, -4(s0)
	sw s1, -36(s0)
.L87_7:
	lw s1, -36(s0)
	sw s1, -32(s0)
	lw s1, -32(s0)
	lw s2, -20(s0)
	lw s3, -24(s0)
	lw s4, -28(s0)
	slt s5, s3, s4
	bnez s5, .L87_8
	j .L87_9
.L87_8:
	lw s3, -24(s0)
	sw s3, -40(s0)
	j .L87_10
.L87_9:
	lw s3, -28(s0)
	sw s3, -40(s0)
.L87_10:
	lw s3, -40(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_aggregate_copy
	mv s4, a0
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
.L87_1:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -44(s0)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	sw s2, -48(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L87_11
	j .L87_12
.L87_11:
	lw s1, -44(s0)
	lw s2, -48(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, to_float
	mv s4, a0
	sw s4, -44(s0)
	j .L87_13
.L87_12:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L87_14
	j .L87_15
.L87_14:
	lw s1, -44(s0)
	lw s2, -48(s0)
	mv a0, s1
	mv a1, s2
	jal ra, widen_to_i64
	mv s3, a0
	sw s3, -44(s0)
	j .L87_16
.L87_15:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L87_17
	j .L87_18
.L87_17:
	lw s1, -44(s0)
	lw s2, -48(s0)
	mv a0, s1
	mv a1, s2
	jal ra, to_bool
	mv s3, a0
	sw s3, -44(s0)
.L87_18:
.L87_16:
.L87_13:
	lw s1, -8(s0)
	bnez s1, .L87_19
	j .L87_20
.L87_19:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s2
	jal ra, emit_addr_const
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_addr_add
	mv s2, a0
	sw s2, -56(s0)
	j .L87_21
.L87_20:
	lw s1, -4(s0)
	sw s1, -56(s0)
.L87_21:
	lw s1, -56(s0)
	sw s1, -52(s0)
	lw s1, -52(s0)
	lw s2, -44(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
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
.Lfunc_end87:
	.size store_leaf, .Lfunc_end87-store_leaf

	.text
	.align 2
	.type store_init, @function
store_init:
	addi sp, sp, -128
	sw ra, 124(sp)
	sw s0, 120(sp)
	addi s0, sp, 120
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
	bnez s1, .L88_0
	j .L88_1
.L88_1:
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L88_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_2
	j .L88_3
.L88_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_4
	j .L88_3
.L88_4:
	lw s1, -8(s0)
	lw s2, 0(s1)
	bnez s2, .L88_5
	j .L88_3
.L88_5:
	lw s1, -8(s0)
	lw s2, 0(s1)
	lw s1, 0(s2)
	li s2, 41
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L88_6
	j .L88_3
.L88_6:
	lw s1, -8(s0)
	lw s2, 0(s1)
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -12(s0)
	lw s2, -16(s0)
	lw s3, -4(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, store_leaf
	mv s5, a0
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L88_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, agg_nslots
	mv s2, a0
	sw s2, -24(s0)
	li s1, 0
	sw s1, -28(s0)
.L88_7:
	lw s1, -8(s0)
	lw s2, 0(s1)
	bnez s2, .L88_8
	j .L88_9
.L88_8:
	lw s1, -8(s0)
	lw s2, 0(s1)
	sw s2, -32(s0)
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_10
	j .L88_11
.L88_10:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_12
	j .L88_13
.L88_12:
	lw s1, -32(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L88_14
	j .L88_15
.L88_15:
	lw s1, -28(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L88_14
	j .L88_16
.L88_14:
	la s1, __str_51
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L88_16:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, agg_slot
	mv s4, a0
	sw s4, -36(s0)
	j .L88_17
.L88_13:
	lw s1, -4(s0)
	lw s2, -32(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, field_index
	mv s3, a0
	sw s3, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L88_18
	j .L88_19
.L88_18:
	lw s1, -44(s0)
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L88_20
	j .L88_21
.L88_21:
	lw s1, -28(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L88_20
	j .L88_22
.L88_20:
	la s1, __str_52
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L88_22:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, agg_slot
	mv s4, a0
	sw s4, -36(s0)
	j .L88_23
.L88_19:
	li s1, 0
	sw s1, -36(s0)
	li s1, 0
	sw s1, -48(s0)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
.L88_24:
	lw s1, -52(s0)
	bnez s1, .L88_25
	j .L88_26
.L88_25:
	lw s1, -52(s0)
	lw s2, 0(s1)
	bnez s2, .L88_27
	j .L88_28
.L88_28:
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L88_29
	j .L88_27
.L88_27:
	j .L88_30
.L88_29:
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 13
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L88_31
	j .L88_32
.L88_31:
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 14
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L88_33
	j .L88_32
.L88_33:
	j .L88_30
.L88_32:
	li s1, 0
	sw s1, -56(s0)
	lw s1, -52(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -32(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, resolve_member
	mv s4, a0
	sw s4, -60(s0)
	lw s1, -60(s0)
	bnez s1, .L88_34
	j .L88_35
.L88_34:
	lw s1, -60(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -52(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -56(s0)
	add s3, s1, s2
	lw s1, -60(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	add s2, s3, s1
	sw s2, -40(s0)
	lw s1, -48(s0)
	sw s1, -28(s0)
	j .L88_26
.L88_35:
.L88_30:
	lw s1, -52(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L88_24
.L88_26:
	lw s1, -36(s0)
	bnez s1, .L88_36
	j .L88_37
.L88_37:
	la s1, __str_53
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -32(s0)
	li s4, 48
	add s5, s3, s4
	lw s3, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L88_36:
.L88_23:
.L88_17:
	lw s1, -32(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -32(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_38
	j .L88_39
.L88_38:
	addi s1, s0, -64
	li s2, 0
	sw s2, 0(s1)
	lw s2, -32(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	sw s2, 0(s1)
	lw s1, -36(s0)
	addi s2, s0, -64
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -40(s0)
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, store_init
	mv s4, a0
	j .L88_40
.L88_39:
	lw s1, -12(s0)
	lw s2, -16(s0)
	lw s3, -40(s0)
	add s4, s2, s3
	lw s2, -36(s0)
	lw s3, -32(s0)
	li s5, 24
	add s6, s3, s5
	lw s3, 0(s6)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	mv a3, s3
	jal ra, store_leaf
	mv s5, a0
.L88_40:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L88_7
.L88_11:
	lw s1, -28(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L88_41
	j .L88_42
.L88_41:
	j .L88_9
.L88_42:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, agg_slot
	mv s4, a0
	sw s4, -36(s0)
	lw s1, -36(s0)
	bnez s1, .L88_43
	j .L88_44
.L88_44:
	j .L88_9
.L88_43:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_45
	j .L88_46
.L88_45:
	lw s1, -32(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -36(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L88_47
	j .L88_48
.L88_47:
	addi s1, s0, -68
	li s2, 0
	sw s2, 0(s1)
	lw s2, -32(s0)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	sw s2, 0(s1)
	lw s1, -36(s0)
	addi s2, s0, -68
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -40(s0)
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, store_init
	mv s4, a0
	j .L88_49
.L88_48:
	lw s1, -32(s0)
	mv a0, s1
	jal ra, first_leaf
	mv s2, a0
	sw s2, -72(s0)
	lw s1, -72(s0)
	bnez s1, .L88_50
	j .L88_51
.L88_50:
	lw s1, -12(s0)
	lw s2, -16(s0)
	lw s3, -40(s0)
	add s4, s2, s3
	lw s2, -36(s0)
	lw s3, -72(s0)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	mv a3, s3
	jal ra, store_leaf
	mv s5, a0
.L88_51:
.L88_49:
	j .L88_52
.L88_46:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L88_53
	j .L88_54
.L88_53:
	lw s1, -36(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_55
	j .L88_56
.L88_55:
	lw s1, -36(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_57
	j .L88_56
.L88_57:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L88_54
	j .L88_56
.L88_56:
	lw s1, -36(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	lw s5, -40(s0)
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, store_init
	mv s4, a0
	j .L88_58
.L88_54:
	lw s1, -32(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -12(s0)
	lw s2, -16(s0)
	lw s3, -40(s0)
	add s4, s2, s3
	lw s2, -36(s0)
	lw s3, -32(s0)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	mv a3, s3
	jal ra, store_leaf
	mv s5, a0
.L88_58:
.L88_52:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L88_7
.L88_9:
	li s1, 0
	mv a0, s1
	lw s1, -116(s0)
	lw s2, -112(s0)
	lw s3, -108(s0)
	lw s4, -104(s0)
	lw s5, -100(s0)
	lw s6, -96(s0)
	lw s7, -92(s0)
	lw s8, -88(s0)
	lw s9, -84(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end88:
	.size store_init, .Lfunc_end88-store_init

	.text
	.align 2
	.type lower_local_decl, @function
lower_local_decl:
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
	fsd fs0, 48(sp)
	fsd fs1, 56(sp)
	sw a0, -4(s0)
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_0
	j .L89_1
.L89_1:
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
	fld fs0, -280(s0)
	fld fs1, -272(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L89_0:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_2
	j .L89_3
.L89_2:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_4
	j .L89_3
.L89_4:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 80
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, compound_matches
	mv s3, a0
	bnez s3, .L89_5
	j .L89_3
.L89_5:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L89_3:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_6
	j .L89_7
.L89_6:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_8
	j .L89_7
.L89_8:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L89_7
	j .L89_9
.L89_9:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_10
	j .L89_7
.L89_10:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_7
	j .L89_11
.L89_11:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L89_12
	j .L89_7
.L89_12:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L89_7:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_13
	j .L89_14
.L89_13:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_15
	j .L89_14
.L89_15:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L89_14
	j .L89_16
.L89_16:
	la s1, __str_54
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L89_14:
	lw s1, -4(s0)
	li s2, 88
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_17
	j .L89_18
.L89_18:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_17
	j .L89_19
.L89_17:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -12(s0)
	lw s4, 0(s3)
	li s3, 12
	xor s5, s4, s3
	seqz s5, s5
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, add_global
	mv s3, a0
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
	fld fs0, -280(s0)
	fld fs1, -272(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L89_19:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
	lw s1, -4(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_20
	j .L89_21
.L89_20:
	addi s1, s0, -144
	li s2, 128
	la s3, __str_55
	la s4, cur_fn_name
	lw s5, 0(s4)
	lw s4, -4(s0)
	li s6, 48
	add s7, s4, s6
	lw t0, 0(s7)
	sw t0, -264(s0)
	la s6, static_counter
	lw t0, 0(s6)
	sw t0, -260(s0)
	li s7, 1
	lw t0, -260(s0)
	add s4, t0, s7
	sw s4, 0(s6)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s5, 0(sp)
	lw t0, -264(s0)
	sw t0, 4(sp)
	lw t0, -260(s0)
	sw t0, 8(sp)
	jal ra, snprintf
	mv s4, a0
	addi sp, sp, 16
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 68
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -148(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	addi s1, s0, -144
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -148(s0)
	sw s3, 0(s1)
	li s1, 1
	lw s2, -148(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, type_is_readonly
	mv s2, a0
	lw s1, -148(s0)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, type_to_ir
	mv s2, a0
	lw s1, -148(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_22
	j .L89_23
.L89_22:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L89_24
	j .L89_23
.L89_24:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_25
	j .L89_23
.L89_25:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_26
	j .L89_23
.L89_26:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
.L89_23:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, wants_image
	mv s3, a0
	bnez s3, .L89_27
	j .L89_28
.L89_27:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_29
	j .L89_30
.L89_29:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L89_31
	j .L89_30
.L89_31:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_32
	j .L89_30
.L89_32:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_33
	j .L89_30
.L89_33:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, infer_array_len
	mv s2, a0
	lw s1, -12(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
.L89_30:
	li s1, 2
	lw s2, -148(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	lw s1, -148(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	lw s1, -148(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_34
	j .L89_35
.L89_34:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_36
	j .L89_35
.L89_36:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, lower_aggregate_init
	mv s3, a0
	lw s1, -148(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
.L89_35:
	j .L89_37
.L89_28:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_38
	j .L89_39
.L89_38:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, type_to_ir
	mv s2, a0
	lw s1, -148(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L89_40
	j .L89_41
.L89_40:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_42
	j .L89_41
.L89_42:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_43
	j .L89_41
.L89_43:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, infer_array_len
	mv s2, a0
	lw s1, -12(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
.L89_41:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L89_44
	j .L89_45
.L89_44:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -152(s0)
	j .L89_46
.L89_45:
	li s1, 0
	sw s1, -152(s0)
.L89_46:
	lw s1, -152(s0)
	lw s2, -148(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L89_39:
.L89_37:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_47
	j .L89_48
.L89_47:
	lw s1, -148(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_48
	j .L89_49
.L89_49:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_50
	j .L89_51
.L89_50:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, count_init_flat
	mv s2, a0
	sw s2, -156(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -156(s0)
	li s3, 8
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -148(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -156(s0)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_zalloc
	mv s1, a0
	lw s2, -148(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -160(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, flat_elem_type
	mv s2, a0
	lw s1, -4(s0)
	li s3, 24
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -148(s0)
	li s4, 44
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -148(s0)
	li s5, 48
	add s6, s4, s5
	lw s4, 0(s6)
	addi s5, s0, -160
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, flatten_init
	mv s6, a0
	lw s1, -160(s0)
	lw s2, -148(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -148(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L89_52
	j .L89_53
.L89_52:
	lw s1, -160(s0)
	lw s2, -148(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L89_53:
	j .L89_54
.L89_51:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_55
	j .L89_56
.L89_55:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L89_57
	j .L89_56
.L89_57:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 24
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 76
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 1
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -148(s0)
	li s3, 56
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -148(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 72
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -148(s0)
	li s3, 56
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -148(s0)
	li s2, 60
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -148(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L89_58
	j .L89_59
.L89_58:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -148(s0)
	li s2, 12
	add s4, s1, s2
	sw s3, 0(s4)
.L89_59:
	j .L89_60
.L89_56:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_61
	j .L89_62
.L89_61:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -168(s0)
	sw s11, -164(s0)
	li s1, 0
	sw s1, -172(s0)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -168
	addi s4, s0, -172
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, encode_scalar
	mv s5, a0
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -148(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s10, -168(s0)
	lw s11, -164(s0)
	lw s1, -148(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	lw s1, -172(s0)
	bnez s1, .L89_63
	j .L89_64
.L89_63:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 4
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	lw s1, -148(s0)
	li s2, 48
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -172(s0)
	lw s2, -148(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L89_64:
	li s1, 1
	lw s2, -148(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L89_65
.L89_62:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_66
	j .L89_67
.L89_67:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_66
	j .L89_68
.L89_68:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_66
	j .L89_69
.L89_66:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -184(s0)
	sw s11, -180(s0)
	li s1, 0
	sw s1, -188(s0)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -184
	addi s4, s0, -188
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, encode_scalar
	mv s5, a0
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -148(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s10, -184(s0)
	lw s11, -180(s0)
	lw s1, -148(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 1
	lw s2, -148(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L89_70
.L89_69:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L89_71
	j .L89_72
.L89_71:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_73
	j .L89_74
.L89_73:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	la s1, __flt_56
	fld fs1, 0(s1)
	feq.d s1, fs0, fs1
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	fsd fs2, -208(s0)
	j .L89_75
.L89_74:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, fold_int_const
	mv s10, a0
	mv s11, a1
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s1, t0
	fcvt.d.w fs0, s1
	fsd fs0, -208(s0)
.L89_75:
	fld fs0, -208(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, -200(s0)
	sw s11, -196(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -148(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s10, -200(s0)
	lw s11, -196(s0)
	lw s1, -148(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 1
	lw s2, -148(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L89_76
.L89_72:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_77
	j .L89_78
.L89_77:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -148(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -148(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 1
	lw s2, -148(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L89_79
.L89_78:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_80
	j .L89_81
.L89_80:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L89_82
	j .L89_81
.L89_82:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_83
	j .L89_81
.L89_83:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_84
	j .L89_81
.L89_84:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -148(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	lw s1, -148(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s8, 0(s2)
	sw s9, 4(s2)
	li s1, 1
	lw s2, -148(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L89_85
.L89_81:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_is_integer
	mv s2, a0
	bnez s2, .L89_86
	j .L89_87
.L89_86:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -148(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, fold_int_const
	mv s10, a0
	mv s11, a1
	lw s1, -148(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 1
	lw s2, -148(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
.L89_87:
.L89_85:
.L89_79:
.L89_76:
.L89_70:
.L89_65:
.L89_60:
.L89_54:
.L89_48:
	la s1, cur_prog
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -148(s0)
	li s3, 64
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -148(s0)
	la s2, cur_prog
	lw s3, 0(s2)
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -144
	lw s2, -12(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, add_global
	mv s4, a0
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_88
	j .L89_89
.L89_88:
	la s1, nlocals
	lw s2, 0(s1)
	la s1, local_cap
	lw s3, 0(s1)
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L89_90
	j .L89_91
.L89_90:
	la s1, local_cap
	lw s2, 0(s1)
	bnez s2, .L89_92
	j .L89_93
.L89_92:
	la s1, local_cap
	lw s2, 0(s1)
	li s1, 2
	mul s3, s2, s1
	sw s3, -212(s0)
	j .L89_94
.L89_93:
	li s1, 32
	sw s1, -212(s0)
.L89_94:
	lw s1, -212(s0)
	la s2, local_cap
	sw s1, 0(s2)
	la s1, locals
	lw s2, 0(s1)
	la s1, local_cap
	lw s3, 0(s1)
	li s1, 20
	mul s4, s3, s1
	mv a0, s2
	mv a1, s4
	jal ra, realloc
	mv s1, a0
	la s2, locals
	sw s1, 0(s2)
.L89_91:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 48
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	la s1, locals
	lw s2, 0(s1)
	la s1, nlocals
	lw s4, 0(s1)
	li s1, 20
	mul s5, s4, s1
	add s1, s2, s5
	sw s3, 0(s1)
	li s1, 1
	neg s2, s1
	la s1, locals
	lw s3, 0(s1)
	la s1, nlocals
	lw s4, 0(s1)
	li s1, 20
	mul s5, s4, s1
	add s1, s3, s5
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	la s2, locals
	lw s3, 0(s2)
	la s2, nlocals
	lw s4, 0(s2)
	li s2, 20
	mul s5, s4, s2
	add s2, s3, s5
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	addi s1, s0, -144
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	la s1, locals
	lw s2, 0(s1)
	la s1, nlocals
	lw s4, 0(s1)
	li s1, 20
	mul s5, s4, s1
	add s1, s2, s5
	li s2, 12
	add s4, s1, s2
	sw s3, 0(s4)
	la s1, nlocals
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
.L89_89:
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
	fld fs0, -280(s0)
	fld fs1, -272(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L89_21:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_95
	j .L89_96
.L89_95:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L89_97
	j .L89_96
.L89_97:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_98
	j .L89_96
.L89_98:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_99
	j .L89_96
.L89_99:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, infer_array_len
	mv s2, a0
	lw s1, -12(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
.L89_96:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_100
	j .L89_101
.L89_100:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L89_102
	j .L89_101
.L89_102:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_103
	j .L89_101
.L89_103:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_104
	j .L89_101
.L89_104:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
.L89_101:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -216(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L89_105
	j .L89_106
.L89_105:
	lw s1, -216(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L89_107
	j .L89_106
.L89_107:
	li s1, 8
	sw s1, -216(s0)
.L89_106:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L89_108
	j .L89_109
.L89_108:
	lw s1, -216(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L89_110
	j .L89_109
.L89_110:
	li s1, 8
	sw s1, -216(s0)
.L89_109:
	lw s1, -216(s0)
	lw s2, -12(s0)
	mv a0, s2
	jal ra, cc_type_align
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, alloc_slot
	mv s2, a0
	sw s2, -220(s0)
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_111
	j .L89_112
.L89_111:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -220(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, add_local
	mv s4, a0
	lw s1, -4(s0)
	li s2, 72
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_113
	j .L89_114
.L89_113:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 72
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -4(s0)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	la s1, locals
	lw s2, 0(s1)
	la s1, nlocals
	lw s3, 0(s1)
	li s1, 1
	sub s5, s3, s1
	li s1, 20
	mul s3, s5, s1
	add s1, s2, s3
	li s2, 16
	add s3, s1, s2
	sw s4, 0(s3)
.L89_114:
.L89_112:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L89_115
	j .L89_116
.L89_116:
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
	fld fs0, -280(s0)
	fld fs1, -272(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L89_115:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_117
	j .L89_118
.L89_117:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L89_119
	j .L89_118
.L89_119:
	lw s1, -220(s0)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	sw s2, -224(s0)
	lw s1, -224(s0)
	lw s2, -12(s0)
	mv a0, s2
	jal ra, cc_type_size
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, emit_zero_fill
	mv s2, a0
	addi s1, s0, -228
	li s2, 0
	sw s2, 0(s1)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	sw s2, 0(s1)
	lw s1, -12(s0)
	addi s2, s0, -228
	lw s3, -224(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, store_init
	mv s5, a0
	j .L89_120
.L89_118:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L89_121
	j .L89_122
.L89_121:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L89_123
	j .L89_122
.L89_123:
	lw s1, -220(s0)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	sw s2, -232(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -236(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	sw s3, -240(s0)
	lw s1, -240(s0)
	lw s2, -236(s0)
	slt s3, s2, s1
	bnez s3, .L89_124
	j .L89_125
.L89_124:
	lw s1, -236(s0)
	sw s1, -240(s0)
.L89_125:
	lw s1, -232(s0)
	lw s2, -236(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_zero_fill
	mv s3, a0
	lw s1, -232(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lower_expr
	mv s3, a0
	lw s2, -240(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, emit_aggregate_copy
	mv s4, a0
	j .L89_126
.L89_122:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	sw s2, -244(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L89_127
	j .L89_128
.L89_127:
	lw s1, -220(s0)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	lw s1, -244(s0)
	lw s3, -12(s0)
	mv a0, s3
	jal ra, cc_type_size
	mv s4, a0
	mv a0, s2
	mv a1, s1
	mv a2, s4
	jal ra, emit_aggregate_copy
	mv s3, a0
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
	fld fs0, -280(s0)
	fld fs1, -272(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L89_128:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L89_129
	j .L89_130
.L89_129:
	li s1, 81
	sw s1, -248(s0)
	lw s1, -244(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, to_float
	mv s4, a0
	sw s4, -244(s0)
	j .L89_131
.L89_130:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L89_132
	j .L89_133
.L89_132:
	li s1, 113
	sw s1, -248(s0)
	lw s1, -244(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, widen_to_i64
	mv s2, a0
	sw s2, -244(s0)
	j .L89_134
.L89_133:
	li s1, 29
	sw s1, -248(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L89_135
	j .L89_136
.L89_135:
	lw s1, -244(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, to_bool
	mv s2, a0
	sw s2, -244(s0)
.L89_136:
.L89_134:
.L89_131:
	lw s1, -248(s0)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -252(s0)
	lw s1, -244(s0)
	lw s2, -252(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -252(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -248(s0)
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L89_137
	j .L89_138
.L89_137:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fwidth
	mv s2, a0
	lw s1, -252(s0)
	li s3, 16
	add s4, s1, s3
	mv s10, s2
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L89_138:
.L89_126:
.L89_120:
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
	fld fs0, -280(s0)
	fld fs1, -272(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end89:
	.size lower_local_decl, .Lfunc_end89-lower_local_decl

	.text
	.align 2
	.type collect_cases, @function
collect_cases:
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
	bnez s1, .L90_0
	j .L90_1
.L90_1:
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
.L90_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L90_2
	j .L90_3
.L90_2:
	jal ra, new_label
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_const_eval
	mv s10, a0
	mv s11, a1
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	sw s10, 0(s1)
	lw s1, -12(s0)
	lw s2, -8(s0)
	li s3, 1036
	add s4, s2, s3
	lw s2, -8(s0)
	li s3, 8
	add s5, s2, s3
	lw s2, 0(s5)
	li s3, 4
	mul s5, s2, s3
	add s2, s4, s5
	sw s1, 0(s2)
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, collect_cases
	mv s3, a0
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
.L90_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L90_4
	j .L90_5
.L90_4:
	jal ra, new_label
	mv s1, a0
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, collect_cases
	mv s3, a0
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
.L90_5:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 3
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L90_6
	j .L90_7
.L90_6:
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
.L90_8:
	lw s1, -16(s0)
	bnez s1, .L90_9
	j .L90_10
.L90_9:
	lw s1, -16(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, collect_cases
	mv s3, a0
.L90_11:
	lw s1, -16(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L90_8
.L90_10:
.L90_7:
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
.Lfunc_end90:
	.size collect_cases, .Lfunc_end90-collect_cases

	.text
	.align 2
	.type lower_stmt, @function
lower_stmt:
	li t6, -2448
	add sp, sp, t6
	li t6, 2444
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 2440
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 2440
	add s0, sp, t6
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
	bnez s1, .L91_0
	j .L91_1
.L91_1:
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_0:
	la s1, cc_debug
	lw s2, 0(s1)
	bnez s2, .L91_2
	j .L91_3
.L91_2:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L91_4
	j .L91_3
.L91_4:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, last_loc_line
	lw s3, 0(s2)
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L91_5
	j .L91_3
.L91_5:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 3
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L91_6
	j .L91_3
.L91_6:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, cur_fn
	lw s3, 0(s2)
	lw s2, -4(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	mv a0, s3
	mv a1, s2
	jal ra, ir_loc
	mv s4, a0
	li s2, 12
	add s3, s4, s2
	sw s1, 0(s3)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, last_loc_line
	sw s1, 0(s2)
.L91_3:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 3
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_7
	li s1, 16
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_8
	li s1, 17
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_9
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_10
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_11
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_12
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_13
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_14
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_15
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_16
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_17
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_18
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_19
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_20
	li s1, 15
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_21
	li s1, 18
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_22
	j .L91_23
.L91_7:
	la s1, nlocals
	lw s2, 0(s1)
	sw s2, -16(s0)
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
.L91_24:
	lw s1, -20(s0)
	bnez s1, .L91_25
	j .L91_26
.L91_25:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
.L91_27:
	lw s1, -20(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L91_24
.L91_26:
	lw s1, -16(s0)
	la s2, nlocals
	sw s1, 0(s2)
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_8:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_28
	j .L91_29
.L91_28:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
.L91_29:
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_9:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lower_local_decl
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_10:
	jal ra, new_label
	mv s1, a0
	sw s1, -24(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -28(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -32(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	lw s3, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	lw s1, -24(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_30
	j .L91_31
.L91_30:
	lw s1, -32(s0)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	lw s1, -28(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	lw s1, -32(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	j .L91_32
.L91_31:
	lw s1, -28(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
.L91_32:
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_11:
	jal ra, new_label
	mv s1, a0
	sw s1, -36(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -40(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -44(s0)
	lw s1, -36(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -40(s0)
	lw s3, -44(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	lw s1, -40(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -44(s0)
	la s2, loop_stack
	la s3, nloops
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -36(s0)
	la s2, loop_stack
	la s3, nloops
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, nloops
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	la s1, nloops
	lw s2, 0(s1)
	li s3, -1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -36(s0)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	lw s1, -44(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_12:
	jal ra, new_label
	mv s1, a0
	sw s1, -48(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -52(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -56(s0)
	lw s1, -48(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -56(s0)
	la s2, loop_stack
	la s3, nloops
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -52(s0)
	la s2, loop_stack
	la s3, nloops
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, nloops
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	la s1, nloops
	lw s2, 0(s1)
	li s3, -1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -52(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -48(s0)
	lw s3, -56(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	lw s1, -56(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_13:
	jal ra, new_label
	mv s1, a0
	sw s1, -60(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -64(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -68(s0)
	jal ra, new_label
	mv s1, a0
	sw s1, -72(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_33
	j .L91_34
.L91_33:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 17
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_35
	j .L91_36
.L91_35:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -76(s0)
.L91_37:
	lw s1, -76(s0)
	bnez s1, .L91_38
	j .L91_39
.L91_38:
	lw s1, -76(s0)
	mv a0, s1
	jal ra, lower_local_decl
	mv s2, a0
.L91_40:
	lw s1, -76(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -76(s0)
	j .L91_37
.L91_39:
	j .L91_41
.L91_36:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
.L91_41:
.L91_34:
	lw s1, -60(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_42
	j .L91_43
.L91_42:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -64(s0)
	lw s3, -72(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, lower_cond
	mv s4, a0
	j .L91_44
.L91_43:
	lw s1, -64(s0)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
.L91_44:
	lw s1, -64(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -72(s0)
	la s2, loop_stack
	la s3, nloops
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -68(s0)
	la s2, loop_stack
	la s3, nloops
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	la s1, nloops
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	la s1, nloops
	lw s2, 0(s1)
	li s3, -1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -68(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_45
	j .L91_46
.L91_45:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
.L91_46:
	lw s1, -60(s0)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	lw s1, -72(s0)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_14:
	li t6, -2136
	add s1, s0, t6
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 60
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 64
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 68
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 72
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 76
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 80
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 84
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 88
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 92
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 96
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 100
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 104
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 108
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 112
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 116
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 120
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 124
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 128
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 132
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 136
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 140
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 144
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 148
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 152
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 156
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 160
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 164
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 168
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 172
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 176
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 180
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 184
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 188
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 192
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 196
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 200
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 204
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 208
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 212
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 216
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 220
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 224
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 228
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 232
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 236
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 240
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 244
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 248
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 252
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 256
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 260
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 264
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 268
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 272
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 276
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 280
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 284
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 288
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 292
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 296
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 300
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 304
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 308
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 312
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 316
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 320
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 324
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 328
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 332
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 336
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 340
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 344
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 348
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 352
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 356
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 360
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 364
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 368
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 372
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 376
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 380
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 384
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 388
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 392
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 396
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 400
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 404
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 408
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 412
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 416
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 420
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 424
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 428
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 432
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 436
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 440
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 444
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 448
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 452
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 456
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 460
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 464
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 468
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 472
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 476
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 480
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 484
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 488
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 492
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 496
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 500
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 504
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 508
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 512
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 516
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 520
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 524
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 528
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 532
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 536
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 540
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 544
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 548
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 552
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 556
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 560
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 564
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 568
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 572
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 576
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 580
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 584
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 588
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 592
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 596
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 600
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 604
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 608
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 612
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 616
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 620
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 624
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 628
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 632
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 636
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 640
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 644
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 648
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 652
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 656
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 660
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 664
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 668
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 672
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 676
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 680
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 684
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 688
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 692
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 696
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 700
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 704
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 708
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 712
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 716
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 720
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 724
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 728
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 732
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 736
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 740
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 744
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 748
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 752
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 756
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 760
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 764
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 768
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 772
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 776
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 780
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 784
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 788
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 792
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 796
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 800
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 804
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 808
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 812
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 816
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 820
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 824
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 828
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 832
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 836
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 840
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 844
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 848
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 852
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 856
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 860
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 864
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 868
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 872
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 876
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 880
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 884
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 888
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 892
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 896
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 900
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 904
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 908
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 912
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 916
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 920
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 924
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 928
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 932
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 936
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 940
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 944
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 948
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 952
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 956
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 960
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 964
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 968
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 972
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 976
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 980
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 984
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 988
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 992
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 996
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1000
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1004
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1008
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1012
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1016
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1020
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1024
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1028
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1032
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1036
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1040
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1044
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1048
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1052
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1056
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1060
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1064
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1068
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1072
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1076
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1080
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1084
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1088
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1092
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1096
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1100
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1104
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1108
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1112
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1116
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1120
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1124
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1128
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1132
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1136
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1140
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1144
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1148
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1152
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1156
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1160
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1164
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1168
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1172
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1176
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1180
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1184
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1188
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1192
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1196
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1200
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1204
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1208
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1212
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1216
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1220
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1224
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1228
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1232
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1236
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1240
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1244
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1248
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1252
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1256
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1260
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1264
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1268
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1272
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1276
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1280
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1284
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1288
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1292
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1296
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1300
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1304
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1308
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1312
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1316
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1320
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1324
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1328
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1332
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1336
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1340
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1344
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1348
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1352
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1356
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1360
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1364
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1368
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1372
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1376
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1380
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1384
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1388
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1392
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1396
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1400
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1404
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1408
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1412
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1416
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1420
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1424
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1428
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1432
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1436
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1440
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1444
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1448
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1452
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1456
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1460
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1464
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1468
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1472
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1476
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1480
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1484
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1488
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1492
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1496
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1500
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1504
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1508
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1512
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1516
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1520
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1524
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1528
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1532
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1536
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1540
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1544
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1548
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1552
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1556
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1560
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1564
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1568
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1572
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1576
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1580
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1584
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1588
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1592
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1596
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1600
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1604
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1608
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1612
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1616
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1620
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1624
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1628
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1632
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1636
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1640
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1644
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1648
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1652
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1656
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1660
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1664
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1668
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1672
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1676
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1680
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1684
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1688
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1692
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1696
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1700
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1704
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1708
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1712
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1716
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1720
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1724
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1728
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1732
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1736
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1740
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1744
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1748
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1752
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1756
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1760
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1764
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1768
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1772
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1776
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1780
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1784
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1788
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1792
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1796
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1800
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1804
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1808
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1812
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1816
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1820
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1824
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1828
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1832
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1836
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1840
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1844
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1848
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1852
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1856
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1860
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1864
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1868
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1872
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1876
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1880
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1884
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1888
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1892
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1896
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1900
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1904
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1908
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1912
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1916
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1920
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1924
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1928
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1932
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1936
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1940
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1944
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1948
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1952
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1956
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1960
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1964
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1968
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1972
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1976
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1980
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1984
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1988
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1992
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 1996
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2000
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2004
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2008
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2012
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2016
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2020
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2024
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2028
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2032
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2036
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2040
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2044
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2048
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2052
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 2056
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	jal ra, new_label
	mv s1, a0
	li t6, -2136
	add s2, s0, t6
	sw s1, 0(s2)
	li s1, 1
	neg s2, s1
	li t6, -2136
	add s1, s0, t6
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2136
	add s2, s0, t6
	mv a0, s1
	mv a1, s2
	jal ra, collect_cases
	mv s3, a0
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	li t6, -2140
	add t6, s0, t6
	sw s2, 0(t6)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	mv a0, s2
	jal ra, is_i64_type
	mv s1, a0
	li t6, -2144
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 0
	li t6, -2148
	add t6, s0, t6
	sw s1, 0(t6)
.L91_47:
	li t6, -2148
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2136
	add s2, s0, t6
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L91_48
	j .L91_49
.L91_48:
	li t6, -2144
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_50
	j .L91_51
.L91_50:
	li t6, -2136
	add s1, s0, t6
	li s2, 12
	add s3, s1, s2
	li t6, -2148
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	mv s10, s2
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
	jal ra, lower_const64
	mv s1, a0
	li t6, -2156
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_52
.L91_51:
	li t6, -2136
	add s1, s0, t6
	li s2, 12
	add s3, s1, s2
	li t6, -2148
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	mv a0, s2
	jal ra, lower_const
	mv s1, a0
	li t6, -2156
	add t6, s0, t6
	sw s1, 0(t6)
.L91_52:
	li t6, -2156
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2152
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -2144
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_53
	j .L91_54
.L91_53:
	li s1, 100
	li t6, -2160
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_55
.L91_54:
	li s1, 31
	li t6, -2160
	add t6, s0, t6
	sw s1, 0(t6)
.L91_55:
	li t6, -2160
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2140
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2152
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2136
	add s2, s0, t6
	li s3, 1036
	add s4, s2, s3
	li t6, -2148
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s5, s2, s3
	add s2, s4, s5
	lw s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, emit_bnz
	mv s2, a0
.L91_56:
	li t6, -2148
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2148
	add t6, s0, t6
	sw s3, 0(t6)
	j .L91_47
.L91_49:
	li t6, -2136
	add s1, s0, t6
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L91_57
	j .L91_58
.L91_57:
	li t6, -2136
	add s1, s0, t6
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	j .L91_59
.L91_58:
	li t6, -2136
	add s1, s0, t6
	lw s2, 0(s1)
	mv a0, s2
	jal ra, emit_jmp
	mv s1, a0
.L91_59:
	la s1, cur_switch
	lw s2, 0(s1)
	li t6, -2164
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -2136
	add s1, s0, t6
	la s2, cur_switch
	sw s1, 0(s2)
	li t6, -2136
	add s1, s0, t6
	lw s2, 0(s1)
	la s1, loop_stack
	la s3, nloops
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s1, s5
	sw s2, 0(s3)
	li s1, 1
	neg s2, s1
	la s1, loop_stack
	la s3, nloops
	lw s4, 0(s3)
	li s3, 8
	mul s5, s4, s3
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	sw s2, 0(s4)
	la s1, nloops
	lw s2, 0(s1)
	li s3, 1
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	la s1, nloops
	lw s2, 0(s1)
	li s3, -1
	add s4, s2, s3
	sw s4, 0(s1)
	li t6, -2164
	add t6, s0, t6
	lw s1, 0(t6)
	la s2, cur_switch
	sw s1, 0(s2)
	li t6, -2136
	add s1, s0, t6
	lw s2, 0(s1)
	mv a0, s2
	jal ra, emit_label
	mv s1, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_15:
	la s1, cur_switch
	lw s2, 0(s1)
	bnez s2, .L91_60
	j .L91_61
.L91_61:
	la s1, __str_57
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L91_60:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_const_eval
	mv s10, a0
	mv s11, a1
	li t6, -2168
	add t6, s0, t6
	sw s10, 0(t6)
	li s1, 0
	li t6, -2172
	add t6, s0, t6
	sw s1, 0(t6)
.L91_62:
	li t6, -2172
	add t6, s0, t6
	lw s1, 0(t6)
	la s2, cur_switch
	lw s3, 0(s2)
	li s2, 8
	add s4, s3, s2
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L91_63
	j .L91_64
.L91_63:
	la s1, cur_switch
	lw s2, 0(s1)
	li s1, 12
	add s3, s2, s1
	li t6, -2172
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	li t6, -2168
	add t6, s0, t6
	lw s1, 0(t6)
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_65
	j .L91_66
.L91_65:
	la s1, cur_switch
	lw s2, 0(s1)
	li s1, 1036
	add s3, s2, s1
	li t6, -2172
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	mv a0, s2
	jal ra, emit_label
	mv s1, a0
	j .L91_64
.L91_66:
.L91_67:
	li t6, -2172
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2172
	add t6, s0, t6
	sw s3, 0(t6)
	j .L91_62
.L91_64:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_16:
	la s1, cur_switch
	lw s2, 0(s1)
	bnez s2, .L91_68
	j .L91_69
.L91_69:
	la s1, __str_58
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L91_68:
	la s1, cur_switch
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_label
	mv s2, a0
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_17:
	la s1, nloops
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L91_70
	j .L91_71
.L91_70:
	la s1, __str_59
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L91_71:
	la s1, loop_stack
	la s2, nloops
	lw s3, 0(s2)
	li s2, 1
	sub s4, s3, s2
	li s2, 8
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_18:
	la s1, nloops
	lw s2, 0(s1)
	li s1, 1
	sub s3, s2, s1
	li t6, -2176
	add t6, s0, t6
	sw s3, 0(t6)
.L91_72:
	li t6, -2176
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L91_73
	j .L91_74
.L91_73:
	la s1, loop_stack
	li t6, -2176
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L91_75
	j .L91_74
.L91_75:
	li t6, -2176
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	li t6, -2176
	add t6, s0, t6
	sw s3, 0(t6)
	j .L91_72
.L91_74:
	li t6, -2176
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L91_76
	j .L91_77
.L91_76:
	la s1, __str_60
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L91_77:
	la s1, loop_stack
	li t6, -2176
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	mv a0, s1
	jal ra, emit_jmp
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_19:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_78
	j .L91_79
.L91_78:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	li t6, -2180
	add t6, s0, t6
	sw s2, 0(t6)
	la s1, cur_fn_ret_mem
	lw s2, 0(s1)
	bnez s2, .L91_80
	j .L91_81
.L91_80:
	li s1, 28
	mv a0, s1
	jal ra, emit
	mv s2, a0
	li t6, -2184
	add t6, s0, t6
	sw s2, 0(t6)
	jal ra, new_temp
	mv s1, a0
	li t6, -2184
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, cur_fn_sret_slot
	lw s2, 0(s1)
	li t6, -2184
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li t6, -2184
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2180
	add t6, s0, t6
	lw s2, 0(t6)
	la s3, cur_fn_ret_type
	lw s4, 0(s3)
	mv a0, s4
	jal ra, cc_type_size
	mv s3, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_aggregate_copy
	mv s4, a0
	li s1, 51
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	li t6, -2184
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_81:
	la s1, cur_fn_ret_neb
	lw s2, 0(s1)
	li s1, 0
	slt s3, s1, s2
	bnez s3, .L91_82
	j .L91_83
.L91_82:
	li s1, 124
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	li t6, -2180
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_83:
	la s1, cur_fn_returns_i64
	lw s2, 0(s1)
	bnez s2, .L91_84
	j .L91_85
.L91_84:
	li t6, -2180
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, widen_to_i64
	mv s2, a0
	li t6, -2180
	add t6, s0, t6
	sw s2, 0(t6)
	j .L91_86
.L91_85:
	la s1, cur_fn_returns_float
	lw s2, 0(s1)
	bnez s2, .L91_87
	j .L91_88
.L91_87:
	li t6, -2180
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	la s2, cur_fn_ret_type
	lw s4, 0(s2)
	mv a0, s1
	mv a1, s3
	mv a2, s4
	jal ra, to_float
	mv s2, a0
	li t6, -2180
	add t6, s0, t6
	sw s2, 0(t6)
	j .L91_89
.L91_88:
	la s1, cur_fn_ret_type
	lw s2, 0(s1)
	mv a0, s2
	jal ra, is_bool_type
	mv s1, a0
	bnez s1, .L91_90
	j .L91_91
.L91_90:
	li t6, -2180
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s2
	jal ra, lvalue_type
	mv s3, a0
	mv a0, s1
	mv a1, s3
	jal ra, to_bool
	mv s2, a0
	li t6, -2180
	add t6, s0, t6
	sw s2, 0(t6)
.L91_91:
.L91_89:
.L91_86:
	la s1, cur_fn_returns_float
	lw s2, 0(s1)
	bnez s2, .L91_92
	j .L91_93
.L91_92:
	li s1, 82
	li t6, -2192
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_94
.L91_93:
	la s1, cur_fn_returns_i64
	lw s2, 0(s1)
	bnez s2, .L91_95
	j .L91_96
.L91_95:
	li s1, 121
	li t6, -2196
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_97
.L91_96:
	li s1, 51
	li t6, -2196
	add t6, s0, t6
	sw s1, 0(t6)
.L91_97:
	li t6, -2196
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2192
	add t6, s0, t6
	sw s1, 0(t6)
.L91_94:
	li t6, -2192
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2188
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -2188
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -12(s0)
	li t6, -2180
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2188
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 82
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L91_98
	j .L91_99
.L91_98:
	la s1, cur_fn_ret_type
	lw s2, 0(s1)
	mv a0, s2
	jal ra, fwidth
	mv s1, a0
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
.L91_99:
	j .L91_100
.L91_79:
	li s1, 50
	mv a0, s1
	jal ra, emit
	mv s2, a0
.L91_100:
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_20:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_101
	j .L91_102
.L91_101:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	li t6, -2200
	add t6, s0, t6
	sw s2, 0(t6)
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L91_103
	j .L91_104
.L91_103:
	li s1, 140
	li t6, -2208
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_105
.L91_104:
	li s1, 138
	li t6, -2208
	add t6, s0, t6
	sw s1, 0(t6)
.L91_105:
	li t6, -2208
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, emit
	mv s2, a0
	li t6, -2204
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -2200
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2204
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	j .L91_106
.L91_102:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, get_named_label
	mv s2, a0
	mv a0, s2
	jal ra, emit_jmp
	mv s1, a0
.L91_106:
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_21:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, get_named_label
	mv s2, a0
	mv a0, s2
	jal ra, emit_label
	mv s1, a0
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_22:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 72
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -4(s0)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	li t6, -2220
	add t6, s0, t6
	sw s4, 0(t6)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_107
	j .L91_108
.L91_108:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_107
	j .L91_109
.L91_109:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L91_107
	j .L91_110
.L91_110:
	li s1, 129
	mv a0, s1
	jal ra, emit
	mv s2, a0
	li t6, -2212
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -2220
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2212
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_107:
	li s1, 0
	li t6, -2224
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 0
	li t6, -2228
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 0
	li t6, -2232
	add t6, s0, t6
	sw s1, 0(t6)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
.L91_111:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_112
	j .L91_113
.L91_112:
	li t6, -2224
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2224
	add t6, s0, t6
	sw s3, 0(t6)
.L91_114:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_111
.L91_113:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
.L91_115:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_116
	j .L91_117
.L91_116:
	li t6, -2228
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2228
	add t6, s0, t6
	sw s3, 0(t6)
.L91_118:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_115
.L91_117:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
.L91_119:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_120
	j .L91_121
.L91_120:
	li t6, -2232
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2232
	add t6, s0, t6
	sw s3, 0(t6)
.L91_122:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_119
.L91_121:
	li t6, -2224
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 16
	slt s3, s2, s1
	bnez s3, .L91_123
	j .L91_124
.L91_123:
	la s1, __str_61
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L91_124:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 24
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	li t6, -2372
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -2224
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	sw s1, 0(s2)
	li t6, -2228
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2232
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	li t6, -2224
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2228
	add t6, s0, t6
	lw s3, 0(t6)
	add s4, s1, s3
	li s1, 24
	mul s3, s4, s1
	mv a0, s2
	mv a1, s3
	jal ra, arena_alloc
	mv s1, a0
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2232
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_125
	j .L91_126
.L91_125:
	la s1, lower_arena
	lw s2, 0(s1)
	li t6, -2232
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	li t6, -2376
	add t6, s0, t6
	sw s1, 0(t6)
	j .L91_127
.L91_126:
	li s1, 0
	li t6, -2376
	add t6, s0, t6
	sw s1, 0(t6)
.L91_127:
	li t6, -2376
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	li t6, -2236
	add t6, s0, t6
	sw s1, 0(t6)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
.L91_128:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_129
	j .L91_130
.L91_129:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L91_131
	j .L91_132
.L91_131:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 72
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 43
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L91_133
	j .L91_132
.L91_133:
	li s1, 1
	j .L91_134
.L91_132:
	li s1, 0
.L91_134:
	li t6, -2380
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_addr
	mv s2, a0
	li t6, -2304
	add s1, s0, t6
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	li t6, -2368
	add s1, s0, t6
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
	li t6, -2368
	add s1, s0, t6
	li t6, -2236
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L91_135
	j .L91_136
.L91_135:
	la s1, __str_62
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L91_136:
	la s1, lower_arena
	lw s2, 0(s1)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 72
	add s4, s1, s3
	lw s1, 0(s4)
	li t6, -2216
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	li t6, -2372
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2236
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	mul s5, s2, s3
	add s2, s1, s5
	sw s4, 0(s2)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, asm_operand_pin
	mv s2, a0
	li t6, -2372
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	sw s2, 0(s4)
	li t6, -2368
	add s1, s0, t6
	li t6, -2236
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li t6, -2372
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 12
	add s4, s3, s1
	sw s2, 0(s4)
	li s1, 1
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 16
	add s4, s3, s2
	sw s1, 0(s4)
	li t6, -2380
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 20
	add s4, s3, s2
	sw s1, 0(s4)
	li t6, -2380
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_137
	j .L91_138
.L91_137:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	li t6, -2384
	add t6, s0, t6
	sw s2, 0(t6)
	j .L91_139
.L91_138:
	jal ra, new_temp
	mv s1, a0
	li t6, -2384
	add t6, s0, t6
	sw s1, 0(t6)
.L91_139:
	li t6, -2384
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
.L91_140:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -2236
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2236
	add t6, s0, t6
	sw s3, 0(t6)
	j .L91_128
.L91_130:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
.L91_141:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_142
	j .L91_143
.L91_142:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	mv a0, s2
	jal ra, is_float_type
	mv s1, a0
	bnez s1, .L91_144
	j .L91_145
.L91_144:
	la s1, __str_63
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L91_145:
	la s1, lower_arena
	lw s2, 0(s1)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 72
	add s4, s1, s3
	lw s1, 0(s4)
	li t6, -2216
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	li t6, -2372
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2236
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	mul s5, s2, s3
	add s2, s1, s5
	sw s4, 0(s2)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, asm_operand_pin
	mv s2, a0
	li t6, -2372
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	sw s2, 0(s4)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lvalue_type
	mv s2, a0
	mv a0, s2
	jal ra, cc_type_size
	mv s1, a0
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 16
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 20
	add s4, s3, s2
	sw s1, 0(s4)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_expr
	mv s2, a0
	li t6, -2372
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 8
	add s4, s3, s1
	sw s2, 0(s4)
.L91_146:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -2236
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2236
	add t6, s0, t6
	sw s3, 0(t6)
	j .L91_141
.L91_143:
	li s1, 0
	li t6, -2236
	add t6, s0, t6
	sw s1, 0(t6)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
.L91_147:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L91_148
	j .L91_149
.L91_148:
	la s1, lower_arena
	lw s2, 0(s1)
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 72
	add s4, s1, s3
	lw s1, 0(s4)
	li t6, -2216
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	li t6, -2372
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2236
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s5, s2, s3
	add s2, s1, s5
	sw s4, 0(s2)
.L91_150:
	li t6, -2216
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2216
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -2236
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2236
	add t6, s0, t6
	sw s3, 0(t6)
	j .L91_147
.L91_149:
	li s1, 129
	mv a0, s1
	jal ra, emit
	mv s2, a0
	li t6, -2212
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -2220
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2212
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2372
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2212
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	li t6, -2236
	add t6, s0, t6
	sw s1, 0(t6)
.L91_151:
	li t6, -2236
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2224
	add t6, s0, t6
	lw s2, 0(t6)
	slt s3, s1, s2
	bnez s3, .L91_152
	j .L91_153
.L91_152:
	li t6, -2304
	add s1, s0, t6
	li t6, -2236
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li t6, -2372
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li t6, -2236
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	lw s2, 0(s4)
	li t6, -2368
	add s3, s0, t6
	li t6, -2236
	add t6, s0, t6
	lw s4, 0(t6)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_store
	mv s4, a0
.L91_154:
	li t6, -2236
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2236
	add t6, s0, t6
	sw s3, 0(t6)
	j .L91_151
.L91_153:
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L91_23:
	la s1, __str_64
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	lw s4, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s4, 4(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L91_155:
	li s1, 0
	mv a0, s1
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2424
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2420
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2416
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2412
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2408
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2404
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2400
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2396
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2392
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2388
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end91:
	.size lower_stmt, .Lfunc_end91-lower_stmt

	.text
	.align 2
	.type lower_function, @function
lower_function:
	addi sp, sp, -432
	sw ra, 428(sp)
	sw s0, 424(sp)
	addi s0, sp, 424
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
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 48
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, ir_new_func
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, cc_debug
	lw s2, 0(s1)
	bnez s2, .L92_0
	j .L92_1
.L92_0:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L92_2
	j .L92_3
.L92_2:
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L92_4
.L92_3:
	la s1, cc_src_file
	lw s2, 0(s1)
	sw s2, -20(s0)
.L92_4:
	lw s1, -20(s0)
	sw s1, -16(s0)
	j .L92_5
.L92_1:
	li s1, 0
	sw s1, -16(s0)
.L92_5:
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	la s2, last_loc_line
	sw s1, 0(s2)
	lw s1, -12(s0)
	la s2, cur_fn
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, cur_fn_name
	sw s1, 0(s2)
	li s1, 0
	la s2, nloops
	sw s1, 0(s2)
	li s1, 0
	la s2, nlocals
	sw s1, 0(s2)
	li s1, 0
	la s2, nslots
	sw s1, 0(s2)
	li s1, 0
	la s2, nnamed_labels
	sw s1, 0(s2)
	li s1, 0
	la s2, cur_switch
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -24(s0)
	lw s1, -4(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L92_6
	j .L92_7
.L92_6:
	li s1, 1
	la s2, ldouble_recover_active
	sw s1, 0(s2)
	la s1, ldouble_recover
	mv a0, s1
	jal ra, setjmp
	mv s2, a0
	bnez s2, .L92_8
	j .L92_9
.L92_8:
	li s1, 0
	la s2, ldouble_recover_active
	sw s1, 0(s2)
	li s1, 0
	mv a0, s1
	lw s1, -412(s0)
	lw s2, -408(s0)
	lw s3, -404(s0)
	lw s4, -400(s0)
	lw s5, -396(s0)
	lw s6, -392(s0)
	lw s7, -388(s0)
	lw s8, -384(s0)
	lw s9, -380(s0)
	lw s10, -376(s0)
	lw s11, -372(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L92_9:
.L92_7:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
	lw s1, -24(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
.L92_10:
	lw s1, -44(s0)
	bnez s1, .L92_11
	j .L92_12
.L92_11:
	lw s1, -44(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, reject_ldouble
	mv s3, a0
.L92_13:
	lw s1, -44(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -44(s0)
	j .L92_10
.L92_12:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	la s1, cur_fn_returns_float
	sw s2, 0(s1)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	la s1, cur_fn_returns_i64
	sw s2, 0(s1)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -40
	mv a0, s1
	mv a1, s2
	jal ra, abi_agg
	mv s3, a0
	la s1, cur_fn_ret_neb
	sw s3, 0(s1)
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, ret_uses_hidden_ptr
	mv s2, a0
	la s1, cur_fn_ret_mem
	sw s2, 0(s1)
	la s1, cur_fn_ret_neb
	lw s2, 0(s1)
	li s1, 0
	slt s3, s2, s1
	bnez s3, .L92_14
	j .L92_15
.L92_14:
	li s1, 0
	la s2, cur_fn_ret_neb
	sw s1, 0(s2)
.L92_15:
	la s1, cur_fn_ret_mem
	lw s2, 0(s1)
	bnez s2, .L92_16
	j .L92_17
.L92_16:
	li s1, 1
	neg s2, s1
	sw s2, -48(s0)
	j .L92_18
.L92_17:
	la s1, cur_fn_ret_neb
	lw s2, 0(s1)
	sw s2, -48(s0)
.L92_18:
	lw s1, -48(s0)
	lw s2, -12(s0)
	li s3, 52
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	sw s1, -52(s0)
.L92_19:
	lw s1, -52(s0)
	li s2, 4
	slt s3, s1, s2
	bnez s3, .L92_20
	j .L92_21
.L92_20:
	addi s1, s0, -40
	lw s2, -52(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -12(s0)
	li s3, 53
	add s4, s2, s3
	lw s2, -52(s0)
	add s3, s4, s2
	sb s1, 0(s3)
.L92_22:
	addi s1, s0, -52
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -52(s0)
	j .L92_19
.L92_21:
	lw s1, -24(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, cur_fn_ret_type
	sw s1, 0(s2)
	lw s1, -24(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -56(s0)
	li s1, 0
	sw s1, -60(s0)
	lw s1, -24(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -64(s0)
.L92_23:
	lw s1, -64(s0)
	bnez s1, .L92_24
	j .L92_25
.L92_24:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
.L92_26:
	lw s1, -64(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -64(s0)
	j .L92_23
.L92_25:
	la s1, cur_fn_ret_mem
	lw s2, 0(s1)
	bnez s2, .L92_27
	j .L92_28
.L92_27:
	addi s1, s0, -60
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -60(s0)
.L92_28:
	lw s1, -60(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L92_29
	j .L92_30
.L92_29:
	lw s1, -60(s0)
	sw s1, -68(s0)
	j .L92_31
.L92_30:
	li s1, 1
	sw s1, -68(s0)
.L92_31:
	lw s1, -68(s0)
	sw s1, -60(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -60(s0)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -60(s0)
	li s3, 1
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 4
	lw s3, -60(s0)
	mul s4, s1, s3
	li s1, 1
	mul s3, s4, s1
	mv a0, s2
	mv a1, s3
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -12(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -60(s0)
	li s3, 1
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -12(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	lw s3, -60(s0)
	li s4, 1
	mul s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, memset
	mv s3, a0
	la s1, cur_fn_ret_mem
	lw s2, 0(s1)
	bnez s2, .L92_32
	j .L92_33
.L92_32:
	li s1, 4
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, alloc_slot
	mv s3, a0
	la s1, cur_fn_sret_slot
	sw s3, 0(s1)
	li s1, 1
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 3
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -12(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 2
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -12(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 1
	add s4, s1, s3
	sb s2, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1
	sw s1, -56(s0)
.L92_33:
	li s1, 0
	sw s1, -140(s0)
	lw s1, -24(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -212(s0)
.L92_34:
	lw s1, -212(s0)
	bnez s1, .L92_35
	j .L92_36
.L92_35:
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -216(s0)
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -232
	mv a0, s1
	mv a1, s2
	jal ra, abi_agg
	mv s3, a0
	sw s3, -236(s0)
	li s1, 0
	sw s1, -240(s0)
	lw s1, -236(s0)
	li s2, 0
	slt s3, s1, s2
	sw s3, -240(s0)
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	sw s2, -244(s0)
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L92_37
	j .L92_38
.L92_37:
	lw s1, -216(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L92_39
	j .L92_38
.L92_39:
	li s1, 8
	sw s1, -216(s0)
	li s1, 8
	sw s1, -244(s0)
	j .L92_40
.L92_38:
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_i64_type
	mv s2, a0
	bnez s2, .L92_41
	j .L92_42
.L92_41:
	lw s1, -216(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L92_43
	j .L92_42
.L92_43:
	li s1, 8
	sw s1, -216(s0)
	j .L92_44
.L92_42:
	lw s1, -236(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L92_45
	j .L92_46
.L92_45:
	lw s1, -216(s0)
	lw s2, -236(s0)
	li s3, 4
	mul s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L92_47
	j .L92_46
.L92_47:
	lw s1, -236(s0)
	li s2, 4
	mul s3, s1, s2
	sw s3, -216(s0)
	j .L92_48
.L92_46:
	lw s1, -216(s0)
	li s2, 4
	slt s3, s1, s2
	bnez s3, .L92_49
	j .L92_50
.L92_49:
	li s1, 4
	sw s1, -216(s0)
.L92_50:
.L92_48:
.L92_44:
.L92_40:
	li s1, 0
	sw s1, -248(s0)
.L92_51:
	lw s1, -248(s0)
	li s2, 4
	slt s3, s1, s2
	bnez s3, .L92_52
	j .L92_53
.L92_52:
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	lw s4, -56(s0)
	mul s5, s3, s4
	lw s3, -248(s0)
	add s4, s5, s3
	add s3, s1, s4
	sb s2, 0(s3)
.L92_54:
	addi s1, s0, -248
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -248(s0)
	j .L92_51
.L92_53:
	lw s1, -240(s0)
	bnez s1, .L92_55
	j .L92_56
.L92_55:
	li s1, 4
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, alloc_slot
	mv s3, a0
	sw s3, -252(s0)
	lw s1, -140(s0)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L92_57
	j .L92_58
.L92_57:
	lw s1, -252(s0)
	addi s2, s0, -136
	lw s3, -140(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -212(s0)
	addi s2, s0, -208
	lw s3, -140(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -140
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -140(s0)
.L92_58:
	li s1, 1
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -56(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	lw s4, -56(s0)
	mul s5, s3, s4
	add s3, s2, s5
	sb s1, 0(s3)
	li s1, 0
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -56(s0)
	j .L92_59
.L92_56:
	lw s1, -216(s0)
	lw s2, -244(s0)
	mv a0, s1
	mv a1, s2
	jal ra, alloc_slot
	mv s3, a0
	sw s3, -256(s0)
	lw s1, -212(s0)
	lw s2, 0(s1)
	bnez s2, .L92_60
	j .L92_61
.L92_60:
	lw s1, -212(s0)
	lw s2, 0(s1)
	lw s1, -256(s0)
	lw s3, -212(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, add_local
	mv s4, a0
.L92_61:
	lw s1, -236(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L92_62
	j .L92_63
.L92_62:
	lw s1, -236(s0)
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -56(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	sw s1, -260(s0)
.L92_64:
	lw s1, -260(s0)
	lw s2, -236(s0)
	slt s3, s1, s2
	bnez s3, .L92_65
	j .L92_66
.L92_65:
	addi s1, s0, -232
	lw s2, -260(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -12(s0)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	lw s4, -56(s0)
	mul s5, s3, s4
	lw s3, -260(s0)
	add s4, s5, s3
	add s3, s2, s4
	sb s1, 0(s3)
.L92_67:
	addi s1, s0, -260
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -260(s0)
	j .L92_64
.L92_66:
	addi s1, s0, -232
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L92_68
.L92_63:
	lw s1, -236(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L92_69
	j .L92_70
.L92_69:
	lw s1, -216(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 8
	div s2, s3, s1
	lw s1, -12(s0)
	li s3, 40
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -56(s0)
	add s4, s1, s3
	sb s2, 0(s4)
	li s1, 2
	neg s2, s1
	lw s1, -12(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	lw s4, -56(s0)
	mul s5, s3, s4
	add s3, s1, s5
	sb s2, 0(s3)
	li s1, 2
	neg s2, s1
	lw s1, -12(s0)
	li s3, 44
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	lw s4, -56(s0)
	mul s5, s3, s4
	li s3, 1
	add s4, s5, s3
	add s3, s1, s4
	sb s2, 0(s3)
	li s1, 0
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L92_71
.L92_70:
	li s1, 1
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -56(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L92_72
	j .L92_73
.L92_72:
	li s1, 1
	sw s1, -264(s0)
	j .L92_74
.L92_73:
	li s1, 0
	sw s1, -264(s0)
.L92_74:
	lw s1, -264(s0)
	lw s2, -12(s0)
	li s3, 44
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	lw s4, -56(s0)
	mul s5, s3, s4
	add s3, s2, s5
	sb s1, 0(s3)
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L92_75
	j .L92_76
.L92_75:
	li s1, 1
	sw s1, -268(s0)
	j .L92_77
.L92_76:
	li s1, 0
	sw s1, -268(s0)
.L92_77:
	lw s1, -268(s0)
	lw s2, -12(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -56(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, is_float_type
	mv s2, a0
	bnez s2, .L92_78
	j .L92_79
.L92_78:
	lw s1, -212(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L92_80
	j .L92_79
.L92_80:
	li s1, 1
	lw s2, -12(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -56(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L92_79:
.L92_71:
.L92_68:
	addi s1, s0, -56
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -56(s0)
.L92_59:
	lw s1, -212(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -212(s0)
	j .L92_34
.L92_36:
	lw s1, -56(s0)
	lw s2, -12(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -340(s0)
.L92_81:
	lw s1, -340(s0)
	lw s2, -140(s0)
	slt s3, s1, s2
	bnez s3, .L92_82
	j .L92_83
.L92_82:
	addi s1, s0, -208
	lw s2, -340(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	addi s1, s0, -208
	lw s3, -340(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s1
	jal ra, cc_type_align
	mv s3, a0
	mv a0, s2
	mv a1, s3
	jal ra, alloc_slot
	mv s1, a0
	addi s2, s0, -336
	lw s3, -340(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -208
	lw s2, -340(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, 0(s1)
	bnez s2, .L92_84
	j .L92_85
.L92_84:
	addi s1, s0, -208
	lw s2, -340(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, 0(s1)
	addi s1, s0, -336
	lw s3, -340(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	addi s3, s0, -208
	lw s4, -340(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, add_local
	mv s4, a0
.L92_85:
.L92_86:
	addi s1, s0, -340
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -340(s0)
	j .L92_81
.L92_83:
	li s1, 52
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -344(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 48
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -344(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -56(s0)
	lw s2, -344(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -348(s0)
.L92_87:
	lw s1, -348(s0)
	lw s2, -140(s0)
	slt s3, s1, s2
	bnez s3, .L92_88
	j .L92_89
.L92_88:
	li s1, 28
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -352(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -352(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -136
	lw s2, -348(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -352(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -336
	lw s2, -348(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, emit_addr_slot
	mv s2, a0
	lw s1, -352(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	addi s3, s0, -208
	lw s4, -348(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s3
	jal ra, cc_type_size
	mv s4, a0
	mv a0, s2
	mv a1, s1
	mv a2, s4
	jal ra, emit_aggregate_copy
	mv s3, a0
.L92_90:
	addi s1, s0, -348
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -348(s0)
	j .L92_87
.L92_89:
	lw s1, -4(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, lower_stmt
	mv s2, a0
	lw s1, -12(s0)
	li s2, 96
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L92_91
	j .L92_92
.L92_91:
	lw s1, -12(s0)
	li s2, 96
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 50
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L92_93
	j .L92_94
.L92_93:
	lw s1, -12(s0)
	li s2, 96
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 51
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L92_95
	j .L92_94
.L92_95:
	lw s1, -12(s0)
	li s2, 96
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 121
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L92_96
	j .L92_94
.L92_96:
	lw s1, -12(s0)
	li s2, 96
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 82
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L92_97
	j .L92_94
.L92_97:
	lw s1, -12(s0)
	li s2, 96
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 124
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L92_92
	j .L92_94
.L92_92:
	la s1, cur_fn_ret_mem
	lw s2, 0(s1)
	bnez s2, .L92_98
	j .L92_99
.L92_98:
	li s1, 28
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -344(s0)
	jal ra, new_temp
	mv s1, a0
	lw s2, -344(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, cur_fn_sret_slot
	lw s2, 0(s1)
	lw s1, -344(s0)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -344(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -356(s0)
	li s1, 51
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -344(s0)
	lw s1, -356(s0)
	lw s2, -344(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	j .L92_100
.L92_99:
	la s1, cur_fn_returns_i64
	lw s2, 0(s1)
	bnez s2, .L92_101
	j .L92_102
.L92_101:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
	jal ra, lower_const64
	mv s1, a0
	sw s1, -360(s0)
	li s1, 121
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -344(s0)
	lw s1, -360(s0)
	lw s2, -344(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	j .L92_103
.L92_102:
	li s1, 0
	mv a0, s1
	jal ra, lower_const
	mv s2, a0
	sw s2, -364(s0)
	li s1, 51
	mv a0, s1
	jal ra, emit
	mv s2, a0
	sw s2, -344(s0)
	lw s1, -364(s0)
	lw s2, -344(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
.L92_103:
.L92_100:
.L92_94:
	li s1, 53
	mv a0, s1
	jal ra, emit
	mv s2, a0
	la s1, nslots
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	la s1, nslots
	lw s3, 0(s1)
	li s1, 4
	mul s4, s3, s1
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -12(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	la s1, nslots
	lw s3, 0(s1)
	li s1, 4
	mul s4, s3, s1
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, nslots
	lw s2, 0(s1)
	bnez s2, .L92_104
	j .L92_105
.L92_104:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, slot_sizes
	lw s3, 0(s2)
	la s2, nslots
	lw s4, 0(s2)
	li s2, 4
	mul s5, s4, s2
	mv a0, s1
	mv a1, s3
	mv a2, s5
	jal ra, memcpy
	mv s2, a0
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, slot_aligns
	lw s3, 0(s2)
	la s2, nslots
	lw s4, 0(s2)
	li s2, 4
	mul s5, s4, s2
	mv a0, s1
	mv a1, s3
	mv a2, s5
	jal ra, memcpy
	mv s2, a0
.L92_105:
	li s1, 0
	la s2, ldouble_recover_active
	sw s1, 0(s2)
	lw s1, -12(s0)
	mv a0, s1
	lw s1, -412(s0)
	lw s2, -408(s0)
	lw s3, -404(s0)
	lw s4, -400(s0)
	lw s5, -396(s0)
	lw s6, -392(s0)
	lw s7, -388(s0)
	lw s8, -384(s0)
	lw s9, -380(s0)
	lw s10, -376(s0)
	lw s11, -372(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end92:
	.size lower_function, .Lfunc_end92-lower_function

	.text
	.align 2
	.type lower_global_decl, @function
lower_global_decl:
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
	fsd fs0, 56(sp)
	fsd fs1, 64(sp)
	sw a0, -4(s0)
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_0
	j .L93_1
.L93_0:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_2
	j .L93_1
.L93_2:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 80
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, compound_matches
	mv s3, a0
	bnez s3, .L93_3
	j .L93_1
.L93_3:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L93_1:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_4
	j .L93_5
.L93_4:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_6
	j .L93_5
.L93_6:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L93_5
	j .L93_7
.L93_7:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_8
	j .L93_5
.L93_8:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_5
	j .L93_9
.L93_9:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L93_10
	j .L93_5
.L93_10:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L93_5:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_11
	j .L93_12
.L93_11:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_13
	j .L93_12
.L93_13:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_aggregate
	mv s2, a0
	bnez s2, .L93_12
	j .L93_14
.L93_14:
	la s1, __str_65
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L93_12:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_15
	j .L93_16
.L93_15:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L93_17
	j .L93_16
.L93_17:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_18
	j .L93_16
.L93_18:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_19
	j .L93_16
.L93_19:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
.L93_16:
	lw s1, -4(s0)
	li s2, 88
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_20
	j .L93_21
.L93_20:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -12(s0)
	lw s4, 0(s3)
	li s3, 12
	xor s5, s4, s3
	seqz s5, s5
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, add_global
	mv s3, a0
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
	fld fs0, -96(s0)
	fld fs1, -88(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L93_21:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_22
	j .L93_23
.L93_22:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, add_global
	mv s4, a0
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
	fld fs0, -96(s0)
	fld fs1, -88(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L93_23:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 68
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -16(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 48
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -16(s0)
	sw s3, 0(s1)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, type_is_readonly
	mv s2, a0
	lw s1, -16(s0)
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, wants_image
	mv s3, a0
	bnez s3, .L93_24
	j .L93_25
.L93_24:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_26
	j .L93_27
.L93_26:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L93_28
	j .L93_27
.L93_28:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_29
	j .L93_27
.L93_29:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_30
	j .L93_27
.L93_30:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, infer_array_len
	mv s2, a0
	lw s1, -12(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
.L93_27:
	li s1, 2
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	lw s1, -16(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	lw s1, -16(s0)
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_31
	j .L93_32
.L93_31:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_33
	j .L93_32
.L93_33:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, lower_aggregate_init
	mv s3, a0
	lw s1, -16(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
.L93_32:
	j .L93_34
.L93_25:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_35
	j .L93_36
.L93_35:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, type_to_ir
	mv s2, a0
	lw s1, -16(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L93_37
	j .L93_38
.L93_37:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_39
	j .L93_38
.L93_39:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_40
	j .L93_38
.L93_40:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, infer_array_len
	mv s2, a0
	lw s1, -12(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
.L93_38:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L93_41
	j .L93_42
.L93_41:
	lw s1, -12(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L93_43
.L93_42:
	li s1, 0
	sw s1, -20(s0)
.L93_43:
	lw s1, -20(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	j .L93_44
.L93_36:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_45
	j .L93_46
.L93_45:
	li s1, 4
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L93_47
	j .L93_48
.L93_47:
	li s1, 5
	sw s1, -24(s0)
	j .L93_49
.L93_48:
	li s1, 1
	sw s1, -24(s0)
.L93_49:
	lw s1, -24(s0)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -16(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	j .L93_50
.L93_46:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, type_to_ir
	mv s2, a0
	lw s1, -16(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
.L93_50:
.L93_44:
.L93_34:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_51
	j .L93_52
.L93_51:
	lw s1, -16(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_52
	j .L93_53
.L93_53:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_54
	j .L93_55
.L93_54:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L93_56
	j .L93_55
.L93_56:
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 24
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 76
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 1
	add s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -16(s0)
	li s3, 56
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 72
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -16(s0)
	li s3, 56
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -4(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 76
	add s5, s3, s4
	lw s3, 0(s5)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	li s2, 60
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L93_57
	j .L93_58
.L93_57:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	li s2, 12
	add s4, s1, s2
	sw s3, 0(s4)
.L93_58:
	j .L93_59
.L93_55:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_60
	j .L93_61
.L93_60:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -32(s0)
	sw s11, -28(s0)
	li s1, 0
	sw s1, -36(s0)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -32
	addi s4, s0, -36
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, encode_scalar
	mv s5, a0
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -16(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s1, -16(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	lw s1, -36(s0)
	bnez s1, .L93_62
	j .L93_63
.L93_62:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 4
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	lw s1, -16(s0)
	li s2, 48
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -36(s0)
	lw s2, -16(s0)
	li s3, 48
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L93_63:
	li s1, 1
	lw s2, -16(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L93_64
.L93_61:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_65
	j .L93_66
.L93_65:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, count_init_flat
	mv s2, a0
	sw s2, -40(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -40(s0)
	li s3, 8
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_alloc
	mv s1, a0
	lw s2, -16(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, lower_arena
	lw s2, 0(s1)
	lw s1, -40(s0)
	li s3, 4
	mul s4, s1, s3
	mv a0, s2
	mv a1, s4
	jal ra, arena_zalloc
	mv s1, a0
	lw s2, -16(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -44(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, flat_elem_type
	mv s2, a0
	lw s1, -4(s0)
	li s3, 24
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -16(s0)
	li s4, 44
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -16(s0)
	li s5, 48
	add s6, s4, s5
	lw s4, 0(s6)
	addi s5, s0, -44
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, flatten_init
	mv s6, a0
	lw s1, -44(s0)
	lw s2, -16(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L93_67
	j .L93_68
.L93_67:
	lw s1, -44(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L93_68:
	j .L93_69
.L93_66:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_70
	j .L93_71
.L93_71:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_70
	j .L93_72
.L93_72:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_70
	j .L93_73
.L93_70:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -56(s0)
	sw s11, -52(s0)
	li s1, 0
	sw s1, -60(s0)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	addi s3, s0, -56
	addi s4, s0, -60
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, encode_scalar
	mv s5, a0
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -16(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s10, -56(s0)
	lw s11, -52(s0)
	lw s1, -16(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 1
	lw s2, -16(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L93_74
.L93_73:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, is_bool_type
	mv s2, a0
	bnez s2, .L93_75
	j .L93_76
.L93_75:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_77
	j .L93_78
.L93_77:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 64
	add s3, s1, s2
	fld fs0, 0(s3)
	la s1, __flt_66
	fld fs1, 0(s1)
	feq.d s1, fs0, fs1
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	fsd fs2, -80(s0)
	j .L93_79
.L93_78:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, fold_int_const
	mv s10, a0
	mv s11, a1
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s1, t0
	fcvt.d.w fs0, s1
	fsd fs0, -80(s0)
.L93_79:
	fld fs0, -80(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, -72(s0)
	sw s11, -68(s0)
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -16(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s10, -72(s0)
	lw s11, -68(s0)
	lw s1, -16(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 1
	lw s2, -16(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L93_80
.L93_76:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_81
	j .L93_82
.L93_81:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -16(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -16(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 1
	lw s2, -16(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L93_83
.L93_82:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_84
	j .L93_85
.L93_84:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L93_86
	j .L93_85
.L93_86:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L93_87
	j .L93_85
.L93_87:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L93_88
	j .L93_85
.L93_88:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -16(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	lw s1, -16(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s8, 0(s2)
	sw s9, 4(s2)
	li s1, 1
	lw s2, -16(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	j .L93_89
.L93_85:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, cc_type_is_integer
	mv s2, a0
	bnez s2, .L93_90
	j .L93_91
.L93_90:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	lw s1, -16(s0)
	li s2, 44
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, fold_int_const
	mv s10, a0
	mv s11, a1
	lw s1, -16(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 1
	lw s2, -16(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
.L93_91:
.L93_89:
.L93_83:
.L93_80:
.L93_74:
.L93_69:
.L93_64:
.L93_59:
.L93_52:
	lw s1, -4(s0)
	li s2, 96
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L93_92
	j .L93_93
.L93_92:
	lw s1, -4(s0)
	li s2, 96
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L93_93:
	la s1, cur_prog
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -16(s0)
	li s3, 64
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	la s2, cur_prog
	lw s3, 0(s2)
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, add_global
	mv s4, a0
	li s1, 0
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
	fld fs0, -96(s0)
	fld fs1, -88(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end93:
	.size lower_global_decl, .Lfunc_end93-lower_global_decl

	.text
	.align 2
	.globl cc_lower_program
	.type cc_lower_program, @function
cc_lower_program:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	lw s1, -4(s0)
	la s2, lower_arena
	sw s1, 0(s2)
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	la s2, cur_prog
	sw s1, 0(s2)
	li s1, 0
	la s2, nglobals
	sw s1, 0(s2)
	li s1, 0
	la s2, str_counter
	sw s1, 0(s2)
	la s1, lvalue_type
	la s2, cc_const_sizeof_typer
	sw s1, 0(s2)
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -16(s0)
	li s1, 8
	lw s2, -16(s0)
	sw s1, 0(s2)
	addi s1, s0, -28
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	jal ra, cc_type_int
	mv s2, a0
	sw s2, 0(s1)
	jal ra, cc_type_long
	mv s2, a0
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s2, -16(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	addi s1, s0, -40
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_67
	sw s2, 0(s1)
	la s2, __str_68
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_69
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	sw s1, -44(s0)
.L94_0:
	lw s1, -44(s0)
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L94_1
	j .L94_2
.L94_1:
	la s1, lower_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -48(s0)
	li s1, 12
	lw s2, -48(s0)
	sw s1, 0(s2)
	addi s1, s0, -28
	lw s2, -44(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -48(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -40
	lw s2, -44(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -48(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, add_global
	mv s4, a0
.L94_3:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L94_0
.L94_2:
	lw s1, -8(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
.L94_4:
	lw s1, -52(s0)
	bnez s1, .L94_5
	j .L94_6
.L94_5:
	lw s1, -52(s0)
	lw s2, 0(s1)
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L94_7
	j .L94_8
.L94_7:
	lw s1, -52(s0)
	mv a0, s1
	jal ra, lower_global_decl
	mv s2, a0
	j .L94_9
.L94_8:
	lw s1, -52(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L94_10
	j .L94_11
.L94_10:
	lw s1, -52(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -52(s0)
	li s3, 80
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, add_global
	mv s4, a0
.L94_11:
.L94_9:
.L94_12:
	lw s1, -52(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	j .L94_4
.L94_6:
	lw s1, -12(s0)
	sw s1, -56(s0)
	lw s1, -8(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -60(s0)
.L94_13:
	lw s1, -60(s0)
	bnez s1, .L94_14
	j .L94_15
.L94_14:
	lw s1, -60(s0)
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L94_16
	j .L94_17
.L94_16:
	j .L94_18
.L94_17:
	lw s1, -60(s0)
	mv a0, s1
	jal ra, lower_function
	mv s2, a0
	sw s2, -64(s0)
	lw s1, -64(s0)
	bnez s1, .L94_19
	j .L94_20
.L94_20:
	j .L94_18
.L94_19:
	lw s1, -64(s0)
	lw s2, -56(s0)
	sw s1, 0(s2)
	lw s1, -64(s0)
	li s2, 100
	add s3, s1, s2
	sw s3, -56(s0)
.L94_18:
	lw s1, -60(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -60(s0)
	j .L94_13
.L94_15:
	la s1, slot_sizes
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	la s1, slot_aligns
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li s1, 0
	la s2, slot_sizes
	sw s1, 0(s2)
	li s1, 0
	la s2, slot_aligns
	sw s1, 0(s2)
	li s1, 0
	la s2, slot_cap
	sw s1, 0(s2)
	la s2, nslots
	sw s1, 0(s2)
	la s1, locals
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li s1, 0
	la s2, locals
	sw s1, 0(s2)
	li s1, 0
	la s2, local_cap
	sw s1, 0(s2)
	la s2, nlocals
	sw s1, 0(s2)
	la s1, globals
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li s1, 0
	la s2, globals
	sw s1, 0(s2)
	li s1, 0
	la s2, global_cap
	sw s1, 0(s2)
	la s2, nglobals
	sw s1, 0(s2)
	lw s1, -12(s0)
	mv a0, s1
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
.Lfunc_end94:
	.size cc_lower_program, .Lfunc_end94-cc_lower_program

	.data
	.align 2
__str_69:
	.ascii "__builtin_va_arg_dbl\000"
	.align 2
__str_68:
	.ascii "__builtin_va_arg_long\000"
	.align 2
__str_67:
	.ascii "__builtin_va_arg_int\000"
	.align 3
__flt_66:
	.word 0x00000000
	.word 0x00000000
	.align 2
__str_65:
	.ascii "lower:%d: braced initializer for scalar type must hold a single value\000"
	.align 2
__str_64:
	.ascii "lower:%d: unhandled statement kind %d\000"
	.align 2
__str_63:
	.ascii "lower:%d: a float extended-asm operand is not supported yet\000"
	.align 2
__str_62:
	.ascii "lower:%d: a float extended-asm operand is not supported yet\000"
	.align 2
__str_61:
	.ascii "lower:%d: too many asm outputs\000"
	.align 2
__str_60:
	.ascii "lower:%d: continue outside loop\000"
	.align 2
__str_59:
	.ascii "lower:%d: break outside loop/switch\000"
	.align 2
__str_58:
	.ascii "lower:%d: default outside switch\000"
	.align 2
__str_57:
	.ascii "lower:%d: case outside switch\000"
	.align 3
__flt_56:
	.word 0x00000000
	.word 0x00000000
	.align 2
__str_55:
	.ascii "%s.%s.%d\000"
	.align 2
__str_54:
	.ascii "lower:%d: braced initializer for scalar type must hold a single value\000"
	.align 2
__str_53:
	.ascii "lower:%d: no field named '%s'\000"
	.align 2
__str_52:
	.ascii "lower:%d: designator out of range\000"
	.align 2
__str_51:
	.ascii "lower:%d: designator out of range\000"
	.align 2
__str_50:
	.ascii "lower:%d: unhandled expression kind %d\000"
	.align 2
__str_49:
	.ascii "lower:%d: init list in expression context\000"
	.align 2
__str_48:
	.ascii "lower:%d: too many arguments\000"
	.align 2
__str_47:
	.ascii "__va_arg\000"
	.align 2
__str_46:
	.ascii "__builtin_va_arg_long\000"
	.align 2
__str_45:
	.ascii "__builtin_va_arg_dbl\000"
	.align 2
__str_44:
	.ascii "__builtin_va_arg_int\000"
	.align 2
__str_43:
	.ascii "__builtin_va_arg\000"
	.align 2
__str_42:
	.ascii "__builtin_va_end\000"
	.align 2
__str_41:
	.ascii "__builtin_va_start\000"
	.align 2
__str_40:
	.ascii "lower:%d: unknown compound assign\000"
	.align 2
__str_39:
	.ascii "lower:%d: unknown i64 compound assign\000"
	.align 2
__str_38:
	.ascii "__moddi3\000"
	.align 2
__str_37:
	.ascii "__umoddi3\000"
	.align 2
__str_36:
	.ascii "__divdi3\000"
	.align 2
__str_35:
	.ascii "__udivdi3\000"
	.align 2
__str_34:
	.ascii "lower:%d: float compound assign %d not supported\000"
	.align 2
__str_33:
	.ascii "lower:%d: unknown binop %d\000"
	.align 2
__str_32:
	.ascii "lower:%d: unknown i64 binop %d\000"
	.align 2
__str_31:
	.ascii "__moddi3\000"
	.align 2
__str_30:
	.ascii "__umoddi3\000"
	.align 2
__str_29:
	.ascii "__divdi3\000"
	.align 2
__str_28:
	.ascii "__udivdi3\000"
	.align 2
__str_27:
	.ascii "lower:%d: float binop %d not supported\000"
	.align 2
__str_26:
	.ascii "lower:%d: unknown unop %d\000"
	.align 2
__str_25:
	.ascii "\000"
	.align 2
__str_24:
	.ascii "__func__\000"
	.align 2
__str_23:
	.ascii "__flt_%d\000"
	.align 2
__str_22:
	.ascii "lower: null expression\000"
	.align 2
__str_21:
	.ascii "lower: bad compound operator %d\000"
	.align 3
__flt_20:
	.word 0x00000000
	.word 0x00000000
	.align 2
__str_19:
	.ascii "__cl.%d\000"
	.align 2
__str_18:
	.ascii "__cl.%d\000"
	.align 2
__str_17:
	.ascii "__builtin_va_arg\000"
	.align 2
lvalue_type.ty_float.3:
	.word 0x00000007
	.space 48
	.align 2
lvalue_type.ty_double.2:
	.word 0x00000008
	.space 48
	.align 2
lvalue_type.ty_float.1:
	.word 0x00000007
	.space 48
	.align 2
lvalue_type.ty_double.0:
	.word 0x00000008
	.space 48
	.align 2
__str_16:
	.ascii "_Generic: no association matches the controlling type at line %d\000"
	.align 2
__str_15:
	.ascii "_Generic: the controlling type matches more than one association at line %d\000"
	.align 2
__str_14:
	.ascii "lower:%d: not an lvalue\000"
	.align 2
__str_13:
	.ascii "lower:%d: not an lvalue\000"
	.align 2
__str_12:
	.ascii "lower:%d: no field '%s'\000"
	.align 2
__str_11:
	.ascii "lower:%d: member access on non-struct\000"
	.align 2
__str_10:
	.ascii "lower:%d: undefined '%s'\000"
	.align 2
__str_9:
	.ascii "lower:%d: no field named '%s'\000"
	.align 2
__str_8:
	.ascii "lower:%d: designator out of range\000"
	.align 2
__str_7:
	.ascii "lower:%d: designator out of range\000"
	.align 2
__str_6:
	.ascii "lower:%d: non-constant initializer\000"
	.align 2
__str_5:
	.ascii "lower:%d: non-constant initializer\000"
	.align 2
__str_4:
	.ascii "expected constant expression\000"
	.align 2
__str_3:
	.ascii "__str_%d\000"
	.align 2
__str_2:
	.ascii "__str_%d\000"
	.align 2
__str_1:
	.ascii "long double is not supported (no 80-bit/128-bit float in this backend); use double\000"
	.align 2
__str_0:
	.ascii "lower:%d: long double is not supported (no 80-bit/128-bit float in this backend); use double\000"
	.align 2
	.globl cc_src_file
cc_src_file:
	.word 0
	.align 2
	.globl cc_debug
cc_debug:
	.word 0

	.bss
	.align 2
	.globl static_counter
static_counter:
	.space 4
	.align 2
	.globl compound_counter
compound_counter:
	.space 4
	.align 2
	.globl str_counter
str_counter:
	.space 4
	.align 2
	.globl ldouble_recover_active
ldouble_recover_active:
	.space 4
	.align 2
	.globl ldouble_recover
ldouble_recover:
	.space 128
	.align 2
	.globl nnamed_labels
nnamed_labels:
	.space 4
	.align 2
	.globl named_labels
named_labels:
	.space 2048
	.align 2
	.globl cur_switch
cur_switch:
	.space 4
	.align 2
	.globl nloops
nloops:
	.space 4
	.align 2
	.globl loop_stack
loop_stack:
	.space 512
	.align 2
	.globl global_cap
global_cap:
	.space 4
	.align 2
	.globl nglobals
nglobals:
	.space 4
	.align 2
	.globl globals
globals:
	.space 4
	.align 2
	.globl local_cap
local_cap:
	.space 4
	.align 2
	.globl nlocals
nlocals:
	.space 4
	.align 2
	.globl locals
locals:
	.space 4
	.align 2
	.globl slot_cap
slot_cap:
	.space 4
	.align 2
	.globl nslots
nslots:
	.space 4
	.align 2
	.globl slot_aligns
slot_aligns:
	.space 4
	.align 2
	.globl slot_sizes
slot_sizes:
	.space 4
	.align 2
	.globl last_loc_line
last_loc_line:
	.space 4
	.align 2
	.globl cur_fn_ret_type
cur_fn_ret_type:
	.space 4
	.align 2
	.globl cur_fn_sret_slot
cur_fn_sret_slot:
	.space 4
	.align 2
	.globl cur_fn_ret_mem
cur_fn_ret_mem:
	.space 4
	.align 2
	.globl cur_fn_ret_neb
cur_fn_ret_neb:
	.space 4
	.align 2
	.globl cur_fn_returns_i64
cur_fn_returns_i64:
	.space 4
	.align 2
	.globl cur_fn_returns_float
cur_fn_returns_float:
	.space 4
	.align 2
	.globl cur_fn_name
cur_fn_name:
	.space 4
	.align 2
	.globl cur_prog
cur_prog:
	.space 4
	.align 2
	.globl cur_fn
cur_fn:
	.space 4
	.align 2
	.globl lower_arena
lower_arena:
	.space 4
