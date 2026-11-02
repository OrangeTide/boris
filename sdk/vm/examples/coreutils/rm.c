/* rm: remove each named file.  -f suppresses the error on a missing file. */

#include <unistd.h>
#include <string.h>

int
main(int argc, char **argv)
{
    int i, rc = 0, force = 0, start = 1;

    if (argc > 1 && strcmp(argv[1], "-f") == 0) {
        force = 1;
        start = 2;
    }
    for (i = start; i < argc; i++) {
        if (unlink(argv[i]) < 0 && !force) {
            write(2, "rm: cannot remove ", 18);
            write(2, argv[i], (int)strlen(argv[i]));
            write(2, "\n", 1);
            rc = 1;
        }
    }
    return rc;
}
