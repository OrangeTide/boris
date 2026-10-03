/* regalloc_rv.c : linear-scan register allocator for RISC-V */
/*
 * Poletto & Sarkar (1999) linear-scan register allocation.
 *
 * RISC-V (RV32IM) register parameters
 * ------------------------------------
 * Integer allocatable (callee-save): s1..s11  ->  11 regs, first = 2
 * I64 pair allocatable (callee-save): (s10,s11), (s8,s9), (s6,s7), (s4,s5)
 *                                     ->  4 pairs
 * Float allocatable (callee-save): fs0..fs11  ->  12 regs, first = 2
 *                                  (disjoint register file, no int overlap)
 *
 * Reserved:
 *   t0  spill-fix-up scratch (first operand reload)
 *   t1  spill-fix-up scratch (second operand reload)
 *   a0  return value / first arg / scratch
 *   a1  address scratch
 *   s0  frame pointer
 *   sp  stack pointer
 *   ra  return address
 *
 * The emitter inspects fn->temp_reg[t]:
 *   >= 0 -> physical register number (for I32)
 *           or pair index (for I64: 0=(s10,s11), 1=(s8,s9), 2=(s6,s7), 3=(s4,s5))
 *   -1   -> spilled; fn->temp_spill[t] is the byte offset
 *           within the spill area.
 *
 * I64 pairs are allocated from the top of s1..s11. I32 temps get whatever
 * remains from the bottom. This avoids overlap without a general graph
 * coloring allocator.
 *
 * fn->nspills    = integer spill slots (4 bytes each)
 * fn->ni64spills = I64 spill slots (8 bytes each)
 */

#include "ir.h"

#include <stdlib.h>  /* qsort */

#define INT_NUM_REGS  11
#define INT_FIRST_REG 2

#define I64_NUM_PAIRS  4
#define I64_FIRST_PAIR 0

/* Float allocatable (callee-save): fs0..fs11 -> 12 regs, first = 2
 * (indices 0-1 are the emitter's float scratch ft0/ft1). */
#define FP_NUM_REGS   12
#define FP_FIRST_REG  2

struct interval {
    int temp;
    int start;
    int end;
    int reg;
    int spill;
};

static int
sort_by_start(const void *pa, const void *pb)
{
    const struct interval *a = pa;
    const struct interval *b = pb;

    if (a->start != b->start)
        return a->start - b->start;
    return a->end - b->end;
}

static int
linscan(struct ir_func *fn, int *first_def, int *last_use,
        int *is_class, int num_regs, int first_reg, int spill_size)
{
    struct interval *ivs;
    struct interval **active;
    struct arena_mark m;
    int ntemps = fn->ntemps;
    int niv;
    int nactive;
    int nspills;
    int t, k, p, r, w;

    m = arena_save(fn->arena);
    ivs = arena_alloc(fn->arena, ntemps * sizeof(*ivs));
    niv = 0;
    for (t = 0; t < ntemps; t++) {
        if (!is_class[t] || first_def[t] < 0)
            continue;
        ivs[niv].temp = t;
        ivs[niv].start = first_def[t];
        ivs[niv].end = last_use[t] >= first_def[t]
                       ? last_use[t] : first_def[t];
        ivs[niv].reg = -1;
        ivs[niv].spill = -1;
        niv++;
    }

    if (niv == 0) {
        arena_release(fn->arena, m);
        return 0;
    }

    if (num_regs == 0) {
        for (p = 0; p < niv; p++) {
            fn->temp_reg[ivs[p].temp] = -1;
            fn->temp_spill[ivs[p].temp] = p * spill_size;
        }
        arena_release(fn->arena, m);
        return niv;
    }

    qsort(ivs, niv, sizeof(*ivs), sort_by_start);

    int pool[num_regs];
    for (k = 0; k < num_regs; k++)
        pool[k] = 1;

    active = arena_alloc(fn->arena, (num_regs + 1) * sizeof(*active));
    nactive = 0;
    nspills = 0;

    for (p = 0; p < niv; p++) {
        struct interval *iv = &ivs[p];
        int got, ins_at;

        w = 0;
        for (r = 0; r < nactive; r++) {
            if (active[r]->end < iv->start) {
                pool[active[r]->reg - first_reg] = 1;
            } else {
                active[w++] = active[r];
            }
        }
        nactive = w;

        got = -1;
        for (k = 0; k < num_regs; k++) {
            if (pool[k]) {
                got = k + first_reg;
                pool[k] = 0;
                break;
            }
        }

        if (got >= 0) {
            iv->reg = got;
            ins_at = nactive;
            for (r = 0; r < nactive; r++) {
                if (active[r]->end > iv->end) {
                    ins_at = r;
                    break;
                }
            }
            for (r = nactive; r > ins_at; r--)
                active[r] = active[r - 1];
            active[ins_at] = iv;
            nactive++;
        } else {
            struct interval *sp = active[nactive - 1];
            if (sp->end > iv->end) {
                iv->reg = sp->reg;
                sp->reg = -1;
                sp->spill = nspills++ * spill_size;
                nactive--;
                ins_at = nactive;
                for (r = 0; r < nactive; r++) {
                    if (active[r]->end > iv->end) {
                        ins_at = r;
                        break;
                    }
                }
                for (r = nactive; r > ins_at; r--)
                    active[r] = active[r - 1];
                active[ins_at] = iv;
                nactive++;
            } else {
                iv->spill = nspills++ * spill_size;
            }
        }
    }

    for (p = 0; p < niv; p++) {
        fn->temp_reg[ivs[p].temp] = ivs[p].reg;
        fn->temp_spill[ivs[p].temp] = ivs[p].spill;
    }

    arena_release(fn->arena, m);
    return nspills;
}

void
regalloc(struct ir_func *fn)
{
    struct ir_insn *i;
    struct arena_mark m;
    int *first_def;
    int *last_use;
    int *is_float;
    int *is_i64;
    int *is_int;
    int ntemps;
    int pos;
    int t;
    int max_pair;
    int int_num_regs;

    ntemps = fn->ntemps;
    fn->temp_reg = arena_alloc(fn->arena,
                               ntemps > 0 ? ntemps * sizeof(int) : 1);
    fn->temp_spill = arena_alloc(fn->arena,
                                 ntemps > 0 ? ntemps * sizeof(int) : 1);
    for (t = 0; t < ntemps; t++) {
        fn->temp_reg[t] = -1;
        fn->temp_spill[t] = -1;
    }
    if (ntemps == 0) {
        fn->nspills = 0;
        fn->nfspills = 0;
        fn->ni64spills = 0;
        return;
    }

    m = arena_save(fn->arena);
    first_def = arena_alloc(fn->arena, ntemps * sizeof(int));
    last_use = arena_alloc(fn->arena, ntemps * sizeof(int));
    is_float = arena_zalloc(fn->arena, ntemps * sizeof(int));
    is_i64 = arena_zalloc(fn->arena, ntemps * sizeof(int));
    is_int = arena_alloc(fn->arena, ntemps * sizeof(int));
    for (t = 0; t < ntemps; t++) {
        first_def[t] = -1;
        last_use[t] = -1;
    }

    pos = 0;
    for (i = fn->head; i; i = i->next, pos++) {
        if (i->dst >= 0 && i->dst < ntemps) {
            if (first_def[i->dst] < 0)
                first_def[i->dst] = pos;
            if (last_use[i->dst] < pos)
                last_use[i->dst] = pos;
            if (ir_op_is_float_def(i->op))
                is_float[i->dst] = 1;
            else if (ir_op_is_i64_def(i->op))
                is_i64[i->dst] = 1;
        }
        if (i->a >= 0 && i->a < ntemps && last_use[i->a] < pos)
            last_use[i->a] = pos;
        if (i->b >= 0 && i->b < ntemps && last_use[i->b] < pos)
            last_use[i->b] = pos;
    }

    fn->ni64spills = linscan(fn, first_def, last_use,
                 is_i64, I64_NUM_PAIRS, I64_FIRST_PAIR, 8);

    max_pair = -1;
    for (t = 0; t < ntemps; t++) {
        if (is_i64[t] && fn->temp_reg[t] > max_pair)
            max_pair = fn->temp_reg[t];
    }
    int_num_regs = INT_NUM_REGS - 2 * (max_pair + 1);
    if (int_num_regs < 0)
        int_num_regs = 0;

    for (t = 0; t < ntemps; t++)
        is_int[t] = !is_float[t] && !is_i64[t];

    fn->nspills = linscan(fn, first_def, last_use,
                  is_int, int_num_regs, INT_FIRST_REG, 4);

    /* Float temps get their own callee-saved class (fs0..fs11), disjoint
       from the integer register file, so a float and an int temp may share
       an index without conflict. */
    fn->nfspills = linscan(fn, first_def, last_use,
                   is_float, FP_NUM_REGS, FP_FIRST_REG, 8);

    arena_release(fn->arena, m);
}
