/* start_rv.S - minimal RISC-V (RV32IM) runtime for Linux user-mode.
 *
 * Provides _start (the ELF entry point), and thin wrappers for the two
 * syscalls the test programs need: write(2) and exit(2).  qemu-riscv32
 * uses the standard Linux/RISC-V syscall convention:
 *
 *   a7 = syscall number
 *   a0..a5 = args
 *   ecall to invoke
 *   return value in a0
 *
 * The backend emits the RISC-V ILP32 platform psABI, so arguments arrive
 * in a0..a7.  The syscall wrappers pass them straight through: write's
 * (fd, buf, n) are already in a0, a1, a2, which is the ecall order too.
 *
 * _start (in the shared crt_entry_rv.S) reads argc/argv/envp from the entry
 * stack, passes argc/argv to main and sets environ, then passes main's return
 * value to _exit.
 */

	.text
	/* _start and the argv/entry contract are shared with the Kobold
	   freestanding crt (kobold/kp_crt_rv.S); both include this fragment.  This
	   file provides stack_top (in bss below) and the C program provides main. */
	.include "crt_entry_rv.S"

	/* the syscall wrappers are shared with the Kobold freestanding runtime:
	   write/read/open/close/lseek/exit/_exit, getdents64, and the file-metadata
	   and path syscalls (statx and the mkdirat/unlinkat/fchmodat/renameat2 *at
	   forms the libc stat.c/fileops.c wrap). */
	.include "syscall_rv.S"

/* __sys_brk (the raw Linux brk) lives in the shared seam syscall_rv.S, included
   above, since both libc/sbrk.c and the Kobold freestanding gheap grow their
   heap through it. */

/* The 64-bit stack-ABI helpers (multiply and the shift family) are shared with
   the JIT, so their bodies live once in i64_rv.S under the internal skj_jit_*
   names.  Pull them in and expose the public libgcc names the rv32 backend emits
   (__muldi3 / __ashldi3 / __ashrdi3 / __lshrdi3) as tail-jumps into them.  tail
   leaves sp and ra untouched, so the stack-passed arguments and the return
   address reach the body unchanged.  This is the freestanding C runtime, so no
   register-ABI libgcc __muldi3 is linked to collide with these definitions. */
	.include "runtime/i64_rv.S"

	.globl __muldi3
	.type	__muldi3,@function
__muldi3:
	tail	skj_jit_muldi3
	.size	__muldi3,.-__muldi3

	.globl __ashldi3
	.type	__ashldi3,@function
__ashldi3:
	tail	skj_jit_ashldi3
	.size	__ashldi3,.-__ashldi3

	.globl __ashrdi3
	.type	__ashrdi3,@function
__ashrdi3:
	tail	skj_jit_ashrdi3
	.size	__ashrdi3,.-__ashrdi3

	.globl __lshrdi3
	.type	__lshrdi3,@function
__lshrdi3:
	tail	skj_jit_lshrdi3
	.size	__lshrdi3,.-__lshrdi3

/* void *__moo_arena_alloc(int size);
 *   Bump allocator.  Aligns size up to 4 bytes.  Returns pointer in a0. */
	.globl __moo_arena_alloc
	.type	__moo_arena_alloc,@function
__moo_arena_alloc:
	addi	a0, a0, 3
	andi	a0, a0, -4
	la	t0, __moo_arena_ptr
	lw	t1, 0(t0)		/* t1 = old pointer (return value) */
	add	t2, t1, a0		/* t2 = new pointer */
	sw	t2, 0(t0)
	mv	a0, t1
	ret
	.size	__moo_arena_alloc,.-__moo_arena_alloc

/* void __moo_arena_reset(void); */
	.globl __moo_arena_reset
	.type	__moo_arena_reset,@function
__moo_arena_reset:
	la	t0, __moo_arena_ptr
	la	t1, __moo_arena
	sw	t1, 0(t0)
	ret
	.size	__moo_arena_reset,.-__moo_arena_reset

/* __cont_capture()
 *   Called by IR_CAPTURE inline code after pushing s1-s11.
 *   The jal return address (ra) is on the stack as part of the
 *   captured segment (pushed by the callee-save block in IR_CAPTURE).
 *
 *   Reads the 12-byte mark slot via __cont_mark_sp, bump-allocates
 *   a buffer in __cont_arena, copies the stack segment from
 *   capture_sp to mark_sp, then longjmps to the mark's re-entry
 *   label with a0 = buffer address (nonzero).
 *
 *   On entry:  s1-s11 on stack (pushed by IR_CAPTURE inline code)
 *              ra = return address to IR_CAPTURE resume point
 *   Clobbers:  all regs (callee-saves are in the captured segment) */
	.globl __cont_capture
	.type	__cont_capture,@function
__cont_capture:
	addi	sp, sp, -4
	sw	ra, 0(sp)		/* save return address on stack */
	mv	t2, sp			/* t2 = capture_sp */
	mv	t3, s0			/* t3 = capture_fp */

	/* read 12-byte mark slot */
	la	t0, __cont_mark_sp
	lw	t0, 0(t0)		/* t0 = mark slot pointer */
	lw	t4, 0(t0)		/* t4 = mark's saved_fp */
	lw	t5, 4(t0)		/* t5 = mark's saved_sp */
	lw	t6, 8(t0)		/* t6 = mark's re-entry PC */

	/* size = mark_sp - capture_sp (stack grows down) */
	sub	a2, t5, t2		/* a2 = size */

	/* bump-allocate: 12-byte header + size bytes */
	la	t0, __cont_arena_ptr
	lw	a0, 0(t0)		/* a0 = buf */

	/* write buffer header [capture_sp, capture_fp, size] */
	sw	t2, 0(a0)		/* buf[0] = capture_sp */
	sw	t3, 4(a0)		/* buf[4] = capture_fp */
	sw	a2, 8(a0)		/* buf[8] = size */

	/* advance arena pointer past this buffer */
	add	t1, a0, a2
	addi	t1, t1, 12
	sw	t1, 0(t0)

	/* copy stack segment: capture_sp -> buf+12 */
	addi	a3, a0, 12		/* a3 = dst (buf + 12) */
	mv	a4, t2			/* a4 = src (capture_sp) */
	mv	a5, a2			/* a5 = remaining bytes */
	beqz	a5, .Lcap_done
.Lcap_loop:
	lw	t1, 0(a4)
	sw	t1, 0(a3)
	addi	a4, a4, 4
	addi	a3, a3, 4
	addi	a5, a5, -4
	bnez	a5, .Lcap_loop
.Lcap_done:

	/* longjmp to mark: restore FP/SP, jump to re-entry label */
	mv	s0, t4			/* restore mark's FP */
	mv	sp, t5			/* restore mark's SP */
	jr	t6			/* a0 = buf (nonzero) */
	.size	__cont_capture,.-__cont_capture

/* __cont_resume(buf, value)
 *   Restores the captured stack segment and returns into it.
 *   The saved ra on the stack (pushed by __cont_capture) is popped
 *   by the epilogue, landing at the IR_CAPTURE resume point.
 *
 *   On entry:  0(sp) = buf pointer, 4(sp) = resume value */
	.globl __cont_resume
	.type	__cont_resume,@function
__cont_resume:
	lw	a3, 0(sp)		/* a3 = buf */
	lw	a1, 4(sp)		/* a1 = resume value */

	/* read buffer header */
	lw	t2, 0(a3)		/* t2 = capture_sp */
	lw	t3, 4(a3)		/* t3 = capture_fp */
	lw	a2, 8(a3)		/* a2 = size */

	/* restore FP and SP to captured state */
	mv	s0, t3
	mv	sp, t2

	/* copy stack data back: buf+12 -> capture_sp */
	addi	a4, a3, 12		/* a4 = src (buf + 12) */
	mv	a5, sp			/* a5 = dst (capture_sp) */
	beqz	a2, .Lres_done
.Lres_loop:
	lw	t1, 0(a4)
	sw	t1, 0(a5)
	addi	a4, a4, 4
	addi	a5, a5, 4
	addi	a2, a2, -4
	bnez	a2, .Lres_loop
.Lres_done:

	mv	a0, a1			/* a0 = resume value */
	lw	ra, 0(sp)		/* restore ra (saved by __cont_capture) */
	addi	sp, sp, 4
	ret				/* return to IR_CAPTURE resume point */
	.size	__cont_resume,.-__cont_resume

	.data
	.align	4
	.globl __cont_mark_sp
__cont_mark_sp:
	.word	0
	.globl	__cont_arena_ptr
__cont_arena_ptr:
	.word	__cont_arena
__moo_arena_ptr:
	.word	__moo_arena

	.bss
	.align	4
__cont_arena:
	.space	65536
__moo_arena:
	.space	65536
	.space	65536
stack_top:
