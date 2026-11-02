# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl opendir
	.type opendir, @function
opendir:
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
	li s2, 65536
	li s3, 0
	or s4, s2, s3
	li s2, 0
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, fs_open
	mv s3, a0
	sw s3, -16(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L1_0
	j .L1_1
.L1_0:
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
.L1_1:
	li s1, 288
	mv a0, s1
	jal ra, malloc
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L1_2
	j .L1_3
.L1_3:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, fs_close
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
.L1_2:
	lw s1, -16(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
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
	.size opendir, .Lfunc_end1-opendir

	.text
	.align 2
	.globl readdir
	.type readdir, @function
readdir:
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
	lw s1, -4(s0)
	bnez s1, .L2_0
	j .L2_1
.L2_1:
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
.L2_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	addi s1, s0, -72
	li s3, 64
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, fs_read
	mv s4, a0
	li s1, 64
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L2_2
	j .L2_3
.L2_2:
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
.L2_3:
	addi s1, s0, -72
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	mv s10, s2
	li s11, 0
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	li s2, 8
	add s3, s4, s2
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s3)
	sw s11, 4(s3)
	li s1, 280
	li s2, 65535
	and s3, s1, s2
	lw s1, -4(s0)
	li s2, 8
	add s4, s1, s2
	li s1, 16
	add s2, s4, s1
	sh s3, 0(s2)
	addi s1, s0, -72
	li s2, 4
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_4
	j .L2_5
.L2_4:
	li s1, 4
	sw s1, -76(s0)
	j .L2_6
.L2_5:
	addi s1, s0, -72
	li s2, 4
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L2_7
	j .L2_8
.L2_7:
	li s1, 8
	sw s1, -80(s0)
	j .L2_9
.L2_8:
	li s1, 0
	sw s1, -80(s0)
.L2_9:
	lw s1, -80(s0)
	sw s1, -76(s0)
.L2_6:
	lw s1, -76(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	li s2, 18
	add s3, s4, s2
	sb s1, 0(s3)
	li s1, 0
	sw s1, -84(s0)
.L2_10:
	lw s1, -84(s0)
	li s2, 256
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L2_11
	j .L2_12
.L2_11:
	addi s1, s0, -72
	li s2, 8
	add s3, s1, s2
	lw s1, -84(s0)
	add s2, s3, s1
	lb s1, 0(s2)
	bnez s1, .L2_13
	j .L2_12
.L2_13:
	addi s1, s0, -72
	li s2, 8
	add s3, s1, s2
	lw s1, -84(s0)
	add s2, s3, s1
	lb s1, 0(s2)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	li s2, 19
	add s3, s4, s2
	lw s2, -84(s0)
	add s4, s3, s2
	sb s1, 0(s4)
	addi s1, s0, -84
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -84(s0)
	j .L2_10
.L2_12:
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	li s2, 19
	add s3, s4, s2
	lw s2, -84(s0)
	add s4, s3, s2
	sb s1, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	mv a0, s3
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
.Lfunc_end2:
	.size readdir, .Lfunc_end2-readdir

	.text
	.align 2
	.globl closedir
	.type closedir, @function
closedir:
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
	bnez s1, .L3_0
	j .L3_1
.L3_1:
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
.L3_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, fs_close
	mv s1, a0
	sw s1, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
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
	.size closedir, .Lfunc_end3-closedir

	.data
