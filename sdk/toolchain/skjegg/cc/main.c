/* main.c : skj-cc C compiler driver */

#include "cc.h"
#include "cpp.h"
#include "arena.h"
#include "version.h"

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

int
main(int argc, char **argv)
{
    const char *inpath;
    const char *outpath;
    int preprocess_only;
    struct cpp *pp;
    char ppbuf[65536];
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
        } else if (strcmp(argv[i], "-E") == 0) {
            preprocess_only = 1;
        } else if (argv[i][0] == '-') {
            /* ignore unknown options silently */
        } else {
            inpath = argv[i];
        }
    }

    if (!inpath)
        die("usage: skj-cc [-V] [-o out.s] [-I path] [-D name[=val]] input.c");

    if (setjmp(util_die_env) != 0)
        return 1;
    util_die_active = 1;

    util_cleanup_push(cleanup_arena, &a);
    util_cleanup_push(cleanup_cpp, pp);

    /* preprocess */
    pplen = 0;
    if (cpp_open(pp, inpath) < 0)
        die("cannot open '%s'", inpath);

    while ((n = cpp_next_line(pp, linebuf, sizeof linebuf)) > 0) {
        if (pplen + n >= (int)sizeof(ppbuf) - 1)
            die("preprocessed source too large");
        memcpy(ppbuf + pplen, linebuf, n);
        pplen += n;
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
