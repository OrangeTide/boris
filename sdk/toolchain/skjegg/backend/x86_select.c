/* x86_select.c : the shared x86-64 instruction selector (see x86_select.h).

   Lifted from the JIT's emit_func: the register model, frame geometry, operand
   materialization, SysV call marshalling, prologue/epilogue, and the per-opcode
   switch, all expressed against the backend/mc.h sink.  The AOT (text) and JIT
   (byte) paths supply the sink; this selection logic is shared. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ir.h"
#include "target.h"
#include "mc.h"
#include "x86_select.h"


/****************************************************************
 * Register model
 *
 * The allocator hands out five callee-saved integer registers by index;
 * map them to hardware here. The emitter keeps rax/rcx/rdx/r10/r11 as
 * within-instruction scratch (all caller-saved), and passes arguments in
 * the SysV order. The prologue saves and the epilogue restores all five
 * allocatable registers, so any assignment the allocator makes is safe.
 ****************************************************************/

static const int intreg[5] = { MC_RBX, MC_R12, MC_R13, MC_R14, MC_R15 };
static const int argreg[6] = { MC_RDI, MC_RSI, MC_RDX, MC_RCX, MC_R8, MC_R9 };

/* The FP allocator hands out xmm1..xmm7 (index 0..6); xmm0 and xmm8 are left
   free as float scratch. Float arguments and returns use xmm0..xmm7. */
static const int fpreg[7] = { MC_XMM1, MC_XMM2, MC_XMM3, MC_XMM4, MC_XMM5,
                              MC_XMM6, MC_XMM7 };
static const int fargreg[8] = { MC_XMM0, MC_XMM1, MC_XMM2, MC_XMM3,
                                MC_XMM4, MC_XMM5, MC_XMM6, MC_XMM7 };

#define SC0 MC_R10       /* integer scratch A */
#define SC1 MC_R11       /* integer scratch B */
#define FSC0 MC_XMM0     /* float scratch A */
#define FSC1 MC_XMM8     /* float scratch B */
#define SAVED 40        /* bytes of pushed callee-saved registers (5 * 8) */

/* Per-temp float storage format: 1 when a float temp holds f32 (single) format in
   its xmm, 0 when f64.  The C front end keeps `float` as f32 in registers while the
   Kobold front end keeps every float as f64, so a single value crossing a call
   (FARG/FCALL/FRETV with FWIDTH_F32) is converted only when the temp's format
   differs from the f32 wire width.  Set per function in x86_select_func. */
static const unsigned char *g_f32;
static int src_is_f32(int t) { return g_f32 && t >= 0 && g_f32[t]; }

/* Per-function frame geometry, all measured downward from rbp. */
struct frame {
    int *slot_off;      /* slot k's low byte sits at rbp - (SAVED + slot_off[k]) */
    int spill_base;     /* start of the integer spill area */
    int fspill_base;    /* start of the float spill area */
    int va_disp;        /* rbp displacement of the 176-byte SysV register save
                           area (variadic only; 0 otherwise) */
    int size;           /* bytes to subtract from rsp */
};


/* Signed condition-code for a compare opcode, or -1 if not a compare. */
static int
cc_of(int op)
{
    switch (op) {
    case IR_CMPEQ:  return MC_E;
    case IR_CMPNE:  return MC_NE;
    case IR_CMPLTS: return MC_L;
    case IR_CMPLES: return MC_LE;
    case IR_CMPGTS: return MC_G;
    case IR_CMPGES: return MC_GE;
    case IR_CMPLTU: return MC_B;
    case IR_CMPLEU: return MC_BE;
    case IR_CMPGTU: return MC_A;
    case IR_CMPGEU: return MC_AE;
    default: return -1;
    }
}

/* Stack displacement of slot k and of the spill home of temp t. */
static int
slot_disp(struct frame *fr, int k)
{
    return -(SAVED + fr->slot_off[k]);
}

static int
spill_disp(struct frame *fr, struct ir_func *fn, int t)
{
    return -(SAVED + fr->spill_base + fn->temp_spill[t] + 8);
}

static int
fspill_disp(struct frame *fr, struct ir_func *fn, int t)
{
    return -(SAVED + fr->fspill_base + fn->temp_spill[t] + 8);
}

/****************************************************************
 * Operand materialization
 ****************************************************************/

/* Load temp t (its full 64-bit home, which holds a value in the low 32 bits
   or a native address) into physical register `into`. */
/* The operand helpers below index fn->temp_reg[t] / fn->temp_spill[t] by a temp
   number. The toolkit's own front ends only ever pass a real temp, but the KPM
   reader is an untrusted boundary: an instruction that omits a temp operand the
   opcode uses leaves it at ir_emit's -1 default, which would index one slot
   before the table. The reader bounds every temp to < ntemps; the remaining
   case is this -1 "none" sentinel (the one the backend already tolerates for a
   discarded dst). Each helper treats t < 0 as that sentinel: a read yields a
   harmless value (stack memory at [rbp], never computed into anything a valid
   program observes) and a write-back is skipped, so a malformed module compiles
   to safe, meaningless code rather than driving an out-of-bounds access. */
static void
mat(struct mc *m, struct ir_func *fn, struct frame *fr, int t, int into)
{
    if (t < 0) {
        mc_load64(m, into, MC_RBP, 0);
        return;
    }
    if (fn->temp_reg[t] >= 0) {
        int src = intreg[fn->temp_reg[t]];
        if (src != into)
            mc_mov_rr(m, into, src);
    } else {
        mc_load64(m, into, MC_RBP, spill_disp(fr, fn, t));
    }
}

/* Store physical register `from` back into temp t's home. */
static void
wb(struct mc *m, struct ir_func *fn, struct frame *fr, int t, int from)
{
    if (t < 0)
        return;
    if (fn->temp_reg[t] >= 0) {
        int dst = intreg[fn->temp_reg[t]];
        if (dst != from)
            mc_mov_rr(m, dst, from);
    } else {
        mc_store64(m, MC_RBP, spill_disp(fr, fn, t), from);
    }
}

/* The float counterparts: a float temp lives in an xmm register from the FP
   pool or an 8-byte slot in the float spill area. */
static void
matf(struct mc *m, struct ir_func *fn, struct frame *fr, int t, int into)
{
    if (t < 0) {
        mc_movsd_load(m, into, MC_RBP, 0);
        return;
    }
    if (fn->temp_reg[t] >= 0) {
        int src = fpreg[fn->temp_reg[t]];
        if (src != into)
            mc_movsd_rr(m, into, src);
    } else {
        mc_movsd_load(m, into, MC_RBP, fspill_disp(fr, fn, t));
    }
}

static void
wbf(struct mc *m, struct ir_func *fn, struct frame *fr, int t, int from)
{
    if (t < 0)
        return;
    if (fn->temp_reg[t] >= 0) {
        int dst = fpreg[fn->temp_reg[t]];
        if (dst != from)
            mc_movsd_rr(m, dst, from);
    } else {
        mc_movsd_store(m, MC_RBP, fspill_disp(fr, fn, t), from);
    }
}

/* ---- In-place operand model.
 *
 * mat/wb above always route a value through a fixed scratch register, which is
 * simple but costs a move per operand even when the temp already lives in a
 * register.  The helpers below instead name the temp's own register: a
 * register-allocated temp is read and written in place, and only a spilled temp
 * touches the scratch register (a reload for a source, a store-back for a
 * destination).  This is the shape the AOT's x86_emit.c used, and it keeps the
 * common register-to-register case at one or two instructions.
 *
 * A temp's home is 64 bits (an i32 in the low half, or a full i64/address), so
 * a reload and a store-back are always 64-bit, exactly as mat/wb do; only the
 * arithmetic that follows narrows to 32 bits.  An allocated integer register is
 * one of intreg[] (rbx/r12-r15), never a scratch (rax/rcx/rdx/r10/r11), so a
 * source register never collides with the SC0/SC1 scratch a sibling operand
 * reloads into. */

/* The register holding integer source temp t: its own register, or `scr` after
   reloading a spilled temp into it. */
static int
rs(struct mc *m, struct ir_func *fn, struct frame *fr, int t, int scr)
{
    if (t < 0) {
        mc_load64(m, scr, MC_RBP, 0);
        return scr;
    }
    if (fn->temp_reg[t] >= 0)
        return intreg[fn->temp_reg[t]];
    mc_load64(m, scr, MC_RBP, spill_disp(fr, fn, t));
    return scr;
}

/* The register to compute destination temp t into: its own register, or the
   scratch `scr`, which wd then stores back. */
static int
rd(struct ir_func *fn, int t, int scr)
{
    if (t < 0)
        return scr;
    return fn->temp_reg[t] >= 0 ? intreg[fn->temp_reg[t]] : scr;
}

/* Store `reg` back into a spilled destination's home; a no-op for a temp that
   was computed in its own register. */
static void
wd(struct mc *m, struct ir_func *fn, struct frame *fr, int t, int reg)
{
    if (t < 0)
        return;
    if (fn->temp_reg[t] < 0)
        mc_store64(m, MC_RBP, spill_disp(fr, fn, t), reg);
}

/* The float counterparts. */
static int
frs(struct mc *m, struct ir_func *fn, struct frame *fr, int t, int scr)
{
    if (t < 0) {
        mc_movsd_load(m, scr, MC_RBP, 0);
        return scr;
    }
    if (fn->temp_reg[t] >= 0)
        return fpreg[fn->temp_reg[t]];
    mc_movsd_load(m, scr, MC_RBP, fspill_disp(fr, fn, t));
    return scr;
}

static int
frd(struct ir_func *fn, int t, int scr)
{
    if (t < 0)
        return scr;
    return fn->temp_reg[t] >= 0 ? fpreg[fn->temp_reg[t]] : scr;
}

static void
fwd(struct mc *m, struct ir_func *fn, struct frame *fr, int t, int reg)
{
    if (t < 0)
        return;
    if (fn->temp_reg[t] < 0)
        mc_movsd_store(m, MC_RBP, fspill_disp(fr, fn, t), reg);
}

/* Move the pending call arguments into their registers. Integer and float
   arguments consume separate register sequences under the SysV ABI. */
/* Marshal the pending call arguments into the SysV registers and, past the
   register capacity, onto the stack.  Returns the number of bytes reserved on
   the stack, which the caller pops after the call returns. */
static int
marshal(struct mc *m, struct ir_func *fn, struct frame *fr,
        int *pend_temp, char *pend_isf, char *pend_fw, int *pend_msize,
        int npending)
{
    int gi = 0, fi = 0, stack_bytes = 0, nfreg = 0, stage, stagebase, space, off, fj;

    /* SysV passes the first six integer arguments in registers and the first
       eight float arguments in xmm registers; the rest go on the stack, in
       source order, the leftmost at the lowest address.  A MEMORY-class struct
       argument (pend_msize > 0) is always a stack copy, occupying its rounded
       byte size.  Count the stack bytes and reserve a 16-aligned block so rsp
       stays 16-aligned at the call (the body already runs with rsp 16-aligned).

       Float register arguments need care: their source temps live in xmm1-7,
       which overlap the xmm0-7 argument registers, so loading them one at a time
       would clobber a source a later argument has not yet consumed.  With two or
       more float register arguments they are staged through a private scratch
       region just above the ABI stack-argument area: every float source is read
       into FSC1 (xmm8, neither an argument register nor a temp home) and stored
       before any xmm0-7 register is written, then reloaded into the argument
       registers.  Integer argument registers never overlap the integer temp
       homes, and a single float register argument cannot clobber anything, so
       both load directly. */
    for (int i = 0; i < npending; i++) {
        if (pend_msize[i] > 0)      stack_bytes += (pend_msize[i] + 7) & ~7;
        else if (pend_isf[i])     { if (fi++ >= 8) stack_bytes += 8; else nfreg++; }
        else                      { if (gi++ >= 6) stack_bytes += 8; }
    }
    stage = nfreg >= 2;
    stagebase = stack_bytes;             /* staging sits above the ABI args */
    space = (stack_bytes + (stage ? nfreg * 8 : 0) + 15) & ~15;
    if (space)
        mc_sub_ri32(m, MC_RSP, space);

    /* 1. Place the ABI stack arguments (structs, overflow ints, overflow floats)
          and, when staging, each float register argument into the staging region.
          All float sources are read (into FSC1) before any xmm0-7 argument
          register is written in pass 3. */
    gi = fi = off = fj = 0;
    for (int i = 0; i < npending; i++) {
        if (pend_msize[i] > 0) {
            /* copy the struct's bytes to [rsp+off]; the address is in the temp */
            int rem = pend_msize[i], o = 0;
            mat(m, fn, fr, pend_temp[i], SC1);   /* struct address */
            while (rem >= 8) {
                mc_load64(m, SC0, SC1, o);
                mc_store64(m, MC_RSP, off + o, SC0);
                o += 8; rem -= 8;
            }
            if (rem >= 4) {
                mc_load32(m, SC0, SC1, o);
                mc_store32(m, MC_RSP, off + o, SC0);
                o += 4; rem -= 4;
            }
            if (rem >= 2) {
                mc_load16(m, SC0, SC1, o);
                mc_store16(m, MC_RSP, off + o, SC0);
                o += 2; rem -= 2;
            }
            if (rem >= 1) {
                mc_load8(m, SC0, SC1, o);
                mc_store8(m, MC_RSP, off + o, SC0);
            }
            off += (pend_msize[i] + 7) & ~7;
        } else if (pend_isf[i]) {
            /* a single is narrowed to f32 (movss); a double keeps its 8-byte store */
            /* a single wire width narrows an f64-format source to f32; a source
               already in f32 format (the C front end) moves as-is */
            int narrow = pend_fw[i] && !src_is_f32(pend_temp[i]);
            if (fi >= 8) {
                matf(m, fn, fr, pend_temp[i], FSC1);
                if (narrow)
                    mc_cvtsd2ss_rr(m, FSC1, FSC1);
                if (pend_fw[i])
                    mc_movss_store(m, MC_RSP, off, FSC1);
                else
                    mc_movsd_store(m, MC_RSP, off, FSC1);
                off += 8;
            } else if (stage) {
                matf(m, fn, fr, pend_temp[i], FSC1);
                if (narrow)
                    mc_cvtsd2ss_rr(m, FSC1, FSC1);
                if (pend_fw[i])
                    mc_movss_store(m, MC_RSP, stagebase + 8 * fj, FSC1);
                else
                    mc_movsd_store(m, MC_RSP, stagebase + 8 * fj, FSC1);
                fj++;
            }
            fi++;
        } else {
            if (gi >= 6) {
                mat(m, fn, fr, pend_temp[i], SC0);
                mc_store64(m, MC_RSP, off, SC0);
                off += 8;
            }
            gi++;
        }
    }

    /* 2. Integer register arguments (rdi..r9 never overlap the integer temp
          homes rbx,r12-r15, so these load directly). */
    gi = 0;
    for (int i = 0; i < npending; i++) {
        if (pend_msize[i] > 0 || pend_isf[i])
            continue;
        if (gi < 6)
            mat(m, fn, fr, pend_temp[i], argreg[gi]);
        gi++;
    }

    /* 3. Float register arguments: from the staging region when staged (no source
          is an xmm0-7 argument register now), else loaded directly.  A single is
          narrowed to f32. */
    fi = fj = 0;
    for (int i = 0; i < npending; i++) {
        if (pend_msize[i] > 0 || !pend_isf[i])
            continue;
        if (fi < 8) {
            if (stage) {
                if (pend_fw[i])
                    mc_movss_load(m, fargreg[fi], MC_RSP, stagebase + 8 * fj);
                else
                    mc_movsd_load(m, fargreg[fi], MC_RSP, stagebase + 8 * fj);
                fj++;
            } else {
                matf(m, fn, fr, pend_temp[i], fargreg[fi]);
                if (pend_fw[i] && !src_is_f32(pend_temp[i]))
                    mc_cvtsd2ss_rr(m, fargreg[fi], fargreg[fi]);
            }
        }
        fi++;
    }
    /* al = number of SSE registers used, which a variadic callee reads.  Set
       last so no later arg load clobbers it; a module (rel32) or indirect (r11)
       call preserves it, and an imported host function is never variadic. */
    mc_mov_ri32(m, MC_RAX, fi > 8 ? 8 : fi);
    return space;
}

/****************************************************************
 * Function emit
 ****************************************************************/

static void
prologue(struct mc *m, struct ir_func *fn, struct frame *fr)
{
    mc_push_r(m, MC_RBP);
    mc_mov_rr(m, MC_RBP, MC_RSP);
    mc_push_r(m, MC_RBX);
    mc_push_r(m, MC_R12);
    mc_push_r(m, MC_R13);
    mc_push_r(m, MC_R14);
    mc_push_r(m, MC_R15);
    if (fr->size)
        mc_sub_ri32(m, MC_RSP, fr->size);
    /* Spill each incoming parameter into its slot (slots 0..nparams-1 are the
       parameters), following the System V AMD64 classification so a struct
       parameter (1-2 eightbytes each INTEGER or SSE) is reconstructed
       contiguously in its slot.  Integer and SSE arguments consume separate
       register sequences; an argument past the register capacity, and a MEMORY
       (>16 byte) or register-classed struct whose eightbytes do not all fit,
       arrives on the incoming stack.  The caller placed the leftmost such
       eightbyte just above the return address, at [rbp+16], the next at
       [rbp+24], and so on.  Copy each into its slot through r10 / xmm8
       (scratch, not argument registers). */
    int int_used = 0, sse_used = 0, si = 0;
    for (int i = 0; i < fn->nparams; i++) {
        int base = slot_disp(fr, i);
        int sz = fn->slot_size ? fn->slot_size[i] : 4;
        int w8 = sz >= 8;               /* store 8 bytes (i64/ptr/struct) or 4 */
        int neb = fn->param_neb ? fn->param_neb[i] : 1;
        int mem = fn->param_cls && fn->param_cls[4 * i] == -2;
        int single = neb == 1 && fn->param_fw && fn->param_fw[i];
        int need_i = 0, need_s = 0, j;
        if (neb < 1)
            neb = 1;
        if (!mem)
            for (j = 0; j < neb; j++) {
                int cls = fn->param_cls ? fn->param_cls[4 * i + j] : 0;
                if (cls == 1) need_s++; else need_i++;
            }
        /* MEMORY, or eightbytes that do not all fit: read neb eightbytes from
           the incoming stack (all-or-nothing, matching the caller). */
        if (mem || int_used + need_i > 6 || sse_used + need_s > 8) {
            for (j = 0; j < neb; j++) {
                if (w8 || j > 0) {
                    mc_load64(m, SC0, MC_RBP, 16 + 8 * (si + j));
                    mc_store64(m, MC_RBP, base + 8 * j, SC0);
                } else {
                    mc_load32(m, SC0, MC_RBP, 16 + 8 * (si + j));
                    mc_store32(m, MC_RBP, base + 8 * j, SC0);
                }
            }
            si += neb;
            continue;
        }
        /* every eightbyte fits in registers: store each into base+8*j */
        for (j = 0; j < neb; j++) {
            int cls = fn->param_cls ? fn->param_cls[4 * i + j] : 0;
            if (cls == 1) {
                if (single)
                    mc_movss_store(m, MC_RBP, base + 8 * j, fargreg[sse_used++]);
                else
                    mc_movsd_store(m, MC_RBP, base + 8 * j, fargreg[sse_used++]);
            } else if (w8 || j > 0) {
                mc_store64(m, MC_RBP, base + 8 * j, argreg[int_used++]);
            } else {
                mc_store32(m, MC_RBP, base + 8 * j, argreg[int_used++]);
            }
        }
    }
    /* Variadic: save all six gp argument registers (48 bytes) then all eight
       xmm argument registers (16 bytes each) into the register save area, the
       backing __va_arg walks.  Named params were already spilled into their
       slots above; saving the registers again here is harmless (va_arg skips
       the named ones via gp_offset/fp_offset). */
    if (fn->is_variadic) {
        int k;
        for (k = 0; k < 6; k++)
            mc_store64(m, MC_RBP, fr->va_disp + 8 * k, argreg[k]);
        for (k = 0; k < 8; k++)
            mc_movsd_store(m, MC_RBP, fr->va_disp + 48 + 16 * k, fargreg[k]);
    }
}

static void
epilogue(struct mc *m, struct frame *fr)
{
    if (fr->size)
        mc_add_ri32(m, MC_RSP, fr->size);
    mc_pop_r(m, MC_R15);
    mc_pop_r(m, MC_R14);
    mc_pop_r(m, MC_R13);
    mc_pop_r(m, MC_R12);
    mc_pop_r(m, MC_RBX);
    mc_pop_r(m, MC_RBP);
    mc_ret(m);
}

/* Map an IR label number to its mc label id, allocating one on first use. */
static int
il(struct mc *m, int *lbl, int n)
{
    if (lbl[n] < 0)
        lbl[n] = mc_new_label(m);
    return lbl[n];
}

/* x86-64 register names by hardware number, for extended-asm %N substitution. */
static const char *x86_reg64[16] = {
    "rax", "rcx", "rdx", "rbx", "rsp", "rbp", "rsi", "rdi",
    "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
};
static const char *x86_reg32[16] = {
    "eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi",
    "r8d", "r9d", "r10d", "r11d", "r12d", "r13d", "r14d", "r15d",
};

/* A register name (64- or 32-bit, with or without a leading %) to its hardware
   number, or -1.  Used to resolve a pin name and match a clobber. */
static int
x86_name_to_hw(const char *name)
{
    int h;
    if (name[0] == '%')
        name++;
    for (h = 0; h < 16; h++)
        if (strcmp(x86_reg64[h], name) == 0 || strcmp(x86_reg32[h], name) == 0)
            return h;
    return -1;
}

static int
asm_hw_clobbered(struct ir_asm_info *ai, int h)
{
    int k;
    for (k = 0; k < ai->nclobbers; k++)
        if (x86_name_to_hw(ai->clobbers[k]) == h)
            return 1;
    return 0;
}

static int x86_op_forced(struct ir_asm_op *op);

/* Is physical register `h` forced (pinned or constrained to a single register)
   by any operand?  Used to keep a spilled generic operand's pool register off
   a forced register. */
static int
asm_hw_pinned(struct ir_asm_info *ai, int h)
{
    int k, n = ai->noutputs + ai->ninputs;
    for (k = 0; k < n; k++)
        if (x86_op_forced(&ai->ops[k]) == h)
            return 1;
    return 0;
}

/* The allocator index (temp_reg value) of hardware register `h`, or -1 if `h`
   is not allocatable. */
static int
x86_hw_to_index(int h)
{
    int k;
    for (k = 0; k < 5; k++)
        if (intreg[k] == h)
            return k;
    return -1;
}

/* A single-register-class constraint maps to one physical register, like a
   pin: "a"=rax, "b"=rbx, "c"=rcx, "d"=rdx, "S"=rsi, "D"=rdi (the leading
   =/+/&/% modifier is skipped).  Any other class (the general "r") returns -1,
   meaning the operand may go in any register. */
static int
x86_constraint_reg(const char *c)
{
    while (*c == '=' || *c == '+' || *c == '&' || *c == '%')
        c++;
    switch (*c) {
    case 'a': return MC_RAX;
    case 'b': return MC_RBX;
    case 'c': return MC_RCX;
    case 'd': return MC_RDX;
    case 'S': return MC_RSI;
    case 'D': return MC_RDI;
    default:  return -1;
    }
}

/* The physical register an operand is forced into (a pin or a single-register
   constraint), or -1 for a general "r" operand.  Dies on an unknown pin. */
static int
x86_op_forced(struct ir_asm_op *op)
{
    if (op->pin_reg) {
        int h = x86_name_to_hw(op->pin_reg);
        if (h < 0)
            die("x86: unknown asm register %s", op->pin_reg);
        return h;
    }
    return x86_constraint_reg(op->constraint);
}

/* Fill out[] (capacity max) with the allocator indices of the allocatable
   registers any extended asm in fn pins, forces by constraint, or clobbers,
   deduplicated. */
int
x86_asm_reserved_regs(struct ir_func *fn, int *out, int max)
{
    struct ir_insn *i;
    int n = 0, k, j;

    for (i = fn->head; i; i = i->next) {
        struct ir_asm_info *ai = i->asm_info;
        if (i->op != IR_ASM || !ai)
            continue;
        for (k = 0; k < ai->noutputs + ai->ninputs; k++) {
            int h = x86_op_forced(&ai->ops[k]);
            int idx = h < 0 ? -1 : x86_hw_to_index(h);
            if (idx < 0)
                continue;
            for (j = 0; j < n && out[j] != idx; j++)
                ;
            if (j == n && n < max)
                out[n++] = idx;
        }
        for (k = 0; k < ai->nclobbers; k++) {
            int h = x86_name_to_hw(ai->clobbers[k]);
            int idx = h < 0 ? -1 : x86_hw_to_index(h);
            if (idx < 0)
                continue;
            for (j = 0; j < n && out[j] != idx; j++)
                ;
            if (j == n && n < max)
                out[n++] = idx;
        }
    }
    return n;
}

/* Extended inline asm.  A generic "r" operand goes in its allocated register
 * or a scratch materialised from the spill slot; a pinned operand goes in the
 * named physical register (its value moved in from the operand temp's home
 * and, for an output, back out).  Each %N is substituted with the AT&T
 * register name at the operand's width (%rax for an 8-byte operand, %eax for a
 * 4-byte one) and the template is emitted as one text blob.  This is the
 * syscall case: rax/rdi/rsi/rdx/r10 are not allocatable, so the pins are free. */
static void
emit_asm_ext(struct mc *m, struct ir_func *fn, struct frame *fr,
             struct ir_insn *i)
{
    struct ir_asm_info *ai = i->asm_info;
    int n = ai->noutputs + ai->ninputs;
    static const int pool[] = { MC_RAX, MC_RCX, MC_RDX, MC_R10, MC_R11 };
    int npool = (int)(sizeof pool / sizeof pool[0]);
    int ophw[32];               /* the register each operand uses */
    int forced[32];             /* its forced hw (pin/single-reg), or -1 */
    int next = 0, k;
    const char *s;
    char buf[1024];
    size_t bp = 0;

    if (n > 32)
        die("x86: too many asm operands");

    for (k = 0; k < n; k++) {
        struct ir_asm_op *op = &ai->ops[k];
        int j, h = x86_op_forced(op);

        forced[k] = h;
        if (h >= 0) {
            /* an allocatable forced register is fine: the allocator reserved
               it (x86_asm_reserved_regs).  Two operands may share a forced
               register only as a pure output + pure input pair (the input is
               moved in before the template, the output moved out after); any
               other overlap is a real conflict. */
            for (j = 0; j < k; j++) {
                if (forced[j] != h)
                    continue;
                int jp_in = ai->ops[j].is_output == 0;
                int jp_out = ai->ops[j].is_output && !ai->ops[j].is_inout;
                int kp_in = op->is_output == 0;
                int kp_out = op->is_output && !op->is_inout;
                if (!((jp_in && kp_out) || (jp_out && kp_in)))
                    die("x86: conflicting asm operands forced to one register");
            }
            ophw[k] = h;
        } else if (fn->temp_reg[op->temp] >= 0) {
            ophw[k] = intreg[fn->temp_reg[op->temp]];
        } else {
            ophw[k] = -1;
        }
    }
    for (k = 0; k < n; k++) {
        if (ophw[k] >= 0)
            continue;
        while (next < npool && (asm_hw_clobbered(ai, pool[next]) ||
                                asm_hw_pinned(ai, pool[next])))
            next++;
        if (next >= npool)
            die("x86: too many spilled asm operands");
        ophw[k] = pool[next++];
    }

    /* materialise input values (the home is 64-bit, so moves are 64-bit) */
    for (k = 0; k < n; k++) {
        struct ir_asm_op *op = &ai->ops[k];
        int home = fn->temp_reg[op->temp];

        if (op->is_output && !op->is_inout)
            continue;
        if (forced[k] >= 0) {
            if (home >= 0)
                mc_mov_rr(m, ophw[k], intreg[home]);
            else
                mc_load64(m, ophw[k], MC_RBP, spill_disp(fr, fn, op->temp));
        } else if (home < 0) {
            mc_load64(m, ophw[k], MC_RBP, spill_disp(fr, fn, op->temp));
        }
    }

    /* build the template with %N substituted (width from the operand size) */
    for (s = i->sym; *s && bp + 1 < sizeof buf; s++) {
        if (*s != '%') {
            buf[bp++] = *s;
            continue;
        }
        s++;
        if (*s == '%') {
            buf[bp++] = '%';
        } else if (*s >= '0' && *s <= '9') {
            int idx = 0;
            const char *nm;
            while (*s >= '0' && *s <= '9')
                idx = idx * 10 + (*s++ - '0');
            s--;
            if (idx >= n)
                die("x86: asm operand %%%d out of range", idx);
            /* the mc_text sink emits GNU intel syntax, so a register name
               carries no % prefix (the template is Intel too) */
            nm = ai->ops[idx].size >= 8 ? x86_reg64[ophw[idx]]
                                        : x86_reg32[ophw[idx]];
            while (*nm && bp + 1 < sizeof buf)
                buf[bp++] = *nm++;
        } else {
            buf[bp++] = '%';
            if (bp + 1 < sizeof buf)
                buf[bp++] = *s;
        }
    }
    buf[bp] = '\0';
    mc_asm(m, buf);

    /* store outputs back */
    for (k = 0; k < ai->noutputs; k++) {
        struct ir_asm_op *op = &ai->ops[k];
        int home = fn->temp_reg[op->temp];

        if (forced[k] >= 0) {
            if (home >= 0)
                mc_mov_rr(m, intreg[home], ophw[k]);
            else
                mc_store64(m, MC_RBP, spill_disp(fr, fn, op->temp), ophw[k]);
        } else if (home < 0) {
            mc_store64(m, MC_RBP, spill_disp(fr, fn, op->temp), ophw[k]);
        }
    }
}

/* Emit one function's body through the mc sink.  Branch targets are mc labels
   the sink resolves; intra-module calls and code-pointer fixups are deferred by
   the sink's mc_call_sym / mc_lea_sym. */
int
x86_select_func(struct mc *m, struct ir_func *fn, int tp,
                char *err, size_t errlen)
{
    struct frame fr;
    int *lbl;               /* IR label number -> mc label id (allocated lazily) */
    int pend_temp[32], npending = 0;
    char pend_isf[32];
    char pend_fw[32];
    int pend_msize[32];
    char *is_float;
    unsigned char *f32fmt;
    int off, rc = 0;

    /* frame geometry */
    fr.slot_off = malloc((fn->nslots > 0 ? fn->nslots : 1) * sizeof(int));
    off = 0;
    for (int k = 0; k < fn->nslots; k++) {
        int sz = fn->slot_size ? fn->slot_size[k] : 4;
        if (sz <= 0)
            sz = 8;
        /* IR_LDL/IR_STL access a scalar slot four bytes wide (eight for an
           i64/pointer), so a sub-word slot (a char or short local, slot_size
           1 or 2) must still reserve the full access width, or a store spills
           into the next slot.  Reserve at least four bytes and keep the stride
           4-aligned; larger (aggregate) slots keep their own size. */
        if (sz < 4)
            sz = 4;
        sz = (sz + 3) & ~3;
        off += sz;
        fr.slot_off[k] = off;
    }
    fr.spill_base = off;
    fr.fspill_base = off + fn->nspills * 8;
    off += fn->nspills * 8 + fn->nfspills * 8;
    /* A variadic function reserves a 176-byte SysV register save area (6 gp
       registers of 8 bytes, then 8 xmm registers of 16 bytes) that the
       prologue fills and __va_arg walks. */
    fr.va_disp = 0;
    if (fn->is_variadic) {
        off += 176;
        fr.va_disp = -(SAVED + off);
    }
    fr.size = ((off + 15) & ~15) + 8;

    /* classify each temp exactly as the allocator did, so temp_reg is read
       against the right register file */
    is_float = calloc((size_t)(fn->ntemps > 0 ? fn->ntemps : 1), 1);
    f32fmt = calloc((size_t)(fn->ntemps > 0 ? fn->ntemps : 1), 1);
    for (struct ir_insn *in = fn->head; in; in = in->next)
        if (in->dst >= 0 && in->dst < fn->ntemps)
            is_float[in->dst] = (char)ir_op_is_float_def(in->op);
    ir_classify_f32(fn, f32fmt);
    g_f32 = f32fmt;

    lbl = malloc((size_t)(fn->nlabels > 0 ? fn->nlabels : 1) * sizeof(int));
    for (int k = 0; k < fn->nlabels; k++)
        lbl[k] = -1;

    prologue(m, fn, &fr);

    for (struct ir_insn *in = fn->head; in && rc == 0; in = in->next) {
        int cc = cc_of(in->op);
        if (cc >= 0) {
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sb = rs(m, fn, &fr, in->b, SC1);
            int sd = rd(fn, in->dst, SC0);
            mc_cmp32_rr(m, sa, sb);      /* reads a, b before sd overwrites them */
            mc_setcc_r(m, cc, sd);
            mc_movzx_rb(m, sd, sd);
            wd(m, fn, &fr, in->dst, sd);
            continue;
        }
        switch (in->op) {
        case IR_LOC:
            /* A debug marker: no code, just note the line at this offset. */
            mc_loc(m, (int)in->imm);
            break;
        case IR_NOP:
        case IR_MARK:
        case IR_FUNC:   /* function-body delimiters skjegg's front ends emit; */
        case IR_ENDF:   /* the ir_func struct already frames the body here */
        case IR_LABEL:
            if (in->op == IR_LABEL && in->label >= 0)
                mc_label(m, il(m, lbl, in->label));
            break;
        case IR_LIC: {
            int sd = rd(fn, in->dst, SC0);
            mc_mov_ri32(m, sd, (uint32_t)in->imm);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_LIC64: {       /* a 64-bit immediate: a set literal's bitmask */
            int sd = rd(fn, in->dst, SC0);
            mc_mov_ri64(m, sd, (uint64_t)in->imm);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_LEA:
        case IR_LEA64: {
            /* the address of a data global or a function's code.  The 32-bit
               (ILP32) and 64-bit (LP64) forms select the same instruction: the
               sink loads the symbol's full address (mc_lea_sym), and the
               narrow-view write of an ILP32 result keeps only the low 32 bits. */
            int sd = rd(fn, in->dst, SC0);
            mc_lea_sym(m, sd, in->sym);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_LABADDR:
        case IR_LABADDR64: {
            /* the address of a local code label, for a threaded/computed jump:
               the IR_LEA analog over a label id rather than a symbol name.  The
               x86 spill path is uniformly 64-bit (wd / rs use mc_store64 /
               mc_load64), so the 32- and 64-bit pointer forms select the same
               code: mc_lea_label is a REX.W RIP-relative lea either way. */
            int sd = rd(fn, in->dst, SC0);
            mc_lea_label(m, sd, il(m, lbl, in->label));
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_LB:            /* load one byte, zero-extended (a string character) */
        case IR_LBS:           /* load one byte, sign-extended (signed char) */
        case IR_LH:            /* load a halfword, zero-extended (unsigned short) */
        case IR_LHS:           /* load a halfword, sign-extended (short) */
        case IR_LW:
        case IR_LD64: {        /* load a 64-bit value (a set) from the address in a */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = rd(fn, in->dst, SC1);
            switch (in->op) {
            case IR_LB:   mc_load8(m, sd, sa, 0); break;
            case IR_LBS:  mc_load8s(m, sd, sa, 0); break;
            case IR_LH:   mc_load16(m, sd, sa, 0); break;
            case IR_LHS:  mc_load16s(m, sd, sa, 0); break;
            case IR_LW:   mc_load32(m, sd, sa, 0); break;
            default:      mc_load64(m, sd, sa, 0); break;   /* IR_LD64 */
            }
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_SB:            /* store the low byte of b to the address in a */
        case IR_SH:            /* store the low halfword of b to the address in a */
        case IR_SW:
        case IR_ST64: {        /* store the 64-bit value b to the address in a */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sb = rs(m, fn, &fr, in->b, SC1);
            switch (in->op) {
            case IR_SB:   mc_store8(m, sa, 0, sb); break;
            case IR_SH:   mc_store16(m, sa, 0, sb); break;
            case IR_SW:   mc_store32(m, sa, 0, sb); break;
            default:      mc_store64(m, sa, 0, sb); break;   /* IR_ST64 */
            }
            break;
        }
        case IR_LDL: {
            int sz = fn->slot_size ? fn->slot_size[in->slot] : 4;
            int sd = rd(fn, in->dst, SC0);
            if (sz == 8)
                mc_load64(m, sd, MC_RBP, slot_disp(&fr, in->slot));
            else
                mc_load32(m, sd, MC_RBP, slot_disp(&fr, in->slot));
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_STL: {
            int sz = fn->slot_size ? fn->slot_size[in->slot] : 4;
            int sa = rs(m, fn, &fr, in->a, SC0);
            if (sz == 8)
                mc_store64(m, MC_RBP, slot_disp(&fr, in->slot), sa);
            else
                mc_store32(m, MC_RBP, slot_disp(&fr, in->slot), sa);
            break;
        }
        case IR_LDL64: {       /* always 64-bit: a set or process slot */
            int sd = rd(fn, in->dst, SC0);
            mc_load64(m, sd, MC_RBP, slot_disp(&fr, in->slot));
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_STL64: {
            int sa = rs(m, fn, &fr, in->a, SC0);
            mc_store64(m, MC_RBP, slot_disp(&fr, in->slot), sa);
            break;
        }
        case IR_ADL:
        case IR_ADL64: {
            /* address of a local slot: a full 64-bit stack address. It lives
               in a 64-bit temp home and feeds 64-bit address arithmetic, so
               it is never truncated. The ILP32 (IR_ADL) and LP64 (IR_ADL64)
               forms are the same lea. */
            int sd = rd(fn, in->dst, SC0);
            mc_lea(m, sd, MC_RBP, slot_disp(&fr, in->slot));
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_MOV:
            if (is_float[in->dst]) {
                int sa = frs(m, fn, &fr, in->a, FSC0);
                int sd = frd(fn, in->dst, FSC0);
                if (sa != sd)
                    mc_movsd_rr(m, sd, sa);
                fwd(m, fn, &fr, in->dst, sd);
            } else {
                int sa = rs(m, fn, &fr, in->a, SC0);
                int sd = rd(fn, in->dst, SC0);
                if (sa != sd)
                    mc_mov_rr(m, sd, sa);
                wd(m, fn, &fr, in->dst, sd);
            }
            break;
        /* Address-capable arithmetic runs 64-bit so pointer math (a LEA
           result plus an offset, as in record-field and array addressing)
           is not truncated. For a plain i32 value the low 32 bits are still
           correct, and every value consumer reads only those. */
        /* The i32 and i64 arithmetic and bitwise ops are the same register
           operations at two widths.  The i32 forms MUST run 32-bit: an x86
           32-bit op zeroes the upper half of its destination, which keeps every
           i32 value's high 32 bits clear.  That invariant is load-bearing under
           the ILP32 address model, where an i32 result may next be an operand
           of a 64-bit address computation (base + index); a 64-bit i32 op can
           leave garbage in bits 32+ (a carry from ADD, a sign fill from NEG),
           and the address add would then read it.  The i64 forms run 64-bit. */
        case IR_ADD: case IR_SUB: case IR_MUL:
        case IR_AND: case IR_OR: case IR_XOR:
        case IR_ADD64: case IR_SUB64: case IR_MUL64:
        case IR_AND64: case IR_OR64: case IR_XOR64: {
            /* Two-address in place: compute into the destination register.  Set
               it to a first (a plain move, skipped when the destination already
               is a), then apply the op with b.  If b happens to share the
               destination register, park it in rcx before the move to a would
               overwrite it. */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sb = rs(m, fn, &fr, in->b, SC1);
            int sd = rd(fn, in->dst, SC0);
            if (sb == sd && sa != sd) {
                mc_mov_rr(m, MC_RCX, sb);
                sb = MC_RCX;
            }
            if (sa != sd)
                mc_mov_rr(m, sd, sa);
            switch (in->op) {
            case IR_ADD:   mc_add32_rr(m, sd, sb); break;
            case IR_ADD64: mc_add_rr(m, sd, sb); break;
            case IR_SUB:   mc_sub32_rr(m, sd, sb); break;
            case IR_SUB64: mc_sub_rr(m, sd, sb); break;
            case IR_MUL:   mc_imul32_rr(m, sd, sb); break;
            case IR_MUL64: mc_imul_rr(m, sd, sb); break;
            case IR_AND:   mc_and32_rr(m, sd, sb); break;
            case IR_AND64: mc_and_rr(m, sd, sb); break;
            case IR_OR:    mc_or32_rr(m, sd, sb); break;
            case IR_OR64:  mc_or_rr(m, sd, sb); break;
            case IR_XOR:   mc_xor32_rr(m, sd, sb); break;
            case IR_XOR64: mc_xor_rr(m, sd, sb); break;
            }
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_SHL: case IR_SHL64:
            /* i32 left shift runs 32-bit: shifting a 32-bit value left can push
               bits into 32+, and under ILP32 an address is a clean 32-bit value
               too, so a scaled index (index << n) must stay 32-bit clean.  The
               i64 form (set-element masks) shifts the full 64 bits. */
        case IR_SHRS: case IR_SHRU:
            /* right shifts fill from bit 31, so they must be 32-bit; they only
               ever apply to i32 values, never addresses */
        case IR_SHRS64: case IR_SHRU64: {
            /* the Int64 right shifts fill from bit 63, so they run 64-bit.
               The count must land in cl before a is moved into the destination,
               since the destination may itself be the count's register. */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = rd(fn, in->dst, SC0);
            int sb = rs(m, fn, &fr, in->b, MC_RCX);
            if (sb != MC_RCX)
                mc_mov_rr(m, MC_RCX, sb);
            if (sa != sd)
                mc_mov_rr(m, sd, sa);
            switch (in->op) {
            case IR_SHL:    mc_shl32_cl(m, sd); break;
            case IR_SHL64:  mc_shl_cl(m, sd); break;
            case IR_SHRS:   mc_sar32_cl(m, sd); break;
            case IR_SHRU:   mc_shr32_cl(m, sd); break;
            case IR_SHRS64: mc_sar_cl(m, sd); break;
            case IR_SHRU64: mc_shr_cl(m, sd); break;
            }
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_DIVS: case IR_MODS: {
            /* Under TRAP_GUARDED (JIT), guard the divisor: an idiv by zero would
               fault the host with SIGFPE, so trap DIV_ZERO instead.  Under
               TRAP_HARDWARE (AOT), the CPU #DE is the fault, so emit the bare
               idiv (matching the historical x86_emit.c). */
            mat(m, fn, &fr, in->a, MC_RAX);
            mat(m, fn, &fr, in->b, SC0);
            if (tp == TRAP_GUARDED) {
                int over = mc_new_label(m);
                int noovf = mc_new_label(m);
                mc_test32_rr(m, SC0, SC0);
                mc_jcc(m, MC_NE, over);
                mc_trap_div_zero(m);    /* never returns; raises the trap */
                mc_label(m, over);
                /* INT_MIN / -1 overflows (idiv would #DE); trap OVERFLOW.  SC1
                   is free here (SC0 is the divisor, rax the dividend). */
                mc_mov_ri32(m, SC1, (uint32_t)-1);
                mc_cmp32_rr(m, SC0, SC1);
                mc_jcc(m, MC_NE, noovf);     /* divisor != -1: cannot overflow */
                mc_mov_ri32(m, SC1, 0x80000000u);
                mc_cmp32_rr(m, MC_RAX, SC1);
                mc_jcc(m, MC_NE, noovf);     /* dividend != INT_MIN: no overflow */
                mc_trap_overflow(m);
                mc_label(m, noovf);
            }
            mc_cdq(m);
            mc_idiv32_r(m, SC0);
            wb(m, fn, &fr, in->dst, in->op == IR_DIVS ? MC_RAX : MC_RDX);
            break;
        }
        case IR_DIVU: case IR_MODU: {
            mat(m, fn, &fr, in->a, MC_RAX);
            mat(m, fn, &fr, in->b, SC0);   /* SC0 is r10, not rdx: safe to zero rdx */
            if (tp == TRAP_GUARDED) {
                int over = mc_new_label(m);
                mc_test32_rr(m, SC0, SC0);
                mc_jcc(m, MC_NE, over);
                mc_trap_div_zero(m);
                mc_label(m, over);
            }
            mc_xor32_rr(m, MC_RDX, MC_RDX); /* zero edx for unsigned div (not cdq) */
            mc_div32_r(m, SC0);
            wb(m, fn, &fr, in->dst, in->op == IR_DIVU ? MC_RAX : MC_RDX);
            break;
        }
        case IR_DIVS64: case IR_MODS64: {
            mat(m, fn, &fr, in->a, MC_RAX);
            mat(m, fn, &fr, in->b, SC0);
            if (tp == TRAP_GUARDED) {
                int over = mc_new_label(m);
                mc_test_rr(m, SC0, SC0);  /* divisor is a full 64-bit value */
                mc_jcc(m, MC_NE, over);
                mc_trap_div_zero(m);
                mc_label(m, over);
            }
            mc_cqo(m);
            mc_idiv_r(m, SC0);
            wb(m, fn, &fr, in->dst, in->op == IR_DIVS64 ? MC_RAX : MC_RDX);
            break;
        }
        case IR_DIVU64: case IR_MODU64: {
            mat(m, fn, &fr, in->a, MC_RAX);
            mat(m, fn, &fr, in->b, SC0);
            if (tp == TRAP_GUARDED) {
                int over = mc_new_label(m);
                mc_test_rr(m, SC0, SC0);
                mc_jcc(m, MC_NE, over);
                mc_trap_div_zero(m);
                mc_label(m, over);
            }
            mc_xor32_rr(m, MC_RDX, MC_RDX); /* zero rdx (a 32-bit xor clears all 64) */
            mc_div_r(m, SC0);
            wb(m, fn, &fr, in->dst, in->op == IR_DIVU64 ? MC_RAX : MC_RDX);
            break;
        }
        case IR_ADDO: case IR_SUBO: case IR_MULO: {
            /* Checked arithmetic runs 32-bit so the CPU overflow flag reflects
               signed i32 overflow (the only width a Kobold integer takes).  The
               C front end never emits these, so under TRAP_HARDWARE (AOT) the
               overflow branch is dropped and the bare arithmetic remains. */
            mat(m, fn, &fr, in->a, SC0);
            mat(m, fn, &fr, in->b, SC1);
            switch (in->op) {
            case IR_ADDO: mc_add32_rr(m, SC0, SC1); break;
            case IR_SUBO: mc_sub32_rr(m, SC0, SC1); break;
            case IR_MULO: mc_imul32_rr(m, SC0, SC1); break;
            }
            if (in->label >= 0) {
                /* explicit per-site trap target (a front end's cold trap
                   trampoline): branch there on overflow. */
                mc_jcc(m, MC_O, il(m, lbl, in->label));
            } else if (tp == TRAP_GUARDED) {
                int ok = mc_new_label(m);
                mc_jcc(m, MC_NO, ok);   /* skip the trap when OF is clear */
                mc_trap_overflow(m);    /* never returns; raises OVERFLOW */
                mc_label(m, ok);
            }
            wb(m, fn, &fr, in->dst, SC0);
            break;
        }
        case IR_NEG: case IR_NEG64: {
            /* i32 negate runs 32-bit: a 64-bit negate sign-fills bits 32+, and
               that garbage would corrupt a later address computation. */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = rd(fn, in->dst, SC0);
            if (sa != sd)
                mc_mov_rr(m, sd, sa);
            if (in->op == IR_NEG64)
                mc_neg_r(m, sd);
            else
                mc_neg32_r(m, sd);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_NOT: {
            /* i32 only (i64 ~ lowers to XOR64 with -1).  Run 32-bit: a 64-bit
               NOT would set bits 32+, dirtying the value for a later address use. */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = rd(fn, in->dst, SC0);
            if (sa != sd)
                mc_mov_rr(m, sd, sa);
            mc_not32_r(m, sd);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_SEXT64: {
            /* widen a signed i32 to Int64: sign-extend the low 32 bits (movsxd
               both reads a and writes the destination, so no separate move) */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = rd(fn, in->dst, SC0);
            mc_movsxd_rr(m, sd, sa);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_ZEXT64:
            /* widen an unsigned i32 to Int64: a 32-bit mov zeroes the upper half */
        case IR_TRUNC64: {
            /* narrow Int64 to i32: keep the low 32 bits, clearing the upper half
               so the result is a clean i32 value.  Both are a 32-bit mov that
               reads a and writes the destination. */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = rd(fn, in->dst, SC0);
            mc_mov32_rr(m, sd, sa);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_JMP:
            mc_jmp(m, il(m, lbl, in->label));
            break;
        case IR_IJMP:
        case IR_IJMP64: {
            /* indirect jump through the address in operand `a` (a threaded
               dispatch); the JMP analog through a register.  rs reloads a
               spilled operand at full 64-bit width on x86, so one case serves
               both pointer widths. */
            int sa = rs(m, fn, &fr, in->a, SC0);
            mc_jmp_reg(m, sa);
            break;
        }
        case IR_BZ: case IR_BNZ: {
            int sa = rs(m, fn, &fr, in->a, SC0);
            mc_test32_rr(m, sa, sa);
            mc_jcc(m, in->op == IR_BZ ? MC_E : MC_NE, il(m, lbl, in->label));
            break;
        }
        case IR_ARG: case IR_FARG: case IR_ARG64: case IR_ARG_MEM:
            if (npending < 32) {
                pend_temp[npending] = in->a;
                pend_isf[npending] = (char)(in->op == IR_FARG);
                pend_fw[npending] = (char)(in->op == IR_FARG && in->imm == FWIDTH_F32);
                /* IR_ARG_MEM carries the by-value struct byte size in imm */
                pend_msize[npending] = in->op == IR_ARG_MEM ? (int)in->imm : 0;
                npending++;
            }
            break;
        case IR_CALL: case IR_FCALL: case IR_CALL64: {
            int space = marshal(m, fn, &fr, pend_temp, pend_isf, pend_fw,
                                pend_msize, npending);
            npending = 0;
            mc_call_sym(m, in->sym);
            if (space)
                mc_add_ri32(m, MC_RSP, space);   /* pop the stack arguments */
            if (in->dst >= 0) {
                if (in->op == IR_FCALL) {
                    /* a single result comes back as f32 in xmm0; widen it when the
                       destination temp holds f64 format (the Kobold front end),
                       and leave it f32 when the temp stays single (the C one) */
                    if (in->imm == FWIDTH_F32 && !src_is_f32(in->dst))
                        mc_cvtss2sd_rr(m, MC_XMM0, MC_XMM0);
                    wbf(m, fn, &fr, in->dst, MC_XMM0);
                } else {
                    wb(m, fn, &fr, in->dst, MC_RAX);
                }
            }
            break;
        }
        case IR_CALLI: case IR_FCALLI: case IR_CALLI64: {
            /* indirect call through a code pointer in the callee temp `a` */
            int space = marshal(m, fn, &fr, pend_temp, pend_isf, pend_fw,
                                pend_msize, npending);
            npending = 0;
            mat(m, fn, &fr, in->a, SC1);   /* pointer: not an argument reg */
            mc_call_reg(m, SC1);
            if (space)
                mc_add_ri32(m, MC_RSP, space);   /* pop the stack arguments */
            if (in->dst >= 0) {
                if (in->op == IR_FCALLI) {
                    if (in->imm == FWIDTH_F32 && !src_is_f32(in->dst))
                        mc_cvtss2sd_rr(m, MC_XMM0, MC_XMM0);
                    wbf(m, fn, &fr, in->dst, MC_XMM0);
                } else {
                    wb(m, fn, &fr, in->dst, MC_RAX);
                }
            }
            break;
        }
        case IR_CALL2: case IR_CALLI2: {
            /* failable call (see ir.h): the value comes back in RAX (-> dst), the
               error in RDX (-> the error slot).  RDX is also the third argument
               register, so the call overwrites whatever marshal put there; the
               error is read only after the call returns. */
            int space = marshal(m, fn, &fr, pend_temp, pend_isf, pend_fw,
                                pend_msize, npending);
            npending = 0;
            if (in->op == IR_CALLI2) {
                mat(m, fn, &fr, in->a, SC1);   /* pointer: not an argument reg */
                mc_call_reg(m, SC1);
            } else {
                mc_call_sym(m, in->sym);
            }
            if (space)
                mc_add_ri32(m, MC_RSP, space);   /* pop the stack arguments */
            mc_store32(m, MC_RBP, slot_disp(&fr, in->slot), MC_RDX);
            if (in->dst >= 0)
                wb(m, fn, &fr, in->dst, MC_RAX);
            break;
        }
        case IR_CALL_AGG: case IR_CALLI_AGG: {
            /* struct-returning call: make the call, then store the returned
               eightbytes (rax/rdx INTEGER, xmm0/xmm1 SSE, per the imm-encoded
               classes) into the destination slot.  imm: neb in bits 0-2, each
               slot's class in a 2-bit field at bits 3+2*j (0 int, 1 double, 2
               float single; x86-64 never produces the single class). */
            int space = marshal(m, fn, &fr, pend_temp, pend_isf, pend_fw,
                                pend_msize, npending);
            npending = 0;
            if (in->op == IR_CALLI_AGG) {
                mat(m, fn, &fr, in->a, SC1);   /* pointer: not an argument reg */
                mc_call_reg(m, SC1);
            } else {
                mc_call_sym(m, in->sym);
            }
            if (space)
                mc_add_ri32(m, MC_RSP, space);   /* pop the stack arguments */
            {
                int neb = (int)(in->imm & 7);
                int cls2[2] = { (int)((in->imm >> 3) & 3),
                                (int)((in->imm >> 5) & 3) };
                int iret[2] = { MC_RAX, MC_RDX };
                int sret[2] = { MC_XMM0, MC_XMM1 };
                int iidx = 0, sidx = 0, base = slot_disp(&fr, in->slot), j;
                for (j = 0; j < neb; j++) {
                    if (cls2[j] == 1)
                        mc_movsd_store(m, MC_RBP, base + 8 * j, sret[sidx++]);
                    else if (cls2[j] == 2)
                        mc_movss_store(m, MC_RBP, base + 8 * j, sret[sidx++]);
                    else
                        mc_store64(m, MC_RBP, base + 8 * j, iret[iidx++]);
                }
            }
            break;
        }
        case IR_FLD: {          /* load float from address in temp a; imm gives width */
            /* A single-float value stays f32 in the register (movss); the width
               is carried explicitly by IR_F32TOF64 when it must widen. */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = frd(fn, in->dst, FSC0);
            if (in->imm == FWIDTH_F32)
                mc_movss_load(m, sd, sa, 0);
            else
                mc_movsd_load(m, sd, sa, 0);
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FSD: {          /* store float value b to address in temp a; imm gives width */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sb = frs(m, fn, &fr, in->b, FSC0);
            if (in->imm == FWIDTH_F32)
                mc_movss_store(m, sa, 0, sb);
            else
                mc_movsd_store(m, sa, 0, sb);
            break;
        }
        case IR_FLS: {          /* load f32 from address in temp a, widen to f64 */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = frd(fn, in->dst, FSC0);
            mc_cvtss2sd_load(m, sd, sa, 0);
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FSS: {          /* narrow f64 value b to f32, store to address in temp a */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sb = frs(m, fn, &fr, in->b, FSC0);
            mc_cvtsd2ss_rr(m, FSC0, sb);   /* narrow into scratch, keeping b intact */
            mc_movss_store(m, sa, 0, FSC0);
            break;
        }
        case IR_F32TOF64: {     /* register f32 -> f64 */
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sd = frd(fn, in->dst, FSC0);
            mc_cvtss2sd_rr(m, sd, sa);
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_F64TOF32: {     /* register f64 -> f32 */
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sd = frd(fn, in->dst, FSC0);
            mc_cvtsd2ss_rr(m, sd, sa);
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FLDL: {
            /* A single-float local lives in a 4-byte slot and stays f32 in the
               register (movss); a double is a plain 8-byte movsd. */
            int sd = frd(fn, in->dst, FSC0);
            if (in->imm == FWIDTH_F32)
                mc_movss_load(m, sd, MC_RBP, slot_disp(&fr, in->slot));
            else
                mc_movsd_load(m, sd, MC_RBP, slot_disp(&fr, in->slot));
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FSTL: {
            int sa = frs(m, fn, &fr, in->a, FSC0);
            if (in->imm == FWIDTH_F32)
                mc_movss_store(m, MC_RBP, slot_disp(&fr, in->slot), sa);
            else
                mc_movsd_store(m, MC_RBP, slot_disp(&fr, in->slot), sa);
            break;
        }
        case IR_FADD: case IR_FSUB: case IR_FMUL: case IR_FDIV: {
            /* The width tag selects the single (ss) or double (sd) form, so a
               float and a double arithmetic op each round at their precision.
               Two-address in place like the integer binops, parking b in the
               spare float scratch when it shares the destination register. */
            int f32 = in->imm == FWIDTH_F32;
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sb = frs(m, fn, &fr, in->b, FSC1);
            int sd = frd(fn, in->dst, FSC0);
            if (sb == sd && sa != sd) {
                mc_movsd_rr(m, FSC1, sb);
                sb = FSC1;
            }
            if (sa != sd)
                mc_movsd_rr(m, sd, sa);
            switch (in->op) {
            case IR_FADD: (f32 ? mc_addss_rr : mc_addsd_rr)(m, sd, sb); break;
            case IR_FSUB: (f32 ? mc_subss_rr : mc_subsd_rr)(m, sd, sb); break;
            case IR_FMUL: (f32 ? mc_mulss_rr : mc_mulsd_rr)(m, sd, sb); break;
            case IR_FDIV: (f32 ? mc_divss_rr : mc_divsd_rr)(m, sd, sb); break;
            }
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FCMPEQ: case IR_FCMPLT: case IR_FCMPLE: {
            /* ucomiss/ucomisd (by width) sets the flags like an unsigned compare
               of a to b; the boolean result is an integer temp. NaN (parity) is
               out of scope. */
            int fcc = in->op == IR_FCMPEQ ? MC_E
                    : in->op == IR_FCMPLT ? MC_B : MC_BE;
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sb = frs(m, fn, &fr, in->b, FSC1);
            int sd = rd(fn, in->dst, SC0);
            if (in->imm == FWIDTH_F32)
                mc_ucomiss_rr(m, sa, sb);
            else
                mc_ucomisd_rr(m, sa, sb);
            mc_setcc_r(m, fcc, sd);
            mc_movzx_rb(m, sd, sd);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_ITOF: {         /* signed i32 to float; width selects ss/sd */
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sd = frd(fn, in->dst, FSC0);
            if (in->imm == FWIDTH_F32)
                mc_cvtsi2ss(m, sd, sa);
            else
                mc_cvtsi2sd(m, sd, sa);
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FSQRT: {        /* f64 square root */
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sd = frd(fn, in->dst, FSC0);
            mc_sqrtsd_rr(m, sd, sa);
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FTOI: {         /* float -> i32, truncating toward zero; width selects ss/sd */
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sd = rd(fn, in->dst, SC0);
            if (in->imm == FWIDTH_F32)
                mc_cvttss2si(m, sd, sa);
            else
                mc_cvttsd2si(m, sd, sa);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FROUND: {       /* f64 -> i32, round to nearest (round) */
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sd = rd(fn, in->dst, SC0);
            mc_cvtsd2si(m, sd, sa);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FABS: {         /* clear the sign bit through a GPR (bit 31 f32, 63 f64) */
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sd = frd(fn, in->dst, FSC0);
            mc_movq_from_xmm(m, SC0, sa);
            mc_mov_ri64(m, SC1, in->imm == FWIDTH_F32
                       ? 0x7FFFFFFFULL : 0x7FFFFFFFFFFFFFFFULL);
            mc_and_rr(m, SC0, SC1);
            mc_movq_to_xmm(m, sd, SC0);
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FNEG: {         /* flip the sign bit through a GPR (bit 31 f32, 63 f64) */
            int sa = frs(m, fn, &fr, in->a, FSC0);
            int sd = frd(fn, in->dst, FSC0);
            mc_movq_from_xmm(m, SC0, sa);
            mc_mov_ri64(m, SC1, in->imm == FWIDTH_F32
                       ? 0x80000000ULL : 0x8000000000000000ULL);
            mc_xor_rr(m, SC0, SC1);
            mc_movq_to_xmm(m, sd, SC0);
            fwd(m, fn, &fr, in->dst, sd);
            break;
        }
        case IR_FLH:
            /* widen a half at [a] to a double through the softfloat helper.
               SysV: the 16-bit half is passed in edi, the single-precision bits
               come back in eax, then widen f32 -> f64.  The JIT has no binding
               for __skj_extendhfsf, so this path is AOT-only in practice. */
            mat(m, fn, &fr, in->a, SC0);
            mc_load16(m, MC_RDI, SC0, 0);      /* movzx edi, word [addr] */
            mc_call_sym(m, "__skj_extendhfsf");
            mc_movd_to_xmm(m, FSC0, MC_RAX);   /* single bits -> xmm */
            mc_cvtss2sd_rr(m, FSC0, FSC0);
            wbf(m, fn, &fr, in->dst, FSC0);
            break;
        case IR_FSH:
            /* narrow a double b to a half and store it at [a] through the
               softfloat helper (SysV: single bits in edi, half bits in eax).
               Reload the address after the call, since the call clobbers the
               scratch registers. */
            matf(m, fn, &fr, in->b, FSC0);
            mc_cvtsd2ss_rr(m, FSC0, FSC0);
            mc_movd_from_xmm(m, MC_RDI, FSC0); /* single bits -> arg */
            mc_call_sym(m, "__skj_truncsfhf");
            mat(m, fn, &fr, in->a, SC0);
            mc_store16(m, SC0, 0, MC_RAX);     /* mov word [addr], ax */
            break;
        case IR_ASM:
            /* basic inline assembly: emitted verbatim (AOT text sink only) */
            if (in->asm_info) {
                emit_asm_ext(m, fn, &fr, in);
                break;
            }
            mc_asm(m, in->sym);
            break;
        case IR_FRETV:
            /* a single result is narrowed to f32 in xmm0 before the return when its
               temp holds f64 format (Kobold); a temp already in f32 format (C) is
               returned as-is */
            matf(m, fn, &fr, in->a, MC_XMM0);
            if (in->imm == FWIDTH_F32 && !src_is_f32(in->a))
                mc_cvtsd2ss_rr(m, MC_XMM0, MC_XMM0);
            epilogue(m, &fr);
            break;
        case IR_VA_START: {
            /* fill the va_list at [temp a] from the named-param counts and the
               register save area.  ILP32 layout: gp_offset@0, fp_offset@4,
               overflow_arg_area@8, reg_save_area@12 (4-byte pointers). */
            int ng = 0, nf = 0, ns = 0, k, j;
            for (k = 0; k < fn->nparams; k++) {
                int neb = fn->param_neb ? fn->param_neb[k] : 1;
                int mem = fn->param_cls && fn->param_cls[4 * k] == -2;
                if (neb < 1)
                    neb = 1;
                if (mem) { ns += neb; continue; }
                for (j = 0; j < neb; j++) {
                    int cls = fn->param_cls ? fn->param_cls[4 * k + j] : 0;
                    if (cls == 1 && nf < 8) nf++;
                    else if (cls != 1 && ng < 6) ng++;
                    else ns++;
                }
            }
            mat(m, fn, &fr, in->a, SC1);   /* va_list address */
            mc_mov_ri32(m, SC0, (uint32_t)(8 * ng));
            mc_store32(m, SC1, 0, SC0);        /* gp_offset  */
            mc_mov_ri32(m, SC0, (uint32_t)(48 + 16 * nf));
            mc_store32(m, SC1, 4, SC0);        /* fp_offset  */
            /* overflow_arg_area = the first unnamed stack arg, at rbp+16+8*ns;
               reg_save_area = the 176-byte area at rbp+va_disp.  These are
               pointers, so their width and their va_list offset follow the
               target model: LP64 stores an 8-byte pointer (overflow@8,
               reg_save@16, the standard __va_list_tag), ILP32 a 4-byte one
               (overflow@8, reg_save@12), valid because the JIT stack is low
               memory and the address fits in 32 bits. */
#if SKJ_LP64
            mc_lea(m, SC0, MC_RBP, 16 + 8 * ns);
            mc_store64(m, SC1, 8, SC0);
            mc_lea(m, SC0, MC_RBP, fr.va_disp);
            mc_store64(m, SC1, 16, SC0);
#else
            mc_lea(m, SC0, MC_RBP, 16 + 8 * ns);
            mc_store32(m, SC1, 8, SC0);
            mc_lea(m, SC0, MC_RBP, fr.va_disp);
            mc_store32(m, SC1, 12, SC0);
#endif
            break;
        }
        case IR_RET:
            epilogue(m, &fr);
            break;
        case IR_RETV: case IR_RETV64:
            mat(m, fn, &fr, in->a, MC_RAX);
            epilogue(m, &fr);
            break;
        case IR_RETV2:
            /* failable return (see ir.h): the value in RAX, the error in RDX.
               No temp lives in either return register, so loading the error
               second cannot clobber the value. */
            mat(m, fn, &fr, in->a, MC_RAX);
            mat(m, fn, &fr, in->b, MC_RDX);
            epilogue(m, &fr);
            break;
        case IR_RETV_AGG: {
            /* pack the struct at [temp a] into the return registers: each
               eightbyte j goes to rax/rdx (INTEGER) or xmm0/xmm1 (SSE) per
               fn->ret_cls. */
            int iret[2] = { MC_RAX, MC_RDX };
            int sret[2] = { MC_XMM0, MC_XMM1 };
            int iidx = 0, sidx = 0, j;
            mat(m, fn, &fr, in->a, SC1);   /* struct address */
            for (j = 0; j < fn->ret_neb; j++) {
                if (fn->ret_cls[j] == 1)
                    mc_movsd_load(m, sret[sidx++], SC1, 8 * j);
                else if (fn->ret_cls[j] == 2)
                    mc_movss_load(m, sret[sidx++], SC1, 8 * j);
                else
                    mc_load64(m, iret[iidx++], SC1, 8 * j);
            }
            epilogue(m, &fr);
            break;
        }
        case IR_CMP64EQ: case IR_CMP64NE:
        case IR_CMP64LTS: case IR_CMP64LES: case IR_CMP64GTS: case IR_CMP64GES:
        case IR_CMP64LTU: case IR_CMP64LEU: case IR_CMP64GTU: case IR_CMP64GEU: {
            /* a full 64-bit compare (Int64 relations, set equality/membership); the
               boolean result is an integer temp, like the 32-bit compares above */
            int cc64;
            switch (in->op) {
            case IR_CMP64EQ:  cc64 = MC_E;  break;
            case IR_CMP64NE:  cc64 = MC_NE; break;
            case IR_CMP64LTS: cc64 = MC_L;  break;
            case IR_CMP64LES: cc64 = MC_LE; break;
            case IR_CMP64GTS: cc64 = MC_G;  break;
            case IR_CMP64GES: cc64 = MC_GE; break;
            case IR_CMP64LTU: cc64 = MC_B;  break;
            case IR_CMP64LEU: cc64 = MC_BE; break;
            case IR_CMP64GTU: cc64 = MC_A;  break;
            default:          cc64 = MC_AE; break;   /* IR_CMP64GEU */
            }
            int sa = rs(m, fn, &fr, in->a, SC0);
            int sb = rs(m, fn, &fr, in->b, SC1);
            int sd = rd(fn, in->dst, SC0);
            mc_cmp_rr(m, sa, sb);        /* reads a, b before sd overwrites them */
            mc_setcc_r(m, cc64, sd);
            mc_movzx_rb(m, sd, sd);
            wd(m, fn, &fr, in->dst, sd);
            break;
        }
        default:
            snprintf(err, errlen, "unsupported opcode %d in '%s'",
                     in->op, fn->name);
            rc = -1;
            break;
        }
    }

    free(fr.slot_off);
    free(lbl);
    free(is_float);
    g_f32 = NULL;
    free(f32fmt);
    return rc;
}
