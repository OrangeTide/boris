/* rv_gdb.c : the RV32 backend for the shared GDB stub (see rv_gdb.h).

   Supplies the gdb_target vtable (registers, memory, single-step, stop signal)
   and a RISC-V target description; the protocol, transport, and the
   breakpoint/watchpoint tables live in the shared core (gdbstub.c). */

#include "rv_gdb.h"
#include "gdbstub.h"

#include <string.h>

#define NGPR        32
#define RV_FP0      33              /* regnum of f0 (ft0), after the 33 GPRs+pc */
#define RV_FCSR     65              /* regnum of fcsr */
#define NREG_ALL    66              /* x0-x31, pc, f0-f31, fcsr */

/* The target description gdb reads over qXfer, so a plain `gdb-multiarch
 * target remote` learns the architecture and register layout with no manual
 * `set architecture`.  33 registers: x0-x31 then pc, each 32 bits. */
static const char target_xml[] =
    "<?xml version=\"1.0\"?>\n"
    "<!DOCTYPE target SYSTEM \"gdb-target.dtd\">\n"
    "<target version=\"1.0\">\n"
    "  <architecture>riscv:rv32</architecture>\n"
    "  <feature name=\"org.gnu.gdb.riscv.cpu\">\n"
    "    <reg name=\"zero\" bitsize=\"32\" regnum=\"0\"/>\n"
    "    <reg name=\"ra\" bitsize=\"32\"/>\n"
    "    <reg name=\"sp\" bitsize=\"32\"/>\n"
    "    <reg name=\"gp\" bitsize=\"32\"/>\n"
    "    <reg name=\"tp\" bitsize=\"32\"/>\n"
    "    <reg name=\"t0\" bitsize=\"32\"/>\n"
    "    <reg name=\"t1\" bitsize=\"32\"/>\n"
    "    <reg name=\"t2\" bitsize=\"32\"/>\n"
    "    <reg name=\"fp\" bitsize=\"32\"/>\n"
    "    <reg name=\"s1\" bitsize=\"32\"/>\n"
    "    <reg name=\"a0\" bitsize=\"32\"/>\n"
    "    <reg name=\"a1\" bitsize=\"32\"/>\n"
    "    <reg name=\"a2\" bitsize=\"32\"/>\n"
    "    <reg name=\"a3\" bitsize=\"32\"/>\n"
    "    <reg name=\"a4\" bitsize=\"32\"/>\n"
    "    <reg name=\"a5\" bitsize=\"32\"/>\n"
    "    <reg name=\"a6\" bitsize=\"32\"/>\n"
    "    <reg name=\"a7\" bitsize=\"32\"/>\n"
    "    <reg name=\"s2\" bitsize=\"32\"/>\n"
    "    <reg name=\"s3\" bitsize=\"32\"/>\n"
    "    <reg name=\"s4\" bitsize=\"32\"/>\n"
    "    <reg name=\"s5\" bitsize=\"32\"/>\n"
    "    <reg name=\"s6\" bitsize=\"32\"/>\n"
    "    <reg name=\"s7\" bitsize=\"32\"/>\n"
    "    <reg name=\"s8\" bitsize=\"32\"/>\n"
    "    <reg name=\"s9\" bitsize=\"32\"/>\n"
    "    <reg name=\"s10\" bitsize=\"32\"/>\n"
    "    <reg name=\"s11\" bitsize=\"32\"/>\n"
    "    <reg name=\"t3\" bitsize=\"32\"/>\n"
    "    <reg name=\"t4\" bitsize=\"32\"/>\n"
    "    <reg name=\"t5\" bitsize=\"32\"/>\n"
    "    <reg name=\"t6\" bitsize=\"32\"/>\n"
    "    <reg name=\"pc\" bitsize=\"32\" type=\"code_ptr\" regnum=\"32\"/>\n"
    "  </feature>\n"
    "  <feature name=\"org.gnu.gdb.riscv.fpu\">\n"
    "    <reg name=\"ft0\" bitsize=\"64\" type=\"ieee_double\" regnum=\"33\"/>\n"
    "    <reg name=\"ft1\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft2\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft3\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft4\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft5\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft6\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft7\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs0\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs1\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fa0\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fa1\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fa2\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fa3\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fa4\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fa5\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fa6\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fa7\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs2\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs3\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs4\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs5\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs6\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs7\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs8\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs9\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs10\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fs11\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft8\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft9\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft10\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"ft11\" bitsize=\"64\" type=\"ieee_double\"/>\n"
    "    <reg name=\"fcsr\" bitsize=\"32\" regnum=\"65\"/>\n"
    "  </feature>\n"
    "</target>\n";

struct rv_ctx {
    rv_cpu *cpu;
    guest *g;
};

/****************************************************************
 * Register hex marshalling (RISC-V specific)
 ****************************************************************/

static char
hexdig(int v)
{
    return "0123456789abcdef"[v & 0xf];
}

static int
hexval(int c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

/* Little-endian u32 -> 8 lowercase hex chars appended at *p. */
static void
put_u32_hex(char **p, uint32_t v)
{
    int i;
    for (i = 0; i < 4; i++) {        /* byte 0 first (little-endian) */
        unsigned b = (v >> (8 * i)) & 0xff;
        *(*p)++ = hexdig(b >> 4);
        *(*p)++ = hexdig(b & 0xf);
    }
}

/* Read a little-endian u32 from 8 hex chars; returns 0 on success. */
static int
get_u32_hex(const char *p, uint32_t *out)
{
    uint32_t v = 0;
    int i;
    for (i = 0; i < 4; i++) {
        int hi = hexval(p[2 * i]), lo = hexval(p[2 * i + 1]);
        if (hi < 0 || lo < 0)
            return -1;
        v |= (uint32_t)((hi << 4) | lo) << (8 * i);
    }
    *out = v;
    return 0;
}

/* Little-endian u64 -> 16 lowercase hex chars appended at *p. */
static void
put_u64_hex(char **p, uint64_t v)
{
    int i;
    for (i = 0; i < 8; i++) {        /* byte 0 first (little-endian) */
        unsigned b = (unsigned)(v >> (8 * i)) & 0xff;
        *(*p)++ = hexdig(b >> 4);
        *(*p)++ = hexdig(b & 0xf);
    }
}

/* Read a little-endian u64 from 16 hex chars; returns 0 on success. */
static int
get_u64_hex(const char *p, uint64_t *out)
{
    uint64_t v = 0;
    int i;
    for (i = 0; i < 8; i++) {
        int hi = hexval(p[2 * i]), lo = hexval(p[2 * i + 1]);
        if (hi < 0 || lo < 0)
            return -1;
        v |= (uint64_t)((hi << 4) | lo) << (8 * i);
    }
    *out = v;
    return 0;
}

/* Byte width of register n in the g/G stream and p/P packets. */
static int
reg_width(int n)
{
    return (n >= RV_FP0 && n < RV_FP0 + 32) ? 8 : 4;
}

/* Append register n in target (little-endian) byte order; out-of-range is a
   no-op.  The 32 FP registers are the full 64-bit D-extension view (cpu->f);
   the integer registers, pc and fcsr are 32-bit. */
static void
emit_reg(char **w, struct rv_ctx *c, int n)
{
    if (n < NGPR)
        put_u32_hex(w, rv_get_x(c->cpu, n));
    else if (n == NGPR)
        put_u32_hex(w, rv_get_pc(c->cpu));
    else if (n >= RV_FP0 && n < RV_FP0 + 32)
        put_u64_hex(w, c->cpu->f[n - RV_FP0]);
    else if (n == RV_FCSR)
        put_u32_hex(w, c->cpu->fcsr);
}

/* Set register n from hex at h (width per reg_width); returns 0 on success. */
static int
set_reg(struct rv_ctx *c, int n, const char *h)
{
    uint32_t v32;
    uint64_t v64;

    if (n < NGPR) {
        if (get_u32_hex(h, &v32)) return -1;
        rv_set_x(c->cpu, n, v32);
    } else if (n == NGPR) {
        if (get_u32_hex(h, &v32)) return -1;
        rv_set_pc(c->cpu, v32);
    } else if (n >= RV_FP0 && n < RV_FP0 + 32) {
        if (get_u64_hex(h, &v64)) return -1;
        c->cpu->f[n - RV_FP0] = v64;
    } else if (n == RV_FCSR) {
        if (get_u32_hex(h, &v32)) return -1;
        c->cpu->fcsr = v32;
    } else {
        return -1;
    }
    return 0;
}

/****************************************************************
 * The gdb_target vtable
 ****************************************************************/

static int
rv_read_regs(void *ctx, char *out, size_t cap)
{
    struct rv_ctx *c = ctx;
    char *w = out;
    int i;
    (void)cap;
    for (i = 0; i < NREG_ALL; i++)
        emit_reg(&w, c, i);
    *w = '\0';
    return 0;
}

static int
rv_write_regs(void *ctx, const char *hex)
{
    struct rv_ctx *c = ctx;
    const char *h = hex;
    int i;
    for (i = 0; i < NREG_ALL; i++) {
        int bytes = reg_width(i);
        if ((int)strlen(h) < bytes * 2 || set_reg(c, i, h))
            return -1;
        h += bytes * 2;
    }
    return 0;
}

static int
rv_read_reg(void *ctx, int n, char *out, size_t cap)
{
    struct rv_ctx *c = ctx;
    char *w = out;
    (void)cap;
    if (n < 0 || n >= NREG_ALL)
        return -1;
    emit_reg(&w, c, n);
    *w = '\0';
    return 0;
}

static int
rv_write_reg(void *ctx, int n, const char *hex)
{
    if (n < 0 || n >= NREG_ALL)
        return -1;
    return set_reg(ctx, n, hex);
}

static int
rv_mem_mapped(void *ctx, uint64_t addr)
{
    guest *g = ((struct rv_ctx *)ctx)->g;
    uint32_t a = (uint32_t)addr;
    int i;
    for (i = 0; i < g->mem.nregions; i++) {
        struct gm_region *r = &g->mem.regions[i];
        if (a >= r->base && a - r->base < r->size)
            return 1;
    }
    return 0;
}

static uint8_t
rv_read8(void *ctx, uint64_t addr)
{
    return gm_read8(&((struct rv_ctx *)ctx)->g->mem, (uint32_t)addr);
}

static void
rv_write8(void *ctx, uint64_t addr, uint8_t v)
{
    gm_write8(&((struct rv_ctx *)ctx)->g->mem, (uint32_t)addr, v);
}

static uint64_t
rv_get_pc_cb(void *ctx)
{
    return rv_get_pc(((struct rv_ctx *)ctx)->cpu);
}

static void
rv_set_pc_cb(void *ctx, uint64_t pc)
{
    rv_set_pc(((struct rv_ctx *)ctx)->cpu, (uint32_t)pc);
}

/* One instruction.  Mirrors the old do_continue body: stop first if the guest
   has already exited or halted, then step; rv_step returns < 0 on a halt. */
static int
rv_step_cb(void *ctx)
{
    struct rv_ctx *c = ctx;
    if (c->g->exited)
        return GDB_RUN_EXITED;
    if (c->cpu->halted)
        return GDB_RUN_STOP;
    if (rv_step(c->cpu) < 0)
        return c->g->exited ? GDB_RUN_EXITED : GDB_RUN_STOP;
    if (c->g->exited)
        return GDB_RUN_EXITED;
    return GDB_RUN_OK;
}

static int
rv_exited(void *ctx)
{
    return ((struct rv_ctx *)ctx)->g->exited;
}

static int
rv_exit_code(void *ctx)
{
    return ((struct rv_ctx *)ctx)->g->exit_code;
}

static int
rv_stop_signal(void *ctx)
{
    return ((struct rv_ctx *)ctx)->g->mem.fault ? 11 : 5;
}

static const struct gdb_target rv_target = {
    target_xml,
    rv_read_regs, rv_write_regs, rv_read_reg, rv_write_reg,
    rv_mem_mapped, rv_read8, rv_write8,
    rv_get_pc_cb, rv_set_pc_cb, rv_step_cb,
    rv_exited, rv_exit_code, rv_stop_signal,
    0, 0,
};

int
rv_gdb_serve(rv_cpu *cpu, guest *g, int port, int *exit_code)
{
    struct rv_ctx ctx;
    ctx.cpu = cpu;
    ctx.g = g;
    return gdb_serve(&rv_target, &ctx, port, exit_code);
}
