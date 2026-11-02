/* call_guest_x86.S : call a JIT-compiled guest entry with marshaled arguments */

/* uint64_t kp_call_guest(void *entry, void *stack_top,
 *                        const int64_t iargs[6], const double fargs[8],
 *                        double *fret)
 *   entry = rdi, stack_top = rsi, iargs = rdx, fargs = rcx, fret = r8.
 *
 * The guest runs on the JIT's low-2GB execution stack (its locals' addresses must
 * fit 32 bits), so switch rsp to stack_top (already 16-byte aligned) for the call
 * and restore it after. Load the SysV argument registers from the arrays: all six
 * integer and all eight float registers are loaded unconditionally, since the guest
 * reads only the ones its signature declares and ignores the rest, which avoids
 * per-signature branching. The integer result comes back in rax; the float result
 * is stored through fret. */

    .text
    .globl kp_call_guest
    .type kp_call_guest, @function
kp_call_guest:
    pushq %rbp
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    movq %rdi, %r12         /* entry */
    movq %rsi, %r13         /* stack_top */
    movq %rdx, %rbx         /* iargs */
    movq %rcx, %r14         /* fargs */
    movq %r8, %r15          /* fret */
    movq %rsp, %rbp         /* save the host stack pointer */

    /* float arguments xmm0..xmm7 from fargs */
    movsd 0(%r14), %xmm0
    movsd 8(%r14), %xmm1
    movsd 16(%r14), %xmm2
    movsd 24(%r14), %xmm3
    movsd 32(%r14), %xmm4
    movsd 40(%r14), %xmm5
    movsd 48(%r14), %xmm6
    movsd 56(%r14), %xmm7

    /* integer arguments rdi..r9 from iargs (read before clobbering the pointer) */
    movq 0(%rbx), %rdi
    movq 8(%rbx), %rsi
    movq 16(%rbx), %rdx
    movq 24(%rbx), %rcx
    movq 32(%rbx), %r8
    movq 40(%rbx), %r9

    movq %r13, %rsp         /* switch to the low execution stack (16-byte aligned) */
    call *%r12              /* run the guest entry */
    movq %rbp, %rsp         /* restore the host stack */

    movsd %xmm0, (%r15)     /* hand back the float result */

    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    popq %rbp
    ret                     /* integer result already in rax */
    .size kp_call_guest, .-kp_call_guest

    /* Mark the stack non-executable so the linker does not warn. */
    .section .note.GNU-stack,"",@progbits
