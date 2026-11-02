# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.globl time
	.type time, @function
time:
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
	bnez s1, .L1_0
	j .L1_1
.L1_0:
	li s1, 1704067200
	lw s2, -4(s0)
	sw s1, 0(s2)
.L1_1:
	li s1, 1704067200
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
	.size time, .Lfunc_end1-time

	.text
	.align 2
	.type is_leap, @function
is_leap:
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
	li s2, 4
	rem s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L2_0
	j .L2_1
.L2_0:
	lw s1, -4(s0)
	li s2, 100
	rem s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L2_2
	j .L2_1
.L2_1:
	lw s1, -4(s0)
	li s2, 400
	rem s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L2_2
	j .L2_3
.L2_2:
	li s1, 1
	j .L2_4
.L2_3:
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
	.size is_leap, .Lfunc_end2-is_leap

	.text
	.align 2
	.globl gmtime
	.type gmtime, @function
gmtime:
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
	lw s1, -4(s0)
	bnez s1, .L3_0
	j .L3_1
.L3_0:
	lw s1, -4(s0)
	lw s2, 0(s1)
	sw s2, -16(s0)
	j .L3_2
.L3_1:
	li s1, 0
	sw s1, -16(s0)
.L3_2:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 86400
	div s3, s1, s2
	sw s3, -20(s0)
	lw s1, -12(s0)
	li s2, 86400
	rem s3, s1, s2
	sw s3, -24(s0)
	li s1, 1970
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_3
	j .L3_4
.L3_3:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 86400
	add s3, s2, s1
	sw s3, -24(s0)
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, -1
	add s3, s2, s1
	sw s3, -20(s0)
.L3_4:
	lw s1, -24(s0)
	li s2, 3600
	div s3, s1, s2
	la s1, gmtime.tm.0
	li s2, 8
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -24(s0)
	li s2, 3600
	rem s3, s1, s2
	li s1, 60
	div s2, s3, s1
	la s1, gmtime.tm.0
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -24(s0)
	li s2, 60
	rem s3, s1, s2
	la s1, gmtime.tm.0
	sw s3, 0(s1)
	lw s1, -20(s0)
	li s2, 4
	add s3, s1, s2
	li s1, 7
	rem s2, s3, s1
	la s1, gmtime.tm.0
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	la s1, gmtime.tm.0
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L3_5
	j .L3_6
.L3_5:
	la s1, gmtime.tm.0
	li s2, 24
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 7
	add s4, s1, s2
	sw s4, 0(s3)
.L3_6:
.L3_7:
	lw s1, -20(s0)
	lw s2, -28(s0)
	mv a0, s2
	jal ra, is_leap
	mv s3, a0
	bnez s3, .L3_8
	j .L3_9
.L3_8:
	li s2, 366
	sw s2, -36(s0)
	j .L3_10
.L3_9:
	li s2, 365
	sw s2, -36(s0)
.L3_10:
	lw s2, -36(s0)
	slt s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L3_11
	j .L3_12
.L3_11:
	addi s1, s0, -20
	lw s2, 0(s1)
	lw s1, -28(s0)
	mv a0, s1
	jal ra, is_leap
	mv s3, a0
	bnez s3, .L3_13
	j .L3_14
.L3_13:
	li s1, 366
	sw s1, -40(s0)
	j .L3_15
.L3_14:
	li s1, 365
	sw s1, -40(s0)
.L3_15:
	lw s1, -40(s0)
	sub s3, s2, s1
	sw s3, -20(s0)
	addi s1, s0, -28
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -28(s0)
	j .L3_7
.L3_12:
	lw s1, -28(s0)
	li s2, 1900
	sub s3, s1, s2
	la s1, gmtime.tm.0
	li s2, 20
	add s4, s1, s2
	sw s3, 0(s4)
	lw s1, -20(s0)
	la s2, gmtime.tm.0
	li s3, 28
	add s4, s2, s3
	sw s1, 0(s4)
.L3_16:
	lw s1, -20(s0)
	la s2, gmtime.mdays.1
	lw s3, -32(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	lw s3, -32(s0)
	li s4, 1
	xor s5, s3, s4
	seqz s5, s5
	bnez s5, .L3_17
	j .L3_18
.L3_17:
	lw s3, -28(s0)
	mv a0, s3
	jal ra, is_leap
	mv s4, a0
	bnez s4, .L3_19
	j .L3_18
.L3_19:
	li s3, 1
	sw s3, -44(s0)
	j .L3_20
.L3_18:
	li s3, 0
	sw s3, -44(s0)
.L3_20:
	lw s3, -44(s0)
	add s4, s2, s3
	slt s2, s1, s4
	xori s2, s2, 1
	bnez s2, .L3_21
	j .L3_22
.L3_21:
	addi s1, s0, -20
	lw s2, 0(s1)
	la s1, gmtime.mdays.1
	lw s3, -32(s0)
	li s4, 4
	mul s5, s3, s4
	add s3, s1, s5
	lw s1, 0(s3)
	lw s3, -32(s0)
	li s4, 1
	xor s5, s3, s4
	seqz s5, s5
	bnez s5, .L3_23
	j .L3_24
.L3_23:
	lw s3, -28(s0)
	mv a0, s3
	jal ra, is_leap
	mv s4, a0
	bnez s4, .L3_25
	j .L3_24
.L3_25:
	li s3, 1
	sw s3, -48(s0)
	j .L3_26
.L3_24:
	li s3, 0
	sw s3, -48(s0)
.L3_26:
	lw s3, -48(s0)
	add s4, s1, s3
	sub s1, s2, s4
	sw s1, -20(s0)
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L3_16
.L3_22:
	lw s1, -32(s0)
	la s2, gmtime.tm.0
	li s3, 16
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -20(s0)
	li s2, 1
	add s3, s1, s2
	la s1, gmtime.tm.0
	li s2, 12
	add s4, s1, s2
	sw s3, 0(s4)
	li s1, 0
	la s2, gmtime.tm.0
	li s3, 32
	add s4, s2, s3
	sw s1, 0(s4)
	la s1, gmtime.tm.0
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
.Lfunc_end3:
	.size gmtime, .Lfunc_end3-gmtime

	.text
	.align 2
	.globl localtime
	.type localtime, @function
localtime:
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
	jal ra, gmtime
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
.Lfunc_end4:
	.size localtime, .Lfunc_end4-localtime

	.text
	.align 2
	.type put2, @function
put2:
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
	li s1, 48
	lw s2, -8(s0)
	li s3, 10
	div s4, s2, s3
	li s2, 10
	rem s3, s4, s2
	add s2, s1, s3
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -4
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -4(s0)
	sb s2, 0(s3)
	li s1, 48
	lw s2, -8(s0)
	li s3, 10
	rem s4, s2, s3
	add s2, s1, s4
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -4
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -4(s0)
	sb s2, 0(s3)
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
.Lfunc_end5:
	.size put2, .Lfunc_end5-put2

	.text
	.align 2
	.globl strftime
	.type strftime, @function
strftime:
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
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	addi s1, s0, -144
	sw s1, -148(s0)
	lw s1, -12(s0)
	sw s1, -152(s0)
.L6_0:
	lw s1, -152(s0)
	lb s2, 0(s1)
	bnez s2, .L6_1
	j .L6_2
.L6_1:
	lw s1, -148(s0)
	addi s2, s0, -144
	sub s3, s1, s2
	li s1, 128
	li s2, 4
	sub s4, s1, s2
	sltu s1, s3, s4
	bnez s1, .L6_3
	j .L6_2
.L6_3:
	lw s1, -152(s0)
	lb s2, 0(s1)
	li s1, 37
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L6_4
	j .L6_5
.L6_4:
	addi s1, s0, -152
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -152(s0)
	lb s1, 0(s2)
	addi s2, s0, -148
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -148(s0)
	sb s1, 0(s3)
	j .L6_0
.L6_5:
	addi s1, s0, -152
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -152(s0)
	lw s1, -152(s0)
	lb s2, 0(s1)
	li s1, 89
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_6
	li s1, 109
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_7
	li s1, 100
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_8
	li s1, 72
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_9
	li s1, 77
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_10
	li s1, 83
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_11
	li s1, 98
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_12
	li s1, 101
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_13
	li s1, 37
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_14
	li s1, 0
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L6_15
	j .L6_16
.L6_6:
	lw s1, -16(s0)
	li s2, 20
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1900
	add s3, s1, s2
	sw s3, -160(s0)
	li s1, 48
	lw s2, -160(s0)
	li s3, 1000
	div s4, s2, s3
	li s2, 10
	rem s3, s4, s2
	add s2, s1, s3
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -148
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -148(s0)
	sb s2, 0(s3)
	li s1, 48
	lw s2, -160(s0)
	li s3, 100
	div s4, s2, s3
	li s2, 10
	rem s3, s4, s2
	add s2, s1, s3
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -148
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -148(s0)
	sb s2, 0(s3)
	li s1, 48
	lw s2, -160(s0)
	li s3, 10
	div s4, s2, s3
	li s2, 10
	rem s3, s4, s2
	add s2, s1, s3
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -148
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -148(s0)
	sb s2, 0(s3)
	li s1, 48
	lw s2, -160(s0)
	li s3, 10
	rem s4, s2, s3
	add s2, s1, s4
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -148
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -148(s0)
	sb s2, 0(s3)
	j .L6_17
.L6_7:
	lw s1, -148(s0)
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 1
	add s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, put2
	mv s2, a0
	sw s2, -148(s0)
	j .L6_17
.L6_8:
	lw s1, -148(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, put2
	mv s3, a0
	sw s3, -148(s0)
	j .L6_17
.L6_9:
	lw s1, -148(s0)
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, put2
	mv s3, a0
	sw s3, -148(s0)
	j .L6_17
.L6_10:
	lw s1, -148(s0)
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, put2
	mv s3, a0
	sw s3, -148(s0)
	j .L6_17
.L6_11:
	lw s1, -148(s0)
	lw s2, -16(s0)
	lw s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, put2
	mv s2, a0
	sw s2, -148(s0)
	j .L6_17
.L6_12:
	la s1, strftime.mon.2
	lw s2, -16(s0)
	li s3, 16
	add s4, s2, s3
	lw s2, 0(s4)
	li s3, 12
	rem s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	sw s1, -164(s0)
	lw s1, -164(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	addi s2, s0, -148
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -148(s0)
	sb s1, 0(s3)
	lw s1, -164(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	addi s2, s0, -148
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -148(s0)
	sb s1, 0(s3)
	lw s1, -164(s0)
	li s2, 2
	add s3, s1, s2
	lb s1, 0(s3)
	addi s2, s0, -148
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -148(s0)
	sb s1, 0(s3)
	j .L6_17
.L6_13:
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 10
	slt s3, s1, s2
	bnez s3, .L6_18
	j .L6_19
.L6_18:
	li s1, 32
	addi s2, s0, -148
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -148(s0)
	sb s1, 0(s3)
	li s1, 48
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	add s3, s1, s2
	li s1, 24
	sll s2, s3, s1
	li s1, 24
	sra s3, s2, s1
	addi s1, s0, -148
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sw s4, -148(s0)
	sb s3, 0(s2)
	j .L6_20
.L6_19:
	lw s1, -148(s0)
	lw s2, -16(s0)
	li s3, 12
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, put2
	mv s3, a0
	sw s3, -148(s0)
.L6_20:
	j .L6_17
.L6_14:
	li s1, 37
	addi s2, s0, -148
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -148(s0)
	sb s1, 0(s3)
	j .L6_17
.L6_15:
	j .L6_0
.L6_16:
	li s1, 37
	addi s2, s0, -148
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -148(s0)
	sb s1, 0(s3)
	lw s1, -152(s0)
	lb s2, 0(s1)
	addi s1, s0, -148
	lw s3, 0(s1)
	li s1, 1
	add s4, s3, s1
	sw s4, -148(s0)
	sb s2, 0(s3)
	j .L6_17
.L6_17:
	addi s1, s0, -152
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -152(s0)
	j .L6_0
.L6_2:
	li s1, 0
	lw s2, -148(s0)
	sb s1, 0(s2)
	lw s1, -148(s0)
	addi s2, s0, -144
	sub s3, s1, s2
	sw s3, -156(s0)
	lw s1, -156(s0)
	lw s2, -8(s0)
	sltu s3, s1, s2
	xori s3, s3, 1
	bnez s3, .L6_21
	j .L6_22
.L6_21:
	lw s1, -8(s0)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L6_23
	j .L6_24
.L6_23:
	li s1, 0
	lw s2, -4(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
.L6_24:
	li s1, 0
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
.L6_22:
	li s1, 0
	sw s1, -168(s0)
.L6_25:
	lw s1, -168(s0)
	lw s2, -156(s0)
	sltu s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L6_26
	j .L6_27
.L6_26:
	addi s1, s0, -144
	lw s2, -168(s0)
	add s3, s1, s2
	lb s1, 0(s3)
	lw s2, -4(s0)
	lw s3, -168(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L6_28:
	addi s1, s0, -168
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -168(s0)
	j .L6_25
.L6_27:
	lw s1, -156(s0)
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
.Lfunc_end6:
	.size strftime, .Lfunc_end6-strftime

	.data
	.align 2
__str_11:
	.ascii "Dec\000"
	.align 2
__str_10:
	.ascii "Nov\000"
	.align 2
__str_9:
	.ascii "Oct\000"
	.align 2
__str_8:
	.ascii "Sep\000"
	.align 2
__str_7:
	.ascii "Aug\000"
	.align 2
__str_6:
	.ascii "Jul\000"
	.align 2
__str_5:
	.ascii "Jun\000"
	.align 2
__str_4:
	.ascii "May\000"
	.align 2
__str_3:
	.ascii "Apr\000"
	.align 2
__str_2:
	.ascii "Mar\000"
	.align 2
__str_1:
	.ascii "Feb\000"
	.align 2
__str_0:
	.ascii "Jan\000"

	.section .rodata
	.align 2
strftime.mon.2:
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
	.align 2
gmtime.mdays.1:
	.word 31
	.word 28
	.word 31
	.word 30
	.word 31
	.word 30
	.word 31
	.word 31
	.word 30
	.word 31
	.word 30
	.word 31

	.bss
	.align 2
gmtime.tm.0:
	.space 36
