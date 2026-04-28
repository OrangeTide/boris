/* coldfire.c : ColdFire V4e CPU emulator */
/* Copyright (c) 2026 Jon Mayo — MIT-0 OR Public Domain */
/* Written with AI assistance (Claude, Anthropic) */

#include "coldfire.h"
#include <limits.h>
#include <string.h>
#include <math.h>

/****************************************************************
 * Internal helpers
 ****************************************************************/

static inline int is_supervisor(cf_cpu *cpu)
{
    return (cpu->sr & CF_SR_S) != 0;
}

/** Swap A7 with shadow stack pointer when changing privilege mode. */
static void update_sp(cf_cpu *cpu, uint32_t new_sr)
{
    int was_super = (cpu->sr & CF_SR_S) != 0;
    int now_super = (new_sr & CF_SR_S) != 0;
    if (was_super != now_super) {
        uint32_t tmp = cpu->a[7];
        cpu->a[7] = cpu->other_a7;
        cpu->other_a7 = tmp;
    }
}

/****************************************************************
 * Memory bus wrappers
 ****************************************************************/

static inline uint32_t bus_read8(cf_cpu *cpu, uint32_t addr)
{
    return cpu->read8(cpu->bus_ctx, addr) & 0xFF;
}

static inline uint32_t bus_read16(cf_cpu *cpu, uint32_t addr)
{
    return cpu->read16(cpu->bus_ctx, addr) & 0xFFFF;
}

static inline uint32_t bus_read32(cf_cpu *cpu, uint32_t addr)
{
    return cpu->read32(cpu->bus_ctx, addr);
}

static inline void bus_write8(cf_cpu *cpu, uint32_t addr, uint32_t val)
{
    cpu->write8(cpu->bus_ctx, addr, val & 0xFF);
}

static inline void bus_write16(cf_cpu *cpu, uint32_t addr, uint32_t val)
{
    cpu->write16(cpu->bus_ctx, addr, val & 0xFFFF);
}

static inline void bus_write32(cf_cpu *cpu, uint32_t addr, uint32_t val)
{
    cpu->write32(cpu->bus_ctx, addr, val);
}

/** Fetch next instruction word and advance PC. */
static inline uint16_t fetch16(cf_cpu *cpu)
{
    uint16_t w = (uint16_t)bus_read16(cpu, cpu->pc);
    cpu->pc += 2;
    return w;
}

/** Fetch next 32-bit extension (two words, big-endian). */
static inline uint32_t fetch32(cf_cpu *cpu)
{
    uint32_t hi = fetch16(cpu);
    uint32_t lo = fetch16(cpu);
    return (hi << 16) | lo;
}

/****************************************************************
 * Operand size helpers
 ****************************************************************/

#define SZ_BYTE  1
#define SZ_WORD  2
#define SZ_LONG  4

static inline int size_bytes(int sz)
{
    return sz; /* SZ_BYTE=1, SZ_WORD=2, SZ_LONG=4 */
}

/** Mask a value to the operand size. */
static inline uint32_t size_mask(uint32_t val, int sz)
{
    switch (sz) {
    case SZ_BYTE: return val & 0xFF;
    case SZ_WORD: return val & 0xFFFF;
    default:      return val;
    }
}

/** Sign-extend a sized value to 32 bits. */
static inline int32_t sign_extend(uint32_t val, int sz)
{
    switch (sz) {
    case SZ_BYTE: return (int32_t)(int8_t)(val & 0xFF);
    case SZ_WORD: return (int32_t)(int16_t)(val & 0xFFFF);
    default:      return (int32_t)val;
    }
}

/** Decode the 2-bit size field used in most instructions.
 *  00=byte, 01=word, 10=long. Returns SZ_* constant. */
static inline int decode_size(int bits)
{
    static const int sizes[] = { SZ_BYTE, SZ_WORD, SZ_LONG, 0 };
    return sizes[bits & 3];
}

/****************************************************************
 * Condition code helpers
 ****************************************************************/

static inline void set_flag(cf_cpu *cpu, uint32_t flag, int cond)
{
    if (cond)
        cpu->sr |= flag;
    else
        cpu->sr &= ~flag;
}

/** Set N and Z flags for a result of given size. */
static void set_nz(cf_cpu *cpu, uint32_t result, int sz)
{
    uint32_t m = size_mask(result, sz);
    uint32_t msb;
    switch (sz) {
    case SZ_BYTE: msb = 0x80; break;
    case SZ_WORD: msb = 0x8000; break;
    default:      msb = 0x80000000; break;
    }
    set_flag(cpu, CF_SR_N, m & msb);
    set_flag(cpu, CF_SR_Z, m == 0);
}

/** Flags for MOVE / logic operations: N, Z set; V, C cleared. */
static void set_flags_move(cf_cpu *cpu, uint32_t result, int sz)
{
    set_nz(cpu, result, sz);
    cpu->sr &= ~(CF_SR_V | CF_SR_C);
}

/** Flags for ADD. */
static void set_flags_add(cf_cpu *cpu, uint32_t src, uint32_t dst,
                          uint32_t res, int sz)
{
    uint32_t msb;
    switch (sz) {
    case SZ_BYTE: msb = 0x80; break;
    case SZ_WORD: msb = 0x8000; break;
    default:      msb = 0x80000000; break;
    }
    uint32_t sm = src & msb, dm = dst & msb, rm = res & msb;
    set_nz(cpu, res, sz);
    /* V: set if both operands same sign and result differs */
    set_flag(cpu, CF_SR_V, (sm == dm) && (rm != sm));
    /* C: carry out */
    set_flag(cpu, CF_SR_C,
             ((sm && dm) || (!rm && (sm || dm))) ? 1 : 0);
    /* X = C for add/sub */
    set_flag(cpu, CF_SR_X, cpu->sr & CF_SR_C);
}

/** Flags for SUB (dst - src -> res). */
static void set_flags_sub(cf_cpu *cpu, uint32_t src, uint32_t dst,
                          uint32_t res, int sz)
{
    uint32_t msb;
    switch (sz) {
    case SZ_BYTE: msb = 0x80; break;
    case SZ_WORD: msb = 0x8000; break;
    default:      msb = 0x80000000; break;
    }
    uint32_t sm = src & msb, dm = dst & msb, rm = res & msb;
    set_nz(cpu, res, sz);
    /* V: overflow if operands differ in sign and result matches src sign */
    set_flag(cpu, CF_SR_V, (sm != dm) && (rm == sm));
    /* C: borrow */
    set_flag(cpu, CF_SR_C,
             ((!dm && sm) || (rm && (!dm || sm))) ? 1 : 0);
    set_flag(cpu, CF_SR_X, cpu->sr & CF_SR_C);
}

/** Flags for CMP (same as SUB but does not set X). */
static void set_flags_cmp(cf_cpu *cpu, uint32_t src, uint32_t dst,
                          uint32_t res, int sz)
{
    uint32_t msb;
    switch (sz) {
    case SZ_BYTE: msb = 0x80; break;
    case SZ_WORD: msb = 0x8000; break;
    default:      msb = 0x80000000; break;
    }
    uint32_t sm = src & msb, dm = dst & msb, rm = res & msb;
    set_nz(cpu, res, sz);
    set_flag(cpu, CF_SR_V, (sm != dm) && (rm == sm));
    set_flag(cpu, CF_SR_C,
             ((!dm && sm) || (rm && (!dm || sm))) ? 1 : 0);
}

/** Evaluate a 4-bit condition code. */
static int eval_cc(cf_cpu *cpu, int cc)
{
    uint32_t sr = cpu->sr;
    int n = (sr >> 3) & 1;
    int z = (sr >> 2) & 1;
    int v = (sr >> 1) & 1;
    int c = sr & 1;
    switch (cc & 0xF) {
    case 0x0: return 1;             /* T (true) */
    case 0x1: return 0;             /* F (false) */
    case 0x2: return !c && !z;      /* HI */
    case 0x3: return c || z;        /* LS */
    case 0x4: return !c;            /* CC/HS */
    case 0x5: return c;             /* CS/LO */
    case 0x6: return !z;            /* NE */
    case 0x7: return z;             /* EQ */
    case 0x8: return !v;            /* VC */
    case 0x9: return v;             /* VS */
    case 0xA: return !n;            /* PL */
    case 0xB: return n;             /* MI */
    case 0xC: return n == v;        /* GE */
    case 0xD: return n != v;        /* LT */
    case 0xE: return !z && (n == v);/* GT */
    case 0xF: return z || (n != v); /* LE */
    }
    return 0;
}

/****************************************************************
 * Exception processing
 ****************************************************************/

void cf_exception(cf_cpu *cpu, int vector)
{
    /* Save current SR */
    uint32_t old_sr = cpu->sr;

    /* Enter supervisor mode, clear trace */
    uint32_t new_sr = old_sr | CF_SR_S;
    new_sr &= ~CF_SR_T;
    update_sp(cpu, new_sr);
    cpu->sr = new_sr;

    /* Push exception frame: format/vector word, PC, SR */
    /* ColdFire 4-word exception frame: format/FS[3:2], vector, SR, PC */
    cpu->a[7] -= 4;
    bus_write32(cpu, cpu->a[7], cpu->pc);
    cpu->a[7] -= 2;
    bus_write16(cpu, cpu->a[7], old_sr & 0xFFFF);
    cpu->a[7] -= 2;
    /* Format word: format=4 (ColdFire), FS=0, vector offset */
    uint16_t fmt = (4 << 12) | ((vector & 0xFF) << 2);
    bus_write16(cpu, cpu->a[7], fmt);

    /* Fetch handler address from vector table */
    uint32_t handler = bus_read32(cpu, cpu->vbr + (uint32_t)vector * 4);
    cpu->pc = handler;
    cpu->halted = 0;
}

/****************************************************************
 * Effective address engine
 ****************************************************************/

/** Operand location descriptor. */
typedef struct {
    int type;       /* 0=data reg, 1=addr reg, 2=memory, 3=immediate */
    int reg;        /* register number (for type 0, 1) */
    uint32_t addr;  /* memory address (for type 2) */
    uint32_t imm;   /* immediate value (for type 3) */
} ea_loc;

/** Decode an effective address field. For PC-relative modes the
 *  current PC (pointing at the extension word) is used as the base. */
static ea_loc decode_ea(cf_cpu *cpu, int mode, int reg, int sz)
{
    ea_loc loc;
    memset(&loc, 0, sizeof(loc));

    switch (mode) {
    case 0: /* Dn */
        loc.type = 0;
        loc.reg = reg;
        break;

    case 1: /* An */
        loc.type = 1;
        loc.reg = reg;
        break;

    case 2: /* (An) */
        loc.type = 2;
        loc.addr = cpu->a[reg];
        break;

    case 3: /* (An)+ */
        loc.type = 2;
        loc.addr = cpu->a[reg];
        cpu->a[reg] += size_bytes(sz);
        break;

    case 4: /* -(An) */
        loc.type = 2;
        cpu->a[reg] -= size_bytes(sz);
        loc.addr = cpu->a[reg];
        break;

    case 5: { /* (d16, An) */
        int16_t disp = (int16_t)fetch16(cpu);
        loc.type = 2;
        loc.addr = cpu->a[reg] + disp;
        break;
    }

    case 6: { /* (d8, An, Xn*SF) */
        uint16_t ext = fetch16(cpu);
        int xreg = (ext >> 12) & 7;
        int is_addr = (ext >> 15) & 1;
        /* W/L bit 11: must be 1 (longword) on ColdFire */
        int scale_bits = (ext >> 9) & 3;
        int scale = 1 << scale_bits; /* 1, 2, 4, 8 */
        int8_t disp = (int8_t)(ext & 0xFF);

        uint32_t xval = is_addr ? cpu->a[xreg] : cpu->d[xreg];
        /* ColdFire: index is always longword (W/L=1) */
        loc.type = 2;
        loc.addr = cpu->a[reg] + (int32_t)xval * scale + disp;
        break;
    }

    case 7: /* Special modes based on reg field */
        switch (reg) {
        case 0: { /* (xxx).W - absolute short */
            int16_t addr16 = (int16_t)fetch16(cpu);
            loc.type = 2;
            loc.addr = (uint32_t)(int32_t)addr16;
            break;
        }
        case 1: { /* (xxx).L - absolute long */
            loc.type = 2;
            loc.addr = fetch32(cpu);
            break;
        }
        case 2: { /* (d16, PC) */
            uint32_t base_pc = cpu->pc; /* PC of extension word */
            int16_t disp = (int16_t)fetch16(cpu);
            loc.type = 2;
            loc.addr = base_pc + disp;
            break;
        }
        case 3: { /* (d8, PC, Xn*SF) */
            uint32_t base_pc = cpu->pc;
            uint16_t ext = fetch16(cpu);
            int xreg = (ext >> 12) & 7;
            int is_addr = (ext >> 15) & 1;
            int scale_bits = (ext >> 9) & 3;
            int scale = 1 << scale_bits;
            int8_t disp = (int8_t)(ext & 0xFF);

            uint32_t xval = is_addr ? cpu->a[xreg] : cpu->d[xreg];
            loc.type = 2;
            loc.addr = base_pc + (int32_t)xval * scale + disp;
            break;
        }
        case 4: { /* #imm */
            loc.type = 3;
            switch (sz) {
            case SZ_BYTE:
                loc.imm = fetch16(cpu) & 0xFF;
                break;
            case SZ_WORD:
                loc.imm = fetch16(cpu);
                break;
            case SZ_LONG:
                loc.imm = fetch32(cpu);
                break;
            }
            break;
        }
        default:
            /* Invalid EA */
            cf_exception(cpu, CF_VEC_ILLEGAL);
            break;
        }
        break;

    default:
        cf_exception(cpu, CF_VEC_ILLEGAL);
        break;
    }
    return loc;
}

/** Read a value from a decoded EA location. */
static uint32_t read_ea(cf_cpu *cpu, ea_loc *loc, int sz)
{
    switch (loc->type) {
    case 0: /* data register */
        return size_mask(cpu->d[loc->reg], sz);
    case 1: /* address register */
        return cpu->a[loc->reg]; /* always 32-bit */
    case 2: /* memory */
        switch (sz) {
        case SZ_BYTE: return bus_read8(cpu, loc->addr);
        case SZ_WORD: return bus_read16(cpu, loc->addr);
        default:      return bus_read32(cpu, loc->addr);
        }
    case 3: /* immediate */
        return size_mask(loc->imm, sz);
    }
    return 0;
}

/** Write a value to a decoded EA location. */
static void write_ea(cf_cpu *cpu, ea_loc *loc, int sz, uint32_t val)
{
    switch (loc->type) {
    case 0: /* data register */
        switch (sz) {
        case SZ_BYTE:
            cpu->d[loc->reg] = (cpu->d[loc->reg] & 0xFFFFFF00) |
                               (val & 0xFF);
            break;
        case SZ_WORD:
            cpu->d[loc->reg] = (cpu->d[loc->reg] & 0xFFFF0000) |
                               (val & 0xFFFF);
            break;
        default:
            cpu->d[loc->reg] = val;
            break;
        }
        break;
    case 1: /* address register — always full 32-bit */
        cpu->a[loc->reg] = val;
        break;
    case 2: /* memory */
        switch (sz) {
        case SZ_BYTE: bus_write8(cpu, loc->addr, val); break;
        case SZ_WORD: bus_write16(cpu, loc->addr, val); break;
        default:      bus_write32(cpu, loc->addr, val); break;
        }
        break;
    case 3: /* immediate — can't write */
        break;
    }
}

/** Decode EA and read in one step (convenience). */
static uint32_t ea_read(cf_cpu *cpu, int mode, int reg, int sz)
{
    ea_loc loc = decode_ea(cpu, mode, reg, sz);
    return read_ea(cpu, &loc, sz);
}

/****************************************************************
 * Group 0: Immediate operations (ORI, ANDI, SUBI, ADDI,
 *          EORI, CMPI) and bit operations (BTST, BCHG,
 *          BCLR, BSET with immediate bit number)
 ****************************************************************/

static void exec_group0(cf_cpu *cpu, uint16_t op)
{
    int upper = (op >> 8) & 0xFF;

    /* Bit operations with immediate bit number: 0000 1000 xx */
    if ((upper & 0xFE) == 0x08) {
        /* BTST/BCHG/BCLR/BSET #imm, <ea> */
        int bit_op = (op >> 6) & 3;
        int ea_mode = (op >> 3) & 7;
        int ea_reg = op & 7;
        uint16_t ext = fetch16(cpu);
        int bitnum = ext & 0xFF;

        if (ea_mode == 0) {
            /* Register: 32-bit, bit modulo 32 */
            bitnum &= 31;
            uint32_t val = cpu->d[ea_reg];
            set_flag(cpu, CF_SR_Z, !(val & (1u << bitnum)));
            switch (bit_op) {
            case 0: break; /* BTST: test only */
            case 1: cpu->d[ea_reg] = val ^ (1u << bitnum); break;
            case 2: cpu->d[ea_reg] = val & ~(1u << bitnum); break;
            case 3: cpu->d[ea_reg] = val | (1u << bitnum); break;
            }
        } else {
            /* Memory: 8-bit, bit modulo 8 */
            bitnum &= 7;
            ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_BYTE);
            uint32_t val = read_ea(cpu, &loc, SZ_BYTE);
            set_flag(cpu, CF_SR_Z, !(val & (1u << bitnum)));
            switch (bit_op) {
            case 0: break;
            case 1: write_ea(cpu, &loc, SZ_BYTE,
                             val ^ (1u << bitnum)); break;
            case 2: write_ea(cpu, &loc, SZ_BYTE,
                             val & ~(1u << bitnum)); break;
            case 3: write_ea(cpu, &loc, SZ_BYTE,
                             val | (1u << bitnum)); break;
            }
        }
        return;
    }

    /* Immediate operations */
    int imm_op = (op >> 9) & 7;
    int sz_bits = (op >> 6) & 3;
    int sz = decode_size(sz_bits);
    int ea_mode = (op >> 3) & 7;
    int ea_reg = op & 7;

    if (sz == 0) {
        cf_exception(cpu, CF_VEC_ILLEGAL);
        return;
    }

    /* Fetch immediate value */
    uint32_t imm;
    if (sz == SZ_LONG)
        imm = fetch32(cpu);
    else
        imm = fetch16(cpu) & (sz == SZ_BYTE ? 0xFF : 0xFFFF);

    ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, sz);
    uint32_t dst = read_ea(cpu, &loc, sz);
    uint32_t res;

    switch (imm_op) {
    case 0: /* ORI */
        res = dst | imm;
        write_ea(cpu, &loc, sz, res);
        set_flags_move(cpu, res, sz);
        break;
    case 1: /* ANDI */
        res = dst & imm;
        write_ea(cpu, &loc, sz, res);
        set_flags_move(cpu, res, sz);
        break;
    case 2: /* SUBI */
        res = dst - imm;
        write_ea(cpu, &loc, sz, res);
        set_flags_sub(cpu, imm, dst, res, sz);
        break;
    case 3: /* ADDI */
        res = dst + imm;
        write_ea(cpu, &loc, sz, res);
        set_flags_add(cpu, imm, dst, res, sz);
        break;
    case 5: /* EORI */
        res = dst ^ imm;
        write_ea(cpu, &loc, sz, res);
        set_flags_move(cpu, res, sz);
        break;
    case 6: /* CMPI */
        res = dst - imm;
        set_flags_cmp(cpu, imm, dst, res, sz);
        break;
    default:
        cf_exception(cpu, CF_VEC_ILLEGAL);
        break;
    }
}

/****************************************************************
 * Group 1-3: MOVE
 * Group 1 = MOVE.B, Group 2 = MOVE.L, Group 3 = MOVE.W
 ****************************************************************/

static void exec_move(cf_cpu *cpu, uint16_t op, int sz)
{
    int src_mode = (op >> 3) & 7;
    int src_reg = op & 7;
    int dst_reg = (op >> 9) & 7;
    int dst_mode = (op >> 6) & 7;

    uint32_t val = ea_read(cpu, src_mode, src_reg, sz);

    if (dst_mode == 1) {
        /* MOVEA: write to address register, no flags change */
        /* Source is sign-extended to 32 bits */
        cpu->a[dst_reg] = (uint32_t)sign_extend(val, sz);
        return;
    }

    ea_loc dst = decode_ea(cpu, dst_mode, dst_reg, sz);
    write_ea(cpu, &dst, sz, val);
    set_flags_move(cpu, val, sz);
}

/****************************************************************
 * Group 4: Miscellaneous
 ****************************************************************/

static void exec_group4(cf_cpu *cpu, uint16_t op)
{
    /* HALT : 0100 1010 1100 1000 — must check before TST */
    if (op == 0x4AC8) {
        cpu->halted = 1;
        return;
    }

    /* TST <ea> : 0100 1010 ss eee rrr */
    if ((op & 0xFF00) == 0x4A00) {
        int sz_bits = (op >> 6) & 3;
        int sz = decode_size(sz_bits);
        if (sz == 0) {
            cf_exception(cpu, CF_VEC_ILLEGAL);
            return;
        }
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        uint32_t val = ea_read(cpu, mode, reg, sz);
        set_flags_move(cpu, val, sz);
        return;
    }

    /* CLR <ea> : 0100 0010 ss eee rrr */
    if ((op & 0xFF00) == 0x4200) {
        int sz_bits = (op >> 6) & 3;
        int sz = decode_size(sz_bits);
        if (sz == 0) goto illegal;
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        ea_loc loc = decode_ea(cpu, mode, reg, sz);
        write_ea(cpu, &loc, sz, 0);
        cpu->sr &= ~(CF_SR_N | CF_SR_V | CF_SR_C);
        cpu->sr |= CF_SR_Z;
        return;
    }

    /* NEG.L Dx : 0100 0100 10 000 rrr */
    if ((op & 0xFFF8) == 0x4480) {
        int reg = op & 7;
        uint32_t src = cpu->d[reg];
        uint32_t res = 0 - src;
        cpu->d[reg] = res;
        set_flags_sub(cpu, src, 0, res, SZ_LONG);
        return;
    }

    /* NEGX.L Dx : 0100 0000 10 000 rrr */
    if ((op & 0xFFF8) == 0x4080) {
        int reg = op & 7;
        uint32_t src = cpu->d[reg];
        uint32_t x = (cpu->sr & CF_SR_X) ? 1 : 0;
        uint64_t diff = (uint64_t)0 - src - x;
        uint32_t res = (uint32_t)diff;
        cpu->d[reg] = res;
        set_flag(cpu, CF_SR_C, diff >> 32);
        set_flag(cpu, CF_SR_X, diff >> 32);
        set_flag(cpu, CF_SR_V, (res & 0x80000000) && (src & 0x80000000));
        set_flag(cpu, CF_SR_N, res & 0x80000000);
        if (res != 0)
            cpu->sr &= ~CF_SR_Z; /* Z only cleared, never set */
        return;
    }

    /* NOT.L Dx : 0100 0110 10 000 rrr */
    if ((op & 0xFFF8) == 0x4680) {
        int reg = op & 7;
        cpu->d[reg] = ~cpu->d[reg];
        set_flags_move(cpu, cpu->d[reg], SZ_LONG);
        return;
    }

    /* EXT.W Dx : 0100 1000 10 000 rrr (byte -> word) */
    if ((op & 0xFFF8) == 0x4880) {
        int reg = op & 7;
        int16_t val = (int8_t)(cpu->d[reg] & 0xFF);
        cpu->d[reg] = (cpu->d[reg] & 0xFFFF0000) | (val & 0xFFFF);
        set_flags_move(cpu, (uint32_t)(uint16_t)val, SZ_WORD);
        return;
    }

    /* EXT.L Dx : 0100 1000 11 000 rrr (word -> long) */
    if ((op & 0xFFF8) == 0x48C0) {
        int reg = op & 7;
        int32_t val = (int16_t)(cpu->d[reg] & 0xFFFF);
        cpu->d[reg] = (uint32_t)val;
        set_flags_move(cpu, (uint32_t)val, SZ_LONG);
        return;
    }

    /* EXTB.L Dx : 0100 1001 11 000 rrr (byte -> long) */
    if ((op & 0xFFF8) == 0x49C0) {
        int reg = op & 7;
        int32_t val = (int8_t)(cpu->d[reg] & 0xFF);
        cpu->d[reg] = (uint32_t)val;
        set_flags_move(cpu, (uint32_t)val, SZ_LONG);
        return;
    }

    /* SWAP Dx : 0100 1000 01 000 rrr */
    if ((op & 0xFFF8) == 0x4840) {
        int reg = op & 7;
        uint32_t val = cpu->d[reg];
        cpu->d[reg] = (val >> 16) | (val << 16);
        set_flags_move(cpu, cpu->d[reg], SZ_LONG);
        return;
    }

    /* PEA <ea> : 0100 1000 01 eee rrr (mode != 000) */
    if ((op & 0xFFC0) == 0x4840) {
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        if (mode == 0) goto illegal; /* SWAP handled above */
        ea_loc loc = decode_ea(cpu, mode, reg, SZ_LONG);
        cpu->a[7] -= 4;
        bus_write32(cpu, cpu->a[7], loc.addr);
        return;
    }

    /* MOVEM.L register list <-> memory (longword only on ColdFire)
     * MOVEM.L #list, <ea> : 0100 1000 11 eee rrr
     * MOVEM.L <ea>, #list : 0100 1100 11 eee rrr
     * Valid EA modes: (An) and (d16,An) only. */
    if ((op & 0xFB80) == 0x4880) {
        int dir = (op >> 10) & 1; /* 0=reg-to-mem, 1=mem-to-reg */
        if (((op >> 6) & 1) == 0) goto illegal; /* word size not on CF */
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        uint16_t mask = fetch16(cpu);

        if (mode == 0) {
            /* EXT handled above, shouldn't reach here */
            goto illegal;
        }

        ea_loc loc = decode_ea(cpu, mode, reg, SZ_LONG);
        uint32_t addr = loc.addr;

        if (dir == 0) {
            /* Register to memory */
            for (int i = 0; i < 16; i++) {
                if (mask & (1 << i)) {
                    if (i < 8)
                        bus_write32(cpu, addr, cpu->d[i]);
                    else
                        bus_write32(cpu, addr, cpu->a[i - 8]);
                    addr += 4;
                }
            }
        } else {
            /* Memory to registers */
            for (int i = 0; i < 16; i++) {
                if (mask & (1 << i)) {
                    uint32_t val = bus_read32(cpu, addr);
                    if (i < 8)
                        cpu->d[i] = val;
                    else
                        cpu->a[i - 8] = val;
                    addr += 4;
                }
            }
        }
        return;
    }

    /* LEA <ea>, An : 0100 rrr1 11 eee rrr */
    if ((op & 0xF1C0) == 0x41C0) {
        int dst = (op >> 9) & 7;
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        ea_loc loc = decode_ea(cpu, mode, reg, SZ_LONG);
        cpu->a[dst] = loc.addr;
        return;
    }

    /* LINK An, #d16 : 0100 1110 0101 0 rrr */
    if ((op & 0xFFF8) == 0x4E50) {
        int reg = op & 7;
        int16_t disp = (int16_t)fetch16(cpu);
        cpu->a[7] -= 4;
        bus_write32(cpu, cpu->a[7], cpu->a[reg]);
        cpu->a[reg] = cpu->a[7];
        cpu->a[7] += disp;
        return;
    }

    /* UNLK An : 0100 1110 0101 1 rrr */
    if ((op & 0xFFF8) == 0x4E58) {
        int reg = op & 7;
        cpu->a[7] = cpu->a[reg];
        cpu->a[reg] = bus_read32(cpu, cpu->a[7]);
        cpu->a[7] += 4;
        return;
    }

    /* NOP : 0100 1110 0111 0001 */
    if (op == 0x4E71) return;

    /* RTS : 0100 1110 0111 0101 */
    if (op == 0x4E75) {
        cpu->pc = bus_read32(cpu, cpu->a[7]);
        cpu->a[7] += 4;
        return;
    }

    /* RTE : 0100 1110 0111 0011 */
    if (op == 0x4E73) {
        if (!is_supervisor(cpu)) {
            cf_exception(cpu, CF_VEC_PRIVILEGE);
            return;
        }
        uint16_t fmt = bus_read16(cpu, cpu->a[7]);
        cpu->a[7] += 2;
        uint32_t new_sr = bus_read16(cpu, cpu->a[7]);
        cpu->a[7] += 2;
        uint32_t new_pc = bus_read32(cpu, cpu->a[7]);
        cpu->a[7] += 4;
        /* ColdFire uses format 4 exclusively */
        int format = (fmt >> 12) & 0xF;
        if (format != 4) {
            cf_exception(cpu, CF_VEC_FORMAT_ERROR);
            return;
        }
        /* Restore SR (may change privilege mode) */
        update_sp(cpu, new_sr);
        cpu->sr = new_sr;
        cpu->pc = new_pc;
        return;
    }

    /* STOP #imm : 0100 1110 0111 0010 */
    if (op == 0x4E72) {
        if (!is_supervisor(cpu)) {
            cf_exception(cpu, CF_VEC_PRIVILEGE);
            return;
        }
        uint16_t new_sr = fetch16(cpu);
        update_sp(cpu, new_sr);
        cpu->sr = new_sr;
        cpu->halted = 1;
        return;
    }

    /* TRAP #vector : 0100 1110 0100 vvvv */
    if ((op & 0xFFF0) == 0x4E40) {
        int vec = op & 0xF;
        cf_exception(cpu, CF_VEC_TRAP(vec));
        return;
    }

    /* JSR <ea> : 0100 1110 10 eee rrr */
    if ((op & 0xFFC0) == 0x4E80) {
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        ea_loc loc = decode_ea(cpu, mode, reg, SZ_LONG);
        cpu->a[7] -= 4;
        bus_write32(cpu, cpu->a[7], cpu->pc);
        cpu->pc = loc.addr;
        return;
    }

    /* JMP <ea> : 0100 1110 11 eee rrr */
    if ((op & 0xFFC0) == 0x4EC0) {
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        ea_loc loc = decode_ea(cpu, mode, reg, SZ_LONG);
        cpu->pc = loc.addr;
        return;
    }

    /* MOVE from SR: 0100 0000 11 eee rrr (supervisor only on CF) */
    if ((op & 0xFFC0) == 0x40C0) {
        if (!is_supervisor(cpu)) {
            cf_exception(cpu, CF_VEC_PRIVILEGE);
            return;
        }
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        ea_loc loc = decode_ea(cpu, mode, reg, SZ_WORD);
        write_ea(cpu, &loc, SZ_WORD, cpu->sr & 0xFFFF);
        return;
    }

    /* MOVE to CCR: 0100 0100 11 eee rrr */
    if ((op & 0xFFC0) == 0x44C0) {
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        uint32_t val = ea_read(cpu, mode, reg, SZ_WORD);
        cpu->sr = (cpu->sr & 0xFF00) | (val & 0xFF);
        return;
    }

    /* MOVE to SR: 0100 0110 11 eee rrr (supervisor) */
    if ((op & 0xFFC0) == 0x46C0) {
        if (!is_supervisor(cpu)) {
            cf_exception(cpu, CF_VEC_PRIVILEGE);
            return;
        }
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        uint32_t val = ea_read(cpu, mode, reg, SZ_WORD);
        uint32_t new_sr = val & 0xFFFF;
        update_sp(cpu, new_sr);
        cpu->sr = new_sr;
        return;
    }

    /* MOVE USP: 0100 1110 0110 d rrr */
    if ((op & 0xFFF0) == 0x4E60) {
        if (!is_supervisor(cpu)) {
            cf_exception(cpu, CF_VEC_PRIVILEGE);
            return;
        }
        int dir = (op >> 3) & 1;
        int reg = op & 7;
        if (dir == 0)
            cpu->other_a7 = cpu->a[reg]; /* An -> USP */
        else
            cpu->a[reg] = cpu->other_a7; /* USP -> An */
        return;
    }

    /* MULS.L / MULU.L : 0100 1100 00 eee rrr (extension word) */
    if ((op & 0xFFC0) == 0x4C00) {
        uint16_t ext = fetch16(cpu);
        int is_signed = (ext >> 11) & 1;
        int dst_reg = (ext >> 12) & 7;
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        ea_loc loc = decode_ea(cpu, mode, reg, SZ_LONG);
        uint32_t src = read_ea(cpu, &loc, SZ_LONG);
        uint32_t dst = cpu->d[dst_reg];
        uint32_t res;
        if (is_signed)
            res = (uint32_t)((int32_t)dst * (int32_t)src);
        else
            res = dst * src;
        cpu->d[dst_reg] = res;
        set_flags_move(cpu, res, SZ_LONG);
        return;
    }

    /* DIVS.L / DIVU.L / REMS.L / REMU.L */
    /* 0100 1100 01 eee rrr (extension word determines variant) */
    if ((op & 0xFFC0) == 0x4C40) {
        uint16_t ext = fetch16(cpu);
        int is_signed = (ext >> 11) & 1;
        int quot_reg = (ext >> 12) & 7;
        int rem_reg = ext & 7;
        /* If quot_reg != rem_reg, it's a rem:quot pair */
        int mode = (op >> 3) & 7;
        int reg = op & 7;
        ea_loc loc = decode_ea(cpu, mode, reg, SZ_LONG);
        uint32_t divisor = read_ea(cpu, &loc, SZ_LONG);

        if (divisor == 0) {
            cf_exception(cpu, CF_VEC_ZERO_DIVIDE);
            return;
        }

        uint32_t dividend = cpu->d[quot_reg];
        uint32_t quotient, remainder;

        if (is_signed) {
            /* Guard against INT32_MIN / -1 (undefined behavior in C) */
            if (dividend == 0x80000000 && (int32_t)divisor == -1) {
                cpu->sr |= CF_SR_V | CF_SR_N;
                cpu->sr &= ~CF_SR_Z;
                return;
            }
            int32_t q = (int32_t)dividend / (int32_t)divisor;
            int32_t r = (int32_t)dividend % (int32_t)divisor;
            quotient = (uint32_t)q;
            remainder = (uint32_t)r;
        } else {
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        }

        if (quot_reg == rem_reg) {
            /* DIVS.L/DIVU.L: result is quotient only */
            cpu->d[quot_reg] = quotient;
        } else {
            /* REMS.L/REMU.L: Dw:Dq */
            cpu->d[quot_reg] = quotient;
            cpu->d[rem_reg] = remainder;
        }
        set_flags_move(cpu, quotient, SZ_LONG);
        return;
    }

    /* MOVEC Rn,Rc : 0100 1110 0111 1011 (0x4E7B)
     * ColdFire control registers are write-only per CFPRM.
     * 0x4E7A (Rc->Rn) is a 68020+ read encoding not in the ColdFire
     * spec, but we support it as an emulator convenience. */
    if ((op & 0xFFFE) == 0x4E7A) {
        if (!is_supervisor(cpu)) {
            cf_exception(cpu, CF_VEC_PRIVILEGE);
            return;
        }
        int dir = op & 1; /* 0 = Rc->Rn (emulator ext), 1 = Rn->Rc */
        uint16_t ext = fetch16(cpu);
        int rn = (ext >> 12) & 0xF;
        int is_addr = rn >= 8;
        int rn_idx = rn & 7;
        int rc = ext & 0xFFF;

        uint32_t *gpr = is_addr ? &cpu->a[rn_idx] : &cpu->d[rn_idx];

        if (dir == 0) {
            /* Rc -> Rn (not in ColdFire spec, emulator extension) */
            switch (rc) {
            case 0x002: *gpr = cpu->cacr; break;   /* CACR */
            case 0x801: *gpr = cpu->vbr; break;    /* VBR */
            case 0x004: /* ACR0 */ *gpr = 0; break;
            case 0x005: /* ACR1 */ *gpr = 0; break;
            case 0x006: /* ACR2 */ *gpr = 0; break;
            case 0x007: /* ACR3 */ *gpr = 0; break;
            default: *gpr = 0; break;
            }
        } else {
            /* Rn -> Rc */
            uint32_t val = *gpr;
            switch (rc) {
            case 0x002: cpu->cacr = val; break;
            case 0x801: cpu->vbr = val & 0xFFF00000; break;
            default: break; /* Ignore writes to unimplemented CRs */
            }
        }
        return;
    }

    /* TODO: FF1, BYTEREV (ISA_C) */

illegal:
    cf_exception(cpu, CF_VEC_ILLEGAL);
}

/****************************************************************
 * Group 5: ADDQ / SUBQ / Scc / MVS / MVZ
 ****************************************************************/

static void exec_group5(cf_cpu *cpu, uint16_t op)
{
    /* Scc Dx : 0101 cccc 11 000 rrr */
    if ((op & 0xF0C0) == 0x50C0) {
        int cc = (op >> 8) & 0xF;
        int mode = (op >> 3) & 7;
        int reg = op & 7;

        if (mode == 0) {
            /* Scc Dx */
            cpu->d[reg] = (cpu->d[reg] & 0xFFFFFF00) |
                          (eval_cc(cpu, cc) ? 0xFF : 0x00);
            return;
        }
        /* Scc only valid for Dn on ColdFire */
        goto illegal;
    }

    /* ADDQ #data, <ea> : 0101 ddd0 ss eee rrr */
    /* SUBQ #data, <ea> : 0101 ddd1 ss eee rrr */
    {
        int data3 = (op >> 9) & 7;
        int imm = data3 ? data3 : 8; /* 0 encodes 8 */
        int sub = (op >> 8) & 1;
        int sz_bits = (op >> 6) & 3;
        if (sz_bits == 3) goto illegal; /* handled above as Scc */
        int sz = decode_size(sz_bits);
        if (sz == 0) goto illegal;
        int mode = (op >> 3) & 7;
        int reg = op & 7;

        if (mode == 1) {
            /* ADDQ/SUBQ to An: full 32-bit, no flags */
            if (sub)
                cpu->a[reg] -= imm;
            else
                cpu->a[reg] += imm;
            return;
        }

        ea_loc loc = decode_ea(cpu, mode, reg, sz);
        uint32_t dst = read_ea(cpu, &loc, sz);
        uint32_t res;
        if (sub) {
            res = dst - imm;
            write_ea(cpu, &loc, sz, res);
            set_flags_sub(cpu, imm, dst, res, sz);
        } else {
            res = dst + imm;
            write_ea(cpu, &loc, sz, res);
            set_flags_add(cpu, imm, dst, res, sz);
        }
    }
    return;

illegal:
    cf_exception(cpu, CF_VEC_ILLEGAL);
}

/****************************************************************
 * Group 6: Bcc / BRA / BSR
 ****************************************************************/

static void exec_group6(cf_cpu *cpu, uint16_t op)
{
    int cc = (op >> 8) & 0xF;
    int8_t disp8 = (int8_t)(op & 0xFF);
    int32_t disp;

    /* Base address for displacement is PC of the Bcc opword + 2 */
    uint32_t base_pc = cpu->pc; /* PC already advanced past opword */

    if (disp8 == 0) {
        /* 16-bit displacement follows */
        disp = (int16_t)fetch16(cpu);
    } else if (disp8 == -1) {
        /* 32-bit displacement follows */
        disp = (int32_t)fetch32(cpu);
    } else {
        disp = disp8;
    }

    if (cc == 0) {
        /* BRA */
        cpu->pc = base_pc + disp;
    } else if (cc == 1) {
        /* BSR */
        cpu->a[7] -= 4;
        bus_write32(cpu, cpu->a[7], cpu->pc);
        cpu->pc = base_pc + disp;
    } else {
        /* Bcc */
        if (eval_cc(cpu, cc))
            cpu->pc = base_pc + disp;
    }
}

/****************************************************************
 * Group 7: MOVEQ
 ****************************************************************/

static void exec_group7(cf_cpu *cpu, uint16_t op)
{
    int reg = (op >> 9) & 7;

    if (!(op & 0x100)) {
        /* MOVEQ: bit 8 = 0 */
        int8_t data = (int8_t)(op & 0xFF);
        cpu->d[reg] = (uint32_t)(int32_t)data;
        set_flags_move(cpu, cpu->d[reg], SZ_LONG);
    } else {
        /* MVS / MVZ: bit 8 = 1 */
        /* bits 7-6: 00=MVS.B, 01=MVS.W, 10=MVZ.B, 11=MVZ.W */
        int sz_bit = (op >> 6) & 1;  /* 0=byte, 1=word */
        int is_zero = (op >> 7) & 1; /* 0=MVS (sign), 1=MVZ (zero) */
        int ea_mode = (op >> 3) & 7;
        int ea_reg = op & 7;
        int sz = sz_bit ? SZ_WORD : SZ_BYTE;
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, sz);

        if (is_zero) {
            /* MVZ — zero extend */
            if (sz == SZ_BYTE)
                cpu->d[reg] = src & 0xFF;
            else
                cpu->d[reg] = src & 0xFFFF;
        } else {
            /* MVS — sign extend */
            cpu->d[reg] = (uint32_t)sign_extend(src, sz);
        }
        set_flags_move(cpu, cpu->d[reg], SZ_LONG);
    }
}

/****************************************************************
 * Group 8: OR / DIVU / DIVS
 ****************************************************************/

static void exec_group8(cf_cpu *cpu, uint16_t op)
{
    int reg_dx = (op >> 9) & 7;
    int opmode = (op >> 6) & 7;
    int ea_mode = (op >> 3) & 7;
    int ea_reg = op & 7;

    /* DIVU.W / DIVS.W: opmode 011 / 111 */
    if (opmode == 3 || opmode == 7) {
        /* Word divide: 32/16 -> 16r:16q */
        int is_signed = (opmode == 7);
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, SZ_WORD);
        if ((src & 0xFFFF) == 0) {
            cf_exception(cpu, CF_VEC_ZERO_DIVIDE);
            return;
        }
        uint32_t dst = cpu->d[reg_dx];
        uint32_t quot, rem;
        if (is_signed) {
            int16_t src16 = (int16_t)src;
            /* Guard against INT32_MIN / -1 (undefined behavior in C) */
            if ((int32_t)dst == INT32_MIN && src16 == -1) {
                cpu->sr |= CF_SR_V | CF_SR_N;
                cpu->sr &= ~CF_SR_Z;
                return;
            }
            int32_t q = (int32_t)dst / src16;
            int32_t r = (int32_t)dst % src16;
            /* Overflow if quotient doesn't fit in 16 bits */
            if (q > 32767 || q < -32768) {
                cpu->sr |= CF_SR_V;
                return;
            }
            quot = (uint32_t)(uint16_t)q;
            rem = (uint32_t)(uint16_t)r;
        } else {
            quot = dst / (src & 0xFFFF);
            rem = dst % (src & 0xFFFF);
        }
        cpu->d[reg_dx] = (rem << 16) | (quot & 0xFFFF);
        set_flags_move(cpu, quot & 0xFFFF, SZ_WORD);
        return;
    }

    /* OR: opmode 000/001/010 = <ea> OR Dn -> Dn (byte/word/long) */
    /*     opmode 100/101/110 = Dn OR <ea> -> <ea> */
    int sz = decode_size(opmode & 3);
    if (sz == 0) goto illegal;
    int dir = (opmode >> 2) & 1;

    if (dir == 0) {
        /* <ea> OR Dn -> Dn */
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, sz);
        uint32_t dst = size_mask(cpu->d[reg_dx], sz);
        uint32_t res = src | dst;
        if (sz == SZ_LONG)
            cpu->d[reg_dx] = res;
        else if (sz == SZ_WORD)
            cpu->d[reg_dx] = (cpu->d[reg_dx] & 0xFFFF0000) |
                             (res & 0xFFFF);
        else
            cpu->d[reg_dx] = (cpu->d[reg_dx] & 0xFFFFFF00) |
                             (res & 0xFF);
        set_flags_move(cpu, res, sz);
    } else {
        /* Dn OR <ea> -> <ea> */
        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, sz);
        uint32_t src = size_mask(cpu->d[reg_dx], sz);
        uint32_t dst = read_ea(cpu, &loc, sz);
        uint32_t res = src | dst;
        write_ea(cpu, &loc, sz, res);
        set_flags_move(cpu, res, sz);
    }
    return;

illegal:
    cf_exception(cpu, CF_VEC_ILLEGAL);
}

/****************************************************************
 * Group 9: SUB / SUBA / SUBX
 ****************************************************************/

static void exec_group9(cf_cpu *cpu, uint16_t op)
{
    int reg_dx = (op >> 9) & 7;
    int opmode = (op >> 6) & 7;
    int ea_mode = (op >> 3) & 7;
    int ea_reg = op & 7;

    /* SUBA.L : opmode 111 */
    if (opmode == 7) {
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, SZ_LONG);
        cpu->a[reg_dx] -= src;
        return;
    }

    /* SUBA.W : opmode 011 */
    if (opmode == 3) {
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, SZ_WORD);
        cpu->a[reg_dx] -= (uint32_t)sign_extend(src, SZ_WORD);
        return;
    }

    /* SUBX Dy,Dx : opmode 1xx, ea_mode = 000 */
    if ((opmode & 0x4) == 0x4 && ea_mode == 0) {
        uint32_t src = cpu->d[ea_reg];
        uint32_t dst = cpu->d[reg_dx];
        uint32_t x = (cpu->sr & CF_SR_X) ? 1 : 0;
        uint64_t diff = (uint64_t)dst - src - x;
        uint32_t res = (uint32_t)diff;
        cpu->d[reg_dx] = res;
        set_flag(cpu, CF_SR_C, diff >> 32);
        set_flag(cpu, CF_SR_X, diff >> 32);
        uint32_t sm = src & 0x80000000, dm = dst & 0x80000000;
        uint32_t rm = res & 0x80000000;
        set_flag(cpu, CF_SR_V, (sm != dm) && (rm == sm));
        set_flag(cpu, CF_SR_N, rm);
        if (res != 0) cpu->sr &= ~CF_SR_Z;
        return;
    }

    /* SUB: opmode 000/001/010 = <ea> - Dn -> Dn */
    /*      opmode 100/101/110 = Dn - <ea> -> <ea> */
    int sz = decode_size(opmode & 3);
    if (sz == 0) goto illegal;
    int dir = (opmode >> 2) & 1;

    if (dir == 0) {
        /* SUB <ea>,Dn: Dn = Dn - <ea> */
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, sz);
        uint32_t dst = size_mask(cpu->d[reg_dx], sz);
        uint32_t res = dst - src;
        if (sz == SZ_LONG)
            cpu->d[reg_dx] = res;
        else if (sz == SZ_WORD)
            cpu->d[reg_dx] = (cpu->d[reg_dx] & 0xFFFF0000) |
                             (res & 0xFFFF);
        else
            cpu->d[reg_dx] = (cpu->d[reg_dx] & 0xFFFFFF00) |
                             (res & 0xFF);
        set_flags_sub(cpu, src, dst, res, sz);
    } else {
        /* SUB Dn,<ea>: <ea> = <ea> - Dn */
        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, sz);
        uint32_t src = size_mask(cpu->d[reg_dx], sz);
        uint32_t dst = read_ea(cpu, &loc, sz);
        uint32_t res = dst - src;
        write_ea(cpu, &loc, sz, res);
        set_flags_sub(cpu, src, dst, res, sz);
    }
    return;

illegal:
    cf_exception(cpu, CF_VEC_ILLEGAL);
}

/****************************************************************
 * Group A: Line-A / EMAC
 ****************************************************************/

static void exec_groupA(cf_cpu *cpu, uint16_t op)
{
    int subop = (op >> 6) & 7;

    if (subop == 5) {
        /* MOV3Q: 1010 ddd 101 eee rrr */
        /* 3-bit data: 0 encodes -1, 1-7 encode 1-7 */
        int data_field = (op >> 9) & 7;
        int32_t val = (data_field == 0) ? -1 : data_field;
        int ea_mode = (op >> 3) & 7;
        int ea_reg = op & 7;

        if (ea_mode == 0) {
            /* Dn */
            cpu->d[ea_reg] = (uint32_t)val;
        } else if (ea_mode == 1) {
            /* An — no flags affected */
            cpu->a[ea_reg] = (uint32_t)val;
            return;
        } else {
            ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_LONG);
            write_ea(cpu, &loc, SZ_LONG, (uint32_t)val);
        }
        set_flags_move(cpu, (uint32_t)val, SZ_LONG);
    } else {
        /* Hypercall: intercept LINE_A before raising exception */
        if (cpu->hypercall &&
            cpu->hypercall(cpu, op, cpu->hypercall_ctx) == 0)
            return;
        /* EMAC instructions use line-A encoding */
        /* TODO: Implement MAC.L, MSAC.L, MOVE ACC/MACSR/MASK */
        cf_exception(cpu, CF_VEC_LINE_A);
    }
}

/****************************************************************
 * Group B: CMP / CMPA / EOR
 ****************************************************************/

static void exec_groupB(cf_cpu *cpu, uint16_t op)
{
    int reg_dx = (op >> 9) & 7;
    int opmode = (op >> 6) & 7;
    int ea_mode = (op >> 3) & 7;
    int ea_reg = op & 7;

    /* CMPA.W : opmode 011 */
    if (opmode == 3) {
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, SZ_WORD);
        src = (uint32_t)sign_extend(src, SZ_WORD);
        uint32_t dst = cpu->a[reg_dx];
        uint32_t res = dst - src;
        set_flags_cmp(cpu, src, dst, res, SZ_LONG);
        return;
    }

    /* CMPA.L : opmode 111 */
    if (opmode == 7) {
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, SZ_LONG);
        uint32_t dst = cpu->a[reg_dx];
        uint32_t res = dst - src;
        set_flags_cmp(cpu, src, dst, res, SZ_LONG);
        return;
    }

    /* EOR: opmode 100/101/110 = Dn EOR <ea> -> <ea> */
    if (opmode >= 4 && opmode <= 6) {
        int sz = decode_size(opmode & 3);
        if (sz == 0) goto illegal;
        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, sz);
        uint32_t src = size_mask(cpu->d[reg_dx], sz);
        uint32_t dst = read_ea(cpu, &loc, sz);
        uint32_t res = src ^ dst;
        write_ea(cpu, &loc, sz, res);
        set_flags_move(cpu, res, sz);
        return;
    }

    /* CMP: opmode 000/001/010 = Dn - <ea> -> CCR */
    {
        int sz = decode_size(opmode & 3);
        if (sz == 0) goto illegal;
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, sz);
        uint32_t dst = size_mask(cpu->d[reg_dx], sz);
        uint32_t res = dst - src;
        set_flags_cmp(cpu, src, dst, res, sz);
    }
    return;

illegal:
    cf_exception(cpu, CF_VEC_ILLEGAL);
}

/****************************************************************
 * Group C: AND / MULS.W / MULU.W / EXG
 ****************************************************************/

static void exec_groupC(cf_cpu *cpu, uint16_t op)
{
    int reg_dx = (op >> 9) & 7;
    int opmode = (op >> 6) & 7;
    int ea_mode = (op >> 3) & 7;
    int ea_reg = op & 7;

    /* MULU.W : opmode 011 */
    if (opmode == 3) {
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, SZ_WORD) & 0xFFFF;
        uint32_t dst = cpu->d[reg_dx] & 0xFFFF;
        uint32_t res = dst * src;
        cpu->d[reg_dx] = res;
        set_flags_move(cpu, res, SZ_LONG);
        return;
    }

    /* MULS.W : opmode 111 */
    if (opmode == 7) {
        int16_t src = (int16_t)ea_read(cpu, ea_mode, ea_reg, SZ_WORD);
        int16_t dst = (int16_t)(cpu->d[reg_dx] & 0xFFFF);
        int32_t res = (int32_t)dst * (int32_t)src;
        cpu->d[reg_dx] = (uint32_t)res;
        set_flags_move(cpu, (uint32_t)res, SZ_LONG);
        return;
    }

    /* EXG: opmode 01000 (Dx<->Dy), 01001 (Ax<->Ay), 10001 (Dx<->Ay) */
    if ((op & 0xF130) == 0xC100) {
        int opm5 = (op >> 3) & 0x1F;
        uint32_t tmp;
        switch (opm5) {
        case 0x08: /* EXG Dx, Dy */
            tmp = cpu->d[reg_dx];
            cpu->d[reg_dx] = cpu->d[ea_reg];
            cpu->d[ea_reg] = tmp;
            return;
        case 0x09: /* EXG Ax, Ay */
            tmp = cpu->a[reg_dx];
            cpu->a[reg_dx] = cpu->a[ea_reg];
            cpu->a[ea_reg] = tmp;
            return;
        case 0x11: /* EXG Dx, Ay */
            tmp = cpu->d[reg_dx];
            cpu->d[reg_dx] = cpu->a[ea_reg];
            cpu->a[ea_reg] = tmp;
            return;
        }
    }

    /* AND: opmode 000/001/010 = <ea> AND Dn -> Dn */
    /*      opmode 100/101/110 = Dn AND <ea> -> <ea> */
    int sz = decode_size(opmode & 3);
    if (sz == 0) goto illegal;
    int dir = (opmode >> 2) & 1;

    if (dir == 0) {
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, sz);
        uint32_t dst = size_mask(cpu->d[reg_dx], sz);
        uint32_t res = src & dst;
        if (sz == SZ_LONG)
            cpu->d[reg_dx] = res;
        else if (sz == SZ_WORD)
            cpu->d[reg_dx] = (cpu->d[reg_dx] & 0xFFFF0000) |
                             (res & 0xFFFF);
        else
            cpu->d[reg_dx] = (cpu->d[reg_dx] & 0xFFFFFF00) |
                             (res & 0xFF);
        set_flags_move(cpu, res, sz);
    } else {
        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, sz);
        uint32_t src = size_mask(cpu->d[reg_dx], sz);
        uint32_t dst = read_ea(cpu, &loc, sz);
        uint32_t res = src & dst;
        write_ea(cpu, &loc, sz, res);
        set_flags_move(cpu, res, sz);
    }
    return;

illegal:
    cf_exception(cpu, CF_VEC_ILLEGAL);
}

/****************************************************************
 * Group D: ADD / ADDA / ADDX
 ****************************************************************/

static void exec_groupD(cf_cpu *cpu, uint16_t op)
{
    int reg_dx = (op >> 9) & 7;
    int opmode = (op >> 6) & 7;
    int ea_mode = (op >> 3) & 7;
    int ea_reg = op & 7;

    /* ADDA.W : opmode 011 */
    if (opmode == 3) {
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, SZ_WORD);
        cpu->a[reg_dx] += (uint32_t)sign_extend(src, SZ_WORD);
        return;
    }

    /* ADDA.L : opmode 111 */
    if (opmode == 7) {
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, SZ_LONG);
        cpu->a[reg_dx] += src;
        return;
    }

    /* ADDX Dy,Dx : opmode 1xx, ea_mode = 000 */
    if ((opmode & 0x4) == 0x4 && ea_mode == 0) {
        uint32_t src = cpu->d[ea_reg];
        uint32_t dst = cpu->d[reg_dx];
        uint32_t x = (cpu->sr & CF_SR_X) ? 1 : 0;
        uint64_t sum = (uint64_t)dst + src + x;
        uint32_t res = (uint32_t)sum;
        cpu->d[reg_dx] = res;
        set_flag(cpu, CF_SR_C, sum >> 32);
        set_flag(cpu, CF_SR_X, sum >> 32);
        uint32_t sm = src & 0x80000000, dm = dst & 0x80000000;
        uint32_t rm = res & 0x80000000;
        set_flag(cpu, CF_SR_V, (sm == dm) && (rm != sm));
        set_flag(cpu, CF_SR_N, rm);
        if (res != 0) cpu->sr &= ~CF_SR_Z;
        return;
    }

    /* ADD */
    int sz = decode_size(opmode & 3);
    if (sz == 0) goto illegal;
    int dir = (opmode >> 2) & 1;

    if (dir == 0) {
        /* <ea> + Dn -> Dn */
        uint32_t src = ea_read(cpu, ea_mode, ea_reg, sz);
        uint32_t dst = size_mask(cpu->d[reg_dx], sz);
        uint32_t res = dst + src;
        if (sz == SZ_LONG)
            cpu->d[reg_dx] = res;
        else if (sz == SZ_WORD)
            cpu->d[reg_dx] = (cpu->d[reg_dx] & 0xFFFF0000) |
                             (res & 0xFFFF);
        else
            cpu->d[reg_dx] = (cpu->d[reg_dx] & 0xFFFFFF00) |
                             (res & 0xFF);
        set_flags_add(cpu, src, dst, res, sz);
    } else {
        /* Dn + <ea> -> <ea> */
        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, sz);
        uint32_t src = size_mask(cpu->d[reg_dx], sz);
        uint32_t dst = read_ea(cpu, &loc, sz);
        uint32_t res = dst + src;
        write_ea(cpu, &loc, sz, res);
        set_flags_add(cpu, src, dst, res, sz);
    }
    return;

illegal:
    cf_exception(cpu, CF_VEC_ILLEGAL);
}

/****************************************************************
 * Group E: Shifts and rotates
 ****************************************************************/

static void exec_groupE(cf_cpu *cpu, uint16_t op)
{
    int count_reg = (op >> 9) & 7;
    int dir = (op >> 8) & 1; /* 0=right, 1=left */
    int sz_bits = (op >> 6) & 3;
    int ir = (op >> 5) & 1;  /* 0=count is immediate, 1=count in reg */
    int type = (op >> 3) & 3; /* 00=AS, 01=LS, 10=ROX, 11=RO */
    int reg = op & 7;

    if (sz_bits == 3) {
        /* Memory shift — not commonly used on ColdFire */
        cf_exception(cpu, CF_VEC_ILLEGAL);
        return;
    }

    int sz = decode_size(sz_bits);
    if (sz == 0) { cf_exception(cpu, CF_VEC_ILLEGAL); return; }

    int count;
    if (ir)
        count = cpu->d[count_reg] & 63;
    else
        count = count_reg ? count_reg : 8;

    uint32_t val = size_mask(cpu->d[reg], sz);
    uint32_t msb;
    switch (sz) {
    case SZ_BYTE: msb = 0x80; break;
    case SZ_WORD: msb = 0x8000; break;
    default:      msb = 0x80000000; break;
    }
    int bits = sz * 8;
    uint32_t mask = (sz == SZ_LONG) ? 0xFFFFFFFF :
                    (1u << bits) - 1;

    uint32_t res = val;
    int last_out = 0;

    if (count == 0) {
        set_nz(cpu, res, sz);
        cpu->sr &= ~(CF_SR_V | CF_SR_C);
        goto store;
    }

    switch (type) {
    case 0: /* ASL / ASR */
        if (dir) {
            /* ASL */
            for (int i = 0; i < count; i++) {
                last_out = (res & msb) ? 1 : 0;
                res <<= 1;
            }
            res &= mask;
            set_nz(cpu, res, sz);
            set_flag(cpu, CF_SR_C, last_out);
            set_flag(cpu, CF_SR_X, last_out);
            set_flag(cpu, CF_SR_V, 0); /* ColdFire: V always 0 */
        } else {
            /* ASR — arithmetic, sign-extending */
            int32_t sval = sign_extend(val, sz);
            for (int i = 0; i < count; i++) {
                last_out = sval & 1;
                sval >>= 1;
            }
            res = (uint32_t)sval & mask;
            set_nz(cpu, res, sz);
            set_flag(cpu, CF_SR_C, last_out);
            set_flag(cpu, CF_SR_X, last_out);
            cpu->sr &= ~CF_SR_V;
        }
        break;

    case 1: /* LSL / LSR */
        if (dir) {
            for (int i = 0; i < count; i++) {
                last_out = (res & msb) ? 1 : 0;
                res <<= 1;
            }
            res &= mask;
        } else {
            for (int i = 0; i < count; i++) {
                last_out = res & 1;
                res >>= 1;
            }
        }
        set_nz(cpu, res, sz);
        set_flag(cpu, CF_SR_C, last_out);
        set_flag(cpu, CF_SR_X, last_out);
        cpu->sr &= ~CF_SR_V;
        break;

    case 3: /* ROL / ROR */
        if (dir) {
            /* ROL — not on ColdFire, but ROR is */
            cf_exception(cpu, CF_VEC_ILLEGAL);
            return;
        } else {
            /* ROR */
            for (int i = 0; i < count; i++) {
                last_out = res & 1;
                res = (res >> 1) | (last_out ? msb : 0);
            }
            res &= mask;
        }
        set_nz(cpu, res, sz);
        set_flag(cpu, CF_SR_C, last_out);
        cpu->sr &= ~CF_SR_V;
        /* X not affected by rotate */
        break;

    default: /* ROX — not typically on ColdFire */
        cf_exception(cpu, CF_VEC_ILLEGAL);
        return;
    }

store:
    /* Write back */
    switch (sz) {
    case SZ_BYTE:
        cpu->d[reg] = (cpu->d[reg] & 0xFFFFFF00) | (res & 0xFF);
        break;
    case SZ_WORD:
        cpu->d[reg] = (cpu->d[reg] & 0xFFFF0000) | (res & 0xFFFF);
        break;
    default:
        cpu->d[reg] = res;
        break;
    }
}

/****************************************************************
 * Group F: Line-F / FPU
 ****************************************************************/

static int eval_fpcc(cf_cpu *cpu, int cc)
{
    uint32_t fpcc = cpu->fpsr >> 24;
    int fn = (fpcc >> 3) & 1;
    int fz = (fpcc >> 2) & 1;
    int fnan = fpcc & 1;

    switch (cc & 0xF) {
    case 0x0: return 0;                              /* F */
    case 0x1: return fz;                             /* EQ */
    case 0x2: return !(fnan || fz || fn);            /* OGT */
    case 0x3: return fz || !(fnan || fn);            /* OGE */
    case 0x4: return fn && !(fnan || fz);            /* OLT */
    case 0x5: return fz || (fn && !fnan);            /* OLE */
    case 0x6: return !(fnan || fz);                  /* OGL */
    case 0x7: return !fnan;                          /* OR */
    case 0x8: return fnan;                           /* UN */
    case 0x9: return fnan || fz;                     /* UEQ */
    case 0xA: return fnan || !(fn || fz);            /* UGT */
    case 0xB: return fnan || fz || !fn;              /* UGE */
    case 0xC: return fnan || (fn && !fz);            /* ULT */
    case 0xD: return fnan || fz || fn;               /* ULE */
    case 0xE: return !fz;                            /* NE */
    case 0xF: return 1;                              /* T */
    }
    return 0;
}

/** Read a double-precision (8-byte) value from an effective address. */
static double fpu_read_double(cf_cpu *cpu, int ea_mode, int ea_reg)
{
    uint64_t bits;
    uint32_t hi, lo;

    if (ea_mode == 3) {
        /* (An)+ postincrement: read 8 bytes, advance An by 8 */
        uint32_t addr = cpu->a[ea_reg];
        hi = bus_read32(cpu, addr);
        lo = bus_read32(cpu, addr + 4);
        cpu->a[ea_reg] = addr + 8;
    } else {
        /* All other modes: decode EA for address, read 8 bytes */
        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_LONG);
        hi = bus_read32(cpu, loc.addr);
        lo = bus_read32(cpu, loc.addr + 4);
    }
    bits = ((uint64_t)hi << 32) | lo;
    double val;
    memcpy(&val, &bits, sizeof(val));
    return val;
}

static void exec_groupF(cf_cpu *cpu, uint16_t op)
{
    /* CP ID is in the opword bits 11-9 */
    int cp_id = (op >> 9) & 7;

    if (cp_id != 1) {
        cf_exception(cpu, CF_VEC_LINE_F);
        return;
    }

    /* FBcc: opword bits 8-7 = 01 */
    if ((op >> 7) & 1) {
        int sz = (op >> 6) & 1;  /* 0=word disp, 1=long disp */
        int cc = op & 0x3F;
        uint32_t base_pc = cpu->pc; /* PC of displacement word */
        int32_t disp;

        if (sz)
            disp = (int32_t)fetch32(cpu);
        else
            disp = (int16_t)fetch16(cpu);

        if (eval_fpcc(cpu, cc))
            cpu->pc = base_pc + disp;
        return;
    }

    /* General FPU: fetch extension word */
    uint16_t ext = fetch16(cpu);

    /* Dispatch on extension word bits 15-13 (opclass) */
    int opclass = (ext >> 13) & 7;

    switch (opclass) {
    case 0: /* Register-to-register (R/M=0, bit 14=0) */
    case 2: { /* Memory-to-register (R/M=1, bit 14=1) */
        int dst_fp = (ext >> 7) & 7;
        int opcode = ext & 0x7F;
        double src_val;

        if (opclass == 0) {
            /* Register to register: source = bits 12-10 */
            int src_fp = (ext >> 10) & 7;
            src_val = cpu->fp[src_fp];
        } else {
            /* Memory to register: source format = bits 12-10 */
            int ea_mode = (op >> 3) & 7;
            int ea_reg = op & 7;
            int src_fmt = (ext >> 10) & 7;

            switch (src_fmt) {
            case 0: { /* Long integer */
                uint32_t raw = ea_read(cpu, ea_mode, ea_reg, SZ_LONG);
                src_val = (double)(int32_t)raw;
                break;
            }
            case 1: { /* Single float */
                uint32_t raw = ea_read(cpu, ea_mode, ea_reg, SZ_LONG);
                float f;
                memcpy(&f, &raw, sizeof(f));
                src_val = (double)f;
                break;
            }
            case 4: { /* Word integer */
                uint32_t raw = ea_read(cpu, ea_mode, ea_reg, SZ_WORD);
                src_val = (double)(int16_t)raw;
                break;
            }
            case 5: /* Double */
                src_val = fpu_read_double(cpu, ea_mode, ea_reg);
                break;
            case 6: { /* Byte integer */
                uint32_t raw = ea_read(cpu, ea_mode, ea_reg, SZ_BYTE);
                src_val = (double)(int8_t)raw;
                break;
            }
            default:
                cf_exception(cpu, CF_VEC_LINE_F);
                return;
            }
        }

        /* Execute FPU operation */
        double *dp = &cpu->fp[dst_fp];
        switch (opcode) {
        case 0x00: *dp = src_val; break;                 /* FMOVE */
        case 0x01: *dp = rint(src_val); break;           /* FINT */
        case 0x03: *dp = trunc(src_val); break;          /* FINTRZ */
        case 0x04: *dp = sqrt(src_val); break;           /* FSQRT */
        case 0x18: *dp = fabs(src_val); break;           /* FABS */
        case 0x1A: *dp = -src_val; break;                /* FNEG */
        case 0x20: *dp /= src_val; break;                /* FDIV */
        case 0x22: *dp += src_val; break;                /* FADD */
        case 0x23: *dp *= src_val; break;                /* FMUL */
        case 0x28: *dp -= src_val; break;                /* FSUB */
        case 0x38: /* FCMP */ {
            double diff = *dp - src_val;
            uint32_t fpcc = 0;
            if (isnan(diff))   fpcc |= (1 << 24); /* NAN */
            else if (diff < 0) fpcc |= (1 << 27); /* N */
            else if (diff == 0)fpcc |= (1 << 26); /* Z */
            if (isinf(src_val) || isinf(*dp))
                fpcc |= (1 << 25); /* I */
            cpu->fpsr = (cpu->fpsr & 0x00FFFFFF) | fpcc;
            break;
        }
        case 0x3A: /* FTST */ {
            uint32_t fpcc = 0;
            if (isnan(src_val))   fpcc |= (1 << 24);
            else if (src_val < 0) fpcc |= (1 << 27);
            else if (src_val == 0)fpcc |= (1 << 26);
            if (isinf(src_val))   fpcc |= (1 << 25);
            cpu->fpsr = (cpu->fpsr & 0x00FFFFFF) | fpcc;
            break;
        }
        /* Single-precision rounding variants (FS prefix) */
        case 0x40: *dp = (float)src_val; break;          /* FSMOVE */
        case 0x41: *dp = sqrtf((float)src_val); break;   /* FSSQRT */
        case 0x58: *dp = fabsf((float)src_val); break;   /* FSABS */
        case 0x5A: *dp = -(float)src_val; break;         /* FSNEG */
        case 0x60: *dp = (float)(*dp / src_val); break;  /* FSDIV */
        case 0x62: *dp = (float)(*dp + src_val); break;  /* FSADD */
        case 0x63: *dp = (float)(*dp * src_val); break;  /* FSMUL */
        case 0x68: *dp = (float)(*dp - src_val); break;  /* FSSUB */
        /* Double-precision rounding variants (FD prefix) */
        case 0x44: *dp = src_val; break;                  /* FDMOVE */
        case 0x45: *dp = sqrt(src_val); break;            /* FDSQRT */
        case 0x5C: *dp = fabs(src_val); break;            /* FDABS */
        case 0x5E: *dp = -src_val; break;                 /* FDNEG */
        case 0x64: *dp = *dp / src_val; break;            /* FDDIV */
        case 0x66: *dp = *dp + src_val; break;            /* FDADD */
        case 0x67: *dp = *dp * src_val; break;            /* FDMUL */
        case 0x6C: *dp = *dp - src_val; break;            /* FDSUB */
        default:
            cf_exception(cpu, CF_VEC_LINE_F);
            return;
        }
        break;
    }

    case 3: { /* FMOVE FPn → <ea> (register to memory) */
        int ea_mode = (op >> 3) & 7;
        int ea_reg = op & 7;
        int dst_fmt = (ext >> 10) & 7;
        int src_fp = (ext >> 7) & 7;
        double val = cpu->fp[src_fp];

        switch (dst_fmt) {
        case 0: { /* Long integer */
            int32_t ival = (int32_t)val;
            ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_LONG);
            write_ea(cpu, &loc, SZ_LONG, (uint32_t)ival);
            break;
        }
        case 1: { /* Single float */
            float f = (float)val;
            uint32_t raw;
            memcpy(&raw, &f, sizeof(raw));
            ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_LONG);
            write_ea(cpu, &loc, SZ_LONG, raw);
            break;
        }
        case 4: { /* Word integer */
            int16_t ival = (int16_t)val;
            ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_WORD);
            write_ea(cpu, &loc, SZ_WORD, (uint32_t)(uint16_t)ival);
            break;
        }
        case 5: { /* Double */
            uint64_t bits;
            memcpy(&bits, &val, sizeof(bits));
            if (ea_mode == 4) {
                /* predecrement: write 8 bytes */
                cpu->a[ea_reg] -= 8;
                uint32_t addr = cpu->a[ea_reg];
                bus_write32(cpu, addr, (uint32_t)(bits >> 32));
                bus_write32(cpu, addr + 4, (uint32_t)bits);
            } else {
                ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_LONG);
                bus_write32(cpu, loc.addr, (uint32_t)(bits >> 32));
                bus_write32(cpu, loc.addr + 4, (uint32_t)bits);
            }
            break;
        }
        case 6: { /* Byte integer */
            int8_t ival = (int8_t)val;
            ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_BYTE);
            write_ea(cpu, &loc, SZ_BYTE, (uint32_t)(uint8_t)ival);
            break;
        }
        default:
            cf_exception(cpu, CF_VEC_LINE_F);
            return;
        }
        break;
    }

    case 4: { /* FMOVE to system control register */
        int ea_mode = (op >> 3) & 7;
        int ea_reg = op & 7;
        int regsel = (ext >> 10) & 7;
        uint32_t val = ea_read(cpu, ea_mode, ea_reg, SZ_LONG);

        if (regsel & 4) cpu->fpcr = val;
        if (regsel & 2) cpu->fpsr = val;
        if (regsel & 1) cpu->fpiar = val;
        break;
    }

    case 5: { /* FMOVE from system control register */
        int ea_mode = (op >> 3) & 7;
        int ea_reg = op & 7;
        int regsel = (ext >> 10) & 7;
        uint32_t val = 0;

        if (regsel & 4) val = cpu->fpcr;
        else if (regsel & 2) val = cpu->fpsr;
        else if (regsel & 1) val = cpu->fpiar;

        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_LONG);
        write_ea(cpu, &loc, SZ_LONG, val);
        break;
    }

    case 6: /* FMOVEM: memory → FP registers (dr=0) */
    case 7: { /* FMOVEM: FP registers → memory (dr=1) */
        int ea_mode = (op >> 3) & 7;
        int ea_reg = op & 7;
        int regmask = ext & 0xFF;
        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_LONG);
        uint32_t addr = loc.addr;

        if (opclass == 6) {
            /* Memory to FP registers (load) */
            for (int i = 0; i < 8; i++) {
                if (regmask & (1 << (7 - i))) {
                    uint64_t bits;
                    uint32_t hi = bus_read32(cpu, addr);
                    uint32_t lo = bus_read32(cpu, addr + 4);
                    bits = ((uint64_t)hi << 32) | lo;
                    memcpy(&cpu->fp[i], &bits, sizeof(double));
                    addr += 8;
                }
            }
        } else {
            /* FP registers to memory (store) */
            for (int i = 0; i < 8; i++) {
                if (regmask & (1 << (7 - i))) {
                    uint64_t bits;
                    memcpy(&bits, &cpu->fp[i], sizeof(double));
                    bus_write32(cpu, addr, (uint32_t)(bits >> 32));
                    bus_write32(cpu, addr + 4, (uint32_t)bits);
                    addr += 8;
                }
            }
        }
        break;
    }

    default:
        cf_exception(cpu, CF_VEC_LINE_F);
        break;
    }
}

/****************************************************************
 * Bit operations with register bit number (Group 0 overlap)
 * BTST/BCHG/BCLR/BSET Dn, <ea>
 ****************************************************************/

static void exec_bit_reg(cf_cpu *cpu, uint16_t op)
{
    int bit_reg = (op >> 9) & 7;
    int bit_op = (op >> 6) & 3;
    int ea_mode = (op >> 3) & 7;
    int ea_reg = op & 7;
    int bitnum = cpu->d[bit_reg];

    if (ea_mode == 0) {
        bitnum &= 31;
        uint32_t val = cpu->d[ea_reg];
        set_flag(cpu, CF_SR_Z, !(val & (1u << bitnum)));
        switch (bit_op) {
        case 0: break;
        case 1: cpu->d[ea_reg] = val ^ (1u << bitnum); break;
        case 2: cpu->d[ea_reg] = val & ~(1u << bitnum); break;
        case 3: cpu->d[ea_reg] = val | (1u << bitnum); break;
        }
    } else {
        bitnum &= 7;
        ea_loc loc = decode_ea(cpu, ea_mode, ea_reg, SZ_BYTE);
        uint32_t val = read_ea(cpu, &loc, SZ_BYTE);
        set_flag(cpu, CF_SR_Z, !(val & (1u << bitnum)));
        switch (bit_op) {
        case 0: break;
        case 1: write_ea(cpu, &loc, SZ_BYTE,
                         val ^ (1u << bitnum)); break;
        case 2: write_ea(cpu, &loc, SZ_BYTE,
                         val & ~(1u << bitnum)); break;
        case 3: write_ea(cpu, &loc, SZ_BYTE,
                         val | (1u << bitnum)); break;
        }
    }
}

/****************************************************************
 * Main decoder
 ****************************************************************/

int cf_step(cf_cpu *cpu)
{
    if (cpu->halted)
        return -1;

    uint16_t op = fetch16(cpu);
    int group = (op >> 12) & 0xF;

    switch (group) {
    case 0x0:
        /* Check for BTST/BCHG/BCLR/BSET with register bit number */
        /* These are: 0000 rrr1 xx eee rrr (xx = 00 BTST, 01 BCHG, 10 BCLR, 11 BSET) */
        if (op & 0x0100) {
            /* MOVEP (0000 rrr1 xx 001 rrr) not on ColdFire — no conflict */
            exec_bit_reg(cpu, op);
        } else {
            exec_group0(cpu, op);
        }
        break;

    case 0x1: exec_move(cpu, op, SZ_BYTE); break;
    case 0x2: exec_move(cpu, op, SZ_LONG); break;
    case 0x3: exec_move(cpu, op, SZ_WORD); break;
    case 0x4: exec_group4(cpu, op); break;
    case 0x5: exec_group5(cpu, op); break;
    case 0x6: exec_group6(cpu, op); break;
    case 0x7: exec_group7(cpu, op); break;
    case 0x8: exec_group8(cpu, op); break;
    case 0x9: exec_group9(cpu, op); break;
    case 0xA: exec_groupA(cpu, op); break;
    case 0xB: exec_groupB(cpu, op); break;
    case 0xC: exec_groupC(cpu, op); break;
    case 0xD: exec_groupD(cpu, op); break;
    case 0xE: exec_groupE(cpu, op); break;
    case 0xF: exec_groupF(cpu, op); break;
    }

    cpu->cycles++;
    return cpu->halted ? -1 : 0;
}

int cf_run(cf_cpu *cpu, int count)
{
    int i;
    for (i = 0; i < count; i++) {
        if (cf_step(cpu) < 0)
            break;
    }
    return i;
}

/****************************************************************
 * Public API
 ****************************************************************/

void cf_init(cf_cpu *cpu,
             cf_read_fn r8, cf_read_fn r16, cf_read_fn r32,
             cf_write_fn w8, cf_write_fn w16, cf_write_fn w32,
             void *bus_ctx)
{
    memset(cpu, 0, sizeof(*cpu));
    cpu->read8 = r8;
    cpu->read16 = r16;
    cpu->read32 = r32;
    cpu->write8 = w8;
    cpu->write16 = w16;
    cpu->write32 = w32;
    cpu->bus_ctx = bus_ctx;
    /* Start in supervisor mode */
    cpu->sr = CF_SR_S;
}

void cf_reset(cf_cpu *cpu)
{
    /* Load SSP and PC from reset vectors */
    cpu->sr = CF_SR_S | (7 << 8); /* supervisor, IPL=7 */
    cpu->a[7] = bus_read32(cpu, cpu->vbr + 0);
    cpu->pc = bus_read32(cpu, cpu->vbr + 4);
    cpu->halted = 0;
    cpu->fault = 0;
    cpu->cycles = 0;

    /* Clear FPU */
    for (int i = 0; i < 8; i++)
        cpu->fp[i] = 0.0;
    cpu->fpcr = 0;
    cpu->fpsr = 0;
    cpu->fpiar = 0;

    /* Clear EMAC */
    for (int i = 0; i < 4; i++)
        cpu->acc[i] = 0;
    cpu->macsr = 0;
    cpu->mask = 0;
}

uint32_t cf_get_d(cf_cpu *cpu, int n) { return cpu->d[n & 7]; }
uint32_t cf_get_a(cf_cpu *cpu, int n) { return cpu->a[n & 7]; }
uint32_t cf_get_pc(cf_cpu *cpu) { return cpu->pc; }
uint32_t cf_get_sr(cf_cpu *cpu) { return cpu->sr; }

void cf_set_d(cf_cpu *cpu, int n, uint32_t val) { cpu->d[n & 7] = val; }
void cf_set_a(cf_cpu *cpu, int n, uint32_t val) { cpu->a[n & 7] = val; }
void cf_set_pc(cf_cpu *cpu, uint32_t val) { cpu->pc = val; }

void cf_set_sr(cf_cpu *cpu, uint32_t val)
{
    update_sp(cpu, val);
    cpu->sr = val & 0xFFFF;
}

double cf_get_fp(cf_cpu *cpu, int n) { return cpu->fp[n & 7]; }
void cf_set_fp(cf_cpu *cpu, int n, double val) { cpu->fp[n & 7] = val; }

void cf_set_hypercall(cf_cpu *cpu, cf_hypercall_fn fn, void *ctx)
{
    cpu->hypercall = fn;
    cpu->hypercall_ctx = ctx;
}
