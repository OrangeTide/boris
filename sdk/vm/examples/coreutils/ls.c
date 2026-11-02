/* ls: list the entries of each named directory, or the current directory when
 * given no argument.  One name per line; the . and .. entries are skipped. */

#include <unistd.h>
#include <string.h>
#include <dirent.h>

static int
list(const char *path)
{
    DIR *d = opendir(path);
    struct dirent *e;

    if (!d) {
        write(2, "ls: cannot open ", 16);
        write(2, path, (int)strlen(path));
        write(2, "\n", 1);
        return 1;
    }
    while ((e = readdir(d)) != NULL) {
        if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0)
            continue;
        write(1, e->d_name, (int)strlen(e->d_name));
        write(1, "\n", 1);
    }
    closedir(d);
    return 0;
}

int
main(int argc, char **argv)
{
    int i, rc = 0;

    if (argc < 2)
        return list(".");
    for (i = 1; i < argc; i++)
        rc |= list(argv[i]);
    return rc;
}
