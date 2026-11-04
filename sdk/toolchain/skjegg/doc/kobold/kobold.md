# Kobold-Pascal front end (`kobold/`)

Kobold-Pascal reaches the shared IR through a different seam from the other
front ends. Its compiler, `kpcom`, is a self-hosting Pascal program whose source
is in this tree (`kobold/kpcom.pas`); skjegg is its home, not a consumer of some
other Kobold tree. Because `kpcom` is written in Pascal and compiles itself, the
tree has no `lex.c`/`parse.c`/`lower.c` for it in `backend/`'s sense. The bridge
into the rest of the toolkit is the **KPM1 text module** that `kpcom` emits:
`kobold/kpm.c` reads a KPM1 image into an `ir_program`, and from there the same
selector and sinks the C compiler uses emit the code. Every other front end is a
source-to-IR pipeline; Kobold is a self-hosting Pascal compiler whose output is
read back through an IR-in-a-text-format reader in front of the same backend.

`kobold/kpm.c` is the practical source of truth for the KPM1 format, and this
file is the in-tree reference for how the front end is built, bootstrapped, and
run.

## Source file extensions: `.kp` versus `.pas`

Kobold source files use the `.kp` extension. Pascal source files (the Compact
Pascal front end, `pascal/`) use `.pas`. The two languages are distinct, so a
project that uses both should keep the extensions apart.

`kobold/kpcom.pas` is the one deliberate exception. The Kobold compiler is
self-hosting and is written in the subset common to both languages, so its
single source file is valid Pascal and valid Kobold at the same time. It keeps
the `.pas` extension because the bootstrap compiles it with the Compact Pascal
front end (`skj-pc`) before a Kobold compiler exists. No other file in a project
should rely on this dual-language property; treat it as unique to `kpcom`.

One in-tree inconsistency to be aware of: the historical Kobold test corpus
under `tests/kp-corpus/` and `tests/kp-src/` still carries `.pas`, predating the
`.kp` convention. The tools select the language from how they are invoked, not
from the suffix, so those tests compile as Kobold regardless. New Kobold code,
in this tree or in a consuming project, should use `.kp`.

## The bootstrap: no committed seed

`kpcom` is written in its own language, so the tree cannot compile
`kobold/kpcom.pas` with a C front end. The bootstrap root is `skj-pc`, the
Compact Pascal compiler: `kpcom.pas` is valid Pascal as well as Kobold (the one
file that is both, see "Source file extensions" above), so `skj-pc` compiles it
directly into a host front end with no prior Kobold compiler and no committed
seed. There is no `prebuild/` artifact.

One front end per target, the C-compiler model: `skj-pc` compiles `kpcom.pas`
with that target baked in (a `KP_TARGET_*` define) into a host binary that emits
modules for exactly that target. The host front ends are `skj-kpc` (x86-64),
`skj-kpc-rv` (rv32), and `skj-kpc-cf` (ColdFire). Each then emits its own source
as that target's KPM1 **seed** at build time:

- `build/kpcom-rv.kpm` (from `skj-kpc-rv`): feeds the RV32 JIT (`bin2c` embeds
  it) and the RV32 self-host ELF.
- `build/kpcom-cf.kpm` (from `skj-kpc-cf`): feeds the ColdFire self-host ELF.
- `build/kpcom-lp64.kpm` (from `skj-kpc`): feeds the x86-64 JIT.

A seed is bound to its target (its `.target` header names the architecture:
`rv32`, `cf`, `x86-64`), so the KPM1 reader rejects a seed built for another
target rather than reading it at the wrong model. Pointer width is a consequence
of the target, not a separate axis.

The front-end source lives in `kobold/`, beside the runtime and reader:

- `kobold/kpcom.pas`: the whole front end (lexer, parser, semantics, IR, KPM1
  writer), one Pascal file.
- `kobold/version.inc`, `kobold/stdlib.inc`: the two `{$I ...}` includes
  `kpcom.pas` pulls in (`KP_VERSION`, `KP_STDLIB`). Their bytes are compiled into
  the IR as string constants (the stdlib path in particular), so a seed
  reproduces byte-identically only when regenerated against these same includes.

### The self-host and compiler-independence checks

- The in-guest self-host (`test-{rv,cf}-selfhost-kpc` and the `-full` variants)
  runs the Kobold compiler on the target under `skj-run`: it compiles a program
  (and, for `-full`, the whole of `kpcom.pas`) in-guest and asserts the emitted
  KPM1 matches the host front end's reference byte for byte.
- `make bootstrap-fpc` is the compiler-independence proof. It builds `kpcom.pas`
  with `fpc` (a toolchain independent of skjegg) targeting rv32, and asserts the
  module it emits matches `build/kpcom-rv.kpm` byte for byte: the module a front
  end emits is fixed by its own logic, not by which compiler built it.

### Vendoring

`vendor.sh kobold` ships the Kobold AOT path as one selection: the front-end
source, the KPM1 reader and runtime (`kobold/`), the x86-64 selector the host
tools build on, and the `jit/` call trampoline `libkpaot.a` links. There is no
committed seed; vendor.sh generates the x86-64 seed from source at vendor time
and ships it as `prebuild/kpcom.kpm`, so the consumer AOT-compiles it with
`skj-kp` into `skj-kpc` without needing `skj-pc` or `fpc`. It generates the
`skjegg.mk` rules for `skj-kp` (the KPM1 compiler), `skj-kpc` (the native front
end), and `libkpaot.a`. Adding `riscv` also generates `skj-kp-rv` (the KPM1 to
RV32 compiler). The hosted RV32 runtime (`libkpaot-rv.a`) and the freestanding
runtime tier arrive with later steps. The selection carries its own x86-64
backend, so it needs no separate backend selection; it needs the host `as` to
assemble the seed, as the rest of the x86 path already does.

## Tools

All built by `make all`. The reader regression and the source fixtures are in
`check-all` (see Testing).

- **`skj-kp-jit`** (`kobold/jit_main.c`): the in-process JIT. Reads a KPM1 module or
  a `.pas` source (which it compiles with the embedded front end, see Source
  compilation), JITs it over the byte sink, and runs it in the current process.
  Maps a low-memory guest heap (the ILP32 address model), searches the program
  directory, `KOBOLD_UNITS`, and a stdlib path for `uses` dependencies, and
  passes guest `argv` through. `--emit-kpm` stops after the module, writing it to
  stdout or, with `-o outfile`, to a file (options precede the source).
  `skj-kp-jit-rv` and `skj-kp-jit-arm64` are the cross-arch counterparts over the
  same driver and runtime.
- **`skj-kpc`** (the seed AOT-compiled to native code, linked against
  `libkpaot.a`): the native front end, `kpcom` running with no JIT. Reads a
  `.pas` source and writes its KPM1 module (`--emit-kpm`, to stdout or `-o
  outfile`; options precede the source). It runs on the host, so it is the front
  end for a cross AOT build too: the host `skj-kpc` emits the module and a cross
  `skj-kp-*` compiles it. `skj-kpc-rv` and `skj-kpc-arm64` are the proof the front
  end itself AOT-compiles and runs on each backend (under qemu); all three emit
  byte-identical KPM1.
- **`skj-kp`** (`kobold/aot_main.c`): the ahead-of-time compiler. Emits native
  assembly over the text sink for a C start file to assemble and link.
  `skj-kp-rv` and `skj-kp-arm64` emit GNU-as assembly for those targets.
- **`skj-kp-patrol`** (`kobold/patrol_main.c`): a sample embedding host that
  registers an opaque handle type of its own beside the standard runtime, the
  counterpart of the C JIT's embedding sample.

The JIT and AOT paths are kept at byte-identical-stdout parity with each other
and with the checked-in `.expected` files across the behavioral corpus, on
x86-64, arm64, and rv32, for single-module and multi-unit programs, overflow
traps included.

## Source compilation

The front end (`kpcom`) is a Kobold program, built from source per target by
`skj-pc` (see "The bootstrap: no committed seed"). A tool runs it to turn `.pas`
source into a KPM1 module, and there are two ways to run it.

The **JIT path** carries a seed inside the binary. `build/kpcom_kpm.c` is the
RV32 seed (`build/kpcom-rv.kpm`) as a C byte array, generated by `kobold/bin2c.c`
and linked into the RV32 JIT; the x86-64 and arm64 JITs embed their own seeds the
same way. When a JIT tool is handed a `.pas` input,
`kobold/frontend.c:kp_compile_pas` JITs the embedded seed in-process, binds the
runtime, calls its `compile` export with the source name and text, and reads back
the produced module. So `skj-kp-jit foo.pas` compiles and runs source in one
process, and `skj-kp-jit --emit-kpm foo.pas` stops after writing the module. The
`KPCOM_KPM` environment variable overrides the embedded seed with a module on
disk for dev iteration.

The **AOT path** runs a native front-end binary built directly from source.
`skj-kpc` (x86-64), `skj-kpc-rv`, and `skj-kpc-cf` are `skj-pc` compiling
`kpcom.pas` with that target baked in, linked against the host harness, so each
runs the front end with no JIT: `skj-kpc --emit-kpm foo.pas` reads source and
writes a module stamped for that target. The front end runs on the host, so a
cross AOT build is two steps: the host front end for the target emits the module,
then that target's backend (`skj-kp-rv` / `skj-kp-cf` / `skj-kp-arm64`) compiles
it. (Vendored trees instead build `skj-kpc` by AOT-compiling a vendor-time seed
with `skj-kp`, since they ship no `skj-pc`.)

A module is bound to one target, not merely one width: its `.target` line records
the architecture (`rv32`, `cf`, `x86-64`, `arm64`), and a backend rejects a
module built for another architecture. Pointer width is a consequence of the
target (4 bytes for rv32/cf, 8 for x86-64/arm64), not a separate category: there
is no shared "ilp32" or "lp64" module. The integer core and control flow are the
same across targets; only the pointer and `int64` opcodes follow the width.

## The KPM1 text module format

A module is a sequence of lines. Blank lines and `;` comment lines are ignored;
leading and trailing whitespace is trimmed. The first non-empty line must be
the header `.kpm 1`.

### Top-level directives

- `.kpm 1`: header and version (required, first).
- `.target <name>`: a target hint (optional).
- `.module <kind> [name]`: `kind` is `object` (the default: a compiled unit
  for linking), `library`, or `executable`. An `object` carries its own unit
  name so a consumer's `.uses` can be matched against it.
- `.entry <routine>`: the entry routine of an executable.
- `.uses <name> [fingerprint <n>]`: a direct unit dependency and the interface
  fingerprint it was compiled against. The linker checks the fingerprint
  against the loaded dependency's own, rejecting interface skew.
- `.interface fingerprint <n> ... .endinterface`: a self-delimiting interface
  block a consumer type-checks against. The reader records only the fingerprint
  and skips the body.
- `.file "<path>"`: the debug source hint (`-g`).
- `.import <kind> <name> ...`: a symbol the host must provide. `kind` is
  `func` (a host function), `helper` (a compiler runtime helper), or `type` (a
  host handle type; carries `methods <n>` and a signature per vtable slot, as
  ABI class tokens).
- `.export <name>`: a symbol this module exports.
- `.global ...` and `.func ...`: see below.

### Globals

```
.global <name> <base> [array <n>] [align <a>] [local] [ptr] [export] [rodata] [from <unit>]
    .init <value>            ; a scalar initializer word
    .init sym <symbol>       ; an address-of-symbol relocation
    .string "<text>"         ; a string/byte initializer
.endglobal
```

`<base>` is `i8`, `i16`, `i32`, `i64`, `f32`, or `f64`. `array <n>` makes it an
array; `align <a>` sets the alignment; `ptr`, `export`, `rodata`, `local`, and
`from <unit>` set the corresponding flags.

### Functions and instructions

```
.func <name> [local] [from <unit>] [variadic] params <n> slots <n> temps <n> labels <n>
    .slotsize <s0> <s1> ...  ; per-slot byte sizes
    .paramclass <c0> ...     ; per-param class: 0 = int/pointer, 1 = float
    .paramfw <f0> ...        ; per-param: 1 = single-precision float scalar
    <OP> [key=value] ...     ; one IR instruction per line
    ...
.endfunc
```

`<OP>` is an `ir_op` mnemonic without the `IR_` prefix (e.g. `ADD`, `LW`,
`FCALL`; the full table is `op_table` in `kobold/kpm.c`). The operand keys are:

| key     | meaning                                             |
|---------|-----------------------------------------------------|
| `dst`   | destination temp index (`0 <= dst < temps`, or `-1` for none) |
| `a`,`b` | operand temp indices (`0 <= a,b < temps`, or `-1` for none)   |
| `imm`   | 64-bit immediate (a `LIC64` value, an f64's bits)   |
| `slot`  | local-slot index (`0 <= slot < slots`)              |
| `label` | label index (`0 <= label < labels`)                 |
| `nargs` | argument count for a call                           |
| `sym`   | a symbol name (call target, address-of)             |

The psABI hint lines `.paramneb`, `.paramcls`, `.retneb`, and `.retcls` are
accepted and ignored for the v1 subset; the reader derives the psABI fields a
backend needs from `.paramclass` (one register slot per parameter, SSE for a
float).

### Input validation

The format is read from untrusted text, so the reader bounds everything it will
later use as an allocation size or an array index. Declared counts (a
function's `params`/`slots`/`temps`/`labels`, a global's `array` size, an
imported type's `methods`) are rejected if negative or above `KPM_MAX_COUNT`
(`1 << 20`). Every temp, slot, and label index an instruction names is checked
against the enclosing function's declared counts, so a module cannot drive an
out-of-bounds access into `temp_reg[]`, the slot table, or the label table
downstream. A field a line does not provide is left at its default and not
checked, so a legitimate instruction that uses no temp (a `JMP` in a function
with `temps 0`) still reads. This path is exercised by `make check-kp`.

## The guest runtime (`kobold/`)

The runtime is the Kobold guest runtime, compiled freestanding with f64
reals. It is shared between the JIT (bound as host symbols) and the AOT path
(resolved by the linker).

- `str_core.c`, `str_fmt.c`: the guest-owned string object and number
  formatting/parsing (`Str`, `Val`).
- `dynarr.c`: the guest-owned dynamic array (`array of T`).
- `map.c`: the guest-owned associative array, string-keyed (`map of T`, `kp_map_*`)
  and ordinal-keyed (`map[K] of T`, `kp_imap_*`).
- `co.c`, `co_shim.c`: stackful coroutines (the coroutine runtime) and the
  host primitives they need. The per-arch context switch is
  `runtime/co_switch_{x86,arm64,rv}.S`, shared with the libc coroutine
  primitive (`doc/tools/libc.md`).
- `handle.h`: refcounted (ARC) opaque handles.
- `rt_host.c`: the platform layer: the guest heap over a low-memory mmap (so a
  guest address fits the 32 bits the front end models), plus a live-bytes
  counter.
- `kp_host.c`, `kp_host.h`: the standard host binding surface. An embedder
  calls `kp_install_runtime` to fill a `kp_binding` table (console I/O,
  strings, arrays, maps, coroutines, ARC, traps, and the 64-bit divide
  helpers), then binds its own host types, then calls `kp_jit`.
  `kp_io_set_args` records the command line for `ParamStr`/`ParamCount`, and
  `kp_handle_sweep` runs live handles' finalizers at teardown.
- `aot_rt.c`: the C start file and link-time runtime surface for `skj-kp`
  output: process entry, a low execution stack, the traps, and the
  `ParamStr`/`ParamCount` surface.

## The binding model

A guest reaches the runtime by name. The two paths resolve those names
differently.

- **JIT**: `kp_install_runtime` binds each guest-facing name to a host symbol
  in a `kp_binding` table, and `kp_jit` resolves the IR's call and data
  relocations against it.
- **AOT**: the names are resolved by the system linker. `aot_main.c`'s
  `remap_sym` mirrors `kp_install_runtime` for the names that appear as call
  symbols in the IR (the coroutine operators, `ParamCount`/`ParamStr`/
  `heapLive`, the transcendentals, and on rv32 the real-valued I/O and `Val`,
  which cross a call as integer-register bits under the soft-float ABI and so
  go through a bits bridge). `-DKP_AOT_RV` selects the rv branch.
  `rv_i64_aot_alias.S` defines the libgcc-named 64-bit multiply/shift helpers
  as tail-jumps into the runtime's `skj_jit_*` routines, since the rv backend
  writes those names directly rather than as call symbols `remap_sym` can see.

## The freestanding tier

A downstream VM host runs a Kobold guest with no host OS: its
seam to the guest is only `write`, `read`, and `exit`, and it hands the guest its
heap at entry rather than letting the runtime map memory. `libkpaot-rv-free.a` is
the re-bottoming of the hosted `libkpaot-rv.a` for that seam. The compute
runtime (`str_core.c`, `dynarr.c`, `map.c`) is the same source, built with
`KP_FREESTANDING`; only the platform underneath changes.

For the end-to-end commands that compile a `.pas` into a freestanding RV32 ELF
and run it in the `skj-run` emulator, see `kp-sandbox.md`.

- `kobold/rt_free.c` is the platform, the freestanding `rt_host.c`. The guest heap is
  the same binned allocator over a flat region, but the region is handed in by
  `kp_rt_init(base, size)` rather than mapped; a block address is a real pointer,
  so the host places the region below 4 GB. It also holds the reference counter,
  the finalizer registry, the `mem*` primitives, and the traps, which write a
  one-line diagnostic and `exit(70)`.
- `kobold/kp_io.c` is the one console implementation, shared by the freestanding
  and the hosted runtimes. Output goes straight to the `write` syscall (no stdio),
  input through `read` with a single byte of pushback for the numeric and line
  reads; the integer formatting and parsing are hand-rolled with no libc (the
  hosted `str_fmt.c` uses `snprintf`/`strtod`, which this tier cannot). Only
  `io_write_real` is per tier, since its `%g` renderer differs.
- `kobold/io_free.c` is the rest of the freestanding `kp_host.c`: the per-tier
  real output (`io_write_real`), the integer `Str`/`Val`, file I/O, the `brv_*`
  soft-float real bridges, and `ParamCount`/`ParamStr` over the entry argument
  vector.
- `kobold/kp_crt_rv.S` is the skjegg test crt: `_start` runs on the entry stack, hands
  the runtime a reserved bss heap region and the argument vector, enters
  `kp_guest_entry`, and exits 0 on return (a program ends nonzero only through
  `Halt`). A real host supplies its own crt and memory region and calls
  `kp_rt_init` with them; nothing in `rt_free.c` or `io_free.c` depends on a
  syscall but the `_exit` the trap makes.

The syscall seam `io_free.c` builds on is the POSIX-standard set `write`, `read`,
and `_exit` (plus `open` and `close` on ColdFire), the same names the C libc
links, so the Kobold freestanding runtime and the C runtime speak one syscall
seam (`runtime/io_free_rv.S`, `runtime/io_free_cf.S`).

The console in `kp_io.c` writes and reads that seam directly rather than through a
buffered-stream core: the only state it keeps is one byte of input pushback (the
irreducible lookahead the numeric and line reads need), not a `BUFSIZ` stdio
buffer. Output is therefore unbuffered, so nothing has to be flushed before the
process ends; `io_halt` simply `_exit`s, and the normal-return path still goes
through it (ABI version 3). (The C libc's own `libc/stdio_core.c` is unaffected: it
is still the buffered-stream core for C programs; the Kobold console no longer
routes through it.)

The entry seam (`kp_set_raw_args`, `kp_rt_init`, `kp_guest_entry`, `_exit`)
is a published ABI a downstream host links against, so it is versioned
(`kobold/kp_abi.h`, `KP_GUEST_ABI_VERSION`). `rt_free.c` defines the symbol
`kp_guest_abi_v<N>` and the plain value `kp_guest_abi_version`, and the crt
references `kp_guest_abi_v<N>`; an archive of one version linked against a crt of
another leaves that symbol undefined, so the mismatch is a link error rather than
a silent seam skew. A host that writes its own crt carries the same reference, and
a bump of the entry seam bumps the version here, in `rt_free.c`, and in the crt
together.

The 64-bit integer helpers are the hosted archive's: the backend's stack-ABI
`__muldi3` and shift family resolve through `rv_i64_aot_alias.S` into
`jit/rv_jit_i64.S`, and the register-ABI `__divdi3` family comes from
`runtime/soft64.c` built `-DSOFT64_NO_MULSHIFT` (so its own stack-ABI-incompatible
multiply and shifts are dropped and do not clash with the alias).

`kobold/co_free.c` is the coroutine runtime, the freestanding counterpart of the
hosted `co.c` + `co_shim.c`. A coroutine is an ordinary gheap object (kind
`KP_OBJ_CORO`), counted by `rt_free.c` like any other value; its private stack is
a gheap block rather than a guarded mapping (no mmap, so no guard page, the
accepted trade). The context switch is `co_switch_rv.S`, whose 160-byte saved
block the file seeds; the entry and value ABI match what `skj-kp-rv` emits
(`kp_co_new(entry, argsp, nargs)`, 8-byte argument cells, a 32-bit resume/yield
value). Reals are covered too: `io_free.c` has a `%g`-matching double formatter
(six significant digits, trailing zeros stripped, validated against the C library)
behind `io_write_real`, a `double` parse behind `kp_str_val_real`, and the rv
soft-float bit bridge (`brv_write_real`/`brv_read_real`/`brv_val_real`). The
transcendentals (`sin`, `cos`, `exp`, `ln`, `arctan`) are in `kobold/math_free.c`,
computed in hardware double with range reduction and series since the tier has no
libm; they are accurate to well under the `%g` six-digit output, so they
reproduce the hosted (libm) results exactly, checked against the C library over a
wide range. The tier is at full parity with the hosted one.

`make check-kp-free` is the end-to-end proof: each `tests/kp-src` fixture goes
`skj-kpc --emit-kpm` -> `skj-kp-rv` -> `skj-as-rv` -> `skj-ld-rv` into a static
rv32 ELF linked against the crt and `libkpaot-rv-free.a`, run under qemu-riscv32,
stdout compared to `.expected`. It is in `check-emu-all`. The portable
`tests/kp-src` set it runs covers integers, strings, int64, parameters, reals
(`realfmt`), and coroutines (`coro`).

## Multi-unit linking

A program that `uses` units links across modules.

- **JIT** (`jit/jit_common.c`): each unit is compiled per-module and its
  exports are published as bindings. A cross-module call lands on a per-export
  stub that tail-jumps through a writable slot (`kp_stubs_*`), so linking is
  order-independent: a slot can be filled after the caller is compiled. The
  stub touches only a scratch register, so the guest's argument registers and
  return address pass through untouched.
- **AOT**: `aot_main.c` gives every name in the module's `.export` list
  external linkage before emitting, so the system linker resolves it; a private
  symbol a unit does not export stays local, so two units' same-named private
  globals do not collide. `kobold/aot-run.sh` follows the main module's `.uses`
  transitively, compiles each dependency unit (resolving `<dir>/<name>.kpm`
  then `KOBOLD_UNITS`), and links the whole set, the system
  linker standing in for the JIT's in-memory link.

## Overflow-trap policy

Kobold's semantics trap on integer overflow, and its JIT does. The shared AOT
text sinks default to the hardware-trap policy they share with the C compiler
(a checked arithmetic op, which C never emits, would otherwise wrap). So
`aot_main.c` raises `target_aot_trap_guarded` (a mode flag in `ir.c`, default
off) before `target_emit`, which makes the x86-64 and arm64 text sinks choose
the selector's guarded trap policy; rv always guards and ignores the flag. The
C compiler is unaffected: the flag defaults to hardware and only `aot_main.c`
raises it, and the checked ops never appear in C.

## Testing

- **In-tree, reader**: `make check-kp` runs `tests/kp/` through `skj-kp`,
  exercising the KPM1 reader's input validation (malformed modules rejected with
  a pinned, line-numbered message; a well-formed module compiles). It needs no
  external repo, qemu, assembler, or linker. The shared JIT the Kobold tools
  drive is also covered by `make check-jit` / `check-jit-arm64` / `check-jit-rv`
  through the C suite.
- **In-tree, reader fuzz**: `make test-kpm-fuzz` drives the whole untrusted
  reader path (`kpm_read` -> `regalloc` -> `target_emit`) under ASan plus UBSan,
  mutating copies of the reader fixtures and real front-end-emitted corpus
  modules with a deterministic PRNG. A clean exit means no input, valid or
  hostile, drove undefined behavior through the pipeline. The harness
  (`kobold/kpm_fuzz.c`) also reads one module from stdin without `--mutate`, the
  entry an external fuzzer (AFL++) or byte loop drives for a longer campaign. It
  is wired into `check-san`.
- **In-tree, source**: `tests/kp-src/<name>.pas` paired with `<name>.expected`
  (stdout) are compiled and run end to end by `tests/run-kp-src-tests.sh` in
  three modes. `make check-kp-frontend` is a host smoke of the embedded front end
  (`--emit-kpm` yields a `.kpm 1` module). `make check-kp-jit` compiles and runs
  each fixture in one process; `make check-kp-aot` emits a module with the native
  `skj-kpc`, AOT-compiles and links it, and runs it. The three x86 targets are in
  `check-all`; the cross runs `check-kp-jit-rv`, `check-kp-jit-arm64`,
  `check-kp-aot-rv`, and `check-kp-aot-arm64` run under qemu in `check-emu-all`.
  `tests/kp-src` is the portable set: every mode, including the freestanding one,
  runs it, so it stays to integer, string, int64, and parameters.
- **In-tree, behavioral corpus**: `tests/kp-corpus` is the broader behavioral set,
  102 real Kobold programs. Each `<name>.expected` holds the program's expected
  stdout, checked in beside the source as the committed oracle. It covers
  arithmetic, records, arrays, string-keyed and ordinal-keyed maps, dynamic
  arrays, strings, enums, sets, coroutines, reals and transcendentals, int64,
  casts, var parameters, properties, and control flow. One `.expected` pins the
  result across the x86-64 JIT and the x86-64, rv32, and arm64 AOT paths at once,
  so it also checks that every backend agrees.
  `make check-kp-corpus` runs the x86 JIT and AOT (in `check-all`);
  `check-kp-corpus-rv` and `check-kp-corpus-arm64` run the AOT path under qemu (in
  `check-emu-all`); `check-kp-corpus-cf` runs the ColdFire AOT path under qemu-m68k
  (in `check-all`), the big-endian cross-check, linking the hosted ColdFire runtime
  `libkpaot-cf.a` statically. The failable two-return
  (`CALL2`) cases `failforms`/`failmethod`/`failmanaged` are among them (see the reader
  note below); `failmanaged` covers `or else` recovering a managed result, and
  `failmethodwide` covers a failable method returning a wide value (real, int64,
  record) through the hidden caller buffer, the same sret path a failable free
  function uses reached through a by-reference receiver. `setelem` covers a set as
  a dynamic-array element and a map value, both a small set (the i64 scalar slot)
  and a large set (the inline blit slot). The `conf_*` programs are a
  conformance set pinning documented corner cases across all four backends:
  `conf_divmod` (div/mod truncate toward zero, mod takes the dividend's sign),
  `conf_wrap` (two's-complement overflow wrap with no `Q+` switch), `conf_strcmp`
  (unsigned bytewise string order, shorter prefix first), `conf_setrel` (set
  subset/superset relations and union/difference/intersection), `conf_defaults`
  (a global reads as the zero of its type), and `conf_evalorder` (operands left
  to right, call arguments right to left). The `conf_trap_*` programs pin the
  fault exit code (70, empty stdout, through a per-fixture `.exitcode` file):
  `conf_trap_divzero` (integer divide by zero, always checked), `conf_trap_mapkey`
  (a missing map key), `conf_trap_range` (an out-of-bounds index under `{$R+}`),
  `conf_trap_overflow` (a signed add past `maxint` under `{$Q+}`), and
  `conf_trap_divovf`/`conf_trap_modovf` (the most negative integer `div`/`mod`
  `-1`, whose unrepresentable quotient always traps `OVERFLOW`). The
  divide-by-zero and signed-overflow division cases are clean traps on every
  backend: the hardware behavior is unusable (RV32 divide returns the wrapped
  value with no fault, the m68k exception surfaces as a raw signal or SIGFPEs
  under qemu), so the backend synthesises a divisor guard and an INT_MIN/-1
  guard under the guarded trap policy on each.
- **In-tree, multi-unit corpus**: `tests/kp-multi` is the cross-module set, the
  one behavioral surface the single-module corpus cannot reach. A fixture is told
  apart by its first keyword: `program NAME;` is a test (paired with
  `NAME.expected`), `unit NAME;` is a dependency with no
  `.expected`. `tests/run-kp-multi-tests.sh` compiles every unit to its own module
  first, then runs the programs against the set: the JIT links the unit modules in
  memory, the AOT path links their objects (`aot-run.sh`), so one `.expected` also
  checks the two links agree. The five programs exercise cross-unit calls, a unit
  const, a unit's mutable global and `shared var`, an exported enum and record
  type, qualified `as`, and a transitive `uses` chain. `make check-kp-multi` runs
  the x86 JIT and AOT (in `check-all`); `check-kp-multi-rv` and
  `check-kp-multi-arm64` run the AOT path under qemu (in `check-emu-all`).
- **In-tree, input-dependent corpus**: `tests/kp-io` is the set that reads input,
  the one surface the other corpora omit (they run with no stdin and no
  arguments). A fixture may carry a `<name>.input` file (fed as the program's
  stdin) and a `<name>.args` file (one line, whitespace-separated, passed as its
  command line, so `ParamStr`/`ParamCount` see it); the `.expected` is the
  expected output under the same stdin and arguments. `make check-kp-io`
  runs the x86 JIT and AOT (in `check-all`); `check-kp-io-rv`, `check-kp-io-arm64`,
  and `check-kp-io-free` run the AOT and freestanding paths under qemu (in
  `check-emu-all`), so the entry argument vector and the `read` seam are exercised
  on the no-libc tier too.
- **In-tree, include-file corpus**: `tests/kp-inc` covers the `{$I ...}` include
  directive. The directive splices the named file's text at the point it appears,
  resolved at compile time against the source directory, so a `<name>.inc` beside
  the program is found with no harness plumbing. One fixture splices expressions
  (a string and a number constant), one a whole procedure declaration; the
  `.expected` is the expected output. `make check-kp-inc` runs the x86
  JIT and AOT (in `check-all`); `check-kp-inc-rv`, `check-kp-inc-arm64`, and
  `check-kp-inc-free` run the AOT and freestanding paths under qemu (in
  `check-emu-all`). The include is resolved by the host front end in every case,
  so the freestanding module carries the spliced text before codegen.
- **In-tree, bootstrap**: `make bootstrap-fpc` rebuilds the front end from source
  with `fpc` and asserts it emits the same RV32 seed as the `skj-pc`-built front
  end, the compiler-independence proof (see "The self-host and
  compiler-independence checks"). The in-guest `test-{rv,cf}-selfhost-kpc` targets
  assert the compiler reproduces its reference on the target.
## Language documentation

This file is the in-tree reference for how the Kobold front end is built,
bootstrapped, and run inside skjegg. The language itself and its host contract
are specified by the companion documents in this directory:

- `kp-language.md`: the language reference: types, statements, routines, and
  built-ins.
- `kp-grammar.md`: the surface grammar (EBNF).
- `kp-semantics.md`: the static semantics: type identity, compatibility and
  conversion rules, expression typing, overload resolution, and storage layout.
- `kp-builtins.md`: the signature reference for the predefined routines:
  argument rules, result types, and trap behavior.
- `kp-evaluation.md`: the dynamic semantics: evaluation order, integer
  division and overflow, string and set comparison, default and
  uninitialized values, traps and exit status, and real output.
- `kp-units.md`: units and separate compilation: `uses`, interface
  fingerprints, and guest-record traits.
- `kp-module-format.md`: the KPM1 serialized-IR format in full (this file
  summarizes the subset the reader accepts).
- `kp-errors.md`: the failable-routine model and the trap semantics.
- `kp-diagnostics.md`: the compiler's diagnostic format and codes.
- `kp-abi.md`: the host ABI: values, calls, handles, lifetime, and faults.
- `kp-embedding.md`: the step-by-step guide to embedding the runtime in a C
  host.
- `kp-conformance.md`: the map against ISO 7185 / 10206 and the dialect
  extensions.
- `kp-hardening.md`: the plan for running untrusted scripts safely.
- `kp-property.md`: the uniform-access (`property`) feature: accessor-backed
  declarations and computed record fields.
- `kp-defer.md`: `defer`, block-scoped teardown run LIFO on every orderly exit.
- `kp-foreach.md`: `for`-`in`, iterating the elements of a sequence directly.

## See also

- `doc/tools/jit.md`: the shared in-process JIT the Kobold tools build on.
- `doc/internals/ir.md`: the IR a KPM1 module is read into.
- `PLAN.md`, "Kobold-Pascal in-process linking and lazy compilation": the
  deferred lazy-compilation work (Steps C and D) and why it waits.
