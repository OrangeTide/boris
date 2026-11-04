# Changelog

All notable changes to this project are recorded here, newest first, grouped by
month. Releases up to and including 0.12.0 are reconstructed from their git tag
notes; the detail there is shallower than for recent releases.

## November 2026

### 0.43.0

#### Changed
- `vendor.sh` builds the Kobold front end from `kpcom.pas` source for any
  target, in place of the single prebuilt x86-64 seed it used to ship. The
  Kobold component now vendors the Compact Pascal compiler and its host runtime,
  and the generated `skjegg.mk` builds `skj-pc` for the host and compiles
  `kpcom.pas` into a per-target `skj-kpc-<target>` (rv32, ColdFire, x86-64,
  arm64), each a host binary that emits its one target's KPM1. A consumer
  targeting a VM host now gets a correct-width front end built from source
  rather than a mismatched seed. The vendored host backend is x86-64; building
  on an arm64 host needs the arm64 selector vendored too.
- A MooScript verb call now carries a per-argument routing mask so a host bridge
  can place values into the verb's context. `__moo_verb_call` takes a new
  `typemask` argument, two bits per call argument (object, string, or anything
  else), letting the host route object and string arguments without guessing
  from the raw temporaries.

#### Fixed
- `vendor.sh` now ships the Kobold runtime glue that lives under `runtime/`
  (`rng_glue.c`, `sched_glue.c`, and the per-architecture `io_free_*.S`). A
  consumer building the freestanding Kobold runtime (the rv32 VM hosts)
  previously had to supply these by hand.

### 0.42.1

#### Fixed
- The host Pascal runtime build (`runtime/pascal_rt.c` with `-DPAS_HOST`) no
  longer warns about ignoring the result of `write()`, which the host libc
  marks `warn_unused_result`. Output now funnels through one helper that checks
  the result and advances over a short write; the freestanding paths share it
  too, so a partial write completes there as well.
- The PDF build of the runtime-layering manual page no longer fails: a few
  space-padded slash separators between inline code spans could wrap onto a
  line starting with a slash and a space, which the PDF typesetter reads as a
  term-list item. They are tightened so the manual's PDF target builds.

### 0.42.0

#### Added
- `make install` and `make uninstall` install the toolchain under a `PREFIX`.
  The `cc` driver resolves its runtime objects and headers relative to the
  installed executable, so an installed tree needs only `PATH` set, not a
  fixed layout.
- A host-served `proc:` pseudo filesystem exposes the `skj-run` sandbox
  process table. It is always mounted and read-only: the root lists one
  directory per live process (named by id) plus a `self` alias, and each
  `<id>/status` carries the process metadata the scheduler already tracks
  (pid, state, parent, retired instruction count, and exit code). A standalone
  `ps` tool reads it and prints the table. Content is generated on demand into
  a growable buffer, a reusable mechanism future pseudo files can build on.

#### Changed
- The hosted Kobold file and directory runtime now routes through the shared
  `fs/` layer in the in-process JIT and the ahead-of-time tiers too, completing
  the stream-primitive unification begun in 0.41.0. The dead native-libc branch
  is gone and the runtime layering, the shared bottom layer and its two
  deliberate seams, is documented.
- The three gdb remote-protocol stubs (RISC-V, MIPS, and the
  hardware-virtualization core) are factored onto one shared transport and
  watchpoint module, `emu/gdbstub.c`. Each stub is now a thin per-architecture
  adapter supplying a target vtable; behavior is unchanged.
- The RISC-V interpreter (`rv_run`) gains a decoded-operand cache and threaded
  (computed-goto) dispatch, about 9% faster on the kpcom self-compile.

#### Fixed
- The self-hosted C compiler build no longer requires `readlink` or `access`;
  `vendor.sh` ships `ir/exepath.h` and builds the vendored skjcc with its
  include path, so a vendored, self-hosted driver links.

### 0.41.0

#### Fixed
- The hardware-virtualization (HV) cores now park on a blocking syscall and let
  the scheduler run a sibling, instead of stalling the one host thread that every
  guest in a sandbox shares. A multi-guest HV program that pipes between its
  guests (the `jsh` shell and its coreutils running under KVM) no longer
  deadlocks when a reader waits on a writer, a writer fills a pipe, or a guest
  sleeps or yields. This also removes an intermittent hang in the HV test tier.
  The full-pipe write case is fixed on the emulated cores too.

#### Changed
- The hosted Kobold file and directory runtime is one shared source across the
  in-process JIT, ahead-of-time, and freestanding tiers, in place of three
  near-identical copies. Behavior is unchanged; only the per-tier differences
  (the allocation model and the filesystem-interpose seam) stay separate.

### 0.40.0

#### Added
- `vendor.sh` ships `setjmp`/`longjmp` in the per-target `libc.a`, so a vendored
  C program that uses them (the jsh shell) links.

#### Changed
- Host-native cross compilers are the default test path. The C in-process cross
  JITs that ran a compiler itself under qemu (`check-jit-rv`, `check-jit-arm64`,
  their disassembly siblings, and the arm64 JIT trap and high-memory tests)
  moved out of `check-all` into `check-emu-all`, matching what the Kobold side
  already does, so `check-all` now runs no compiler under emulation. The
  host-native `check-cc-rv` and `check-cc-arm64` keep the C corpus there.
- The Kobold tutorial (`doc/languages/kobold/kp-tutorial.md`) is reworked into a
  22-step path over the complete implemented language, each step a complete
  program verified under the in-process JIT (or the ahead-of-time path units and
  inline assembly require). New steps cover the scalar type set, constants,
  `case`, `out` parameters, overloading, forward declarations, nested routines,
  `with`, variant records, methods, dynamic arrays, open-array parameters, maps,
  string interpolation, `for`-`in`, properties, `defer`, failable routines,
  computed goto, units with the standard library, and the compiler directives.

#### Fixed
- The C compiler (`skj-cc`) folds three constant-expression cases in a
  file-scope or static-storage initializer that it previously got wrong, on
  every backend. `sizeof` of an expression operand no longer defaults to `int`
  (it was folding to 4); an array bound deduced from a string-literal
  initializer (`char x[] = "hello"`) is carried into the type, so `sizeof` is
  the string length plus the NUL rather than garbage; and an enumerator
  initializer evaluates the whole constant expression, so a computed enumerator
  (`1 << n`, `A | B`, a reference to a prior enumerator) is correct rather than
  0.
- A 9P frame-length integer overflow in both the server's batched message
  dispatcher and the `ninefs` client's reply cursor. A peer could choose a
  later frame's declared size to wrap past the 32-bit maximum and slip it past
  the length guard, reading past the buffer. Both now compare against the
  remaining length.
- A confined guest (one given any mount or grant) refuses the ambient
  `AT_FDCWD` syscall path, which previously let a hostile guest reach any host
  path with a raw `openat(AT_FDCWD, "/abs", ...)` despite the capability mounts.
- `hv_run` no longer arms the per-vcpu preemption timer or reads the fault PC on
  a null vcpu when hardware-virtualization startup failed, which crashed the
  whole `skj-run` process instead of degrading to a clean halt.
- Four correctness bugs across the RISC-V, MIPS and HV gdb remote stubs:
  single-step now checks write watchpoints; the register-write (`G`) packet
  reports an error on short or non-hex data instead of a false `OK`; a MIPS
  guest can be resumed after a trap; and the HV stub clears its sticky fault
  flag on resume, rather than reporting the same fault forever.
- Guest-side filesystem hardening. The romfs parser validates an untrusted
  image (every node's name, type, parent index and data range, with 64-bit
  arithmetic). ramfs fixes the unlink-while-open slot-reuse aliasing, an
  `int` write-offset truncation, a capacity-doubling overflow, and `rename` into
  a node's own subtree. ninefs enforces the target kind in `unlink` and `rmdir`.
- The scheduler records a child's spawner by handle, not by slot, so a
  reaped-and-reused parent slot is recognized and the orphan is reaped rather
  than leaked and falsely reparented; `wait` and `kill` ownership is exact
  across slot reuse.

### 0.39.0

#### Added
- The gdb remote stubs report the floating-point registers. The RISC-V stub
  advertises the 32 `f` registers and `fcsr` in its target description, the MIPS
  stub appends the 32 FP registers and `fcsr`/`fir` to its `g` packet, and the
  HV stub returns the x86-64 SSE / AArch64 SIMD register file, so a debugger can
  read float state on every tier, not only the integer registers.
- The gdb remote stubs honour write watchpoints (`Z2`/`z2`). A `watch`
  expression now stops the guest when the watched address is written, on the
  RISC-V, MIPS and HV stubs.
- A spawned child's fault backtrace is symbolized against the child's own ELF
  image, not the root process's. Each process keeps its own DWARF reader, so a
  crash in a program a guest spawned resolves to that program's file and line.
- Kobold gains `io.textfile`, a unit that provides the classic Pascal file
  verbs (`Assign`, `Reset`, `Rewrite`, `Read`, `ReadLn`, `Write`, `WriteLn`,
  `Eof`, `Eoln`, `CloseFile`) over the shared POSIX file seam, including a
  character-level `Read` built on a one-character look-ahead.

#### Changed
- Kobold console number output routes through the shared C-runtime formatters
  (`__fmt_udec` and `__fmt_greal` in `libc/numfmt.c`). The per-tier number
  formatting in `kp_io.c` is gone, so a Kobold program and a C program print an
  integer or a real the same way, with no libgcc 64-bit-divide or
  double-to-u64 helper pulled on the freestanding tier.
- The documentation set is swept current with the shipped debugger, the LP64
  migration, the shared number formatter, the ColdFire control-register decode,
  and the Pascal record field alignment.

#### Fixed
- Kobold console real output spells the non-finite values. A positive or
  negative infinity now prints as `inf` or `-inf` and a NaN as `nan`, rather
  than a garbage digit string from feeding a non-finite value to the finite
  formatter.
- The ColdFire core implements the `PULSE`, `WDDATA` and `WDEBUG` debug
  instructions instead of faulting on them, so code that emits them runs under
  the emulator.

### 0.38.0

#### Added
- Two in-tree ELF64 static linkers, `skj-ld-x86-64` and `skj-ld-arm64`, so the
  64-bit targets no longer need an external `ld`. They read the ELFCLASS64
  relocatable objects the in-tree assemblers emit, pull members from `ar`
  archives, and write a runnable `ET_EXEC`. Both share one ELF64 core over the
  existing layout engine, the script parser and the mapfile reader, differing
  only in the machine id and the relocation set: x86-64 patches absolute and
  PC-relative byte fields, while arm64 encodes the bit-packed instruction
  relocations (the 26-bit branch, the conditional branch, the ADRP page split
  and the ADD low-12). Executable addresses stay in the low 4 GiB, so the
  32-bit layout core is reused unchanged. `skjcc -target x86-64` and
  `-target arm64` now link with these, so the whole 64-bit compile-to-executable
  path runs on in-tree tools with no external assembler or linker.
- The scheduler can load a process-tree root from an in-memory ELF image, not
  only a file path. A host that already holds a guest executable in memory (a
  freshly built image, a buffer received over a connection) hands the bytes to
  `sched_add_root` through `image` and `image_len` on the root spec, and
  `skj-run --mem-root` drives it from the command line. This is the portable
  path a host reaches for instead of a non-portable in-memory file descriptor.
- Per-arch accessors for the CPU operation vtables (`skj_ops_rv32`,
  `skj_ops_coldfire`, `skj_ops_mips32`, `skj_ops_x86_64hv`, `skj_ops_arm64hv`),
  so a host embedding the scheduler can obtain a core's ops without reaching
  into emulator internals.

#### Fixed
- `skjcc -g` now emits debug information. The driver silently dropped `-g`
  along with the optimization and warning flags it does not forward, so a `-g`
  build through the driver produced a binary with no `.debug_*` sections at all,
  only symbol names. The flag now reaches the compile stage, so a driver-built
  `-g` program carries DWARF that `skj-addr2line` and a fault backtrace resolve
  to file and line.
- Compact Pascal record fields now align to their own natural boundary rather
  than to the target pointer width. On the LP64 targets (x86-64 and arm64) a
  4-byte `integer` field was aligned to 8, so a record of integers sized larger
  than it should and its field offsets diverged from the 32-bit targets. Each
  field now aligns to a power of two no larger than the field, capped by the
  `{$A}` alignment, so an integer field aligns to 4 on every target while a
  pointer, `Int64` or real still aligns to 8 where the ABI needs it.

#### Changed
- `vendor.sh` can ship more of the debugging tier: the gdb stubs, the symbolized
  fault backtrace and their docs, and `skj-addr2line` (the offline DWARF
  symbolizer) as a selectable `addr2line` component, so a consuming project can
  debug a guest and resolve a backtrace's addresses without the host toolchain.
- `vendor.sh` can ship the whole 64-bit C target. `--arch x86-64` and
  `--arch aarch64` select the LP64 cc backend (parallel to the 32-bit arches),
  `--with toolchain` adds the ELF64 assembler and linker (`as-x86-64`/`ld-x86-64`
  and `as-aarch64`/`ld-arm64`), and `--with runtime` stages the crt and
  varargs/`_Float16` helpers, so a vendored `skjcc -target x86-64` or
  `-target arm64` compiles, assembles and links C with no external toolchain.
  The runtime is self-hosted: the vendored build compiles the helpers with
  `skj-cc-*` and assembles them with the in-tree assemblers.

### 0.37.0

#### Changed
- The hardware-virtualization preemption timer is now per-vcpu, so several HV
  sandboxes can run at once, each on its own host thread. A compute-bound guest
  (one that never traps to a syscall) is bounded by a time-slice timer; that
  timer was a single process-global interval timer delivered to an arbitrary
  thread, so two sandboxes stomped each other's timer. Each vcpu now drives its
  own timer, targeted at the thread that runs it (a per-thread `timer_create` on
  Linux/KVM, a per-vcpu watcher thread on macOS/HVF). A host can run many
  sandboxes in parallel, one per connection, by calling the sandbox entry on its
  own threads. Single-sandbox behavior is unchanged.

### 0.36.0

#### Added
- The process scheduler is now a reusable, embeddable API. A host program can
  drive many sandbox process trees from its own event loop, each tree bound to
  its own input and output, which is what a shell server that runs one sandbox
  per telnet or websocket connection needs. `sched_init`, `sched_add_root`,
  `sched_step`, `sched_run`, and the wait and ready primitives are the surface,
  and `run_sandbox` is now a thin wrapper over them, so the command line behaves
  exactly as before. Each root carries its own argument vector, environment, and
  standard file descriptors.
- `skj-run --env KEY=VALUE` (repeatable) passes an environment to the guest. It
  reaches `getenv` on every target, little-endian and big-endian, 32-bit and
  64-bit, because the stack builder lays the environment pointers in the guest's
  own width and byte order. The default is still an empty environment, so an
  existing run is unchanged.
- The vDSO now runs on all three emulated cores. ColdFire and MIPS join RISC-V,
  and the x86-64 and arm64 hardware-virtualized guests already had it, so the
  feature now spans every target `skj-run` hosts. ColdFire is big-endian and
  MIPS little-endian, so the image loader and the system-page clock writer are
  proven in both byte orders.
- `vendor.sh` ships the vDSO image source and builds it for each emulated core
  whose toolchain is vendored, so a consuming project gets a working `--vdso`
  out of the box.

### 0.35.0

#### Added
- `skj-run --vdso IMG` injects a slice of runtime into every process, the way
  Linux hands a process its vDSO. The image is a small read-only block of pure
  leaf functions. The host advertises its export table through a private auxv
  tag, and the guest walks its auxv to find it and calls functions through an
  ordinal table. One image is built once and shared read-only across every
  sandbox: an emulated guest aliases the one host buffer through its software
  memory path, a hardware-virtualized guest backs a read-only hypervisor memory
  slot with it. A guest write faults, so one sandbox cannot corrupt the image
  another shares. Supported on the emulated RISC-V core and the x86-64 and arm64
  KVM/HVF guests.
- The vDSO image carries a system page the host keeps updated and the guest
  reads with no syscall or doorbell, in the spirit of a QNX system page: a
  monotonic and a realtime nanosecond clock the scheduler refreshes before each
  slice, the host page size and cpu count, and reserved room for more such
  state. A guest reads the clock through the vDSO functions or reads the page
  directly, whose address the export table carries.
- The `jsh` userland and its coreutils now run on the emulated MIPS tier too, so
  the shell runs on all five targets `skj-run` hosts: RISC-V, ColdFire, MIPS,
  and the x86-64 and arm64 hardware-virtualized guests. The MIPS runtime gained
  the `nanosleep` and `sched_yield` wrappers the shell needs.

### 0.34.0

#### Added
- `skj-run --mount-ro NAME:DIR` grants a confined host directory read-only, so a
  mutating operation returns `EROFS`. The `jsh` userland serves its tool images
  (`bin:`) this way, and the per-sandbox scratch uses the same capability path.

#### Changed
- The `skj-run` userland no longer carries an in-guest filesystem for its default
  mounts. `skj-run` owns them host-side through the confined capability path it
  already used for `--mount`: `scratch`, the spot a bare path resolves against,
  is an ephemeral host directory granted per sandbox, and `bin:` is served as a
  read-only host directory. The in-guest ramfs and romfs are now compile-time
  options (`FS_WITH_RAM`, `FS_WITH_ROM`) kept for the standalone VM tiers and
  bare-qemu, and are compiled out of the `skj-run` build. The guest fs code there
  is now just the mount switch and the hostcap adapter.
- The `jsh` userland links against a `libc.a` archive instead of a list of loose
  objects, so each program pulls only the archive members it references. With the
  host-owned filesystem, the coreutil set shrank about 65% (each fd-using tool
  from roughly 135 KB to 52 KB on RISC-V, and `sleep`, which opens no file, to
  under 5 KB).
- Each sandbox, whether the root or a spawned child, now gets its own fresh
  scratch directory. Scratch is never shared across the process tree, matching
  the per-process isolation the in-guest ramfs provided.

#### Fixed
- `run_sandbox` releases the root process's host fds and removes its scratch
  directory at teardown, not only a reaped child's.

### 0.33.0

#### Added
- A process model for the `skj-run` emulator: one sandbox per process. Four
  emulator-private syscalls build it up. `SKJ_SYS_SPAWNV` spawns a child from a
  size-prefixed descriptor in guest memory, carrying the child image, its argv,
  a flags word, and an fd map. `SKJ_SYS_WAIT` returns a child's exit status and
  reaps it. `SKJ_SYS_KILL` terminates a child by handle. `SKJ_SYS_PIPE` creates
  a host-backed pipe as two capability fds. Each spawned process gets its own
  guest memory and its own capability and filesystem view, so isolation is the
  default, not an accident. The spawn descriptor is a size-prefixed row of
  pointer-width words, so a single layout serves the ILP32 tiers (ColdFire,
  RISC-V, MIPS) and the LP64 tiers (x86-64, arm64).
- Mount and descriptor inheritance across a spawn. A parent hands a child its
  mount namespace (host and dev grants) and an fd map through the spawn
  descriptor, host-mediated so neither side marshals the other's private fd
  table. This is how a spawned command reaches the same files and how a shell
  wires a child's stdin, stdout, and stderr.
- A mini unix userland: the `jsh` shell plus coreutils (`cat`, `echo`, `ls`,
  `rm`, `sleep`, `cp`, `mv`), built as guest ELFs over skjegg's libc and the
  `fs/` layer. jsh resolves a bare command name in a romfs mounted at `bin:`,
  then spawns a fresh sandbox per command. With no fork and no exec, a redirect
  is "open the target and place its capability in the child's fd map", and a
  pipeline is a host pipe wired through the same map. It runs on all five tiers:
  ColdFire, RISC-V, and MIPS, and the x86-64 and arm64 hardware-virtualization
  tiers.
- The console descriptors (0, 1, 2) are bound into the one fd space as ordinary
  stream fds. Each sandbox owns its own duplicates, so close and inheritance are
  uniform with every other descriptor.
- LP64 `setjmp` / `longjmp` for the hardware-virtualization tiers (x86-64 SysV
  and aarch64 AAPCS), which the userland needs. [x86-64, arm64]

#### Fixed
- The LP64 initial stack the hardware-virtualization guests receive under-reserved
  its auxv by one slot pair, so the terminating entry could overrun the argv
  string area. Whether it corrupted an argument depended on alignment, so it
  struck only particular argv layouts. The reservation now matches the words
  written. [x86-64, arm64]
- The dynamic `mmap` area for a hardware-virtualization guest now stays inside
  the guest's RAM instead of starting at the paged default address, which lay
  past the end of that RAM. A rom mount, a 9P channel, a pipe buffer, or a guest
  `mmap` reached that address and faulted. [x86-64, arm64]

### 0.32.0

#### Added
- Cooperative yields for blocking guest syscalls in the `skj-run` emulator. A
  `read` on a would-block descriptor, `nanosleep`, and `sched_yield` now park
  the calling guest and hand the single host thread back to the scheduler, which
  blocks in `poll()` only when no guest can run. A blocking call no longer
  stalls the whole cooperative sandbox. The hardware-virtualization cores keep
  their plain blocking behavior. [ColdFire, RISC-V, MIPS]
- 9P request batching in the sandbox filesystem client. The hot `fs/` composites
  now cost one doorbell round trip each instead of two or three: `stat` /
  `size` / `exists` / `isdir`, `open`, `unlink` / `rmdir`, and `mkdir`. The 9P
  server processes a pipeline of framed messages on one session, so a `Twalk`
  and the operation on the fid it binds travel in the same round trip. A deep
  path past the 16-element walk limit keeps the stepwise path.
- `ROOT:` names the default root. Mount index 0 is the default root, and `ROOT:`
  (any case) selects it without a program having to know the real mount name,
  the DOS single-drive convention. It resolves only after an exact mount-name
  match fails, so it never shadows a mount actually named `ROOT`.
- `std.time` and `std.random` glue linked into the RISC-V and arm64 Kobold JITs,
  extending the hosted-tier coverage added in 0.31.0 to those JIT targets.

#### Fixed
- The 9P sandbox server now rejects a truncated request with `Rerror` instead of
  decoding its missing fields as zero and acting on them. Before, a short
  `Tclunk` clunked fid 0, a short `Tversion` reset the session, and a short
  `Twalk` bound a fid, all from malformed input.
- `skj-cc` grows its preprocessed-source buffer to 2 MiB, so a translation unit
  that embeds a large guest image as a byte array (the sandbox spawn demos)
  compiles again after the embedded Kobold child crossed 1 MiB.

### 0.31.0

#### Added
- Ordinal-keyed maps. A `map[K] of T` is keyed by an ordinal `K` (integer,
  int64, char, enum, or boolean) alongside the existing string-keyed `map of T`.
  Indexing, `in`, `Delete`, `TryGet`, `Length`, `MapFirst` / `MapNext`, and
  `for k, v in m` all work on both. The two are distinct types with distinct
  runtime representations, and value (copy-on-assign) semantics are unchanged.
- Handle-typed and aggregate-typed properties. A `property` may now carry a
  handle value (string, dynamic array, map, interface, or process) or an
  aggregate value (record, fixed array, or large set), extending the scalar
  properties shipped earlier. The accessor calls and uniform-access rules are
  the same.
- Extended inline assembly. The `asm(...)` statement accepts the GNU extended
  form `asm(template : outputs : inputs : clobbers)` in a simple subset: the
  general register class (`=r` output, `+r` read-write output, `r` input) over
  integer-class operands, plus a clobber list, with `%N` substitution in the
  template. The register allocator places each operand and reserves the
  clobbers. The basic verbatim form is unchanged. Ahead-of-time only.
- `std.time` and `std.random` link on the hosted AOT and JIT tiers, so `Now`,
  `Sleep`, and the random surface are available there as well as on the
  freestanding tiers.

### 0.30.0

#### Added
- Source-level debug information carried through the arm64 macOS toolchain.
  `skj-cc-arm64 -g` emits a DWARF 4 line table that `skj-as-aarch64` assembles
  into `__DWARF` sections and `skj-ld-aarch64` places in a `__DWARF` segment of
  the linked executable, inside the ad-hoc code signature. The table carries a
  multi-file file list, so a `static` function defined in a header is attributed
  to that header rather than the including source, and records source columns.
  Apple `dwarfdump` and `llvm-dwarfdump --verify` read it, and `lldb` resolves
  breakpoints and source lines against it.
- Full `make all` self-hosting on a Darwin arm64 host. Beyond the C toolchain,
  the Kobold front ends and the in-process JITs build and run natively on macOS
  with clang as the only external C compiler (no Apple `as`/`ld` and no cross
  tools); the Kobold AOT lane assembles with the in-tree `skj-as-aarch64`.

#### Changed
- The arm64 Mach-O linker emits dyld chained fixups (`LC_DYLD_CHAINED_FIXUPS`)
  in place of the classic bind and rebase opcode streams, and places the `__got`
  and the pointer-bearing const data in a read-only `__DATA_CONST` segment that
  dyld maps writable, fixes up, then protects.

#### Fixed
- C compiler `-g` line numbers were wrong for any translation unit with an
  `#include`: a statement was numbered by its position in the fully preprocessed
  stream, which counts the spliced-in header text, not by its source line. The
  preprocessor now records each emitted line's origin and the compiler numbers
  by it, so the line table is correct on every backend.
- `skj-as-aarch64` miscompiled a symbol spelled like a register, for example a
  function named `s8`: it was taken as the register, so a branch to it lost its
  target and an address calculation using it became a register operation.

### 0.29.0

#### Added
- A macOS Hypervisor.framework backend for the `skj-run` VMM, the peer of the
  Linux KVM backend. On an Apple Silicon host an arm64 guest runs natively under
  Hypervisor.framework, driven through the same backend-neutral VMM seam, syscall
  doorbell, and scheduler as the KVM path; the backend is chosen by the host OS.
- Native macOS (Mach-O) code generation and a complete in-tree Mach-O toolchain
  for arm64. `skj-cc-arm64` emits Mach-O-assemblable AArch64, `skj-as-aarch64`
  writes Mach-O `MH_OBJECT` relocatables, and `skj-ld-aarch64`, a new in-tree
  Mach-O static linker, lays out a PIE `MH_EXECUTE`: it resolves symbols, binds
  libSystem imports through arm64 stubs and a `__got` with dyld bind opcodes,
  applies the arm64 relocations, and self-signs with an ad-hoc SHA-256 code
  signature. The whole cc corpus and the computational libc phases compile and
  run natively on Apple Silicon through the fully in-tree pipeline (`skj-cc-arm64`
  then `skj-as-aarch64` then `skj-ld-aarch64`), with no Apple assembler or linker.
  Linking is hosted on libSystem.
- The Darwin AArch64 variadic ABI, on both the caller and the callee side: the
  variadic arguments of a call go on the stack, and a variadic function walks
  them there with no register save area, so C programs that call or define
  variadic functions build and run on macOS.
- macOS cc and libc test lanes, `check-cc-macho-arm64` and
  `check-libc-macho-arm64`, that compile, link, and run natively on a Darwin
  arm64 host through the in-tree toolchain and skip elsewhere.
- Host-architecture detection in the build, so a plain `make` on a non-x86_64
  host (arm64 Linux or macOS) builds the native in-process JITs and host tools
  for that architecture instead of the x86-64 ones.
- Documentation of the VMM sandbox prerequisites and setup for each platform and
  architecture.

#### Changed
- The AArch64 object format and ABI are fixed when a tool is built, not selected
  at run time (one binary per target): a native macOS build targets Mach-O and
  the Darwin ABI automatically, a cross build selects them with `-DSKJ_DARWIN`.
- The arm64 identity-MMU bring-up for the KVM backend brings the Linux x86-64 and
  AArch64 hardware-virtualization backends to full parity, so an AArch64 guest
  runs correctly under KVM on an AArch64 host.

#### Fixed
- The hardware-virtualization test targets skip cleanly, rather than failing,
  when `/dev/kvm` exists but is not accessible to the user.

### 0.28.0

#### Added
- A hardware-virtualization tier in `skj-run`: x86-64 and AArch64 guests run
  natively under the host hypervisor (Linux KVM today) instead of being
  interpreted, driven through the same process sandbox and scheduler as the
  emulated cores. The guest architecture equals the host's, so an x86-64 host
  runs x86-64 guests and an AArch64 host AArch64 guests; off a supported host
  the tier reports the VMM unavailable and fails cleanly. The VMM abstraction is
  backend-neutral, with the Linux KVM backend in place and a macOS
  Hypervisor.framework backend planned as a peer.
- The guest reaches the host through a syscall doorbell (one unbacked MMIO read
  carrying a Linux syscall in the platform's argument registers), so the whole
  freestanding C libc, string, formatted I/O, `malloc`, stdio, the math helpers,
  delimited continuations, cooperative threads, and file and directory I/O over
  the `fs/` layer, runs under the VMM, built by `skj-cc-x86-64` or
  `skj-cc-arm64` and linked with the hardware crt and the doorbell seam.
- A compute-bound guest under the VMM is preemptible. The hypervisor cannot
  count retired instructions, so the slice currency is wall-clock time: a
  periodic timer breaks into the guest every 10 ms, which keeps the round-robin
  scheduler fair and makes `--max-insns` bound a runaway guest.
- A GDB remote-protocol stub for the hardware-virtualization cores, served by
  `skj-run --gdb`: breakpoints, single-step, register and memory access over the
  same scheduler hook as the RISC-V and MIPS stubs, with the vcpu single-stepped
  through the hypervisor so guest memory is never patched.
- The `fs/` sandbox mount table is complete. A devfs backend (`null`, `zero`,
  `full`), a romfs backend (a read-only packed image), and a 9pfs backend (a
  9P2000 client over a transport) join ramfs and the confined host backend, each
  wired into the guest libc and the launcher through `--dev`, `--rom` and
  `--9p`.
- `std.threads`, a Kobold cooperative-thread unit that parallels C
  `<threads.h>`, over the shared runtime.
- `skj-as-x86-64` folds constant and label-difference expressions (for example
  `(end - start) * 4 + 1`), matching the GNU assembler byte for byte.

#### Fixed
- The guest `sched_yield` is routed through the host-platform seam. Its
  `#include <sched.h>` had resolved to the emulator's own scheduler header on
  the include path, so the C library prototype was never seen and the call
  compiled with an implicit declaration.

### 0.27.0

#### Added
- An in-tree MIPS I (R3000-class) user-mode core in `skj-run`, little-endian
  o32. It runs MIPS guests at parity with the RISC-V and ColdFire cores: the
  integer core, the Linux syscall surface, fault reporting with a symbolized
  DWARF backtrace, and the COP1 floating-point unit (single and double
  precision, the condition flag and rounding modes) that the hardware-float
  MIPS backend targets. The MIPS toolchain now self-hosts under `skj-run`, not
  only under qemu: the in-guest compiler builds a program through the sandbox
  syscalls and emits assembly byte-identical to a qemu run.
- The MIPS process sandbox: guarded `mmap`, `munmap` and `spawn`, a round-robin
  scheduler and a shared memory budget, at RISC-V parity.
- A confined `fs/` capability filesystem libc for MIPS: named mounts, the
  `hostcap` backend and `--mount` grants, matching RISC-V and ColdFire.
- A GDB remote stub for MIPS (`skj-run --gdb PORT`), the sibling of the RV32
  stub: registers, memory, breakpoints, continue, step and the fault signal
  over the remote-serial protocol.
- Numeric local labels (`1:` with `1f` and `1b` references) in `skj-as-mips`,
  and a wider encoding golden corpus checked against GNU `as`.
- Selection axes for `vendor.sh` (`--arch`, `--frontend`, `--with`) and a
  packaged `sandbox` component that builds a confined hosted libc. A vendored
  tree now builds the crt, driver and confined libc and runs a confined guest
  end to end. `make check-vendor` vendors the checkout and proves it, as a CI
  smoke test.

#### Changed
- The process sandbox and scheduler are one arch-neutral implementation
  (`emu/sched.c`) driven through a CPU-handle vtable, shared by the ColdFire,
  RISC-V and MIPS cores, in place of the earlier per-core copies.
- The ColdFire and MIPS cores use a standardized batched run-with-reason loop
  and a reserved host-call selector for cooperative yield, matching RISC-V.

#### Fixed
- `skj-as-mips` encodes the REGIMM `bgez` and `bltz` branches.

### 0.26.0

#### Added
- `skj-as-x86-64`, an in-tree x86-64 assembler. It reads GNU `.intel_syntax
  noprefix` and writes ELF64 relocatable objects, and is now the default
  assembler for the x86-64 toolchain, so a build no longer needs `nasm`.
- `skj-as-aarch64`, an in-tree AArch64 assembler. It reads the native GNU
  AArch64 assembler syntax and writes ELF64 relocatable objects, and is now the
  default AArch64 assembler, so assembling the toolkit's own AArch64 output no
  longer needs an external assembler.
- Inline assembly in TinC (`asm("text")`) and Kobold (`asm('text')`), joining
  the C front end. The one string literal is emitted verbatim into the generated
  assembly; there are no operand constraints and no interpolation. Inline
  assembly is ahead-of-time only, since the in-process JIT does not assemble
  text.

#### Changed
- The x86-64 code generators and the hand-written x86-64 runtime now emit GNU
  `.intel_syntax` assembly. `nasm` is retired: it is no longer used by the
  build, the test suite, or CI.
- The JIT reports a program that uses inline assembly with a clear message that
  it must be compiled ahead of time, instead of a misleading "unresolved
  symbol".

### 0.25.0

#### Added
- A `writev` wrapper on the shared freestanding syscall seam (number 66 on
  RV32, 146 on ColdFire) with `struct iovec` in `<sys/uio.h>`. The buffered
  stdio core uses it to send a stream's pending buffer and a large `fwrite`
  block in one call on the freestanding tiers, instead of draining the buffer
  and then the block as two writes. The other targets fall back to two `write`
  calls, which is still fewer syscalls than the character path. The deliberately
  unbuffered Kobold console is unchanged.
- The skjegg/boris hosting contract, `doc/skjegg-kobold-requirements.md`. It is
  the authoritative handoff: the raw Linux RV32 syscall seam skjegg commits to
  (kept at the real Linux numbers), the name-bound host-call seam boris owns, and
  the status of boris's follow-on wishlist. It records that full hosting of the
  compiler and toolchain inside the rv32 sandbox is confirmed, proven in-tree by
  `make check-kp-free`.

#### Changed
- Pointer width now derives from one axis. The `KP_LP64` build macro is gone;
  whether a tool is LP64 or ILP32 follows from its instruction-set selector
  through the single `SKJ_LP64` fact in `ir/target.h`, so a tool can no longer
  name a 64-bit backend yet stay ILP32, the mismatch that once bit the Kobold
  JIT. On AArch64 every build is LP64, so the backend now uses a uniform 64-bit
  integer-register home unconditionally rather than a per-build opt-in, which
  also lets the arm64 C JIT map its guest memory anywhere instead of only in the
  low 32-bit address space.

### 0.24.2

#### Fixed
- The continuous integration job that proves the compiler is independent of its
  build compiler now installs `nasm`. With the committed seed gone, that job
  rebuilds the reference RISC-V seed from source, which assembles the x86-64
  front end's NASM output, so it needs `nasm` as well as Free Pascal.

### 0.24.1

#### Fixed
- A clean build of the `bootstrap-fpc` path failed with `version.h: No such
  file or directory`. The `skj-pc` LP64 host variants (`skj-pc-x86-64` and
  `skj-pc-arm64`) compile a source that includes the generated `version.h` but
  were not registered as needing it, so a build that reached them without
  building the main tool set first (as `bootstrap-fpc` does when it generates
  the RISC-V seed from source) did not generate the header in time.

### 0.24.0

#### Added
- Per-architecture Kobold host front ends. Alongside `skj-kpc` (x86-64) there
  are now `skj-kpc-rv`, `skj-kpc-cf`, and `skj-kpc-arm64`. Each is the Kobold
  compiler built for one target: it accepts source and emits a module for that
  target only, the way the C compiler has one tool per target.

#### Changed
- A Kobold unit module (`.kpm`) now records its target architecture on the
  `.target` line (`rv32`, `cf`, `x86-64`, `arm64`), and the backend rejects a
  module built for another architecture. A unit carries IR, native code, and
  type definitions bound to one target, so it was never portable between
  architectures; the reader now enforces that instead of checking pointer width
  alone.
- The Kobold compiler no longer ships a committed bootstrap seed. Each
  architecture's seed is generated at build time from that architecture's front
  end, and `vendor.sh` generates the seed when it copies the compiler into a
  consumer project.
- Removed `skj-kpc-32`, the shared front end that emitted one module fed to both
  the RISC-V and ColdFire backends. RISC-V and ColdFire builds use their own
  per-architecture front ends.
- The documentation now states that Kobold source uses `.kp` and Compact Pascal
  uses `.pas`, with `kobold/kpcom.pas` (the self-hosting compiler, valid in both
  languages) the one dual-compilable exception.
- The libc file-operation diff tests compare against a native host oracle rather
  than a fixed expected file.
- Test scratch directories are isolated per mode and per runner so a parallel
  `make -j` run does not let one target's modules clobber another's.

#### Fixed
- A coroutine value word is width-tagged, so a coroutine that carries a 64-bit
  or pointer value through `yield` and resume is handled correctly on every
  target.

### 0.23.0

#### Added
- A shared `fs/` filesystem layer: a flat, DOS-style mount table of named
  namespaces (not a VFS), with a `ramfs` backend and a tier-portable
  multi-instance `hostfs` backend. It builds freestanding for the guest and is
  shared by the C libc and the Kobold runtime, so both reach files through one
  mount table and namespace model.
- A sandbox fd table in skj-run: each guest gets its own fd table, so host file
  descriptors never leak to the guest. A `--mount name:hostdir` grant opens the
  host directory as a capability and populates the guest's `fs/` mount table.
- A confined capability host backend for the freestanding guest. A `--mount`
  grant is a capability directory fd, and every open is confined beneath it:
  kernel-enforced with `openat2(RESOLVE_BENEATH)` on Linux, a portable
  component-walk (`cap_walk`, which also refuses in-tree symlinks and any `..`)
  on other POSIX hosts, and failing closed on a host with neither.
- macOS and other non-Linux host support for skj-run. The host-varying
  facilities sit behind the `emu/hostplat.{c,h}` shim (confined opens, directory
  enumeration, clock, sleep, random), the only file that branches on the host
  OS. `make macos` builds the emulator with the stock host compiler, no cross
  toolchain or qemu required. The Darwin code paths are written but not yet
  exercised on a real machine.
- A `check-slow` target for the heavy in-guest self-compiles (a full C
  translation unit and kpcom's own source compiled under the interpreter), split
  out of `check-all` so the routine suite stays fast.

#### Changed
- Scratch `ramfs` is now the default landing for a guest with no mount grant;
  the ambient host backend is opt-in (`FS_AMBIENT_DEFAULT`), a temporary
  convenience for the qemu harnesses that have no launcher.
- The freestanding file I/O for the rv32 and ColdFire C libc and the Kobold
  runtime now routes through the shared `fs/` layer instead of raw syscalls.
- skj-run's host-platform code is a pure-POSIX floor with a single Linux
  accelerator: directory enumeration, clock, sleep, and random bytes (through
  `/dev/urandom`) are shared POSIX across all hosts, and the one host branch is
  the `openat2` confinement accelerator over the portable `cap_walk`.
- On an x86-64 Linux host the x86-64 test suite runs the target binaries
  natively instead of under `qemu-x86_64`. Set `QEMU_X64=qemu-x86_64` to force
  the emulator.

#### Fixed
- skj-cc dropped the return type of a call whose callee was not a plain
  identifier (a struct or union member function pointer, an array element, a
  dereference, or a cast), so an `int64_t`, `float`, or struct return through
  such a callee was silently narrowed to a 32-bit `int`. A member function
  pointer returning `long long` came back as its high word alone. The call now
  keeps the callee's declared return type.

### 0.22.0

#### Added
- Kobold `defer`: `defer <statement>` registers block-scoped teardown that runs
  in last-in-first-out order on every orderly exit from the enclosing block,
  including a `return`, a `break` or `continue` that leaves the block, and a
  failable divert. It does not run when a trap aborts the program.
- Kobold `${}` string interpolation: a double-quoted string literal `"..."`
  interpolates `${expr}` holes, converting each expression to text in place; the
  single-quoted literal `'...'` is unchanged. Write `$${` for a literal `${`.
- Kobold `for`-`in` loops: `for x in seq do` walks the elements of a sequence
  directly, binding each to a pre-declared loop variable. The sources are a
  fixed or dynamic array, a string (over its bytes, each bound as a `char`), a
  set (members in ordinal order), a map (`for k, v in m do`, binding the key and
  the value), and any custom cursor type with a `function Next for (c): E fails`
  method, where a failure ends the iteration. Bind `_` to ignore an element.
  Array, string, and set loops lower to the counted loop with no iterator object
  and no per-element call.

#### Removed
- The Excelsior front end (`skj-exc`) and its runtime are removed. Excelsior was
  an in-progress scripting language that had converged with Kobold on its core
  runtime model, and no target host consumed it. Its distinct surface features
  (`defer`, `${}` interpolation, and `for`-`in`) are now part of Kobold, so the
  front end carried no capability Kobold lacks. The removal also drops the
  Excelsior smolmoo host binding and its demo link.

### 0.21.0

#### Changed
- The TinC and TinScheme compilers and the in-process C JIT now use a native
  64-bit pointer model (LP64) on x86-64 and AArch64, retiring the
  32-bit-on-64-bit guest model on those targets. Every front end is now LP64 on
  the 64-bit targets, in line with the C and Kobold compilers; RISC-V RV32,
  ColdFire, and MIPS stay 32-bit (ILP32). The in-process C JIT maps its guest
  across the full address space. Pointer width is unified on a single axis that
  derives from the target instruction set, so a tool can no longer be built with
  a 64-bit code generator yet a 32-bit pointer model.

### 0.20.0

#### Added
- Kobold standard-library units: `core.convert` (failable string-to-number
  `ValInt`/`ValReal` over the `Val` builtin), `io.files` (file metadata and path
  operations), and `io.buffered` (userland buffering).
- The RISC-V in-process JIT compiles GNU `&&label` label values and the computed
  `goto *p`, so threaded-dispatch programs run on the RV JIT as they already did
  on the x86-64 and AArch64 JITs.

#### Changed
- Kobold uses a native 64-bit pointer and handle model (LP64) on x86-64 and
  AArch64; RISC-V RV32 and ColdFire stay 32-bit (ILP32). This retires the
  32-bit-on-64-bit guest model on the 64-bit targets, so the JIT and AOT
  runtimes use the full address space there. `kpcom` bakes the pointer width in
  at build time and emits a module for that width class.
- A KPM module records its pointer-width class on the `.target` line
  (`ilp32`/`lp64`), and the backend rejects a module whose width does not match,
  instead of silently truncating pointers.
- Kobold console I/O is single-sourced over a POSIX file descriptor, and the C
  and Kobold freestanding runtimes share one break-based heap bump, shrinking the
  duplicated runtime surface.

#### Fixed
- A negative 32-bit `or else` fallback into a 64-bit result (`Int64` or real) is
  sign-extended rather than zero-extended; on a 64-bit backend `or else -1` had
  read back as a large positive value.
- A `label` (a threaded-dispatch code address) is sized at pointer width, so a
  stored `@label` keeps its full address when the JIT maps guest code high.
- The C compiler loads a narrow scalar local at its own width.

### 0.19.0

#### Added
- A major Compact Pascal expansion that brings the front end far enough to
  compile and run the Kobold compiler's own source (`kpcom.pas`). The in-tree
  acceptance suite compiles 88 corpus programs through the Pascal front end with
  byte-identical output, and the host test suite passes 209 programs.
- Pascal numeric and layout support: `Int64` with a scalar type-size layer, and
  `Real`, `Double`, and `Single` floating point. A host AOT pipeline and an LP64
  pointer-width layer build native x86-64 executables.
- Pascal heap strings: an `ansistring` representation with reference-counted
  assignment, reference-counted aggregate string members, scope-exit release
  under a leak gate, and in-place self-append.
- Pascal aggregates and routines: scalar and managed-element dynamic arrays,
  open-array parameters, nested dynamic arrays, registered enum types with
  ordinal `High`/`Low` and enum-indexed arrays, `out` parameters, overloading by
  arity and type, and typed constant aggregates with string members.
- Pascal host and build integration: external `cdecl` host imports,
  `ErrOutput`/`Output` stream selection with `Flush`, `{$I file}` include
  splicing, and `ParamStr`/`ParamCount` command-line access.
- A `make help` target that prints the common targets plus the full
  `check-*`/`test-*` catalog, generated from the Makefile so it stays complete.

#### Changed
- The Kobold compiler is documented as self-hosting inside the sandbox: `kpcom`
  runs as an RV32 or ColdFire guest ELF under `skj-run` and reproduces the host
  compiler's output byte for byte, including its own full source.

#### Fixed
- Several Pascal codegen correctness fixes surfaced by compiling `kpcom.pas`:
  call arguments evaluate right to left (FPC order), an indexed-store r-value is
  evaluated before its address (a reallocation hazard), nested-function frame
  corruption and integer `not`, and the string result of `Exit(value)` is
  retained.

### 0.18.0

#### Added
- Kobold can express both classic bytecode-dispatch shapes in the language. A
  procedural value may now be called through a computed designator
  (`table[i](args)`), which is the direct-threaded loop, and a new second-class
  `label` value type with the `@label` address-of operator and a computed
  `goto <expr>` is the indirect (token-threaded) inner loop. A bare
  `goto name` stays a compile error, so general structured goto remains omitted.
- The `label` value is statically second-class: it can only be made from a
  label in the current routine and stored in that routine's own frame, never in
  a global, a field, a return, a parameter, or a collection. A computed jump can
  therefore only land in a live frame, closing the escaping-label-address
  footgun without any runtime check.
- skj-cc gains the GNU C extensions labels as values (`&&label`) and computed
  goto (`goto *expr`), reusing the new dispatch IR opcodes, so a C bytecode
  interpreter can thread its inner loop on every backend.
- Two shared-IR opcodes carry threaded dispatch across all backends:
  `IR_LABADDR` (the address of a local code label) and `IR_IJMP` (an indirect
  jump through a register), with 64-bit twins for the LP64 C targets.

#### Changed
- ColdFire guest faults in the emulator are symbolized through DWARF line info,
  so a trap reports source file and line rather than a bare address.

### 0.17.0

#### Added
- The freestanding Kobold tier gains real number I/O and random units: io.console
  `ReadReal`/`WriteReal` and `ReadInt`/`WriteInt`, and std.random `RandomReal` and
  `SecureRandom`, reached through units with no change to the compiler.
- C guests can draw from the shared random generators. `rand`/`srand` and the BSD
  `arc4random` family (`arc4random`, `arc4random_buf`, `arc4random_uniform`) now
  run over the same xoshiro128** fast generator and ChaCha20 CSPRNG that Kobold's
  std.random uses.
- ColdFire gains the time, RNG, and yield syscall seam (`clock_gettime`,
  `getrandom`, `nanosleep`, `sched_yield`), matching the RV32 freestanding tier.
- A manual for the toolchain itself (the pipeline, the drivers, the assembler and
  linker, the targets and ABIs, building and vendoring), grammar references in the
  C and Compact Pascal language manuals, and a doc/abi note for the shared
  freestanding syscall seam.
- An rv32 guest fault now prints the integer register file at the trap point, and
  a backtrace that walks into unknown code is trimmed with a truncation marker
  instead of printing garbage frames.

#### Changed
- The C and Kobold freestanding runtimes share one bottom layer: a single `_start`
  and argv contract, one libgcc-free number formatter behind both libc `printf`
  and the Kobold numeric I/O, and the syscall-wrapper and `*at` prototypes
  collected in the libc headers instead of per-file externs.
- The x86-64 hand-written crt stacks are marked non-executable, clearing the
  linker's `.note.GNU-stack` warning.
- The Kobold reference manuals now describe the current language and compiler
  rather than the history of how the design was reached; the settled rationale is
  kept in a source-tree decision log (`kobold/DECISIONS.md`).

#### Fixed
- ColdFire file operations: big-endian `statx` and `getdents64` decoding, with
  ColdFire file-op test coverage to match the RV32 tier.

### 0.16.0

#### Added
- In-guest self-hosting: the whole skj toolchain (skj-cc, skj-as, skj-ld, and
  skj-kpc, the Kobold compiler) builds and runs as guest ELFs under skj-run on
  RV32 and ColdFire. The Kobold compiler self-compiles in-guest and its output
  matches the host byte for byte. New opt-in `make` targets prove each stage.
- skj-ld reads objects without mmap under the guest libc, and fchmodat/chmod
  were added to the emulator and the libc so the linker runs in-guest.

#### Changed
- The compiler does about 3.8x less work when self-compiling, with byte-identical
  output. EmittedRoutineName's overload scan is resolved once per routine instead
  of per call site, LowerStr builds its result in place, symbol comparisons use
  the precomputed lowercase name, and a no-allocation SameTextCI serves the
  parser's case-insensitive checks.
- skj-run caches store write permission in a page directory parallel to the main
  one, so a store to a committed writable page skips the per-access region check.

#### Fixed
- skj-cpp collects function-like macro arguments split across source lines.
- skj-as: a use-after-free in the lexer-rewind peek.

### 0.15.0

#### Added
- Kobold standard-library units with dotted namespaces (the core, io, std,
  experimental, and kobold tiers) and a `uses ns.*` wildcard. Runtime services
  (RNG, clock, sleep, console I/O, files) are now reached through units rather
  than compiler builtins. Adds the core.strings unit and a typed read/write
  surface for io.console.
- boris runtime glue (A1-A7): a freestanding heap backed by brk, a 32-bit
  xoshiro128** RNG with seed-driven and pure generators, a clock_gettime and
  getrandom sandbox seam, Sleep/Yield over nanosleep, a sticky EOF latch for the
  freestanding console, and the guest trap ecall aligned with boris VM_SYS_TRAP.

#### Changed
- Strings carry a byte capacity and grow in place: the self-append idiom
  `s := s + e` and left-leaning concat chains lower to amortized in-place appends
  instead of allocating and copying the whole left operand each step.
- A one-character string literal is accepted where a char argument is expected.

#### Tooling
- `check-kp-corpus-san`: the Kobold corpus under the GH_POISON guest-heap
  instrument plus ASan and UBSan.

### 0.14.0

#### Added
- Guest file I/O: openat and real lseek in the sandbox; whole-file and
  line/stream handles through a Kobold `files` unit; stat/fstat via statx across
  rv32, ColdFire, MIPS, x86-64, and arm64; directory reads via getdents64 with a
  `dirs` unit; and mkdir, rmdir, unlink, rename, and remove over the *at syscalls.
- One buffered-stdio core and one syscall seam shared between the C libc and the
  Kobold runtime; open/close/lseek on every C crt; open_memstream; and sbrk
  backed by real brk on ILP32 so a full translation unit self-hosts.
- DWARF for ColdFire and MIPS, with the serializer and reader parameterized by
  endianness; abort and assert are symbolized like a fault.
- skj-cc self-hosts under skj-run on RV32, filling the libc and runtime gaps it
  hit, and `-h`/`--help` is recognized uniformly across every skj-* tool.

#### Changed
- skj-as defaults to 32-bit long-form branches, with `-mshort-branches` to opt
  out, and gains an `.include` directive.

#### Fixed
- A Kobold string release-after-free in kpcom's IsOwnedExpr, found with the new
  GH_POISON instrument.
- cc/backends: a `%ld`/int64 vararg bug and continue inside a switch.

### 0.13.0

#### Added
- A source-level debugger for the toolchain. Source position is carried through
  the IR for `-g` across every front end (C, Pascal, MooScript, TinC, Excelsior,
  Kobold). A DWARF 4 `.debug_line`/`.debug_info`/`.debug_abbrev` serializer;
  skj-as-rv and skj-ld-rv build, carry, and relocate the `.debug_*` sections and
  emit sized STT_FUNC symbols; a shared DWARF reader with skj-addr2line; a
  zero-allocation frame-pointer backtrace that skj-run uses to symbolize faults;
  a GDB remote-protocol stub in skj-run (`--gdb PORT`); and skj-dbg, an
  interactive source-level debugger over that stub.

#### Changed
- Vendored trees copy the usage docs for each selected tool and language.
- CI runners are pinned to ubuntu-24.04.

### 0.12.0

#### Added
- Freestanding RISC-V guest runtime that builds with the skj toolchain alone:
  skj-as-rv gains the tail pseudo and skj-ld-rv resolves it, so no binutils or
  external riscv32 gcc is needed.
- Linker map output (`-Map`) for skj-ld, skj-ld-rv, and skj-ld-mips, listing
  memory regions, output sections with input contributions, and symbols by
  address.
- Kobold dialect features: properties, failable methods with wide results (real,
  int64, record), a set as a dynamic-array element and a map value, real and
  single-precision constants, and string case selectors.
- Near clean-room Kobold specification: static and dynamic semantics, a built-in
  routine signature reference, the host ABI across all four backends, and the
  KPM1 fingerprint and IR opcode reference.

#### Changed
- skj-cc models const qualifiers in its type system, distinguishing
  `int * const` from `const int *`, and rejects a braced scalar initializer with
  the wrong element count.
- Const globals and static-const locals are placed in `.rodata` on all five
  backends. skj-as gains a `.rodata` section for ColdFire, and an uninitialized
  const stays in `.bss`.

#### Fixed
- Integer divide by zero traps cleanly on rv32 and ColdFire, and `INT_MIN / -1`
  (signed division and modulo) traps on every backend, matching the documented
  exit-70 fault semantics.
- The KPM1 reader rejects a slot-less MARK or CONT_UNWIND instead of reading out
  of bounds.

#### Tooling
- A Kobold conformance corpus pins the documented semantics and runtime fault
  exit codes. ColdFire reaches full corpus parity as a backend
  (check-kp-corpus-cf) over the hosted libkpaot-cf.a.

### 0.11.0

#### Added
- Kobold on the ColdFire VM: skj-kp-cf compiles modules ahead of time, and a
  freestanding no-libc runtime (libkpaot-cf-free.a) provides guest file I/O, a
  link script, coroutine support, and the 64-bit and transcendental helpers.
- Extended inline assembly with outputs, inputs, and clobbers on all five
  backends (ColdFire, RISC-V, x86-64, AArch64, MIPS), with integer
  register-class constraints, operand pins, and MIPS named-register pins for
  syscalls.
- Overflow-checked add, subtract, multiply, and negate in the backends, each
  with a per-site trap target. Excelsior traps on integer and decimal overflow.
- Near clean-room Kobold language reference: static and dynamic semantics, a
  built-in routine signature reference, the host ABI across all four backends,
  and the pinned KPM1 interface fingerprint.

#### Changed
- The self-hosting seed is backend-neutral and endian-neutral, so one seed
  serves the big-endian ColdFire target.
- The fails-test error binder is scoped to its branch.
- skj-run provides host file open, read, and close for guest file I/O, and
  asm_lex accepts `$` in symbol names on non-MIPS targets.

#### Fixed
- Integer divide by zero traps cleanly on rv32 and ColdFire, where it previously
  returned a wrong answer or raised a raw SIGFPE.
- The most-negative integer divided by -1 (and the matching modulo) traps
  OVERFLOW on every backend.
- A ColdFire call-argument liveness bug and a 64-bit compare bug in the register
  allocator are fixed.
- The C compiler initializes a local char array from a string literal, and the
  lexer skips GNU `__attribute__`.

#### Tooling
- New `check-kp-corpus-cf` (full Kobold corpus on ColdFire under qemu-m68k) and
  `check-kp-free-cf` (freestanding AOT path on skj-run) targets, plus a
  conformance corpus that pins value semantics and the exit-70 fault code.

### 0.10.4

#### Fixed
- skj-cpp: `__FILE__` expansion overflowed a fixed 64-byte buffer, so a long
  source path was truncated and left an unterminated string literal.
- MIPS: the crts define `__start` so the linker enters at `_start`, the runtime
  builds with the backend's `-mno-abicalls -fno-pic -mfp32` flags, and the
  encoding golden master tolerates trailing section-alignment padding.
- cc: `expect()` parse errors name the file, the tokens, and the context, while
  keeping the pinned "parse error at line" text.

#### Tooling
- CI: the mips and rv32 jobs install the toolchains they need, and the matrix
  runs on `test/**` branches for pre-release dry runs.

### 0.10.3

#### Fixed
- MIPS runtime objects build with `-mfp32`, which the Debian mipsel-linux-gnu
  cross requires.
- The rv32 lockstep and fuzz harnesses compare the full 64-bit f-register,
  including the single-precision NaN-box, now that the core is FLEN=64 like qemu.
- The fuzzer NaN-boxes its single-precision seeds so fuzzed single-precision ops
  run on real values. No core bug was involved.

### 0.10.2

#### Fixed
- tests/test_rv_fp.c NaN-boxes its single-precision operands for the FLEN=64
  f-registers.
- The instruction-count baseline is re-accepted for the intended codegen
  changes, and `exc_walker_test` builds for the gate so an accept no longer drops
  it.

#### Tooling
- The build and mips CI jobs point MIPS_CC (and, for build, MIPS_OBJCOPY) at the
  Debian mipsel-linux-gnu cross. The rv32-reference job installs the riscv cross
  its guest ELF needs.

### 0.10.1

#### Fixed
- tests/test_rv_fp.c NaN-boxes its single-precision operands for the FLEN=64
  f-registers, so the emulator suite passes. The emulator core was correct.

### 0.10.0

#### Added
- A freestanding and hosted C standard library: string, ctype, printf, stdlib, a
  boundary-tag malloc family over a `__libc_sbrk` seam, buffered stdio, errno,
  float conversions, and strtod/sscanf and related functions.
- A stackful coroutine primitive (`co_create`/`co_resume`/`co_yield`) and a
  cooperative C11 `threads.h` subset built on it. The hosted libc, coroutines,
  and threads ship vendorable with the skjcc cross driver.
- skj-cc: by-value struct passing and return on RISC-V, ColdFire, and MIPS o32,
  C99 compound literals, anonymous struct and union members, `_Bool`,
  `_Static_assert`, and `_Generic`.
- skj-cc constant initializers: float and double statics, symbol-plus-addend
  pointers, aggregate leaves, and zero-filled globals in `.bss`.
- RV32 emulator: the D (double) extension, so double-precision guests run under
  skj-run.
- Kobold: `or else` recovers managed results, and `map of T` is structurally
  compatible.
- Documentation: a C language reference, a C standard library design note, a
  Kobold guide, and the Skjegg manual as a GitHub Pages site.

#### Changed
- The in-tree linkers read `ar` archives and pull only the members that resolve
  an undefined symbol. Weak symbols are supported across the assembler and both
  linkers, and the assembler encodes `negx`.

#### Fixed
- Code generation bugs found by a cross-backend differential torture corpus
  (host gcc as oracle against every skj backend, the emulator, and the JIT),
  including unsigned and 64-bit compound assignment, a `long long` switch control
  value, ColdFire signed and unsigned modulo, and the `*p++` load width.

### 0.9.0

#### Added
- C compiler (skj-cc): variadic functions on every target through a real
  `<stdarg.h>`, with per-ABI varargs helpers. The RISC-V varargs convention is
  self-consistent for skj-to-skj calls only and does not interoperate with gcc
  callers.
- Kobold is a first-class in-tree front end (moved to `kobold/`), with `-o`
  output on both the JIT and AOT compilers and a freestanding RV32 guest runtime
  tier that has a versioned entry ABI.
- Cross-language RV32 process sandbox demo, where a C root spawns both a C child
  and a Kobold child under a shared budget.
- Fuzz harnesses for the preprocessor, the KPM1 reader, the assemblers, and the
  TinC, Pascal, MooScript, cc, and Excelsior parsers, plus a code-generator
  coverage harness and a cross-backend differential torture test.

#### Changed
- C compiler: full integer promotions and usual arithmetic conversions,
  nested-brace initializers for local aggregates with incomplete-array
  inference, string literals typed as `char[len+1]` so `sizeof` measures storage,
  and a fix for reversed multidimensional array dimensions.
- Sanitizers (ASan and UBSan) now cover every front end, the archive tool, and
  the Kobold corpora. The undefined behavior they surfaced is fixed.
- The vendored tree ships `<stdarg.h>` and bakes the default include path into
  every cc tool.
- CI runs the MIPS, emulator, RV32-reference, and conformance tiers.

### 0.8.0

#### Added
- Kobold front end: a sixth front end that reads the KPM1 text module emitted by
  its self-hosting compiler, with an in-process JIT (x86-64, plus RV32 and
  AArch64) and an ahead-of-time compiler (RV32 and AArch64). It includes a guest
  runtime for strings, dynamic arrays, maps, coroutines, and refcounted handles.
- Multi-unit ahead-of-time linking with cross-module calls through ordinary
  external linkage.
- A deterministic instruction-count benchmark in `check-emu-all`, so changes in
  generated-code size are caught.

#### Changed
- Integer overflow traps on both the Kobold JIT and AOT paths.
- The KPM1 reader validates its input, including out-of-range operand indices.
- x86-16 is dropped as out of scope, and PLAN.md is corrected.

#### Fixed
- Undefined behavior surfaced by the sanitizers is fixed, and `check-san` builds
  the toolchain under ASan and UBSan in CI.

## September 2026

### 0.7.2

#### Fixed
- CI full test matrix: the arm64 QEMU loader argument was lost because the test
  runners quoted the qemu command. The test runners now word-split `$QEMU`.

### 0.7.1

#### Fixed
- CI for the in-process JIT test tiers: the AArch64 JIT suite runs under
  qemu-aarch64 with the cross toolchain's loader, and CI installs zig to
  cross-build the RV32 JIT. No code changes.

### 0.7.0

#### Added
- In-process JITs for AArch64 (`skj-jit-arm64`) and RV32 (`skj-jit-rv`), joining
  the x86-64 JIT over a shared arch-neutral JIT core. Excelsior runs in-process
  on the AArch64 JIT, including source coroutines.
- RV32 process sandbox (`skj-run`): a round-robin scheduler with spawnable child
  processes, per-process and aggregate memory budgets, guarded dynamic memory
  (`gm_mmap`/`gm_munmap`) so coroutine-stack overruns fault, and a
  decoded-instruction cache that `fence.i` invalidates.

#### Changed
- Each backend is a single instruction selector driving a byte sink (for the JIT)
  and a text sink (for AOT output). RISC-V uses `rv_select.c` in place of
  `rv_emit.c`.
- `rv_run` returns an enum reason (budget, halt, trap, or yield) and stops early,
  which is an API change to the emu-rv component.
- Redundant license notices are removed across the tree.

#### Fixed
- Undefined behavior in the RV32 S/B/J immediate decoders, found by a new ASan
  and UBSan pass, plus hardening of `gm_mmap`/`gm_munmap` against 32-bit wrap and
  two sandbox bugs (a spawn leaving the parent's fault flag set, and a scheduler
  slice not clearing the wfi wait).

#### Tooling
- `make check-emu-san` runs the host-only emulator tests under ASan and UBSan in
  CI, with new tests for the `rv_run` contract, guest mappings, the decode cache,
  and the sandbox.
- The byte encoders are checked against GNU as (RV32) and a disassembler
  (AArch64).

### 0.6.0

#### Added
- `skj-jit`, an in-process x86-64 JIT for the C compiler. It compiles C source to
  native code in the same process and runs it, with no assembler, linker, or
  emulator. It covers the integer core, single and double float, small-struct
  by-value arguments and returns, System V varargs, and calls that spill to the
  stack.
- A new `check-jit` test tier.
- New IR opcodes: `FSQRT`, `FROUND`, 64-bit divide and modulo, overflow-checked
  `ADDO`/`SUBO`/`MULO`, and `IR_LOC` for source-location tracking.

#### Changed
- The x86-64 code generator is one instruction selector (`backend/x86_select.c`)
  with a byte sink for the JIT and a NASM text sink for ahead-of-time output.
  `skj-cc-x86-64`, `skj-exc-x86-64`, and the JIT share it.
- The x86-32 target is removed: its tools, tests, runtime, vendoring, and
  `X86_BITS==32` branches.
- RISC-V and MIPS now match the platform psABI for every external call, and the
  toolkit's stack convention is retired there. `skj-cc-rv-psabi` merges into
  `skj-cc-rv`. ColdFire keeps its convention.
- MIPS fixes: single-precision float arguments take the same eight-byte footprint
  as doubles, and a tail call whose arguments fit in registers is a real tail
  call.
- Preprocessor constraint violations now fail `skj-cpp` instead of passing
  silently.

### 0.5.1

#### Fixed
- Calls with 17 to 32 arguments compile on every backend. The per-call cap rose
  from 16 to 32 to match the C front end. Calls of 33 are still rejected by the
  front end.
- RISC-V handles stack frames larger than 2047 bytes. Out-of-range frame offsets
  go through a scratch register.
- `skj-as-rv` rejects out-of-range 12-bit immediates with a diagnostic that names
  the mnemonic and value, instead of silently truncating them.

#### Tooling
- New cross-target regression test `cc_t078`, covering a 3200-byte frame and a
  20-argument call on every C backend.

### 0.5.0

#### Added
- `skj-as-mips` and `skj-ld-mips`, a binutils-free MIPS I assembler and static
  linker for ELF32 little-endian objects. The linker applies the o32 relocations,
  emits the MIPS ABI flags, and pulls only the archive members it needs.
- `skj-ar`, a target-neutral archive tool that creates GNU/SysV archives with a
  symbol index and lists or extracts members.
- A PlayStation target. `skj-ld-mips -f ps-exe` writes a PS-X EXE image, and
  `start_psx.S` is a BIOS-TTY runtime crt. A PS-EXE test validates the container,
  and an opt-in test runs programs on PCSX-Redux, including a soft-float program
  on the FPU-less R3051. This completes MIPS milestone 6.

#### Tooling
- `check-mipsas` checks encodings against GNU as and includes a delay-slot load
  test. `check-cc-mips-skj` runs the full C suite through the in-tree toolchain
  under qemu-mipsel.
- The MIPS toolchain vendors as `as-mips`, `ld-mips`, and `ar`, plus the `mips`
  backend component and the soft-float compiler `skj-cc-mips-sf`.
- `drop-to-main` takes an explicit version and names the main commit `vX.Y.Z`.

### 0.4.0

#### Added
- A MIPS I backend for the R2000 and R3000, little-endian. It has two calling
  tiers: the toolkit's stack convention for TinC, TinScheme, and the C compiler,
  and the o32 platform ABI for Excelsior. Floating point is a build choice, and a
  `.set noreorder` mode fills delay slots with a scheduler.
- `skj-run`, an in-tree guest runner for ColdFire and RV32 that replaces
  qemu-m68k and qemu-riscv32 for those targets. It reports the guest's exit
  status, and `--trace` and `--stats` expose emulator events. The RV32 core ships
  with its audit suites.
- `skj-as-rv` and `skj-ld-rv`, an in-tree RISC-V assembler and static linker for
  ELF32 that interoperate with gcc-built code.
- Excelsior sources: the fallible pump as the iteration protocol, `source of T`
  with `yield` on a stackful coroutine, `defer`, list comprehensions, and
  function values.
- Inline assembly (`asm` and `asm volatile`) in `skj-cc`, plus a MIPS I retarget.
- Runtime additions: software float (`softfloat.c`) and 64-bit integer helpers
  (`soft64.c`) for targets without hardware support, a smolmoo runtime, and psABI
  start files for MIPS and RISC-V.

#### Changed
- The Excelsior host runtime is renamed from `exc_host` to `libexc`, with a
  public `libexc.h`.
- The ColdFire assembler's lexer and object emission are split into `asm_lex` and
  `asm_obj`.

#### Tooling
- `make check-all` passes across ColdFire, RISC-V, x86-32, x86-64, AArch64, MIPS,
  and the emulator suites, including the new RISC-V assembler and linker suites.
  Documented in `doc/mips.md` and `doc/emulator.md`.

## July 2026

### 0.3.0

#### Added
- AArch64 (ARM64) backend, and an x86-64 target sharing the x86 backend. Both are
  at feature parity with x86-32: integer core, native 64-bit integers, float,
  `_Float16`, and delimited continuations.
- Native single-precision float (IR_F32) on every backend, and RISC-V hardware
  float (RV32FD + Zfh) in place of the soft-float path.
- skj-cc retargeted to x86-64, AArch64, and RISC-V alongside ColdFire. It has an
  LP64 data model on the 64-bit targets, SysV AMD64 and AAPCS64 calling
  conventions (including varargs and struct-by-value), bit-fields, designated
  initializers, `_Alignof` and `_Alignas`, and a `_Float16` storage type.
- Excelsior (skj-exc), a new statically typed, class-based in-world scripting
  front end. It covers per-instance object state, records, enums, `set of E`,
  base-10 decimal, UTF-8 strings, lists, fallible expressions with `otherwise`
  and `on fail`, teaching runtime faults, interfaces and object slices, `shared`
  parameters, and compile-time macros with record, class, and enum introspection.
- `make release-check`, which verifies that `version.mk` and the release tag
  agree.

#### Changed
- `version.mk` is the source of truth for the version, and git only refines it. A
  vendored build reports the Skjegg version plus the commit it was vendored from,
  not the consuming project's tags.
- `long double` is a distinct, detected type instead of causing silent ABI
  corruption.

#### Fixed
- A float temp live across a call is spilled on x86 and AArch64.
- RISC-V double slots are 8-byte aligned, so `fld` and `fsd` are never
  misaligned.
- Struct and union globals are sized and aligned correctly, and pointer globals
  initialized to addresses are relocated.
- Vendored trees now get the `version.h` rule, so vendored tools compile.

## May 2026

### 0.2.0

#### Added
- The initial public toolkit: a shared 3AC IR with ColdFire/m68k and RISC-V
  backends, and a built-in ColdFire assembler, linker, and C preprocessor.
- Front ends for TinC, TinScheme, MooScript, Compact Pascal, and an early C
  compiler (skj-cc), plus `vendor.sh` for embedding components in other projects.
