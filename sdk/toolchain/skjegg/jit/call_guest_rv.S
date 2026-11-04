/* call_guest_rv.S : call a JIT-compiled RV32 guest entry with marshaled arguments */

/* uint64_t kp_call_guest(void *entry, void *stack_top,
 *                        const int64_t iargs[6], const double fargs[8],
 *                        double *fret)
 *   entry = a0, stack_top = a1, iargs = a2, fargs = a3, fret = a4.
 *
 * The guest runs on the JIT's low-memory execution stack (its locals' addresses
 * must fit 32 bits), so switch sp to stack_top (already 16-byte aligned) for the
 * call and restore it after.  RV32 is natively 32-bit, so every address already
 * fits; there is no register-width juggling.
 *
 * The RISC-V ILP32 psABI (soft float) passes every argument, integer or float,
 * in the integer registers a0..a7, so this shim loads a0..a5 from the low words
 * of iargs[0..5] and ignores fargs (a float argument, if ever needed, would
 * arrive through the integer registers too).  The guest reads only the ones its
 * signature declares.  The integer result comes back in a0 (a0:a1 for a wide
 * value); a float result through this shim is not used, so *fret is cleared. */

    .text
    .globl kp_call_guest
    .type kp_call_guest, @function
kp_call_guest:
    addi sp, sp, -32
    sw   ra, 28(sp)
    sw   s0, 24(sp)
    sw   s1, 20(sp)
    sw   s2, 16(sp)
    sw   s3, 12(sp)

    mv   s2, a0             /* entry */
    mv   s3, a1             /* stack_top */
    mv   s1, a4             /* fret */
    mv   t0, a2             /* iargs (loaded before the arg regs are overwritten) */
    mv   s0, sp             /* save the host stack pointer (guest preserves s0) */

    lw   a5, 40(t0)
    lw   a4, 32(t0)
    lw   a3, 24(t0)
    lw   a2, 16(t0)
    lw   a1, 8(t0)
    lw   a0, 0(t0)

    mv   sp, s3            /* switch to the low execution stack */
    jalr ra, s2, 0        /* run the guest entry */
    mv   sp, s0           /* restore the host stack */

    sw   zero, 0(s1)      /* float result unused on RV; clear *fret */
    sw   zero, 4(s1)

    lw   ra, 28(sp)
    lw   s0, 24(sp)
    lw   s1, 20(sp)
    lw   s2, 16(sp)
    lw   s3, 12(sp)
    addi sp, sp, 32
    ret                    /* integer result already in a0 (a1 = high word) */
    .size kp_call_guest, .-kp_call_guest

    .section .note.GNU-stack,"",%progbits
