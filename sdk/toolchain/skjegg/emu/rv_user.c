/* rv_user.c : the RV32 binding for the shared process sandbox (sched.c) */

#include "elf32.h"
#include "guest.h"
#include "rv32.h"
#include "sched.h"

/* The GDB remote-protocol stub (--gdb PORT); the in-tree skj-run build defines
 * SKJ_RV_GDB and links emu/rv_gdb.c.  Independent of the backtrace add-on. */
#ifdef SKJ_RV_GDB
#include "rv_gdb.h"
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Linux/RISC-V syscall numbers (the generic table). */
#define RV_NR_OPENAT        56
#define RV_NR_CLOSE         57
#define RV_NR_LSEEK         62
#define RV_NR_READ          63
#define RV_NR_WRITE         64
#define RV_NR_WRITEV        66
#define RV_NR_EXIT          93
#define RV_NR_EXIT_GROUP    94
#define RV_NR_BRK           214
#define RV_NR_STATX         291
#define RV_NR_MKDIRAT       34
#define RV_NR_UNLINKAT      35
#define RV_NR_FCHMODAT      53
#define RV_NR_RENAMEAT2     276
#define RV_NR_GETDENTS64    61
#define RV_NR_CLOCK_GETTIME 113
#define RV_NR_GETRANDOM     278
#define RV_NR_NANOSLEEP     101
#define RV_NR_SCHED_YIELD   124

static int
sys_of_rv(uint32_t nr)
{
    switch (nr) {
    case RV_NR_OPENAT:      return GSYS_OPENAT;
    case RV_NR_CLOSE:       return GSYS_CLOSE;
    case RV_NR_LSEEK:       return GSYS_LLSEEK;      /* rv32 #62 is _llseek */
    case RV_NR_READ:        return GSYS_READ;
    case RV_NR_WRITE:       return GSYS_WRITE;
    case RV_NR_WRITEV:      return GSYS_WRITEV;
    case RV_NR_EXIT:        return GSYS_EXIT;
    case RV_NR_EXIT_GROUP:  return GSYS_EXIT_GROUP;
    case RV_NR_BRK:         return GSYS_BRK;
    case RV_NR_STATX:       return GSYS_STATX;
    case RV_NR_MKDIRAT:     return GSYS_MKDIRAT;
    case RV_NR_UNLINKAT:    return GSYS_UNLINKAT;
    case RV_NR_FCHMODAT:    return GSYS_FCHMODAT;
    case RV_NR_RENAMEAT2:   return GSYS_RENAMEAT2;
    case RV_NR_GETDENTS64:  return GSYS_GETDENTS64;
    case RV_NR_CLOCK_GETTIME: return GSYS_CLOCK_GETTIME;
    case RV_NR_GETRANDOM:   return GSYS_GETRANDOM;
    case RV_NR_NANOSLEEP:   return GSYS_NANOSLEEP;
    case RV_NR_SCHED_YIELD: return GSYS_SCHED_YIELD;
    default:                return GSYS_UNKNOWN;
    }
}

/* The ecall handler the core calls in-step.  a7 is the number, a0-a5 the
 * arguments, a0 the result.  The emulator-private selectors (MAP/MUNMAP/SPAWN/
 * FATAL) go to the shared handler; everything else is a Linux syscall. */
static int
rv_ecall(rv_cpu *cpu, void *ctx)
{
    proc *p = ctx;
    guest *g = &p->g;
    uint32_t nr = cpu->x[17];                    /* a7 */
    uint32_t result;
    int32_t r;

    switch (sched_private(p, nr, cpu->x[10], cpu->x[11], cpu->pc, &result)) {
    case SKJ_PRIV_OK:    cpu->x[10] = result; return RV_ECALL_OK;
    case SKJ_PRIV_FATAL: rv_halt(cpu); return RV_ECALL_OK;
    case SKJ_PRIV_YIELD: cpu->waiting = 1; return RV_ECALL_OK;
    case SKJ_PRIV_RETRY: cpu->waiting = 1; return RV_ECALL_RETRY;  /* re-run the ecall */
    case SKJ_PRIV_NO:    break;
    }

    r = guest_syscall(g, sys_of_rv(nr), cpu->x[10], cpu->x[11], cpu->x[12],
                      cpu->x[13], cpu->x[14], cpu->x[15]);
    if (g->park == GPARK_RETRY) {
        /* The syscall did nothing: park and re-run the ecall next slice,
         * committing no result (a0 keeps the call's own argument). */
        cpu->waiting = 1;
        return RV_ECALL_RETRY;
    }
    cpu->x[10] = (uint32_t)r;
    if (g->park == GPARK_YIELD)         /* completed, but end the slice */
        cpu->waiting = 1;
    if (g->exited)
        rv_halt(cpu);
    return RV_ECALL_OK;
}

/****************************************************************
 * Diagnostics
 ****************************************************************/

static const char *
trace_name(int type)
{
    switch (type) {
    case RV_TR_ILLEGAL:         return "illegal instruction";
    case RV_TR_FETCH_FAULT:     return "instruction fetch fault";
    case RV_TR_LOAD_FAULT:      return "load fault";
    case RV_TR_STORE_FAULT:     return "store fault";
    case RV_TR_LOAD_MISALIGN:   return "misaligned load";
    case RV_TR_STORE_MISALIGN:  return "misaligned store";
    case RV_TR_ECALL:           return "ecall";
    case RV_TR_EBREAK:          return "ebreak";
    case RV_TR_CSR:             return "csr";
    case RV_TR_TRAP:            return "trap";
    case RV_TR_DOUBLE_FAULT:    return "double fault";
    case RV_TR_INTERRUPT:       return "interrupt";
    default:                    return "event";
    }
}

static void
rv_dump_trace(FILE *out, void *vcpu)
{
    const rv_cpu *cpu = vcpu;
    uint32_t n = rv_trace_count(&cpu->trace);
    uint32_t i;

    if (rv_trace_overflowed(&cpu->trace))
        fprintf(out, "  (earlier events dropped)\n");
    for (i = 0; i < n; i++) {
        const rv_trace_event_t *e = rv_trace_peek(&cpu->trace, i);
        fprintf(out, "  pc=0x%08x insn=0x%08x %s%s%s\n", e->pc, e->insn,
                trace_name(e->type), e->note[0] ? ": " : "", e->note);
    }
}

/* The integer register file at a fault, four per line, in ABI-name order. */
static void
rv_dump_regs(FILE *out, int slot, void *vcpu)
{
    const rv_cpu *cpu = vcpu;
    int i;

    fprintf(out, "skj-run: [proc %d] registers:\n", slot + 1);
    for (i = 0; i < 32; i++)
        fprintf(out, "  %4s=0x%08x%s", rv_x_names[i], cpu->x[i],
                (i % 4) == 3 ? "\n" : "");
}

static const char *
cause_name(uint32_t cause)
{
    switch (cause) {
    case RV_CAUSE_INSN_MISALIGNED:      return "misaligned instruction";
    case RV_CAUSE_INSN_ACCESS_FAULT:    return "instruction access fault";
    case RV_CAUSE_ILLEGAL_INSN:         return "illegal instruction";
    case RV_CAUSE_BREAKPOINT:           return "breakpoint";
    case RV_CAUSE_LOAD_MISALIGNED:      return "misaligned load";
    case RV_CAUSE_LOAD_ACCESS_FAULT:    return "load access fault";
    case RV_CAUSE_STORE_MISALIGNED:     return "misaligned store";
    case RV_CAUSE_STORE_ACCESS_FAULT:   return "store access fault";
    default:                            return "trap";
    }
}

static void
rv_report_trap(FILE *out, int slot, void *vcpu)
{
    const rv_cpu *cpu = vcpu;

    fprintf(out, "skj-run: [proc %d] %s at 0x%08x (mtval=0x%08x)\n",
            slot + 1, cause_name(cpu->mcause), cpu->mepc, cpu->mtval);
}

static int
rv_trap_signal(void *vcpu)
{
    const rv_cpu *cpu = vcpu;

    switch (cpu->mcause) {
    case RV_CAUSE_ILLEGAL_INSN:     return 4;   /* SIGILL */
    case RV_CAUSE_BREAKPOINT:       return 5;   /* SIGTRAP */
    default:                        return 11;  /* SIGSEGV */
    }
}

/****************************************************************
 * The vtable
 ****************************************************************/

static void *
rv_alloc(void)
{
    return calloc(1, sizeof(rv_cpu));
}

static void
rv_free(void *cpu)
{
    if (cpu) {
        rv_dec_free(cpu);
        free(cpu);
    }
}

static void
rv_ready(proc *p, uint32_t entry, uint32_t sp)
{
    rv_cpu *cpu = p->cpu;

    rv_init(cpu, skj_bus_r8, skj_bus_r16, skj_bus_r32,
            skj_bus_w8, skj_bus_w16, skj_bus_w32, p);
    rv_reset(cpu, entry);
    rv_set_ecall(cpu, rv_ecall, p);
    cpu->zcmp = 1;
    cpu->atomics = 1;
    cpu->bitmanip = 1;
    cpu->zcb = 1;
    cpu->dp = 1;                /* double precision, host-double (see rv_cpu.dp) */
    rv_dec_enable(cpu);         /* the decoded-instruction cache: a pure speed-up */
    cpu->x[2] = sp;             /* sp */
    p->g.can_park = 1;          /* cooperative blocking-syscall yields (see guest.h) */
}

static enum skj_run_reason
rv_run_adapter(proc *p, int budget, int *ran)
{
    return (enum skj_run_reason)rv_run(p->cpu, budget, ran);
}

static void       rv_halt_adapter(void *cpu) { rv_halt(cpu); }
static void       rv_clear_yield(void *cpu)  { ((rv_cpu *)cpu)->waiting = 0; }
static uint32_t   rv_fault_pc(void *cpu)     { return ((rv_cpu *)cpu)->pc; }
static uint32_t   rv_trap_pc(void *cpu)      { return ((rv_cpu *)cpu)->mepc; }
static uint32_t   rv_bt_fp(void *cpu)        { return ((rv_cpu *)cpu)->x[8]; }

#ifdef SKJ_RV_GDB
static void
rv_gdb(proc *root, int port, int *ec)
{
    rv_gdb_serve(root->cpu, &root->g, port, ec);
}
#endif

static const skj_cpu_ops rv_ops = {
    .name = "RISC-V",
    .machine = EM_RISCV,
    .arch = GUEST_ARCH_RV32,
    .big_endian = 0,
    .alloc = rv_alloc,
    .free = rv_free,
    .ready = rv_ready,
    .run = rv_run_adapter,
    .halt = rv_halt_adapter,
    .clear_yield = rv_clear_yield,
    .fault_pc = rv_fault_pc,
    .trap_pc = rv_trap_pc,
    .bt_fp = rv_bt_fp,
    .bt_bigendian = 0,
    .report_trap = rv_report_trap,
    .trap_signal = rv_trap_signal,
    .dump_regs = rv_dump_regs,
    .dump_trace = rv_dump_trace,
#ifdef SKJ_RV_GDB
    .gdb = rv_gdb,
#else
    .gdb = NULL,
#endif
};

int
run_rv32(const run_opts *o, int *status)
{
    return run_sandbox(o, &rv_ops, status);
}

const skj_cpu_ops *
skj_ops_rv32(void)
{
    return &rv_ops;
}
