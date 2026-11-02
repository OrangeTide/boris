/* kp_crt_cf.S : the freestanding ColdFire start file for a Kobold guest program.

   The entry and the argv contract are shared with the C runtime: this file
   includes runtime/crt_entry_cf.S, the same _start the C crt (runtime/start.S)
   uses.  The shared _start reads argc and argv from the entry sp, switches to
   the stack reserved here, and calls main(argc, argv).  For a Kobold guest,
   main is the entry shim in kobold/io_free.c: it records the args for
   ParamCount / ParamStr, runs the program through kp_guest_entry (the fixed
   name the AOT driver gives the program's entry), and returns 0.  A normal
   return flushes buffered stdio through the weak __libc_fini (also io_free.c)
   and exits 0; a program ends nonzero only by calling Halt(code), which exits
   through io_halt.

   The guest heap grows the program break on demand (rt_free.c over the brk
   syscall), so this file reserves no heap region and no longer calls
   kp_rt_init; the host sets the break's base and limit when it loads the task
   (boris A3).  Only the execution stack is reserved here: a deep self-compile
   overflows a small entry stack, so the shared _start switches to this one.

   The execution stack is 2 MiB (2097152); skj-as has no .equ, so the literal
   is repeated at its .space. */

    .text
    .include "../runtime/crt_entry_cf.S"

    /* Entry-ABI version guard (kp_abi.h): reference the archive's version symbol
       so a crt built for one ABI version fails to link against a libkpaot-*-free
       of another, rather than silently mismatching the entry seam.  Bump the
       suffix here with KP_GUEST_ABI_VERSION. */
    .data
    .align  4
    .globl  __kp_crt_abi_ref
__kp_crt_abi_ref:
    .long   kp_guest_abi_v3

    .bss
    .align  4                   | 16-aligned base
    .space  2097152             | execution stack (2 MiB)
stack_top:
