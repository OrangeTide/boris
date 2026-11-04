/* aot_main.c : skj-kp, the ahead-of-time compiler for Kobold modules.

   Reads a KPM1 text module (the Kobold front end's output) and writes native
   assembly through the shared instruction selector and text sink, the same
   selector the JIT drives.  This is the AOT counterpart of skj-kp-jit: instead of
   emitting machine code into a mapped buffer and running it, it writes an assembly
   file that an assembler and linker turn into a native object.

   The emitted object calls the Kobold runtime by symbol (io_write_str,
   kp_str_concat, and so on), which the final link resolves against the runtime
   library plus a small C start file (kobold/aot_crt.c): that file owns the process
   entry, sets up the low-memory guest heap and stack, and calls the guest program
   through kp_call_guest.  So the program's own entry is renamed here to a fixed
   symbol the start file calls, leaving `main` to the C runtime. */

#include "kpm.h"
#include "ir.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* The symbol the C start file (aot_crt.c) calls to enter the guest program. */
#define KP_GUEST_ENTRY "kp_guest_entry"

/* The JIT binds a few guest-facing runtime names to differently named host
   implementations (kp_install_runtime does the remapping in its table).  AOT
   resolves calls by linker symbol instead, so the same map is applied here to the
   call targets; this table mirrors that one.  What needs remapping:

     - The coroutine operators: the guest calls kp_co_new and friends, whose real
       implementations are the vm-less shims kp_co_new_g (co.c owns the bare names
       with a different, vm-taking signature).
     - ParamCount / ParamStr / heapLive, which the runtime provides under C names.
     - The transcendentals (kp_sin and friends), which wrap the C library.
     - On rv32 only: the real-valued I/O and Val, which cross the call in an integer
       register pair (the soft-float ilp32 ABI the backend emits) and so go through
       the bits bridge in kp_host.c; and the stack-ABI 64-bit multiply and shifts
       (the backend's rv lowering), which carry skj_jit_* names so they do not
       collide with the runtime's own register-ABI libgcc helpers.  The __divdi3
       family uses the register ABI on both sides, so it resolves to libgcc with no
       remap.

   Every other runtime name the guest emits is provided under that exact name by
   the AOT runtime, so it is absent here and resolves directly at link. */
static const char *
remap_sym(const char *s)
{
    static const struct { const char *from, *to; } tab[] = {
        { "kp_co_new",        "kp_co_new_g" },
        { "kp_co_resume",     "kp_co_resume_g" },
        { "kp_co_yield",      "kp_co_yield_g" },
        { "kp_co_self",       "kp_co_self_g" },
        { "kp_co_cancelling", "kp_co_cancelling_g" },

        { "ParamCount",       "rt_param_count" },
        { "ParamStr",         "rt_param_str" },
        { "heapLive",         "kp_gheap_live" },

#if defined(KP_AOT_RV)
        /* rv32: the real ABI crosses the call as integer-register bits, so the
           guest's real I/O, Val, and transcendentals go through the bits bridge. */
        { "io_write_real",    "brv_write_real" },
        { "io_read_real",     "brv_read_real" },
        { "kp_str_val_real",  "brv_val_real" },
        { "kp_sin",           "brv_sin" },
        { "kp_cos",           "brv_cos" },
        { "kp_exp",           "brv_exp" },
        { "kp_ln",            "brv_ln" },
        { "kp_arctan",        "brv_arctan" },
        /* The stack-ABI 64-bit multiply and shift helpers the backend emits are not
           call-instruction symbols (the rv selector writes the names directly), so
           they cannot be remapped here; libkpaot-rv.a aliases those names to its
           skj_jit_* routines at link instead (kobold/rv_i64_aot_alias.S). */
#else
        /* Other targets pass a real in the native float register, matching the
           runtime directly; only the transcendental names need the C-symbol remap. */
        { "kp_sin",           "h_sin" },
        { "kp_cos",           "h_cos" },
        { "kp_exp",           "h_exp" },
        { "kp_ln",            "h_ln" },
        { "kp_arctan",        "h_arctan" },
#endif
    };
    size_t i;

    for (i = 0; i < sizeof tab / sizeof tab[0]; i++)
        if (strcmp(s, tab[i].from) == 0)
            return tab[i].to;
    return NULL;
}

static char *
kp_slurp(const char *path, size_t *lenp)
{
    FILE *f = fopen(path, "rb");
    long sz;
    char *buf;

    if (!f)
        return NULL;
    if (fseek(f, 0, SEEK_END) != 0 || (sz = ftell(f)) < 0) {
        fclose(f);
        return NULL;
    }
    rewind(f);
    buf = malloc((size_t)sz + 1);
    if (!buf) {
        fclose(f);
        return NULL;
    }
    if (fread(buf, 1, (size_t)sz, f) != (size_t)sz) {
        free(buf);
        fclose(f);
        return NULL;
    }
    fclose(f);
    buf[sz] = '\0';
    *lenp = (size_t)sz;
    return buf;
}

int
main(int argc, char **argv)
{
    const char *inpath = NULL;
    const char *outpath = NULL;
    char *text;
    size_t len;
    struct kpm_module m;
    char err[256];
    struct ir_func *fn;
    FILE *out;
    int i;

    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            printf("usage: skj-kp module.kpm [-o out.asm]\n");
            return 0;
        } else if (strcmp(argv[i], "-o") == 0 && i + 1 < argc)
            outpath = argv[++i];
        else if (argv[i][0] != '-' && !inpath)
            inpath = argv[i];
    }
    if (!inpath) {
        fprintf(stderr, "usage: skj-kp module.kpm [-o out.asm]\n");
        return 2;
    }

    text = kp_slurp(inpath, &len);
    if (!text) {
        fprintf(stderr, "skj-kp: cannot read '%s'\n", inpath);
        return 1;
    }
    if (kpm_read(&m, text, len, err, sizeof err) != 0) {
        fprintf(stderr, "skj-kp: %s\n", err);
        free(text);
        return 1;
    }

    /* Rename the program's entry so the C start file keeps the process `main`.
       A module without an explicit `.entry` runs its `main`, the same fallback the
       JIT driver uses. */
    {
        const char *entry = m.entry ? m.entry : "main";
        for (fn = m.prog.funcs; fn; fn = fn->next)
            if (fn->name && strcmp(fn->name, entry) == 0) {
                fn->name = KP_GUEST_ENTRY;
                fn->is_local = 0;   /* must be global for the start file to call it */
                break;
            }
    }

    /* Give every exported routine or global external linkage so the system linker
       resolves a cross-unit reference to it.  The module lists its exports by name;
       the function and global definitions themselves are emitted local by default
       (the JIT's loader resolves cross-module names through its own export table, not
       ELF visibility).  A private symbol a unit does not export stays local, so two
       units' same-named private globals do not collide at link. */
    {
        int e;
        for (e = 0; e < m.nexports; e++) {
            struct ir_global *g;
            for (fn = m.prog.funcs; fn; fn = fn->next)
                if (fn->name && strcmp(fn->name, m.exports[e]) == 0)
                    fn->is_local = 0;
            for (g = m.prog.globals; g; g = g->next)
                if (g->name && strcmp(g->name, m.exports[e]) == 0)
                    g->is_local = 0;
        }
    }

    /* Apply the guest-name -> runtime-symbol remapping to every call target. */
    for (fn = m.prog.funcs; fn; fn = fn->next) {
        struct ir_insn *in;
        for (in = fn->head; in; in = in->next)
            if (in->sym) {
                const char *to = remap_sym(in->sym);
                if (to)
                    in->sym = (char *)to;
            }
    }

    for (fn = m.prog.funcs; fn; fn = fn->next)
        regalloc(fn);

    if (outpath) {
        out = fopen(outpath, "w");
        if (!out) {
            fprintf(stderr, "skj-kp: cannot write '%s'\n", outpath);
            kpm_free(&m);
            free(text);
            return 1;
        }
    } else {
        out = stdout;
    }

    /* Kobold traps on integer overflow, so the AOT compiles the checked arithmetic
       ops to the trap helper, as its JIT does, rather than letting them wrap under
       the hardware policy the C compiler shares.  rv always guards and ignores this;
       x86-64 and arm64 read it. */
    target_aot_trap_guarded = 1;
    target_emit(out, &m.prog);

    if (out != stdout)
        fclose(out);
    kpm_free(&m);
    free(text);
    return 0;
}
