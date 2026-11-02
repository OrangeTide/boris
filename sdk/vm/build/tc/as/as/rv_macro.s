# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type buf_add, @function
buf_add:
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
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	add s3, s1, s2
	li s1, 1
	add s2, s3, s1
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	sltu s3, s1, s2
	bnez s3, .L1_0
	j .L1_1
.L1_0:
.L1_2:
	lw s1, -4(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	add s3, s1, s2
	li s1, 1
	add s2, s3, s1
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	sltu s3, s1, s2
	bnez s3, .L1_3
	j .L1_4
.L1_3:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L1_5
	j .L1_6
.L1_5:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	mul s3, s1, s2
	sw s3, -20(s0)
	j .L1_7
.L1_6:
	li s1, 1024
	sw s1, -20(s0)
.L1_7:
	lw s1, -20(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	j .L1_2
.L1_4:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	mv a0, s2
	mv a1, s1
	jal ra, realloc
	mv s3, a0
	lw s1, -4(s0)
	sw s3, 0(s1)
.L1_1:
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
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -4(s0)
	li s4, 4
	add s5, s2, s4
	lw s2, 0(s5)
	add s4, s3, s2
	sb s1, 0(s4)
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
	.size buf_add, .Lfunc_end1-buf_add

	.text
	.align 2
	.type first_token, @function
first_token:
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
	sw s1, -20(s0)
.L2_0:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L2_1
	j .L2_2
.L2_2:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L2_1
	j .L2_3
.L2_1:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L2_0
.L2_3:
	lw s1, -20(s0)
	sw s1, -24(s0)
.L2_4:
	lw s1, -20(s0)
	lb s2, 0(s1)
	bnez s2, .L2_5
	j .L2_6
.L2_5:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L2_7
	j .L2_6
.L2_7:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L2_8
	j .L2_6
.L2_8:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L2_9
	j .L2_6
.L2_9:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L2_10
	j .L2_6
.L2_10:
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 58
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L2_11
	j .L2_6
.L2_11:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L2_4
.L2_6:
	lw s1, -24(s0)
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -20(s0)
	lw s2, -24(s0)
	sub s3, s1, s2
	lw s1, -12(s0)
	sw s3, 0(s1)
	lw s1, -20(s0)
	lb s2, 0(s1)
	li s1, 58
	xor s3, s2, s1
	seqz s3, s3
	lw s1, -16(s0)
	sb s3, 0(s1)
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
	.size first_token, .Lfunc_end2-first_token

	.text
	.align 2
	.type tokeq, @function
tokeq:
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
	lw s1, -12(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	lw s1, -8(s0)
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	lw s2, -12(s0)
	lw s3, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L3_2
	j .L3_1
.L3_2:
	li s1, 1
	j .L3_3
.L3_1:
	li s1, 0
.L3_3:
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
	.size tokeq, .Lfunc_end3-tokeq

	.text
	.align 2
	.type expand_call, @function
expand_call:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	li s1, 0
	sw s1, -92(s0)
	lw s1, -12(s0)
	sw s1, -104(s0)
	addi s1, s0, -116
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
.L4_0:
	lw s1, -104(s0)
	lb s2, 0(s1)
	bnez s2, .L4_1
	j .L4_2
.L4_1:
	lw s1, -104(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L4_3
	j .L4_2
.L4_3:
	lw s1, -92(s0)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L4_4
	j .L4_2
.L4_4:
.L4_5:
	lw s1, -104(s0)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_6
	j .L4_7
.L4_7:
	lw s1, -104(s0)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_6
	j .L4_8
.L4_6:
	addi s1, s0, -104
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -104(s0)
	j .L4_5
.L4_8:
	lw s1, -104(s0)
	sw s1, -120(s0)
.L4_9:
	lw s1, -104(s0)
	lb s2, 0(s1)
	bnez s2, .L4_10
	j .L4_11
.L4_10:
	lw s1, -104(s0)
	lb s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L4_12
	j .L4_11
.L4_12:
	lw s1, -104(s0)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L4_13
	j .L4_11
.L4_13:
	addi s1, s0, -104
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -104(s0)
	j .L4_9
.L4_11:
	lw s1, -104(s0)
	sw s1, -124(s0)
.L4_14:
	lw s1, -124(s0)
	lw s2, -120(s0)
	slt s3, s2, s1
	bnez s3, .L4_15
	j .L4_16
.L4_15:
	lw s1, -124(s0)
	li s2, 1
	neg s3, s2
	add s2, s1, s3
	lb s1, 0(s2)
	li s2, 32
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_17
	j .L4_18
.L4_18:
	lw s1, -124(s0)
	li s2, 1
	neg s3, s2
	add s2, s1, s3
	lb s1, 0(s2)
	li s2, 9
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L4_17
	j .L4_16
.L4_17:
	addi s1, s0, -124
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -124(s0)
	j .L4_14
.L4_16:
	addi s1, s0, -116
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	addi s2, s0, -88
	lw s3, -92(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -116
	lw s2, -120(s0)
	lw s3, -124(s0)
	lw s4, -120(s0)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, buf_add
	mv s3, a0
	addi s1, s0, -116
	la s2, __str_0
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, buf_add
	mv s4, a0
	addi s1, s0, -92
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -92(s0)
	lw s1, -104(s0)
	lb s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_19
	j .L4_20
.L4_19:
	addi s1, s0, -104
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -104(s0)
.L4_20:
	j .L4_0
.L4_2:
	addi s1, s0, -116
	lw s2, 0(s1)
	sw s2, -96(s0)
	li s1, 0
	sw s1, -128(s0)
.L4_21:
	lw s1, -128(s0)
	lw s2, -92(s0)
	slt s3, s1, s2
	bnez s3, .L4_22
	j .L4_23
.L4_22:
	lw s1, -96(s0)
	addi s2, s0, -88
	lw s3, -128(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	add s3, s1, s2
	addi s1, s0, -88
	lw s2, -128(s0)
	li s4, 4
	mul s5, s2, s4
	add s2, s1, s5
	sw s3, 0(s2)
.L4_24:
	addi s1, s0, -128
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -128(s0)
	j .L4_21
.L4_23:
	lw s1, -8(s0)
	li s2, 72
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -100(s0)
.L4_25:
	lw s1, -100(s0)
	lb s2, 0(s1)
	bnez s2, .L4_26
	j .L4_27
.L4_26:
	addi s1, s0, -140
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	lw s1, -100(s0)
	li s2, 10
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	sw s3, -144(s0)
	lw s1, -144(s0)
	bnez s1, .L4_28
	j .L4_29
.L4_28:
	lw s1, -144(s0)
	li s2, 1
	add s3, s1, s2
	sw s3, -152(s0)
	j .L4_30
.L4_29:
	lw s1, -100(s0)
	lw s2, -100(s0)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	add s2, s1, s3
	sw s2, -152(s0)
.L4_30:
	lw s1, -152(s0)
	sw s1, -148(s0)
	lw s1, -100(s0)
	sw s1, -156(s0)
.L4_31:
	lw s1, -156(s0)
	lw s2, -148(s0)
	slt s3, s1, s2
	bnez s3, .L4_32
	j .L4_33
.L4_32:
	lw s1, -156(s0)
	lb s2, 0(s1)
	li s1, 92
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L4_34
	j .L4_35
.L4_34:
	lw s1, -156(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -148(s0)
	slt s2, s3, s1
	bnez s2, .L4_36
	j .L4_35
.L4_36:
	li s1, 1
	neg s2, s1
	sw s2, -164(s0)
	li s1, 0
	sw s1, -168(s0)
	li s1, 0
	sw s1, -160(s0)
.L4_37:
	lw s1, -160(s0)
	lw s2, -8(s0)
	li s3, 68
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L4_38
	j .L4_39
.L4_38:
	lw s1, -8(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, -160(s0)
	li s2, 4
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	sw s1, -172(s0)
	lw s1, -172(s0)
	lw s2, -168(s0)
	slt s3, s2, s1
	bnez s3, .L4_40
	j .L4_41
.L4_40:
	lw s1, -156(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -8(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, -160(s0)
	li s2, 4
	mul s5, s1, s2
	add s1, s4, s5
	lw s2, 0(s1)
	lw s1, -172(s0)
	mv a0, s3
	mv a1, s2
	mv a2, s1
	jal ra, strncmp
	mv s4, a0
	li s1, 0
	xor s2, s4, s1
	seqz s2, s2
	bnez s2, .L4_42
	j .L4_41
.L4_42:
	lw s1, -160(s0)
	sw s1, -164(s0)
	lw s1, -172(s0)
	sw s1, -168(s0)
.L4_41:
.L4_43:
	addi s1, s0, -160
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -160(s0)
	j .L4_37
.L4_39:
	lw s1, -164(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L4_44
	j .L4_45
.L4_44:
	lw s1, -164(s0)
	lw s2, -92(s0)
	slt s3, s1, s2
	bnez s3, .L4_46
	j .L4_45
.L4_46:
	addi s1, s0, -140
	addi s2, s0, -88
	lw s3, -164(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	addi s3, s0, -88
	lw s4, -164(s0)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s3
	jal ra, strlen
	mv s4, a0
	mv a0, s1
	mv a1, s2
	mv a2, s4
	jal ra, buf_add
	mv s3, a0
	addi s1, s0, -156
	lw s2, 0(s1)
	li s1, 1
	lw s3, -168(s0)
	add s4, s1, s3
	add s1, s2, s4
	sw s1, -156(s0)
	j .L4_31
.L4_45:
	lw s1, -164(s0)
	li s2, 0
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L4_47
	j .L4_48
.L4_47:
	addi s1, s0, -156
	lw s2, 0(s1)
	li s1, 1
	lw s3, -168(s0)
	add s4, s1, s3
	add s1, s2, s4
	sw s1, -156(s0)
	j .L4_31
.L4_48:
.L4_35:
	addi s1, s0, -140
	lw s2, -156(s0)
	li s3, 1
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, buf_add
	mv s4, a0
	addi s1, s0, -156
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -156(s0)
	j .L4_31
.L4_33:
	lw s1, -4(s0)
	addi s2, s0, -140
	lw s3, 0(s2)
	bnez s3, .L4_49
	j .L4_50
.L4_49:
	addi s2, s0, -140
	lw s3, 0(s2)
	sw s3, -176(s0)
	j .L4_51
.L4_50:
	la s2, __str_1
	sw s2, -176(s0)
.L4_51:
	lw s2, -176(s0)
	addi s3, s0, -140
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -16(s0)
	lw s5, -20(s0)
	lw s6, -24(s0)
	li s7, 1
	add s8, s6, s7
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s8
	jal ra, expand_line
	mv s6, a0
	addi s1, s0, -140
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	lw s1, -148(s0)
	sw s1, -100(s0)
	j .L4_25
.L4_27:
	lw s1, -96(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 0
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
.Lfunc_end4:
	.size expand_call, .Lfunc_end4-expand_call

	.text
	.align 2
	.type expand_line, @function
expand_line:
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
	sw a5, -24(s0)
	lw s1, -24(s0)
	li s2, 32
	slt s3, s2, s1
	bnez s3, .L5_0
	j .L5_1
.L5_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, buf_add
	mv s4, a0
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
.L5_1:
	lw s1, -8(s0)
	addi s2, s0, -28
	addi s3, s0, -32
	addi s4, s0, -36
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, first_token
	mv s5, a0
	sw s5, -40(s0)
	addi s1, s0, -36
	lb s2, 0(s1)
	bnez s2, .L5_2
	j .L5_3
.L5_3:
	lw s1, -32(s0)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L5_4
	j .L5_2
.L5_4:
	li s1, 0
	sw s1, -44(s0)
.L5_5:
	lw s1, -44(s0)
	lw s2, -20(s0)
	slt s3, s1, s2
	bnez s3, .L5_6
	j .L5_7
.L5_6:
	lw s1, -28(s0)
	lw s2, -32(s0)
	lw s3, -16(s0)
	lw s4, -44(s0)
	li s5, 76
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, tokeq
	mv s4, a0
	bnez s4, .L5_8
	j .L5_9
.L5_8:
	lw s1, -4(s0)
	lw s2, -16(s0)
	lw s3, -44(s0)
	li s4, 76
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, -40(s0)
	lw s4, -16(s0)
	lw s5, -20(s0)
	lw s6, -24(s0)
	mv a0, s1
	mv a1, s3
	mv a2, s2
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, expand_call
	mv s7, a0
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
.L5_9:
.L5_10:
	addi s1, s0, -44
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -44(s0)
	j .L5_5
.L5_7:
.L5_2:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, buf_add
	mv s4, a0
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
.Lfunc_end5:
	.size expand_line, .Lfunc_end5-expand_line

	.text
	.align 2
	.globl rv_expand_macros
	.type rv_expand_macros, @function
rv_expand_macros:
	li t6, -5040
	add sp, sp, t6
	li t6, 5036
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 5032
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 5032
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
	li s1, 0
	li t6, -4876
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -4888
	add s1, s0, t6
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	lw s1, -8(s0)
	li t6, -4892
	add t6, s0, t6
	sw s1, 0(t6)
.L6_0:
	li t6, -4892
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	bnez s2, .L6_1
	j .L6_2
.L6_1:
	li t6, -4892
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 10
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	li t6, -4900
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4900
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L6_3
	j .L6_4
.L6_3:
	li t6, -4900
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 1
	add s3, s1, s2
	li t6, -4908
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_5
.L6_4:
	li t6, -4892
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4892
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	add s2, s1, s3
	li t6, -4908
	add t6, s0, t6
	sw s2, 0(t6)
.L6_5:
	li t6, -4908
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4904
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -4892
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4912
	add s2, s0, t6
	li t6, -4916
	add s3, s0, t6
	li t6, -4920
	add s4, s0, t6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, first_token
	mv s5, a0
	li t6, -4912
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4916
	add t6, s0, t6
	lw s2, 0(t6)
	la s3, __str_2
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, tokeq
	mv s4, a0
	bnez s4, .L6_6
	j .L6_7
.L6_6:
	li t6, -4876
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 64
	slt s3, s1, s2
	bnez s3, .L6_8
	j .L6_7
.L6_8:
	li t6, -4872
	add s1, s0, t6
	li t6, -4876
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 76
	mul s4, s2, s3
	add s2, s1, s4
	li t6, -4924
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -4912
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4916
	add t6, s0, t6
	lw s2, 0(t6)
	add s3, s1, s2
	li t6, -4928
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4940
	add s1, s0, t6
	li s2, 0
	sw s2, 0(s1)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	li s3, 8
	add s4, s1, s3
	sw s2, 0(s4)
	li s2, 0
	sw s2, 0(s1)
	li t6, -4924
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 0
	li s3, 76
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
.L6_9:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_10
	j .L6_11
.L6_11:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_10
	j .L6_12
.L6_10:
	li t6, -4928
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -4928
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_9
.L6_12:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4944
	add t6, s0, t6
	sw s1, 0(t6)
.L6_13:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	bnez s2, .L6_14
	j .L6_15
.L6_14:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_16
	j .L6_15
.L6_16:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_17
	j .L6_15
.L6_17:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_18
	j .L6_15
.L6_18:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_19
	j .L6_15
.L6_19:
	li t6, -4928
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -4928
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_13
.L6_15:
	lw s1, -4(s0)
	li t6, -4944
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4928
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4944
	add t6, s0, t6
	lw s4, 0(t6)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, arena_strndup
	mv s3, a0
	li t6, -4924
	add t6, s0, t6
	lw s1, 0(t6)
	sw s3, 0(s1)
.L6_20:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	bnez s2, .L6_21
	j .L6_22
.L6_21:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_23
	j .L6_22
.L6_23:
	li t6, -4924
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 68
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 16
	slt s3, s1, s2
	bnez s3, .L6_24
	j .L6_22
.L6_24:
.L6_25:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_26
	j .L6_27
.L6_27:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_26
	j .L6_28
.L6_28:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_26
	j .L6_29
.L6_26:
	li t6, -4928
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -4928
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_25
.L6_29:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_30
	j .L6_31
.L6_31:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	bnez s2, .L6_32
	j .L6_30
.L6_30:
	j .L6_22
.L6_32:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4948
	add t6, s0, t6
	sw s1, 0(t6)
.L6_33:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	bnez s2, .L6_34
	j .L6_35
.L6_34:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 32
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_36
	j .L6_35
.L6_36:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 9
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_37
	j .L6_35
.L6_37:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 10
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_38
	j .L6_35
.L6_38:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	li s1, 44
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_39
	j .L6_35
.L6_39:
	li t6, -4928
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -4928
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_33
.L6_35:
	li t6, -4928
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4948
	add t6, s0, t6
	lw s2, 0(t6)
	slt s3, s2, s1
	bnez s3, .L6_40
	j .L6_41
.L6_40:
	lw s1, -4(s0)
	li t6, -4948
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4928
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4948
	add t6, s0, t6
	lw s4, 0(t6)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, arena_strndup
	mv s3, a0
	li t6, -4924
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 4
	add s4, s1, s2
	li t6, -4924
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 68
	add s5, s1, s2
	lw s1, 0(s5)
	li s2, 1
	add s6, s1, s2
	sw s6, 0(s5)
	li s2, 4
	mul s5, s1, s2
	add s1, s4, s5
	sw s3, 0(s1)
.L6_41:
	j .L6_20
.L6_22:
	li t6, -4904
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4892
	add t6, s0, t6
	sw s1, 0(t6)
.L6_42:
	li t6, -4892
	add t6, s0, t6
	lw s1, 0(t6)
	lb s2, 0(s1)
	bnez s2, .L6_43
	j .L6_44
.L6_43:
	li t6, -4892
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 10
	mv a0, s1
	mv a1, s2
	jal ra, strchr
	mv s3, a0
	li t6, -4952
	add t6, s0, t6
	sw s3, 0(t6)
	li t6, -4952
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L6_45
	j .L6_46
.L6_45:
	li t6, -4952
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 1
	add s3, s1, s2
	li t6, -4960
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_47
.L6_46:
	li t6, -4892
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4892
	add t6, s0, t6
	lw s2, 0(t6)
	mv a0, s2
	jal ra, strlen
	mv s3, a0
	add s2, s1, s3
	li t6, -4960
	add t6, s0, t6
	sw s2, 0(t6)
.L6_47:
	li t6, -4960
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4956
	add t6, s0, t6
	sw s1, 0(t6)
	li t6, -4892
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4964
	add s2, s0, t6
	li t6, -4968
	add s3, s0, t6
	li t6, -4972
	add s4, s0, t6
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, first_token
	mv s5, a0
	li t6, -4964
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4968
	add t6, s0, t6
	lw s2, 0(t6)
	la s3, __str_3
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, tokeq
	mv s4, a0
	bnez s4, .L6_48
	j .L6_49
.L6_48:
	li t6, -4956
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4892
	add t6, s0, t6
	sw s1, 0(t6)
	j .L6_44
.L6_49:
	li t6, -4940
	add s1, s0, t6
	li t6, -4892
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4956
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4892
	add t6, s0, t6
	lw s4, 0(t6)
	sub s5, s3, s4
	mv a0, s1
	mv a1, s2
	mv a2, s5
	jal ra, buf_add
	mv s3, a0
	li t6, -4956
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4892
	add t6, s0, t6
	sw s1, 0(t6)
	j .L6_42
.L6_44:
	lw s1, -4(s0)
	li t6, -4940
	add s2, s0, t6
	lw s3, 0(s2)
	bnez s3, .L6_50
	j .L6_51
.L6_50:
	li t6, -4940
	add s2, s0, t6
	lw s3, 0(s2)
	li t6, -4976
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_52
.L6_51:
	la s2, __str_4
	li t6, -4976
	add t6, s0, t6
	sw s2, 0(t6)
.L6_52:
	li t6, -4976
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4940
	add s3, s0, t6
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	li t6, -4924
	add t6, s0, t6
	lw s1, 0(t6)
	li s2, 72
	add s3, s1, s2
	sw s4, 0(s3)
	li t6, -4940
	add s1, s0, t6
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li t6, -4876
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -4876
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_0
.L6_7:
	li t6, -4888
	add s1, s0, t6
	li t6, -4892
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4904
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -4892
	add t6, s0, t6
	lw s4, 0(t6)
	sub s5, s3, s4
	li t6, -4872
	add s3, s0, t6
	li t6, -4876
	add t6, s0, t6
	lw s4, 0(t6)
	li s6, 0
	mv a0, s1
	mv a1, s2
	mv a2, s5
	mv a3, s3
	mv a4, s4
	mv a5, s6
	jal ra, expand_line
	mv s7, a0
	li t6, -4904
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -4892
	add t6, s0, t6
	sw s1, 0(t6)
	j .L6_0
.L6_2:
	lw s1, -4(s0)
	li t6, -4888
	add s2, s0, t6
	lw s3, 0(s2)
	bnez s3, .L6_53
	j .L6_54
.L6_53:
	li t6, -4888
	add s2, s0, t6
	lw s3, 0(s2)
	li t6, -4980
	add t6, s0, t6
	sw s3, 0(t6)
	j .L6_55
.L6_54:
	la s2, __str_5
	li t6, -4980
	add t6, s0, t6
	sw s2, 0(t6)
.L6_55:
	li t6, -4980
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -4888
	add s3, s0, t6
	li s4, 4
	add s5, s3, s4
	lw s3, 0(s5)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, arena_strndup
	mv s4, a0
	li t6, -4896
	add t6, s0, t6
	sw s4, 0(t6)
	li t6, -4888
	add s1, s0, t6
	lw s2, 0(s1)
	mv a0, s2
	jal ra, free
	mv s1, a0
	li t6, -4896
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	li t6, -5028
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -5024
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -5020
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -5016
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -5012
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -5008
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -5004
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -5000
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -4996
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -4992
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -4988
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end6:
	.size rv_expand_macros, .Lfunc_end6-rv_expand_macros

	.data
	.align 2
__str_5:
	.ascii "\000"
	.align 2
__str_4:
	.ascii "\000"
	.align 2
__str_3:
	.ascii ".endm\000"
	.align 2
__str_2:
	.ascii ".macro\000"
	.align 2
__str_1:
	.ascii "\000"
	.align 2
__str_0:
	.ascii "\000"
