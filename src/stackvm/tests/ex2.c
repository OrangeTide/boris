#include "ex2_syscalls.h"

int vmMain(int x, int y)
{
	void *s;
	trap_Print(s = "Hello World");
	if (0) /* set to 1 to enable a negative test */
		trap_Error("This is the end!");
	return (int)s;
}
