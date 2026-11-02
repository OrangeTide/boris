#ifndef _SETJMP_H
#define _SETJMP_H

/* jmp_buf holds the callee-saved registers, the stack pointer, and the return
   address that longjmp must restore.  32 words is ample headroom for every
   target's save set; the per-arch asm (runtime/setjmp_*.S) uses only the slots
   it needs. */
typedef long jmp_buf[32];

int  setjmp(jmp_buf env);
void longjmp(jmp_buf env, int val);

#endif /* _SETJMP_H */
