# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type remap_sym, @function
remap_sym:
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
.L1_0:
	lw s1, -12(s0)
	li s2, 128
	li s3, 8
	div s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L1_1
	j .L1_2
.L1_1:
	lw s1, -4(s0)
	la s2, remap_sym.tab.0
	lw s3, -12(s0)
	li s4, 8
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L1_3
	j .L1_4
.L1_3:
	la s1, remap_sym.tab.0
	lw s2, -12(s0)
	li s3, 8
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
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
.L1_4:
.L1_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L1_0
.L1_2:
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
	.size remap_sym, .Lfunc_end1-remap_sym

	.text
	.align 2
	.type kp_slurp, @function
kp_slurp:
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
	la s2, __str_32
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -12(s0)
	lw s1, -12(s0)
	bnez s1, .L2_0
	j .L2_1
.L2_1:
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
.L2_0:
	lw s1, -12(s0)
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
	bnez s2, .L2_2
	j .L2_3
.L2_3:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, ftell
	mv s2, a0
	sw s2, -16(s0)
	li s1, 0
	slt s3, s2, s1
	bnez s3, .L2_2
	j .L2_4
.L2_2:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
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
.L2_4:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, rewind
	mv s2, a0
	lw s1, -16(s0)
	li s2, 1
	add s3, s1, s2
	mv a0, s3
	jal ra, malloc
	mv s1, a0
	sw s1, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L2_5
	j .L2_6
.L2_6:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
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
.L2_5:
	lw s1, -20(s0)
	li s2, 1
	lw s3, -16(s0)
	lw s4, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fread
	mv s5, a0
	lw s1, -16(s0)
	xor s2, s5, s1
	snez s2, s2
	bnez s2, .L2_7
	j .L2_8
.L2_7:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
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
.L2_8:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	li s1, 0
	lw s2, -20(s0)
	lw s3, -16(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -16(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -20(s0)
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
.Lfunc_end2:
	.size kp_slurp, .Lfunc_end2-kp_slurp

	.text
	.align 2
	.globl main
	.type main, @function
main:
	addi sp, sp, -448
	sw ra, 444(sp)
	sw s0, 440(sp)
	addi s0, sp, 440
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
	li s1, 0
	sw s1, -16(s0)
	li s1, 1
	sw s1, -356(s0)
.L3_0:
	lw s1, -356(s0)
	lw s2, -4(s0)
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	lw s1, -8(s0)
	lw s2, -356(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_33
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_3
	j .L3_4
.L3_4:
	lw s1, -8(s0)
	lw s2, -356(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_34
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_3
	j .L3_5
.L3_3:
	la s1, __str_35
	mv a0, s1
	jal ra, printf
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -428(s0)
	lw s2, -424(s0)
	lw s3, -420(s0)
	lw s4, -416(s0)
	lw s5, -412(s0)
	lw s6, -408(s0)
	lw s7, -404(s0)
	lw s8, -400(s0)
	lw s9, -396(s0)
	lw s10, -392(s0)
	lw s11, -388(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	j .L3_6
.L3_5:
	lw s1, -8(s0)
	lw s2, -356(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_36
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_7
	j .L3_8
.L3_7:
	lw s1, -356(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -4(s0)
	slt s2, s3, s1
	bnez s2, .L3_9
	j .L3_8
.L3_9:
	lw s1, -8(s0)
	addi s2, s0, -356
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -356(s0)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	sw s1, -16(s0)
	j .L3_10
.L3_8:
	lw s1, -8(s0)
	lw s2, -356(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 45
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_11
	j .L3_12
.L3_11:
	lw s1, -12(s0)
	bnez s1, .L3_12
	j .L3_13
.L3_13:
	lw s1, -8(s0)
	lw s2, -356(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -12(s0)
.L3_12:
.L3_10:
.L3_6:
.L3_14:
	addi s1, s0, -356
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -356(s0)
	j .L3_0
.L3_2:
	lw s1, -12(s0)
	bnez s1, .L3_15
	j .L3_16
.L3_16:
	la s1, __libc_stderr
	la s2, __str_37
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	li s1, 2
	mv a0, s1
	lw s1, -428(s0)
	lw s2, -424(s0)
	lw s3, -420(s0)
	lw s4, -416(s0)
	lw s5, -412(s0)
	lw s6, -408(s0)
	lw s7, -404(s0)
	lw s8, -400(s0)
	lw s9, -396(s0)
	lw s10, -392(s0)
	lw s11, -388(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_15:
	lw s1, -12(s0)
	addi s2, s0, -24
	mv a0, s1
	mv a1, s2
	jal ra, kp_slurp
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L3_17
	j .L3_18
.L3_18:
	la s1, __libc_stderr
	la s2, __str_38
	lw s3, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	li s1, 1
	mv a0, s1
	lw s1, -428(s0)
	lw s2, -424(s0)
	lw s3, -420(s0)
	lw s4, -416(s0)
	lw s5, -412(s0)
	lw s6, -408(s0)
	lw s7, -404(s0)
	lw s8, -400(s0)
	lw s9, -396(s0)
	lw s10, -392(s0)
	lw s11, -388(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_17:
	addi s1, s0, -88
	lw s2, -20(s0)
	lw s3, -24(s0)
	addi s4, s0, -344
	li s5, 256
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, kpm_read
	mv s6, a0
	li s1, 0
	xor s2, s6, s1
	snez s2, s2
	bnez s2, .L3_19
	j .L3_20
.L3_19:
	la s1, __libc_stderr
	la s2, __str_39
	addi s3, s0, -344
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 1
	mv a0, s1
	lw s1, -428(s0)
	lw s2, -424(s0)
	lw s3, -420(s0)
	lw s4, -416(s0)
	lw s5, -412(s0)
	lw s6, -408(s0)
	lw s7, -404(s0)
	lw s8, -400(s0)
	lw s9, -396(s0)
	lw s10, -392(s0)
	lw s11, -388(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_20:
	addi s1, s0, -88
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_21
	j .L3_22
.L3_21:
	addi s1, s0, -88
	li s2, 40
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -364(s0)
	j .L3_23
.L3_22:
	la s1, __str_40
	sw s1, -364(s0)
.L3_23:
	lw s1, -364(s0)
	sw s1, -360(s0)
	addi s1, s0, -88
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -348(s0)
.L3_24:
	lw s1, -348(s0)
	bnez s1, .L3_25
	j .L3_26
.L3_25:
	lw s1, -348(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_27
	j .L3_28
.L3_27:
	lw s1, -348(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -360(s0)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_29
	j .L3_28
.L3_29:
	la s1, __str_41
	lw s2, -348(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -348(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	j .L3_26
.L3_28:
.L3_30:
	lw s1, -348(s0)
	li s2, 100
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -348(s0)
	j .L3_24
.L3_26:
	li s1, 0
	sw s1, -368(s0)
.L3_31:
	lw s1, -368(s0)
	addi s2, s0, -88
	li s3, 28
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L3_32
	j .L3_33
.L3_32:
	addi s1, s0, -88
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -348(s0)
.L3_34:
	lw s1, -348(s0)
	bnez s1, .L3_35
	j .L3_36
.L3_35:
	lw s1, -348(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_37
	j .L3_38
.L3_37:
	lw s1, -348(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -88
	li s3, 24
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -368(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_39
	j .L3_38
.L3_39:
	li s1, 0
	lw s2, -348(s0)
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
.L3_38:
.L3_40:
	lw s1, -348(s0)
	li s2, 100
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -348(s0)
	j .L3_34
.L3_36:
	addi s1, s0, -88
	li s2, 8
	add s3, s1, s2
	li s1, 4
	add s2, s3, s1
	lw s1, 0(s2)
	sw s1, -372(s0)
.L3_41:
	lw s1, -372(s0)
	bnez s1, .L3_42
	j .L3_43
.L3_42:
	lw s1, -372(s0)
	lw s2, 0(s1)
	bnez s2, .L3_44
	j .L3_45
.L3_44:
	lw s1, -372(s0)
	lw s2, 0(s1)
	addi s1, s0, -88
	li s3, 24
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -368(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	mv a0, s2
	mv a1, s1
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_46
	j .L3_45
.L3_46:
	li s1, 0
	lw s2, -372(s0)
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
.L3_45:
.L3_47:
	lw s1, -372(s0)
	li s2, 64
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -372(s0)
	j .L3_41
.L3_43:
.L3_48:
	addi s1, s0, -368
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -368(s0)
	j .L3_31
.L3_33:
	addi s1, s0, -88
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -348(s0)
.L3_49:
	lw s1, -348(s0)
	bnez s1, .L3_50
	j .L3_51
.L3_50:
	lw s1, -348(s0)
	li s2, 92
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -376(s0)
.L3_52:
	lw s1, -376(s0)
	bnez s1, .L3_53
	j .L3_54
.L3_53:
	lw s1, -376(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_55
	j .L3_56
.L3_55:
	lw s1, -376(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	mv a0, s1
	jal ra, remap_sym
	mv s2, a0
	sw s2, -380(s0)
	lw s1, -380(s0)
	bnez s1, .L3_57
	j .L3_58
.L3_57:
	lw s1, -380(s0)
	lw s2, -376(s0)
	li s3, 24
	add s4, s2, s3
	sw s1, 0(s4)
.L3_58:
.L3_56:
.L3_59:
	lw s1, -376(s0)
	li s2, 52
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -376(s0)
	j .L3_52
.L3_54:
.L3_60:
	lw s1, -348(s0)
	li s2, 100
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -348(s0)
	j .L3_49
.L3_51:
	addi s1, s0, -88
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -348(s0)
.L3_61:
	lw s1, -348(s0)
	bnez s1, .L3_62
	j .L3_63
.L3_62:
	lw s1, -348(s0)
	mv a0, s1
	jal ra, regalloc
	mv s2, a0
.L3_64:
	lw s1, -348(s0)
	li s2, 100
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -348(s0)
	j .L3_61
.L3_63:
	lw s1, -16(s0)
	bnez s1, .L3_65
	j .L3_66
.L3_65:
	lw s1, -16(s0)
	la s2, __str_42
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -352(s0)
	lw s1, -352(s0)
	bnez s1, .L3_67
	j .L3_68
.L3_68:
	la s1, __libc_stderr
	la s2, __str_43
	lw s3, -16(s0)
	addi sp, sp, -16
	mv a0, s1
	mv a1, s2
	sw s3, 0(sp)
	jal ra, fprintf
	mv s4, a0
	addi sp, sp, 16
	addi s1, s0, -88
	mv a0, s1
	jal ra, kpm_free
	mv s2, a0
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 1
	mv a0, s1
	lw s1, -428(s0)
	lw s2, -424(s0)
	lw s3, -420(s0)
	lw s4, -416(s0)
	lw s5, -412(s0)
	lw s6, -408(s0)
	lw s7, -404(s0)
	lw s8, -400(s0)
	lw s9, -396(s0)
	lw s10, -392(s0)
	lw s11, -388(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_67:
	j .L3_69
.L3_66:
	la s1, __libc_stdout
	sw s1, -352(s0)
.L3_69:
	li s1, 1
	la s2, target_aot_trap_guarded
	sw s1, 0(s2)
	lw s1, -352(s0)
	addi s2, s0, -88
	li s3, 8
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, target_emit
	mv s2, a0
	lw s1, -352(s0)
	la s2, __libc_stdout
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_70
	j .L3_71
.L3_70:
	lw s1, -352(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
.L3_71:
	addi s1, s0, -88
	mv a0, s1
	jal ra, kpm_free
	mv s2, a0
	lw s1, -20(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 0
	mv a0, s1
	lw s1, -428(s0)
	lw s2, -424(s0)
	lw s3, -420(s0)
	lw s4, -416(s0)
	lw s5, -412(s0)
	lw s6, -408(s0)
	lw s7, -404(s0)
	lw s8, -400(s0)
	lw s9, -396(s0)
	lw s10, -392(s0)
	lw s11, -388(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size main, .Lfunc_end3-main

	.data
	.align 2
__str_43:
	.ascii "skj-kp: cannot write '%s'\n\000"
	.align 2
__str_42:
	.ascii "w\000"
	.align 2
__str_41:
	.ascii "kp_guest_entry\000"
	.align 2
__str_40:
	.ascii "main\000"
	.align 2
__str_39:
	.ascii "skj-kp: %s\n\000"
	.align 2
__str_38:
	.ascii "skj-kp: cannot read '%s'\n\000"
	.align 2
__str_37:
	.ascii "usage: skj-kp module.kpm [-o out.asm]\n\000"
	.align 2
__str_36:
	.ascii "-o\000"
	.align 2
__str_35:
	.ascii "usage: skj-kp module.kpm [-o out.asm]\n\000"
	.align 2
__str_34:
	.ascii "--help\000"
	.align 2
__str_33:
	.ascii "-h\000"
	.align 2
__str_32:
	.ascii "rb\000"
	.align 2
__str_31:
	.ascii "brv_arctan\000"
	.align 2
__str_30:
	.ascii "kp_arctan\000"
	.align 2
__str_29:
	.ascii "brv_ln\000"
	.align 2
__str_28:
	.ascii "kp_ln\000"
	.align 2
__str_27:
	.ascii "brv_exp\000"
	.align 2
__str_26:
	.ascii "kp_exp\000"
	.align 2
__str_25:
	.ascii "brv_cos\000"
	.align 2
__str_24:
	.ascii "kp_cos\000"
	.align 2
__str_23:
	.ascii "brv_sin\000"
	.align 2
__str_22:
	.ascii "kp_sin\000"
	.align 2
__str_21:
	.ascii "brv_val_real\000"
	.align 2
__str_20:
	.ascii "kp_str_val_real\000"
	.align 2
__str_19:
	.ascii "brv_read_real\000"
	.align 2
__str_18:
	.ascii "io_read_real\000"
	.align 2
__str_17:
	.ascii "brv_write_real\000"
	.align 2
__str_16:
	.ascii "io_write_real\000"
	.align 2
__str_15:
	.ascii "kp_gheap_live\000"
	.align 2
__str_14:
	.ascii "heapLive\000"
	.align 2
__str_13:
	.ascii "rt_param_str\000"
	.align 2
__str_12:
	.ascii "ParamStr\000"
	.align 2
__str_11:
	.ascii "rt_param_count\000"
	.align 2
__str_10:
	.ascii "ParamCount\000"
	.align 2
__str_9:
	.ascii "kp_co_cancelling_g\000"
	.align 2
__str_8:
	.ascii "kp_co_cancelling\000"
	.align 2
__str_7:
	.ascii "kp_co_self_g\000"
	.align 2
__str_6:
	.ascii "kp_co_self\000"
	.align 2
__str_5:
	.ascii "kp_co_yield_g\000"
	.align 2
__str_4:
	.ascii "kp_co_yield\000"
	.align 2
__str_3:
	.ascii "kp_co_resume_g\000"
	.align 2
__str_2:
	.ascii "kp_co_resume\000"
	.align 2
__str_1:
	.ascii "kp_co_new_g\000"
	.align 2
__str_0:
	.ascii "kp_co_new\000"

	.section .rodata
	.align 2
remap_sym.tab.0:
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
