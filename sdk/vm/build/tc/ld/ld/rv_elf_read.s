# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type get16, @function
get16:
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
	li s1, 65535
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
	.size get16, .Lfunc_end1-get16

	.text
	.align 2
	.type get32, @function
get32:
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
.Lfunc_end2:
	.size get32, .Lfunc_end2-get32

	.text
	.align 2
	.type get32s, @function
get32s:
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
	jal ra, get32
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
.Lfunc_end3:
	.size get32s, .Lfunc_end3-get32s

	.text
	.align 2
	.type shdr_at, @function
shdr_at:
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
	lw s2, -8(s0)
	add s3, s1, s2
	lw s1, -12(s0)
	li s2, 40
	mul s4, s1, s2
	add s1, s3, s4
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
	.size shdr_at, .Lfunc_end4-shdr_at

	.text
	.align 2
	.globl rv_parse_elf
	.type rv_parse_elf, @function
rv_parse_elf:
	addi sp, sp, -240
	sw ra, 236(sp)
	sw s0, 232(sp)
	addi s0, sp, 232
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
	li s1, 1
	neg s2, s1
	sw s2, -52(s0)
	lw s1, -20(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -16(s0)
	li s2, 52
	sltu s3, s1, s2
	bnez s3, .L5_0
	j .L5_1
.L5_0:
	la s1, __str_0
	lw s2, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_1:
	lw s1, -12(s0)
	la s2, __str_1
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L5_2
	j .L5_3
.L5_2:
	la s1, __str_2
	lw s2, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_3:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_4
	j .L5_5
.L5_4:
	la s1, __str_3
	lw s2, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_5:
	lw s1, -12(s0)
	li s2, 5
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_6
	j .L5_7
.L5_6:
	la s1, __str_4
	lw s2, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_7:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	mv a0, s3
	jal ra, get16
	mv s1, a0
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_8
	j .L5_9
.L5_8:
	la s1, __str_5
	lw s2, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_9:
	lw s1, -12(s0)
	li s2, 18
	add s3, s1, s2
	mv a0, s3
	jal ra, get16
	mv s1, a0
	li s2, 243
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_10
	j .L5_11
.L5_10:
	la s1, __str_6
	lw s2, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_11:
	lw s1, -12(s0)
	li s2, 32
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -28(s0)
	lw s1, -12(s0)
	li s2, 48
	add s3, s1, s2
	mv a0, s3
	jal ra, get16
	mv s1, a0
	sw s1, -32(s0)
	lw s1, -12(s0)
	li s2, 50
	add s3, s1, s2
	mv a0, s3
	jal ra, get16
	mv s1, a0
	sw s1, -36(s0)
	lw s1, -36(s0)
	lw s2, -32(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_12
	j .L5_13
.L5_12:
	la s1, __str_7
	lw s2, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_13:
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, shdr_at
	mv s4, a0
	sw s4, -40(s0)
	lw s1, -12(s0)
	lw s2, -40(s0)
	li s3, 16
	add s4, s2, s3
	mv a0, s4
	jal ra, get32
	mv s2, a0
	add s3, s1, s2
	sw s3, -44(s0)
	lw s1, -32(s0)
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -32(s0)
	li s3, 32
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	sw s1, -48(s0)
.L5_14:
	lw s1, -48(s0)
	lw s2, -32(s0)
	slt s3, s1, s2
	bnez s3, .L5_15
	j .L5_16
.L5_15:
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, -48(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, shdr_at
	mv s4, a0
	sw s4, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -60(s0)
	lw s1, -56(s0)
	li s2, 4
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -64(s0)
	lw s1, -56(s0)
	li s2, 8
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -68(s0)
	lw s1, -56(s0)
	li s2, 16
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -72(s0)
	lw s1, -56(s0)
	li s2, 20
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -76(s0)
	lw s1, -56(s0)
	li s2, 32
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -80(s0)
	lw s1, -44(s0)
	lw s2, -60(s0)
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -48(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	lw s1, -64(s0)
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -68(s0)
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -76(s0)
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 16
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -80(s0)
	bnez s1, .L5_17
	j .L5_18
.L5_17:
	lw s1, -80(s0)
	sw s1, -84(s0)
	j .L5_19
.L5_18:
	li s1, 1
	sw s1, -84(s0)
.L5_19:
	lw s1, -84(s0)
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 20
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 24
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 28
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -64(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_20
	j .L5_21
.L5_21:
	lw s1, -64(s0)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_20
	j .L5_22
.L5_20:
	lw s1, -64(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_23
	j .L5_24
.L5_23:
	lw s1, -76(s0)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L5_25
	j .L5_24
.L5_25:
	lw s1, -12(s0)
	lw s2, -72(s0)
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -48(s0)
	li s4, 32
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 12
	add s4, s2, s1
	sw s3, 0(s4)
	j .L5_26
.L5_24:
	li s1, 0
	lw s2, -8(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
.L5_26:
.L5_22:
	lw s1, -64(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_27
	j .L5_28
.L5_27:
	lw s1, -48(s0)
	sw s1, -52(s0)
.L5_28:
.L5_29:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L5_14
.L5_16:
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L5_30
	j .L5_31
.L5_30:
	la s1, __str_8
	lw s2, -20(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L5_31:
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, -52(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, shdr_at
	mv s4, a0
	sw s4, -88(s0)
	lw s1, -88(s0)
	li s2, 16
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -92(s0)
	lw s1, -88(s0)
	li s2, 20
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -96(s0)
	lw s1, -88(s0)
	li s2, 24
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -100(s0)
	lw s1, -96(s0)
	li s2, 16
	divu s3, s1, s2
	sw s3, -104(s0)
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, -100(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, shdr_at
	mv s4, a0
	sw s4, -108(s0)
	lw s1, -12(s0)
	lw s2, -108(s0)
	li s3, 16
	add s4, s2, s3
	mv a0, s4
	jal ra, get32
	mv s2, a0
	add s3, s1, s2
	sw s3, -112(s0)
	lw s1, -104(s0)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -104(s0)
	li s3, 24
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_zalloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	sw s1, -48(s0)
.L5_32:
	lw s1, -48(s0)
	lw s2, -104(s0)
	slt s3, s1, s2
	bnez s3, .L5_33
	j .L5_34
.L5_33:
	lw s1, -12(s0)
	lw s2, -92(s0)
	add s3, s1, s2
	lw s1, -48(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -116(s0)
	lw s1, -116(s0)
	li s2, 0
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -120(s0)
	lw s1, -116(s0)
	li s2, 4
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -124(s0)
	lw s1, -116(s0)
	li s2, 8
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -128(s0)
	lw s1, -116(s0)
	li s2, 12
	add s3, s1, s2
	lbu s1, 0(s3)
	sw s1, -132(s0)
	lw s1, -116(s0)
	li s2, 14
	add s3, s1, s2
	mv a0, s3
	jal ra, get16
	mv s1, a0
	sw s1, -136(s0)
	lw s1, -112(s0)
	lw s2, -120(s0)
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 20
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -48(s0)
	li s4, 24
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	lw s1, -124(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -128(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -48(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -136
	lhu s2, 0(s1)
	lw s1, -8(s0)
	li s3, 20
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -48(s0)
	li s4, 24
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 12
	add s4, s3, s1
	sw s2, 0(s4)
	addi s1, s0, -132
	lbu s2, 0(s1)
	li s1, 4
	sra s3, s2, s1
	lw s1, -8(s0)
	li s2, 20
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -48(s0)
	li s4, 24
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 16
	add s4, s2, s1
	sw s3, 0(s4)
	addi s1, s0, -132
	lbu s2, 0(s1)
	li s1, 15
	and s3, s2, s1
	lw s1, -8(s0)
	li s2, 20
	add s4, s1, s2
	lw s1, 0(s4)
	lw s2, -48(s0)
	li s4, 24
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 20
	add s4, s2, s1
	sw s3, 0(s4)
.L5_35:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L5_32
.L5_34:
	li s1, 0
	sw s1, -48(s0)
.L5_36:
	lw s1, -48(s0)
	lw s2, -32(s0)
	slt s3, s1, s2
	bnez s3, .L5_37
	j .L5_38
.L5_37:
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, -48(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, shdr_at
	mv s4, a0
	sw s4, -140(s0)
	lw s1, -140(s0)
	li s2, 4
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -144(s0)
	lw s1, -144(s0)
	li s2, 4
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L5_39
	j .L5_40
.L5_39:
	j .L5_41
.L5_40:
	lw s1, -140(s0)
	li s2, 16
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -148(s0)
	lw s1, -140(s0)
	li s2, 20
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -152(s0)
	lw s1, -140(s0)
	li s2, 28
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -156(s0)
	lw s1, -152(s0)
	li s2, 12
	divu s3, s1, s2
	sw s3, -160(s0)
	lw s1, -8(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -160(s0)
	add s3, s1, s2
	sw s3, -164(s0)
	lw s1, -164(s0)
	lw s2, -8(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s2, s1
	bnez s3, .L5_42
	j .L5_43
.L5_42:
	lw s1, -164(s0)
	li s2, 2
	mul s3, s1, s2
	lw s1, -8(s0)
	li s2, 36
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -8(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 24
	mul s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, realloc
	mv s2, a0
	lw s1, -8(s0)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -8(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_44
	j .L5_45
.L5_45:
	la s1, __str_9
	mv a0, s1
	jal ra, die
	mv s2, a0
.L5_44:
.L5_43:
	li s1, 0
	sw s1, -168(s0)
.L5_46:
	lw s1, -168(s0)
	lw s2, -160(s0)
	slt s3, s1, s2
	bnez s3, .L5_47
	j .L5_48
.L5_47:
	lw s1, -12(s0)
	lw s2, -148(s0)
	add s3, s1, s2
	lw s1, -168(s0)
	li s2, 12
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -172(s0)
	lw s1, -8(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s5, s2, s3
	sw s5, 0(s4)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -176(s0)
	lw s1, -172(s0)
	li s2, 4
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	sw s1, -180(s0)
	lw s1, -172(s0)
	li s2, 0
	add s3, s1, s2
	mv a0, s3
	jal ra, get32
	mv s1, a0
	lw s2, -176(s0)
	sw s1, 0(s2)
	lw s1, -180(s0)
	li s2, 8
	srl s3, s1, s2
	lw s1, -176(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -180(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -176(s0)
	li s2, 16
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -172(s0)
	li s2, 8
	add s3, s1, s2
	mv a0, s3
	jal ra, get32s
	mv s1, a0
	lw s2, -176(s0)
	li s3, 8
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -156(s0)
	lw s2, -176(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
.L5_49:
	addi s1, s0, -168
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -168(s0)
	j .L5_46
.L5_48:
.L5_41:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L5_36
.L5_38:
	li s1, 0
	mv a0, s1
	lw s1, -228(s0)
	lw s2, -224(s0)
	lw s3, -220(s0)
	lw s4, -216(s0)
	lw s5, -212(s0)
	lw s6, -208(s0)
	lw s7, -204(s0)
	lw s8, -200(s0)
	lw s9, -196(s0)
	lw s10, -192(s0)
	lw s11, -188(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end5:
	.size rv_parse_elf, .Lfunc_end5-rv_parse_elf

	.text
	.align 2
	.globl rv_ld_read_object
	.type rv_ld_read_object, @function
rv_ld_read_object:
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
	li s2, 4
	add s3, s1, s2
	lw s1, -12(s0)
	mv a0, s3
	mv a1, s1
	jal ra, mapfile_open
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_0
	j .L6_1
.L6_0:
	la s1, __str_10
	lw s2, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L6_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -8(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -8(s0)
	li s5, 4
	add s6, s4, s5
	li s4, 4
	add s5, s6, s4
	lw s4, 0(s5)
	lw s5, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, rv_parse_elf
	mv s6, a0
	mv a0, s6
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
	.size rv_ld_read_object, .Lfunc_end6-rv_ld_read_object

	.data
	.align 2
__str_10:
	.ascii "cannot open %s\000"
	.align 2
__str_9:
	.ascii "out of memory\000"
	.align 2
__str_8:
	.ascii "%s: no symbol table\000"
	.align 2
__str_7:
	.ascii "%s: bad shstrndx\000"
	.align 2
__str_6:
	.ascii "%s: not RISC-V\000"
	.align 2
__str_5:
	.ascii "%s: not a relocatable object\000"
	.align 2
__str_4:
	.ascii "%s: not little-endian\000"
	.align 2
__str_3:
	.ascii "%s: not ELF32\000"
	.align 2
__str_2:
	.ascii "%s: not an ELF file\000"
	.align 2
__str_1:
	.ascii "\177ELF\000"
	.align 2
__str_0:
	.ascii "%s: too small for ELF header\000"
