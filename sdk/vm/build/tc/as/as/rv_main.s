# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type cleanup_rv, @function
cleanup_rv:
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
	jal ra, rv_free
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
	.size cleanup_rv, .Lfunc_end1-cleanup_rv

	.text
	.align 2
	.type cleanup_free, @function
cleanup_free:
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
	jal ra, free
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
	.size cleanup_free, .Lfunc_end2-cleanup_free

	.text
	.align 2
	.type usage, @function
usage:
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
	la s1, __libc_stderr
	la s2, __str_0
	mv a0, s1
	mv a1, s2
	jal ra, fprintf
	mv s3, a0
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
.Lfunc_end3:
	.size usage, .Lfunc_end3-usage

	.text
	.align 2
	.globl main
	.type main, @function
main:
	addi sp, sp, -736
	sw ra, 732(sp)
	sw s0, 728(sp)
	addi s0, sp, 728
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
	li s1, 1
	sw s1, -672(s0)
.L4_0:
	lw s1, -672(s0)
	lw s2, -4(s0)
	slt s3, s1, s2
	bnez s3, .L4_1
	j .L4_2
.L4_1:
	lw s1, -8(s0)
	lw s2, -672(s0)
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
	bnez s2, .L4_3
	j .L4_4
.L4_3:
	jal ra, usage
	mv s1, a0
	li s1, 0
	mv a0, s1
	lw s1, -716(s0)
	lw s2, -712(s0)
	lw s3, -708(s0)
	lw s4, -704(s0)
	lw s5, -700(s0)
	lw s6, -696(s0)
	lw s7, -692(s0)
	lw s8, -688(s0)
	lw s9, -684(s0)
	lw s10, -680(s0)
	lw s11, -676(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L4_4:
	lw s1, -8(s0)
	lw s2, -672(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L4_5
	j .L4_6
.L4_5:
	la s1, __str_4
	la s2, __str_5
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, printf
	mv s3, a0
	addi sp, sp, 16
	li s1, 0
	mv a0, s1
	lw s1, -716(s0)
	lw s2, -712(s0)
	lw s3, -708(s0)
	lw s4, -704(s0)
	lw s5, -700(s0)
	lw s6, -696(s0)
	lw s7, -692(s0)
	lw s8, -688(s0)
	lw s9, -684(s0)
	lw s10, -680(s0)
	lw s11, -676(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L4_6:
	lw s1, -8(s0)
	lw s2, -672(s0)
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
	bnez s2, .L4_7
	j .L4_8
.L4_7:
	lw s1, -672(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -4(s0)
	slt s2, s3, s1
	bnez s2, .L4_9
	j .L4_8
.L4_9:
	lw s1, -8(s0)
	addi s2, s0, -672
	lw s3, 0(s2)
	li s2, 1
	add s4, s3, s2
	sw s4, -672(s0)
	li s2, 4
	mul s3, s4, s2
	add s2, s1, s3
	lw s1, 0(s2)
	sw s1, -12(s0)
	j .L4_10
.L4_8:
	lw s1, -8(s0)
	lw s2, -672(s0)
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
	bnez s3, .L4_11
	j .L4_12
.L4_11:
	la s1, __str_7
	lw s2, -8(s0)
	lw s3, -672(s0)
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
	j .L4_13
.L4_12:
	lw s1, -16(s0)
	bnez s1, .L4_14
	j .L4_15
.L4_14:
	la s1, __str_8
	mv a0, s1
	jal ra, die
	mv s2, a0
.L4_15:
	lw s1, -8(s0)
	lw s2, -672(s0)
	li s3, 4
	mul s4, s2, s3
	add s2, s1, s4
	lw s1, 0(s2)
	sw s1, -16(s0)
.L4_13:
.L4_10:
.L4_16:
	addi s1, s0, -672
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -672(s0)
	j .L4_0
.L4_2:
	lw s1, -16(s0)
	bnez s1, .L4_17
	j .L4_18
.L4_18:
	jal ra, usage
	mv s1, a0
	li s1, 1
	mv a0, s1
	lw s1, -716(s0)
	lw s2, -712(s0)
	lw s3, -708(s0)
	lw s4, -704(s0)
	lw s5, -700(s0)
	lw s6, -696(s0)
	lw s7, -692(s0)
	lw s8, -688(s0)
	lw s9, -684(s0)
	lw s10, -680(s0)
	lw s11, -676(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L4_17:
	la s1, util_die_env
	mv a0, s1
	jal ra, setjmp
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L4_19
	j .L4_20
.L4_19:
	li s1, 1
	mv a0, s1
	lw s1, -716(s0)
	lw s2, -712(s0)
	lw s3, -708(s0)
	lw s4, -704(s0)
	lw s5, -700(s0)
	lw s6, -696(s0)
	lw s7, -692(s0)
	lw s8, -688(s0)
	lw s9, -684(s0)
	lw s10, -680(s0)
	lw s11, -676(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L4_20:
	li s1, 1
	la s2, util_die_active
	sw s1, 0(s2)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, slurp
	mv s2, a0
	sw s2, -24(s0)
	la s1, cleanup_free
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, util_cleanup_push
	mv s3, a0
	addi s1, s0, -668
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_init
	mv s3, a0
	addi s1, s0, -668
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, lex_set_source_path
	mv s3, a0
	la s1, cleanup_rv
	addi s2, s0, -668
	mv a0, s1
	mv a1, s2
	jal ra, util_cleanup_push
	mv s3, a0
	addi s1, s0, -668
	mv a0, s1
	jal ra, rv_assemble
	mv s2, a0
	addi s1, s0, -668
	mv a0, s1
	jal ra, rv_emit_debug
	mv s2, a0
	lw s1, -12(s0)
	bnez s1, .L4_21
	j .L4_22
.L4_21:
	lw s1, -12(s0)
	la s2, __str_9
	mv a0, s1
	mv a1, s2
	jal ra, fopen
	mv s3, a0
	sw s3, -20(s0)
	lw s1, -20(s0)
	bnez s1, .L4_23
	j .L4_24
.L4_24:
	la s1, __str_10
	lw s2, -12(s0)
	addi sp, sp, -16
	mv a0, s1
	sw s2, 0(sp)
	jal ra, die
	mv s3, a0
	addi sp, sp, 16
.L4_23:
	j .L4_25
.L4_22:
	la s1, __libc_stdout
	sw s1, -20(s0)
.L4_25:
	addi s1, s0, -668
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, rv_elf_write
	mv s3, a0
	lw s1, -12(s0)
	bnez s1, .L4_26
	j .L4_27
.L4_26:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, fclose
	mv s2, a0
.L4_27:
	jal ra, util_cleanup_run
	mv s1, a0
	li s1, 0
	mv a0, s1
	lw s1, -716(s0)
	lw s2, -712(s0)
	lw s3, -708(s0)
	lw s4, -704(s0)
	lw s5, -700(s0)
	lw s6, -696(s0)
	lw s7, -692(s0)
	lw s8, -688(s0)
	lw s9, -684(s0)
	lw s10, -680(s0)
	lw s11, -676(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end4:
	.size main, .Lfunc_end4-main

	.data
	.align 2
__str_10:
	.ascii "cannot open %s for writing\000"
	.align 2
__str_9:
	.ascii "wb\000"
	.align 2
__str_8:
	.ascii "multiple input files\000"
	.align 2
__str_7:
	.ascii "unknown option: %s\000"
	.align 2
__str_6:
	.ascii "-o\000"
	.align 2
__str_5:
	.ascii "0.43.0+g49a60c3\000"
	.align 2
__str_4:
	.ascii "skj-as-rv %s\n\000"
	.align 2
__str_3:
	.ascii "-V\000"
	.align 2
__str_2:
	.ascii "-h\000"
	.align 2
__str_1:
	.ascii "skj-as-rv\000"
	.align 2
__str_0:
	.ascii "usage: skj-as-rv [-o output.o] input.s\n\nRISC-V RV32 assembler (GAS syntax subset).\nReads assembly text and produces ELF32 little-endian EM_RISCV\nrelocatable objects.  Covers RV32IMAFD + Zfh + Zicsr +\nZba/Zbb/Zbs and the backend's pseudo-instructions.\n\noptions:\n  -o FILE   write output to FILE (default: stdout)\n  -h        show this help\n  -V        show version\n\000"
