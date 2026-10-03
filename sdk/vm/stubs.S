/* stubs.S : host-call stubs.
 *
 * Each stub sets a7 to VM_HOSTCALL_BASE (0x00100000) plus the call's import
 * index and issues an ecall. Integer and pointer arguments are already in
 * a0-a5 and the result comes back in a0, per the host-call ABI, so the C
 * calling convention passes straight through. The index order here must match
 * imports.S, which names the same calls in the same order. */

	.text

	.globl sys_exit
sys_exit:
	li	a7, 0x00100000
	ecall
	ret

	.globl sys_write
sys_write:
	li	a7, 0x00100001
	ecall
	ret

	.globl sys_random
sys_random:
	li	a7, 0x00100002
	ecall
	ret

	.globl sys_now
sys_now:
	li	a7, 0x00100003
	ecall
	ret

	.globl sys_suspend
sys_suspend:
	li	a7, 0x00100004
	ecall
	ret

	.globl sys_getprop
sys_getprop:
	li	a7, 0x00100005
	ecall
	ret

	.globl sys_setprop
sys_setprop:
	li	a7, 0x00100006
	ecall
	ret

	.globl sys_broadcast
sys_broadcast:
	li	a7, 0x00100007
	ecall
	ret

	.globl sys_getmsg
sys_getmsg:
	li	a7, 0x00100008
	ecall
	ret

	.globl sys_listen
sys_listen:
	li	a7, 0x00100009
	ecall
	ret

	.globl sys_notify
sys_notify:
	li	a7, 0x0010000a
	ecall
	ret

	.globl sys_post
sys_post:
	li	a7, 0x0010000b
	ecall
	ret

	.globl sys_taskid
sys_taskid:
	li	a7, 0x0010000c
	ecall
	ret

	.globl sys_close
sys_close:
	li	a7, 0x0010000d
	ecall
	ret

	.globl sys_getobj
sys_getobj:
	li	a7, 0x0010000e
	ecall
	ret

	.globl sys_objfind
sys_objfind:
	li	a7, 0x0010000f
	ecall
	ret

	.globl sys_next
sys_next:
	li	a7, 0x00100010
	ecall
	ret

	.globl sys_move
sys_move:
	li	a7, 0x00100011
	ecall
	ret

	.globl sys_setpriv
sys_setpriv:
	li	a7, 0x00100012
	ecall
	ret

	.globl sys_create
sys_create:
	li	a7, 0x00100013
	ecall
	ret

	.globl sys_recycle
sys_recycle:
	li	a7, 0x00100014
	ecall
	ret

	.globl sys_errno
sys_errno:
	li	a7, 0x00100015
	ecall
	ret

	.globl sys_contents_count
sys_contents_count:
	li	a7, 0x00100016
	ecall
	ret
