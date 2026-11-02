# Kobold-Pascal Guide

This is the starting point for writing Kobold-Pascal. It explains what the
language is for, shows the language at a glance, and walks through compiling and
running a program with the skjegg tools. When you want to learn the language
step by step, read `kp-tutorial.md`; when you want the precise rules, read
`kp-language.md` (the reference) and `kp-grammar.md` (the grammar).

## What Kobold-Pascal is

Kobold-Pascal is a small, statically typed language in the Pascal family,
designed to be embedded in a C program as a scripting layer and compiled to
native machine code. In skjegg it is a front end that reaches the shared IR
through its own compiler, `kpcom`, and then uses the same backends as the C
compiler, so a Kobold program runs on x86-64, AArch64, and RISC-V RV32.

It aims at the niche that games and tools reach for when they need a scripting
layer that is easy to embed, cheap to run, and safe to hand to someone who is
not a systems programmer.

- **Embeddable in any C project.** The runtime is a small C library. The
  in-process JIT compiles the IR to native code in an executable buffer the host
  calls directly, with no assembler, linker, or emulator at run time.
- **A familiar, readable syntax.** Pascal's block structure and strong typing
  are easy to read and hard to misuse, which suits scripts that ship inside a
  larger application.
- **No pointers.** Scripts cannot form raw pointers or do pointer arithmetic,
  and the language exposes no address type. Host resources are reached through
  opaque, typed handles instead (see Opaque handles below).
- **The host owns the world.** Memory layout, object lifetimes, and method
  dispatch for host objects live in the C host and are reached through a foreign
  function interface. A host object is named by an integer handle id, never by
  an address, so a script never holds a host pointer.

Kobold-Pascal shares much of its syntax with Compact Pascal (`../pascal.md`),
but compiles to native machine code rather than WebAssembly and uses opaque
handles rather than pointers.

## The language at a glance

```pascal
program patrol;

type
  { Entity is a host handle type: the script declares the interface, the host
    registers a matching object system, and 'e.move(...)' becomes a (handle,
    slot) call the host dispatches. }
  Entity = interface
    move: procedure (dx, dy: integer);
  end;

procedure patrol(e: Entity);
var i: integer;
begin
  for i := 1 to 4 do
  begin
    e.move(1, 0);
    { 'yield' suspends this coroutine until it is resumed again. }
    yield;
  end;
end;

var
  guard: Entity;
  p: process;
begin
  guard := spawnGuard;    { host function, returns a handle }
  p := start patrol(guard);   { create the coroutine }
  p(0);                   { run it to the first yield; resume on each later tick }
end.
```

### Core types

- `integer`, `real`, `boolean`, `char`
- `enum` (enumerated types) and subranges
- `set of` an ordinal type
- `array[lo..hi] of T`, and dynamic `array of T`
- `record`, including variant records
- `string` (host-managed, not a raw memory type)
- `map of T` (a string-keyed associative array; `map[K] of T` keys by an ordinal `K`)
- opaque host handles (see below)

### Control flow and structure

Standard Pascal control flow: `if`/`then`/`else`, `while`, `for ... to`/`downto`,
`repeat`/`until`, `case`, `with`, plus `break` and `continue`. Boolean `and` and
`or` short-circuit, so a left operand can guard the right, as in
`(i <= n) and (a[i] = x)`; on integer operands the same words are bitwise.
Procedures and functions take value, `var`, and `const` parameters and may be
nested. The language is case-insensitive.

## Extensions for game scripting

Kobold-Pascal adds a few features beyond the Pascal subset, each chosen to help
with embedding and with the kind of scripting that games need.

### Opaque handles

Instead of pointers, a script holds typed, opaque handles to objects that live
in the C host, much like references in Java. A handle type is declared with the
`interface` syntax (named procedural fields); a method call is a call into the
host's object system, with the slot patched in at load time. A script passes
handles around and calls methods on them, but cannot inspect or forge the
underlying object. The compiler emits retain and release calls as handles are
copied and go out of scope, so the host can reference-count and reclaim the real
object.

### Go-style methods

Methods attach to a type through a receiver parameter, in the spirit of Go,
rather than being declared inside the type. A receiver is by reference by default
(so a method can mutate it) unless it is `const`. A call on a record receiver
resolves statically; a call on a handle receiver resolves at link time to a
direct call into the host's registered method. A script may add methods to a host
handle type, and a script method overrides a host-registered method of the same
name.

### Coroutines

Kobold provides stackful coroutines through the `start` and `bind` control
operators, with `yield` as the simple form. A script can pause at a `yield` and
be resumed later where it left off. They are in-script control operators, so the
host makes an ordinary call and gets an ordinary return; a script keeps its own
coroutine handles and resumes them on the next tick. That maps naturally onto
per-frame game logic such as enemy behaviors, cutscene sequencing, and timed
events.

- `start E` creates a coroutine for the call `E` and evaluates to its handle (a
  `process` value). The body does not run yet.
- A `process` is resumed by calling it like a function, `k(v)`. The first call
  runs the body from the top to its first `yield`; each later call continues
  from the suspended `yield`. The call evaluates to the yielded value, and `v`
  becomes the result of the `yield` that resumes.
- `yield E` suspends the current coroutine and hands `E` back as the value of
  the resume; `yield` with no value is allowed.
- `bind k in E` is the explicit form: it binds the current coroutine handle to a
  `process` value `k` for storing, passing, or handing to a scheduler.

`release(k)` cancels a coroutine that will not be resumed. Each coroutine runs on
its own refcounted private stack, so it can be stored and resumed across ticks
from any depth.

### Overloaded routines

There is no special `write`/`writeln` syntax baked into the grammar. Output is
done with overloaded routines: several routines share a name and are chosen by
argument type, so the built-in types print through one name and a script can add
its own overloads.

## Compiling and running

A Kobold program is a `.pas` source file. skjegg compiles it in two ways.

### Run it directly (the JIT)

`skj-kp-jit` compiles the source and runs it in the same process. This is the
quickest way to try a program:

```sh
skj-kp-jit hello.pas
```

There are per-backend JIT tools (`skj-kp-jit-rv`, `skj-kp-jit-arm64`) that run
the same source on the RISC-V and AArch64 runtimes.

### Build a native executable (ahead of time)

The ahead-of-time path first turns the source into a KPM1 module (the serialized
IR, see `kp-module-format.md`), then compiles that module to native code:

```sh
# 1. front end: source to a KPM1 module
skj-kpc --emit-kpm hello.pas -o hello.kpm

# 2. backend: module to a native executable, assembled and linked
sh kobold/aot-run.sh hello.kpm
```

`skj-kpc` is the front end compiled to a native binary, so it runs on the host
and emits a module for one target: `skj-kpc` (x86-64), `skj-kpc-arm64`,
`skj-kpc-rv`, and `skj-kpc-cf`, one per backend. The module's `.target` line
records that architecture and the backend rejects a module built for another.
`skj-kp` (and `skj-kp-rv`, `skj-kp-cf`, `skj-kp-arm64`) is the backend that
compiles a module to assembly for each target.

### Emit a module without running

Both `skj-kp-jit --emit-kpm` and `skj-kpc --emit-kpm` stop after writing the
module and run nothing, which is useful for inspecting the generated IR or for
feeding a cross build.

## Where to go next

- `kp-tutorial.md` teaches the language step by step, from a first program to
  records, handles, and coroutines.
- `kp-examples.md` is a set of annotated programs you can compile and run.
- `kp-language.md` is the language reference, and `kp-grammar.md` is the
  grammar.
- `kp-units.md` covers splitting a program across units and separate
  compilation.
- `kp-embedding.md` and `kp-abi.md` explain how to embed the runtime in a C host
  and the contract between the compiler and the host.
- `kp-sandbox.md` walks through compiling a program to a freestanding RV32 ELF
  and running it in the in-tree emulator (`skj-run`), the build a real RV32 VM
  host would load.
- `kobold.md` describes how the Kobold front end is built and run inside the
  skjegg tree.
