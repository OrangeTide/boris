# Embedding Kobold-Pascal

This is the practical guide to running Kobold-Pascal scripts inside a C program.
It works out the whole process, from getting a compiled module to calling into it
and back. For the exact value and call ABI it builds on, see `kp-abi.md`; for the
module format, `kp-module-format.md`.

Kobold-Pascal is split in two. The front end (`kpcom`) turns Pascal source into a
KPM1 module, a portable image of the intermediate representation. The backend is a
small C library, `libkobold.a`, that loads a module, JITs it to native code
(x86-64 or AArch64), and runs it in the host process. A host embeds the backend; the front end is a
build-time or optional runtime tool, not something the host links.

## What you need

- **The library and headers.** `make install` places `libkobold.a` in
  `$(PREFIX)/lib` and the public headers in `$(PREFIX)/include/kobold`: `kp.h` (the
  load/link/call API), `handle.h` (the value-stack FFI and handle table, pulled in
  by `kp.h`), `str.h` (the string runtime, for passing text across the boundary),
  and `rt.h` (the optional standard I/O runtime). Staged installs honor `DESTDIR`.
- **A C99 compiler.** The backend is plain C99. Because the runtime's math builtins
  call the C math library, a host links `-lm` alongside the library.
- **A module to run.** Either compiled ahead of time or produced in the process;
  see the next section.

Linked together, a host includes `<kobold/kp.h>` and builds with:

```sh
cc -I$(PREFIX)/include host.c -lkobold -lm -o host
# or against a build tree, without installing:
cc -Isrc host.c build/libkobold.a -lm -o host
```

## Getting a module

A module is the KPM1 image the backend loads. There are two ways to get one.

**Ahead of time.** Compile a source file with the front end and ship the result:

```sh
kpcom --emit-kpm game.pas > game.kpm      # add -g for source-line trap info
```

The host reads `game.kpm` into memory and passes the bytes to `kp_load`. This keeps
the front end out of the shipped program entirely.

**In the process.** The front end self-hosts, so it is itself a module
(a build-time seed such as `build/kpcom-rv.kpm`) with an exported
`compile(srcName, srcText): string` entry. A
host can load that module, call `compile` on source text, take the produced module
back as a string, and run it, with no temporary file and no subprocess. This is the
two-stage boot; `examples/runpas.c` is the complete worked example. Use it when the
host compiles user-supplied scripts at runtime.

## The lifecycle

Every embedding follows the same five steps, in order:

```c
#include <kobold/kp.h>

kp_vm *vm = kp_new();                       /* 1. create the VM */

kp_register_func(vm, "emit", host_emit);    /* 2. register what the module imports */

kp_module *m = kp_load(vm, image, len);     /* 3. parse the module image */
if (!m) { /* kp_last_error(vm) */ }

if (kp_link(vm) != KP_OK) { /* kp_last_error(vm) */ }   /* 4. resolve imports, JIT */

int rc = kp_call(m, "main");                /* 5. run an exported entry */
if (rc != KP_OK) { /* rc is a trap code; kp_trap_message(vm) */ }

kp_destroy(vm);                             /* frees every module and the VM */
```

The order matters. Register every import a module names **before** `kp_link`, and
load every module **before** the single `kp_link` call. `kp_link` JITs each module
once all imports are known; a name a module imports but the host never registered is
a link error, reported by `kp_last_error`, not a crash at the call.

## The value-stack FFI

Guest and host exchange values through a small typed stack. A host function has the
signature `int fn(kp_vm *vm)`: it reads its arguments by index, pushes its results,
and returns the result count.

```c
/* emit(v: integer): print an integer the script computed. */
static int
host_emit(kp_vm *vm)
{
    printf("%d\n", kp_to_i32(vm, 0));   /* argument 0 */
    return 0;                            /* no result */
}
```

Read arguments with `kp_argc`, `kp_to_i32`, `kp_to_i64`, `kp_to_f64`,
`kp_to_handle`, and `kp_to_obj`; push results with `kp_push_i32`, `kp_push_i64`,
`kp_push_f64`, and `kp_push_handle`. The cells carry no type tag: the type of each
argument and result is fixed by the routine's declared signature in the module, so
read and push in the types the signature names.

To call **into** the guest with arguments, push them before `kp_call` and take the
results after it:

```c
kp_push_handle(vm, kp_str_new(vm, src, (int)strlen(src)));
int rc = kp_call(m, "compile");
uint32_t result = (uint32_t)kp_take_i64(vm);   /* the returned string handle */
```

`kp_take_i64` and `kp_take_f64` take a scalar or handle result off the stack after a
call returns.

## Strings

A Kobold string is a reference-counted, host-managed byte string named by a handle
id. Cross the boundary with `str.h`: `kp_str_new(vm, bytes, len)` makes one and
returns its id, `kp_str_bytes(vm, id)` reads it back as a NUL-terminated buffer, and
`kp_str_len(vm, id)` gives its byte length. A string handle passes through the value
stack as its id (`kp_push_handle` / `kp_to_handle`).

## Handles: exposing host objects

Scripts never see host pointers. A host object is reached through an opaque, typed
handle, which the script declares as an `interface` type and calls methods on. The
host registers the matching type and its methods:

```c
static const kp_hostfn methods[] = { entity_bump, entity_total };  /* interface order */
uint32_t entity_type = kp_register_type(vm, "Entity", methods, 2, entity_free);
```

A factory function creates an object and hands back a handle (refcount 1):

```c
static int
host_spawn(kp_vm *vm)
{
    struct entity *e = calloc(1, sizeof(*e));
    kp_push_handle(vm, kp_handle_new_typed(vm, e, entity_type));
    return 1;
}
```

In a method, the receiver arrives as argument 0 and the method's own parameters
follow; `kp_to_obj(vm, 0)` recovers the C object. The compiler emits retain and
release calls as handles are copied and go out of scope, so the object is
reference-counted; when the last reference drops, the type's finalizer runs and
reclaims it. This is automatic reference counting, not tracing garbage collection.
`examples/embed.c` is the full handle-and-methods example.

## Traps and safety

`kp_call` owns a trap landing pad for the duration of the call, so a fault in the
guest (division by zero, an out-of-bounds access under `{$R+}`, a nil method call, a
coroutine misuse, out of memory) unwinds back to `kp_call` instead of aborting the
host. `kp_call` returns `KP_OK` on a clean return, or the nonzero trap code
otherwise; `kp_trap_message(vm)` carries the message.

For a located report, install a hook with `kp_set_trap`; `kp_raise` calls it with
the trap kind and the source line, file, and routine, resolved from the module's
address-to-line table when the source was compiled `-g`. `kp_locate` maps a code
address back to a guest location, which a crashing host can call from a signal
handler. The full trap list and the reporting contract are in `kp-abi.md`.

Note that the backend runs the module's native code in the host process with no
sandbox. Run only modules you trust or produced yourself. The deferred plan for
running untrusted scripts safely is in `kp-hardening.md`.

## The standard I/O runtime

A script that uses `write`, `writeln`, `read`, `readln`, or the program-argument
builtins imports host functions named `io_write_*`, `io_read_*`, `ParamCount`, and
`ParamStr`. Each `io_*` function carries the stream as a POSIX-style file
descriptor (fd 1 is standard output, fd 2 standard error, input is fd 0), not a
stdio `FILE*`, so the seam matches the VM boundary and needs no guest pointer.
Rather than registering each by hand, call `kp_register_io(vm)` (from `rt.h`) once
after `kp_new` and before `kp_link`, and they resolve to a native implementation
over the OS `read`/`write` calls, with one byte of input pushback for the numeric
and line reads. `kp_io_set_args(argc, argv)` records the command line for the
argument builtins. A host that provides its own I/O can register those names itself
instead.

## A complete minimal host

This host loads a precompiled module, registers the one function it imports, and
runs its `main`:

```c
#include <kobold/kp.h>
#include <stdio.h>
#include <stdlib.h>

static int host_emit(kp_vm *vm) { printf("%d\n", kp_to_i32(vm, 0)); return 0; }

int
main(void)
{
    FILE *f = fopen("game.kpm", "rb");
    long n; char *buf; kp_vm *vm; kp_module *m; int rc;

    fseek(f, 0, SEEK_END); n = ftell(f); fseek(f, 0, SEEK_SET);
    buf = malloc((size_t)n); fread(buf, 1, (size_t)n, f); fclose(f);

    vm = kp_new();
    kp_register_func(vm, "emit", host_emit);
    m = kp_load(vm, buf, (size_t)n);
    if (!m) { fprintf(stderr, "load: %s\n", kp_last_error(vm)); return 1; }
    if (kp_link(vm) != KP_OK) { fprintf(stderr, "link: %s\n", kp_last_error(vm)); return 1; }
    rc = kp_call(m, "main");
    if (rc != KP_OK) { fprintf(stderr, "trap %d: %s\n", rc, kp_trap_message(vm)); return 1; }

    kp_destroy(vm);
    free(buf);
    return 0;
}
```

Against a guest that calls `emit`, this compiles with the installed library and runs
the script.

## The worked examples

The `examples/` directory holds three hosts, each built and run by
`make -C examples check`:

- `embed.c` registers a plain function and a handle type with methods, then loads,
  links, and calls a module. The handle lifetime and method dispatch example.
- `patrol.c` runs a coroutine-driven script (`patrol.pas`) compiled by `kpcom`.
- `runpas.c` is the two-stage boot: it compiles a source in memory with the
  `compile` export, then loads and runs the produced module.

## See also

- `kp-abi.md` the precise value, call, handle, lifetime, and trap ABI.
- `kp-module-format.md` the KPM1 module the front end emits and `kp_load` reads.
- `kp-language.md` the language the scripts are written in.
- `kp-hardening.md` the deferred plan for running untrusted scripts.
