# tinc: generated RISC-V (RV32IMFD + Zfh) assembly

	.text
	.align 2
	.type chan_rpc, @function
chan_rpc:
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
	lw s1, -4(s0)
	sw s1, -28(s0)
	lw s1, -12(s0)
	li s2, 8192
	sltu s3, s2, s1
	bnez s3, .L1_0
	j .L1_1
.L1_0:
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
.L1_1:
	lw s1, -28(s0)
	li s2, 8
	add s3, s1, s2
	lw s1, -8(s0)
	lw s2, -12(s0)
	mv a0, s3
	mv a1, s1
	mv a2, s2
	jal ra, memcpy
	mv s4, a0
	lw s1, -12(s0)
	lw s2, -28(s0)
	sw s1, 0(s2)
	lw s1, -28(s0)
	mv a0, s1
	jal ra, __skj_p9_doorbell
	mv s2, a0
	li s1, 0
	xor s3, s2, s1
	snez s3, s3
	bnez s3, .L1_2
	j .L1_3
.L1_2:
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
.L1_3:
	lw s1, -28(s0)
	li s2, 4
	add s3, s1, s2
	lw s1, 0(s3)
	sw s1, -32(s0)
	lw s1, -32(s0)
	lw s2, -20(s0)
	sltu s3, s2, s1
	bnez s3, .L1_4
	j .L1_5
.L1_4:
	lw s1, -20(s0)
	sw s1, -32(s0)
.L1_5:
	lw s1, -32(s0)
	li s2, 8192
	sltu s3, s2, s1
	bnez s3, .L1_6
	j .L1_7
.L1_6:
	li s1, 8192
	sw s1, -32(s0)
.L1_7:
	lw s1, -16(s0)
	lw s2, -28(s0)
	li s3, 8200
	add s4, s2, s3
	lw s2, -32(s0)
	mv a0, s1
	mv a1, s4
	mv a2, s2
	jal ra, memcpy
	mv s3, a0
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
.Lfunc_end1:
	.size chan_rpc, .Lfunc_end1-chan_rpc

	.text
	.align 2
	.globl p9_guest_transport
	.type p9_guest_transport, @function
p9_guest_transport:
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
	la s1, chan_rpc
	lw s2, -8(s0)
	sw s1, 0(s2)
	lw s1, -4(s0)
	lw s2, -8(s0)
	li s3, 4
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
	.size p9_guest_transport, .Lfunc_end2-p9_guest_transport

	.data
