# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type put16, @function
put16:
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
	addi s1, s0, -8
	lhu s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	li s2, 0
	add s4, s1, s2
	sb s3, 0(s4)
	addi s1, s0, -8
	lhu s2, 0(s1)
	li s1, 8
	sra s3, s2, s1
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 1
	add s4, s1, s3
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
.Lfunc_end1:
	.size put16, .Lfunc_end1-put16

	.text
	.align 2
	.type put32, @function
put32:
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
	lw s1, -8(s0)
	li s2, 255
	and s3, s1, s2
	lw s1, -4(s0)
	li s2, 0
	add s4, s1, s2
	sb s3, 0(s4)
	lw s1, -8(s0)
	li s2, 8
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 1
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 16
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 2
	add s4, s1, s3
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 24
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	li s3, 3
	add s4, s1, s3
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
	.size put32, .Lfunc_end2-put32

	.text
	.align 2
	.globl rv_ld_write_exec
	.type rv_ld_write_exec, @function
rv_ld_write_exec:
	addi sp, sp, -1472
	sw ra, 1468(sp)
	sw s0, 1464(sp)
	addi s0, sp, 1464
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
	li s2, 20
	add s3, s1, s2
	sw s3, -12(s0)
	li s1, 0
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
.L3_0:
	lw s1, -24(s0)
	lw s2, -12(s0)
	li s3, 6100
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	lw s1, -24(s0)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_3
	j .L3_4
.L3_4:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	lw s1, -24(s0)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L3_5
	j .L3_3
.L3_5:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
.L3_3:
.L3_6:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L3_0
.L3_2:
	lw s1, -12(s0)
	li s2, 272
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_7
	j .L3_8
.L3_7:
	li s1, 1
	sw s1, -28(s0)
.L3_8:
	li s1, 52
	sw s1, -32(s0)
	lw s1, -28(s0)
	li s2, 32
	mul s3, s1, s2
	sw s3, -36(s0)
	lw s1, -32(s0)
	lw s2, -36(s0)
	add s3, s1, s2
	sw s3, -40(s0)
	lw s1, -40(s0)
	sw s1, -44(s0)
	li s1, 0
	sw s1, -564(s0)
	li s1, 0
	addi s2, s0, -560
	addi s3, s0, -564
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -564(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 0
	sw s1, -764(s0)
	li s1, 0
	sw s1, -768(s0)
.L3_9:
	lw s1, -768(s0)
	lw s2, -12(s0)
	li s3, 6100
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L3_10
	j .L3_11
.L3_10:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	lw s1, -768(s0)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -772(s0)
	lw s1, -772(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_12
	j .L3_13
.L3_13:
	lw s1, -772(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_12
	j .L3_14
.L3_12:
	j .L3_15
.L3_14:
	lw s1, -768(s0)
	addi s2, s0, -760
	lw s3, -764(s0)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -772(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_16
	j .L3_17
.L3_16:
	li s1, 0
	sw s1, -776(s0)
	j .L3_18
.L3_17:
	lw s1, -44(s0)
	sw s1, -776(s0)
.L3_18:
	lw s1, -776(s0)
	addi s2, s0, -760
	lw s3, -764(s0)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -772(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	li s2, 1
	add s3, s1, s2
	sw s3, -780(s0)
	lw s1, -564(s0)
	addi s2, s0, -760
	lw s3, -764(s0)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -560
	lw s2, -564(s0)
	add s3, s1, s2
	lw s1, -772(s0)
	lw s2, 0(s1)
	lw s1, -780(s0)
	mv a0, s3
	mv a1, s2
	mv a2, s1
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -564
	lw s2, 0(s1)
	lw s1, -780(s0)
	add s3, s2, s1
	sw s3, -564(s0)
	lw s1, -772(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_19
	j .L3_20
.L3_20:
	addi s1, s0, -44
	lw s2, 0(s1)
	lw s1, -772(s0)
	li s3, 16
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -44(s0)
.L3_19:
	addi s1, s0, -764
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -764(s0)
.L3_15:
	addi s1, s0, -768
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -768(s0)
	j .L3_9
.L3_11:
	li s1, 0
	sw s1, -836(s0)
	li s1, 0
	sw s1, -840(s0)
.L3_21:
	lw s1, -840(s0)
	lw s2, -4(s0)
	li s3, 6192
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L3_22
	j .L3_23
.L3_22:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -840(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_24
	j .L3_25
.L3_24:
	j .L3_26
.L3_25:
	lw s1, -840(s0)
	addi s2, s0, -832
	lw s3, -836(s0)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	sw s1, 0(s3)
	lw s1, -44(s0)
	addi s2, s0, -832
	lw s3, -836(s0)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	lw s1, -840(s0)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	li s2, 1
	add s3, s1, s2
	sw s3, -844(s0)
	lw s1, -564(s0)
	addi s2, s0, -832
	lw s3, -836(s0)
	li s4, 12
	mul s5, s3, s4
	add s3, s2, s5
	li s2, 8
	add s4, s3, s2
	sw s1, 0(s4)
	addi s1, s0, -560
	lw s2, -564(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 6128
	add s4, s1, s2
	lw s1, -840(s0)
	li s2, 16
	mul s5, s1, s2
	add s1, s4, s5
	lw s2, 0(s1)
	lw s1, -844(s0)
	mv a0, s3
	mv a1, s2
	mv a2, s1
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -564
	lw s2, 0(s1)
	lw s1, -844(s0)
	add s3, s2, s1
	sw s3, -564(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 6128
	add s4, s1, s3
	lw s1, -840(s0)
	li s3, 16
	mul s5, s1, s3
	add s1, s4, s5
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	sw s3, -44(s0)
	addi s1, s0, -836
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -836(s0)
.L3_26:
	addi s1, s0, -840
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -840(s0)
	j .L3_21
.L3_23:
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	li s1, 4
	mul s2, s3, s1
	mv a0, s2
	jal ra, xmalloc
	mv s1, a0
	sw s1, -848(s0)
	li s1, 0
	sw s1, -852(s0)
	li s1, 0
	sw s1, -856(s0)
	li s1, 1
	sw s1, -860(s0)
	li s1, 0
	sw s1, -864(s0)
.L3_27:
	lw s1, -864(s0)
	li s2, 2
	slt s3, s1, s2
	bnez s3, .L3_28
	j .L3_29
.L3_28:
	li s1, 0
	sw s1, -868(s0)
.L3_30:
	lw s1, -868(s0)
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L3_31
	j .L3_32
.L3_31:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -868(s0)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -872(s0)
	lw s1, -872(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_33
	j .L3_34
.L3_33:
	lw s1, -872(s0)
	lw s2, 0(s1)
	li s1, 0
	add s3, s2, s1
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_34
	j .L3_35
.L3_34:
	j .L3_36
.L3_35:
	lw s1, -872(s0)
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_37
	j .L3_38
.L3_37:
	lw s1, -872(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L3_39
	j .L3_38
.L3_39:
	j .L3_36
.L3_38:
	lw s1, -872(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	lw s1, -864(s0)
	li s2, 0
	xor s4, s1, s2
	seqz s4, s4
	xor s1, s3, s4
	snez s1, s1
	bnez s1, .L3_40
	j .L3_41
.L3_40:
	j .L3_36
.L3_41:
	lw s1, -868(s0)
	lw s2, -848(s0)
	addi s3, s0, -852
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -852(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	addi s1, s0, -860
	lw s2, 0(s1)
	lw s1, -872(s0)
	lw s3, 0(s1)
	mv a0, s3
	jal ra, strlen
	mv s1, a0
	li s3, 1
	add s4, s1, s3
	add s1, s2, s4
	sw s1, -860(s0)
.L3_36:
	addi s1, s0, -868
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -868(s0)
	j .L3_30
.L3_32:
	lw s1, -864(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_42
	j .L3_43
.L3_42:
	lw s1, -852(s0)
	sw s1, -856(s0)
.L3_43:
.L3_44:
	addi s1, s0, -864
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -864(s0)
	j .L3_27
.L3_29:
	li s1, 1
	lw s2, -856(s0)
	add s3, s1, s2
	sw s3, -876(s0)
	lw s1, -860(s0)
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -880(s0)
	li s1, 0
	sw s1, -884(s0)
	li s1, 0
	lw s2, -880(s0)
	addi s3, s0, -884
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -884(s0)
	add s3, s2, s4
	sb s1, 0(s3)
	li s1, 1
	lw s2, -852(s0)
	add s3, s1, s2
	li s1, 16
	mul s2, s3, s1
	sw s2, -888(s0)
	lw s1, -888(s0)
	mv a0, s1
	jal ra, xmalloc
	mv s2, a0
	sw s2, -892(s0)
	lw s1, -892(s0)
	li s2, 0
	lw s3, -888(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li s1, 0
	sw s1, -896(s0)
.L3_45:
	lw s1, -896(s0)
	lw s2, -852(s0)
	slt s3, s1, s2
	bnez s3, .L3_46
	j .L3_47
.L3_46:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -848(s0)
	lw s3, -896(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	li s3, 36
	mul s4, s2, s3
	add s2, s1, s4
	sw s2, -900(s0)
	lw s1, -892(s0)
	lw s2, -896(s0)
	li s3, 1
	add s4, s2, s3
	li s2, 16
	mul s3, s4, s2
	add s2, s1, s3
	sw s2, -904(s0)
	li s1, 65521
	sw s1, -908(s0)
	lw s1, -900(s0)
	lw s2, 0(s1)
	mv a0, s2
	jal ra, strlen
	mv s1, a0
	li s2, 1
	add s3, s1, s2
	sw s3, -912(s0)
	li s1, 0
	sw s1, -916(s0)
.L3_48:
	lw s1, -916(s0)
	lw s2, -764(s0)
	slt s3, s1, s2
	bnez s3, .L3_49
	j .L3_50
.L3_49:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	addi s1, s0, -760
	lw s2, -916(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -920(s0)
	lw s1, -900(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -920(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_51
	j .L3_52
.L3_51:
	lw s1, -900(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -920(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -920(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	add s4, s2, s3
	sltu s2, s1, s4
	bnez s2, .L3_53
	j .L3_52
.L3_53:
	li s1, 1
	lw s2, -916(s0)
	add s3, s1, s2
	li s1, 65535
	and s2, s3, s1
	sw s2, -908(s0)
	j .L3_50
.L3_52:
.L3_54:
	addi s1, s0, -916
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -916(s0)
	j .L3_48
.L3_50:
	lw s1, -904(s0)
	li s2, 0
	add s3, s1, s2
	lw s1, -884(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	lw s1, -880(s0)
	lw s2, -884(s0)
	add s3, s1, s2
	lw s1, -900(s0)
	lw s2, 0(s1)
	lw s1, -912(s0)
	mv a0, s3
	mv a1, s2
	mv a2, s1
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -884
	lw s2, 0(s1)
	lw s1, -912(s0)
	add s3, s2, s1
	sw s3, -884(s0)
	lw s1, -904(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, -900(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	lw s1, -904(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, -900(s0)
	li s2, 28
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	lw s1, -900(s0)
	li s2, 32
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	sll s3, s1, s2
	lw s1, -900(s0)
	li s2, 24
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 15
	and s4, s1, s2
	or s1, s3, s4
	li s2, 255
	and s3, s1, s2
	lw s1, -904(s0)
	li s2, 12
	add s4, s1, s2
	sb s3, 0(s4)
	li s1, 0
	lw s2, -904(s0)
	li s3, 13
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -904(s0)
	li s2, 14
	add s3, s1, s2
	addi s1, s0, -908
	lhu s2, 0(s1)
	mv a0, s3
	mv a1, s2
	jal ra, put16
	mv s1, a0
.L3_55:
	addi s1, s0, -896
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -896(s0)
	j .L3_45
.L3_47:
	lw s1, -564(s0)
	sw s1, -924(s0)
	la s1, __str_0
	sw s1, -928(s0)
	lw s1, -928(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	li s1, 1
	add s3, s2, s1
	sw s3, -932(s0)
	addi s1, s0, -560
	lw s2, -564(s0)
	add s3, s1, s2
	lw s1, -928(s0)
	lw s2, -932(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -564
	lw s2, 0(s1)
	lw s1, -932(s0)
	add s3, s2, s1
	sw s3, -564(s0)
	lw s1, -564(s0)
	sw s1, -936(s0)
	la s1, __str_1
	sw s1, -940(s0)
	lw s1, -940(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	li s1, 1
	add s3, s2, s1
	sw s3, -944(s0)
	addi s1, s0, -560
	lw s2, -564(s0)
	add s3, s1, s2
	lw s1, -940(s0)
	lw s2, -944(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -564
	lw s2, 0(s1)
	lw s1, -944(s0)
	add s3, s2, s1
	sw s3, -564(s0)
	li s1, 1
	lw s2, -20(s0)
	add s3, s1, s2
	lw s1, -836(s0)
	add s2, s3, s1
	li s1, 3
	add s3, s2, s1
	sw s3, -948(s0)
	li s1, 1
	lw s2, -20(s0)
	add s3, s1, s2
	lw s1, -836(s0)
	add s2, s3, s1
	li s1, 1
	add s3, s2, s1
	sw s3, -952(s0)
	lw s1, -564(s0)
	sw s1, -956(s0)
	la s1, __str_2
	sw s1, -960(s0)
	lw s1, -960(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	li s1, 1
	add s3, s2, s1
	sw s3, -964(s0)
	addi s1, s0, -560
	lw s2, -564(s0)
	add s3, s1, s2
	lw s1, -960(s0)
	lw s2, -964(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -564
	lw s2, 0(s1)
	lw s1, -964(s0)
	add s3, s2, s1
	sw s3, -564(s0)
	lw s1, -44(s0)
	sw s1, -968(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	lw s1, -888(s0)
	add s3, s2, s1
	sw s3, -44(s0)
	lw s1, -44(s0)
	sw s1, -972(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	lw s1, -884(s0)
	add s3, s2, s1
	sw s3, -44(s0)
	lw s1, -44(s0)
	sw s1, -976(s0)
	addi s1, s0, -44
	lw s2, 0(s1)
	lw s1, -564(s0)
	add s3, s2, s1
	sw s3, -44(s0)
	lw s1, -44(s0)
	sw s1, -980(s0)
	lw s1, -12(s0)
	li s2, 172
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_56
	j .L3_57
.L3_56:
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	li s1, 0
	li s2, 20
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -988(s0)
	j .L3_58
.L3_57:
	li s1, 65536
	sw s1, -988(s0)
.L3_58:
	lw s1, -988(s0)
	sw s1, -984(s0)
	li s1, 0
	sw s1, -992(s0)
	li s1, 0
	sw s1, -996(s0)
	li s1, 0
	sw s1, -1000(s0)
	li s1, 0
	sw s1, -1004(s0)
.L3_59:
	lw s1, -1004(s0)
	lw s2, -12(s0)
	li s3, 6100
	add s4, s2, s3
	lw s2, 0(s4)
	slt s3, s1, s2
	bnez s3, .L3_60
	j .L3_61
.L3_60:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	lw s1, -1004(s0)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -1008(s0)
	lw s1, -1008(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_62
	j .L3_63
.L3_63:
	lw s1, -1008(s0)
	li s2, 16
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_62
	j .L3_64
.L3_62:
	j .L3_65
.L3_64:
	lw s1, -1008(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -1008(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	sw s3, -1012(s0)
	lw s1, -1012(s0)
	lw s2, -992(s0)
	sltu s3, s2, s1
	bnez s3, .L3_66
	j .L3_67
.L3_66:
	lw s1, -1012(s0)
	sw s1, -992(s0)
.L3_67:
.L3_65:
	addi s1, s0, -1004
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1004(s0)
	j .L3_59
.L3_61:
	lw s1, -992(s0)
	lw s2, -984(s0)
	sub s3, s1, s2
	sw s3, -1000(s0)
	li s1, 0
	sw s1, -1016(s0)
.L3_68:
	lw s1, -1016(s0)
	lw s2, -764(s0)
	slt s3, s1, s2
	bnez s3, .L3_69
	j .L3_70
.L3_69:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	addi s1, s0, -760
	lw s2, -1016(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -1020(s0)
	lw s1, -1020(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_71
	j .L3_72
.L3_72:
	addi s1, s0, -760
	lw s2, -1016(s0)
	li s3, 12
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 4
	add s3, s2, s1
	lw s1, 0(s3)
	lw s2, -1020(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	sw s3, -1024(s0)
	lw s1, -1024(s0)
	lw s2, -996(s0)
	sltu s3, s2, s1
	bnez s3, .L3_73
	j .L3_74
.L3_73:
	lw s1, -1024(s0)
	sw s1, -996(s0)
.L3_74:
.L3_71:
.L3_75:
	addi s1, s0, -1016
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1016(s0)
	j .L3_68
.L3_70:
	lw s1, -8(s0)
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -16(s0)
	lw s1, -16(s0)
	bnez s1, .L3_76
	j .L3_77
.L3_77:
	la s1, __str_4
	lw s2, -8(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L3_76:
	addi s1, s0, -1076
	li s2, 0
	li s3, 52
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -1076
	la s2, __str_5
	li s3, 4
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 1
	addi s2, s0, -1076
	li s3, 4
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 1
	addi s2, s0, -1076
	li s3, 5
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 1
	addi s2, s0, -1076
	li s3, 6
	add s4, s2, s3
	sb s1, 0(s4)
	addi s1, s0, -1076
	li s2, 16
	add s3, s1, s2
	li s1, 2
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -1076
	li s2, 18
	add s3, s1, s2
	li s1, 243
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -1076
	li s2, 20
	add s3, s1, s2
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1076
	li s2, 24
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 6124
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1076
	li s2, 28
	add s3, s1, s2
	lw s1, -32(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1076
	li s2, 32
	add s3, s1, s2
	lw s1, -980(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1076
	li s2, 36
	add s3, s1, s2
	li s1, 0
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1076
	li s2, 40
	add s3, s1, s2
	li s1, 52
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -1076
	li s2, 42
	add s3, s1, s2
	li s1, 32
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -1076
	li s2, 44
	add s3, s1, s2
	lw s1, -28(s0)
	li s2, 65535
	and s4, s1, s2
	mv a0, s3
	mv a1, s4
	jal ra, put16
	mv s1, a0
	addi s1, s0, -1076
	li s2, 46
	add s3, s1, s2
	li s1, 40
	mv a0, s3
	mv a1, s1
	jal ra, put16
	mv s2, a0
	addi s1, s0, -1076
	li s2, 48
	add s3, s1, s2
	lw s1, -948(s0)
	li s2, 65535
	and s4, s1, s2
	mv a0, s3
	mv a1, s4
	jal ra, put16
	mv s1, a0
	addi s1, s0, -1076
	li s2, 50
	add s3, s1, s2
	lw s1, -948(s0)
	li s2, 1
	sub s4, s1, s2
	li s1, 65535
	and s2, s4, s1
	mv a0, s3
	mv a1, s2
	jal ra, put16
	mv s1, a0
	addi s1, s0, -1076
	li s2, 1
	li s3, 52
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	li s1, 0
	sw s1, -1080(s0)
.L3_78:
	lw s1, -1080(s0)
	lw s2, -28(s0)
	slt s3, s1, s2
	bnez s3, .L3_79
	j .L3_80
.L3_79:
	lw s1, -12(s0)
	li s2, 272
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_81
	j .L3_82
.L3_81:
	lw s1, -12(s0)
	li s2, 176
	add s3, s1, s2
	lw s1, -1080(s0)
	li s2, 12
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1120(s0)
	j .L3_83
.L3_82:
	li s1, 4
	li s2, 2
	or s3, s1, s2
	li s1, 1
	or s2, s3, s1
	sw s2, -1120(s0)
.L3_83:
	lw s1, -1120(s0)
	sw s1, -1116(s0)
	lw s1, -12(s0)
	li s2, 272
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L3_84
	j .L3_85
.L3_84:
	lw s1, -12(s0)
	li s2, 176
	add s3, s1, s2
	lw s1, -1080(s0)
	li s2, 12
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -1128(s0)
	j .L3_86
.L3_85:
	li s1, 1
	sw s1, -1128(s0)
.L3_86:
	lw s1, -1128(s0)
	sw s1, -1124(s0)
	addi s1, s0, -1112
	li s2, 0
	li s3, 32
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -1112
	li s2, 0
	add s3, s1, s2
	lw s1, -1124(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1112
	li s2, 4
	add s3, s1, s2
	li s1, 0
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1112
	li s2, 8
	add s3, s1, s2
	lw s1, -984(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1112
	li s2, 12
	add s3, s1, s2
	lw s1, -984(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1112
	li s2, 16
	add s3, s1, s2
	lw s1, -996(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1112
	li s2, 20
	add s3, s1, s2
	lw s1, -1000(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1112
	li s2, 24
	add s3, s1, s2
	lw s1, -1116(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1112
	li s2, 28
	add s3, s1, s2
	li s1, 4096
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1112
	li s2, 1
	li s3, 32
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L3_87:
	addi s1, s0, -1080
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1080(s0)
	j .L3_78
.L3_80:
	li s1, 0
	sw s1, -1132(s0)
.L3_88:
	lw s1, -1132(s0)
	lw s2, -764(s0)
	slt s3, s1, s2
	bnez s3, .L3_89
	j .L3_90
.L3_89:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	addi s1, s0, -760
	lw s2, -1132(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -1136(s0)
	lw s1, -1136(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L3_91
	j .L3_92
.L3_91:
	j .L3_93
.L3_92:
	lw s1, -1136(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	lw s3, -1136(s0)
	li s4, 16
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L3_93:
	addi s1, s0, -1132
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1132(s0)
	j .L3_88
.L3_90:
	li s1, 0
	sw s1, -1140(s0)
.L3_94:
	lw s1, -1140(s0)
	lw s2, -836(s0)
	slt s3, s1, s2
	bnez s3, .L3_95
	j .L3_96
.L3_95:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	addi s1, s0, -832
	lw s2, -1140(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	lw s3, -4(s0)
	li s4, 6128
	add s5, s3, s4
	addi s3, s0, -832
	lw s4, -1140(s0)
	li s6, 12
	mul s7, s4, s6
	add s4, s3, s7
	lw s3, 0(s4)
	li s4, 16
	mul s6, s3, s4
	add s3, s5, s6
	li s4, 8
	add s5, s3, s4
	lw s3, 0(s5)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L3_97:
	addi s1, s0, -1140
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1140(s0)
	j .L3_94
.L3_96:
	lw s1, -892(s0)
	li s2, 1
	lw s3, -888(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	lw s1, -880(s0)
	li s2, 1
	lw s3, -884(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	addi s1, s0, -560
	li s2, 1
	lw s3, -564(s0)
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	addi s1, s0, -1184
	li s2, 0
	li s3, 40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -1184
	li s2, 1
	li s3, 40
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	li s1, 0
	sw s1, -1188(s0)
.L3_98:
	lw s1, -1188(s0)
	lw s2, -764(s0)
	slt s3, s1, s2
	bnez s3, .L3_99
	j .L3_100
.L3_99:
	lw s1, -12(s0)
	li s2, 276
	add s3, s1, s2
	addi s1, s0, -760
	lw s2, -1188(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	li s2, 364
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -1192(s0)
	li s1, 2
	sw s1, -1236(s0)
	addi s1, s0, -1232
	li s2, 0
	li s3, 40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -1232
	li s2, 0
	add s3, s1, s2
	addi s1, s0, -760
	lw s2, -1188(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 8
	add s4, s2, s1
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1232
	li s2, 4
	add s3, s1, s2
	lw s1, -1192(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	bnez s1, .L3_101
	j .L3_102
.L3_101:
	li s1, 8
	sw s1, -1240(s0)
	j .L3_103
.L3_102:
	li s1, 1
	sw s1, -1240(s0)
.L3_103:
	lw s1, -1240(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	lw s1, -1192(s0)
	lw s2, 0(s1)
	la s1, __str_6
	mv a0, s2
	mv a1, s1
	jal ra, strstr
	mv s3, a0
	bnez s3, .L3_104
	j .L3_105
.L3_104:
	addi s1, s0, -1236
	lw s2, 0(s1)
	li s1, 4
	or s3, s2, s1
	sw s3, -1236(s0)
.L3_105:
	lw s1, -1192(s0)
	lw s2, 0(s1)
	la s1, __str_7
	mv a0, s2
	mv a1, s1
	jal ra, strstr
	mv s3, a0
	bnez s3, .L3_106
	j .L3_107
.L3_107:
	lw s1, -1192(s0)
	lw s2, 0(s1)
	la s1, __str_8
	mv a0, s2
	mv a1, s1
	jal ra, strstr
	mv s3, a0
	bnez s3, .L3_106
	j .L3_108
.L3_106:
	addi s1, s0, -1236
	lw s2, 0(s1)
	li s1, 1
	or s3, s2, s1
	sw s3, -1236(s0)
.L3_108:
	addi s1, s0, -1232
	li s2, 8
	add s3, s1, s2
	lw s1, -1236(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1232
	li s2, 12
	add s3, s1, s2
	lw s1, -1192(s0)
	li s2, 12
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1232
	li s2, 16
	add s3, s1, s2
	lw s1, -1192(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	bnez s1, .L3_109
	j .L3_110
.L3_109:
	li s1, 0
	sw s1, -1244(s0)
	j .L3_111
.L3_110:
	addi s1, s0, -760
	lw s2, -1188(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 4
	add s4, s2, s1
	lw s1, 0(s4)
	sw s1, -1244(s0)
.L3_111:
	lw s1, -1244(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1232
	li s2, 20
	add s3, s1, s2
	lw s1, -1192(s0)
	li s2, 16
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1232
	li s2, 32
	add s3, s1, s2
	li s1, 4
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1232
	li s2, 1
	li s3, 40
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L3_112:
	addi s1, s0, -1188
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1188(s0)
	j .L3_98
.L3_100:
	li s1, 0
	sw s1, -1248(s0)
.L3_113:
	lw s1, -1248(s0)
	lw s2, -836(s0)
	slt s3, s1, s2
	bnez s3, .L3_114
	j .L3_115
.L3_114:
	lw s1, -4(s0)
	li s2, 6128
	add s3, s1, s2
	addi s1, s0, -832
	lw s2, -1248(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	lw s1, 0(s2)
	li s2, 16
	mul s4, s1, s2
	add s1, s3, s4
	sw s1, -1252(s0)
	addi s1, s0, -1296
	li s2, 0
	li s3, 40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -1296
	li s2, 0
	add s3, s1, s2
	addi s1, s0, -832
	lw s2, -1248(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 8
	add s4, s2, s1
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1296
	li s2, 4
	add s3, s1, s2
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1296
	li s2, 16
	add s3, s1, s2
	addi s1, s0, -832
	lw s2, -1248(s0)
	li s4, 12
	mul s5, s2, s4
	add s2, s1, s5
	li s1, 4
	add s4, s2, s1
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1296
	li s2, 20
	add s3, s1, s2
	lw s1, -1252(s0)
	li s2, 8
	add s4, s1, s2
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1296
	li s2, 32
	add s3, s1, s2
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1296
	li s2, 1
	li s3, 40
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
.L3_116:
	addi s1, s0, -1248
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -1248(s0)
	j .L3_113
.L3_115:
	addi s1, s0, -1336
	li s2, 0
	li s3, 40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -1336
	li s2, 0
	add s3, s1, s2
	lw s1, -924(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1336
	li s2, 4
	add s3, s1, s2
	li s1, 2
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1336
	li s2, 16
	add s3, s1, s2
	lw s1, -968(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1336
	li s2, 20
	add s3, s1, s2
	lw s1, -888(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1336
	li s2, 24
	add s3, s1, s2
	lw s1, -952(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1336
	li s2, 28
	add s3, s1, s2
	lw s1, -876(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1336
	li s2, 32
	add s3, s1, s2
	li s1, 4
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1336
	li s2, 36
	add s3, s1, s2
	li s1, 16
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1336
	li s2, 1
	li s3, 40
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	addi s1, s0, -1376
	li s2, 0
	li s3, 40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -1376
	li s2, 0
	add s3, s1, s2
	lw s1, -936(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1376
	li s2, 4
	add s3, s1, s2
	li s1, 3
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1376
	li s2, 16
	add s3, s1, s2
	lw s1, -972(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1376
	li s2, 20
	add s3, s1, s2
	lw s1, -884(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1376
	li s2, 32
	add s3, s1, s2
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1376
	li s2, 1
	li s3, 40
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	addi s1, s0, -1416
	li s2, 0
	li s3, 40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	addi s1, s0, -1416
	li s2, 0
	add s3, s1, s2
	lw s1, -956(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1416
	li s2, 4
	add s3, s1, s2
	li s1, 3
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1416
	li s2, 16
	add s3, s1, s2
	lw s1, -976(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1416
	li s2, 20
	add s3, s1, s2
	lw s1, -564(s0)
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1416
	li s2, 32
	add s3, s1, s2
	li s1, 1
	mv a0, s3
	mv a1, s1
	jal ra, put32
	mv s2, a0
	addi s1, s0, -1416
	li s2, 1
	li s3, 40
	lw s4, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fwrite
	mv s5, a0
	lw s1, -848(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -880(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -892(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	lw s1, -16(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
	lw s1, -8(s0)
	li s2, 493
	mv a0, s1
	mv a1, s2
	jal ra, chmod
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -1460(s0)
	lw s2, -1456(s0)
	lw s3, -1452(s0)
	lw s4, -1448(s0)
	lw s5, -1444(s0)
	lw s6, -1440(s0)
	lw s7, -1436(s0)
	lw s8, -1432(s0)
	lw s9, -1428(s0)
	lw s10, -1424(s0)
	lw s11, -1420(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size rv_ld_write_exec, .Lfunc_end3-rv_ld_write_exec

	.data
	.align 2
__str_8:
	.ascii ".bss\000"
	.align 2
__str_7:
	.ascii ".data\000"
	.align 2
__str_6:
	.ascii ".text\000"
	.align 2
__str_5:
	.ascii "\177ELF\000"
	.align 2
__str_4:
	.ascii "cannot create %s\000"
	.align 2
__str_3:
	.ascii "wb\000"
	.align 2
__str_2:
	.ascii ".shstrtab\000"
	.align 2
__str_1:
	.ascii ".strtab\000"
	.align 2
__str_0:
	.ascii ".symtab\000"
