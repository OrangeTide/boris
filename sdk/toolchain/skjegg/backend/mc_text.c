/* mc_text.c : the GNU intel-syntax text sink (see mc_text.h).

   One implementation of backend/mc.h that writes GNU `.intel_syntax noprefix`
   (elf64) assembly.  Each mc_* call prints one instruction; the selector drives
   it exactly as it drives the JIT's byte sink, so the two paths emit the same
   code from the same
   selection logic.  Registers arrive as hardware numbers (the mc_reg / mc_xmm
   enums), indexed here into the name tables; an operation's width rides its
   opcode name (the 32-bit forms use the e-registers, the 64-bit forms the
   r-registers), matching the sink contract in mc.h. */

#include <stdint.h>
#include <stdlib.h>

#include "mc.h"
#include "mc_text.h"

struct mc {
    FILE *out;
    int serial;             /* per-function label namespace */
    int nlab;               /* next label id */
    const char *errsym;     /* parity with the byte sink; never set here */
};

/* Register names by hardware number (ModRM/REX order). */
static const char *reg64[16] = {
    "rax", "rcx", "rdx", "rbx", "rsp", "rbp", "rsi", "rdi",
    "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
};
static const char *reg32[16] = {
    "eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi",
    "r8d", "r9d", "r10d", "r11d", "r12d", "r13d", "r14d", "r15d",
};
static const char *reg16[16] = {
    "ax", "cx", "dx", "bx", "sp", "bp", "si", "di",
    "r8w", "r9w", "r10w", "r11w", "r12w", "r13w", "r14w", "r15w",
};
static const char *reg8[16] = {
    "al", "cl", "dl", "bl", "spl", "bpl", "sil", "dil",
    "r8b", "r9b", "r10b", "r11b", "r12b", "r13b", "r14b", "r15b",
};
static const char *xmmn[16] = {
    "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5", "xmm6", "xmm7",
    "xmm8", "xmm9", "xmm10", "xmm11", "xmm12", "xmm13", "xmm14", "xmm15",
};
/* Condition-code suffixes indexed by the mc_cc value (the low nibble of the
   Jcc/SETcc opcodes). */
static const char *ccname[16] = {
    "o", "no", "b", "ae", "e", "ne", "be", "a",
    "s", "ns", "p", "np", "l", "ge", "le", "g",
};

/* Format a base+disp memory operand into buf.  x86 allows at most one memory
   operand per instruction, so a single caller buffer per call is enough. */
static const char *
memop(char *buf, size_t n, int base, int32_t disp)
{
    snprintf(buf, n, "[%s%+d]", reg64[base], disp);
    return buf;
}

struct mc *
mct_new(FILE *out)
{
    struct mc *m = calloc(1, sizeof *m);
    if (m)
        m->out = out;
    return m;
}

void
mct_free(struct mc *m)
{
    free(m);
}

void
mct_begin_func(struct mc *m, int serial)
{
    m->serial = serial;
    m->nlab = 0;
}

const char *
mct_errsym(struct mc *m)
{
    return m->errsym;
}

/* ---- Data movement. */
void mc_mov_ri32(struct mc *m, int r, uint32_t v)
{ fprintf(m->out, "\tmov %s, 0x%x\n", reg32[r], v); }
void mc_mov_ri64(struct mc *m, int r, uint64_t v)
{ fprintf(m->out, "\tmov %s, 0x%llx\n", reg64[r], (unsigned long long)v); }
void mc_mov_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmov %s, %s\n", reg64[d], reg64[s]); }
void mc_mov32_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmov %s, %s\n", reg32[d], reg32[s]); }

/* ---- 32-bit integer arithmetic and logic. */
void mc_add32_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tadd %s, %s\n", reg32[d], reg32[s]); }
void mc_sub32_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tsub %s, %s\n", reg32[d], reg32[s]); }
void mc_and32_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tand %s, %s\n", reg32[d], reg32[s]); }
void mc_or32_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tor %s, %s\n", reg32[d], reg32[s]); }
void mc_xor32_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\txor %s, %s\n", reg32[d], reg32[s]); }
void mc_imul32_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\timul %s, %s\n", reg32[d], reg32[s]); }
void mc_neg32_r(struct mc *m, int r)
{ fprintf(m->out, "\tneg %s\n", reg32[r]); }
void mc_not32_r(struct mc *m, int r)
{ fprintf(m->out, "\tnot %s\n", reg32[r]); }

/* ---- 64-bit integer arithmetic and address math. */
void mc_add_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tadd %s, %s\n", reg64[d], reg64[s]); }
void mc_sub_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tsub %s, %s\n", reg64[d], reg64[s]); }
void mc_and_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tand %s, %s\n", reg64[d], reg64[s]); }
void mc_or_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tor %s, %s\n", reg64[d], reg64[s]); }
void mc_xor_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\txor %s, %s\n", reg64[d], reg64[s]); }
void mc_imul_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\timul %s, %s\n", reg64[d], reg64[s]); }
void mc_neg_r(struct mc *m, int r)
{ fprintf(m->out, "\tneg %s\n", reg64[r]); }
void mc_not_r(struct mc *m, int r)
{ fprintf(m->out, "\tnot %s\n", reg64[r]); }

void mc_add_ri32(struct mc *m, int r, int32_t v)
{ fprintf(m->out, "\tadd %s, %d\n", reg64[r], v); }
void mc_sub_ri32(struct mc *m, int r, int32_t v)
{ fprintf(m->out, "\tsub %s, %d\n", reg64[r], v); }

/* ---- Division. */
void mc_cqo(struct mc *m) { fputs("\tcqo\n", m->out); }
void mc_cdq(struct mc *m) { fputs("\tcdq\n", m->out); }
void mc_idiv_r(struct mc *m, int r)
{ fprintf(m->out, "\tidiv %s\n", reg64[r]); }
void mc_idiv32_r(struct mc *m, int r)
{ fprintf(m->out, "\tidiv %s\n", reg32[r]); }
void mc_div_r(struct mc *m, int r)
{ fprintf(m->out, "\tdiv %s\n", reg64[r]); }
void mc_div32_r(struct mc *m, int r)
{ fprintf(m->out, "\tdiv %s\n", reg32[r]); }

/* ---- Shifts by cl. */
void mc_shl_cl(struct mc *m, int r) { fprintf(m->out, "\tshl %s, cl\n", reg64[r]); }
void mc_sar_cl(struct mc *m, int r) { fprintf(m->out, "\tsar %s, cl\n", reg64[r]); }
void mc_shr_cl(struct mc *m, int r) { fprintf(m->out, "\tshr %s, cl\n", reg64[r]); }
void mc_shl32_cl(struct mc *m, int r) { fprintf(m->out, "\tshl %s, cl\n", reg32[r]); }
void mc_sar32_cl(struct mc *m, int r) { fprintf(m->out, "\tsar %s, cl\n", reg32[r]); }
void mc_shr32_cl(struct mc *m, int r) { fprintf(m->out, "\tshr %s, cl\n", reg32[r]); }

/* ---- Compare and condition materialization. */
void mc_cmp_rr(struct mc *m, int a, int b)
{ fprintf(m->out, "\tcmp %s, %s\n", reg64[a], reg64[b]); }
void mc_test_rr(struct mc *m, int a, int b)
{ fprintf(m->out, "\ttest %s, %s\n", reg64[a], reg64[b]); }
void mc_cmp32_rr(struct mc *m, int a, int b)
{ fprintf(m->out, "\tcmp %s, %s\n", reg32[a], reg32[b]); }
void mc_test32_rr(struct mc *m, int a, int b)
{ fprintf(m->out, "\ttest %s, %s\n", reg32[a], reg32[b]); }
void mc_setcc_r(struct mc *m, int cc, int r)
{ fprintf(m->out, "\tset%s %s\n", ccname[cc], reg8[r]); }
void mc_movzx_rb(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmovzx %s, %s\n", reg32[d], reg8[s]); }
void mc_movsxd_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmovsxd %s, %s\n", reg64[d], reg32[s]); }

/* ---- Memory.  A sub-word load extends into a 32-bit result; a sub-word store
   writes the register's low byte / low 16 bits. */
void mc_load8(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tmovzx %s, byte ptr %s\n", reg32[d], memop(t, sizeof t, b, o)); }
void mc_load8s(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tmovsx %s, byte ptr %s\n", reg32[d], memop(t, sizeof t, b, o)); }
void mc_load16(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tmovzx %s, word ptr %s\n", reg32[d], memop(t, sizeof t, b, o)); }
void mc_load16s(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tmovsx %s, word ptr %s\n", reg32[d], memop(t, sizeof t, b, o)); }
void mc_store8(struct mc *m, int b, int32_t o, int s)
{ char t[32]; fprintf(m->out, "\tmov byte ptr %s, %s\n", memop(t, sizeof t, b, o), reg8[s]); }
void mc_store16(struct mc *m, int b, int32_t o, int s)
{ char t[32]; fprintf(m->out, "\tmov word ptr %s, %s\n", memop(t, sizeof t, b, o), reg16[s]); }
void mc_load32(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tmov %s, %s\n", reg32[d], memop(t, sizeof t, b, o)); }
void mc_store32(struct mc *m, int b, int32_t o, int s)
{ char t[32]; fprintf(m->out, "\tmov %s, %s\n", memop(t, sizeof t, b, o), reg32[s]); }
void mc_load64(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tmov %s, %s\n", reg64[d], memop(t, sizeof t, b, o)); }
void mc_store64(struct mc *m, int b, int32_t o, int s)
{ char t[32]; fprintf(m->out, "\tmov %s, %s\n", memop(t, sizeof t, b, o), reg64[s]); }
void mc_lea(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tlea %s, %s\n", reg64[d], memop(t, sizeof t, b, o)); }

/* ---- Stack. */
void mc_push_r(struct mc *m, int r) { fprintf(m->out, "\tpush %s\n", reg64[r]); }
void mc_pop_r(struct mc *m, int r) { fprintf(m->out, "\tpop %s\n", reg64[r]); }

/* ---- Control flow by label id.  Labels are file-unique via the per-function
   serial. */
int mc_new_label(struct mc *m) { return m->nlab++; }
void mc_label(struct mc *m, int id)
{ fprintf(m->out, ".Lf%d_%d:\n", m->serial, id); }
void mc_jmp(struct mc *m, int id)
{ fprintf(m->out, "\tjmp .Lf%d_%d\n", m->serial, id); }
void mc_jcc(struct mc *m, int cc, int id)
{ fprintf(m->out, "\tj%s .Lf%d_%d\n", ccname[cc], m->serial, id); }
void mc_ret(struct mc *m) { fputs("\tret\n", m->out); }
void mc_leave(struct mc *m) { fputs("\tleave\n", m->out); }
void mc_nop(struct mc *m) { fputs("\tnop\n", m->out); }
void mc_call_reg(struct mc *m, int r) { fprintf(m->out, "\tcall %s\n", reg64[r]); }
void mc_jmp_reg(struct mc *m, int r) { fprintf(m->out, "\tjmp %s\n", reg64[r]); }
void mc_lea_label(struct mc *m, int r, int id)
{ fprintf(m->out, "\tlea %s, [rip+.Lf%d_%d]\n", reg64[r], m->serial, id); }

/* In GNU intel syntax (noprefix) a bare register name in an operand is the
   register, so a guest symbol that happens to spell one (a global named "di",
   "ss", "al", ...) assembles as "invalid use of register".  Report whether a
   name collides with a register name or an intel operand keyword, so asm_sym can
   escape it.  Matched case-insensitively, the way `as` reads the tokens. */
static int
is_reserved_token(const char *s)
{
    static const char *const words[] = {
        /* 8/16/32/64-bit GPRs and their r8..r15 forms */
        "al","cl","dl","bl","spl","bpl","sil","dil","ah","ch","dh","bh",
        "ax","cx","dx","bx","sp","bp","si","di",
        "eax","ecx","edx","ebx","esp","ebp","esi","edi",
        "rax","rcx","rdx","rbx","rsp","rbp","rsi","rdi",
        "r8","r9","r10","r11","r12","r13","r14","r15",
        "r8b","r9b","r10b","r11b","r12b","r13b","r14b","r15b",
        "r8w","r9w","r10w","r11w","r12w","r13w","r14w","r15w",
        "r8d","r9d","r10d","r11d","r12d","r13d","r14d","r15d",
        "rip","eip","ip",
        /* segment registers */
        "cs","ds","es","fs","gs","ss",
        /* xmm/ymm and x87/mmx */
        "xmm0","xmm1","xmm2","xmm3","xmm4","xmm5","xmm6","xmm7",
        "xmm8","xmm9","xmm10","xmm11","xmm12","xmm13","xmm14","xmm15",
        "st","mm0","mm1","mm2","mm3","mm4","mm5","mm6","mm7",
        /* operand keywords */
        "byte","word","dword","qword","tbyte","oword","xmmword",
        "ptr","offset","flat","short","near","far",
        NULL,
    };
    int k;
    for (k = 0; words[k]; k++) {
        const char *a = s, *b = words[k];
        while (*a && *b && ((*a | 0x20) == (*b | 0x20)))
            a++, b++;
        if (!*a && !*b)
            return 1;
    }
    return 0;
}

/* GNU `as` accepts dotted and most reserved-word-like names verbatim, so almost
   no escaping is needed.  Two adjustments: (1) a guest routine name arrives with
   a leading `.` (for example ".coentry.1"), and `as` reserves the `.L` prefix for
   local labels it does not emit into the symbol table, so strip the single
   leading `.` to make an ordinary global ("coentry.1"); (2) a name that spells an
   intel register or operand keyword ("di", "ss", "byte", ...) would be read as
   that token in an operand, so append a `$` (a legal symbol character `as` keeps)
   to disambiguate.  Both the defining label and every reference run through here,
   so the spelling stays consistent.  Several buffers rotate so a single statement
   can format more than one symbol. */
const char *
asm_sym(const char *name)
{
    static char pool[4][256];
    static int which = 0;
    char *buf;
    size_t i, j = 0;

    if (!name)
        return name;
    which = (which + 1) & 3;
    buf = pool[which];

    if (name[0] == '.')
        name++;                 /* drop the leading dot of a generated name */
    for (i = 0; name[i] && j + 1 < sizeof pool[0]; i++)
        buf[j++] = name[i];
    buf[j] = '\0';
    if (is_reserved_token(buf) && j + 1 < sizeof pool[0])
        buf[j++] = '$', buf[j] = '\0';
    return buf;
}

/* ---- Symbolic call and address.  The linker resolves the name, so a local and
   an external symbol are the same `call name` / `mov reg, offset name`.  The
   address load uses `offset` because in GNU intel syntax a bare symbol operand
   means the contents at that symbol (MASM semantics), not its address. */
void mc_call_sym(struct mc *m, const char *name)
{ fprintf(m->out, "\tcall %s\n", asm_sym(name)); }
void mc_lea_sym(struct mc *m, int reg, const char *name)
{ fprintf(m->out, "\tmov %s, offset %s\n", reg64[reg], asm_sym(name)); }

/* ---- Traps.  Under the AOT (TRAP_HARDWARE) trap policy the selector never
   emits these, so they are unreachable in text output; keep the sink complete
   by naming the same runtime helpers the byte sink calls. */
void mc_trap_div_zero(struct mc *m)
{ fputs("\tcall kp_trap_div_zero\n", m->out); }
void mc_trap_overflow(struct mc *m)
{ fputs("\tcall kp_trap_overflow\n", m->out); }

/* A source-line marker: the text sink has no address-to-line table to build, so
   it records the line as a comment for a human reading the assembly. */
void mc_loc(struct mc *m, int line)
{ fprintf(m->out, "\t# line %d\n", line); }

/* ---- Double-precision SSE (f64). */
void mc_movsd_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmovsd %s, %s\n", xmmn[d], xmmn[s]); }
void mc_movsd_load(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tmovsd %s, %s\n", xmmn[d], memop(t, sizeof t, b, o)); }
void mc_movsd_store(struct mc *m, int b, int32_t o, int s)
{ char t[32]; fprintf(m->out, "\tmovsd %s, %s\n", memop(t, sizeof t, b, o), xmmn[s]); }
void mc_addsd_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\taddsd %s, %s\n", xmmn[d], xmmn[s]); }
void mc_subsd_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tsubsd %s, %s\n", xmmn[d], xmmn[s]); }
void mc_mulsd_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmulsd %s, %s\n", xmmn[d], xmmn[s]); }
void mc_divsd_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tdivsd %s, %s\n", xmmn[d], xmmn[s]); }
void mc_ucomisd_rr(struct mc *m, int a, int b)
{ fprintf(m->out, "\tucomisd %s, %s\n", xmmn[a], xmmn[b]); }
void mc_cvtsi2sd(struct mc *m, int d, int s)
{ fprintf(m->out, "\tcvtsi2sd %s, %s\n", xmmn[d], reg32[s]); }
void mc_sqrtsd_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tsqrtsd %s, %s\n", xmmn[d], xmmn[s]); }
void mc_cvttsd2si(struct mc *m, int d, int s)
{ fprintf(m->out, "\tcvttsd2si %s, %s\n", reg32[d], xmmn[s]); }
void mc_cvtsd2si(struct mc *m, int d, int s)
{ fprintf(m->out, "\tcvtsd2si %s, %s\n", reg32[d], xmmn[s]); }

/* ---- Single-precision SSE (f32) and the width converts. */
void mc_movss_load(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tmovss %s, %s\n", xmmn[d], memop(t, sizeof t, b, o)); }
void mc_movss_store(struct mc *m, int b, int32_t o, int s)
{ char t[32]; fprintf(m->out, "\tmovss %s, %s\n", memop(t, sizeof t, b, o), xmmn[s]); }
void mc_addss_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\taddss %s, %s\n", xmmn[d], xmmn[s]); }
void mc_subss_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tsubss %s, %s\n", xmmn[d], xmmn[s]); }
void mc_mulss_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmulss %s, %s\n", xmmn[d], xmmn[s]); }
void mc_divss_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tdivss %s, %s\n", xmmn[d], xmmn[s]); }
void mc_ucomiss_rr(struct mc *m, int a, int b)
{ fprintf(m->out, "\tucomiss %s, %s\n", xmmn[a], xmmn[b]); }
void mc_cvtsi2ss(struct mc *m, int d, int s)
{ fprintf(m->out, "\tcvtsi2ss %s, %s\n", xmmn[d], reg32[s]); }
void mc_cvttss2si(struct mc *m, int d, int s)
{ fprintf(m->out, "\tcvttss2si %s, %s\n", reg32[d], xmmn[s]); }
void mc_cvtss2sd_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tcvtss2sd %s, %s\n", xmmn[d], xmmn[s]); }
void mc_cvtsd2ss_rr(struct mc *m, int d, int s)
{ fprintf(m->out, "\tcvtsd2ss %s, %s\n", xmmn[d], xmmn[s]); }
void mc_cvtss2sd_load(struct mc *m, int d, int b, int32_t o)
{ char t[32]; fprintf(m->out, "\tcvtss2sd %s, dword ptr %s\n", xmmn[d], memop(t, sizeof t, b, o)); }

/* movq between a 64-bit GPR and an xmm. */
void mc_movq_from_xmm(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmovq %s, %s\n", reg64[d], xmmn[s]); }
void mc_movq_to_xmm(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmovq %s, %s\n", xmmn[d], reg64[s]); }

/* movd between a 32-bit GPR and an xmm. */
void mc_movd_from_xmm(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmovd %s, %s\n", reg32[d], xmmn[s]); }
void mc_movd_to_xmm(struct mc *m, int d, int s)
{ fprintf(m->out, "\tmovd %s, %s\n", xmmn[d], reg32[s]); }

/* Inline assembly: the string is emitted verbatim.  It is now GNU intel-syntax
   (the host assembler, and later skj-as-x86-64, assembles it). */
void mc_asm(struct mc *m, const char *text)
{ fprintf(m->out, "%s\n", text); }
