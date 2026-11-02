# MUD VM -- the skjegg rebase

This document describes the guest runtime as it stands after boris was
re-based onto the skjegg compiler suite. It supersedes the runtime and
compilation sections of `doc/mud-vm-design.md`, which describe the earlier
bespoke RV32 interpreter and the host-call-by-name model. The high-level
goals in that document still hold: objects carry programs, a program runs as
RV32 guest code in a bounded memory image, and isolation comes from the
emulator boundary plus the host process sandbox.

## The embedded emulator

The server embeds skjegg's RV32 emulator as a library, `skjrun`
(`sdk/toolchain/skjegg/`, built by its `module.mk`). boris does not fork the
`skj-run` CLI and does not run its blocking scheduler. Instead the runtime
adapter in `src/vm/vm.c` drives skjegg's embeddable process scheduler one
non-blocking round at a time from boris's own event loop (`sched_step`,
`sched_waits`, `sched_mark_ready`). Each guest tree is one `sched` embedded in
a `vm_task`. boris supplies its own CPU vtable so it can intercept host calls,
the console streams (fd 0/1/2), and the mailbox, while spawn, pipe, and wait
come for free from skjegg inside a round.

The skjegg toolchain is vendored at a pinned tag and refreshed with
`sdk/toolchain/update-skjegg.sh`. See `project_skjegg_vendoring` for the axes
the vendor script takes.

## Host calls: the selector band

A guest reaches boris's game services through an `ecall` with `a7` in the
boris host-call band (`VM_HOSTCALL_BASE`, 0x00100000 and up), chosen to sit
clear of skjegg's own private selectors (0x000f0000). A few builtins
(exit, write, read, random, now, suspend, getmsg) are served directly; the
game calls (object and world access, the mailbox) are a selector table a
guest's stubs index by a fixed number, not by name. Everything below the band
(ordinary Linux syscalls, the program break, the clock) goes to skjegg's own
`guest_syscall`.

## Files: the in-world 9P server

Guest file I/O does not use a host-call seam. A guest links skjegg's `fs/`
mount layer and reaches files through a 9P2000 mount served by boris. The
server (`src/vfs/p9_vfs.c`) is backed by the in-world object store (a
content-addressed VFS, `src/vfs/vfs.c`), so a guest reads and writes the same
tree the authoring commands and the compile pipeline use. A task is granted
the mount before it loads (`vm_task_add_p9_mount`); `@run` gives a program the
VFS as `world:`.

For the compile toolchain, a stage is instead granted a confined host
directory through a hostcap mount (`vm_task_add_mount`), so its reads and
writes stay inside one temporary build directory.

## In-world compilation

`@compile <src> [<out>]` compiles a guest source in the VFS to an RV32 ELF in
the VFS. The compiler, assembler, and linker are themselves RV32 ELFs
(`skj-cc-rv.elf`, `skj-as-rv.elf`, `skj-ld-rv.elf`, built by
`make -C sdk/vm toolchain`), run as guests under the embedded runtime over a
hostcap build directory. Because no host process is spawned, in-world
compilation works with seccomp and Landlock active; the pipeline is
`src/vfs/vfs_compile.c`. C and assembly are supported; Kobold-Pascal is a
follow-up.

## Launching programs

A program object `programs/<id>` names an ELF image, by a VFS path (the
`@compile` output) or a host image under the image directory. `@program`
binds, lists, and removes them; `@setverb` attaches one as a command verb on
an object; `@run` launches one as a foreground interactive session, feeding
the player's typed lines to the guest's stdin and writing its stdout back. A
foreground session is stepped on the server heartbeat, so it spans the
player's later input. Command verbs and resident agents run the same images
through the one-shot and agent paths.

## The guest SDK

`sdk/vm/` builds the guest programs. The confined libc (skjegg's `fs/`
interpose libc) plus the C start files are built from the vendored sources,
and two guest flavors link against them: the unix userland (jsh and the
coreutils), which reach the host through the Linux syscall seam and files
through the mount table, and the band guests (command verbs and agents),
which reach boris through the selector band and do not use libc.
