/* regalloc_x86.c : linear-scan register allocator for i686 (IA-32) */
/*
 * Poletto & Sarkar (1999) linear-scan register allocation.
 *
 * i686 (IA-32, flat protected mode) register parameters
 * ------------------------------------------------------
 * Integer allocatable (callee-save): ebx, esi, edi  ->  3 regs, first = 0
 *   reg 0 = ebx, reg 1 = esi, reg 2 = edi
 *
 * I64 pair allocatable (callee-save): (esi, edi)  ->  1 pair
 *
 * FP allocatable (caller-save): xmm1..xmm7  ->  7 regs, first = 0
 *   reg 0 = xmm1, reg 1 = xmm2, ..., reg 6 = xmm7
 *
 * Reserved (integer):
 *   eax  return value / multiply-lo / scratch
 *   ecx  shift count / scratch
 *   edx  multiply-hi / scratch
 *   ebp  frame pointer
 *   esp  stack pointer
 *
 * Reserved (float):
 *   xmm0  return value / scratch
 *
 * The emitter inspects fn->temp_reg[t]:
 *   >= 0 -> register index (mapped to physical name by emitter)
 *   -1   -> spilled; fn->temp_spill[t] is the byte offset
 *           within the spill area.
 *
 * I64 pairs are allocated from the top of the callee-save pool.
 * When a pair is used, esi and edi are consumed, leaving only ebx
 * for integer allocation.
 *
 * fn->nspills    = integer spill slots (4 bytes each)
 * fn->nfspills   = float spill slots (8 bytes each)
 * fn->ni64spills = I64 spill slots (8 bytes each)
 */

#include "ir.h"

#include <stdlib.h>  /* qsort */

/* x86_select.c: the allocator-index (temp_reg value) of each integer register
   an extended asm pins or clobbers; the allocator reserves them. */
int x86_asm_reserved_regs(struct ir_func *fn, int *out, int max);


/* x86-64: rbx, r12-r15 (5 regs); i64 shares the int class (native, one reg) */
#define INT_NUM_REGS  5
#define INT_SPILL     8

#define INT_FIRST_REG 0
#define FP_NUM_REGS   7
#define FP_FIRST_REG  0

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

/* force_spill (may be NULL): temps that must not get a register (e.g. a float
   temp live across a call, since the SSE registers are all caller-saved). */
static int
linscan(struct ir_func *fn, int *first_def, int *last_use,
        int *is_class, int num_regs, int first_reg, int spill_size,
        int *force_spill, const int *reserved)
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
        pool[k] = (reserved && reserved[k]) ? 0 : 1;

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

        /* a temp that must spill never takes a register (no callee-saved SSE
           register exists to hold a float across a call) */
        if (force_spill && force_spill[iv->temp]) {
            iv->spill = nspills++ * spill_size;
            continue;
        }

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

/* mark each float temp whose live range strictly contains a call position: it
   must be spilled, since every SSE register is caller-saved */
static void
mark_float_cross(struct ir_func *fn, int *first_def, int *last_use,
                 int *is_float, int *call_pos, int ncall, int *out)
{
    int t, c;
    for (t = 0; t < fn->ntemps; t++) {
        out[t] = 0;
        if (!is_float[t] || first_def[t] < 0)
            continue;
        for (c = 0; c < ncall; c++)
            if (call_pos[c] > first_def[t] && call_pos[c] < last_use[t]) {
                out[t] = 1;
                break;
            }
    }
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

    /* call positions (for the float-across-call spill), and the resulting
       force-spill mask */
    int ninsn = 0;
    for (i = fn->head; i; i = i->next)
        ninsn++;
    int *call_pos = arena_alloc(fn->arena, (ninsn > 0 ? ninsn : 1) * sizeof(int));
    int *float_cross = arena_zalloc(fn->arena, ntemps * sizeof(int));
    int ncall = 0;

    /* One integer class covers both i32 and i64 (one native register each);
     * an IR_ARG operand is consumed at the following call, not the ARG, so
     * pending arg operands have their live range extended to the call (the
     * merged pool otherwise lets a temp defined between the ARG and the call
     * reuse the argument's register). Same latent gap as the arm64 backend. */
    int pending[16];
    int npending = 0;

    pos = 0;
    for (i = fn->head; i; i = i->next, pos++) {
        if (i->dst >= 0 && i->dst < ntemps) {
            if (first_def[i->dst] < 0)
                first_def[i->dst] = pos;
            if (last_use[i->dst] < pos)
                last_use[i->dst] = pos;
            if (ir_op_is_float_def(i->op))
                is_float[i->dst] = 1;
        }
        if (i->a >= 0 && i->a < ntemps && last_use[i->a] < pos)
            last_use[i->a] = pos;
        if (i->b >= 0 && i->b < ntemps && last_use[i->b] < pos)
            last_use[i->b] = pos;
        /* Extended inline asm operands live in asm_info, not i->a/i->b: an
           output is a def, an input a use, an in-out operand both. */
        if (i->op == IR_ASM && i->asm_info) {
            int k, nops = i->asm_info->noutputs + i->asm_info->ninputs;
            for (k = 0; k < nops; k++) {
                int at = i->asm_info->ops[k].temp;
                if (at < 0 || at >= ntemps)
                    continue;
                if ((i->asm_info->ops[k].is_output ||
                     i->asm_info->ops[k].is_inout) && first_def[at] < 0)
                    first_def[at] = pos;
                if (last_use[at] < pos)
                    last_use[at] = pos;
            }
        }

        if (i->op == IR_ARG || i->op == IR_ARG64 || i->op == IR_FARG ||
            i->op == IR_ARG_MEM) {
            if (npending < 16)
                pending[npending++] = i->a;
        } else if (i->op == IR_CALL || i->op == IR_CALLI ||
                   i->op == IR_CALL64 || i->op == IR_CALLI64 ||
                   i->op == IR_FCALL || i->op == IR_FCALLI ||
                   i->op == IR_CALL_AGG || i->op == IR_CALLI_AGG ||
                   i->op == IR_TAILCALL || i->op == IR_TAILCALLI) {
            int k;
            for (k = 0; k < npending; k++)
                if (pending[k] >= 0 && pending[k] < ntemps &&
                    last_use[pending[k]] < pos)
                    last_use[pending[k]] = pos;
            npending = 0;
            call_pos[ncall++] = pos;
        }
    }

    (void)is_i64;
    (void)max_pair;
    (void)int_num_regs;
    for (t = 0; t < ntemps; t++)
        is_int[t] = !is_float[t];

    mark_float_cross(fn, first_def, last_use, is_float, call_pos, ncall,
                     float_cross);
    fn->ni64spills = 0;

    /* Reserve any integer register an extended asm pins or clobbers.  i32 and
       i64 share one integer pool here, so reserving it covers both; there is
       no separate i64-pair pool to guard against. */
    int reserved[INT_NUM_REGS];
    int pinned[INT_NUM_REGS], npinned, pk, rk;
    for (rk = 0; rk < INT_NUM_REGS; rk++)
        reserved[rk] = 0;
    npinned = x86_asm_reserved_regs(fn, pinned, INT_NUM_REGS);
    for (pk = 0; pk < npinned; pk++) {
        int slot = pinned[pk] - INT_FIRST_REG;
        if (slot >= 0 && slot < INT_NUM_REGS)
            reserved[slot] = 1;
    }

    fn->nspills = linscan(fn, first_def, last_use,
                  is_int, INT_NUM_REGS, INT_FIRST_REG, INT_SPILL, NULL, reserved);
    fn->nfspills = linscan(fn, first_def, last_use,
                   is_float, FP_NUM_REGS, FP_FIRST_REG, 8, float_cross, NULL);

    arena_release(fn->arena, m);
}
