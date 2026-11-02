/* vm_sys.h : boris host-call selector band.
 *
 * A guest reaches a host call with an ecall whose a7 holds VM_HOSTCALL_BASE
 * plus one of the fixed selectors below, integer and pointer arguments in
 * a0-a5, and the result written back to a0. The selectors are fixed: there is
 * no per-image import table to scan, so the guest stubs (sdk/vm/stubs.S) and
 * the host dispatch share this one list and must stay in step.
 *
 * The band sits above skjegg's own private selectors (0x000f0000..0x000f0005:
 * FATAL/MAP/MUNMAP/SPAWN/YIELD/P9), so a boris host call and a skjegg runtime
 * call never collide. Linux syscall numbers (small integers) are a third,
 * disjoint range handled by the ELF/libc file I/O seam. */

#ifndef VM_SYS_H
#define VM_SYS_H

/* Base of the boris host-call selector band. */
#define VM_HOSTCALL_BASE 0x00100000u

/* Fixed host-call selectors. The first group (through VM_CALL_CONTENTS_COUNT)
 * mirrors sdk/vm/stubs.S one for one and in order; do not renumber it without
 * rebuilding the guest SDK. Selectors past the stub table are reachable only
 * from host-built images (the unit tests), never emitted by the SDK stubs. */
enum vm_call {
	VM_CALL_EXIT = 0,
	VM_CALL_WRITE,
	VM_CALL_RANDOM,
	VM_CALL_NOW,
	VM_CALL_SUSPEND,
	VM_CALL_GETPROP,
	VM_CALL_SETPROP,
	VM_CALL_BROADCAST,
	VM_CALL_GETMSG,
	VM_CALL_LISTEN,
	VM_CALL_NOTIFY,
	VM_CALL_POST,
	VM_CALL_TASKID,
	VM_CALL_CLOSE,
	VM_CALL_GETOBJ,
	VM_CALL_OBJFIND,
	VM_CALL_NEXT,
	VM_CALL_MOVE,
	VM_CALL_SETPRIV,
	VM_CALL_CREATE,
	VM_CALL_RECYCLE,
	VM_CALL_ERRNO,
	VM_CALL_CONTENTS_COUNT,

	/* Host-image-only selectors (no SDK stub). */
	VM_CALL_READ,

	VM_CALL_COUNT
};

#endif /* VM_SYS_H */
