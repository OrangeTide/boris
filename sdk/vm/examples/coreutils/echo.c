/* echo: write the arguments to stdout, separated by spaces.  -n drops the
 * trailing newline.  A spawned program over skjegg's libc and fs/ layer. */

#include <unistd.h>
#include <string.h>

int
main(int argc, char **argv)
{
    int i = 1, nflag = 0;

    if (i < argc && strcmp(argv[i], "-n") == 0) {
        nflag = 1;
        i++;
    }
    for (; i < argc; i++) {
        write(1, argv[i], (int)strlen(argv[i]));
        if (i + 1 < argc)
            write(1, " ", 1);
    }
    if (!nflag)
        write(1, "\n", 1);
    return 0;
}
