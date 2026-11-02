/* run_reason.h : the shared batched-run contract for the CPU cores
 *
 * Every skjegg CPU core exposes a batched run:
 *
 *     enum skj_run_reason <arch>_run(<arch>_cpu *cpu, int count, int *retired);
 *
 * It executes up to `count` instructions, stops the moment the machine halts,
 * takes a trap, or voluntarily yields, and returns why; `*retired`, when
 * non-NULL, receives the number of instructions actually executed.  A host
 * (the user-mode harness, a scheduler, or a hypervisor) drives any core the
 * same way and observes a stuck, faulting, or yielding guest instead of
 * spinning out the whole batch.  A JIT or hardware-virtualization backend
 * returns through the same contract; this is the interface guests are driven
 * on going forward.
 *
 * The RISC-V core predates this header and spells the same four meanings, with
 * the same values, as enum rv_run_reason / RV_RUN_* (rv32.h); the two are
 * interchangeable and rv can adopt these names without any behaviour change.
 */

#ifndef SKJ_RUN_REASON_H
#define SKJ_RUN_REASON_H

enum skj_run_reason {
    SKJ_RUN_BUDGET = 0, /* ran the full count; still runnable */
    SKJ_RUN_HALT,       /* halted: a clean exit or a double fault */
    SKJ_RUN_TRAP,       /* a trap or fault was taken; the core's trap state,
                         * or the host's reserved trap window, names it */
    SKJ_RUN_YIELD,      /* voluntarily parked; still runnable (the cooperative
                         * yield boundary a scheduler builds tasks on) */
};

#endif /* SKJ_RUN_REASON_H */
