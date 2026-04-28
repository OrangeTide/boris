/* crt0.S : ColdFire V4e CRT for machine scripts */

	.section .text
	.global _start
	.weak main

_start:
	/* Zero .bss */
	move.l	#__bss_start, %a0
	move.l	#__bss_end, %a1
.Lzero_bss:
	cmp.l	%a1, %a0
	bge.s	.Lzero_done
	clr.b	(%a0)+
	bra.s	.Lzero_bss
.Lzero_done:

	/* Iterate .data.verb_regs, calling HC_OPEN for each entry */
	move.l	#__verb_regs_start, %a2
	move.l	#__verb_regs_end, %a3
	move.l	#_verb_fds, %a4
	moveq	#0, %d2

.Lreg_loop:
	cmp.l	%a3, %a2
	bge.s	.Lreg_done

	move.l	(%a2)+, %a0		/* name string pointer */
	move.l	(%a2)+, %d3		/* handler function pointer */

	/* HC_OPEN(name, flags=0, handler_pc) */
	moveq	#0, %d0
	move.l	%d3, %d1
	.word	0xA006

	tst.l	%d0
	bmi.s	.Lreg_loop

	/* verb_fds[nfds] = fd */
	move.w	%d0, (%a4,%d2.l*2)

	/* dispatch_table[fd] = handler */
	move.l	#_dispatch_table, %a5
	move.l	%d3, (%a5,%d0.l*4)

	addq.l	#1, %d2
	bra.s	.Lreg_loop

.Lreg_done:
	move.l	%d2, _nfds

	/* Call main() if defined (weak symbol -- 0 if absent) */
	move.l	#main, %d0
	beq.s	.Ldispatch

	move.l	%d0, %a0
	jsr	(%a0)

.Ldispatch:
	/* HC_WAIT(nfds, verb_fds, -1) */
	move.l	_nfds, %d0
	move.l	#_verb_fds, %a0
	moveq	#-1, %d1
	.word	0xA008

	/* d0 = index of signaled handle, -1 = loop exit */
	tst.l	%d0
	bmi.s	.Lexit

	/* fd = verb_fds[idx] */
	move.l	#_verb_fds, %a0
	and.l	#0xFFFF, %d0
	move.w	(%a0,%d0.l*2), %d0

	/* handler = dispatch_table[fd] */
	and.l	#0xFFFF, %d0
	move.l	#_dispatch_table, %a0
	move.l	(%a0,%d0.l*4), %a0
	jsr	(%a0)

	bra.s	.Ldispatch

.Lexit:
	moveq	#0, %d0
	.word	0xA004
.Lhalt:
	bra.s	.Lhalt

	/* CRT data in .bss */
	.section .bss
	.global _nfds, _verb_fds, _dispatch_table

_nfds:
	.space	4
_verb_fds:
	.space	256 * 2
_dispatch_table:
	.space	256 * 4

	.section .note.GNU-stack,"",@progbits
