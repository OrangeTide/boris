# A C standard library for the skj toolchain

Status: Phases A through E implemented and passing on all five targets
(ColdFire, RISC-V, MIPS, x86-64, arm64). The toolchain prerequisite (predefined
target and data-model macros) is done. The headers, string/ctype, the snprintf
formatter (now including the floating conversions f/e/g), the stdlib
numeric/sort functions, the `malloc` family over the `__libc_sbrk` seam,
buffered stdio (the three standard streams, the printf family, and the
character/line I/O functions), `errno`, and a round of self-contained
additions (`strerror`/`perror`, `rand`/`srand`, `strtod`/`atof`,
`sscanf`/`vsscanf`), and exit-time flushing with `atexit` are in `include/`
and `libc/`, pinned by `tests/libc_phase_a.c`, `_b.c`, `_c.c`, `_e.c`, `_f.c`,
and `_g.c` through `make check-libc` (and the per-target `check-libc-*`). ColdFire and MIPS needed three compiler fixes
the formatter surfaced (open-questions.md items 7 and 8): a 64-bit truthiness
test that checked only one word in the older `cf_emit.c`/`mips_emit.c`
backends, a 64-bit array index not truncated to address width, and the `?:`
64-bit result round-tripping through a slot. The allocator surfaced a fourth,
a self-referential struct field (`struct node *next` inside `struct node`)
resolving to a fieldless forward stub so a chained `p->next->field` found no
field; the struct tag is now registered before its body is parsed. All are
fixed.

## The problem, and why it is a shared-runtime problem

skjegg targets several VM hosts (native and qemu, smolmoo, and the planned
boris and aldeby) plus the bare qemu and emulator tiers. Each consumer that
runs compiled code carries its own runtime, and those runtimes are partially
the same. Today that overlap is implicit and the shared parts are duplicated
rather than factored:

- The 64-bit integer helpers exist as target assembly in every full crt and
  again in C in `runtime/soft64.c`.
- The bump arena is reimplemented about five times (the crts).
- Integer and float to string formatting exists in more than one place:
  `runtime/str.c` (`__moo_tostr*`) and `runtime/pascal_rt.c`
  (`__pascal_write_*`).
- String and list value operations exist over near-identical
  `{ int len; char *data }` structs in the `__moo_*` world (str.c, list.c,
  rope.c).
- `memset` and `memmove` live only in `pascal_rt.c`.

The per-host code that is genuinely different is small. The irreducible host
power a guest needs is write, exit, and read. The trap instruction differs by
target (`trap #0` on ColdFire, `ecall` on RISC-V, `syscall` on MIPS, a BIOS
jump on the PlayStation). Everything else (persistence, cross-VM messaging,
scheduling, memory mapping) is optional and host-tier.

So the libc is not a new thing bolted on. It should formalize a portable
host-independent layer over a tiny per-host seam, and make pascal_rt and the
moo runtime consumers of one shared core rather than parallel implementations.

## Constraints from skj-cc

The library is compiled by skj-cc itself, which bounds what its source may
use. These are facts about the current compiler, not wishes.

1. No extended inline assembly. Only a verbatim `asm("...")` string is
   accepted, with no operand constraints or `%` substitution. The syscall
   layer therefore cannot be written in C. This is convenient rather than
   limiting: the crt is the syscall layer and already exists per target.
2. No builtin target macros and no builtin `size_t`, `stddef`, `stdint`,
   `limits`, or `stdbool`. The compiler predefines only a handful of macros.
   The library must ship all of those headers itself, and the compiler must
   name the target and data model (now done, below).
3. No `_Generic`, `_Static_assert`, variable-length arrays, `_Complex`,
   atomics, thread-local storage, or K&R definitions. Avoid all of these.
4. `_Bool` and `<stdbool.h>` are not wired up: the keyword is not lexed. The
   library defines `bool` itself (a typedef or macro), or the lexer gains the
   keyword first.
5. `long double` has no code generation. Only dead `sizeof`-guarded branches
   survive, which is how musl-style header helpers compile. The library must
   avoid real long double arithmetic.
6. Struct copies are inlined by the backend, not lowered to `memcpy`, so the
   compiler does not require a runtime `memcpy`. The library still provides
   `memcpy` as ordinary API.
7. The data model is ILP32 on ColdFire, RISC-V, and MIPS, and LP64 on x86-64
   and arm64. On all five, pointer, `long`, and `size_t` are one machine word,
   so `size_t` is `unsigned long` and `ptrdiff_t` is `long` everywhere. The
   fixed-width `stdint` types are the same on all targets (`int` is 32-bit,
   `long long` is 64-bit, and so on).
8. gcc object interop is confirmed only on RISC-V (scalars and structs, both
   directions, though varargs stays skj-only). Linking against a stock gcc
   libc is not a portable path. The library is skjegg's own, rooted in the
   freestanding runtime that already exists.
9. A static pointer whose initializer is another object's address is not
   emitted: skj-cc rejects `static int *p = arr;` ("non-constant initializer")
   and silently zeroes the cast form `static char *p = (char *)arr;`. The
   library initializes such a pointer lazily at first use instead (the
   allocator's break pointer in `libc/sbrk.c`). A string-literal initializer
   (`static char *s = "x";`) does work, through the ordinary literal relocation.
10. A struct member inside a union is not accepted (`union u { struct { ... } s;
    ... }` reports "no field 's'"), so the allocator uses a flat struct header
    rather than the K&R alignment union. A global array has no guaranteed
    alignment directive either, so `libc/sbrk.c` rounds the heap base up to 8
    bytes itself rather than relying on the array's symbol alignment.

## What already exists to build on

Do not rewrite these. The library sits on top of them.

- The per-target crt and syscall wrappers (`runtime/start_*.S`) provide
  `_start`, `write`, `read`, and `exit`. This is the OS seam, already written.
- `runtime/soft64.c` (64-bit integer helpers), `runtime/softfloat.c`
  (software binary64 and binary32), and `runtime/half.c` (binary16) are the
  math and compiler-rt substrate.
- `runtime/utf8.c` is a clean, reusable text primitive.
- The per-ABI `__va_arg` helpers back `<stdarg.h>`, which is the one library
  header that already ships.

## Design: one portable core over a four-call seam

```
include/     stddef stdint limits stdbool string stdlib stdio ctype errno
             assert sys/types   (types sized from the data-model macros)

libc/        (compiled by skj-cc, per target, host-independent)
  string/    mem* and str*
  ctype/     the character class predicates
  fmt/       one printf, vprintf, snprintf engine writing to a sink
             (this absorbs the three duplicate number formatters)
  stdlib/    strtol, atoi, strtod, qsort, bsearch, abs, div, and malloc
  stdio/     FILE over the seam; stdin, stdout, stderr; fopen only where a
             host offers a file power

the seam    (per host, tiny; maps onto the existing crt)
  __libc_write   __libc_read   __libc_exit   __libc_sbrk
```

The seam is small. `write` and `exit` already exist in every crt. Add `read`
(present in most crts) and one memory primitive, `__libc_sbrk`, which is a
real `brk` call under skj-run and qemu and a fixed static region under the VM
hosts. That single primitive is what turns the allocate-only bump arena into
a real `malloc` with `free`.

As built, the write/read/exit three are realized directly as the crt's bare
`write`, `read`, and `exit` symbols (the names `start.S` already exports), not
under a `__libc_` prefix: `libc/stdio.c`, `assert.c`, and `abort()` call them
by those names, and so do moo and pascal. So the consumers already share
one seam at the crt. `__libc_sbrk` is the only
libc-private seam member, and it lives in `libc/sbrk.c` over a reserved `.bss`
region. The names above are the conceptual contract; the prefix was not added,
since a single set of crt symbols already serves everyone.

`stdio` splits along the same line. Formatted output is portable and lives in
`fmt/`. The stream backing (the three standard streams, buffering) sits on the
seam. `fopen` of a real file is host-tier and optional: boris and aldeby may
provide a file power, while smolmoo and the native tier do not, so `fopen`
arrives only where a host backs it.

## Phasing

Each phase is independently testable through the `skjcc` driver on all five
targets.

- Phase A, the freestanding core, needs no new host surface. The headers,
  the `string.h` and `ctype.h` bodies, the one printf formatter writing to a
  sink, `strtol`, `atoi`, `qsort`, `bsearch`, and `assert`. Nothing but the
  existing crt is required. Done on all five targets; `strtod` is deferred to a
  later increment, since float formatting (`%f`/`%e`/`%g`) is not in the
  formatter yet either. This alone lets real C compile and is where the three
  duplicate number formatters eventually fold into one.
- Phase B, the allocator. Done. `__libc_sbrk` (`libc/sbrk.c`) is the memory
  seam: the portable "fixed static region" backing, a reserved `.bss` array the
  linker places in the low-address image, which every target and host shares
  without a syscall and which stays inside the 32-bit address window the 64-bit
  targets' ILP32-style model requires. `libc/malloc.c` is a boundary-tag,
  segregated-fit allocator over that seam. Reuse is an O(1) pop from an
  exact-size bin in the common case (the scheme kobold's guest heap uses: free
  blocks of a given total size share a bin), with a large-block list reused by
  first fit with a split for sizes past the bins. On top of that every block
  carries its size in a header and a footer, so `free()` finds its physical
  neighbours and coalesces with any that are also free, which keeps a varied
  mix of sizes from fragmenting the arena the way a bin-only allocator would.
  Payloads are 16-aligned; the header's low bit is a best-effort double-free
  guard, and `__libc_malloc_live`/`__libc_malloc_peak` report the footprint for
  leak hunting. `malloc`, `calloc`, `realloc`, and `free`, pinned by
  `tests/libc_phase_b.c` (the contract) and `tests/libc_phase_h.c` (a
  randomized churn across the bin/large boundary that re-verifies every live
  block's contents and checks for a leak at the end). The seam is
  backing-independent, so a VM host, or the qemu/skj-run tier wanting a growable
  heap, can replace `sbrk.c` with a real `brk` without touching the allocator.
- Phase C, stdio. Done. The three standard streams (`libc/stdio.c`) over the
  crt's write/read seam: a `FILE` with an embedded buffer (so the streams need
  no static pointer initializer, which skj-cc does not yet emit), stdout line
  buffered, stderr unbuffered, stdin read in `BUFSIZ` chunks. Output
  (`fputc`/`putc`/`putchar`/`fputs`/`puts`/`fwrite`/`fflush`), input
  (`fgetc`/`getc`/`getchar`/`fgets`/`fread`), status (`feof`/`ferror`/
  `clearerr`), and the printf family (`printf`/`fprintf`/`vprintf`/`vfprintf`).
  The printf family and `snprintf` share one conversion engine (`__vformat`,
  `libc/fmt.h`) that renders to an abstract sink, a memory buffer for snprintf
  and a stream for fprintf, so the formatter is written once. The floating
  conversions (`f F e E g G a A`) are a compile-time option: `__vformat`
  compiles them only when `SKJ_LIBC_FLOAT` is defined, so a build that cannot or
  does not want double arithmetic in the link gets an integer-only formatter
  (`fmt_float` and its helpers are then absent from the object, and a float
  conversion is echoed verbatim like an unknown one). The option is on by
  default for every shipped `libc.a` (`LIBC_CFLAGS_*` in the Makefile) and in
  the `check-libc` harness (which runs under qemu, where double works); clear a
  target's `LIBC_CFLAGS_*` to ship a float-free libc for a core that cannot run
  double, such as the RV32 `skj-run` core (no D extension). Pinned by
  `tests/libc_phase_c.c` with a `.expected` stdout and a `.input` stdin, and the
  float path by `tests/libc_phase_e.c`.
  `fopen` of a real file is deferred to a host with a file power. Note: the
  crt's normal exit (returning from main) does not flush, so a program leaving
  output in a buffer should `fflush` before returning; a flushing exit path is
  a later phase.
- Phase D, errno and the hosted or freestanding split. Done. A single global
  `errno` (`libc/errno.c`, `include/errno.h`) set by `strtol`/`strtoul`
  (`ERANGE`) and `malloc` (`ENOMEM`). The build stages `build/lib/<target>/libc.a`
  beside the crt and runtime helpers (a pull-only GNU archive built by `skj-ar`;
  this phase also taught `skj-ld` to read archives, matching `skj-ld-rv` and
  `skj-ld-mips`). `skjcc` links that archive by default, placed after the
  program objects and before the runtime helpers so one left-to-right pass
  resolves each, and links only the crt plus helpers under `-ffreestanding`
  (alias `-nostdlib`). Verified by `make test-cc-driver` (a hosted
  printf+malloc program on cf/rv/mips through the driver, and a freestanding
  program). `vendor.sh` ships the libc with the driver when the `ar` component
  is also selected: it copies the sources and headers, regenerates the
  per-target `libc.a` / `fini.o` / `soft64_div.o` rules into `skjegg.mk`, and a
  vendored `skjcc` then links a hosted program (including coroutines) the same
  way. Without `ar` the vendored driver stays freestanding.
- Phase E, convergence. Done, though a survey of the three runtimes showed the
  premise was largely already met, so the work was narrower than the heading
  implies.
  - utf8 is already shared: the one `runtime/utf8.c` is the only decoder, and
    moo and pascal are byte-oriented and decode no UTF-8, so there was no
    duplicate to remove.
  - The seam is already one. moo, pascal, and the libc all reach the host
    through the crt's bare `write`/`read`/`exit` (see the seam note above);
    only `__libc_sbrk` is libc-private. No collapse was needed.
  - The number formatters converge where it is libgcc-free to. The shared
    `__vformat` engine has the floating conversions f/e/g (closed this phase in
    `libc/printf.c`, pinned by `tests/libc_phase_e.c`), and the two libgcc-free
    core formatters live in `libc/numfmt.c` (`__fmt_udec` for unsigned decimal
    and `__fmt_greal` for a finite `%g` real) and are shared across the ABI
    boundary: the C libc's `%g` path AND the Kobold runtime's `writeln`/`readln`
    numeric output (`io_write_int`/`io_write_real`) call them, so a C program and
    a Kobold program built against the same libc print a number identically (see
    `doc/abi/README.md`). What stays bespoke is the format *framing* each runtime
    wraps around those digits (Pascal shortstring output, the MOO error-name
    table), not the digit conversions themselves.
  - The mem functions were left as they are. `runtime/pascal_rt.c` defines
    `memset`/`memmove` because the Pascal codegen emits calls to them; those
    are the canonical copies for the Pascal tiers, which link no libc. The
    generic-m68k Pascal tier runs under qemu-m68k and must not link the
    ColdFire `libc.a`, so a redirect would need a build-macro split for two
    trivial functions. `libc/string.c` is the copy C programs use; the
    duplication is intentional and documented rather than removed.

## Backlog

- `strerror`/`perror`, `rand`/`srand`, `strtod`/`atof`, and `sscanf`/`vsscanf`
  are done (`libc/strerror.c`, `rand.c`, `strtod.c`, `scanf.c`), pinned on all
  five targets by `tests/libc_phase_f.c`. Wiring them surfaced two pre-existing
  skj-cc codegen bugs, neither in the libc: the address of a scalar
  `char`/`short` local is wrong on ColdFire (big-endian), and `sizeof` of an
  implicit-dimension array of 8-byte elements is wrong on the LP64 targets
  (open-questions.md items 9 and 10). The library and the test steer around
  both (a `char *` parameter rather than `&ch`, an explicit array dimension in
  `strerror`); the bugs themselves are still open.
- Exit-time flushing and `atexit`. Done, via weak symbols (the `.weak`
  support added to the in-tree assemblers and linkers; GNU as already has it). Each crt's `_start` makes a guarded call to a weak-*undefined*
  `__libc_fini` before it exits: the reference is a relocation that resolves to
  0 when no libc is linked (the call is skipped) and to libc's finalizer when
  one is. `libc/fini.c` supplies `__libc_fini` (run `atexit` handlers LIFO,
  then `fflush(NULL)`), `atexit`, and a strong `exit` that overrides the crt's
  now-`weak` `exit` so an explicit `exit()` flushes too. `fini.o` is
  force-linked (the driver and the libc test runner place it beside the crt),
  not archived, because the crt's weak reference does not pull an archive
  member. The weak-undefined reference is the key choice: it is always a
  relocation, so the shared crt gains no hard dependency and the non-libc tiers
  (moo, pascal, scheme) are unaffected (the reference stays 0). Pinned on all
  five targets by `tests/libc_phase_g.c` (a partial line plus two `atexit`
  handlers; the expected stdout is the flushed, reverse-ordered result).
- `setjmp`/`longjmp` and the coroutine machinery: investigate the synergy.
  `longjmp` saves and restores the callee-saved registers, the stack pointer,
  and the return address, which is a subset of what the stackful coroutine
  machinery already does in `runtime/start.S` (`save_ctx`/`restore_ctx`, the
  stackful context switch). A `setjmp`/`longjmp` pair is a one-shot,
  same-stack special case of that switch (no private stack, resume-once), so
  the per-arch register save/restore blocks could be shared rather than
  written twice. Worth a pass to factor the common context struct and the
  save/restore sequence so libc's `setjmp` and the coroutine runtime use one
  implementation per backend.
- `fscanf`/`scanf` over the read seam (needs a one-char `ungetc`), `fopen` of a
  real file (host-power dependent), a `math.h` subset, and `time.h` are later,
  consumer-driven additions.

## Coroutines

`include/coro.h` and `libc/coro.c` are a small stackful coroutine primitive:
`co_create`, `co_resume`, `co_yield`, `co_done`, `co_self`. A coroutine is a
function that suspends with `co_yield` and resumes where it left off, carrying a
`void *` across each switch; the body returns a final value the resume ending it
reports. It is the substrate a cooperative `threads.h` would sit on.

The primitive never allocates. The caller hands `co_create` one buffer and the
control block and the private stack are carved from it, so the coroutine lives
entirely in memory the caller owns (sized as `CO_OVERHEAD` plus the stack depth
the body needs). It is single-threaded: one coroutine runs at a time, tracked in
a file static, so no TLS and no locking. There is no guard page (this libc has
no mmap), so an overrun past the stack is undefined; `co_resume` checks a canary
just below the stack as a cheap smoke test, and the caller sizes the buffer for
the deepest call.

The one arch-specific piece is `co_switch(from, to)` over `struct co_ctx { void
*sp; }`, which saves the callee-saved registers on the current stack, swaps the
stack pointer, and returns on the switched-to stack. The rv/x86-64/arm64
switches are shared with the Kobold runtime (`runtime/co_switch_{rv,x86,arm64}.S`);
ColdFire and MIPS have their own (`runtime/co_switch_{cf,mips}.S`, saving
d2-d7/a2-a6/fp2-fp7 and $s0-$s7/$fp/$ra/$f20-$f31 respectively). `co.c` seeds the
private stack per target so the first switch lands in a trampoline that calls
the body. Each target's `co_switch` object is archived into that target's
`libc.a` (so a program pulls it only when it uses a coroutine). Pinned by
`tests/libc_coroutine.c` on every target through `check-libc`, and by `make
test-coro`, a host-only quick gate.

## On the donor libc

nyctos (a separate OS project) is 0BSD or Apache-2.0, some files CC0, all
original. That is permissive enough to adapt freely with no attribution or
header obligation. The reusable surface is small, roughly 300 to 350 lines:
the printf formatter engine (naive, no `%l`, no float, no precision, so it
needs extending), four string loops, and the crt1 skeleton pattern. There is
no malloc, no FILE, no errno, no math, no setjmp, and no mman, and the syscall
model is capability IPC that does not map onto a trap-based VM. The verdict is
a style template and a printf starting point, not a drop-in. The missing
pieces are built regardless, and skjegg's own soft64, softfloat, half, and
utf8 already cover the math side better than nyctos does. (A second donor,
jutan, was named but is not present under the home directory.)

## Toolchain prerequisites

Done: skj-cc predefines `__skj__` plus one target id (`__skj_m68k__`,
`__skj_riscv__`, `__skj_mips__`, `__skj_x86_64__`, `__skj_arm64__`) and the
data model (`__skj_lp64__` on the 64-bit targets, `__skj_ilp32__` on the
32-bit ones). They are set before the command line is scanned, so a user `-D`
still overrides them. The MIPS compiler builds gained `-DCC_MIPS` so the
target is explicit rather than a fall-through. A header can now size its types
and select per-target code from these macros.

Open, before Phase A: decide `_Bool`. Either add the keyword to the lexer so
`<stdbool.h>` is a real `_Bool`, or define `bool` in the header as
`unsigned char`. The first is cleaner and small.
