# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type cleanup_ld, @function
cleanup_ld:
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
	jal ra, ld_free
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
.Lfunc_end1:
	.size cleanup_ld, .Lfunc_end1-cleanup_ld

	.text
	.align 2
	.type usage, @function
usage:
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
	la s2, __str_0
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
	lw s1, -8(s0)
	mv a0, s1
	jal ra, exit
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
.Lfunc_end2:
	.size usage, .Lfunc_end2-usage

	.text
	.align 2
	.globl main
	.type main, @function
main:
	li t6, -6336
	add sp, sp, t6
	li t6, 6332
	add t6, sp, t6
	sw ra, 0(t6)
	li t6, 6328
	add t6, sp, t6
	sw s0, 0(t6)
	li t6, 6328
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
	la s1, __str_1
	mv a0, s1
	jal ra, util_set_progname
	mv s2, a0
	li s1, 0
	sw s1, -12(s0)
	li s1, 0
	sw s1, -16(s0)
	li s1, 0
	sw s1, -20(s0)
	li s1, 0
	sw s1, -24(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 0
	sw s1, -32(s0)
	li s1, 1
	li t6, -6248
	add t6, s0, t6
	sw s1, 0(t6)
.L3_0:
	li t6, -6248
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -4(s0)
	slt s3, s1, s2
	bnez s3, .L3_1
	j .L3_2
.L3_1:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_2
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_3
	j .L3_4
.L3_3:
	la s1, __str_3
	la s2, __str_4
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, printf
	mv s3, a0
	addi sp, sp, 16
	li s1, 0
	mv a0, s1
	li t6, -6316
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -6312
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -6308
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -6304
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -6300
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -6296
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -6292
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -6288
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -6284
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -6280
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -6276
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
	j .L3_5
.L3_4:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_5
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_6
	j .L3_7
.L3_7:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_6
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_6
	j .L3_8
.L3_6:
	la s1, __libc_stdout
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, usage
	mv s3, a0
	j .L3_9
.L3_8:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_7
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_10
	j .L3_11
.L3_10:
	li t6, -6248
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -6248
	add t6, s0, t6
	sw s3, 0(t6)
	lw s1, -4(s0)
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L3_12
	j .L3_13
.L3_12:
	la s1, __libc_stderr
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, usage
	mv s3, a0
.L3_13:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -12(s0)
	j .L3_14
.L3_11:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_8
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_15
	j .L3_16
.L3_15:
	li t6, -6248
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -6248
	add t6, s0, t6
	sw s3, 0(t6)
	lw s1, -4(s0)
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L3_17
	j .L3_18
.L3_17:
	la s1, __libc_stderr
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, usage
	mv s3, a0
.L3_18:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -16(s0)
	j .L3_19
.L3_16:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_9
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_20
	j .L3_21
.L3_20:
	li t6, -6248
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -6248
	add t6, s0, t6
	sw s3, 0(t6)
	lw s1, -4(s0)
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L3_22
	j .L3_23
.L3_22:
	la s1, __libc_stderr
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, usage
	mv s3, a0
.L3_23:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -20(s0)
	j .L3_24
.L3_21:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_10
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L3_25
	j .L3_26
.L3_25:
	li t6, -6248
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -6248
	add t6, s0, t6
	sw s3, 0(t6)
	lw s1, -4(s0)
	slt s2, s3, s1
	xori s2, s2, 1
	bnez s2, .L3_27
	j .L3_28
.L3_27:
	la s1, __libc_stderr
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, usage
	mv s3, a0
.L3_28:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -24(s0)
	j .L3_29
.L3_26:
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 45
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_30
	j .L3_31
.L3_30:
	la s1, __str_11
	lw s2, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s3, 0(t6)
	li s4, 4
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s3)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
	j .L3_32
.L3_31:
	lw s1, -28(s0)
	lw s2, -32(s0)
	li s3, 1
	add s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, realloc
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -8(s0)
	li t6, -6248
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	lw s2, -28(s0)
	addi s3, s0, -32
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -32(s0)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
.L3_32:
.L3_29:
.L3_24:
.L3_19:
.L3_14:
.L3_9:
.L3_5:
.L3_33:
	li t6, -6248
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -6248
	add t6, s0, t6
	sw s3, 0(t6)
	j .L3_0
.L3_2:
	lw s1, -20(s0)
	bnez s1, .L3_34
	j .L3_35
.L3_34:
	lw s1, -32(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L3_35
	j .L3_36
.L3_35:
	la s1, __libc_stderr
	li s2, 1
	mv a0, s1
	mv a1, s2
	jal ra, usage
	mv s3, a0
.L3_36:
	la s1, util_die_env
	mv a0, s1
	jal ra, setjmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L3_37
	j .L3_38
.L3_37:
	lw s1, -28(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 1
	mv a0, s1
	li t6, -6316
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -6312
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -6308
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -6304
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -6300
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -6296
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -6292
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -6288
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -6284
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -6280
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -6276
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L3_38:
	li s1, 1
	la s2, util_die_active
	sw s1, 0(s2)
	li t6, -6244
	add s1, s0, t6
	li s2, 0
	li s3, 6212
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memset
	mv s4, a0
	li t6, -6244
	add s1, s0, t6
	li s2, 6204
	add s3, s1, s2
	mv a0, s3
	jal ra, arena_init
	mv s1, a0
	la s1, cleanup_ld
	li t6, -6244
	add s2, s0, t6
	mv a0, s1
	mv a1, s2
	jal ra, util_cleanup_push
	mv s3, a0
	lw s1, -12(s0)
	bnez s1, .L3_39
	j .L3_40
.L3_39:
	lw s1, -12(s0)
	mv a0, s1
	jal ra, slurp
	mv s2, a0
	li t6, -6252
	add t6, s0, t6
	sw s2, 0(t6)
	li t6, -6244
	add s1, s0, t6
	li s2, 6204
	add s3, s1, s2
	li t6, -6244
	add s1, s0, t6
	li s2, 20
	add s4, s1, s2
	li t6, -6252
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s3
	mv a1, s4
	mv a2, s1
	jal ra, ld_parse_script
	mv s2, a0
	li t6, -6252
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, free
	mv s2, a0
	j .L3_41
.L3_40:
	li t6, -6244
	add s1, s0, t6
	li s2, 6204
	add s3, s1, s2
	li t6, -6244
	add s1, s0, t6
	li s2, 20
	add s4, s1, s2
	mv a0, s3
	mv a1, s4
	jal ra, rv_default_script
	mv s1, a0
.L3_41:
	lw s1, -16(s0)
	bnez s1, .L3_42
	j .L3_43
.L3_42:
	lw s1, -16(s0)
	li t6, -6244
	add s2, s0, t6
	li s3, 20
	add s4, s2, s3
	li s2, 8
	add s3, s4, s2
	sw s1, 0(s3)
.L3_43:
	li s1, 0
	li t6, -6256
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 0
	li t6, -6260
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 0
	li t6, -6264
	add t6, s0, t6
	sw s1, 0(t6)
.L3_44:
	li t6, -6264
	add t6, s0, t6
	lw s1, 0(t6)
	lw s2, -32(s0)
	slt s3, s1, s2
	bnez s3, .L3_45
	j .L3_46
.L3_45:
	lw s1, -28(s0)
	li t6, -6264
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	mv a0, s1
	jal ra, rv_ld_is_archive
	mv s2, a0
	bnez s2, .L3_47
	j .L3_48
.L3_47:
	li t6, -6256
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -6260
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 1
	add s4, s2, s3
	li s2, 4
	mul s3, s4, s2
	mv a0, s1
	mv a1, s3
	jal ra, realloc
	mv s2, a0
	li t6, -6256
	add t6, s0, t6
	sw s2, 0(t6)
	lw s1, -28(s0)
	li t6, -6264
	add t6, s0, t6
	lw s2, 0(t6)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	li t6, -6256
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -6260
	add s3, s0, t6
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	li t6, -6260
	add t6, s0, t6
	sw s5, 0(t6)
	li s3, 4
	mul s5, s4, s3
	add s3, s2, s5
	sw s1, 0(s3)
	j .L3_49
.L3_48:
	li t6, -6244
	add s1, s0, t6
	li s2, 6204
	add s3, s1, s2
	li t6, -6244
	add s1, s0, t6
	mv a0, s1
	jal ra, ld_add_object
	mv s2, a0
	lw s1, -28(s0)
	li t6, -6264
	add t6, s0, t6
	lw s4, 0(t6)
	li s5, 4
	mul s6, s4, s5
	add s4, s1, s6
	lw s1, 0(s4)
	mv a0, s3
	mv a1, s2
	mv a2, s1
	jal ra, rv_ld_read_object
	mv s4, a0
.L3_49:
.L3_50:
	li t6, -6264
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -6264
	add t6, s0, t6
	sw s3, 0(t6)
	j .L3_44
.L3_46:
	jal ra, rv_ld_archive_reset
	mv s1, a0
	li s1, 1
	li t6, -6268
	add t6, s0, t6
	sw s1, 0(t6)
.L3_51:
	li t6, -6268
	add t6, s0, t6
	lw s1, 0(t6)
	bnez s1, .L3_52
	j .L3_53
.L3_52:
	li s1, 0
	li t6, -6268
	add t6, s0, t6
	sw s1, 0(t6)
	li s1, 0
	li t6, -6272
	add t6, s0, t6
	sw s1, 0(t6)
.L3_54:
	li t6, -6272
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -6260
	add t6, s0, t6
	lw s2, 0(t6)
	slt s3, s1, s2
	bnez s3, .L3_55
	j .L3_56
.L3_55:
	li t6, -6268
	add s1, s0, t6
	lw s2, 0(s1)
	li t6, -6244
	add s1, s0, t6
	li t6, -6256
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -6272
	add t6, s0, t6
	lw s4, 0(t6)
	li s5, 4
	mul s6, s4, s5
	add s4, s3, s6
	lw s3, 0(s4)
	mv a0, s1
	mv a1, s3
	jal ra, rv_ld_read_archive
	mv s4, a0
	add s1, s2, s4
	li t6, -6268
	add t6, s0, t6
	sw s1, 0(t6)
.L3_57:
	li t6, -6272
	add s1, s0, t6
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	li t6, -6272
	add t6, s0, t6
	sw s3, 0(t6)
	j .L3_54
.L3_56:
	j .L3_51
.L3_53:
	li t6, -6256
	add t6, s0, t6
	lw s1, 0(t6)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li t6, -6244
	add s1, s0, t6
	mv a0, s1
	jal ra, rv_ld_link
	mv s2, a0
	lw s1, -24(s0)
	bnez s1, .L3_58
	j .L3_59
.L3_58:
	li t6, -6244
	add s1, s0, t6
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, ld_write_map
	mv s3, a0
.L3_59:
	li t6, -6244
	add s1, s0, t6
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_ld_write_exec
	mv s3, a0
	jal ra, util_cleanup_run
	mv s1, a0
	lw s1, -28(s0)
	mv a0, s1
	jal ra, free
	mv s2, a0
	li s1, 0
	mv a0, s1
	li t6, -6316
	add t6, s0, t6
	lw s1, 0(t6)
	li t6, -6312
	add t6, s0, t6
	lw s2, 0(t6)
	li t6, -6308
	add t6, s0, t6
	lw s3, 0(t6)
	li t6, -6304
	add t6, s0, t6
	lw s4, 0(t6)
	li t6, -6300
	add t6, s0, t6
	lw s5, 0(t6)
	li t6, -6296
	add t6, s0, t6
	lw s6, 0(t6)
	li t6, -6292
	add t6, s0, t6
	lw s7, 0(t6)
	li t6, -6288
	add t6, s0, t6
	lw s8, 0(t6)
	li t6, -6284
	add t6, s0, t6
	lw s9, 0(t6)
	li t6, -6280
	add t6, s0, t6
	lw s10, 0(t6)
	li t6, -6276
	add t6, s0, t6
	lw s11, 0(t6)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end3:
	.size main, .Lfunc_end3-main

	.data
	.align 2
__str_11:
	.ascii "unknown option: %s\000"
	.align 2
__str_10:
	.ascii "-Map\000"
	.align 2
__str_9:
	.ascii "-o\000"
	.align 2
__str_8:
	.ascii "-e\000"
	.align 2
__str_7:
	.ascii "-T\000"
	.align 2
__str_6:
	.ascii "--help\000"
	.align 2
__str_5:
	.ascii "-h\000"
	.align 2
__str_4:
	.ascii "0.43.0+g49a60c3\000"
	.align 2
__str_3:
	.ascii "skj-ld-rv %s\n\000"
	.align 2
__str_2:
	.ascii "-V\000"
	.align 2
__str_1:
	.ascii "skj-ld-rv\000"
	.align 2
__str_0:
	.ascii "usage: skj-ld-rv [-V] [-T script.ld] [-e entry] [-Map map] -o output input.o [...]\n\nRISC-V RV32 static linker.  Reads ELF32 little-endian EM_RISCV\nrelocatable objects and writes an ET_EXEC based at 0x10000 for\nqemu-riscv32 user mode and the in-tree emulator (skj-run).\n\000"
