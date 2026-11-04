/* jit_main.c : skj-kp-jit, the in-process JIT driver for Kobold modules.

   Reads a KPM1 text module (the Kobold front end's output), JITs it to native
   code with the shared jit/ library, and calls an entry in-process.  This is the
   JIT counterpart of the ahead-of-time path: it shares the same instruction
   selector and byte sink, differing only in that it runs the module rather than
   writing assembly.  No assembler, linker, or emulator is involved.

   A program that `uses` units is loaded with its dependencies: the driver follows
   each module's `.uses` list, loads every unit `<name>.kpm` from the program's
   directory (transitively, de-duplicated), and JITs them in dependency order.
   Modules are linked by name, per the one-selector-two-sinks design: each module is
   JIT'd on its own, and its exports' mapped addresses are fed as bindings to the
   modules compiled after it, so a cross-module call or a reference to another unit's
   global resolves through the binding table.  This handles an acyclic unit graph;
   mutual cycles would need pre-resolved export stubs (a later step).

   The standard language runtime it binds lives in kp_host.c; this driver is a
   plain embedder of it.  A host that wants to expose its own opaque handle types
   installs the same runtime and then binds its own factories and methods (see
   patrol_main.c).  The Kobold front end stays a separate self-hosting Pascal
   program; its KPM1 output is the bridge into the Skjegg tree (doc/languages/kobold/kobold.md). */

#include "kpm.h"
#include "jit_common.h"
#include "kp_host.h"
#include "kp_rt_io.h"
#include "str.h"
#include "frontend.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <fcntl.h>
#include <dirent.h>
#include <sys/stat.h>

/* Whole-file string I/O (ReadFileStr/WriteFileStr) and the files and dirs unit
   primitives (the kpf_ and kpd_ families) live in kobold/kp_rt_io.c now,
   compiled host-native and linked here (the AOT start file links the same
   source target-native). The bindings below map each guest symbol name to the
   linked function.

   The four debug/test stubs stay here as statics: the JIT byte sink (jit/code.h)
   already owns the C symbols emit and emit64, so the shared file cannot export
   them under those names; the bindings point the guest names at these copies.
   The console seam writes straight to the fd (kp_io.c), so these printf-based
   stubs flush after each line to stay in order with a program's own output. */
static void h_printInt(int n) { printf("%d\n", n); fflush(stdout); }
static void h_emit64(int64_t n) { printf("%lld\n", (long long)n); fflush(stdout); }

/* emitf takes a real.  On rv32 the JIT's soft-float call ABI passes it as the
   double's bits in an integer register pair (see the bridge in kp_host.c), so the
   harness receives those bits; every other target passes a native double. */
#if defined(__riscv) && __riscv_xlen == 32
static void h_emitf(uint64_t xb) { double x; memcpy(&x, &xb, sizeof x); printf("%g\n", x); fflush(stdout); }
#else
static void h_emitf(double x) { printf("%g\n", x); fflush(stdout); }
#endif

static void *jit_as_addr(void (*fn)(void))
{
    union { void (*f)(void); void *o; } u;
    u.f = fn;
    return u.o;
}

static int
ends_with(const char *s, const char *suffix)
{
    size_t ls = strlen(s), lx = strlen(suffix);
    return ls >= lx && strcmp(s + ls - lx, suffix) == 0;
}

/****************************************************************
 * Multi-module load and link
 ****************************************************************/

#define MAX_MODULES 64

struct module_slot {
    char name[64];              /* the unit's name ("" for the program) */
    int named;                  /* 0 for the program (no unit name) */
    char *text;                 /* the module's source text (owned) */
    struct kpm_module m;        /* the parsed module */
    struct kp_jit j;            /* its JIT code and data regions */
    int have_jit;               /* j is live and must be freed */
};

static struct module_slot g_mods[MAX_MODULES];
static int g_nmods;

static struct kp_binding g_binds[256];
static int g_nbinds;

/* The cross-module call stubs (Phase 4 Step B): one per exported routine, at a
   stable address a cross-module call is linked to before anything is compiled, so
   linking no longer depends on compile order.  g_funcstub maps an exported routine's
   name to its stub slot, filled with the real entry once the owning module is JIT'd. */
static struct kp_stubs g_stubs;
struct funcstub { const char *name; int index; };
static struct funcstub g_funcstub[256];
static int g_nfuncstub;

static char g_dir[1024];        /* directory of the program, where units are found */

/* The built-in standard-library unit directory, the last place a unit is sought,
   matching kprun.  An embedder or test overrides the search with KOBOLD_UNITS. */
#ifndef KP_STDLIB_DIR
#define KP_STDLIB_DIR "/usr/local/lib/kobold"
#endif

/* Try d/name.kpm, then d/<lowercased name>.kpm (as the compiler's unit search
   does), writing the first readable path to path.  Returns 1 if one exists.  A
   dotted unit name maps its dots to path separators, so io.files is sought as
   d/io/files.kpm (doc/languages/kobold/kp-units.md). */
static int
try_dep_path(const char *d, const char *name, char *path, size_t plen)
{
    char rel[256], low[256];
    size_t j;

    for (j = 0; name[j] && j + 1 < sizeof rel; j++)
        rel[j] = name[j] == '.' ? '/' : name[j];
    rel[j] = '\0';

    snprintf(path, plen, "%s/%s.kpm", d, rel);
    if (access(path, R_OK) == 0)
        return 1;
    for (j = 0; rel[j] && j + 1 < sizeof low; j++)
        low[j] = (char)tolower((unsigned char)rel[j]);
    low[j] = '\0';
    snprintf(path, plen, "%s/%s.kpm", d, low);
    return access(path, R_OK) == 0;
}

/* Resolve a dependency module file, searching in order: the main module's
   directory, each colon-separated entry of KOBOLD_UNITS, then the built-in
   standard library directory.  Returns 1 and fills path on the first hit. */
static int
resolve_dep(const char *name, char *path, size_t plen)
{
    const char *env, *p, *q;
    char d[1024];
    size_t len;

    if (try_dep_path(g_dir, name, path, plen))
        return 1;
    env = getenv("KOBOLD_UNITS");
    p = env;
    while (p && *p) {
        q = strchr(p, ':');
        len = q ? (size_t)(q - p) : strlen(p);
        if (len > 0 && len < sizeof d) {
            memcpy(d, p, len);
            d[len] = '\0';
            if (try_dep_path(d, name, path, plen))
                return 1;
        }
        p = q ? q + 1 : NULL;
    }
    return try_dep_path(KP_STDLIB_DIR, name, path, plen);
}

static int
module_loaded(const char *name)
{
    int i;
    if (!name)
        return 0;
    for (i = 0; i < g_nmods; i++)
        if (g_mods[i].named && strcmp(g_mods[i].name, name) == 0)
            return 1;
    return 0;
}

static struct module_slot *
find_module(const char *name)
{
    int i;
    if (!name)
        return NULL;
    for (i = 0; i < g_nmods; i++)
        if (g_mods[i].named && strcmp(g_mods[i].name, name) == 0)
            return &g_mods[i];
    return NULL;
}

/* Add a binding (last one wins for a repeated name, which never happens here). */
static int
add_binding(const char *name, void *addr, char *err, size_t errlen)
{
    if (g_nbinds >= (int)(sizeof g_binds / sizeof g_binds[0])) {
        snprintf(err, errlen, "too many bindings (raise MAX in jit_main.c)");
        return -1;
    }
    g_binds[g_nbinds].name = name;
    g_binds[g_nbinds].addr = addr;
    g_nbinds++;
    return 0;
}

static int load_tree(const char *path, const char *unitname, char *err, size_t errlen);

/* Install one module into g_mods from its KPM1 text (which the slot takes over and
   free_modules frees), then load its unit dependencies.  No code is generated here;
   the whole module set is loaded first so every export's stub can be allocated
   before any module compiles.  `unitname` is the dependency's declared name (NULL
   for the program), used to de-duplicate.  The root may come from a file (load_tree)
   or from the front end's in-memory output (the .pas path in main). */
static int
add_module(const char *unitname, char *text, size_t len, char *err, size_t errlen)
{
    struct module_slot *slot;
    int i;

    if (g_nmods >= MAX_MODULES) {
        snprintf(err, errlen, "too many modules");
        free(text);
        return -1;
    }

    slot = &g_mods[g_nmods++];
    if (unitname) {
        snprintf(slot->name, sizeof slot->name, "%s", unitname);
        slot->named = 1;
    }

    slot->text = text;
    if (kpm_read(&slot->m, slot->text, len, err, errlen) != 0)
        return -1;

    for (i = 0; i < slot->m.ndeps; i++) {
        const char *dep = slot->m.deps[i].name;
        char dpath[1024];
        struct module_slot *dslot;

        if (!module_loaded(dep)) {
            if (!resolve_dep(dep ? dep : "", dpath, sizeof dpath)) {
                snprintf(err, errlen, "cannot find unit '%s' (searched the module "
                         "directory, KOBOLD_UNITS, and %s)", dep, KP_STDLIB_DIR);
                return -1;
            }
            if (load_tree(dpath, dep, err, errlen) != 0)
                return -1;
        }
        /* Interface skew check, as kprun does: the dependency's interface must
           match the fingerprint recorded when this module was compiled. */
        dslot = find_module(dep);
        if (dslot && slot->m.deps[i].fingerprint &&
            dslot->m.iface_fp != slot->m.deps[i].fingerprint) {
            snprintf(err, errlen,
                     "interface fingerprint mismatch for unit '%s'", dep);
            return -1;
        }
    }
    return 0;
}

/* Pass 1 from a file: read `path` and install it as a module (see add_module). */
static int
load_tree(const char *path, const char *unitname, char *err, size_t errlen)
{
    char *text;
    size_t len;

    if (module_loaded(unitname))
        return 0;

    text = kp_read_file(path, &len);
    if (!text) {
        snprintf(err, errlen, "cannot read '%s'", path);
        return -1;
    }
    return add_module(unitname, text, len, err, errlen);
}

/* Pass 2: a stub per exported routine, bound to its name, at a stable address.  A
   cross-module call then links to the stub regardless of which module compiles
   first; the stub's slot is pointed at the real entry in pass 3.  An exported
   global is data, not code, so it takes no stub; its real address is published once
   its module is laid out (pass 3). */
static int
alloc_stubs(char *err, size_t errlen)
{
    int total = 0, i, k;

    for (i = 0; i < g_nmods; i++)
        total += g_mods[i].m.nexports;
    if (kp_stubs_init(&g_stubs, total > 0 ? total : 1, err, errlen) != 0)
        return -1;

    for (i = 0; i < g_nmods; i++) {
        struct module_slot *m = &g_mods[i];
        for (k = 0; k < m->m.nexports; k++) {
            const char *name = m->m.exports[k];
            int idx;
            void *stub;

            if (!kp_is_module_func(&m->m.prog, name))
                continue;                       /* an exported global: no stub */
            if (g_nfuncstub >= (int)(sizeof g_funcstub / sizeof g_funcstub[0])) {
                snprintf(err, errlen, "too many exported routines");
                return -1;
            }
            stub = kp_stub_add(&g_stubs, &idx);
            if (!stub) {
                snprintf(err, errlen, "stub table overflow");
                return -1;
            }
            g_funcstub[g_nfuncstub].name = name;
            g_funcstub[g_nfuncstub].index = idx;
            g_nfuncstub++;
            if (add_binding(name, stub, err, errlen) != 0)
                return -1;
        }
    }
    return 0;
}

static int
funcstub_index(const char *name)
{
    int i;
    for (i = 0; i < g_nfuncstub; i++)
        if (strcmp(g_funcstub[i].name, name) == 0)
            return g_funcstub[i].index;
    return -1;
}

/* Pass 3: compile `slot` after its dependencies (so a cross-unit global reference
   resolves to an already-laid-out address), then point each of its exported
   routines' stubs at the real entry and publish its exported globals. */
static int
compile_tree(struct module_slot *slot, char *err, size_t errlen)
{
    int i;

    if (!slot || slot->have_jit)
        return 0;

    for (i = 0; i < slot->m.ndeps; i++) {
        struct module_slot *dslot = find_module(slot->m.deps[i].name);
        if (compile_tree(dslot, err, errlen) != 0)
            return -1;
    }

    if (kp_jit(&slot->j, &slot->m.prog, g_binds, g_nbinds, err, errlen) != 0)
        return -1;
    slot->have_jit = 1;

    for (i = 0; i < slot->m.nexports; i++) {
        const char *e = slot->m.exports[i];
        int idx = funcstub_index(e);
        if (idx >= 0) {
            kp_stub_set(&g_stubs, idx, kp_jit_entry(&slot->j, e));
        } else {
            /* an exported global that rode the .export list: publish its address */
            void *a = (void *)kp_global_addr(&slot->j, e);
            if (a && add_binding(e, a, err, errlen) != 0)
                return -1;
        }
    }

    /* Publish exported globals (an `export` global carries the flag on its
       definition, not in the `.export` list) so another unit can reach them. */
    {
        struct ir_global *g;
        for (g = slot->m.prog.globals; g; g = g->next)
            if (g->is_export) {
                void *a = (void *)kp_global_addr(&slot->j, g->name);
                if (a && add_binding(g->name, a, err, errlen) != 0)
                    return -1;
            }
    }
    return 0;
}

static void
free_modules(void)
{
    int i;
    for (i = 0; i < g_nmods; i++) {
        if (g_mods[i].have_jit)
            kp_jit_free(&g_mods[i].j);
        kpm_free(&g_mods[i].m);
        free(g_mods[i].text);
    }
    kp_stubs_free(&g_stubs);
}

int main(int argc, char **argv)
{
    const char *inpath = NULL;
    const char *outpath = NULL;
    const char *entryname;
    char err[256];
    void *entry;
    int64_t iargs[6] = { 0 };
    double fargs[8] = { 0 };
    double fret = 0;
    uintptr_t top;
    const char *slash;
    struct module_slot *root;

    /* Options precede the module.  The first non-option argument is the module;
       everything after it is the guest program's own command line, reached through
       ParamStr/ParamCount, so it is not consumed here (matching kprun).
       --emit-kpm writes the compiled module and stops; -o names the file it writes
       (default stdout), so a module can be produced without a shell redirect. */
    int emit_kpm = 0;
    for (int i = 1; i < argc; i++) {
        if (argv[i][0] != '-') {
            inpath = argv[i];
            break;
        }
        if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            printf("usage: skj-kp-jit (module.kpm | source.pas) "
                   "[--emit-kpm [-o out.kpm]] [args...]\n");
            return 0;
        } else if (strcmp(argv[i], "--emit-kpm") == 0)
            emit_kpm = 1;
        else if (strcmp(argv[i], "-o") == 0 && i + 1 < argc)
            outpath = argv[++i];
    }
    if (!inpath) {
        fprintf(stderr, "usage: skj-kp-jit (module.kpm | source.pas) "
                        "[--emit-kpm [-o out.kpm]] [args...]\n");
        return 2;
    }

    /* A .pas input is Kobold source, compiled in-process by the embedded front
       end; a .kpm is a prebuilt module.  --emit-kpm (above) is only meaningful for
       a .pas input. */
    int is_pas = ends_with(inpath, ".pas");

    kp_install_runtime(g_binds, &g_nbinds, (int)(sizeof g_binds / sizeof g_binds[0]));
    kp_io_set_args(argc, argv);

    /* std.time / std.random host glue (runtime/sched_glue.c, rng_glue.c), linked
       into the JIT through KP_RT.  Scalar signatures (no guest pointers), so they
       bind directly, with no host-pointer bridge like the kpf_* file calls need. */
    extern long long kp_now_ms(void);
    extern void kp_sleep_ms(int ms);
    extern void kp_random_seed(int seed);
    extern void kp_randomize(void);
    extern int kp_random_below(int bound);
    extern double kp_random_real(void);
    extern int kp_secure_below(int bound);

    /* The kprun-compatible debug/test surface and the files/dirs primitives,
       all from kobold/kp_rt_io.c (shared with the AOT runtime). */
    if (add_binding("printInt", jit_as_addr((void (*)(void))h_printInt), err, sizeof err) ||
        add_binding("emit", jit_as_addr((void (*)(void))h_printInt), err, sizeof err) ||
        add_binding("emitf", jit_as_addr((void (*)(void))h_emitf), err, sizeof err) ||
        add_binding("emit64", jit_as_addr((void (*)(void))h_emit64), err, sizeof err) ||
        add_binding("ReadFileStr", jit_as_addr((void (*)(void))ReadFileStr), err, sizeof err) ||
        add_binding("WriteFileStr", jit_as_addr((void (*)(void))WriteFileStr), err, sizeof err) ||
        add_binding("kpf_open_read", jit_as_addr((void (*)(void))kpf_open_read), err, sizeof err) ||
        add_binding("kpf_open_write", jit_as_addr((void (*)(void))kpf_open_write), err, sizeof err) ||
        add_binding("kpf_read", jit_as_addr((void (*)(void))kpf_read), err, sizeof err) ||
        add_binding("kpf_write", jit_as_addr((void (*)(void))kpf_write), err, sizeof err) ||
        add_binding("kpf_close", jit_as_addr((void (*)(void))kpf_close), err, sizeof err) ||
        add_binding("kpf_exists", jit_as_addr((void (*)(void))kpf_exists), err, sizeof err) ||
        add_binding("kpf_size", jit_as_addr((void (*)(void))kpf_size), err, sizeof err) ||
        add_binding("kpf_isdir", jit_as_addr((void (*)(void))kpf_isdir), err, sizeof err) ||
        add_binding("kpf_delete", jit_as_addr((void (*)(void))kpf_delete), err, sizeof err) ||
        add_binding("kpf_rename", jit_as_addr((void (*)(void))kpf_rename), err, sizeof err) ||
        add_binding("kpf_mkdir", jit_as_addr((void (*)(void))kpf_mkdir), err, sizeof err) ||
        add_binding("kpf_rmdir", jit_as_addr((void (*)(void))kpf_rmdir), err, sizeof err) ||
        add_binding("kpd_open", jit_as_addr((void (*)(void))kpd_open), err, sizeof err) ||
        add_binding("kpd_next", jit_as_addr((void (*)(void))kpd_next), err, sizeof err) ||
        add_binding("kpd_close", jit_as_addr((void (*)(void))kpd_close), err, sizeof err) ||
        add_binding("kp_now_ms", jit_as_addr((void (*)(void))kp_now_ms), err, sizeof err) ||
        add_binding("kp_sleep_ms", jit_as_addr((void (*)(void))kp_sleep_ms), err, sizeof err) ||
        add_binding("kp_random_seed", jit_as_addr((void (*)(void))kp_random_seed), err, sizeof err) ||
        add_binding("kp_randomize", jit_as_addr((void (*)(void))kp_randomize), err, sizeof err) ||
        add_binding("kp_random_below", jit_as_addr((void (*)(void))kp_random_below), err, sizeof err) ||
        add_binding("kp_random_real", jit_as_addr((void (*)(void))kp_random_real), err, sizeof err) ||
        add_binding("kp_secure_below", jit_as_addr((void (*)(void))kp_secure_below), err, sizeof err)) {
        fprintf(stderr, "skj-kp-jit: %s\n", err);
        return 1;
    }

    /* The directory a unit's `<name>.kpm` is loaded from, taken from the program's
       path (kept with its trailing slash, or empty for the current directory). */
    slash = strrchr(inpath, '/');
    if (slash) {
        size_t n = (size_t)(slash - inpath);   /* directory part, no trailing slash */
        if (n == 0)
            n = 1;                              /* a path like "/x" lives in "/" */
        if (n >= sizeof g_dir)
            n = sizeof g_dir - 1;
        memcpy(g_dir, inpath, n);
        g_dir[n] = '\0';
    } else {
        g_dir[0] = '.';                         /* no directory part: the cwd */
        g_dir[1] = '\0';
    }

    /* Obtain the root module.  A .pas source is compiled in-process by the embedded
       front end (stopping at --emit-kpm if asked); a .kpm is read directly. */
    if (is_pas) {
        char *mtext;
        size_t mlen;
        int crc = kp_compile_pas(inpath, &mtext, &mlen, err, sizeof err);
        if (crc != 0) {
            if (err[0])
                fprintf(stderr, "skj-kp-jit: %s\n", err);
            return crc;             /* 2: kpcom already reported the source error */
        }
        if (emit_kpm) {
            FILE *out = stdout;
            if (outpath) {
                out = fopen(outpath, "wb");
                if (!out) {
                    fprintf(stderr, "skj-kp-jit: cannot write %s\n", outpath);
                    free(mtext);
                    return 1;
                }
            }
            fwrite(mtext, 1, mlen, out);
            if (out != stdout)
                fclose(out);
            free(mtext);
            return 0;
        }
        if (add_module(NULL, mtext, mlen, err, sizeof err) != 0) {
            fprintf(stderr, "skj-kp-jit: %s\n", err);
            free_modules();
            return 1;
        }
    } else if (load_tree(inpath, NULL, err, sizeof err) != 0) {
        fprintf(stderr, "skj-kp-jit: %s\n", err);
        free_modules();
        return 1;
    }

    /* Give every exported routine a stable call stub, then compile in dependency
       order and point each stub at its real entry. */
    if (alloc_stubs(err, sizeof err) != 0 ||
        compile_tree(&g_mods[0], err, sizeof err) != 0 ||
        kp_stubs_finalize(&g_stubs, err, sizeof err) != 0) {
        fprintf(stderr, "skj-kp-jit: %s\n", err);
        free_modules();
        return 1;
    }

    root = &g_mods[0];

    /* Run the program's own entry (a void `main`); its machine return value is
       undefined, so a normal end is exit status 0.  A program sets a nonzero
       status through io_halt. */
    entryname = root->m.entry ? root->m.entry : "main";
    entry = kp_jit_entry(&root->j, entryname);
    if (!entry) {
        fprintf(stderr, "skj-kp-jit: no entry '%s' in the module\n", entryname);
        free_modules();
        return 1;
    }

    top = ((uintptr_t)root->j.stack + root->j.stack_len) & ~(uintptr_t)15;
    kp_call_guest(entry, (void *)top, iargs, fargs, &fret);

    kp_handle_sweep();   /* finalize any handle left live, while the code is mapped */
    free_modules();
    return 0;
}
