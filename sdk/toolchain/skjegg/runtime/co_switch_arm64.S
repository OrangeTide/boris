/* co_switch_arm64.S : AArch64 (AAPCS64) context switch for the coroutine runtime */

/* void co_switch(struct co_ctx *from, struct co_ctx *to)
 *   from = x0, to = x1; co_ctx.sp is at offset 0.
 * Save the callee-saved registers on the current stack, stash sp into *from,
 * load sp from *to, restore its callee-saved registers, and ret into whatever
 * that stack was about to return to. The saved x30 rides the switched stack, so
 * a plain bl/ret carries control across the switch. The callee-saved FP
 * registers d8-d15 are saved too, since a suspended coroutine may hold live
 * floats. */

/* Mach-O (macOS) prefixes C symbols with an underscore and rejects the ELF-only
   .type/.size/.note.GNU-stack directives; ELF uses the bare name and wants them. */
#if defined(__APPLE__)
# define GSYM(n) _##n
#else
# define GSYM(n) n
#endif

    .text
    .globl GSYM(co_switch)
#if !defined(__APPLE__)
    .type co_switch, %function
#endif
GSYM(co_switch):
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    stp x25, x26, [sp, #-16]!
    stp x27, x28, [sp, #-16]!
    stp x29, x30, [sp, #-16]!
    stp d8,  d9,  [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    mov x2, sp
    str x2, [x0]            /* from->sp = sp */
    ldr x2, [x1]            /* sp = to->sp */
    mov sp, x2

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp d8,  d9,  [sp], #16
    ldp x29, x30, [sp], #16
    ldp x27, x28, [sp], #16
    ldp x25, x26, [sp], #16
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ret
#if !defined(__APPLE__)
    .size co_switch, .-co_switch

    .section .note.GNU-stack,"",%progbits
#endif
