/* cat: copy each named file to stdout, or stdin when given no file. */

#include <unistd.h>
#include <string.h>
#include <fcntl.h>

static int
drain(int fd)
{
    char buf[1024];
    int n;

    while ((n = read(fd, buf, sizeof buf)) > 0) {
        int off = 0;
        while (off < n) {
            int w = write(1, buf + off, n - off);
            if (w <= 0)
                return -1;
            off += w;
        }
    }
    return n < 0 ? -1 : 0;
}

static void
oops(const char *path)
{
    write(2, "cat: cannot open ", 17);
    write(2, path, (int)strlen(path));
    write(2, "\n", 1);
}

int
main(int argc, char **argv)
{
    int i, rc = 0;

    if (argc < 2)
        return drain(0) < 0 ? 1 : 0;
    for (i = 1; i < argc; i++) {
        int fd = open(argv[i], O_RDONLY, 0);
        if (fd < 0) {
            oops(argv[i]);
            rc = 1;
            continue;
        }
        if (drain(fd) < 0)
            rc = 1;
        close(fd);
    }
    return rc;
}
