# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type peek, @function
peek:
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
	sw a0, -4(s0)
	la s1, have_cur
	lw s2, 0(s1)
	bnez s2, .L1_0
	j .L1_1
.L1_0:
	la s1, cur
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L1_1:
	addi s1, s0, -72
	mv a0, s1
	jal ra, cc_lex_peek
	mv s2, a0
	addi s1, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end1:
	.size peek, .Lfunc_end1-peek

	.text
	.align 2
	.type next, @function
next:
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
	sw a0, -4(s0)
	la s1, have_cur
	lw s2, 0(s1)
	bnez s2, .L2_0
	j .L2_1
.L2_0:
	li s1, 0
	la s2, have_cur
	sw s1, 0(s2)
	la s1, cur
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L2_1:
	addi s1, s0, -72
	mv a0, s1
	jal ra, cc_lex_next
	mv s2, a0
	addi s1, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end2:
	.size next, .Lfunc_end2-next

	.text
	.align 2
	.type ungettok, @function
ungettok:
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
	sw a0, -4(s0)
	lw s1, -4(s0)
	addi s2, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	la s2, cur
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	la s2, have_cur
	sw s1, 0(s2)
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size ungettok, .Lfunc_end3-ungettok

	.text
	.align 2
	.type expect, @function
expect:
	addi sp, sp, -224
	sw ra, 220(sp)
	sw s0, 216(sp)
	addi s0, sp, 216
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
	addi s1, s0, -136
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -136
	addi s2, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	lw s2, 0(s1)
	lw s1, -8(s0)
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L4_0
	j .L4_1
.L4_0:
	addi s1, s0, -72
	lw s2, 0(s1)
	mv a0, s2
	jal ra, cc_tok_name
	mv s1, a0
	sw s1, -140(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, cc_tok_name
	mv s2, a0
	sw s2, -144(s0)
	addi s1, s0, -72
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, cc_lex_print_context
	mv s3, a0
	addi s1, s0, -72
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L4_2
	j .L4_3
.L4_2:
	addi s1, s0, -72
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lb s2, 0(s1)
	bnez s2, .L4_4
	j .L4_3
.L4_4:
	la s1, __str_0
	addi s2, s0, -72
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	jal ra, cc_lex_file
	mv s3, a0
	lw s4, -140(s0)
	bnez s4, .L4_5
	j .L4_6
.L4_5:
	lw s4, -140(s0)
	sw s4, -148(s0)
	j .L4_7
.L4_6:
	la s4, __str_1
	sw s4, -148(s0)
.L4_7:
	lw s4, -148(s0)
	addi s5, s0, -72
	lw s6, 0(s5)
	addi s5, s0, -72
	li s7, 24
	add s8, s5, s7
	lw s5, 0(s8)
	lw s7, -144(s0)
	bnez s7, .L4_8
	j .L4_9
.L4_8:
	lw s7, -144(s0)
	sw s7, -152(s0)
	j .L4_10
.L4_9:
	la s7, __str_2
	sw s7, -152(s0)
.L4_10:
	lw s7, -152(s0)
	lw s8, -8(s0)
	addi sp, sp, -32
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	sw s4, 8(sp)
	sw s6, 12(sp)
	sw s5, 16(sp)
	sw s7, 20(sp)
	sw s8, 24(sp)
	jal ra, die
	mv s9, a0
	addi sp, sp, 32
.L4_3:
	la s1, __str_3
	addi s2, s0, -72
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	jal ra, cc_lex_file
	mv s3, a0
	lw s4, -140(s0)
	bnez s4, .L4_11
	j .L4_12
.L4_11:
	lw s4, -140(s0)
	sw s4, -156(s0)
	j .L4_13
.L4_12:
	la s4, __str_4
	sw s4, -156(s0)
.L4_13:
	lw s4, -156(s0)
	addi s5, s0, -72
	lw s6, 0(s5)
	lw s5, -144(s0)
	bnez s5, .L4_14
	j .L4_15
.L4_14:
	lw s5, -144(s0)
	sw s5, -160(s0)
	j .L4_16
.L4_15:
	la s5, __str_5
	sw s5, -160(s0)
.L4_16:
	lw s5, -160(s0)
	lw s7, -8(s0)
	addi sp, sp, -32
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	sw s4, 8(sp)
	sw s6, 12(sp)
	sw s5, 16(sp)
	sw s7, 20(sp)
	jal ra, die
	mv s8, a0
	addi sp, sp, 32
.L4_1:
	addi s1, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	mv a0, s2
	lw s1, -204(s0)
	lw s2, -200(s0)
	lw s3, -196(s0)
	lw s4, -192(s0)
	lw s5, -188(s0)
	lw s6, -184(s0)
	lw s7, -180(s0)
	lw s8, -176(s0)
	lw s9, -172(s0)
	lw s10, -168(s0)
	lw s11, -164(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end4:
	.size expect, .Lfunc_end4-expect

	.text
	.align 2
	.type consume, @function
consume:
	addi sp, sp, -256
	sw ra, 252(sp)
	sw s0, 248(sp)
	addi s0, sp, 248
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
	addi s1, s0, -136
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -136
	addi s2, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	lw s2, 0(s1)
	lw s1, -4(s0)
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L5_0
	j .L5_1
.L5_0:
	addi s1, s0, -200
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -200
	li s1, 1
	mv a0, s1
	lw s1, -244(s0)
	lw s2, -240(s0)
	lw s3, -236(s0)
	lw s4, -232(s0)
	lw s5, -228(s0)
	lw s6, -224(s0)
	lw s7, -220(s0)
	lw s8, -216(s0)
	lw s9, -212(s0)
	lw s10, -208(s0)
	lw s11, -204(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L5_1:
	li s1, 0
	mv a0, s1
	lw s1, -244(s0)
	lw s2, -240(s0)
	lw s3, -236(s0)
	lw s4, -232(s0)
	lw s5, -228(s0)
	lw s6, -224(s0)
	lw s7, -220(s0)
	lw s8, -216(s0)
	lw s9, -212(s0)
	lw s10, -208(s0)
	lw s11, -204(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end5:
	.size consume, .Lfunc_end5-consume

	.text
	.align 2
	.type node, @function
node:
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
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 104
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	li s3, 104
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -4(s0)
	lw s2, -12(s0)
	sw s1, 0(s2)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, cc_lex_col
	mv s1, a0
	lw s2, -12(s0)
	li s3, 12
	add s4, s2, s3
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
.Lfunc_end6:
	.size node, .Lfunc_end6-node

	.text
	.align 2
	.type push_scope, @function
push_scope:
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
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 8
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -4(s0)
	li s1, 0
	lw s2, -4(s0)
	sw s1, 0(s2)
	la s1, cur_scope
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	la s2, cur_scope
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
.Lfunc_end7:
	.size push_scope, .Lfunc_end7-push_scope

	.text
	.align 2
	.type pop_scope, @function
pop_scope:
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
	la s1, cur_scope
	lw s2, 0(s1)
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	la s2, cur_scope
	sw s1, 0(s2)
	li s1, 0
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
.Lfunc_end8:
	.size pop_scope, .Lfunc_end8-pop_scope

	.text
	.align 2
	.type add_sym, @function
add_sym:
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
	bnez s1, .L9_0
	j .L9_1
.L9_1:
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
.L9_0:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 20
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -20(s0)
	la s1, parse_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -20(s0)
	sw s3, 0(s1)
	lw s1, -8(s0)
	lw s2, -20(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -20(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, cur_scope
	lw s2, 0(s1)
	lw s1, 0(s2)
	lw s2, -20(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	la s2, cur_scope
	lw s3, 0(s2)
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
.Lfunc_end9:
	.size add_sym, .Lfunc_end9-add_sym

	.text
	.align 2
	.type find_sym, @function
find_sym:
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
	la s1, cur_scope
	lw s2, 0(s1)
	sw s2, -12(s0)
.L10_0:
	lw s1, -12(s0)
	bnez s1, .L10_1
	j .L10_2
.L10_1:
	lw s1, -12(s0)
	lw s2, 0(s1)
	sw s2, -16(s0)
.L10_3:
	lw s1, -16(s0)
	bnez s1, .L10_4
	j .L10_5
.L10_4:
	lw s1, -16(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L10_6
	j .L10_7
.L10_6:
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
.L10_7:
.L10_8:
	lw s1, -16(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -16(s0)
	j .L10_3
.L10_5:
.L10_9:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L10_0
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
	.size find_sym, .Lfunc_end10-find_sym

	.text
	.align 2
	.type find_tag, @function
find_tag:
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
	bnez s1, .L11_0
	j .L11_1
.L11_1:
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
.L11_0:
	la s1, tags
	lw s2, 0(s1)
	sw s2, -12(s0)
.L11_2:
	lw s1, -12(s0)
	bnez s1, .L11_3
	j .L11_4
.L11_3:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L11_5
	j .L11_6
.L11_5:
	lw s1, -12(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
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
.L11_6:
.L11_7:
	lw s1, -12(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	j .L11_2
.L11_4:
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
.Lfunc_end11:
	.size find_tag, .Lfunc_end11-find_tag

	.text
	.align 2
	.type add_tag, @function
add_tag:
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
	bnez s1, .L12_0
	j .L12_1
.L12_1:
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
.L12_0:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 12
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -12(s0)
	la s1, parse_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -12(s0)
	sw s3, 0(s1)
	lw s1, -8(s0)
	lw s2, -12(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, tags
	lw s2, 0(s1)
	lw s1, -12(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	la s2, tags
	sw s1, 0(s2)
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
	.size add_tag, .Lfunc_end12-add_tag

	.text
	.align 2
	.type is_type_start, @function
is_type_start:
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
	lw s1, -4(s0)
	addi s2, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_0
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_1
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_2
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_3
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_4
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_5
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_6
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_7
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_8
	li s1, 15
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_9
	li s1, 16
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_10
	li s1, 17
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_11
	li s1, 18
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_12
	li s1, 19
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_13
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_14
	li s1, 22
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_15
	li s1, 25
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_16
	li s1, 26
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_17
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_18
	li s1, 28
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_19
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_20
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L13_21
	j .L13_22
.L13_0:
.L13_1:
.L13_2:
.L13_3:
.L13_4:
.L13_5:
.L13_6:
.L13_7:
.L13_8:
.L13_9:
.L13_10:
.L13_11:
.L13_12:
.L13_13:
.L13_14:
.L13_15:
.L13_16:
.L13_17:
.L13_18:
.L13_19:
.L13_20:
	li s1, 1
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
.L13_21:
	addi s1, s0, -72
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_sym
	mv s2, a0
	sw s2, -76(s0)
	lw s1, -76(s0)
	bnez s1, .L13_23
	j .L13_24
.L13_23:
	lw s1, -76(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L13_25
	j .L13_24
.L13_25:
	li s1, 1
	j .L13_26
.L13_24:
	li s1, 0
.L13_26:
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
.L13_22:
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
.L13_27:
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
.Lfunc_end13:
	.size is_type_start, .Lfunc_end13-is_type_start

	.text
	.align 2
	.type parse_fields, @function
parse_fields:
	addi sp, sp, -224
	sw ra, 220(sp)
	sw s0, 216(sp)
	addi s0, sp, 216
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
	sw s1, -4(s0)
	li s1, 0
	sw s1, -8(s0)
.L14_0:
	li s1, 50
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L14_1
	j .L14_2
.L14_2:
	addi s1, s0, -72
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L14_3
	j .L14_4
.L14_3:
	jal ra, parse_static_assert
	mv s1, a0
	j .L14_0
.L14_4:
	li s1, 0
	sw s1, -76(s0)
	li s1, 0
	sw s1, -80(s0)
	addi s1, s0, -76
	addi s2, s0, -80
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -84(s0)
.L14_5:
	j .L14_6
.L14_6:
	li s1, 0
	sw s1, -88(s0)
	lw s1, -84(s0)
	addi s2, s0, -88
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -92(s0)
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 24
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -96(s0)
	lw s1, -96(s0)
	li s2, 0
	li s3, 24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -88(s0)
	lw s2, -96(s0)
	sw s1, 0(s2)
	lw s1, -92(s0)
	lw s2, -96(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 92
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L14_7
	j .L14_8
.L14_7:
	jal ra, parse_assign_expr
	mv s1, a0
	sw s1, -100(s0)
	lw s1, -100(s0)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L14_9
	j .L14_10
.L14_9:
	la s1, __str_6
	lw s2, -100(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L14_10:
	lw s1, -100(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv s1, s10
	lw s2, -96(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -96(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L14_11
	j .L14_12
.L14_11:
	li s1, 1
	neg s2, s1
	lw s1, -96(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
.L14_12:
.L14_8:
	lw s1, -4(s0)
	bnez s1, .L14_13
	j .L14_14
.L14_14:
	lw s1, -96(s0)
	sw s1, -4(s0)
	j .L14_15
.L14_13:
	lw s1, -96(s0)
	lw s2, -8(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
.L14_15:
	lw s1, -96(s0)
	sw s1, -8(s0)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L14_16
	j .L14_17
.L14_17:
	j .L14_18
.L14_16:
.L14_19:
	j .L14_5
.L14_18:
	addi s1, s0, -168
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -168
	j .L14_0
.L14_1:
	lw s1, -4(s0)
	mv a0, s1
	lw s1, -212(s0)
	lw s2, -208(s0)
	lw s3, -204(s0)
	lw s4, -200(s0)
	lw s5, -196(s0)
	lw s6, -192(s0)
	lw s7, -188(s0)
	lw s8, -184(s0)
	lw s9, -180(s0)
	lw s10, -176(s0)
	lw s11, -172(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end14:
	.size parse_fields, .Lfunc_end14-parse_fields

	.text
	.align 2
	.type layout_struct, @function
layout_struct:
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
	li s1, 0
	sw s1, -12(s0)
	li s1, 1
	sw s1, -16(s0)
	li s1, 1
	neg s2, s1
	sw s2, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	li s1, 0
	sw s1, -28(s0)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
.L15_0:
	lw s1, -32(s0)
	bnez s1, .L15_1
	j .L15_2
.L15_1:
	lw s1, -32(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L15_3
	j .L15_4
.L15_3:
	lw s1, -32(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -32(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	sw s2, -40(s0)
	lw s1, -40(s0)
	lw s2, -16(s0)
	slt s3, s2, s1
	bnez s3, .L15_5
	j .L15_6
.L15_5:
	lw s1, -40(s0)
	sw s1, -16(s0)
.L15_6:
	lw s1, -32(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_7
	j .L15_8
.L15_7:
	li s1, 1
	neg s2, s1
	sw s2, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	lw s1, -12(s0)
	lw s2, -40(s0)
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	lw s1, -40(s0)
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	sw s3, -12(s0)
	j .L15_9
.L15_8:
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L15_10
	j .L15_11
.L15_11:
	lw s1, -24(s0)
	lw s2, -32(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	lw s1, -28(s0)
	slt s2, s1, s3
	bnez s2, .L15_10
	j .L15_12
.L15_10:
	lw s1, -12(s0)
	lw s2, -40(s0)
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	lw s1, -40(s0)
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	lw s1, -36(s0)
	li s2, 8
	mul s3, s1, s2
	sw s3, -28(s0)
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -36(s0)
	add s3, s2, s1
	sw s3, -12(s0)
.L15_12:
	lw s1, -20(s0)
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -24(s0)
	lw s2, -32(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -24
	lw s2, 0(s1)
	lw s1, -32(s0)
	li s3, 12
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -24(s0)
	j .L15_13
.L15_4:
	lw s1, -32(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	sw s2, -44(s0)
	lw s1, -44(s0)
	lw s2, -16(s0)
	slt s3, s2, s1
	bnez s3, .L15_14
	j .L15_15
.L15_14:
	lw s1, -44(s0)
	sw s1, -16(s0)
.L15_15:
	li s1, 1
	neg s2, s1
	sw s2, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	lw s1, -12(s0)
	lw s2, -44(s0)
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	lw s1, -44(s0)
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	sw s3, -12(s0)
	lw s1, -12(s0)
	lw s2, -32(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -12
	lw s2, 0(s1)
	lw s1, -32(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s1
	jal ra, cc_type_size
	mv s3, a0
	add s1, s2, s3
	sw s1, -12(s0)
.L15_13:
.L15_9:
	lw s1, -32(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	j .L15_0
.L15_2:
	lw s1, -12(s0)
	lw s2, -16(s0)
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	lw s1, -16(s0)
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	lw s1, -4(s0)
	li s2, 40
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end15:
	.size layout_struct, .Lfunc_end15-layout_struct

	.text
	.align 2
	.type layout_union, @function
layout_union:
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
	li s1, 0
	sw s1, -12(s0)
	li s1, 1
	sw s1, -16(s0)
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
.L16_0:
	lw s1, -20(s0)
	bnez s1, .L16_1
	j .L16_2
.L16_1:
	li s1, 0
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -24(s0)
	lw s2, -12(s0)
	slt s3, s2, s1
	bnez s3, .L16_3
	j .L16_4
.L16_3:
	lw s1, -24(s0)
	sw s1, -12(s0)
.L16_4:
	lw s1, -28(s0)
	lw s2, -16(s0)
	slt s3, s2, s1
	bnez s3, .L16_5
	j .L16_6
.L16_5:
	lw s1, -28(s0)
	sw s1, -16(s0)
.L16_6:
.L16_7:
	lw s1, -20(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -20(s0)
	j .L16_0
.L16_2:
	lw s1, -12(s0)
	lw s2, -16(s0)
	add s3, s1, s2
	li s1, 1
	sub s2, s3, s1
	lw s1, -16(s0)
	li s3, 1
	sub s4, s1, s3
	not s1, s4
	and s3, s2, s1
	lw s1, -4(s0)
	li s2, 40
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -16(s0)
	lw s2, -4(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
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
.Lfunc_end16:
	.size layout_union, .Lfunc_end16-layout_union

	.text
	.align 2
	.type cc_type_const, @function
cc_type_const:
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
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -4(s0)
	lw s2, -12(s0)
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
	lw s1, 0(s4)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -12(s0)
	li s3, 8
	add s4, s2, s3
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
.Lfunc_end17:
	.size cc_type_const, .Lfunc_end17-cc_type_const

	.text
	.align 2
	.type parse_declspec, @function
parse_declspec:
	li t6, -2560
	add sp, sp, t6
	li t6, 2556
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 2552
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 2552
	add s0, sp, t6
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
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 0
	sw s1, -36(s0)
	li s1, 1
	neg s2, s1
	sw s2, -40(s0)
	li s1, 0
	sw s1, -44(s0)
	li s1, 0
	sw s1, -48(s0)
	li s1, 0
	la s2, declspec_alignas
	sw s1, 0(s2)
	li s1, 0
	la s2, declspec_inline
	sw s1, 0(s2)
	lw s1, -4(s0)
	bnez s1, .L18_0
	j .L18_1
.L18_0:
	li s1, 0
	lw s2, -4(s0)
	sw s1, 0(s2)
.L18_1:
	lw s1, -8(s0)
	bnez s1, .L18_2
	j .L18_3
.L18_2:
	li s1, 0
	lw s2, -8(s0)
	sw s1, 0(s2)
.L18_3:
	lw s1, -12(s0)
	bnez s1, .L18_4
	j .L18_5
.L18_4:
	li s1, 0
	lw s2, -12(s0)
	sw s1, 0(s2)
.L18_5:
.L18_6:
	j .L18_7
.L18_7:
	addi s1, s0, -176
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -176
	addi s2, s0, -112
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -112
	lw s2, 0(s1)
	li s1, 26
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_8
	li s1, 25
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_9
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_10
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_11
	li s1, 28
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_12
	li s1, 24
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_13
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_14
	li s1, 22
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_15
	li s1, 23
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_16
	li s1, 43
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_17
	li s1, 16
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_18
	li s1, 15
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_19
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_20
	li s1, 7
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_21
	li s1, 8
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_22
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_23
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_24
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_25
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_26
	li s1, 13
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_27
	li s1, 14
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_28
	li s1, 17
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_29
	li s1, 18
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_30
	li s1, 19
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_31
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_32
	j .L18_33
.L18_8:
	addi s1, s0, -240
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -240
	lw s1, -4(s0)
	bnez s1, .L18_34
	j .L18_35
.L18_34:
	li s1, 1
	lw s2, -4(s0)
	sw s1, 0(s2)
.L18_35:
	j .L18_36
.L18_9:
	addi s1, s0, -304
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -304
	lw s1, -8(s0)
	bnez s1, .L18_37
	j .L18_38
.L18_37:
	li s1, 1
	lw s2, -8(s0)
	sw s1, 0(s2)
.L18_38:
	j .L18_36
.L18_10:
	addi s1, s0, -368
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -368
	lw s1, -12(s0)
	bnez s1, .L18_39
	j .L18_40
.L18_39:
	li s1, 1
	lw s2, -12(s0)
	sw s1, 0(s2)
.L18_40:
	j .L18_36
.L18_11:
.L18_12:
	addi s1, s0, -432
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -432
	j .L18_36
.L18_13:
	addi s1, s0, -496
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -496
	li s1, 1
	la s2, declspec_inline
	sw s1, 0(s2)
	j .L18_36
.L18_14:
	addi s1, s0, -560
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -560
	li s1, 1
	sw s1, -36(s0)
	j .L18_36
.L18_15:
.L18_16:
	addi s1, s0, -624
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -624
	j .L18_36
.L18_17:
	addi s1, s0, -688
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -688
	addi s1, s0, -752
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -752
	addi s1, s0, -824
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -824
	addi s2, s0, -888
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -888
	mv a0, s1
	jal ra, is_type_start
	mv s2, a0
	bnez s2, .L18_41
	j .L18_42
.L18_41:
	la s1, declspec_alignas
	lw s2, 0(s1)
	sw s2, -892(s0)
	li s1, 0
	sw s1, -896(s0)
	li s1, 0
	sw s1, -900(s0)
	addi s1, s0, -896
	addi s2, s0, -900
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -904(s0)
	lw s1, -904(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -904(s0)
	lw s1, -904(s0)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	sw s2, -756(s0)
	lw s1, -892(s0)
	la s2, declspec_alignas
	sw s1, 0(s2)
	j .L18_43
.L18_42:
	jal ra, parse_assign_expr
	mv s1, a0
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	mv s1, s10
	sw s1, -756(s0)
.L18_43:
	addi s1, s0, -968
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -968
	lw s1, -756(s0)
	la s2, declspec_alignas
	lw s3, 0(s2)
	slt s2, s3, s1
	bnez s2, .L18_44
	j .L18_45
.L18_44:
	lw s1, -756(s0)
	la s2, declspec_alignas
	sw s1, 0(s2)
.L18_45:
	j .L18_36
.L18_18:
	addi s1, s0, -1032
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1032
	li s1, 1
	sw s1, -24(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_19:
	addi s1, s0, -1096
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1096
	li s1, 1
	sw s1, -28(s0)
	li s1, 1
	sw s1, -20(s0)
	lw s1, -28(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	j .L18_36
.L18_20:
	addi s1, s0, -1160
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1160
	li s1, 0
	sw s1, -40(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_21:
	addi s1, s0, -1224
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1224
	li s1, 1
	sw s1, -40(s0)
	li s1, 1
	sw s1, -24(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_22:
	addi s1, s0, -1288
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1288
	li s1, 1
	sw s1, -40(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_23:
	addi s1, s0, -1352
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1352
	li s1, 2
	sw s1, -40(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_24:
	addi s1, s0, -1416
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1416
	li s1, 3
	sw s1, -40(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_25:
	addi s1, s0, -1480
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1480
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_26:
	addi s1, s0, -1544
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1544
	li s1, 6
	sw s1, -40(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_27:
	addi s1, s0, -1608
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1608
	li s1, 7
	sw s1, -40(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_28:
	addi s1, s0, -1672
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1672
	li s1, 8
	sw s1, -40(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_36
.L18_29:
.L18_30:
	addi s1, s0, -112
	lw s2, 0(s1)
	li s1, 18
	xor s3, s2, s1
	seqz s3, s3
	sw s3, -1676(s0)
	addi s1, s0, -1744
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1744
	li s1, 0
	sw s1, -1748(s0)
	addi s1, s0, -1880
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -1880
	addi s2, s0, -1816
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1816
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_46
	j .L18_47
.L18_46:
	addi s1, s0, -1816
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1748(s0)
	addi s1, s0, -1944
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1944
.L18_47:
	li s1, 49
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L18_48
	j .L18_49
.L18_48:
	lw s1, -1676(s0)
	bnez s1, .L18_50
	j .L18_51
.L18_50:
	li s1, 14
	sw s1, -1952(s0)
	j .L18_52
.L18_51:
	li s1, 13
	sw s1, -1952(s0)
.L18_52:
	lw s1, -1952(s0)
	sw s1, -1948(s0)
	lw s1, -1748(s0)
	bnez s1, .L18_53
	j .L18_54
.L18_53:
	lw s1, -1748(s0)
	mv a0, s1
	jal ra, find_tag
	mv s2, a0
	sw s2, -1956(s0)
	j .L18_55
.L18_54:
	li s1, 0
	sw s1, -1956(s0)
.L18_55:
	lw s1, -1956(s0)
	sw s1, -48(s0)
	lw s1, -48(s0)
	bnez s1, .L18_56
	j .L18_57
.L18_56:
	lw s1, -48(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L18_57
	j .L18_58
.L18_58:
	lw s1, -48(s0)
	lw s2, 0(s1)
	lw s1, -1948(s0)
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L18_57
	j .L18_59
.L18_57:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	li s3, 52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -1948(s0)
	lw s2, -48(s0)
	sw s1, 0(s2)
	lw s1, -1748(s0)
	lw s2, -48(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1748(s0)
	bnez s1, .L18_60
	j .L18_61
.L18_60:
	lw s1, -1748(s0)
	lw s2, -48(s0)
	mv a0, s1
	mv a1, s2
	jal ra, add_tag
	mv s3, a0
.L18_61:
.L18_59:
	jal ra, parse_fields
	mv s1, a0
	lw s2, -48(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1676(s0)
	bnez s1, .L18_62
	j .L18_63
.L18_62:
	lw s1, -48(s0)
	mv a0, s1
	jal ra, layout_union
	mv s2, a0
	j .L18_64
.L18_63:
	lw s1, -48(s0)
	mv a0, s1
	jal ra, layout_struct
	mv s2, a0
.L18_64:
	j .L18_65
.L18_49:
	lw s1, -1748(s0)
	mv a0, s1
	jal ra, find_tag
	mv s2, a0
	sw s2, -48(s0)
	lw s1, -48(s0)
	bnez s1, .L18_66
	j .L18_67
.L18_67:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	li s3, 52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -1676(s0)
	bnez s1, .L18_68
	j .L18_69
.L18_68:
	li s1, 14
	sw s1, -1960(s0)
	j .L18_70
.L18_69:
	li s1, 13
	sw s1, -1960(s0)
.L18_70:
	lw s1, -1960(s0)
	lw s2, -48(s0)
	sw s1, 0(s2)
	lw s1, -1748(s0)
	lw s2, -48(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1748(s0)
	lw s2, -48(s0)
	mv a0, s1
	mv a1, s2
	jal ra, add_tag
	mv s3, a0
.L18_66:
.L18_65:
	li s1, 1
	sw s1, -20(s0)
	j .L18_71
.L18_31:
	addi s1, s0, -2024
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -2024
	li s1, 0
	sw s1, -2028(s0)
	li t6, -2160
	add s1, s0, t6
	mv a0, s1
	jal ra, peek
	mv s2, a0
	li t6, -2160
	add s1, s0, t6
	li t6, -2096
	add s2, s0, t6
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2096
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L18_72
	j .L18_73
.L18_72:
	li t6, -2096
	add s1, s0, t6
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -2028(s0)
	li t6, -2224
	add s1, s0, t6
	mv a0, s1
	jal ra, next
	mv s2, a0
	li t6, -2224
	add s1, s0, t6
.L18_73:
	li s1, 49
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L18_74
	j .L18_75
.L18_74:
	li s1, 0
	li t6, -2228
	add t6, s0, t6
	sw s1, 0(t6)
.L18_76:
	li s1, 50
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L18_77
	j .L18_78
.L18_78:
	li t6, -2360
	add s1, s0, t6
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2360
	add s1, s0, t6
	li t6, -2296
	add s2, s0, t6
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 58
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L18_79
	j .L18_80
.L18_79:
	jal ra, parse_assign_expr
	mv s1, a0
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	mv s1, s10
	li t6, -2228
	add t6, s0, t6
	sw s1, 0(t6)
.L18_80:
	li t6, -2296
	add s1, s0, t6
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	jal ra, cc_type_int
	mv s3, a0
	li t6, -2228
	add t6, s0, t6
	lw s4, 0(t6)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, add_sym
	mv s5, a0
	li t6, -2228
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -2228
	add t6, s0, t6
	sw s3, 0(t6)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L18_81
	j .L18_82
.L18_82:
	li t6, -2424
	add s1, s0, t6
	li s2, 50
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2424
	add s1, s0, t6
	j .L18_77
.L18_81:
	j .L18_76
.L18_77:
	lw s1, -2028(s0)
	bnez s1, .L18_83
	j .L18_84
.L18_83:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	li t6, -2428
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -2428
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	li s3, 52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li s1, 15
	li t6, -2428
	add t6, s0, t6
	lw s2, 0(t6)
	sw s1, 0(s2)
	lw s1, -2028(s0)
	li t6, -2428
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -2028(s0)
	li t6, -2428
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s1
	mv a1, s2
	jal ra, add_tag
	mv s3, a0
.L18_84:
.L18_75:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	li s3, 52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li s1, 15
	lw s2, -48(s0)
	sw s1, 0(s2)
	lw s1, -2028(s0)
	lw s2, -48(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	sw s1, -20(s0)
	j .L18_71
.L18_32:
	addi s1, s0, -112
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_sym
	mv s2, a0
	li t6, -2432
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -2432
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L18_85
	j .L18_86
.L18_85:
	li t6, -2432
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_87
	j .L18_86
.L18_87:
	lw s1, -20(s0)
	bnez s1, .L18_86
	j .L18_88
.L18_88:
	li t6, -2496
	add s1, s0, t6
	mv a0, s1
	jal ra, next
	mv s2, a0
	li t6, -2496
	add s1, s0, t6
	li t6, -2432
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -48(s0)
	li s1, 1
	sw s1, -20(s0)
	j .L18_71
.L18_86:
	j .L18_71
.L18_33:
	j .L18_71
.L18_89:
.L18_36:
	j .L18_6
.L18_90:
.L18_71:
	lw s1, -20(s0)
	bnez s1, .L18_91
	j .L18_92
.L18_92:
	la s1, __str_7
	jal ra, cc_lex_line
	mv s2, a0
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L18_91:
	lw s1, -48(s0)
	bnez s1, .L18_93
	j .L18_94
.L18_94:
	lw s1, -40(s0)
	li s2, 1
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L18_95
	j .L18_96
.L18_95:
	lw s1, -44(s0)
	li s2, 2
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L18_97
	j .L18_98
.L18_97:
	li s1, 5
	sw s1, -40(s0)
	j .L18_99
.L18_98:
	lw s1, -44(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_100
	j .L18_101
.L18_100:
	li s1, 4
	sw s1, -40(s0)
	j .L18_102
.L18_101:
	li s1, 3
	sw s1, -40(s0)
.L18_102:
.L18_99:
	j .L18_103
.L18_96:
	lw s1, -40(s0)
	li s2, 8
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L18_104
	j .L18_105
.L18_104:
	lw s1, -44(s0)
	li s2, 1
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L18_106
	j .L18_105
.L18_106:
	li s1, 9
	sw s1, -40(s0)
.L18_105:
.L18_103:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -48(s0)
	lw s1, -48(s0)
	li s2, 0
	li s3, 52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -40(s0)
	lw s2, -48(s0)
	sw s1, 0(s2)
	lw s1, -24(s0)
	lw s2, -48(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -48(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
.L18_93:
	lw s1, -36(s0)
	bnez s1, .L18_107
	j .L18_108
.L18_107:
	lw s1, -48(s0)
	mv a0, s1
	jal ra, cc_type_const
	mv s2, a0
	sw s2, -48(s0)
.L18_108:
	lw s1, -48(s0)
	mv a0, s1
	li t6, -2540
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2536
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -2532
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -2528
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -2524
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -2520
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -2516
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -2512
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -2508
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -2504
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -2500
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end18:
	.size parse_declspec, .Lfunc_end18-parse_declspec

	.text
	.align 2
	.type const_eval, @function
const_eval:
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
	bnez s1, .L19_0
	j .L19_1
.L19_1:
	la s1, __str_8
	mv a0, s1
	jal ra, die
	mv s2, a0
.L19_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_2
	li s1, 20
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_3
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_4
	li s1, 24
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_5
	li s1, 28
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_6
	li s1, 27
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_7
	li s1, 29
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_8
	j .L19_9
.L19_2:
	lw s1, -4(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	mv a0, s10
	mv a1, s11
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
.L19_3:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	sw s10, -16(s0)
	sw s11, -12(s0)
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_10
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_11
	li s2, 71
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_12
	li s2, 72
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_13
	li s2, 73
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_14
	li s2, 74
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_15
	li s2, 75
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_16
	li s2, 76
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_17
	li s2, 87
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_18
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_19
	li s2, 79
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_20
	li s2, 80
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_21
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_22
	li s2, 82
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_23
	li s2, 83
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_24
	li s2, 84
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_25
	li s2, 85
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_26
	li s2, 86
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_27
	j .L19_28
.L19_10:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	mv a0, s6
	mv a1, s7
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
.L19_11:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	sltu t0, s10, s8
	sub s6, s10, s8
	sub s7, s11, t0
	sub s7, s7, s9
	mv a0, s6
	mv a1, s7
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
.L19_12:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
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
	mv a0, s6
	mv a1, s7
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
.L19_13:
	lw s10, -24(s0)
	lw s11, -20(s0)
	bnez s10, .L19_29
	j .L19_30
.L19_29:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __divdi3
	mv s6, a0
	mv s7, a1
	sw s6, -32(s0)
	sw s7, -28(s0)
	j .L19_31
.L19_30:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -32(s0)
	sw s11, -28(s0)
.L19_31:
	lw s10, -32(s0)
	lw s11, -28(s0)
	mv a0, s10
	mv a1, s11
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
.L19_14:
	lw s10, -24(s0)
	lw s11, -20(s0)
	bnez s10, .L19_32
	j .L19_33
.L19_32:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	mv a0, s10
	mv a1, s11
	mv a2, s8
	mv a3, s9
	jal ra, __moddi3
	mv s6, a0
	mv s7, a1
	sw s6, -40(s0)
	sw s7, -36(s0)
	j .L19_34
.L19_33:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -40(s0)
	sw s11, -36(s0)
.L19_34:
	lw s10, -40(s0)
	lw s11, -36(s0)
	mv a0, s10
	mv a1, s11
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
.L19_15:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	and s6, s10, s8
	and s7, s11, s9
	mv a0, s6
	mv a1, s7
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
.L19_16:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	or s6, s10, s8
	or s7, s11, s9
	mv a0, s6
	mv a1, s7
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
.L19_17:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	xor s6, s10, s8
	xor s7, s11, s9
	mv a0, s6
	mv a1, s7
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
.L19_18:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s8, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	mv a0, s6
	mv a1, s7
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
.L19_19:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s8, 0(sp)
	jal ra, __ashrdi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	mv a0, s6
	mv a1, s7
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
.L19_20:
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L19_35
	j .L19_36
.L19_35:
	lw s10, -24(s0)
	lw s11, -20(s0)
	bnez s10, .L19_37
	j .L19_36
.L19_37:
	li s1, 1
	j .L19_38
.L19_36:
	li s1, 0
.L19_38:
	srai t1, s1, 31
	mv a0, s1
	mv a1, t1
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
.L19_21:
	lw s10, -16(s0)
	lw s11, -12(s0)
	bnez s10, .L19_39
	j .L19_40
.L19_40:
	lw s10, -24(s0)
	lw s11, -20(s0)
	bnez s10, .L19_39
	j .L19_41
.L19_39:
	li s1, 1
	j .L19_42
.L19_41:
	li s1, 0
.L19_42:
	srai t1, s1, 31
	mv a0, s1
	mv a1, t1
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
.L19_22:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_23:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	snez s1, t0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_24:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	slt s1, s11, s9
	bne s11, s9, .L19_43
	sltu s1, s10, s8
.L19_43:
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_25:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	slt s1, s9, s11
	bne s9, s11, .L19_44
	sltu s1, s8, s10
.L19_44:
	xori s1, s1, 1
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_26:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	slt s1, s9, s11
	bne s9, s11, .L19_45
	sltu s1, s8, s10
.L19_45:
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_27:
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	slt s1, s11, s9
	bne s11, s9, .L19_46
	sltu s1, s10, s8
.L19_46:
	xori s1, s1, 1
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_28:
	la s1, __str_9
	mv a0, s1
	jal ra, die
	mv s2, a0
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_47:
.L19_4:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	sw s10, -48(s0)
	sw s11, -44(s0)
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_48
	li s2, 77
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_49
	li s2, 78
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_50
	j .L19_51
.L19_48:
	lw s10, -48(s0)
	lw s11, -44(s0)
	neg s8, s10
	snez t0, s10
	neg s9, s11
	sub s9, s9, t0
	mv a0, s8
	mv a1, s9
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
.L19_49:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s8, -1
	li s9, -1
	xor s6, s10, s8
	xor s7, s11, s9
	mv a0, s6
	mv a1, s7
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
.L19_50:
	lw s10, -48(s0)
	lw s11, -44(s0)
	li s8, 0
	li s9, 0
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	srai t1, s1, 31
	mv a0, s1
	mv a1, t1
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
.L19_51:
	la s1, __str_10
	mv a0, s1
	jal ra, die
	mv s2, a0
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_52:
.L19_5:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	bnez s10, .L19_53
	j .L19_54
.L19_53:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	sw s10, -56(s0)
	sw s11, -52(s0)
	j .L19_55
.L19_54:
	lw s1, -4(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	sw s10, -56(s0)
	sw s11, -52(s0)
.L19_55:
	lw s10, -56(s0)
	lw s11, -52(s0)
	mv a0, s10
	mv a1, s11
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
.L19_6:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L19_56
	j .L19_57
.L19_56:
	lw s1, -4(s0)
	li s2, 80
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -64(s0)
	j .L19_58
.L19_57:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L19_59
	j .L19_60
.L19_59:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -68(s0)
	j .L19_61
.L19_60:
	li s1, 0
	sw s1, -68(s0)
.L19_61:
	lw s1, -68(s0)
	sw s1, -64(s0)
.L19_58:
	lw s1, -64(s0)
	sw s1, -60(s0)
	lw s1, -60(s0)
	bnez s1, .L19_62
	j .L19_63
.L19_63:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L19_64
	j .L19_62
.L19_64:
	la s1, cc_const_sizeof_typer
	lw s2, 0(s1)
	bnez s2, .L19_65
	j .L19_62
.L19_65:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, cc_const_sizeof_typer
	mv s2, a0
	sw s2, -60(s0)
.L19_62:
	lw s1, -60(s0)
	bnez s1, .L19_66
	j .L19_67
.L19_67:
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -60(s0)
.L19_66:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 42
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L19_68
	j .L19_69
.L19_68:
	lw s1, -60(s0)
	mv a0, s1
	jal ra, cc_type_align
	mv s2, a0
	sw s2, -72(s0)
	j .L19_70
.L19_69:
	lw s1, -60(s0)
	mv a0, s1
	jal ra, cc_type_size
	mv s2, a0
	sw s2, -72(s0)
.L19_70:
	lw s1, -72(s0)
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_7:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	mv a0, s10
	mv a1, s11
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
.L19_8:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L19_71
	j .L19_72
.L19_71:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L19_73
	j .L19_72
.L19_73:
	lw s1, -4(s0)
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	sw s10, -80(s0)
	sw s11, -76(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L19_74
	sltu s1, s10, s8
.L19_74:
	bnez s1, .L19_75
	j .L19_76
.L19_76:
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	mv s8, s1
	srai s9, s8, 31
	slt s1, s9, s11
	bne s9, s11, .L19_77
	sltu s1, s8, s10
.L19_77:
	bnez s1, .L19_75
	j .L19_78
.L19_75:
	la s1, __str_11
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s10, 0(sp)
	sw s11, 4(sp)
	sw s2, 8(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L19_78:
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 76
	add s3, s1, s2
	lw s1, 0(s3)
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L19_79
	j .L19_80
.L19_79:
	li s1, 0
	sw s1, -84(s0)
	j .L19_81
.L19_80:
	lw s1, -4(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 72
	add s3, s1, s2
	lw s1, 0(s3)
	lw s10, -80(s0)
	lw s11, -76(s0)
	mv s2, s10
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 255
	and s3, s1, s2
	sw s3, -84(s0)
.L19_81:
	lw s1, -84(s0)
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_72:
	la s1, __str_12
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_9:
	la s1, __str_13
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L19_82:
	li s10, 0
	li s11, 0
	mv a0, s10
	mv a1, s11
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
.Lfunc_end19:
	.size const_eval, .Lfunc_end19-const_eval

	.text
	.align 2
	.globl cc_const_eval
	.type cc_const_eval, @function
cc_const_eval:
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
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	mv a0, s10
	mv a1, s11
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
.Lfunc_end20:
	.size cc_const_eval, .Lfunc_end20-cc_const_eval

	.text
	.align 2
	.type parse_static_assert, @function
parse_static_assert:
	addi sp, sp, -464
	sw ra, 460(sp)
	sw s0, 456(sp)
	addi s0, sp, 456
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
	jal ra, cc_lex_line
	mv s1, a0
	sw s1, -4(s0)
	addi s1, s0, -72
	li s2, 44
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -72
	addi s1, s0, -136
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -136
	jal ra, parse_assign_expr
	mv s1, a0
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	sw s10, -144(s0)
	sw s11, -140(s0)
	li s1, 0
	sw s1, -148(s0)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L21_0
	j .L21_1
.L21_0:
	addi s1, s0, -280
	li s2, 3
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -280
	addi s2, s0, -216
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -216
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -148(s0)
.L21_1:
	addi s1, s0, -344
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -344
	addi s1, s0, -408
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -408
	lw s10, -144(s0)
	lw s11, -140(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	xor t0, s10, s8
	xor t1, s11, s9
	or t0, t0, t1
	seqz s1, t0
	bnez s1, .L21_2
	j .L21_3
.L21_2:
	lw s1, -148(s0)
	bnez s1, .L21_4
	j .L21_5
.L21_4:
	la s1, __str_14
	lw s2, -4(s0)
	lw s3, -148(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	sw s3, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
.L21_5:
	la s1, __str_15
	lw s2, -4(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L21_3:
	li s1, 0
	mv a0, s1
	lw s1, -452(s0)
	lw s2, -448(s0)
	lw s3, -444(s0)
	lw s4, -440(s0)
	lw s5, -436(s0)
	lw s6, -432(s0)
	lw s7, -428(s0)
	lw s8, -424(s0)
	lw s9, -420(s0)
	lw s10, -416(s0)
	lw s11, -412(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end21:
	.size parse_static_assert, .Lfunc_end21-parse_static_assert

	.text
	.align 2
	.type parse_declarator, @function
parse_declarator:
	addi sp, sp, -1936
	sw ra, 1932(sp)
	sw s0, 1928(sp)
	addi s0, sp, 1928
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
.L22_0:
	li s1, 71
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L22_1
	j .L22_2
.L22_1:
	la s1, parse_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	sw s3, -4(s0)
.L22_3:
	addi s1, s0, -72
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_4
	j .L22_5
.L22_5:
	addi s1, s0, -136
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -136
	lw s2, 0(s1)
	li s1, 22
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_4
	j .L22_6
.L22_6:
	addi s1, s0, -200
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -200
	lw s2, 0(s1)
	li s1, 23
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_4
	j .L22_7
.L22_4:
	addi s1, s0, -264
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -264
	lw s2, 0(s1)
	li s1, 21
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_8
	j .L22_9
.L22_8:
	li s1, 1
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
.L22_9:
	addi s1, s0, -328
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -328
	j .L22_3
.L22_7:
	j .L22_0
.L22_2:
	li s1, 0
	sw s1, -332(s0)
	li s1, 0
	sw s1, -336(s0)
	addi s1, s0, -400
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -400
	lw s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_10
	j .L22_11
.L22_10:
	addi s1, s0, -528
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -528
	addi s2, s0, -464
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -656
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -656
	addi s2, s0, -592
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -592
	lw s2, 0(s1)
	li s1, 71
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_12
	j .L22_13
.L22_13:
	addi s1, s0, -592
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_14
	j .L22_15
.L22_14:
	addi s1, s0, -592
	addi s2, s0, -720
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -720
	mv a0, s1
	jal ra, is_type_start
	mv s2, a0
	bnez s2, .L22_15
	j .L22_12
.L22_15:
	addi s1, s0, -592
	lw s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_12
	j .L22_16
.L22_12:
	lw s1, -4(s0)
	addi s2, s0, -336
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -332(s0)
	addi s1, s0, -784
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -784
	j .L22_17
.L22_16:
	addi s1, s0, -464
	addi s2, s0, -848
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -848
	mv a0, s1
	jal ra, ungettok
	mv s2, a0
.L22_17:
	j .L22_18
.L22_11:
	addi s1, s0, -912
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -912
	lw s2, 0(s1)
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_19
	j .L22_20
.L22_19:
	addi s1, s0, -1040
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1040
	addi s2, s0, -976
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -976
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -336(s0)
.L22_20:
.L22_18:
.L22_21:
	j .L22_22
.L22_22:
	addi s1, s0, -1104
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -1104
	lw s2, 0(s1)
	li s1, 51
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_23
	j .L22_24
.L22_23:
	li s1, 0
	sw s1, -1236(s0)
.L22_25:
	li s1, 51
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L22_26
	j .L22_27
.L22_26:
	li s1, 1
	neg s2, s1
	sw s2, -1240(s0)
	addi s1, s0, -1304
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -1304
	lw s2, 0(s1)
	li s1, 52
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L22_28
	j .L22_29
.L22_28:
	jal ra, parse_assign_expr
	mv s1, a0
	sw s1, -1308(s0)
	lw s1, -1308(s0)
	mv a0, s1
	jal ra, const_eval
	mv s10, a0
	mv s11, a1
	mv s1, s10
	sw s1, -1240(s0)
.L22_29:
	addi s1, s0, -1376
	li s2, 52
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1376
	lw s1, -1236(s0)
	li s2, 32
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_30
	j .L22_31
.L22_30:
	la s1, __str_16
	jal ra, cc_lex_line
	mv s2, a0
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L22_31:
	lw s1, -1240(s0)
	addi s2, s0, -1232
	addi s3, s0, -1236
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -1236(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	j .L22_25
.L22_27:
	lw s1, -1236(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -1380(s0)
.L22_32:
	lw s1, -1380(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L22_33
	j .L22_34
.L22_33:
	la s1, parse_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	addi s3, s0, -1232
	lw s4, -1380(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s2
	mv a1, s1
	mv a2, s3
	jal ra, cc_type_array
	mv s4, a0
	sw s4, -4(s0)
.L22_35:
	addi s1, s0, -1380
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -1380(s0)
	j .L22_32
.L22_34:
	j .L22_36
.L22_24:
	li s1, 47
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L22_37
	j .L22_38
.L22_37:
	la s1, parse_arena
	lw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_func
	mv s3, a0
	sw s3, -1384(s0)
	li s1, 0
	sw s1, -1388(s0)
	li s1, 0
	sw s1, -1392(s0)
	li s1, 48
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L22_39
	j .L22_40
.L22_40:
	addi s1, s0, -1456
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -1456
	lw s2, 0(s1)
	li s1, 6
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_41
	j .L22_42
.L22_41:
	addi s1, s0, -1584
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1584
	addi s2, s0, -1520
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1648
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -1648
	lw s2, 0(s1)
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_43
	j .L22_44
.L22_43:
	addi s1, s0, -1712
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1712
	j .L22_45
.L22_44:
	addi s1, s0, -1520
	addi s2, s0, -1776
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1776
	mv a0, s1
	jal ra, ungettok
	mv s2, a0
	j .L22_46
.L22_45:
	j .L22_47
.L22_42:
.L22_46:
.L22_48:
	j .L22_49
.L22_49:
	li s1, 57
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L22_50
	j .L22_51
.L22_50:
	li s1, 1
	lw s2, -1384(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	j .L22_52
.L22_51:
	li s1, 0
	sw s1, -1780(s0)
	li s1, 0
	sw s1, -1784(s0)
	addi s1, s0, -1780
	addi s2, s0, -1784
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -1788(s0)
	li s1, 0
	sw s1, -1792(s0)
	lw s1, -1788(s0)
	addi s2, s0, -1792
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -1788(s0)
	lw s1, -1788(s0)
	bnez s1, .L22_53
	j .L22_54
.L22_53:
	lw s1, -1788(s0)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_55
	j .L22_54
.L22_55:
	la s1, parse_arena
	lw s2, 0(s1)
	lw s1, -1788(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	sw s3, -1788(s0)
	j .L22_56
.L22_54:
	lw s1, -1788(s0)
	bnez s1, .L22_57
	j .L22_58
.L22_57:
	lw s1, -1788(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_59
	j .L22_58
.L22_59:
	la s1, parse_arena
	lw s2, 0(s1)
	lw s1, -1788(s0)
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	sw s3, -1788(s0)
.L22_58:
.L22_56:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 12
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -1796(s0)
	lw s1, -1796(s0)
	li s2, 0
	li s3, 12
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	lw s1, -1792(s0)
	lw s2, -1796(s0)
	sw s1, 0(s2)
	lw s1, -1788(s0)
	lw s2, -1796(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1388(s0)
	bnez s1, .L22_60
	j .L22_61
.L22_61:
	lw s1, -1796(s0)
	sw s1, -1388(s0)
	j .L22_62
.L22_60:
	lw s1, -1796(s0)
	lw s2, -1392(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
.L22_62:
	lw s1, -1796(s0)
	sw s1, -1392(s0)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L22_63
	j .L22_64
.L22_64:
	j .L22_52
.L22_63:
.L22_65:
	j .L22_48
.L22_52:
	addi s1, s0, -1864
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1864
.L22_47:
.L22_39:
	lw s1, -1388(s0)
	lw s2, -1384(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1384(s0)
	sw s1, -4(s0)
	j .L22_66
.L22_38:
	j .L22_67
.L22_66:
.L22_36:
.L22_68:
	j .L22_21
.L22_67:
	lw s1, -8(s0)
	bnez s1, .L22_69
	j .L22_70
.L22_69:
	lw s1, -336(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
.L22_70:
	lw s1, -332(s0)
	bnez s1, .L22_71
	j .L22_72
.L22_71:
	lw s1, -332(s0)
	sw s1, -1868(s0)
.L22_73:
	lw s1, -1868(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L22_74
	j .L22_75
.L22_74:
	lw s1, -1868(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_76
	j .L22_77
.L22_77:
	lw s1, -1868(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 11
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_76
	j .L22_78
.L22_78:
	lw s1, -1868(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L22_76
	j .L22_75
.L22_76:
	lw s1, -1868(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1868(s0)
	j .L22_73
.L22_75:
	lw s1, -4(s0)
	lw s2, -1868(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -332(s0)
	mv a0, s1
	lw s1, -1916(s0)
	lw s2, -1912(s0)
	lw s3, -1908(s0)
	lw s4, -1904(s0)
	lw s5, -1900(s0)
	lw s6, -1896(s0)
	lw s7, -1892(s0)
	lw s8, -1888(s0)
	lw s9, -1884(s0)
	lw s10, -1880(s0)
	lw s11, -1876(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L22_72:
	lw s1, -4(s0)
	mv a0, s1
	lw s1, -1916(s0)
	lw s2, -1912(s0)
	lw s3, -1908(s0)
	lw s4, -1904(s0)
	lw s5, -1900(s0)
	lw s6, -1896(s0)
	lw s7, -1892(s0)
	lw s8, -1888(s0)
	lw s9, -1884(s0)
	lw s10, -1880(s0)
	lw s11, -1876(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end22:
	.size parse_declarator, .Lfunc_end22-parse_declarator

	.text
	.align 2
	.type parse_initializer, @function
parse_initializer:
	addi sp, sp, -608
	sw ra, 604(sp)
	sw s0, 600(sp)
	addi s0, sp, 600
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
	li s1, 49
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L23_0
	j .L23_1
.L23_0:
	li s1, 42
	jal ra, cc_lex_line
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -4(s0)
	li s1, 0
	sw s1, -8(s0)
	li s1, 0
	sw s1, -12(s0)
.L23_2:
	li s1, 50
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L23_3
	j .L23_4
.L23_4:
	addi s1, s0, -80
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 55
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L23_5
	j .L23_6
.L23_6:
	addi s1, s0, -144
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -144
	lw s2, 0(s1)
	li s1, 51
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L23_5
	j .L23_7
.L23_5:
	li s1, 43
	jal ra, cc_lex_line
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -148(s0)
	li s1, 55
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L23_8
	j .L23_9
.L23_8:
	addi s1, s0, -280
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -280
	addi s2, s0, -216
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, parse_arena
	lw s2, 0(s1)
	addi s1, s0, -216
	li s3, 24
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -148(s0)
	li s2, 48
	add s4, s1, s2
	sw s3, 0(s4)
	j .L23_10
.L23_9:
	addi s1, s0, -344
	li s2, 51
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -344
	jal ra, parse_assign_expr
	mv s1, a0
	sw s1, -348(s0)
	lw s1, -348(s0)
	lw s2, 0(s1)
	li s1, 39
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L23_11
	j .L23_12
.L23_11:
	la s1, __str_17
	lw s2, -348(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L23_12:
	lw s1, -348(s0)
	li s2, 56
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -148(s0)
	li s2, 56
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	addi s1, s0, -416
	li s2, 52
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -416
.L23_10:
	addi s1, s0, -480
	li s2, 58
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -480
	jal ra, parse_initializer
	mv s1, a0
	lw s2, -148(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -148(s0)
	sw s1, -16(s0)
	j .L23_13
.L23_7:
	jal ra, parse_initializer
	mv s1, a0
	sw s1, -16(s0)
.L23_13:
	lw s1, -8(s0)
	bnez s1, .L23_14
	j .L23_15
.L23_15:
	lw s1, -16(s0)
	sw s1, -8(s0)
	j .L23_16
.L23_14:
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
.L23_16:
	lw s1, -16(s0)
	sw s1, -12(s0)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L23_17
	j .L23_18
.L23_18:
	addi s1, s0, -544
	li s2, 50
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -544
	j .L23_3
.L23_17:
	j .L23_2
.L23_3:
	lw s1, -8(s0)
	lw s2, -4(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	lw s1, -588(s0)
	lw s2, -584(s0)
	lw s3, -580(s0)
	lw s4, -576(s0)
	lw s5, -572(s0)
	lw s6, -568(s0)
	lw s7, -564(s0)
	lw s8, -560(s0)
	lw s9, -556(s0)
	lw s10, -552(s0)
	lw s11, -548(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L23_1:
	jal ra, parse_assign_expr
	mv s1, a0
	mv a0, s1
	lw s1, -588(s0)
	lw s2, -584(s0)
	lw s3, -580(s0)
	lw s4, -576(s0)
	lw s5, -572(s0)
	lw s6, -568(s0)
	lw s7, -564(s0)
	lw s8, -560(s0)
	lw s9, -556(s0)
	lw s10, -552(s0)
	lw s11, -548(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end23:
	.size parse_initializer, .Lfunc_end23-parse_initializer

	.text
	.align 2
	.type parse_primary, @function
parse_primary:
	addi sp, sp, -960
	sw ra, 956(sp)
	sw s0, 952(sp)
	addi s0, sp, 952
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
	addi s1, s0, -128
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -128
	addi s2, s0, -64
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 1
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L24_0
	li s1, 2
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L24_1
	li s1, 4
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L24_2
	li s1, 3
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L24_3
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L24_4
	li s1, 45
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L24_5
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L24_6
	j .L24_7
.L24_0:
	li s1, 39
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -132(s0)
	addi s1, s0, -64
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -132(s0)
	li s2, 56
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	addi s1, s0, -64
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L24_8
	j .L24_9
.L24_8:
	jal ra, cc_type_long_long
	mv s1, a0
	sw s1, -140(s0)
	j .L24_10
.L24_9:
	addi s1, s0, -64
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L24_11
	j .L24_12
.L24_11:
	jal ra, cc_type_long
	mv s1, a0
	sw s1, -144(s0)
	j .L24_13
.L24_12:
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -144(s0)
.L24_13:
	lw s1, -144(s0)
	sw s1, -140(s0)
.L24_10:
	lw s1, -140(s0)
	sw s1, -136(s0)
	addi s1, s0, -64
	li s2, 56
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L24_14
	j .L24_15
.L24_14:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -148(s0)
	lw s1, -136(s0)
	lw s2, -148(s0)
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
	lw s1, 0(s4)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -148(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -148(s0)
	sw s1, -136(s0)
.L24_15:
	lw s1, -136(s0)
	lw s2, -132(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -132(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_1:
	li s1, 40
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -152(s0)
	addi s1, s0, -64
	li s2, 16
	add s3, s1, s2
	fld fs0, 0(s3)
	lw s1, -152(s0)
	li s2, 64
	add s3, s1, s2
	fsd fs0, 0(s3)
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	sw s3, -156(s0)
	lw s1, -156(s0)
	li s2, 0
	li s3, 52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -64
	li s2, 44
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L24_16
	j .L24_17
.L24_16:
	li s1, 6
	sw s1, -160(s0)
	j .L24_18
.L24_17:
	addi s1, s0, -64
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L24_19
	j .L24_20
.L24_19:
	li s1, 7
	sw s1, -164(s0)
	j .L24_21
.L24_20:
	li s1, 8
	sw s1, -164(s0)
.L24_21:
	lw s1, -164(s0)
	sw s1, -160(s0)
.L24_18:
	lw s1, -160(s0)
	lw s2, -156(s0)
	sw s1, 0(s2)
	lw s1, -156(s0)
	lw s2, -152(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -152(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_2:
	li s1, 39
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -168(s0)
	addi s1, s0, -64
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	lw s1, -168(s0)
	li s2, 56
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	jal ra, cc_type_int
	mv s1, a0
	lw s2, -168(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -168(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_3:
	li s1, 41
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -172(s0)
	addi s1, s0, -64
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -172(s0)
	li s3, 72
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -64
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -172(s0)
	li s3, 76
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, parse_arena
	lw s2, 0(s1)
	jal ra, cc_type_char
	mv s1, a0
	addi s3, s0, -64
	li s4, 28
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 1
	add s5, s3, s4
	mv a0, s2
	mv a1, s1
	mv a2, s5
	jal ra, cc_type_array
	mv s3, a0
	lw s1, -172(s0)
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -172(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_4:
	addi s1, s0, -64
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, find_sym
	mv s2, a0
	sw s2, -176(s0)
	lw s1, -176(s0)
	bnez s1, .L24_22
	j .L24_23
.L24_22:
	lw s1, -176(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L24_24
	j .L24_23
.L24_24:
	li s1, 39
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -180(s0)
	lw s1, -176(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -180(s0)
	li s3, 56
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	jal ra, cc_type_int
	mv s1, a0
	lw s2, -180(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -180(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_23:
	li s1, 38
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -184(s0)
	addi s1, s0, -64
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -184(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -184(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_5:
	li s1, 45
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -188(s0)
	addi s1, s0, -256
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -256
	jal ra, parse_assign_expr
	mv s1, a0
	lw s2, -188(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -320
	li s2, 54
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -320
	li s1, 0
	sw s1, -324(s0)
	li s1, 0
	sw s1, -328(s0)
	li s1, 0
	sw s1, -332(s0)
.L24_25:
	j .L24_26
.L24_26:
	li s1, 45
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -336(s0)
	li s1, 36
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L24_27
	j .L24_28
.L24_27:
	li s1, 0
	lw s2, -336(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -332
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -332(s0)
	li s1, 1
	slt s2, s1, s3
	bnez s2, .L24_29
	j .L24_30
.L24_29:
	la s1, __str_18
	lw s2, -336(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L24_30:
	j .L24_31
.L24_28:
	li s1, 0
	sw s1, -340(s0)
	li s1, 0
	sw s1, -344(s0)
	addi s1, s0, -340
	addi s2, s0, -344
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -348(s0)
	lw s1, -348(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	lw s1, -336(s0)
	li s2, 80
	add s4, s1, s2
	sw s3, 0(s4)
.L24_31:
	addi s1, s0, -416
	li s2, 92
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -416
	jal ra, parse_assign_expr
	mv s1, a0
	lw s2, -336(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -324(s0)
	bnez s1, .L24_32
	j .L24_33
.L24_33:
	lw s1, -336(s0)
	sw s1, -324(s0)
	j .L24_34
.L24_32:
	lw s1, -336(s0)
	lw s2, -328(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
.L24_34:
	lw s1, -336(s0)
	sw s1, -328(s0)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L24_35
	j .L24_36
.L24_36:
	j .L24_37
.L24_35:
.L24_38:
	j .L24_25
.L24_37:
	addi s1, s0, -480
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -480
	lw s1, -324(s0)
	lw s2, -188(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -188(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_6:
	addi s1, s0, -608
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -608
	addi s2, s0, -544
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -544
	addi s2, s0, -672
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -672
	mv a0, s1
	jal ra, is_type_start
	mv s2, a0
	bnez s2, .L24_39
	j .L24_40
.L24_39:
	li s1, 0
	sw s1, -676(s0)
	li s1, 0
	sw s1, -680(s0)
	addi s1, s0, -676
	addi s2, s0, -680
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -684(s0)
	lw s1, -684(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -684(s0)
	addi s1, s0, -752
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -752
	addi s1, s0, -816
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -816
	lw s2, 0(s1)
	li s1, 49
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L24_41
	j .L24_42
.L24_41:
	li s1, 44
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -820(s0)
	lw s1, -684(s0)
	lw s2, -820(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -684(s0)
	lw s2, -820(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_initializer
	mv s1, a0
	lw s2, -820(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -820(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_42:
	li s1, 27
	addi s2, s0, -64
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -824(s0)
	lw s1, -684(s0)
	lw s2, -824(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_cast
	mv s1, a0
	lw s2, -824(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -684(s0)
	lw s2, -824(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -824(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_40:
	jal ra, parse_expr
	mv s1, a0
	sw s1, -828(s0)
	addi s1, s0, -896
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -896
	lw s1, -828(s0)
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_7:
	la s1, __str_19
	addi s2, s0, -64
	lw s3, 0(s2)
	addi s2, s0, -64
	li s4, 32
	add s5, s2, s4
	lw s2, 0(s5)
	addi sp, sp, -16
	mv a0, s1
	sw s3, 0(sp)
	sw s2, 4(sp)
	jal ra, die
	mv s4, a0
	addi sp, sp, 16
	li s1, 0
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L24_43:
	li s1, 0
	mv a0, s1
	lw s1, -948(s0)
	lw s2, -944(s0)
	lw s3, -940(s0)
	lw s4, -936(s0)
	lw s5, -932(s0)
	lw s6, -928(s0)
	lw s7, -924(s0)
	lw s8, -920(s0)
	lw s9, -916(s0)
	lw s10, -912(s0)
	lw s11, -908(s0)
	fld fs0, -904(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end24:
	.size parse_primary, .Lfunc_end24-parse_primary

	.text
	.align 2
	.type parse_postfix, @function
parse_postfix:
	addi sp, sp, -656
	sw ra, 652(sp)
	sw s0, 648(sp)
	addi s0, sp, 648
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
	jal ra, parse_primary
	mv s1, a0
	sw s1, -4(s0)
.L25_0:
	j .L25_1
.L25_1:
	jal ra, cc_lex_line
	mv s1, a0
	sw s1, -8(s0)
	li s1, 51
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L25_2
	j .L25_3
.L25_2:
	jal ra, parse_expr
	mv s1, a0
	sw s1, -12(s0)
	addi s1, s0, -80
	li s2, 52
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -80
	li s1, 29
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -84(s0)
	lw s1, -4(s0)
	lw s2, -84(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -84(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -84(s0)
	sw s1, -4(s0)
	j .L25_4
.L25_3:
	li s1, 47
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L25_5
	j .L25_6
.L25_5:
	li s1, 26
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -88(s0)
	lw s1, -4(s0)
	lw s2, -88(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L25_7
	j .L25_8
.L25_7:
	lw s1, -4(s0)
	li s2, 48
	add s3, s1, s2
	lw s1, 0(s3)
	la s2, __str_20
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L25_9
	j .L25_8
.L25_9:
	jal ra, parse_assign_expr
	mv s1, a0
	lw s2, -88(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -152
	li s2, 54
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -152
	li s1, 0
	sw s1, -156(s0)
	li s1, 0
	sw s1, -160(s0)
	addi s1, s0, -156
	addi s2, s0, -160
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -164(s0)
	lw s1, -164(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -164(s0)
	lw s1, -164(s0)
	lw s2, -88(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -232
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -232
	lw s1, -88(s0)
	sw s1, -4(s0)
	j .L25_10
.L25_8:
	li s1, 0
	sw s1, -236(s0)
	li s1, 0
	sw s1, -240(s0)
	li s1, 48
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L25_11
	j .L25_12
.L25_12:
.L25_13:
	j .L25_14
.L25_14:
	jal ra, parse_assign_expr
	mv s1, a0
	sw s1, -244(s0)
	lw s1, -236(s0)
	bnez s1, .L25_15
	j .L25_16
.L25_16:
	lw s1, -244(s0)
	sw s1, -236(s0)
	j .L25_17
.L25_15:
	lw s1, -244(s0)
	lw s2, -240(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
.L25_17:
	lw s1, -244(s0)
	sw s1, -240(s0)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L25_18
	j .L25_19
.L25_19:
	j .L25_20
.L25_18:
.L25_21:
	j .L25_13
.L25_20:
	addi s1, s0, -312
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -312
.L25_11:
	lw s1, -236(s0)
	lw s2, -88(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -88(s0)
	sw s1, -4(s0)
	j .L25_22
.L25_6:
	li s1, 55
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L25_23
	j .L25_24
.L25_23:
	addi s1, s0, -440
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -440
	addi s2, s0, -376
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 30
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -444(s0)
	lw s1, -4(s0)
	lw s2, -444(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -376
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -444(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -444(s0)
	sw s1, -4(s0)
	j .L25_25
.L25_24:
	li s1, 56
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L25_26
	j .L25_27
.L25_26:
	addi s1, s0, -576
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -576
	addi s2, s0, -512
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 30
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -580(s0)
	li s1, 31
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	lw s1, -580(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -4(s0)
	lw s2, -580(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -512
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -580(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -580(s0)
	sw s1, -4(s0)
	j .L25_28
.L25_27:
	li s1, 89
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L25_29
	j .L25_30
.L25_29:
	li s1, 34
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -584(s0)
	lw s1, -4(s0)
	lw s2, -584(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -584(s0)
	sw s1, -4(s0)
	j .L25_31
.L25_30:
	li s1, 90
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L25_32
	j .L25_33
.L25_32:
	li s1, 35
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -588(s0)
	lw s1, -4(s0)
	lw s2, -588(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -588(s0)
	sw s1, -4(s0)
	j .L25_34
.L25_33:
	j .L25_35
.L25_34:
.L25_31:
.L25_28:
.L25_25:
.L25_22:
.L25_4:
.L25_10:
	j .L25_0
.L25_35:
	lw s1, -4(s0)
	mv a0, s1
	lw s1, -636(s0)
	lw s2, -632(s0)
	lw s3, -628(s0)
	lw s4, -624(s0)
	lw s5, -620(s0)
	lw s6, -616(s0)
	lw s7, -612(s0)
	lw s8, -608(s0)
	lw s9, -604(s0)
	lw s10, -600(s0)
	lw s11, -596(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end25:
	.size parse_postfix, .Lfunc_end25-parse_postfix

	.text
	.align 2
	.type parse_unary, @function
parse_unary:
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
	jal ra, cc_lex_line
	mv s1, a0
	sw s1, -4(s0)
	addi s1, s0, -136
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -136
	addi s2, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 89
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_0
	li s1, 90
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_1
	li s1, 74
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_2
	li s1, 79
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_3
	li s1, 71
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_4
	li s1, 69
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_5
	li s1, 70
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_6
	li s1, 77
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_7
	li s1, 78
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_8
	li s1, 41
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_9
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_10
	j .L26_11
.L26_0:
	addi s1, s0, -200
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -200
	li s1, 36
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -204(s0)
	jal ra, parse_unary
	mv s1, a0
	lw s2, -204(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -204(s0)
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
.L26_1:
	addi s1, s0, -272
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -272
	li s1, 37
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -276(s0)
	jal ra, parse_unary
	mv s1, a0
	lw s2, -276(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -276(s0)
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
.L26_2:
	addi s1, s0, -344
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -344
	li s1, 32
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -348(s0)
	jal ra, parse_cast
	mv s1, a0
	lw s2, -348(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -348(s0)
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
.L26_3:
	addi s1, s0, -488
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -488
	addi s1, s0, -552
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -552
	addi s2, s0, -416
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 33
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -420(s0)
	addi s1, s0, -416
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -420(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -420(s0)
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
.L26_4:
	addi s1, s0, -616
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -616
	li s1, 31
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -620(s0)
	jal ra, parse_cast
	mv s1, a0
	lw s2, -620(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -620(s0)
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
.L26_5:
	addi s1, s0, -688
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -688
	jal ra, parse_cast
	mv s1, a0
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
.L26_6:
	addi s1, s0, -752
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -752
	li s1, 21
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -756(s0)
	li s1, 70
	lw s2, -756(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_cast
	mv s1, a0
	lw s2, -756(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -756(s0)
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
.L26_7:
	addi s1, s0, -824
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -824
	li s1, 21
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -828(s0)
	li s1, 77
	lw s2, -828(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_cast
	mv s1, a0
	lw s2, -828(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -828(s0)
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
.L26_8:
	addi s1, s0, -896
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -896
	li s1, 21
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -900(s0)
	li s1, 78
	lw s2, -900(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_cast
	mv s1, a0
	lw s2, -900(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -900(s0)
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
.L26_9:
.L26_10:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 42
	xor s3, s2, s1
	seqz s3, s3
	sw s3, -904(s0)
	addi s1, s0, -968
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -968
	li s1, 28
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -972(s0)
	lw s1, -904(s0)
	bnez s1, .L26_12
	j .L26_13
.L26_12:
	li s1, 42
	sw s1, -976(s0)
	j .L26_14
.L26_13:
	li s1, 41
	sw s1, -976(s0)
.L26_14:
	lw s1, -976(s0)
	lw s2, -972(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 47
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L26_15
	j .L26_16
.L26_15:
	addi s1, s0, -1104
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -1104
	addi s2, s0, -1040
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1040
	addi s2, s0, -1168
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1168
	mv a0, s1
	jal ra, is_type_start
	mv s2, a0
	bnez s2, .L26_17
	j .L26_18
.L26_17:
	li s1, 0
	sw s1, -1172(s0)
	li s1, 0
	sw s1, -1176(s0)
	addi s1, s0, -1172
	addi s2, s0, -1176
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -1180(s0)
	lw s1, -1180(s0)
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -1180(s0)
	lw s1, -1180(s0)
	lw s2, -972(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1248
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1248
	j .L26_19
.L26_18:
	jal ra, parse_expr
	mv s1, a0
	sw s1, -1252(s0)
	addi s1, s0, -1320
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1320
	lw s1, -1252(s0)
	lw s2, -972(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L26_19:
	j .L26_20
.L26_16:
	jal ra, parse_unary
	mv s1, a0
	lw s2, -972(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L26_20:
	jal ra, cc_type_int
	mv s1, a0
	lw s2, -972(s0)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -972(s0)
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
.L26_11:
	jal ra, parse_postfix
	mv s1, a0
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
.L26_21:
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
.Lfunc_end26:
	.size parse_unary, .Lfunc_end26-parse_unary

	.text
	.align 2
	.type parse_cast, @function
parse_cast:
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
	jal ra, parse_unary
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
.Lfunc_end27:
	.size parse_cast, .Lfunc_end27-parse_cast

	.text
	.align 2
	.type binop_prec, @function
binop_prec:
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
	li s2, 71
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_0
	li s2, 72
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_1
	li s2, 73
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_2
	li s2, 69
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_3
	li s2, 70
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_4
	li s2, 87
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_5
	li s2, 88
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_6
	li s2, 83
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_7
	li s2, 84
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_8
	li s2, 85
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_9
	li s2, 86
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_10
	li s2, 81
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_11
	li s2, 82
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_12
	li s2, 74
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_13
	li s2, 76
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_14
	li s2, 75
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_15
	li s2, 79
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_16
	li s2, 80
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L28_17
	j .L28_18
.L28_0:
.L28_1:
.L28_2:
	li s1, 13
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
.L28_3:
.L28_4:
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
.L28_5:
.L28_6:
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
.L28_7:
.L28_8:
.L28_9:
.L28_10:
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
.L28_11:
.L28_12:
	li s1, 9
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
.L28_13:
	li s1, 8
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
.L28_14:
	li s1, 7
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
.L28_15:
	li s1, 6
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
.L28_16:
	li s1, 5
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
.L28_17:
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
.L28_18:
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
.L28_19:
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
.Lfunc_end28:
	.size binop_prec, .Lfunc_end28-binop_prec

	.text
	.align 2
	.type parse_binop, @function
parse_binop:
	addi sp, sp, -288
	sw ra, 284(sp)
	sw s0, 280(sp)
	addi s0, sp, 280
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
	jal ra, parse_cast
	mv s1, a0
	sw s1, -12(s0)
.L29_0:
	j .L29_1
.L29_1:
	addi s1, s0, -144
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -144
	addi s2, s0, -80
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -80
	lw s2, 0(s1)
	mv a0, s2
	jal ra, binop_prec
	mv s1, a0
	sw s1, -148(s0)
	lw s1, -148(s0)
	lw s2, -4(s0)
	slt s3, s1, s2
	bnez s3, .L29_2
	j .L29_3
.L29_2:
	j .L29_4
.L29_3:
	addi s1, s0, -216
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -216
	lw s1, -148(s0)
	li s2, 1
	add s3, s1, s2
	mv a0, s3
	jal ra, parse_binop
	mv s1, a0
	sw s1, -220(s0)
	li s1, 20
	addi s2, s0, -80
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -224(s0)
	addi s1, s0, -80
	lw s2, 0(s1)
	lw s1, -224(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -12(s0)
	lw s2, -224(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -220(s0)
	lw s2, -224(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -224(s0)
	sw s1, -12(s0)
.L29_5:
	j .L29_0
.L29_4:
	lw s1, -12(s0)
	mv a0, s1
	lw s1, -268(s0)
	lw s2, -264(s0)
	lw s3, -260(s0)
	lw s4, -256(s0)
	lw s5, -252(s0)
	lw s6, -248(s0)
	lw s7, -244(s0)
	lw s8, -240(s0)
	lw s9, -236(s0)
	lw s10, -232(s0)
	lw s11, -228(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end29:
	.size parse_binop, .Lfunc_end29-parse_binop

	.text
	.align 2
	.type parse_ternary, @function
parse_ternary:
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
	li s1, 4
	mv a0, s1
	jal ra, parse_binop
	mv s2, a0
	sw s2, -4(s0)
	li s1, 91
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L30_0
	j .L30_1
.L30_0:
	li s1, 24
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -8(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_expr
	mv s1, a0
	lw s2, -8(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	li s2, 92
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -72
	jal ra, parse_ternary
	mv s1, a0
	lw s2, -8(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L30_1:
	lw s1, -4(s0)
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
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end30:
	.size parse_ternary, .Lfunc_end30-parse_ternary

	.text
	.align 2
	.type parse_assign_expr, @function
parse_assign_expr:
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
	jal ra, parse_ternary
	mv s1, a0
	sw s1, -4(s0)
	addi s1, s0, -136
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -136
	addi s2, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 58
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L31_0
	j .L31_1
.L31_0:
	addi s1, s0, -200
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -200
	li s1, 22
	addi s2, s0, -72
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -204(s0)
	lw s1, -4(s0)
	lw s2, -204(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_assign_expr
	mv s1, a0
	lw s2, -204(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -204(s0)
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
.L31_1:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 59
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L31_2
	j .L31_3
.L31_2:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 68
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L31_4
	j .L31_3
.L31_4:
	addi s1, s0, -272
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -272
	li s1, 23
	addi s2, s0, -72
	li s3, 32
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -276(s0)
	addi s1, s0, -72
	lw s2, 0(s1)
	lw s1, -276(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	lw s2, -276(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_assign_expr
	mv s1, a0
	lw s2, -276(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
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
.L31_3:
	lw s1, -4(s0)
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
.Lfunc_end31:
	.size parse_assign_expr, .Lfunc_end31-parse_assign_expr

	.text
	.align 2
	.type parse_expr, @function
parse_expr:
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
	jal ra, parse_assign_expr
	mv s1, a0
	sw s1, -4(s0)
.L32_0:
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L32_1
	j .L32_2
.L32_1:
	li s1, 25
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -8(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_assign_expr
	mv s1, a0
	lw s2, -8(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	sw s1, -4(s0)
	j .L32_0
.L32_2:
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
.Lfunc_end32:
	.size parse_expr, .Lfunc_end32-parse_expr

	.text
	.align 2
	.type parse_local_decl, @function
parse_local_decl:
	addi sp, sp, -544
	sw ra, 540(sp)
	sw s0, 536(sp)
	addi s0, sp, 536
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
	li s1, 0
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
.L33_0:
	j .L33_1
.L33_1:
	li s1, 0
	sw s1, -28(s0)
	lw s1, -4(s0)
	addi s2, s0, -28
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -32(s0)
	li s1, 17
	jal ra, cc_lex_line
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -36(s0)
	lw s1, -28(s0)
	lw s2, -36(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -32(s0)
	lw s2, -36(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -8(s0)
	lw s2, -36(s0)
	li s3, 84
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	lw s2, -36(s0)
	li s3, 88
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -104
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -104
	lw s2, 0(s1)
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L33_2
	j .L33_3
.L33_2:
	addi s1, s0, -232
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -232
	addi s1, s0, -296
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -296
	addi s1, s0, -360
	li s2, 3
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -360
	addi s2, s0, -168
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -424
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -424
	addi s1, s0, -168
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -36(s0)
	li s3, 72
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -168
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -36(s0)
	li s3, 76
	add s4, s2, s3
	sw s1, 0(s4)
.L33_3:
	lw s1, -28(s0)
	bnez s1, .L33_4
	j .L33_5
.L33_4:
	lw s1, -28(s0)
	li s2, 0
	lw s3, -32(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, add_sym
	mv s5, a0
.L33_5:
	li s1, 58
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L33_6
	j .L33_7
.L33_6:
	jal ra, parse_initializer
	mv s1, a0
	lw s2, -36(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L33_7:
	lw s1, -20(s0)
	bnez s1, .L33_8
	j .L33_9
.L33_9:
	lw s1, -36(s0)
	sw s1, -20(s0)
	j .L33_10
.L33_8:
	lw s1, -36(s0)
	lw s2, -24(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
.L33_10:
	lw s1, -36(s0)
	sw s1, -24(s0)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L33_11
	j .L33_12
.L33_12:
	j .L33_13
.L33_11:
.L33_14:
	j .L33_0
.L33_13:
	addi s1, s0, -488
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -488
	lw s1, -20(s0)
	mv a0, s1
	lw s1, -532(s0)
	lw s2, -528(s0)
	lw s3, -524(s0)
	lw s4, -520(s0)
	lw s5, -516(s0)
	lw s6, -512(s0)
	lw s7, -508(s0)
	lw s8, -504(s0)
	lw s9, -500(s0)
	lw s10, -496(s0)
	lw s11, -492(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end33:
	.size parse_local_decl, .Lfunc_end33-parse_local_decl

	.text
	.align 2
	.type parse_asm_operands, @function
parse_asm_operands:
	addi sp, sp, -464
	sw ra, 460(sp)
	sw s0, 456(sp)
	addi s0, sp, 456
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
	li s1, 0
	sw s1, -16(s0)
	addi s1, s0, -80
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -80
	lw s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L34_0
	j .L34_1
.L34_1:
	addi s1, s0, -144
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -144
	lw s2, 0(s1)
	li s1, 48
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L34_0
	j .L34_2
.L34_0:
	li s1, 0
	mv a0, s1
	lw s1, -452(s0)
	lw s2, -448(s0)
	lw s3, -444(s0)
	lw s4, -440(s0)
	lw s5, -436(s0)
	lw s6, -432(s0)
	lw s7, -428(s0)
	lw s8, -424(s0)
	lw s9, -420(s0)
	lw s10, -416(s0)
	lw s11, -412(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L34_2:
.L34_3:
	j .L34_4
.L34_4:
	jal ra, cc_lex_line
	mv s1, a0
	sw s1, -148(s0)
	li s1, 19
	lw s2, -148(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -152(s0)
	addi s1, s0, -280
	li s2, 3
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -280
	addi s2, s0, -216
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -216
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -152(s0)
	li s3, 72
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -216
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -152(s0)
	li s3, 76
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	bnez s1, .L34_5
	j .L34_6
.L34_5:
	addi s1, s0, -344
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -344
	jal ra, parse_assign_expr
	mv s1, a0
	lw s2, -152(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -408
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -408
.L34_6:
	lw s1, -12(s0)
	bnez s1, .L34_7
	j .L34_8
.L34_8:
	lw s1, -152(s0)
	sw s1, -12(s0)
	j .L34_9
.L34_7:
	lw s1, -152(s0)
	lw s2, -16(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
.L34_9:
	lw s1, -152(s0)
	sw s1, -16(s0)
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L34_10
	j .L34_11
.L34_11:
	j .L34_12
.L34_10:
.L34_13:
	j .L34_3
.L34_12:
	lw s1, -12(s0)
	mv a0, s1
	lw s1, -452(s0)
	lw s2, -448(s0)
	lw s3, -444(s0)
	lw s4, -440(s0)
	lw s5, -436(s0)
	lw s6, -432(s0)
	lw s7, -428(s0)
	lw s8, -424(s0)
	lw s9, -420(s0)
	lw s10, -416(s0)
	lw s11, -412(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end34:
	.size parse_asm_operands, .Lfunc_end34-parse_asm_operands

	.text
	.align 2
	.type parse_stmt, @function
parse_stmt:
	li t6, -3536
	add sp, sp, t6
	li t6, 3532
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 3528
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 3528
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
	jal ra, cc_lex_line
	mv s1, a0
	sw s1, -4(s0)
	addi s1, s0, -136
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -136
	addi s2, s0, -72
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -72
	addi s2, s0, -200
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -200
	mv a0, s1
	jal ra, is_type_start
	mv s2, a0
	bnez s2, .L35_0
	j .L35_1
.L35_0:
	li s1, 0
	sw s1, -204(s0)
	li s1, 0
	sw s1, -208(s0)
	addi s1, s0, -204
	addi s2, s0, -208
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -212(s0)
	lw s1, -212(s0)
	lw s2, -204(s0)
	lw s3, -208(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_local_decl
	mv s4, a0
	mv a0, s4
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_1:
	addi s1, s0, -72
	lw s2, 0(s1)
	li s1, 49
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_2
	li s1, 29
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_3
	li s1, 31
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_4
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_5
	li s1, 33
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_6
	li s1, 34
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_7
	li s1, 35
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_8
	li s1, 36
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_9
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_10
	li s1, 38
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_11
	li s1, 39
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_12
	li s1, 40
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_13
	li s1, 46
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_14
	li s1, 5
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_15
	li s1, 53
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L35_16
	j .L35_17
.L35_2:
	jal ra, parse_block
	mv s1, a0
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_3:
	addi s1, s0, -280
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -280
	li s1, 4
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -284(s0)
	addi s1, s0, -352
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -352
	jal ra, parse_expr
	mv s1, a0
	lw s2, -284(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -416
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -416
	jal ra, parse_stmt
	mv s1, a0
	lw s2, -284(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 30
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_18
	j .L35_19
.L35_18:
	jal ra, parse_stmt
	mv s1, a0
	lw s2, -284(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
.L35_19:
	lw s1, -284(s0)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_4:
	addi s1, s0, -480
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -480
	li s1, 5
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -484(s0)
	addi s1, s0, -552
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -552
	jal ra, parse_expr
	mv s1, a0
	lw s2, -484(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -616
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -616
	jal ra, parse_stmt
	mv s1, a0
	lw s2, -484(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -484(s0)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_5:
	addi s1, s0, -680
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -680
	li s1, 6
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -684(s0)
	jal ra, parse_stmt
	mv s1, a0
	lw s2, -684(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -752
	li s2, 31
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -752
	addi s1, s0, -816
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -816
	jal ra, parse_expr
	mv s1, a0
	lw s2, -684(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -880
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -880
	addi s1, s0, -944
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -944
	lw s1, -684(s0)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_6:
	addi s1, s0, -1008
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1008
	li s1, 7
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -1012(s0)
	addi s1, s0, -1080
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1080
	li s1, 53
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_20
	j .L35_21
.L35_21:
	addi s1, s0, -1144
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -1144
	addi s2, s0, -1208
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1208
	mv a0, s1
	jal ra, is_type_start
	mv s2, a0
	bnez s2, .L35_22
	j .L35_23
.L35_22:
	li s1, 0
	sw s1, -1212(s0)
	li s1, 0
	sw s1, -1216(s0)
	addi s1, s0, -1212
	addi s2, s0, -1216
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -1220(s0)
	lw s1, -1220(s0)
	lw s2, -1212(s0)
	lw s3, -1216(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_local_decl
	mv s4, a0
	lw s1, -1012(s0)
	li s2, 24
	add s3, s1, s2
	sw s4, 0(s3)
	j .L35_24
.L35_23:
	li s1, 16
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	lw s1, -1012(s0)
	li s2, 24
	add s4, s1, s2
	sw s3, 0(s4)
	jal ra, parse_expr
	mv s1, a0
	lw s2, -1012(s0)
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1288
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1288
.L35_24:
.L35_20:
	li s1, 53
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_25
	j .L35_26
.L35_26:
	jal ra, parse_expr
	mv s1, a0
	lw s2, -1012(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1352
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1352
.L35_25:
	addi s1, s0, -1416
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -1416
	lw s2, 0(s1)
	li s1, 48
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L35_27
	j .L35_28
.L35_27:
	jal ra, parse_expr
	mv s1, a0
	lw s2, -1012(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
.L35_28:
	addi s1, s0, -1480
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1480
	jal ra, parse_stmt
	mv s1, a0
	lw s2, -1012(s0)
	li s3, 36
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1012(s0)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_7:
	addi s1, s0, -1544
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1544
	li s1, 8
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -1548(s0)
	addi s1, s0, -1616
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1616
	jal ra, parse_expr
	mv s1, a0
	lw s2, -1548(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1680
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1680
	jal ra, parse_stmt
	mv s1, a0
	lw s2, -1548(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1548(s0)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_8:
	addi s1, s0, -1744
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1744
	li s1, 9
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -1748(s0)
	jal ra, parse_expr
	mv s1, a0
	lw s2, -1748(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -1816
	li s2, 92
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1816
	jal ra, parse_stmt
	mv s1, a0
	lw s2, -1748(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1748(s0)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_9:
	addi s1, s0, -1880
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -1880
	li s1, 10
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -1884(s0)
	addi s1, s0, -1952
	li s2, 92
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -1952
	jal ra, parse_stmt
	mv s1, a0
	lw s2, -1884(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -1884(s0)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_10:
	addi s1, s0, -2016
	mv a0, s1
	jal ra, next
	mv s2, a0
	addi s1, s0, -2016
	li t6, -2080
	add s1, s0, t6
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2080
	add s1, s0, t6
	li s1, 11
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	mv a0, s3
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_11:
	li t6, -2144
	add s1, s0, t6
	mv a0, s1
	jal ra, next
	mv s2, a0
	li t6, -2144
	add s1, s0, t6
	li t6, -2208
	add s1, s0, t6
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2208
	add s1, s0, t6
	li s1, 12
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	mv a0, s3
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_12:
	li t6, -2272
	add s1, s0, t6
	mv a0, s1
	jal ra, next
	mv s2, a0
	li t6, -2272
	add s1, s0, t6
	li s1, 13
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	li t6, -2276
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -2344
	add s1, s0, t6
	mv a0, s1
	jal ra, peek
	mv s2, a0
	li t6, -2344
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 53
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L35_29
	j .L35_30
.L35_29:
	jal ra, parse_expr
	mv s1, a0
	li t6, -2276
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L35_30:
	li t6, -2408
	add s1, s0, t6
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2408
	add s1, s0, t6
	li t6, -2276
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_13:
	li t6, -2472
	add s1, s0, t6
	mv a0, s1
	jal ra, next
	mv s2, a0
	li t6, -2472
	add s1, s0, t6
	li s1, 14
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	li t6, -2476
	add t6, s0, t6
	sw s3, 0(t6)
	li s1, 71
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_31
	j .L35_32
.L35_31:
	jal ra, parse_expr
	mv s1, a0
	li t6, -2476
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	j .L35_33
.L35_32:
	li t6, -2608
	add s1, s0, t6
	li s2, 5
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2608
	add s1, s0, t6
	li t6, -2544
	add s2, s0, t6
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2544
	add s1, s0, t6
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2476
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
.L35_33:
	li t6, -2672
	add s1, s0, t6
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2672
	add s1, s0, t6
	li t6, -2476
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_14:
	li s1, 18
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	li t6, -2676
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -2808
	add s1, s0, t6
	mv a0, s1
	jal ra, next
	mv s2, a0
	li t6, -2808
	add s1, s0, t6
	li s1, 22
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_34
	j .L35_35
.L35_34:
	li s1, 1
	li t6, -2812
	add t6, s0, t6
	sw s1, 0(t6)
	j .L35_36
.L35_35:
	li s1, 0
	li t6, -2812
	add t6, s0, t6
	sw s1, 0(t6)
.L35_36:
	li t6, -2812
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -2676
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 56
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	li t6, -2880
	add s1, s0, t6
	li s2, 47
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2880
	add s1, s0, t6
	li t6, -2944
	add s1, s0, t6
	li s2, 3
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -2944
	add s1, s0, t6
	li t6, -2744
	add s2, s0, t6
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2744
	add s1, s0, t6
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2676
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 72
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -2744
	add s1, s0, t6
	li s2, 28
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -2676
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 76
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 92
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_37
	j .L35_38
.L35_37:
	li s1, 1
	mv a0, s1
	jal ra, parse_asm_operands
	mv s2, a0
	li t6, -2676
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 92
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_39
	j .L35_40
.L35_39:
	li s1, 1
	mv a0, s1
	jal ra, parse_asm_operands
	mv s2, a0
	li t6, -2676
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 28
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 92
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_41
	j .L35_42
.L35_41:
	li s1, 0
	mv a0, s1
	jal ra, parse_asm_operands
	mv s2, a0
	li t6, -2676
	add t6, s0, t6
	lw s1, 0(t6)
	li s3, 32
	add s4, s1, s3
	sw s2, 0(s4)
.L35_42:
.L35_40:
.L35_38:
	li t6, -3008
	add s1, s0, t6
	li s2, 48
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -3008
	add s1, s0, t6
	li t6, -3072
	add s1, s0, t6
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -3072
	add s1, s0, t6
	li t6, -2676
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_15:
	li t6, -3200
	add s1, s0, t6
	mv a0, s1
	jal ra, next
	mv s2, a0
	li t6, -3200
	add s1, s0, t6
	li t6, -3136
	add s2, s0, t6
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 92
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L35_43
	j .L35_44
.L35_43:
	li s1, 15
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	li t6, -3204
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -3136
	add s1, s0, t6
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li t6, -3204
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, parse_stmt
	mv s1, a0
	li t6, -3204
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -3204
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_44:
	li t6, -3136
	add s1, s0, t6
	li t6, -3272
	add s2, s0, t6
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
	lw s1, 0(s4)
	li s3, 60
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -3272
	add s1, s0, t6
	mv a0, s1
	jal ra, ungettok
	mv s2, a0
	li s1, 16
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	li t6, -3276
	add t6, s0, t6
	sw s3, 0(t6)
	jal ra, parse_expr
	mv s1, a0
	li t6, -3276
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -3344
	add s1, s0, t6
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -3344
	add s1, s0, t6
	li t6, -3276
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_16:
	li t6, -3408
	add s1, s0, t6
	mv a0, s1
	jal ra, next
	mv s2, a0
	li t6, -3408
	add s1, s0, t6
	li s1, 16
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	mv a0, s3
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_17:
	li s1, 16
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	li t6, -3412
	add t6, s0, t6
	sw s3, 0(t6)
	jal ra, parse_expr
	mv s1, a0
	li t6, -3412
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
	li t6, -3480
	add s1, s0, t6
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	li t6, -3480
	add s1, s0, t6
	li t6, -3412
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_45:
	li s1, 0
	mv a0, s1
	li t6, -3524
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -3520
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -3516
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -3512
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -3508
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -3504
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -3500
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -3496
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -3492
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -3488
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -3484
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end35:
	.size parse_stmt, .Lfunc_end35-parse_stmt

	.text
	.align 2
	.type parse_block, @function
parse_block:
	addi sp, sp, -224
	sw ra, 220(sp)
	sw s0, 216(sp)
	addi s0, sp, 216
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
	jal ra, cc_lex_line
	mv s1, a0
	sw s1, -4(s0)
	addi s1, s0, -72
	li s2, 49
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -72
	jal ra, push_scope
	mv s1, a0
	li s1, 3
	lw s2, -4(s0)
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -76(s0)
	li s1, 0
	sw s1, -80(s0)
	li s1, 0
	sw s1, -84(s0)
.L36_0:
	li s1, 50
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L36_1
	j .L36_2
.L36_2:
	addi s1, s0, -152
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -152
	lw s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L36_3
	j .L36_4
.L36_3:
	jal ra, parse_static_assert
	mv s1, a0
	j .L36_0
.L36_4:
	jal ra, parse_stmt
	mv s1, a0
	sw s1, -156(s0)
.L36_5:
	lw s1, -156(s0)
	bnez s1, .L36_6
	j .L36_7
.L36_6:
	lw s1, -156(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -160(s0)
	li s1, 0
	lw s2, -156(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -80(s0)
	bnez s1, .L36_8
	j .L36_9
.L36_9:
	lw s1, -156(s0)
	sw s1, -80(s0)
	j .L36_10
.L36_8:
	lw s1, -156(s0)
	lw s2, -84(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
.L36_10:
	lw s1, -156(s0)
	sw s1, -84(s0)
	lw s1, -160(s0)
	sw s1, -156(s0)
	j .L36_5
.L36_7:
	j .L36_0
.L36_1:
	lw s1, -80(s0)
	lw s2, -76(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, pop_scope
	mv s1, a0
	lw s1, -76(s0)
	mv a0, s1
	lw s1, -204(s0)
	lw s2, -200(s0)
	lw s3, -196(s0)
	lw s4, -192(s0)
	lw s5, -188(s0)
	lw s6, -184(s0)
	lw s7, -180(s0)
	lw s8, -176(s0)
	lw s9, -172(s0)
	lw s10, -168(s0)
	lw s11, -164(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end36:
	.size parse_block, .Lfunc_end36-parse_block

	.text
	.align 2
	.type parse_top_decl, @function
parse_top_decl:
	addi sp, sp, -384
	sw ra, 380(sp)
	sw s0, 376(sp)
	addi s0, sp, 376
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
	addi s1, s0, -64
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L37_0
	j .L37_1
.L37_0:
	jal ra, parse_static_assert
	mv s1, a0
	li s1, 0
	mv a0, s1
	lw s1, -372(s0)
	lw s2, -368(s0)
	lw s3, -364(s0)
	lw s4, -360(s0)
	lw s5, -356(s0)
	lw s6, -352(s0)
	lw s7, -348(s0)
	lw s8, -344(s0)
	lw s9, -340(s0)
	lw s10, -336(s0)
	lw s11, -332(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_1:
	li s1, 0
	sw s1, -68(s0)
	li s1, 0
	sw s1, -72(s0)
	li s1, 0
	sw s1, -76(s0)
	addi s1, s0, -68
	addi s2, s0, -72
	addi s3, s0, -76
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, parse_declspec
	mv s4, a0
	sw s4, -80(s0)
	la s1, declspec_alignas
	lw s2, 0(s1)
	sw s2, -84(s0)
	la s1, declspec_inline
	lw s2, 0(s1)
	sw s2, -88(s0)
	li s1, 53
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L37_2
	j .L37_3
.L37_2:
	li s1, 0
	mv a0, s1
	lw s1, -372(s0)
	lw s2, -368(s0)
	lw s3, -364(s0)
	lw s4, -360(s0)
	lw s5, -356(s0)
	lw s6, -352(s0)
	lw s7, -348(s0)
	lw s8, -344(s0)
	lw s9, -340(s0)
	lw s10, -336(s0)
	lw s11, -332(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_3:
	li s1, 0
	sw s1, -92(s0)
	lw s1, -80(s0)
	addi s2, s0, -92
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -96(s0)
	lw s1, -92(s0)
	bnez s1, .L37_4
	j .L37_5
.L37_5:
	la s1, __str_21
	jal ra, cc_lex_line
	mv s2, a0
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L37_4:
	lw s1, -76(s0)
	bnez s1, .L37_6
	j .L37_7
.L37_6:
	lw s1, -92(s0)
	li s2, 1
	lw s3, -96(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, add_sym
	mv s5, a0
.L37_8:
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L37_9
	j .L37_10
.L37_9:
	li s1, 0
	sw s1, -100(s0)
	lw s1, -80(s0)
	addi s2, s0, -100
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -104(s0)
	lw s1, -100(s0)
	bnez s1, .L37_11
	j .L37_12
.L37_12:
	la s1, __str_22
	jal ra, cc_lex_line
	mv s2, a0
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L37_11:
	lw s1, -100(s0)
	li s2, 1
	lw s3, -104(s0)
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, add_sym
	mv s5, a0
	j .L37_8
.L37_10:
	addi s1, s0, -168
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -168
	li s1, 0
	mv a0, s1
	lw s1, -372(s0)
	lw s2, -368(s0)
	lw s3, -364(s0)
	lw s4, -360(s0)
	lw s5, -356(s0)
	lw s6, -352(s0)
	lw s7, -348(s0)
	lw s8, -344(s0)
	lw s9, -340(s0)
	lw s10, -336(s0)
	lw s11, -332(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_7:
	lw s1, -96(s0)
	lw s2, 0(s1)
	li s1, 12
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L37_13
	j .L37_14
.L37_13:
	addi s1, s0, -232
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -232
	lw s2, 0(s1)
	li s1, 49
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L37_15
	j .L37_14
.L37_15:
	li s1, 1
	jal ra, cc_lex_line
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -236(s0)
	jal ra, cc_lex_file
	mv s1, a0
	lw s2, -236(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -92(s0)
	lw s2, -236(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -96(s0)
	lw s2, -236(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -68(s0)
	lw s2, -236(s0)
	li s3, 84
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -88(s0)
	lw s2, -236(s0)
	li s3, 92
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, push_scope
	mv s1, a0
	lw s1, -96(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -240(s0)
.L37_16:
	lw s1, -240(s0)
	bnez s1, .L37_17
	j .L37_18
.L37_17:
	lw s1, -240(s0)
	lw s2, 0(s1)
	bnez s2, .L37_19
	j .L37_20
.L37_19:
	lw s1, -240(s0)
	lw s2, 0(s1)
	li s1, 0
	lw s3, -240(s0)
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	li s4, 0
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, add_sym
	mv s5, a0
.L37_20:
.L37_21:
	lw s1, -240(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -240(s0)
	j .L37_16
.L37_18:
	jal ra, parse_block
	mv s1, a0
	lw s2, -236(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, pop_scope
	mv s1, a0
	lw s1, -236(s0)
	mv a0, s1
	lw s1, -372(s0)
	lw s2, -368(s0)
	lw s3, -364(s0)
	lw s4, -360(s0)
	lw s5, -356(s0)
	lw s6, -352(s0)
	lw s7, -348(s0)
	lw s8, -344(s0)
	lw s9, -340(s0)
	lw s10, -336(s0)
	lw s11, -332(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_14:
	li s1, 0
	sw s1, -244(s0)
	li s1, 0
	sw s1, -248(s0)
	li s1, 2
	jal ra, cc_lex_line
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -252(s0)
	lw s1, -92(s0)
	lw s2, -252(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -96(s0)
	lw s2, -252(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -68(s0)
	lw s2, -252(s0)
	li s3, 84
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -72(s0)
	lw s2, -252(s0)
	li s3, 88
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -84(s0)
	lw s2, -252(s0)
	li s3, 96
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 58
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L37_22
	j .L37_23
.L37_22:
	jal ra, parse_initializer
	mv s1, a0
	lw s2, -252(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L37_23:
	lw s1, -252(s0)
	sw s1, -244(s0)
	lw s1, -252(s0)
	sw s1, -248(s0)
.L37_24:
	li s1, 54
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L37_25
	j .L37_26
.L37_25:
	li s1, 0
	sw s1, -256(s0)
	lw s1, -80(s0)
	addi s2, s0, -256
	mv a0, s1
	mv a1, s2
	jal ra, parse_declarator
	mv s3, a0
	sw s3, -260(s0)
	lw s1, -256(s0)
	bnez s1, .L37_27
	j .L37_28
.L37_28:
	la s1, __str_23
	jal ra, cc_lex_line
	mv s2, a0
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L37_27:
	li s1, 2
	jal ra, cc_lex_line
	mv s2, a0
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -264(s0)
	lw s1, -256(s0)
	lw s2, -264(s0)
	li s3, 48
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -260(s0)
	lw s2, -264(s0)
	li s3, 80
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -68(s0)
	lw s2, -264(s0)
	li s3, 84
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -72(s0)
	lw s2, -264(s0)
	li s3, 88
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -84(s0)
	lw s2, -264(s0)
	li s3, 96
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 58
	mv a0, s1
	jal ra, consume
	mv s2, a0
	bnez s2, .L37_29
	j .L37_30
.L37_29:
	jal ra, parse_initializer
	mv s1, a0
	lw s2, -264(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L37_30:
	lw s1, -264(s0)
	lw s2, -248(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -264(s0)
	sw s1, -248(s0)
	j .L37_24
.L37_26:
	addi s1, s0, -328
	li s2, 53
	mv a0, s1
	mv a1, s2
	jal ra, expect
	mv s3, a0
	addi s1, s0, -328
	lw s1, -244(s0)
	mv a0, s1
	lw s1, -372(s0)
	lw s2, -368(s0)
	lw s3, -364(s0)
	lw s4, -360(s0)
	lw s5, -356(s0)
	lw s6, -352(s0)
	lw s7, -348(s0)
	lw s8, -344(s0)
	lw s9, -340(s0)
	lw s10, -336(s0)
	lw s11, -332(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end37:
	.size parse_top_decl, .Lfunc_end37-parse_top_decl

	.text
	.align 2
	.globl cc_parse_program
	.type cc_parse_program, @function
cc_parse_program:
	addi sp, sp, -240
	sw ra, 236(sp)
	sw s0, 232(sp)
	addi s0, sp, 232
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
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
	lw s1, -4(s0)
	la s2, parse_arena
	sw s1, 0(s2)
	li s1, 0
	la s2, cur_scope
	sw s1, 0(s2)
	li s1, 0
	la s2, tags
	sw s1, 0(s2)
	li s1, 0
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, node
	mv s3, a0
	sw s3, -12(s0)
	jal ra, push_scope
	mv s1, a0
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -24(s0)
	li s1, 3
	lw s2, -24(s0)
	sw s1, 0(s2)
	li s1, 1
	lw s2, -24(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	jal ra, cc_type_int
	mv s1, a0
	sw s1, -28(s0)
	la s1, parse_arena
	lw s2, 0(s1)
	jal ra, cc_type_void
	mv s1, a0
	mv a0, s2
	mv a1, s1
	jal ra, cc_type_ptr
	mv s3, a0
	sw s3, -32(s0)
	lw s1, -28(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -52
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
	la s2, __str_24
	sw s2, 0(s1)
	la s2, __str_25
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_26
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	la s2, __str_27
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
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
	lw s2, -24(s0)
	sw s2, 0(s1)
	lw s2, -24(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s2, -32(s0)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	lw s2, -32(s0)
	li s3, 12
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	li s3, 16
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 4
	sw s1, -76(s0)
	li s1, 0
	sw s1, -100(s0)
.L38_0:
	lw s1, -100(s0)
	lw s2, -76(s0)
	slt s3, s1, s2
	bnez s3, .L38_1
	j .L38_2
.L38_1:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 24
	mv a0, s2
	mv a1, s1
	jal ra, arena_alloc
	mv s3, a0
	addi s1, s0, -96
	lw s2, -100(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
	addi s1, s0, -96
	lw s2, -100(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	li s3, 24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	la s1, parse_arena
	lw s2, 0(s1)
	addi s1, s0, -52
	lw s3, -100(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	addi s1, s0, -96
	lw s2, -100(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	sw s3, 0(s1)
	addi s1, s0, -72
	lw s2, -100(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -96
	lw s3, -100(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	addi s2, s0, -96
	lw s3, -100(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -100(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L38_3
	j .L38_4
.L38_3:
	addi s1, s0, -96
	lw s2, -100(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	addi s2, s0, -96
	lw s3, -100(s0)
	li s4, 1
	sub s5, s3, s4
	li s3, 4
	mul s4, s5, s3
	add s3, s2, s4
	lw s2, 0(s3)
	li s3, 20
	add s4, s2, s3
	sw s1, 0(s4)
.L38_4:
.L38_5:
	addi s1, s0, -100
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -100(s0)
	j .L38_0
.L38_2:
	la s1, parse_arena
	lw s2, 0(s1)
	li s1, 52
	mv a0, s2
	mv a1, s1
	jal ra, arena_zalloc
	mv s3, a0
	sw s3, -104(s0)
	li s1, 13
	lw s2, -104(s0)
	sw s1, 0(s2)
	la s1, parse_arena
	lw s2, 0(s1)
	la s1, __str_28
	mv a0, s2
	mv a1, s1
	jal ra, arena_strdup
	mv s3, a0
	lw s1, -104(s0)
	li s2, 36
	add s4, s1, s2
	sw s3, 0(s4)
	addi s1, s0, -96
	li s2, 0
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -104(s0)
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -104(s0)
	mv a0, s1
	jal ra, layout_struct
	mv s2, a0
	la s1, __str_29
	lw s2, -104(s0)
	mv a0, s1
	mv a1, s2
	jal ra, add_tag
	mv s3, a0
	la s1, __str_30
	li s2, 1
	la s3, parse_arena
	lw s4, 0(s3)
	lw s3, -104(s0)
	li s5, 1
	mv a0, s4
	mv a1, s3
	mv a2, s5
	jal ra, cc_type_array
	mv s6, a0
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s6
	mv a3, s3
	jal ra, add_sym
	mv s4, a0
.L38_6:
	addi s1, s0, -168
	mv a0, s1
	jal ra, peek
	mv s2, a0
	addi s1, s0, -168
	lw s2, 0(s1)
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L38_7
	j .L38_8
.L38_7:
	jal ra, parse_top_decl
	mv s1, a0
	sw s1, -172(s0)
.L38_9:
	lw s1, -172(s0)
	bnez s1, .L38_10
	j .L38_11
.L38_10:
	lw s1, -172(s0)
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -176(s0)
	li s1, 0
	lw s2, -172(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -16(s0)
	bnez s1, .L38_12
	j .L38_13
.L38_13:
	lw s1, -172(s0)
	sw s1, -16(s0)
	j .L38_14
.L38_12:
	lw s1, -172(s0)
	lw s2, -20(s0)
	li s3, 40
	add s4, s2, s3
	sw s1, 0(s4)
.L38_14:
	lw s1, -172(s0)
	sw s1, -20(s0)
	lw s1, -176(s0)
	sw s1, -172(s0)
	j .L38_9
.L38_11:
	j .L38_6
.L38_8:
	jal ra, pop_scope
	mv s1, a0
	lw s1, -16(s0)
	lw s2, -12(s0)
	li s3, 44
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -12(s0)
	mv a0, s1
	lw s1, -220(s0)
	lw s2, -216(s0)
	lw s3, -212(s0)
	lw s4, -208(s0)
	lw s5, -204(s0)
	lw s6, -200(s0)
	lw s7, -196(s0)
	lw s8, -192(s0)
	lw s9, -188(s0)
	lw s10, -184(s0)
	lw s11, -180(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end38:
	.size cc_parse_program, .Lfunc_end38-cc_parse_program

	.data
	.align 2
__str_30:
	.ascii "__builtin_va_list\000"
	.align 2
__str_29:
	.ascii "__va_list_tag\000"
	.align 2
__str_28:
	.ascii "__va_list_tag\000"
	.align 2
__str_27:
	.ascii "reg_save_area\000"
	.align 2
__str_26:
	.ascii "overflow_arg_area\000"
	.align 2
__str_25:
	.ascii "fp_offset\000"
	.align 2
__str_24:
	.ascii "gp_offset\000"
	.align 2
__str_23:
	.ascii "parse error at line %d: declarator has no name\000"
	.align 2
__str_22:
	.ascii "parse error at line %d: declarator has no name\000"
	.align 2
__str_21:
	.ascii "parse error at line %d: declarator has no name\000"
	.align 2
__str_20:
	.ascii "__builtin_va_arg\000"
	.align 2
__str_19:
	.ascii "unexpected token %d at line %d in expression\000"
	.align 2
__str_18:
	.ascii "_Generic: more than one default association at line %d\000"
	.align 2
__str_17:
	.ascii "parse error at line %d: array designator must be a constant\000"
	.align 2
__str_16:
	.ascii "too many array dimensions at line %d\000"
	.align 2
__str_15:
	.ascii "static assertion failed at line %d\000"
	.align 2
__str_14:
	.ascii "static assertion failed at line %d: %s\000"
	.align 2
__str_13:
	.ascii "expected constant expression at line %d\000"
	.align 2
__str_12:
	.ascii "expected constant expression at line %d\000"
	.align 2
__str_11:
	.ascii "string literal index %lld out of range at line %d\000"
	.align 2
__str_10:
	.ascii "unsupported unary operator in constant expression\000"
	.align 2
__str_9:
	.ascii "unsupported operator in constant expression\000"
	.align 2
__str_8:
	.ascii "expected constant expression\000"
	.align 2
__str_7:
	.ascii "expected type specifier at line %d\000"
	.align 2
__str_6:
	.ascii "parse error at line %d: bit-field width must be a constant\000"
	.align 2
__str_5:
	.ascii "token\000"
	.align 2
__str_4:
	.ascii "token\000"
	.align 2
__str_3:
	.ascii "parse error at line %d in %s: unexpected %s [%d] (expected %s [%d])\000"
	.align 2
__str_2:
	.ascii "token\000"
	.align 2
__str_1:
	.ascii "token\000"
	.align 2
__str_0:
	.ascii "parse error at line %d in %s: unexpected %s [%d] \"%s\" (expected %s [%d])\000"
	.align 2
	.globl cc_const_sizeof_typer
cc_const_sizeof_typer:
	.word 0

	.bss
	.align 2
	.globl declspec_inline
declspec_inline:
	.space 4
	.align 2
	.globl declspec_alignas
declspec_alignas:
	.space 4
	.align 2
	.globl have_cur
have_cur:
	.space 4
	.align 3
	.globl cur
cur:
	.space 64
	.align 2
	.globl tags
tags:
	.space 4
	.align 2
	.globl cur_scope
cur_scope:
	.space 4
	.align 2
	.globl parse_arena
parse_arena:
	.space 4
