/* kpm_fuzz.c : a fuzz harness for the KPM1 reader pipeline.

   It drives the whole untrusted-input path the reader feeds: kpm_read, then
   regalloc and target_emit over whatever program the reader accepted. The
   emitted assembly is discarded (written to /dev/null): the harness is a
   memory-safety probe, not a codegen check, so it is built ASan plus UBSan and
   the point is that no input, valid or hostile, drives an out-of-bounds access,
   an overflow, or any other undefined behavior through the pipeline. This path
   maps no executable memory, so ASan's shadow reservation does not collide with
   it (unlike the JIT), and full ASan applies.

   Two modes:

     (default)  Read all of stdin and run the pipeline once, then exit 0
                whatever the reader decides. This is the AFL++ / external
                byte-mutation entry: a crash is a sanitizer abort, which the
                fuzzer records as a finding.

     --mutate N SEED...   A dependency-free in-tree driver: load each SEED file,
                then run N iterations, each mutating a fresh copy of a randomly
                chosen seed with a deterministic PRNG and running the pipeline on
                it. `--rng K` sets the PRNG seed (default 1) so a run reproduces.
                This is what `make test-kpm-fuzz` runs over the valid fixtures. */

#include "kpm.h"
#include "ir.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "fuzz_mutate.h"

/* One pass of the reader pipeline over a text buffer of the given length. The
   buffer need not be NUL-terminated; kpm_read copies it and appends its own
   terminator. A reader rejection is an ordinary outcome, not a failure. */
static void
run_once(const char *text, size_t len)
{
    struct kpm_module m;
    char err[256];
    struct ir_func *fn;
    FILE *out;

    if (kpm_read(&m, text, len, err, sizeof err) != 0)
        return;

    for (fn = m.prog.funcs; fn; fn = fn->next)
        regalloc(fn);

    /* Match the AOT driver's trap policy so the selector lowers the checked
       arithmetic ops the same way it does in skj-kp. */
    target_aot_trap_guarded = 1;

    out = fopen("/dev/null", "w");
    if (out) {
        target_emit(out, &m.prog);
        fclose(out);
    }
    kpm_free(&m);
}

int
main(int argc, char **argv)
{
    if (argc >= 3 && strcmp(argv[1], "--mutate") == 0) {
        long iters;
        int argi = 2;
        char **seeds;
        size_t *seedlens;
        int nseed, s, i;

        iters = strtol(argv[argi++], NULL, 10);
        if (iters < 0)
            iters = 0;
        if (argi + 1 < argc && strcmp(argv[argi], "--rng") == 0) {
            fz_rng_seed((uint64_t)strtoull(argv[argi + 1], NULL, 10));
            argi += 2;
        }
        nseed = argc - argi;
        if (nseed <= 0) {
            fprintf(stderr, "usage: kpm_fuzz --mutate N [--rng K] seed.kpm...\n");
            return 2;
        }
        seeds = calloc((size_t)nseed, sizeof *seeds);
        seedlens = calloc((size_t)nseed, sizeof *seedlens);
        if (!seeds || !seedlens)
            return 1;
        for (s = 0; s < nseed; s++) {
            seeds[s] = fz_slurp_file(argv[argi + s], &seedlens[s]);
            if (!seeds[s]) {
                fprintf(stderr, "kpm_fuzz: cannot read '%s'\n", argv[argi + s]);
                return 1;
            }
            /* a seed itself must pass the pipeline cleanly */
            run_once(seeds[s], seedlens[s]);
        }

        for (i = 0; i < iters; i++) {
            size_t si = fz_rng_below((size_t)nseed);
            size_t mlen;
            char *mbuf = fz_mutate(seeds[si], seedlens[si], &mlen);
            if (!mbuf)
                return 1;
            run_once(mbuf, mlen);
            free(mbuf);
        }

        for (s = 0; s < nseed; s++)
            free(seeds[s]);
        free(seeds);
        free(seedlens);
        fprintf(stderr, "kpm_fuzz: %ld iterations over %d seed(s), no crash\n",
                iters, nseed);
        return 0;
    }

    /* default: one pass over stdin (AFL++ / external byte-mutation entry) */
    {
        size_t len;
        char *text = fz_slurp_stdin(&len);
        if (!text)
            return 1;
        run_once(text, len);
        free(text);
    }
    return 0;
}
