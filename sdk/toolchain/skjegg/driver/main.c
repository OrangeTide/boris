/* skjcc : the cross driver for the skj C toolchain.

   One command that runs the per-target pipeline the test scripts wire by hand:
   compile (skj-cc*, preprocessing is built in) -> assemble (skj-as*) -> link
   (skj-ld*), linking the right crt, the C library, and the runtime helpers.  A
   target is chosen with -target; the in-tree targets (coldfire, riscv, mips)
   are fully binutils-free, while x86-64 and arm64 shell out to the host as and ld.

   A link pulls in the crt, then the target's libc.a (a pull-only archive, so
   nothing a program does not reference is linked), then the runtime helpers
   (the 64-bit/_Float16/varargs support each target needs).  -ffreestanding (or
   its alias -nostdlib) drops the libc, linking only the crt and the helpers,
   for a program that provides its own environment. */

/* mkdtemp, fork, execvp, dup2 and friends are POSIX; expose their prototypes
   under -std=c99 so mkdtemp is not implicitly declared int (which would
   truncate its returned pointer on LP64). */
#define _DEFAULT_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <errno.h>

#include "version.h"
#include "exepath.h"

#ifndef SKJ_LIB_DIR
#define SKJ_LIB_DIR ""
#endif

#define MAXARGV 256

struct target {
    const char *names[3];       /* canonical name plus aliases, NULL-terminated */
    const char *cc;             /* compiler tool */
    const char *as;             /* assembler tool */
    const char *as_pre[4];      /* assembler flags before "-o out in" */
    const char *ld;             /* linker tool */
    const char *ld_pre[4];      /* linker flags before "-o out crt objs rt" */
    const char *crt0;           /* crt object basename under <libdir>/<name>/ */
    const char *runtime[4];     /* runtime helper basenames, NULL-terminated */
    const char *libc;           /* libc archive basename, linked unless -ffreestanding */
};

/* The table mirrors the check-cc-* Makefile recipes.  crt0/runtime names are
   looked up under <libdir>/<canonical-name>/, which the build stages. */
static const struct target targets[] = {
    { { "coldfire", "m68k", NULL },
      "skj-cc",
      "skj-as", { NULL },
      "skj-ld", { NULL },
      "crt0.o", { "half.o", "va_cf.o", NULL }, "libc.a" },
    { { "riscv", "rv32", NULL },
      "skj-cc-rv",
      "skj-as-rv", { NULL },
      "skj-ld-rv", { NULL },
      "crt0.o", { "va_rv.o", "soft64_div.o", NULL }, "libc.a" },
    { { "mips", NULL },
      "skj-cc-mips",
      "skj-as-mips", { NULL },
      "skj-ld-mips", { NULL },
      "crt0.o", { "half.o", "va_mips.o", "soft64_div.o", NULL }, "libc.a" },
    { { "x86-64", "x86_64", NULL },
      "skj-cc-x86-64",
      "skj-as-x86-64", { NULL },
      "skj-ld-x86-64", { NULL },
      "crt0.o", { "half.o", "va.o", NULL }, NULL },
    { { "arm64", "aarch64", NULL },
      "skj-cc-arm64",
      "skj-as-aarch64", { NULL },
      "skj-ld-arm64", { NULL },
      "crt0.o", { "va.o", NULL }, NULL },
};
#define NTARGETS ((int)(sizeof(targets) / sizeof(targets[0])))

static const char *progname = "skjcc";
static char self_dir[1024];     /* directory holding this driver, or "" */

static void
die(const char *fmt, ...)
{
    va_list ap;
    fprintf(stderr, "%s: ", progname);
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    fputc('\n', stderr);
    exit(1);
}

static int
is_executable(const char *path)
{
    return access(path, X_OK) == 0;
}

/* Resolve a tool: a skj-* tool sitting beside this driver wins (so an in-tree
   build/skjcc finds build/skj-cc-rv); otherwise the bare name goes through PATH
   at exec time.  Returned storage is a static ring, enough for one pipeline. */
static const char *
tool_path(const char *name)
{
    static char buf[4][1024];
    static int which;
    char *b = buf[which++ & 3];
    size_t dl = strlen(self_dir), nl = strlen(name);

    /* build "<self_dir>/<name>" with an explicit bound (no snprintf, so there
       is no spurious -Wformat-truncation on the unbounded name) */
    if (self_dir[0] && strncmp(name, "skj", 3) == 0 &&
        dl + 1 + nl < sizeof buf[0]) {
        memcpy(b, self_dir, dl);
        b[dl] = '/';
        memcpy(b + dl + 1, name, nl + 1);
        if (is_executable(b))
            return b;
    }
    return name;                /* execvp searches PATH */
}

/* fork/exec argv (NULL-terminated), redirecting stdout to outfd when >= 0.
   Returns the child's exit status (0 on success). */
static int
run(const char *const argv[], int outfd)
{
    pid_t pid = fork();
    if (pid < 0)
        die("fork: %s", strerror(errno));
    if (pid == 0) {
        if (outfd >= 0) {
            if (dup2(outfd, 1) < 0)
                _exit(127);
            if (outfd != 1)
                close(outfd);
        }
        execvp(argv[0], (char *const *)argv);
        fprintf(stderr, "%s: cannot run %s: %s\n", progname, argv[0],
                strerror(errno));
        _exit(127);
    }
    int status;
    while (waitpid(pid, &status, 0) < 0)
        if (errno != EINTR)
            die("waitpid: %s", strerror(errno));
    if (WIFEXITED(status))
        return WEXITSTATUS(status);
    return 128 + (WIFSIGNALED(status) ? WTERMSIG(status) : 0);
}

static const struct target *
find_target(const char *name)
{
    for (int i = 0; i < NTARGETS; i++)
        for (int j = 0; targets[i].names[j]; j++)
            if (strcmp(name, targets[i].names[j]) == 0)
                return &targets[i];
    return NULL;
}

static const char *
lib_dir(void)
{
    const char *d = getenv("SKJ_CC_LIB");
    if (d && *d)
        return d;
    /* A relocated install keeps the per-target runtime at <bindir>/../lib/skjegg
       beside this driver.  Prefer it over the baked build-tree path when it is
       actually present, so an installed copy works with nothing in the
       environment; an in-tree build has no such directory and falls through.
       The candidate is heap-allocated and sized exactly (not a fixed on-stack
       array), so there is no truncation and the callers' path snprintf stay
       free of -Wformat-truncation (a bounded source array would bound libd and
       make gcc flag the downstream concatenation). */
    if (self_dir[0]) {
        static const char suffix[] = "/../lib/skjegg";
        size_t dl = strlen(self_dir);
        char *buf = malloc(dl + sizeof suffix);
        if (buf) {
            memcpy(buf, self_dir, dl);
            memcpy(buf + dl, suffix, sizeof suffix);
            if (access(buf, F_OK) == 0)
                return buf;
            free(buf);
        }
    }
    if (SKJ_LIB_DIR[0])
        return SKJ_LIB_DIR;
    return "lib";
}

/* strip a directory and a trailing ".c" from a path, into a fresh string */
static char *
stem(const char *path)
{
    const char *base = strrchr(path, '/');
    base = base ? base + 1 : path;
    size_t n = strlen(base);
    if (n > 2 && base[n - 2] == '.' && base[n - 1] == 'c')
        n -= 2;
    char *s = malloc(n + 1);
    if (!s)
        die("out of memory");
    memcpy(s, base, n);
    s[n] = '\0';
    return s;
}

static int
has_suffix(const char *s, const char *suf)
{
    size_t ls = strlen(s), lu = strlen(suf);
    return ls >= lu && strcmp(s + ls - lu, suf) == 0;
}

static void
usage(FILE *f)
{
    fprintf(f,
        "usage: %s -target <name> [-c|-S|-E] [-o out] [-I dir] [-D name[=val]]\n"
        "          [-ffreestanding] [-save-temps] file.c... [file.o...]\n"
        "targets:", progname);
    for (int i = 0; i < NTARGETS; i++)
        fprintf(f, " %s", targets[i].names[0]);
    fprintf(f, "\n");
}

int
main(int argc, char **argv)
{
    const char *tname = NULL;
    const char *outpath = NULL;
    int stop_s = 0, stop_c = 0, stop_e = 0, save_temps = 0;
    int freestanding = 0;           /* -ffreestanding: link only the crt */
    const char *cc_opts[MAXARGV];   /* -I / -D passthrough to the compile */
    int ncc_opts = 0;
    const char *srcs[MAXARGV];      /* .c inputs */
    int nsrcs = 0;
    const char *objs[MAXARGV];      /* .o / .a inputs passed to the link */
    int nobjs = 0;

    /* record our own directory for tool/lib discovery */
    skj_exe_dir(argv[0], self_dir, sizeof self_dir);

    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (strcmp(a, "-target") == 0) {
            if (++i >= argc) die("-target needs an argument");
            tname = argv[i];
        } else if (strncmp(a, "-target=", 8) == 0) {
            tname = a + 8;
        } else if (strcmp(a, "-o") == 0) {
            if (++i >= argc) die("-o needs an argument");
            outpath = argv[i];
        } else if (strcmp(a, "-c") == 0) {
            stop_c = 1;
        } else if (strcmp(a, "-S") == 0) {
            stop_s = 1;
        } else if (strcmp(a, "-E") == 0) {
            stop_e = 1;
        } else if (strcmp(a, "-save-temps") == 0) {
            save_temps = 1;
        } else if (strcmp(a, "-ffreestanding") == 0 ||
                   strcmp(a, "-nostdlib") == 0) {
            freestanding = 1;
        } else if (strncmp(a, "-I", 2) == 0 || strncmp(a, "-D", 2) == 0) {
            /* keep the flag; if it is a bare -I/-D, take the next arg too */
            if (ncc_opts + 2 >= MAXARGV) die("too many options");
            cc_opts[ncc_opts++] = a;
            if (a[2] == '\0') {
                if (++i >= argc) die("%s needs an argument", a);
                cc_opts[ncc_opts++] = argv[i];
            }
        } else if (strcmp(a, "-g") == 0) {
            /* forward to the compile stage: skj-cc emits DWARF under -g, which
               the assembler carries and the linker relocates into the output. */
            if (ncc_opts + 1 >= MAXARGV) die("too many options");
            cc_opts[ncc_opts++] = a;
        } else if (strcmp(a, "--version") == 0 || strcmp(a, "-V") == 0) {
            printf("skjcc %s\n", SKJ_VERSION);
            return 0;
        } else if (strcmp(a, "--help") == 0 || strcmp(a, "-h") == 0) {
            usage(stdout);
            return 0;
        } else if (a[0] == '-') {
            /* ignore unknown -O/-W... flags the backends do not consume */
        } else if (has_suffix(a, ".c")) {
            if (nsrcs >= MAXARGV) die("too many inputs");
            srcs[nsrcs++] = a;
        } else if (has_suffix(a, ".o") || has_suffix(a, ".a") ||
                   has_suffix(a, ".s")) {
            if (nobjs >= MAXARGV) die("too many inputs");
            objs[nobjs++] = a;
        } else {
            die("unrecognized input '%s'", a);
        }
    }

    if (!tname)
        tname = getenv("SKJ_CC_TARGET");
    if (!tname)
        tname = "coldfire";             /* compiled-in default */
    const struct target *t = find_target(tname);
    if (!t)
        die("unknown target '%s' (see --help)", tname);

    if (nsrcs == 0 && nobjs == 0)
        die("no input files");
    if (stop_s + stop_c + stop_e > 1)
        die("-c, -S and -E are mutually exclusive");

    /* -E: preprocess each source to stdout (or -o), via skj-cpp */
    if (stop_e) {
        int outfd = 1;
        if (outpath && strcmp(outpath, "-") != 0) {
            outfd = creat(outpath, 0644);
            if (outfd < 0) die("cannot create %s: %s", outpath, strerror(errno));
        }
        for (int s = 0; s < nsrcs; s++) {
            const char *av[MAXARGV];
            int n = 0;
            av[n++] = tool_path("skj-cpp");
            for (int k = 0; k < ncc_opts; k++) av[n++] = cc_opts[k];
            av[n++] = srcs[s];
            av[n] = NULL;
            if (run(av, outfd) != 0) die("preprocess failed for %s", srcs[s]);
        }
        if (outfd != 1) close(outfd);
        return 0;
    }

    /* a temp directory for intermediates, unless -save-temps.  -S needs none
       (its only artifact is the .s); -c and a full link both produce an
       intermediate .s (and the link an intermediate .o). */
    char tmpl[] = "/tmp/skjccXXXXXX";
    char *tmpdir = NULL;
    if (!save_temps && !stop_s) {
        tmpdir = mkdtemp(tmpl);
        if (!tmpdir) die("mkdtemp: %s", strerror(errno));
    }

    /* where an intermediate .s/.o for input `src` lands.  -S/-c put the final
       artifact in the CWD (or -o); the link path uses the temp dir. */
    char link_objs[MAXARGV][1024];
    int nlink = 0;

    for (int s = 0; s < nsrcs; s++) {
        char *st = stem(srcs[s]);
        char spath[1024], opath[1024];

        if (stop_s && outpath && nsrcs == 1)
            snprintf(spath, sizeof spath, "%s", outpath);
        else if (stop_s || save_temps)
            snprintf(spath, sizeof spath, "%s.s", st);
        else
            snprintf(spath, sizeof spath, "%s/%s.s", tmpdir, st);

        /* compile: cc -o out.s [opts] in.c */
        {
            const char *av[MAXARGV];
            int n = 0;
            av[n++] = tool_path(t->cc);
            av[n++] = "-o";
            av[n++] = spath;
            for (int k = 0; k < ncc_opts; k++) av[n++] = cc_opts[k];
            av[n++] = srcs[s];
            av[n] = NULL;
            if (run(av, -1) != 0) die("compile failed for %s", srcs[s]);
        }
        if (stop_s) { free(st); continue; }

        if (stop_c && outpath && nsrcs == 1)
            snprintf(opath, sizeof opath, "%s", outpath);
        else if (stop_c || save_temps)
            snprintf(opath, sizeof opath, "%s.o", st);
        else
            snprintf(opath, sizeof opath, "%s/%s.o", tmpdir, st);

        /* assemble: as <pre...> -o out.o in.s */
        {
            const char *av[MAXARGV];
            int n = 0;
            av[n++] = tool_path(t->as);
            for (int k = 0; t->as_pre[k]; k++) av[n++] = t->as_pre[k];
            av[n++] = "-o";
            av[n++] = opath;
            av[n++] = spath;
            av[n] = NULL;
            if (run(av, -1) != 0) die("assemble failed for %s", srcs[s]);
        }
        if (!stop_c) {
            snprintf(link_objs[nlink], sizeof link_objs[0], "%s", opath);
            nlink++;
        }
        free(st);
    }

    if ((stop_s || stop_c) && outpath && nsrcs != 1)
        die("-o with %s requires a single input", stop_s ? "-S" : "-c");

    /* link: ld <pre...> -o out crt0 objs... passed-objs... runtime... */
    if (!stop_s && !stop_c) {
        const char *libd = lib_dir();
        char crt0[1024];
        char fini[1024];
        char libc[1024];
        char rtbuf[8][1024];
        snprintf(crt0, sizeof crt0, "%s/%s/%s", libd, t->names[0], t->crt0);

        const char *av[MAXARGV];
        int n = 0;
        av[n++] = tool_path(t->ld);
        for (int k = 0; t->ld_pre[k]; k++) av[n++] = t->ld_pre[k];
        av[n++] = "-o";
        av[n++] = outpath ? outpath : "a.out";
        av[n++] = crt0;
        for (int k = 0; k < nlink; k++) av[n++] = link_objs[k];
        for (int k = 0; k < nobjs; k++) av[n++] = objs[k];
        /* The libc archive sits after the program objects (which reference it)
           and before the runtime helpers (which it may reference), so the
           pull-only archive linker resolves each in one left-to-right pass. */
        if (!freestanding && t->libc) {
            /* fini.o is force-linked (the crt's weak __libc_fini resolves to
               it), then the pull-only archive. */
            snprintf(fini, sizeof fini, "%s/%s/fini.o", libd, t->names[0]);
            av[n++] = fini;
            snprintf(libc, sizeof libc, "%s/%s/%s", libd, t->names[0], t->libc);
            av[n++] = libc;
        }
        int nrt = 0;
        for (int k = 0; t->runtime[k]; k++) {
            snprintf(rtbuf[nrt], sizeof rtbuf[0], "%s/%s/%s",
                     libd, t->names[0], t->runtime[k]);
            av[n++] = rtbuf[nrt++];
        }
        av[n] = NULL;
        if (run(av, -1) != 0) die("link failed");
    }

    /* clean up the temp directory */
    if (tmpdir) {
        for (int k = 0; k < nlink; k++)
            unlink(link_objs[k]);
        /* the .s intermediates share the stem; remove them too */
        for (int s = 0; s < nsrcs; s++) {
            char *st = stem(srcs[s]);
            char p[1024];
            snprintf(p, sizeof p, "%s/%s.s", tmpdir, st);
            unlink(p);
            free(st);
        }
        rmdir(tmpdir);
    }
    return 0;
}
