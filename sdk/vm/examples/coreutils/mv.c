/* mv: rename the source to the destination within a mount.  The fs/ rename op
 * backs this; a cross-mount move is not supported (rename reports the error). */

#include <unistd.h>
#include <string.h>

int rename(const char *oldpath, const char *newpath);

int
main(int argc, char **argv)
{
    if (argc != 3) {
        write(2, "usage: mv src dst\n", 18);
        return 1;
    }
    if (rename(argv[1], argv[2]) < 0) {
        write(2, "mv: cannot rename ", 18);
        write(2, argv[1], (int)strlen(argv[1]));
        write(2, "\n", 1);
        return 1;
    }
    return 0;
}
