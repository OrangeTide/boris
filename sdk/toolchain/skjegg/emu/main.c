/* main.c : skj-run driver — run a guest ELF on an in-tree emulator */

#include "elf32.h"
#include "elf64.h"
#include "guest.h"
#include "version.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Each architecture is an optional component: a project that vendors only
 * one emulator builds skj-run with only that one compiled in. */
#ifndef EMU_COLDFIRE
#define EMU_COLDFIRE 1
#endif
#ifndef EMU_RV32
#define EMU_RV32 1
#endif
#ifndef EMU_MIPS32
#define EMU_MIPS32 1
#endif
#ifndef EMU_HV
#define EMU_HV 1
#endif

#define DEFAULT_MEM     (256u * 1024u * 1024u)
#define DEFAULT_STACK   (1u * 1024u * 1024u)
#define DEFAULT_HEAP    (16u * 1024u * 1024u)

static void
usage(FILE *out)
{
    fprintf(out,
        "usage: skj-run [options] program.elf [args...]\n"
        "\n"
        "Run a 32-bit guest program on the built-in emulator.  The\n"
        "architecture comes from the ELF header; --arch overrides it.\n"
        "\n"
        "options:\n"
        "  --arch NAME     guest architecture:"
#if EMU_COLDFIRE
        " coldfire"
#endif
#if EMU_RV32
        " rv32"
#endif
#if EMU_MIPS32
        " mips32"
#endif
#if EMU_HV
        " x86-64 arm64"
#endif
        "\n"
        "  --mem BYTES     cap on guest memory (default 256M)\n"
        "  --stack BYTES   guest stack size (default 1M)\n"
        "  --heap BYTES    guest heap size for brk (default 16M)\n"
        "  --max-insns N   stop after N instructions (default unlimited)\n"
        "  --gdb PORT      serve the GDB remote protocol on PORT\n"
        "  --mount NAME:DIR  grant the guest a confined host directory\n"
        "  --mount-ro NAME:DIR  the same, read-only (mutating ops fail EROFS)\n"
        "  --vdso IMG      map a vDSO image of pure leaf functions, found via auxv\n"
        "  --mem-root      load the program image from memory, not by reopening it\n"
        "  --env KEY=VALUE  add an environment entry (repeatable)\n"
        "  --dev NAME      grant the guest a devfs mount (null/zero/full)\n"
        "  --rom NAME:IMG  grant the guest a read-only romfs image\n"
        "  --9p NAME:DIR   serve a host directory to the guest over 9P2000\n"
        "  --total-mem BYTES  aggregate memory cap across all processes\n"
        "  --child-max-insns N  per-spawned-child instruction budget\n"
        "  --trace         dump the CPU event ring on a fault\n"
        "  --stats         report instruction and syscall counts\n"
        "  -q, --quiet     discard guest output\n"
        "  --version       print the version and exit\n"
        "  -h, --help      print this message and exit\n"
        "\n"
        "A size accepts a K, M or G suffix.  The exit status is the\n"
        "guest's; a guest killed by a fault reports 128 plus the signal\n"
        "a host kernel would have raised.\n");
}

/** Parse a size with an optional K/M/G suffix.  Returns 0 on error. */
static uint64_t
parse_size(const char *s)
{
    char *end;
    unsigned long long v = strtoull(s, &end, 0);

    if (end == s)
        return 0;
    switch (*end) {
    case 'k': case 'K': v *= 1024ull; end++; break;
    case 'm': case 'M': v *= 1024ull * 1024ull; end++; break;
    case 'g': case 'G': v *= 1024ull * 1024ull * 1024ull; end++; break;
    default: break;
    }
    if (*end)
        return 0;
    return v;
}

static int
arch_of_name(const char *name)
{
    if (strcmp(name, "coldfire") == 0 || strcmp(name, "cf") == 0 ||
        strcmp(name, "m68k") == 0)
        return GUEST_ARCH_COLDFIRE;
    if (strcmp(name, "rv32") == 0 || strcmp(name, "riscv32") == 0 ||
        strcmp(name, "riscv") == 0)
        return GUEST_ARCH_RV32;
    if (strcmp(name, "mips32") == 0 || strcmp(name, "mipsel") == 0 ||
        strcmp(name, "mips") == 0)
        return GUEST_ARCH_MIPS32;
    if (strcmp(name, "x86-64") == 0 || strcmp(name, "x86_64") == 0 ||
        strcmp(name, "x86-64hv") == 0 || strcmp(name, "amd64") == 0)
        return GUEST_ARCH_X86_64;
    if (strcmp(name, "arm64") == 0 || strcmp(name, "aarch64") == 0 ||
        strcmp(name, "arm64hv") == 0)
        return GUEST_ARCH_AARCH64;
    return GUEST_ARCH_NONE;
}

/* The ELF class byte (EI_CLASS): 1 = ELF32, 2 = ELF64, 0 if unreadable. */
static int
elf_class(const char *path)
{
    FILE *f = fopen(path, "rb");
    unsigned char id[6];
    size_t n;

    if (!f)
        return 0;
    n = fread(id, 1, sizeof id, f);
    fclose(f);
    if (n < sizeof id || memcmp(id, "\177ELF", 4) != 0)
        return 0;
    return id[4];
}

static int
arch_of_machine(uint32_t machine)
{
    switch (machine) {
    case EM_68K:    return GUEST_ARCH_COLDFIRE;
    case EM_MIPS:   return GUEST_ARCH_MIPS32;
    case EM_RISCV:  return GUEST_ARCH_RV32;
    default:        return GUEST_ARCH_NONE;
    }
}

int
main(int argc, char **argv)
{
    run_opts o;
    char *envv[64];                     /* --env entries, pointed at by o.envp */
    elf32_info info;
    int arch = GUEST_ARCH_NONE;
    int status = 0;
    int load_mem = 0;                   /* --mem: load the root image from memory */
    uint8_t *root_buf = NULL;
    int i;

    memset(&o, 0, sizeof(o));
    o.mem_limit = DEFAULT_MEM;
    o.stack_size = DEFAULT_STACK;
    o.heap_size = DEFAULT_HEAP;

    for (i = 1; i < argc; i++) {
        const char *a = argv[i];

        if (a[0] != '-' || a[1] == '\0')
            break;
        if (strcmp(a, "--") == 0) {
            i++;
            break;
        }
        if (strcmp(a, "-h") == 0 || strcmp(a, "--help") == 0) {
            usage(stdout);
            return 0;
        }
        if (strcmp(a, "--version") == 0) {
            printf("skj-run %s\n", SKJ_VERSION);
            return 0;
        }
        if (strcmp(a, "-q") == 0 || strcmp(a, "--quiet") == 0) {
            o.quiet = 1;
            continue;
        }
        if (strcmp(a, "--trace") == 0) {
            o.trace = 1;
            continue;
        }
        if (strcmp(a, "--stats") == 0) {
            o.stats = 1;
            continue;
        }
        if (strcmp(a, "--arch") == 0 && i + 1 < argc) {
            arch = arch_of_name(argv[++i]);
            if (arch == GUEST_ARCH_NONE) {
                fprintf(stderr, "skj-run: unknown architecture '%s'\n",
                        argv[i]);
                return 2;
            }
            continue;
        }
        if (strcmp(a, "--mem") == 0 && i + 1 < argc) {
            o.mem_limit = parse_size(argv[++i]);
            if (!o.mem_limit) {
                fprintf(stderr, "skj-run: bad size '%s'\n", argv[i]);
                return 2;
            }
            continue;
        }
        if (strcmp(a, "--stack") == 0 && i + 1 < argc) {
            o.stack_size = (uint32_t)parse_size(argv[++i]);
            if (!o.stack_size) {
                fprintf(stderr, "skj-run: bad size '%s'\n", argv[i]);
                return 2;
            }
            continue;
        }
        if (strcmp(a, "--heap") == 0 && i + 1 < argc) {
            o.heap_size = (uint32_t)parse_size(argv[++i]);
            if (!o.heap_size) {
                fprintf(stderr, "skj-run: bad size '%s'\n", argv[i]);
                return 2;
            }
            continue;
        }
        if (strcmp(a, "--max-insns") == 0 && i + 1 < argc) {
            o.max_insns = parse_size(argv[++i]);
            continue;
        }
        if (strcmp(a, "--gdb") == 0 && i + 1 < argc) {
            o.gdb_port = (int)strtol(argv[++i], NULL, 0);
            if (o.gdb_port <= 0 || o.gdb_port > 65535) {
                fprintf(stderr, "skj-run: bad gdb port '%s'\n", argv[i]);
                return 2;
            }
            continue;
        }
        if (strcmp(a, "--total-mem") == 0 && i + 1 < argc) {
            o.total_mem = parse_size(argv[++i]);
            continue;
        }
        if (strcmp(a, "--child-max-insns") == 0 && i + 1 < argc) {
            o.child_max_insns = parse_size(argv[++i]);
            continue;
        }
        if (strcmp(a, "--mount") == 0 && i + 1 < argc) {
            if (o.nmounts >= RUN_MAX_MOUNTS) {
                fprintf(stderr, "skj-run: too many --mount options\n");
                return 2;
            }
            o.mounts[o.nmounts++] = argv[++i];
            continue;
        }
        if (strcmp(a, "--vdso") == 0 && i + 1 < argc) {
            o.vdso = argv[++i];
            continue;
        }
        if (strcmp(a, "--mem-root") == 0) {
            load_mem = 1;               /* load the root image from memory */
            continue;
        }
        if (strcmp(a, "--env") == 0 && i + 1 < argc) {
            if (o.envc >= (int)(sizeof(envv) / sizeof(envv[0]))) {
                fprintf(stderr, "skj-run: too many --env options\n");
                return 2;
            }
            envv[o.envc++] = argv[++i];     /* a "KEY=VALUE" entry */
            o.envp = envv;
            continue;
        }
        if (strcmp(a, "--mount-ro") == 0 && i + 1 < argc) {
            if (o.nmounts_ro >= RUN_MAX_MOUNTS) {
                fprintf(stderr, "skj-run: too many --mount-ro options\n");
                return 2;
            }
            o.mounts_ro[o.nmounts_ro++] = argv[++i];
            continue;
        }
        if (strcmp(a, "--dev") == 0 && i + 1 < argc) {
            if (o.ndevs >= RUN_MAX_MOUNTS) {
                fprintf(stderr, "skj-run: too many --dev options\n");
                return 2;
            }
            o.devs[o.ndevs++] = argv[++i];
            continue;
        }
        if (strcmp(a, "--rom") == 0 && i + 1 < argc) {
            if (o.nroms >= RUN_MAX_MOUNTS) {
                fprintf(stderr, "skj-run: too many --rom options\n");
                return 2;
            }
            o.roms[o.nroms++] = argv[++i];
            continue;
        }
        if (strcmp(a, "--9p") == 0 && i + 1 < argc) {
            if (o.np9s >= RUN_MAX_MOUNTS) {
                fprintf(stderr, "skj-run: too many --9p options\n");
                return 2;
            }
            o.p9s[o.np9s++] = argv[++i];
            continue;
        }
        fprintf(stderr, "skj-run: unknown option '%s'\n", a);
        usage(stderr);
        return 2;
    }

    if (i >= argc) {
        usage(stderr);
        return 2;
    }

    o.path = argv[i];
    o.argv = argv + i;
    o.argc = argc - i;

    /* --mem: read the root ELF into memory and run it from there, the way an
     * embedding host whose images are byte buffers does (sched_root.image).  The
     * path still names the file for arch detection below and labels diagnostics. */
    if (load_mem) {
        FILE *f = fopen(o.path, "rb");
        long n;

        if (!f || fseek(f, 0, SEEK_END) != 0 || (n = ftell(f)) < 0) {
            fprintf(stderr, "skj-run: cannot read %s into memory\n", o.path);
            if (f) fclose(f);
            return 2;
        }
        rewind(f);
        root_buf = malloc((size_t)n);
        if (!root_buf || fread(root_buf, 1, (size_t)n, f) != (size_t)n) {
            fprintf(stderr, "skj-run: cannot read %s into memory\n", o.path);
            free(root_buf);
            fclose(f);
            return 2;
        }
        fclose(f);
        o.root_image = root_buf;
        o.root_image_len = n;
    }

    if (arch == GUEST_ARCH_NONE) {
        /* Pick the loader by ELF class: ELF32 for the emulated 32-bit cores,
         * ELF64 for the hardware-virtualization guests. */
        int cls = elf_class(o.path);

        if (cls == 2) {
            if (elf64_probe(o.path, &info) != 0)
                return 2;
            if (info.machine == EM_X86_64)
                arch = GUEST_ARCH_X86_64;
            else if (info.machine == EM_AARCH64)
                arch = GUEST_ARCH_AARCH64;
        } else {
            if (elf32_probe(o.path, &info) != 0)
                return 2;
            arch = arch_of_machine(info.machine);
        }
        if (arch == GUEST_ARCH_NONE) {
            fprintf(stderr, "skj-run: %s targets an unsupported machine "
                    "(e_machine %u)\n", o.path, info.machine);
            return 2;
        }
    }

    switch (arch) {
#if EMU_COLDFIRE
    case GUEST_ARCH_COLDFIRE:
        if (run_coldfire(&o, &status) != 0)
            return 2;
        break;
#endif
#if EMU_RV32
    case GUEST_ARCH_RV32:
        if (run_rv32(&o, &status) != 0)
            return 2;
        break;
#endif
#if EMU_MIPS32
    case GUEST_ARCH_MIPS32:
        if (run_mips32(&o, &status) != 0)
            return 2;
        break;
#endif
#if EMU_HV
    case GUEST_ARCH_X86_64:
        if (run_x86_64hv(&o, &status) != 0)
            return 2;
        break;
    case GUEST_ARCH_AARCH64:
        if (run_arm64hv(&o, &status) != 0)
            return 2;
        break;
#endif
    default:
        fprintf(stderr, "skj-run: this build has no emulator for that "
                "architecture\n");
        free(root_buf);
        return 2;
    }

    free(root_buf);
    return status;
}
