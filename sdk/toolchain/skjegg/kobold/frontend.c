/* frontend.c : the in-process Kobold front end for skj-kp-jit (see frontend.h).

   The front end kpcom is a self-hosting Pascal program whose KPM1 output is the
   bridge into this tree.  It is also a KPM1 module itself (the committed seed,
   embedded here by bin2c), so compiling source is a two-stage boot: JIT the seed,
   then call its `compile(srcName, srcText): string` export with the user's source
   and take back the KPM1 module text.  This mirrors Kobold's examples/runpas.c,
   over Skjegg's freestanding register-ABI JIT rather than the Kobold VM. */

#include "frontend.h"
#include "kpm.h"
#include "jit_common.h"
#include "kp_host.h"
#include "str.h"
#include "kpcom_kpm.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <dirent.h>

/* kpcom imports ReadFileStr (its command-line driver reads source files), so it
   must be bound even though the `compile` export takes its source as a string. */
static kp_gptr
fe_read_file_str(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    char *buf;
    size_t n = 0;
    kp_gptr s;

    if (plen < 0 || plen >= (int)sizeof path)
        return kp_str_new("", 0);
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    buf = kp_read_file(path, &n);
    s = kp_str_new(buf ? buf : "", (int)n);
    free(buf);
    return s;
}

/* kpcom also imports WriteFileStr for its `-o` output path (reached only when the
   embedded seed is run as a standalone front end, not through the `compile`
   export), so it must be bound too or the seed fails to link under the JIT. */
static int
fe_write_file_str(kp_gptr pathstr, kp_gptr datastr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);

    if (plen < 0 || plen >= (int)sizeof path)
        return 0;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    return kp_write_file(path, kp_str_bytes(datastr), (size_t)kp_str_len(datastr));
}

/* Directory enumeration for the `uses ns.*` wildcard: kpcom lists a namespace directory at
   compile time. The same handle-based primitives the io.dirs unit uses, over the host
   opendir/readdir. A handle is an index into a small table of open DIR*; kpd_next returns one
   entry name at a time (the empty string at end). The jit_main and aot_rt host tiers carry
   their own copies for the standalone and native-AOT compilers. */
#define FE_KPD_MAX 16
static DIR *fe_kpd_tab[FE_KPD_MAX];

static int
fe_kpd_open(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    int i;

    if (plen < 0 || plen >= (int)sizeof path)
        return -1;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    for (i = 0; i < FE_KPD_MAX; i++)
        if (!fe_kpd_tab[i])
            break;
    if (i == FE_KPD_MAX)
        return -1;
    fe_kpd_tab[i] = opendir(path);
    return fe_kpd_tab[i] ? i : -1;
}

static kp_gptr
fe_kpd_next(int h)
{
    struct dirent *e;

    if (h < 0 || h >= FE_KPD_MAX || !fe_kpd_tab[h])
        return kp_str_new("", 0);
    e = readdir(fe_kpd_tab[h]);
    if (!e)
        return kp_str_new("", 0);
    return kp_str_new(e->d_name, (int)strlen(e->d_name));
}

static void
fe_kpd_close(int h)
{
    if (h >= 0 && h < FE_KPD_MAX && fe_kpd_tab[h]) {
        closedir(fe_kpd_tab[h]);
        fe_kpd_tab[h] = 0;
    }
}

static void *
fe_as_addr(void (*fn)(void))
{
    union { void (*f)(void); void *o; } u;
    u.f = fn;
    return u.o;
}

int
kp_compile_pas(const char *pas_path, char **module_text, size_t *out_len,
               char *err, size_t errlen)
{
    struct kp_binding binds[256];
    int nbinds = 0;
    const unsigned char *mod_bytes = kpcom_kpm;
    size_t mod_len = kpcom_kpm_len;
    char *mod_owned = NULL;          /* set when KPCOM_KPM overrides the seed */
    const char *override;
    struct kpm_module m;
    struct kp_jit j;
    char *src = NULL;
    size_t srclen = 0;
    kp_gptr name_s, text_s;
    void *entry;
    int64_t iargs[6] = { 0 };
    double fargs[8] = { 0 };
    double fret = 0;
    uint64_t result;
    uintptr_t top;
    int rc = 1;
    int have_jit = 0;
    int mod_parsed = 0;

    err[0] = '\0';

    /* The front end: the embedded seed, or a file named by KPCOM_KPM. */
    override = getenv("KPCOM_KPM");
    if (override && override[0]) {
        size_t n = 0;
        mod_owned = kp_read_file(override, &n);
        if (!mod_owned) {
            snprintf(err, errlen, "cannot read KPCOM_KPM '%s'", override);
            return 1;
        }
        mod_bytes = (const unsigned char *)mod_owned;
        mod_len = n;
    }

    /* The user's source: the `compile` export takes its text, not a path. */
    src = kp_read_file(pas_path, &srclen);
    if (!src) {
        snprintf(err, errlen, "cannot read '%s'", pas_path);
        free(mod_owned);
        return 1;
    }

    /* Bind the standard runtime plus the file I/O kpcom imports (ReadFileStr for
       its source reads, WriteFileStr for `-o`). */
    kp_install_runtime(binds, &nbinds, (int)(sizeof binds / sizeof binds[0]));
    if (nbinds + 5 <= (int)(sizeof binds / sizeof binds[0])) {
        binds[nbinds].name = "ReadFileStr";
        binds[nbinds].addr = fe_as_addr((void (*)(void))fe_read_file_str);
        nbinds++;
        binds[nbinds].name = "WriteFileStr";
        binds[nbinds].addr = fe_as_addr((void (*)(void))fe_write_file_str);
        nbinds++;
        /* the unit-namespace wildcard lists a namespace directory at compile time */
        binds[nbinds].name = "kpd_open";
        binds[nbinds].addr = fe_as_addr((void (*)(void))fe_kpd_open);
        nbinds++;
        binds[nbinds].name = "kpd_next";
        binds[nbinds].addr = fe_as_addr((void (*)(void))fe_kpd_next);
        nbinds++;
        binds[nbinds].name = "kpd_close";
        binds[nbinds].addr = fe_as_addr((void (*)(void))fe_kpd_close);
        nbinds++;
    }

    if (kpm_read(&m, (char *)mod_bytes, mod_len, err, errlen) != 0)
        goto done;
    mod_parsed = 1;
    if (kp_jit(&j, &m.prog, binds, nbinds, err, errlen) != 0)
        goto done;
    have_jit = 1;

    entry = kp_jit_entry(&j, "compile");
    if (!entry) {
        snprintf(err, errlen, "the front end has no 'compile' export");
        goto done;
    }

    /* compile(srcName, srcText): two guest strings in, a guest string out. The
       front end's pointer width is baked into its binary (native per target), so
       the export sets its own target and takes no width argument. */
    name_s = kp_str_new(pas_path, (int)strlen(pas_path));
    text_s = kp_str_new(src, (int)srclen);
    iargs[0] = name_s;
    iargs[1] = text_s;

    top = ((uintptr_t)j.stack + j.stack_len) & ~(uintptr_t)15;
    result = kp_call_guest(entry, (void *)top, iargs, fargs, &fret);

    if (result == 0) {
        /* kpcom returns the empty string on a compile error, having already
           written its diagnostics to stderr.  Signal that distinctly. */
        rc = 2;
        goto done;
    }
    {
        int rlen = kp_str_len((kp_gptr)result);
        const char *rbytes = kp_str_bytes((kp_gptr)result);
        char *copy;

        if (rlen < 0)
            rlen = 0;
        copy = malloc((size_t)rlen + 1);
        if (!copy) {
            snprintf(err, errlen, "out of memory");
            goto done;
        }
        memcpy(copy, rbytes, (size_t)rlen);  /* copy out before kp_jit_free unmaps it */
        copy[rlen] = '\0';
        *module_text = copy;
        *out_len = (size_t)rlen;
        rc = 0;
    }

done:
    if (have_jit)
        kp_jit_free(&j);
    if (mod_parsed)
        kpm_free(&m);
    free(src);
    free(mod_owned);
    return rc;
}
