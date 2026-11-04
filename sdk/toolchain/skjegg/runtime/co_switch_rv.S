/* co_switch_rv.S : RV32 (ILP32D) context switch for the coroutine runtime */

/* void co_switch(struct co_ctx *from, struct co_ctx *to)
 *   from = a0, to = a1; co_ctx.sp is at offset 0.
 * Save the callee-saved registers on the current stack, stash sp into *from,
 * load sp from *to, restore its callee-saved registers, and ret into whatever
 * that stack was about to return to. The saved ra rides the switched stack, so a
 * plain call/ret carries control across the switch. The callee-saved FP registers
 * fs0-fs11 are saved too, since a suspended coroutine may hold live floats. The
 * block is 160 bytes: ra and s0-s11 (13 words) at the base, then fs0-fs11
 * (12 doubles) from offset 56, matching the seed in co.c. */

    .text
    .globl co_switch
    .type co_switch, @function
co_switch:
    addi sp, sp, -160
    sw   ra,   0(sp)
    sw   s0,   4(sp)
    sw   s1,   8(sp)
    sw   s2,  12(sp)
    sw   s3,  16(sp)
    sw   s4,  20(sp)
    sw   s5,  24(sp)
    sw   s6,  28(sp)
    sw   s7,  32(sp)
    sw   s8,  36(sp)
    sw   s9,  40(sp)
    sw   s10, 44(sp)
    sw   s11, 48(sp)
    fsd  fs0,  56(sp)
    fsd  fs1,  64(sp)
    fsd  fs2,  72(sp)
    fsd  fs3,  80(sp)
    fsd  fs4,  88(sp)
    fsd  fs5,  96(sp)
    fsd  fs6, 104(sp)
    fsd  fs7, 112(sp)
    fsd  fs8, 120(sp)
    fsd  fs9, 128(sp)
    fsd  fs10,136(sp)
    fsd  fs11,144(sp)

    sw   sp, 0(a0)          /* from->sp = sp */
    lw   sp, 0(a1)          /* sp = to->sp */

    lw   ra,   0(sp)
    lw   s0,   4(sp)
    lw   s1,   8(sp)
    lw   s2,  12(sp)
    lw   s3,  16(sp)
    lw   s4,  20(sp)
    lw   s5,  24(sp)
    lw   s6,  28(sp)
    lw   s7,  32(sp)
    lw   s8,  36(sp)
    lw   s9,  40(sp)
    lw   s10, 44(sp)
    lw   s11, 48(sp)
    fld  fs0,  56(sp)
    fld  fs1,  64(sp)
    fld  fs2,  72(sp)
    fld  fs3,  80(sp)
    fld  fs4,  88(sp)
    fld  fs5,  96(sp)
    fld  fs6, 104(sp)
    fld  fs7, 112(sp)
    fld  fs8, 120(sp)
    fld  fs9, 128(sp)
    fld  fs10,136(sp)
    fld  fs11,144(sp)
    addi sp, sp, 160
    ret
    .size co_switch, .-co_switch

    .section .note.GNU-stack,"",%progbits
