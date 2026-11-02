# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type out_bytes, @function
out_bytes:
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
	slt s3, s2, s1
	bnez s3, .L1_0
	j .L1_1
.L1_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, write
	mv s4, a0
	sw s4, -20(s0)
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
.L1_1:
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
.Lfunc_end1:
	.size out_bytes, .Lfunc_end1-out_bytes

	.text
	.align 2
	.globl io_write_str
	.type io_write_str, @function
io_write_str:
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
	mv a0, s2
	jal ra, kp_str_bytes
	mv s3, a0
	lw s2, -8(s0)
	mv a0, s2
	jal ra, kp_str_len
	mv s4, a0
	mv a0, s1
	mv a1, s3
	mv a2, s4
	jal ra, out_bytes
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
	.size io_write_str, .Lfunc_end2-io_write_str

	.text
	.align 2
	.globl io_write_char
	.type io_write_char, @function
io_write_char:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	sw s2, -12(s0)
	lw s1, -4(s0)
	addi s2, s0, -12
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, out_bytes
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
.Lfunc_end3:
	.size io_write_char, .Lfunc_end3-io_write_char

	.text
	.align 2
	.globl io_write_int
	.type io_write_int, @function
io_write_int:
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
	li s1, 0
	sw s1, -24(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	li s1, 0
	lw s2, -8(s0)
	sub s3, s1, s2
	sw s3, -32(s0)
	j .L4_2
.L4_1:
	lw s1, -8(s0)
	sw s1, -32(s0)
.L4_2:
	lw s1, -32(s0)
	sw s1, -28(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L4_3
	j .L4_4
.L4_3:
	li s1, 45
	addi s2, s0, -20
	addi s3, s0, -24
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -24(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L4_4:
	addi s1, s0, -24
	lw s2, 0(s1)
	addi s1, s0, -20
	lw s3, -24(s0)
	add s4, s1, s3
	lw s1, -28(s0)
	mv s10, s1
	li s11, 0
	mv a0, s4
	mv a1, s10
	mv a2, s11
	jal ra, __fmt_udec
	mv s1, a0
	add s3, s2, s1
	sw s3, -24(s0)
	lw s1, -4(s0)
	addi s2, s0, -20
	lw s3, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, out_bytes
	mv s4, a0
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
	.size io_write_int, .Lfunc_end4-io_write_int

	.text
	.align 2
	.type fmt_g, @function
fmt_g:
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
	fsd fs0, 56(sp)
	fsd fs1, 64(sp)
	fsd fs2, 72(sp)
	sw a0, -8(s0)
	sw a1, -4(s0)
	sw a2, -12(s0)
	li s1, 0
	sw s1, -20(s0)
	fld fs0, -8(s0)
	fld fs1, -8(s0)
	feq.d s1, fs0, fs1
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_0
	j .L5_1
.L5_0:
	li s1, 110
	lw s2, -12(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 97
	lw s2, -12(s0)
	li s3, 1
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 110
	lw s2, -12(s0)
	li s3, 2
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 3
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
	fld fs0, -48(s0)
	fld fs1, -40(s0)
	fld fs2, -32(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L5_1:
	fld fs0, -8(s0)
	la s1, __flt_0
	fld fs1, 0(s1)
	flt.d s1, fs0, fs1
	bnez s1, .L5_2
	j .L5_3
.L5_2:
	li s1, 45
	lw s2, -12(s0)
	addi s3, s0, -20
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -20(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	fld fs0, -8(s0)
	fneg.d fs1, fs0
	fsd fs1, -8(s0)
.L5_3:
	fld fs0, -8(s0)
	la s1, __flt_1
	fld fs1, 0(s1)
	flt.d s1, fs1, fs0
	bnez s1, .L5_4
	j .L5_5
.L5_4:
	fld fs0, -8(s0)
	fld fs1, -8(s0)
	fadd.d fs2, fs0, fs1
	fld fs0, -8(s0)
	feq.d s1, fs2, fs0
	bnez s1, .L5_6
	j .L5_5
.L5_6:
	li s1, 105
	lw s2, -12(s0)
	addi s3, s0, -20
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -20(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 110
	lw s2, -12(s0)
	addi s3, s0, -20
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -20(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 102
	lw s2, -12(s0)
	addi s3, s0, -20
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -20(s0)
	add s3, s2, s4
	sb s1, 0(s3)
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
	fld fs0, -48(s0)
	fld fs1, -40(s0)
	fld fs2, -32(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L5_5:
	lw s1, -20(s0)
	lw s2, -12(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	fld fs0, -8(s0)
	li s2, 6
	li s3, 0
	li s5, 0
	addi sp, sp, -16
	mv a0, s4
	fsd fs0, 0(sp)
	lw a1, 0(sp)
	lw a2, 4(sp)
	mv a3, s2
	mv a4, s3
	mv a5, s5
	jal ra, __fmt_greal
	mv s6, a0
	addi sp, sp, 16
	add s2, s1, s6
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
	fld fs0, -48(s0)
	fld fs1, -40(s0)
	fld fs2, -32(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end5:
	.size fmt_g, .Lfunc_end5-fmt_g

	.text
	.align 2
	.globl io_write_real
	.type io_write_real, @function
io_write_real:
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
	fsd fs0, 48(sp)
	sw a0, -4(s0)
	sw a1, -16(s0)
	sw a2, -12(s0)
	fld fs0, -16(s0)
	addi s1, s0, -56
	addi sp, sp, -16
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	mv a2, s1
	jal ra, fmt_g
	mv s2, a0
	addi sp, sp, 16
	sw s2, -60(s0)
	lw s1, -4(s0)
	addi s2, s0, -56
	lw s3, -60(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, out_bytes
	mv s4, a0
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
	fld fs0, -72(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end6:
	.size io_write_real, .Lfunc_end6-io_write_real

	.text
	.align 2
	.globl io_flush
	.type io_flush, @function
io_flush:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
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
	.size io_flush, .Lfunc_end7-io_flush

	.text
	.align 2
	.globl io_halt
	.type io_halt, @function
io_halt:
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
	jal ra, _exit
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
.Lfunc_end8:
	.size io_halt, .Lfunc_end8-io_halt

	.text
	.align 2
	.type read_byte, @function
read_byte:
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
	li s1, 0
	addi s2, s0, -4
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, read
	mv s4, a0
	sw s4, -8(s0)
	lw s1, -8(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_0
	j .L9_1
.L9_0:
	li s1, 1
	la s2, g_eof
	sw s1, 0(s2)
	li s1, 1
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
.L9_1:
	addi s1, s0, -4
	lbu s2, 0(s1)
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
.Lfunc_end9:
	.size read_byte, .Lfunc_end9-read_byte

	.text
	.align 2
	.type next_byte, @function
next_byte:
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
	la s1, g_peek
	lw s2, 0(s1)
	li s1, 2
	neg s3, s1
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L10_0
	j .L10_1
.L10_0:
	la s1, g_peek
	lw s2, 0(s1)
	sw s2, -4(s0)
	li s1, 2
	neg s2, s1
	la s1, g_peek
	sw s2, 0(s1)
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
.L10_1:
	jal ra, read_byte
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
.Lfunc_end10:
	.size next_byte, .Lfunc_end10-next_byte

	.text
	.align 2
	.type push_byte, @function
push_byte:
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
	la s2, g_peek
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
.Lfunc_end11:
	.size push_byte, .Lfunc_end11-push_byte

	.text
	.align 2
	.globl io_eof
	.type io_eof, @function
io_eof:
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
	la s1, g_peek
	lw s2, 0(s1)
	li s1, 2
	neg s3, s1
	xor s1, s2, s3
	snez s1, s1
	bnez s1, .L12_0
	j .L12_1
.L12_0:
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
.L12_1:
	la s1, g_eof
	lw s2, 0(s1)
	bnez s2, .L12_2
	j .L12_3
.L12_2:
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
.L12_3:
	jal ra, read_byte
	mv s1, a0
	sw s1, -4(s0)
	lw s1, -4(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L12_4
	j .L12_5
.L12_4:
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
.L12_5:
	lw s1, -4(s0)
	la s2, g_peek
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
.Lfunc_end12:
	.size io_eof, .Lfunc_end12-io_eof

	.text
	.align 2
	.type skip_space, @function
skip_space:
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
.L13_0:
	jal ra, next_byte
	mv s1, a0
	sw s1, -4(s0)
.L13_1:
	lw s1, -4(s0)
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_0
	j .L13_2
.L13_2:
	lw s1, -4(s0)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_0
	j .L13_3
.L13_3:
	lw s1, -4(s0)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_0
	j .L13_4
.L13_4:
	lw s1, -4(s0)
	li s2, 13
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_0
	j .L13_5
.L13_5:
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
.Lfunc_end13:
	.size skip_space, .Lfunc_end13-skip_space

	.text
	.align 2
	.globl io_read_int
	.type io_read_int, @function
io_read_int:
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
	jal ra, skip_space
	mv s1, a0
	sw s1, -4(s0)
	li s1, 0
	sw s1, -8(s0)
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -16(s0)
	sw s11, -12(s0)
	lw s1, -4(s0)
	li s2, 43
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_0
	j .L14_1
.L14_1:
	lw s1, -4(s0)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_0
	j .L14_2
.L14_0:
	lw s1, -4(s0)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	sw s3, -8(s0)
	jal ra, next_byte
	mv s1, a0
	sw s1, -4(s0)
.L14_2:
.L14_3:
	lw s1, -4(s0)
	li s2, 48
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L14_4
	j .L14_5
.L14_4:
	lw s1, -4(s0)
	li s2, 57
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L14_6
	j .L14_5
.L14_6:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 10
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
	lw s1, -4(s0)
	li s2, 48
	sub s3, s1, s2
	mv s10, s3
	srai s11, s10, 31
	add s8, s6, s10
	sltu t0, s8, s10
	add s9, s7, t0
	add s9, s9, s11
	sw s8, -16(s0)
	sw s9, -12(s0)
	jal ra, next_byte
	mv s1, a0
	sw s1, -4(s0)
	j .L14_3
.L14_5:
	lw s1, -4(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L14_7
	j .L14_8
.L14_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, push_byte
	mv s2, a0
.L14_8:
	lw s1, -8(s0)
	bnez s1, .L14_9
	j .L14_10
.L14_9:
	lw s10, -16(s0)
	lw s11, -12(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	sw s8, -24(s0)
	sw s9, -20(s0)
	j .L14_11
.L14_10:
	lw s10, -16(s0)
	lw s11, -12(s0)
	sw s10, -24(s0)
	sw s11, -20(s0)
.L14_11:
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
.Lfunc_end14:
	.size io_read_int, .Lfunc_end14-io_read_int

	.text
	.align 2
	.globl io_read_real
	.type io_read_real, @function
io_read_real:
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
	fsd fs0, 48(sp)
	li s1, 0
	sw s1, -68(s0)
	jal ra, skip_space
	mv s1, a0
	sw s1, -72(s0)
.L15_0:
	lw s1, -72(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L15_1
	j .L15_2
.L15_1:
	lw s1, -72(s0)
	li s2, 32
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_3
	j .L15_2
.L15_3:
	lw s1, -72(s0)
	li s2, 9
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_4
	j .L15_2
.L15_4:
	lw s1, -72(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_5
	j .L15_2
.L15_5:
	lw s1, -72(s0)
	li s2, 13
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_6
	j .L15_2
.L15_6:
	lw s1, -68(s0)
	li s2, 64
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L15_7
	j .L15_2
.L15_7:
	lw s1, -72(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -64
	addi s3, s0, -68
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -68(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	jal ra, next_byte
	mv s1, a0
	sw s1, -72(s0)
	j .L15_0
.L15_2:
	lw s1, -72(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L15_8
	j .L15_9
.L15_8:
	lw s1, -72(s0)
	mv a0, s1
	jal ra, push_byte
	mv s2, a0
.L15_9:
	li s1, 0
	addi s2, s0, -64
	lw s3, -68(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -68(s0)
	bnez s1, .L15_10
	j .L15_11
.L15_10:
	addi s1, s0, -64
	li s2, 0
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	jal ra, strtod
	sw a0, 0(sp)
	sw a1, 4(sp)
	fld fs0, 0(sp)
	addi sp, sp, 16
	fsd fs0, -80(s0)
	j .L15_12
.L15_11:
	la s1, __flt_2
	fld fs0, 0(s1)
	fsd fs0, -80(s0)
.L15_12:
	fld fs0, -80(s0)
	addi sp, sp, -8
	fsd fs0, 0(sp)
	lw a0, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
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
	fld fs0, -88(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
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
	fld fs0, -88(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end15:
	.size io_read_real, .Lfunc_end15-io_read_real

	.text
	.align 2
	.globl io_read_char
	.type io_read_char, @function
io_read_char:
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
	jal ra, next_byte
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
.Lfunc_end16:
	.size io_read_char, .Lfunc_end16-io_read_char

	.text
	.align 2
	.globl io_read_ln
	.type io_read_ln, @function
io_read_ln:
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
.L17_0:
	jal ra, next_byte
	mv s1, a0
	sw s1, -4(s0)
.L17_1:
	lw s1, -4(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L17_2
	j .L17_3
.L17_2:
	lw s1, -4(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L17_0
	j .L17_3
.L17_3:
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
.Lfunc_end17:
	.size io_read_ln, .Lfunc_end17-io_read_ln

	.text
	.align 2
	.globl io_read_str
	.type io_read_str, @function
io_read_str:
	addi sp, sp, -320
	sw ra, 316(sp)
	sw s0, 312(sp)
	addi s0, sp, 312
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
	li s1, 0
	sw s1, -260(s0)
	jal ra, next_byte
	mv s1, a0
	sw s1, -264(s0)
.L18_0:
	lw s1, -264(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L18_1
	j .L18_2
.L18_1:
	lw s1, -264(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	snez s2, s2
	bnez s2, .L18_3
	j .L18_2
.L18_3:
	lw s1, -260(s0)
	li s2, 256
	slt s3, s1, s2
	bnez s3, .L18_4
	j .L18_2
.L18_4:
	lw s1, -264(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -256
	addi s3, s0, -260
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -260(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	jal ra, next_byte
	mv s1, a0
	sw s1, -264(s0)
	j .L18_0
.L18_2:
	lw s1, -264(s0)
	li s2, 10
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_5
	j .L18_6
.L18_5:
	lw s1, -264(s0)
	mv a0, s1
	jal ra, push_byte
	mv s2, a0
.L18_6:
	addi s1, s0, -256
	lw s2, -260(s0)
	mv a0, s1
	mv a1, s2
	jal ra, kp_str_new
	mv s3, a0
	mv a0, s3
	lw s1, -308(s0)
	lw s2, -304(s0)
	lw s3, -300(s0)
	lw s4, -296(s0)
	lw s5, -292(s0)
	lw s6, -288(s0)
	lw s7, -284(s0)
	lw s8, -280(s0)
	lw s9, -276(s0)
	lw s10, -272(s0)
	lw s11, -268(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end18:
	.size io_read_str, .Lfunc_end18-io_read_str

	.data
	.align 3
__flt_2:
	.word 0x00000000
	.word 0x00000000
	.align 3
__flt_1:
	.word 0x00000000
	.word 0x00000000
	.align 3
__flt_0:
	.word 0x00000000
	.word 0x00000000
	.align 2
	.globl g_peek
g_peek:
	.word -2

	.bss
	.align 2
	.globl g_eof
g_eof:
	.space 4
