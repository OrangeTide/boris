# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type put16, @function
put16:
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
	addi s1, s0, -8
	lhu s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	li s2, 0
	add s4, s1, s2
	sb s3, 0(s4)
	addi s1, s0, -8
	lhu s2, 0(s1)
	li s1, 8
	sra s3, s2, s1
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 1
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
.Lfunc_end1:
	.size put16, .Lfunc_end1-put16

	.text
	.align 2
	.type put32, @function
put32:
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
	.size put32, .Lfunc_end2-put32

	.text
	.align 2
	.type sec_addralign, @function
sec_addralign:
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
	li s2, 4
	slt s3, s2, s1
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L3_2
.L3_1:
	li s1, 4
	sw s1, -12(s0)
.L3_2:
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
	.size sec_addralign, .Lfunc_end3-sec_addralign

	.text
	.align 2
	.type strtab_init, @function
strtab_init:
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
	li s1, 256
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	lw s1, -4(s0)
	sw s2, 0(s1)
	li s1, 0
	lw s2, -4(s0)
	lw s3, 0(s2)
	li s2, 0
	add s4, s3, s2
	sb s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end4:
	.size strtab_init, .Lfunc_end4-strtab_init

	.text
	.align 2
	.type strtab_add, @function
strtab_add:
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
	jal ra, strlen
	mv s2, a0
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
.L5_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	slt s2, s1, s3
	bnez s2, .L5_1
	j .L5_2
.L5_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, realloc
	mv s3, a0
	lw s1, -4(s0)
	sw s3, 0(s1)
	j .L5_0
.L5_2:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end5:
	.size strtab_add, .Lfunc_end5-strtab_add

	.text
	.align 2
	.type write_sym, @function
write_sym:
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
	li s2, 0
	add s3, s1, s2
	lw s1, -8(s0)
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s2
	jal ra, put32
	mv s1, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	lw s1, -8(s0)
	li s2, 12
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -8(s0)
	li s2, 13
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -4(s0)
	li s3, 13
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -4(s0)
	li s2, 14
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 14
	add s4, s1, s2
	lhu s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put16
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
.Lfunc_end6:
	.size write_sym, .Lfunc_end6-write_sym

	.text
	.align 2
	.type rsec_shndx, @function
rsec_shndx:
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
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_0
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_1
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_2
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_3
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_4
	li s2, 5
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_5
	li s2, 6
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L7_6
	j .L7_7
.L7_0:
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
.L7_1:
	li s1, 2
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
.L7_2:
	li s1, 3
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
.L7_3:
	li s1, 4
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
.L7_4:
	li s1, 10
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
.L7_5:
	li s1, 11
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
.L7_6:
	li s1, 12
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
.L7_7:
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
.L7_8:
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
.Lfunc_end7:
	.size rsec_shndx, .Lfunc_end7-rsec_shndx

	.text
	.align 2
	.globl rv_elf_write
	.type rv_elf_write, @function
rv_elf_write:
	addi sp, sp, -1312
	sw ra, 1308(sp)
	sw s0, 1304(sp)
	addi s0, sp, 1304
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
	li s1, 0
	sw s1, -848(s0)
	li s1, 0
	sw s1, -808(s0)
.L8_0:
	lw s1, -808(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L8_1
	j .L8_2
.L8_1:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -808(s0)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -880
	lw s3, -808(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -808(s0)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -908
	lw s3, -808(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L8_3:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_0
.L8_2:
	addi s1, s0, -20
	mv a0, s1
	jal ra, strtab_init
	mv s2, a0
	li s1, 0
	addi s2, s0, -96
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -20
	la s2, __str_0
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 1
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_1
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 2
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_2
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 3
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 4
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_4
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 5
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_5
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 6
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_6
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 7
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_7
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 8
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_8
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 9
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_9
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 10
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_10
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 11
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_11
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 12
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_12
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 13
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_13
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 14
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -20
	la s2, __str_14
	mv a0, s1
	mv a1, s2
	jal ra, strtab_add
	mv s3, a0
	addi s1, s0, -96
	li s2, 15
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -32
	mv a0, s1
	jal ra, strtab_init
	mv s2, a0
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	li s1, 4
	add s2, s3, s1
	lw s1, 0(s2)
	bnez s1, .L8_4
	j .L8_5
.L8_4:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	li s1, 4
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -912(s0)
	j .L8_6
.L8_5:
	li s1, 1
	sw s1, -912(s0)
.L8_6:
	lw s1, -912(s0)
	li s2, 4
	mul s3, s1, s2
	mv a0, s3
	jal ra, xmalloc
	mv s1, a0
	sw s1, -840(s0)
	li s1, 1
	li s2, 7
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 556
	add s4, s1, s2
	li s1, 4
	add s2, s4, s1
	lw s1, 0(s2)
	add s2, s3, s1
	sw s2, -852(s0)
	lw s1, -852(s0)
	li s2, 16
	mul s3, s1, s2
	mv a0, s3
	jal ra, xmalloc
	mv s1, a0
	sw s1, -844(s0)
	lw s1, -844(s0)
	lw s2, -848(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	li s3, 16
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -848
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -848(s0)
	li s1, 0
	sw s1, -808(s0)
.L8_7:
	lw s1, -808(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L8_8
	j .L8_9
.L8_8:
	addi s1, s0, -928
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
	li s2, 0
	sw s2, 0(s1)
	li s2, 0
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 4
	sll s4, s2, s3
	li s2, 3
	li s3, 15
	and s5, s2, s3
	or s2, s4, s5
	li s3, 12
	add s4, s1, s3
	sb s2, 0(s4)
	li s2, 0
	li s3, 13
	add s4, s1, s3
	sb s2, 0(s4)
	lw s2, -808(s0)
	mv a0, s2
	jal ra, rsec_shndx
	mv s3, a0
	li s2, 65535
	and s4, s3, s2
	li s2, 14
	add s3, s1, s2
	sh s4, 0(s3)
	addi s1, s0, -928
	lw s2, -844(s0)
	lw s3, -848(s0)
	li s4, 16
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
	lw s1, 0(s4)
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -848
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -848(s0)
	addi s1, s0, -836
	lw s3, -808(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L8_10:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_7
.L8_9:
	li s1, 0
	sw s1, -808(s0)
.L8_11:
	lw s1, -808(s0)
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	slt s3, s1, s2
	bnez s3, .L8_12
	j .L8_13
.L8_12:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -808(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L8_14
	j .L8_15
.L8_15:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -808(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L8_16
	j .L8_14
.L8_14:
	j .L8_17
.L8_16:
	addi s1, s0, -944
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
	addi s2, s0, -32
	lw s3, -4(s0)
	li s4, 556
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -808(s0)
	li s5, 32
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s2
	mv a1, s3
	jal ra, strtab_add
	mv s4, a0
	sw s4, 0(s1)
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -808(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	lw s2, 0(s4)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -808(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 28
	add s4, s3, s2
	lw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 4
	sll s4, s2, s3
	lw s2, -4(s0)
	li s3, 556
	add s5, s2, s3
	lw s2, 0(s5)
	lw s3, -808(s0)
	li s5, 32
	mul s6, s3, s5
	add s3, s2, s6
	li s2, 24
	add s5, s3, s2
	lw s2, 0(s5)
	bnez s2, .L8_18
	j .L8_19
.L8_18:
	li s2, 2
	sw s2, -948(s0)
	j .L8_20
.L8_19:
	li s2, 0
	sw s2, -948(s0)
.L8_20:
	lw s2, -948(s0)
	li s3, 15
	and s5, s2, s3
	or s2, s4, s5
	li s3, 12
	add s4, s1, s3
	sb s2, 0(s4)
	li s2, 0
	li s3, 13
	add s4, s1, s3
	sb s2, 0(s4)
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -808(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	mv a0, s2
	jal ra, rsec_shndx
	mv s3, a0
	li s2, 65535
	and s4, s3, s2
	li s2, 14
	add s3, s1, s2
	sh s4, 0(s3)
	addi s1, s0, -944
	lw s2, -844(s0)
	lw s3, -848(s0)
	li s4, 16
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
	lw s1, 0(s4)
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -848
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -848(s0)
	lw s1, -840(s0)
	lw s3, -808(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L8_17:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_11
.L8_13:
	lw s1, -848(s0)
	sw s1, -800(s0)
	li s1, 0
	sw s1, -808(s0)
.L8_21:
	lw s1, -808(s0)
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	lw s2, 0(s3)
	slt s3, s1, s2
	bnez s3, .L8_22
	j .L8_23
.L8_22:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -808(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L8_24
	j .L8_25
.L8_25:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -808(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L8_26
	j .L8_24
.L8_26:
	j .L8_27
.L8_24:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -808(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L8_28
	j .L8_29
.L8_29:
	li s1, 0
	sw s1, -952(s0)
	j .L8_30
.L8_28:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -808(s0)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	mv a0, s1
	jal ra, rsec_shndx
	mv s2, a0
	li s1, 65535
	and s3, s2, s1
	sw s3, -952(s0)
.L8_30:
	addi s1, s0, -968
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
	addi s2, s0, -32
	lw s3, -4(s0)
	li s4, 556
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -808(s0)
	li s5, 32
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s2
	mv a1, s3
	jal ra, strtab_add
	mv s4, a0
	sw s4, 0(s1)
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -808(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 20
	add s4, s3, s2
	lw s2, 0(s4)
	bnez s2, .L8_31
	j .L8_32
.L8_31:
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -808(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	lw s2, 0(s4)
	sw s2, -972(s0)
	j .L8_33
.L8_32:
	li s2, 0
	sw s2, -972(s0)
.L8_33:
	lw s2, -972(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -808(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 28
	add s4, s3, s2
	lw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -808(s0)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 16
	add s4, s3, s2
	lw s2, 0(s4)
	bnez s2, .L8_34
	j .L8_35
.L8_34:
	li s2, 2
	sw s2, -976(s0)
	j .L8_36
.L8_35:
	li s2, 1
	sw s2, -976(s0)
.L8_36:
	lw s2, -976(s0)
	li s3, 4
	sll s4, s2, s3
	lw s2, -4(s0)
	li s3, 556
	add s5, s2, s3
	lw s2, 0(s5)
	lw s3, -808(s0)
	li s5, 32
	mul s6, s3, s5
	add s3, s2, s6
	li s2, 24
	add s5, s3, s2
	lw s2, 0(s5)
	bnez s2, .L8_37
	j .L8_38
.L8_37:
	li s2, 2
	sw s2, -980(s0)
	j .L8_39
.L8_38:
	li s2, 0
	sw s2, -980(s0)
.L8_39:
	lw s2, -980(s0)
	li s3, 15
	and s5, s2, s3
	or s2, s4, s5
	li s3, 12
	add s4, s1, s3
	sb s2, 0(s4)
	li s2, 0
	li s3, 13
	add s4, s1, s3
	sb s2, 0(s4)
	addi s2, s0, -952
	lhu s3, 0(s2)
	li s2, 14
	add s4, s1, s2
	sh s3, 0(s4)
	addi s1, s0, -968
	lw s2, -844(s0)
	lw s3, -848(s0)
	li s4, 16
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
	lw s1, 0(s4)
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -848
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -848(s0)
	lw s1, -840(s0)
	lw s3, -808(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L8_27:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_21
.L8_23:
	lw s1, -848(s0)
	sw s1, -804(s0)
	li s1, 0
	sw s1, -808(s0)
.L8_40:
	lw s1, -808(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L8_41
	j .L8_42
.L8_41:
	addi s1, s0, -908
	lw s2, -808(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 12
	mul s3, s1, s2
	addi s1, s0, -1036
	lw s2, -808(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -908
	lw s2, -808(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L8_43
	j .L8_44
.L8_43:
	addi s1, s0, -1036
	lw s2, -808(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -1040(s0)
	j .L8_45
.L8_44:
	li s1, 0
	sw s1, -1040(s0)
.L8_45:
	lw s1, -1040(s0)
	addi s2, s0, -1008
	lw s3, -808(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L8_46:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_40
.L8_42:
	li s1, 0
	sw s1, -808(s0)
.L8_47:
	lw s1, -808(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L8_48
	j .L8_49
.L8_48:
	li s1, 0
	sw s1, -1044(s0)
.L8_50:
	lw s1, -1044(s0)
	addi s2, s0, -908
	lw s3, -808(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	slt s3, s1, s2
	bnez s3, .L8_51
	j .L8_52
.L8_51:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	lw s1, -808(s0)
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1044(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -1048(s0)
	addi s1, s0, -1008
	lw s2, -808(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -1044(s0)
	li s3, 12
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -1052(s0)
	lw s1, -840(s0)
	lw s2, -1048(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1056(s0)
	lw s1, -1048(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1060(s0)
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1048(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L8_53
	j .L8_54
.L8_53:
	lw s1, -4(s0)
	li s2, 556
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1048(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 32
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L8_54
	j .L8_55
.L8_55:
	addi s1, s0, -1060
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 556
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -1048(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 32
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 8
	add s4, s3, s1
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -1060(s0)
	addi s1, s0, -836
	lw s2, -4(s0)
	li s3, 556
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -1048(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 32
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1056(s0)
.L8_54:
	lw s1, -1052(s0)
	li s2, 0
	add s3, s1, s2
	lw s1, -1048(s0)
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s2
	jal ra, put32
	mv s1, a0
	lw s1, -1052(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, -1056(s0)
	li s2, 8
	sll s4, s1, s2
	lw s1, -1048(s0)
	li s2, 12
	add s5, s1, s2
	lw s1, 0(s5)
	li s2, 255
	and s5, s1, s2
	or s1, s4, s5
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	lw s1, -1052(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, -1060(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
.L8_56:
	addi s1, s0, -1044
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1044(s0)
	j .L8_50
.L8_52:
.L8_57:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_47
.L8_49:
	lw s1, -804(s0)
	li s2, 16
	mul s3, s1, s2
	sw s3, -1064(s0)
	li s1, 52
	sw s1, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1092
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -880
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1092
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -880
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1092
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -880
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1092
	li s3, 4
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -880
	li s3, 4
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1092
	li s3, 5
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -880
	li s3, 5
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1092
	li s3, 6
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -880
	li s3, 6
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1092
	li s3, 3
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -796(s0)
	sw s1, -1096(s0)
	addi s1, s0, -796
	lw s2, 0(s1)
	lw s1, -1064(s0)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	sw s1, -1100(s0)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -32
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1128
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -1036
	li s3, 0
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1128
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -1036
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1128
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -1036
	li s3, 1
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1128
	li s3, 4
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -1036
	li s3, 4
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1128
	li s3, 5
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -1036
	li s3, 5
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	addi s2, s0, -1128
	li s3, 6
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -796(s0)
	sw s1, -1132(s0)
	addi s1, s0, -796
	lw s2, 0(s1)
	addi s1, s0, -20
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -796(s0)
	lw s1, -796(s0)
	sw s1, -1136(s0)
	addi s1, s0, -148
	li s2, 0
	li s3, 52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -148
	la s2, __str_15
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 1
	addi s2, s0, -148
	li s3, 4
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 1
	addi s2, s0, -148
	li s3, 5
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 1
	addi s2, s0, -148
	li s3, 6
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	addi s2, s0, -148
	li s3, 7
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -148
	li s2, 16
	add s3, s1, s2
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -148
	li s2, 18
	add s3, s1, s2
	li s1, 243
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -148
	li s2, 20
	add s3, s1, s2
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -148
	li s2, 32
	add s3, s1, s2
	lw s1, -1136(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -148
	li s2, 36
	add s3, s1, s2
	li s1, 0
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -148
	li s2, 40
	add s3, s1, s2
	li s1, 52
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -148
	li s2, 46
	add s3, s1, s2
	li s1, 40
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -148
	li s2, 48
	add s3, s1, s2
	li s1, 16
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -148
	li s2, 50
	add s3, s1, s2
	li s1, 15
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -792
	li s2, 0
	li s3, 640
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -792
	li s2, 1
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	li s2, 1
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 1
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 1
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	li s1, 2
	li s2, 4
	or s4, s1, s2
	mv a0, s3
	mv a1, s4
	jal ra, put32
	mv s1, a0
	addi s1, s0, -792
	li s2, 1
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	addi s1, s0, -1092
	li s2, 0
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 1
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	addi s1, s0, -880
	li s2, 0
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 1
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 32
	add s3, s2, s1
	lw s1, -4(s0)
	li s2, 328
	add s4, s1, s2
	li s1, 0
	li s2, 32
	mul s5, s1, s2
	add s1, s4, s5
	mv a0, s1
	jal ra, sec_addralign
	mv s2, a0
	mv a0, s3
	mv a1, s2
	jal ra, put32
	mv s1, a0
	addi s1, s0, -792
	li s2, 2
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	li s2, 2
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 2
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 2
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	li s1, 2
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 2
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	addi s1, s0, -1092
	li s2, 2
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 2
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	addi s1, s0, -880
	li s2, 2
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 2
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 32
	add s3, s2, s1
	lw s1, -4(s0)
	li s2, 328
	add s4, s1, s2
	li s1, 2
	li s2, 32
	mul s5, s1, s2
	add s1, s4, s5
	mv a0, s1
	jal ra, sec_addralign
	mv s2, a0
	mv a0, s3
	mv a1, s2
	jal ra, put32
	mv s1, a0
	addi s1, s0, -792
	li s2, 3
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	li s2, 3
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 3
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 3
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	li s1, 1
	li s2, 2
	or s4, s1, s2
	mv a0, s3
	mv a1, s4
	jal ra, put32
	mv s1, a0
	addi s1, s0, -792
	li s2, 3
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	addi s1, s0, -1092
	li s2, 1
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 3
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	addi s1, s0, -880
	li s2, 1
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 3
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 32
	add s3, s2, s1
	lw s1, -4(s0)
	li s2, 328
	add s4, s1, s2
	li s1, 1
	li s2, 32
	mul s5, s1, s2
	add s1, s4, s5
	mv a0, s1
	jal ra, sec_addralign
	mv s2, a0
	mv a0, s3
	mv a1, s2
	jal ra, put32
	mv s1, a0
	addi s1, s0, -792
	li s2, 4
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	li s2, 4
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 4
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 8
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 4
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	li s1, 1
	li s2, 2
	or s4, s1, s2
	mv a0, s3
	mv a1, s4
	jal ra, put32
	mv s1, a0
	addi s1, s0, -792
	li s2, 4
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	addi s1, s0, -1092
	li s2, 3
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 4
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	addi s1, s0, -880
	li s2, 3
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 4
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 32
	add s3, s2, s1
	lw s1, -4(s0)
	li s2, 328
	add s4, s1, s2
	li s1, 3
	li s2, 32
	mul s5, s1, s2
	add s1, s4, s5
	mv a0, s1
	jal ra, sec_addralign
	mv s2, a0
	mv a0, s3
	mv a1, s2
	jal ra, put32
	mv s1, a0
	addi s1, s0, -792
	li s2, 5
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	li s2, 5
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 5
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 2
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 5
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, -1096(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 5
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	lw s1, -1064(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 5
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 24
	add s3, s2, s1
	li s1, 6
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 5
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 28
	add s3, s2, s1
	lw s1, -800(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 5
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 32
	add s3, s2, s1
	li s1, 4
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 5
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 36
	add s3, s2, s1
	li s1, 16
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 6
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	li s2, 6
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 6
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 3
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 6
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, -1100(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 6
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	addi s1, s0, -32
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 6
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 36
	add s3, s2, s1
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1160
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
	li s2, 10
	sw s2, 0(s1)
	li s2, 4
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 11
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 5
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 12
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 6
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	sw s1, -1164(s0)
.L8_58:
	lw s1, -1164(s0)
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L8_59
	j .L8_60
.L8_59:
	addi s1, s0, -1160
	lw s2, -1164(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1168(s0)
	addi s1, s0, -792
	lw s2, -1168(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	lw s2, -1168(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1168(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1168(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	li s1, 0
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1168(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	addi s1, s0, -1092
	addi s2, s0, -1160
	lw s4, -1164(s0)
	li s5, 8
	mul s6, s4, s5
	add s4, s2, s6
	li s2, 4
	add s5, s4, s2
	lw s2, 0(s5)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1168(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	addi s1, s0, -880
	addi s2, s0, -1160
	lw s4, -1164(s0)
	li s5, 8
	mul s6, s4, s5
	add s4, s2, s6
	li s2, 4
	add s5, s4, s2
	lw s2, 0(s5)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1168(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 32
	add s3, s2, s1
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
.L8_61:
	addi s1, s0, -1164
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1164(s0)
	j .L8_58
.L8_60:
	addi s1, s0, -1228
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
	li s2, 7
	sw s2, 0(s1)
	li s2, 0
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 8
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 2
	li s3, 20
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 9
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 1
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 3
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 13
	li s3, 36
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 4
	li s3, 40
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 10
	li s3, 44
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 14
	li s3, 48
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 5
	li s3, 52
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 11
	li s3, 56
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	sw s1, -1232(s0)
.L8_62:
	lw s1, -1232(s0)
	li s2, 5
	slt s3, s1, s2
	bnez s3, .L8_63
	j .L8_64
.L8_63:
	addi s1, s0, -1228
	lw s2, -1232(s0)
	li s3, 12
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1236(s0)
	addi s1, s0, -792
	lw s2, -1236(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	lw s2, -1236(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1236(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 4
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1236(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	addi s1, s0, -1128
	addi s2, s0, -1228
	lw s4, -1232(s0)
	li s5, 12
	mul s6, s4, s5
	add s4, s2, s6
	li s2, 4
	add s5, s4, s2
	lw s2, 0(s5)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1236(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	addi s1, s0, -1036
	addi s2, s0, -1228
	lw s4, -1232(s0)
	li s5, 12
	mul s6, s4, s5
	add s4, s2, s6
	li s2, 4
	add s5, s4, s2
	lw s2, 0(s5)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1236(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 24
	add s3, s2, s1
	li s1, 5
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1236(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 28
	add s3, s2, s1
	addi s1, s0, -1228
	lw s2, -1232(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 8
	add s4, s2, s1
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1236(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 32
	add s3, s2, s1
	li s1, 4
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	lw s2, -1236(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 36
	add s3, s2, s1
	li s1, 12
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
.L8_65:
	addi s1, s0, -1232
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1232(s0)
	j .L8_62
.L8_64:
	addi s1, s0, -792
	li s2, 15
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 0
	add s3, s2, s1
	addi s1, s0, -96
	li s2, 15
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 15
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	li s1, 3
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 15
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 16
	add s3, s2, s1
	lw s1, -1132(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 15
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 20
	add s3, s2, s1
	addi s1, s0, -20
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -792
	li s2, 15
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 36
	add s3, s2, s1
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -148
	li s2, 1
	li s3, 52
	lw s4, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	addi s1, s0, -880
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_66
	j .L8_67
.L8_66:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 0
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	li s1, 1
	addi s3, s0, -880
	li s4, 0
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_67:
	addi s1, s0, -880
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_68
	j .L8_69
.L8_68:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 2
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	li s1, 1
	addi s3, s0, -880
	li s4, 2
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_69:
	addi s1, s0, -880
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_70
	j .L8_71
.L8_70:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 1
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	li s1, 1
	addi s3, s0, -880
	li s4, 1
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_71:
	addi s1, s0, -880
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_72
	j .L8_73
.L8_72:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 4
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	li s1, 1
	addi s3, s0, -880
	li s4, 4
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_73:
	addi s1, s0, -880
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_74
	j .L8_75
.L8_74:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 5
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	li s1, 1
	addi s3, s0, -880
	li s4, 5
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_75:
	addi s1, s0, -880
	li s2, 6
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_76
	j .L8_77
.L8_76:
	lw s1, -4(s0)
	li s2, 328
	add s3, s1, s2
	li s1, 6
	li s2, 32
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	li s1, 1
	addi s3, s0, -880
	li s4, 6
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_77:
	li s1, 0
	sw s1, -808(s0)
.L8_78:
	lw s1, -808(s0)
	lw s2, -804(s0)
	slt s3, s1, s2
	bnez s3, .L8_79
	j .L8_80
.L8_79:
	addi s1, s0, -1256
	lw s2, -844(s0)
	lw s3, -808(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	mv a0, s1
	mv a1, s3
	jal ra, write_sym
	mv s2, a0
	addi s1, s0, -1256
	li s2, 1
	li s3, 16
	lw s4, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_81:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_78
.L8_80:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	addi s3, s0, -32
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	addi s1, s0, -1036
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_82
	j .L8_83
.L8_82:
	addi s1, s0, -1008
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	addi s3, s0, -1036
	li s4, 0
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_83:
	addi s1, s0, -1036
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_84
	j .L8_85
.L8_84:
	addi s1, s0, -1008
	li s2, 2
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	addi s3, s0, -1036
	li s4, 2
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_85:
	addi s1, s0, -1036
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_86
	j .L8_87
.L8_86:
	addi s1, s0, -1008
	li s2, 1
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	addi s3, s0, -1036
	li s4, 1
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_87:
	addi s1, s0, -1036
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_88
	j .L8_89
.L8_88:
	addi s1, s0, -1008
	li s2, 4
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	addi s3, s0, -1036
	li s4, 4
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_89:
	addi s1, s0, -1036
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L8_90
	j .L8_91
.L8_90:
	addi s1, s0, -1008
	li s2, 5
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 1
	addi s3, s0, -1036
	li s4, 5
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	lw s4, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_91:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	addi s3, s0, -20
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	li s1, 0
	sw s1, -808(s0)
.L8_92:
	lw s1, -808(s0)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L8_93
	j .L8_94
.L8_93:
	addi s1, s0, -792
	lw s2, -808(s0)
	li s3, 40
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 1
	li s3, 40
	lw s4, -8(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L8_95:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_92
.L8_94:
	lw s1, -840(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -844(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 0
	sw s1, -808(s0)
.L8_96:
	lw s1, -808(s0)
	li s2, 7
	slt s3, s1, s2
	bnez s3, .L8_97
	j .L8_98
.L8_97:
	addi s1, s0, -1008
	lw s2, -808(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L8_99:
	addi s1, s0, -808
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -808(s0)
	j .L8_96
.L8_98:
	addi s1, s0, -32
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	addi s1, s0, -20
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li s1, 0
	mv a0, s1
	lw s1, -1300(s0)
	lw s2, -1296(s0)
	lw s3, -1292(s0)
	lw s4, -1288(s0)
	lw s5, -1284(s0)
	lw s6, -1280(s0)
	lw s7, -1276(s0)
	lw s8, -1272(s0)
	lw s9, -1268(s0)
	lw s10, -1264(s0)
	lw s11, -1260(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end8:
	.size rv_elf_write, .Lfunc_end8-rv_elf_write

	.data
	.align 2
__str_15:
	.ascii "\177ELF\000"
	.align 2
__str_14:
	.ascii ".shstrtab\000"
	.align 2
__str_13:
	.ascii ".rela.debug_info\000"
	.align 2
__str_12:
	.ascii ".rela.debug_line\000"
	.align 2
__str_11:
	.ascii ".debug_abbrev\000"
	.align 2
__str_10:
	.ascii ".debug_info\000"
	.align 2
__str_9:
	.ascii ".debug_line\000"
	.align 2
__str_8:
	.ascii ".rela.data\000"
	.align 2
__str_7:
	.ascii ".rela.rodata\000"
	.align 2
__str_6:
	.ascii ".rela.text\000"
	.align 2
__str_5:
	.ascii ".strtab\000"
	.align 2
__str_4:
	.ascii ".symtab\000"
	.align 2
__str_3:
	.ascii ".bss\000"
	.align 2
__str_2:
	.ascii ".data\000"
	.align 2
__str_1:
	.ascii ".rodata\000"
	.align 2
__str_0:
	.ascii ".text\000"
