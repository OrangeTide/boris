# C Language Reference (skj-cc)

`skj-cc` is the C front end for the Skjegg shared IR. It compiles a large
subset of C to every Skjegg backend. This document records what is supported,
what is not, and what is intentionally deferred.

The baseline is C99: `__STDC__` is `1` and `__STDC_VERSION__` is `199901L`. A
small, named set of C11 features is implemented on top of that baseline, so a
program that relies on the full C11 feature set will not compile unchanged.
The sections below separate the C99 baseline from the C11 additions and list
the gaps in each.

## Toolset

One front end drives every backend. The ahead-of-time compilers are `skj-cc`
(ColdFire/m68k), `skj-cc-rv` (RISC-V RV32), `skj-cc-x86-64`, `skj-cc-arm64`,
`skj-cc-mips` (MIPS I), and `skj-cc-mips-sf` (soft-float MIPS for the FPU-less
PlayStation R3051). The in-process JITs are `skj-jit`, `skj-jit-rv`, and
`skj-jit-arm64`. `skj-cpp` is the standalone preprocessor, which `skj-cc` also
uses as a library.

The test suite is `tests/cc_t001` through `tests/cc_t107` (run per target by
`make check-cc`, `check-cc-rv`, `check-cc-x86-64`, `check-cc-arm64`,
`check-cc-mips`, and end to end through the skj toolchain by
`check-cc-rv-skj` and `check-cc-mips-skj`), plus the preprocessor suite
`tests/cpp_t001` through `tests/cpp_t033` (`make check-cpp`).

## Type model

The 32-bit targets (ColdFire, RISC-V RV32, MIPS o32) are **ILP32**: `int`,
`long`, and a pointer are all 32 bits. The 64-bit targets (x86-64 and AArch64)
are **LP64**: `long` and a pointer are 64 bits. They run in a low-memory,
32-bit-address model, so every pointer value fits in 32 bits even though it
occupies eight bytes. `int` is 32 bits and `long long` is a real 64-bit integer
on every target. The two usable types whose size varies by architecture are
collected in the table below; see `doc/internals/lp64.md` for the data model.

| Type | ColdFire | RISC-V RV32 | MIPS o32 | x86-64 | AArch64 |
|------|----------|-------------|----------|--------|---------|
| `long`, `unsigned long` | 4 | 4 | 4 | 8 | 8 |
| pointer `T *`, function pointer | 4 | 4 | 4 | 8 | 8 |

Every other scalar is the same width on every target: `char` 1, `short` 2,
`int` 4, `long long` 8, `_Float16` 2, `float` 4, `double` 8. Each scalar's
alignment equals its width.

| Type | Width | Status |
|------|-------|--------|
| `_Bool` | 1 | supported; holds only 0 or 1 (`<stdbool.h>` `bool` is `_Bool`) |
| `char`, `signed char`, `unsigned char` | 1 | supported |
| `short`, `unsigned short` | 2 | supported |
| `int`, `unsigned int` | 4 | supported |
| `long`, `unsigned long` | 4 or 8 | supported (see the by-architecture table above) |
| `long long`, `unsigned long long` | 8 | supported |
| `_Float16` | 2 | supported (native on AArch64, softfloat helpers elsewhere) |
| `float` | 4 | supported |
| `double` | 8 | supported |
| `long double` | n/a | **deferred by design**: no 80-bit or 128-bit float in any backend, rejected at any use |
| pointer `T *` | 4 or 8 | supported (see the by-architecture table above) |
| `T[]`, `T[N]`, multidimensional | | supported |
| `struct`, `union`, `enum` | | supported |
| bit-fields | | supported |
| flexible array member (`char d[];`) | | supported |
| function pointers | | supported |
| `_Complex`, `_Imaginary` | | **deferred by design**: no complex arithmetic in the IR |

## C11 features

| Feature | Status |
|---------|--------|
| `_Alignas` | supported |
| `_Alignof` | supported |
| anonymous `struct` / `union` members | supported, including reaching the anonymous member's own inner fields (`o.a` where `a` is declared inside the unnamed member), through a value or a pointer, as an lvalue or an address, in a bit-field, nested, in `offsetof`, and in a designated initializer |
| `_Static_assert` | supported: evaluated at translation time at file scope, as a block item, and as a `struct`/`union` member; the message is optional (the C23 form). `static_assert` is accepted as a keyword and `<assert.h>` also defines it per C11 |
| `_Generic` | supported: selects an association by the controlling expression's static type (unevaluated), after lvalue conversion (array/function decay). Matches scalar, pointer (by pointee), and tagged types, distinguishing `_Bool` from `char`; `default` is the fallback. Since skj-cc does not model `const`/`volatile`, a qualified type matches its unqualified form. No match and no default, more than one default, or a type matching two associations are all compile errors |
| `_Noreturn` | **not implemented** (declare the function without it) |
| `_Bool` keyword | supported: a 1-byte type that holds only 0 or 1 (any conversion to it normalizes a nonzero value to 1); `<stdbool.h>`'s `bool` is `_Bool` |
| `_Atomic`, atomic operations | **deferred by design** (cooperative runtime, see below) |
| `_Thread_local` | **deferred by design** (cooperative runtime, see below) |
| Unicode / wide literals (`u8"..."`, `u"..."`, `U"..."`, `L"..."`, `u'x'`) | **deferred by design** (byte and UTF-8 oriented targets) |
| `_Pragma(...)` operator | **not implemented** (`#pragma` as a directive is accepted) |

`<stdbool.h>` defines `bool` as `_Bool`, with `true` and `false`. A `_Bool` is a
1-byte object that holds only 0 or 1: every conversion to it (an assignment,
initializer, cast, argument, or return) normalizes any nonzero value to 1, so
`bool b = 2;` leaves `b == 1`. It behaves as an `int` in expressions.

## C99 baseline

| Feature | Status |
|---------|--------|
| `//` line comments | supported |
| mixed declarations and statements | supported |
| declarations in `for` initializers | supported |
| designated initializers (`.field`, `[index]`) | supported |
| variadic functions and `<stdarg.h>` | supported |
| `inline`, `restrict` (parsed) | supported |
| `long long` | supported |
| flexible array members | supported |
| variadic macros (`__VA_ARGS__`) | supported |
| variable-length arrays (VLAs) | **deferred**: awaits the `IR_ALLOCA` IR decision (see `open-questions.md`) |
| compound literals (`(int[]){1,2,3}`) | supported (static at file scope, automatic at block scope) |
| old-style (K&R) function definitions | **not implemented** |

## Declarations

Supported: `typedef`; `struct`, `union`, `enum` with tags and members;
bit-fields; nested and anonymous aggregates; function pointers and function
pointer typedefs; multidimensional arrays; flexible array members. Storage
classes `static`, `extern`, `auto`, and `register` and the qualifiers `const`,
`volatile`, and `restrict` are accepted (`auto`, `register`, and the qualifiers
do not change code generation).

## Statements

All C statements are supported: `if` / `else`, `while`, `do` / `while`, `for`
(including a declaration in the initializer), `switch` / `case` / `default`,
`break`, `continue`, `return`, `goto` and labels, compound blocks, and
expression statements. A basic `asm` / `asm volatile` statement emits one
verbatim instruction string per backend.

The GNU **labels as values** extension is supported: `&&label` is the address of
a label (a `void *`) and `goto *expr` is a computed jump through such a value, so
a bytecode interpreter can use a threaded-dispatch inner loop, `goto
table[op];`. The dispatch table is filled at run time (`void *tab[N]; tab[0] =
&&op0; ...`). A label address used as a **static or aggregate initializer**
(`static void *tab[] = {&&a, &&b};`) is not supported and is reported as "expected
constant expression" rather than miscompiled; build the table with run-time
assignments instead.

## Expressions

The full C operator set is supported: arithmetic, bitwise, shifts, logical and
relational operators, the ternary and comma operators, `sizeof`, `_Alignof`,
casts, compound assignment, and prefix and postfix `++` / `--`. Integer
promotion and the usual arithmetic conversions apply, as do `float` and
`double` arithmetic with the conversions inserted by the type checker.

Passing and returning a `struct` or `union` by value is supported on every
target. On the register-ABI targets (x86-64, AArch64, RISC-V) a small aggregate
travels in registers per the platform psABI and a large one by reference. On
ColdFire and MIPS o32 the caller copies the aggregate word by word into the
argument structure (the stack on ColdFire; the argument registers then the
stack on MIPS), and the callee reads it back from its parameter slot. On MIPS a
struct with 8-byte-aligned members (an embedded `double` or `long long`) starts
on an even argument word, so it reconstructs 8-aligned in the callee's home slot
and the aligned field loads correctly. A struct return on these two targets is
handed back through a hidden result pointer the caller allocates and passes as a
leading argument, so the result lives in the caller's frame.

A member access, index, or address-of applied directly to the result of a
function that returns a `struct` (`mk().a`, `mk().arr[i]`, `&mk().a`) works on
every target: the call result is materialized in a temporary, whose address the
postfix operator uses.

## Initializers

Static and aggregate initializers are a strong area and were hardened across
several passes:

- Scalar initializers for every integer and floating type.
- Aggregate initializers: nested, brace-elided, and designated (`.field` and
  `[index]`), and a byte-image path for structs and unions.
- String initializers for `char[]`, and a string literal assigned to a
  `char *`.
- Constant expressions, folded per the slot type: integer expressions
  (`1 << 4`, `A * B`), floating expressions (`1.5 + 2.0`, respecting C typing
  so `1 / 2` is `0`), and each leaf of an array or aggregate folded against its
  element type.
- Address constants carrying a byte offset, as a relocation with an addend:
  `&a[2]`, `a + 2`, `"s" + 1`, `&s.field`, and an array of such pointers.
- An integer-constant pointer (`(int *)0x1000`).
- The `offsetof` idiom, `(size_t)&((T *)0)->member`, folded to the member
  offset.
- A constant index of a string literal (`"abc"[1]` is `'b'`).

## Preprocessor (skj-cpp)

Supported directives: `#include` (quote and angle forms), `#define` for
object-like, function-like, and variadic macros, `#undef`, the conditional
family `#if` / `#ifdef` / `#ifndef` / `#elif` / `#else` / `#endif` with the
`defined` operator, `#error`, `#pragma`, and `#line`. The token-paste (`##`)
and stringize (`#`) operators and `__VA_ARGS__` are supported.

Predefined macros: `__FILE__`, `__LINE__`, `__DATE__`, `__TIME__`, `__STDC__`
(`1`), and `__STDC_VERSION__` (`199901L`). The `_Pragma` operator form is not
implemented.

## Standard library headers

A freestanding-plus libc subset ships in `include/`: `assert.h`, `ctype.h`,
`errno.h`, `limits.h`, `stdarg.h`, `stdbool.h`, `stddef.h`, `stdint.h`,
`stdio.h`, `stdlib.h`, `string.h`, a cooperative C11 `threads.h`, and `coro.h`
(the stackful coroutine primitive the threads layer rides on). See
`doc/tools/libc.md`.

## Targets and ABIs

Code generation covers five backends: ColdFire/m68k, RISC-V RV32, x86-64,
AArch64, and MIPS I. Each external call uses that target's platform ABI (the
m68k C ABI, the RISC-V ILP32 and MIPS o32 psABIs, SysV on x86-64 and AArch64).
MIPS also has a soft-float configuration (`skj-cc-mips-sf`) that emits no
coprocessor-1 instructions and lowers every float operation to an integer
IEEE-754 helper, for the FPU-less PlayStation R3051. See the per-backend notes
in `doc/tools/`.

## Grammar

The grammar skj-cc accepts is the C99 grammar from the ISO standard (ISO/IEC
9899:1999, Annex A), with the named C11 additions above layered on top. This
document does not inline that grammar, since the surface syntax is standard C;
what differs from a conforming C implementation is the set of accepted features,
and those are enumerated in the tables above and in the gaps below. A program
that stays inside the supported feature set parses as standard C. For the
preprocessor grammar see the preprocessor section above; for the token and macro
rules see `cpp/`.

## Summary of gaps

Intentionally deferred, by a design decision:

- `long double` (no wide float type in any backend).
- `_Complex` and `_Imaginary` (no complex arithmetic in the IR).
- `_Atomic` and `_Thread_local` (the runtime is cooperative, a single OS thread
  with no preemption, so there is nothing for atomics or thread-local storage
  to guard; see the `threads.h` notes in `doc/tools/libc.md`).
- Unicode and wide string and character literals (the targets and runtime are
  byte and UTF-8 oriented, so wide encodings are handled at the source level).
- Variable-length arrays (they await the `IR_ALLOCA` IR design decision
  recorded in `open-questions.md`).

Not yet implemented, with no fundamental obstacle:

- `_Noreturn`.
- The `_Pragma` operator.
- Old-style (K&R) function definitions.
- A label address (`&&label`) as a static or aggregate initializer. The computed
  goto itself and a run-time-filled dispatch table work on every backend; only the
  constant-initializer form is missing (it needs a data relocation to a local
  label), and it is a clean compile error rather than a miscompile.
