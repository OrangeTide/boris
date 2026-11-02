/* co_switch_x86.S : x86-64 SysV context switch for the coroutine runtime */

/* void co_switch(struct co_ctx *from, struct co_ctx *to)
 *   from = rdi, to = rsi; co_ctx.sp is at offset 0.
 * Save the callee-saved registers on the current stack, stash rsp into *from,
 * load rsp from *to, restore its callee-saved registers, and ret into whatever
 * that stack was about to return to. The return address rides the stack, so a
 * plain call/ret carries control across the switch. */

    .text
    .globl co_switch
    .type co_switch, @function
co_switch:
    pushq %rbp
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq %rsp, (%rdi)        /* from->sp = rsp */
    movq (%rsi), %rsp        /* rsp = to->sp */
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    popq %rbp
    ret
    .size co_switch, .-co_switch

    /* Mark the stack non-executable so the linker does not warn. */
    .section .note.GNU-stack,"",@progbits
