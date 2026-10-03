/* imports.S : the KPIMPT1 host-call import table.
 *
 * The loader scans the image for the "KPIMPT1" magic and binds each name here
 * to a host function, so import index i (the i-th name below) is the selector
 * a7 = 0x00100000 + i that stubs.S uses. Layout: the magic, a u32 count, then
 * the packed NUL-terminated names. Keep the order in step with stubs.S. */

	.rodata
	.globl _kp_imports
_kp_imports:
	.ascii "KPIMPT1"
	.byte 0
	.word 23
	.asciz "sys_exit"
	.asciz "sys_write"
	.asciz "sys_random"
	.asciz "sys_now"
	.asciz "sys_suspend"
	.asciz "sys_getprop"
	.asciz "sys_setprop"
	.asciz "sys_broadcast"
	.asciz "sys_getmsg"
	.asciz "sys_listen"
	.asciz "sys_notify"
	.asciz "sys_post"
	.asciz "sys_taskid"
	.asciz "sys_close"
	.asciz "sys_getobj"
	.asciz "sys_objfind"
	.asciz "sys_next"
	.asciz "sys_move"
	.asciz "sys_setpriv"
	.asciz "sys_create"
	.asciz "sys_recycle"
	.asciz "sys_errno"
	.asciz "sys_contents_count"
