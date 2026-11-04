/* syscall_rv.S : the RV32 Linux syscall wrappers, the one seam shared by the C
   crt (start_rv.S) and the Kobold freestanding runtime (io_free_rv.S).  Both
   .include this file, so the wrappers are written once.  Each is a single ecall:
   a7 is the syscall number, a0..a4 the arguments (already in place on the ILP32
   psABI), the result in a0.  exit is weak so libc's flushing exit overrides it;
   _exit is the raw process exit.

   Error convention (the raw-seam ABI boris and skj-run both honor): a failing
   call returns a negative Linux errno in a0, the real rv32 Linux numbers (for
   example -2 ENOENT, -9 EBADF).  The wrappers pass a0 through unchanged, lseek
   included, so a guest built against this runtime reads the same -errno on
   skj-run (emu/guest.c returns -GUEST_E*, the Linux values) and in the boris VM.
   This is distinct from boris's name-bound host-call error space (its own small
   VM_ERR_* read back through sys_errno), which this freestanding seam never
   touches: it issues only the raw Linux calls. */

	/* The five fd primitives are weak so the C libc's fs/ layer (libc/fdio.c)
	   can override them with path-resolving versions; a consumer that links no
	   fdio.c (the Kobold runtime, a bare crt) keeps these raw wrappers.  Their
	   __sys_* aliases are the raw entry points the fs/ backends call so they
	   reach the kernel without recursing through an override. */
	.weak  write
	.weak  read
	.weak  open
	.weak  close
	.weak  lseek
	.globl __sys_write
	.globl writev
	.globl __sys_read
	.globl __sys_open
	.globl __sys_close
	.globl __sys_lseek
	.globl openat
	.globl getdents64
	.globl statx
	.globl mkdirat
	.globl unlinkat
	.globl fchmodat
	.globl renameat2
	.globl clock_gettime
	.globl getrandom
	.globl nanosleep
	.globl sched_yield
	.globl __sys_brk
	.weak  exit
	.globl _exit

/* int write(int fd, const char *buf, int n); */
	.type	write,@function
	.type	__sys_write,@function
write:
__sys_write:
	li	a7, 64
	ecall
	ret
	.size	write,.-write
	.size	__sys_write,.-__sys_write

/* int writev(int fd, const struct iovec *iov, int iovcnt); */
	.type	writev,@function
writev:
	li	a7, 66
	ecall
	ret
	.size	writev,.-writev

/* int read(int fd, char *buf, int n); */
	.type	read,@function
	.type	__sys_read,@function
read:
__sys_read:
	li	a7, 63
	ecall
	ret
	.size	read,.-read
	.size	__sys_read,.-__sys_read

/* int open(const char *path, int flags, int mode);
   rv32 Linux has no bare open, so this is openat(AT_FDCWD, path, flags, mode)
   with the arguments shifted up one register. */
	.type	open,@function
	.type	__sys_open,@function
open:
__sys_open:
	mv	a3, a2			/* mode */
	mv	a2, a1			/* flags */
	mv	a1, a0			/* path */
	li	a0, -100		/* AT_FDCWD */
	li	a7, 56			/* openat */
	ecall
	ret
	.size	open,.-open
	.size	__sys_open,.-__sys_open

/* int openat(int dirfd, const char *path, int flags, int mode);
   The confined hostcap backend (fs/hostcap.c) issues this against a mount
   capability fd, so the raw dirfd matters; it is not interposed (no weak
   alias).  Args already in a0..a3 on the ILP32 psABI. */
	.globl	openat
	.type	openat,@function
openat:
	li	a7, 56			/* openat */
	ecall
	ret
	.size	openat,.-openat

/* int close(int fd); */
	.type	close,@function
	.type	__sys_close,@function
close:
__sys_close:
	li	a7, 57
	ecall
	ret
	.size	close,.-close
	.size	__sys_close,.-__sys_close

/* long lseek(int fd, long offset, int whence);
   rv32 Linux has no simple lseek; syscall 62 is _llseek(fd, off_hi, off_lo,
   loff_t *result, whence) with a 64-bit offset split into two words and the new
   position written back through a pointer.  Sign-extend the 32-bit offset into
   the high word, pass a stack slot for the result, and return its low 32 bits
   (a file under 2 GiB, which every toolchain input is).  On error _llseek sets
   a0 to a negative Linux errno; return it unchanged, so the raw seam keeps the
   negative-errno convention the other wrappers pass through. */
	.type	lseek,@function
	.type	__sys_lseek,@function
lseek:
__sys_lseek:
	addi	sp, sp, -16
	mv	t0, a1			/* t0 = offset */
	mv	a4, a2			/* a4 = whence */
	srai	a1, t0, 31		/* a1 = off_hi (sign extension) */
	mv	a2, t0			/* a2 = off_lo */
	mv	a3, sp			/* a3 = &result (loff_t) */
	li	a7, 62			/* _llseek */
	ecall
	bltz	a0, 1f			/* a0 < 0: keep the kernel's -errno */
	lw	a0, 0(sp)		/* success: low 32 bits of the new position */
1:	addi	sp, sp, 16
	ret
	.size	lseek,.-lseek
	.size	__sys_lseek,.-__sys_lseek

/* int getdents64(int fd, void *buf, int count); reads directory entries into
   buf as a packed sequence of struct linux_dirent64.  Shared with the Kobold
   freestanding runtime (the dirs unit), hence here rather than in start_rv.S.
   Args already in a0..a2. */
	.type	getdents64,@function
getdents64:
	li	a7, 61
	ecall
	ret
	.size	getdents64,.-getdents64

/* The file-metadata and path syscalls the libc wraps (libc/stat.c over statx,
   libc/fileops.c over the *at forms with AT_FDCWD).  rv32 has no bare stat /
   mkdir / unlink / rename, so these *at forms are the primitives.  Shared with
   the Kobold freestanding runtime (the files unit's Exists/FileSize/IsDir and
   Delete/Rename/MakeDir/RemoveDir), hence here rather than in start_rv.S.  All
   arguments are already in a0.. on the ILP32 psABI. */
	.type	statx,@function
statx:
	li	a7, 291
	ecall
	ret
	.size	statx,.-statx

	.type	mkdirat,@function
mkdirat:
	li	a7, 34
	ecall
	ret
	.size	mkdirat,.-mkdirat

	.type	unlinkat,@function
unlinkat:
	li	a7, 35
	ecall
	ret
	.size	unlinkat,.-unlinkat

	.type	fchmodat,@function
fchmodat:
	li	a7, 53
	ecall
	ret
	.size	fchmodat,.-fchmodat

	.type	renameat2,@function
renameat2:
	li	a7, 276
	ecall
	ret
	.size	renameat2,.-renameat2

/* int clock_gettime(int clk_id, void *ts); writes a 32-bit {tv_sec, tv_nsec}
   through ts (see the seam note on the 32-bit timespec convention).  Args in
   a0..a1. */
	.type	clock_gettime,@function
clock_gettime:
	li	a7, 113
	ecall
	ret
	.size	clock_gettime,.-clock_gettime

/* int getrandom(void *buf, int len, unsigned flags); fills buf with len random
   bytes and returns the count.  Args in a0..a2. */
	.type	getrandom,@function
getrandom:
	li	a7, 278
	ecall
	ret
	.size	getrandom,.-getrandom

/* int nanosleep(const void *req, void *rem); parks the task for the {tv_sec,
   tv_nsec} the req timespec holds (the 32-bit timespec convention this seam and
   boris share).  Args in a0..a1.  On boris the park/yield glue is bound to its
   sys_wait(timeout) host-call instead; this raw syscall is the skj-run backing. */
	.type	nanosleep,@function
nanosleep:
	li	a7, 101
	ecall
	ret
	.size	nanosleep,.-nanosleep

/* int sched_yield(void); gives up the rest of the task's turn without sleeping.
   No arguments.  A standard POSIX wrapper on the shared seam for C; the Kobold
   runtime does not wrap it (Sleep(0) is the guest-level yield for now). */
	.type	sched_yield,@function
sched_yield:
	li	a7, 124
	ecall
	ret
	.size	sched_yield,.-sched_yield

/* void *__sys_brk(void *addr); the raw Linux brk (#214), returning the new
   program break.  Both heaps grow through one brk-bump, libc/sbrk.c's
   __libc_sbrk: libc's malloc on the hosted ILP32 targets and the Kobold
   freestanding gheap (rt_free.c) call it alike, so it lives in the shared seam. */
	.type	__sys_brk,@function
__sys_brk:
	li	a7, 214
	ecall
	ret
	.size	__sys_brk,.-__sys_brk

/* void exit(int status); (weak) and void _exit(int status); */
	.type	exit,@function
	.type	_exit,@function
exit:
_exit:
	li	a7, 93
	ecall
1:	j	1b
	.size	exit,.-exit
	.size	_exit,.-_exit

/* void __skj_trap_backtrace(int code);
   The RV_SYS_FATAL ecall (0x000f0000, boris's VM_SYS_TRAP): print a symbolized
   backtrace for the calling frame and end the process with exit code a0, so an
   abort or a runtime trap shows a source-level stack like a CPU fault does, and
   a guest faults identically on skj-run and in the boris VM.  a7 sits far above
   the Linux range, so on qemu-user it returns -ENOSYS and control returns here;
   the caller then falls through to its own exit, so this is a no-op off a VM. */
	.globl	__skj_trap_backtrace
	.type	__skj_trap_backtrace,@function
__skj_trap_backtrace:
	li	a7, 0x000f0000		/* RV_SYS_FATAL = boris VM_SYS_TRAP */
	ecall
	ret
	.size	__skj_trap_backtrace,.-__skj_trap_backtrace

/* long __skj_p9_doorbell(void *chan);
   The 9p channel doorbell: hand the launcher the framed T-message in the
   channel at a0 and get the R-message back in the same channel.  SKJ_SYS_P9
   (0x000f0005) sits above the Linux range, so off a sandbox (bare qemu) it
   returns -ENOSYS and the caller's 9p rpc fails cleanly. */
	.globl	__skj_p9_doorbell
	.type	__skj_p9_doorbell,@function
__skj_p9_doorbell:
	li	a7, 0x000f0005		/* SKJ_SYS_P9 */
	ecall
	ret
	.size	__skj_p9_doorbell,.-__skj_p9_doorbell

/* unsigned skj_spawnv(const void *req);  spawn a child from a size-prefixed
   request in guest memory (SKJ_SYS_SPAWNV), returning its handle in a0.
   unsigned skj_wait(unsigned handle);  wait on a child and return its status
   (SKJ_SYS_WAIT).  The one argument is already in a0. */
	.globl	skj_spawnv
	.type	skj_spawnv,@function
skj_spawnv:
	li	a7, 0x000f0006		/* SKJ_SYS_SPAWNV */
	ecall
	ret
	.size	skj_spawnv,.-skj_spawnv

	.globl	skj_wait
	.type	skj_wait,@function
skj_wait:
	li	a7, 0x000f0007		/* SKJ_SYS_WAIT */
	ecall
	ret
	.size	skj_wait,.-skj_wait

/* unsigned skj_kill(unsigned handle, unsigned status);  terminate a child
   (SKJ_SYS_KILL), a0=handle a1=status already in place, result in a0. */
	.globl	skj_kill
	.type	skj_kill,@function
skj_kill:
	li	a7, 0x000f0008		/* SKJ_SYS_KILL */
	ecall
	ret
	.size	skj_kill,.-skj_kill

/* int skj_pipe(unsigned *ends);  create a host pipe (SKJ_SYS_PIPE); a0 points
   at two u32 the host fills with the read and write capability indices; the
   result (0 or -1) is in a0. */
	.globl	skj_pipe
	.type	skj_pipe,@function
skj_pipe:
	li	a7, 0x000f0009		/* SKJ_SYS_PIPE */
	ecall
	ret
	.size	skj_pipe,.-skj_pipe
