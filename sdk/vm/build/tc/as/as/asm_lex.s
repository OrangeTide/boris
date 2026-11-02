# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl lex_init
	.type lex_init, @function
lex_init:
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
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 12
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -12
	lb s2, 0(s1)
	lw s1, -4(s0)
	li s3, 44
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 52
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 56
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 64
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 324
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
.Lfunc_end1:
	.size lex_init, .Lfunc_end1-lex_init

	.text
	.align 2
	.globl lex_rewind
	.type lex_rewind, @function
lex_rewind:
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
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 12
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 324
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
	.size lex_rewind, .Lfunc_end2-lex_rewind

	.text
	.align 2
	.globl lex_restore
	.type lex_restore, @function
lex_restore:
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
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	lw s1, -8(s0)
	lw s2, -4(s0)
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
	lw s3, 0(s4)
	li s4, 52
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 56
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 56
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 60
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 60
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 64
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 64
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 68
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 68
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 72
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 72
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 76
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 76
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 80
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 80
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 84
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 84
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 88
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 88
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 92
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 92
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 96
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 96
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 100
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 100
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 104
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 104
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 108
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 108
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 112
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 112
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 116
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 116
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 120
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 120
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 124
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 124
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 128
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 128
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 132
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 132
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 136
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 136
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 140
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 140
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 144
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 144
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 148
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 148
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 152
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 152
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 156
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 156
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 160
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 160
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 164
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 164
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 168
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 168
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 172
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 172
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 176
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 176
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 180
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 180
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 184
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 184
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 188
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 188
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 192
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 192
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 196
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 196
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 200
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 200
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 204
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 204
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 208
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 208
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 212
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 212
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 216
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 216
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 220
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 220
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 224
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 224
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 228
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 228
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 232
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 232
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 236
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 236
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 240
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 240
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 244
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 244
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 248
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 248
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 252
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 252
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 256
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 256
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 260
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 260
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 264
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 264
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 268
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 268
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 272
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 272
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 276
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 276
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 280
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 280
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 284
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 284
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 288
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 288
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 292
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 292
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 296
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 296
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 300
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 300
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 304
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 304
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 308
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 308
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 312
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 312
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 316
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 316
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 320
	add s4, s1, s3
	lw s3, 0(s4)
	li s4, 320
	add s5, s2, s4
	sw s3, 0(s5)
	li s3, 324
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 324
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -4(s0)
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
.Lfunc_end3:
	.size lex_restore, .Lfunc_end3-lex_restore

	.text
	.align 2
	.type dir_of, @function
dir_of:
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
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, strrchr
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	la s1, __str_0
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
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	lw s4, -8(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, arena_strndup
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
.Lfunc_end4:
	.size dir_of, .Lfunc_end4-dir_of

	.text
	.align 2
	.globl lex_set_source_path
	.type lex_set_source_path, @function
lex_set_source_path:
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
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, dir_of
	mv s3, a0
	lw s1, -4(s0)
	li s2, 64
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 60
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
.Lfunc_end5:
	.size lex_set_source_path, .Lfunc_end5-lex_set_source_path

	.text
	.align 2
	.globl lex_include
	.type lex_include, @function
lex_include:
	addi sp, sp, -1104
	sw ra, 1100(sp)
	sw s0, 1096(sp)
	addi s0, sp, 1096
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
	li s2, 324
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_0
	j .L6_1
.L6_0:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L6_1:
	lw s1, -8(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_2
	j .L6_3
.L6_3:
	lw s1, -4(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_2
	j .L6_4
.L6_4:
	lw s1, -4(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_2
	j .L6_5
.L6_2:
	addi s1, s0, -1032
	li s2, 1024
	la s3, __str_1
	lw s4, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	li s1, 1024
	sltu s2, s5, s1
	xori s2, s2, 1
	bnez s2, .L6_6
	j .L6_7
.L6_6:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L6_7:
	j .L6_8
.L6_5:
	addi s1, s0, -1032
	li s2, 1024
	la s3, __str_2
	lw s4, -4(s0)
	li s5, 60
	add s6, s4, s5
	lw s4, 0(s6)
	lw s5, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	sw s5, 4(sp)
	jal ra, snprintf
	mv s6, a0
	addi sp, sp, 16
	li s1, 1024
	sltu s2, s6, s1
	xori s2, s2, 1
	bnez s2, .L6_9
	j .L6_10
.L6_9:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L6_10:
.L6_8:
	addi s1, s0, -1032
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -1048(s0)
	lw s1, -1048(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_11
	j .L6_12
.L6_11:
	lw s1, -8(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L6_13
	j .L6_12
.L6_13:
	addi s1, s0, -1032
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L6_14
	j .L6_12
.L6_14:
	addi s1, s0, -1032
	li s2, 1024
	la s3, __str_4
	lw s4, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	sw s4, 0(sp)
	jal ra, snprintf
	mv s5, a0
	addi sp, sp, 16
	li s1, 1024
	sltu s2, s5, s1
	bnez s2, .L6_15
	j .L6_16
.L6_15:
	addi s1, s0, -1032
	la s2, __str_5
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -1048(s0)
.L6_16:
.L6_12:
	lw s1, -1048(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L6_17
	j .L6_18
.L6_17:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L6_18:
	lw s1, -1048(s0)
	li s2, 0
	li s3, 2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, fseek
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	snez s2, s2
	bnez s2, .L6_19
	j .L6_20
.L6_19:
	lw s1, -1048(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L6_20:
	lw s1, -1048(s0)
	mv a0, s1
	jal ra, ftell
	mv s2, a0
	sw s2, -1040(s0)
	lw s1, -1040(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L6_21
	j .L6_22
.L6_22:
	lw s1, -1040(s0)
	li s2, 1
	li s3, 22
	sll s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L6_21
	j .L6_23
.L6_21:
	lw s1, -1048(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L6_23:
	lw s1, -1048(s0)
	mv a0, s1
	jal ra, rewind
	mv s2, a0
	lw s1, -4(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1040(s0)
	li s3, 1
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, arena_alloc
	mv s2, a0
	sw s2, -1036(s0)
	lw s1, -1036(s0)
	li s2, 1
	lw s3, -1040(s0)
	lw s4, -1048(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fread
	mv s5, a0
	sw s5, -1044(s0)
	lw s1, -1048(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	li s1, 0
	lw s2, -1036(s0)
	lw s3, -1044(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 68
	add s4, s1, s3
	lw s1, -4(s0)
	li s3, 324
	add s5, s1, s3
	lw s1, 0(s5)
	li s3, 16
	mul s5, s1, s3
	add s1, s4, s5
	sw s2, 0(s1)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 68
	add s4, s2, s3
	lw s2, -4(s0)
	li s3, 324
	add s5, s2, s3
	lw s2, 0(s5)
	li s3, 16
	mul s5, s2, s3
	add s2, s4, s5
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 68
	add s4, s2, s3
	lw s2, -4(s0)
	li s3, 324
	add s5, s2, s3
	lw s2, 0(s5)
	li s3, 16
	mul s5, s2, s3
	add s2, s4, s5
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 60
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 68
	add s4, s2, s3
	lw s2, -4(s0)
	li s3, 324
	add s5, s2, s3
	lw s2, 0(s5)
	li s3, 16
	mul s5, s2, s3
	add s2, s4, s5
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 324
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -1036(s0)
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -1036(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -1032
	mv a0, s1
	mv a1, s2
	jal ra, dir_of
	mv s3, a0
	lw s1, -4(s0)
	li s2, 60
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 0
	mv a0, s1
	lw s1, -1092(s0)
	lw s2, -1088(s0)
	lw s3, -1084(s0)
	lw s4, -1080(s0)
	lw s5, -1076(s0)
	lw s6, -1072(s0)
	lw s7, -1068(s0)
	lw s8, -1064(s0)
	lw s9, -1060(s0)
	lw s10, -1056(s0)
	lw s11, -1052(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end6:
	.size lex_include, .Lfunc_end6-lex_include

	.text
	.align 2
	.type str_buf_push, @function
str_buf_push:
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
	lw s1, -8(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 36
	add s4, s1, s3
	lw s1, 0(s4)
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L7_0
	j .L7_1
.L7_0:
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L7_2
	j .L7_3
.L7_2:
	lw s1, -4(s0)
	li s2, 36
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -20(s0)
	j .L7_4
.L7_3:
	li s1, 64
	sw s1, -20(s0)
.L7_4:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 36
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, realloc
	mv s3, a0
	lw s1, -4(s0)
	li s2, 32
	add s4, s1, s2
	sw s3, 0(s4)
.L7_1:
	addi s1, s0, -12
	lb s2, 0(s1)
	lw s1, -4(s0)
	li s3, 32
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -8(s0)
	lw s4, 0(s3)
	li s5, 1
	add s6, s4, s5
	sw s6, 0(s3)
	add s3, s1, s4
	sb s2, 0(s3)
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
	.size str_buf_push, .Lfunc_end7-str_buf_push

	.text
	.align 2
	.type skip_line_comment, @function
skip_line_comment:
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
.L8_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L8_1
	j .L8_2
.L8_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L8_3
	j .L8_2
.L8_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L8_0
.L8_2:
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
	.size skip_line_comment, .Lfunc_end8-skip_line_comment

	.text
	.align 2
	.type lex_string, @function
lex_string:
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
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L9_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L9_1
	j .L9_2
.L9_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L9_3
	j .L9_2
.L9_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_4
	j .L9_5
.L9_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_6
	j .L9_7
.L9_6:
	j .L9_2
.L9_7:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 110
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_8
	li s1, 116
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_9
	li s1, 114
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_10
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_11
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_12
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_13
	li s1, 49
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_14
	li s1, 50
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_15
	li s1, 51
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_16
	li s1, 52
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_17
	li s1, 53
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_18
	li s1, 54
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_19
	li s1, 55
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_20
	j .L9_21
.L9_8:
	lw s1, -4(s0)
	addi s2, s0, -12
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_buf_push
	mv s4, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L9_22
.L9_9:
	lw s1, -4(s0)
	addi s2, s0, -12
	li s3, 9
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_buf_push
	mv s4, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L9_22
.L9_10:
	lw s1, -4(s0)
	addi s2, s0, -12
	li s3, 13
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_buf_push
	mv s4, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L9_22
.L9_11:
	lw s1, -4(s0)
	addi s2, s0, -12
	li s3, 92
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_buf_push
	mv s4, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L9_22
.L9_12:
	lw s1, -4(s0)
	addi s2, s0, -12
	li s3, 34
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_buf_push
	mv s4, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L9_22
.L9_13:
.L9_14:
.L9_15:
.L9_16:
.L9_17:
.L9_18:
.L9_19:
.L9_20:
	li s1, 0
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
.L9_23:
	lw s1, -20(s0)
	li s2, 3
	slt s3, s1, s2
	bnez s3, .L9_24
	j .L9_25
.L9_24:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 48
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L9_26
	j .L9_25
.L9_26:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 55
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L9_27
	j .L9_25
.L9_27:
	lw s1, -16(s0)
	li s2, 8
	mul s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	lb s2, 0(s1)
	li s1, 48
	sub s4, s2, s1
	add s1, s3, s4
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L9_28:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L9_23
.L9_25:
	lw s1, -4(s0)
	addi s2, s0, -12
	lw s3, -16(s0)
	li s4, 24
	sll s5, s3, s4
	li s3, 24
	sra s4, s5, s3
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, str_buf_push
	mv s3, a0
	j .L9_22
.L9_21:
	lw s1, -4(s0)
	addi s2, s0, -12
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lb s4, 0(s3)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, str_buf_push
	mv s3, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L9_22
.L9_22:
	j .L9_29
.L9_5:
	lw s1, -4(s0)
	addi s2, s0, -12
	lw s3, -4(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lb s4, 0(s3)
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, str_buf_push
	mv s3, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L9_29:
	j .L9_0
.L9_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L9_30
	j .L9_31
.L9_30:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L9_31:
	lw s1, -4(s0)
	addi s2, s0, -12
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, str_buf_push
	mv s4, a0
	li s1, 3
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 8
	add s3, s4, s2
	sw s1, 0(s3)
	lw s1, -12(s0)
	li s2, 1
	sub s3, s1, s2
	lw s1, -4(s0)
	li s2, 12
	add s4, s1, s2
	li s1, 12
	add s2, s4, s1
	sw s3, 0(s2)
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
.Lfunc_end9:
	.size lex_string, .Lfunc_end9-lex_string

	.text
	.align 2
	.type is_ident_char, @function
is_ident_char:
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
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isalnum
	mv s1, a0
	bnez s1, .L10_0
	j .L10_1
.L10_1:
	addi s1, s0, -4
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L10_0
	j .L10_2
.L10_0:
	li s1, 1
	j .L10_3
.L10_2:
	li s1, 0
.L10_3:
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
	.size is_ident_char, .Lfunc_end10-is_ident_char

	.text
	.align 2
	.type lex_ident, @function
lex_ident:
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
	bnez s1, .L11_0
	j .L11_1
.L11_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	sub s3, s1, s2
	sw s3, -12(s0)
	j .L11_2
.L11_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
.L11_2:
.L11_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, is_ident_char
	mv s1, a0
	bnez s1, .L11_4
	j .L11_5
.L11_5:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_4
	j .L11_6
.L11_6:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L11_7
	j .L11_8
.L11_7:
	lw s1, -4(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L11_8
	j .L11_4
.L11_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L11_3
.L11_8:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	sub s3, s1, s2
	sw s3, -16(s0)
	lw s1, -8(s0)
	bnez s1, .L11_9
	j .L11_10
.L11_9:
	li s1, 1
	sw s1, -20(s0)
	j .L11_11
.L11_10:
	li s1, 0
	sw s1, -20(s0)
.L11_11:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	sw s4, 0(s2)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 12
	add s3, s4, s2
	sw s1, 0(s3)
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
.Lfunc_end11:
	.size lex_ident, .Lfunc_end11-lex_ident

	.text
	.align 2
	.type lex_number, @function
lex_number:
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
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 48
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_0
	j .L12_1
.L12_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 120
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_2
	j .L12_3
.L12_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L12_2
	j .L12_1
.L12_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -12
	li s3, 16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoull
	mv s10, a0
	mv s11, a1
	mv s1, s10
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 16
	add s3, s4, s2
	sw s1, 0(s3)
	j .L12_4
.L12_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -12
	li s3, 10
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strtoull
	mv s10, a0
	mv s11, a1
	mv s1, s10
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 16
	add s3, s4, s2
	sw s1, 0(s3)
.L12_4:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
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
.Lfunc_end12:
	.size lex_number, .Lfunc_end12-lex_number

	.text
	.align 2
	.type lex_char, @function
lex_char:
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
	li s1, 2
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_0
	j .L13_1
.L13_0:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 110
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_2
	li s1, 116
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_3
	li s1, 114
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_4
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_5
	li s1, 98
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_6
	li s1, 102
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_7
	li s1, 118
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_8
	li s1, 97
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_9
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_10
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_11
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_12
	j .L13_13
.L13_2:
	li s1, 10
	sw s1, -12(s0)
	j .L13_14
.L13_3:
	li s1, 9
	sw s1, -12(s0)
	j .L13_14
.L13_4:
	li s1, 13
	sw s1, -12(s0)
	j .L13_14
.L13_5:
	li s1, 0
	sw s1, -12(s0)
	j .L13_14
.L13_6:
	li s1, 8
	sw s1, -12(s0)
	j .L13_14
.L13_7:
	li s1, 12
	sw s1, -12(s0)
	j .L13_14
.L13_8:
	li s1, 11
	sw s1, -12(s0)
	j .L13_14
.L13_9:
	li s1, 7
	sw s1, -12(s0)
	j .L13_14
.L13_10:
	li s1, 92
	sw s1, -12(s0)
	j .L13_14
.L13_11:
	li s1, 39
	sw s1, -12(s0)
	j .L13_14
.L13_12:
	li s1, 34
	sw s1, -12(s0)
	j .L13_14
.L13_13:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	sw s3, -12(s0)
	j .L13_14
.L13_14:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L13_15
	j .L13_16
.L13_15:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L13_16:
	j .L13_17
.L13_1:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L13_18
	j .L13_19
.L13_18:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	sw s3, -12(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L13_19:
.L13_17:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_20
	j .L13_21
.L13_20:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L13_21:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 16
	add s3, s4, s2
	sw s1, 0(s3)
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
.Lfunc_end13:
	.size lex_char, .Lfunc_end13-lex_char

	.text
	.align 2
	.globl lex_next
	.type lex_next, @function
lex_next:
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
.L14_0:
	j .L14_1
.L14_1:
.L14_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_3
	j .L14_4
.L14_4:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_3
	j .L14_5
.L14_3:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L14_2
.L14_5:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 4
	add s3, s4, s2
	sw s1, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_6
	j .L14_7
.L14_6:
	lw s1, -4(s0)
	li s2, 324
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L14_8
	j .L14_9
.L14_8:
	lw s1, -4(s0)
	li s2, 324
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, -1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 68
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 324
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	lw s1, -4(s0)
	sw s2, 0(s1)
	lw s1, -4(s0)
	li s2, 68
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 324
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 68
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 324
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 68
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 324
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -4(s0)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	j .L14_10
.L14_9:
	li s1, 13
	lw s2, -4(s0)
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
.L14_7:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_11
	j .L14_12
.L14_11:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 12
	lw s2, -4(s0)
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
.L14_12:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	lw s1, -4(s0)
	li s3, 44
	add s4, s1, s3
	lb s1, 0(s4)
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_13
	j .L14_14
.L14_13:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, skip_line_comment
	mv s2, a0
	j .L14_10
.L14_14:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_15
	j .L14_16
.L14_15:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_17
	j .L14_16
.L14_17:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, skip_line_comment
	mv s2, a0
	j .L14_10
.L14_16:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_18
	j .L14_19
.L14_18:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_20
	j .L14_19
.L14_20:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	add s4, s1, s2
	sw s4, 0(s3)
.L14_21:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L14_22
	j .L14_23
.L14_22:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_24
	j .L14_25
.L14_24:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_23
	j .L14_25
.L14_25:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_26
	j .L14_27
.L14_26:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L14_27:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L14_21
.L14_23:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L14_28
	j .L14_29
.L14_28:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	add s4, s1, s2
	sw s4, 0(s3)
.L14_29:
	j .L14_10
.L14_19:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_30
	j .L14_31
.L14_30:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_string
	mv s2, a0
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
.L14_31:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_32
	j .L14_33
.L14_32:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, is_ident_char
	mv s1, a0
	bnez s1, .L14_34
	j .L14_35
.L14_34:
	lw s1, -4(s0)
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, lex_ident
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
.L14_35:
	li s1, 1
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, __str_6
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 8
	add s3, s4, s2
	sw s1, 0(s3)
	li s1, 1
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 12
	add s3, s4, s2
	sw s1, 0(s3)
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
.L14_33:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isalpha
	mv s1, a0
	bnez s1, .L14_36
	j .L14_37
.L14_37:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 95
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_36
	j .L14_38
.L14_36:
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, lex_ident
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
.L14_38:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	mv a0, s3
	jal ra, isdigit
	mv s1, a0
	bnez s1, .L14_39
	j .L14_40
.L14_39:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_number
	mv s2, a0
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 98
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_41
	j .L14_42
.L14_42:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 102
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_41
	j .L14_43
.L14_41:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	mv a0, s1
	jal ra, is_ident_char
	mv s2, a0
	bnez s2, .L14_43
	j .L14_44
.L14_44:
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, lex_ident
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
.L14_43:
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
.L14_40:
	lw s1, -4(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_45
	j .L14_46
.L14_45:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_47
	j .L14_46
.L14_47:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
.L14_48:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	mv a0, s2
	jal ra, is_ident_char
	mv s1, a0
	bnez s1, .L14_49
	j .L14_50
.L14_49:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L14_48
.L14_50:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	sub s3, s1, s2
	sw s3, -20(s0)
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -16(s0)
	lw s3, -20(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 8
	add s2, s3, s1
	sw s4, 0(s2)
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	li s2, 12
	add s3, s4, s2
	sw s1, 0(s3)
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
.L14_46:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_51
	j .L14_52
.L14_51:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, lex_char
	mv s2, a0
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
.L14_52:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_53
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_54
	li s1, 58
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_55
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_56
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_57
	li s1, 91
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_58
	li s1, 93
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_59
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_60
	li s1, 61
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_61
	li s1, 64
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_62
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_63
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_64
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_65
	j .L14_66
.L14_53:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 4
	lw s2, -4(s0)
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
.L14_54:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 5
	lw s2, -4(s0)
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
.L14_55:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 6
	lw s2, -4(s0)
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
.L14_56:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 7
	lw s2, -4(s0)
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
.L14_57:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 8
	lw s2, -4(s0)
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
.L14_58:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 14
	lw s2, -4(s0)
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
.L14_59:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 15
	lw s2, -4(s0)
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
.L14_60:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 16
	lw s2, -4(s0)
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
.L14_61:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 17
	lw s2, -4(s0)
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
.L14_62:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 18
	lw s2, -4(s0)
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
.L14_63:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 9
	lw s2, -4(s0)
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
.L14_64:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	li s1, 10
	lw s2, -4(s0)
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
.L14_65:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L14_67
	j .L14_68
.L14_67:
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, lex_ident
	mv s3, a0
	li s1, 11
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	j .L14_69
.L14_68:
	lw s1, -4(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, lex_ident
	mv s3, a0
.L14_69:
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
.L14_66:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s4, s1, s2
	sw s4, 0(s3)
	j .L14_10
.L14_70:
.L14_10:
	j .L14_0
.L14_71:
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
	.size lex_next, .Lfunc_end14-lex_next

	.data
	.align 2
__str_6:
	.ascii ".\000"
	.align 2
__str_5:
	.ascii "rb\000"
	.align 2
__str_4:
	.ascii "%s\000"
	.align 2
__str_3:
	.ascii "rb\000"
	.align 2
__str_2:
	.ascii "%s/%s\000"
	.align 2
__str_1:
	.ascii "%s\000"
	.align 2
__str_0:
	.ascii "\000"
