/* cp: copy the source file to the destination, creating or truncating it. */

#include <unistd.h>
#include <string.h>
#include <fcntl.h>

static void
oops(const char *msg)
{
    write(2, "cp: ", 4);
    write(2, msg, (int)strlen(msg));
    write(2, "\n", 1);
}

int
main(int argc, char **argv)
{
    char buf[1024];
    int in, out, n, rc = 0;

    if (argc != 3) {
        oops("usage: cp src dst");
        return 1;
    }
    in = open(argv[1], O_RDONLY, 0);
    if (in < 0) {
        oops("cannot open source");
        return 1;
    }
    out = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (out < 0) {
        oops("cannot create destination");
        close(in);
        return 1;
    }
    while ((n = read(in, buf, sizeof buf)) > 0) {
        int off = 0;
        while (off < n) {
            int w = write(out, buf + off, n - off);
            if (w <= 0) {
                rc = 1;
                goto done;
            }
            off += w;
        }
    }
    if (n < 0)
        rc = 1;
done:
    close(in);
    close(out);
    return rc;
}
