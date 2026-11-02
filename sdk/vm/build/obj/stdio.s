# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl fopen
	.type fopen, @function
fopen:
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
	li s1, 0
	sw s1, -24(s0)
	lw s1, -8(s0)
	sw s1, -28(s0)
.L1_0:
	lw s1, -28(s0)
	lb s2, 0(s1)
	bnez s2, .L1_1
	j .L1_2
.L1_1:
	lw s1, -28(s0)
	lb s2, 0(s1)
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L1_3
	j .L1_4
.L1_3:
	li s1, 1
	sw s1, -24(s0)
.L1_4:
.L1_5:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L1_0
.L1_2:
	lw s1, -8(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 114
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_6
	li s2, 119
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_7
	li s2, 97
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_8
	j .L1_9
.L1_6:
	lw s1, -24(s0)
	bnez s1, .L1_10
	j .L1_11
.L1_10:
	li s1, 2
	sw s1, -36(s0)
	j .L1_12
.L1_11:
	li s1, 0
	sw s1, -36(s0)
.L1_12:
	lw s1, -36(s0)
	sw s1, -12(s0)
	lw s1, -24(s0)
	bnez s1, .L1_13
	j .L1_14
.L1_13:
	li s1, 1
	li s2, 2
	or s3, s1, s2
	sw s3, -40(s0)
	j .L1_15
.L1_14:
	li s1, 1
	sw s1, -40(s0)
.L1_15:
	lw s1, -40(s0)
	sw s1, -16(s0)
	j .L1_16
.L1_7:
	lw s1, -24(s0)
	bnez s1, .L1_17
	j .L1_18
.L1_17:
	li s1, 2
	sw s1, -44(s0)
	j .L1_19
.L1_18:
	li s1, 1
	sw s1, -44(s0)
.L1_19:
	lw s1, -44(s0)
	li s2, 64
	or s3, s1, s2
	li s1, 512
	or s2, s3, s1
	sw s2, -12(s0)
	lw s1, -24(s0)
	bnez s1, .L1_20
	j .L1_21
.L1_20:
	li s1, 1
	li s2, 2
	or s3, s1, s2
	sw s3, -48(s0)
	j .L1_22
.L1_21:
	li s1, 2
	sw s1, -48(s0)
.L1_22:
	lw s1, -48(s0)
	sw s1, -16(s0)
	j .L1_16
.L1_8:
	lw s1, -24(s0)
	bnez s1, .L1_23
	j .L1_24
.L1_23:
	li s1, 2
	sw s1, -52(s0)
	j .L1_25
.L1_24:
	li s1, 1
	sw s1, -52(s0)
.L1_25:
	lw s1, -52(s0)
	li s2, 64
	or s3, s1, s2
	li s1, 1024
	or s2, s3, s1
	sw s2, -12(s0)
	lw s1, -24(s0)
	bnez s1, .L1_26
	j .L1_27
.L1_26:
	li s1, 1
	li s2, 2
	or s3, s1, s2
	sw s3, -56(s0)
	j .L1_28
.L1_27:
	li s1, 2
	sw s1, -56(s0)
.L1_28:
	lw s1, -56(s0)
	sw s1, -16(s0)
	j .L1_16
.L1_9:
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
.L1_16:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 438
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, open
	mv s4, a0
	sw s4, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L1_29
	j .L1_30
.L1_29:
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
.L1_30:
	li s1, 1068
	mv a0, s1
	jal ra, malloc
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L1_31
	j .L1_32
.L1_31:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, close
	mv s2, a0
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
.L1_32:
	lw s1, -20(s0)
	lw s2, -32(s0)
	sw s1, 0(s2)
	lw s1, -16(s0)
	li s2, 16
	or s3, s1, s2
	lw s1, -32(s0)
	li s2, 4
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 0
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -32(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -32(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end1:
	.size fopen, .Lfunc_end1-fopen

	.text
	.align 2
	.globl fclose
	.type fclose, @function
fclose:
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
	jal ra, fflush
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 32
	and s3, s1, s2
	bnez s3, .L2_0
	j .L2_1
.L2_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, close
	mv s1, a0
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L2_2
	j .L2_0
.L2_2:
	li s1, 1
	neg s2, s1
	sw s2, -12(s0)
.L2_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	and s3, s1, s2
	bnez s3, .L2_3
	j .L2_4
.L2_3:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
.L2_4:
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
	.size fclose, .Lfunc_end2-fclose

	.text
	.align 2
	.globl fseek
	.type fseek, @function
fseek:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 32
	and s3, s1, s2
	bnez s3, .L3_0
	j .L3_1
.L3_0:
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
.L3_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	and s3, s1, s2
	bnez s3, .L3_2
	j .L3_3
.L3_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, fflush
	mv s2, a0
	li s1, 1
	neg s3, s1
	xor s1, s2, s3
	seqz s1, s1
	bnez s1, .L3_4
	j .L3_3
.L3_4:
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
.L3_3:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	lw s3, -12(s0)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, lseek
	mv s4, a0
	li s1, 0
	slt s2, s4, s1
	bnez s2, .L3_5
	j .L3_6
.L3_5:
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
.L3_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	not s4, s2
	and s2, s1, s4
	sw s2, 0(s3)
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
	.size fseek, .Lfunc_end3-fseek

	.text
	.align 2
	.globl ftell
	.type ftell, @function
ftell:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 32
	and s3, s1, s2
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
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
.L4_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 0
	li s3, 1
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, lseek
	mv s4, a0
	sw s4, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L4_2
	j .L4_3
.L4_2:
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
.L4_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	and s3, s1, s2
	bnez s3, .L4_4
	j .L4_5
.L4_4:
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 12
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -12(s0)
	j .L4_6
.L4_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -4(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	sub s4, s1, s3
	sub s1, s2, s4
	sw s1, -12(s0)
.L4_6:
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
	.size ftell, .Lfunc_end4-ftell

	.text
	.align 2
	.globl rewind
	.type rewind, @function
rewind:
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
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fseek
	mv s4, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 8
	not s4, s2
	and s2, s1, s4
	sw s2, 0(s3)
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
.Lfunc_end5:
	.size rewind, .Lfunc_end5-rewind

	.text
	.align 2
	.type file_put, @function
file_put:
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
	sw s1, -12(s0)
	addi s1, s0, -8
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	lw s1, -12(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, fputc
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
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
.Lfunc_end6:
	.size file_put, .Lfunc_end6-file_put

	.text
	.align 2
	.globl vfprintf
	.type vfprintf, @function
vfprintf:
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
	la s1, file_put
	addi s2, s0, -28
	sw s1, 0(s2)
	li s1, 0
	addi s2, s0, -28
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	addi s2, s0, -28
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -28
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, __vformat
	mv s4, a0
	addi s1, s0, -28
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
.Lfunc_end7:
	.size vfprintf, .Lfunc_end7-vfprintf

	.text
	.align 2
	.globl fprintf
	.type fprintf, @function
fprintf:
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
	addi s1, s0, -24
	addi t0, s0, 8
	sw t0, 8(s1)
	sw zero, 0(s1)
	sw zero, 4(s1)
	sw zero, 12(s1)
	li s1, 0
	lw s1, -4(s0)
	lw s2, -8(s0)
	addi s3, s0, -24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, vfprintf
	mv s4, a0
	sw s4, -28(s0)
	li s1, 0
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
.Lfunc_end8:
	.size fprintf, .Lfunc_end8-fprintf

	.text
	.align 2
	.globl vprintf
	.type vprintf, @function
vprintf:
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
	la s1, __libc_stdout
	lw s2, -4(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, vfprintf
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
.Lfunc_end9:
	.size vprintf, .Lfunc_end9-vprintf

	.text
	.align 2
	.globl printf
	.type printf, @function
printf:
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
	addi s1, s0, -24
	addi t0, s0, 8
	sw t0, 8(s1)
	sw zero, 0(s1)
	sw zero, 4(s1)
	sw zero, 12(s1)
	li s1, 0
	la s1, __libc_stdout
	lw s2, -4(s0)
	addi s3, s0, -24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, vfprintf
	mv s4, a0
	sw s4, -28(s0)
	li s1, 0
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
.Lfunc_end10:
	.size printf, .Lfunc_end10-printf

	.data
