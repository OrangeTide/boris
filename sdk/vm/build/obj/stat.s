# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type from_statx, @function
from_statx:
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
	li s2, 28
	add s3, s1, s2
	lhu s1, 0(s3)
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 128
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
	li s2, 132
	add s3, s1, s2
	lw s1, 0(s3)
	mv s10, s1
	li s11, 0
	or s6, s8, s10
	or s7, s9, s11
	lw s1, -8(s0)
	li s2, 32
	add s3, s1, s2
	sw s6, 0(s3)
	sw s7, 4(s3)
	lw s1, -4(s0)
	li s2, 40
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 40
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 56
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -4(s0)
	li s2, 112
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 72
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -4(s0)
	li s2, 96
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 80
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
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
	.size from_statx, .Lfunc_end1-from_statx

	.text
	.align 2
	.type from_fs_stat, @function
from_fs_stat:
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
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s1, -8(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -8(s0)
	li s2, 40
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	li s1, 0
	lw s2, -8(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -8(s0)
	li s3, 32
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li s1, 512
	lw s2, -8(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 511
	mv s8, s1
	srai s9, s8, 31
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	li s1, 512
	mv s10, s1
	srai s11, s10, 31
	mv a0, s6
	mv a1, s7
	mv a2, s10
	mv a3, s11
	jal ra, __divdi3
	mv s8, a0
	mv s9, a1
	lw s1, -8(s0)
	li s2, 56
	add s3, s1, s2
	sw s8, 0(s3)
	sw s9, 4(s3)
	li s1, 0
	lw s2, -8(s0)
	li s3, 80
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -8(s0)
	li s2, 72
	add s3, s1, s2
	mv s8, s10
	srai s9, s8, 31
	sw s8, 0(s3)
	sw s9, 4(s3)
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	mv s10, s8
	srai s11, s10, 31
	sw s10, 0(s3)
	sw s11, 4(s3)
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
	.size from_fs_stat, .Lfunc_end2-from_fs_stat

	.text
	.align 2
	.globl fstat
	.type fstat, @function
fstat:
	addi sp, sp, -368
	sw ra, 364(sp)
	sw s0, 360(sp)
	addi s0, sp, 360
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
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	la s2, __str_0
	li s3, 4096
	li s4, 2047
	addi s5, s0, -304
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, statx
	mv s6, a0
	sw s6, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_2
	j .L3_3
.L3_2:
	lw s1, -44(s0)
	mv a0, s1
	lw s1, -348(s0)
	lw s2, -344(s0)
	lw s3, -340(s0)
	lw s4, -336(s0)
	lw s5, -332(s0)
	lw s6, -328(s0)
	lw s7, -324(s0)
	lw s8, -320(s0)
	lw s9, -316(s0)
	lw s10, -312(s0)
	lw s11, -308(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_3:
	addi s1, s0, -304
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, from_statx
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -348(s0)
	lw s2, -344(s0)
	lw s3, -340(s0)
	lw s4, -336(s0)
	lw s5, -332(s0)
	lw s6, -328(s0)
	lw s7, -324(s0)
	lw s8, -320(s0)
	lw s9, -316(s0)
	lw s10, -312(s0)
	lw s11, -308(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_1:
	lw s1, -4(s0)
	addi s2, s0, -40
	mv a0, s1
	mv a1, s2
	jal ra, fs_fstat
	mv s3, a0
	sw s3, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_4
	j .L3_5
.L3_4:
	lw s1, -44(s0)
	mv a0, s1
	lw s1, -348(s0)
	lw s2, -344(s0)
	lw s3, -340(s0)
	lw s4, -336(s0)
	lw s5, -332(s0)
	lw s6, -328(s0)
	lw s7, -324(s0)
	lw s8, -320(s0)
	lw s9, -316(s0)
	lw s10, -312(s0)
	lw s11, -308(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_5:
	addi s1, s0, -40
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, from_fs_stat
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -348(s0)
	lw s2, -344(s0)
	lw s3, -340(s0)
	lw s4, -336(s0)
	lw s5, -332(s0)
	lw s6, -328(s0)
	lw s7, -324(s0)
	lw s8, -320(s0)
	lw s9, -316(s0)
	lw s10, -312(s0)
	lw s11, -308(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size fstat, .Lfunc_end3-fstat

	.text
	.align 2
	.globl stat
	.type stat, @function
stat:
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
	lw s1, -4(s0)
	addi s2, s0, -40
	mv a0, s1
	mv a1, s2
	jal ra, fs_stat
	mv s3, a0
	sw s3, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	lw s1, -44(s0)
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
.L4_1:
	addi s1, s0, -40
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, from_fs_stat
	mv s3, a0
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
.Lfunc_end4:
	.size stat, .Lfunc_end4-stat

	.data
	.align 2
__str_0:
	.ascii "\000"
