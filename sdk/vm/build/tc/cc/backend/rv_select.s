# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type t_is_i64, @function
t_is_i64:
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
	la s1, g_is_i64
	lw s2, 0(s1)
	bnez s2, .L1_0
	j .L1_1
.L1_0:
	lw s1, -4(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L1_2
	j .L1_1
.L1_2:
	la s1, g_is_i64
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, 0(s1)
	bnez s2, .L1_3
	j .L1_1
.L1_3:
	li s1, 1
	j .L1_4
.L1_1:
	li s1, 0
.L1_4:
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
	.size t_is_i64, .Lfunc_end1-t_is_i64

	.text
	.align 2
	.type src_is_f32, @function
src_is_f32:
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
	la s1, g_f32
	lw s2, 0(s1)
	bnez s2, .L2_0
	j .L2_1
.L2_0:
	lw s1, -4(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L2_2
	j .L2_1
.L2_2:
	la s1, g_f32
	lw s2, 0(s1)
	lw s1, -4(s0)
	add s3, s2, s1
	lbu s1, 0(s3)
	bnez s1, .L2_3
	j .L2_1
.L2_3:
	li s1, 1
	j .L2_4
.L2_1:
	li s1, 0
.L2_4:
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
	.size src_is_f32, .Lfunc_end2-src_is_f32

	.text
	.align 2
	.type rv_abi_assign, @function
rv_abi_assign:
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
	li s1, 0
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	li s1, 0
	sw s1, -28(s0)
.L3_0:
	lw s1, -28(s0)
	lw s2, -8(s0)
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -32(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_3
	j .L3_4
.L3_3:
	lw s1, -28(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_5
	j .L3_4
.L3_5:
	li s1, 8
	sw s1, -20(s0)
.L3_4:
	lw s1, -32(s0)
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1
	neg s2, s1
	lw s1, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	sw s2, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 0
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -32(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_6
	j .L3_7
.L3_6:
	lw s1, -20(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L3_8
	j .L3_9
.L3_8:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	lw s1, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s1, s5
	li s1, 4
	add s4, s3, s1
	sw s2, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	j .L3_10
.L3_9:
	lw s1, -24(s0)
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	sw s3, -24(s0)
.L3_10:
	j .L3_11
.L3_7:
	lw s1, -32(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_12
	j .L3_13
.L3_12:
	lw s1, -20(s0)
	li s2, 1
	add s3, s1, s2
	li s1, 8
	slt s2, s3, s1
	bnez s2, .L3_14
	j .L3_15
.L3_14:
	lw s1, -20(s0)
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 2
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 2
	add s3, s2, s1
	sw s3, -20(s0)
	j .L3_16
.L3_15:
	lw s1, -20(s0)
	li s2, 8
	slt s3, s1, s2
	bnez s3, .L3_17
	j .L3_18
.L3_17:
	lw s1, -20(s0)
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 8
	sw s1, -20(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	sw s3, -24(s0)
	j .L3_19
.L3_18:
	lw s1, -24(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 7
	not s2, s1
	and s1, s3, s2
	sw s1, -24(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 8
	add s3, s2, s1
	sw s3, -24(s0)
.L3_19:
.L3_16:
	j .L3_20
.L3_13:
	li s1, 8
	sw s1, -20(s0)
	lw s1, -24(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 7
	not s2, s1
	and s1, s3, s2
	sw s1, -24(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	lw s3, -28(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 12
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -24
	lw s2, 0(s1)
	lw s1, -32(s0)
	li s3, 4
	mul s4, s1, s3
	add s1, s2, s4
	sw s1, -24(s0)
.L3_20:
.L3_11:
.L3_21:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L3_0
.L3_2:
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
.Lfunc_end3:
	.size rv_abi_assign, .Lfunc_end3-rv_abi_assign

	.text
	.align 2
	.type rv_param_words, @function
rv_param_words:
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
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 3
	add s3, s1, s2
	li s1, 3
	not s2, s1
	and s1, s3, s2
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_0
	j .L4_1
.L4_0:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	bnez s1, .L4_2
	j .L4_1
.L4_2:
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
.L4_1:
	lw s1, -12(s0)
	li s2, 4
	div s3, s1, s2
	li s1, 1
	slt s2, s3, s1
	bnez s2, .L4_3
	j .L4_4
.L4_3:
	li s1, 1
	sw s1, -16(s0)
	j .L4_5
.L4_4:
	lw s1, -12(s0)
	li s2, 4
	div s3, s1, s2
	sw s3, -16(s0)
.L4_5:
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
.Lfunc_end4:
	.size rv_param_words, .Lfunc_end4-rv_param_words

	.text
	.align 2
	.type rv_param, @function
rv_param:
	addi sp, sp, -1376
	sw ra, 1372(sp)
	sw s0, 1368(sp)
	addi s0, sp, 1368
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
	addi s1, s0, -1296
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
	li s2, 0
	sw s2, 0(s1)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1300(s0)
	li s1, 0
	sw s1, -1308(s0)
	lw s1, -1300(s0)
	li s2, 64
	slt s3, s2, s1
	bnez s3, .L5_0
	j .L5_1
.L5_0:
	li s1, 64
	sw s1, -1300(s0)
.L5_1:
	li s1, 0
	sw s1, -1304(s0)
.L5_2:
	lw s1, -1304(s0)
	lw s2, -1300(s0)
	slt s3, s1, s2
	bnez s3, .L5_3
	j .L5_4
.L5_3:
	lw s1, -4(s0)
	lw s2, -1304(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_param_words
	mv s3, a0
	addi s1, s0, -1296
	lw s2, -1304(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L5_5:
	addi s1, s0, -1304
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1304(s0)
	j .L5_2
.L5_4:
	addi s1, s0, -1296
	lw s2, -1300(s0)
	addi s3, s0, -1040
	li s4, 1
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_abi_assign
	mv s4, a0
	li s1, 0
	sw s1, -1304(s0)
.L5_6:
	lw s1, -1304(s0)
	lw s2, -1300(s0)
	slt s3, s1, s2
	bnez s3, .L5_7
	j .L5_8
.L5_7:
	addi s1, s0, -1296
	lw s2, -1304(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 4
	mul s3, s1, s2
	sw s3, -1312(s0)
	addi s1, s0, -1040
	lw s2, -1304(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_9
	j .L5_10
.L5_9:
	j .L5_11
.L5_10:
	lw s1, -1312(s0)
	li s2, 8
	rem s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L5_12
	j .L5_13
.L5_12:
	lw s1, -1308(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 7
	not s2, s1
	and s1, s3, s2
	sw s1, -1308(s0)
.L5_13:
	addi s1, s0, -1308
	lw s2, 0(s1)
	lw s1, -1312(s0)
	add s3, s2, s1
	sw s3, -1308(s0)
	lw s1, -1304(s0)
	lw s2, -8(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L5_14
	j .L5_15
.L5_14:
	addi s1, s0, -1040
	lw s2, -1304(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, -12(s0)
	lw s3, 0(s2)
	sw s3, 0(s1)
	li s3, 4
	add s4, s2, s3
	lw s3, 0(s4)
	li s4, 4
	add s5, s1, s4
	sw s3, 0(s5)
	li s3, 8
	add s4, s2, s3
	lw s3, 0(s4)
	li s4, 8
	add s5, s1, s4
	sw s3, 0(s5)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -1308(s0)
	neg s2, s1
	lw s1, -16(s0)
	sw s2, 0(s1)
	lw s1, -1364(s0)
	lw s2, -1360(s0)
	lw s3, -1356(s0)
	lw s4, -1352(s0)
	lw s5, -1348(s0)
	lw s6, -1344(s0)
	lw s7, -1340(s0)
	lw s8, -1336(s0)
	lw s9, -1332(s0)
	lw s10, -1328(s0)
	lw s11, -1324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L5_15:
.L5_11:
	addi s1, s0, -1304
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1304(s0)
	j .L5_6
.L5_8:
	addi s1, s0, -1040
	lw s2, -8(s0)
	lw s3, -1300(s0)
	slt s4, s2, s3
	bnez s4, .L5_16
	j .L5_17
.L5_16:
	lw s2, -8(s0)
	sw s2, -1316(s0)
	j .L5_18
.L5_17:
	li s2, 0
	sw s2, -1316(s0)
.L5_18:
	lw s2, -1316(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, -12(s0)
	lw s3, 0(s2)
	sw s3, 0(s1)
	li s3, 4
	add s4, s2, s3
	lw s3, 0(s4)
	li s4, 4
	add s5, s1, s4
	sw s3, 0(s5)
	li s3, 8
	add s4, s2, s3
	lw s3, 0(s4)
	li s4, 8
	add s5, s1, s4
	sw s3, 0(s5)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	sw s1, 0(s2)
	li s1, 0
	mv a0, s1
	lw s1, -1364(s0)
	lw s2, -1360(s0)
	lw s3, -1356(s0)
	lw s4, -1352(s0)
	lw s5, -1348(s0)
	lw s6, -1344(s0)
	lw s7, -1340(s0)
	lw s8, -1336(s0)
	lw s9, -1332(s0)
	lw s10, -1328(s0)
	lw s11, -1324(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end5:
	.size rv_param, .Lfunc_end5-rv_param

	.text
	.align 2
	.type param_home, @function
param_home:
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
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -28(s0)
.L6_0:
	lw s1, -28(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L6_1
	j .L6_2
.L6_1:
	lw s1, -4(s0)
	lw s2, -28(s0)
	addi s3, s0, -24
	addi s4, s0, -36
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_param
	mv s5, a0
	addi s1, s0, -24
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_3
	j .L6_4
.L6_3:
	j .L6_5
.L6_4:
	lw s1, -36(s0)
	neg s2, s1
	lw s1, -32(s0)
	slt s3, s1, s2
	bnez s3, .L6_6
	j .L6_7
.L6_6:
	lw s1, -36(s0)
	neg s2, s1
	sw s2, -32(s0)
.L6_7:
.L6_5:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L6_0
.L6_2:
	lw s1, -32(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 7
	not s2, s1
	and s1, s3, s2
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
.Lfunc_end6:
	.size param_home, .Lfunc_end6-param_home

	.text
	.align 2
	.type frame_reserve, @function
frame_reserve:
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
	jal ra, param_home
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
.Lfunc_end7:
	.size frame_reserve, .Lfunc_end7-frame_reserve

	.text
	.align 2
	.type slot_bytes, @function
slot_bytes:
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
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 3
	add s3, s1, s2
	li s1, 3
	not s2, s1
	and s1, s3, s2
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
	.size slot_bytes, .Lfunc_end8-slot_bytes

	.text
	.align 2
	.type locals_size, @function
locals_size:
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
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L9_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L9_1
	j .L9_2
.L9_1:
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, slot_bytes
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	li s2, 8
	rem s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L9_3
	j .L9_4
.L9_3:
	lw s1, -16(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 7
	not s2, s1
	and s1, s3, s2
	sw s1, -16(s0)
.L9_4:
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -20(s0)
	add s3, s2, s1
	sw s3, -16(s0)
.L9_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L9_0
.L9_2:
	lw s1, -16(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 7
	not s2, s1
	and s1, s3, s2
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
	.size locals_size, .Lfunc_end9-locals_size

	.text
	.align 2
	.type slot_offset, @function
slot_offset:
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
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L10_0
	j .L10_1
.L10_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	addi s3, s0, -32
	addi s4, s0, -36
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_param
	mv s5, a0
	addi s1, s0, -32
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L10_2
	j .L10_3
.L10_2:
	lw s1, -36(s0)
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
.L10_3:
	li s1, 8
	addi s2, s0, -32
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	mv a0, s3
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
.L10_1:
	li s1, 0
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L10_4:
	lw s1, -12(s0)
	lw s2, -8(s0)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L10_5
	j .L10_6
.L10_5:
	lw s1, -4(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, slot_bytes
	mv s3, a0
	sw s3, -40(s0)
	lw s1, -40(s0)
	li s2, 8
	rem s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L10_7
	j .L10_8
.L10_7:
	lw s1, -16(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 7
	not s2, s1
	and s1, s3, s2
	sw s1, -16(s0)
.L10_8:
	addi s1, s0, -16
	lw s2, 0(s1)
	lw s1, -40(s0)
	add s3, s2, s1
	sw s3, -16(s0)
.L10_9:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L10_4
.L10_6:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, frame_reserve
	mv s2, a0
	neg s1, s2
	lw s2, -16(s0)
	sub s3, s1, s2
	mv a0, s3
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
	.size slot_offset, .Lfunc_end10-slot_offset

	.text
	.align 2
	.type frame_size, @function
frame_size:
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
	jal ra, frame_reserve
	mv s2, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, locals_size
	mv s3, a0
	add s1, s2, s3
	lw s2, -4(s0)
	li s3, 76
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, -4(s0)
	li s3, 72
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	mul s4, s1, s3
	add s1, s2, s4
	lw s2, -4(s0)
	li s3, 80
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 8
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
.Lfunc_end11:
	.size frame_size, .Lfunc_end11-frame_size

	.text
	.align 2
	.type fspill_byte_offset, @function
fspill_byte_offset:
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
	mv a0, s1
	jal ra, frame_reserve
	mv s2, a0
	neg s1, s2
	lw s2, -4(s0)
	mv a0, s2
	jal ra, locals_size
	mv s3, a0
	sub s2, s1, s3
	lw s1, -4(s0)
	li s3, 88
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -8(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	li s3, 8
	add s4, s1, s3
	sub s1, s2, s4
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
	.size fspill_byte_offset, .Lfunc_end12-fspill_byte_offset

	.text
	.align 2
	.type spill_byte_offset, @function
spill_byte_offset:
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
	mv a0, s1
	jal ra, frame_reserve
	mv s2, a0
	neg s1, s2
	lw s2, -4(s0)
	mv a0, s2
	jal ra, locals_size
	mv s3, a0
	sub s2, s1, s3
	lw s1, -4(s0)
	li s3, 76
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 8
	mul s4, s1, s3
	sub s1, s2, s4
	lw s2, -4(s0)
	li s3, 88
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -8(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 4
	add s4, s2, s3
	sub s2, s1, s4
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
.Lfunc_end13:
	.size spill_byte_offset, .Lfunc_end13-spill_byte_offset

	.text
	.align 2
	.type i64spill_byte_offset, @function
i64spill_byte_offset:
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
	mv a0, s1
	jal ra, frame_reserve
	mv s2, a0
	neg s1, s2
	lw s2, -4(s0)
	mv a0, s2
	jal ra, locals_size
	mv s3, a0
	sub s2, s1, s3
	lw s1, -4(s0)
	li s3, 76
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 8
	mul s4, s1, s3
	sub s1, s2, s4
	lw s2, -4(s0)
	li s3, 72
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	sub s2, s1, s4
	lw s1, -4(s0)
	li s3, 88
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -8(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	li s3, 8
	add s4, s1, s3
	sub s1, s2, s4
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
.Lfunc_end14:
	.size i64spill_byte_offset, .Lfunc_end14-i64spill_byte_offset

	.text
	.align 2
	.type frs_w, @function
frs_w:
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
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L15_0
	j .L15_1
.L15_0:
	la s1, freg
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.L15_1:
	lw s1, -20(s0)
	bnez s1, .L15_2
	j .L15_3
.L15_2:
	lw s1, -4(s0)
	la s2, freg
	lw s3, -16(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, fspill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_flw
	mv s4, a0
	j .L15_4
.L15_3:
	lw s1, -4(s0)
	la s2, freg
	lw s3, -16(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, fspill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_fld
	mv s4, a0
.L15_4:
	la s1, freg
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.Lfunc_end15:
	.size frs_w, .Lfunc_end15-frs_w

	.text
	.align 2
	.type frd_w, @function
frd_w:
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
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L16_0
	j .L16_1
.L16_0:
	la s1, freg
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -24(s0)
	j .L16_2
.L16_1:
	la s1, freg
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -24(s0)
.L16_2:
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
.Lfunc_end16:
	.size frd_w, .Lfunc_end16-frd_w

	.text
	.align 2
	.type fwd_f, @function
fwd_f:
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
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L17_0
	j .L17_1
.L17_0:
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
.L17_1:
	lw s1, -20(s0)
	bnez s1, .L17_2
	j .L17_3
.L17_2:
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, fspill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_fsw
	mv s4, a0
	j .L17_4
.L17_3:
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, fspill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_fsd
	mv s4, a0
.L17_4:
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
.Lfunc_end17:
	.size fwd_f, .Lfunc_end17-fwd_f

	.text
	.align 2
	.type rs_i32, @function
rs_i32:
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
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L18_0
	j .L18_1
.L18_0:
	la s1, reg
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.L18_1:
	lw s1, -4(s0)
	la s2, reg
	lw s3, -16(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, spill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_lw
	mv s4, a0
	la s1, reg
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.Lfunc_end18:
	.size rs_i32, .Lfunc_end18-rs_i32

	.text
	.align 2
	.type rs, @function
rs:
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
	lw s1, -12(s0)
	mv a0, s1
	jal ra, t_is_i64
	mv s2, a0
	bnez s2, .L19_0
	j .L19_1
.L19_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	mv a0, s5
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
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs_i32
	mv s5, a0
	mv a0, s5
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
	.size rs, .Lfunc_end19-rs

	.text
	.align 2
	.type rd, @function
rd:
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
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L20_0
	j .L20_1
.L20_0:
	la s1, reg
	lw s2, -20(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -24(s0)
	j .L20_2
.L20_1:
	la s1, reg
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -24(s0)
.L20_2:
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
.Lfunc_end20:
	.size rd, .Lfunc_end20-rd

	.text
	.align 2
	.type wd, @function
wd:
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
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L21_0
	j .L21_1
.L21_0:
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
.L21_1:
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, spill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
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
.Lfunc_end21:
	.size wd, .Lfunc_end21-wd

	.text
	.align 2
	.type i64_lo_idx, @function
i64_lo_idx:
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
	li s1, 11
	li s2, 2
	lw s3, -4(s0)
	mul s4, s2, s3
	sub s2, s1, s4
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
.Lfunc_end22:
	.size i64_lo_idx, .Lfunc_end22-i64_lo_idx

	.text
	.align 2
	.type i64_hi_idx, @function
i64_hi_idx:
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
	li s1, 12
	li s2, 2
	lw s3, -4(s0)
	mul s4, s2, s3
	sub s2, s1, s4
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
.Lfunc_end23:
	.size i64_hi_idx, .Lfunc_end23-i64_hi_idx

	.text
	.align 2
	.type i64_rs_lo, @function
i64_rs_lo:
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
	lw s1, -12(s0)
	mv a0, s1
	jal ra, t_is_i64
	mv s2, a0
	bnez s2, .L24_0
	j .L24_1
.L24_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs_i32
	mv s5, a0
	mv a0, s5
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
.L24_0:
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L24_2
	j .L24_3
.L24_2:
	la s1, reg
	lw s2, -20(s0)
	mv a0, s2
	jal ra, i64_lo_idx
	mv s3, a0
	li s2, 4
	mul s4, s3, s2
	add s2, s1, s4
	lw s1, 0(s2)
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
.L24_3:
	lw s1, -4(s0)
	la s2, reg
	lw s3, -16(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, i64spill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_lw
	mv s4, a0
	la s1, reg
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.Lfunc_end24:
	.size i64_rs_lo, .Lfunc_end24-i64_rs_lo

	.text
	.align 2
	.type i64_rs_hi, @function
i64_rs_hi:
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
	lw s1, -12(s0)
	mv a0, s1
	jal ra, t_is_i64
	mv s2, a0
	bnez s2, .L25_0
	j .L25_1
.L25_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs_i32
	mv s5, a0
	sw s5, -24(s0)
	lw s1, -4(s0)
	la s2, reg
	lw s3, -16(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -24(s0)
	li s4, 31
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_srai
	mv s5, a0
	la s1, reg
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.L25_0:
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L25_2
	j .L25_3
.L25_2:
	la s1, reg
	lw s2, -20(s0)
	mv a0, s2
	jal ra, i64_hi_idx
	mv s3, a0
	li s2, 4
	mul s4, s3, s2
	add s2, s1, s4
	lw s1, 0(s2)
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
.L25_3:
	lw s1, -4(s0)
	la s2, reg
	lw s3, -16(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, i64spill_byte_offset
	mv s6, a0
	li s4, 4
	add s5, s6, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_lw
	mv s4, a0
	la s1, reg
	lw s2, -16(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.Lfunc_end25:
	.size i64_rs_hi, .Lfunc_end25-i64_rs_hi

	.text
	.align 2
	.type i64_rd_lo, @function
i64_rd_lo:
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
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L26_0
	j .L26_1
.L26_0:
	la s1, reg
	lw s2, -20(s0)
	mv a0, s2
	jal ra, i64_lo_idx
	mv s3, a0
	li s2, 4
	mul s4, s3, s2
	add s2, s1, s4
	lw s1, 0(s2)
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
.L26_1:
	la s1, reg
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.Lfunc_end26:
	.size i64_rd_lo, .Lfunc_end26-i64_rd_lo

	.text
	.align 2
	.type i64_rd_hi, @function
i64_rd_hi:
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
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L27_0
	j .L27_1
.L27_0:
	la s1, reg
	lw s2, -20(s0)
	mv a0, s2
	jal ra, i64_hi_idx
	mv s3, a0
	li s2, 4
	mul s4, s3, s2
	add s2, s1, s4
	lw s1, 0(s2)
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
	la s1, reg
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
	.size i64_rd_hi, .Lfunc_end27-i64_rd_hi

	.text
	.align 2
	.type i64_wd_lo, @function
i64_wd_lo:
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
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L28_0
	j .L28_1
.L28_0:
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
.L28_1:
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, i64spill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
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
.Lfunc_end28:
	.size i64_wd_lo, .Lfunc_end28-i64_wd_lo

	.text
	.align 2
	.type i64_wd_hi, @function
i64_wd_hi:
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
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L29_0
	j .L29_1
.L29_0:
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
.L29_1:
	lw s1, -4(s0)
	lw s2, -16(s0)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	mv a0, s4
	mv a1, s5
	jal ra, i64spill_byte_offset
	mv s6, a0
	li s4, 4
	add s5, s6, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_sw
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
.Lfunc_end29:
	.size i64_wd_hi, .Lfunc_end29-i64_wd_hi

	.text
	.align 2
	.type emit_binop, @function
emit_binop:
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
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -20(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -24(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -28(s0)
	lw s4, -20(s0)
	lw s5, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
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
.Lfunc_end30:
	.size emit_binop, .Lfunc_end30-emit_binop

	.text
	.align 2
	.type emit_div, @function
emit_div:
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
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -28(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -32(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -36(s0)
	la s1, g_trap_policy
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L31_0
	j .L31_1
.L31_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rv_mc_new_label
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -40(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_bnez
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_32
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -40(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_label
	mv s3, a0
	lw s1, -20(s0)
	bnez s1, .L31_2
	j .L31_3
.L31_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rv_mc_new_label
	mv s2, a0
	sw s2, -44(s0)
	lw s1, -4(s0)
	li s2, 7
	li s3, 1
	neg s4, s3
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, rv_mc_li
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -32(s0)
	li s3, 7
	lw s4, -44(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_bne
	mv s5, a0
	lw s1, -4(s0)
	li s2, 7
	li s3, 2147483647
	neg s4, s3
	li s3, 1
	sub s5, s4, s3
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, rv_mc_li
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 7
	lw s4, -44(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_bne
	mv s5, a0
	lw s1, -4(s0)
	la s2, __str_33
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_label
	mv s3, a0
.L31_3:
.L31_1:
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -36(s0)
	lw s4, -28(s0)
	lw s5, -32(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
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
.Lfunc_end31:
	.size emit_div, .Lfunc_end31-emit_div

	.text
	.align 2
	.type emit_overflow, @function
emit_overflow:
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
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -20(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -24(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 132
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L32_0
	j .L32_1
.L32_0:
	lw s1, -4(s0)
	li s2, 7
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_mulh
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_mul
	mv s5, a0
	lw s1, -4(s0)
	li s2, 31
	lw s3, -28(s0)
	li s4, 31
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_srai
	mv s5, a0
	lw s1, -4(s0)
	li s2, 7
	li s3, 7
	li s4, 31
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	li s1, 7
	sw s1, -32(s0)
	j .L32_2
.L32_1:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 130
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L32_3
	j .L32_4
.L32_3:
	lw s1, -4(s0)
	li s2, 7
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_add
	mv s5, a0
	lw s1, -4(s0)
	li s2, 31
	lw s3, -20(s0)
	li s4, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	li s2, 7
	lw s3, -24(s0)
	li s4, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	li s2, 31
	li s3, 31
	li s4, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_and
	mv s5, a0
	lw s1, -4(s0)
	li s2, 31
	li s3, 31
	li s4, 31
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_srai
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_add
	mv s5, a0
	li s1, 31
	sw s1, -32(s0)
	j .L32_5
.L32_4:
	lw s1, -4(s0)
	li s2, 7
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sub
	mv s5, a0
	lw s1, -4(s0)
	li s2, 31
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	li s2, 7
	lw s3, -20(s0)
	li s4, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	li s2, 31
	li s3, 31
	li s4, 7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_and
	mv s5, a0
	lw s1, -4(s0)
	li s2, 31
	li s3, 31
	li s4, 31
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_srai
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sub
	mv s5, a0
	li s1, 31
	sw s1, -32(s0)
.L32_5:
.L32_2:
	lw s1, -12(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L32_6
	j .L32_7
.L32_6:
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -4(s0)
	lw s4, -16(s0)
	lw s5, -12(s0)
	li s6, 36
	add s7, s5, s6
	lw s5, 0(s7)
	mv a0, s3
	mv a1, s4
	mv a2, s5
	jal ra, il
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s6
	jal ra, rv_mc_bnez
	mv s3, a0
	j .L32_8
.L32_7:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rv_mc_new_label
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_beqz
	mv s4, a0
	lw s1, -4(s0)
	la s2, __str_34
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -36(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_label
	mv s3, a0
.L32_8:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
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
.Lfunc_end32:
	.size emit_overflow, .Lfunc_end32-emit_overflow

	.text
	.align 2
	.type emit_unop, @function
emit_unop:
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
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -20(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -24(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -24(s0)
	lw s4, -20(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv t0, s1
	jalr ra, t0, 0
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
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
.Lfunc_end33:
	.size emit_unop, .Lfunc_end33-emit_unop

	.text
	.align 2
	.type emit_cmp, @function
emit_cmp:
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
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -20(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -24(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -16(s0)
	li s2, 31
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_0
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_1
	li s2, 33
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_2
	li s2, 34
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_3
	li s2, 35
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_4
	li s2, 36
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_5
	li s2, 37
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_6
	li s2, 38
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_7
	li s2, 39
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_8
	li s2, 40
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_9
	j .L34_10
.L34_0:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_seqz
	mv s4, a0
	j .L34_10
.L34_1:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_snez
	mv s4, a0
	j .L34_10
.L34_2:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_slt
	mv s5, a0
	j .L34_10
.L34_3:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -24(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_slt
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -28(s0)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xori
	mv s5, a0
	j .L34_10
.L34_4:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -24(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_slt
	mv s5, a0
	j .L34_10
.L34_5:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_slt
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -28(s0)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xori
	mv s5, a0
	j .L34_10
.L34_6:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sltu
	mv s5, a0
	j .L34_10
.L34_7:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -24(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sltu
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -28(s0)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xori
	mv s5, a0
	j .L34_10
.L34_8:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -24(s0)
	lw s4, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sltu
	mv s5, a0
	j .L34_10
.L34_9:
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -20(s0)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sltu
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -28(s0)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xori
	mv s5, a0
	j .L34_10
.L34_10:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
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
.Lfunc_end34:
	.size emit_cmp, .Lfunc_end34-emit_cmp

	.text
	.align 2
	.type emit_fbinop, @function
emit_fbinop:
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
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -20(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv s6, a0
	sw s6, -24(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv s6, a0
	sw s6, -28(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -32(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -20(s0)
	lw s4, -32(s0)
	lw s5, -24(s0)
	lw s6, -28(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv t0, s1
	jalr ra, t0, 0
	mv s7, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -32(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv s6, a0
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
.Lfunc_end35:
	.size emit_fbinop, .Lfunc_end35-emit_fbinop

	.text
	.align 2
	.type emit_funop, @function
emit_funop:
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
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -20(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv s6, a0
	sw s6, -24(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -20(s0)
	lw s4, -28(s0)
	lw s5, -24(s0)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -28(s0)
	lw s5, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv s6, a0
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
	.size emit_funop, .Lfunc_end36-emit_funop

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
	sw a2, -12(s0)
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -20(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -24(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -24(s0)
	lw s4, -20(s0)
	li s5, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
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
.Lfunc_end37:
	.size emit_load, .Lfunc_end37-emit_load

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
	sw a3, -16(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -20(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -24(s0)
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -24(s0)
	lw s4, -20(s0)
	li s5, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv t0, s1
	jalr ra, t0, 0
	mv s6, a0
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
.Lfunc_end38:
	.size emit_store, .Lfunc_end38-emit_store

	.text
	.align 2
	.type compute_used_fregs, @function
compute_used_fregs:
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
	addi s1, s0, -72
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
	li s2, 0
	sw s2, 0(s1)
	li s1, 0
	la s2, n_used_fregs
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L39_0:
	lw s1, -12(s0)
	bnez s1, .L39_1
	j .L39_2
.L39_1:
	lw s1, -12(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, ir_op_is_float_def
	mv s1, a0
	bnez s1, .L39_3
	j .L39_4
.L39_3:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L39_5
	j .L39_4
.L39_5:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 64
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L39_6
	j .L39_4
.L39_6:
	lw s1, -4(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -76(s0)
	lw s1, -76(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L39_7
	j .L39_8
.L39_7:
	lw s1, -76(s0)
	li s2, 13
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L39_9
	j .L39_8
.L39_9:
	li s1, 1
	addi s2, s0, -72
	lw s3, -76(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L39_8:
.L39_4:
.L39_10:
	lw s1, -12(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L39_0
.L39_2:
	li s1, 2
	sw s1, -76(s0)
.L39_11:
	lw s1, -76(s0)
	li s2, 13
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L39_12
	j .L39_13
.L39_12:
	addi s1, s0, -72
	lw s2, -76(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L39_14
	j .L39_15
.L39_14:
	lw s1, -76(s0)
	la s2, used_fregs
	la s3, n_used_fregs
	lw s4, 0(s3)
	li s5, 1
	add s6, s4, s5
	sw s6, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L39_15:
.L39_16:
	addi s1, s0, -76
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -76(s0)
	j .L39_11
.L39_13:
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
.Lfunc_end39:
	.size compute_used_fregs, .Lfunc_end39-compute_used_fregs

	.text
	.align 2
	.type emit_prologue, @function
emit_prologue:
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
	lw s1, -8(s0)
	mv a0, s1
	jal ra, frame_size
	mv s2, a0
	sw s2, -12(s0)
	la s1, n_used_fregs
	lw s2, 0(s1)
	li s1, 8
	mul s3, s2, s1
	sw s3, -16(s0)
	li s1, 11
	li s2, 4
	mul s3, s1, s2
	lw s1, -16(s0)
	add s2, s3, s1
	lw s1, -12(s0)
	add s3, s2, s1
	sw s3, -20(s0)
	li s1, 8
	lw s2, -20(s0)
	add s3, s1, s2
	li s1, 15
	add s2, s3, s1
	li s1, 15
	not s3, s1
	and s1, s2, s3
	sw s1, -24(s0)
	lw s1, -24(s0)
	li s2, 8
	lw s3, -20(s0)
	add s4, s2, s3
	sub s2, s1, s4
	sw s2, -28(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	lw s4, -24(s0)
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addbig
	mv s4, a0
	lw s1, -4(s0)
	li s2, 1
	li s3, 2
	lw s4, -24(s0)
	li s5, 4
	sub s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	li s3, 2
	lw s4, -24(s0)
	li s5, 8
	sub s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
	lw s1, -4(s0)
	li s2, 8
	li s3, 2
	lw s4, -24(s0)
	li s5, 8
	sub s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_addbig
	mv s4, a0
	li s1, 0
	sw s1, -32(s0)
.L40_0:
	lw s1, -32(s0)
	li s2, 11
	slt s3, s1, s2
	bnez s3, .L40_1
	j .L40_2
.L40_1:
	lw s1, -4(s0)
	la s2, reg
	lw s3, -32(s0)
	li s4, 2
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	li s3, 2
	lw s4, -28(s0)
	lw s5, -32(s0)
	li s6, 4
	mul s7, s5, s6
	add s5, s4, s7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_sw
	mv s4, a0
.L40_3:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L40_0
.L40_2:
	li s1, 0
	sw s1, -32(s0)
.L40_4:
	lw s1, -32(s0)
	la s2, n_used_fregs
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L40_5
	j .L40_6
.L40_5:
	lw s1, -4(s0)
	la s2, freg
	la s3, used_fregs
	lw s4, -32(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 2
	lw s4, -28(s0)
	li s5, 11
	li s6, 4
	mul s7, s5, s6
	add s5, s4, s7
	lw s4, -32(s0)
	li s6, 8
	mul s7, s4, s6
	add s4, s5, s7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fsd
	mv s5, a0
.L40_7:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L40_4
.L40_6:
	li s1, 0
	sw s1, -32(s0)
.L40_8:
	lw s1, -32(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L40_9
	j .L40_10
.L40_9:
	lw s1, -8(s0)
	lw s2, -32(s0)
	addi s3, s0, -48
	addi s4, s0, -52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_param
	mv s5, a0
	addi s1, s0, -48
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_11
	j .L40_12
.L40_11:
	j .L40_13
.L40_12:
	lw s1, -4(s0)
	la s2, argreg
	addi s3, s0, -48
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -52(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	addi s1, s0, -48
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_14
	j .L40_15
.L40_14:
	lw s1, -4(s0)
	la s2, argreg
	addi s3, s0, -48
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	li s3, 8
	lw s4, -52(s0)
	li s5, 4
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
	j .L40_16
.L40_15:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L40_17
	j .L40_18
.L40_17:
	lw s1, -4(s0)
	li s2, 5
	li s3, 8
	li s4, 8
	addi s5, s0, -48
	li s6, 12
	add s7, s5, s6
	lw s5, 0(s7)
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_lw
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 8
	lw s4, -52(s0)
	li s5, 4
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
.L40_18:
.L40_16:
.L40_13:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L40_8
.L40_10:
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
	.size emit_prologue, .Lfunc_end40-emit_prologue

	.text
	.align 2
	.type emit_epilogue_no_ret, @function
emit_epilogue_no_ret:
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
	lw s1, -8(s0)
	mv a0, s1
	jal ra, frame_size
	mv s2, a0
	sw s2, -12(s0)
	la s1, n_used_fregs
	lw s2, 0(s1)
	li s1, 8
	mul s3, s2, s1
	sw s3, -16(s0)
	li s1, 11
	li s2, 4
	mul s3, s1, s2
	lw s1, -16(s0)
	add s2, s3, s1
	lw s1, -12(s0)
	add s3, s2, s1
	neg s1, s3
	sw s1, -20(s0)
	lw s1, -16(s0)
	lw s2, -12(s0)
	add s3, s1, s2
	neg s1, s3
	sw s1, -24(s0)
	li s1, 0
	sw s1, -28(s0)
.L41_0:
	lw s1, -28(s0)
	li s2, 11
	slt s3, s1, s2
	bnez s3, .L41_1
	j .L41_2
.L41_1:
	lw s1, -4(s0)
	la s2, reg
	lw s3, -28(s0)
	li s4, 2
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	li s3, 8
	lw s4, -20(s0)
	lw s5, -28(s0)
	li s6, 4
	mul s7, s5, s6
	add s5, s4, s7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_lw
	mv s4, a0
.L41_3:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L41_0
.L41_2:
	li s1, 0
	sw s1, -28(s0)
.L41_4:
	lw s1, -28(s0)
	la s2, n_used_fregs
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L41_5
	j .L41_6
.L41_5:
	lw s1, -4(s0)
	la s2, freg
	la s3, used_fregs
	lw s4, -28(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -24(s0)
	lw s5, -28(s0)
	li s6, 8
	mul s7, s5, s6
	add s5, s4, s7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_fld
	mv s4, a0
.L41_7:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L41_4
.L41_6:
	lw s1, -4(s0)
	li s2, 1
	li s3, 8
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 8
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 8
	li s4, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
	lw s1, -4(s0)
	li s2, 8
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
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
.Lfunc_end41:
	.size emit_epilogue_no_ret, .Lfunc_end41-emit_epilogue_no_ret

	.text
	.align 2
	.type emit_epilogue, @function
emit_epilogue:
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
	jal ra, emit_epilogue_no_ret
	mv s3, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rv_mc_ret
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
.Lfunc_end42:
	.size emit_epilogue, .Lfunc_end42-emit_epilogue

	.text
	.align 2
	.type emit_call_flush, @function
emit_call_flush:
	addi sp, sp, -816
	sw ra, 812(sp)
	sw s0, 808(sp)
	addi s0, sp, 808
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
	addi s1, s0, -664
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
	li s1, 1
	neg s2, s1
	sw s2, -688(s0)
	li s1, 0
	sw s1, -668(s0)
.L43_0:
	lw s1, -668(s0)
	la s2, narg
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L43_1
	j .L43_2
.L43_1:
	la s1, arg_is_i64
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_3
	j .L43_4
.L43_3:
	li s1, 2
	addi s2, s0, -664
	lw s3, -668(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L43_5
.L43_4:
	la s1, arg_is_float
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_6
	j .L43_7
.L43_6:
	la s1, arg_fw
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_8
	j .L43_9
.L43_8:
	li s1, 1
	sw s1, -692(s0)
	j .L43_10
.L43_9:
	li s1, 2
	sw s1, -692(s0)
.L43_10:
	lw s1, -692(s0)
	addi s2, s0, -664
	lw s3, -668(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L43_11
.L43_7:
	li s1, 1
	addi s2, s0, -664
	lw s3, -668(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L43_11:
.L43_5:
	lw s1, -688(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L43_12
	j .L43_13
.L43_12:
	la s1, arg_vararg
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_14
	j .L43_13
.L43_14:
	lw s1, -668(s0)
	sw s1, -688(s0)
.L43_13:
.L43_15:
	addi s1, s0, -668
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -668(s0)
	j .L43_0
.L43_2:
	addi s1, s0, -664
	la s2, narg
	lw s3, 0(s2)
	addi s2, s0, -536
	lw s4, -688(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	mv a3, s4
	jal ra, rv_abi_assign
	mv s5, a0
	sw s5, -676(s0)
	lw s1, -20(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L43_16
	j .L43_17
.L43_16:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s1, t0
	bnez s1, .L43_18
	j .L43_17
.L43_18:
	li s1, 1
	j .L43_19
.L43_17:
	li s1, 0
.L43_19:
	sw s1, -684(s0)
	li s1, 0
	sw s1, -668(s0)
.L43_20:
	lw s1, -668(s0)
	la s2, narg
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L43_21
	j .L43_22
.L43_21:
	la s1, arg_is_float
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_23
	j .L43_24
.L43_23:
	la s1, arg_fw
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_24
	j .L43_25
.L43_25:
	li s1, 1
	sw s1, -684(s0)
.L43_24:
.L43_26:
	addi s1, s0, -668
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -668(s0)
	j .L43_20
.L43_22:
	lw s1, -676(s0)
	li s2, 7
	add s3, s1, s2
	li s1, 7
	not s2, s1
	and s1, s3, s2
	sw s1, -680(s0)
	lw s1, -680(s0)
	lw s2, -684(s0)
	bnez s2, .L43_27
	j .L43_28
.L43_27:
	li s2, 8
	sw s2, -696(s0)
	j .L43_29
.L43_28:
	li s2, 0
	sw s2, -696(s0)
.L43_29:
	lw s2, -696(s0)
	add s3, s1, s2
	sw s3, -672(s0)
	lw s1, -672(s0)
	li s2, 15
	add s3, s1, s2
	li s1, 15
	not s2, s1
	and s1, s3, s2
	sw s1, -672(s0)
	lw s1, -684(s0)
	bnez s1, .L43_30
	j .L43_31
.L43_30:
	lw s1, -672(s0)
	lw s2, -680(s0)
	li s3, 8
	add s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L43_32
	j .L43_31
.L43_32:
	lw s1, -680(s0)
	li s2, 16
	add s3, s1, s2
	sw s3, -672(s0)
.L43_31:
	lw s1, -672(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L43_33
	j .L43_34
.L43_33:
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	lw s4, -672(s0)
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addbig
	mv s4, a0
.L43_34:
	li s1, 0
	sw s1, -668(s0)
.L43_35:
	lw s1, -668(s0)
	la s2, narg
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L43_36
	j .L43_37
.L43_36:
	addi s1, s0, -536
	lw s2, -668(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -700(s0)
	la s1, arg_is_float
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_38
	j .L43_39
.L43_38:
	la s1, arg_fw
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_39
	j .L43_40
.L43_40:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -668(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv s6, a0
	sw s6, -704(s0)
	lw s1, -4(s0)
	lw s2, -704(s0)
	li s3, 2
	lw s4, -680(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fsd
	mv s5, a0
	lw s1, -700(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L43_41
	j .L43_42
.L43_41:
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -700(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 2
	lw s4, -680(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	j .L43_43
.L43_42:
	lw s1, -4(s0)
	li s2, 5
	li s3, 2
	lw s4, -680(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 2
	lw s4, -700(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
.L43_43:
	lw s1, -700(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L43_44
	j .L43_45
.L43_44:
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -700(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	li s3, 2
	lw s4, -680(s0)
	li s5, 4
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_lw
	mv s4, a0
	j .L43_46
.L43_45:
	lw s1, -4(s0)
	li s2, 5
	li s3, 2
	lw s4, -680(s0)
	li s5, 4
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_lw
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 2
	lw s4, -700(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	lw s5, -700(s0)
	li s6, 8
	add s7, s5, s6
	lw s5, 0(s7)
	li s6, 1
	xor s7, s5, s6
	seqz s7, s7
	bnez s7, .L43_47
	j .L43_48
.L43_47:
	li s5, 0
	sw s5, -708(s0)
	j .L43_49
.L43_48:
	li s5, 4
	sw s5, -708(s0)
.L43_49:
	lw s5, -708(s0)
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
.L43_46:
	j .L43_50
.L43_39:
	la s1, arg_is_float
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_51
	j .L43_52
.L43_51:
	la s1, arg_temps
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, src_is_f32
	mv s2, a0
	bnez s2, .L43_53
	j .L43_54
.L43_53:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -668(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv s6, a0
	sw s6, -712(s0)
	j .L43_55
.L43_54:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -668(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv s6, a0
	sw s6, -716(s0)
	lw s1, -4(s0)
	li s2, 1
	lw s3, -716(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_s_d
	mv s4, a0
	li s1, 1
	sw s1, -712(s0)
.L43_55:
	lw s1, -700(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L43_56
	j .L43_57
.L43_56:
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -700(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -712(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fmv_x_w
	mv s4, a0
	j .L43_58
.L43_57:
	lw s1, -4(s0)
	li s2, 5
	lw s3, -712(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fmv_x_w
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 2
	lw s4, -700(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
.L43_58:
	j .L43_59
.L43_52:
	la s1, arg_is_i64
	lw s2, -668(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L43_60
	j .L43_61
.L43_60:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -668(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -720(s0)
	lw s1, -700(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L43_62
	j .L43_63
.L43_62:
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -700(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -720(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	j .L43_64
.L43_63:
	lw s1, -4(s0)
	lw s2, -720(s0)
	li s3, 2
	lw s4, -700(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
.L43_64:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -668(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -724(s0)
	lw s1, -700(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L43_65
	j .L43_66
.L43_65:
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -700(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	lw s3, -724(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	j .L43_67
.L43_66:
	lw s1, -4(s0)
	lw s2, -724(s0)
	li s3, 2
	lw s4, -700(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	lw s5, -700(s0)
	li s6, 8
	add s7, s5, s6
	lw s5, 0(s7)
	li s6, 1
	xor s7, s5, s6
	seqz s7, s7
	bnez s7, .L43_68
	j .L43_69
.L43_68:
	li s5, 0
	sw s5, -728(s0)
	j .L43_70
.L43_69:
	li s5, 4
	sw s5, -728(s0)
.L43_70:
	lw s5, -728(s0)
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
.L43_67:
	j .L43_71
.L43_61:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -668(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -732(s0)
	lw s1, -700(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L43_72
	j .L43_73
.L43_72:
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -700(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -732(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	j .L43_74
.L43_73:
	lw s1, -4(s0)
	lw s2, -732(s0)
	li s3, 2
	lw s4, -700(s0)
	li s5, 12
	add s6, s4, s5
	lw s4, 0(s6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
.L43_74:
.L43_71:
.L43_59:
.L43_50:
.L43_75:
	addi s1, s0, -668
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -668(s0)
	j .L43_35
.L43_37:
	lw s1, -16(s0)
	bnez s1, .L43_76
	j .L43_77
.L43_76:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -736(s0)
	lw s1, -736(s0)
	li s2, 5
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L43_78
	j .L43_79
.L43_78:
	lw s1, -4(s0)
	li s2, 5
	lw s3, -736(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L43_79:
	lw s1, -4(s0)
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_jalr
	mv s3, a0
	j .L43_80
.L43_77:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
.L43_80:
	li s1, 0
	la s2, narg
	sw s1, 0(s2)
	lw s1, -20(s0)
	li s2, 3
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L43_81
	j .L43_82
.L43_81:
	lw s1, -4(s0)
	li s2, 11
	li s3, 8
	lw s4, -8(s0)
	lw s5, -12(s0)
	li s6, 32
	add s7, s5, s6
	lw s5, 0(s7)
	mv a0, s4
	mv a1, s5
	jal ra, slot_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
.L43_82:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L43_83
	j .L43_84
.L43_83:
	lw s1, -20(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L43_85
	j .L43_86
.L43_85:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -740(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -744(s0)
	lw s1, -740(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L43_87
	j .L43_88
.L43_87:
	lw s1, -4(s0)
	lw s2, -740(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L43_88:
	lw s1, -744(s0)
	li s2, 11
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L43_89
	j .L43_90
.L43_89:
	lw s1, -4(s0)
	lw s2, -744(s0)
	li s3, 11
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L43_90:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -740(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -744(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L43_91
.L43_86:
	lw s1, -20(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L43_92
	j .L43_93
.L43_92:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -748(s0)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L43_94
	j .L43_95
.L43_94:
	lw s1, -4(s0)
	lw s2, -748(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fmv_w_x
	mv s4, a0
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, src_is_f32
	mv s2, a0
	bnez s2, .L43_96
	j .L43_97
.L43_97:
	lw s1, -4(s0)
	lw s2, -748(s0)
	lw s3, -748(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_d_s
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -748(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv s6, a0
	j .L43_98
.L43_96:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -748(s0)
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv s6, a0
.L43_98:
	j .L43_99
.L43_95:
	lw s1, -4(s0)
	li s2, 10
	li s3, 2
	lw s4, -680(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 11
	li s3, 2
	lw s4, -680(s0)
	li s5, 4
	add s6, s4, s5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -748(s0)
	li s3, 2
	lw s4, -680(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fld
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -748(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv s6, a0
.L43_99:
	j .L43_100
.L43_93:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -752(s0)
	lw s1, -752(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L43_101
	j .L43_102
.L43_101:
	lw s1, -4(s0)
	lw s2, -752(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L43_102:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -752(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
.L43_100:
.L43_91:
.L43_84:
	lw s1, -672(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L43_103
	j .L43_104
.L43_103:
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	lw s4, -672(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addbig
	mv s5, a0
.L43_104:
	li s1, 0
	mv a0, s1
	lw s1, -796(s0)
	lw s2, -792(s0)
	lw s3, -788(s0)
	lw s4, -784(s0)
	lw s5, -780(s0)
	lw s6, -776(s0)
	lw s7, -772(s0)
	lw s8, -768(s0)
	lw s9, -764(s0)
	lw s10, -760(s0)
	lw s11, -756(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end43:
	.size emit_call_flush, .Lfunc_end43-emit_call_flush

	.text
	.align 2
	.type emit_tailcall_flush, @function
emit_tailcall_flush:
	addi sp, sp, -816
	sw ra, 812(sp)
	sw s0, 808(sp)
	addi s0, sp, 808
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
	addi s1, s0, -656
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
	li s1, 1
	neg s2, s1
	sw s2, -668(s0)
	li s1, 0
	sw s1, -660(s0)
.L44_0:
	lw s1, -660(s0)
	la s2, narg
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L44_1
	j .L44_2
.L44_1:
	la s1, arg_is_i64
	lw s2, -660(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L44_3
	j .L44_4
.L44_3:
	li s1, 2
	addi s2, s0, -656
	lw s3, -660(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L44_5
.L44_4:
	la s1, arg_is_float
	lw s2, -660(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L44_6
	j .L44_7
.L44_6:
	la s1, arg_fw
	lw s2, -660(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L44_8
	j .L44_9
.L44_8:
	li s1, 1
	sw s1, -672(s0)
	j .L44_10
.L44_9:
	li s1, 2
	sw s1, -672(s0)
.L44_10:
	lw s1, -672(s0)
	addi s2, s0, -656
	lw s3, -660(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L44_11
.L44_7:
	li s1, 1
	addi s2, s0, -656
	lw s3, -660(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L44_11:
.L44_5:
	lw s1, -668(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L44_12
	j .L44_13
.L44_12:
	la s1, arg_vararg
	lw s2, -660(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L44_14
	j .L44_13
.L44_14:
	lw s1, -660(s0)
	sw s1, -668(s0)
.L44_13:
.L44_15:
	addi s1, s0, -660
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -660(s0)
	j .L44_0
.L44_2:
	addi s1, s0, -656
	la s2, narg
	lw s3, 0(s2)
	addi s2, s0, -528
	lw s4, -668(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	mv a3, s4
	jal ra, rv_abi_assign
	mv s5, a0
	sw s5, -664(s0)
	lw s1, -664(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L44_16
	j .L44_17
.L44_16:
	lw s1, -12(s0)
	addi s2, s0, -728
	lw s3, 0(s1)
	sw s3, 0(s2)
	li s3, 4
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 4
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 8
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 8
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 12
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 12
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 16
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 16
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 20
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 20
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 24
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 24
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 28
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 28
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 32
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 32
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 36
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 36
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 40
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 40
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 44
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 44
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 48
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 48
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 52
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	neg s2, s1
	addi s1, s0, -728
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	lw s2, -8(s0)
	addi s3, s0, -728
	lw s4, -16(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv s6, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue
	mv s3, a0
	lw s1, -796(s0)
	lw s2, -792(s0)
	lw s3, -788(s0)
	lw s4, -784(s0)
	lw s5, -780(s0)
	lw s6, -776(s0)
	lw s7, -772(s0)
	lw s8, -768(s0)
	lw s9, -764(s0)
	lw s10, -760(s0)
	lw s11, -756(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_17:
	li s1, 0
	sw s1, -660(s0)
.L44_18:
	lw s1, -660(s0)
	la s2, narg
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L44_19
	j .L44_20
.L44_19:
	addi s1, s0, -528
	lw s2, -660(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -732(s0)
	la s1, arg_is_float
	lw s2, -660(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L44_21
	j .L44_22
.L44_21:
	la s1, arg_fw
	lw s2, -660(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L44_22
	j .L44_23
.L44_23:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -660(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv s6, a0
	sw s6, -736(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -736(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fsd
	mv s5, a0
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -732(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -732(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	li s3, 2
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
	j .L44_24
.L44_22:
	la s1, arg_is_float
	lw s2, -660(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L44_25
	j .L44_26
.L44_25:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -660(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv s6, a0
	sw s6, -740(s0)
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -732(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -740(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fmv_x_w
	mv s4, a0
	j .L44_27
.L44_26:
	la s1, arg_is_i64
	lw s2, -660(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	bnez s1, .L44_28
	j .L44_29
.L44_28:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -660(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -744(s0)
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -732(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -744(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -732(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	lw s3, -4(s0)
	lw s4, -8(s0)
	la s5, arg_temps
	lw s6, -660(s0)
	li s7, 4
	mul s8, s6, s7
	add s6, s5, s8
	lw s5, 0(s6)
	li s6, 0
	mv a0, s3
	mv a1, s4
	mv a2, s5
	mv a3, s6
	jal ra, i64_rs_hi
	mv s7, a0
	mv a0, s1
	mv a1, s2
	mv a2, s7
	jal ra, rv_mc_mv
	mv s3, a0
	j .L44_30
.L44_29:
	lw s1, -4(s0)
	lw s2, -8(s0)
	la s3, arg_temps
	lw s4, -660(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -748(s0)
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -732(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -748(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L44_30:
.L44_27:
.L44_24:
.L44_31:
	addi s1, s0, -660
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -660(s0)
	j .L44_18
.L44_20:
	lw s1, -16(s0)
	bnez s1, .L44_32
	j .L44_33
.L44_32:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -752(s0)
	lw s1, -4(s0)
	li s2, 7
	lw s3, -752(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L44_33:
	li s1, 0
	la s2, narg
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue_no_ret
	mv s3, a0
	lw s1, -16(s0)
	bnez s1, .L44_34
	j .L44_35
.L44_34:
	lw s1, -4(s0)
	li s2, 7
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_jr
	mv s3, a0
	j .L44_36
.L44_35:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_j_sym
	mv s3, a0
.L44_36:
	li s1, 0
	mv a0, s1
	lw s1, -796(s0)
	lw s2, -792(s0)
	lw s3, -788(s0)
	lw s4, -784(s0)
	lw s5, -780(s0)
	lw s6, -776(s0)
	lw s7, -772(s0)
	lw s8, -768(s0)
	lw s9, -764(s0)
	lw s10, -760(s0)
	lw s11, -756(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end44:
	.size emit_tailcall_flush, .Lfunc_end44-emit_tailcall_flush

	.text
	.align 2
	.type il, @function
il:
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
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L45_0
	j .L45_1
.L45_0:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rv_mc_new_label
	mv s2, a0
	lw s1, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L45_1:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
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
.Lfunc_end45:
	.size il, .Lfunc_end45-il

	.text
	.align 2
	.type rv_reg_num, @function
rv_reg_num:
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
	la s2, __str_35
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L46_0
	j .L46_1
.L46_0:
	li s1, 8
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
.L46_1:
	li s1, 0
	sw s1, -12(s0)
.L46_2:
	lw s1, -12(s0)
	li s2, 32
	slt s3, s1, s2
	bnez s3, .L46_3
	j .L46_4
.L46_3:
	la s1, rv_abi_name
	lw s2, -12(s0)
	li s3, 4
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
	bnez s2, .L46_5
	j .L46_6
.L46_5:
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
.L46_6:
.L46_7:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L46_2
.L46_4:
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
.Lfunc_end46:
	.size rv_reg_num, .Lfunc_end46-rv_reg_num

	.text
	.align 2
	.type asm_reg_clobbered, @function
asm_reg_clobbered:
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
.L47_0:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L47_1
	j .L47_2
.L47_1:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L47_3
	j .L47_4
.L47_3:
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
.L47_4:
.L47_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L47_0
.L47_2:
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
.Lfunc_end47:
	.size asm_reg_clobbered, .Lfunc_end47-asm_reg_clobbered

	.text
	.align 2
	.type rv_hw_to_index, @function
rv_hw_to_index:
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
	li s1, 2
	sw s1, -12(s0)
.L48_0:
	lw s1, -12(s0)
	li s2, 52
	li s3, 4
	div s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L48_1
	j .L48_2
.L48_1:
	la s1, reg
	lw s2, -12(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -4(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L48_3
	j .L48_4
.L48_3:
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
.L48_4:
.L48_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L48_0
.L48_2:
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
.Lfunc_end48:
	.size rv_hw_to_index, .Lfunc_end48-rv_hw_to_index

	.text
	.align 2
	.globl rv_asm_reserved_regs
	.type rv_asm_reserved_regs, @function
rv_asm_reserved_regs:
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
	li s1, 0
	sw s1, -24(s0)
	lw s1, -4(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
.L49_0:
	lw s1, -20(s0)
	bnez s1, .L49_1
	j .L49_2
.L49_1:
	lw s1, -20(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -36(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	li s1, 129
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L49_3
	j .L49_4
.L49_4:
	lw s1, -36(s0)
	bnez s1, .L49_5
	j .L49_3
.L49_3:
	j .L49_6
.L49_5:
	li s1, 0
	sw s1, -28(s0)
.L49_7:
	lw s1, -28(s0)
	lw s2, -36(s0)
	lw s3, 0(s2)
	lw s2, -36(s0)
	li s4, 4
	add s5, s2, s4
	lw s2, 0(s5)
	add s4, s3, s2
	slt s2, s1, s4
	bnez s2, .L49_8
	j .L49_9
.L49_8:
	lw s1, -36(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L49_10
	j .L49_11
.L49_11:
	j .L49_12
.L49_10:
	lw s1, -36(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	mv a0, s1
	jal ra, rv_reg_num
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -40(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L49_13
	j .L49_14
.L49_13:
	li s1, 1
	neg s2, s1
	sw s2, -48(s0)
	j .L49_15
.L49_14:
	lw s1, -40(s0)
	mv a0, s1
	jal ra, rv_hw_to_index
	mv s2, a0
	sw s2, -48(s0)
.L49_15:
	lw s1, -48(s0)
	sw s1, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L49_16
	j .L49_17
.L49_16:
	j .L49_12
.L49_17:
	li s1, 0
	sw s1, -32(s0)
.L49_18:
	lw s1, -32(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	bnez s3, .L49_19
	j .L49_20
.L49_19:
	lw s1, -8(s0)
	lw s2, -32(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -44(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L49_21
	j .L49_20
.L49_21:
.L49_22:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L49_18
.L49_20:
	lw s1, -32(s0)
	lw s2, -24(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L49_23
	j .L49_24
.L49_23:
	lw s1, -24(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L49_25
	j .L49_24
.L49_25:
	lw s1, -44(s0)
	lw s2, -8(s0)
	addi s3, s0, -24
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -24(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L49_24:
.L49_12:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L49_7
.L49_9:
	li s1, 0
	sw s1, -28(s0)
.L49_26:
	lw s1, -28(s0)
	lw s2, -36(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L49_27
	j .L49_28
.L49_27:
	lw s1, -36(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, rv_reg_num
	mv s2, a0
	sw s2, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L49_29
	j .L49_30
.L49_29:
	li s1, 1
	neg s2, s1
	sw s2, -60(s0)
	j .L49_31
.L49_30:
	lw s1, -52(s0)
	mv a0, s1
	jal ra, rv_hw_to_index
	mv s2, a0
	sw s2, -60(s0)
.L49_31:
	lw s1, -60(s0)
	sw s1, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L49_32
	j .L49_33
.L49_32:
	j .L49_34
.L49_33:
	li s1, 0
	sw s1, -32(s0)
.L49_35:
	lw s1, -32(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	bnez s3, .L49_36
	j .L49_37
.L49_36:
	lw s1, -8(s0)
	lw s2, -32(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -56(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L49_38
	j .L49_37
.L49_38:
.L49_39:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L49_35
.L49_37:
	lw s1, -32(s0)
	lw s2, -24(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L49_40
	j .L49_41
.L49_40:
	lw s1, -24(s0)
	lw s2, -12(s0)
	slt s3, s1, s2
	bnez s3, .L49_42
	j .L49_41
.L49_42:
	lw s1, -56(s0)
	lw s2, -8(s0)
	addi s3, s0, -24
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -24(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L49_41:
.L49_34:
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L49_26
.L49_28:
.L49_6:
	lw s1, -20(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L49_0
.L49_2:
	lw s1, -24(s0)
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
.Lfunc_end49:
	.size rv_asm_reserved_regs, .Lfunc_end49-rv_asm_reserved_regs

	.text
	.align 2
	.type asm_reg_pinned, @function
asm_reg_pinned:
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
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -16(s0)
	li s1, 0
	sw s1, -12(s0)
.L50_0:
	lw s1, -12(s0)
	lw s2, -16(s0)
	slt s3, s1, s2
	bnez s3, .L50_1
	j .L50_2
.L50_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L50_3
	j .L50_4
.L50_3:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L50_5
	j .L50_4
.L50_5:
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
.L50_4:
.L50_6:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L50_0
.L50_2:
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
.Lfunc_end50:
	.size asm_reg_pinned, .Lfunc_end50-asm_reg_pinned

	.text
	.align 2
	.type emit_asm_ext, @function
emit_asm_ext:
	addi sp, sp, -1296
	sw ra, 1292(sp)
	sw s0, 1288(sp)
	addi s0, sp, 1288
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
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	lw s1, -20(s0)
	lw s2, 0(s1)
	lw s1, -20(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -24(s0)
	li s1, 24
	li s2, 4
	div s3, s1, s2
	sw s3, -28(s0)
	li s1, 0
	sw s1, -164(s0)
	li s1, 0
	sw s1, -1204(s0)
	lw s1, -24(s0)
	li s2, 32
	slt s3, s2, s1
	bnez s3, .L51_0
	j .L51_1
.L51_0:
	la s1, __str_36
	mv a0, s1
	jal ra, die
	mv s2, a0
.L51_1:
	li s1, 0
	sw s1, -168(s0)
.L51_2:
	lw s1, -168(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	bnez s3, .L51_3
	j .L51_4
.L51_3:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -168(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -1208(s0)
	lw s1, -1208(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, t_is_i64
	mv s2, a0
	bnez s2, .L51_5
	j .L51_6
.L51_5:
	la s1, __str_37
	mv a0, s1
	jal ra, die
	mv s2, a0
.L51_6:
	lw s1, -1208(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L51_7
	j .L51_8
.L51_7:
	lw s1, -1208(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, rv_reg_num
	mv s2, a0
	sw s2, -1216(s0)
	lw s1, -1216(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L51_9
	j .L51_10
.L51_9:
	la s1, __str_38
	lw s2, -1208(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L51_10:
	li s1, 0
	sw s1, -1212(s0)
.L51_11:
	lw s1, -1212(s0)
	lw s2, -168(s0)
	slt s3, s1, s2
	bnez s3, .L51_12
	j .L51_13
.L51_12:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1212(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	bnez s1, .L51_14
	j .L51_15
.L51_14:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1212(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -1208(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L51_16
	j .L51_15
.L51_16:
	la s1, __str_39
	lw s2, -1208(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L51_15:
.L51_17:
	addi s1, s0, -1212
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1212(s0)
	j .L51_11
.L51_13:
	lw s1, -1216(s0)
	addi s2, s0, -160
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L51_18
.L51_8:
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1208(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L51_19
	j .L51_20
.L51_19:
	la s1, reg
	lw s2, -8(s0)
	li s3, 84
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -1208(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -160
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	j .L51_21
.L51_20:
	li s1, 1
	neg s2, s1
	addi s1, s0, -160
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L51_21:
.L51_18:
.L51_22:
	addi s1, s0, -168
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -168(s0)
	j .L51_2
.L51_4:
	li s1, 0
	sw s1, -168(s0)
.L51_23:
	lw s1, -168(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	bnez s3, .L51_24
	j .L51_25
.L51_24:
	addi s1, s0, -160
	lw s2, -168(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L51_26
	j .L51_27
.L51_26:
	j .L51_28
.L51_27:
.L51_29:
	lw s1, -164(s0)
	lw s2, -28(s0)
	slt s3, s1, s2
	bnez s3, .L51_30
	j .L51_31
.L51_30:
	lw s1, -20(s0)
	la s2, rv_abi_name
	la s3, emit_asm_ext.pool.0
	lw s4, -164(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, asm_reg_clobbered
	mv s3, a0
	bnez s3, .L51_32
	j .L51_33
.L51_33:
	lw s1, -20(s0)
	la s2, rv_abi_name
	la s3, emit_asm_ext.pool.0
	lw s4, -164(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, asm_reg_pinned
	mv s3, a0
	bnez s3, .L51_32
	j .L51_31
.L51_32:
	addi s1, s0, -164
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -164(s0)
	j .L51_29
.L51_31:
	lw s1, -164(s0)
	lw s2, -28(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L51_34
	j .L51_35
.L51_34:
	la s1, __str_40
	mv a0, s1
	jal ra, die
	mv s2, a0
.L51_35:
	la s1, emit_asm_ext.pool.0
	addi s2, s0, -164
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -164(s0)
	li s2, 4
	mul s4, s3, s2
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -160
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L51_28:
	addi s1, s0, -168
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -168(s0)
	j .L51_23
.L51_25:
	li s1, 0
	sw s1, -168(s0)
.L51_36:
	lw s1, -168(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	bnez s3, .L51_37
	j .L51_38
.L51_37:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -168(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -1220(s0)
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1220(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1224(s0)
	lw s1, -1220(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L51_39
	j .L51_40
.L51_39:
	lw s1, -1220(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L51_40
	j .L51_41
.L51_41:
	j .L51_42
.L51_40:
	lw s1, -1220(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L51_43
	j .L51_44
.L51_43:
	lw s1, -1224(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L51_45
	j .L51_46
.L51_45:
	lw s1, -4(s0)
	addi s2, s0, -160
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	la s3, reg
	lw s4, -1224(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	j .L51_47
.L51_46:
	lw s1, -4(s0)
	addi s2, s0, -160
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -1220(s0)
	li s6, 8
	add s7, s5, s6
	lw s5, 0(s7)
	mv a0, s4
	mv a1, s5
	jal ra, spill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_lw
	mv s4, a0
.L51_47:
	j .L51_48
.L51_44:
	lw s1, -1224(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L51_49
	j .L51_50
.L51_49:
	lw s1, -4(s0)
	addi s2, s0, -160
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -1220(s0)
	li s6, 8
	add s7, s5, s6
	lw s5, 0(s7)
	mv a0, s4
	mv a1, s5
	jal ra, spill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_lw
	mv s4, a0
.L51_50:
.L51_48:
.L51_42:
	addi s1, s0, -168
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -168(s0)
	j .L51_36
.L51_38:
	lw s1, -12(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -172(s0)
.L51_51:
	lw s1, -172(s0)
	lb s2, 0(s1)
	bnez s2, .L51_52
	j .L51_53
.L51_52:
	lw s1, -1204(s0)
	li s2, 1
	add s3, s1, s2
	li s1, 1024
	sltu s2, s3, s1
	bnez s2, .L51_54
	j .L51_53
.L51_54:
	lw s1, -172(s0)
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L51_55
	j .L51_56
.L51_55:
	lw s1, -172(s0)
	lb s2, 0(s1)
	addi s1, s0, -1200
	addi s3, s0, -1204
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -1204(s0)
	add s3, s1, s4
	sb s2, 0(s3)
	j .L51_57
.L51_56:
	addi s1, s0, -172
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -172(s0)
	lw s1, -172(s0)
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L51_58
	j .L51_59
.L51_58:
	li s1, 37
	addi s2, s0, -1200
	addi s3, s0, -1204
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -1204(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L51_60
.L51_59:
	lw s1, -172(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L51_61
	j .L51_62
.L51_61:
	lw s1, -172(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L51_63
	j .L51_62
.L51_63:
	li s1, 0
	sw s1, -1228(s0)
.L51_64:
	lw s1, -172(s0)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L51_65
	j .L51_66
.L51_65:
	lw s1, -172(s0)
	lb s2, 0(s1)
	li s1, 57
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L51_67
	j .L51_66
.L51_67:
	lw s1, -1228(s0)
	li s2, 10
	mul s3, s1, s2
	addi s1, s0, -172
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -172(s0)
	lb s1, 0(s2)
	li s2, 48
	sub s4, s1, s2
	add s1, s3, s4
	sw s1, -1228(s0)
	j .L51_64
.L51_66:
	addi s1, s0, -172
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -172(s0)
	lw s1, -1228(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L51_68
	j .L51_69
.L51_68:
	la s1, __str_41
	lw s2, -1228(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L51_69:
	la s1, rv_abi_name
	addi s2, s0, -160
	lw s3, -1228(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1232(s0)
.L51_70:
	lw s1, -1232(s0)
	lb s2, 0(s1)
	bnez s2, .L51_71
	j .L51_72
.L51_71:
	lw s1, -1204(s0)
	li s2, 1
	add s3, s1, s2
	li s1, 1024
	sltu s2, s3, s1
	bnez s2, .L51_73
	j .L51_72
.L51_73:
	addi s1, s0, -1232
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1232(s0)
	lb s1, 0(s2)
	addi s2, s0, -1200
	addi s3, s0, -1204
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -1204(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	j .L51_70
.L51_72:
	j .L51_74
.L51_62:
	li s1, 37
	addi s2, s0, -1200
	addi s3, s0, -1204
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -1204(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	lw s1, -1204(s0)
	li s2, 1
	add s3, s1, s2
	li s1, 1024
	sltu s2, s3, s1
	bnez s2, .L51_75
	j .L51_76
.L51_75:
	lw s1, -172(s0)
	lb s2, 0(s1)
	addi s1, s0, -1200
	addi s3, s0, -1204
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -1204(s0)
	add s3, s1, s4
	sb s2, 0(s3)
.L51_76:
.L51_74:
.L51_60:
.L51_57:
	addi s1, s0, -172
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -172(s0)
	j .L51_51
.L51_53:
	li s1, 0
	addi s2, s0, -1200
	lw s3, -1204(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -4(s0)
	addi s2, s0, -1200
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_asm
	mv s3, a0
	li s1, 0
	sw s1, -168(s0)
.L51_77:
	lw s1, -168(s0)
	lw s2, -20(s0)
	lw s3, 0(s2)
	slt s2, s1, s3
	bnez s2, .L51_78
	j .L51_79
.L51_78:
	lw s1, -20(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -168(s0)
	li s3, 24
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -1236(s0)
	lw s1, -8(s0)
	li s2, 84
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1236(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -1240(s0)
	lw s1, -1236(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L51_80
	j .L51_81
.L51_80:
	lw s1, -1240(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L51_82
	j .L51_83
.L51_82:
	lw s1, -4(s0)
	la s2, reg
	lw s3, -1240(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	addi s3, s0, -160
	lw s4, -168(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	j .L51_84
.L51_83:
	lw s1, -4(s0)
	addi s2, s0, -160
	lw s3, -168(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 8
	lw s4, -8(s0)
	lw s5, -1236(s0)
	li s6, 8
	add s7, s5, s6
	lw s5, 0(s7)
	mv a0, s4
	mv a1, s5
	jal ra, spill_byte_offset
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	jal ra, rv_mc_sw
	mv s4, a0
.L51_84:
	j .L51_85
.L51_81:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -1236(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	addi s4, s0, -160
	lw s5, -168(s0)
	li s6, 4
	mul s7, s5, s6
	add s5, s4, s7
	lw s4, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
.L51_85:
.L51_86:
	addi s1, s0, -168
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -168(s0)
	j .L51_77
.L51_79:
	li s1, 0
	mv a0, s1
	lw s1, -1284(s0)
	lw s2, -1280(s0)
	lw s3, -1276(s0)
	lw s4, -1272(s0)
	lw s5, -1268(s0)
	lw s6, -1264(s0)
	lw s7, -1260(s0)
	lw s8, -1256(s0)
	lw s9, -1252(s0)
	lw s10, -1248(s0)
	lw s11, -1244(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end51:
	.size emit_asm_ext, .Lfunc_end51-emit_asm_ext

	.text
	.align 2
	.type emit_insn, @function
emit_insn:
	li t6, -2352
	add sp, sp, t6
	li t6, 2348
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 2344
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 2344
	add s0, sp, t6
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
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_0
	li s1, 129
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_1
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_2
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_3
	li s1, 137
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_4
	li s1, 3
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_5
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_6
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_7
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_8
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_9
	li s1, 130
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_10
	li s1, 131
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_11
	li s1, 132
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_12
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_13
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_14
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_15
	li s1, 15
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_16
	li s1, 16
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_17
	li s1, 17
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_18
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_19
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_20
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_21
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_22
	li s1, 18
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_23
	li s1, 19
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_24
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_25
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_26
	li s1, 22
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_27
	li s1, 23
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_28
	li s1, 24
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_29
	li s1, 25
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_30
	li s1, 26
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_31
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_32
	li s1, 28
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_33
	li s1, 29
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_34
	li s1, 30
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_35
	li s1, 31
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_36
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_37
	li s1, 33
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_38
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_39
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_40
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_41
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_42
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_43
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_44
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_45
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_46
	li s1, 138
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_47
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_48
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_49
	li s1, 54
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_50
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_51
	li s1, 120
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_52
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_53
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_54
	li s1, 135
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_55
	li s1, 136
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_56
	li s1, 125
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_57
	li s1, 126
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_58
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_59
	li s1, 49
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_60
	li s1, 50
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_61
	li s1, 51
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_62
	li s1, 134
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_63
	li s1, 124
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_64
	li s1, 55
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_65
	li s1, 56
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_66
	li s1, 58
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_67
	li s1, 57
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_68
	li s1, 59
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_69
	li s1, 60
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_70
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_71
	li s1, 62
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_72
	li s1, 63
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_73
	li s1, 64
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_74
	li s1, 65
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_75
	li s1, 66
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_76
	li s1, 67
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_77
	li s1, 68
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_78
	li s1, 69
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_79
	li s1, 70
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_80
	li s1, 71
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_81
	li s1, 72
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_82
	li s1, 73
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_83
	li s1, 80
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_84
	li s1, 81
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_85
	li s1, 75
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_86
	li s1, 77
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_87
	li s1, 74
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_88
	li s1, 76
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_89
	li s1, 78
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_90
	li s1, 79
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_91
	li s1, 82
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_92
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_93
	li s1, 83
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_94
	li s1, 84
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_95
	li s1, 85
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_96
	li s1, 86
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_97
	li s1, 87
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_98
	li s1, 88
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_99
	li s1, 89
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_100
	li s1, 90
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_101
	li s1, 91
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_102
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_103
	li s1, 93
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_104
	li s1, 94
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_105
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_106
	li s1, 99
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_107
	li s1, 96
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_108
	li s1, 97
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_109
	li s1, 98
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_110
	li s1, 100
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_111
	li s1, 101
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_112
	li s1, 102
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_113
	li s1, 103
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_114
	li s1, 104
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_115
	li s1, 105
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_116
	li s1, 106
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_117
	li s1, 107
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_118
	li s1, 108
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_119
	li s1, 109
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_120
	li s1, 110
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_121
	li s1, 111
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_122
	li s1, 112
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_123
	li s1, 113
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_124
	li s1, 117
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_125
	li s1, 118
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_126
	li s1, 119
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_127
	li s1, 122
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_128
	li s1, 123
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_129
	li s1, 121
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_130
	li s1, 116
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_131
	li s1, 52
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_132
	li s1, 53
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_133
	li s1, 133
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_134
	j .L52_135
.L52_0:
	j .L52_136
.L52_1:
	lw s1, -12(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L52_137
	j .L52_138
.L52_137:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, emit_asm_ext
	mv s4, a0
	j .L52_136
.L52_138:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_asm
	mv s3, a0
	j .L52_136
.L52_2:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -4(s0)
	lw s2, -28(s0)
	lw s3, -12(s0)
	li s4, 16
	add s5, s3, s4
	lw s10, 0(s5)
	lw s11, 4(s5)
	mv s3, s10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_li
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -28(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_3:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -32(s0)
	lw s1, -4(s0)
	lw s2, -32(s0)
	lw s3, -12(s0)
	li s4, 24
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_la
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -32(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_4:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -36(s0)
	lw t0, -4(s0)
	sw t0, -2016(s0)
	lw t0, -36(s0)
	sw t0, -2012(s0)
	lw s3, -4(s0)
	lw s4, -16(s0)
	lw s5, -12(s0)
	li s2, 36
	add s1, s5, s2
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s4
	mv a2, s2
	jal ra, il
	mv s1, a0
	lw t0, -2016(s0)
	mv a0, t0
	lw t0, -2012(s0)
	mv a1, t0
	mv a2, s1
	jal ra, rv_mc_lea_label
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -36(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_5:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -40(s0)
	lw s1, -4(s0)
	lw t0, -40(s0)
	sw t0, -2024(s0)
	li t0, 8
	sw t0, -2020(s0)
	lw s4, -8(s0)
	lw s5, -12(s0)
	li s3, 32
	add s2, s5, s3
	lw s3, 0(s2)
	mv a0, s4
	mv a1, s3
	jal ra, slot_offset
	mv s2, a0
	mv a0, s1
	lw t0, -2024(s0)
	mv a1, t0
	lw t0, -2020(s0)
	mv a2, t0
	mv a3, s2
	jal ra, rv_mc_addbig
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -40(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_6:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -44(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -48(s0)
	lw s1, -44(s0)
	lw s2, -48(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_139
	j .L52_140
.L52_139:
	lw s1, -4(s0)
	lw s2, -48(s0)
	lw s3, -44(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_140:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -48(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_7:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_add
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_8:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_sub
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_9:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_mul
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_10:
.L52_11:
.L52_12:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_overflow
	mv s5, a0
	j .L52_136
.L52_13:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_and
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_14:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_or
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_15:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_xor
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_16:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_sll
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_17:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_sra
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_18:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_srl
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_binop
	mv s5, a0
	j .L52_136
.L52_19:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_div
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_div
	mv t0, a0
	sw t0, -2028(s0)
	j .L52_136
.L52_20:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_divu
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_div
	mv t0, a0
	sw t0, -2032(s0)
	j .L52_136
.L52_21:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_rem
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_div
	mv t0, a0
	sw t0, -2036(s0)
	j .L52_136
.L52_22:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_remu
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_div
	mv t0, a0
	sw t0, -2040(s0)
	j .L52_136
.L52_23:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_neg
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_unop
	mv s5, a0
	j .L52_136
.L52_24:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_not
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_unop
	mv s5, a0
	j .L52_136
.L52_25:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_lbu
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_load
	mv s5, a0
	j .L52_136
.L52_26:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_lb
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_load
	mv s5, a0
	j .L52_136
.L52_27:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_lhu
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_load
	mv s5, a0
	j .L52_136
.L52_28:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_lh
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_load
	mv s5, a0
	j .L52_136
.L52_29:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_lw
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_load
	mv s5, a0
	j .L52_136
.L52_30:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_sb
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_store
	mv s5, a0
	j .L52_136
.L52_31:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_sh
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_store
	mv s5, a0
	j .L52_136
.L52_32:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_sw
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_store
	mv s5, a0
	j .L52_136
.L52_33:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -52(s0)
	lw s1, -4(s0)
	lw t0, -52(s0)
	sw t0, -2048(s0)
	li t0, 8
	sw t0, -2044(s0)
	lw s4, -8(s0)
	lw s5, -12(s0)
	li s3, 32
	add s2, s5, s3
	lw s3, 0(s2)
	mv a0, s4
	mv a1, s3
	jal ra, slot_offset
	mv s2, a0
	mv a0, s1
	lw t0, -2048(s0)
	mv a1, t0
	lw t0, -2044(s0)
	mv a2, t0
	mv a3, s2
	jal ra, rv_mc_lw
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -52(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_34:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -56(s0)
	lw s1, -4(s0)
	lw t0, -56(s0)
	li t6, -2056
	add t6, s0, t6
	sw t0, 0(t6)
	li t0, 8
	li t6, -2052
	add t6, s0, t6
	sw t0, 0(t6)
	lw s4, -8(s0)
	lw s5, -12(s0)
	li s3, 32
	add s2, s5, s3
	lw s3, 0(s2)
	mv a0, s4
	mv a1, s3
	jal ra, slot_offset
	mv s2, a0
	mv a0, s1
	li t6, -2056
	add t6, s0, t6
	lw t0, 0(t6)
	mv a1, t0
	li t6, -2052
	add t6, s0, t6
	lw t0, 0(t6)
	mv a2, t0
	mv a3, s2
	jal ra, rv_mc_sw
	mv s3, a0
	j .L52_136
.L52_35:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -60(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -64(s0)
	lw s1, -60(s0)
	li s2, 5
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_141
	j .L52_142
.L52_141:
	lw s1, -4(s0)
	li s2, 5
	lw s3, -60(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_142:
	lw s1, -4(s0)
	li s2, 5
	li s3, 5
	li s4, 3
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 5
	li s4, 4
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_andi
	mv s4, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sub
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -64(s0)
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -64(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_36:
.L52_37:
.L52_38:
.L52_39:
.L52_40:
.L52_41:
.L52_42:
.L52_43:
.L52_44:
.L52_45:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -12(s0)
	lw s5, 0(s4)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, emit_cmp
	mv s4, a0
	j .L52_136
.L52_46:
	lw t0, -4(s0)
	li t6, -2060
	add t6, s0, t6
	sw t0, 0(t6)
	lw s2, -4(s0)
	lw s3, -16(s0)
	lw s4, -12(s0)
	li s5, 36
	add s1, s4, s5
	lw s4, 0(s1)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, il
	mv s1, a0
	li t6, -2060
	add t6, s0, t6
	lw t0, 0(t6)
	mv a0, t0
	mv a1, s1
	jal ra, rv_mc_j
	mv s2, a0
	j .L52_136
.L52_47:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -68(s0)
	lw s1, -4(s0)
	lw s2, -68(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_jr
	mv s3, a0
	j .L52_136
.L52_48:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -72(s0)
	lw t0, -4(s0)
	li t6, -2068
	add t6, s0, t6
	sw t0, 0(t6)
	lw t0, -72(s0)
	li t6, -2064
	add t6, s0, t6
	sw t0, 0(t6)
	lw s3, -4(s0)
	lw s4, -16(s0)
	lw s5, -12(s0)
	li s2, 36
	add s1, s5, s2
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s4
	mv a2, s2
	jal ra, il
	mv s1, a0
	li t6, -2068
	add t6, s0, t6
	lw t0, 0(t6)
	mv a0, t0
	li t6, -2064
	add t6, s0, t6
	lw t0, 0(t6)
	mv a1, t0
	mv a2, s1
	jal ra, rv_mc_beqz
	mv s2, a0
	j .L52_136
.L52_49:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -76(s0)
	lw t0, -4(s0)
	li t6, -2076
	add t6, s0, t6
	sw t0, 0(t6)
	lw t0, -76(s0)
	li t6, -2072
	add t6, s0, t6
	sw t0, 0(t6)
	lw s3, -4(s0)
	lw s4, -16(s0)
	lw s5, -12(s0)
	li s2, 36
	add s1, s5, s2
	lw s2, 0(s1)
	mv a0, s3
	mv a1, s4
	mv a2, s2
	jal ra, il
	mv s1, a0
	li t6, -2076
	add t6, s0, t6
	lw t0, 0(t6)
	mv a0, t0
	li t6, -2072
	add t6, s0, t6
	lw t0, 0(t6)
	mv a1, t0
	mv a2, s1
	jal ra, rv_mc_bnez
	mv s2, a0
	j .L52_136
.L52_50:
	lw t0, -4(s0)
	li t6, -2080
	add t6, s0, t6
	sw t0, 0(t6)
	lw s2, -4(s0)
	lw s3, -16(s0)
	lw s4, -12(s0)
	li s5, 36
	add s1, s4, s5
	lw s4, 0(s1)
	mv a0, s2
	mv a1, s3
	mv a2, s4
	jal ra, il
	mv s1, a0
	li t6, -2080
	add t6, s0, t6
	lw t0, 0(t6)
	mv a0, t0
	mv a1, s1
	jal ra, rv_mc_label
	mv s2, a0
	j .L52_136
.L52_51:
	la s1, narg
	lw s2, 0(s1)
	li s1, 32
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L52_143
	j .L52_144
.L52_143:
	lw s1, -20(s0)
	lw s2, -24(s0)
	la s3, __str_42
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, snprintf
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	li t6, -2340
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2336
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2332
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2328
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2324
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2320
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2316
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2312
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2308
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2304
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2300
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L52_144:
	li s1, 0
	la s2, arg_is_i64
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	la s2, arg_is_float
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, arg_vararg
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw t0, 0(s3)
	li t6, -2084
	add t6, s0, t6
	sw t0, 0(t6)
	la s2, arg_temps
	la s3, narg
	lw s4, 0(s3)
	li s5, 1
	add s1, s4, s5
	sw s1, 0(s3)
	li s1, 4
	mul s3, s4, s1
	add s1, s2, s3
	li t6, -2084
	add t6, s0, t6
	lw t1, 0(t6)
	sw t1, 0(s1)
	j .L52_136
.L52_52:
	la s1, narg
	lw s2, 0(s1)
	li s1, 32
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L52_145
	j .L52_146
.L52_145:
	lw s1, -20(s0)
	lw s2, -24(s0)
	la s3, __str_43
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, snprintf
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	li t6, -2340
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2336
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2332
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2328
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2324
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2320
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2316
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2312
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2308
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2304
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2300
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L52_146:
	li s1, 1
	la s2, arg_is_i64
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 0
	la s2, arg_is_float
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, arg_vararg
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw t0, 0(s3)
	li t6, -2088
	add t6, s0, t6
	sw t0, 0(t6)
	la s2, arg_temps
	la s3, narg
	lw s4, 0(s3)
	li s5, 1
	add s1, s4, s5
	sw s1, 0(s3)
	li s1, 4
	mul s3, s4, s1
	add s1, s2, s3
	li t6, -2088
	add t6, s0, t6
	lw t1, 0(t6)
	sw t1, 0(s1)
	j .L52_136
.L52_53:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv t0, a0
	li t6, -2092
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_54:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 1
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv t0, a0
	li t6, -2096
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_55:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 0
	li s5, 3
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv t0, a0
	li t6, -2100
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_56:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 1
	li s5, 3
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv t0, a0
	li t6, -2104
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_57:
.L52_58:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 7
	mv s8, s1
	srai s9, s8, 31
	and s6, s10, s8
	and s7, s11, s9
	mv s1, s6
	sw s1, -80(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -12(s0)
	lw s5, 0(s4)
	li s4, 126
	xor t0, s5, s4
	seqz t0, t0
	li t6, -2108
	add t6, s0, t6
	sw t0, 0(t6)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2108
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	mv a4, s4
	jal ra, emit_call_flush
	mv s5, a0
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, slot_offset
	mv s3, a0
	sw s3, -84(s0)
	lw s1, -4(s0)
	li s2, 10
	li s3, 8
	lw s4, -84(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -80(s0)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L52_147
	j .L52_148
.L52_147:
	lw s1, -4(s0)
	li s2, 11
	li s3, 8
	lw s4, -84(s0)
	li s5, 4
	add t0, s4, s5
	li t6, -2112
	add t6, s0, t6
	sw t0, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2112
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	jal ra, rv_mc_sw
	mv s4, a0
.L52_148:
	j .L52_136
.L52_59:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_tailcall_flush
	mv s5, a0
	j .L52_136
.L52_60:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_tailcall_flush
	mv s5, a0
	j .L52_136
.L52_61:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue
	mv s3, a0
	j .L52_136
.L52_62:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -88(s0)
	lw s1, -88(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_149
	j .L52_150
.L52_149:
	lw s1, -4(s0)
	li s2, 10
	lw s3, -88(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_150:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue
	mv s3, a0
	j .L52_136
.L52_63:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -92(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -96(s0)
	lw s1, -92(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_151
	j .L52_152
.L52_151:
	lw s1, -4(s0)
	li s2, 10
	lw s3, -92(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_152:
	lw s1, -96(s0)
	li s2, 11
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_153
	j .L52_154
.L52_153:
	lw s1, -4(s0)
	li s2, 11
	lw s3, -96(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_154:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue
	mv s3, a0
	j .L52_136
.L52_64:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -100(s0)
	li s1, 0
	sw s1, -104(s0)
.L52_155:
	lw s1, -104(s0)
	lw s2, -8(s0)
	li s3, 52
	add s4, s2, s3
	lb s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L52_156
	j .L52_157
.L52_156:
	lw s1, -4(s0)
	la s2, argreg
	lw s3, -104(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -100(s0)
	li s4, 4
	lw s5, -104(s0)
	mul t0, s4, s5
	li t6, -2116
	add t6, s0, t6
	sw t0, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2116
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	jal ra, rv_mc_lw
	mv s4, a0
.L52_158:
	addi s1, s0, -104
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -104(s0)
	j .L52_155
.L52_157:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue
	mv s3, a0
	j .L52_136
.L52_65:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -108(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, slot_offset
	mv s3, a0
	sw s3, -112(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rv_mc_new_label
	mv s2, a0
	sw s2, -116(s0)
	lw s1, -4(s0)
	li s2, 8
	li s3, 8
	lw s4, -112(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 8
	lw s4, -112(s0)
	li s5, 4
	add t0, s4, s5
	li t6, -2120
	add t6, s0, t6
	sw t0, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2120
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	jal ra, rv_mc_sw
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	lw s3, -116(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_lea_label
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 8
	lw s4, -112(s0)
	li s5, 8
	add t0, s4, s5
	li t6, -2124
	add t6, s0, t6
	sw t0, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2124
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	jal ra, rv_mc_sw
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 8
	lw s4, -112(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addbig
	mv s5, a0
	lw s1, -4(s0)
	li s2, 6
	la s3, __str_44
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_la
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 6
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 5
	la s3, __str_45
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_la
	mv s4, a0
	lw s1, -4(s0)
	li s2, 6
	li s3, 5
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 6
	li s3, 8
	lw s4, -112(s0)
	li s5, 12
	add t0, s4, s5
	li t6, -2128
	add t6, s0, t6
	sw t0, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2128
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	jal ra, rv_mc_sw
	mv s4, a0
	lw s1, -4(s0)
	li s2, 10
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_li
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -116(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_label
	mv s3, a0
	lw s1, -108(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_159
	j .L52_160
.L52_159:
	lw s1, -4(s0)
	lw s2, -108(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_160:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -108(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_66:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -120(s0)
	li s1, 0
	sw s1, -124(s0)
.L52_161:
	lw s1, -124(s0)
	li s2, 11
	slt s3, s1, s2
	bnez s3, .L52_162
	j .L52_163
.L52_162:
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 4
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	la s2, reg
	lw s3, -124(s0)
	li s4, 2
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
.L52_164:
	addi s1, s0, -124
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -124(s0)
	j .L52_161
.L52_163:
	lw s1, -4(s0)
	la s2, __str_46
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	li s1, 11
	li s2, 1
	sub s3, s1, s2
	sw s3, -124(s0)
.L52_165:
	lw s1, -124(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L52_166
	j .L52_167
.L52_166:
	lw s1, -4(s0)
	la s2, reg
	lw s3, -124(s0)
	li s4, 2
	add s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
.L52_168:
	addi s1, s0, -124
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -124(s0)
	j .L52_165
.L52_167:
	lw s1, -120(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_169
	j .L52_170
.L52_169:
	lw s1, -4(s0)
	lw s2, -120(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_170:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -120(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_67:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, slot_offset
	mv s3, a0
	sw s3, -128(s0)
	lw s1, -4(s0)
	li s2, 5
	li s3, 8
	lw s4, -128(s0)
	li s5, 12
	add t0, s4, s5
	li t6, -2132
	add t6, s0, t6
	sw t0, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2132
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	jal ra, rv_mc_lw
	mv s4, a0
	lw s1, -4(s0)
	li s2, 6
	la s3, __str_47
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_la
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 6
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	j .L52_136
.L52_68:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -132(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -136(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -132(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -136(s0)
	li s3, 2
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	la s2, __str_48
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	j .L52_136
.L52_69:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_fadd
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_fbinop
	mv s5, a0
	j .L52_136
.L52_70:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_fsub
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_fbinop
	mv s5, a0
	j .L52_136
.L52_71:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_fmul
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_fbinop
	mv s5, a0
	j .L52_136
.L52_72:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_fdiv
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_fbinop
	mv s5, a0
	j .L52_136
.L52_73:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_fneg
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_funop
	mv s5, a0
	j .L52_136
.L52_74:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_fabs
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_funop
	mv s5, a0
	j .L52_136
.L52_75:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	la s4, rv_mc_fsqrt
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, emit_funop
	mv s5, a0
	j .L52_136
.L52_76:
.L52_77:
.L52_78:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -140(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	lw s5, -140(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2136
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2136
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -144(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	lw s5, -140(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2140
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2140
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -148(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -152(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 66
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_171
	j .L52_172
.L52_171:
	lw s1, -4(s0)
	lw s2, -140(s0)
	lw s3, -152(s0)
	lw s4, -144(s0)
	lw s5, -148(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, rv_mc_feq
	mv t0, a0
	li t6, -2144
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_173
.L52_172:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 67
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_174
	j .L52_175
.L52_174:
	lw s1, -4(s0)
	lw s2, -140(s0)
	lw s3, -152(s0)
	lw s4, -144(s0)
	lw s5, -148(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, rv_mc_flt
	mv t0, a0
	li t6, -2148
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_176
.L52_175:
	lw s1, -4(s0)
	lw s2, -140(s0)
	lw s3, -152(s0)
	lw s4, -144(s0)
	lw s5, -148(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, rv_mc_fle
	mv t0, a0
	li t6, -2152
	add t6, s0, t6
	sw t0, 0(t6)
.L52_176:
.L52_173:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -152(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_79:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -156(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -160(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -164(s0)
	lw s1, -4(s0)
	lw s2, -156(s0)
	lw s3, -164(s0)
	lw s4, -160(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fcvt_f_w
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -164(s0)
	lw s5, -156(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv t0, a0
	li t6, -2156
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_80:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -168(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	lw s5, -168(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2160
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2160
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -172(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -176(s0)
	lw s1, -4(s0)
	lw s2, -168(s0)
	lw s3, -176(s0)
	lw s4, -172(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fcvt_w_f
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -176(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_81:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -180(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	lw s5, -180(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2164
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2164
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -184(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -188(s0)
	lw s1, -4(s0)
	lw s2, -180(s0)
	lw s3, -188(s0)
	lw s4, -184(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fround
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -188(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_82:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2168
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2168
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -192(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -196(s0)
	lw s1, -4(s0)
	lw s2, -196(s0)
	lw s3, -192(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_d_s
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -196(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv t0, a0
	li t6, -2172
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_83:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2176
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2176
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -200(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -204(s0)
	lw s1, -4(s0)
	lw s2, -204(s0)
	lw s3, -200(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_s_d
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -204(s0)
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv t0, a0
	li t6, -2180
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_84:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -208(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -212(s0)
	lw s1, -208(s0)
	bnez s1, .L52_177
	j .L52_178
.L52_177:
	lw s1, -4(s0)
	lw t0, -212(s0)
	li t6, -2188
	add t6, s0, t6
	sw t0, 0(t6)
	li t0, 8
	li t6, -2184
	add t6, s0, t6
	sw t0, 0(t6)
	lw s4, -8(s0)
	lw s5, -12(s0)
	li s3, 32
	add s2, s5, s3
	lw s3, 0(s2)
	mv a0, s4
	mv a1, s3
	jal ra, slot_offset
	mv s2, a0
	mv a0, s1
	li t6, -2188
	add t6, s0, t6
	lw t0, 0(t6)
	mv a1, t0
	li t6, -2184
	add t6, s0, t6
	lw t0, 0(t6)
	mv a2, t0
	mv a3, s2
	jal ra, rv_mc_flw
	mv s3, a0
	j .L52_179
.L52_178:
	lw s1, -4(s0)
	lw t0, -212(s0)
	li t6, -2196
	add t6, s0, t6
	sw t0, 0(t6)
	li t0, 8
	li t6, -2192
	add t6, s0, t6
	sw t0, 0(t6)
	lw s4, -8(s0)
	lw s5, -12(s0)
	li s3, 32
	add s2, s5, s3
	lw s3, 0(s2)
	mv a0, s4
	mv a1, s3
	jal ra, slot_offset
	mv s2, a0
	mv a0, s1
	li t6, -2196
	add t6, s0, t6
	lw t0, 0(t6)
	mv a1, t0
	li t6, -2192
	add t6, s0, t6
	lw t0, 0(t6)
	mv a2, t0
	mv a3, s2
	jal ra, rv_mc_fld
	mv s3, a0
.L52_179:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -212(s0)
	lw s5, -208(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv t0, a0
	li t6, -2200
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_85:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -216(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	lw s5, -216(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2204
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2204
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -220(s0)
	lw s1, -216(s0)
	bnez s1, .L52_180
	j .L52_181
.L52_180:
	lw s1, -4(s0)
	lw t0, -220(s0)
	li t6, -2212
	add t6, s0, t6
	sw t0, 0(t6)
	li t0, 8
	li t6, -2208
	add t6, s0, t6
	sw t0, 0(t6)
	lw s4, -8(s0)
	lw s5, -12(s0)
	li s3, 32
	add s2, s5, s3
	lw s3, 0(s2)
	mv a0, s4
	mv a1, s3
	jal ra, slot_offset
	mv s2, a0
	mv a0, s1
	li t6, -2212
	add t6, s0, t6
	lw t0, 0(t6)
	mv a1, t0
	li t6, -2208
	add t6, s0, t6
	lw t0, 0(t6)
	mv a2, t0
	mv a3, s2
	jal ra, rv_mc_fsw
	mv s3, a0
	j .L52_182
.L52_181:
	lw s1, -4(s0)
	lw t0, -220(s0)
	li t6, -2220
	add t6, s0, t6
	sw t0, 0(t6)
	li t0, 8
	li t6, -2216
	add t6, s0, t6
	sw t0, 0(t6)
	lw s4, -8(s0)
	lw s5, -12(s0)
	li s3, 32
	add s2, s5, s3
	lw s3, 0(s2)
	mv a0, s4
	mv a1, s3
	jal ra, slot_offset
	mv s2, a0
	mv a0, s1
	li t6, -2220
	add t6, s0, t6
	lw t0, 0(t6)
	mv a1, t0
	li t6, -2216
	add t6, s0, t6
	lw t0, 0(t6)
	mv a2, t0
	mv a3, s2
	jal ra, rv_mc_fsd
	mv s3, a0
.L52_182:
	j .L52_136
.L52_86:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -224(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -228(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -232(s0)
	lw s1, -224(s0)
	bnez s1, .L52_183
	j .L52_184
.L52_183:
	lw s1, -4(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_flw
	mv s5, a0
	j .L52_185
.L52_184:
	lw s1, -4(s0)
	lw s2, -232(s0)
	lw s3, -228(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fld
	mv s5, a0
.L52_185:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -232(s0)
	lw s5, -224(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv t0, a0
	li t6, -2224
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_87:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	sw s1, -236(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -240(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	lw s5, -236(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2228
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2228
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -244(s0)
	lw s1, -236(s0)
	bnez s1, .L52_186
	j .L52_187
.L52_186:
	lw s1, -4(s0)
	lw s2, -244(s0)
	lw s3, -240(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fsw
	mv s5, a0
	j .L52_188
.L52_187:
	lw s1, -4(s0)
	lw s2, -244(s0)
	lw s3, -240(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fsd
	mv s5, a0
.L52_188:
	j .L52_136
.L52_88:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -248(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -252(s0)
	lw s1, -4(s0)
	li s2, 0
	lw s3, -248(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_flw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -252(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_d_s
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -252(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv t0, a0
	li t6, -2232
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_89:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -256(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2236
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2236
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -260(s0)
	lw s1, -4(s0)
	li s2, 0
	lw s3, -260(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_s_d
	mv s4, a0
	lw s1, -4(s0)
	li s2, 0
	lw s3, -256(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fsw
	mv s5, a0
	j .L52_136
.L52_90:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -264(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, frd_w
	mv s4, a0
	sw s4, -268(s0)
	lw s1, -4(s0)
	li s2, 0
	lw s3, -264(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_flh
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -268(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_d_h
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -268(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, fwd_f
	mv t0, a0
	li t6, -2240
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_91:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -272(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2244
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2244
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -276(s0)
	lw s1, -4(s0)
	li s2, 0
	lw s3, -276(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_h_d
	mv s4, a0
	lw s1, -4(s0)
	li s2, 0
	lw s3, -272(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fsh
	mv s5, a0
	j .L52_136
.L52_92:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L52_189
	j .L52_190
.L52_189:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, src_is_f32
	mv s2, a0
	bnez s2, .L52_191
	j .L52_192
.L52_191:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2248
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2248
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -280(s0)
	j .L52_193
.L52_192:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2252
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2252
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -284(s0)
	lw s1, -4(s0)
	li s2, 1
	lw s3, -284(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fcvt_s_d
	mv s4, a0
	li s1, 1
	sw s1, -280(s0)
.L52_193:
	lw s1, -4(s0)
	li s2, 10
	lw s3, -280(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_fmv_x_w
	mv s4, a0
	j .L52_194
.L52_190:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, frs_w
	mv t0, a0
	li t6, -2256
	add t6, s0, t6
	sw t0, 0(t6)
	li t6, -2256
	add t6, s0, t6
	lw t0, 0(t6)
	sw t0, -288(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -288(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_fsd
	mv s5, a0
	lw s1, -4(s0)
	li s2, 10
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 11
	li s3, 2
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
.L52_194:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue
	mv s3, a0
	j .L52_136
.L52_93:
	la s1, narg
	lw s2, 0(s1)
	li s1, 32
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L52_195
	j .L52_196
.L52_195:
	lw s1, -20(s0)
	lw s2, -24(s0)
	la s3, __str_49
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, snprintf
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	li t6, -2340
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2336
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2332
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2328
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2324
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2320
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2316
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2312
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2308
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2304
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2300
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L52_196:
	li s1, 0
	la s2, arg_is_i64
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	li s1, 1
	la s2, arg_is_float
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 4
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	la s2, arg_fw
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, arg_vararg
	la s3, narg
	lw s4, 0(s3)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw t0, 0(s3)
	li t6, -2260
	add t6, s0, t6
	sw t0, 0(t6)
	la s2, arg_temps
	la s3, narg
	lw s4, 0(s3)
	li s5, 1
	add s1, s4, s5
	sw s1, 0(s3)
	li s1, 4
	mul s3, s4, s1
	add s1, s2, s3
	li t6, -2260
	add t6, s0, t6
	lw t1, 0(t6)
	sw t1, 0(s1)
	j .L52_136
.L52_94:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 0
	li s5, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv t0, a0
	li t6, -2264
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_95:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 1
	li s5, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv t0, a0
	li t6, -2268
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_96:
	lw s1, -12(s0)
	li s2, 16
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	sw s10, -296(s0)
	sw s11, -292(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -300(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -304(s0)
	lw s1, -4(s0)
	lw s2, -300(s0)
	lw s10, -296(s0)
	lw s11, -292(s0)
	mv s3, s10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_li
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -304(s0)
	lw s10, -296(s0)
	lw s11, -292(s0)
	li s3, 32
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s3, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	mv s3, s8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_li
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -300(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -304(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_97:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -308(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -312(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -316(s0)
	lw s1, -4(s0)
	lw s2, -316(s0)
	lw s3, -308(s0)
	lw s4, -312(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_add
	mv s5, a0
	lw s1, -4(s0)
	li s2, 5
	lw s3, -316(s0)
	lw s4, -312(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sltu
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -316(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -320(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -324(s0)
	lw s1, -4(s0)
	lw s2, -324(s0)
	lw s3, -320(s0)
	li s4, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_add
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -328(s0)
	lw s1, -4(s0)
	lw s2, -324(s0)
	lw s3, -324(s0)
	lw s4, -328(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_add
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -324(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_98:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -332(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -336(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -340(s0)
	lw s1, -4(s0)
	li s2, 5
	lw s3, -332(s0)
	lw s4, -336(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sltu
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -340(s0)
	lw s3, -332(s0)
	lw s4, -336(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sub
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -340(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -344(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -348(s0)
	lw s1, -4(s0)
	lw s2, -348(s0)
	lw s3, -344(s0)
	li s4, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sub
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -352(s0)
	lw s1, -4(s0)
	lw s2, -348(s0)
	lw s3, -348(s0)
	lw s4, -352(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sub
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -348(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_99:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -356(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -356(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw t0, -4(s0)
	li t6, -2272
	add t6, s0, t6
	sw t0, 0(t6)
	lw s2, -4(s0)
	lw s3, -8(s0)
	lw s4, -12(s0)
	li s5, 8
	add s1, s4, s5
	lw s4, 0(s1)
	li s1, 0
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s1
	jal ra, i64_rs_hi
	mv s5, a0
	li s1, 2
	li s2, 4
	li t6, -2272
	add t6, s0, t6
	lw t0, 0(t6)
	mv a0, t0
	mv a1, s5
	mv a2, s1
	mv a3, s2
	jal ra, rv_mc_sw
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -360(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -360(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw t0, -4(s0)
	li t6, -2276
	add t6, s0, t6
	sw t0, 0(t6)
	lw s2, -4(s0)
	lw s3, -8(s0)
	lw s4, -12(s0)
	li s5, 12
	add s1, s4, s5
	lw s4, 0(s1)
	li s1, 1
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s1
	jal ra, i64_rs_hi
	mv s5, a0
	li s1, 2
	li s2, 4
	li t6, -2276
	add t6, s0, t6
	lw t0, 0(t6)
	mv a0, t0
	mv a1, s5
	mv a2, s1
	mv a3, s2
	jal ra, rv_mc_sw
	mv s3, a0
	lw s1, -4(s0)
	la s2, __str_50
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -364(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -368(s0)
	lw s1, -364(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_197
	j .L52_198
.L52_197:
	lw s1, -4(s0)
	lw s2, -364(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_198:
	lw s1, -368(s0)
	li s2, 11
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_199
	j .L52_200
.L52_199:
	lw s1, -4(s0)
	lw s2, -368(s0)
	li s3, 11
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_200:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -364(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -368(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_100:
.L52_101:
.L52_102:
.L52_103:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 89
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_201
	j .L52_202
.L52_201:
	la s1, __str_51
	sw s1, -376(s0)
	j .L52_203
.L52_202:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 90
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_204
	j .L52_205
.L52_204:
	la s1, __str_52
	sw s1, -380(s0)
	j .L52_206
.L52_205:
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 91
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_207
	j .L52_208
.L52_207:
	la s1, __str_53
	sw s1, -384(s0)
	j .L52_209
.L52_208:
	la s1, __str_54
	sw s1, -384(s0)
.L52_209:
	lw s1, -384(s0)
	sw s1, -380(s0)
.L52_206:
	lw s1, -380(s0)
	sw s1, -376(s0)
.L52_203:
	lw s1, -376(s0)
	sw s1, -372(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -388(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -392(s0)
	lw s1, -4(s0)
	li s2, 10
	lw s3, -388(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	lw s1, -4(s0)
	li s2, 11
	lw s3, -392(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -396(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -400(s0)
	lw s1, -4(s0)
	la s2, argreg
	li s3, 2
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -396(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	lw s1, -4(s0)
	la s2, argreg
	li s3, 3
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -400(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -372(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -404(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -408(s0)
	lw s1, -404(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_210
	j .L52_211
.L52_210:
	lw s1, -4(s0)
	lw s2, -404(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_211:
	lw s1, -408(s0)
	li s2, 11
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_212
	j .L52_213
.L52_212:
	lw s1, -4(s0)
	lw s2, -408(s0)
	li s3, 11
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_213:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -404(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -408(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_104:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -412(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -416(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -420(s0)
	lw s1, -4(s0)
	lw s2, -420(s0)
	lw s3, -412(s0)
	lw s4, -416(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_and
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -420(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -424(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -428(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -432(s0)
	lw s1, -4(s0)
	lw s2, -432(s0)
	lw s3, -424(s0)
	lw s4, -428(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_and
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -432(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_105:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -436(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -440(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -444(s0)
	lw s1, -4(s0)
	lw s2, -444(s0)
	lw s3, -436(s0)
	lw s4, -440(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_or
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -444(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -448(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -452(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -456(s0)
	lw s1, -4(s0)
	lw s2, -456(s0)
	lw s3, -448(s0)
	lw s4, -452(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_or
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -456(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_106:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -460(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -464(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -468(s0)
	lw s1, -4(s0)
	lw s2, -468(s0)
	lw s3, -460(s0)
	lw s4, -464(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -468(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -472(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -476(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -480(s0)
	lw s1, -4(s0)
	lw s2, -480(s0)
	lw s3, -472(s0)
	lw s4, -476(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -480(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_107:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -484(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -488(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -492(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -496(s0)
	lw s1, -4(s0)
	lw s2, -492(s0)
	lw s3, -484(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_neg
	mv s4, a0
	lw s1, -4(s0)
	li s2, 5
	lw s3, -484(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_snez
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -496(s0)
	lw s3, -488(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_neg
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -496(s0)
	lw s3, -496(s0)
	li s4, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sub
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -492(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -496(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_108:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -500(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -504(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -508(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -500(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -504(s0)
	li s3, 2
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 4
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -508(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	la s2, __str_55
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 12
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -512(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -516(s0)
	lw s1, -512(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_214
	j .L52_215
.L52_214:
	lw s1, -4(s0)
	lw s2, -512(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_215:
	lw s1, -516(s0)
	li s2, 11
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_216
	j .L52_217
.L52_216:
	lw s1, -4(s0)
	lw s2, -516(s0)
	li s3, 11
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_217:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -512(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -516(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_109:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -520(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -524(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -528(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -520(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -524(s0)
	li s3, 2
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 4
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -528(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	la s2, __str_56
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 12
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -532(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -536(s0)
	lw s1, -532(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_218
	j .L52_219
.L52_218:
	lw s1, -4(s0)
	lw s2, -532(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_219:
	lw s1, -536(s0)
	li s2, 11
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_220
	j .L52_221
.L52_220:
	lw s1, -4(s0)
	lw s2, -536(s0)
	li s3, 11
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_221:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -532(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -536(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_110:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -540(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -544(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -548(s0)
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 8
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -540(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -544(s0)
	li s3, 2
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 4
	neg s5, s4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s5
	jal ra, rv_mc_addi
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -548(s0)
	li s3, 2
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	la s2, __str_57
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_call
	mv s3, a0
	lw s1, -4(s0)
	li s2, 2
	li s3, 2
	li s4, 12
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addi
	mv s5, a0
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -552(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -556(s0)
	lw s1, -552(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_222
	j .L52_223
.L52_222:
	lw s1, -4(s0)
	lw s2, -552(s0)
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_223:
	lw s1, -556(s0)
	li s2, 11
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_224
	j .L52_225
.L52_224:
	lw s1, -4(s0)
	lw s2, -556(s0)
	li s3, 11
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_225:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -552(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -556(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_111:
.L52_112:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -560(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -564(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -568(s0)
	lw s1, -4(s0)
	li s2, 5
	lw s3, -560(s0)
	lw s4, -564(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -572(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -576(s0)
	lw s1, -4(s0)
	li s2, 6
	lw s3, -572(s0)
	lw s4, -576(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xor
	mv s5, a0
	lw s1, -4(s0)
	li s2, 5
	li s3, 5
	li s4, 6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_or
	mv s5, a0
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 100
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_226
	j .L52_227
.L52_226:
	lw s1, -4(s0)
	lw s2, -568(s0)
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_seqz
	mv s4, a0
	j .L52_228
.L52_227:
	lw s1, -4(s0)
	lw s2, -568(s0)
	li s3, 5
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_snez
	mv s4, a0
.L52_228:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -568(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_113:
.L52_114:
.L52_115:
.L52_116:
.L52_117:
.L52_118:
.L52_119:
.L52_120:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, rv_mc_new_label
	mv s2, a0
	sw s2, -580(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -584(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -588(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -592(s0)
	li s1, 0
	sw s1, -600(s0)
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 102
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_229
	li s1, 104
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_230
	li s1, 106
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_231
	li s1, 108
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_232
	li s1, 103
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_233
	li s1, 105
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_234
	li s1, 107
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_235
	li s1, 109
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_236
	j .L52_237
.L52_229:
	li s1, 1
	sw s1, -596(s0)
	j .L52_238
.L52_230:
	li s1, 1
	sw s1, -596(s0)
	li s1, 1
	sw s1, -600(s0)
	j .L52_238
.L52_231:
	li s1, 0
	sw s1, -596(s0)
	j .L52_238
.L52_232:
	li s1, 0
	sw s1, -596(s0)
	li s1, 1
	sw s1, -600(s0)
	j .L52_238
.L52_233:
	li s1, 1
	sw s1, -596(s0)
	li s1, 1
	sw s1, -600(s0)
	j .L52_238
.L52_234:
	li s1, 1
	sw s1, -596(s0)
	j .L52_238
.L52_235:
	li s1, 0
	sw s1, -596(s0)
	li s1, 1
	sw s1, -600(s0)
	j .L52_238
.L52_236:
	li s1, 0
	sw s1, -596(s0)
	j .L52_238
.L52_237:
	li s1, 0
	sw s1, -596(s0)
	j .L52_238
.L52_238:
	lw s1, -600(s0)
	bnez s1, .L52_239
	j .L52_240
.L52_239:
	lw s1, -584(s0)
	sw s1, -612(s0)
	lw s1, -588(s0)
	sw s1, -584(s0)
	lw s1, -612(s0)
	sw s1, -588(s0)
.L52_240:
	lw s1, -596(s0)
	bnez s1, .L52_241
	j .L52_242
.L52_241:
	lw s1, -4(s0)
	lw s2, -592(s0)
	lw s3, -584(s0)
	lw s4, -588(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_slt
	mv s5, a0
	j .L52_243
.L52_242:
	lw s1, -4(s0)
	lw s2, -592(s0)
	lw s3, -584(s0)
	lw s4, -588(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sltu
	mv s5, a0
.L52_243:
	lw s1, -4(s0)
	lw s2, -584(s0)
	lw s3, -588(s0)
	lw s4, -580(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_bne
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -600(s0)
	bnez s3, .L52_244
	j .L52_245
.L52_244:
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	sw s3, -616(s0)
	j .L52_246
.L52_245:
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	sw s3, -616(s0)
.L52_246:
	lw s3, -616(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -604(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -600(s0)
	bnez s3, .L52_247
	j .L52_248
.L52_247:
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	sw s3, -620(s0)
	j .L52_249
.L52_248:
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	sw s3, -620(s0)
.L52_249:
	lw s3, -620(s0)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -608(s0)
	lw s1, -4(s0)
	lw s2, -592(s0)
	lw s3, -604(s0)
	lw s4, -608(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sltu
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -580(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_label
	mv s3, a0
	lw s1, -12(s0)
	lw s2, 0(s1)
	li s1, 103
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_250
	li s1, 105
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_251
	li s1, 107
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_252
	li s1, 109
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L52_253
	j .L52_254
.L52_250:
.L52_251:
.L52_252:
.L52_253:
	lw s1, -4(s0)
	lw s2, -592(s0)
	lw s3, -592(s0)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_xori
	mv s5, a0
	j .L52_255
.L52_254:
	j .L52_255
.L52_255:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -592(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_121:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -624(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -628(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -632(s0)
	lw s1, -4(s0)
	lw s2, -628(s0)
	lw s3, -624(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -632(s0)
	lw s3, -624(s0)
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -628(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -632(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_122:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -636(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -640(s0)
	lw s1, -4(s0)
	lw s2, -640(s0)
	lw s3, -636(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 12
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -644(s0)
	lw s1, -4(s0)
	lw s2, -644(s0)
	lw s3, -636(s0)
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	j .L52_136
.L52_123:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, slot_offset
	mv s3, a0
	sw s3, -648(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -652(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -656(s0)
	lw s1, -4(s0)
	lw s2, -652(s0)
	li s3, 8
	lw s4, -648(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_lw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -656(s0)
	li s3, 8
	lw s4, -648(s0)
	li s5, 4
	add t0, s4, s5
	li t6, -2280
	add t6, s0, t6
	sw t0, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2280
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	jal ra, rv_mc_lw
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -652(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -656(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_124:
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, slot_offset
	mv s3, a0
	sw s3, -660(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -664(s0)
	lw s1, -4(s0)
	lw s2, -664(s0)
	li s3, 8
	lw s4, -660(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -668(s0)
	lw s1, -4(s0)
	lw s2, -668(s0)
	li s3, 8
	lw s4, -660(s0)
	li s5, 4
	add t0, s4, s5
	li t6, -2284
	add t6, s0, t6
	sw t0, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	li t6, -2284
	add t6, s0, t6
	lw t0, 0(t6)
	mv a3, t0
	jal ra, rv_mc_sw
	mv s4, a0
	j .L52_136
.L52_125:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -672(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -676(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -680(s0)
	lw s1, -676(s0)
	lw s2, -672(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_256
	j .L52_257
.L52_256:
	lw s1, -4(s0)
	lw s2, -676(s0)
	lw s3, -672(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_257:
	lw s1, -4(s0)
	lw s2, -680(s0)
	lw s3, -676(s0)
	li s4, 31
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_srai
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -676(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -680(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_126:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -684(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_lo
	mv s4, a0
	sw s4, -688(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, i64_rd_hi
	mv s4, a0
	sw s4, -692(s0)
	lw s1, -688(s0)
	lw s2, -684(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_258
	j .L52_259
.L52_258:
	lw s1, -4(s0)
	lw s2, -688(s0)
	lw s3, -684(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_259:
	lw s1, -4(s0)
	lw s2, -692(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_li
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -688(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_lo
	mv s5, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -692(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_wd_hi
	mv s5, a0
	j .L52_136
.L52_127:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -696(s0)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rd
	mv s4, a0
	sw s4, -700(s0)
	lw s1, -700(s0)
	lw s2, -696(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_260
	j .L52_261
.L52_260:
	lw s1, -4(s0)
	lw s2, -700(s0)
	lw s3, -696(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_261:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -700(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, wd
	mv s5, a0
	j .L52_136
.L52_128:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 0
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv t0, a0
	li t6, -2288
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_129:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 1
	li s5, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, emit_call_flush
	mv t0, a0
	li t6, -2292
	add t6, s0, t6
	sw t0, 0(t6)
	j .L52_136
.L52_130:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_lo
	mv s5, a0
	sw s5, -704(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, i64_rs_hi
	mv s5, a0
	sw s5, -708(s0)
	lw s1, -704(s0)
	li s2, 10
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_262
	j .L52_263
.L52_262:
	lw s1, -4(s0)
	li s2, 10
	lw s3, -704(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_263:
	lw s1, -708(s0)
	li s2, 11
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L52_264
	j .L52_265
.L52_264:
	lw s1, -4(s0)
	li s2, 11
	lw s3, -708(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, rv_mc_mv
	mv s4, a0
.L52_265:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue
	mv s3, a0
	j .L52_136
.L52_131:
	addi s1, s0, -1992
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
	li s2, 0
	sw s2, 0(s1)
	lw s1, -8(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1996(s0)
	lw s1, -1996(s0)
	li s2, 64
	slt s3, s2, s1
	bnez s3, .L52_266
	j .L52_267
.L52_266:
	li s1, 64
	sw s1, -1996(s0)
.L52_267:
	li s1, 0
	sw s1, -2000(s0)
.L52_268:
	lw s1, -2000(s0)
	lw s2, -1996(s0)
	slt s3, s1, s2
	bnez s3, .L52_269
	j .L52_270
.L52_269:
	lw s1, -8(s0)
	lw s2, -2000(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_param_words
	mv s3, a0
	addi s1, s0, -1992
	lw s2, -2000(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L52_271:
	addi s1, s0, -2000
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -2000(s0)
	j .L52_268
.L52_270:
	li t0, 8
	li t6, -2296
	add t6, s0, t6
	sw t0, 0(t6)
	addi s2, s0, -1992
	lw s3, -1996(s0)
	addi s4, s0, -1736
	li s5, 1
	neg s1, s5
	mv a0, s2
	mv a1, s3
	mv a2, s4
	mv a3, s1
	jal ra, rv_abi_assign
	mv s5, a0
	li t6, -2296
	add t6, s0, t6
	lw t0, 0(t6)
	add s1, t0, s5
	sw s1, -2004(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rs
	mv s5, a0
	sw s5, -2008(s0)
	lw s1, -4(s0)
	li s2, 5
	li s3, 8
	lw s4, -2004(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_addbig
	mv s5, a0
	lw s1, -4(s0)
	li s2, 5
	lw s3, -2008(s0)
	li s4, 8
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 0
	lw s3, -2008(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 0
	lw s3, -2008(s0)
	li s4, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	lw s1, -4(s0)
	li s2, 0
	lw s3, -2008(s0)
	li s4, 12
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, rv_mc_sw
	mv s5, a0
	j .L52_136
.L52_132:
.L52_133:
	j .L52_136
.L52_134:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 16
	add s4, s2, s3
	lw s10, 0(s4)
	lw s11, 4(s4)
	mv s2, s10
	mv a0, s1
	mv a1, s2
	jal ra, rv_mc_loc
	mv s3, a0
	j .L52_136
.L52_135:
	lw s1, -20(s0)
	lw s2, -24(s0)
	la s3, __str_58
	lw s4, -12(s0)
	lw s5, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s5, 0(sp)
	jal ra, snprintf
	mv s4, a0
	addi sp, sp, 16
	li s1, 1
	neg s2, s1
	mv a0, s2
	li t6, -2340
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2336
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2332
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2328
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2324
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2320
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2316
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2312
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2308
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2304
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2300
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L52_136:
	li s1, 0
	mv a0, s1
	li t6, -2340
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2336
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2332
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2328
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2324
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2320
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2316
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2312
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2308
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2304
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2300
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end52:
	.size emit_insn, .Lfunc_end52-emit_insn

	.text
	.align 2
	.globl rv_select_func
	.type rv_select_func, @function
rv_select_func:
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
	li s1, 0
	sw s1, -32(s0)
	lw s1, -12(s0)
	la s2, g_trap_policy
	sw s1, 0(s2)
	li s1, 0
	la s2, narg
	sw s1, 0(s2)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, compute_used_fregs
	mv s2, a0
	lw s1, -8(s0)
	li s2, 68
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L53_0
	j .L53_1
.L53_0:
	lw s1, -8(s0)
	li s2, 68
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -52(s0)
	j .L53_2
.L53_1:
	li s1, 1
	sw s1, -52(s0)
.L53_2:
	lw s1, -52(s0)
	li s2, 4
	mul s3, s1, s2
	mv a0, s3
	jal ra, malloc
	mv s1, a0
	sw s1, -36(s0)
	lw s1, -36(s0)
	bnez s1, .L53_3
	j .L53_4
.L53_4:
	lw s1, -16(s0)
	lw s2, -20(s0)
	la s3, __str_59
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, snprintf
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L53_3:
	li s1, 0
	sw s1, -48(s0)
.L53_5:
	lw s1, -48(s0)
	lw s2, -8(s0)
	li s3, 68
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L53_6
	j .L53_7
.L53_6:
	li s1, 1
	neg s2, s1
	lw s1, -36(s0)
	lw s3, -48(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	sw s2, 0(s3)
.L53_8:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L53_5
.L53_7:
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L53_9
	j .L53_10
.L53_9:
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -56(s0)
	j .L53_11
.L53_10:
	li s1, 1
	sw s1, -56(s0)
.L53_11:
	lw s1, -56(s0)
	li s2, 4
	mv a0, s1
	mv a1, s2
	jal ra, calloc
	mv s3, a0
	sw s3, -40(s0)
	lw s1, -40(s0)
	bnez s1, .L53_12
	j .L53_13
.L53_13:
	lw s1, -36(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -16(s0)
	lw s2, -20(s0)
	la s3, __str_60
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, snprintf
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L53_12:
	lw s1, -8(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
.L53_14:
	lw s1, -28(s0)
	bnez s1, .L53_15
	j .L53_16
.L53_15:
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L53_17
	j .L53_18
.L53_17:
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	li s3, 64
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L53_19
	j .L53_18
.L53_19:
	lw s1, -28(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, ir_op_is_i64_def
	mv s1, a0
	bnez s1, .L53_20
	j .L53_18
.L53_20:
	li s1, 1
	lw s2, -40(s0)
	lw s3, -28(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
.L53_18:
.L53_21:
	lw s1, -28(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	j .L53_14
.L53_16:
	lw s1, -40(s0)
	la s2, g_is_i64
	sw s1, 0(s2)
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L53_22
	j .L53_23
.L53_22:
	lw s1, -8(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -60(s0)
	j .L53_24
.L53_23:
	li s1, 1
	sw s1, -60(s0)
.L53_24:
	lw s1, -60(s0)
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, calloc
	mv s3, a0
	sw s3, -44(s0)
	lw s1, -44(s0)
	bnez s1, .L53_25
	j .L53_26
.L53_26:
	li s1, 0
	la s2, g_is_i64
	sw s1, 0(s2)
	lw s1, -40(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -36(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -16(s0)
	lw s2, -20(s0)
	la s3, __str_61
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, snprintf
	mv s4, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L53_25:
	lw s1, -8(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ir_classify_f32
	mv s3, a0
	lw s1, -44(s0)
	la s2, g_f32
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_prologue
	mv s3, a0
	lw s1, -8(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
.L53_27:
	lw s1, -28(s0)
	bnez s1, .L53_28
	j .L53_29
.L53_28:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -28(s0)
	lw s4, -36(s0)
	lw s5, -16(s0)
	lw s6, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, emit_insn
	mv s7, a0
	li s1, 0
	xor s2, s7, s1
	snez s2, s2
	bnez s2, .L53_30
	j .L53_31
.L53_30:
	li s1, 0
	la s2, g_is_i64
	sw s1, 0(s2)
	li s1, 0
	la s2, g_f32
	sw s1, 0(s2)
	lw s1, -44(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -40(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -36(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L53_31:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s1, 52
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_32
	j .L53_33
.L53_32:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s1, 53
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_34
	j .L53_33
.L53_34:
	lw s1, -28(s0)
	lw s2, 0(s1)
	li s1, 54
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_35
	j .L53_33
.L53_35:
	lw s1, -28(s0)
	sw s1, -32(s0)
.L53_33:
.L53_36:
	lw s1, -28(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	j .L53_27
.L53_29:
	lw s1, -32(s0)
	bnez s1, .L53_37
	j .L53_38
.L53_37:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 50
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_39
	j .L53_40
.L53_39:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 51
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_41
	j .L53_40
.L53_41:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 121
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_42
	j .L53_40
.L53_42:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 48
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_43
	j .L53_40
.L53_43:
	lw s1, -32(s0)
	lw s2, 0(s1)
	li s1, 49
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L53_38
	j .L53_40
.L53_38:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, emit_epilogue
	mv s3, a0
.L53_40:
	li s1, 0
	la s2, g_is_i64
	sw s1, 0(s2)
	li s1, 0
	la s2, g_f32
	sw s1, 0(s2)
	lw s1, -44(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -40(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -36(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 0
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
.Lfunc_end53:
	.size rv_select_func, .Lfunc_end53-rv_select_func

	.data
	.align 2
__str_61:
	.ascii "rv_select: out of memory\000"
	.align 2
__str_60:
	.ascii "rv_select: out of memory\000"
	.align 2
__str_59:
	.ascii "rv_select: out of memory\000"
	.align 2
__str_58:
	.ascii "rv_select: unhandled op %d\000"
	.align 2
__str_57:
	.ascii "__lshrdi3\000"
	.align 2
__str_56:
	.ascii "__ashrdi3\000"
	.align 2
__str_55:
	.ascii "__ashldi3\000"
	.align 2
__str_54:
	.ascii "__umoddi3\000"
	.align 2
__str_53:
	.ascii "__moddi3\000"
	.align 2
__str_52:
	.ascii "__udivdi3\000"
	.align 2
__str_51:
	.ascii "__divdi3\000"
	.align 2
__str_50:
	.ascii "__muldi3\000"
	.align 2
__str_49:
	.ascii "rv_select: too many args\000"
	.align 2
__str_48:
	.ascii "__cont_resume\000"
	.align 2
__str_47:
	.ascii "__cont_arena_ptr\000"
	.align 2
__str_46:
	.ascii "__cont_capture\000"
	.align 2
__str_45:
	.ascii "__cont_arena_ptr\000"
	.align 2
__str_44:
	.ascii "__cont_mark_sp\000"
	.align 2
__str_43:
	.ascii "rv_select: too many args\000"
	.align 2
__str_42:
	.ascii "rv_select: too many args\000"
	.align 2
__str_41:
	.ascii "rv: asm operand %%%d out of range\000"
	.align 2
__str_40:
	.ascii "rv: too many spilled asm operands\000"
	.align 2
__str_39:
	.ascii "rv: two asm operands pinned to %s\000"
	.align 2
__str_38:
	.ascii "rv: unknown asm register %s\000"
	.align 2
__str_37:
	.ascii "rv: 64-bit asm operand not supported yet\000"
	.align 2
__str_36:
	.ascii "rv: too many asm operands\000"
	.align 2
__str_35:
	.ascii "fp\000"
	.align 2
__str_34:
	.ascii "kp_trap_overflow\000"
	.align 2
__str_33:
	.ascii "kp_trap_overflow\000"
	.align 2
__str_32:
	.ascii "kp_trap_div_zero\000"
	.align 2
	.globl rv_abi_name
rv_abi_name:
	.word __str_0
	.word __str_1
	.word __str_2
	.word __str_3
	.word __str_4
	.word __str_5
	.word __str_6
	.word __str_7
	.word __str_8
	.word __str_9
	.word __str_10
	.word __str_11
	.word __str_12
	.word __str_13
	.word __str_14
	.word __str_15
	.word __str_16
	.word __str_17
	.word __str_18
	.word __str_19
	.word __str_20
	.word __str_21
	.word __str_22
	.word __str_23
	.word __str_24
	.word __str_25
	.word __str_26
	.word __str_27
	.word __str_28
	.word __str_29
	.word __str_30
	.word __str_31
	.align 2
__str_31:
	.ascii "t6\000"
	.align 2
__str_30:
	.ascii "t5\000"
	.align 2
__str_29:
	.ascii "t4\000"
	.align 2
__str_28:
	.ascii "t3\000"
	.align 2
__str_27:
	.ascii "s11\000"
	.align 2
__str_26:
	.ascii "s10\000"
	.align 2
__str_25:
	.ascii "s9\000"
	.align 2
__str_24:
	.ascii "s8\000"
	.align 2
__str_23:
	.ascii "s7\000"
	.align 2
__str_22:
	.ascii "s6\000"
	.align 2
__str_21:
	.ascii "s5\000"
	.align 2
__str_20:
	.ascii "s4\000"
	.align 2
__str_19:
	.ascii "s3\000"
	.align 2
__str_18:
	.ascii "s2\000"
	.align 2
__str_17:
	.ascii "a7\000"
	.align 2
__str_16:
	.ascii "a6\000"
	.align 2
__str_15:
	.ascii "a5\000"
	.align 2
__str_14:
	.ascii "a4\000"
	.align 2
__str_13:
	.ascii "a3\000"
	.align 2
__str_12:
	.ascii "a2\000"
	.align 2
__str_11:
	.ascii "a1\000"
	.align 2
__str_10:
	.ascii "a0\000"
	.align 2
__str_9:
	.ascii "s1\000"
	.align 2
__str_8:
	.ascii "s0\000"
	.align 2
__str_7:
	.ascii "t2\000"
	.align 2
__str_6:
	.ascii "t1\000"
	.align 2
__str_5:
	.ascii "t0\000"
	.align 2
__str_4:
	.ascii "tp\000"
	.align 2
__str_3:
	.ascii "gp\000"
	.align 2
__str_2:
	.ascii "sp\000"
	.align 2
__str_1:
	.ascii "ra\000"
	.align 2
__str_0:
	.ascii "zero\000"

	.section .rodata
	.align 2
emit_asm_ext.pool.0:
	.word 5
	.word 6
	.word 7
	.word 28
	.word 29
	.word 30
	.align 2
	.globl argreg
argreg:
	.word 10
	.word 11
	.word 12
	.word 13
	.word 14
	.word 15
	.word 16
	.word 17
	.align 2
	.globl freg
freg:
	.word 0
	.word 1
	.word 8
	.word 9
	.word 18
	.word 19
	.word 20
	.word 21
	.word 22
	.word 23
	.word 24
	.word 25
	.word 26
	.word 27
	.align 2
	.globl reg
reg:
	.word 5
	.word 6
	.word 9
	.word 18
	.word 19
	.word 20
	.word 21
	.word 22
	.word 23
	.word 24
	.word 25
	.word 26
	.word 27

	.bss
	.align 2
	.globl n_used_fregs
n_used_fregs:
	.space 4
	.align 2
	.globl used_fregs
used_fregs:
	.space 48
	.align 2
	.globl narg
narg:
	.space 4
	.align 2
	.globl arg_vararg
arg_vararg:
	.space 128
	.align 2
	.globl arg_fw
arg_fw:
	.space 128
	.align 2
	.globl arg_is_float
arg_is_float:
	.space 128
	.align 2
	.globl arg_is_i64
arg_is_i64:
	.space 128
	.align 2
	.globl arg_temps
arg_temps:
	.space 128
	.align 2
	.globl g_trap_policy
g_trap_policy:
	.space 4
	.align 2
	.globl g_f32
g_f32:
	.space 4
	.align 2
	.globl g_is_i64
g_is_i64:
	.space 4
