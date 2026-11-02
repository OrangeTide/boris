# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type w_room, @function
w_room:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L1_0
	j .L1_1
.L1_0:
	la s1, __str_0
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -8(s0)
	lw s4, -4(s0)
	li s5, 8
	add s6, s4, s5
	lw s4, 0(s6)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	sw s4, 8(sp)
	jal ra, die
	mv s5, a0
	addi sp, sp, 16
.L1_1:
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
	.size w_room, .Lfunc_end1-w_room

	.text
	.align 2
	.type w_u8, @function
w_u8:
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
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_room
	mv s3, a0
	addi s1, s0, -8
	lbu s2, 0(s1)
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -4(s0)
	li s4, 4
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 1
	add s6, s1, s4
	sw s6, 0(s5)
	add s4, s3, s1
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
	.size w_u8, .Lfunc_end2-w_u8

	.text
	.align 2
	.type w_u16, @function
w_u16:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	addi s2, s0, -8
	lhu s3, 0(s2)
	li s2, 8
	sra s4, s3, s2
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
	lw s1, -4(s0)
	addi s2, s0, -8
	lhu s3, 0(s2)
	li s2, 255
	and s4, s3, s2
	mv a0, s1
	mv a1, s4
	jal ra, w_u8
	mv s2, a0
	j .L3_2
.L3_1:
	lw s1, -4(s0)
	addi s2, s0, -8
	lhu s3, 0(s2)
	li s2, 255
	and s4, s3, s2
	mv a0, s1
	mv a1, s4
	jal ra, w_u8
	mv s2, a0
	lw s1, -4(s0)
	addi s2, s0, -8
	lhu s3, 0(s2)
	li s2, 8
	sra s4, s3, s2
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
.L3_2:
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
.Lfunc_end3:
	.size w_u16, .Lfunc_end3-w_u16

	.text
	.align 2
	.type w_u32, @function
w_u32:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 24
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 16
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 8
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 255
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, w_u8
	mv s2, a0
	j .L4_2
.L4_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 255
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, w_u8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 8
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 16
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 24
	srl s4, s2, s3
	li s2, 255
	and s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
.L4_2:
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
	.size w_u32, .Lfunc_end4-w_u32

	.text
	.align 2
	.type w_u64, @function
w_u64:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L5_0
	j .L5_1
.L5_0:
	li s1, 7
	sw s1, -20(s0)
.L5_2:
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L5_3
	j .L5_4
.L5_3:
	lw s1, -4(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s2, -20(s0)
	li s3, 8
	mul s4, s2, s3
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s4, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	mv s2, s8
	li s3, 255
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, w_u8
	mv s2, a0
.L5_5:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L5_2
.L5_4:
	j .L5_6
.L5_1:
	li s1, 0
	sw s1, -20(s0)
.L5_7:
	lw s1, -20(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L5_8
	j .L5_9
.L5_8:
	lw s1, -4(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s2, -20(s0)
	li s3, 8
	mul s4, s2, s3
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s4, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	mv s2, s8
	li s3, 255
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, w_u8
	mv s2, a0
.L5_10:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L5_7
.L5_9:
.L5_6:
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
.Lfunc_end5:
	.size w_u64, .Lfunc_end5-w_u64

	.text
	.align 2
	.type w_addr, @function
w_addr:
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
	sw a3, -20(s0)
	lw s1, -20(s0)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_0
	j .L6_1
.L6_0:
	lw s1, -4(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_u64
	mv s2, a0
	j .L6_2
.L6_1:
	lw s1, -4(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	mv s2, s10
	mv a0, s1
	mv a1, s2
	jal ra, w_u32
	mv s3, a0
.L6_2:
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
.Lfunc_end6:
	.size w_addr, .Lfunc_end6-w_addr

	.text
	.align 2
	.type w_uleb, @function
w_uleb:
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
.L7_0:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 127
	mv s8, s1
	srai s9, s8, 31
	and s6, s10, s8
	and s7, s11, s9
	sw s6, -20(s0)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 7
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	sw s8, -16(s0)
	sw s9, -12(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L7_1
	j .L7_2
.L7_1:
	addi s1, s0, -20
	lbu s2, 0(s1)
	li s1, 128
	or s3, s2, s1
	sw s3, -20(s0)
.L7_2:
	lw s1, -4(s0)
	addi s2, s0, -20
	lbu s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
.L7_3:
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L7_0
	j .L7_4
.L7_4:
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
.Lfunc_end7:
	.size w_uleb, .Lfunc_end7-w_uleb

	.text
	.align 2
	.type w_sleb, @function
w_sleb:
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
	li s1, 1
	sw s1, -20(s0)
.L8_0:
	lw s1, -20(s0)
	bnez s1, .L8_1
	j .L8_2
.L8_1:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 127
	mv s8, s1
	srai s9, s8, 31
	and s6, s10, s8
	and s7, s11, s9
	sw s6, -24(s0)
	addi s1, s0, -16
	lw s10, 0(s1)
	lw s11, 4(s1)
	li s1, 7
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	sw s8, -16(s0)
	sw s9, -12(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L8_3
	j .L8_4
.L8_3:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 64
	and s3, s2, s1
	bnez s3, .L8_4
	j .L8_5
.L8_4:
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s1, 1
	neg s2, s1
	mv s8, s2
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L8_6
	j .L8_7
.L8_6:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 64
	and s3, s2, s1
	bnez s3, .L8_5
	j .L8_7
.L8_5:
	li s1, 0
	sw s1, -20(s0)
	j .L8_8
.L8_7:
	addi s1, s0, -24
	lbu s2, 0(s1)
	li s1, 128
	or s3, s2, s1
	sw s3, -24(s0)
.L8_8:
	lw s1, -4(s0)
	addi s2, s0, -24
	lbu s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, w_u8
	mv s2, a0
	j .L8_0
.L8_2:
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
.Lfunc_end8:
	.size w_sleb, .Lfunc_end8-w_sleb

	.text
	.align 2
	.type w_str, @function
w_str:
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
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, w_room
	mv s3, a0
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
.Lfunc_end9:
	.size w_str, .Lfunc_end9-w_str

	.text
	.align 2
	.type w_patch_u32, @function
w_patch_u32:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L10_0
	j .L10_1
.L10_0:
	lw s1, -12(s0)
	li s2, 24
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -8(s0)
	li s4, 0
	add s5, s1, s4
	add s1, s3, s5
	sb s2, 0(s1)
	lw s1, -12(s0)
	li s2, 16
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -8(s0)
	li s4, 1
	add s5, s1, s4
	add s1, s3, s5
	sb s2, 0(s1)
	lw s1, -12(s0)
	li s2, 8
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -8(s0)
	li s4, 2
	add s5, s1, s4
	add s1, s3, s5
	sb s2, 0(s1)
	lw s1, -12(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s4, 3
	add s5, s1, s4
	add s1, s2, s5
	sb s3, 0(s1)
	j .L10_2
.L10_1:
	lw s1, -12(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -8(s0)
	li s4, 0
	add s5, s1, s4
	add s1, s2, s5
	sb s3, 0(s1)
	lw s1, -12(s0)
	li s2, 8
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -8(s0)
	li s4, 1
	add s5, s1, s4
	add s1, s3, s5
	sb s2, 0(s1)
	lw s1, -12(s0)
	li s2, 16
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -8(s0)
	li s4, 2
	add s5, s1, s4
	add s1, s3, s5
	sb s2, 0(s1)
	lw s1, -12(s0)
	li s2, 24
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -8(s0)
	li s4, 3
	add s5, s1, s4
	add s1, s3, s5
	sb s2, 0(s1)
.L10_2:
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
.Lfunc_end10:
	.size w_patch_u32, .Lfunc_end10-w_patch_u32

	.text
	.align 2
	.globl dw_line_build
	.type dw_line_build, @function
dw_line_build:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	sw a6, -28(s0)
	sw a7, -32(s0)
	li s1, 0
	sw s1, -68(s0)
	li s1, 0
	sw s1, -72(s0)
.L11_0:
	lw s1, -72(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L11_1
	j .L11_2
.L11_1:
	addi s1, s0, -68
	lw s2, 0(s1)
	lw s1, -8(s0)
	lw s3, -72(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	mv a0, s1
	jal ra, strlen
	mv s3, a0
	li s1, 4
	add s4, s3, s1
	add s1, s2, s4
	sw s1, -68(s0)
.L11_3:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -72(s0)
	j .L11_0
.L11_2:
	li s1, 64
	lw s2, -68(s0)
	add s3, s1, s2
	lw s1, -20(s0)
	li s2, 28
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 16
	add s3, s1, s2
	lw s1, 12(s0)
	add s2, s3, s1
	sw s2, -84(s0)
	lw s1, -4(s0)
	lw s2, -84(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arena_alloc
	mv s3, a0
	addi s1, s0, -48
	sw s3, 0(s1)
	li s1, 0
	addi s2, s0, -48
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -84(s0)
	addi s2, s0, -48
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, 8(s0)
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u32
	mv s3, a0
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -56(s0)
	addi s1, s0, -48
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, w_u16
	mv s3, a0
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -60(s0)
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u32
	mv s3, a0
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -64(s0)
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 5
	neg s3, s2
	li s2, 255
	and s4, s3, s2
	mv a0, s1
	mv a1, s4
	jal ra, w_u8
	mv s2, a0
	addi s1, s0, -48
	li s2, 14
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 13
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	li s1, 0
	sw s1, -72(s0)
.L11_4:
	lw s1, -72(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L11_5
	j .L11_6
.L11_5:
	addi s1, s0, -48
	lw s2, -8(s0)
	lw s3, -72(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, w_str
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -48
	li s2, 0
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -48
	li s2, 0
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
.L11_7:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -72(s0)
	j .L11_4
.L11_6:
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	lw s2, -60(s0)
	addi s3, s0, -48
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -64(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, w_patch_u32
	mv s3, a0
	li s1, 1
	sw s1, -76(s0)
	li s1, 0
	sw s1, -80(s0)
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	lw s3, 12(s0)
	add s4, s2, s3
	mv s10, s4
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -48
	li s2, 2
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	lw s1, -32(s0)
	bnez s1, .L11_8
	j .L11_9
.L11_8:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -32(s0)
	sw s1, 0(s2)
.L11_9:
	addi s1, s0, -48
	lw s2, -16(s0)
	li s3, 0
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv s10, s2
	li s11, 0
	lw s2, 12(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	jal ra, w_addr
	mv s3, a0
	li s1, 0
	sw s1, -72(s0)
.L11_10:
	lw s1, -72(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L11_11
	j .L11_12
.L11_11:
	lw s1, -16(s0)
	lw s2, -72(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L11_13
	j .L11_14
.L11_13:
	lw s1, -16(s0)
	lw s2, -72(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -92(s0)
	j .L11_15
.L11_14:
	li s1, 1
	sw s1, -92(s0)
.L11_15:
	lw s1, -92(s0)
	sw s1, -88(s0)
	lw s1, -72(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L11_16
	j .L11_17
.L11_16:
	addi s1, s0, -48
	li s2, 2
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi t0, s0, -48
	sw t0, -100(s0)
	lw s2, -16(s0)
	lw s3, -72(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -16(s0)
	lw s4, -72(s0)
	li s5, 1
	sub s1, s4, s5
	li s4, 16
	mul s5, s1, s4
	add s1, s3, s5
	lw s3, 0(s1)
	sub s1, s2, s3
	mv s10, s1
	li s11, 0
	lw t0, -100(s0)
	mv a0, t0
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s1, a0
.L11_17:
	lw s1, -88(s0)
	lw s2, -76(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L11_18
	j .L11_19
.L11_18:
	addi s1, s0, -48
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	lw s2, -88(s0)
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	lw s1, -88(s0)
	sw s1, -76(s0)
.L11_19:
	lw s1, -16(s0)
	lw s2, -72(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -80(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L11_20
	j .L11_21
.L11_20:
	addi s1, s0, -48
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	lw s2, -16(s0)
	lw s3, -72(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	lw s2, 0(s4)
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	lw s1, -16(s0)
	lw s2, -72(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 12
	add s3, s2, s1
	lw s1, 0(s3)
	sw s1, -80(s0)
.L11_21:
	addi s1, s0, -48
	li s2, 3
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	lw s2, -16(s0)
	lw s3, -72(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	mv s10, s2
	srai s11, s10, 31
	lw s2, -72(s0)
	bnez s2, .L11_22
	j .L11_23
.L11_22:
	lw s2, -16(s0)
	lw s3, -72(s0)
	li s4, 1
	sub s5, s3, s4
	li s3, 16
	mul s4, s5, s3
	add s3, s2, s4
	li s2, 4
	add s4, s3, s2
	lw s2, 0(s4)
	sw s2, -96(s0)
	j .L11_24
.L11_23:
	li s2, 1
	sw s2, -96(s0)
.L11_24:
	lw s2, -96(s0)
	mv s8, s2
	srai s9, s8, 31
	sltu t0, s10, s8
	sub s6, s10, s8
	sub s7, s11, t0
	sub s7, s7, s9
	mv a0, s1
	mv a1, s6
	mv a2, s7
	jal ra, w_sleb
	mv s2, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
.L11_25:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -72(s0)
	j .L11_10
.L11_12:
	addi s1, s0, -48
	li s2, 2
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi t0, s0, -48
	sw t0, -104(s0)
	lw s2, -24(s0)
	lw s3, -16(s0)
	lw s4, -20(s0)
	li s5, 1
	sub s1, s4, s5
	li s4, 16
	mul s5, s1, s4
	add s1, s3, s5
	lw s3, 0(s1)
	sub s1, s2, s3
	mv s10, s1
	li s11, 0
	lw t0, -104(s0)
	mv a0, t0
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s1, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	li s2, 1
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -48
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -48
	lw s2, -52(s0)
	addi s3, s0, -48
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -56(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, w_patch_u32
	mv s3, a0
	addi s1, s0, -48
	lw s2, 0(s1)
	lw s1, -28(s0)
	sw s2, 0(s1)
	addi s1, s0, -48
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
.Lfunc_end11:
	.size dw_line_build, .Lfunc_end11-dw_line_build

	.text
	.align 2
	.globl dw_abbrev_build
	.type dw_abbrev_build, @function
dw_abbrev_build:
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
	li s2, 64
	mv a0, s1
	mv a1, s2
	jal ra, arena_alloc
	mv s3, a0
	addi s1, s0, -24
	sw s3, 0(s1)
	li s1, 0
	addi s2, s0, -24
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 64
	addi s2, s0, -24
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	addi s2, s0, -24
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -24
	li s2, 1
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 17
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u8
	mv s3, a0
	addi s1, s0, -24
	li s2, 37
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 8
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 19
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 5
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 3
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 8
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 27
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 8
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 17
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 1
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 18
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 1
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 16
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 23
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 0
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 0
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	li s2, 0
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -24
	lw s2, 0(s1)
	lw s1, -8(s0)
	sw s2, 0(s1)
	addi s1, s0, -24
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
.Lfunc_end12:
	.size dw_abbrev_build, .Lfunc_end12-dw_abbrev_build

	.text
	.align 2
	.globl dw_info_build
	.type dw_info_build, @function
dw_info_build:
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
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	sw a6, -28(s0)
	sw a7, -32(s0)
	li s1, 32
	lw s2, -8(s0)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	add s2, s1, s3
	li s1, 1
	add s3, s2, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	add s1, s3, s2
	li s2, 1
	add s3, s1, s2
	lw s1, -16(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	add s1, s3, s2
	li s2, 1
	add s3, s1, s2
	li s1, 16
	add s2, s3, s1
	li s1, 2
	lw s3, 20(s0)
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -60(s0)
	lw s1, -4(s0)
	lw s2, -60(s0)
	mv a0, s1
	mv a1, s2
	jal ra, arena_alloc
	mv s3, a0
	addi s1, s0, -48
	sw s3, 0(s1)
	li s1, 0
	addi s2, s0, -48
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -60(s0)
	addi s2, s0, -48
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, 16(s0)
	addi s2, s0, -48
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u32
	mv s3, a0
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -56(s0)
	addi s1, s0, -48
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, w_u16
	mv s3, a0
	addi s1, s0, -48
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, w_u32
	mv s3, a0
	addi s1, s0, -48
	lw s2, 20(s0)
	li s3, 255
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, w_u8
	mv s2, a0
	addi s1, s0, -48
	li s2, 1
	mv s10, s2
	srai s11, s10, 31
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, w_uleb
	mv s2, a0
	addi s1, s0, -48
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, w_str
	mv s3, a0
	addi s1, s0, -48
	li s2, 12
	mv a0, s1
	mv a1, s2
	jal ra, w_u16
	mv s3, a0
	addi s1, s0, -48
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, w_str
	mv s3, a0
	addi s1, s0, -48
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, w_str
	mv s3, a0
	lw s1, 8(s0)
	bnez s1, .L13_0
	j .L13_1
.L13_0:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 8(s0)
	sw s1, 0(s2)
.L13_1:
	addi s1, s0, -48
	lw s2, -20(s0)
	mv s10, s2
	li s11, 0
	lw s2, 20(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	jal ra, w_addr
	mv s3, a0
	lw s1, 12(s0)
	bnez s1, .L13_2
	j .L13_3
.L13_2:
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 12(s0)
	sw s1, 0(s2)
.L13_3:
	addi s1, s0, -48
	lw s2, -24(s0)
	mv s10, s2
	li s11, 0
	lw s2, 20(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	jal ra, w_addr
	mv s3, a0
	addi s1, s0, -48
	lw s2, -28(s0)
	mv a0, s1
	mv a1, s2
	jal ra, w_u32
	mv s3, a0
	addi s1, s0, -48
	lw s2, -52(s0)
	addi s3, s0, -48
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -56(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, w_patch_u32
	mv s3, a0
	addi s1, s0, -48
	lw s2, 0(s1)
	lw s1, -32(s0)
	sw s2, 0(s1)
	addi s1, s0, -48
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.Lfunc_end13:
	.size dw_info_build, .Lfunc_end13-dw_info_build

	.data
	.align 2
__str_0:
	.ascii "dwarf: writer overflow (%zu + %zu > %zu)\000"
