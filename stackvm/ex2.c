#include "ex2_syscalls.h"

int vmMain(int x, int y)
{
	trap_Print("Hello World");
	trap_Error("This is the end!");
	return 0;
}
