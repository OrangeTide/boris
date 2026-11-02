# The in-process JITs

`skj-jit`, `skj-jit-arm64`, and `skj-jit-rv` compile a C source to native
machine code in the running process and call into it, rather than writing
assembly for an external assembler. Each is the same driver over a
different byte sink.

```sh
skj-jit prog.c          # x86-64 host: compile prog.c in memory and run main()
skj-jit-arm64 prog.c    # AArch64 host (run under qemu-aarch64 in this tree)
skj-jit-rv prog.c       # RV32 guest code, run under qemu-riscv32
```

## One selector, two sinks

The design mirrors the ahead-of-time backends. A shared instruction
selector turns the IR into a stream of abstract machine operations, and a
sink turns each operation into either GAS assembly (the AOT path) or raw
bytes (the JIT path). The selector is written once against hardware
register numbers and calls the sink interface without knowing which sink
it drives.

```
                         text sink  ->  GAS assembly   (the AOT compiler)
IR  ->  shared selector  <
                         byte sink  ->  machine code    (the JIT)
```

For RISC-V this is `backend/rv_select.c` over the sink interface
`backend/rv_mc.h`. The text sink is `backend/rv_mc_text.c` (the old
`rv_emit.c` GAS output: `li`/`la`/`mv` pseudos, large-frame fallbacks
through a scratch register). The byte sink is `jit/jit_rv.c`, which
materialises what the assembler would have produced (`lui`/`addi` pairs,
scratch-base offsets, relocations) through the encoder `jit/emit_rv.c`.
Lifting the selector out of `rv_emit.c` retired that file: every RV
ahead-of-time tool now goes through `rv_select.c` and the text sink, and
the JIT drives the identical selector through the identical interface.

The x86-64 and AArch64 backends have the same shape:
`backend/x86_select.c` and `backend/arm64_select.c` drive their own text
and byte sinks (`jit/jit_x86.c`, `jit/jit_arm64.c`).

## The byte encoders and their oracles

Each byte encoder is validated instruction by instruction against a real
assembler, the same golden-master method the standalone assemblers use.

- RISC-V: `tests/rv_oracle.c` (`make check-rv-oracle`) encodes each case
  through `jit/emit_rv.c` and through `riscv64-linux-gnu-as`, then
  `memcmp`s the `.text` bytes. It covers RV32I/M, loads and stores,
  U-type and jumps, the F/D/Zfh float set and the full conversion matrix,
  and the B/J displacement patchers including their range guards. Host
  only, no qemu.
- x86-64: `tests/x86_oracle.c` against `as`.
- AArch64: `tests/arm64_oracle.c` against `aarch64-linux-gnu-as`.

## The shared driver and the guest ABIs

`jit/main.c` is the common driver for all three targets, selected with
`#if defined(__riscv)` / `__aarch64__` blocks. It preprocesses, parses,
and lowers the C source, calls `kp_jit`, binds the host runtime symbols
the guest references, and enters `main` in process. `jit/jit_common.c` is
the architecture-neutral core (data layout, symbol resolution,
relocations, the low-memory mappings); the per-target sink and its two
relocation appliers arrive through a `kp_target` table.

RV32 is the first register-pair JIT target, so its 64-bit helpers need
care. `jit/rv_jit_i64.S` supplies `skj_jit_muldi3` and the shift family
(`ashldi3`/`ashrdi3`/`lshrdi3`) in the internal stack-passed ABI the
backend uses (operands on the stack, result in the `a0:a1` pair), copied
from `runtime/start_rv.S`. They carry the `skj_jit_` prefix so they do
not clash with the driver's own libgcc `__muldi3`, and the driver binds
the guest's `__muldi3` and shift names to them. The divide family
(`__divdi3` and the rest) stays a normal register-ABI call served by the
shared host bindings. `jit/call_guest_rv.S` switches to the low execution
stack and marshals up to six integer arguments into `a0`-`a5`.

## Divide by zero

RISC-V defines divide by zero (it returns all-ones or the dividend and
does not trap), so `skj-cc-rv` emits no guard and `skj-jit-rv` matches it:
`rv_mc_div`/`divu`/`rem`/`remu` emit the bare hardware instruction. There
is therefore no RV divide-by-zero trap test, unlike `test-jit-trap` and
`test-jit-trap-arm64`, whose selectors emit a guard that raises exit 70.

## Tests

| Target | Command | Runs where |
|---|---|---|
| encoder oracle | `make check-rv-oracle` | host only |
| C exit-code suite | `make check-jit-rv` | qemu-riscv32 |
| x86-64 C suite | `make check-jit` | host |
| arm64 C suite | `make check-jit-arm64` | qemu-aarch64 |
| arm64 disasm sweep | `make check-jit-arm64-disasm` | qemu-aarch64 |
| RV disasm sweep | `make check-jit-rv-disasm` | qemu-riscv32 |

`make check-jit-rv` runs the C exit-code suite in process through the JIT
and compares each program's exit code to its `.exitcode` fixture. The
generated RV32 machine code executes under `qemu-riscv32`; the driver is
cross-built (the default is `zig cc -target riscv32-linux-musl`, since the
rv64 cross toolchain has no ilp32 multilib). It excludes the same varargs
and by-value struct tests the RV psABI backend excludes, plus inline
assembly. `_Float16` is included, since RV covers it natively through Zfh.

`make check-jit-rv-disasm` is the disassembly-legality sweep, the
counterpart of `check-jit-arm64-disasm` over the shared
`tests/run-jit-disasm.sh`: it dumps each test's compiled code region with
`skj-jit-rv -d` and confirms `riscv objdump` decodes every instruction to
a legal one, catching a composed-encoding bug (a wrong `li`/`la` sequence,
a `memop` base fallback, or a branch patch) that runtime execution would
not reach. The RV sink emits only 32-bit encodings, so the linear decode
stays aligned. (There is still no x86 disasm sweep.)

### Gaps specific to the RV32 JIT

- No branch-relaxation path. The byte sink rejects an out-of-range B
  (+/-4 KB) or J (+/-1 MB) target through the error channel rather than
  relaxing it the way the assembler does. No test forces that range,
  since JIT code regions stay in range.
- Inline assembly, varargs, and by-value struct passing are unsupported
  and excluded, matching the RV psABI backend's own gaps.
- A float-returning `main` is not exercised: `call_guest_rv.S` clears the
  float-return slot.
