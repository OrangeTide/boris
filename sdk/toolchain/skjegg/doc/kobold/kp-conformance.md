# Kobold-Pascal Standards Conformance and Roadmap

This document maps Kobold-Pascal against the Pascal standards and dialects it draws
from, so the distance to a complete, production-ready language is visible in one
place. It records three things:

1. Which **Standard Pascal (ISO 7185)** features are implemented, deliberately
   omitted, or still missing.
2. Which extensions from **Extended Pascal (ISO 10206)**, the **Turbo / Delphi /
   Free Pascal** family, and other dialects have been adopted.
3. The **Kobold-original** extensions for embedded game scripting.

It reflects the language as the compiler implements it today, cross-checked against
`kp-language.md`, `kp-grammar.md`, and the front end. This document is about
language surface, not build tasks.

Kobold-Pascal is a Pascal-family scripting language, not a conforming ISO Pascal.
It removes constructs that do not fit an embedded, no-pointer, host-sandboxed model,
leaves out Standard Pascal features that are clumsy or rarely useful in a script,
and adds constructs that a game host needs. The tables below are a gap analysis, not
a conformance claim.

## Legend

- **Done**: implemented and covered by the test corpus.
- **Omitted**: intentionally excluded by the language design; not planned.
- **Deferred**: intended, but not built yet. The direction is reserved (for example
  the KPM1 section framework in `kp-module-format.md`) and the feature is expected to
  land, it has just not been scheduled.
- **Gap**: absent today, but reasonable for a production Pascal and a candidate for
  future work.

## Standard Pascal (ISO 7185)

### Lexical and program structure

| Feature | Status | Notes |
|---|---|---|
| `program` header, block, terminating `.` | Done | |
| Program-parameter list `program p(input, output)` | Omitted | I/O is not through file parameters. See I/O below. |
| Case-insensitive identifiers and keywords | Done | |
| `{ }` and `(* *)` comments | Done | Do not nest. |
| `const`, `type`, `var`, routine sections, any order | Done | ISO fixes the section order; Kobold allows any order and repetition. |

### Types

| Feature | Status | Notes |
|---|---|---|
| `integer`, `boolean`, `char` | Done | |
| `real` | Done | 64-bit IEEE double. |
| Enumerated types | Done | |
| Subrange types | Done | |
| `array [index] of T`, multi-dimensional | Done | Fixed arrays with ordinal index ranges. |
| `record`, including variant records | Done | |
| `set of` an ordinal base | Done | |
| `packed` structures | Omitted | No `packed` keyword; layout is the host's concern. |
| `file of T` and `text` | Omitted | No file type. File input is a host `external` primitive. |
| Pointer types (`^T`), `nil` pointers | Omitted | No pointers by design. Host objects are opaque handles; `nil` is the empty handle. |
| `@` address-of | Extension (labels only) | `@name` takes the address of a code label, yielding a second-class `label` value for a computed `goto` (threaded dispatch). It is not a general address-of: the only operand is a label name. |

### Constants and expressions

| Feature | Status | Notes |
|---|---|---|
| Named constants | Done | |
| Constant expressions evaluated at compile time | Done | |
| Arithmetic `+ - * /`, `div`, `mod` | Done | `/` yields real; mixed int/real promotes to real. |
| Relational operators, `in` | Done | |
| Boolean `and`, `or`, `not` (short-circuit) | Done | Short-circuit is an extension over ISO's unspecified order. |
| Set operators `+ - *` and membership | Done | |
| Left-to-right vs unspecified evaluation order | Note | Kobold fixes operand evaluation right to left. |

### Statements and control flow

| Feature | Status | Notes |
|---|---|---|
| Assignment, compound `begin ... end` | Done | |
| `if` / `then` / `else` | Done | |
| `case` on an ordinal | Done | Labels may be ranges. |
| `while`, `repeat` / `until`, `for` (`to` / `downto`) | Done | For-counter is undefined after the loop. |
| `with` | Done | |
| `goto` / labels | Computed form only (extension) | No unstructured `goto`: a bare `goto name` is a compile error, and `break` / `continue` remain the structured exits. A `name:` label and `goto EXPR` where `EXPR` is a `label` value (from `@name`) give the threaded-dispatch primitive `goto table[token]`. The `label` value is second-class (local frame only), so a computed jump always lands in a live frame. |

### Routines

| Feature | Status | Notes |
|---|---|---|
| Procedures and functions | Done | |
| Value and `var` parameters | Done | |
| Procedural and functional parameters | Done | A procedure or function value is a bare code pointer, no captured environment. |
| Nested routines with access to enclosing locals | Done | No closures: a nested routine that captures a local may be called but not stored or returned. |
| `forward` declarations | Done | |
| Function result via function name | Done | Also `exit(value)`. |

### Required procedures and functions

This is the largest Standard Pascal gap. Kobold implements the ordinal and string
built-ins but not the standard arithmetic, transfer, or console-I/O intrinsics.

| Group | Standard names | Status | Notes |
|---|---|---|---|
| Ordinal | `ord`, `chr`, `succ`, `pred`, `odd` | Done | `succ` / `pred` return the argument's own ordinal type. |
| Arithmetic | `abs`, `sqr`, `sqrt` | Done | `abs` / `sqr` keep the argument's numeric type; `sqrt` yields a real. |
| Arithmetic | `sin`, `cos`, `exp`, `ln`, `arctan` | Done | Real functions lowered to runtime helpers over the C library (the runtime links `-lm`). |
| Transfer | `trunc`, `round` | Done | `trunc` toward zero, `round` to nearest (round-to-nearest-even). |
| Console output | `write`, `writeln` | Done | Overloaded by argument type (integer, real, char, string); select `output` or `erroutput`. |
| Output formatting | `write(x:width[:decimals])` | Omitted | Format with `str` / `copy` or a host `external`. |
| Console input | `read`, `readln` | Done | Token-based over stdin, into integer, real, char, or string variables. No field-width formatting. |
| File I/O | `get`, `put`, `reset`, `rewrite`, `eof`, `eoln`, `page` | Omitted | No file type. |
| Dynamic | `new`, `dispose` | Omitted | No pointers; handles are host-managed and reference-counted. |
| Layout | `pack`, `unpack` | Omitted | No `packed` types. |

## Extended Pascal (ISO 10206)

Extended Pascal adds modules, schema (parameterized) types, variable-length strings,
richer constant handling, and structured value constructors. Kobold adopts the ideas
that fit an embedded scripting language, though not always with the ISO syntax.

| Feature | Status | Notes |
|---|---|---|
| Variable-length strings with `+`, `length`, `pos`, `copy` | Done | Kobold's `string` is a host-managed, length-counted, immutable value type (share on assignment, build new values with `+` and `copy`), not the ISO string schema, but it fills the same role. |
| `otherwise` / `else` branch on `case` | Done | Kobold spells it `else`. |
| Structured constant constructors (array, record, set) | Done | Const arrays, records, and sets are initialized at compile time. |
| Initial values on variables (typed constants) | Done | `var x: T = value` and `const x: T = value`. |
| Compile-time constant expressions | Done | Shared with the ISO 7185 row above. |
| Modules / separate compilation | Done | A program or `unit` compiles separately to a KPM1 module, and `uses` links precompiled units, resolved through the `-U` search path and interface fingerprints. Cross-unit routines, methods, types, exported globals, and exported constants link and run, and `kpbundle` packages a program with its units into one self-contained module. See `kp-units.md` and `kp-module-format.md`. |
| Exported constants | Done | A const is a read-only var. An inline scalar const (`const X = v`) folds like a `#define` and sits in the interface fingerprint. A value-less interface const (`const X: T;`) valued in the implementation is resolved at link, so its value is out of the fingerprint and changing it needs only a relink. Scalar values become an exported read-only global; string values become an exported static string object. See `kp-units.md` and `kobold.md`. |
| Schema types (parameterized types) | Omitted | Dynamic arrays and the string type cover the needed cases without a general schema mechanism. |
| Complex numbers, `bindable`, date/time types | Omitted | Out of scope for game scripting. |

## Turbo Pascal / Delphi / Free Pascal family

Kobold accepts a subset of the Free Pascal dialect, so these family features apply.

| Feature | Status | Notes |
|---|---|---|
| `//` line comments | Done | |
| Hexadecimal literals `$1F` | Done | |
| Character-code literals `#10`, `#$0A` | Done | |
| Sized integer types `shortint`, `byte`, `word`, `cardinal`, `longint`, `int64`, `qword` | Done | `integer` is 32-bit; `int64` / `qword` are true 64-bit. |
| `single` (32-bit) and `double` (64-bit) reals | Done | `double` aliases `real`. |
| `shl`, `shr`, bitwise `and` / `or` / `not` on integers | Done | |
| `break`, `continue` | Done | |
| `inc`, `dec` with optional step | Done | |
| `exit` and `exit(value)` | Done | |
| `out` parameters | Done | |
| `const` reference parameters | Done | Pass aggregates without a copy. |
| Function and procedure overloading | Done | Resolved by argument type at the call site. |
| Dynamic arrays `array of T`, `setlength`, `low` / `high` | Done | Value semantics with copy on write, `low` is 0. |
| Open-array parameters `array of T` | Done | |
| Reference-counted strings with copy on write | Done | Similar to Free Pascal `ansistring` behavior. |
| `str` / `val` conversion | Done | |
| Directives `{$R+}`, `{$Q+}`, `{$DEFINE}`, `{$IFDEF}`, `{$ELSE}`, `{$ENDIF}`, `{$I}` | Done | Predefines `KOBOLD`. Unknown directives such as `{$mode}` and `{$H+}` are accepted and ignored, so source can be shared with `fpc`. |
| `external` / `cdecl` foreign routines | Done | The FFI to the C host. See `kp-abi.md`. |
| Classes, objects, inheritance, `constructor` / `destructor`, exceptions, generics | Omitted | Kobold uses receiver methods and host handles instead of a class model, and traps instead of exceptions. |
| Properties (uniform access `read` / `write`) | Done | A `property name: T read getX write setX;` on a record, or a computed field, that reads and writes through accessor routines. Scalar, handle, and aggregate value types are all supported. Inline accessor bodies and cross-module export are not yet available. See `kp-property.md`. |
| Units (`unit` / `interface` / `implementation`, `uses`) | Done | Not the class model above; a separate-compilation feature, with selective imports, renames, re-export, and `implement I for R` trait conformance. See the Modules row under Extended Pascal, `kp-units.md`, and `kp-module-format.md`. |

## Kobold-original and Compact-Pascal extensions

These are the features that make Kobold an embedded game-scripting language rather
than a general-purpose Pascal.

| Feature | Status | Notes |
|---|---|---|
| Opaque host handles via `interface` types | Done | Named procedural fields; a method call resolves at link to a direct call to the host's registered method. No pointer is ever exposed. |
| Go-style receiver methods (`function f for (const p: T)`) | Done | Receiver is by reference unless `const`. Record calls resolve statically; handle calls resolve at link to the host's registered method. A script method overrides a host-registered method of the same name. |
| Automatic reference counting (ARC) for handles and strings | Done | Retain on copy, release on scope exit or overwrite. Not tracing GC. |
| Reference dynamic arrays `ref array of T` | Dropped | The array surface is two cases, value `array of T` and host `buffer of T`. `ref` stays a reserved word. |
| Host buffers `buffer of T`, multidimensional `buffer[,] of T` | Done | A shared array over a host-owned, strided element region; the host creates it and the guest indexes it. Read, written, and mapped through the checked `kp_buf_*` FFI. |
| Guest-record trait conformance `implement I for R` | Done | Checks at compile time that record `R`'s receiver methods match interface `I`; retroactive and cross-unit, with no runtime representation. |
| Stackful coroutines: `start`, `yield`, `bind`, `release` | Done | Each coroutine runs on its own reference-counted private stack. `yield` is statement-position only. Resumed one at a time, not forkable. |
| `process` handle type | Done | The handle type of a coroutine. The `std.threads` unit builds a cooperative thread API on top of coroutines. |
| Associative maps `map of T` and `map[K] of T` | Done | A reference-counted container with value (copy-on-assign) semantics. The key is a `string`, or an ordinal `K` (integer, int64, char, enum, boolean) in the bracketed form. Indexing, `in`, `Delete`, `Length`, `TryGet`, `MapFirst` / `MapNext`, and `for k, v in m` all apply. See `kp-language.md` and `kp-builtins.md`. |
| Inline assembly `asm("...")` | Done | A statement carrying an assembly template to the backend. It is the string form, not Turbo/FPC `asm ... end` blocks. The basic form is the template alone; the extended form adds GNU-style operand constraints and clobbers, in the simple subset of integer-class operands and the general register class (`r`, `=r`, `+r`). AOT only. See `AsmStmt` in `kp-grammar.md`. |
| `export` routine directive | Done | Adds a module entry a host can call besides `main`, which is how the two-stage boot compiles in memory. |
| Opt-in range checks `{$R+}` and overflow checks `{$Q+}` | Done | Off by default; raise host-reported traps when on. |
| Runtime traps (divide by zero, bounds, overflow, nil dispatch, coroutine misuse, out of memory, stack overflow) | Done | Reported through a host hook with a source location when built `-g`. |

## Production-readiness assessment

The standard language surface an author writes against is complete. In place: the
full type system, control flow, routines (including
nested routines, overloading, receiver methods, and procedural values), the string
and dynamic-array runtimes, handles with ARC, coroutines, separate compilation with
units, and the opt-in range and overflow checks. The standard ordinal and numeric
intrinsics are all present, `ord`, `chr`, `succ`, `pred`, `odd`, `abs`, `sqr`,
`sqrt`, `round`, `trunc`, and the transcendentals `sin`, `cos`, `exp`, `ln`,
`arctan`, so ordinary numeric code needs no host functions. Console I/O is complete
on both sides: `write` / `writeln` print integers, reals, chars, and strings, and
token-based `read` / `readln` read the same scalar and string types. No standard
feature an author would reach for is missing (the remaining unimplemented items are
the deliberate omissions below).

What remains is polish and packaging, not language surface:

1. **Diagnostics quality.** The compiler recovers within a phase to report many errors
   per run, each located as `file:line:col` and shown with the source line and a caret.
   The daily-use polish is now in: warnings for an unused local, an assigned-but-never-read
   local, an unused parameter, a shadowed built-in, and a narrowing conversion; stable
   `E####`/`W####` error codes on every diagnostic; "did you mean" name suggestions; and
   the `__line__` intrinsic for source locations in a helper. What remains is finer, such as
   notes attached to an error and cross-phase reporting. The current state is detailed in
   `kp-diagnostics.md`.
2. **Release engineering.** Packaging, the untrusted-script hardening path
   (`kp-hardening.md`), and cutting a tagged release.

Deliberate omissions that are unlikely to change. Some conflict with the embedded,
sandboxed, no-pointer design: pointers and `new` / `dispose`, `file` / `text` types,
unstructured `goto`, `packed`, and a class model with exceptions. (Labels and a
computed `goto` through a second-class `label` value are supported for threaded
dispatch, but a bare `goto name` stays omitted.) A host reaches these
capabilities on the script's behalf through the FFI and handles. Another omission is
the `write` / `read` field-width and precision formatting (`x:width[:decimals]`),
where a script formats through the string builtins or a host routine instead.

The unit and separate-compilation system is implemented; its design is in
`kp-units.md`.

Observable-behavior pins. The `conf_*` programs in `tests/kp-corpus` are a
conformance set that locks the documented corner cases in place: integer div/mod
sign, two's-complement overflow wrap, unsigned bytewise string ordering, set
subset/superset relations, global zero-initialization, and evaluation order. The
`conf_trap_*` programs pin the faults: a divide by zero (always checked), a
missing map key, an out-of-bounds index under `{$R+}`, a signed add overflow
under `{$Q+}`, and the most negative integer `div`/`mod` `-1` (always checked)
each trap and exit 70 with empty stdout. Each program runs on all
four backends (the x86-64 JIT, and the x86-64, rv32, arm64, and ColdFire AOT
paths), so a silent change in any backend, or a divergence from the behavior
specified in `kp-semantics.md` and `kp-evaluation.md`, fails the build. They are
the executable counterpart to those specifications and the seed of a fuller
conformance suite.

## See also

- `kp-language.md` the language reference (what the compiler accepts).
- `kp-grammar.md` the full grammar in EBNF.
- `kp-semantics.md` and `kp-evaluation.md` the static and dynamic semantics the
  `conf_*` corpus pins.
- `kobold.md` the compiler and runtime design and detailed status.
- `kp-abi.md` the host ABI for `external` routines and handle types.
- `kp-units.md` the design of the unit and separate-compilation system.
