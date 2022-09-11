void trap_Print(const char *string);
void trap_Error(const char *string); /* __attribute__((noreturn)); */
int trap_Callback(int n_args, int (*func)(), ...);
