/* sleep: park for the given whole number of seconds.  nanosleep is the crt's
 * park syscall; the guest timespec is two target-endian 32-bit words. */

extern int nanosleep(const void *req, void *rem);

struct gtimespec {
    unsigned sec;
    unsigned nsec;
};

int
main(int argc, char **argv)
{
    struct gtimespec ts;
    unsigned sec = 0;
    const char *p;

    if (argc < 2)
        return 1;
    for (p = argv[1]; *p >= '0' && *p <= '9'; p++)
        sec = sec * 10 + (unsigned)(*p - '0');
    ts.sec = sec;
    ts.nsec = 0;
    nanosleep(&ts, 0);
    return 0;
}
