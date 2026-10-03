/* rv_main.c : driver for skj-as-rv, the RISC-V RV32 assembler */

#include "rv.h"
#include "version.h"

#include <stdlib.h>
#include <string.h>

static void
cleanup_rv(void *p)
{
    rv_free(p);
}

static void
cleanup_free(void *p)
{
    free(p);
}

static void
usage(void)
{
    fprintf(stderr,
        "usage: skj-as-rv [-o output.o] input.s\n"
        "\n"
        "RISC-V RV32 assembler (GAS syntax subset).\n"
        "Reads assembly text and produces ELF32 little-endian EM_RISCV\n"
        "relocatable objects.  Covers RV32IMAFD + Zfh + Zicsr +\n"
        "Zba/Zbb/Zbs and the backend's pseudo-instructions.\n"
        "\n"
        "options:\n"
        "  -o FILE   write output to FILE (default: stdout)\n"
        "  -h        show this help\n"
        "  -V        show version\n");
}

int
main(int argc, char **argv)
{
    const char *outpath;
    const char *inpath;
    FILE *out;
    char *src;
    struct rv_asm a;
    int k;

    util_set_progname("skj-as-rv");

    outpath = NULL;
    inpath = NULL;
    for (k = 1; k < argc; k++) {
        if (strcmp(argv[k], "-h") == 0) {
            usage();
            return 0;
        }
        if (strcmp(argv[k], "-V") == 0) {
            printf("skj-as-rv %s\n", SKJ_VERSION);
            return 0;
        }
        if (strcmp(argv[k], "-o") == 0 && k + 1 < argc) {
            outpath = argv[++k];
        } else if (argv[k][0] == '-') {
            die("unknown option: %s", argv[k]);
        } else {
            if (inpath)
                die("multiple input files");
            inpath = argv[k];
        }
    }

    if (!inpath) {
        usage();
        return 1;
    }

    if (setjmp(util_die_env) != 0)
        return 1;
    util_die_active = 1;

    src = slurp(inpath);
    util_cleanup_push(cleanup_free, src);

    rv_init(&a, src);
    util_cleanup_push(cleanup_rv, &a);

    rv_assemble(&a);

    if (outpath) {
        out = fopen(outpath, "wb");
        if (!out)
            die("cannot open %s for writing", outpath);
    } else {
        out = stdout;
    }

    rv_elf_write(&a, out);

    if (outpath)
        fclose(out);

    util_cleanup_run();

    return 0;
}
