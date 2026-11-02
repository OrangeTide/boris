# Kobold-Pascal Untrusted-Script Hardening

This document sketches how Kobold-Pascal would run untrusted scripts, code from
someone other than the game author, such as a downloaded mod. It is a deferred
design: the default posture is trusted-now (see the Safety section of
`kobold.md`), and none of the mechanisms below are built yet.

## Threat model

An untrusted script runs in the host process, so the concerns are that it might:

- read or write host memory outside what the language exposes,
- call host capability it was not given,
- hang the host or exhaust its memory, or
- escape to arbitrary native execution.

The language design already narrows this. There is no pointer type, host state is
reached only through opaque handles, and the host chooses which FFI entries exist,
so a script can only call capability the host registered. What untrusted operation
adds is forcing every memory and arithmetic check on, bounding resources, and fixing
the trust boundary so the runtime never compiles code it did not check.

## Decisions

### Untrusted input is source, never compiled KPM

The host accepts untrusted scripts only as Pascal **source**, which it compiles with
its own trusted `kpcom`. A precompiled KPM module is trusted like a shared library
and is never loaded from an untrusted source.

This matters because the front end emits indirect calls (`CALLI`) and the JIT
compiles whatever IR it is handed. A hand-crafted KPM with an indirect call to an
arbitrary address is arbitrary code execution. Accepting untrusted KPM would need a
full IR verifier (temp, label, and slot bounds; calls restricted to registered
imports and exports; no arbitrary indirect targets; memory operations confined to
known slots and globals). Compiling from source with a trusted compiler removes that
whole surface, because the compiler controls every byte of codegen.

### One tier: hardened native

Untrusted scripts run on the native JIT with all checks forced on and resource
limits enforced, not on a separate interpreter or emulated target.

The accepted trade is that safety then rests on the compiler emitting every check
correctly: a codegen bug in a forced check is an escape, where an interpreter would
contain it. The mitigation is to keep the checked-lowering paths simple and to fuzz
them, and to treat the sandbox codegen as security-sensitive. If a future need calls
for true isolation, an interpreter over the same IR remains the fallback, since the
front end and IR do not change.

## Sandbox compile mode

`kpcom --sandbox` compiles a script for untrusted execution. Regardless of the
directives in the source, it forces:

- **bounds checks** on every array access (`{$R+}`), raising `INDEX_RANGE`,
- **overflow checks** on checked arithmetic (`{$Q+}`), raising `OVERFLOW`,
- **definite initialization**: a variable read before assignment is a compile error,
  or is zero-initialized, so a script cannot read a stale frame slot, and
- **budget and cancellation instrumentation** (below).

The emitted module carries a `.sandbox` marker. The loader refuses to run a
`.sandbox` module unless resource limits are configured, and refuses a non-sandbox
module when the host asked for an untrusted run, so the two cannot be confused.

## Resource limits

All three limits reuse points the runtime already funnels through, and all raise a
trap that unwinds cleanly to the host's landing pad, running the ARC releases on the
way out.

- **CPU (a step budget).** A per-VM counter is decremented at loop back-edges and
  call entry; reaching zero raises `STEP_LIMIT`. This bounds runtime without async
  signals or preemption. The same check point reads a host-set **cancel flag**, so
  the host can stop a running script cleanly, reusing the cancel-by-unwind machinery
  the coroutine runtime already has.
- **Memory.** A per-VM byte and handle budget is checked in the allocation funnels
  (`kp_str_new`, `kp_handle_intern`, `kp_co_new`, and value-stack growth); exceeding
  it raises `MEM_LIMIT`. These are already single points, so the check is local.
- **Stack depth.** The main JIT execution stack gets the `PROT_NONE` guard page the
  coroutine stacks already have, and the existing `SIGSEGV` handler is extended to
  turn a fault in it into `STACK_OVERFLOW`. Today only coroutine stacks are guarded;
  this closes the main stack against unbounded native recursion.

Two trap kinds are reserved for this tier and are not raised outside a sandbox run:
`STEP_LIMIT` and `MEM_LIMIT`. They join the kinds in `kp-abi.md` when the tier is
built.

## Out of scope

- Side channels: timing, cache, and speculative-execution leaks are not addressed.
- The JIT's own correctness: a miscompile is a bug, not a modeled attacker input,
  though the sandbox codegen is treated as security-sensitive.
- Bounded-but-pathological work within the configured limits.

## Rollout

The pieces are independent and can land in order: sandbox mode with forced checks
first (it reuses the shipped `{$R+}`/`{$Q+}` lowering), then the memory budget,
then the step budget and cancel flag, then the main-stack guard. Each is testable on
its own, and none changes the trusted-now default.
