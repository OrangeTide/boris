/* crt_entry_rv.S : the shared RV32 _start, included by both the C runtime
 * (runtime/start_rv.S, assembled by GNU as) and the Kobold freestanding crt
 * (kobold/kp_crt_rv.S, assembled by skj-as-rv).  One entry, one argv contract.
 *
 * It reads the entry argument vector the host places at the entry sp (argc at
 * 0(sp), the argv pointers just above, then a NULL, the ordinary ELF
 * convention qemu-riscv32 follows), switches to the larger stack the including
 * file reserves as stack_top, calls main(argc, argv), runs the weak
 * __libc_fini finalizer when one is linked, and exits with main's return.
 *
 * The including file provides stack_top (its own bss stack) and main.  A C
 * program's main is the program; a Kobold program's main is the entry shim in
 * kobold/io_free.c, which records the args for ParamStr/ParamCount and runs
 * kp_guest_entry.  environ and __libc_fini are weak: set or called only when a
 * libc links them (the Kobold runtime defines both so its link needs no
 * weak-undefined resolution).  Because both languages enter here and read argc
 * and argv from the same bytes, ParamStr and C argv are identical.
 */

	.text
	.globl _start
	.weak  __libc_fini
	.weak  environ

	.type	_start,@function
_start:
	mv	t0, sp			/* the kernel/skj-run stack: argc at 0(sp), */
					/* the argv pointers just above it */
	la	sp, stack_top		/* switch to our own, larger stack */
	addi	sp, sp, -16
	lw	a0, 0(t0)		/* argc */
	addi	a1, t0, 4		/* argv (the pointers live in the entry */
					/* stack region, which stays mapped) */
	slli	t1, a0, 2		/* envp = argv + (argc+1) words: skip the */
	add	t1, a1, t1		/* argv[] entries and their NULL terminator */
	addi	t1, t1, 4
	la	t2, environ		/* weak: present only when the libc links it */
	beqz	t2, 1f
	sw	t1, 0(t2)
1:
	jal	ra, main
	mv	s1, a0			/* preserve main's return across the finalizer */
	la	t0, __libc_fini		/* weak: 0 when no libc is linked */
	beqz	t0, 1f
	jalr	t0			/* run atexit handlers and flush stdio */
1:
	mv	a0, s1
	li	a7, 93
	ecall
2:	j	2b
	.size	_start,.-_start
