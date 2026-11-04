# The skj-run process model

This document describes the process model skj-run is growing toward: a small
unix-like system where each process runs in its own sandbox, and a userland of a
shell (`jsh`) and small tools is spawned on top of it. It records the design and
the host-call ABI, and marks what is implemented today versus planned, so the
pieces can land one at a time without the contract drifting.

Status is marked inline: **(done)** ships today, **(planned)** is designed here
but not yet built.

## One sandbox per process

`skj-run` runs a root process and lets a guest spawn children. Every process has
its own CPU, its own guest memory, its own heap and stack, its own open-file
table, and its own mount table. A child shares no memory with its parent. A
round-robin scheduler (`emu/sched.c`) runs the live processes a `SKJ_QUANTUM` of
instructions at a time and reaps each as it exits, halts, or faults. One copy of
the scheduler serves every core through the `skj_cpu_ops` vtable.

Isolation is the default, not an afterthought. A freshly spawned process comes up
with its own empty scratch and nothing else, so it reaches the host only
through a capability its parent deliberately hands it. This is the opposite of
`fork`: nothing is inherited unless it is passed.

A process **handle** is a table slot plus a generation, so a handle kept past a
child's death never matches a later child that reuses the slot.

## The spawn request

Spawn takes a size-prefixed, extensible descriptor in guest memory. The host
reads the leading `size` (the byte count the guest filled) and honors only the
fields that fit, so later fields are added without a new selector and an older
guest that fills fewer fields simply gets host defaults for the rest. Every word
is a 32-bit value in the guest's byte order.

```
offset  field       meaning                                   status
0       size        bytes the guest filled                    done
4       image       guest address of the ELF image            done
8       image_len   its length (<= 16 MiB)                     done
12      argv        guest address of argc string pointers      done
16      argc        argument count                            done
20      flags       SKJ_SPAWN_FLAG_SHARE_MOUNTS, ...           done
24      fdmap       guest address of {gfd, dst} fd-map pairs   done
28      fdmap_n     number of fd-map entries                   done
```

The fields past `argc` are present when the request reaches
`SKJ_SPAWN_WITH_FDS` bytes; an older guest that fills only through `argc` gets
host defaults (its own `0/1/2`, no shared mounts). Environment passing is not a
descriptor field: a process holds its own environment, and the shell has no
cross-process `setenv` to propagate.

The host-side marshalling is bounded: at most `SKJ_SPAWN_MAX_ARGC` arguments,
`SKJ_SPAWN_ARG_MAX` bytes each, `SKJ_SPAWN_ARGBUF` total. A read out of mapped
memory fails the spawn cleanly rather than faulting the caller.

## Lifecycle host calls

These sit in the emulator-private selector space (see "How guest syscalls work"
in `emulator.md`); every core routes them to the shared `sched_private` handler,
so one build serves all five targets.

| selector | value | meaning | status |
|---|---|---|---|
| `SKJ_SYS_SPAWN`  | `0x000f0003` | spawn from an image pointer + length (no argv) | done |
| `SKJ_SYS_SPAWNV` | `0x000f0006` | spawn from the size-prefixed request above | done |
| `SKJ_SYS_WAIT`   | `0x000f0007` | wait on a child handle, return its status, reap it | done |
| `SKJ_SYS_KILL`   | `0x000f0008` | terminate a child handle with a given status | done |
| `SKJ_SYS_PIPE`   | `0x000f0009` | create a host-backed pipe, return two handles | done |

`SKJ_SYS_WAIT` parks the caller if the child is still running, reusing the
scheduler's existing blocked-process path, and wakes it when the child exits. A
child that has exited but not been waited on is kept as a zombie (its resources
freed, its status retained) until a wait reaps it or its parent is gone.
`SKJ_SYS_KILL` reaches only the caller's own children, matching the capability
model: there is no system-wide process namespace, and a "pid" is a spawn handle.

## Arguments and environment

The initial stack frame the loader builds carries the full Linux-style layout:
`argc`, the `argv` pointers, a NULL, the `envp` pointers, a NULL, then a minimal
auxv. A root gets its own `argv` and environment through `sched_add_root` (see
"Embedding the scheduler"), which the CLI exposes as `--env KEY=VALUE`
(repeatable); the stack builders write the `envp` pointers in the guest's own
width and byte order, so this works on every tier, not just ILP32. The crt
delivers `argc`/`argv` and sets `environ` (from the `envp` the loader laid down)
for `getenv` and for the auxv walk the vDSO needs; every tier's crt does this,
the emulated and the HV ones alike. A **spawned child** still inherits no
environment; the spawn descriptor could carry one later, the way it grew `argv`
and the fd map **(planned)**.

A process holds its own environment. There is no shared global environment and no
cross-process `setenv`: a shell keeps its own `environ`, mutates it with
`export`, and passes a copy to each child it spawns.

## File descriptors, streams, pipes, and redirection

`fs/` keeps one open-file table per process (`fd_tab`). There are no special
descriptors: 0, 1, and 2 are ordinary stream slots (`FD_STREAM`), the same kind
a pipe end or an inherited descriptor binds. `fs_init` binds them to the
sandbox's own stdin/out/err (gated on `FS_WITH_STREAMS`, so only a guest build
has them; the hosted `fs_test` does not). A stream slot reaches the host
directly through the raw crt seam, bypassing the mount backend, so it is not
seekable (`lseek` reports `ESPIPE`); closing it closes the host fd, since the
sandbox owns it. The libc routes every op through `fs_*`, with no `fd < 3`
shortcut, so 0/1/2 travel the same path as every other fd.

Each sandbox gets its **own** `dup` of the real 0/1/2 when its capability table
is first used, so there is nothing shared to protect: a guest closing its fd 1
closes only its own dup, never the terminal, and process teardown closes every
host fd the sandbox still holds (which is also how a writer's exit closes a pipe
and the reader sees EOF).

A **pipe** is `SKJ_SYS_PIPE`: the host creates a host pipe and hands the sandbox
two capability indices, one per end, which the libc `pipe()` adopts as two
stream fds. Because there is no `fork`, there is no `dup2`; descriptors are
handed to a child **at spawn** through an fd map: `{gfd, dst}` pairs past `argc`
in the spawn request (a flags word, the map pointer, and its count, present when
the request reaches `SKJ_SPAWN_WITH_FDS`). The guest resolves one of its fds to
the capability index backing it (`fs_fd_backing`) and names the id the child
should see it as. The host dups that resource into the child and records the
child's `fs_inherit_fds` table for its `fs_init` to install. That is how a pipe
end or a redirect reaches a child; with no map the child just gets its own
0/1/2. A redirect to a file is the same mechanism once the target is a
host-backed fd.

## Passing capabilities: the mounts

A capability in this model is a mount: a `struct fs_mount` entry plus the backend
handle its root fd names. The `SKJ_SPAWN_FLAG_SHARE_MOUNTS` request hands a child
the parent's namespace. With the flag unset the child still gets its own scratch
(a fresh per-sandbox host directory `skj-run` grants, see below) and nothing the
parent held.

Delivery is **host-mediated**, not a guest-side table copy, for two reasons.
The guest's `fd_tab` is a `static` the host cannot read by symbol, and the
guest's live `fs_mounts` is post-adoption (its `fd` fields are `fd_tab` slot
indices, not the capability indices a fresh `fs_init` expects). So the host
keeps the inheritable form itself: each process records its installed mounts as
a `guest_grant` list as it receives them, holding each host-backed grant's real
resource (a `FS_KIND_HOST` directory fd). At spawn the host replays that list
into the child, resolving the child's `fs_mounts` from its in-memory ELF image,
dup'ing each host dir fd so the child owns an independent capability, and writing
the child's table in launcher form for the child's own `fs_init` to adopt
unchanged.

Only **host-backed** capabilities can be shared this way: hostcap (a host
directory fd) and devfs (stateless), with pipe ends to follow. Their backing is
a host resource the host can replicate into the child. A ramfs, romfs, or 9P
client keeps its backend state in the parent's guest memory (or a server bound to
the parent), which the child does not share, so those mounts stay private to the
process that holds them; they are recorded for an accurate count but not yet
inherited.

### Host-backing the filesystem where a host is present **(done)**

When a host is present, as it always is under `skj-run` (the emulated tiers and
the KVM/HVF ones alike), the host can own the filesystem and the guest needs
almost no `fs/` code. The backends were most of a guest binary's size, so this
is the main lever on guest size, and it is now the default for the `skj-run`
userland. It is a per-deployment choice, not a wholesale conversion: the
in-guest backends stay available for the hosts that need them.

The mechanism is the capability-fd path that already existed for a `--mount`
host directory (`hostcap`): the guest issues ordinary `openat`/`read`/`write`/
`statx`/`getdents` on an opaque directory fd, and `skj-run` services them
against the real host fd it holds. Two default mounts move onto it:

- **scratch**, the spot a bare path resolves against, is an ephemeral host
  directory `skj-run` grants per sandbox (`mkdtemp`, removed at teardown). Each
  process gets its own, so it is as private as the in-guest ramfs it replaced,
  with no cross-process shared state.
- **bin:**, the tool images `jsh` reads, is served as a read-only host directory
  (`--mount-ro`, which sets `FS_RO`). One host copy serves `jsh` and every
  child, instead of a romfs image parsed into each guest's memory.

The in-guest ramfs and romfs are kept behind `FS_WITH_RAM` and `FS_WITH_ROM` for
the cases that still need them, and are compiled out of the `skj-run` build:

- The standalone VM hosts. `fs/` runs *in the guest* so the Excelsior ColdFire
  and RISC-V hosts, which run the guest as the operating system with no host
  underneath, have a filesystem at all. Those deployments keep the in-guest
  ramfs and romfs; a bare-qemu guest likewise lands on the in-guest ramfs.
- The cost of host-backing is a doorbell round trip per `open`/`read`/`write`/
  `stat`, where an in-guest ramfs read is a memory access. That is fine for
  scratch and for loading a program image, which is why those move; a backend on
  a hot inner loop would not.

So the `fs/` switch, a vtable over backend kinds, carries both forms, and the
deployment chooses by what it links and what the launcher grants. This went
through the capability-fd mechanism rather than a new 9P-style served kind, so
it needs no 9P and no round-trip batching for scratch or bin.

### The `proc:` filesystem **(done)**

`proc:` is a read-only pseudo filesystem that exposes the live process table, so
a tool can enumerate what is running. It is **host-served**: a guest cannot read
the host scheduler state directly, so the content is generated host-side from the
`sched` process table and handed back a byte range at a time.

It reuses the capability-fd path with no new guest-side backend. A `proc:` mount's
root fd is a new capability-device kind, `GDEV_PROC`, and the ordinary
`openat`/`read`/`getdents64`/`statx`/`lseek`/`close` the `hostcap` backend issues
against it are routed, inside `skj-run`, to the generators in `emu/procfs.c`. There
is no `fs/` layer change and no new `FS_WITH_*` flag. A file's text is produced into
a growable buffer with a `printf`-style append helper (`gbuf`), the reusable
generated-content mechanism future pseudo files reuse.

`proc:` is **always mounted**, for the root process and every spawned child, so a
tool can rely on it without a `--mount`. The namespace is:

- `proc:` (root): one directory per live process, named by its id (`slot + 1`,
  matching the `[proc N]` convention), plus a `self` alias for the opening
  process.
- `proc:<id>/status`: `key:value` lines from the `proc` fields that already
  exist: `Pid`, `State` (running / sleeping / blocked / zombie / done),
  `Parent`, `Insns` (retired instruction count), and `ExitCode`/`Fatal` when
  applicable.

There is no `cmdline` yet: argv is not retained on `proc`. Richer per-pid files
are a follow-on that first needs argv retention. The `ps` tool
(`examples/bin/ps.c`) reads `proc:` and prints a `PID` / `STATE` / `PARENT` /
`INSNS` table; `tests/run-ps.sh` (target `test-rv-ps`) runs it under `skj-run`
with no `--mount` and checks the sole process lists as pid 1, running.

## The userland **(done)**

The userland that rides on this is a shell, `jsh`, and a set of small tools
(`cat`, `echo`, `ls`, `rm`, `sleep`, `cp`, `mv`), reimplemented in C over
skjegg's libc and the `fs/` layer. They live under `examples/` (`examples/jsh`
and `examples/bin`) and run on every tier `skj-run` hosts, the emulated RISC-V,
ColdFire, and MIPS cores and the KVM/HVF x86-64 and arm64 guests, with `skj-run`
owning scratch and `bin:` host-side so the guest links only the `fs/` switch and
the hostcap adapter.

`jsh` is a Bourne-subset shell (variables, `if`/`while`/`for`/`case`, functions,
`&&`/`||`, pipelines, redirection, command substitution). Its parser and
execution are shared with the standalone build; only the process seam is
retargeted here. The shell resolves a command name to a program image: a bare
name is read from the `bin:` mount, which `skj-run` grants as a read-only host
directory of the tool images (`--mount-ro`). It reads the image into a buffer,
spawns a fresh sandbox for it with argv and an fd map, and waits on the handle.

Because a child inherits no descriptors, pipelines and redirection build the fd
map rather than mutating the shell's own fds. A redirect opens the target in the
shell and places the opened fd at the child's `0`, `1`, or `2`; a pipeline
creates a host pipe per stage boundary and places each end in the adjacent
stage's map. With `SKJ_SPAWN_FLAG_SHARE_MOUNTS` the children see the shell's
namespace, so a tool can reach the same files the shell can.

`kill` is a shell builtin, not one of the external tools: a spawn handle is
private to the process that holds it (there is no system-wide process
namespace), so only the shell that spawned a child can name it. `kill HANDLE`
calls `SKJ_SYS_KILL` with the handle the shell printed when it backgrounded the
job.

## Injecting runtime: the vDSO and the system page **(done)**

The host can hand a process a slice of runtime the way Linux hands a process its
vDSO: `--vdso IMG` maps a small read-only image of pure leaf functions
(`runtime/vdso.c`: `strlen`, `strcmp`, `memcpy`, `memset`) into the guest and
advertises its export table through a private auxv tag, `AT_SKJ_VDSO` (`0x7001`,
chosen out of the Linux `AT_*` range so a real libc ignores it). The guest finds
it by walking its own auxv (`environ` to the NULL, then the auxv pairs) and calls
a function through `table->fn[ordinal]`. No crt change is needed, only the
`environ` the crt already sets. The image is the injection seam: the host decides
what runtime a process sees by choosing the image it maps.

Only **stateless** code goes in the image, so one copy is safe to share
read-only across every sandbox. The stateful parts of libc (`malloc`, stdio,
`errno`, the `fs/` layer) stay per process. The image is built once and shared,
but the sharing mechanism differs by tier because the guest reaches memory
differently. An emulated guest aliases the one host buffer through its software
memory path (`gm_page`), read-only. An HV guest runs on real hardware through
the hypervisor's own map, so the same buffer backs a read-only hypervisor memory
slot (`KVM_MEM_READONLY`, or read-plus-execute under HVF) at a fixed guest
address above RAM but inside the identity map. Either way a guest write faults,
so one sandbox cannot corrupt the image another shares.

The **system page** is the data counterpart, the vDSO's namesake win: a small
block the host keeps updated and the guest reads with no syscall or doorbell,
in the spirit of a QNX system page. It lives in the same shared image
(`struct skj_vdso_sys`: a magic and version, a seqlock, the host page size and
cpu count, monotonic and realtime nanosecond clocks, and reserved words for more
such state) and is read-only to the guest. The scheduler refreshes the clock
just before each process runs, writing the time into the backing buffer in the
guest's byte order and driving the seqlock (odd, write, even). The guest is
stopped at that point, so a write never races a read; the clock therefore
advances at slice granularity, the tradeoff a trap-free read makes for freshness
bounded by the quantum. A guest reads the clock two ways: the vDSO functions for
monotonic and realtime nanoseconds, or directly through the page, whose address
the export table carries so a guest can read the page size, cpu count, and the
rest.

The tag, the ABI struct, the ordinals (append-only, so the index never moves),
and the system-page layout live in `include/skj_vdso.h`. The feature is exercised
by `test-rv-vdso`, `test-cf-vdso` and `test-mips-vdso` on the emulated tier (one
per core: RISC-V and MIPS little-endian, ColdFire big-endian, so the loader and
the byte-order-aware system-page writer are both exercised either way) and
`test-hv-x86-64-vdso` under KVM (with `test-hv-arm64-vdso` building the image
everywhere and running it on an aarch64 KVM host), all in `check-emu-all`.

## Embedding the scheduler **(done)**

`run_sandbox` runs one process tree to completion with its stdio bound to
`skj-run`'s own terminal, and owns the poll loop. That is the CLI, not the only
way in: the scheduler is a reusable object a host can drive itself, which is what
a shell server (telnet, websockets) binding each connection to its own sandbox
tree needs.

The I/O scheduling is a single cooperative reactor. A blocking guest read parks
the process on its host fd (`park_fd`, `POLLIN`); the scheduler skips it until a
`poll()` over every parked fd says it is ready. A pipeline is exactly this: each
stage parks on its pipe end, all in one `poll()`, and the ready one resumes. No
threads, no per-process stall.

The reusable API in `sched.h` exposes that machinery:

- `sched_init` / `sched_destroy` bracket a scheduler over a core and the run
  options. The core is a `skj_cpu_ops` vtable, obtained from the per-arch getter
  for the arch this build carries: `skj_ops_rv32`, `skj_ops_coldfire`,
  `skj_ops_mips32`, `skj_ops_x86_64hv`, or `skj_ops_arm64hv` (`guest.h`). These
  are how a host reaches a core without the CLI's `run_*` wrappers.
- `sched_add_root(S, &root)` loads a root from a `sched_root` spec. Each root
  carries its own `argv`, its own environment, and the three host fds its
  `0`/`1`/`2` bind to, a connection's socket rather than the terminal (any of
  the three may be `NULL`: `argv` falls back to the run options', the
  environment is empty, stdio is `skj-run`'s own). A host may add several
  independent roots. The image comes from a file at `path`, or, when the spec's
  `image` field is set, from that in-memory ELF buffer (with `path` then only
  labelling it in fault and trace messages). A host whose guest images are byte
  buffers, from an object store or a just-finished compile, runs them directly
  this way, with no temporary file. The CLI exposes it as `--mem-root`, which
  reads the program into memory and runs it from there.
- `sched_step` runs one round of slices and returns the live count; `sched_run`
  is the built-in loop over it.
- `sched_waits` hands out the parked fds and the nearest sleep deadline, so the
  host's own `poll()` can watch them alongside its listening socket and timers;
  `sched_mark_ready` and `sched_wake_deadlines` report readiness back.

So a server runs one event loop over many scheduler instances (one per
connection) plus its accept socket, stepping whichever tree a ready fd belongs
to. Two constraints shape that design: the cores and the shared memory pool are
single-threaded, so it is one event loop and not one thread per connection; and
the HV cores spin-retry rather than park on blocking I/O, so connection-bound
shells run best on an emulated core. A spawned child, unlike a root, still
inherits no environment; that is the one piece of per-process state the spawn
path does not yet carry.

## See also

- `emulator.md`, "The process sandbox" and "How guest syscalls work", for the
  scheduler, the batched-run reason contract, and the selector mechanics.
- `emulator.md`, "The filesystem layer (`fs/`)", for mounts, the fd space, and
  the guest-versus-host split.
