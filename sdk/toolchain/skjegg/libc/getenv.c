/* getenv over the environ vector.  The crt sets environ to the envp array the
   kernel (or skj-run) placed above argv on the entry stack; it is null until
   then, in which case the environment is treated as empty. */
#include <stdlib.h>
#include <string.h>

char **environ = 0;

char *
getenv(const char *name)
{
    char **e = environ;
    size_t n;

    if (!e)
        return 0;
    n = strlen(name);
    for (; *e; e++) {
        if (strncmp(*e, name, n) == 0 && (*e)[n] == '=')
            return *e + n + 1;
    }
    return 0;
}
