#include "ex2_syscalls.h"

void do_fail(void);
int do_add(int a, int b, int c);
int do_mul(int a, int b);
int do_callback(int (*func)(), int a, int b, int c);

/* first function is the entry point */
int vmMain(int x, int y)
{
	int a, b;
#if 1 /* uses a VM call to call another function. demonstrates a re-entrant VM. */
	a = trap_Callback(3, do_add, 300, 400, 500);
	b = trap_Callback(2, do_mul, 600, 700);
	return a + b;
#else /* example of doing something simular in C. */
	a = do_callback(do_add, 300, 400, 500);
	b = do_callback(do_mul, 600, 700, 0);
	return a + b;
#endif
}

void do_fail(void)
{
	trap_Error("Should never happen");
}

int do_add(int a, int b, int c)
{
	trap_Print("Adding");
	return a + b + c;
}

int do_mul(int a, int b)
{
	trap_Print("Multiplying");
	return a * b;
}

int do_callback(int (*func)(), int a, int b, int c)
{
	return func(a, b, c);
}
