/* main.c : skj-cc C compiler driver */

#define _DEFAULT_SOURCE         /* expose readlink() under -std=c99 (exepath.h) */

#include "cc.h"
#include "cpp.h"
#include "arena.h"
#include "version.h"
#include "exepath.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


static void
cleanup_arena(void *p)
{
    arena_free(p);
}

static void
cleanup_cpp(void *p)
{
    cpp_free(p);
}

#define CC_USAGE "usage: skj-cc [-V] [-o out.s] [-I path] [-D name[=val]] input.c"

static void
usage(FILE *out)
{
    fprintf(out, "%s\n", CC_USAGE);
}

int
main(int argc, char **argv)
{
    const char *inpath;
    const char *outpath;
    int preprocess_only;
    struct cpp *pp;
    /* The whole translation unit after preprocessing lives here.  It is 2 MiB
       (static, not on the stack) so a source that embeds a data blob as a byte
       array, like the sandbox demos' guest-image headers, fits; 64 KiB did
       not, and 1 MiB stopped fitting once the embedded Kobold child ELF crossed
       ~170 KiB (xxd -i expands each byte to about six source bytes). */
    static char ppbuf[1u << 21];
    int pplen;
    char linebuf[4096];
    int n;
    struct cc_node *ast;
    struct ir_program *prog;
    struct ir_func *fn;
    FILE *out;
    struct arena a;

    util_set_progname("skj-cc");

    arena_init(&a);
    pp = cpp_new();

    /* Target identification macros, predefined so a libc header can size its
       own types and select per-target code.  The compiler ships none of gcc's
       builtin target macros, so these are the only signal a header has.  They
       are set before the command line is scanned, so a user -D still wins.  One
       target id is defined, plus the data model (__skj_lp64__ on x86-64 and
       arm64, __skj_ilp32__ on the 32-bit targets, where pointer, long, and
       size_t are all one machine word). */
    cpp_define(pp, "__skj__", "1");
#if defined(CC_M68K)
    cpp_define(pp, "__skj_m68k__", "1");
#elif defined(CC_RISCV)
    cpp_define(pp, "__skj_riscv__", "1");
#elif defined(CC_MIPS)
    cpp_define(pp, "__skj_mips__", "1");
#elif defined(CC_ARM64)
    cpp_define(pp, "__skj_arm64__", "1");
#elif defined(X86_BITS) && X86_BITS == 64
    cpp_define(pp, "__skj_x86_64__", "1");
#endif
#if SKJ_LP64
    cpp_define(pp, "__skj_lp64__", "1");
#else
    cpp_define(pp, "__skj_ilp32__", "1");
#endif

    inpath = NULL;
    outpath = NULL;
    preprocess_only = 0;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-o") == 0 && i + 1 < argc) {
            outpath = argv[++i];
        } else if (strncmp(argv[i], "-I", 2) == 0) {
            const char *path = argv[i][2] ? &argv[i][2] : argv[++i];
            cpp_add_include_path(pp, path);
        } else if (strncmp(argv[i], "-D", 2) == 0) {
            const char *def = argv[i][2] ? &argv[i][2] : argv[++i];
            char *eq = strchr(def, '=');
            if (eq) {
                char name[256];
                int len = (int)(eq - def);
                if (len >= (int)sizeof(name)) len = (int)sizeof(name) - 1;
                memcpy(name, def, len);
                name[len] = '\0';
                cpp_define(pp, name, eq + 1);
            } else {
                cpp_define(pp, def, "1");
            }
        } else if (strcmp(argv[i], "-V") == 0) {
            printf("skj-cc %s\n", SKJ_VERSION);
            cpp_free(pp);
            return 0;
        } else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            usage(stdout);
            cpp_free(pp);
            return 0;
        } else if (strcmp(argv[i], "-E") == 0) {
            preprocess_only = 1;
        } else if (strcmp(argv[i], "-g") == 0) {
            cc_debug = 1;
        } else if (argv[i][0] == '-') {
            /* ignore unknown options silently */
        } else {
            inpath = argv[i];
        }
    }

    if (!inpath)
        die("%s", CC_USAGE);

    /* Default search path for skj-provided headers (e.g. <stdarg.h>), added
       after any -I so user paths win.  Resolution order: the SKJ_CC_INCLUDE
       environment variable (explicit override); then, for a relocated install,
       <bindir>/../lib/skjegg/include beside this compiler, when present; then
       the SKJ_INCLUDE_DIR baked in at build time (the in-tree build tree). */
    {
        const char *inc = getenv("SKJ_CC_INCLUDE");
#ifndef __skj__
        /* The relocated-install probe (resolve headers beside the binary) is a
           host-tool feature; it uses access(), which the self-hosting skjegg
           libc does not provide.  A guest-built compiler (__skj__) skips it and
           uses the env or baked path below. */
        static char selfbuf[1024];
        if (!inc || !*inc) {
            char self_dir[1024];
            skj_exe_dir(argv[0], self_dir, sizeof self_dir);
            if (self_dir[0]) {
                snprintf(selfbuf, sizeof selfbuf,
                         "%s/../lib/skjegg/include", self_dir);
                if (access(selfbuf, F_OK) == 0)
                    inc = selfbuf;
            }
        }
#endif
#ifdef SKJ_INCLUDE_DIR
        if (!inc || !*inc)
            inc = SKJ_INCLUDE_DIR;
#endif
        if (inc && *inc)
            cpp_add_include_path(pp, inc);
    }

    if (setjmp(util_die_env) != 0)
        return 1;
    util_die_active = 1;

    util_cleanup_push(cleanup_arena, &a);
    util_cleanup_push(cleanup_cpp, pp);

    /* preprocess */
    pplen = 0;
    if (cpp_open(pp, inpath) < 0)
        die("cannot open '%s'", inpath);

    {
        /* Re-lexing the flattened stream would number every line by its position
           after all #includes were spliced in, not by its source line.  So, on
           the compile path, emit a GNU line marker (`# <line> "<file>"`) whenever
           the source line or file is not simply the previous line + 1; cc_lex
           resets its counter on each marker, giving IR_LOC (hence DWARF) the true
           source line.  -E output stays marker-free (byte-identical to before). */
        int last_line = 0;
        const char *last_file = NULL;
        while ((n = cpp_next_line(pp, linebuf, sizeof linebuf)) > 0) {
            if (!preprocess_only) {
                int el = cpp_get_emit_line(pp);
                const char *ef = cpp_get_emit_file(pp);
                if (ef && (!last_file || strcmp(ef, last_file) != 0
                           || el != last_line + 1)) {
                    char marker[4200];
                    int m = snprintf(marker, sizeof marker,
                                     "# %d \"%s\"\n", el, ef);
                    if (m > 0 && m < (int)sizeof marker) {
                        if (pplen + m >= (int)sizeof(ppbuf) - 1)
                            die("preprocessed source too large");
                        memcpy(ppbuf + pplen, marker, m);
                        pplen += m;
                    }
                    last_file = arena_strdup(&a, ef);
                }
                last_line = el;
            }
            if (pplen + n >= (int)sizeof(ppbuf) - 1)
                die("preprocessed source too large");
            memcpy(ppbuf + pplen, linebuf, n);
            pplen += n;
        }
    }
    ppbuf[pplen] = '\0';
    cpp_free(pp);
    util_cleanup_pop();

    if (preprocess_only) {
        out = outpath ? fopen(outpath, "w") : stdout;
        if (!out)
            die("cannot write '%s'", outpath);
        fwrite(ppbuf, 1, pplen, out);
        if (out != stdout)
            fclose(out);
        util_cleanup_run();
        return 0;
    }

    /* parse */
    cc_lex_init(&a, ppbuf, inpath);
    ast = cc_parse_program(&a);

    /* lower to IR */
    if (cc_debug)
        cc_src_file = inpath;
    prog = cc_lower_program(&a, ast);

    /* register allocation */
    for (fn = prog->funcs; fn; fn = fn->next)
        regalloc(fn);

    /* emit assembly */
    if (outpath) {
        out = fopen(outpath, "w");
        if (!out)
            die("cannot write '%s'", outpath);
    } else {
        out = stdout;
    }
    target_emit(out, prog);
    if (out != stdout)
        fclose(out);

    util_cleanup_run();

    return 0;
}
