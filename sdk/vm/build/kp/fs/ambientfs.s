# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type do_statx, @function
do_statx:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 2047
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, statx
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
.Lfunc_end1:
	.size do_statx, .Lfunc_end1-do_statx

	.text
	.align 2
	.type fill_stat, @function
fill_stat:
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
	li s2, 136
	add s3, s1, s2
	lw s1, 0(s3)
	mv s10, s1
	li s11, 0
	li s1, 8
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	lw s1, -4(s0)
	li s2, 140
	add s3, s1, s2
	lw s1, 0(s3)
	mv s10, s1
	li s11, 0
	or s6, s8, s10
	or s7, s9, s11
	lw s1, -8(s0)
	sw s6, 0(s1)
	sw s7, 4(s1)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -4(s0)
	li s2, 40
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 16
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lhu s1, 0(s3)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 28
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
.Lfunc_end2:
	.size fill_stat, .Lfunc_end2-fill_stat

	.text
	.align 2
	.type adir_alloc, @function
adir_alloc:
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
.L3_0:
	lw s1, -12(s0)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	la s1, adirs
	lw s2, -12(s0)
	li s3, 4112
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L3_3
	j .L3_4
.L3_4:
	li s1, 1
	la s2, adirs
	lw s3, -12(s0)
	li s4, 4112
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -4(s0)
	la s2, adirs
	lw s3, -12(s0)
	li s4, 4112
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	la s2, adirs
	lw s3, -12(s0)
	li s4, 4112
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	la s2, adirs
	lw s3, -12(s0)
	li s4, 4112
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
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
.L3_3:
.L3_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L3_0
.L3_2:
	li s1, 16
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
.Lfunc_end3:
	.size adir_alloc, .Lfunc_end3-adir_alloc

	.text
	.align 2
	.type to_oflags, @function
to_oflags:
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
	li s2, 3
	and s3, s1, s2
	li s1, 1
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_0
	li s1, 2
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_1
	j .L4_2
.L4_0:
	li s1, 1
	sw s1, -12(s0)
	j .L4_3
.L4_1:
	li s1, 2
	sw s1, -12(s0)
	j .L4_3
.L4_2:
	li s1, 0
	sw s1, -12(s0)
	j .L4_3
.L4_3:
	lw s1, -4(s0)
	li s2, 64
	and s3, s1, s2
	bnez s3, .L4_4
	j .L4_5
.L4_4:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 64
	or s3, s2, s1
	sw s3, -12(s0)
.L4_5:
	lw s1, -4(s0)
	li s2, 512
	and s3, s1, s2
	bnez s3, .L4_6
	j .L4_7
.L4_6:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 512
	or s3, s2, s1
	sw s3, -12(s0)
.L4_7:
	lw s1, -4(s0)
	li s2, 1024
	and s3, s1, s2
	bnez s3, .L4_8
	j .L4_9
.L4_8:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1024
	or s3, s2, s1
	sw s3, -12(s0)
.L4_9:
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
	.size to_oflags, .Lfunc_end4-to_oflags

	.text
	.align 2
	.type ap, @function
ap:
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
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L5_0
	j .L5_1
.L5_0:
	lw s1, -4(s0)
	sw s1, -12(s0)
	j .L5_2
.L5_1:
	la s1, __str_1
	sw s1, -12(s0)
.L5_2:
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
.Lfunc_end5:
	.size ap, .Lfunc_end5-ap

	.text
	.align 2
	.type amb_open, @function
amb_open:
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
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -16(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L6_0
	j .L6_1
.L6_0:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s2, a0
	li s1, 0
	li s3, 0
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, __sys_open
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L6_2
	j .L6_3
.L6_2:
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
.L6_3:
	lw s1, -28(s0)
	mv a0, s1
	jal ra, adir_alloc
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L6_4
	j .L6_5
.L6_4:
	lw s1, -28(s0)
	mv a0, s1
	jal ra, __sys_close
	mv s2, a0
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
.L6_5:
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
.L6_1:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s2, a0
	lw s1, -16(s0)
	mv a0, s1
	jal ra, to_oflags
	mv s3, a0
	lw s1, -20(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, __sys_open
	mv s4, a0
	sw s4, -28(s0)
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
.Lfunc_end6:
	.size amb_open, .Lfunc_end6-amb_open

	.text
	.align 2
	.type amb_read, @function
amb_read:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, __sys_read
	mv s4, a0
	mv a0, s4
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
	.size amb_read, .Lfunc_end7-amb_read

	.text
	.align 2
	.type amb_write, @function
amb_write:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, __sys_write
	mv s4, a0
	mv a0, s4
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
	.size amb_write, .Lfunc_end8-amb_write

	.text
	.align 2
	.type amb_lseek, @function
amb_lseek:
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
	sw a2, -16(s0)
	sw a3, -12(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	lw s1, -8(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv s2, s10
	lw s3, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, __sys_lseek
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L9_0
	j .L9_1
.L9_0:
	lw s1, -28(s0)
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
	lw s1, -28(s0)
	mv s10, s1
	srai s11, s10, 31
	lw s1, -24(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	lw s1, -28(s0)
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
	.size amb_lseek, .Lfunc_end9-amb_lseek

	.text
	.align 2
	.type amb_readdir, @function
amb_readdir:
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
	la s1, adirs
	lw s2, -8(s0)
	li s3, 4112
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -20(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
.L10_0:
	j .L10_1
.L10_1:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L10_2
	j .L10_3
.L10_2:
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	li s2, 4096
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, getdents64
	mv s3, a0
	sw s3, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L10_4
	j .L10_5
.L10_4:
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
.L10_5:
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_6
	j .L10_7
.L10_6:
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
.L10_7:
	lw s1, -28(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
.L10_3:
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, -20(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	add s2, s3, s1
	sw s2, -24(s0)
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -24(s0)
	li s4, 16
	add s5, s2, s4
	lhu s2, 0(s5)
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -24(s0)
	li s2, 19
	add s3, s1, s2
	la s1, __str_2
	mv a0, s3
	mv a1, s1
	jal ra, strcmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L10_8
	j .L10_9
.L10_9:
	lw s1, -24(s0)
	li s2, 19
	add s3, s1, s2
	la s1, __str_3
	mv a0, s3
	mv a1, s1
	jal ra, strcmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L10_8
	j .L10_10
.L10_8:
	j .L10_11
.L10_10:
	lw s1, -24(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	mv s1, s10
	lw s2, -16(s0)
	sw s1, 0(s2)
	lw s1, -24(s0)
	li s2, 18
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 4
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_12
	j .L10_13
.L10_12:
	li s1, 2
	sw s1, -32(s0)
	j .L10_14
.L10_13:
	lw s1, -24(s0)
	li s2, 18
	add s3, s1, s2
	lbu s1, 0(s3)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L10_15
	j .L10_16
.L10_15:
	li s1, 1
	sw s1, -36(s0)
	j .L10_17
.L10_16:
	li s1, 0
	sw s1, -36(s0)
.L10_17:
	lw s1, -36(s0)
	sw s1, -32(s0)
.L10_14:
	lw s1, -32(s0)
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 2
	add s3, s4, s2
	sb s1, 0(s3)
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 1
	add s3, s4, s2
	sb s1, 0(s3)
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 0
	add s3, s4, s2
	sb s1, 0(s3)
	lw s1, -16(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, -24(s0)
	li s2, 19
	add s4, s1, s2
	li s1, 56
	li s2, 1
	sub s5, s1, s2
	mv a0, s3
	mv a1, s4
	mv a2, s5
	jal ra, strncpy
	mv s1, a0
	li s1, 0
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	li s2, 56
	li s3, 1
	sub s5, s2, s3
	add s2, s4, s5
	sb s1, 0(s2)
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
.L10_11:
	j .L10_0
.L10_18:
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
.Lfunc_end10:
	.size amb_readdir, .Lfunc_end10-amb_readdir

	.text
	.align 2
	.type amb_close, @function
amb_close:
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
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	bnez s1, .L11_0
	j .L11_1
.L11_0:
	la s1, adirs
	lw s2, -8(s0)
	li s3, 4112
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -20(s0)
	li s1, 0
	la s2, adirs
	lw s3, -8(s0)
	li s4, 4112
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -20(s0)
	mv a0, s1
	jal ra, __sys_close
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
	mv a0, s1
	jal ra, __sys_close
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
.Lfunc_end11:
	.size amb_close, .Lfunc_end11-amb_close

	.text
	.align 2
	.type amb_exists, @function
amb_exists:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 100
	neg s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s3, a0
	li s1, 0
	addi s4, s0, -272
	mv a0, s2
	mv a1, s3
	mv a2, s1
	mv a3, s4
	jal ra, do_statx
	mv s5, a0
	li s1, 0
	xor s2, s5, s1
	seqz s2, s2
	bnez s2, .L12_0
	j .L12_1
.L12_0:
	li s1, 1
	sw s1, -276(s0)
	j .L12_2
.L12_1:
	li s1, 0
	sw s1, -276(s0)
.L12_2:
	lw s1, -276(s0)
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end12:
	.size amb_exists, .Lfunc_end12-amb_exists

	.text
	.align 2
	.type amb_size, @function
amb_size:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 100
	neg s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s3, a0
	li s1, 0
	addi s4, s0, -272
	mv a0, s2
	mv a1, s3
	mv a2, s1
	mv a3, s4
	jal ra, do_statx
	mv s5, a0
	sw s5, -276(s0)
	lw s1, -276(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L13_0
	j .L13_1
.L13_0:
	lw s1, -276(s0)
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L13_1:
	addi s1, s0, -272
	li s2, 40
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv a0, s10
	mv a1, s11
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end13:
	.size amb_size, .Lfunc_end13-amb_size

	.text
	.align 2
	.type amb_isdir, @function
amb_isdir:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 100
	neg s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s3, a0
	li s1, 0
	addi s4, s0, -272
	mv a0, s2
	mv a1, s3
	mv a2, s1
	mv a3, s4
	jal ra, do_statx
	mv s5, a0
	li s1, 0
	slt s2, s5, s1
	bnez s2, .L14_0
	j .L14_1
.L14_0:
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L14_1:
	addi s1, s0, -272
	li s2, 28
	add s3, s1, s2
	lhu s1, 0(s3)
	li s2, 61440
	and s3, s1, s2
	li s1, 16384
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L14_2
	j .L14_3
.L14_2:
	li s1, 1
	sw s1, -276(s0)
	j .L14_4
.L14_3:
	li s1, 0
	sw s1, -276(s0)
.L14_4:
	lw s1, -276(s0)
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end14:
	.size amb_isdir, .Lfunc_end14-amb_isdir

	.text
	.align 2
	.type amb_stat, @function
amb_stat:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 100
	neg s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s3, a0
	li s1, 0
	addi s4, s0, -272
	mv a0, s2
	mv a1, s3
	mv a2, s1
	mv a3, s4
	jal ra, do_statx
	mv s5, a0
	sw s5, -276(s0)
	lw s1, -276(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_0
	j .L15_1
.L15_0:
	lw s1, -276(s0)
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L15_1:
	addi s1, s0, -272
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fill_stat
	mv s3, a0
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end15:
	.size amb_stat, .Lfunc_end15-amb_stat

	.text
	.align 2
	.type amb_fstat, @function
amb_fstat:
	addi sp, sp, -352
	sw ra, 348(sp)
	sw s0, 344(sp)
	addi s0, sp, 344
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
	lw s1, -12(s0)
	bnez s1, .L16_0
	j .L16_1
.L16_0:
	la s1, adirs
	lw s2, -8(s0)
	li s3, 4112
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -280(s0)
	j .L16_2
.L16_1:
	lw s1, -8(s0)
	sw s1, -280(s0)
.L16_2:
	lw s1, -280(s0)
	sw s1, -276(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -276(s0)
	la s2, __str_4
	li s3, 4096
	addi s4, s0, -272
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, do_statx
	mv s5, a0
	sw s5, -284(s0)
	lw s1, -284(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L16_3
	j .L16_4
.L16_3:
	lw s1, -284(s0)
	mv a0, s1
	lw s1, -332(s0)
	lw s2, -328(s0)
	lw s3, -324(s0)
	lw s4, -320(s0)
	lw s5, -316(s0)
	lw s6, -312(s0)
	lw s7, -308(s0)
	lw s8, -304(s0)
	lw s9, -300(s0)
	lw s10, -296(s0)
	lw s11, -292(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L16_4:
	addi s1, s0, -272
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fill_stat
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -332(s0)
	lw s2, -328(s0)
	lw s3, -324(s0)
	lw s4, -320(s0)
	lw s5, -316(s0)
	lw s6, -312(s0)
	lw s7, -308(s0)
	lw s8, -304(s0)
	lw s9, -300(s0)
	lw s10, -296(s0)
	lw s11, -292(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end16:
	.size amb_fstat, .Lfunc_end16-amb_fstat

	.text
	.align 2
	.type amb_unlink, @function
amb_unlink:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 100
	neg s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s3, a0
	li s1, 0
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, unlinkat
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
.Lfunc_end17:
	.size amb_unlink, .Lfunc_end17-amb_unlink

	.text
	.align 2
	.type amb_mkdir, @function
amb_mkdir:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 100
	neg s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s3, a0
	li s1, 511
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, mkdirat
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
.Lfunc_end18:
	.size amb_mkdir, .Lfunc_end18-amb_mkdir

	.text
	.align 2
	.type amb_rmdir, @function
amb_rmdir:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 100
	neg s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s3, a0
	li s1, 512
	mv a0, s2
	mv a1, s3
	mv a2, s1
	jal ra, unlinkat
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
.Lfunc_end19:
	.size amb_rmdir, .Lfunc_end19-amb_rmdir

	.text
	.align 2
	.type amb_rename, @function
amb_rename:
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
	sw a3, -16(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	li s1, 100
	neg s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ap
	mv s3, a0
	li s1, 100
	neg s4, s1
	lw s1, -16(s0)
	mv a0, s1
	jal ra, ap
	mv s5, a0
	li s1, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s1
	jal ra, renameat2
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
.Lfunc_end20:
	.size amb_rename, .Lfunc_end20-amb_rename

	.text
	.align 2
	.globl ambient_mount
	.type ambient_mount, @function
ambient_mount:
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
	li s2, 2
	li s3, 0
	lw s4, -8(s0)
	li s5, 512
	or s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, fs_install_mount
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
.Lfunc_end21:
	.size ambient_mount, .Lfunc_end21-ambient_mount

	.data
	.align 2
__str_4:
	.ascii "\000"
	.align 2
__str_3:
	.ascii "..\000"
	.align 2
__str_2:
	.ascii ".\000"
	.align 2
__str_1:
	.ascii ".\000"
	.align 2
__str_0:
	.ascii "ambient\000"

	.section .rodata
	.align 2
	.globl ambient_backend
ambient_backend:
	.word 0x00000002
	.word __str_0
	.word amb_open
	.word amb_read
	.word amb_write
	.word amb_lseek
	.word amb_readdir
	.word amb_close
	.word amb_exists
	.word amb_size
	.word amb_isdir
	.word amb_stat
	.word amb_fstat
	.word amb_unlink
	.word amb_rename
	.word amb_mkdir
	.word amb_rmdir

	.bss
	.align 2
	.globl adirs
adirs:
	.space 65792
