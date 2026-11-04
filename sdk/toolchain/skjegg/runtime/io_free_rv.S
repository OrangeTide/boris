/* io_free_rv.S : the RV32 syscall seam for the Kobold freestanding guest.
 *
 * The wrappers are the same ones the C crt uses, so they live in syscall_rv.S
 * and both files .include it; the Kobold console C (io_free.c) and libc's
 * stdio_core.c build on write / read, and io_halt exits through _exit.  (open /
 * close / lseek come along too; the rv32 freestanding console does not use
 * them, so they are harmless spare stubs here.) */

    .text
    .include "syscall_rv.S"
