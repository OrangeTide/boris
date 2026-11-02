# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type wire_out_init, @function
wire_out_init:
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
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 12
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
	.size wire_out_init, .Lfunc_end1-wire_out_init

	.text
	.align 2
	.type wire_put_u8, @function
wire_put_u8:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L2_0
	j .L2_1
.L2_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
.L2_1:
	addi s1, s0, -8
	lbu s2, 0(s1)
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -4(s0)
	li s4, 8
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
	.size wire_put_u8, .Lfunc_end2-wire_put_u8

	.text
	.align 2
	.type wire_put_u16, @function
wire_put_u16:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L3_0
	j .L3_1
.L3_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
.L3_1:
	addi s1, s0, -8
	lhu s2, 0(s1)
	li s1, 255
	and s3, s2, s1
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -4(s0)
	li s4, 8
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 1
	add s6, s1, s4
	sw s6, 0(s5)
	add s4, s3, s1
	sb s2, 0(s4)
	addi s1, s0, -8
	lhu s2, 0(s1)
	li s1, 8
	sra s3, s2, s1
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -4(s0)
	li s4, 8
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
.Lfunc_end3:
	.size wire_put_u16, .Lfunc_end3-wire_put_u16

	.text
	.align 2
	.type wire_put_u32, @function
wire_put_u32:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L4_0
	j .L4_1
.L4_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
.L4_1:
	lw s1, -8(s0)
	li s2, 255
	and s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -4(s0)
	li s4, 8
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 1
	add s6, s1, s4
	sw s6, 0(s5)
	add s4, s3, s1
	sb s2, 0(s4)
	lw s1, -8(s0)
	li s2, 8
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s4, 8
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 1
	add s6, s1, s4
	sw s6, 0(s5)
	add s4, s2, s1
	sb s3, 0(s4)
	lw s1, -8(s0)
	li s2, 16
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s4, 8
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 1
	add s6, s1, s4
	sw s6, 0(s5)
	add s4, s2, s1
	sb s3, 0(s4)
	lw s1, -8(s0)
	li s2, 24
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s4, 8
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 1
	add s6, s1, s4
	sw s6, 0(s5)
	add s4, s2, s1
	sb s3, 0(s4)
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
	.size wire_put_u32, .Lfunc_end4-wire_put_u32

	.text
	.align 2
	.type wire_put_u64, @function
wire_put_u64:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s2, 4294967295
	mv s8, s2
	li s9, 0
	and s6, s10, s8
	and s7, s11, s9
	mv s2, s6
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -4(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	li s2, 32
	addi sp, sp, -8
	sw s10, 0(sp)
	sw s11, 4(sp)
	addi sp, sp, -4
	sw s2, 0(sp)
	jal ra, __lshrdi3
	addi sp, sp, 12
	mv s8, a0
	mv s9, a1
	mv s2, s8
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
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
.Lfunc_end5:
	.size wire_put_u64, .Lfunc_end5-wire_put_u64

	.text
	.align 2
	.type wire_put_bytes, @function
wire_put_bytes:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -12(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L6_0
	j .L6_1
.L6_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
.L6_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
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
	li s2, 8
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
.Lfunc_end6:
	.size wire_put_bytes, .Lfunc_end6-wire_put_bytes

	.text
	.align 2
	.type wire_put_str, @function
wire_put_str:
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
	bnez s1, .L7_0
	j .L7_1
.L7_0:
	lw s1, -8(s0)
	mv a0, s1
	jal ra, strlen
	mv s2, a0
	sw s2, -16(s0)
	j .L7_2
.L7_1:
	li s1, 0
	sw s1, -16(s0)
.L7_2:
	lw s1, -16(s0)
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 65535
	sltu s3, s2, s1
	bnez s3, .L7_3
	j .L7_4
.L7_3:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
.L7_4:
	lw s1, -4(s0)
	lw s2, -12(s0)
	li s3, 65535
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, wire_put_u16
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_put_bytes
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
.Lfunc_end7:
	.size wire_put_str, .Lfunc_end7-wire_put_str

	.text
	.align 2
	.type wire_in_init, @function
wire_in_init:
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
	lw s2, -4(s0)
	sw s1, 0(s2)
	lw s1, -12(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 0
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	li s1, 1
	lw s2, -4(s0)
	li s3, 12
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
.Lfunc_end8:
	.size wire_in_init, .Lfunc_end8-wire_in_init

	.text
	.align 2
	.type wire_get_u8, @function
wire_get_u8:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 1
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L9_0
	j .L9_1
.L9_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
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
.L9_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 1
	add s5, s1, s3
	sw s5, 0(s4)
	add s3, s2, s1
	lbu s1, 0(s3)
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
.Lfunc_end9:
	.size wire_get_u8, .Lfunc_end9-wire_get_u8

	.text
	.align 2
	.type wire_get_u16, @function
wire_get_u16:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L10_0
	j .L10_1
.L10_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
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
.L10_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	lbu s1, 0(s3)
	li s2, 65535
	and s3, s1, s2
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s4, 8
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 1
	add s5, s1, s4
	add s1, s2, s5
	lbu s2, 0(s1)
	li s1, 65535
	and s4, s2, s1
	li s1, 8
	sll s2, s4, s1
	or s1, s3, s2
	sw s1, -12(s0)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 2
	add s4, s1, s2
	sw s4, 0(s3)
	addi s1, s0, -12
	lhu s2, 0(s1)
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
.Lfunc_end10:
	.size wire_get_u16, .Lfunc_end10-wire_get_u16

	.text
	.align 2
	.type wire_get_u32, @function
wire_get_u32:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L11_0
	j .L11_1
.L11_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
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
.L11_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	add s3, s2, s1
	lbu s1, 0(s3)
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -4(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	li s4, 1
	add s5, s2, s4
	add s2, s3, s5
	lbu s3, 0(s2)
	li s2, 8
	sll s4, s3, s2
	or s2, s1, s4
	lw s1, -4(s0)
	lw s3, 0(s1)
	lw s1, -4(s0)
	li s4, 8
	add s5, s1, s4
	lw s1, 0(s5)
	li s4, 2
	add s5, s1, s4
	add s1, s3, s5
	lbu s3, 0(s1)
	li s1, 16
	sll s4, s3, s1
	or s1, s2, s4
	lw s2, -4(s0)
	lw s3, 0(s2)
	lw s2, -4(s0)
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	li s4, 3
	add s5, s2, s4
	add s2, s3, s5
	lbu s3, 0(s2)
	li s2, 24
	sll s4, s3, s2
	or s2, s1, s4
	sw s2, -12(s0)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	li s2, 4
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end11:
	.size wire_get_u32, .Lfunc_end11-wire_get_u32

	.text
	.align 2
	.type wire_get_u64, @function
wire_get_u64:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	mv s10, s2
	li s11, 0
	sw s10, -16(s0)
	sw s11, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	mv s10, s2
	li s11, 0
	sw s10, -24(s0)
	sw s11, -20(s0)
	lw s10, -16(s0)
	lw s11, -12(s0)
	lw s8, -24(s0)
	lw s9, -20(s0)
	li s1, 32
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	or s8, s10, s6
	or s9, s11, s7
	mv a0, s8
	mv a1, s9
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
	.size wire_get_u64, .Lfunc_end12-wire_get_u64

	.text
	.align 2
	.type wire_get_str, @function
wire_get_str:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L13_0
	j .L13_1
.L13_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
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
.L13_1:
	li s1, 0
	sw s1, -24(s0)
.L13_2:
	lw s1, -24(s0)
	lw s2, -20(s0)
	sltu s3, s1, s2
	bnez s3, .L13_3
	j .L13_4
.L13_3:
	lw s1, -8(s0)
	bnez s1, .L13_5
	j .L13_6
.L13_5:
	lw s1, -24(s0)
	li s2, 1
	add s3, s1, s2
	lw s1, -12(s0)
	sltu s2, s3, s1
	bnez s2, .L13_7
	j .L13_6
.L13_7:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 8
	add s4, s1, s3
	lw s1, 0(s4)
	lw s3, -24(s0)
	add s4, s1, s3
	add s1, s2, s4
	lbu s2, 0(s1)
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	lw s3, -24(s0)
	add s4, s1, s3
	sb s2, 0(s4)
.L13_6:
.L13_8:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L13_2
.L13_4:
	lw s1, -8(s0)
	bnez s1, .L13_9
	j .L13_10
.L13_9:
	lw s1, -12(s0)
	li s2, 0
	sltu s3, s2, s1
	bnez s3, .L13_11
	j .L13_10
.L13_11:
	li s1, 0
	lw s2, -8(s0)
	lw s3, -20(s0)
	lw s4, -12(s0)
	sltu s5, s3, s4
	bnez s5, .L13_12
	j .L13_13
.L13_12:
	lw s3, -20(s0)
	sw s3, -28(s0)
	j .L13_14
.L13_13:
	lw s3, -12(s0)
	li s4, 1
	sub s5, s3, s4
	sw s5, -28(s0)
.L13_14:
	lw s3, -28(s0)
	add s4, s2, s3
	sb s1, 0(s4)
.L13_10:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -20(s0)
	add s4, s1, s2
	sw s4, 0(s3)
	lw s1, -20(s0)
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
.Lfunc_end13:
	.size wire_get_str, .Lfunc_end13-wire_get_str

	.text
	.align 2
	.type wire_skip, @function
wire_skip:
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
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s3, s1, s2
	lw s1, -4(s0)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L14_0
	j .L14_1
.L14_0:
	li s1, 0
	lw s2, -4(s0)
	li s3, 12
	add s4, s2, s3
	sw s1, 0(s4)
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
.L14_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -8(s0)
	add s4, s1, s2
	sw s4, 0(s3)
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
.Lfunc_end14:
	.size wire_skip, .Lfunc_end14-wire_skip

	.text
	.align 2
	.type p9o_qid, @function
p9o_qid:
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
	lbu s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, wire_put_u8
	mv s2, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 8
	add s4, s2, s3
	lw s10, 0(s4)
	lw s11, 4(s4)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, wire_put_u64
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
.Lfunc_end15:
	.size p9o_qid, .Lfunc_end15-p9o_qid

	.text
	.align 2
	.type p9o_hdr, @function
p9o_hdr:
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
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -4(s0)
	addi s2, s0, -8
	lbu s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, wire_put_u8
	mv s2, a0
	lw s1, -4(s0)
	addi s2, s0, -12
	lhu s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, wire_put_u16
	mv s2, a0
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
.Lfunc_end16:
	.size p9o_hdr, .Lfunc_end16-p9o_hdr

	.text
	.align 2
	.type p9o_finish, @function
p9o_finish:
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
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L17_0
	j .L17_1
.L17_1:
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
.L17_0:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -12(s0)
	lw s1, -12(s0)
	li s2, 255
	and s3, s1, s2
	li s1, 255
	and s2, s3, s1
	lw s1, -4(s0)
	lw s3, 0(s1)
	li s1, 0
	add s4, s3, s1
	sb s2, 0(s4)
	lw s1, -12(s0)
	li s2, 8
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 1
	add s4, s2, s1
	sb s3, 0(s4)
	lw s1, -12(s0)
	li s2, 16
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 2
	add s4, s2, s1
	sb s3, 0(s4)
	lw s1, -12(s0)
	li s2, 24
	srl s3, s1, s2
	li s1, 255
	and s2, s3, s1
	li s1, 255
	and s3, s2, s1
	lw s1, -4(s0)
	lw s2, 0(s1)
	li s1, 3
	add s4, s2, s1
	sb s3, 0(s4)
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
	.size p9o_finish, .Lfunc_end17-p9o_finish

	.text
	.align 2
	.type p9i_qid, @function
p9i_qid:
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
	jal ra, wire_get_u8
	mv s2, a0
	lw s1, -8(s0)
	sb s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	lw s1, -8(s0)
	li s3, 4
	add s4, s1, s3
	sw s2, 0(s4)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u64
	mv s10, a0
	mv s11, a1
	lw s1, -8(s0)
	li s2, 8
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
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
.Lfunc_end18:
	.size p9i_qid, .Lfunc_end18-p9i_qid

	.text
	.align 2
	.type nm_of, @function
nm_of:
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
	la s1, mounts
	lw s2, -4(s0)
	la s3, fs_mounts
	sub s4, s2, s3
	li s2, 16
	div s3, s4, s2
	li s2, 16
	mul s4, s3, s2
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
.Lfunc_end19:
	.size nm_of, .Lfunc_end19-nm_of

	.text
	.align 2
	.type fid_alloc, @function
fid_alloc:
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
	li s1, 1
	sw s1, -12(s0)
.L20_0:
	lw s1, -12(s0)
	li s2, 64
	slt s3, s1, s2
	bnez s3, .L20_1
	j .L20_2
.L20_1:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	lw s1, -12(s0)
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	and s8, s10, s6
	and s9, s11, s7
	bnez s8, .L20_3
	j .L20_4
.L20_4:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	lw s1, -12(s0)
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	or s8, s10, s6
	or s9, s11, s7
	sw s8, 0(s3)
	sw s9, 4(s3)
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
.L20_3:
.L20_5:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
	j .L20_0
.L20_2:
	li s1, 16
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
.Lfunc_end20:
	.size fid_alloc, .Lfunc_end20-fid_alloc

	.text
	.align 2
	.type fid_free, @function
fid_free:
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
	li s2, 0
	slt s3, s2, s1
	bnez s3, .L21_0
	j .L21_1
.L21_0:
	lw s1, -8(s0)
	li s2, 64
	slt s3, s1, s2
	bnez s3, .L21_2
	j .L21_1
.L21_2:
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s10, 0(s3)
	lw s11, 4(s3)
	li s1, 1
	mv s8, s1
	srai s9, s8, 31
	lw s1, -8(s0)
	addi sp, sp, -8
	sw s8, 0(sp)
	sw s9, 4(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal ra, __ashldi3
	addi sp, sp, 12
	mv s6, a0
	mv s7, a1
	li s8, -1
	li s9, -1
	xor s4, s6, s8
	xor s5, s7, s9
	and s8, s10, s4
	and s9, s11, s5
	sw s8, 0(s3)
	sw s9, 4(s3)
.L21_1:
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
.Lfunc_end21:
	.size fid_free, .Lfunc_end21-fid_free

	.text
	.align 2
	.type p9_txn, @function
p9_txn:
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
	lw s1, -8(s0)
	mv a0, s1
	jal ra, p9o_finish
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_0
	j .L22_1
.L22_0:
	li s1, 4
	neg s2, s1
	mv a0, s2
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
.L22_1:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	la s3, txbuf
	lw s4, -20(s0)
	la s5, rxbuf
	li s6, 8192
	mv a0, s1
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv t0, s2
	jalr ra, t0, 0
	mv s7, a0
	sw s7, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L22_2
	j .L22_3
.L22_2:
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
.L22_3:
	lw s1, -12(s0)
	la s2, rxbuf
	lw s3, -24(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_in_init
	mv s4, a0
	lw s1, -12(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, wire_get_u8
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -12(s0)
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L22_4
	j .L22_5
.L22_5:
	li s1, 8
	neg s2, s1
	mv a0, s2
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
.L22_4:
	lw s1, -28(s0)
	li s2, 107
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L22_6
	j .L22_7
.L22_6:
	li s1, 6
	neg s2, s1
	mv a0, s2
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
.L22_7:
	lw s1, -28(s0)
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
.Lfunc_end22:
	.size p9_txn, .Lfunc_end22-p9_txn

	.text
	.align 2
	.type next_reply, @function
next_reply:
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
	lw s2, 0(s1)
	sw s2, -20(s0)
	lw s1, -20(s0)
	lw s2, -8(s0)
	sltu s3, s2, s1
	bnez s3, .L23_0
	j .L23_1
.L23_1:
	lw s1, -8(s0)
	lw s2, -20(s0)
	sub s3, s1, s2
	li s1, 7
	sltu s2, s3, s1
	bnez s2, .L23_0
	j .L23_2
.L23_0:
	li s1, 8
	neg s2, s1
	mv a0, s2
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
.L23_2:
	lw s1, -4(s0)
	lw s2, -20(s0)
	add s3, s1, s2
	lbu s1, 0(s3)
	lw s2, -4(s0)
	lw s3, -20(s0)
	li s4, 1
	add s5, s3, s4
	add s3, s2, s5
	lbu s2, 0(s3)
	li s3, 8
	sll s4, s2, s3
	or s2, s1, s4
	lw s1, -4(s0)
	lw s3, -20(s0)
	li s4, 2
	add s5, s3, s4
	add s3, s1, s5
	lbu s1, 0(s3)
	li s3, 16
	sll s4, s1, s3
	or s1, s2, s4
	lw s2, -4(s0)
	lw s3, -20(s0)
	li s4, 3
	add s5, s3, s4
	add s3, s2, s5
	lbu s2, 0(s3)
	li s3, 24
	sll s4, s2, s3
	or s2, s1, s4
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 7
	sltu s3, s1, s2
	bnez s3, .L23_3
	j .L23_4
.L23_4:
	lw s1, -24(s0)
	lw s2, -8(s0)
	lw s3, -20(s0)
	sub s4, s2, s3
	sltu s2, s4, s1
	bnez s2, .L23_3
	j .L23_5
.L23_3:
	li s1, 8
	neg s2, s1
	mv a0, s2
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
.L23_5:
	lw s1, -16(s0)
	lw s2, -4(s0)
	lw s3, -20(s0)
	add s4, s2, s3
	lw s2, -24(s0)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, wire_in_init
	mv s3, a0
	lw s1, -16(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -16(s0)
	mv a0, s1
	jal ra, wire_get_u8
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -16(s0)
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	lw s2, -24(s0)
	add s3, s1, s2
	lw s1, -12(s0)
	sw s3, 0(s1)
	lw s1, -16(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L23_6
	j .L23_7
.L23_7:
	li s1, 8
	neg s2, s1
	mv a0, s2
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
.L23_6:
	lw s1, -28(s0)
	li s2, 107
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L23_8
	j .L23_9
.L23_8:
	li s1, 6
	neg s2, s1
	mv a0, s2
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
.L23_9:
	lw s1, -28(s0)
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
.Lfunc_end23:
	.size next_reply, .Lfunc_end23-next_reply

	.text
	.align 2
	.type p9_clunk, @function
p9_clunk:
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
	addi s1, s0, -24
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -24
	li s2, 120
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -24
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -4(s0)
	addi s2, s0, -24
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -44(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -44(s0)
	li s2, 121
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L24_0
	j .L24_1
.L24_0:
	li s1, 0
	sw s1, -48(s0)
	j .L24_2
.L24_1:
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L24_3
	j .L24_4
.L24_3:
	lw s1, -44(s0)
	sw s1, -52(s0)
	j .L24_5
.L24_4:
	li s1, 8
	neg s2, s1
	sw s2, -52(s0)
.L24_5:
	lw s1, -52(s0)
	sw s1, -48(s0)
.L24_2:
	lw s1, -48(s0)
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
.Lfunc_end24:
	.size p9_clunk, .Lfunc_end24-p9_clunk

	.text
	.align 2
	.type split_count, @function
split_count:
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
	lw s1, -4(s0)
	sw s1, -16(s0)
.L25_0:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L25_1
	j .L25_2
.L25_1:
.L25_3:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L25_4
	j .L25_5
.L25_4:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L25_3
.L25_5:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L25_6
	j .L25_7
.L25_7:
	j .L25_2
.L25_6:
	lw s1, -16(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_8
	j .L25_9
.L25_8:
	lw s1, -16(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 47
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_10
	j .L25_11
.L25_11:
	lw s1, -16(s0)
	li s2, 1
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L25_10
	j .L25_9
.L25_9:
	addi s1, s0, -12
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -12(s0)
.L25_10:
.L25_12:
	lw s1, -16(s0)
	lb s2, 0(s1)
	bnez s2, .L25_13
	j .L25_14
.L25_13:
	lw s1, -16(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L25_15
	j .L25_14
.L25_15:
	addi s1, s0, -16
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -16(s0)
	j .L25_12
.L25_14:
	j .L25_0
.L25_2:
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
.Lfunc_end25:
	.size split_count, .Lfunc_end25-split_count

	.text
	.align 2
	.type split_at, @function
split_at:
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
	lw s1, -4(s0)
	sw s1, -24(s0)
.L26_0:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L26_1
	j .L26_2
.L26_1:
.L26_3:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	seqz s3, s3
	bnez s3, .L26_4
	j .L26_5
.L26_4:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L26_3
.L26_5:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L26_6
	j .L26_7
.L26_7:
	j .L26_2
.L26_6:
	lw s1, -24(s0)
	sw s1, -28(s0)
.L26_8:
	lw s1, -24(s0)
	lb s2, 0(s1)
	bnez s2, .L26_9
	j .L26_10
.L26_9:
	lw s1, -24(s0)
	lb s2, 0(s1)
	li s1, 47
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L26_11
	j .L26_10
.L26_11:
	addi s1, s0, -24
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -24(s0)
	j .L26_8
.L26_10:
	lw s1, -24(s0)
	lw s2, -28(s0)
	sub s3, s1, s2
	sw s3, -32(s0)
	lw s1, -32(s0)
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_12
	j .L26_13
.L26_12:
	lw s1, -28(s0)
	li s2, 0
	add s3, s1, s2
	lb s1, 0(s3)
	li s2, 46
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_14
	j .L26_13
.L26_14:
	j .L26_0
.L26_13:
	lw s1, -20(s0)
	lw s2, -8(s0)
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L26_15
	j .L26_16
.L26_15:
	lw s1, -32(s0)
	lw s2, -16(s0)
	li s3, 1
	sub s4, s2, s3
	slt s2, s4, s1
	bnez s2, .L26_17
	j .L26_18
.L26_17:
	lw s1, -16(s0)
	li s2, 1
	sub s3, s1, s2
	sw s3, -32(s0)
.L26_18:
	lw s1, -12(s0)
	lw s2, -28(s0)
	lw s3, -32(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, memcpy
	mv s4, a0
	li s1, 0
	lw s2, -12(s0)
	lw s3, -32(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -32(s0)
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
.L26_16:
	addi s1, s0, -20
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -20(s0)
	j .L26_0
.L26_2:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.Lfunc_end26:
	.size split_at, .Lfunc_end26-split_at

	.text
	.align 2
	.type batch_walk, @function
batch_walk:
	addi sp, sp, -176
	sw ra, 172(sp)
	sw s0, 168(sp)
	addi s0, sp, 168
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
	mv a0, s1
	jal ra, split_count
	mv s2, a0
	sw s2, -44(s0)
	lw s1, -44(s0)
	li s2, 16
	slt s3, s2, s1
	bnez s3, .L27_0
	j .L27_1
.L27_0:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_1:
	addi s1, s0, -40
	lw s2, -4(s0)
	lw s3, -12(s0)
	lw s4, 0(s3)
	add s3, s2, s4
	lw s2, -8(s0)
	lw s4, -12(s0)
	lw s5, 0(s4)
	sub s4, s2, s5
	mv a0, s1
	mv a1, s3
	mv a2, s4
	jal ra, wire_out_init
	mv s2, a0
	addi s1, s0, -40
	li s2, 110
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -40
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -40
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -40
	lw s2, -44(s0)
	li s3, 65535
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, wire_put_u16
	mv s2, a0
	li s1, 0
	sw s1, -48(s0)
.L27_2:
	lw s1, -48(s0)
	lw s2, -44(s0)
	slt s3, s1, s2
	bnez s3, .L27_3
	j .L27_4
.L27_3:
	lw s1, -24(s0)
	lw s2, -48(s0)
	addi s3, s0, -112
	li s4, 56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, split_at
	mv s5, a0
	addi s1, s0, -40
	addi s2, s0, -112
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
.L27_5:
	addi s1, s0, -48
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -48(s0)
	j .L27_2
.L27_4:
	addi s1, s0, -40
	mv a0, s1
	jal ra, p9o_finish
	mv s2, a0
	sw s2, -52(s0)
	lw s1, -52(s0)
	bnez s1, .L27_6
	j .L27_7
.L27_7:
	li s1, 1
	neg s2, s1
	mv a0, s2
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L27_6:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s3, -52(s0)
	add s4, s2, s3
	sw s4, 0(s1)
	lw s1, -44(s0)
	mv a0, s1
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end27:
	.size batch_walk, .Lfunc_end27-batch_walk

	.text
	.align 2
	.type batch_fid_msg, @function
batch_fid_msg:
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
	addi s1, s0, -40
	lw s2, -4(s0)
	lw s3, -12(s0)
	lw s4, 0(s3)
	add s3, s2, s4
	lw s2, -8(s0)
	lw s4, -12(s0)
	lw s5, 0(s4)
	sub s4, s2, s5
	mv a0, s1
	mv a1, s3
	mv a2, s4
	jal ra, wire_out_init
	mv s2, a0
	addi s1, s0, -40
	addi s2, s0, -16
	lbu s3, 0(s2)
	li s2, 0
	mv a0, s1
	mv a1, s3
	mv a2, s2
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -40
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -40
	mv a0, s1
	jal ra, p9o_finish
	mv s2, a0
	sw s2, -44(s0)
	lw s1, -44(s0)
	bnez s1, .L28_0
	j .L28_1
.L28_1:
	li s1, 1
	neg s2, s1
	mv a0, s2
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
.L28_0:
	lw s1, -12(s0)
	lw s2, 0(s1)
	lw s3, -44(s0)
	add s4, s2, s3
	sw s4, 0(s1)
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
.Lfunc_end28:
	.size batch_fid_msg, .Lfunc_end28-batch_fid_msg

	.text
	.align 2
	.type batch_walk_reply, @function
batch_walk_reply:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	addi s4, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, next_reply
	mv s5, a0
	sw s5, -60(s0)
	li s1, 128
	addi s2, s0, -56
	sb s1, 0(s2)
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L29_0
	j .L29_1
.L29_0:
	lw s1, -60(s0)
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
.L29_1:
	lw s1, -60(s0)
	li s2, 111
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L29_2
	j .L29_3
.L29_2:
	li s1, 8
	neg s2, s1
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
.L29_3:
	addi s1, s0, -40
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	sw s2, -68(s0)
	li s1, 0
	sw s1, -64(s0)
.L29_4:
	lw s1, -64(s0)
	lw s2, -68(s0)
	slt s3, s1, s2
	bnez s3, .L29_5
	j .L29_6
.L29_5:
	addi s1, s0, -40
	addi s2, s0, -56
	mv a0, s1
	mv a1, s2
	jal ra, p9i_qid
	mv s3, a0
.L29_7:
	addi s1, s0, -64
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -64(s0)
	j .L29_4
.L29_6:
	addi s1, s0, -40
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L29_8
	j .L29_9
.L29_8:
	lw s1, -68(s0)
	lw s2, -16(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L29_9
	j .L29_10
.L29_9:
	li s1, 6
	neg s2, s1
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
.L29_10:
	lw s1, -20(s0)
	bnez s1, .L29_11
	j .L29_12
.L29_11:
	addi s1, s0, -56
	lbu s2, 0(s1)
	lw s1, -20(s0)
	sw s2, 0(s1)
.L29_12:
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
.Lfunc_end29:
	.size batch_walk_reply, .Lfunc_end29-batch_walk_reply

	.text
	.align 2
	.type walk_rel, @function
walk_rel:
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
	sw a2, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, fid_alloc
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, split_count
	mv s2, a0
	sw s2, -24(s0)
	li s1, 0
	sw s1, -28(s0)
	li s1, 1
	sw s1, -32(s0)
	li s1, 128
	addi s2, s0, -48
	sb s1, 0(s2)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L30_0
	j .L30_1
.L30_0:
	lw s1, -20(s0)
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
.L30_1:
.L30_2:
	lw s1, -24(s0)
	lw s2, -28(s0)
	sub s3, s1, s2
	sw s3, -84(s0)
	lw s1, -84(s0)
	li s2, 16
	slt s3, s2, s1
	bnez s3, .L30_3
	j .L30_4
.L30_3:
	li s1, 16
	sw s1, -84(s0)
.L30_4:
	addi s1, s0, -64
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -64
	li s2, 110
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -64
	lw s2, -32(s0)
	bnez s2, .L30_5
	j .L30_6
.L30_5:
	li s2, 0
	sw s2, -100(s0)
	j .L30_7
.L30_6:
	lw s2, -20(s0)
	sw s2, -100(s0)
.L30_7:
	lw s2, -100(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -64
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -64
	lw s2, -84(s0)
	li s3, 65535
	and s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, wire_put_u16
	mv s2, a0
	li s1, 0
	sw s1, -88(s0)
.L30_8:
	lw s1, -88(s0)
	lw s2, -84(s0)
	slt s3, s1, s2
	bnez s3, .L30_9
	j .L30_10
.L30_9:
	lw s1, -8(s0)
	lw s2, -28(s0)
	lw s3, -88(s0)
	add s4, s2, s3
	addi s2, s0, -160
	li s3, 56
	mv a0, s1
	mv a1, s4
	mv a2, s2
	mv a3, s3
	jal ra, split_at
	mv s5, a0
	addi s1, s0, -64
	addi s2, s0, -160
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
.L30_11:
	addi s1, s0, -88
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -88(s0)
	j .L30_8
.L30_10:
	lw s1, -4(s0)
	addi s2, s0, -64
	addi s3, s0, -80
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -96(s0)
	lw s1, -96(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L30_12
	j .L30_13
.L30_12:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -96(s0)
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
.L30_13:
	lw s1, -96(s0)
	li s2, 111
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L30_14
	j .L30_15
.L30_14:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	li s1, 8
	neg s2, s1
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
.L30_15:
	addi s1, s0, -80
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	sw s2, -92(s0)
	li s1, 0
	sw s1, -88(s0)
.L30_16:
	lw s1, -88(s0)
	lw s2, -92(s0)
	slt s3, s1, s2
	bnez s3, .L30_17
	j .L30_18
.L30_17:
	addi s1, s0, -80
	addi s2, s0, -48
	mv a0, s1
	mv a1, s2
	jal ra, p9i_qid
	mv s3, a0
.L30_19:
	addi s1, s0, -88
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -88(s0)
	j .L30_16
.L30_18:
	addi s1, s0, -80
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L30_20
	j .L30_21
.L30_20:
	lw s1, -92(s0)
	lw s2, -84(s0)
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L30_21
	j .L30_22
.L30_21:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	li s1, 6
	neg s2, s1
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
.L30_22:
	addi s1, s0, -28
	lw s2, 0(s1)
	lw s1, -84(s0)
	add s3, s2, s1
	sw s3, -28(s0)
	li s1, 0
	sw s1, -32(s0)
.L30_23:
	lw s1, -28(s0)
	lw s2, -24(s0)
	slt s3, s1, s2
	bnez s3, .L30_2
	j .L30_24
.L30_24:
	lw s1, -12(s0)
	bnez s1, .L30_25
	j .L30_26
.L30_25:
	addi s1, s0, -48
	lbu s2, 0(s1)
	lw s1, -12(s0)
	sw s2, 0(s1)
.L30_26:
	lw s1, -20(s0)
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
.Lfunc_end30:
	.size walk_rel, .Lfunc_end30-walk_rel

	.text
	.align 2
	.type split_last, @function
split_last:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, split_count
	mv s2, a0
	sw s2, -28(s0)
	li s1, 0
	sw s1, -36(s0)
	lw s1, -28(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L31_0
	j .L31_1
.L31_0:
	li s1, 0
	lw s2, -8(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
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
.L31_1:
	li s1, 0
	lw s2, -8(s0)
	li s3, 0
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	sw s1, -32(s0)
.L31_2:
	lw s1, -32(s0)
	lw s2, -28(s0)
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L31_3
	j .L31_4
.L31_3:
	lw s1, -4(s0)
	lw s2, -32(s0)
	addi s3, s0, -96
	li s4, 56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, split_at
	mv s5, a0
	sw s5, -100(s0)
	lw s1, -36(s0)
	bnez s1, .L31_5
	j .L31_6
.L31_5:
	lw s1, -36(s0)
	lw s2, -12(s0)
	li s3, 1
	sub s4, s2, s3
	slt s2, s1, s4
	bnez s2, .L31_7
	j .L31_6
.L31_7:
	li s1, 47
	lw s2, -8(s0)
	addi s3, s0, -36
	lw s4, 0(s3)
	li s3, 1
	add s5, s4, s3
	sw s5, -36(s0)
	add s3, s2, s4
	sb s1, 0(s3)
.L31_6:
	lw s1, -100(s0)
	lw s2, -12(s0)
	li s3, 1
	sub s4, s2, s3
	lw s2, -36(s0)
	sub s3, s4, s2
	slt s2, s3, s1
	bnez s2, .L31_8
	j .L31_9
.L31_8:
	lw s1, -12(s0)
	li s2, 1
	sub s3, s1, s2
	lw s1, -36(s0)
	sub s2, s3, s1
	sw s2, -100(s0)
.L31_9:
	lw s1, -8(s0)
	lw s2, -36(s0)
	add s3, s1, s2
	addi s1, s0, -96
	lw s2, -100(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	addi s1, s0, -36
	lw s2, 0(s1)
	lw s1, -100(s0)
	add s3, s2, s1
	sw s3, -36(s0)
.L31_10:
	addi s1, s0, -32
	lw s2, 0(s1)
	li s1, 1
	add s3, s2, s1
	sw s3, -32(s0)
	j .L31_2
.L31_4:
	li s1, 0
	lw s2, -8(s0)
	lw s3, -36(s0)
	add s4, s2, s3
	sb s1, 0(s4)
	lw s1, -4(s0)
	lw s2, -28(s0)
	li s3, 1
	sub s4, s2, s3
	lw s2, -16(s0)
	lw s3, -20(s0)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	mv a3, s3
	jal ra, split_at
	mv s5, a0
	mv a0, s5
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
.Lfunc_end31:
	.size split_last, .Lfunc_end31-split_last

	.text
	.align 2
	.type p9_open_mode, @function
p9_open_mode:
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
	li s2, 3
	and s3, s1, s2
	li s1, 1
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L32_0
	li s1, 2
	xor s2, s3, s1
	seqz s2, s2
	bnez s2, .L32_1
	j .L32_2
.L32_0:
	li s1, 1
	sw s1, -12(s0)
	j .L32_3
.L32_1:
	li s1, 2
	sw s1, -12(s0)
	j .L32_3
.L32_2:
	li s1, 0
	sw s1, -12(s0)
	j .L32_3
.L32_3:
	lw s1, -4(s0)
	li s2, 512
	and s3, s1, s2
	bnez s3, .L32_4
	j .L32_5
.L32_4:
	addi s1, s0, -12
	lbu s2, 0(s1)
	li s1, 16
	or s3, s2, s1
	sw s3, -12(s0)
.L32_5:
	addi s1, s0, -12
	lbu s2, 0(s1)
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
.Lfunc_end32:
	.size p9_open_mode, .Lfunc_end32-p9_open_mode

	.text
	.align 2
	.type do_open, @function
do_open:
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
	addi s1, s0, -32
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -32
	li s2, 112
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -32
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -32
	addi s2, s0, -12
	lbu s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, wire_put_u8
	mv s2, a0
	lw s1, -4(s0)
	addi s2, s0, -32
	addi s3, s0, -48
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -52(s0)
	lw s1, -52(s0)
	li s2, 113
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L33_0
	j .L33_1
.L33_0:
	li s1, 0
	sw s1, -56(s0)
	j .L33_2
.L33_1:
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L33_3
	j .L33_4
.L33_3:
	lw s1, -52(s0)
	sw s1, -60(s0)
	j .L33_5
.L33_4:
	li s1, 8
	neg s2, s1
	sw s2, -60(s0)
.L33_5:
	lw s1, -60(s0)
	sw s1, -56(s0)
.L33_2:
	lw s1, -56(s0)
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
.Lfunc_end33:
	.size do_open, .Lfunc_end33-do_open

	.text
	.align 2
	.type do_create, @function
do_create:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	addi s1, s0, -40
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -40
	li s2, 114
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -40
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -40
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -40
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -40
	addi s2, s0, -20
	lbu s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, wire_put_u8
	mv s2, a0
	lw s1, -4(s0)
	addi s2, s0, -40
	addi s3, s0, -56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -60(s0)
	lw s1, -60(s0)
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L34_0
	j .L34_1
.L34_0:
	li s1, 0
	sw s1, -64(s0)
	j .L34_2
.L34_1:
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L34_3
	j .L34_4
.L34_3:
	lw s1, -60(s0)
	sw s1, -68(s0)
	j .L34_5
.L34_4:
	li s1, 9
	neg s2, s1
	sw s2, -68(s0)
.L34_5:
	lw s1, -68(s0)
	sw s1, -64(s0)
.L34_2:
	lw s1, -64(s0)
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
.Lfunc_end34:
	.size do_create, .Lfunc_end34-do_create

	.text
	.align 2
	.type open_create, @function
open_create:
	addi sp, sp, -400
	sw ra, 396(sp)
	sw s0, 392(sp)
	addi s0, sp, 392
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
	addi s2, s0, -272
	li s3, 256
	addi s4, s0, -328
	li s5, 56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, split_last
	mv s6, a0
	li s1, 0
	slt s2, s1, s6
	xori s2, s2, 1
	bnez s2, .L35_0
	j .L35_1
.L35_0:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -380(s0)
	lw s2, -376(s0)
	lw s3, -372(s0)
	lw s4, -368(s0)
	lw s5, -364(s0)
	lw s6, -360(s0)
	lw s7, -356(s0)
	lw s8, -352(s0)
	lw s9, -348(s0)
	lw s10, -344(s0)
	lw s11, -340(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_1:
	lw s1, -4(s0)
	addi s2, s0, -272
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk_rel
	mv s4, a0
	sw s4, -332(s0)
	lw s1, -332(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L35_2
	j .L35_3
.L35_2:
	lw s1, -332(s0)
	mv a0, s1
	lw s1, -380(s0)
	lw s2, -376(s0)
	lw s3, -372(s0)
	lw s4, -368(s0)
	lw s5, -364(s0)
	lw s6, -360(s0)
	lw s7, -356(s0)
	lw s8, -352(s0)
	lw s9, -348(s0)
	lw s10, -344(s0)
	lw s11, -340(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_3:
	lw s1, -4(s0)
	lw s2, -332(s0)
	addi s3, s0, -328
	li s4, 420
	lw s5, -12(s0)
	mv a0, s5
	jal ra, p9_open_mode
	mv s6, a0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s6
	jal ra, do_create
	mv s5, a0
	sw s5, -336(s0)
	lw s1, -336(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L35_4
	j .L35_5
.L35_4:
	lw s1, -4(s0)
	lw s2, -332(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	lw s1, -336(s0)
	mv a0, s1
	lw s1, -380(s0)
	lw s2, -376(s0)
	lw s3, -372(s0)
	lw s4, -368(s0)
	lw s5, -364(s0)
	lw s6, -360(s0)
	lw s7, -356(s0)
	lw s8, -352(s0)
	lw s9, -348(s0)
	lw s10, -344(s0)
	lw s11, -340(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L35_5:
	lw s1, -332(s0)
	mv a0, s1
	lw s1, -380(s0)
	lw s2, -376(s0)
	lw s3, -372(s0)
	lw s4, -368(s0)
	lw s5, -364(s0)
	lw s6, -360(s0)
	lw s7, -356(s0)
	lw s8, -352(s0)
	lw s9, -348(s0)
	lw s10, -344(s0)
	lw s11, -340(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end35:
	.size open_create, .Lfunc_end35-open_create

	.text
	.align 2
	.type open_stepwise, @function
open_stepwise:
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
	li s1, 0
	sw s1, -24(s0)
	lw s1, -4(s0)
	lw s2, -8(s0)
	addi s3, s0, -24
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk_rel
	mv s4, a0
	sw s4, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L36_0
	j .L36_1
.L36_0:
	lw s1, -20(s0)
	li s2, 6
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L36_2
	j .L36_3
.L36_2:
	lw s1, -12(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L36_3
	j .L36_4
.L36_4:
	lw s1, -12(s0)
	li s2, 64
	and s3, s1, s2
	bnez s3, .L36_5
	j .L36_3
.L36_5:
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, open_create
	mv s4, a0
	mv a0, s4
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
.L36_3:
	lw s1, -20(s0)
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
.L36_1:
	lw s1, -12(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L36_6
	j .L36_7
.L36_6:
	lw s1, -24(s0)
	li s2, 128
	and s3, s1, s2
	bnez s3, .L36_7
	j .L36_8
.L36_8:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	li s1, 12
	neg s2, s1
	mv a0, s2
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
.L36_7:
	lw s1, -12(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L36_9
	j .L36_10
.L36_10:
	lw s1, -24(s0)
	li s2, 128
	and s3, s1, s2
	bnez s3, .L36_11
	j .L36_9
.L36_11:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	li s1, 13
	neg s2, s1
	mv a0, s2
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
.L36_9:
	lw s1, -4(s0)
	lw s2, -20(s0)
	lw s3, -12(s0)
	li s4, 65536
	and s5, s3, s4
	bnez s5, .L36_12
	j .L36_13
.L36_12:
	li s3, 0
	sw s3, -32(s0)
	j .L36_14
.L36_13:
	lw s3, -12(s0)
	mv a0, s3
	jal ra, p9_open_mode
	mv s4, a0
	sw s4, -32(s0)
.L36_14:
	lw s3, -32(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, do_open
	mv s4, a0
	sw s4, -28(s0)
	lw s1, -28(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L36_15
	j .L36_16
.L36_15:
	lw s1, -4(s0)
	lw s2, -20(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	lw s1, -28(s0)
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
.L36_16:
	lw s1, -20(s0)
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
	.size open_stepwise, .Lfunc_end36-open_stepwise

	.text
	.align 2
	.type nine_open, @function
nine_open:
	addi sp, sp, -176
	sw ra, 172(sp)
	sw s0, 168(sp)
	addi s0, sp, 168
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
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -28(s0)
	li s1, 0
	sw s1, -40(s0)
	lw s1, -16(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L37_0
	j .L37_1
.L37_0:
	li s1, 0
	sw s1, -60(s0)
	j .L37_2
.L37_1:
	lw s1, -16(s0)
	mv a0, s1
	jal ra, p9_open_mode
	mv s2, a0
	sw s2, -60(s0)
.L37_2:
	lw s1, -60(s0)
	sw s1, -56(s0)
	li s1, 0
	sw s1, -64(s0)
	li s1, 0
	sw s1, -68(s0)
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	mv a0, s1
	jal ra, split_count
	mv s2, a0
	sw s2, -36(s0)
	lw s1, -36(s0)
	li s2, 16
	slt s3, s2, s1
	bnez s3, .L37_3
	j .L37_4
.L37_3:
	lw s1, -28(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, open_stepwise
	mv s4, a0
	mv a0, s4
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_4:
	lw s1, -28(s0)
	mv a0, s1
	jal ra, fid_alloc
	mv s2, a0
	sw s2, -32(s0)
	lw s1, -32(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L37_5
	j .L37_6
.L37_5:
	lw s1, -32(s0)
	mv a0, s1
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_6:
	la s1, txbuf
	li s2, 8192
	addi s3, s0, -64
	li s4, 0
	lw s5, -32(s0)
	lw s6, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, batch_walk
	mv s7, a0
	li s1, 0
	slt s2, s7, s1
	bnez s2, .L37_7
	j .L37_8
.L37_7:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -28(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, open_stepwise
	mv s4, a0
	mv a0, s4
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_8:
	addi s1, s0, -88
	la s2, txbuf
	lw s3, -64(s0)
	add s4, s2, s3
	li s2, 8192
	lw s3, -64(s0)
	sub s5, s2, s3
	mv a0, s1
	mv a1, s4
	mv a2, s5
	jal ra, wire_out_init
	mv s2, a0
	addi s1, s0, -88
	li s2, 112
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -88
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -88
	addi s2, s0, -56
	lbu s3, 0(s2)
	mv a0, s1
	mv a1, s3
	jal ra, wire_put_u8
	mv s2, a0
	addi s1, s0, -88
	mv a0, s1
	jal ra, p9o_finish
	mv s2, a0
	sw s2, -72(s0)
	lw s1, -72(s0)
	bnez s1, .L37_9
	j .L37_10
.L37_10:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_9:
	addi s1, s0, -64
	lw s2, 0(s1)
	lw s1, -72(s0)
	add s3, s2, s1
	sw s3, -64(s0)
	lw s1, -28(s0)
	lw s2, 0(s1)
	lw s1, -28(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	la s3, txbuf
	lw s4, -64(s0)
	la s5, rxbuf
	li s6, 8192
	mv a0, s1
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv t0, s2
	jalr ra, t0, 0
	mv s7, a0
	sw s7, -52(s0)
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L37_11
	j .L37_12
.L37_11:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -52(s0)
	mv a0, s1
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_12:
	la s1, rxbuf
	lw s2, -52(s0)
	addi s3, s0, -68
	lw s4, -36(s0)
	addi s5, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, batch_walk_reply
	mv s6, a0
	sw s6, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L37_13
	j .L37_14
.L37_13:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -44(s0)
	li s2, 6
	neg s3, s2
	xor s2, s1, s3
	seqz s2, s2
	bnez s2, .L37_15
	j .L37_16
.L37_15:
	lw s1, -16(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L37_16
	j .L37_17
.L37_17:
	lw s1, -16(s0)
	li s2, 64
	and s3, s1, s2
	bnez s3, .L37_18
	j .L37_16
.L37_18:
	lw s1, -28(s0)
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, open_create
	mv s4, a0
	mv a0, s4
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_16:
	lw s1, -44(s0)
	mv a0, s1
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_14:
	lw s1, -16(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L37_19
	j .L37_20
.L37_19:
	lw s1, -40(s0)
	li s2, 128
	and s3, s1, s2
	bnez s3, .L37_20
	j .L37_21
.L37_21:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	li s1, 12
	neg s2, s1
	mv a0, s2
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_20:
	lw s1, -16(s0)
	li s2, 65536
	and s3, s1, s2
	bnez s3, .L37_22
	j .L37_23
.L37_23:
	lw s1, -40(s0)
	li s2, 128
	and s3, s1, s2
	bnez s3, .L37_24
	j .L37_22
.L37_24:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	li s1, 13
	neg s2, s1
	mv a0, s2
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_22:
	la s1, rxbuf
	lw s2, -52(s0)
	addi s3, s0, -68
	addi s4, s0, -104
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, next_reply
	mv s5, a0
	sw s5, -48(s0)
	lw s1, -48(s0)
	li s2, 113
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L37_25
	j .L37_26
.L37_25:
	lw s1, -28(s0)
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	lw s1, -48(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L37_27
	j .L37_28
.L37_27:
	lw s1, -48(s0)
	sw s1, -108(s0)
	j .L37_29
.L37_28:
	li s1, 8
	neg s2, s1
	sw s2, -108(s0)
.L37_29:
	lw s1, -108(s0)
	mv a0, s1
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L37_26:
	lw s1, -32(s0)
	mv a0, s1
	lw s1, -156(s0)
	lw s2, -152(s0)
	lw s3, -148(s0)
	lw s4, -144(s0)
	lw s5, -140(s0)
	lw s6, -136(s0)
	lw s7, -132(s0)
	lw s8, -128(s0)
	lw s9, -124(s0)
	lw s10, -120(s0)
	lw s11, -116(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end37:
	.size nine_open, .Lfunc_end37-nine_open

	.text
	.align 2
	.type nine_read, @function
nine_read:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L38_0
	j .L38_1
.L38_0:
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
.L38_1:
	lw s1, -16(s0)
	li s2, 8192
	li s3, 32
	sub s4, s2, s3
	sltu s2, s4, s1
	bnez s2, .L38_2
	j .L38_3
.L38_2:
	li s1, 8192
	li s2, 32
	sub s3, s1, s2
	sw s3, -16(s0)
.L38_3:
	addi s1, s0, -48
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -48
	li s2, 116
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -48
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -48
	lw s2, -20(s0)
	lw s10, 0(s2)
	lw s11, 4(s2)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, wire_put_u64
	mv s2, a0
	addi s1, s0, -48
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -28(s0)
	addi s2, s0, -48
	addi s3, s0, -64
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -68(s0)
	lw s1, -68(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L38_4
	j .L38_5
.L38_4:
	lw s1, -68(s0)
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
.L38_5:
	lw s1, -68(s0)
	li s2, 117
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L38_6
	j .L38_7
.L38_6:
	li s1, 8
	neg s2, s1
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
.L38_7:
	addi s1, s0, -64
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	sw s2, -72(s0)
	addi s1, s0, -64
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L38_8
	j .L38_9
.L38_8:
	addi s1, s0, -64
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -72(s0)
	add s3, s1, s2
	addi s1, s0, -64
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L38_9
	j .L38_10
.L38_9:
	li s1, 8
	neg s2, s1
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
.L38_10:
	lw s1, -72(s0)
	lw s2, -16(s0)
	sltu s3, s2, s1
	bnez s3, .L38_11
	j .L38_12
.L38_11:
	lw s1, -16(s0)
	sw s1, -72(s0)
.L38_12:
	lw s1, -12(s0)
	addi s2, s0, -64
	lw s3, 0(s2)
	addi s2, s0, -64
	li s4, 8
	add s5, s2, s4
	lw s2, 0(s5)
	add s4, s3, s2
	lw s2, -72(s0)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, memcpy
	mv s3, a0
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s2, -72(s0)
	mv s8, s2
	li s9, 0
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, 0(s1)
	sw s7, 4(s1)
	lw s1, -72(s0)
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
.Lfunc_end38:
	.size nine_read, .Lfunc_end38-nine_read

	.text
	.align 2
	.type nine_write, @function
nine_write:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -16(s0)
	li s2, 0
	slt s3, s2, s1
	xori s3, s3, 1
	bnez s3, .L39_0
	j .L39_1
.L39_0:
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
.L39_1:
	lw s1, -16(s0)
	li s2, 8192
	li s3, 32
	sub s4, s2, s3
	sltu s2, s4, s1
	bnez s2, .L39_2
	j .L39_3
.L39_2:
	li s1, 8192
	li s2, 32
	sub s3, s1, s2
	sw s3, -16(s0)
.L39_3:
	addi s1, s0, -48
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -48
	li s2, 118
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -48
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -48
	lw s2, -20(s0)
	lw s10, 0(s2)
	lw s11, 4(s2)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, wire_put_u64
	mv s2, a0
	addi s1, s0, -48
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -48
	lw s2, -12(s0)
	lw s3, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_put_bytes
	mv s4, a0
	lw s1, -28(s0)
	addi s2, s0, -48
	addi s3, s0, -64
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -68(s0)
	lw s1, -68(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L39_4
	j .L39_5
.L39_4:
	lw s1, -68(s0)
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
.L39_5:
	lw s1, -68(s0)
	li s2, 119
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L39_6
	j .L39_7
.L39_6:
	li s1, 8
	neg s2, s1
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
.L39_7:
	addi s1, s0, -64
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	sw s2, -72(s0)
	addi s1, s0, -64
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L39_8
	j .L39_9
.L39_9:
	li s1, 8
	neg s2, s1
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
.L39_8:
	lw s1, -20(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s2, -72(s0)
	mv s8, s2
	li s9, 0
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, 0(s1)
	sw s7, 4(s1)
	lw s1, -72(s0)
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
.Lfunc_end39:
	.size nine_write, .Lfunc_end39-nine_write

	.text
	.align 2
	.type nine_lseek, @function
nine_lseek:
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
	sw a2, -16(s0)
	sw a3, -12(s0)
	sw a4, -20(s0)
	sw a5, -24(s0)
	lw s1, -4(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_0
	li s2, 1
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L40_1
	j .L40_2
.L40_0:
	lw s10, -16(s0)
	lw s11, -12(s0)
	sw s10, -32(s0)
	sw s11, -28(s0)
	j .L40_3
.L40_1:
	lw s1, -24(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	lw s8, -16(s0)
	lw s9, -12(s0)
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, -32(s0)
	sw s7, -28(s0)
	j .L40_3
.L40_2:
	li s1, 4
	neg s2, s1
	mv s10, s2
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L40_3:
	lw s10, -32(s0)
	lw s11, -28(s0)
	li s1, 0
	mv s8, s1
	srai s9, s8, 31
	slt s1, s11, s9
	bne s11, s9, .L40_4
	sltu s1, s10, s8
.L40_4:
	bnez s1, .L40_5
	j .L40_6
.L40_5:
	li s1, 4
	neg s2, s1
	mv s10, s2
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L40_6:
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s1, -24(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	lw s10, -32(s0)
	lw s11, -28(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end40:
	.size nine_lseek, .Lfunc_end40-nine_lseek

	.text
	.align 2
	.type parse_stat, @function
parse_stat:
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
	sw a2, -12(s0)
	sw a3, -16(s0)
	sw a4, -20(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	sw s2, -28(s0)
	lw s1, -4(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -28(s0)
	add s3, s1, s2
	sw s3, -32(s0)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L41_0
	j .L41_1
.L41_0:
	lw s1, -32(s0)
	lw s2, -4(s0)
	li s3, 4
	add s4, s2, s3
	lw s2, 0(s4)
	sltu s3, s2, s1
	bnez s3, .L41_1
	j .L41_2
.L41_1:
	li s1, 8
	neg s2, s1
	mv a0, s2
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
.L41_2:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	addi s2, s0, -48
	mv a0, s1
	mv a1, s2
	jal ra, p9i_qid
	mv s3, a0
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	lw s1, -16(s0)
	sw s2, 0(s1)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	mv a0, s1
	jal ra, wire_get_u64
	mv s10, a0
	mv s11, a1
	lw s1, -20(s0)
	sw s10, 0(s1)
	sw s11, 4(s1)
	lw s1, -4(s0)
	lw s2, -8(s0)
	lw s3, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_get_str
	mv s4, a0
	lw s1, -32(s0)
	lw s2, -4(s0)
	li s3, 8
	add s4, s2, s3
	sw s1, 0(s4)
	lw s1, -4(s0)
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L41_3
	j .L41_4
.L41_3:
	li s1, 0
	sw s1, -52(s0)
	j .L41_5
.L41_4:
	li s1, 8
	neg s2, s1
	sw s2, -52(s0)
.L41_5:
	lw s1, -52(s0)
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
.Lfunc_end41:
	.size parse_stat, .Lfunc_end41-parse_stat

	.text
	.align 2
	.type nine_readdir, @function
nine_readdir:
	addi sp, sp, -160
	sw ra, 156(sp)
	sw s0, 152(sp)
	addi s0, sp, 152
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
	sw s7, 32(sp)
	sw s8, 36(sp)
	sw s9, 40(sp)
	sw s10, 44(sp)
	sw s11, 48(sp)
	sw a0, -4(s0)
	sw a1, -8(s0)
	sw a2, -12(s0)
	sw a3, -16(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -20(s0)
	li s1, 512
	sw s1, -84(s0)
	addi s1, s0, -40
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -40
	li s2, 116
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -40
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -40
	lw s2, -12(s0)
	lw s10, 0(s2)
	lw s11, 4(s2)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, wire_put_u64
	mv s2, a0
	addi s1, s0, -40
	lw s2, -84(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -20(s0)
	addi s2, s0, -40
	addi s3, s0, -56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -60(s0)
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L42_0
	j .L42_1
.L42_0:
	lw s1, -60(s0)
	mv a0, s1
	lw s1, -144(s0)
	lw s2, -140(s0)
	lw s3, -136(s0)
	lw s4, -132(s0)
	lw s5, -128(s0)
	lw s6, -124(s0)
	lw s7, -120(s0)
	lw s8, -116(s0)
	lw s9, -112(s0)
	lw s10, -108(s0)
	lw s11, -104(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L42_1:
	lw s1, -60(s0)
	li s2, 117
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L42_2
	j .L42_3
.L42_2:
	li s1, 8
	neg s2, s1
	mv a0, s2
	lw s1, -144(s0)
	lw s2, -140(s0)
	lw s3, -136(s0)
	lw s4, -132(s0)
	lw s5, -128(s0)
	lw s6, -124(s0)
	lw s7, -120(s0)
	lw s8, -116(s0)
	lw s9, -112(s0)
	lw s10, -108(s0)
	lw s11, -104(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L42_3:
	addi s1, s0, -56
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	sw s2, -68(s0)
	addi s1, s0, -56
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L42_4
	j .L42_5
.L42_4:
	lw s1, -68(s0)
	li s2, 0
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L42_5
	j .L42_6
.L42_6:
	addi s1, s0, -56
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -68(s0)
	add s3, s1, s2
	addi s1, s0, -56
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	sltu s2, s1, s3
	bnez s2, .L42_5
	j .L42_7
.L42_5:
	li s1, 0
	mv a0, s1
	lw s1, -144(s0)
	lw s2, -140(s0)
	lw s3, -136(s0)
	lw s4, -132(s0)
	lw s5, -128(s0)
	lw s6, -124(s0)
	lw s7, -120(s0)
	lw s8, -116(s0)
	lw s9, -112(s0)
	lw s10, -108(s0)
	lw s11, -104(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L42_7:
	addi s1, s0, -56
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -88(s0)
	addi s1, s0, -56
	lw s2, -16(s0)
	li s3, 8
	add s4, s2, s3
	li s2, 56
	addi s3, s0, -72
	addi s5, s0, -80
	mv a0, s1
	mv a1, s4
	mv a2, s2
	mv a3, s3
	mv a4, s5
	jal ra, parse_stat
	mv t0, a0
	sw t0, -100(s0)
	lw t0, -100(s0)
	sw t0, -64(s0)
	lw s1, -64(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L42_8
	j .L42_9
.L42_8:
	lw s1, -64(s0)
	mv a0, s1
	lw s1, -144(s0)
	lw s2, -140(s0)
	lw s3, -136(s0)
	lw s4, -132(s0)
	lw s5, -128(s0)
	lw s6, -124(s0)
	lw s7, -120(s0)
	lw s8, -116(s0)
	lw s9, -112(s0)
	lw s10, -108(s0)
	lw s11, -104(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L42_9:
	lw s1, -72(s0)
	li s2, 2147483648
	and s3, s1, s2
	bnez s3, .L42_10
	j .L42_11
.L42_10:
	li s1, 2
	sw s1, -92(s0)
	j .L42_12
.L42_11:
	li s1, 1
	sw s1, -92(s0)
.L42_12:
	lw s1, -92(s0)
	lw s2, -16(s0)
	li s3, 4
	add s4, s2, s3
	sb s1, 0(s4)
	li s1, 0
	lw s2, -16(s0)
	sw s1, 0(s2)
	li s1, 0
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 2
	add s3, s4, s2
	sb s1, 0(s3)
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 1
	add s3, s4, s2
	sb s1, 0(s3)
	lw s2, -16(s0)
	li s3, 5
	add s4, s2, s3
	li s2, 0
	add s3, s4, s2
	sb s1, 0(s3)
	lw s1, -12(s0)
	lw s10, 0(s1)
	lw s11, 4(s1)
	addi s2, s0, -56
	li s3, 8
	add s4, s2, s3
	lw s2, 0(s4)
	lw s3, -88(s0)
	sub s4, s2, s3
	mv s8, s4
	li s9, 0
	add s6, s10, s8
	sltu t0, s6, s8
	add s7, s11, t0
	add s7, s7, s9
	sw s6, 0(s1)
	sw s7, 4(s1)
	li s1, 1
	mv a0, s1
	lw s1, -144(s0)
	lw s2, -140(s0)
	lw s3, -136(s0)
	lw s4, -132(s0)
	lw s5, -128(s0)
	lw s6, -124(s0)
	lw s7, -120(s0)
	lw s8, -116(s0)
	lw s9, -112(s0)
	lw s10, -108(s0)
	lw s11, -104(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end42:
	.size nine_readdir, .Lfunc_end42-nine_readdir

	.text
	.align 2
	.type nine_close, @function
nine_close:
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
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	lw s1, -8(s0)
	mv a0, s2
	mv a1, s1
	jal ra, p9_clunk
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
.Lfunc_end43:
	.size nine_close, .Lfunc_end43-nine_close

	.text
	.align 2
	.type stat_rel, @function
stat_rel:
	addi sp, sp, -208
	sw ra, 204(sp)
	sw s0, 200(sp)
	addi s0, sp, 200
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
	sw s1, -128(s0)
	li s1, 0
	sw s1, -132(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, split_count
	mv s2, a0
	sw s2, -112(s0)
	lw s1, -112(s0)
	li s2, 16
	slt s3, s2, s1
	bnez s3, .L44_0
	j .L44_1
.L44_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk_rel
	mv s4, a0
	sw s4, -108(s0)
	lw s1, -108(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L44_2
	j .L44_3
.L44_2:
	lw s1, -108(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_3:
	addi s1, s0, -32
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -32
	li s2, 124
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -32
	lw s2, -108(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -4(s0)
	addi s2, s0, -32
	addi s3, s0, -48
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -116(s0)
	lw s1, -116(s0)
	li s2, 125
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L44_4
	j .L44_5
.L44_4:
	lw s1, -4(s0)
	lw s2, -108(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	lw s1, -116(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L44_6
	j .L44_7
.L44_6:
	lw s1, -116(s0)
	sw s1, -136(s0)
	j .L44_8
.L44_7:
	li s1, 8
	neg s2, s1
	sw s2, -136(s0)
.L44_8:
	lw s1, -136(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_5:
	addi s1, s0, -48
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -48
	addi s2, s0, -104
	li s3, 56
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, parse_stat
	mv s6, a0
	sw s6, -120(s0)
	lw s1, -4(s0)
	lw s2, -108(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	lw s1, -120(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, fid_alloc
	mv s2, a0
	sw s2, -108(s0)
	lw s1, -108(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L44_9
	j .L44_10
.L44_9:
	lw s1, -108(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_10:
	la s1, txbuf
	li s2, 8192
	addi s3, s0, -128
	li s4, 0
	lw s5, -108(s0)
	lw s6, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, batch_walk
	mv s7, a0
	li s1, 0
	slt s2, s7, s1
	bnez s2, .L44_11
	j .L44_12
.L44_12:
	la s1, txbuf
	li s2, 8192
	addi s3, s0, -128
	li s4, 124
	lw s5, -108(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, batch_fid_msg
	mv s6, a0
	li s1, 0
	slt s2, s6, s1
	bnez s2, .L44_11
	j .L44_13
.L44_13:
	la s1, txbuf
	li s2, 8192
	addi s3, s0, -128
	li s4, 120
	lw s5, -108(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, batch_fid_msg
	mv s6, a0
	li s1, 0
	slt s2, s6, s1
	bnez s2, .L44_11
	j .L44_14
.L44_11:
	lw s1, -4(s0)
	lw s2, -108(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_14:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	la s3, txbuf
	lw s4, -128(s0)
	la s5, rxbuf
	li s6, 8192
	mv a0, s1
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv t0, s2
	jalr ra, t0, 0
	mv s7, a0
	sw s7, -124(s0)
	lw s1, -4(s0)
	lw s2, -108(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -124(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L44_15
	j .L44_16
.L44_15:
	lw s1, -124(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_16:
	la s1, rxbuf
	lw s2, -124(s0)
	addi s3, s0, -132
	lw s4, -112(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, batch_walk_reply
	mv s6, a0
	sw s6, -120(s0)
	lw s1, -120(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L44_17
	j .L44_18
.L44_17:
	lw s1, -120(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_18:
	la s1, rxbuf
	lw s2, -124(s0)
	addi s3, s0, -132
	addi s4, s0, -48
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, next_reply
	mv s5, a0
	sw s5, -116(s0)
	lw s1, -116(s0)
	li s2, 125
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L44_19
	j .L44_20
.L44_19:
	lw s1, -116(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L44_21
	j .L44_22
.L44_21:
	lw s1, -116(s0)
	sw s1, -140(s0)
	j .L44_23
.L44_22:
	li s1, 8
	neg s2, s1
	sw s2, -140(s0)
.L44_23:
	lw s1, -140(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L44_20:
	addi s1, s0, -48
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -48
	addi s2, s0, -104
	li s3, 56
	lw s4, -12(s0)
	lw s5, -16(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, parse_stat
	mv s6, a0
	mv a0, s6
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end44:
	.size stat_rel, .Lfunc_end44-stat_rel

	.text
	.align 2
	.type nine_exists, @function
nine_exists:
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
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	lw s1, -12(s0)
	addi s3, s0, -20
	addi s4, s0, -32
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, stat_rel
	mv s5, a0
	li s1, 0
	xor s2, s5, s1
	seqz s2, s2
	bnez s2, .L45_0
	j .L45_1
.L45_0:
	li s1, 1
	sw s1, -36(s0)
	j .L45_2
.L45_1:
	li s1, 0
	sw s1, -36(s0)
.L45_2:
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
.Lfunc_end45:
	.size nine_exists, .Lfunc_end45-nine_exists

	.text
	.align 2
	.type nine_size, @function
nine_size:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	lw s1, -12(s0)
	addi s3, s0, -20
	addi s4, s0, -32
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, stat_rel
	mv s5, a0
	sw s5, -36(s0)
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L46_0
	j .L46_1
.L46_0:
	lw s1, -36(s0)
	mv s10, s1
	srai s11, s10, 31
	mv a0, s10
	mv a1, s11
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
.L46_1:
	lw s1, -20(s0)
	li s2, 2147483648
	and s3, s1, s2
	bnez s3, .L46_2
	j .L46_3
.L46_2:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -48(s0)
	sw s11, -44(s0)
	j .L46_4
.L46_3:
	lw s10, -32(s0)
	lw s11, -28(s0)
	sw s10, -48(s0)
	sw s11, -44(s0)
.L46_4:
	lw s10, -48(s0)
	lw s11, -44(s0)
	mv a0, s10
	mv a1, s11
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
.Lfunc_end46:
	.size nine_size, .Lfunc_end46-nine_size

	.text
	.align 2
	.type nine_isdir, @function
nine_isdir:
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
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	lw s1, -12(s0)
	addi s3, s0, -20
	addi s4, s0, -32
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, stat_rel
	mv s5, a0
	li s1, 0
	slt s2, s5, s1
	bnez s2, .L47_0
	j .L47_1
.L47_0:
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
.L47_1:
	lw s1, -20(s0)
	li s2, 2147483648
	and s3, s1, s2
	bnez s3, .L47_2
	j .L47_3
.L47_2:
	li s1, 1
	sw s1, -36(s0)
	j .L47_4
.L47_3:
	li s1, 0
	sw s1, -36(s0)
.L47_4:
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
.Lfunc_end47:
	.size nine_isdir, .Lfunc_end47-nine_isdir

	.text
	.align 2
	.type fill_stat, @function
fill_stat:
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
	sw a1, -16(s0)
	sw a2, -12(s0)
	sw a3, -20(s0)
	lw s1, -4(s0)
	li s2, 2147483648
	and s3, s1, s2
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	sw s2, -28(s0)
	li s1, 14704
	lw s2, -20(s0)
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s2)
	sw s11, 4(s2)
	li s1, 0
	lw s2, -20(s0)
	li s3, 8
	add s4, s2, s3
	mv s10, s1
	srai s11, s10, 31
	sw s10, 0(s4)
	sw s11, 4(s4)
	lw s1, -28(s0)
	bnez s1, .L48_0
	j .L48_1
.L48_0:
	li s1, 0
	mv s10, s1
	srai s11, s10, 31
	sw s10, -40(s0)
	sw s11, -36(s0)
	j .L48_2
.L48_1:
	lw s10, -16(s0)
	lw s11, -12(s0)
	sw s10, -40(s0)
	sw s11, -36(s0)
.L48_2:
	lw s10, -40(s0)
	lw s11, -36(s0)
	lw s1, -20(s0)
	li s2, 16
	add s3, s1, s2
	sw s10, 0(s3)
	sw s11, 4(s3)
	lw s1, -28(s0)
	bnez s1, .L48_3
	j .L48_4
.L48_3:
	li s1, 16384
	sw s1, -44(s0)
	j .L48_5
.L48_4:
	li s1, 32768
	sw s1, -44(s0)
.L48_5:
	lw s1, -44(s0)
	lw s2, -4(s0)
	li s3, 511
	and s4, s2, s3
	or s2, s1, s4
	lw s1, -20(s0)
	li s3, 24
	add s4, s1, s3
	sw s2, 0(s4)
	li s1, 1
	lw s2, -20(s0)
	li s3, 28
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
.Lfunc_end48:
	.size fill_stat, .Lfunc_end48-fill_stat

	.text
	.align 2
	.type nine_stat, @function
nine_stat:
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
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	lw s1, -12(s0)
	addi s3, s0, -20
	addi s4, s0, -32
	mv a0, s2
	mv a1, s1
	mv a2, s3
	mv a3, s4
	jal ra, stat_rel
	mv s5, a0
	sw s5, -36(s0)
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -36(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L49_0
	j .L49_1
.L49_0:
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
.L49_1:
	lw s1, -20(s0)
	lw s10, -32(s0)
	lw s11, -28(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	jal ra, fill_stat
	mv s3, a0
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
.Lfunc_end49:
	.size nine_stat, .Lfunc_end49-nine_stat

	.text
	.align 2
	.type nine_fstat, @function
nine_fstat:
	addi sp, sp, -208
	sw ra, 204(sp)
	sw s0, 200(sp)
	addi s0, sp, 200
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
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -12(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -40
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -40
	li s2, 124
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -40
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -20(s0)
	addi s2, s0, -40
	addi s3, s0, -56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -60(s0)
	lw s1, -60(s0)
	li s2, 125
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L50_0
	j .L50_1
.L50_0:
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L50_2
	j .L50_3
.L50_2:
	lw s1, -60(s0)
	sw s1, -140(s0)
	j .L50_4
.L50_3:
	li s1, 8
	neg s2, s1
	sw s2, -140(s0)
.L50_4:
	lw s1, -140(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L50_1:
	addi s1, s0, -56
	mv a0, s1
	jal ra, wire_get_u16
	mv s2, a0
	li s1, 24
	sll s3, s2, s1
	li s1, 24
	sra s2, s3, s1
	addi s1, s0, -56
	addi s2, s0, -136
	li s3, 56
	addi s4, s0, -68
	addi s5, s0, -80
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, parse_stat
	mv s6, a0
	sw s6, -64(s0)
	lw s1, -64(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L50_5
	j .L50_6
.L50_5:
	lw s1, -64(s0)
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L50_6:
	lw s1, -68(s0)
	lw s10, -80(s0)
	lw s11, -76(s0)
	lw s2, -16(s0)
	mv a0, s1
	mv a1, s10
	mv a2, s11
	mv a3, s2
	jal ra, fill_stat
	mv s3, a0
	li s1, 0
	mv a0, s1
	lw s1, -188(s0)
	lw s2, -184(s0)
	lw s3, -180(s0)
	lw s4, -176(s0)
	lw s5, -172(s0)
	lw s6, -168(s0)
	lw s7, -164(s0)
	lw s8, -160(s0)
	lw s9, -156(s0)
	lw s10, -152(s0)
	lw s11, -148(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end50:
	.size nine_fstat, .Lfunc_end50-nine_fstat

	.text
	.align 2
	.type remove_rel, @function
remove_rel:
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
	sw a1, -8(s0)
	li s1, 0
	sw s1, -64(s0)
	li s1, 0
	sw s1, -68(s0)
	lw s1, -8(s0)
	mv a0, s1
	jal ra, split_count
	mv s2, a0
	sw s2, -48(s0)
	lw s1, -48(s0)
	li s2, 16
	slt s3, s2, s1
	bnez s3, .L51_0
	j .L51_1
.L51_0:
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk_rel
	mv s4, a0
	sw s4, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L51_2
	j .L51_3
.L51_2:
	lw s1, -44(s0)
	mv a0, s1
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
.L51_3:
	addi s1, s0, -24
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -24
	li s2, 122
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -24
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	lw s1, -4(s0)
	addi s2, s0, -24
	addi s3, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -52(s0)
	lw s1, -4(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -52(s0)
	li s2, 123
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L51_4
	j .L51_5
.L51_4:
	li s1, 0
	sw s1, -72(s0)
	j .L51_6
.L51_5:
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L51_7
	j .L51_8
.L51_7:
	lw s1, -52(s0)
	sw s1, -76(s0)
	j .L51_9
.L51_8:
	li s1, 9
	neg s2, s1
	sw s2, -76(s0)
.L51_9:
	lw s1, -76(s0)
	sw s1, -72(s0)
.L51_6:
	lw s1, -72(s0)
	mv a0, s1
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
.L51_1:
	lw s1, -4(s0)
	mv a0, s1
	jal ra, fid_alloc
	mv s2, a0
	sw s2, -44(s0)
	lw s1, -44(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L51_10
	j .L51_11
.L51_10:
	lw s1, -44(s0)
	mv a0, s1
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
.L51_11:
	la s1, txbuf
	li s2, 8192
	addi s3, s0, -64
	li s4, 0
	lw s5, -44(s0)
	lw s6, -8(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, batch_walk
	mv s7, a0
	li s1, 0
	slt s2, s7, s1
	bnez s2, .L51_12
	j .L51_13
.L51_13:
	la s1, txbuf
	li s2, 8192
	addi s3, s0, -64
	li s4, 122
	lw s5, -44(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, batch_fid_msg
	mv s6, a0
	li s1, 0
	slt s2, s6, s1
	bnez s2, .L51_12
	j .L51_14
.L51_12:
	lw s1, -4(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	li s1, 4
	neg s2, s1
	mv a0, s2
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
.L51_14:
	lw s1, -4(s0)
	lw s2, 0(s1)
	lw s1, -4(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	la s3, txbuf
	lw s4, -64(s0)
	la s5, rxbuf
	li s6, 8192
	mv a0, s1
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv t0, s2
	jalr ra, t0, 0
	mv s7, a0
	sw s7, -60(s0)
	lw s1, -4(s0)
	lw s2, -44(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -60(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L51_15
	j .L51_16
.L51_15:
	lw s1, -60(s0)
	mv a0, s1
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
.L51_16:
	la s1, rxbuf
	lw s2, -60(s0)
	addi s3, s0, -68
	lw s4, -48(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, batch_walk_reply
	mv s6, a0
	sw s6, -56(s0)
	lw s1, -56(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L51_17
	j .L51_18
.L51_17:
	lw s1, -56(s0)
	mv a0, s1
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
.L51_18:
	la s1, rxbuf
	lw s2, -60(s0)
	addi s3, s0, -68
	addi s4, s0, -40
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, next_reply
	mv s5, a0
	sw s5, -52(s0)
	lw s1, -52(s0)
	li s2, 123
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L51_19
	j .L51_20
.L51_19:
	li s1, 0
	sw s1, -80(s0)
	j .L51_21
.L51_20:
	lw s1, -52(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L51_22
	j .L51_23
.L51_22:
	lw s1, -52(s0)
	sw s1, -84(s0)
	j .L51_24
.L51_23:
	li s1, 9
	neg s2, s1
	sw s2, -84(s0)
.L51_24:
	lw s1, -84(s0)
	sw s1, -80(s0)
.L51_21:
	lw s1, -80(s0)
	mv a0, s1
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
.Lfunc_end51:
	.size remove_rel, .Lfunc_end51-remove_rel

	.text
	.align 2
	.type nine_unlink, @function
nine_unlink:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	lw s2, -12(s0)
	addi s3, s0, -24
	addi s4, s0, -32
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, stat_rel
	mv s5, a0
	li s1, 0
	slt s2, s5, s1
	bnez s2, .L52_0
	j .L52_1
.L52_0:
	li s1, 6
	neg s2, s1
	mv a0, s2
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
.L52_1:
	lw s1, -24(s0)
	li s2, 2147483648
	and s3, s1, s2
	bnez s3, .L52_2
	j .L52_3
.L52_2:
	li s1, 13
	neg s2, s1
	mv a0, s2
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
.L52_3:
	lw s1, -20(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, remove_rel
	mv s3, a0
	mv a0, s3
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
.Lfunc_end52:
	.size nine_unlink, .Lfunc_end52-nine_unlink

	.text
	.align 2
	.type nine_rmdir, @function
nine_rmdir:
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
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -20(s0)
	lw s2, -12(s0)
	addi s3, s0, -24
	addi s4, s0, -32
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, stat_rel
	mv s5, a0
	li s1, 0
	slt s2, s5, s1
	bnez s2, .L53_0
	j .L53_1
.L53_0:
	li s1, 6
	neg s2, s1
	mv a0, s2
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
.L53_1:
	lw s1, -24(s0)
	li s2, 2147483648
	and s3, s1, s2
	bnez s3, .L53_2
	j .L53_3
.L53_3:
	li s1, 12
	neg s2, s1
	mv a0, s2
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
.L53_2:
	lw s1, -20(s0)
	lw s2, -12(s0)
	mv a0, s1
	mv a1, s2
	jal ra, remove_rel
	mv s3, a0
	mv a0, s3
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
.Lfunc_end53:
	.size nine_rmdir, .Lfunc_end53-nine_rmdir

	.text
	.align 2
	.type nine_mkdir, @function
nine_mkdir:
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
	sw a1, -8(s0)
	sw a2, -12(s0)
	lw s1, -4(s0)
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -20(s0)
	li s1, 0
	sw s1, -392(s0)
	li s1, 0
	sw s1, -396(s0)
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	addi s2, s0, -280
	li s3, 256
	addi s4, s0, -336
	li s5, 56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, split_last
	mv s6, a0
	li s1, 0
	slt s2, s1, s6
	xori s2, s2, 1
	bnez s2, .L54_0
	j .L54_1
.L54_0:
	li s1, 4
	neg s2, s1
	mv a0, s2
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
.L54_1:
	addi s1, s0, -280
	mv a0, s1
	jal ra, split_count
	mv s2, a0
	sw s2, -376(s0)
	lw s1, -376(s0)
	li s2, 16
	slt s3, s2, s1
	bnez s3, .L54_2
	j .L54_3
.L54_2:
	lw s1, -20(s0)
	addi s2, s0, -280
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk_rel
	mv s4, a0
	sw s4, -372(s0)
	lw s1, -372(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L54_4
	j .L54_5
.L54_4:
	lw s1, -372(s0)
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
.L54_5:
	lw s1, -20(s0)
	lw s2, -372(s0)
	addi s3, s0, -336
	li s4, 2147483648
	li s5, 493
	or s6, s4, s5
	li s4, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s6
	mv a4, s4
	jal ra, do_create
	mv s5, a0
	sw s5, -384(s0)
	lw s1, -20(s0)
	lw s2, -372(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	lw s1, -384(s0)
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
.L54_3:
	lw s1, -20(s0)
	mv a0, s1
	jal ra, fid_alloc
	mv s2, a0
	sw s2, -372(s0)
	lw s1, -372(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L54_6
	j .L54_7
.L54_6:
	lw s1, -372(s0)
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
.L54_7:
	la s1, txbuf
	li s2, 8192
	addi s3, s0, -392
	li s4, 0
	lw s5, -372(s0)
	addi s6, s0, -280
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	mv a5, s6
	jal ra, batch_walk
	mv s7, a0
	li s1, 0
	slt s2, s7, s1
	bnez s2, .L54_8
	j .L54_9
.L54_8:
	lw s1, -20(s0)
	lw s2, -372(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	li s1, 4
	neg s2, s1
	mv a0, s2
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
.L54_9:
	addi s1, s0, -352
	la s2, txbuf
	lw s3, -392(s0)
	add s4, s2, s3
	li s2, 8192
	lw s3, -392(s0)
	sub s5, s2, s3
	mv a0, s1
	mv a1, s4
	mv a2, s5
	jal ra, wire_out_init
	mv s2, a0
	addi s1, s0, -352
	li s2, 114
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -352
	lw s2, -372(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -352
	addi s2, s0, -336
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -352
	li s2, 2147483648
	li s3, 493
	or s4, s2, s3
	mv a0, s1
	mv a1, s4
	jal ra, wire_put_u32
	mv s2, a0
	addi s1, s0, -352
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u8
	mv s3, a0
	addi s1, s0, -352
	mv a0, s1
	jal ra, p9o_finish
	mv s2, a0
	sw s2, -400(s0)
	lw s1, -400(s0)
	bnez s1, .L54_10
	j .L54_11
.L54_11:
	lw s1, -20(s0)
	lw s2, -372(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	li s1, 4
	neg s2, s1
	mv a0, s2
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
.L54_10:
	addi s1, s0, -392
	lw s2, 0(s1)
	lw s1, -400(s0)
	add s3, s2, s1
	sw s3, -392(s0)
	la s1, txbuf
	li s2, 8192
	addi s3, s0, -392
	li s4, 120
	lw s5, -372(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, batch_fid_msg
	mv s6, a0
	li s1, 0
	slt s2, s6, s1
	bnez s2, .L54_12
	j .L54_13
.L54_12:
	lw s1, -20(s0)
	lw s2, -372(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	li s1, 4
	neg s2, s1
	mv a0, s2
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
.L54_13:
	lw s1, -20(s0)
	lw s2, 0(s1)
	lw s1, -20(s0)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	la s3, txbuf
	lw s4, -392(s0)
	la s5, rxbuf
	li s6, 8192
	mv a0, s1
	mv a1, s3
	mv a2, s4
	mv a3, s5
	mv a4, s6
	mv t0, s2
	jalr ra, t0, 0
	mv s7, a0
	sw s7, -388(s0)
	lw s1, -20(s0)
	lw s2, -372(s0)
	mv a0, s1
	mv a1, s2
	jal ra, fid_free
	mv s3, a0
	lw s1, -388(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L54_14
	j .L54_15
.L54_14:
	lw s1, -388(s0)
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
.L54_15:
	la s1, rxbuf
	lw s2, -388(s0)
	addi s3, s0, -396
	lw s4, -376(s0)
	li s5, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, batch_walk_reply
	mv s6, a0
	sw s6, -384(s0)
	lw s1, -384(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L54_16
	j .L54_17
.L54_16:
	lw s1, -384(s0)
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
.L54_17:
	la s1, rxbuf
	lw s2, -388(s0)
	addi s3, s0, -396
	addi s4, s0, -368
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, next_reply
	mv s5, a0
	sw s5, -380(s0)
	lw s1, -380(s0)
	li s2, 115
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L54_18
	j .L54_19
.L54_18:
	li s1, 0
	sw s1, -404(s0)
	j .L54_20
.L54_19:
	lw s1, -380(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L54_21
	j .L54_22
.L54_21:
	lw s1, -380(s0)
	sw s1, -408(s0)
	j .L54_23
.L54_22:
	li s1, 9
	neg s2, s1
	sw s2, -408(s0)
.L54_23:
	lw s1, -408(s0)
	sw s1, -404(s0)
.L54_20:
	lw s1, -404(s0)
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
.Lfunc_end54:
	.size nine_mkdir, .Lfunc_end54-nine_mkdir

	.text
	.align 2
	.type nine_rename, @function
nine_rename:
	addi sp, sp, -768
	sw ra, 764(sp)
	sw s0, 760(sp)
	addi s0, sp, 760
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
	mv a0, s1
	jal ra, nm_of
	mv s2, a0
	sw s2, -20(s0)
	lw s1, -8(s0)
	li s2, 24
	sll s3, s1, s2
	li s1, 24
	sra s2, s3, s1
	lw s1, -12(s0)
	addi s2, s0, -280
	li s3, 256
	addi s4, s0, -336
	li s5, 56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, split_last
	mv s6, a0
	lw s1, -16(s0)
	addi s2, s0, -592
	li s3, 256
	addi s4, s0, -648
	li s5, 56
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	mv a4, s5
	jal ra, split_last
	mv s6, a0
	li s1, 0
	slt s2, s1, s6
	xori s2, s2, 1
	bnez s2, .L55_0
	j .L55_1
.L55_0:
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -748(s0)
	lw s2, -744(s0)
	lw s3, -740(s0)
	lw s4, -736(s0)
	lw s5, -732(s0)
	lw s6, -728(s0)
	lw s7, -724(s0)
	lw s8, -720(s0)
	lw s9, -716(s0)
	lw s10, -712(s0)
	lw s11, -708(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L55_1:
	addi s1, s0, -280
	addi s2, s0, -592
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L55_2
	j .L55_3
.L55_2:
	li s1, 17
	neg s2, s1
	mv a0, s2
	lw s1, -748(s0)
	lw s2, -744(s0)
	lw s3, -740(s0)
	lw s4, -736(s0)
	lw s5, -732(s0)
	lw s6, -728(s0)
	lw s7, -724(s0)
	lw s8, -720(s0)
	lw s9, -716(s0)
	lw s10, -712(s0)
	lw s11, -708(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L55_3:
	lw s1, -20(s0)
	lw s2, -12(s0)
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, walk_rel
	mv s4, a0
	sw s4, -684(s0)
	lw s1, -684(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L55_4
	j .L55_5
.L55_4:
	lw s1, -684(s0)
	mv a0, s1
	lw s1, -748(s0)
	lw s2, -744(s0)
	lw s3, -740(s0)
	lw s4, -736(s0)
	lw s5, -732(s0)
	lw s6, -728(s0)
	lw s7, -724(s0)
	lw s8, -720(s0)
	lw s9, -716(s0)
	lw s10, -712(s0)
	lw s11, -708(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L55_5:
	addi s1, s0, -664
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -664
	li s2, 126
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -664
	lw s2, -684(s0)
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -664
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -696(s0)
	addi s1, s0, -664
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u16
	mv s3, a0
	addi s1, s0, -664
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u16
	mv s3, a0
	addi s1, s0, -664
	li s2, 65535
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u16
	mv s3, a0
	addi s1, s0, -664
	li s2, 4294967295
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -664
	li s2, 255
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u8
	mv s3, a0
	addi s1, s0, -664
	li s2, 4294967295
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -664
	li s10, -1
	li s11, -1
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, wire_put_u64
	mv s2, a0
	addi s1, s0, -664
	li s2, 4294967295
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -664
	li s2, 4294967295
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -664
	li s2, 4294967295
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -664
	li s10, -1
	li s11, -1
	mv a0, s1
	mv a1, s10
	mv a2, s11
	jal ra, wire_put_u64
	mv s2, a0
	addi s1, s0, -664
	addi s2, s0, -648
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -664
	la s2, __str_1
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -664
	la s2, __str_2
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -664
	la s2, __str_3
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -664
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L55_6
	j .L55_7
.L55_7:
	lw s1, -20(s0)
	lw s2, -684(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	li s1, 4
	neg s2, s1
	mv a0, s2
	lw s1, -748(s0)
	lw s2, -744(s0)
	lw s3, -740(s0)
	lw s4, -736(s0)
	lw s5, -732(s0)
	lw s6, -728(s0)
	lw s7, -724(s0)
	lw s8, -720(s0)
	lw s9, -716(s0)
	lw s10, -712(s0)
	lw s11, -708(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.L55_6:
	addi s1, s0, -664
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -696(s0)
	li s3, 2
	add s4, s2, s3
	sub s2, s1, s4
	sw s2, -692(s0)
	addi s1, s0, -664
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -696(s0)
	sub s3, s1, s2
	li s1, 2
	sub s2, s3, s1
	li s1, 255
	and s3, s2, s1
	li s1, 255
	and s2, s3, s1
	addi s1, s0, -664
	lw s3, 0(s1)
	lw s1, -696(s0)
	add s4, s3, s1
	sb s2, 0(s4)
	addi s1, s0, -664
	li s2, 8
	add s3, s1, s2
	lw s1, 0(s3)
	lw s2, -696(s0)
	sub s3, s1, s2
	li s1, 2
	sub s2, s3, s1
	li s1, 8
	srl s3, s2, s1
	li s1, 255
	and s2, s3, s1
	li s1, 255
	and s3, s2, s1
	addi s1, s0, -664
	lw s2, 0(s1)
	lw s1, -696(s0)
	li s4, 1
	add s5, s1, s4
	add s1, s2, s5
	sb s3, 0(s1)
	lw s1, -692(s0)
	li s2, 2
	sub s3, s1, s2
	li s1, 255
	and s2, s3, s1
	li s1, 255
	and s3, s2, s1
	addi s1, s0, -664
	lw s2, 0(s1)
	lw s1, -696(s0)
	li s4, 2
	add s5, s1, s4
	add s1, s2, s5
	sb s3, 0(s1)
	lw s1, -692(s0)
	li s2, 2
	sub s3, s1, s2
	li s1, 8
	srl s2, s3, s1
	li s1, 255
	and s3, s2, s1
	li s1, 255
	and s2, s3, s1
	addi s1, s0, -664
	lw s3, 0(s1)
	lw s1, -696(s0)
	li s4, 3
	add s5, s1, s4
	add s1, s3, s5
	sb s2, 0(s1)
	lw s1, -20(s0)
	addi s2, s0, -664
	addi s3, s0, -680
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -688(s0)
	lw s1, -20(s0)
	lw s2, -684(s0)
	mv a0, s1
	mv a1, s2
	jal ra, p9_clunk
	mv s3, a0
	lw s1, -688(s0)
	li s2, 127
	xor s3, s1, s2
	seqz s3, s3
	bnez s3, .L55_8
	j .L55_9
.L55_8:
	li s1, 0
	sw s1, -700(s0)
	j .L55_10
.L55_9:
	lw s1, -688(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L55_11
	j .L55_12
.L55_11:
	lw s1, -688(s0)
	sw s1, -704(s0)
	j .L55_13
.L55_12:
	li s1, 9
	neg s2, s1
	sw s2, -704(s0)
.L55_13:
	lw s1, -704(s0)
	sw s1, -700(s0)
.L55_10:
	lw s1, -700(s0)
	mv a0, s1
	lw s1, -748(s0)
	lw s2, -744(s0)
	lw s3, -740(s0)
	lw s4, -736(s0)
	lw s5, -732(s0)
	lw s6, -728(s0)
	lw s7, -724(s0)
	lw s8, -720(s0)
	lw s9, -716(s0)
	lw s10, -712(s0)
	lw s11, -708(s0)
	lw ra, 4(s0)
	lw t0, 0(s0)
	addi sp, s0, 8
	mv s0, t0
	ret
.Lfunc_end55:
	.size nine_rename, .Lfunc_end55-nine_rename

	.text
	.align 2
	.type p9_handshake, @function
p9_handshake:
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
	addi s2, s0, -16
	lw s3, 0(s1)
	sw s3, 0(s2)
	li s3, 4
	add s4, s1, s3
	lw s1, 0(s4)
	li s3, 4
	add s4, s2, s3
	sw s1, 0(s4)
	addi s1, s0, -32
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -32
	li s2, 100
	li s3, 65535
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -32
	li s2, 8192
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -32
	la s2, __str_4
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -16
	addi s2, s0, -32
	addi s3, s0, -48
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -68(s0)
	lw s1, -68(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L56_0
	j .L56_1
.L56_0:
	lw s1, -68(s0)
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
.L56_1:
	lw s1, -68(s0)
	li s2, 101
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L56_2
	j .L56_3
.L56_2:
	li s1, 22
	neg s2, s1
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
.L56_3:
	addi s1, s0, -48
	mv a0, s1
	jal ra, wire_get_u32
	mv s2, a0
	sw s2, -72(s0)
	addi s1, s0, -48
	addi s2, s0, -64
	li s3, 16
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_get_str
	mv s4, a0
	addi s1, s0, -48
	li s2, 12
	add s3, s1, s2
	lw s1, 0(s3)
	bnez s1, .L56_4
	j .L56_5
.L56_4:
	lw s1, -72(s0)
	li s2, 256
	sltu s3, s1, s2
	bnez s3, .L56_5
	j .L56_6
.L56_6:
	addi s1, s0, -64
	la s2, __str_5
	mv a0, s1
	mv a1, s2
	jal ra, strcmp
	mv s3, a0
	li s1, 0
	xor s2, s3, s1
	snez s2, s2
	bnez s2, .L56_5
	j .L56_7
.L56_5:
	li s1, 22
	neg s2, s1
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
.L56_7:
	addi s1, s0, -32
	la s2, txbuf
	li s3, 8192
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, wire_out_init
	mv s4, a0
	addi s1, s0, -32
	li s2, 104
	li s3, 0
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9o_hdr
	mv s4, a0
	addi s1, s0, -32
	li s2, 0
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -32
	li s2, 4294967295
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_u32
	mv s3, a0
	addi s1, s0, -32
	la s2, __str_6
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -32
	la s2, __str_7
	mv a0, s1
	mv a1, s2
	jal ra, wire_put_str
	mv s3, a0
	addi s1, s0, -16
	addi s2, s0, -32
	addi s3, s0, -48
	mv a0, s1
	mv a1, s2
	mv a2, s3
	jal ra, p9_txn
	mv s4, a0
	sw s4, -68(s0)
	lw s1, -68(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L56_8
	j .L56_9
.L56_8:
	lw s1, -68(s0)
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
.L56_9:
	lw s1, -68(s0)
	li s2, 105
	xor s3, s1, s2
	snez s3, s3
	bnez s3, .L56_10
	j .L56_11
.L56_10:
	li s1, 22
	neg s2, s1
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
.L56_11:
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
.Lfunc_end56:
	.size p9_handshake, .Lfunc_end56-p9_handshake

	.text
	.align 2
	.type bind_mount, @function
bind_mount:
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
	la s2, mounts
	lw s3, -4(s0)
	li s4, 16
	mul s5, s3, s4
	add s3, s2, s5
	lw s2, 0(s1)
	sw s2, 0(s3)
	li s2, 4
	add s4, s1, s2
	lw s1, 0(s4)
	li s2, 4
	add s4, s3, s2
	sw s1, 0(s4)
	li s1, 1
	mv s10, s1
	srai s11, s10, 31
	la s1, mounts
	lw s2, -4(s0)
	li s3, 16
	mul s4, s2, s3
	add s2, s1, s4
	li s1, 8
	add s3, s2, s1
	sw s10, 0(s3)
	sw s11, 4(s3)
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
.Lfunc_end57:
	.size bind_mount, .Lfunc_end57-bind_mount

	.text
	.align 2
	.globl ninefs_mount
	.type ninefs_mount, @function
ninefs_mount:
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
	mv a0, s1
	jal ra, p9_handshake
	mv s2, a0
	sw s2, -24(s0)
	lw s1, -24(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L58_0
	j .L58_1
.L58_0:
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
.L58_1:
	lw s1, -4(s0)
	li s2, 4
	li s3, 0
	lw s4, -12(s0)
	mv a0, s1
	mv a1, s2
	mv a2, s3
	mv a3, s4
	jal ra, fs_install_mount
	mv s5, a0
	sw s5, -20(s0)
	lw s1, -20(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L58_2
	j .L58_3
.L58_2:
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
.L58_3:
	lw s1, -20(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, bind_mount
	mv s3, a0
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
.Lfunc_end58:
	.size ninefs_mount, .Lfunc_end58-ninefs_mount

	.text
	.align 2
	.globl ninefs_adopt
	.type ninefs_adopt, @function
ninefs_adopt:
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
	jal ra, p9_handshake
	mv s2, a0
	sw s2, -12(s0)
	lw s1, -12(s0)
	li s2, 0
	slt s3, s1, s2
	bnez s3, .L59_0
	j .L59_1
.L59_0:
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
.L59_1:
	lw s1, -4(s0)
	lw s2, -8(s0)
	mv a0, s1
	mv a1, s2
	jal ra, bind_mount
	mv s3, a0
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
.Lfunc_end59:
	.size ninefs_adopt, .Lfunc_end59-ninefs_adopt

	.data
	.align 2
__str_7:
	.ascii "\000"
	.align 2
__str_6:
	.ascii "skj\000"
	.align 2
__str_5:
	.ascii "9P2000\000"
	.align 2
__str_4:
	.ascii "9P2000\000"
	.align 2
__str_3:
	.ascii "\000"
	.align 2
__str_2:
	.ascii "\000"
	.align 2
__str_1:
	.ascii "\000"
	.align 2
__str_0:
	.ascii "9pfs\000"

	.section .rodata
	.align 2
	.globl ninefs_backend
ninefs_backend:
	.word 0x00000004
	.word __str_0
	.word nine_open
	.word nine_read
	.word nine_write
	.word nine_lseek
	.word nine_readdir
	.word nine_close
	.word nine_exists
	.word nine_size
	.word nine_isdir
	.word nine_stat
	.word nine_fstat
	.word nine_unlink
	.word nine_rename
	.word nine_mkdir
	.word nine_rmdir

	.bss
	.align 2
	.globl rxbuf
rxbuf:
	.space 8192
	.align 2
	.globl txbuf
txbuf:
	.space 8192
	.align 3
	.globl mounts
mounts:
	.space 256
